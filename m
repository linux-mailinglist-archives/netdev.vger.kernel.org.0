Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630144CA8BF
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 16:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243333AbiCBPEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 10:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiCBPEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 10:04:00 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A34CA307;
        Wed,  2 Mar 2022 07:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646233397; x=1677769397;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hzoUhmNLUaUocUeWD6uJAxizGDzSnCXxwKehYrN0fvo=;
  b=HBldpZnMqvFJVTEseLpxDnTAEA4tLnBxsJpvrHavvua1fhBDWViw8vjP
   MYj/5EolmfHjxKpLr/OfVJK0pl+d7xCPMiVE+yCdwvd2H+pSrKeieaCFJ
   5HmnxgMGfqBTVj4KX05F5I9rNypLmxbBZT5lYmZ3d9Y1WAp3oLiKD9aSD
   GVNhhVePpc234YMS3oRPLyAMuPZ5bJFpq3th1NPMGCkRvfYkgmyQjQ/ot
   gnvXG1noYRkFRlH1u0ev0cMMPPr/RvpireXTFECqmdp4bv6+X5DSjADPA
   k0Fss4RFPEVcVttOrZQ+xjWuVD6ETnwkgeHiiKiaiSeYM9obBb+WG4uDE
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="234034669"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="234034669"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 07:03:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="709536596"
Received: from lkp-server02.sh.intel.com (HELO e9605edfa585) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 02 Mar 2022 07:03:10 -0800
Received: from kbuild by e9605edfa585 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nPQVR-0001Um-Gf; Wed, 02 Mar 2022 15:03:09 +0000
Date:   Wed, 2 Mar 2022 23:02:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dust Li <dust.li@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: fix compile warning for smc_sysctl
Message-ID: <202203022234.AMB3WcyJ-lkp@intel.com>
References: <20220302034312.31168-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302034312.31168-1-dust.li@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dust,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Dust-Li/net-smc-fix-compile-warning-for-smc_sysctl/20220302-114411
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 7282c126f7688f697d33f3b965c29bba67fb4eba
config: sparc-buildonly-randconfig-r005-20220302 (https://download.01.org/0day-ci/archive/20220302/202203022234.AMB3WcyJ-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/4b16b08f4709ad49412ee1df69b6922a370dad46
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Dust-Li/net-smc-fix-compile-warning-for-smc_sysctl/20220302-114411
        git checkout 4b16b08f4709ad49412ee1df69b6922a370dad46
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=sparc SHELL=/bin/bash net/smc/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/smc/smc_sysctl.c: In function 'smc_sysctl_init_net':
   net/smc/smc_sysctl.c:47:17: error: 'struct netns_smc' has no member named 'smc_hdr'
      47 |         net->smc.smc_hdr = register_net_sysctl(net, "net/smc", table);
         |                 ^
   net/smc/smc_sysctl.c:48:22: error: 'struct netns_smc' has no member named 'smc_hdr'
      48 |         if (!net->smc.smc_hdr)
         |                      ^
   net/smc/smc_sysctl.c: In function 'smc_sysctl_exit_net':
   net/smc/smc_sysctl.c:64:45: error: 'struct netns_smc' has no member named 'smc_hdr'
      64 |         unregister_net_sysctl_table(net->smc.smc_hdr);
         |                                             ^
   net/smc/smc_sysctl.c: At top level:
   net/smc/smc_sysctl.c:72:16: error: redefinition of 'smc_sysctl_init'
      72 | int __net_init smc_sysctl_init(void)
         |                ^~~~~~~~~~~~~~~
   In file included from net/smc/smc_sysctl.c:18:
   net/smc/smc_sysctl.h:23:19: note: previous definition of 'smc_sysctl_init' with type 'int(void)'
      23 | static inline int smc_sysctl_init(void)
         |                   ^~~~~~~~~~~~~~~
>> net/smc/smc_sysctl.c:78:1: warning: ignoring attribute 'noinline' because it conflicts with attribute 'gnu_inline' [-Wattributes]
      78 | {
         | ^
   In file included from net/smc/smc_sysctl.c:18:
   net/smc/smc_sysctl.h:28:20: note: previous declaration here
      28 | static inline void smc_sysctl_exit(void) { }
         |                    ^~~~~~~~~~~~~~~
   net/smc/smc_sysctl.c:77:17: error: redefinition of 'smc_sysctl_exit'
      77 | void __net_exit smc_sysctl_exit(void)
         |                 ^~~~~~~~~~~~~~~
   In file included from net/smc/smc_sysctl.c:18:
   net/smc/smc_sysctl.h:28:20: note: previous definition of 'smc_sysctl_exit' with type 'void(void)'
      28 | static inline void smc_sysctl_exit(void) { }
         |                    ^~~~~~~~~~~~~~~


vim +78 net/smc/smc_sysctl.c

462791bbfa35018 Dust Li 2022-03-01  76  
4b16b08f4709ad4 Dust Li 2022-03-02  77  void __net_exit smc_sysctl_exit(void)
462791bbfa35018 Dust Li 2022-03-01 @78  {

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
