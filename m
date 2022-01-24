Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBB1499EB5
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 00:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383213AbiAXWms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 17:42:48 -0500
Received: from mga12.intel.com ([192.55.52.136]:46514 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1588220AbiAXWbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 17:31:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643063503; x=1674599503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MlBqFzOGHIqRIuV84uGl2sQ80qahuQb+v1H8qqH9+uE=;
  b=Ur3gemQ/tJSz1KO6/iWLb+7Bv2HtN33s3NsmisnhjNdSn6LheNB1xFQZ
   /m4oMnx8/HyBV8dR/wlxrggbLhVkP67pekpMBualkwrRdM1gIziJlZmbB
   Prj+XvBfFKUyKlC1q3ep4nHfThO9Rsy2b+H5Gh+kFZmUY3/tXTq7F1FBZ
   m7PClu2QaTM/Djl7ioTFQaSOE5EWYBG2D6QrTilpOJS6ynitrtTrbUWA+
   GQChFCaypaG2dsJb99kJurdCP4pdaH7V/bIXN+/ZmWSD9lJsi/9V7nPE9
   TtoWSiJRtGPGq0+aOP+WYIz8T4Qd632t+oHn5/FXpj+c5Mdt8syw2o6vr
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="226141043"
X-IronPort-AV: E=Sophos;i="5.88,313,1635231600"; 
   d="scan'208";a="226141043"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 14:24:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,313,1635231600"; 
   d="scan'208";a="562817637"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 24 Jan 2022 14:24:10 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nC7kv-000IzD-LI; Mon, 24 Jan 2022 22:24:09 +0000
Date:   Tue, 25 Jan 2022 06:23:13 +0800
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
Subject: Re: [PATCH v4 6/9] arm64: rethook: Add arm64 rethook implementation
Message-ID: <202201250403.5YnZvb4K-lkp@intel.com>
References: <164304063053.1680787.17728029474747738793.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164304063053.1680787.17728029474747738793.stgit@devnote2>
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
config: arm64-randconfig-r033-20220124 (https://download.01.org/0day-ci/archive/20220125/202201250403.5YnZvb4K-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/981b0378461c912ba2d7b10412dd6fe21c316055
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Masami-Hiramatsu/fprobe-Introduce-fprobe-function-entry-exit-probe/20220125-001253
        git checkout 981b0378461c912ba2d7b10412dd6fe21c316055
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/kernel/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/arm64/kernel/stacktrace.c: In function 'unwind_frame':
>> arch/arm64/kernel/stacktrace.c:141:73: error: 'struct stackframe' has no member named 'kr_cur'
     141 |                 frame->pc = rethook_find_ret_addr(tsk, frame->fp, &frame->kr_cur);
         |                                                                         ^~


vim +141 arch/arm64/kernel/stacktrace.c

    59	
    60	/*
    61	 * Unwind from one frame record (A) to the next frame record (B).
    62	 *
    63	 * We terminate early if the location of B indicates a malformed chain of frame
    64	 * records (e.g. a cycle), determined based on the location and fp value of A
    65	 * and the location (but not the fp value) of B.
    66	 */
    67	int notrace unwind_frame(struct task_struct *tsk, struct stackframe *frame)
    68	{
    69		unsigned long fp = frame->fp;
    70		struct stack_info info;
    71	
    72		if (!tsk)
    73			tsk = current;
    74	
    75		/* Final frame; nothing to unwind */
    76		if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
    77			return -ENOENT;
    78	
    79		if (fp & 0x7)
    80			return -EINVAL;
    81	
    82		if (!on_accessible_stack(tsk, fp, 16, &info))
    83			return -EINVAL;
    84	
    85		if (test_bit(info.type, frame->stacks_done))
    86			return -EINVAL;
    87	
    88		/*
    89		 * As stacks grow downward, any valid record on the same stack must be
    90		 * at a strictly higher address than the prior record.
    91		 *
    92		 * Stacks can nest in several valid orders, e.g.
    93		 *
    94		 * TASK -> IRQ -> OVERFLOW -> SDEI_NORMAL
    95		 * TASK -> SDEI_NORMAL -> SDEI_CRITICAL -> OVERFLOW
    96		 *
    97		 * ... but the nesting itself is strict. Once we transition from one
    98		 * stack to another, it's never valid to unwind back to that first
    99		 * stack.
   100		 */
   101		if (info.type == frame->prev_type) {
   102			if (fp <= frame->prev_fp)
   103				return -EINVAL;
   104		} else {
   105			set_bit(frame->prev_type, frame->stacks_done);
   106		}
   107	
   108		/*
   109		 * Record this frame record's values and location. The prev_fp and
   110		 * prev_type are only meaningful to the next unwind_frame() invocation.
   111		 */
   112		frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
   113		frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 8));
   114		frame->prev_fp = fp;
   115		frame->prev_type = info.type;
   116	
   117		frame->pc = ptrauth_strip_insn_pac(frame->pc);
   118	
   119	#ifdef CONFIG_FUNCTION_GRAPH_TRACER
   120		if (tsk->ret_stack &&
   121			(frame->pc == (unsigned long)return_to_handler)) {
   122			unsigned long orig_pc;
   123			/*
   124			 * This is a case where function graph tracer has
   125			 * modified a return address (LR) in a stack frame
   126			 * to hook a function return.
   127			 * So replace it to an original value.
   128			 */
   129			orig_pc = ftrace_graph_ret_addr(tsk, NULL, frame->pc,
   130							(void *)frame->fp);
   131			if (WARN_ON_ONCE(frame->pc == orig_pc))
   132				return -EINVAL;
   133			frame->pc = orig_pc;
   134		}
   135	#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
   136	#ifdef CONFIG_KRETPROBES
   137		if (is_kretprobe_trampoline(frame->pc))
   138			frame->pc = kretprobe_find_ret_addr(tsk, (void *)frame->fp, &frame->kr_cur);
   139	#endif
   140		if (IS_ENABLED(CONFIG_RETHOOK) && is_rethook_trampoline(frame->pc))
 > 141			frame->pc = rethook_find_ret_addr(tsk, frame->fp, &frame->kr_cur);
   142	
   143		return 0;
   144	}
   145	NOKPROBE_SYMBOL(unwind_frame);
   146	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
