Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D354AA6FC
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 06:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243384AbiBEFxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 00:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235459AbiBEFxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 00:53:20 -0500
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 04 Feb 2022 21:53:19 PST
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A400C061346
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 21:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644040399; x=1675576399;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iX48ViLuOhFLYHT7tRd5qzB9H0kvgo+NOZpk8GHpT3A=;
  b=N4G6HhUM7Hb0Esl1bphWBW+RKfBj+UI2XfHV371IaEXAXv9e7+1aWjlu
   vCCew+eTOfCbSGS4B7e3IX24kRotgSYl82EyCvGv2JkuhyiRZNdQbf7KD
   adRU4h/TOMyt6fGt4aVIAoCrnNHwkxGZNDmxTRfdI3aHMiSfET3n0f/xq
   WgGsRSIFCZhRY0RDpfQ4LBVOzL3Bt4JITKgLKmpY3Eqt9G4awZy1O+8sa
   D4n00fDgAdUJAcCuyISwwzGxcSHsFS1fxKXR/1dmeDclwHndz3o7pTi9+
   hVg4wCyzzuwbTIb4U/LKZtYTrqAbUi2cMEd39/U/+ARvL0X+m50OgZxkS
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="311790663"
X-IronPort-AV: E=Sophos;i="5.88,345,1635231600"; 
   d="scan'208";a="311790663"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 21:52:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,345,1635231600"; 
   d="scan'208";a="600427572"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 04 Feb 2022 21:52:13 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nGDzZ-000Yeu-8s; Sat, 05 Feb 2022 05:52:13 +0000
