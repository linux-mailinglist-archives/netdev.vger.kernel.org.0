Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D34530DB3
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbiEWJPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 05:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbiEWJPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 05:15:01 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A7B47394;
        Mon, 23 May 2022 02:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653297300; x=1684833300;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rSp8OAS9Z+rAmZ/IeViGc7ucpC+E1jdk1BjrMYZI1Yo=;
  b=dm6GVQ26uthFwFzm1ArwpxcI7/IsEwoYm5RcdDbxAlxzg8ukNHfs/VoA
   AGE4A79O4R04Dc9iwkacjdgPis8fxbkxu/Ge/03KHrKzhLwOgPCy9FM2z
   2yTkCC9GLKrUHP+KOGejpls8/CLfIij8kKKBPAqlkEnuH988tMg7lMNiS
   PdHSq6iz96AFQ9tX9JHiSRUXtP9C02GedTtKnRzY5v8UxiyYVYpLAF4K3
   yaE2BloCJLlYRRI11fGl+FD9OvMFA6ROtHvoyJAre9nR2TbdjNVYwV51e
   UwgBcEcjxjfX/joVXRmoO8HLvJV1J8InZbRkg1k55xP4F/gy2mvss3bdX
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10355"; a="253664520"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="253664520"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 02:14:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="558557154"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 23 May 2022 02:14:50 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nt49K-00011I-1K;
        Mon, 23 May 2022 09:14:50 +0000
Date:   Mon, 23 May 2022 17:13:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Corentin Labbe <clabbe@baylibre.com>, andrew@lunn.ch,
        broonie@kernel.org, calvin.johnson@oss.nxp.com,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        netdev@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: Re: [PATCH v3 2/3] phy: handle optional regulator for PHY
Message-ID: <202205231735.QGDB1Mcy-lkp@intel.com>
References: <20220523052807.4044800-3-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523052807.4044800-3-clabbe@baylibre.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Corentin,

I love your patch! Perhaps something to improve:

[auto build test WARNING on broonie-regulator/for-next]
[also build test WARNING on sunxi/sunxi/for-next linus/master v5.18 next-20220520]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Corentin-Labbe/arm64-add-ethernet-to-orange-pi-3/20220523-133344
base:   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-next
config: mips-cu1830-neo_defconfig (https://download.01.org/0day-ci/archive/20220523/202205231735.QGDB1Mcy-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 768a1ca5eccb678947f4155e38a5f5744dcefb56)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install mips cross compiling tool for clang build
        # apt-get install binutils-mips-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/7ae2ab7d1efe8091f6b7ea048a7ac495afba9e46
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Corentin-Labbe/arm64-add-ethernet-to-orange-pi-3/20220523-133344
        git checkout 7ae2ab7d1efe8091f6b7ea048a7ac495afba9e46
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash drivers/net/mdio/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from drivers/net/mdio/of_mdio.c:13:
>> include/linux/fwnode_mdio.h:20:5: warning: no previous prototype for function 'fwnode_mdiobus_phy_device_register' [-Wmissing-prototypes]
   int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
       ^
   include/linux/fwnode_mdio.h:20:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
   ^
   static 
   1 warning generated.


vim +/fwnode_mdiobus_phy_device_register +20 include/linux/fwnode_mdio.h

bc1bee3b87ee48b Calvin Johnson 2021-06-11  10  
bc1bee3b87ee48b Calvin Johnson 2021-06-11  11  #if IS_ENABLED(CONFIG_FWNODE_MDIO)
bc1bee3b87ee48b Calvin Johnson 2021-06-11  12  int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
bc1bee3b87ee48b Calvin Johnson 2021-06-11  13  				       struct phy_device *phy,
bc1bee3b87ee48b Calvin Johnson 2021-06-11  14  				       struct fwnode_handle *child, u32 addr);
bc1bee3b87ee48b Calvin Johnson 2021-06-11  15  
bc1bee3b87ee48b Calvin Johnson 2021-06-11  16  int fwnode_mdiobus_register_phy(struct mii_bus *bus,
bc1bee3b87ee48b Calvin Johnson 2021-06-11  17  				struct fwnode_handle *child, u32 addr);
bc1bee3b87ee48b Calvin Johnson 2021-06-11  18  
bc1bee3b87ee48b Calvin Johnson 2021-06-11  19  #else /* CONFIG_FWNODE_MDIO */
bc1bee3b87ee48b Calvin Johnson 2021-06-11 @20  int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
bc1bee3b87ee48b Calvin Johnson 2021-06-11  21  				       struct phy_device *phy,
bc1bee3b87ee48b Calvin Johnson 2021-06-11  22  				       struct fwnode_handle *child, u32 addr)
bc1bee3b87ee48b Calvin Johnson 2021-06-11  23  {
bc1bee3b87ee48b Calvin Johnson 2021-06-11  24  	return -EINVAL;
bc1bee3b87ee48b Calvin Johnson 2021-06-11  25  }
bc1bee3b87ee48b Calvin Johnson 2021-06-11  26  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
