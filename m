Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47CD1E993A
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 19:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgEaRTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 13:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbgEaRTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 13:19:19 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A43C061A0E;
        Sun, 31 May 2020 10:19:19 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id g5so2341503pfm.10;
        Sun, 31 May 2020 10:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0NoqoLgeFV05DwStme6AY8HWmUhYmSoSETzNa4bMDsM=;
        b=bp29/DVJEfBLIyIdCDBJ3UqDJ+xLd82ss6uIJt/00FgFMbz/S4Gl4vPr5u4kYjkZ56
         JksrUcYZ0Wr8qEqKciMSFkiCTdM2xxbZSUt+v2pjkwoB2/vZgF6e8+w9H8zFozI5E0m2
         Y0CNkch4nNwbRKGEWo0L3H2byr4QhL+AV/bMN9dWlY12Dn8XvpbFY0i6bystBI2p9wIh
         qIBs2TmyPXWaBR0wrRM3i5JzMH9fX9tUk5OsK1GQC4dRCe9uOJbLdeweyG+VaPXhpV3a
         PL+ED8ksHuRx9pEPdRdrYN3ouurh4q3+0ZB7K690wlwvEnxzHlRKiHC573owPk5hxcoY
         zrdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0NoqoLgeFV05DwStme6AY8HWmUhYmSoSETzNa4bMDsM=;
        b=X+QXRvfFC1bsoGRlLhcdcwY0n/nuH2695va1ZD4LlBPWVoUH1XPmqPJFEuCpKHbeUe
         fR5JiWqQC3BTYhgruLSBNkNjX5Mv26steCHAey/z7UM7jNwsIXL5Hzkw5Q1KsRKZb8sP
         Lv2F0RJvlZU9ZoTDfA7oQq6cHvMII4omDYIW9slbAGNyMCSPLEwi/WcRVkQCUB57oFv3
         P5norjtwQHyuBXQuF8sYQ3TaKxr2Qa2TrcMspfOGuvamgZHkyckEiZq6MC5AOrYwoThM
         ef1hhP9ry029OnUFyaVa+hEaAnA6YKdpdSZNy+FjK4HruRqoh3VuohJ6q4mxzbsifMJg
         HwvA==
X-Gm-Message-State: AOAM532sdxwRqBR7TZUGzINLLjhPnETd48vdmfkNpoubsgw56b5MXbtK
        8GPGffLbx1pFogU7MJXaWzLhdg90
X-Google-Smtp-Source: ABdhPJy29IWuxxHi6iPZpFGhGmaPW4Gylj3OcVtJcrTRlrQJeuiPWlNqKTWPys/AZ3BvOv+MaBjCbQ==
X-Received: by 2002:a05:6a00:2b0:: with SMTP id q16mr1187613pfs.104.1590945558897;
        Sun, 31 May 2020 10:19:18 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:6ddc])
        by smtp.gmail.com with ESMTPSA id 2sm12046502pfd.163.2020.05.31.10.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 10:19:17 -0700 (PDT)
Date:   Sun, 31 May 2020 10:19:15 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     "zhujianwei (C)" <zhujianwei7@huawei.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        Hehuazhen <hehuazhen@huawei.com>,
        Lennart Poettering <lennart@poettering.net>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        Zbigniew =?utf-8?Q?J=C4=99drzejewski-Szmek?= <zbyszek@in.waw.pl>,
        daniel@iogearbox.net, netdev@vger.kernel.org
Subject: Re: new seccomp mode aims to improve performance
Message-ID: <20200531171915.wsxvdjeetmhpsdv2@ast-mbp.dhcp.thefacebook.com>
References: <c22a6c3cefc2412cad00ae14c1371711@huawei.com>
 <CAADnVQLnFuOR+Xk1QXpLFGHx-8StPCye7j5UgKbBoLrmKtygQA@mail.gmail.com>
 <202005290903.11E67AB0FD@keescook>
 <202005291043.A63D910A8@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202005291043.A63D910A8@keescook>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 12:27:03PM -0700, Kees Cook wrote:
