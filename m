Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC10168C55
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 05:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbgBVE3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 23:29:23 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38329 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgBVE3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 23:29:23 -0500
Received: by mail-pl1-f195.google.com with SMTP id t6so1731173plj.5;
        Fri, 21 Feb 2020 20:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=PQjtRg2D+YOC6LQJMq1KINxDIr5LnRlZetCwtD0Vi38=;
        b=pBS22jpp9wcAGM/vhbL/qfOoUEUz53/ZZxc78EYC3/qj9W+TxVvlUce2ekRwrj4jYk
         vQ7em5uYrWtP/uzC5X4LHZr1CnheDcX/whXy3A5qW0vzDuG2lQYbtfs1hud/EhFDXE1n
         3VvbHhteeNHqdJ5anEjGOfMaKwtNhGZWEDIPi52RPljJBOYaCDlzXPnlKeMGzF+vTp4S
         EHrCjXvzb+mOnNoA+la8EjOzUwuqlPOrTM9FOT9sBqhmJY2OHNvEV9TVOvMsVzWKy12+
         AydFje5jUabvi/VsWWKWd6yos8Gthd9Ln241LAcgm9yP8Kd6CWRoVX+Pj51Ttz54jzjU
         4o5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=PQjtRg2D+YOC6LQJMq1KINxDIr5LnRlZetCwtD0Vi38=;
        b=Zg3UWDztQbbTdWT1QMks2MOvzckrd7IL6ZmnXU4fISEBON1ZxEFfX5rTyuivfkDMEA
         X8JIA9xRXShVxr+E2RPT2I6/iu1hczMkaHc0J1TvMMDau2by/q57RUiX70NJQesy2zlR
         PVNlxlVRs+Xvb/xj385ECUNZ5hN4l7W6mFd3AfQK2+/gciDBhkBYc+lu+HcTsFpbtXw4
         60ZbOyVs5tzYnWVlXFDTn5mE5qZSMP+hKapaZgdJ00N6DuXaVA7C5HFJWYWvuBfviohp
         xWMDJlGVkc5XPOyTG6Q9oIIKPIpG4KLYZZcO140y1U5mv7W2YgMOHVH8nRs++vtWKtY6
         OBPw==
X-Gm-Message-State: APjAAAUmyZettZ89Y8IgJpR8M6+pXpEsUtnSE99CYQ0rjq6pQTy8zfIY
        FpwbTPpPkVT/gLAQw/z14uGA7i9W
X-Google-Smtp-Source: APXvYqxKXIjDBN7OZnDKOwPbjIMmZYyn+yK6hSWZkIP5ekA9p6l3VOAZyUShHMNfMhLl71ijHsRGug==
X-Received: by 2002:a17:90a:f0d1:: with SMTP id fa17mr6887514pjb.90.1582345762489;
        Fri, 21 Feb 2020 20:29:22 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:889f])
        by smtp.gmail.com with ESMTPSA id 13sm4337384pfj.68.2020.02.21.20.29.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Feb 2020 20:29:21 -0800 (PST)
Date:   Fri, 21 Feb 2020 20:29:18 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [patch V2 01/20] bpf: Enforce preallocation for all
 instrumentation programs
Message-ID: <20200222042916.k3r5dj5njoo2ywyj@ast-mbp>
References: <20200220204517.863202864@linutronix.de>
 <20200220204617.440152945@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200220204617.440152945@linutronix.de>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 09:45:18PM +0100, Thomas Gleixner wrote:
