Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4145965B1
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237707AbiHPWz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237506AbiHPWzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:55:52 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48CB647EC;
        Tue, 16 Aug 2022 15:55:51 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a7so21644107ejp.2;
        Tue, 16 Aug 2022 15:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=xaLBKYz/NspcrKgbukvBxgHlffMD/LglZ9aKHRnhLQ8=;
        b=hWqOro8AZlpQdEaXISXR45I2wiGhkQk2hp6z1USBnkJYFD6ba/1WM//2yKnkXUsnrF
         7ef3/f59Rr7TgfYKxTHe/vksIFsGaLc7L91YmsvdeS7tnOMEj9HbPsx7zRcRbJ8s+lPy
         YffV6mqVGMcmuACVanSF2WnOnslVjhINaAS/IYQ0P0gcgAJXP2i79KSDgvXicuTmTEfy
         wLMXAY6tBc3JNFbNOynEHBM7TS1YnurXEOdsZ0KRiBsjnjCSJJ+jKhCZ+AV6YDR+hvAL
         yTLwwngmWD0l6bxyJCVL3QS/GPCx/d+OhVSDcjWZ5dkjGdF68h1mZRK7OEU+IA+nyVP9
         a13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=xaLBKYz/NspcrKgbukvBxgHlffMD/LglZ9aKHRnhLQ8=;
        b=oQAkZ6Bx8fzBedFyxYYPaNIAMRkIxiLxDgSBc3kuz+vpMZA3Rt0gBqS0YSE89/Hl0Y
         AIg3BFJ/A5hJyiVAfgBNVaDUT6g0Sm7F6LTra0R7+fXEFzl6HK7aR1oL8EpJkAC0Qy0U
         XHVaIMls0BCJYQqwJaleKO203cEqX62pII92H+9pCghHFyD9s7DldY3MN1Oc0/vc+2SZ
         wlKQ2pbwBd8/eXdnKo/jnNWoTlU1ScFHMJw1HMkyDZJ08Zqunlo8c7/QDPgiRC7B+D2l
         on0rk3Arc8Kb2jabGRBCb7g5tx/frdxhT/+rZIEQkOXfj1lPpPmmdVG7Nx8FClX1DqQj
         42bA==
X-Gm-Message-State: ACgBeo3fYyjMmYItOa1BpKF+QFbnP4uksQ75SlqxjiLovfi6SiC3YRqi
        hbg3GBGSzghj/N+NZfsTPt70RgyxwfThIcncyVyxAI8Y
X-Google-Smtp-Source: AA6agR5heqRzrlUztQskbhhE0ThFAjz6hXfg3a4sCRN4LkCKa0L1Zv25uwz68ovMeAWJGquZIv0BM71PQaeJTwLpt9w=
X-Received: by 2002:a17:907:1361:b0:730:8f59:6434 with SMTP id
 yo1-20020a170907136100b007308f596434mr15116251ejb.745.1660690550251; Tue, 16
 Aug 2022 15:55:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220816214945.742924-1-haoluo@google.com> <CAEf4Bza1SMFvzofz4RkBF=pByFHp+Z1v16Z+TMAQZ6rD2m9Lxg@mail.gmail.com>
 <CA+khW7hHGL1DAMSOjbJSj21wJYY=j4VrRJcFB1zv52Db20_MGA@mail.gmail.com>
In-Reply-To: <CA+khW7hHGL1DAMSOjbJSj21wJYY=j4VrRJcFB1zv52Db20_MGA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Aug 2022 15:55:38 -0700
Message-ID: <CAEf4BzbBOrVU+BWySMk_v3w6019+5VpNXZY03JpmiwoQPnV1yA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: allow disabling auto attach
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Jiri Olsa <jolsa@kernel.org>
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

On Tue, Aug 16, 2022 at 3:16 PM Hao Luo <haoluo@google.com> wrote:
>
> On Tue, Aug 16, 2022 at 3:01 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Aug 16, 2022 at 2:49 PM Hao Luo <haoluo@google.com> wrote:
> > >
> > > Add libbpf APIs for disabling auto-attach for individual functions.
> > > This is motivated by the use case of cgroup iter [1]. Some iter
> > > types require their parameters to be non-zero, therefore applying
> > > auto-attach on them will fail. With these two new APIs, Users who
> > > want to use auto-attach and these types of iters can disable
> > > auto-attach for them and perform manual attach.
> > >
> > > [1] https://lore.kernel.org/bpf/CAEf4BzZ+a2uDo_t6kGBziqdz--m2gh2_EUwkGLDtMd65uwxUjA@mail.gmail.com/
> > >
> > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 16 ++++++++++++++++
> > >  tools/lib/bpf/libbpf.h |  2 ++
> > >  2 files changed, 18 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index aa05a99b913d..25f654d25b46 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> [...]
> > >  const struct bpf_insn *bpf_program__insns(const struct bpf_program *prog)
> > >  {
> > >         return prog->insns;
> > > @@ -12349,6 +12362,9 @@ int bpf_object__attach_skeleton(struct bpf_object_skeleton *s)
> > >                 if (!prog->autoload)
> > >                         continue;
> > >
> > > +               if (!prog->autoattach)
> > > +                       continue;
> > > +
> >
> > nit: I'd combine as if (!prog->autoload || !prog->autoattach), they
> > are very coupled in this sense
> >
>
> Sure.
>
> > >                 /* auto-attaching not supported for this program */
> > >                 if (!prog->sec_def || !prog->sec_def->prog_attach_fn)
> > >                         continue;
> > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > index 61493c4cddac..88a1ac34b12a 100644
> > > --- a/tools/lib/bpf/libbpf.h
> > > +++ b/tools/lib/bpf/libbpf.h
> > > @@ -260,6 +260,8 @@ LIBBPF_API const char *bpf_program__name(const struct bpf_program *prog);
> > >  LIBBPF_API const char *bpf_program__section_name(const struct bpf_program *prog);
> > >  LIBBPF_API bool bpf_program__autoload(const struct bpf_program *prog);
> > >  LIBBPF_API int bpf_program__set_autoload(struct bpf_program *prog, bool autoload);
> > > +LIBBPF_API bool bpf_program__autoattach(const struct bpf_program *prog);
> > > +LIBBPF_API void bpf_program__set_autoattach(struct bpf_program *prog, bool autoattach);
> >
> > please add these APIs to libbpf.map as well
> >
>
> Ok. Which section? LIBBPF_1.0.0? Do the items in each section have a
> particular order?

Yes, 1.0.0 section. All the functions are sorted alphabetically.

> > it would be also nice to have a simple test validating that skeleton's
> > auto-attach doesn't attach program (no link will be created) if
> > bpf_program__set_autoattach(false) is called before. Can you please
> > add that as well?
> >
>
> Ok. Will add a test and send v2.
>
> > >
> > >  struct bpf_insn;
> > >
> > > --
> > > 2.37.1.595.g718a3a8f04-goog
> > >
