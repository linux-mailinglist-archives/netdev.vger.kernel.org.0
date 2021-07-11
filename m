Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57F73C3D68
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 16:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhGKOvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 10:51:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33188 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233398AbhGKOvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 10:51:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626014904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l1Gd6x6S4H50o7BryE+xUHOXRSufSSPrCcsP3hzMefY=;
        b=N7zbCx9PqzlcMyrTEhJp2pQ3Z7OpwZMJZJ4XpJclP5iSctoldnTOkGDsdaYYogWlHuX/Es
        hdX8sppW9Wm4qMctO5ohsAWYQpiqz2lbZ50D7BN/pb735Oeb5zAaizxSta7pukFGQnAIx9
        DngP0OquyVQzgXzGXzIUzq6bgoKjuaQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-kqLvkM8zP4ecn6umkRUaDQ-1; Sun, 11 Jul 2021 10:48:23 -0400
X-MC-Unique: kqLvkM8zP4ecn6umkRUaDQ-1
Received: by mail-ed1-f72.google.com with SMTP id f20-20020a0564020054b0290395573bbc17so8336959edu.19
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 07:48:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l1Gd6x6S4H50o7BryE+xUHOXRSufSSPrCcsP3hzMefY=;
        b=WWbhTLS0sl4f6PdXj2rWmBsidsTS3i/PihPsS9Mc8YSlofx9XwSx0peq/jVzpA84gl
         adv6L+Kpl3SKi9AW36Sgbe5c9+7Tu0SvdfQI76MRPWfQAwhuyoCJlwAMgcYTlwdW++G2
         sOwvEM3XT7yr/zLS2T3gqkYN+gqgTAROmSZV9QRbgEN15IS9JSXWIedcb3qnRTs4Jl+/
         CSb8j8rRlqXLzy8wbRhJNZb65afa0nYfCg5SOEQ8yorhJlk8TS+a/XUR0d/IrhvKY02K
         CpnFPltae2XknpnaplwZmJWK8z+kvx89OCDJk0Bjssg4sRFrFayhmVMF3d4WtyVI7fHr
         e0dA==
X-Gm-Message-State: AOAM530a7606Uur//HzuHo6N5khiO2RFK7HfOaE0Sqn9i0u94R0w2tP7
        qTnHFms9wD+im0UqaOmPuCvwozwKF+RBZnIaQHUHMGqxbPBsEFZjjTdJ84M4LN89GsgqxcopHHm
        9f4qu5T05hRFpcVg8
X-Received: by 2002:aa7:dc0c:: with SMTP id b12mr60332820edu.105.1626014901228;
        Sun, 11 Jul 2021 07:48:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxHBCrpGCL0NIkOSK4B89oWuCzH4krk+sh3ocb71/fj8wTf3DQaGfhkPH77/RtBFdaUKNO/iQ==
X-Received: by 2002:aa7:dc0c:: with SMTP id b12mr60332807edu.105.1626014901063;
        Sun, 11 Jul 2021 07:48:21 -0700 (PDT)
Received: from krava ([5.171.250.127])
        by smtp.gmail.com with ESMTPSA id s7sm5349378ejd.88.2021.07.11.07.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 07:48:20 -0700 (PDT)
Date:   Sun, 11 Jul 2021 16:48:17 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCHv3 bpf-next 7/7] selftests/bpf: Add test for
 bpf_get_func_ip in kprobe+offset probe
Message-ID: <YOsEsb1sMasi1WyR@krava>
References: <20210707214751.159713-1-jolsa@kernel.org>
 <20210707214751.159713-8-jolsa@kernel.org>
 <CAEf4Bzb9DTtGWubdEgMYirWLT-AiYbU2LfB-cSpGNzk6L0z8Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb9DTtGWubdEgMYirWLT-AiYbU2LfB-cSpGNzk6L0z8Kg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 05:18:49PM -0700, Andrii Nakryiko wrote:
> On Wed, Jul 7, 2021 at 2:54 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > Adding test for bpf_get_func_ip in kprobe+ofset probe.
> 
> typo: offset
> 
> > Because of the offset value it's arch specific, adding
> > it only for x86_64 architecture.
> 
> I'm not following, you specified +0x5 offset explicitly, why is this
> arch-specific?

I need some instruction offset != 0 in the traced function,
x86_64's fentry jump is 5 bytes, other archs will be different

> 
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  .../testing/selftests/bpf/progs/get_func_ip_test.c  | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > index 8ca54390d2b1..e8a9428a0ea3 100644
> > --- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > +++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > @@ -10,6 +10,7 @@ extern const void bpf_fentry_test2 __ksym;
> >  extern const void bpf_fentry_test3 __ksym;
> >  extern const void bpf_fentry_test4 __ksym;
> >  extern const void bpf_modify_return_test __ksym;
> > +extern const void bpf_fentry_test6 __ksym;
> >
> >  __u64 test1_result = 0;
> >  SEC("fentry/bpf_fentry_test1")
> > @@ -60,3 +61,15 @@ int BPF_PROG(fmod_ret_test, int a, int *b, int ret)
> >         test5_result = (const void *) addr == &bpf_modify_return_test;
> >         return ret;
> >  }
> > +
> > +#ifdef __x86_64__
> > +__u64 test6_result = 0;
> 
> see, and you just forgot to update the user-space part of the test to
> even check test6_result...
> 
> please group variables together and do explicit ASSERT_EQ

right.. will change

thanks,
jirka

> 
> > +SEC("kprobe/bpf_fentry_test6+0x5")
> > +int test6(struct pt_regs *ctx)
> > +{
> > +       __u64 addr = bpf_get_func_ip(ctx);
> > +
> > +       test6_result = (const void *) addr == &bpf_fentry_test6 + 5;
> > +       return 0;
> > +}
> > +#endif
> > --
> > 2.31.1
> >
> 

