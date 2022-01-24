Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DC3499EB4
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 00:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1587833AbiAXWmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 17:42:38 -0500
Received: from mga05.intel.com ([192.55.52.43]:61240 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1583831AbiAXWdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 17:33:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643063580; x=1674599580;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Fxf9gxg/X1RfJSgX8EYRn9ZdFJkbiAutWxK6z4YLqo8=;
  b=VVJ/lUY+K5Zv2ppMm2ibdlaX2+/F3Dba+gzfvUKMqZkWSDD/1Syds6Y3
   31r5uDvcW7e7fRECAcxGGGudXwOf//269HCNmoT3F3MivmyRi9dWmTOiD
   68Snp1oXmLXGHMwm8q/YtiEuwCq+MFoFnVhsTDMjGxV0f4Kr30L+IPn8h
   ciARJTk+hrtpXylzaPpq9TTxxxHFHqs7OuoeAcLogK6zL/AmIiWFVVOcc
   0W33bsafNN1Rs3bfmz6+3H4TLICfpE62dFoDXy8yjMIIOdAy+XByIzeqf
   60WxCFqTvBgq6CgGRlqvXAHjKylLnBzfSjNwM54uEkoGZREoJLTCgz4yY
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="332516879"
X-IronPort-AV: E=Sophos;i="5.88,313,1635231600"; 
   d="scan'208";a="332516879"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 14:24:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,313,1635231600"; 
   d="scan'208";a="695588184"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 24 Jan 2022 14:24:10 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nC7kv-000Iz8-KA; Mon, 24 Jan 2022 22:24:09 +0000
Date:   Tue, 25 Jan 2022 06:23:33 +0800
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
Subject: Re: [PATCH v4 4/9] rethook: x86: Add rethook x86 implementation
Message-ID: <202201250509.MSbKNePn-lkp@intel.com>
References: <164304060913.1680787.1167309209346264268.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164304060913.1680787.1167309209346264268.stgit@devnote2>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Masami,

I love your patch! Yet something to improve:

[auto build test ERROR on rostedt-trace/for-next]
[also build test ERROR on tip/x86/core linus/master v5.17-rc1 next-20220124]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Masami-Hiramatsu/fprobe-Introduce-fprobe-function-entry-exit-probe/20220125-001253
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git for-next
config: i386-tinyconfig (https://download.01.org/0day-ci/archive/20220125/202201250509.MSbKNePn-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/6366c7f830e71242dd9538fbdb09acdccea6e786
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Masami-Hiramatsu/fprobe-Introduce-fprobe-function-entry-exit-probe/20220125-001253
        git checkout 6366c7f830e71242dd9538fbdb09acdccea6e786
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kernel/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/x86/kernel/process.c:48:
   arch/x86/include/asm/unwind.h: In function 'unwind_recover_kretprobe':
>> arch/x86/include/asm/unwind.h:113:17: error: 'struct unwind_state' has no member named 'kr_cur'
     113 |           &state->kr_cur);
         |                 ^~
   arch/x86/kernel/process.c: At top level:
   arch/x86/kernel/process.c:887:13: warning: no previous prototype for 'arch_post_acpi_subsys_init' [-Wmissing-prototypes]
     887 | void __init arch_post_acpi_subsys_init(void)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
--
   In file included from arch/x86/kernel/unwind_guess.c:7:
   arch/x86/include/asm/unwind.h: In function 'unwind_recover_kretprobe':
>> arch/x86/include/asm/unwind.h:113:17: error: 'struct unwind_state' has no member named 'kr_cur'
     113 |           &state->kr_cur);
         |                 ^~


vim +113 arch/x86/include/asm/unwind.h

   106	
   107	static inline
   108	unsigned long unwind_recover_kretprobe(struct unwind_state *state,
   109					       unsigned long addr, unsigned long *addr_p)
   110	{
   111		if (IS_ENABLED(CONFIG_RETHOOK) && is_rethook_trampoline(addr))
   112			return rethook_find_ret_addr(state->task, (unsigned long)addr_p,
 > 113						     &state->kr_cur);
   114	#ifdef CONFIG_KRETPROBES
   115		return is_kretprobe_trampoline(addr) ?
   116			kretprobe_find_ret_addr(state->task, addr_p, &state->kr_cur) :
   117			addr;
   118	#else
   119		return addr;
   120	#endif
   121	}
   122	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
