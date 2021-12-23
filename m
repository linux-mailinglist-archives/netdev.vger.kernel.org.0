Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249CB47DDE1
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 03:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242498AbhLWCz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 21:55:29 -0500
Received: from mga05.intel.com ([192.55.52.43]:61444 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229788AbhLWCz3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 21:55:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640228129; x=1671764129;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G87KUt6i7K66GwuWvCDQqDz2ZNFtFO6Fz15I0vXXysg=;
  b=FCkAYBqnwTyAfjIOg/xliYNi/DD9RX3IBIJUaAVAwI6bct+rLrertFX9
   4xCM9M6KWGd8uZKmWzoeVI7RG+lK5X1QzBAd5/9sdYYddbswgPEy7CzJV
   OlB9iHSFLDGPITc22NiO8SqTETPxh9KHAiQk+CyL6F2l59JWiGciDmzs8
   7/w2GDVQ27N6cbOOshVclxnTPwZxbrRGeKlArGWJTMHfOawhKFqzzo6xM
   eo+4Htz3+0wDlvrK351xNI2OtbLMRmptb6BFdWo+wxl23Nb6bxop/Lv/g
   TTcHW02GU+y71JHExb0bf9PznG+H5OT7iuBJuzQ8kCZ1gAMyEBwCD/eYl
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="327051091"
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="327051091"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 18:55:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="664453047"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 22 Dec 2021 18:55:14 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n0EGA-0001Hw-51; Thu, 23 Dec 2021 02:55:14 +0000
Date:   Thu, 23 Dec 2021 10:54:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     cgel.zte@gmail.com, thomas.petazzoni@bootlin.com
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net: mvneta: use min() to make code cleaner
Message-ID: <202112231021.c93ilPDO-lkp@intel.com>
References: <20211220113648.473204-1-deng.changcheng@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220113648.473204-1-deng.changcheng@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master horms-ipvs/master linus/master v5.16-rc6 next-20211222]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/cgel-zte-gmail-com/net-mvneta-use-min-to-make-code-cleaner/20211220-193846
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 434ed21389948a45c238f63258bd5aae4237e20b
config: sh-randconfig-s032-20211222 (https://download.01.org/0day-ci/archive/20211223/202112231021.c93ilPDO-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/be0462f87c94afd5304c286f4b7041e92f5df0bd
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/net-mvneta-use-min-to-make-code-cleaner/20211220-193846
        git checkout be0462f87c94afd5304c286f4b7041e92f5df0bd
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=sh SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   drivers/net/ethernet/marvell/mvneta.c:1787:25: sparse: sparse: restricted __be16 degrades to integer
   drivers/net/ethernet/marvell/mvneta.c:1969:45: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected int l3_proto @@     got restricted __be16 [usertype] l3_proto @@
   drivers/net/ethernet/marvell/mvneta.c:1969:45: sparse:     expected int l3_proto
   drivers/net/ethernet/marvell/mvneta.c:1969:45: sparse:     got restricted __be16 [usertype] l3_proto
>> drivers/net/ethernet/marvell/mvneta.c:4637:28: sparse: sparse: incompatible types in comparison expression (different signedness):
>> drivers/net/ethernet/marvell/mvneta.c:4637:28: sparse:    unsigned int *
>> drivers/net/ethernet/marvell/mvneta.c:4637:28: sparse:    int *

vim +4637 drivers/net/ethernet/marvell/mvneta.c

  4626	
  4627	static int
  4628	mvneta_ethtool_set_ringparam(struct net_device *dev,
  4629				     struct ethtool_ringparam *ring,
  4630				     struct kernel_ethtool_ringparam *kernel_ring,
  4631				     struct netlink_ext_ack *extack)
  4632	{
  4633		struct mvneta_port *pp = netdev_priv(dev);
  4634	
  4635		if ((ring->rx_pending == 0) || (ring->tx_pending == 0))
  4636			return -EINVAL;
> 4637		pp->rx_ring_size = min(ring->rx_pending, MVNETA_MAX_RXD);
  4638	
  4639		pp->tx_ring_size = clamp_t(u16, ring->tx_pending,
  4640					   MVNETA_MAX_SKB_DESCS * 2, MVNETA_MAX_TXD);
  4641		if (pp->tx_ring_size != ring->tx_pending)
  4642			netdev_warn(dev, "TX queue size set to %u (requested %u)\n",
  4643				    pp->tx_ring_size, ring->tx_pending);
  4644	
  4645		if (netif_running(dev)) {
  4646			mvneta_stop(dev);
  4647			if (mvneta_open(dev)) {
  4648				netdev_err(dev,
  4649					   "error on opening device after ring param change\n");
  4650				return -ENOMEM;
  4651			}
  4652		}
  4653	
  4654		return 0;
  4655	}
  4656	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
