Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AE8CC72A
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 03:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbfJEBUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 21:20:53 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42067 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJEBUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 21:20:53 -0400
Received: by mail-oi1-f194.google.com with SMTP id i185so7291554oif.9
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 18:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=l7SpZ5N+nq30rgJQpL3EBg3liLfBQdxTGgET1uXmwsc=;
        b=Zze+RMswfsiddqq3WNI6XF4iUfnjUN6r5TgrfWQ4m6MyLHMOGcWr4pEvPthzvwK8aN
         tt1fKZzJzv6YWCnV00bfmaolg5RrsHhjCXMRdAd9mQyvBTuwFB7dxJvhxWh2MphwtRh9
         PBjrwgb5NQPBRaMP+qkUDRWwWhCnohuoUhclbWAWelsBXXZJiPZr7waaEGU5epdBmy31
         82zCYtmRC57tRi55eycEDhBXSt2ihJGHpdbsNqKa2WVexsNXjySNeZ9MTZFQUaJH8rLu
         91RMXm5UnBZPKPxRp6Qa3HhgE6eZP/hsLXtZNeCZqU4f1wIKjm3KU1rBQ+KxyfJGkAOq
         mcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=l7SpZ5N+nq30rgJQpL3EBg3liLfBQdxTGgET1uXmwsc=;
        b=hnF6TkulU9hyI3lhx9e5EkESQ2tJQssbH0fC9cA2MZevmZIbadVeDlIg/IwNWmCHaP
         X56c3bWXgD4LWbcZzL+tcIXdm2p+gu9EeWgr1Q181A3URGtEdYkIXr0aM97zGIp8JtRx
         Gm9P5SSW8nbcprH2Sy678i1NsZ7dLP4xf5znqPsvh7hLtCrk2UR6VIgQJrKW23AkjJsP
         lJn5nJ32JVzV9TcN+7SwMCEFMK7hZP58ilIWbj7xU1VwkoFhd/6MoIjdmEJR+mXSAHT4
         R87LxrGUgGv6B/yCyp7Dz8gAJbyADq6MgVVPQjgSBH+2Pq4gi7p+rFgeR2ES9+zicCEW
         IlIw==
X-Gm-Message-State: APjAAAU8Pv+qNH+gZ3XWTVPwPy6SI5FZGzrfLAY7P5oSqeTAIlZfiL41
        d0meubxRvWJYfAVij1xTnv45ZQ==
X-Google-Smtp-Source: APXvYqzioOi+HOtThzusxaB/ANabIUdROpbaSBNWELHI+GDE5ZcWC75F+oaJ1TZH0khzFfbAEuRH6w==
X-Received: by 2002:aca:c4d3:: with SMTP id u202mr8918088oif.139.1570238452426;
        Fri, 04 Oct 2019 18:20:52 -0700 (PDT)
Received: from localhost ([2600:100e:b029:4ada:34fb:aeb7:d598:e51c])
        by smtp.gmail.com with ESMTPSA id y30sm2321328oix.36.2019.10.04.18.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 18:20:51 -0700 (PDT)
Date:   Fri, 4 Oct 2019 18:20:50 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Shuah Khan <shuah@kernel.org>
cc:     Palmer Dabbelt <palmer@sifive.com>,
        David Abdurachmanov <david.abdurachmanov@gmail.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Abdurachmanov <david.abdurachmanov@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Vincent Chen <vincentc@andestech.com>,
        Alan Kao <alankao@andestech.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, me@carlosedp.com
Subject: Re: [PATCH v2] riscv: add support for SECCOMP and SECCOMP_FILTER
In-Reply-To: <20190822205533.4877-1-david.abdurachmanov@sifive.com>
Message-ID: <alpine.DEB.2.21.9999.1910041819230.15827@viisi.sifive.com>
References: <20190822205533.4877-1-david.abdurachmanov@sifive.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Shuah,

On Thu, 22 Aug 2019, David Abdurachmanov wrote:

> This patch was extensively tested on Fedora/RISCV (applied by default on
> top of 5.2-rc7 kernel for <2 months). The patch was also tested with 5.3-rc
> on QEMU and SiFive Unleashed board.
> 
> libseccomp (userspace) was rebased:
> https://github.com/seccomp/libseccomp/pull/134
> 
> Fully passes libseccomp regression testing (simulation and live).
> 
> There is one failing kernel selftest: global.user_notification_signal
> 
> v1 -> v2:
>   - return immediatly if secure_computing(NULL) returns -1
>   - fixed whitespace issues
>   - add missing seccomp.h
>   - remove patch #2 (solved now)
>   - add riscv to seccomp kernel selftest
> 
> Cc: keescook@chromium.org
> Cc: me@carlosedp.com
> 
> Signed-off-by: David Abdurachmanov <david.abdurachmanov@sifive.com>

