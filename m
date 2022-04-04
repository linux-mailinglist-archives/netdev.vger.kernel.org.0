Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E5F4F0F93
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 08:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353941AbiDDGq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 02:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240418AbiDDGqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 02:46:55 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC46328E33;
        Sun,  3 Apr 2022 23:44:59 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id 125so10074653iov.10;
        Sun, 03 Apr 2022 23:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g0ClKFuH7/uxJwEPwcXH6UlRmJbu6n2QH3M9ZvCVFuo=;
        b=hhpyXIMkpX+mxIp1BkffRqBoVRvu4nsvMnb7sj97D+/PtDsoHMmePXMwGvaYurt1Hz
         ZZsn5jIWMXfZCJHjmDctyndrwHKpODJHEMF+coKtqgZyLDeeyju9DTa5Xpcn5zyKHAgW
         XfsKfd5GLEPhpPH3JsNWT79NVMC2DLe6uOX85GSozk82SbmLFADxi6RNfQBrWd1d/Y+H
         nBBdtQ+2BBOMLefOS20lp/JH7CgpwRZbfL7G4t97lAN61CCN5DX1N9vYpp4TbkHBzu8x
         PYAeiT+7tSNJsalgl9QCkVRgMSW55v/1iDBTjyunwEsMozn2FktCVuIzNFH6QoZjlAp8
         DhOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g0ClKFuH7/uxJwEPwcXH6UlRmJbu6n2QH3M9ZvCVFuo=;
        b=fJwjDEgve/6u0mlXAHsH0z/nn98M75fqCsFjxw0zlYDCUNnbt3M5TmSq5WRjhrsiN/
         zvky6pwmyN6a+rIuNh+oLrjFMUCu5696Dy+7sr917qz/JuxLUZ8ST4t6hs5MdN8f6KmI
         2LyKOwatuVAcW+Hc47e8rIQBzvPIreXaVQWG560MpPgCq1qD46uHeoSxrFlr5qqLQi+M
         Xqcm9M6z9sI7LpHsGuGmMHTMnXocOPMYxOnavsFC+I1Bm3Le0jO02hQsSVrtoVJa+4i2
         xCnB9Zn0o3HhWg9LlAjar9H3sDEiyB5L0RrKxGyEjYVOusVd83Ew8/n3WGj8Ay1MuZz3
         AbQw==
X-Gm-Message-State: AOAM530aU1uQU1qN4nYMkpID/7p992tBWPIPSmWJ3r4TTSGA9nUqCjxK
        ddQyIDjG+Uj+Ba5A67fZo1q0PdhhVU/YmyZASVk=
X-Google-Smtp-Source: ABdhPJxUVYXIgYbvbm9i/MchNl6Cbk0gj6At+dsJeWvKa0j7yPwoe/b7DG+wH+5JbBQrvHAsVUTgjknVC+SfEEvLDO0=
X-Received: by 2002:a05:6638:3729:b0:323:e943:aaf8 with SMTP id
 k41-20020a056638372900b00323e943aaf8mr1602818jav.293.1649054699116; Sun, 03
 Apr 2022 23:44:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220403144300.6707-1-laoar.shao@gmail.com> <20220403144300.6707-2-laoar.shao@gmail.com>
 <CAEf4BzZ2U=H-FEft3twSV7RCgTHHVJ8Dt6_RuYMdHdtC17WM1A@mail.gmail.com>
In-Reply-To: <CAEf4BzZ2U=H-FEft3twSV7RCgTHHVJ8Dt6_RuYMdHdtC17WM1A@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Mon, 4 Apr 2022 14:44:23 +0800
Message-ID: <CALOAHbCE-k-by5BvJJje_4P+dpJkAtRCeypLkDbNtqcrWsEAHg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/9] bpf: selftests: Use libbpf 1.0 API mode
 in bpf constructor
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Mon, Apr 4, 2022 at 9:24 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Apr 3, 2022 at 7:43 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > In libbpf 1.0 API mode, it will bump rlimit automatically if there's no
> > memcg-basaed accounting, so we can use libbpf 1.0 API mode instead in case
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

Sure, I will do it.

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

-- 
Thanks
Yafang