> On Fri, May 29, 2020 at 09:09:28AM -0700, Kees Cook wrote:
> > On Fri, May 29, 2020 at 08:43:56AM -0700, Alexei Starovoitov wrote:
> > > I don't think your hunch at where cpu is spending cycles is correct.
> > > Could you please do two experiments:
> > > 1. try trivial seccomp bpf prog that simply returns 'allow'
> > > 2. replace bpf_prog_run_pin_on_cpu() in seccomp.c with C code
> > >   that returns 'allow' and make sure it's noinline or in a different C file,
> > >   so that compiler doesn't optimize the whole seccomp_run_filters() into a nop.
> > > 
> > > Then measure performance of both.
> > > I bet you'll see exactly the same numbers.
> > 
> > Android has already done this, it appeared to not be the same. Calling
> > into a SECCOMP_RET_ALLOW filter had a surprisingly high cost. I'll see
> > if I can get you the numbers. I was frankly quite surprised -- I
> > understood the bulk of the seccomp overhead to be in taking the TIF_WORK
> > path, copying arguments, etc, but something else is going on there.
> 
> So while it's not the Android measurements, here's what I'm seeing on
> x86_64 (this is hardly a perfect noiseless benchmark, but sampling error
> appears to close to 1%):
> 
> 
> net.core.bpf_jit_enable=0:
> 
> Benchmarking 16777216 samples...
> 10.633756139 - 0.004359714 = 10629396425
> getpid native: 633 ns
> 23.008737499 - 10.633967641 = 12374769858
> getpid RET_ALLOW 1 filter: 737 ns
> 36.723141843 - 23.008975696 = 13714166147
> getpid RET_ALLOW 2 filters: 817 ns
> 47.751422021 - 36.723345630 = 11028076391
> getpid BPF-less allow: 657 ns
> Estimated total seccomp overhead for 1 filter: 104 ns
> Estimated total seccomp overhead for 2 filters: 184 ns
> Estimated seccomp per-filter overhead: 80 ns
> Estimated seccomp entry overhead: 24 ns
> Estimated BPF overhead per filter: 80 ns
> 
> 
> net.core.bpf_jit_enable=1:
> net.core.bpf_jit_harden=1:
> 
> Benchmarking 16777216 samples...
> 31.939978606 - 21.275190689 = 10664787917
> getpid native: 635 ns
> 43.324592380 - 31.940794751 = 11383797629
> getpid RET_ALLOW 1 filter: 678 ns
> 55.001650599 - 43.326293248 = 11675357351
> getpid RET_ALLOW 2 filters: 695 ns
> 65.986452855 - 55.002249904 = 10984202951
> getpid BPF-less allow: 654 ns
> Estimated total seccomp overhead for 1 filter: 43 ns
> Estimated total seccomp overhead for 2 filters: 60 ns
> Estimated seccomp per-filter overhead: 17 ns
> Estimated seccomp entry overhead: 26 ns
> Estimated BPF overhead per filter: 24 ns
> 
> 
> net.core.bpf_jit_enable=1:
> net.core.bpf_jit_harden=0:
> 
> Benchmarking 16777216 samples...
> 10.684681435 - 0.004198682 = 10680482753
> getpid native: 636 ns
> 22.050823167 - 10.685571417 = 11365251750
> getpid RET_ALLOW 1 filter: 677 ns
> 33.714134291 - 22.051100183 = 11663034108
> getpid RET_ALLOW 2 filters: 695 ns
> 44.793312551 - 33.714383001 = 11078929550
> getpid BPF-less allow: 660 ns
> Estimated total seccomp overhead for 1 filter: 41 ns
> Estimated total seccomp overhead for 2 filters: 59 ns
> Estimated seccomp per-filter overhead: 18 ns
> Estimated seccomp entry overhead: 23 ns
> Estimated BPF overhead per filter: 17 ns
> 
> 
> The above is from my (very dangerous!) benchmarking patch[1].

Thank you for crafting a benchmark.
The only thing that it's not doing a fair comparison.
The problem with that patch [1] that is using:

static noinline u32 __seccomp_benchmark(struct bpf_prog *prog,
                                        const struct seccomp_data *sd)
{
        return SECCOMP_RET_ALLOW;
}

as a benchmarking function.
The 'noinline' keyword tells the compiler to keep the body of the function, but
the compiler is still doing full control and data flow analysis though this
function and it is smart enough to optimize its usage in seccomp_run_filters()
and in __seccomp_filter() because all functions are in a single .c file.
Lots of code gets optimized away when 'f->benchmark' is on.

