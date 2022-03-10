Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E294D3DF3
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238940AbiCJAQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbiCJAQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:16:36 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2435995A1F
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646871337; x=1678407337;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h5QwPXXdQnRLGw6nWjUg1Ub312PVL9cjv6oktKBRjM8=;
  b=TlnhdCgPEUcPWtFjt/L14oltuXrOZO4yYmRX1UnES5yFCCL4tak+7Ipo
   ZMi+pBNL7iz8Puz77z8dHXzhdwz440ck3+vBLgvC8dcw/wIog8YAp+6ao
   CpbIb0t9OrIzcMdac/t0ax1JDPXzN2eJkWL30J/d6y41P01iCrfbL6+xN
   nLwpXgpV/sxe+MvPhAlbmx1ISN/HR525VP8Fh8qnAMLlZgi1HDXgqOWGo
   7yfuTtG88m7CIs5d0w0SXR7KQZOIU5CrUhBFKbyIUzXDv6KDqbEchwt59
   vOtFrg9s7ODjsKSIKoI7m5U866ENTkLAI8k0ScHFBC6QKEOQlkkB+8HfO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="315838315"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="315838315"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 16:15:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="781270992"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga006.fm.intel.com with ESMTP; 09 Mar 2022 16:15:34 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nS6Sr-000410-Gs; Thu, 10 Mar 2022 00:15:33 +0000
Date:   Thu, 10 Mar 2022 08:15:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        jeffreyji <jeffreyji@google.com>,
        Brian Vazquez <brianvv@google.com>
Subject: Re: [PATCH net-next] net: add per-cpu storage and net->core_stats
Message-ID: <202203100857.encufNnt-lkp@intel.com>
References: <20220309211808.114307-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309211808.114307-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

url:    https://github.com/0day-ci/linux/commits/Eric-Dumazet/net-add-per-cpu-storage-and-net-core_stats/20220310-051831
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 7f415828f987fca9651694c7589560e55ffdf9a6
config: m68k-randconfig-r015-20220309 (https://download.01.org/0day-ci/archive/20220310/202203100857.encufNnt-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/9e6510e2ec32ebae0469ff500b2ba5bb2eb7a761
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-add-per-cpu-storage-and-net-core_stats/20220310-051831
        git checkout 9e6510e2ec32ebae0469ff500b2ba5bb2eb7a761
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=m68k SHELL=/bin/bash drivers/media/dvb-frontends/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/media/dvb_net.h:22,
                    from drivers/media/usb/dvb-usb-v2/dvb_usb.h:19,
                    from drivers/media/dvb-frontends/rtl2832_sdr.c:12:
>> include/linux/netdevice.h:201:9: error: unknown type name 'local_t'
     201 |         local_t         rx_dropped;
         |         ^~~~~~~
   include/linux/netdevice.h:202:9: error: unknown type name 'local_t'
     202 |         local_t         tx_dropped;
         |         ^~~~~~~
   include/linux/netdevice.h:203:9: error: unknown type name 'local_t'
     203 |         local_t         rx_nohandler;
         |         ^~~~~~~
   In file included from include/linux/compiler_types.h:68,
                    from <command-line>:
>> include/linux/netdevice.h:204:24: error: 'local_t' undeclared here (not in a function)
     204 | } __aligned(4 * sizeof(local_t));
         |                        ^~~~~~~
   include/linux/compiler_attributes.h:33:68: note: in definition of macro '__aligned'
      33 | #define __aligned(x)                    __attribute__((__aligned__(x)))
         |                                                                    ^
   In file included from include/media/dvb_net.h:22,
                    from drivers/media/usb/dvb-usb-v2/dvb_usb.h:19,
                    from drivers/media/dvb-frontends/rtl2832_sdr.c:12:
   include/linux/netdevice.h: In function 'dev_core_stats_rx_dropped_inc':
>> include/linux/netdevice.h:3863:17: error: implicit declaration of function 'local_inc'; did you mean 'local_lock'? [-Werror=implicit-function-declaration]
    3863 |                 local_inc(&p->FIELD);                                           \
         |                 ^~~~~~~~~
   include/linux/netdevice.h:3865:1: note: in expansion of macro 'DEV_CORE_STATS_INC'
    3865 | DEV_CORE_STATS_INC(rx_dropped)
         | ^~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/local_t +201 include/linux/netdevice.h

   196	
   197	/* per-cpu stats, allocated on demand.
   198	 * Try to fit them in a single cache line, for dev_get_stats() sake.
   199	 */
   200	struct net_device_core_stats {
 > 201		local_t		rx_dropped;
 > 202		local_t		tx_dropped;
   203		local_t		rx_nohandler;
 > 204	} __aligned(4 * sizeof(local_t));
   205	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