> The assumption that only programs attached to perf NMI events can deadlock
> on memory allocators is wrong. Assume the following simplified callchain:
> 
>  kmalloc() from regular non BPF context
>   cache empty
>    freelist empty
>     lock(zone->lock);
>      tracepoint or kprobe
>       BPF()
>        update_elem()
>         lock(bucket)
>           kmalloc()
>            cache empty
>             freelist empty
>              lock(zone->lock);  <- DEADLOCK
> 
> There are other ways which do not involve locking to create wreckage:
> 
>  kmalloc() from regular non BPF context
>   local_irq_save();
>    ...
>     obj = percpu_slab_first();
>      kprobe()
>       BPF()
>        update_elem()
>         lock(bucket)
>          kmalloc()
>           local_irq_save();
>            ...
>             obj = percpu_slab_first(); <- Same object as above ...
> 
> So preallocation _must_ be enforced for all variants of intrusive
> instrumentation.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> V2: New patch
> ---
>  kernel/bpf/verifier.c |   18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -8144,19 +8144,23 @@ static int check_map_prog_compatibility(
>  					struct bpf_prog *prog)
>  
>  {
> -	/* Make sure that BPF_PROG_TYPE_PERF_EVENT programs only use
> -	 * preallocated hash maps, since doing memory allocation
> -	 * in overflow_handler can crash depending on where nmi got
> -	 * triggered.
> +	/*
> +	 * Make sure that trace type programs only use preallocated hash
> +	 * maps. Perf programs obviously can't do memory allocation in NMI
> +	 * context and all other types can deadlock on a memory allocator
> +	 * lock when a tracepoint/kprobe triggers a BPF program inside a
> +	 * lock held region or create inconsistent state when the probe is
> +	 * within an interrupts disabled critical region in the memory
> +	 * allocator.
>  	 */
> -	if (prog->type == BPF_PROG_TYPE_PERF_EVENT) {
> +	if ((is_tracing_prog_type(prog->type)) {

This doesn't build.
I assumed the typo somehow sneaked in and proceeded, but it broke
a bunch of tests:
Summary: 1526 PASSED, 0 SKIPPED, 54 FAILED
One can argue that the test are unsafe and broken.
We used to test all those tests with and without prealloc:
map_flags = 0;
run_all_tests();
map_flags = BPF_F_NO_PREALLOC;
run_all_tests();
Then 4 years ago commit 5aa5bd14c5f866 switched hashmap to be no_prealloc
always and that how it stayed since then. We can adjust the tests to use
prealloc with tracing progs, but this breakage shows that there could be plenty
of bpf users that also use BPF_F_NO_PREALLOC with tracing. It could simply
be because they know that their kprobes are in a safe spot (and kmalloc is ok)
and they want to save memory. They could be using large max_entries parameter
for worst case hash map usage, but typical load is low. In general hashtables
don't perform well after 50%, so prealloc is wasting half of the memory. Since
we cannot control where kprobes are placed I'm not sure what is the right fix
here. It feels that if we proceed with this patch somebody will complain and we
would have to revert, but I'm willing to take this risk if we cannot come up
with an alternative fix.

Going further with the patchset.

Patch 9 "bpf: Use bpf_prog_run_pin_on_cpu() at simple call sites."
adds new warning:
../kernel/seccomp.c: In function ‘seccomp_run_filters’:
../kernel/seccomp.c:272:50: warning: passing argument 2 of ‘bpf_prog_run_pin_on_cpu’ discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
   u32 cur_ret = bpf_prog_run_pin_on_cpu(f->prog, sd);

I fixed it up and proceeded, but patch 16 failed to apply:

Applying: bpf: Factor out hashtab bucket lock operations
error: sha1 information is lacking or useless (kernel/bpf/hashtab.c).
error: could not build fake ancestor
Patch failed at 0001 bpf: Factor out hashtab bucket lock operations

I patched it in manually:
patch -p1 < a.patch
patching file kernel/bpf/hashtab.c
Hunk #1 succeeded at 1333 (offset 14 lines).
Hunk #2 succeeded at 1361 with fuzz 1 (offset 24 lines).
Hunk #3 succeeded at 1372 with fuzz 1 (offset 27 lines).
Hunk #4 succeeded at 1442 (offset 48 lines).
patching file kernel/bpf/syscall.c

and it looks correct.

But patch 17 failed completely:
patch -p1 < b.patch
patching file kernel/bpf/hashtab.c
Hunk #1 succeeded at 88 (offset 1 line).
Hunk #2 succeeded at 374 (offset 12 lines).
Hunk #3 succeeded at 437 (offset 12 lines).
Hunk #4 succeeded at 645 (offset 12 lines).
Hunk #5 succeeded at 653 (offset 12 lines).
Hunk #6 succeeded at 919 (offset 12 lines).
Hunk #7 succeeded at 960 (offset 12 lines).
Hunk #8 succeeded at 998 (offset 12 lines).
Hunk #9 succeeded at 1017 (offset 12 lines).
Hunk #10 succeeded at 1052 (offset 12 lines).
Hunk #11 succeeded at 1075 (offset 12 lines).
Hunk #12 succeeded at 1115 (offset 12 lines).
Hunk #13 succeeded at 1137 (offset 12 lines).
Hunk #14 succeeded at 1175 (offset 12 lines).
Hunk #15 succeeded at 1185 (offset 12 lines).
Hunk #16 succeeded at 1207 (offset 12 lines).
Hunk #17 succeeded at 1216 (offset 12 lines).
Hunk #18 FAILED at 1349.
Hunk #19 FAILED at 1358.
Hunk #20 FAILED at 1366.
Hunk #21 FAILED at 1407.
4 out of 21 hunks FAILED -- saving rejects to file kernel/bpf/hashtab.c.rej

That's where I gave up.

I pulled sched-for-bpf-2020-02-20 branch from tip and pushed it into bpf-next.
Could you please rebase your set on top of bpf-next and repost?
The logic in all patches looks good.

For now I propose to drop patch 1 and get the rest merged while we're
figuring out what to do.

Thanks!
