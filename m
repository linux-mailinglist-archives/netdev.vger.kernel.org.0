Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832624C7C13
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 22:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiB1VdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 16:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiB1VdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 16:33:09 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0149712222B;
        Mon, 28 Feb 2022 13:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646083950; x=1677619950;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LczHU2VgdEbSa318frFVSW5Uambj7Tf+7NqJ5ePTTEQ=;
  b=AptW2Y2biP5E2LvufbaRiPLu296uq7tW4dbIXt/dLRKahqrFwsssGeVa
   IjsANgC9+CfIjQ6fhQGysyYJnMIR7IpvtD4440Yq5mlexv84o7Kk9Pcmr
   xyIGqhHmv39dQ632CKGGZkyrRO1zCjQxnyHuRWE9s76vsQNeTQhVO2kGy
   EZvczSA079JSM7OvK8mN5FTeOUR/pvuBaeJjMboUgOO8kU/9qn2x+18xS
   2PzXqsQrDjgG0sckA2QAUlov1XXD722gevcz1jlRelsmT552M5G9APaex
   BzfrSTTjlECvNXE3YNw+mzYhO6frDRZGy0QW+tS+V5OXrpxuLnQeIJmry
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="339425562"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="339425562"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 13:32:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="641029708"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 28 Feb 2022 13:32:25 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nOnd3-0007oH-1c; Mon, 28 Feb 2022 21:32:25 +0000
Date:   Tue, 1 Mar 2022 05:31:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     wudaemon <wudaemon@163.com>, davem@davemloft.net, kuba@kernel.org,
        m.grzeschik@pengutronix.de, chenhao288@hisilicon.com, arnd@arndb.de
Cc:     kbuild-all@lists.01.org, wudaemon@163.com, shenyang39@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ksz884x: use time_before in netdev_open for
 compatibility and remove static variable
Message-ID: <202203010549.CYZcqRXa-lkp@intel.com>
References: <20220228162955.22819-1-wudaemon@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228162955.22819-1-wudaemon@163.com>
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

