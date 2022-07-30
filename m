Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAB4585C61
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 23:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236013AbiG3Vk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 17:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbiG3Vky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 17:40:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AFC12A9F;
        Sat, 30 Jul 2022 14:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659217253; x=1690753253;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=V5fo+ZjN6qVh2ehdMQ8scHgdijFwALwamZEruMT0vWg=;
  b=R4QRzfnUwQq5gBBuZajMaNVxanjW0gIDATuLQfElk5604pR+L+RA2Gr5
   BfGVmnYY/SVQJbkmyUE2wXp2+cJ7Xdwkc8FuB2OKWSaQPMJU/GOigkXXD
   PeJrYxCtUAGvRjPR2HEe9lYy6mfiXijeMkC7D5zS9eU/nHRG/oShZKNJC
   s+L/DSs0Unf7PBgplQTbB0uAnwNwTToG8hHjfxJvSs4IY1T2tkJGxb9Ku
   L0wNoNMxKYVGAUlpRVyTX/4SHDzbffADWStxb9fFWx6ezfG/Mz8W6+0/l
   Ft9Re3dJvClhNhVqQjur9jONXrAd34twWw3qZqNI4NUL6JZG/TwSW9ksI
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10424"; a="375251665"
X-IronPort-AV: E=Sophos;i="5.93,205,1654585200"; 
   d="scan'208";a="375251665"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2022 14:40:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,205,1654585200"; 
   d="scan'208";a="605278720"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jul 2022 14:40:49 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oHuCW-000DN9-0o;
        Sat, 30 Jul 2022 21:40:48 +0000
Date:   Sun, 31 Jul 2022 05:40:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        andriy.shevchenko@linux.intel.com, vee.khee.wong@intel.com,
        weifeng.voon@intel.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] stmmac: intel: Add a missing clk_disable_unprepare()
 call in intel_eth_pci_remove()
Message-ID: <202207310531.48IGPx8Z-lkp@intel.com>
References: <b5b44a0c025d0fdddd9b9d23153261363089a06a.1659204745.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5b44a0c025d0fdddd9b9d23153261363089a06a.1659204745.git.christophe.jaillet@wanadoo.fr>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.19-rc8 next-20220728]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Christophe-JAILLET/stmmac-intel-Add-a-missing-clk_disable_unprepare-call-in-intel_eth_pci_remove/20220731-022139
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 620725263f4222b3c94d4ee19846835feec0ad69
config: x86_64-randconfig-a003 (https://download.01.org/0day-ci/archive/20220731/202207310531.48IGPx8Z-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 52cd00cabf479aa7eb6dbb063b7ba41ea57bce9e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/2d1d09034cc62ee19f799b92bb67640ba86ca557
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Christophe-JAILLET/stmmac-intel-Add-a-missing-clk_disable_unprepare-call-in-intel_eth_pci_remove/20220731-022139
        git checkout 2d1d09034cc62ee19f799b92bb67640ba86ca557
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/ethernet/stmicro/stmmac/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c:1107:24: error: use of undeclared identifier 'plat'
           clk_disable_unprepare(plat->stmmac_clk);
                                 ^
   1 error generated.


vim +/plat +1107 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c

  1092	
  1093	/**
  1094	 * intel_eth_pci_remove
  1095	 *
  1096	 * @pdev: pci device pointer
  1097	 * Description: this function calls the main to free the net resources
  1098	 * and releases the PCI resources.
  1099	 */
  1100	static void intel_eth_pci_remove(struct pci_dev *pdev)
  1101	{
  1102		struct net_device *ndev = dev_get_drvdata(&pdev->dev);
  1103		struct stmmac_priv *priv = netdev_priv(ndev);
  1104	
  1105		stmmac_dvr_remove(&pdev->dev);
  1106	
> 1107		clk_disable_unprepare(plat->stmmac_clk);
  1108		clk_unregister_fixed_rate(priv->plat->stmmac_clk);
  1109	
  1110		pcim_iounmap_regions(pdev, BIT(0));
  1111	}
  1112	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
