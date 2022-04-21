Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A21509849
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 09:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378569AbiDUGwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 02:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385254AbiDUGv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 02:51:58 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D26192AB
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 23:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650523586; x=1682059586;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZfiuklJBnzRQbWfTREJyRvY7qS6na55jecAaS7tZZxI=;
  b=fdCK97IoPbql9BGOeDtNVf1H2aArkcL7f00cjk9AiAmRsZHkVzGNsVo0
   mAxpu1AFjNDrCtfcD8pTV+di/xw1AIGENSlgRbmmcqprEalbPpg7El651
   Kgq/KrnlgwseaYoKvTNMgbhbR/lWd+gG0cP+fezQYlkIVyOvH03ClA7hv
   cDuNhcEZFTbf7T8sJn3Jco2xqn2u9BqPqV6L3ppHZsbVdUiB/2Q1s4riP
   niLGy+icULPZ8xmF3NJe0zNsosaZjurJPmP1GhHftG9m6FeiWUINMud62
   8qRs93yHp58Wv0QjHICVBCJl718L8OrwcmGNVXdxHgSXED5Sb4InrpQq5
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="244190516"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="244190516"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 23:45:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="532794650"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 20 Apr 2022 23:45:52 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nhQZb-00082g-PL;
        Thu, 21 Apr 2022 06:45:51 +0000
Date:   Thu, 21 Apr 2022 14:45:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Josua Mayer <josua@solid-run.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, alvaro.karsz@solid-run.com,
        Josua Mayer <josua@solid-run.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 2/3] net: phy: adin: add support for clock output
Message-ID: <202204211324.qgcPMycQ-lkp@intel.com>
References: <20220419102709.26432-3-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419102709.26432-3-josua@solid-run.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Josua,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on robh/for-next]
[also build test WARNING on net/master net-next/master v5.18-rc3 next-20220420]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Josua-Mayer/dt-bindings-net-adin-document-phy-clock-output-properties/20220419-192719
base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
config: openrisc-randconfig-s032-20220420 (https://download.01.org/0day-ci/archive/20220421/202204211324.qgcPMycQ-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/74d856f1c89a6534fd58889f20ad4b481b8191c9
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Josua-Mayer/dt-bindings-net-adin-document-phy-clock-output-properties/20220419-192719
        git checkout 74d856f1c89a6534fd58889f20ad4b481b8191c9
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=openrisc SHELL=/bin/bash drivers/net/phy/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/net/phy/adin.c:448:27: sparse: sparse: Using plain integer as NULL pointer

vim +448 drivers/net/phy/adin.c

   444	
   445	static int adin_config_clk_out(struct phy_device *phydev)
   446	{
   447		struct device *dev = &phydev->mdio.dev;
 > 448		const char *val = 0;
   449		u8 sel = 0;
   450	
   451		device_property_read_string(dev, "adi,phy-output-clock", &val);
   452		if(!val) {
   453			/* property not present, do not enable GP_CLK pin */
   454		} else if(strcmp(val, "25mhz-reference") == 0) {
   455			sel |= ADIN1300_GE_CLK_CFG_25;
   456		} else if(strcmp(val, "125mhz-free-running") == 0) {
   457			sel |= ADIN1300_GE_CLK_CFG_FREE_125;
   458		} else if(strcmp(val, "125mhz-recovered") == 0) {
   459			sel |= ADIN1300_GE_CLK_CFG_RCVR_125;
   460		} else if(strcmp(val, "adaptive-free-running") == 0) {
   461			sel |= ADIN1300_GE_CLK_CFG_HRT_FREE;
   462		} else if(strcmp(val, "adaptive-recovered") == 0) {
   463			sel |= ADIN1300_GE_CLK_CFG_HRT_RCVR;
   464		} else {
   465			phydev_err(phydev, "invalid adi,phy-output-clock\n");
   466			return -EINVAL;
   467		}
   468	
   469		if(device_property_read_bool(dev, "adi,phy-output-reference-clock"))
   470			sel |= ADIN1300_GE_CLK_CFG_REF_EN;
   471	
   472		return phy_modify_mmd(phydev, MDIO_MMD_VEND1, ADIN1300_GE_CLK_CFG_REG,
   473				      ADIN1300_GE_CLK_CFG_MASK, sel);
   474	}
   475	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
