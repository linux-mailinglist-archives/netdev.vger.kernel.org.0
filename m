Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0E653D36A
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 23:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348453AbiFCV4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 17:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiFCV4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 17:56:41 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB56424967;
        Fri,  3 Jun 2022 14:56:39 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id y15so4361409ljc.0;
        Fri, 03 Jun 2022 14:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QjV2keLn8ksFTBP7+D6RPrmgrPXRhau2LX6VaRt9vA8=;
        b=ahTiww370kDspuCZq2eTYtjPaNCKKAYGHHg5ucqUyee3trD7vZ4sy38hO4w4XvNxn0
         nw3LQG3eJ9TOrOSXraJC5qz0Pn7U8s+kglX803z3Bu67tkGUvlF55iQzSoycFT5UNuxh
         9pVRKG+b3G9QUhE9CAkToEIeE7DioG1fvXyl99zTeOdFpG9E01iCJUN3sZUER9VGu1KQ
         wIJ3HxerC3GZyeQASwrzCYQwENgq8zgqJ+4b69e2it/17pPKO/aJAPBzK7J4vG6Kk10k
         HALlrz846mahAlJwvoBd3CqYLNB9KmHvPBxJODBZ5KBvMoceg/8E1ESHi+9gOcHgGIJu
         WhQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QjV2keLn8ksFTBP7+D6RPrmgrPXRhau2LX6VaRt9vA8=;
        b=XoMUHHVqt7aZhApjG3xFTy5jU2brhqmcY5p5nggKunqbLw8K00+oiNE4/vBcxeRPDa
         LMXJJtN2QZAmUPcVaxeV+yQL9oL3RqyGEAeK4lv+jaRTCCNkBeT+oZ/jGYQnGvszJ7am
         HeVnm41tXmHLoDut1KYE+elFBayuqjaK4DMild2KUq0DEK8NuF6tvmK8eKaXYYH38Mdt
         c2RU7k0hmiK6uGFK7TW+20wvzeSOmOu3R3cvaOfNB/MQuZftn/fIztXQmOR52Cpfl9hl
         /tvUKTAI3sRmxK/8QFJT8a3+b+qavdR2auWZbIpXi6fagKGFIQjsAkY1PFkW8AOfpr9J
         c61g==
X-Gm-Message-State: AOAM533b8X0pusxQ5Nk1L6qeUoZo3cekV3000M4Va1KJ9Ju0RD8/gEuX
        sc/mGEtgJYjuBJ49iM4ZgAuhl8PS0WU7Fgw3g30=
X-Google-Smtp-Source: ABdhPJyGZxdn1TsyVk5tCwF3nZpAyd2Is4STQfbfpO5V1pZMYd9FOKtrDRSKSXXevP9mUjZUDgbs6OZhkRaK+z/Dz5U=
X-Received: by 2002:a2e:87c8:0:b0:255:6d59:ebce with SMTP id
 v8-20020a2e87c8000000b002556d59ebcemr7700808ljj.455.1654293398272; Fri, 03
 Jun 2022 14:56:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220527205611.655282-1-jolsa@kernel.org> <20220527205611.655282-4-jolsa@kernel.org>
 <CAEf4BzbY19qe6Ftzev884R_xuS4H5OD_fRLOfeekbPWjd5jkiA@mail.gmail.com>
 <CAEf4Bza84ei+Nmyh+aKHY_LSuDfziKjYTmphHQ39xCkooygbxA@mail.gmail.com> <YpnhDxpRuUbx4b2i@krava>
In-Reply-To: <YpnhDxpRuUbx4b2i@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Jun 2022 14:56:26 -0700
Message-ID: <CAEf4BzbVmtt238JtO6bwd-CD45WCT4CjBn1JuYw4r5=jpdmrGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] bpf: Force cookies array to follow symbols sorting
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
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

On Fri, Jun 3, 2022 at 3:23 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Thu, Jun 02, 2022 at 04:02:28PM -0700, Andrii Nakryiko wrote:
> > On Thu, Jun 2, 2022 at 4:01 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Fri, May 27, 2022 at 1:57 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > > >
> > > > When user specifies symbols and cookies for kprobe_multi link
> > > > interface it's very likely the cookies will be misplaced and
> > > > returned to wrong functions (via get_attach_cookie helper).
> > > >
> > > > The reason is that to resolve the provided functions we sort
> > > > them before passing them to ftrace_lookup_symbols, but we do
> > > > not do the same sort on the cookie values.
> > > >
> > > > Fixing this by using sort_r function with custom swap callback
> > > > that swaps cookie values as well.
> > > >
> > > > Fixes: 0236fec57a15 ("bpf: Resolve symbols with ftrace_lookup_symbols for kprobe multi link")
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >  kernel/trace/bpf_trace.c | 65 ++++++++++++++++++++++++++++++----------
> > > >  1 file changed, 50 insertions(+), 15 deletions(-)
> > > >
> > > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > > index 10b157a6d73e..e5c423b835ab 100644
> > > > --- a/kernel/trace/bpf_trace.c
> > > > +++ b/kernel/trace/bpf_trace.c
> > > > @@ -2423,7 +2423,12 @@ kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
> > > >         kprobe_multi_link_prog_run(link, entry_ip, regs);
> > > >  }
> > > >
> > > > -static int symbols_cmp(const void *a, const void *b)
> > > > +struct multi_symbols_sort {
> > > > +       const char **funcs;
> > > > +       u64 *cookies;
> > > > +};
> > > > +
> > > > +static int symbols_cmp_r(const void *a, const void *b, const void *priv)
> > > >  {
> > > >         const char **str_a = (const char **) a;
> > > >         const char **str_b = (const char **) b;
> > > > @@ -2431,6 +2436,25 @@ static int symbols_cmp(const void *a, const void *b)
> > > >         return strcmp(*str_a, *str_b);
> > > >  }
> > > >
> > > > +static void symbols_swap_r(void *a, void *b, int size, const void *priv)
> > > > +{
> > > > +       const struct multi_symbols_sort *data = priv;
> > > > +       const char **name_a = a, **name_b = b;
> > > > +       u64 *cookie_a, *cookie_b;
> > > > +
> > > > +       cookie_a = data->cookies + (name_a - data->funcs);
> > > > +       cookie_b = data->cookies + (name_b - data->funcs);
> > > > +
> > > > +       /* swap name_a/name_b and cookie_a/cookie_b values */
> > > > +       swap(*name_a, *name_b);
> > > > +       swap(*cookie_a, *cookie_b);
> > > > +}
> > > > +
> > > > +static int symbols_cmp(const void *a, const void *b)
> > > > +{
> > > > +       return symbols_cmp_r(a, b, NULL);
> > > > +}
> > > > +
> > > >  int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> > > >  {
> > > >         struct bpf_kprobe_multi_link *link = NULL;
> > > > @@ -2468,6 +2492,19 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
> > > >         if (!addrs)
> > > >                 return -ENOMEM;
> > > >
> > > > +       ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
> > > > +       if (ucookies) {
> > > > +               cookies = kvmalloc(size, GFP_KERNEL);
> >
> > oh, and you'll have to rebase anyways after kvmalloc_array patch
>
> true, that kvmalloc_array change went to bpf-next/master,
> but as Song mentioned this patchset should probably go for bpf/master?
>
> I'm fine either way, let me know ;-)
>

I've moved kvmalloc_array() fix to bpf tree (it is an actual fix
against potential overflow after all), so please base everything on
bpf tree.

> thanks,
> jirka