We'd like to merge this patch through the RISC-V tree.
Care to ack the change to tools/testing/selftests/seccomp/seccomp_bpf.c ?  

Kees has already reviewed it:

https://lore.kernel.org/linux-riscv/CAJr-aD=UnCN9E_mdVJ2H5nt=6juRSWikZnA5HxDLQxXLbsRz-w@mail.gmail.com/


- Paul


> ---
>  arch/riscv/Kconfig                            | 14 ++++++++++
>  arch/riscv/include/asm/seccomp.h              | 10 +++++++
>  arch/riscv/include/asm/thread_info.h          |  5 +++-
>  arch/riscv/kernel/entry.S                     | 27 +++++++++++++++++--
>  arch/riscv/kernel/ptrace.c                    | 10 +++++++
>  tools/testing/selftests/seccomp/seccomp_bpf.c |  8 +++++-
>  6 files changed, 70 insertions(+), 4 deletions(-)
>  create mode 100644 arch/riscv/include/asm/seccomp.h
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 59a4727ecd6c..441e63ff5adc 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -31,6 +31,7 @@ config RISCV
>  	select GENERIC_SMP_IDLE_THREAD
>  	select GENERIC_ATOMIC64 if !64BIT
>  	select HAVE_ARCH_AUDITSYSCALL
> +	select HAVE_ARCH_SECCOMP_FILTER
>  	select HAVE_MEMBLOCK_NODE_MAP
>  	select HAVE_DMA_CONTIGUOUS
>  	select HAVE_FUTEX_CMPXCHG if FUTEX
> @@ -235,6 +236,19 @@ menu "Kernel features"
>  
>  source "kernel/Kconfig.hz"
>  
> +config SECCOMP
> +	bool "Enable seccomp to safely compute untrusted bytecode"
> +	help
> +	  This kernel feature is useful for number crunching applications
> +	  that may need to compute untrusted bytecode during their
> +	  execution. By using pipes or other transports made available to
> +	  the process as file descriptors supporting the read/write
> +	  syscalls, it's possible to isolate those applications in
> +	  their own address space using seccomp. Once seccomp is
> +	  enabled via prctl(PR_SET_SECCOMP), it cannot be disabled
> +	  and the task is only allowed to execute a few safe syscalls
> +	  defined by each seccomp mode.
> +
>  endmenu
>  
>  menu "Boot options"
> diff --git a/arch/riscv/include/asm/seccomp.h b/arch/riscv/include/asm/seccomp.h
> new file mode 100644
> index 000000000000..bf7744ee3b3d
> --- /dev/null
> +++ b/arch/riscv/include/asm/seccomp.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _ASM_SECCOMP_H
> +#define _ASM_SECCOMP_H
> +
> +#include <asm/unistd.h>
> +
> +#include <asm-generic/seccomp.h>
> +
> +#endif /* _ASM_SECCOMP_H */
> diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
> index 905372d7eeb8..a0b2a29a0da1 100644
> --- a/arch/riscv/include/asm/thread_info.h
> +++ b/arch/riscv/include/asm/thread_info.h
> @@ -75,6 +75,7 @@ struct thread_info {
>  #define TIF_MEMDIE		5	/* is terminating due to OOM killer */
>  #define TIF_SYSCALL_TRACEPOINT  6       /* syscall tracepoint instrumentation */
>  #define TIF_SYSCALL_AUDIT	7	/* syscall auditing */
> +#define TIF_SECCOMP		8	/* syscall secure computing */
>  
>  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
>  #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
> @@ -82,11 +83,13 @@ struct thread_info {
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
>  #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
>  #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
> +#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
>  
>  #define _TIF_WORK_MASK \
>  	(_TIF_NOTIFY_RESUME | _TIF_SIGPENDING | _TIF_NEED_RESCHED)
>  
>  #define _TIF_SYSCALL_WORK \
> -	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_TRACEPOINT | _TIF_SYSCALL_AUDIT)
> +	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_TRACEPOINT | _TIF_SYSCALL_AUDIT | \
> +	 _TIF_SECCOMP )
>  
>  #endif /* _ASM_RISCV_THREAD_INFO_H */
> diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
> index bc7a56e1ca6f..0bbedfa3e47d 100644
> --- a/arch/riscv/kernel/entry.S
> +++ b/arch/riscv/kernel/entry.S
> @@ -203,8 +203,25 @@ check_syscall_nr:
>  	/* Check to make sure we don't jump to a bogus syscall number. */
>  	li t0, __NR_syscalls
>  	la s0, sys_ni_syscall
> -	/* Syscall number held in a7 */
> -	bgeu a7, t0, 1f
> +	/*
> +	 * The tracer can change syscall number to valid/invalid value.
> +	 * We use syscall_set_nr helper in syscall_trace_enter thus we
> +	 * cannot trust the current value in a7 and have to reload from
> +	 * the current task pt_regs.
> +	 */
> +	REG_L a7, PT_A7(sp)
> +	/*
> +	 * Syscall number held in a7.
> +	 * If syscall number is above allowed value, redirect to ni_syscall.
> +	 */
> +	bge a7, t0, 1f
> +	/*
> +	 * Check if syscall is rejected by tracer or seccomp, i.e., a7 == -1.
> +	 * If yes, we pretend it was executed.
> +	 */
> +	li t1, -1
> +	beq a7, t1, ret_from_syscall_rejected
> +	/* Call syscall */
>  	la s0, sys_call_table
>  	slli t0, a7, RISCV_LGPTR
>  	add s0, s0, t0
> @@ -215,6 +232,12 @@ check_syscall_nr:
>  ret_from_syscall:
>  	/* Set user a0 to kernel a0 */
>  	REG_S a0, PT_A0(sp)
> +	/*
> +	 * We didn't execute the actual syscall.
> +	 * Seccomp already set return value for the current task pt_regs.
> +	 * (If it was configured with SECCOMP_RET_ERRNO/TRACE)
> +	 */
> +ret_from_syscall_rejected:
>  	/* Trace syscalls, but only if requested by the user. */
>  	REG_L t0, TASK_TI_FLAGS(tp)
>  	andi t0, t0, _TIF_SYSCALL_WORK
> diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
> index 368751438366..63e47c9f85f0 100644
> --- a/arch/riscv/kernel/ptrace.c
> +++ b/arch/riscv/kernel/ptrace.c
> @@ -154,6 +154,16 @@ void do_syscall_trace_enter(struct pt_regs *regs)
>  		if (tracehook_report_syscall_entry(regs))
>  			syscall_set_nr(current, regs, -1);
>  
> +	/*
> +	 * Do the secure computing after ptrace; failures should be fast.
> +	 * If this fails we might have return value in a0 from seccomp
> +	 * (via SECCOMP_RET_ERRNO/TRACE).
> +	 */
> +	if (secure_computing(NULL) == -1) {
> +		syscall_set_nr(current, regs, -1);
> +		return;
> +	}
> +
>  #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
>  	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
>  		trace_sys_enter(regs, syscall_get_nr(current, regs));
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> index 6ef7f16c4cf5..492e0adad9d3 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -112,6 +112,8 @@ struct seccomp_data {
>  #  define __NR_seccomp 383
>  # elif defined(__aarch64__)
>  #  define __NR_seccomp 277
> +# elif defined(__riscv)
> +#  define __NR_seccomp 277
>  # elif defined(__hppa__)
>  #  define __NR_seccomp 338
>  # elif defined(__powerpc__)
> @@ -1582,6 +1584,10 @@ TEST_F(TRACE_poke, getpid_runs_normally)
>  # define ARCH_REGS	struct user_pt_regs
>  # define SYSCALL_NUM	regs[8]
>  # define SYSCALL_RET	regs[0]
> +#elif defined(__riscv) && __riscv_xlen == 64
> +# define ARCH_REGS	struct user_regs_struct
> +# define SYSCALL_NUM	a7
> +# define SYSCALL_RET	a0
>  #elif defined(__hppa__)
>  # define ARCH_REGS	struct user_regs_struct
>  # define SYSCALL_NUM	gr[20]
> @@ -1671,7 +1677,7 @@ void change_syscall(struct __test_metadata *_metadata,
>  	EXPECT_EQ(0, ret) {}
>  
>  #if defined(__x86_64__) || defined(__i386__) || defined(__powerpc__) || \
> -    defined(__s390__) || defined(__hppa__)
> +    defined(__s390__) || defined(__hppa__) || defined(__riscv)
>  	{
>  		regs.SYSCALL_NUM = syscall;
>  	}
> -- 
> 2.21.0
> 
> 


- Paul