Date:   Sat, 5 Feb 2022 13:52:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: initialize init_net earlier
Message-ID: <202202051344.7VoLsgix-lkp@intel.com>
References: <20220204233809.3082403-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204233809.3082403-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/net-initialize-init_net-earlier/20220205-073957
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git c531adaf884d313df2729ca94228317a52e46b83
config: arm-randconfig-r031-20220131 (https://download.01.org/0day-ci/archive/20220205/202202051344.7VoLsgix-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project a73e4ce6a59b01f0e37037761c1e6889d539d233)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/0day-ci/linux/commit/0d2a51961bd19173f1d7cfa779b9cf82c48e4499
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-initialize-init_net-earlier/20220205-073957
        git checkout 0d2a51961bd19173f1d7cfa779b9cf82c48e4499
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from kernel/events/core.c:46:
   In file included from include/linux/filter.h:20:
   In file included from include/linux/if_vlan.h:10:
   In file included from include/linux/netdevice.h:37:
>> include/net/net_namespace.h:519:34: error: non-void function does not return a value [-Werror,-Wreturn-type]
   static inline net_ns_init(void) {}
                                    ^
   1 error generated.
--
   In file included from init/main.c:102:
>> include/net/net_namespace.h:519:34: error: non-void function does not return a value [-Werror,-Wreturn-type]
   static inline net_ns_init(void) {}
                                    ^
   init/main.c:769:20: warning: no previous prototype for function 'arch_post_acpi_subsys_init' [-Wmissing-prototypes]
   void __init __weak arch_post_acpi_subsys_init(void) { }
                      ^
   init/main.c:769:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void __init __weak arch_post_acpi_subsys_init(void) { }
   ^
   static 
   init/main.c:781:20: warning: no previous prototype for function 'mem_encrypt_init' [-Wmissing-prototypes]
   void __init __weak mem_encrypt_init(void) { }
                      ^
   init/main.c:781:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void __init __weak mem_encrypt_init(void) { }
   ^
   static 
   init/main.c:783:20: warning: no previous prototype for function 'poking_init' [-Wmissing-prototypes]
   void __init __weak poking_init(void) { }
                      ^
   init/main.c:783:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void __init __weak poking_init(void) { }
   ^
   static 
   3 warnings and 1 error generated.
--
   kernel/fork.c:162:13: warning: no previous prototype for function 'arch_release_task_struct' [-Wmissing-prototypes]
   void __weak arch_release_task_struct(struct task_struct *tsk)
               ^
   kernel/fork.c:162:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void __weak arch_release_task_struct(struct task_struct *tsk)
   ^
   static 
   kernel/fork.c:764:20: warning: no previous prototype for function 'arch_task_cache_init' [-Wmissing-prototypes]
   void __init __weak arch_task_cache_init(void) { }
                      ^
   kernel/fork.c:764:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void __init __weak arch_task_cache_init(void) { }
   ^
   static 
   kernel/fork.c:859:12: warning: no previous prototype for function 'arch_dup_task_struct' [-Wmissing-prototypes]
   int __weak arch_dup_task_struct(struct task_struct *dst,
              ^
   kernel/fork.c:859:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int __weak arch_dup_task_struct(struct task_struct *dst,
   ^
   static 
   In file included from kernel/fork.c:996:
   In file included from include/linux/init_task.h:18:
>> include/net/net_namespace.h:519:34: error: non-void function does not return a value [-Werror,-Wreturn-type]
   static inline net_ns_init(void) {}
                                    ^
   3 warnings and 1 error generated.
--
   In file included from kernel/kallsyms.c:25:
   In file included from include/linux/filter.h:20:
   In file included from include/linux/if_vlan.h:10:
   In file included from include/linux/netdevice.h:37:
>> include/net/net_namespace.h:519:34: error: non-void function does not return a value [-Werror,-Wreturn-type]
   static inline net_ns_init(void) {}
                                    ^
   kernel/kallsyms.c:587:12: warning: no previous prototype for function 'arch_get_kallsym' [-Wmissing-prototypes]
   int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
              ^
   kernel/kallsyms.c:587:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
   ^
   static 
   1 warning and 1 error generated.
--
   In file included from kernel/sched/core.c:13:
   In file included from kernel/sched/sched.h:49:
   In file included from include/linux/init_task.h:18:
>> include/net/net_namespace.h:519:34: error: non-void function does not return a value [-Werror,-Wreturn-type]
   static inline net_ns_init(void) {}
                                    ^
   kernel/sched/core.c:6401:35: warning: no previous prototype for function 'schedule_user' [-Wmissing-prototypes]
   asmlinkage __visible void __sched schedule_user(void)
                                     ^
   kernel/sched/core.c:6401:22: note: declare 'static' if the function is not intended to be used outside of this translation unit
   asmlinkage __visible void __sched schedule_user(void)
                        ^
                        static 
   1 warning and 1 error generated.
--
   In file included from kernel/sched/fair.c:23:
   In file included from kernel/sched/sched.h:49:
   In file included from include/linux/init_task.h:18:
>> include/net/net_namespace.h:519:34: error: non-void function does not return a value [-Werror,-Wreturn-type]
   static inline net_ns_init(void) {}
                                    ^
   kernel/sched/fair.c:5477:6: warning: no previous prototype for function 'init_cfs_bandwidth' [-Wmissing-prototypes]
   void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
        ^
   kernel/sched/fair.c:5477:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
   ^
   static 
   kernel/sched/fair.c:11703:6: warning: no previous prototype for function 'free_fair_sched_group' [-Wmissing-prototypes]
   void free_fair_sched_group(struct task_group *tg) { }
        ^
   kernel/sched/fair.c:11703:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void free_fair_sched_group(struct task_group *tg) { }
   ^
   static 
   kernel/sched/fair.c:11705:5: warning: no previous prototype for function 'alloc_fair_sched_group' [-Wmissing-prototypes]
   int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
       ^
   kernel/sched/fair.c:11705:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
   ^
   static 
   kernel/sched/fair.c:11710:6: warning: no previous prototype for function 'online_fair_sched_group' [-Wmissing-prototypes]
   void online_fair_sched_group(struct task_group *tg) { }
        ^
   kernel/sched/fair.c:11710:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void online_fair_sched_group(struct task_group *tg) { }
   ^
   static 
   kernel/sched/fair.c:11712:6: warning: no previous prototype for function 'unregister_fair_sched_group' [-Wmissing-prototypes]
   void unregister_fair_sched_group(struct task_group *tg) { }
        ^
   kernel/sched/fair.c:11712:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void unregister_fair_sched_group(struct task_group *tg) { }
   ^
   static 
   5 warnings and 1 error generated.
--
   In file included from kernel/sched/rt.c:6:
   In file included from kernel/sched/sched.h:49:
   In file included from include/linux/init_task.h:18:
>> include/net/net_namespace.h:519:34: error: non-void function does not return a value [-Werror,-Wreturn-type]
   static inline net_ns_init(void) {}
                                    ^
   kernel/sched/rt.c:262:6: warning: no previous prototype for function 'unregister_rt_sched_group' [-Wmissing-prototypes]
   void unregister_rt_sched_group(struct task_group *tg) { }
        ^
   kernel/sched/rt.c:262:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void unregister_rt_sched_group(struct task_group *tg) { }
   ^
   static 
   kernel/sched/rt.c:264:6: warning: no previous prototype for function 'free_rt_sched_group' [-Wmissing-prototypes]
   void free_rt_sched_group(struct task_group *tg) { }
        ^
   kernel/sched/rt.c:264:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void free_rt_sched_group(struct task_group *tg) { }
   ^
   static 
   kernel/sched/rt.c:266:5: warning: no previous prototype for function 'alloc_rt_sched_group' [-Wmissing-prototypes]
   int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
       ^
   kernel/sched/rt.c:266:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
   ^
   static 
   kernel/sched/rt.c:680:6: warning: no previous prototype for function 'sched_rt_bandwidth_account' [-Wmissing-prototypes]
   bool sched_rt_bandwidth_account(struct rt_rq *rt_rq)
        ^
   kernel/sched/rt.c:680:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   bool sched_rt_bandwidth_account(struct rt_rq *rt_rq)
   ^
   static 
   4 warnings and 1 error generated.


vim +519 include/net/net_namespace.h

   515	
   516	#ifdef CONFIG_NET
   517	void net_ns_init(void);
   518	#else
 > 519	static inline net_ns_init(void) {}
   520	#endif
   521	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
