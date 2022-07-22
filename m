Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4979257D7A8
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 02:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbiGVAWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 20:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiGVAWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 20:22:09 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3E92E9D8;
        Thu, 21 Jul 2022 17:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658449328; x=1689985328;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mQ0pC712+OzYYGrUvJ+td313D0F3ym/rOgekLIDwVLs=;
  b=a1/pje3LeQOuBQ13LJjjQ/HyBC5nY9FpnWUIkEZUrGlqI45jtzC2w7RZ
   WGYaIDOaNbJkrk3GRF/cVLrNSs7NLjAYUSIDfzzPIzgB7d/aCV0g5l+md
   HT+grGHApvRebpamf1DrSPZtseNKSm5qLN8NqzPFB/HhFO9RLTJvK6wJV
   UYrEprZj+B8vDwDI8L7RWO02wO64XYlJwksacSXgnNWkw82AWjhuNORo5
   5felqfFq7jYncsqDAdQ6ntr2QqhVJL6asY92liUq8YY/jKciNRUdc7xYl
   TFD90+79UP6BVxy+7kLZnsP+ss0zR4gn+1V0h8gkY26Trn6Tx9iQs1r5W
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="351197316"
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="351197316"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 17:22:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,184,1654585200"; 
   d="scan'208";a="740870628"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 21 Jul 2022 17:22:04 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oEgQd-0000lo-2f;
        Fri, 22 Jul 2022 00:22:03 +0000
Date:   Fri, 22 Jul 2022 08:21:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: Re: [PATCH net-next v2 6/9] net: marvell: prestera: Add heplers to
 interact with fib_notifier_info
Message-ID: <202207220859.9D3mfHop-lkp@intel.com>
References: <20220721221148.18787-7-yevhen.orlov@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721221148.18787-7-yevhen.orlov@plvision.eu>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yevhen,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Yevhen-Orlov/net-marvell-prestera-add-nexthop-routes-offloading/20220722-061517
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 5588d628027092e66195097bdf6835ddf64418b3
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20220722/202207220859.9D3mfHop-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/a6535f7f7b3aea14504cac208c170d413739d5f9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yevhen-Orlov/net-marvell-prestera-add-nexthop-routes-offloading/20220722-061517
        git checkout a6535f7f7b3aea14504cac208c170d413739d5f9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash drivers/net/ethernet/marvell/prestera/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/marvell/prestera/prestera_router.c: In function 'prestera_kern_fib_info_nhs':
>> drivers/net/ethernet/marvell/prestera/prestera_router.c:274:47: warning: the comparison will always evaluate as 'true' for the address of 'fib6_nh' will never be NULL [-Waddress]
     274 |                 return fen6_info->rt->fib6_nh ?
         |                                               ^
   In file included from include/net/nexthop.h:17,
                    from drivers/net/ethernet/marvell/prestera/prestera_router.c:10:
   include/net/ip6_fib.h:206:41: note: 'fib6_nh' declared here
     206 |         struct fib6_nh                  fib6_nh[];
         |                                         ^~~~~~~
   drivers/net/ethernet/marvell/prestera/prestera_router.c: In function '__prestera_k_arb_fc_apply':
   drivers/net/ethernet/marvell/prestera/prestera_router.c:466:9: warning: enumeration value 'PRESTERA_FIB_TYPE_UC_NH' not handled in switch [-Wswitch]
     466 |         switch (fc->lpm_info.fib_type) {
         |         ^~~~~~
   drivers/net/ethernet/marvell/prestera/prestera_router.c: At top level:
   drivers/net/ethernet/marvell/prestera/prestera_router.c:262:12: warning: 'prestera_kern_fib_info_nhs' defined but not used [-Wunused-function]
     262 | static int prestera_kern_fib_info_nhs(struct fib_notifier_info *info)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/marvell/prestera/prestera_router.c:230:1: warning: 'prestera_kern_fib_info_nhc' defined but not used [-Wunused-function]
     230 | prestera_kern_fib_info_nhc(struct fib_notifier_info *info, int n)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/marvell/prestera/prestera_router.c:216:1: warning: 'prestera_util_kern_set_nh_offload' defined but not used [-Wunused-function]
     216 | prestera_util_kern_set_nh_offload(struct fib_nh_common *nhc, bool offloaded, bool trap)
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/marvell/prestera/prestera_router.c:206:13: warning: 'prestera_util_kern_set_neigh_offload' defined but not used [-Wunused-function]
     206 | static void prestera_util_kern_set_neigh_offload(struct neighbour *n,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/marvell/prestera/prestera_router.c:194:1: warning: 'prestera_util_kern_n_is_reachable' defined but not used [-Wunused-function]
     194 | prestera_util_kern_n_is_reachable(u32 tb_id,
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/marvell/prestera/prestera_router.c:135:13: warning: 'prestera_fib_info_is_nh' defined but not used [-Wunused-function]
     135 | static bool prestera_fib_info_is_nh(struct fib_notifier_info *info)
         |             ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/marvell/prestera/prestera_router.c:122:13: warning: 'prestera_fib_info_is_direct' defined but not used [-Wunused-function]
     122 | static bool prestera_fib_info_is_direct(struct fib_notifier_info *info)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +274 drivers/net/ethernet/marvell/prestera/prestera_router.c

   261	
   262	static int prestera_kern_fib_info_nhs(struct fib_notifier_info *info)
   263	{
   264		struct fib6_entry_notifier_info *fen6_info;
   265		struct fib_entry_notifier_info *fen4_info;
   266	
   267		if (info->family == AF_INET) {
   268			fen4_info = container_of(info, struct fib_entry_notifier_info,
   269						 info);
   270			return fib_info_num_path(fen4_info->fi);
   271		} else if (info->family == AF_INET6) {
   272			fen6_info = container_of(info, struct fib6_entry_notifier_info,
   273						 info);
 > 274			return fen6_info->rt->fib6_nh ?
   275				(fen6_info->rt->fib6_nsiblings + 1) : 0;
   276		}
   277	
   278		return 0;
   279	}
   280	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
