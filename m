Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718FF24E3B8
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 01:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgHUXAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 19:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgHUXAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 19:00:35 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF0FC061573;
        Fri, 21 Aug 2020 16:00:34 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d19so1668897pgl.10;
        Fri, 21 Aug 2020 16:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TCw2I4LhckzIKslySIEuB7+DYrxiWBg1FZst/Fotyz4=;
        b=hZVidOd+0BEVo/RuP5YFEw4LqB+zyXGcvVf+BHZvrGLZrNDSIqZb94dqeYtBg7hNgD
         4TmO7YAoX1qU9P7A7IPyeB4WOWMF8XFZUgUz2K+PumuGsbOCm6QNhhIHUG9DKFF+ZuDH
         8U7XRkVR8lu8N9wmjDyqa9/Vabgwo25IMN42k/FrxyGbFoR1YaL/YweV1Uik2hlOc3ie
         axlQ8v2QkOfIz4RajYkWqNGPxB3v0fIZiKEjKLc7BT2w4sHoZ/GAaACbLFnjC13YkTST
         1b9LnMaxlvYfRb9d3U9gLi7TolmWtUsPRuvgfOP9o02WT+dBPG5lT7PkaRv9QP48wt+3
         KoQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TCw2I4LhckzIKslySIEuB7+DYrxiWBg1FZst/Fotyz4=;
        b=GoefnF8roDk6n3pUceHqmLeYeO7wYdPinGkLpccud1LjmGq7A41hAsJSDauSzFh/+6
         9AYI7jpjSvl5U5pj7r2uqT9Ec8CdgtsyBaBRFMpxiUhDtQI/S6/wX59y4Pcz/gB5M9jO
         2+gZQb4gIh2RIwWrTYpyXpfc8P5zQaP7IOyZbez9Jlk4n0sV/aqoaPPh95xLiTnCG9c/
         7p44Lo3++IOc7qsYR1fjuFhhr/LuvLWvbiMTpaWkrETHqjNyM1vhAPgOZCSwWLencVve
         AL+BAlGCMMxMsncq1VzyVy++cWht1FpPF6NsSZnXKylZ+zWLcC5qRHAvIB/kHFgPJlNX
         zvAQ==
X-Gm-Message-State: AOAM531gxM/GxV03m+7Nqgo6yUixSh2W1D+UzE9/YzcFo1F5fkhshfQ2
        egSaIy5BlizeNRgVUlXQEd4wd93svaU=
X-Google-Smtp-Source: ABdhPJzEJu68pmsi1N2tMPnQyVQJ/B40MgxE+Us/gMiOLRgL7urDINIgxZUdgssscEsQUhkzoM5rAA==
X-Received: by 2002:a63:6fc6:: with SMTP id k189mr3676409pgc.165.1598050834027;
        Fri, 21 Aug 2020 16:00:34 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8791])
        by smtp.gmail.com with ESMTPSA id e26sm3526618pfj.197.2020.08.21.16.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 16:00:33 -0700 (PDT)
Date:   Fri, 21 Aug 2020 16:00:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 00/16] Add libbpf full support for BPF-to-BPF
 calls
Message-ID: <20200821230031.3p6x7twnt4reayou@ast-mbp.dhcp.thefacebook.com>
References: <20200820231250.1293069-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820231250.1293069-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 04:12:34PM -0700, Andrii Nakryiko wrote:
> Currently, libbpf supports a limited form of BPF-to-BPF subprogram calls. The
> restriction is that entry-point BPF program should use *all* of defined
> sub-programs in BPF .o file. If any of the subprograms is not used, such
> entry-point BPF program will be rejected by verifier as containing unreachable
> dead code. This is not a big limitation for cases with single entry-point BPF
> programs, but is quite a havy restriction for multi-programs that use only
> partially overlapping set of subprograms.
> 
> This patch sets removes all such restrictions and adds complete support for
> using BPF sub-program calls on BPF side. This is achieved through libbpf
> tracking subprograms individually and detecting which subprograms are used by
> any given entry-point BPF program, and subsequently only appending and
> relocating code for just those used subprograms.
> 
> In addition, libbpf now also supports multiple entry-point BPF programs within
> the same ELF section. This allows to structure code so that there are few
> variants of BPF programs of the same type and attaching to the same target
> (e.g., for tracepoints and kprobes) without the need to worry about ELF
> section name clashes.
> 
> This patch set opens way for more wider adoption of BPF subprogram calls,
> especially for real-world production use-cases with complicated net of
> subprograms. This will allow to further scale BPF verification process through
> good use of global functions, which can be verified independently. This is
> also important prerequisite for static linking which allows static BPF
> libraries to not worry about naming clashes for section names, as well as use
> static non-inlined functions (subprograms) without worries of verifier
> rejecting program due to dead code.
> 
> Patch set is structured as follows:
> - patches 1-5 contain various smaller improvements to logging and selftests;
> - patched 6-11 contain all the libbpf changes necessary to support multi-prog
>   sections and bpf2bpf subcalls;
> - patch 12 adds dedicated selftests validating all combinations of possible
>   sub-calls (within and across sections, static vs global functions);
> - patch 13 deprecated bpf_program__title() in favor of
>   bpf_program__section_name(). The intent was to also deprecate
>   bpf_object__find_program_by_title() as it's now non-sensical with multiple
>   programs per section. But there were too many selftests uses of this and
>   I didn't want to delay this patches further and make it even bigger, so left
>   it for a follow up cleanup;
> - patches 14-15 remove uses for title-related APIs from bpftool and
>   bpf_program__title() use from selftests;
> - patch 16 is converting fexit_bpf2bpf to have explicit subtest (it does
>   contain 4 subtests, which are not handled as sub-tests).

I've applied the first 5 patches. Cleanup of 'elf:' logs is nice.
Thanks for doing it.
The rest of the patches look fine as well, but minimalistic selftest is
a bit concerning for such major update to libbpf.
Please consider expanding the tests.
May be cloudflare's test_cls_redirect.c can be adopted for this purpose?
test_xdp_noinline.c can also be extended by doing two copies of
balancer_ingress(). One to process ipv4 another ipv6.
Then it will make libbpf to do plenty of intersting call adjustments
and function munipulations for three programs in "xdp-test" section
that use different sets of sub-programs.
test_l4lb_noinline.c can be another candidate.
The selftest that is part of this set is nice for targeted debugging, but would
be great to see production bpf prog adopting this exciting libbpf feature.
