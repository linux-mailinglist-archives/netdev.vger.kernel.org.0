Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566C458D029
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 00:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244377AbiHHWfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 18:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbiHHWfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 18:35:13 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04F71AB;
        Mon,  8 Aug 2022 15:35:11 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id gk3so19132288ejb.8;
        Mon, 08 Aug 2022 15:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ZgiIDoNaJYkoXbluWbEgNhdPfAEJFOBf77+pUBxYmX0=;
        b=pNgPS/9gTXfI2VhwQww6EZRCghR71vWsMBW/dxOqR2EscAk/g/6RjGs44F4SLCKSC3
         RbWNi0gyc66anQGYuQJ///yY9XtzmUMWG5zv+eIKCAXMHMxh/VxhH2pa4+cjkIoPjOd+
         WFLkPHkCM69f9UE5n8eVop+3GBGhWdC4Q8+cQkzt5X3I5mMySNSvNddwR6qrNljzB95Z
         mkQZM5pHdfH63cp9PmlSLevu5p7RRB6EEDkkM1r98u/EMTXU2uYvxjElVXi4kEurzHEU
         tmj/x6Op90hozVNl0qPUjSouJ63l60Agdj3aAtnz27qxRncNZ/YsrxUmPlnbhxWFeIbF
         r41w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ZgiIDoNaJYkoXbluWbEgNhdPfAEJFOBf77+pUBxYmX0=;
        b=A8viWsoEdxage8qQyG9MXCthNw6hxVY21IFtcsS77lnHNibyG6leZU2hxGunCWxHHp
         UwNw9FTGlPTvMJBjqPnhh+sPQxIXuMaejm2nUzHJwT9XuaUvjfbjKbt/w5i6j5H1ofMx
         YbAHwYmrUOZLjt8JnMV+K8HYBRwP8j1nCnJ9taaz7PfMX+pL9MsSAZMguLsIIiZUNKDf
         YD+xrv4aWfMckp1k+EsSMXOXCPDGcTf0Nxi9Plh7ZCjOW7eNpKBdd3A/FIVeYPTHz/HT
         wzI8i3eO40/K8N9xA4OA8Dl9bOyYuSRbTnTuR5OPsTe41KzDZ9kR1XjP3BOAXZ+tAeI3
         h6MA==
X-Gm-Message-State: ACgBeo0ZpeFIMFBpwrKsjw9Rsx3mFEbQpRi5HlGvdDPAV2S5cJ9lrUnu
        Snlnk9iCP5Jz48Yana0/1ePjXEaboWPPlRGEdC8=
X-Google-Smtp-Source: AA6agR5EX9GH+q2WOU7Duh16c5mFBXWIJXPKZ0iBLTkogYYbCM2DjL5d7cddeVz6JB2OQH4KxsPBGYImCUA4uokLNEQ=
X-Received: by 2002:a17:907:1361:b0:730:8f59:6434 with SMTP id
 yo1-20020a170907136100b007308f596434mr15419878ejb.745.1659998110234; Mon, 08
 Aug 2022 15:35:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220808093304.46291-1-liuhangbin@gmail.com> <9656fc7c-a5f6-8fa8-31c1-aeac07b765d8@isovalent.com>
In-Reply-To: <9656fc7c-a5f6-8fa8-31c1-aeac07b765d8@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Aug 2022 15:34:58 -0700
Message-ID: <CAEf4BzZO8=74puCeUrAcfCoX-1hG9ZaVCi==YuOuJq75T6KVAw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: try to add a name for bpftool
 self-created maps
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 8, 2022 at 6:45 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On 08/08/2022 10:33, Hangbin Liu wrote:
> > As discussed before[1], the bpftool self-created maps can appear in final
> > map show output due to deferred removal in kernel. These maps don't have
> > a name, which would make users confused about where it comes from.
> >
> > Adding names for these maps could make users know what these maps used for.
> > It also could make some tests (like test_offload.py, which skip base maps
> > without names as a workaround) filter them out.
> >
> > As Quentin suggested, add a small wrapper to fall back with no name
> > if kernel is not supported.
> >
> > [1] https://lore.kernel.org/bpf/CAEf4BzY66WPKQbDe74AKZ6nFtZjq5e+G3Ji2egcVytB9R6_sGQ@mail.gmail.com/
> >
> > Suggested-by: Quentin Monnet <quentin@isovalent.com>
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 22 +++++++++++++++++++---
> >  1 file changed, 19 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 77e3797cf75a..db4f1a02b9e0 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -4423,6 +4423,22 @@ static int probe_kern_prog_name(void)
> >       return probe_fd(ret);
> >  }
> >
> > +static int probe_kern_map_name(enum bpf_map_type map_type,
> > +                            const char *map_name, __u32 key_size,
> > +                            __u32 value_size, __u32 max_entries,
> > +                            const struct bpf_map_create_opts *opts)
> > +{
> > +     int map;
> > +
> > +     map = bpf_map_create(map_type, map_name, key_size, value_size, max_entries, opts);
> > +     if (map < 0 && errno == EINVAL) {
> > +             /* Retry without name */
> > +             map = bpf_map_create(map_type, NULL, key_size, value_size, max_entries, opts);
> > +     }
> > +
> > +     return map;
> > +}
> > +
> >  static int probe_kern_global_data(void)
> >  {
> >       char *cp, errmsg[STRERR_BUFSIZE];
> > @@ -4434,7 +4450,7 @@ static int probe_kern_global_data(void)
> >       };
> >       int ret, map, insn_cnt = ARRAY_SIZE(insns);
> >
> > -     map = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, sizeof(int), 32, 1, NULL);
> > +     map = probe_kern_map_name(BPF_MAP_TYPE_ARRAY, "global_data", sizeof(int), 32, 1, NULL);
>
> Thanks! Some comments on the naming: It reads strange here to "probe"
> for the maps, given that we still need to compare the return value
> below. Maybe use something else instead of "probe_kern_map_name()"?
> Maybe "map_create_adjust_name()" or "map_create_compat()" (or something
> else)?
>
> Regarding "global_data": If the intent is to filter out these maps from
> the output of bpftool for example, should we use a common prefix for the
> three of them? "libbpf_" or "probe_"? Or even something shorter? I know
> we're limited to 15 characters.

Yeah, "libbpf_" sounds like the best name to let users know it's some
libbpf-specific internal thing. It leaves only 8 characters for the
"feature name", but we can be creative about those 8 symbols, right?
:)

>
> Quentin