Hi wudaemon,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on net/master soc/for-next linus/master v5.17-rc6 next-20220228]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/wudaemon/net-ksz884x-use-time_before-in-netdev_open-for-compatibility-and-remove-static-variable/20220301-003151
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b42a738e409b62f38a15ce7530e8290b00f823a4
config: ia64-randconfig-r012-20220227 (https://download.01.org/0day-ci/archive/20220301/202203010549.CYZcqRXa-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/5db9da911f33045f8dd202d40c20530211b48af0
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review wudaemon/net-ksz884x-use-time_before-in-netdev_open-for-compatibility-and-remove-static-variable/20220301-003151
        git checkout 5db9da911f33045f8dd202d40c20530211b48af0
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=ia64 SHELL=/bin/bash drivers/net/ethernet/micrel/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   In file included from arch/ia64/include/asm/pgtable.h:153,
                    from include/linux/pgtable.h:6,
                    from arch/ia64/include/asm/uaccess.h:40,
                    from include/linux/uaccess.h:11,
                    from arch/ia64/include/asm/sections.h:11,
                    from include/linux/interrupt.h:21,
                    from drivers/net/ethernet/micrel/ksz884x.c:12:
   arch/ia64/include/asm/mmu_context.h: In function 'reload_context':
   arch/ia64/include/asm/mmu_context.h:127:48: warning: variable 'old_rr4' set but not used [-Wunused-but-set-variable]
     127 |         unsigned long rr0, rr1, rr2, rr3, rr4, old_rr4;
         |                                                ^~~~~~~
   drivers/net/ethernet/micrel/ksz884x.c: In function 'prepare_hardware':
   drivers/net/ethernet/micrel/ksz884x.c:5363:23: warning: unused variable 'next_jiffies' [-Wunused-variable]
    5363 |         unsigned long next_jiffies = 0;
         |                       ^~~~~~~~~~~~
   In file included from include/linux/bitops.h:7,
                    from include/linux/kernel.h:22,
                    from include/linux/interrupt.h:6,
                    from drivers/net/ethernet/micrel/ksz884x.c:12:
   drivers/net/ethernet/micrel/ksz884x.c: In function 'netdev_open':
>> drivers/net/ethernet/micrel/ksz884x.c:5430:41: error: 'next_jiffies' undeclared (first use in this function)
    5430 |                         if (time_before(next_jiffies, jiffies))
         |                                         ^~~~~~~~~~~~
   include/linux/typecheck.h:11:16: note: in definition of macro 'typecheck'
      11 |         typeof(x) __dummy2; \
         |                ^
   include/linux/jiffies.h:108:33: note: in expansion of macro 'time_after'
     108 | #define time_before(a,b)        time_after(b,a)
         |                                 ^~~~~~~~~~
   drivers/net/ethernet/micrel/ksz884x.c:5430:29: note: in expansion of macro 'time_before'
    5430 |                         if (time_before(next_jiffies, jiffies))
         |                             ^~~~~~~~~~~
   drivers/net/ethernet/micrel/ksz884x.c:5430:41: note: each undeclared identifier is reported only once for each function it appears in
    5430 |                         if (time_before(next_jiffies, jiffies))
         |                                         ^~~~~~~~~~~~
   include/linux/typecheck.h:11:16: note: in definition of macro 'typecheck'
      11 |         typeof(x) __dummy2; \
         |                ^
   include/linux/jiffies.h:108:33: note: in expansion of macro 'time_after'
     108 | #define time_before(a,b)        time_after(b,a)
         |                                 ^~~~~~~~~~
   drivers/net/ethernet/micrel/ksz884x.c:5430:29: note: in expansion of macro 'time_before'
    5430 |                         if (time_before(next_jiffies, jiffies))
         |                             ^~~~~~~~~~~
>> include/linux/typecheck.h:12:25: warning: comparison of distinct pointer types lacks a cast
      12 |         (void)(&__dummy == &__dummy2); \
         |                         ^~
   include/linux/jiffies.h:106:10: note: in expansion of macro 'typecheck'
     106 |          typecheck(unsigned long, b) && \
         |          ^~~~~~~~~
   include/linux/jiffies.h:108:33: note: in expansion of macro 'time_after'
     108 | #define time_before(a,b)        time_after(b,a)
         |                                 ^~~~~~~~~~
   drivers/net/ethernet/micrel/ksz884x.c:5430:29: note: in expansion of macro 'time_before'
    5430 |                         if (time_before(next_jiffies, jiffies))
         |                             ^~~~~~~~~~~


vim +/next_jiffies +5430 drivers/net/ethernet/micrel/ksz884x.c

  5397	
  5398	/**
  5399	 * netdev_open - open network device
  5400	 * @dev:	Network device.
  5401	 *
  5402	 * This function process the open operation of network device.  This is caused
  5403	 * by the user command "ifconfig ethX up."
  5404	 *
  5405	 * Return 0 if successful; otherwise an error code indicating failure.
  5406	 */
  5407	static int netdev_open(struct net_device *dev)
  5408	{
  5409		struct dev_priv *priv = netdev_priv(dev);
  5410		struct dev_info *hw_priv = priv->adapter;
  5411		struct ksz_hw *hw = &hw_priv->hw;
  5412		struct ksz_port *port = &priv->port;
  5413		int i;
  5414		int p;
  5415		int rc = 0;
  5416	
  5417		priv->multicast = 0;
  5418		priv->promiscuous = 0;
  5419	
  5420		/* Reset device statistics. */
  5421		memset(&dev->stats, 0, sizeof(struct net_device_stats));
  5422		memset((void *) port->counter, 0,
  5423			(sizeof(u64) * OID_COUNTER_LAST));
  5424	
  5425		if (!(hw_priv->opened)) {
  5426			rc = prepare_hardware(dev);
  5427			if (rc)
  5428				return rc;
  5429			for (i = 0; i < hw->mib_port_cnt; i++) {
> 5430				if (time_before(next_jiffies, jiffies))
  5431					next_jiffies = jiffies + HZ * 2;
  5432				else
  5433					next_jiffies += HZ * 1;
  5434				hw_priv->counter[i].time = next_jiffies;
  5435				hw->port_mib[i].state = media_disconnected;
  5436				port_init_cnt(hw, i);
  5437			}
  5438			if (hw->ksz_switch)
  5439				hw->port_mib[HOST_PORT].state = media_connected;
  5440			else {
  5441				hw_add_wol_bcast(hw);
  5442				hw_cfg_wol_pme(hw, 0);
  5443				hw_clr_wol_pme_status(&hw_priv->hw);
  5444			}
  5445		}
  5446		port_set_power_saving(port, false);
  5447	
  5448		for (i = 0, p = port->first_port; i < port->port_cnt; i++, p++) {
  5449			/*
  5450			 * Initialize to invalid value so that link detection
  5451			 * is done.
  5452			 */
  5453			hw->port_info[p].partner = 0xFF;
  5454			hw->port_info[p].state = media_disconnected;
  5455		}
  5456	
  5457		/* Need to open the port in multiple device interfaces mode. */
  5458		if (hw->dev_count > 1) {
  5459			port_set_stp_state(hw, port->first_port, STP_STATE_SIMPLE);
  5460			if (port->first_port > 0)
  5461				hw_add_addr(hw, dev->dev_addr);
  5462		}
  5463	
  5464		port_get_link_speed(port);
  5465		if (port->force_link)
  5466			port_force_link_speed(port);
  5467		else
  5468			port_set_link_speed(port);
  5469	
  5470		if (!(hw_priv->opened)) {
  5471			hw_setup_intr(hw);
  5472			hw_enable(hw);
  5473			hw_ena_intr(hw);
  5474	
  5475			if (hw->mib_port_cnt)
  5476				ksz_start_timer(&hw_priv->mib_timer_info,
  5477					hw_priv->mib_timer_info.period);
  5478		}
  5479	
  5480		hw_priv->opened++;
  5481	
  5482		ksz_start_timer(&priv->monitor_timer_info,
  5483			priv->monitor_timer_info.period);
  5484	
  5485		priv->media_state = port->linked->state;
  5486	
  5487		set_media_state(dev, media_connected);
  5488		netif_start_queue(dev);
  5489	
  5490		return 0;
  5491	}
  5492	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
