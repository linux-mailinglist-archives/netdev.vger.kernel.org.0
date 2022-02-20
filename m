Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DA34BD28D
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 00:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243234AbiBTW4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 17:56:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbiBTW4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 17:56:22 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5A2517FF;
        Sun, 20 Feb 2022 14:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645397760; x=1676933760;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sdYAtXZV6VS6Py+w36OsucDIDtzFkCYCuiuihXMs5lI=;
  b=k8fy1iNW58IDEiltwwMNt/DkeRUePg9uAiBPZmYKpcRXXQRs1UMA3ofl
   lbIAfGKp3MHXw1kUAxu7nyq1+9xL2GDinznVvwKlnQgUlomC85C0Ubv+T
   KxLPKRkw2ejwotBe8Jf3rzBkc9rj8IU3pF3uRio8oaaJ8rxxjPdoufUzY
   REXlMNrcP4uuR8oIaqnjEj+1sj6a9rCQ9boTxPBbcGuLHgwfXHhiqf/cd
   8AxxSTS8iuXIs9VpppzoSObzs+FncDcjOiU8XCA0bnoKL8C+Lx3IQPodN
   KWi79vCYuYbn6fNKIwICVL0+HTI7La7h+Td+I00VYVDK15D561GGFFXIl
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="251590340"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="251590340"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 14:56:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="706044068"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 20 Feb 2022 14:55:56 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nLv7U-0000yo-4e; Sun, 20 Feb 2022 22:55:56 +0000
Date:   Mon, 21 Feb 2022 06:55:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 10/15] bpf: Wire up freeing of referenced
 PTR_TO_BTF_ID in map
Message-ID: <202202210651.wyTgHcwt-lkp@intel.com>
References: <20220220134813.3411982-11-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220220134813.3411982-11-memxor@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kumar,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on next-20220217]
[cannot apply to bpf-next/master bpf/master linus/master v5.17-rc4 v5.17-rc3 v5.17-rc2 v5.17-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Kumar-Kartikeya-Dwivedi/Introduce-typed-pointer-support-in-BPF-maps/20220220-215105
base:    3c30cf91b5ecc7272b3d2942ae0505dd8320b81c
config: mips-randconfig-r012-20220220 (https://download.01.org/0day-ci/archive/20220221/202202210651.wyTgHcwt-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mips-linux-gnu
        # https://github.com/0day-ci/linux/commit/09a47522ec608218eb6aabd5011316d78ad245e0
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Kumar-Kartikeya-Dwivedi/Introduce-typed-pointer-support-in-BPF-maps/20220220-215105
        git checkout 09a47522ec608218eb6aabd5011316d78ad245e0
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash kernel/bpf/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from kernel/bpf/syscall.c:4:
   In file included from include/linux/bpf.h:9:
   In file included from include/linux/workqueue.h:9:
   In file included from include/linux/timer.h:6:
   In file included from include/linux/ktime.h:24:
   In file included from include/linux/time.h:60:
   In file included from include/linux/time32.h:13:
   In file included from include/linux/timex.h:65:
   In file included from arch/mips/include/asm/timex.h:19:
   In file included from arch/mips/include/asm/cpu-type.h:12:
   In file included from include/linux/smp.h:13:
   In file included from include/linux/cpumask.h:13:
   In file included from include/linux/atomic.h:7:
   In file included from arch/mips/include/asm/atomic.h:23:
>> arch/mips/include/asm/cmpxchg.h:83:11: error: call to __xchg_called_with_bad_pointer declared with 'error' attribute: Bad argument size for xchg
                           return __xchg_called_with_bad_pointer();
                                  ^
   1 error generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for OMAP_GPMC
   Depends on MEMORY && OF_ADDRESS
   Selected by
   - MTD_NAND_OMAP2 && MTD && MTD_RAW_NAND && (ARCH_OMAP2PLUS || ARCH_KEYSTONE || ARCH_K3 || COMPILE_TEST && HAS_IOMEM


vim +/error +83 arch/mips/include/asm/cmpxchg.h

5154f3b4194910 Paul Burton         2017-06-09  66  
b70eb30056dc84 Paul Burton         2017-06-09  67  extern unsigned long __xchg_small(volatile void *ptr, unsigned long val,
b70eb30056dc84 Paul Burton         2017-06-09  68  				  unsigned int size);
b70eb30056dc84 Paul Burton         2017-06-09  69  
46f1619500d022 Thomas Bogendoerfer 2019-10-09  70  static __always_inline
46f1619500d022 Thomas Bogendoerfer 2019-10-09  71  unsigned long __xchg(volatile void *ptr, unsigned long x, int size)
b81947c646bfef David Howells       2012-03-28  72  {
b81947c646bfef David Howells       2012-03-28  73  	switch (size) {
b70eb30056dc84 Paul Burton         2017-06-09  74  	case 1:
b70eb30056dc84 Paul Burton         2017-06-09  75  	case 2:
b70eb30056dc84 Paul Burton         2017-06-09  76  		return __xchg_small(ptr, x, size);
b70eb30056dc84 Paul Burton         2017-06-09  77  
b81947c646bfef David Howells       2012-03-28  78  	case 4:
62c6081dca75d6 Paul Burton         2017-06-09  79  		return __xchg_asm("ll", "sc", (volatile u32 *)ptr, x);
62c6081dca75d6 Paul Burton         2017-06-09  80  
b81947c646bfef David Howells       2012-03-28  81  	case 8:
62c6081dca75d6 Paul Burton         2017-06-09  82  		if (!IS_ENABLED(CONFIG_64BIT))
62c6081dca75d6 Paul Burton         2017-06-09 @83  			return __xchg_called_with_bad_pointer();
62c6081dca75d6 Paul Burton         2017-06-09  84  
62c6081dca75d6 Paul Burton         2017-06-09  85  		return __xchg_asm("lld", "scd", (volatile u64 *)ptr, x);
62c6081dca75d6 Paul Burton         2017-06-09  86  
d15dc68c1143e2 Paul Burton         2017-06-09  87  	default:
d15dc68c1143e2 Paul Burton         2017-06-09  88  		return __xchg_called_with_bad_pointer();
b81947c646bfef David Howells       2012-03-28  89  	}
b81947c646bfef David Howells       2012-03-28  90  }
b81947c646bfef David Howells       2012-03-28  91  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
