Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3044C7B48
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 22:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiB1VCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 16:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiB1VCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 16:02:30 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC20ADD45B;
        Mon, 28 Feb 2022 13:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646082106; x=1677618106;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iQvL0ZuBaUBPEkeF0scPNzz3XMBs5b3VZM2NenECRzM=;
  b=d2iTClJgdOiuxvQV1NxlHHknPxfIePgVbe40yh4YSQpeVXbkdnD93W8w
   VFPTCpJm1yWt42r0WzZDPsmxOrcrp5S0Bw4uid0wvN1IoBtYJKgtWo5Xt
   T5qEMgjNLGsS7XYLYODL4hGSZPy4+JSHsaIWSCES/d2kFeA3W73LNFgyZ
   pCu6ol2eyFBy2PRCphbdrgVAVXcbX6ZS609INXVo8SBQ0pC4MQ237nCCU
   bYRzUaSouaTRzbou8/uQZehd5ltu+Uemxm2q53Xspnp1rcpVPIpSuUnN3
   Vppn6Ex9g4KEu4AzOWpFw91ps6m80kmhNY3StHDZ02dSZL/RY/nK/Hf+9
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="236494283"
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="236494283"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2022 13:01:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,144,1643702400"; 
   d="scan'208";a="575458542"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 28 Feb 2022 13:01:24 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nOn92-0007mP-5s; Mon, 28 Feb 2022 21:01:24 +0000
Date:   Tue, 1 Mar 2022 05:00:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     wudaemon <wudaemon@163.com>, davem@davemloft.net, kuba@kernel.org,
        m.grzeschik@pengutronix.de, chenhao288@hisilicon.com, arnd@arndb.de
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, wudaemon@163.com,
        shenyang39@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ksz884x: use time_before in netdev_open for
 compatibility and remove static variable
Message-ID: <202203010451.ORtLeJ28-lkp@intel.com>
References: <20220228162955.22819-1-wudaemon@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228162955.22819-1-wudaemon@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220301/202203010451.ORtLeJ28-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/5db9da911f33045f8dd202d40c20530211b48af0
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review wudaemon/net-ksz884x-use-time_before-in-netdev_open-for-compatibility-and-remove-static-variable/20220301-003151
        git checkout 5db9da911f33045f8dd202d40c20530211b48af0
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ethernet/micrel/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/micrel/ksz884x.c:3216:6: warning: variable 'change' set but not used [-Wunused-but-set-variable]
           int change = 0;
               ^
   drivers/net/ethernet/micrel/ksz884x.c:5363:16: warning: unused variable 'next_jiffies' [-Wunused-variable]
           unsigned long next_jiffies = 0;
                         ^
>> drivers/net/ethernet/micrel/ksz884x.c:5430:20: error: use of undeclared identifier 'next_jiffies'
                           if (time_before(next_jiffies, jiffies))
                                           ^
>> drivers/net/ethernet/micrel/ksz884x.c:5430:20: error: use of undeclared identifier 'next_jiffies'
   drivers/net/ethernet/micrel/ksz884x.c:5431:5: error: use of undeclared identifier 'next_jiffies'
                                   next_jiffies = jiffies + HZ * 2;
                                   ^
   drivers/net/ethernet/micrel/ksz884x.c:5433:5: error: use of undeclared identifier 'next_jiffies'
                                   next_jiffies += HZ * 1;
                                   ^
   drivers/net/ethernet/micrel/ksz884x.c:5434:31: error: use of undeclared identifier 'next_jiffies'
                           hw_priv->counter[i].time = next_jiffies;
                                                      ^
   2 warnings and 5 errors generated.


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
