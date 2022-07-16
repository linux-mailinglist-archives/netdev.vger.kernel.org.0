Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043A05771F7
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 00:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbiGPWkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 18:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbiGPWkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 18:40:02 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93D91D0F3;
        Sat, 16 Jul 2022 15:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658011201; x=1689547201;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T+U4/9gl2O2+RuxdizGkJmWvRwLv3yFNdA8/DkiNESE=;
  b=Wrg/re6alFh2wx5LBfeg2aZw5UOrMgncM9ggJRAfdqyEz6Qv5fTSb1OE
   QS1YmpBbUMBRHW3eGAanGs7WMK5AGL0IE15qcWWANHo9NFxkiCllP0So4
   zSq0myOMthAYBhKEMO2292Y1HiZufED06IPz/14NFxuN9qAuNJPf0p9HU
   f09bwOnD6k7yztvHFsIOw+FD69KYc95grxSZHTiIpLJ97jBRJsQBAEzaj
   3dZSRtb3CHHhSXE20kXZmcFbZp+yDyCdVXbvl7tNuHRAD/S6vKG/x7bhf
   /SxOLMeEQwbyftH7DlyFx28GjWWS7OxAgkCeIszD+TiS+amaIHclzNYxj
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10410"; a="266418302"
X-IronPort-AV: E=Sophos;i="5.92,277,1650956400"; 
   d="scan'208";a="266418302"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2022 15:40:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,277,1650956400"; 
   d="scan'208";a="596848246"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 16 Jul 2022 15:39:57 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oCqS4-0002Fr-UK;
        Sat, 16 Jul 2022 22:39:56 +0000
Date:   Sun, 17 Jul 2022 06:39:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [net-next PATCH v2 3/5] net: ethernet: stmicro: stmmac: move dma
 conf to dedicated struct
Message-ID: <202207170636.Ism1wGe8-lkp@intel.com>
References: <20220716184533.2962-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716184533.2962-4-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Christian-Marangi/Add-MTU-change-with-stmmac-interface-running/20220717-025128
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 2acd1022549e210edc4cfc9fc65b07b88751f0d9
config: arc-randconfig-r043-20220717 (https://download.01.org/0day-ci/archive/20220717/202207170636.Ism1wGe8-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/acdac2fef543d7b7fc85c7a5627e5e833ee756d8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Christian-Marangi/Add-MTU-change-with-stmmac-interface-running/20220717-025128
        git checkout acdac2fef543d7b7fc85c7a5627e5e833ee756d8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/build_bug.h:5,
                    from include/linux/container_of.h:5,
                    from include/linux/list.h:5,
                    from include/linux/timer.h:5,
                    from include/linux/workqueue.h:9,
                    from include/net/pkt_cls.h:6,
                    from drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c:7:
   drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c: In function 'tc_setup_etf':
>> drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c:1094:19: error: 'struct stmmac_priv' has no member named 'tx_queue'
    1094 |         if (!(priv->tx_queue[qopt->queue].tbs & STMMAC_TBS_AVAIL))
         |                   ^~
   include/linux/compiler.h:58:52: note: in definition of macro '__trace_if_var'
      58 | #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
         |                                                    ^~~~
   drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c:1094:9: note: in expansion of macro 'if'
    1094 |         if (!(priv->tx_queue[qopt->queue].tbs & STMMAC_TBS_AVAIL))
         |         ^~
>> drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c:1094:19: error: 'struct stmmac_priv' has no member named 'tx_queue'
    1094 |         if (!(priv->tx_queue[qopt->queue].tbs & STMMAC_TBS_AVAIL))
         |                   ^~
   include/linux/compiler.h:58:61: note: in definition of macro '__trace_if_var'
      58 | #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
         |                                                             ^~~~
   drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c:1094:9: note: in expansion of macro 'if'
    1094 |         if (!(priv->tx_queue[qopt->queue].tbs & STMMAC_TBS_AVAIL))
         |         ^~
>> drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c:1094:19: error: 'struct stmmac_priv' has no member named 'tx_queue'
    1094 |         if (!(priv->tx_queue[qopt->queue].tbs & STMMAC_TBS_AVAIL))
         |                   ^~
   include/linux/compiler.h:69:10: note: in definition of macro '__trace_if_value'
      69 |         (cond) ?                                        \
         |          ^~~~
   include/linux/compiler.h:56:28: note: in expansion of macro '__trace_if_var'
      56 | #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
         |                            ^~~~~~~~~~~~~~
   drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c:1094:9: note: in expansion of macro 'if'
    1094 |         if (!(priv->tx_queue[qopt->queue].tbs & STMMAC_TBS_AVAIL))
         |         ^~
   drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c:1098:21: error: 'struct stmmac_priv' has no member named 'tx_queue'
    1098 |                 priv->tx_queue[qopt->queue].tbs |= STMMAC_TBS_EN;
         |                     ^~
   drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c:1100:21: error: 'struct stmmac_priv' has no member named 'tx_queue'
    1100 |                 priv->tx_queue[qopt->queue].tbs &= ~STMMAC_TBS_EN;
         |                     ^~


vim +1094 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c

b60189e0392fa0 Jose Abreu 2019-12-18  1086  
430b383c737ca0 Jose Abreu 2020-01-13  1087  static int tc_setup_etf(struct stmmac_priv *priv,
430b383c737ca0 Jose Abreu 2020-01-13  1088  			struct tc_etf_qopt_offload *qopt)
430b383c737ca0 Jose Abreu 2020-01-13  1089  {
430b383c737ca0 Jose Abreu 2020-01-13  1090  	if (!priv->dma_cap.tbssel)
430b383c737ca0 Jose Abreu 2020-01-13  1091  		return -EOPNOTSUPP;
430b383c737ca0 Jose Abreu 2020-01-13  1092  	if (qopt->queue >= priv->plat->tx_queues_to_use)
430b383c737ca0 Jose Abreu 2020-01-13  1093  		return -EINVAL;
430b383c737ca0 Jose Abreu 2020-01-13 @1094  	if (!(priv->tx_queue[qopt->queue].tbs & STMMAC_TBS_AVAIL))
430b383c737ca0 Jose Abreu 2020-01-13  1095  		return -EINVAL;
430b383c737ca0 Jose Abreu 2020-01-13  1096  
430b383c737ca0 Jose Abreu 2020-01-13  1097  	if (qopt->enable)
430b383c737ca0 Jose Abreu 2020-01-13  1098  		priv->tx_queue[qopt->queue].tbs |= STMMAC_TBS_EN;
430b383c737ca0 Jose Abreu 2020-01-13  1099  	else
430b383c737ca0 Jose Abreu 2020-01-13  1100  		priv->tx_queue[qopt->queue].tbs &= ~STMMAC_TBS_EN;
430b383c737ca0 Jose Abreu 2020-01-13  1101  
430b383c737ca0 Jose Abreu 2020-01-13  1102  	netdev_info(priv->dev, "%s ETF for Queue %d\n",
430b383c737ca0 Jose Abreu 2020-01-13  1103  		    qopt->enable ? "enabled" : "disabled", qopt->queue);
430b383c737ca0 Jose Abreu 2020-01-13  1104  	return 0;
430b383c737ca0 Jose Abreu 2020-01-13  1105  }
430b383c737ca0 Jose Abreu 2020-01-13  1106  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
