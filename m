Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8313A3B9D6D
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 10:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhGBITa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 04:19:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230226AbhGBIT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 04:19:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625213815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zBkbuL0GAQIoWtsDWjIVFNTZu/k7IM9ZWEHLrdTuBFM=;
        b=gxFWVMuVLRQlLw85KWIoHfWUyee3/FK3kzWKcb/Jkxr0RSCWVJ0se8Fi60qhMCmgq7Lamg
        4EMUH339MOCItDEL2GWSJb2CKrs+4r08FBWP9CIyZGB1DeqNyPbgL4Ek3bzjX1m5Jan3cM
        H+RnMF+skT7ErC+Zrj29iQ0Jfl29eMk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-AJtEa-esPT29WoBlIdvHiw-1; Fri, 02 Jul 2021 04:16:54 -0400
X-MC-Unique: AJtEa-esPT29WoBlIdvHiw-1
Received: by mail-ej1-f71.google.com with SMTP id k1-20020a17090666c1b029041c273a883dso3270902ejp.3
        for <netdev@vger.kernel.org>; Fri, 02 Jul 2021 01:16:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zBkbuL0GAQIoWtsDWjIVFNTZu/k7IM9ZWEHLrdTuBFM=;
        b=N7PMRBibB/ZYf0pOnI8lK7EfHwlvH1qt/r2LCTzYiE9SZ08VCLlvgVxPw8ACR3/C61
         q3dGZ5PQC6prb4VaqOD6he1ldSPU+LNtljfc7B8hgkb7BIjxfLmjpbfZ049p/W6kXGbh
         lR9QsyL1WouMoqbQ0UjrWP7Xx/w+RxzdyMeZT5yOm5j+QbY1RGGw0KVrfSt6ZUUjhj64
         q48QE4ANy2ozUGvxpHlgTZIISbndWxHMxpSsuAGo065+JR/j7vry1hJtq7ZpdEfQbCyL
         5wD47TA0reUEXdZd6n0k013huYehJhxwkeJ+xcOrIArBPIv6vPqaoaUN8YGbBVU9iRI7
         MC7A==
X-Gm-Message-State: AOAM531YB2hu2h4UtjXDinUrNEi6Ixs/jJfthxyls+klDEWIOg+uv1oJ
        wlomw9PC2f36mhNsoGZif2he1uIWsVL2VZ547B3kqTqPVhX+GwFlEN3Ixj0WTpuhFR6wZ7Cuvfq
        5GBo4N61d/2yPhoGo
X-Received: by 2002:a17:906:940b:: with SMTP id q11mr4274033ejx.79.1625213812782;
        Fri, 02 Jul 2021 01:16:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzi6ZvJtE42/Z8dw3YYQEScj3zDC9d9Z8uOfAcwviCkH+zoWbYqKCjfOrDMjV851yZkNo9sw==
X-Received: by 2002:a17:906:940b:: with SMTP id q11mr4274024ejx.79.1625213812587;
        Fri, 02 Jul 2021 01:16:52 -0700 (PDT)
Received: from krava ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id jz12sm738900ejc.94.2021.07.02.01.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 01:16:52 -0700 (PDT)
Date:   Fri, 2 Jul 2021 10:16:48 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [RFC bpf-next 0/5] bpf, x86: Add bpf_get_func_ip helper
Message-ID: <YN7LcJu73nCz3Ips@krava>
References: <20210629192945.1071862-1-jolsa@kernel.org>
 <alpine.LRH.2.23.451.2107011819160.27594@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.23.451.2107011819160.27594@localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 06:22:45PM +0100, Alan Maguire wrote:
> On Tue, 29 Jun 2021, Jiri Olsa wrote:
> 
> > hi,
> > adding bpf_get_func_ip helper that returns IP address of the
> > caller function for trampoline and krobe programs.
> > 
> > There're 2 specific implementation of the bpf_get_func_ip
> > helper, one for trampoline progs and one for kprobe/kretprobe
> > progs.
> > 
> > The trampoline helper call is replaced/inlined by verifier
> > with simple move instruction. The kprobe/kretprobe is actual
> > helper call that returns prepared caller address.
> > 
> > The trampoline extra 3 instructions for storing IP address
> > is now optional, which I'm not completely sure is necessary,
> > so I plan to do some benchmarks, if it's noticeable, hence
> > the RFC. I'm also not completely sure about the kprobe/kretprobe
> > implementation.
> > 
> > Also available at:
> >   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> >   bpf/get_func_ip
> > 
> > thanks,
> > jirka
> > 
> >
> 
> This is great Jiri! Feel free to add for the series:
> 
> Tested-by: Alan Maguire <alan.maguire@oracle.com>

great, thanks for testing

> 
> BTW I also verified that if we extend bpf_program__attach_kprobe() to
> support the function+offset format in the func_name argument for kprobes, 
> the following test will pass too:
> 
> __u64 test5_result = 0;
> SEC("kprobe/bpf_fentry_test5+0x6")
> int test5(struct pt_regs *ctx)
> {
>         __u64 addr = bpf_get_func_ip(ctx);
> 
>         test5_result = (const void *) addr == (&bpf_fentry_test5 + 0x6);
>         return 0;
> }

right, I did not think of this test, I'll add it

thanks,
jirka

