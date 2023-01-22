Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA9D676AF4
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 04:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjAVDGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 22:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjAVDGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 22:06:13 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A651F5F9
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 19:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674356772; x=1705892772;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=baVItVo7YTQD1JZPevKfW4PCBqOLIXY5TIziHObz3f4=;
  b=gUf2ZoX3ZSfzuiZzkM0RjbUa4dxyH++wf1HE+G9+QqWKMl7gWVduo014
   le995xb/jdBvmRO0/8swECHPDTmIHJ8JkI+uw/qu8Ha2quNAkr51nCYiU
   jmko6zhgRGNWoDBAESw6a4isqHVy/XdGyadrxjGCoSZJntAisp3NZCrTZ
   0DyQojSPZ0BS35E0SgY8Jsxb2vrhWkhNWpEZYTfJVzmwpoQOtJjsK9ujp
   Uf1wkLvtqW12jAaGfxcyveERFw5Sa1JrM1aShWT8H9SktU99v9wCs6acY
   ugVGF2VzPoFGz2XlnHIYFzSQqiEAtcsGPD6ZI5jzzSP2bKcUMyzNvUgTk
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10597"; a="388221029"
X-IronPort-AV: E=Sophos;i="5.97,235,1669104000"; 
   d="scan'208";a="388221029"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2023 19:06:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10597"; a="906392425"
X-IronPort-AV: E=Sophos;i="5.97,235,1669104000"; 
   d="scan'208";a="906392425"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 21 Jan 2023 19:06:10 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pJQgM-0004hc-09;
        Sun, 22 Jan 2023 03:06:10 +0000
