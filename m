Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94844F0D6D
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 03:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376865AbiDDB3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 21:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344091AbiDDB3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 21:29:00 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9B73A5F6;
        Sun,  3 Apr 2022 18:27:05 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id q11so9579362iod.6;
        Sun, 03 Apr 2022 18:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VaOZbRR43qQ0JgsqzQJ3/IMBqjvcGybpqt430DJSuu0=;
        b=c27Tg+jZ8OQ/0o+EYhKlZPBXsF3aCjT4fGzrKgpCso+T0yKk6HHQljZLVBuqYRMAPu
         CWcAVKqDc8zwpAX68K06ynDkrs0awl/sLrsNJsaltii6Bgvgceh/kNo15I1kCrWvYjuU
         Pp86xmsPF1yekzBk13LX837ylcEohkWzQYYWRULp5S19dCjmVpoYiBGmQrVuBwvAd4n7
         ynn7xt2gp/QI37+P+Pj3M4Z1Wiu21CT2AgKQkprYwdMiJ2v4A29IxgzSr8sf98OXSC9R
         Yh+z2gNdmUSoncDr/4eDe6HNhnuWGGk3kBVL3erMe2aAc7wDgFunemhDGM61Ht455KeY
         elRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VaOZbRR43qQ0JgsqzQJ3/IMBqjvcGybpqt430DJSuu0=;
        b=msUud2gmNoYTKiXhh6dGxQHEHDdOm6+S2dkNXU3JCNEDmskAH0AuoWGvhRaikI4Nay
         +IoqRYEbO5Pe2PTyRFB1hVLjBLHt2z/ljY6t+8QrykgyTejqUMo214YffiISUlBPxSLF
         IJGU4f1Oof3jLFpo0InVqEoa1LnHxEh22CIF5sX3MqhuFb7xRm4QbLku35CCwWHLc/in
         V7XuNtxzHztkP7ieEwERVwfy3mcny9PcsUhhi8Ivh6igQfNXe1VUqZ7hxgj8Rqnclb1e
         U+c/VNzbgIrRVOhmRnneLxtAbPSLAIgoTRPcAHR6cs1c75c0AqgVCPMJ9OwTD9dxCe3z
         foOw==
X-Gm-Message-State: AOAM531IXz+ZR73NHR4yEcHsAN5DdDCwsgbqjjytD/3CQNLoq1eZCDTs
        KwvSAr4MGR8IPLD8LsgnU+qVQMviqf+miSHZlq0=
X-Google-Smtp-Source: ABdhPJznfsazK2Yr/l0TzOwsU5SXT+SuGxoyI8Zs1QIX1oFXSKQJS4CR5HjcP5ogkfSbCXoGK34UPPkk7iztNDw+fWo=
X-Received: by 2002:a05:6602:3c6:b0:63d:cac9:bd35 with SMTP id
 g6-20020a05660203c600b0063dcac9bd35mr4424798iov.144.1649035624730; Sun, 03
 Apr 2022 18:27:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220403144300.6707-1-laoar.shao@gmail.com> <20220403144300.6707-2-laoar.shao@gmail.com>
 <CAEf4BzZ2U=H-FEft3twSV7RCgTHHVJ8Dt6_RuYMdHdtC17WM1A@mail.gmail.com>
In-Reply-To: <CAEf4BzZ2U=H-FEft3twSV7RCgTHHVJ8Dt6_RuYMdHdtC17WM1A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 3 Apr 2022 18:26:54 -0700
Message-ID: <CAEf4BzYGOgrbvobqPBW+1Zdb5W7Cj0WUvQNitnrxJNgSOCnzQQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/9] bpf: selftests: Use libbpf 1.0 API mode
 in bpf constructor
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Sun, Apr 3, 2022 at 6:24 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Apr 3, 2022 at 7:43 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > In libbpf 1.0 API mode, it will bump rlimit automatically if there's no
> > memcg-basaed accounting, so we can use libbpf 1.0 API mode instead in case

also very eye catching typo: basaed -> based

> > we want to run it in an old kernel.
> >
> > The constructor is renamed to bpf_strict_all_ctor().
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  tools/testing/selftests/bpf/bpf_rlimit.h | 26 +++---------------------
> >  1 file changed, 3 insertions(+), 23 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/bpf_rlimit.h b/tools/testing/selftests/bpf/bpf_rlimit.h
> > index 9dac9b30f8ef..d050f7d0bb5c 100644
> > --- a/tools/testing/selftests/bpf/bpf_rlimit.h
> > +++ b/tools/testing/selftests/bpf/bpf_rlimit.h
> > @@ -1,28 +1,8 @@
> >  #include <sys/resource.h>
> >  #include <stdio.h>
> >
> > -static  __attribute__((constructor)) void bpf_rlimit_ctor(void)
> > +static  __attribute__((constructor)) void bpf_strict_all_ctor(void)
>
> well, no, let's get rid of bpf_rlimit.h altogether. There is no need
> for constructor magic when you can have an explicit
> libbpf_set_strict_mode(LIBBPF_STRICT_ALL).
>
> >  {
> > -       struct rlimit rlim_old, rlim_new = {
> > -               .rlim_cur       = RLIM_INFINITY,
> > -               .rlim_max       = RLIM_INFINITY,
> > -       };
> > -
> > -       getrlimit(RLIMIT_MEMLOCK, &rlim_old);
> > -       /* For the sake of running the test cases, we temporarily
> > -        * set rlimit to infinity in order for kernel to focus on
> > -        * errors from actual test cases and not getting noise
> > -        * from hitting memlock limits. The limit is on per-process
> > -        * basis and not a global one, hence destructor not really
> > -        * needed here.
> > -        */
> > -       if (setrlimit(RLIMIT_MEMLOCK, &rlim_new) < 0) {
> > -               perror("Unable to lift memlock rlimit");
> > -               /* Trying out lower limit, but expect potential test
> > -                * case failures from this!
> > -                */
> > -               rlim_new.rlim_cur = rlim_old.rlim_cur + (1UL << 20);
> > -               rlim_new.rlim_max = rlim_old.rlim_max + (1UL << 20);
> > -               setrlimit(RLIMIT_MEMLOCK, &rlim_new);
> > -       }
> > +       /* Use libbpf 1.0 API mode */
> > +       libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
> >  }
> > --
> > 2.17.1
> >
