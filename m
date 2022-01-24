Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD056498D9A
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 20:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347096AbiAXTdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 14:33:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:26900 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353012AbiAXTbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 14:31:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643052707; x=1674588707;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TG2q+/j5awwYR/POyqAYX1Q9rqeQKWr70oDpRqB7LlU=;
  b=OpeDbzmomFhVe/xtmUHEXwiUECnmsupX24xydig8bqPJAE5iSyZgGV3H
   HJ+0C+aNTyHd4KkdlBG29Sn/pJ4oSasnJXF5WxUysDFU2+iii87KTouIL
   kn3/EAqHOXOkEUuH5quaTwI+Emhq7Du0i5Wb7tVv38iajEl72jtCc7KQ/
   Us7CAamZ6YgUxIX+No0AScHuXwiQM2uJBAp8IpOQPqjQ8l2EbcYCAJ8AI
   I66TYZFHxPLRVakCtpIeHpM7XObVYSoFjh8O2dntFAuZ+T05/rC9Ci+De
   dtPLukTA5Xbt3srOjVQVswkIWZBge1LnyrY2lG0Jp6v9YwhVDAPGsUSY3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="270567357"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="270567357"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 11:25:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="768782484"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 24 Jan 2022 11:25:03 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nC4xa-000IoP-Oz; Mon, 24 Jan 2022 19:25:02 +0000
Date:   Tue, 25 Jan 2022 03:24:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kbuild-all@lists.01.org, Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v4 5/9] ARM: rethook: Add rethook arm implementation
Message-ID: <202201250328.drn6ia3n-lkp@intel.com>
References: <164304061932.1680787.11603911228891618150.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164304061932.1680787.11603911228891618150.stgit@devnote2>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Masami,

I love your patch! Yet something to improve:

[auto build test ERROR on rostedt-trace/for-next]
[also build test ERROR on arm64/for-next/core tip/x86/core linus/master v5.17-rc1 next-20220124]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Masami-Hiramatsu/fprobe-Introduce-fprobe-function-entry-exit-probe/20220125-001253
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git for-next
config: arm-aspeed_g5_defconfig (https://download.01.org/0day-ci/archive/20220125/202201250328.drn6ia3n-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/df6df88bb474db78d80fc5619d39b25ec15d5d16
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Masami-Hiramatsu/fprobe-Introduce-fprobe-function-entry-exit-probe/20220125-001253
        git checkout df6df88bb474db78d80fc5619d39b25ec15d5d16
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash arch/arm/kernel/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/arm/kernel/stacktrace.c: In function 'unwind_frame':
>> arch/arm/kernel/stacktrace.c:71:56: error: 'struct stackframe' has no member named 'tsk'
      71 |                 frame->pc = rethook_find_ret_addr(frame->tsk, frame->fp,
         |                                                        ^~
>> arch/arm/kernel/stacktrace.c:72:57: error: 'struct stackframe' has no member named 'kr_cur'
      72 |                                                   &frame->kr_cur);
         |                                                         ^~


vim +71 arch/arm/kernel/stacktrace.c

    12	
    13	#if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)
    14	/*
    15	 * Unwind the current stack frame and store the new register values in the
    16	 * structure passed as argument. Unwinding is equivalent to a function return,
    17	 * hence the new PC value rather than LR should be used for backtrace.
    18	 *
    19	 * With framepointer enabled, a simple function prologue looks like this:
    20	 *	mov	ip, sp
    21	 *	stmdb	sp!, {fp, ip, lr, pc}
    22	 *	sub	fp, ip, #4
    23	 *
    24	 * A simple function epilogue looks like this:
    25	 *	ldm	sp, {fp, sp, pc}
    26	 *
    27	 * When compiled with clang, pc and sp are not pushed. A simple function
    28	 * prologue looks like this when built with clang:
    29	 *
    30	 *	stmdb	{..., fp, lr}
    31	 *	add	fp, sp, #x
    32	 *	sub	sp, sp, #y
    33	 *
    34	 * A simple function epilogue looks like this when built with clang:
    35	 *
    36	 *	sub	sp, fp, #x
    37	 *	ldm	{..., fp, pc}
    38	 *
    39	 *
    40	 * Note that with framepointer enabled, even the leaf functions have the same
    41	 * prologue and epilogue, therefore we can ignore the LR value in this case.
    42	 */
    43	int notrace unwind_frame(struct stackframe *frame)
    44	{
    45		unsigned long high, low;
    46		unsigned long fp = frame->fp;
    47	
    48		/* only go to a higher address on the stack */
    49		low = frame->sp;
    50		high = ALIGN(low, THREAD_SIZE);
    51	
    52	#ifdef CONFIG_CC_IS_CLANG
    53		/* check current frame pointer is within bounds */
    54		if (fp < low + 4 || fp > high - 4)
    55			return -EINVAL;
    56	
    57		frame->sp = frame->fp;
    58		frame->fp = *(unsigned long *)(fp);
    59		frame->pc = *(unsigned long *)(fp + 4);
    60	#else
    61		/* check current frame pointer is within bounds */
    62		if (fp < low + 12 || fp > high - 4)
    63			return -EINVAL;
    64	
    65		/* restore the registers from the stack frame */
    66		frame->fp = *(unsigned long *)(fp - 12);
    67		frame->sp = *(unsigned long *)(fp - 8);
    68		frame->pc = *(unsigned long *)(fp - 4);
    69	#endif
    70		if (IS_ENABLED(CONFIG_RETHOOK) && is_rethook_trampoline(frame->pc))
  > 71			frame->pc = rethook_find_ret_addr(frame->tsk, frame->fp,
  > 72							  &frame->kr_cur);
    73	#ifdef CONFIG_KRETPROBES
    74		if (is_kretprobe_trampoline(frame->pc))
    75			frame->pc = kretprobe_find_ret_addr(frame->tsk,
    76						(void *)frame->fp, &frame->kr_cur);
    77	#endif
    78	
    79		return 0;
    80	}
    81	#endif
    82	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
