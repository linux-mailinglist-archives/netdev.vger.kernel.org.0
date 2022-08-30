Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26DC5A71D1
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 01:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiH3Xby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 19:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiH3Xbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 19:31:40 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83E872EDC
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 16:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661902298; x=1693438298;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eushmtcv7d0as8OwB+uza/6Ofidi+rdcLdw5Q7nvJ/8=;
  b=gYyY7xqg7FQtE5KzdwuLcvcq95TAtApyG2MYmvjmJ7OmfS8fXWm7FVxy
   YngJHuqo+uRcTgM04U4gY52Z0gJRX5s+ro3QB5rH8jsgKrLvakZcHV2pV
   Hp5/40O82UmvVF9c4kdjM1HAGlfcElgFGcq9i8KLkFZCjvJzaFEuYDeiX
   A/wPWQIrhJxpzFbLfszTvpVLLOS2jCQlyAisC34+jnP0boYyxNekK85WT
   RQeN+6iDxXFHZJOmC1bIGAgmi1gQr15edceJUwVBKhC8EUjmDRAWdMLSF
   9qOxgVn95ppCo0JqqKLiHskJrsw+wNsEYCvAHOgWWPBZlLrQRF5ZecUyB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="295334067"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="295334067"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 16:31:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="680231802"
Received: from lkp-server02.sh.intel.com (HELO 77b6d4e16fc5) ([10.239.97.151])
  by fmsmga004.fm.intel.com with ESMTP; 30 Aug 2022 16:31:37 -0700
Received: from kbuild by 77b6d4e16fc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oTAhk-0000jj-1s;
        Tue, 30 Aug 2022 23:31:36 +0000
Date:   Wed, 31 Aug 2022 07:31:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, mengyuanlou@net-swift.com,
        Jiawen Wu <jiawenwu@trustnetic.com>
Subject: Re: [PATCH net-next v2 11/16] net: txgbe: Allocate Rx and Tx
 resources
