Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F965A2F22
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 20:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344764AbiHZSqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 14:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344593AbiHZSpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 14:45:55 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9626CEEF03;
        Fri, 26 Aug 2022 11:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661539341; x=1693075341;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8y01OaWeZKCTB9z6kjJxT3Ord1ZClF8Fg5c7HZIUHxc=;
  b=GBeBggYkdcHev4LmpjFR0hS9843kZ9d3S+tlA+BuCRgwRmdoAeJ4YA3V
   Uyvd2TW46XHyuoQG06ToqWsvP1xCA6MYZ/xJ+w6UGQSG1lyx1R6lMRSfl
   IN186mFG5J1teIgTODaQv7Gq2AtS67qgR6zbpgBajrk7esMuVMFy4O68O
   p8yb2Y/LhzgXeHmO/b1WkXGZHhXjxnISRK4pRE1d0p88Fh/13EfvM5Dj5
   Kp/qZ+Rnwi6b2FiiWO5Bddnxm4KKkBtJtoe5NbfaLGHImqYLD1H21Lb7k
   a5oF6HRm5/1i2kKQ7YC/pI8h1LjwkXeC2TJiWJj89aVLyW8GIWHExSCHM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10451"; a="293314560"
X-IronPort-AV: E=Sophos;i="5.93,266,1654585200"; 
   d="scan'208";a="293314560"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 11:42:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,266,1654585200"; 
   d="scan'208";a="561534400"
Received: from lkp-server01.sh.intel.com (HELO 71b0d3b5b1bc) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 26 Aug 2022 11:42:13 -0700
Received: from kbuild by 71b0d3b5b1bc with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oReHQ-0000HT-2E;
        Fri, 26 Aug 2022 18:42:08 +0000
Date:   Sat, 27 Aug 2022 02:41:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     kbuild-all@lists.01.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v3 1/5] net: ipqess: introduce the Qualcomm
 IPQESS driver
Message-ID: <202208270238.v4dYsRet-lkp@intel.com>
References: <20220826154650.615582-2-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826154650.615582-2-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Maxime-Chevallier/net-ipqess-introduce-Qualcomm-IPQESS-driver/20220826-234846
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 44387d1736c40a74085be354e2b5f37ca0689608
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20220827/202208270238.v4dYsRet-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/7a04850338791b6a0d192df5be0e4317e6961fc4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Maxime-Chevallier/net-ipqess-introduce-Qualcomm-IPQESS-driver/20220826-234846
        git checkout 7a04850338791b6a0d192df5be0e4317e6961fc4
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/device.h:15,
                    from include/linux/dma-mapping.h:7,
                    from include/linux/skbuff.h:31,
                    from include/net/net_namespace.h:43,
                    from include/linux/netdevice.h:38,
                    from include/linux/if_vlan.h:10,
                    from drivers/net/ethernet/qualcomm/ipqess/ipqess.c:12:
   drivers/net/ethernet/qualcomm/ipqess/ipqess.c: In function 'ipqess_rx_buf_prepare':
>> drivers/net/ethernet/qualcomm/ipqess/ipqess.c:180:30: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'dma_addr_t' {aka 'long long unsigned int'} [-Wformat=]
     180 |                              "IPQESS DMA mapping failed for linear address %x",
         |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:110:30: note: in definition of macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                              ^~~
   include/linux/dev_printk.h:144:56: note: in expansion of macro 'dev_fmt'
     144 |         dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                                                        ^~~~~~~
   include/linux/dev_printk.h:174:17: note: in expansion of macro 'dev_err'
     174 |                 dev_level(dev, fmt, ##__VA_ARGS__);                     \
         |                 ^~~~~~~~~
   include/linux/dev_printk.h:192:9: note: in expansion of macro 'dev_level_once'
     192 |         dev_level_once(dev_err, dev, fmt, ##__VA_ARGS__)
         |         ^~~~~~~~~~~~~~
   drivers/net/ethernet/qualcomm/ipqess/ipqess.c:179:17: note: in expansion of macro 'dev_err_once'
     179 |                 dev_err_once(rx_ring->ppdev,
         |                 ^~~~~~~~~~~~
   drivers/net/ethernet/qualcomm/ipqess/ipqess.c:180:77: note: format string is defined here
     180 |                              "IPQESS DMA mapping failed for linear address %x",
         |                                                                            ~^
         |                                                                             |
         |                                                                             unsigned int
         |                                                                            %llx
   drivers/net/ethernet/qualcomm/ipqess/ipqess.c: In function 'ipqess_axi_probe':
>> drivers/net/ethernet/qualcomm/ipqess/ipqess.c:1181:29: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    1181 |         netdev->base_addr = (u32)ess->hw_addr;
         |                             ^


vim +180 drivers/net/ethernet/qualcomm/ipqess/ipqess.c

   170	
   171	static int ipqess_rx_buf_prepare(struct ipqess_buf *buf,
   172					 struct ipqess_rx_ring *rx_ring)
   173	{
   174		memset(buf->skb->data, 0, sizeof(struct ipqess_rx_desc));
   175	
   176		buf->dma = dma_map_single(rx_ring->ppdev, buf->skb->data,
   177					  IPQESS_RX_HEAD_BUFF_SIZE, DMA_FROM_DEVICE);
   178		if (dma_mapping_error(rx_ring->ppdev, buf->dma)) {
   179			dev_err_once(rx_ring->ppdev,
 > 180				     "IPQESS DMA mapping failed for linear address %x",
   181				     buf->dma);
   182			dev_kfree_skb_any(buf->skb);
   183			buf->skb = NULL;
   184			return -EFAULT;
   185		}
   186	
   187		buf->length = IPQESS_RX_HEAD_BUFF_SIZE;
   188		rx_ring->hw_desc[rx_ring->head] = (struct ipqess_rx_desc *)buf->dma;
   189		rx_ring->head = (rx_ring->head + 1) % IPQESS_RX_RING_SIZE;
   190	
   191		ipqess_m32(rx_ring->ess, IPQESS_RFD_PROD_IDX_BITS,
   192			   (rx_ring->head + IPQESS_RX_RING_SIZE - 1) % IPQESS_RX_RING_SIZE,
   193			   IPQESS_REG_RFD_IDX_Q(rx_ring->idx));
   194	
   195		return 0;
   196	}
   197	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
