Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37D9466016
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 10:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345572AbhLBJHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 04:07:36 -0500
Received: from mga03.intel.com ([134.134.136.65]:47444 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345465AbhLBJHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 04:07:35 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="236606094"
X-IronPort-AV: E=Sophos;i="5.87,281,1631602800"; 
   d="scan'208";a="236606094"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 01:04:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,281,1631602800"; 
   d="scan'208";a="609909625"
Received: from lkp-server02.sh.intel.com (HELO 9e1e9f9b3bcb) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 02 Dec 2021 01:04:11 -0800
Received: from kbuild by 9e1e9f9b3bcb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1msi0g-000G6x-Gw; Thu, 02 Dec 2021 09:04:10 +0000
Date:   Thu, 2 Dec 2021 17:03:42 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 02/19] lib: add tests for reference tracker
Message-ID: <202112021600.8HBrwOX4-lkp@intel.com>
References: <20211202032139.3156411-3-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202032139.3156411-3-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211202-112353
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 8057cbb8335cf6d419866737504473833e1d128a
config: sparc-buildonly-randconfig-r005-20211202 (https://download.01.org/0day-ci/archive/20211202/202112021600.8HBrwOX4-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/5da0cdb1848fae9fb2d9d749bb94e568e2493df8
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-add-preliminary-netdev-refcount-tracking/20211202-112353
        git checkout 5da0cdb1848fae9fb2d9d749bb94e568e2493df8
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=sparc SHELL=/bin/bash arch/sparc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/sparc/kernel/stacktrace.c:11:
   arch/sparc/kernel/kstack.h: In function 'kstack_valid':
>> arch/sparc/kernel/kstack.h:23:13: error: 'hardirq_stack' undeclared (first use in this function)
      23 |         if (hardirq_stack[tp->cpu]) {
         |             ^~~~~~~~~~~~~
   arch/sparc/kernel/kstack.h:23:13: note: each undeclared identifier is reported only once for each function it appears in
>> arch/sparc/kernel/kstack.h:28:40: error: 'softirq_stack' undeclared (first use in this function)
      28 |                 base = (unsigned long) softirq_stack[tp->cpu];
         |                                        ^~~~~~~~~~~~~
   arch/sparc/kernel/kstack.h: In function 'kstack_is_trap_frame':
   arch/sparc/kernel/kstack.h:46:13: error: 'hardirq_stack' undeclared (first use in this function)
      46 |         if (hardirq_stack[tp->cpu]) {
         |             ^~~~~~~~~~~~~
   arch/sparc/kernel/kstack.h:51:40: error: 'softirq_stack' undeclared (first use in this function)
      51 |                 base = (unsigned long) softirq_stack[tp->cpu];
         |                                        ^~~~~~~~~~~~~
>> arch/sparc/kernel/kstack.h:59:18: error: 'struct pt_regs' has no member named 'magic'
      59 |         if ((regs->magic & ~0x1ff) == PT_REGS_MAGIC)
         |                  ^~
>> arch/sparc/kernel/kstack.h:59:39: error: 'PT_REGS_MAGIC' undeclared (first use in this function); did you mean 'PT_V9_MAGIC'?
      59 |         if ((regs->magic & ~0x1ff) == PT_REGS_MAGIC)
         |                                       ^~~~~~~~~~~~~
         |                                       PT_V9_MAGIC
   arch/sparc/kernel/kstack.h: In function 'set_hardirq_stack':
   arch/sparc/kernel/kstack.h:67:30: error: 'hardirq_stack' undeclared (first use in this function); did you mean 'set_hardirq_stack'?
      67 |         void *orig_sp, *sp = hardirq_stack[smp_processor_id()];
         |                              ^~~~~~~~~~~~~
         |                              set_hardirq_stack
   arch/sparc/kernel/stacktrace.c: In function '__save_stack_trace':
>> arch/sparc/kernel/stacktrace.c:46:35: error: 'struct pt_regs' has no member named 'tstate'
      46 |                         if (!(regs->tstate & TSTATE_PRIV))
         |                                   ^~
>> arch/sparc/kernel/stacktrace.c:46:46: error: 'TSTATE_PRIV' undeclared (first use in this function)
      46 |                         if (!(regs->tstate & TSTATE_PRIV))
         |                                              ^~~~~~~~~~~
>> arch/sparc/kernel/stacktrace.c:48:36: error: 'struct pt_regs' has no member named 'tpc'; did you mean 'pc'?
      48 |                         pc = regs->tpc;
         |                                    ^~~
         |                                    pc

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for STACKTRACE
   Depends on STACKTRACE_SUPPORT
   Selected by
   - STACKDEPOT


vim +/hardirq_stack +23 arch/sparc/kernel/kstack.h

4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12   9  
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  10  /* SP must be STACK_BIAS adjusted already.  */
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  11  static inline bool kstack_valid(struct thread_info *tp, unsigned long sp)
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  12  {
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  13  	unsigned long base = (unsigned long) tp;
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  14  
232486e1e9f348 arch/sparc/kernel/kstack.h   David S. Miller 2010-02-12  15  	/* Stack pointer must be 16-byte aligned.  */
232486e1e9f348 arch/sparc/kernel/kstack.h   David S. Miller 2010-02-12  16  	if (sp & (16UL - 1))
232486e1e9f348 arch/sparc/kernel/kstack.h   David S. Miller 2010-02-12  17  		return false;
232486e1e9f348 arch/sparc/kernel/kstack.h   David S. Miller 2010-02-12  18  
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  19  	if (sp >= (base + sizeof(struct thread_info)) &&
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  20  	    sp <= (base + THREAD_SIZE - sizeof(struct sparc_stackf)))
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  21  		return true;
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  22  
6f63e781eaf6a7 arch/sparc64/kernel/kstack.h David S. Miller 2008-08-13 @23  	if (hardirq_stack[tp->cpu]) {
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  24  		base = (unsigned long) hardirq_stack[tp->cpu];
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  25  		if (sp >= base &&
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  26  		    sp <= (base + THREAD_SIZE - sizeof(struct sparc_stackf)))
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  27  			return true;
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12 @28  		base = (unsigned long) softirq_stack[tp->cpu];
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  29  		if (sp >= base &&
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  30  		    sp <= (base + THREAD_SIZE - sizeof(struct sparc_stackf)))
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  31  			return true;
6f63e781eaf6a7 arch/sparc64/kernel/kstack.h David S. Miller 2008-08-13  32  	}
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  33  	return false;
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  34  }
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  35  
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  36  /* Does "regs" point to a valid pt_regs trap frame?  */
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  37  static inline bool kstack_is_trap_frame(struct thread_info *tp, struct pt_regs *regs)
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  38  {
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  39  	unsigned long base = (unsigned long) tp;
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  40  	unsigned long addr = (unsigned long) regs;
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  41  
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  42  	if (addr >= base &&
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  43  	    addr <= (base + THREAD_SIZE - sizeof(*regs)))
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  44  		goto check_magic;
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  45  
6f63e781eaf6a7 arch/sparc64/kernel/kstack.h David S. Miller 2008-08-13  46  	if (hardirq_stack[tp->cpu]) {
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  47  		base = (unsigned long) hardirq_stack[tp->cpu];
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  48  		if (addr >= base &&
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  49  		    addr <= (base + THREAD_SIZE - sizeof(*regs)))
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  50  			goto check_magic;
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  51  		base = (unsigned long) softirq_stack[tp->cpu];
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  52  		if (addr >= base &&
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  53  		    addr <= (base + THREAD_SIZE - sizeof(*regs)))
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  54  			goto check_magic;
6f63e781eaf6a7 arch/sparc64/kernel/kstack.h David S. Miller 2008-08-13  55  	}
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  56  	return false;
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  57  
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  58  check_magic:
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12 @59  	if ((regs->magic & ~0x1ff) == PT_REGS_MAGIC)
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  60  		return true;
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  61  	return false;
4f70f7a91bffdc arch/sparc64/kernel/kstack.h David S. Miller 2008-08-12  62  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
