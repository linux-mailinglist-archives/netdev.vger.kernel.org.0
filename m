Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBFC4C8723
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 09:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiCAIxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 03:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiCAIxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 03:53:49 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0403C4CD4E;
        Tue,  1 Mar 2022 00:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646124789; x=1677660789;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yiJ/BQ5gAoHmkyVxyQI8IbcLARTSRg++r4C90UozetE=;
  b=e4I2ZL1o8MwXmVtVdZXANZldr3xQqFjm6n67zV6Ram0KsIwtQeMlTGbx
   fYSJWrBldaxFw0Plg+flrkwu27wXlCSwsMQUQXP062uLS2CqRFD41UTh1
   ZWeNpgYrfv70yFK5QjinWxqJjNgQ8U0sU55LVb1jgI/rrYrCuj2cLCoO8
   sXfa+VWGKlxYgCu0QTQ4xz8pI8/NOuNmX61HBIgL8mI6v81Xpoos+eVEI
   Lt5flnEByFkJuKkvtcNiWxxVAbFbw1N6wDhJzHYuh010q8QDZSO2Yfi+W
   mX9xUVyAhhNtEvd2wAUvK3ND3WHfSVmdlvwYkwFb1YBUpVjREebilJ957
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="277755696"
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="277755696"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 00:53:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,145,1643702400"; 
   d="scan'208";a="708980686"
Received: from lkp-server01.sh.intel.com (HELO 2146afe809fb) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 01 Mar 2022 00:53:06 -0800
Received: from kbuild by 2146afe809fb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nOyFl-0000CZ-E8; Tue, 01 Mar 2022 08:53:05 +0000
Date:   Tue, 1 Mar 2022 16:52:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Veerasenareddy Burru <vburru@marvell.com>, davem@davemloft.net,
        kuba@kernel.org, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: Re: [PATCH v2 4/7] octeon_ep: add Tx/Rx ring resource setup and
 cleanup
Message-ID: <202203011646.KOYQZTf2-lkp@intel.com>
References: <20220301050359.19374-5-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301050359.19374-5-vburru@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Veerasenareddy,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.17-rc6 next-20220228]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Veerasenareddy-Burru/Add-octeon_ep-driver/20220301-130525
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 719fce7539cd3e186598e2aed36325fe892150cf
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20220301/202203011646.KOYQZTf2-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/4f90d53a8dea4a3aa77ba5ba8d34d576b81bd773
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Veerasenareddy-Burru/Add-octeon_ep-driver/20220301-130525
        git checkout 4f90d53a8dea4a3aa77ba5ba8d34d576b81bd773
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=alpha SHELL=/bin/bash drivers/net/ethernet/marvell/octeon_ep/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/marvell/octeon_ep/octep_tx.c: In function 'octep_setup_iq':
   drivers/net/ethernet/marvell/octeon_ep/octep_tx.c:110:14: error: implicit declaration of function 'vzalloc'; did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
     110 |         iq = vzalloc(sizeof(*iq));
         |              ^~~~~~~
         |              kvzalloc
>> drivers/net/ethernet/marvell/octeon_ep/octep_tx.c:110:12: warning: assignment to 'struct octep_iq *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     110 |         iq = vzalloc(sizeof(*iq));
         |            ^
>> drivers/net/ethernet/marvell/octeon_ep/octep_tx.c:148:23: warning: assignment to 'struct octep_tx_buffer *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     148 |         iq->buff_info = vzalloc(buff_info_size);
         |                       ^
   drivers/net/ethernet/marvell/octeon_ep/octep_tx.c:178:9: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
     178 |         vfree(iq);
         |         ^~~~~
         |         kvfree
   cc1: some warnings being treated as errors
--
   drivers/net/ethernet/marvell/octeon_ep/octep_rx.c: In function 'octep_setup_oq':
   drivers/net/ethernet/marvell/octeon_ep/octep_rx.c:83:14: error: implicit declaration of function 'vzalloc'; did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
      83 |         oq = vzalloc(sizeof(*oq));
         |              ^~~~~~~
         |              kvzalloc
>> drivers/net/ethernet/marvell/octeon_ep/octep_rx.c:83:12: warning: assignment to 'struct octep_oq *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
      83 |         oq = vzalloc(sizeof(*oq));
         |            ^
>> drivers/net/ethernet/marvell/octeon_ep/octep_rx.c:116:25: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     116 |         oq->buff_info = (struct octep_rx_buffer *)
         |                         ^
   drivers/net/ethernet/marvell/octeon_ep/octep_rx.c:134:9: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
     134 |         vfree(oq->buff_info);
         |         ^~~~~
         |         kvfree
   cc1: some warnings being treated as errors


