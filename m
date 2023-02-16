Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D65699530
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 14:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjBPNHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 08:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjBPNHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 08:07:36 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9FF6589
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676552855; x=1708088855;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=q/Cg2/SiFo6xuspA4OLUhIMj4EfH6A4tSLWVFEg/MB0=;
  b=AoCe6e8/9f7r0F7SFATVg8hmV8XjoDv1uXWF4jjUKn3pjL0MKqKQA54d
   Plhy3ZEUdfX3NBBUVXUFBPgqgIltW3x+TerV4uQfeG3EoDvVbkd+Jowt8
   R1qibHGGyz8MsH0i9q6JNqyh/OQtYcc9IJx34gJDktPHtTvudIiu7RPTv
   vb8lktowAhfRBgVQGebTuDDE9CwzCQv7ZpwwlA6NQUSsaLvbtx4ji4utv
   FsXKiy9+Zqcvn13lQfX1AtqZR6qx7ozc7cpy4JqJ0s72jFqSo/2dJFOaH
   Tf7pcMsei7MO+duqHw/FAUpgfB+yr5yIWGmJRj1BzmuhcoIzZPmiBtWdA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="333881438"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="333881438"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 05:07:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="647672287"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="647672287"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 16 Feb 2023 05:07:27 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pSdyw-000AGX-2N;
        Thu, 16 Feb 2023 13:07:26 +0000
Date:   Thu, 16 Feb 2023 21:06:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH net-next 1/2] net: make default_rps_mask a per netns
 attribute
Message-ID: <202302162052.Pm80BWt6-lkp@intel.com>
References: <35bde791a3fd775f0a027bba04a549233b705494.1676484775.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35bde791a3fd775f0a027bba04a549233b705494.1676484775.git.pabeni@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Abeni/net-make-default_rps_mask-a-per-netns-attribute/20230216-023751
patch link:    https://lore.kernel.org/r/35bde791a3fd775f0a027bba04a549233b705494.1676484775.git.pabeni%40redhat.com
patch subject: [PATCH net-next 1/2] net: make default_rps_mask a per netns attribute
config: parisc-defconfig (https://download.01.org/0day-ci/archive/20230216/202302162052.Pm80BWt6-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/7b0e8effb3c7ac131c0da6e37cc33322ff22e2e3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Paolo-Abeni/net-make-default_rps_mask-a-per-netns-attribute/20230216-023751
        git checkout 7b0e8effb3c7ac131c0da6e37cc33322ff22e2e3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=parisc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=parisc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302162052.Pm80BWt6-lkp@intel.com/

All errors (new ones prefixed by >>):

   net/core/sysctl_net_core.c: In function 'rps_default_mask_cow_alloc':
>> net/core/sysctl_net_core.c:85:33: error: passing argument 1 of 'zalloc_cpumask_var' from incompatible pointer type [-Werror=incompatible-pointer-types]
      85 |         if (!zalloc_cpumask_var(&rps_default_mask, GFP_KERNEL))
         |                                 ^~~~~~~~~~~~~~~~~
         |                                 |
         |                                 struct cpumask **
   In file included from include/linux/smp.h:13,
                    from include/linux/lockdep.h:14,
                    from include/linux/spinlock.h:63,
                    from include/linux/debugobjects.h:6,
                    from include/linux/timer.h:8,
                    from include/linux/workqueue.h:9,
                    from include/linux/bpf.h:10,
                    from include/linux/filter.h:9,
                    from net/core/sysctl_net_core.c:9:
   include/linux/cpumask.h:897:54: note: expected 'struct cpumask (*)[1]' but argument is of type 'struct cpumask **'
     897 | static inline bool zalloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
         |                                       ~~~~~~~~~~~~~~~^~~~
   cc1: some warnings being treated as errors


vim +/zalloc_cpumask_var +85 net/core/sysctl_net_core.c

    77	
    78	static struct cpumask *rps_default_mask_cow_alloc(struct net *net)
    79	{
    80		struct cpumask *rps_default_mask;
    81	
    82		if (net->core.rps_default_mask)
    83			return net->core.rps_default_mask;
    84	
  > 85		if (!zalloc_cpumask_var(&rps_default_mask, GFP_KERNEL))
    86			return NULL;
    87	
    88		/* pairs with READ_ONCE in rx_queue_default_mask() */
    89		WRITE_ONCE(net->core.rps_default_mask, rps_default_mask);
    90		return rps_default_mask;
    91	}
    92	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
