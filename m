Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F2B520867
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 01:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbiEIXgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 19:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbiEIXgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 19:36:01 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D4D20D267
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 16:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652139124; x=1683675124;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FzHEK7nZzm9FI1iKStZdzdKwVde9YF4O+OBbpJJgkts=;
  b=nHSTpNH8meT9hqz7CMMC6EzysB2tEvLynZNNe35zkwmzUpnmL5byd2CS
   FlNcl4M6AXBKoOyg7jYWWt9NSTzTaWMWy2/6j+l4CXHI5uumdy6Z1Xodl
   4uQzvZFDcrFQRItjYhg59fG2x0hIvmhoUCykdAjbV2Q0Dll7UlzgiPBiG
   zVO8DzOhXUWhgE+Qp+oG7P56XSOK88lSiE6wINGedbwwd4rLJkGCbxBch
   QyLi80ydrzbsbRIivr84I/NupHaMaLoEO8QwzqND5UhnyTf4cZNXNyjmF
   3rr4wtS3IzwbdA4bqrrLoi2onIqso2kXgYeq1gq+DKAzPWA5i3EWh7ezG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="355626795"
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="355626795"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 16:32:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="669585915"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 09 May 2022 16:32:02 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1noCrA-000H0F-Rw;
        Mon, 09 May 2022 23:32:00 +0000