Date:   Sun, 22 Jan 2023 11:05:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        mengyuanlou@net-swift.com
Cc:     oe-kbuild-all@lists.linux.dev, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: Re: [PATCH net-next 05/10] net: libwx: Allocate Rx and Tx resources
Message-ID: <202301221047.SBlK8xvt-lkp@intel.com>
References: <20230118065504.3075474-6-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118065504.3075474-6-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiawen,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawen-Wu/net-libwx-Add-irq-flow-functions/20230118-154258
patch link:    https://lore.kernel.org/r/20230118065504.3075474-6-jiawenwu%40trustnetic.com
patch subject: [PATCH net-next 05/10] net: libwx: Allocate Rx and Tx resources
config: mips-allyesconfig (https://download.01.org/0day-ci/archive/20230122/202301221047.SBlK8xvt-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/583ee5bbec18cbfb2f88a647db0d8d15457d2b54
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiawen-Wu/net-libwx-Add-irq-flow-functions/20230118-154258
        git checkout 583ee5bbec18cbfb2f88a647db0d8d15457d2b54
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=mips olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/wangxun/libwx/wx_lib.c: In function 'wx_free_rx_resources':
>> drivers/net/ethernet/wangxun/libwx/wx_lib.c:612:9: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
     612 |         vfree(rx_ring->rx_buffer_info);
         |         ^~~~~
         |         kvfree
   drivers/net/ethernet/wangxun/libwx/wx_lib.c: In function 'wx_setup_rx_resources':
>> drivers/net/ethernet/wangxun/libwx/wx_lib.c:728:35: error: implicit declaration of function 'vmalloc_node'; did you mean 'kvmalloc_node'? [-Werror=implicit-function-declaration]
     728 |         rx_ring->rx_buffer_info = vmalloc_node(size, numa_node);
         |                                   ^~~~~~~~~~~~
         |                                   kvmalloc_node
   drivers/net/ethernet/wangxun/libwx/wx_lib.c:728:33: warning: assignment to 'struct wx_rx_buffer *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     728 |         rx_ring->rx_buffer_info = vmalloc_node(size, numa_node);
         |                                 ^
>> drivers/net/ethernet/wangxun/libwx/wx_lib.c:730:43: error: implicit declaration of function 'vmalloc'; did you mean 'kvmalloc'? [-Werror=implicit-function-declaration]
     730 |                 rx_ring->rx_buffer_info = vmalloc(size);
         |                                           ^~~~~~~
         |                                           kvmalloc
   drivers/net/ethernet/wangxun/libwx/wx_lib.c:730:41: warning: assignment to 'struct wx_rx_buffer *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     730 |                 rx_ring->rx_buffer_info = vmalloc(size);
         |                                         ^
   drivers/net/ethernet/wangxun/libwx/wx_lib.c: In function 'wx_setup_tx_resources':
   drivers/net/ethernet/wangxun/libwx/wx_lib.c:810:33: warning: assignment to 'struct wx_tx_buffer *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     810 |         tx_ring->tx_buffer_info = vmalloc_node(size, numa_node);
         |                                 ^
   drivers/net/ethernet/wangxun/libwx/wx_lib.c:812:41: warning: assignment to 'struct wx_tx_buffer *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     812 |                 tx_ring->tx_buffer_info = vmalloc(size);
         |                                         ^
   cc1: some warnings being treated as errors


vim +612 drivers/net/ethernet/wangxun/libwx/wx_lib.c

   603	
   604	/**
   605	 * wx_free_rx_resources - Free Rx Resources
   606	 * @rx_ring: ring to clean the resources from
   607	 *
   608	 * Free all receive software resources
   609	 **/
   610	static void wx_free_rx_resources(struct wx_ring *rx_ring)
   611	{
 > 612		vfree(rx_ring->rx_buffer_info);
   613		rx_ring->rx_buffer_info = NULL;
   614	
   615		/* if not set, then don't free */
   616		if (!rx_ring->desc)
   617			return;
   618	
   619		dma_free_coherent(rx_ring->dev, rx_ring->size,
   620				  rx_ring->desc, rx_ring->dma);
   621	
   622		rx_ring->desc = NULL;
   623	
   624		if (rx_ring->page_pool) {
   625			page_pool_destroy(rx_ring->page_pool);
   626			rx_ring->page_pool = NULL;
   627		}
   628	}
   629	
   630	/**
   631	 * wx_free_all_rx_resources - Free Rx Resources for All Queues
   632	 * @wx: pointer to hardware structure
   633	 *
   634	 * Free all receive software resources
   635	 **/
   636	static void wx_free_all_rx_resources(struct wx *wx)
   637	{
   638		int i;
   639	
   640		for (i = 0; i < wx->num_rx_queues; i++)
   641			wx_free_rx_resources(wx->rx_ring[i]);
   642	}
   643	
   644	/**
   645	 * wx_free_tx_resources - Free Tx Resources per Queue
   646	 * @tx_ring: Tx descriptor ring for a specific queue
   647	 *
   648	 * Free all transmit software resources
   649	 **/
   650	static void wx_free_tx_resources(struct wx_ring *tx_ring)
   651	{
   652		vfree(tx_ring->tx_buffer_info);
   653		tx_ring->tx_buffer_info = NULL;
   654	
   655		/* if not set, then don't free */
   656		if (!tx_ring->desc)
   657			return;
   658	
   659		dma_free_coherent(tx_ring->dev, tx_ring->size,
   660				  tx_ring->desc, tx_ring->dma);
   661		tx_ring->desc = NULL;
   662	}
   663	
   664	/**
   665	 * wx_free_all_tx_resources - Free Tx Resources for All Queues
   666	 * @wx: pointer to hardware structure
   667	 *
   668	 * Free all transmit software resources
   669	 **/
   670	static void wx_free_all_tx_resources(struct wx *wx)
   671	{
   672		int i;
   673	
   674		for (i = 0; i < wx->num_tx_queues; i++)
   675			wx_free_tx_resources(wx->tx_ring[i]);
   676	}
   677	
   678	void wx_free_resources(struct wx *wx)
   679	{
   680		wx_free_isb_resources(wx);
   681		wx_free_all_rx_resources(wx);
   682		wx_free_all_tx_resources(wx);
   683	}
   684	EXPORT_SYMBOL(wx_free_resources);
   685	
   686	static int wx_alloc_page_pool(struct wx_ring *rx_ring)
   687	{
   688		int ret = 0;
   689	
   690		struct page_pool_params pp_params = {
   691			.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
   692			.order = 0,
   693			.pool_size = rx_ring->size,
   694			.nid = dev_to_node(rx_ring->dev),
   695			.dev = rx_ring->dev,
   696			.dma_dir = DMA_FROM_DEVICE,
   697			.offset = 0,
   698			.max_len = PAGE_SIZE,
   699		};
   700	
   701		rx_ring->page_pool = page_pool_create(&pp_params);
   702		if (IS_ERR(rx_ring->page_pool)) {
   703			rx_ring->page_pool = NULL;
   704			ret = PTR_ERR(rx_ring->page_pool);
   705		}
   706	
   707		return ret;
   708	}
   709	
   710	/**
   711	 * wx_setup_rx_resources - allocate Rx resources (Descriptors)
   712	 * @rx_ring: rx descriptor ring (for a specific queue) to setup
   713	 *
   714	 * Returns 0 on success, negative on failure
   715	 **/
   716	static int wx_setup_rx_resources(struct wx_ring *rx_ring)
   717	{
   718		struct device *dev = rx_ring->dev;
   719		int orig_node = dev_to_node(dev);
   720		int numa_node = -1;
   721		int size, ret;
   722	
   723		size = sizeof(struct wx_rx_buffer) * rx_ring->count;
   724	
   725		if (rx_ring->q_vector)
   726			numa_node = rx_ring->q_vector->numa_node;
   727	
 > 728		rx_ring->rx_buffer_info = vmalloc_node(size, numa_node);
   729		if (!rx_ring->rx_buffer_info)
 > 730			rx_ring->rx_buffer_info = vmalloc(size);
   731		if (!rx_ring->rx_buffer_info)
   732			goto err;
   733	
   734		/* Round up to nearest 4K */
   735		rx_ring->size = rx_ring->count * sizeof(union wx_rx_desc);
   736		rx_ring->size = ALIGN(rx_ring->size, 4096);
   737	
   738		set_dev_node(dev, numa_node);
   739		rx_ring->desc = dma_alloc_coherent(dev, rx_ring->size,
   740						   &rx_ring->dma, GFP_KERNEL);
   741		set_dev_node(dev, orig_node);
   742		rx_ring->desc = dma_alloc_coherent(dev, rx_ring->size,
   743						   &rx_ring->dma, GFP_KERNEL);
   744		if (!rx_ring->desc)
   745			goto err;
   746	
   747		ret = wx_alloc_page_pool(rx_ring);
   748		if (ret < 0) {
   749			dev_err(rx_ring->dev, "Page pool creation failed: %d\n", ret);
   750			goto err;
   751		}
   752	
   753		return 0;
   754	err:
   755		vfree(rx_ring->rx_buffer_info);
   756		rx_ring->rx_buffer_info = NULL;
   757		dev_err(dev, "Unable to allocate memory for the Rx descriptor ring\n");
   758		return -ENOMEM;
   759	}
   760	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