vim +110 drivers/net/ethernet/marvell/octeon_ep/octep_tx.c

    95	
    96	/**
    97	 * octep_setup_iq() - Setup a Tx queue.
    98	 *
    99	 * @oct: Octeon device private data structure.
   100	 * @q_no: Tx queue number to be setup.
   101	 *
   102	 * Allocate resources for a Tx queue.
   103	 */
   104	static int octep_setup_iq(struct octep_device *oct, int q_no)
   105	{
   106		u32 desc_ring_size, buff_info_size, sglist_size;
   107		struct octep_iq *iq;
   108		int i;
   109	
 > 110		iq = vzalloc(sizeof(*iq));
   111		if (!iq)
   112			goto iq_alloc_err;
   113		oct->iq[q_no] = iq;
   114	
   115		iq->octep_dev = oct;
   116		iq->netdev = oct->netdev;
   117		iq->dev = &oct->pdev->dev;
   118		iq->q_no = q_no;
   119		iq->max_count = CFG_GET_IQ_NUM_DESC(oct->conf);
   120		iq->ring_size_mask = iq->max_count - 1;
   121		iq->fill_threshold = CFG_GET_IQ_DB_MIN(oct->conf);
   122		iq->netdev_q = netdev_get_tx_queue(iq->netdev, q_no);
   123	
   124		/* Allocate memory for hardware queue descriptors */
   125		desc_ring_size = OCTEP_IQ_DESC_SIZE * CFG_GET_IQ_NUM_DESC(oct->conf);
   126		iq->desc_ring = dma_alloc_coherent(iq->dev, desc_ring_size,
   127						   &iq->desc_ring_dma, GFP_KERNEL);
   128		if (unlikely(!iq->desc_ring)) {
   129			dev_err(iq->dev,
   130				"Failed to allocate DMA memory for IQ-%d\n", q_no);
   131			goto desc_dma_alloc_err;
   132		}
   133	
   134		/* Allocate memory for hardware SGLIST descriptors */
   135		sglist_size = OCTEP_SGLIST_SIZE_PER_PKT *
   136			      CFG_GET_IQ_NUM_DESC(oct->conf);
   137		iq->sglist = dma_alloc_coherent(iq->dev, sglist_size,
   138						&iq->sglist_dma, GFP_KERNEL);
   139		if (unlikely(!iq->sglist)) {
   140			dev_err(iq->dev,
   141				"Failed to allocate DMA memory for IQ-%d SGLIST\n",
   142				q_no);
   143			goto sglist_alloc_err;
   144		}
   145	
   146		/* allocate memory to manage Tx packets pending completion */
   147		buff_info_size = OCTEP_IQ_TXBUFF_INFO_SIZE * iq->max_count;
 > 148		iq->buff_info = vzalloc(buff_info_size);
   149		if (!iq->buff_info) {
   150			dev_err(iq->dev,
   151				"Failed to allocate buff info for IQ-%d\n", q_no);
   152			goto buff_info_err;
   153		}
   154	
   155		/* Setup sglist addresses in tx_buffer entries */
   156		for (i = 0; i < CFG_GET_IQ_NUM_DESC(oct->conf); i++) {
   157			struct octep_tx_buffer *tx_buffer;
   158	
   159			tx_buffer = &iq->buff_info[i];
   160			tx_buffer->sglist =
   161				&iq->sglist[i * OCTEP_SGLIST_ENTRIES_PER_PKT];
   162			tx_buffer->sglist_dma =
   163				iq->sglist_dma + (i * OCTEP_SGLIST_SIZE_PER_PKT);
   164		}
   165	
   166		octep_iq_reset_indices(iq);
   167		oct->hw_ops.setup_iq_regs(oct, q_no);
   168	
   169		oct->num_iqs++;
   170		return 0;
   171	
   172	buff_info_err:
   173		dma_free_coherent(iq->dev, sglist_size, iq->sglist, iq->sglist_dma);
   174	sglist_alloc_err:
   175		dma_free_coherent(iq->dev, desc_ring_size,
   176				  iq->desc_ring, iq->desc_ring_dma);
   177	desc_dma_alloc_err:
   178		vfree(iq);
   179		oct->iq[q_no] = NULL;
   180	iq_alloc_err:
   181		return -1;
   182	}
   183	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
