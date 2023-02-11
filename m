Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D99F692E8B
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 07:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjBKGGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 01:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKGGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 01:06:03 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E9B4DE36;
        Fri, 10 Feb 2023 22:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676095562; x=1707631562;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JMEsPC/F0g+9M4k/jEp0dA2A9EJTETOkzMVm5ZZ6RLI=;
  b=hCmccq62LmD8I7TqlSCMsSny/9gf3PK9ypND5lbBPb+8AX+vF7S2mAwo
   KYH9S//VWkq8qpk0n//TtA9fX+44x+ldl8PhuI1SekGU5Um0X+o1BHDnn
   wwl99P0Us1F9DR2/8ZvgZLYjuHA8dwV9W5vCsD+ispEfMtsUNGsnR2wEj
   Ut9fTZXeejOuHrbAigtOV9QhPRu920ckVZg9Mx3yProWX0rksbwz0Q8Mg
   2HCuzYiv4MEcqC6xkswB7t+qkSBCZDsVyC4BX464wc/jk/RWj0sshumsC
   IMuk89Q+H0tot8Mt1intfTyMBS74TWz5b1fxinuDE0QlIwomntbzvMPbN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="310952423"
X-IronPort-AV: E=Sophos;i="5.97,289,1669104000"; 
   d="scan'208";a="310952423"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 22:06:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="757010576"
X-IronPort-AV: E=Sophos;i="5.97,289,1669104000"; 
   d="scan'208";a="757010576"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Feb 2023 22:05:58 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pQj1J-0006Hl-21;
        Sat, 11 Feb 2023 06:05:57 +0000
Date:   Sat, 11 Feb 2023 14:05:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] net: pcs: tse: port to pcs-lynx
Message-ID: <202302111310.IO2xvRNi-lkp@intel.com>
References: <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210190949.1115836-1-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Maxime-Chevallier/net-pcs-tse-port-to-pcs-lynx/20230211-021544
patch link:    https://lore.kernel.org/r/20230210190949.1115836-1-maxime.chevallier%40bootlin.com
patch subject: [PATCH net-next] net: pcs: tse: port to pcs-lynx
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20230211/202302111310.IO2xvRNi-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/fc34f36dac37aedc9928f351a233c6f610fd5a68
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Maxime-Chevallier/net-pcs-tse-port-to-pcs-lynx/20230211-021544
        git checkout fc34f36dac37aedc9928f351a233c6f610fd5a68
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302111310.IO2xvRNi-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "alt_tse_pcs_create" [drivers/net/ethernet/altera/altera_tse.ko] undefined!
>> ERROR: modpost: "alt_tse_pcs_destroy" [drivers/net/ethernet/altera/altera_tse.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
