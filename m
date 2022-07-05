Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C465676A6
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 20:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbiGESi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 14:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiGESiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 14:38:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C770413F5B;
        Tue,  5 Jul 2022 11:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657046333; x=1688582333;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pFb9nPw68TFCIeyeBjL+zv4wyN7xTCporTHN050htS0=;
  b=nb+YiyrDeWP5DSLW4xjDbNN7GqNos3id8gpToabaA4zrlaZdFRqNeEpR
   QRRTwcmfJGsmtdaQ4Dp6bMMXQfrHwGvXW34ARyTWC1FpQdM62tMvsv3pt
   ze7OGHem+0XeHTS1vzRoaVD7SO3FmpXwI4vDfUqNScH0jU2pyf0tKVFv7
   BT5MAofEfGbLr/Sp1rA/YHp+NDxDRlqEBA6qc0Mtqofw8FQy+bIaXDCXQ
   dU9lQsJNmG+xMXYMwl1MiYtHNJKXWoHosgSBx5MctHGhVvI3mUaDI3/7b
   0SGDFPbDlTwCyH3IdKbUEZgDak+txcRiGmAprjct7OEuPO+YfkR0RXzSD
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="263228882"
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="263228882"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 11:38:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="839231123"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 05 Jul 2022 11:38:51 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o8nRi-000JTl-K3;
        Tue, 05 Jul 2022 18:38:50 +0000
Date:   Wed, 6 Jul 2022 02:38:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vladimir.oltean@nxp.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v3 5/7] net: lan966x: Add lag support for
 lan966x.
Message-ID: <202207060247.0TIpleTV-lkp@intel.com>
References: <20220701205227.1337160-6-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701205227.1337160-6-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Horatiu-Vultur/net-lan966x-Add-lag-support/20220702-045154
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git dbdd9a28e1406ab8218a69e60f10a168b968c81d
config: powerpc-randconfig-r012-20220703 (https://download.01.org/0day-ci/archive/20220706/202207060247.0TIpleTV-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/a531636c4ccc3d4528016f83627b2e4677e83e59
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Horatiu-Vultur/net-lan966x-Add-lag-support/20220702-045154
        git checkout a531636c4ccc3d4528016f83627b2e4677e83e59
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   powerpc-linux-ld: drivers/net/ethernet/microchip/lan966x/lan966x_lag.o: in function `lan966x_lag_port_join':
>> drivers/net/ethernet/microchip/lan966x/lan966x_lag.c:138: undefined reference to `br_port_get_stp_state'


vim +138 drivers/net/ethernet/microchip/lan966x/lan966x_lag.c

   118	
   119	int lan966x_lag_port_join(struct lan966x_port *port,
   120				  struct net_device *brport_dev,
   121				  struct net_device *bond,
   122				  struct netlink_ext_ack *extack)
   123	{
   124		struct lan966x *lan966x = port->lan966x;
   125		struct net_device *dev = port->dev;
   126		int err;
   127	
   128		port->bond = bond;
   129		lan966x_lag_update_ids(lan966x);
   130	
   131		err = switchdev_bridge_port_offload(brport_dev, dev, port,
   132						    &lan966x_switchdev_nb,
   133						    &lan966x_switchdev_blocking_nb,
   134						    false, extack);
   135		if (err)
   136			goto out;
   137	
 > 138		lan966x_port_stp_state_set(port, br_port_get_stp_state(brport_dev));
   139	
   140		return 0;
   141	
   142	out:
   143		port->bond = NULL;
   144		lan966x_lag_update_ids(lan966x);
   145	
   146		return err;
   147	}
   148	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
