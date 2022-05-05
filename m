Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F171551CAC5
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377597AbiEEUqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 16:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbiEEUqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:46:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5CBB841;
        Thu,  5 May 2022 13:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651783348; x=1683319348;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ymzjNgr6wXbJBAQoerxRdvjeszrBU3nmqB3iQd5YQy8=;
  b=koU7yL70toCAj8vk6QNxmLD8q+JlK308b5F0uyF+DNA4GtRn36X3PI5p
   lKqQCe5TzmN5r2KaoAGNt/kpBQSL5DLMlu8HgQaL3nCZ5MUz+YQHzdOf4
   vk3AQlugiTsIZ5G/cuenv0qVdWlpFK8VY8cX4NQ+bz3o0v9ZzxiF3ZmiG
   Gobr7M4xo9OENVZupWgqT4WQtZmIgVan+CsZHFI38A3md1L1dcJySG4D8
   8x5anvhQm514lj7iGSlfyDwUbLqSED5BMCill1JunMDKP4WZuNaRSsGup
   N7AeRatnzYEwY698C8xVwHs+zpIsjqwjkjNIH83vyTxlZgVAeDugfyeaX
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="250235012"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="250235012"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 13:42:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="811896847"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 05 May 2022 13:42:25 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nmiIq-000Ck0-Gs;
        Thu, 05 May 2022 20:42:24 +0000
Date:   Fri, 6 May 2022 04:42:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/7] net: phy: introduce
 genphy_c45_pma_baset1_read_master_slave()
Message-ID: <202205060406.gHnrGdXy-lkp@intel.com>
References: <20220505063318.296280-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505063318.296280-5-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Oleksij-Rempel/add-ti-dp83td510-support/20220505-143922
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 4950b6990e3b1efae64a5f6fc5738d25e3b816b3
config: mips-allyesconfig (https://download.01.org/0day-ci/archive/20220506/202205060406.gHnrGdXy-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/80dad43edb356876484acb116b8a906dd4bef941
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Oleksij-Rempel/add-ti-dp83td510-support/20220505-143922
        git checkout 80dad43edb356876484acb116b8a906dd4bef941
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash drivers/net/phy/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/phy/phy-c45.c:558: warning: expecting prototype for genphy_c45_baset1_read_master_slave(). Prototype was for genphy_c45_pma_baset1_read_master_slave() instead


vim +558 drivers/net/phy/phy-c45.c

   552	
   553	/**
   554	 * genphy_c45_baset1_read_master_slave - read forced master/slave configuration
   555	 * @phydev: target phy_device struct
   556	 */
   557	int genphy_c45_pma_baset1_read_master_slave(struct phy_device *phydev)
 > 558	{
   559		int val;
   560	
   561		phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
   562	
   563		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_PMD_BT1_CTRL);
   564		if (val < 0)
   565			return val;
   566	
   567		if (val & MDIO_PMA_PMD_BT1_CTRL_CFG_MST)
   568			phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
   569		else
   570			phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
   571	
   572		return 0;
   573	}
   574	EXPORT_SYMBOL_GPL(genphy_c45_pma_baset1_read_master_slave);
   575	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