Date:   Tue, 10 May 2022 07:31:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 3/4] net: warn if transport header was not set
Message-ID: <202205100723.9Wqso3nI-lkp@intel.com>
References: <20220509190851.1107955-4-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509190851.1107955-4-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Dumazet/net-CONFIG_DEBUG_NET-and-friends/20220510-031145
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9c095bd0d4c451d31d0fd1131cc09d3b60de815d
config: arm-oxnas_v6_defconfig (https://download.01.org/0day-ci/archive/20220510/202205100723.9Wqso3nI-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d316b61f313a417d7dfa97fa006320288f3af150
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Eric-Dumazet/net-CONFIG_DEBUG_NET-and-friends/20220510-031145
        git checkout d316b61f313a417d7dfa97fa006320288f3af150
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/net/ethernet/stmicro/stmmac/ drivers/net/mdio/ net/core/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/skbuff.h:45,
                    from include/linux/netlink.h:7,
                    from include/linux/ethtool.h:18,
                    from include/linux/phy.h:16,
                    from include/linux/fwnode_mdio.h:9,
                    from drivers/net/mdio/of_mdio.c:13:
>> include/net/net_debug.h:6:52: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
       6 | void netdev_printk(const char *level, const struct net_device *dev,
         |                                                    ^~~~~~~~~~
   include/net/net_debug.h:9:32: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
       9 | void netdev_emerg(const struct net_device *dev, const char *format, ...);
         |                                ^~~~~~~~~~
   include/net/net_debug.h:11:32: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      11 | void netdev_alert(const struct net_device *dev, const char *format, ...);
         |                                ^~~~~~~~~~
   include/net/net_debug.h:13:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      13 | void netdev_crit(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   include/net/net_debug.h:15:30: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                              ^~~~~~~~~~
   include/net/net_debug.h:17:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   include/net/net_debug.h:19:33: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      19 | void netdev_notice(const struct net_device *dev, const char *format, ...);
         |                                 ^~~~~~~~~~
   include/net/net_debug.h:21:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   drivers/net/mdio/of_mdio.c: In function 'of_phy_get_and_connect':
   drivers/net/mdio/of_mdio.c:326:36: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
     326 |                         netdev_err(dev, "broken fixed-link specification\n");
         |                                    ^~~
         |                                    |
         |                                    struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from include/linux/netlink.h:7,
                    from include/linux/ethtool.h:18,
                    from include/linux/phy.h:16,
                    from include/linux/fwnode_mdio.h:9,
                    from drivers/net/mdio/of_mdio.c:13:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   cc1: some warnings being treated as errors
--
   In file included from include/linux/skbuff.h:45,
                    from include/linux/ip.h:16,
                    from drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:20:
>> include/net/net_debug.h:6:52: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
       6 | void netdev_printk(const char *level, const struct net_device *dev,
         |                                                    ^~~~~~~~~~
   include/net/net_debug.h:9:32: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
       9 | void netdev_emerg(const struct net_device *dev, const char *format, ...);
         |                                ^~~~~~~~~~
   include/net/net_debug.h:11:32: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      11 | void netdev_alert(const struct net_device *dev, const char *format, ...);
         |                                ^~~~~~~~~~
   include/net/net_debug.h:13:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      13 | void netdev_crit(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   include/net/net_debug.h:15:30: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                              ^~~~~~~~~~
   include/net/net_debug.h:17:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   include/net/net_debug.h:19:33: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      19 | void netdev_notice(const struct net_device *dev, const char *format, ...);
         |                                 ^~~~~~~~~~
   include/net/net_debug.h:21:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   In file included from include/linux/skbuff.h:45,
                    from include/linux/ip.h:16,
                    from drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:20:
   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function 'stmmac_eee_init':
   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:486:40: error: passing argument 2 of 'netdev_printk' from incompatible pointer type [-Werror=incompatible-pointer-types]
     486 |                         netdev_dbg(priv->dev, "disable EEE\n");
         |                                    ~~~~^~~~~
         |                                        |
         |                                        struct net_device *
   include/net/net_debug.h:61:43: note: in definition of macro 'netdev_dbg'
      61 |                 netdev_printk(KERN_DEBUG, __dev, format, ##args); \
         |                                           ^~~~~
   include/net/net_debug.h:6:64: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
       6 | void netdev_printk(const char *level, const struct net_device *dev,
         |                                       ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:520:24: error: passing argument 2 of 'netdev_printk' from incompatible pointer type [-Werror=incompatible-pointer-types]
     520 |         netdev_dbg(priv->dev, "Energy-Efficient Ethernet initialized\n");
         |                    ~~~~^~~~~
         |                        |
         |                        struct net_device *
   include/net/net_debug.h:61:43: note: in definition of macro 'netdev_dbg'
      61 |                 netdev_printk(KERN_DEBUG, __dev, format, ##args); \
         |                                           ^~~~~
   include/net/net_debug.h:6:64: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
       6 | void netdev_printk(const char *level, const struct net_device *dev,
         |                                       ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function 'stmmac_get_tx_hwtstamp':
   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:560:32: error: passing argument 2 of 'netdev_printk' from incompatible pointer type [-Werror=incompatible-pointer-types]
     560 |                 netdev_dbg(priv->dev, "get valid TX hw timestamp %llu\n", ns);
         |                            ~~~~^~~~~
         |                                |
         |                                struct net_device *
   include/net/net_debug.h:61:43: note: in definition of macro 'netdev_dbg'
      61 |                 netdev_printk(KERN_DEBUG, __dev, format, ##args); \
         |                                           ^~~~~
   include/net/net_debug.h:6:64: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
       6 | void netdev_printk(const char *level, const struct net_device *dev,
         |                                       ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function 'stmmac_get_rx_hwtstamp':
   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:594:32: error: passing argument 2 of 'netdev_printk' from incompatible pointer type [-Werror=incompatible-pointer-types]
     594 |                 netdev_dbg(priv->dev, "get valid RX hw timestamp %llu\n", ns);
         |                            ~~~~^~~~~
         |                                |
         |                                struct net_device *
   include/net/net_debug.h:61:43: note: in definition of macro 'netdev_dbg'
      61 |                 netdev_printk(KERN_DEBUG, __dev, format, ##args); \
         |                                           ^~~~~
   include/net/net_debug.h:6:64: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
       6 | void netdev_printk(const char *level, const struct net_device *dev,
         |                                       ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:599:32: error: passing argument 2 of 'netdev_printk' from incompatible pointer type [-Werror=incompatible-pointer-types]
     599 |                 netdev_dbg(priv->dev, "cannot get RX hw timestamp\n");
         |                            ~~~~^~~~~
         |                                |
         |                                struct net_device *
   include/net/net_debug.h:61:43: note: in definition of macro 'netdev_dbg'
      61 |                 netdev_printk(KERN_DEBUG, __dev, format, ##args); \
         |                                           ^~~~~
   include/net/net_debug.h:6:64: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
       6 | void netdev_printk(const char *level, const struct net_device *dev,
         |                                       ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function 'stmmac_hwtstamp_set':
   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:628:34: error: passing argument 1 of 'netdev_alert' from incompatible pointer type [-Werror=incompatible-pointer-types]
     628 |                 netdev_alert(priv->dev, "No support for HW time stamping\n");
         |                              ~~~~^~~~~
         |                                  |
         |                                  struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from include/linux/ip.h:16,
                    from drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:20:
   include/net/net_debug.h:11:44: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      11 | void netdev_alert(const struct net_device *dev, const char *format, ...);
         |                   ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:639:24: error: passing argument 2 of 'netdev_printk' from incompatible pointer type [-Werror=incompatible-pointer-types]
     639 |         netdev_dbg(priv->dev, "%s config flags:0x%x, tx_type:0x%x, rx_filter:0x%x\n",
         |                    ~~~~^~~~~
         |                        |
--
   In file included from include/linux/skbuff.h:45,
                    from include/linux/if_ether.h:19,
                    from include/linux/etherdevice.h:20,
                    from drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c:11:
>> include/net/net_debug.h:6:52: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
       6 | void netdev_printk(const char *level, const struct net_device *dev,
         |                                                    ^~~~~~~~~~
   include/net/net_debug.h:9:32: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
       9 | void netdev_emerg(const struct net_device *dev, const char *format, ...);
         |                                ^~~~~~~~~~
   include/net/net_debug.h:11:32: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      11 | void netdev_alert(const struct net_device *dev, const char *format, ...);
         |                                ^~~~~~~~~~
   include/net/net_debug.h:13:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      13 | void netdev_crit(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   include/net/net_debug.h:15:30: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                              ^~~~~~~~~~
   include/net/net_debug.h:17:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   include/net/net_debug.h:19:33: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      19 | void netdev_notice(const struct net_device *dev, const char *format, ...);
         |                                 ^~~~~~~~~~
   include/net/net_debug.h:21:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c: In function 'stmmac_ethtool_op_set_eee':
   drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c:803:33: error: passing argument 1 of 'netdev_warn' from incompatible pointer type [-Werror=incompatible-pointer-types]
     803 |                 netdev_warn(priv->dev,
         |                             ~~~~^~~~~
         |                                 |
         |                                 struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from include/linux/if_ether.h:19,
                    from include/linux/etherdevice.h:20,
                    from drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c:11:
   include/net/net_debug.h:17:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   cc1: some warnings being treated as errors
--
   In file included from include/linux/skbuff.h:45,
                    from include/linux/netlink.h:7,
                    from include/linux/ethtool.h:18,
                    from include/linux/linkmode.h:5,
                    from include/linux/mii.h:13,
                    from drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c:16:
>> include/net/net_debug.h:6:52: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
       6 | void netdev_printk(const char *level, const struct net_device *dev,
         |                                                    ^~~~~~~~~~
   include/net/net_debug.h:9:32: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
       9 | void netdev_emerg(const struct net_device *dev, const char *format, ...);
         |                                ^~~~~~~~~~
   include/net/net_debug.h:11:32: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      11 | void netdev_alert(const struct net_device *dev, const char *format, ...);
         |                                ^~~~~~~~~~
   include/net/net_debug.h:13:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      13 | void netdev_crit(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   include/net/net_debug.h:15:30: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                              ^~~~~~~~~~
   include/net/net_debug.h:17:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   include/net/net_debug.h:19:33: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      19 | void netdev_notice(const struct net_device *dev, const char *format, ...);
         |                                 ^~~~~~~~~~
   include/net/net_debug.h:21:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
--
   In file included from include/linux/skbuff.h:45,
                    from include/linux/netlink.h:7,
                    from include/linux/ethtool.h:18,
                    from drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:15:
>> include/net/net_debug.h:6:52: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
       6 | void netdev_printk(const char *level, const struct net_device *dev,
         |                                                    ^~~~~~~~~~
   include/net/net_debug.h:9:32: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
       9 | void netdev_emerg(const struct net_device *dev, const char *format, ...);
         |                                ^~~~~~~~~~
   include/net/net_debug.h:11:32: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      11 | void netdev_alert(const struct net_device *dev, const char *format, ...);
         |                                ^~~~~~~~~~
   include/net/net_debug.h:13:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      13 | void netdev_crit(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   include/net/net_debug.h:15:30: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                              ^~~~~~~~~~
   include/net/net_debug.h:17:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   include/net/net_debug.h:19:33: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      19 | void netdev_notice(const struct net_device *dev, const char *format, ...);
         |                                 ^~~~~~~~~~
   include/net/net_debug.h:21:31: warning: 'struct net_device' declared inside parameter list will not be visible outside of this definition or declaration
      21 | void netdev_info(const struct net_device *dev, const char *format, ...);
         |                               ^~~~~~~~~~
   drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c: In function 'dwmac4_write_vlan_filter':
   drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:462:20: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
     462 |         netdev_err(dev, "Timeout accessing MAC_VLAN_Tag_Filter\n");
         |                    ^~~
         |                    |
         |                    struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from include/linux/netlink.h:7,
                    from include/linux/ethtool.h:18,
                    from drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:15:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c: In function 'dwmac4_add_hw_vlan_rx_fltr':
   drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:479:28: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
     479 |                 netdev_err(dev,
         |                            ^~~
         |                            |
         |                            struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from include/linux/netlink.h:7,
                    from include/linux/ethtool.h:18,
                    from drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:15:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:488:37: error: passing argument 1 of 'netdev_warn' from incompatible pointer type [-Werror=incompatible-pointer-types]
     488 |                         netdev_warn(dev, "Adding VLAN ID 0 is not supported\n");
         |                                     ^~~
         |                                     |
         |                                     struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from include/linux/netlink.h:7,
                    from include/linux/ethtool.h:18,
                    from drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:15:
   include/net/net_debug.h:17:43: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      17 | void netdev_warn(const struct net_device *dev, const char *format, ...);
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:493:36: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
     493 |                         netdev_err(dev, "Only single VLAN ID supported\n");
         |                                    ^~~
         |                                    |
         |                                    struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from include/linux/netlink.h:7,
                    from include/linux/ethtool.h:18,
                    from drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:15:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:514:28: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
     514 |                 netdev_err(dev, "MAC_VLAN_Tag_Filter full (size: %0u)\n",
         |                            ^~~
         |                            |
         |                            struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from include/linux/netlink.h:7,
                    from include/linux/ethtool.h:18,
                    from drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:15:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c: In function 'dwmac4_del_hw_vlan_rx_fltr':
   drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:534:28: error: passing argument 1 of 'netdev_err' from incompatible pointer type [-Werror=incompatible-pointer-types]
     534 |                 netdev_err(dev,
         |                            ^~~
         |                            |
         |                            struct net_device *
   In file included from include/linux/skbuff.h:45,
                    from include/linux/netlink.h:7,
                    from include/linux/ethtool.h:18,
                    from drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c:15:
   include/net/net_debug.h:15:42: note: expected 'const struct net_device *' but argument is of type 'struct net_device *'
      15 | void netdev_err(const struct net_device *dev, const char *format, ...);
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   cc1: some warnings being treated as errors
..


vim +6 include/net/net_debug.h

877efca8201a88 Eric Dumazet 2022-05-09   4  
877efca8201a88 Eric Dumazet 2022-05-09   5  __printf(3, 4) __cold
877efca8201a88 Eric Dumazet 2022-05-09  @6  void netdev_printk(const char *level, const struct net_device *dev,
877efca8201a88 Eric Dumazet 2022-05-09   7  		   const char *format, ...);
877efca8201a88 Eric Dumazet 2022-05-09   8  __printf(2, 3) __cold
877efca8201a88 Eric Dumazet 2022-05-09   9  void netdev_emerg(const struct net_device *dev, const char *format, ...);
877efca8201a88 Eric Dumazet 2022-05-09  10  __printf(2, 3) __cold
877efca8201a88 Eric Dumazet 2022-05-09  11  void netdev_alert(const struct net_device *dev, const char *format, ...);
877efca8201a88 Eric Dumazet 2022-05-09  12  __printf(2, 3) __cold
877efca8201a88 Eric Dumazet 2022-05-09  13  void netdev_crit(const struct net_device *dev, const char *format, ...);
877efca8201a88 Eric Dumazet 2022-05-09  14  __printf(2, 3) __cold
877efca8201a88 Eric Dumazet 2022-05-09  15  void netdev_err(const struct net_device *dev, const char *format, ...);
877efca8201a88 Eric Dumazet 2022-05-09  16  __printf(2, 3) __cold
877efca8201a88 Eric Dumazet 2022-05-09  17  void netdev_warn(const struct net_device *dev, const char *format, ...);
877efca8201a88 Eric Dumazet 2022-05-09  18  __printf(2, 3) __cold
877efca8201a88 Eric Dumazet 2022-05-09  19  void netdev_notice(const struct net_device *dev, const char *format, ...);
877efca8201a88 Eric Dumazet 2022-05-09  20  __printf(2, 3) __cold
877efca8201a88 Eric Dumazet 2022-05-09  21  void netdev_info(const struct net_device *dev, const char *format, ...);
877efca8201a88 Eric Dumazet 2022-05-09  22  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
