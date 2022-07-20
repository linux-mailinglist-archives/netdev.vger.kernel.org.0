Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6431C57B379
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 11:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiGTJId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 05:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiGTJIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 05:08:32 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7800C48C8C;
        Wed, 20 Jul 2022 02:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658308111; x=1689844111;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y8/mcRCZPyCGIyoGEwHXJ1tzZEoycqJ4yx/t97a/K2g=;
  b=I5X43HhemifFggfrOvKbq4E+WM8IpAisFqmsCMenMMoHf5LC/r2H1anr
   mY9rZ93KGzwblH06jMGWLsJcshYRoE+MAGbebI4FwH5gfGD68Z2SefgE6
   o9zXpJ2r+mzaLlpe92xBl+LNQKA6pNJHScad63hX7737Qd3BdqoPf6peC
   TRjKQzEWeLxc1w6tTtQTCaHW+0xvxtB0OerXQk+fBHlfg8ZV1s7Y14C5b
   y6yftIimNnn1nFQ0X8Aasa6zsqyHcJsmUYYGCqDi3XWh/ii8RGQpaRuTD
   kmSCsz8nZNvT2cx7uq65OpdVe0g9ECEVTiLsXqbTpEo52JST+757ClDrF
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="286733897"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="286733897"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 02:08:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="724588959"
Received: from lkp-server01.sh.intel.com (HELO 7dfbdc7c7900) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 20 Jul 2022 02:08:20 -0700
Received: from kbuild by 7dfbdc7c7900 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oE5gp-0000Jp-RI;
        Wed, 20 Jul 2022 09:08:19 +0000
Date:   Wed, 20 Jul 2022 17:08:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH v2 07/11] net: phylink: Adjust link settings based on
 rate adaptation
Message-ID: <202207201640.6pB23GJN-lkp@intel.com>
References: <20220719235002.1944800-8-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719235002.1944800-8-sean.anderson@seco.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on net/master horms-ipvs/master linus/master v5.19-rc7 next-20220719]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sean-Anderson/net-phy-Add-support-for-rate-adaptation/20220720-075438
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 1f17708b47a99ca5bcad594a6f8d14cb016edfd2
config: x86_64-randconfig-a005 (https://download.01.org/0day-ci/archive/20220720/202207201640.6pB23GJN-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project dd5635541cd7bbd62cd59b6694dfb759b6e9a0d8)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/a17fd2b01914c1c5779a76167def6910a6dd1185
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sean-Anderson/net-phy-Add-support-for-rate-adaptation/20220720-075438
        git checkout a17fd2b01914c1c5779a76167def6910a6dd1185
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "phy_rate_adaptation_to_str" [drivers/net/phy/phylink.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