To make it into fair comparison I've added the following patch
on top of your [1].

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 2fdbf5ad8372..86204422e096 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -244,7 +244,7 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
        return 0;
 }

-static noinline u32 __seccomp_benchmark(struct bpf_prog *prog,
+__weak noinline u32 __seccomp_benchmark(struct bpf_prog *prog,
                                        const struct seccomp_data *sd)

Please take a look at 'make kernel/seccomp.s' before and after to see the difference
__weak keyword makes.
And here is what seccomp_benchmark now reports:

Benchmarking 33554432 samples...
22.618269641 - 15.030812794 = 7587456847
getpid native: 226 ns
30.792042986 - 22.619048831 = 8172994155
getpid RET_ALLOW 1 filter: 243 ns
39.451435038 - 30.792836778 = 8658598260
getpid RET_ALLOW 2 filters: 258 ns
47.616011529 - 39.452190830 = 8163820699
getpid BPF-less allow: 243 ns
Estimated total seccomp overhead for 1 filter: 17 ns
Estimated total seccomp overhead for 2 filters: 32 ns
Estimated seccomp per-filter overhead: 15 ns
Estimated seccomp entry overhead: 2 ns
Estimated BPF overhead per filter: 0 ns

Depending on the run BPF-less mode would be slower than with BPF ;)

Benchmarking 33554432 samples...
22.602737193 - 15.078827612 = 7523909581
getpid native: 224 ns
30.734009056 - 22.603540911 = 8130468145
getpid RET_ALLOW 1 filter: 242 ns
39.106701659 - 30.734762631 = 8371939028
getpid RET_ALLOW 2 filters: 249 ns
47.326509567 - 39.107552786 = 8218956781
getpid BPF-less allow: 244 ns
Estimated total seccomp overhead for 1 filter: 18 ns
Estimated total seccomp overhead for 2 filters: 25 ns
Estimated seccomp per-filter overhead: 7 ns
Estimated seccomp entry overhead: 11 ns
Estimated BPF overhead per filter: 18446744073709551614 ns

Above numbers were obtained on non-debug kernel with retpoline off
and net.core.bpf_jit_enable=1.
When retpoline=y the f->benchmark mode will be slightly faster
due to retpoline overhead.
If retpoline is a concern the bpf dispatcher logic can be applied to seccomp.
It eliminiated retpoline overhead in XDP/bpf fast path.

> So, with the layered nature of seccomp filters there's a reasonable gain
> to be seen for a O(1) bitmap lookup to skip running even a single filter,
> even for the fastest BPF mode.

This is not true.
The O(1) bitmap implemented as kernel C code will have exactly the same speed
as O(1) bitmap implemented as eBPF program.

> Not that we need to optimize for the pathological case, but this would
> be especially useful for cases like systemd, which appears to be
> constructing seccomp filters very inefficiently maybe on a per-syscall[3]
> basis? For example, systemd-resolved has 32 (!) seccomp filters
> attached[2]:
> 
> # grep ^Seccomp_filters /proc/$(pidof systemd-resolved)/status
> Seccomp_filters:        32
> 
> # grep SystemCall /lib/systemd/system/systemd-resolved.service
> SystemCallArchitectures=native
> SystemCallErrorNumber=EPERM
> SystemCallFilter=@system-service
> 
> I'd like to better understand what they're doing, but haven't had time
> to dig in. (The systemd devel mailing list requires subscription, so
> I've directly CCed some systemd folks that have touched seccomp there
> recently. Hi! The starts of this thread is here[4].)

32 seccomp filters sounds like a lot.
Would be great to find out what are they doing and whether
they can be optimized into much shorter and faster eBPF program.

> -Kees
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=seccomp/benchmark-bpf&id=20cc7d8f4238ea3bc1798f204bb865f4994cca27
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=for-next/seccomp&id=9d06f16f463cef5c445af9738efed2bfe4c64730
> [3] https://www.freedesktop.org/software/systemd/man/systemd.exec.html#SystemCallFilter=
> [4] https://lore.kernel.org/bpf/c22a6c3cefc2412cad00ae14c1371711@huawei.com/
> 
> -- 
> Kees Cook
