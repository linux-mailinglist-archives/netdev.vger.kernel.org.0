Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093494C8951
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbiCAKbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiCAKbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:31:00 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EE55E164;
        Tue,  1 Mar 2022 02:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646130619; x=1677666619;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qjMQe44OgAQj153g2DNzxJPxNFnNII9PaZptrJHxDWo=;
  b=XNYmu1NVTGXXcPJ2XWKCF3oF5I1wGDyW1e7/tWfpBJh2qhbxq30k1Jd/
   km6E8n6H5IOykWIqPuLkPcXQx3AOKrilgTytrBWz9kn7vnWYGI617YMd0
   Z+rdSGFEYyDggFGrLCa3Uo9SJJGwMX3oq7a+GmDd0fl/t5wVFUJnEkFS+
   9PPzmjFXCT+R8zW6Tym/ePdGrQLaeHaRUeaJ3yaGxK/j93INGZmnmjpzq
   IarzHPrjDGVZnP/IalwqNBIxfL3XT5khlWB6iXdA6J+mnHqQKVqODdyVc
   kIqkP0QIp33b4SlF93ol5j+OVtoli9hAC5SdC/M+wPxOH+ZAj5a64G6Tl
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="233722775"
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="233722775"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 02:30:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="709002733"
Received: from lkp-server01.sh.intel.com (HELO 2146afe809fb) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 01 Mar 2022 02:30:16 -0800
Received: from kbuild by 2146afe809fb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nOzln-0000IJ-Ag; Tue, 01 Mar 2022 10:30:15 +0000
Date:   Tue, 1 Mar 2022 18:29:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Haowen Bai <baihaowen88@gmail.com>,
        sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haowen Bai <baihaowen88@gmail.com>
Subject: Re: [PATCH] net: marvell: Use min() instead of doing it manually
Message-ID: <202203011855.FRrOViok-lkp@intel.com>
References: <1646115417-24639-1-git-send-email-baihaowen88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1646115417-24639-1-git-send-email-baihaowen88@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Haowen,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master horms-ipvs/master linus/master v5.17-rc6 next-20220228]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Haowen-Bai/net-marvell-Use-min-instead-of-doing-it-manually/20220301-141800
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git f2b77012ddd5b2532d262f100be3394ceae3ea59
config: hexagon-randconfig-r041-20220301 (https://download.01.org/0day-ci/archive/20220301/202203011855.FRrOViok-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/55e43d9d6e3e0a8774e6a5e3976808e5736f6c9f
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Haowen-Bai/net-marvell-Use-min-instead-of-doing-it-manually/20220301-141800
        git checkout 55e43d9d6e3e0a8774e6a5e3976808e5736f6c9f
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/net/ethernet/marvell/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/marvell/mv643xx_eth.c:1664:21: warning: comparison of distinct pointer types ('typeof (er->rx_pending) *' (aka 'unsigned int *') and 'typeof (4096) *' (aka 'int *')) [-Wcompare-distinct-pointer-types]
           mp->rx_ring_size = min(er->rx_pending, 4096);
                              ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:45:19: note: expanded from macro 'min'
   #define min(x, y)       __careful_cmp(x, y, <)
                           ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:36:24: note: expanded from macro '__careful_cmp'
           __builtin_choose_expr(__safe_cmp(x, y), \
                                 ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:26:4: note: expanded from macro '__safe_cmp'
                   (__typecheck(x, y) && __no_side_effects(x, y))
                    ^~~~~~~~~~~~~~~~~
   include/linux/minmax.h:20:28: note: expanded from macro '__typecheck'
           (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
                      ~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~
   1 warning generated.


vim +1664 drivers/net/ethernet/marvell/mv643xx_eth.c

  1653	
  1654	static int
  1655	mv643xx_eth_set_ringparam(struct net_device *dev, struct ethtool_ringparam *er,
  1656				  struct kernel_ethtool_ringparam *kernel_er,
  1657				  struct netlink_ext_ack *extack)
  1658	{
  1659		struct mv643xx_eth_private *mp = netdev_priv(dev);
  1660	
  1661		if (er->rx_mini_pending || er->rx_jumbo_pending)
  1662			return -EINVAL;
  1663	
> 1664		mp->rx_ring_size = min(er->rx_pending, 4096);
  1665		mp->tx_ring_size = clamp_t(unsigned int, er->tx_pending,
  1666					   MV643XX_MAX_SKB_DESCS * 2, 4096);
  1667		if (mp->tx_ring_size != er->tx_pending)
  1668			netdev_warn(dev, "TX queue size set to %u (requested %u)\n",
  1669				    mp->tx_ring_size, er->tx_pending);
  1670	
  1671		if (netif_running(dev)) {
  1672			mv643xx_eth_stop(dev);
  1673			if (mv643xx_eth_open(dev)) {
  1674				netdev_err(dev,
  1675					   "fatal error on re-opening device after ring param change\n");
  1676				return -ENOMEM;
  1677			}
  1678		}
  1679	
  1680		return 0;
  1681	}
  1682	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