Message-ID: <202208310732.sJ1RQ8FS-lkp@intel.com>
References: <20220830070454.146211-12-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830070454.146211-12-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiawen,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawen-Wu/net-WangXun-txgbe-ethernet-driver/20220830-151052
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git f97e971dbdc7c83d697fa2209fed0ea50fffa12e
config: sparc-allyesconfig (https://download.01.org/0day-ci/archive/20220831/202208310732.sJ1RQ8FS-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c864cd7572cc2087b05b4b7850e9fd01f8a1c3ea
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiawen-Wu/net-WangXun-txgbe-ethernet-driver/20220830-151052
        git checkout c864cd7572cc2087b05b4b7850e9fd01f8a1c3ea
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sparc SHELL=/bin/bash drivers/net/ethernet/wangxun/txgbe/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c: In function 'txgbe_setup_tx_resources':
   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:1786:35: error: implicit declaration of function 'vzalloc_node'; did you mean 'kvzalloc_node'? [-Werror=implicit-function-declaration]
    1786 |         tx_ring->tx_buffer_info = vzalloc_node(size, numa_node);
         |                                   ^~~~~~~~~~~~
         |                                   kvzalloc_node
>> drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:1786:33: warning: assignment to 'struct txgbe_tx_buffer *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    1786 |         tx_ring->tx_buffer_info = vzalloc_node(size, numa_node);
         |                                 ^
   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:1788:43: error: implicit declaration of function 'vzalloc'; did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
    1788 |                 tx_ring->tx_buffer_info = vzalloc(size);
         |                                           ^~~~~~~
         |                                           kvzalloc
   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:1788:41: warning: assignment to 'struct txgbe_tx_buffer *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    1788 |                 tx_ring->tx_buffer_info = vzalloc(size);
         |                                         ^
   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:1811:9: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
    1811 |         vfree(tx_ring->tx_buffer_info);
         |         ^~~~~
         |         kvfree
   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c: In function 'txgbe_setup_rx_resources':
>> drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:1867:33: warning: assignment to 'struct txgbe_rx_buffer *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    1867 |         rx_ring->rx_buffer_info = vzalloc_node(size, numa_node);
         |                                 ^
   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:1869:41: warning: assignment to 'struct txgbe_rx_buffer *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
    1869 |                 rx_ring->rx_buffer_info = vzalloc(size);
         |                                         ^
   cc1: some warnings being treated as errors


vim +1786 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c

  1767	
  1768	/**
  1769	 * txgbe_setup_tx_resources - allocate Tx resources (Descriptors)
  1770	 * @tx_ring:    tx descriptor ring (for a specific queue) to setup
  1771	 *
  1772	 * Return 0 on success, negative on failure
  1773	 **/
  1774	int txgbe_setup_tx_resources(struct txgbe_ring *tx_ring)
  1775	{
  1776		struct device *dev = tx_ring->dev;
  1777		int orig_node = dev_to_node(dev);
  1778		int numa_node = -1;
  1779		int size;
  1780	
  1781		size = sizeof(struct txgbe_tx_buffer) * tx_ring->count;
  1782	
  1783		if (tx_ring->q_vector)
  1784			numa_node = tx_ring->q_vector->numa_node;
  1785	
> 1786		tx_ring->tx_buffer_info = vzalloc_node(size, numa_node);
  1787		if (!tx_ring->tx_buffer_info)
> 1788			tx_ring->tx_buffer_info = vzalloc(size);
  1789		if (!tx_ring->tx_buffer_info)
  1790			goto err;
  1791	
  1792		/* round up to nearest 4K */
  1793		tx_ring->size = tx_ring->count * sizeof(union txgbe_tx_desc);
  1794		tx_ring->size = ALIGN(tx_ring->size, 4096);
  1795	
  1796		set_dev_node(dev, numa_node);
  1797		tx_ring->desc = dma_alloc_coherent(dev,
  1798						   tx_ring->size,
  1799						   &tx_ring->dma,
  1800						   GFP_KERNEL);
  1801		set_dev_node(dev, orig_node);
  1802		if (!tx_ring->desc)
  1803			tx_ring->desc = dma_alloc_coherent(dev, tx_ring->size,
  1804							   &tx_ring->dma, GFP_KERNEL);
  1805		if (!tx_ring->desc)
  1806			goto err;
  1807	
  1808		return 0;
  1809	
  1810	err:
  1811		vfree(tx_ring->tx_buffer_info);
  1812		tx_ring->tx_buffer_info = NULL;
  1813		dev_err(dev, "Unable to allocate memory for the Tx descriptor ring\n");
  1814		return -ENOMEM;
  1815	}
  1816	
  1817	/**
  1818	 * txgbe_setup_all_tx_resources - allocate all queues Tx resources
  1819	 * @adapter: board private structure
  1820	 *
  1821	 * If this function returns with an error, then it's possible one or
  1822	 * more of the rings is populated (while the rest are not).  It is the
  1823	 * callers duty to clean those orphaned rings.
  1824	 *
  1825	 * Return 0 on success, negative on failure
  1826	 **/
  1827	static int txgbe_setup_all_tx_resources(struct txgbe_adapter *adapter)
  1828	{
  1829		int i, err = 0;
  1830	
  1831		for (i = 0; i < adapter->num_tx_queues; i++) {
  1832			err = txgbe_setup_tx_resources(adapter->tx_ring[i]);
  1833			if (!err)
  1834				continue;
  1835	
  1836			netif_err(adapter, probe, adapter->netdev,
  1837				  "Allocation for Tx Queue %u failed\n", i);
  1838			goto err_setup_tx;
  1839		}
  1840	
  1841		return 0;
  1842	err_setup_tx:
  1843		/* rewind the index freeing the rings as we go */
  1844		while (i--)
  1845			txgbe_free_tx_resources(adapter->tx_ring[i]);
  1846		return err;
  1847	}
  1848	
  1849	/**
  1850	 * txgbe_setup_rx_resources - allocate Rx resources (Descriptors)
  1851	 * @rx_ring:    rx descriptor ring (for a specific queue) to setup
  1852	 *
  1853	 * Returns 0 on success, negative on failure
  1854	 **/
  1855	int txgbe_setup_rx_resources(struct txgbe_ring *rx_ring)
  1856	{
  1857		struct device *dev = rx_ring->dev;
  1858		int orig_node = dev_to_node(dev);
  1859		int numa_node = -1;
  1860		int size;
  1861	
  1862		size = sizeof(struct txgbe_rx_buffer) * rx_ring->count;
  1863	
  1864		if (rx_ring->q_vector)
  1865			numa_node = rx_ring->q_vector->numa_node;
  1866	
> 1867		rx_ring->rx_buffer_info = vzalloc_node(size, numa_node);
  1868		if (!rx_ring->rx_buffer_info)
  1869			rx_ring->rx_buffer_info = vzalloc(size);
  1870		if (!rx_ring->rx_buffer_info)
  1871			goto err;
  1872	
  1873		/* Round up to nearest 4K */
  1874		rx_ring->size = rx_ring->count * sizeof(union txgbe_rx_desc);
  1875		rx_ring->size = ALIGN(rx_ring->size, 4096);
  1876	
  1877		set_dev_node(dev, numa_node);
  1878		rx_ring->desc = dma_alloc_coherent(dev,
  1879						   rx_ring->size,
  1880						   &rx_ring->dma,
  1881						   GFP_KERNEL);
  1882		set_dev_node(dev, orig_node);
  1883		if (!rx_ring->desc)
  1884			rx_ring->desc = dma_alloc_coherent(dev, rx_ring->size,
  1885							   &rx_ring->dma, GFP_KERNEL);
  1886		if (!rx_ring->desc)
  1887			goto err;
  1888	
  1889		return 0;
  1890	err:
  1891		vfree(rx_ring->rx_buffer_info);
  1892		rx_ring->rx_buffer_info = NULL;
  1893		dev_err(dev, "Unable to allocate memory for the Rx descriptor ring\n");
  1894		return -ENOMEM;
  1895	}
  1896	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
