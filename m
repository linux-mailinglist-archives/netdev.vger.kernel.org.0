Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5456850C8C5
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 11:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbiDWJnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 05:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiDWJnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 05:43:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603817EA26;
        Sat, 23 Apr 2022 02:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650706817; x=1682242817;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SECSW/KfTCFzvgQa0o1UPp5w19OimdSmXQzt+n2rFnA=;
  b=SXtVpqtftNvP88PAXX4RLHfSZc+i1VfmrI7FA2ouWALZhVgZpYmdWiFF
   tDdDFDZuHhVAYFfMuTnpL8PUByafvXrUNCAeBPk11rvN/DdLQ6PXkREKw
   JYR6BGxzCv5gmY1PANT3dJrnBCBiQgf53t+xUn0frFIbVU2agQOdKYW3p
   pi7220XK4FbAI0HQEq7RL8Fx4AYEDcLHuF/jbJVWoMT3cQlgktG+XA9L+
   3iYu61c645aCSdHIJ2zXIYfPbTr9CIfNzQ1fDDbyOkDUzq0eusM/AMeit
   UC+ItCoBNLE3pWsP0x/tR1DPb4UD7voPCx5HGwX5utkCPGyK8kpDoJSaF
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="351323762"
X-IronPort-AV: E=Sophos;i="5.90,284,1643702400"; 
   d="scan'208";a="351323762"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 02:40:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,284,1643702400"; 
   d="scan'208";a="627330466"
Received: from lkp-server01.sh.intel.com (HELO dd58949a6e39) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 23 Apr 2022 02:40:14 -0700
Received: from kbuild by dd58949a6e39 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1niCFR-00007m-V3;
        Sat, 23 Apr 2022 09:40:13 +0000
Date:   Sat, 23 Apr 2022 17:39:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vasily Averin <vvs@openvz.org>, Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeelb@google.com>
Cc:     kbuild-all@lists.01.org, kernel@openvz.org,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: set proper memcg for net_init hooks allocations
Message-ID: <202204231724.0eEAtmxV-lkp@intel.com>
References: <6f38e02b-9af3-4dcf-9000-1118a04b13c7@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f38e02b-9af3-4dcf-9000-1118a04b13c7@openvz.org>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vasily,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.18-rc3 next-20220422]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Vasily-Averin/net-set-proper-memcg-for-net_init-hooks-allocations/20220423-160759
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git c00c5e1d157bec0ef0b0b59aa5482eb8dc7e8e49
config: mips-buildonly-randconfig-r006-20220423 (https://download.01.org/0day-ci/archive/20220423/202204231724.0eEAtmxV-lkp@intel.com/config)
compiler: mips64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/3b379e5391e36e13b9f36305aa6d233fb03d4e58
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vasily-Averin/net-set-proper-memcg-for-net_init-hooks-allocations/20220423-160759
        git checkout 3b379e5391e36e13b9f36305aa6d233fb03d4e58
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross W=1 O=build_dir ARCH=mips prepare

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/swap.h:9,
                    from include/linux/suspend.h:5,
                    from arch/mips/kernel/asm-offsets.c:17:
   include/linux/memcontrol.h: In function 'get_mem_cgroup_from_kmem':
>> include/linux/memcontrol.h:1773:28: error: implicit declaration of function 'css_tryget'; did you mean 'wb_tryget'? [-Werror=implicit-function-declaration]
    1773 |         } while (memcg && !css_tryget(&memcg->css));
         |                            ^~~~~~~~~~
         |                            wb_tryget
>> include/linux/memcontrol.h:1773:45: error: invalid use of undefined type 'struct mem_cgroup'
    1773 |         } while (memcg && !css_tryget(&memcg->css));
         |                                             ^~
   arch/mips/kernel/asm-offsets.c: At top level:
   arch/mips/kernel/asm-offsets.c:26:6: warning: no previous prototype for 'output_ptreg_defines' [-Wmissing-prototypes]
      26 | void output_ptreg_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:78:6: warning: no previous prototype for 'output_task_defines' [-Wmissing-prototypes]
      78 | void output_task_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:92:6: warning: no previous prototype for 'output_thread_info_defines' [-Wmissing-prototypes]
      92 | void output_thread_info_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:108:6: warning: no previous prototype for 'output_thread_defines' [-Wmissing-prototypes]
     108 | void output_thread_defines(void)
         |      ^~~~~~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:179:6: warning: no previous prototype for 'output_mm_defines' [-Wmissing-prototypes]
     179 | void output_mm_defines(void)
         |      ^~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:240:6: warning: no previous prototype for 'output_sc_defines' [-Wmissing-prototypes]
     240 | void output_sc_defines(void)
         |      ^~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:253:6: warning: no previous prototype for 'output_signal_defined' [-Wmissing-prototypes]
     253 | void output_signal_defined(void)
         |      ^~~~~~~~~~~~~~~~~~~~~
   arch/mips/kernel/asm-offsets.c:332:6: warning: no previous prototype for 'output_pm_defines' [-Wmissing-prototypes]
     332 | void output_pm_defines(void)
         |      ^~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
   make[2]: *** [scripts/Makefile.build:120: arch/mips/kernel/asm-offsets.s] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [Makefile:1194: prepare0] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:219: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +1773 include/linux/memcontrol.h

  1765	
  1766	static inline struct mem_cgroup *get_mem_cgroup_from_kmem(void *p)
  1767	{
  1768		struct mem_cgroup *memcg;
  1769	
  1770		rcu_read_lock();
  1771		do {
  1772			memcg = mem_cgroup_from_obj(p);
> 1773		} while (memcg && !css_tryget(&memcg->css));

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
