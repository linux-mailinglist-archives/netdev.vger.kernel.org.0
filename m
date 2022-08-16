Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0662C59654F
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbiHPWQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237959AbiHPWQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:16:51 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA54786EC
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 15:16:50 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id y4so7977401qvr.7
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 15:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=zAVoK2y0IblTkUtCF2+DJlXYzSXXXw12A5petDOhN5E=;
        b=IP+BohMQzQjIx2VjirAenZa/lMePA7zPokS9BlYFTRN8m/nGjLgAQ/rTpaE9elClY7
         LeObnzazdZXAcQxZ+7mv03rgF3EcrZsMotDhbdt4jZQ4KtN3R6y57tuD8Cy3ZbBotVZh
         GrBeWl3KTeEfYXH606jCLEHMaBIYhCD6+bi2duKLThctxnxDArlUqsAV2s2IRzoJA514
         5l0EOsva/nmhAYKFZdRuXIEZeGB90/CTD/gGDevfLJ/ymkbVc0dUR6DnN/BaNX6zZo59
         BLMxOxTSp3Uqccmqb3QyNVBDXliGREWGBITeNloI4zvjEj0ZmJXkIL1/xqUMdZC6/ogh
         Rrwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=zAVoK2y0IblTkUtCF2+DJlXYzSXXXw12A5petDOhN5E=;
        b=ZMMzwhQWk5Kz3RtJK6a5KMbhpvCrUlnRdVpGCTMsmqwKpndHm7+DQRAlb5tnogN4sF
         wiTFRWlvpf/1rn0ACAzRu9+LS27xittrCYinSCpPl5Dk2Pu1BbPz+YcXA+CHSDWxy0wE
         alsBReclUOd+Zr7sX6YKN077+6eZ4dUzHbWn0ulCWKr7/YklDkCmt2HZKAhojsjW2edu
         M7PO4nszk84sJ+ACsoXHMFVj7KyXAYeGgoVfkfLCREU1WCHa21AUERuuER5dqyQhv+DP
         ailwPZi6t3lbNSTQ58Z/Pin/HpyoLBgtLYrD0tZHaKqc1DbzW3Rp+qbgz5jC5D8j0umy
         f2/A==
X-Gm-Message-State: ACgBeo2l60j7MfPxUVRF/J4SrwPpSdU2SLdK97FYRISN9jg+7BJxHL4s
        BHuurMBat47NK82zVLQxkFHPqv+01jHJzahI7SfzigdGX93419SA
X-Google-Smtp-Source: AA6agR4rcZ3y0cSZ5tIp/Q/Gtnd8PqnUBfvhciEjwRRV0JFXzi+SKPnM81czOBZvk96BaLNcdiEFk8k8DislOFP+L+8=
X-Received: by 2002:a05:6214:20a8:b0:477:1882:3e7 with SMTP id
 8-20020a05621420a800b00477188203e7mr19871631qvd.44.1660688209597; Tue, 16 Aug
 2022 15:16:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220816214945.742924-1-haoluo@google.com> <CAEf4Bza1SMFvzofz4RkBF=pByFHp+Z1v16Z+TMAQZ6rD2m9Lxg@mail.gmail.com>
In-Reply-To: <CAEf4Bza1SMFvzofz4RkBF=pByFHp+Z1v16Z+TMAQZ6rD2m9Lxg@mail.gmail.com>
From:   Hao Luo <haoluo@google.com>
Date:   Tue, 16 Aug 2022 15:16:38 -0700
Message-ID: <CA+khW7hHGL1DAMSOjbJSj21wJYY=j4VrRJcFB1zv52Db20_MGA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: allow disabling auto attach
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 3:01 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Aug 16, 2022 at 2:49 PM Hao Luo <haoluo@google.com> wrote:
> >
> > Add libbpf APIs for disabling auto-attach for individual functions.
> > This is motivated by the use case of cgroup iter [1]. Some iter
> > types require their parameters to be non-zero, therefore applying
> > auto-attach on them will fail. With these two new APIs, Users who
> > want to use auto-attach and these types of iters can disable
> > auto-attach for them and perform manual attach.
> >
> > [1] https://lore.kernel.org/bpf/CAEf4BzZ+a2uDo_t6kGBziqdz--m2gh2_EUwkGLDtMd65uwxUjA@mail.gmail.com/
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 16 ++++++++++++++++
> >  tools/lib/bpf/libbpf.h |  2 ++
> >  2 files changed, 18 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index aa05a99b913d..25f654d25b46 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
[...]
> >  const struct bpf_insn *bpf_program__insns(const struct bpf_program *prog)
> >  {
> >         return prog->insns;
> > @@ -12349,6 +12362,9 @@ int bpf_object__attach_skeleton(struct bpf_object_skeleton *s)
> >                 if (!prog->autoload)
> >                         continue;
> >
> > +               if (!prog->autoattach)
> > +                       continue;
> > +
>
> nit: I'd combine as if (!prog->autoload || !prog->autoattach), they
> are very coupled in this sense
>

Sure.

> >                 /* auto-attaching not supported for this program */
> >                 if (!prog->sec_def || !prog->sec_def->prog_attach_fn)
> >                         continue;
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index 61493c4cddac..88a1ac34b12a 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -260,6 +260,8 @@ LIBBPF_API const char *bpf_program__name(const struct bpf_program *prog);
> >  LIBBPF_API const char *bpf_program__section_name(const struct bpf_program *prog);
> >  LIBBPF_API bool bpf_program__autoload(const struct bpf_program *prog);
> >  LIBBPF_API int bpf_program__set_autoload(struct bpf_program *prog, bool autoload);
> > +LIBBPF_API bool bpf_program__autoattach(const struct bpf_program *prog);
> > +LIBBPF_API void bpf_program__set_autoattach(struct bpf_program *prog, bool autoattach);
>
> please add these APIs to libbpf.map as well
>

Ok. Which section? LIBBPF_1.0.0? Do the items in each section have a
particular order?

> it would be also nice to have a simple test validating that skeleton's
> auto-attach doesn't attach program (no link will be created) if
> bpf_program__set_autoattach(false) is called before. Can you please
> add that as well?
>

Ok. Will add a test and send v2.

> >
> >  struct bpf_insn;
> >
> > --
> > 2.37.1.595.g718a3a8f04-goog
> >
