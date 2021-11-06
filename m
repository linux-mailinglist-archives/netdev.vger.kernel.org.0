Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04260446FE9
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 19:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhKFSpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 14:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhKFSpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 14:45:51 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB04EC061570;
        Sat,  6 Nov 2021 11:43:09 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s136so11242795pgs.4;
        Sat, 06 Nov 2021 11:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yyfRWDK8NCqlPqDCBGpSUQxg8ZGEujbB5rTKuJMxw0M=;
        b=ekvunCuGbBmzpCgyWBCWIXRx5w52Y2G+RsPgUYm1KBfUAqmtPLQoxQSipH+C19gihx
         LOLpjZD7/46KUG+fljFxJ/Wnt0bocI5eVjECb2HX1ZtuMIAFs4Rim+606rWbN8I+tsOr
         glmLalZrGs0qRu4PMpMoNWmutnpIm1bEz19Gd+KWaEjl5qhRAAaDAf4TdtogB3Wnie3x
         O4rQj/swe+1JF7bxiGR1wVIrxWT88vTasKUV9kyHCjLyEIXbmToQz3Tntd11XexSApU6
         8wNMns2dYhLRX8/0xa9fR8MmCSF+z3enYJJm9iqa4NCfwDdpfczgdOs8xG4SMP4echMP
         VU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yyfRWDK8NCqlPqDCBGpSUQxg8ZGEujbB5rTKuJMxw0M=;
        b=j6Y5u3gM7OWgNOKR/nDOCDpGe4VjGBoxDKdxJ3u4bftEfmq1svhbRO3VRrEM50gv2T
         epKcpq47N45flk9mEt7i/YQ4klCBVSl8r6SY2EzWy8XACA5bAegymLUwHcJzKysX//gX
         bcyEX9GrATuY9byNBdxaZJYy8OZ7khWyUaWrLfgpN2cb6uJkrTuiCEuLbWFbEZw/ip6L
         biBJhC3isE0aRuMZ9bd+dbXEXmSmmvGhwpQRwAKo2F64TaH9jwr2p6X4BxC9eelel68t
         gRxrcDPPCzZddHjfBNEKiLKNLnN9FoR+NvjOhu03+3XfjAKKoXMOxoNI1Q/IHWjVQmJI
         cpLw==
X-Gm-Message-State: AOAM530XiL3Lg/Sti31YBJXxt25WjxEl6NUgbJF0w9YZJuAlQW4gTfT2
        VHJjcc4m4bwK5z0vSb4uhT8=
X-Google-Smtp-Source: ABdhPJyRBJSH67CaK3tFmpv+UdQGbRsqyk2fjY6i96cGS3Btd1UoluWexQwE2vk2pZxt7HY7O5xPQw==
X-Received: by 2002:aa7:8611:0:b0:49f:a5b3:14b4 with SMTP id p17-20020aa78611000000b0049fa5b314b4mr9525248pfn.30.1636224189396;
        Sat, 06 Nov 2021 11:43:09 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:5e3b])
        by smtp.gmail.com with ESMTPSA id mv22sm8986084pjb.36.2021.11.06.11.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Nov 2021 11:43:09 -0700 (PDT)
Date:   Sat, 6 Nov 2021 11:43:07 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 2/2] selftests/bpf: add benchmark bpf_strcmp
Message-ID: <20211106184307.7gbztgkeprktbohz@ast-mbp.dhcp.thefacebook.com>
References: <20211106132822.1396621-1-houtao1@huawei.com>
 <20211106132822.1396621-3-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211106132822.1396621-3-houtao1@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 06, 2021 at 09:28:22PM +0800, Hou Tao wrote:
> The benchmark runs a loop 5000 times. In the loop it reads the file name
> from kprobe argument into stack by using bpf_probe_read_kernel_str(),
> and compares the file name with a target character or string.
> 
> Three cases are compared: only compare one character, compare the whole
> string by a home-made strncmp() and compare the whole string by
> bpf_strcmp().
> 
> The following is the result:
> 
> x86-64 host:
> 
> one character: 2613499 ns
> whole str by strncmp: 2920348 ns
> whole str by helper: 2779332 ns
> 
> arm64 host:
> 
> one character: 3898867 ns
> whole str by strncmp: 4396787 ns
> whole str by helper: 3968113 ns
> 
> Compared with home-made strncmp, the performance of bpf_strncmp helper
> improves 80% under x86-64 and 600% under arm64. The big performance win
> on arm64 may comes from its arch-optimized strncmp().

80% and 600% improvement?!
I don't understand how this math works.

Why one char is barely different in total nsec than the whole string?
The string shouldn't miscompare on the first char as far as I understand the test.
