Return-Path: <netdev+bounces-1450-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B7696FDCD4
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:36:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 518CE1C20D30
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D49DDB7;
	Wed, 10 May 2023 11:36:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F013D60
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:36:54 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834A67DBD;
	Wed, 10 May 2023 04:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683718594; x=1715254594;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OIHMQRBUSAAIKqFfKJ0b5Sjxv6B77OgJnTeBhK6P5aQ=;
  b=dXBGBh5R/o3DNHsgtLR5PAgJEaS6vokq+bbHJWyges3p7jCX5REzbD++
   5iC3umMYUQQQX1JpcGRAV8OXdApiNEjSfKVUskqMOq56ubax45wvRBTtO
   bafcS7BNPwbJYqwWmv9DeoBlXM19KAW77dRnoS80B2YxZs922UEVYv9Mq
   drqtoSMwXYpeG1ZGXAo7C0eMSIWZA3+bQ51sA/LZeZX6km2U1rY5469Mo
   Z89tMXjyg56LnV8AlqVUphxc5y7V/oXnH4e7Ca5av7OrM4CCIS2NC1dfJ
   prZ49O77EoN4kv6soGDQ9QGdsnxUG8xj4tiW7S+uzbuDHwYIBqCEbl2EP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="347651912"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="347651912"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 04:36:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="764253680"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="764253680"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 10 May 2023 04:36:29 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pwi7Q-0003EC-2a;
	Wed, 10 May 2023 11:36:28 +0000
Date: Wed, 10 May 2023 19:36:19 +0800
From: kernel test robot <lkp@intel.com>
To: Yan Wang <rk.code@outlook.com>, andrew@lunn.ch, hkallweit1@gmail.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux@armlinux.org.uk
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Yan Wang <rk.code@outlook.com>
Subject: Re: [PATCH v3] net: mdiobus: Add a function to deassert reset
Message-ID: <202305101922.dXHLqoSw-lkp@intel.com>
References: <KL1PR01MB5448A33A549CDAD7D68945B9E6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <KL1PR01MB5448A33A549CDAD7D68945B9E6779@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Yan,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]
[also build test ERROR on net/main linus/master v6.4-rc1 next-20230510]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yan-Wang/net-mdiobus-Add-a-function-to-deassert-reset/20230510-161736
base:   net-next/main
patch link:    https://lore.kernel.org/r/KL1PR01MB5448A33A549CDAD7D68945B9E6779%40KL1PR01MB5448.apcprd01.prod.exchangelabs.com
patch subject: [PATCH v3] net: mdiobus: Add a function to deassert reset
config: x86_64-randconfig-a003 (https://download.01.org/0day-ci/archive/20230510/202305101922.dXHLqoSw-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f7ded94d887d1020adb4813c2b1025142288e882
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yan-Wang/net-mdiobus-Add-a-function-to-deassert-reset/20230510-161736
        git checkout f7ded94d887d1020adb4813c2b1025142288e882
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/mdio/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305101922.dXHLqoSw-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/mdio/fwnode_mdio.c:64:10: error: implicit declaration of function 'fwnode_gpiod_get_index' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
           reset = fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_HIGH, NULL);
                   ^
>> drivers/net/mdio/fwnode_mdio.c:64:53: error: use of undeclared identifier 'GPIOD_OUT_HIGH'
           reset = fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_HIGH, NULL);
                                                              ^
>> drivers/net/mdio/fwnode_mdio.c:69:2: error: implicit declaration of function 'gpiod_set_value_cansleep' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
           gpiod_set_value_cansleep(reset, 0);
           ^
>> drivers/net/mdio/fwnode_mdio.c:71:2: error: implicit declaration of function 'gpiod_put' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
           gpiod_put(reset);
           ^
   4 errors generated.


vim +/fwnode_gpiod_get_index +64 drivers/net/mdio/fwnode_mdio.c

    59	
    60	static void fwnode_mdiobus_pre_enable_phy(struct fwnode_handle *fwnode)
    61	{
    62		struct gpio_desc *reset;
    63	
  > 64		reset = fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_HIGH, NULL);
    65		if (IS_ERR(reset) && PTR_ERR(reset) != -EPROBE_DEFER)
    66			return;
    67	
    68		usleep_range(100, 200);
  > 69		gpiod_set_value_cansleep(reset, 0);
    70		/*Release the reset pin,it needs to be registered with the PHY.*/
  > 71		gpiod_put(reset);
    72	}
    73	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

