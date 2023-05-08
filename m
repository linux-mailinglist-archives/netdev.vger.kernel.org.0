Return-Path: <netdev+bounces-818-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62D876FA0B5
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 09:11:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEFF7280EE2
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 07:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF5115496;
	Mon,  8 May 2023 07:11:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696B47E
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 07:11:25 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E21D1AEC0;
	Mon,  8 May 2023 00:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683529860; x=1715065860;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=d8vJgSlA7sOSKqafhmqky88R9LmTjbeQyY4r6QERO8o=;
  b=heF4bTrUPeyaslmKTxLNIjkiGF2VyT2BCXrjoMhA7ydue4y7peiYjKu/
   lM4tZGRK1X+vc51sNT6DipBOEKFM0UQLidOb3zTmLAIcTY5P/DI44sjCF
   rJXN0SPGZ1KTOXsbtpo5Ea36ztyY+HldMhVJnNoU9MGTAxUSfjai/7pDD
   fAHIYHK4386YDdqsJ/4/BYQkmCVFzUfVH8BgCEOkXi3e2sI4uCECK7nSI
   9rAstwkZFzsIgFO6DZF20IWLE8yEosSH+/CLUloACx1ohloVuMhaF1gzl
   +SqvL1DCZ8HTqGzyUaRUQzYXJJ99Jax5D9HnL8raFbOg9KPez4VSHOuGp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="349608797"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="349608797"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 00:10:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="767963180"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="767963180"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 08 May 2023 00:10:56 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pvv1M-00016L-00;
	Mon, 08 May 2023 07:10:56 +0000
Date: Mon, 8 May 2023 15:10:17 +0800
From: kernel test robot <lkp@intel.com>
To: Arnd Bergmann <arnd@kernel.org>, Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: oe-kbuild-all@lists.linux.dev, Arnd Bergmann <arnd@arndb.de>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net/mlx4: avoid overloading user/kernel pointers
Message-ID: <202305081441.iME4qFhY-lkp@intel.com>
References: <20230418114730.3674657-2-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418114730.3674657-2-arnd@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Arnd,

kernel test robot noticed the following build warnings:

[auto build test WARNING on soc/for-next]
[also build test WARNING on linus/master v6.4-rc1 next-20230508]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Arnd-Bergmann/net-mlx4-avoid-overloading-user-kernel-pointers/20230418-195238
base:   https://git.kernel.org/pub/scm/linux/kernel/git/soc/soc.git for-next
patch link:    https://lore.kernel.org/r/20230418114730.3674657-2-arnd%40kernel.org
patch subject: [PATCH 2/2] net/mlx4: avoid overloading user/kernel pointers
config: loongarch-randconfig-s043-20230507 (https://download.01.org/0day-ci/archive/20230508/202305081441.iME4qFhY-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/1389cdaec07839abb7b8aacb2b16f37d4affd8d3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Arnd-Bergmann/net-mlx4-avoid-overloading-user-kernel-pointers/20230418-195238
        git checkout 1389cdaec07839abb7b8aacb2b16f37d4affd8d3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=loongarch olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=loongarch SHELL=/bin/bash drivers/net/ethernet/mellanox/mlx4/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305081441.iME4qFhY-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/net/ethernet/mellanox/mlx4/en_cq.c:141:59: sparse: sparse: incorrect type in argument 10 (different address spaces) @@     expected void [noderef] __user *ubuf_addr @@     got struct mlx4_buf * @@
   drivers/net/ethernet/mellanox/mlx4/en_cq.c:141:59: sparse:     expected void [noderef] __user *ubuf_addr
   drivers/net/ethernet/mellanox/mlx4/en_cq.c:141:59: sparse:     got struct mlx4_buf *
>> drivers/net/ethernet/mellanox/mlx4/en_cq.c:141:74: sparse: sparse: Using plain integer as NULL pointer

vim +141 drivers/net/ethernet/mellanox/mlx4/en_cq.c

c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22   88  
76532d0c7e7424 drivers/net/ethernet/mellanox/mlx4/en_cq.c Alexander Guller  2011-10-09   89  int mlx4_en_activate_cq(struct mlx4_en_priv *priv, struct mlx4_en_cq *cq,
76532d0c7e7424 drivers/net/ethernet/mellanox/mlx4/en_cq.c Alexander Guller  2011-10-09   90  			int cq_idx)
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22   91  {
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22   92  	struct mlx4_en_dev *mdev = priv->mdev;
80a62deedf9d44 drivers/net/ethernet/mellanox/mlx4/en_cq.c Thomas Gleixner   2020-12-10   93  	int irq, err = 0;
ec693d47010e83 drivers/net/ethernet/mellanox/mlx4/en_cq.c Amir Vadai        2013-04-23   94  	int timestamp_en = 0;
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31   95  	bool assigned_eq = false;
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22   96  
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22   97  	cq->dev = mdev->pndev[priv->port];
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22   98  	cq->mcq.set_ci_db  = cq->wqres.db.db;
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22   99  	cq->mcq.arm_db     = cq->wqres.db.db + 1;
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22  100  	*cq->mcq.set_ci_db = 0;
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22  101  	*cq->mcq.arm_db    = 0;
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22  102  	memset(cq->buf, 0, cq->buf_size);
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22  103  
ccc109b8ed24c6 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2016-11-02  104  	if (cq->type == RX) {
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  105  		if (!mlx4_is_eq_vector_valid(mdev->dev, priv->port,
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  106  					     cq->vector)) {
de1618034ae570 drivers/net/ethernet/mellanox/mlx4/en_cq.c Ido Shamay        2015-05-31  107  			cq->vector = cpumask_first(priv->rx_ring[cq->ring]->affinity_mask);
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  108  
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  109  			err = mlx4_assign_eq(mdev->dev, priv->port,
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  110  					     &cq->vector);
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  111  			if (err) {
b0f6446377e72b drivers/net/ethernet/mellanox/mlx4/en_cq.c Carol L Soto      2015-08-27  112  				mlx4_err(mdev, "Failed assigning an EQ to CQ vector %d\n",
b0f6446377e72b drivers/net/ethernet/mellanox/mlx4/en_cq.c Carol L Soto      2015-08-27  113  					 cq->vector);
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  114  				goto free_eq;
1fb9876e9bf895 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2011-03-22  115  			}
35f6f45368632f drivers/net/ethernet/mellanox/mlx4/en_cq.c Amir Vadai        2014-06-29  116  
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  117  			assigned_eq = true;
1fb9876e9bf895 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2011-03-22  118  		}
80a62deedf9d44 drivers/net/ethernet/mellanox/mlx4/en_cq.c Thomas Gleixner   2020-12-10  119  		irq = mlx4_eq_get_irq(mdev->dev, cq->vector);
197d2370772957 drivers/net/ethernet/mellanox/mlx4/en_cq.c Thomas Gleixner   2020-12-10  120  		cq->aff_mask = irq_get_effective_affinity_mask(irq);
1fb9876e9bf895 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2011-03-22  121  	} else {
76532d0c7e7424 drivers/net/ethernet/mellanox/mlx4/en_cq.c Alexander Guller  2011-10-09  122  		/* For TX we use the same irq per
76532d0c7e7424 drivers/net/ethernet/mellanox/mlx4/en_cq.c Alexander Guller  2011-10-09  123  		ring we assigned for the RX    */
76532d0c7e7424 drivers/net/ethernet/mellanox/mlx4/en_cq.c Alexander Guller  2011-10-09  124  		struct mlx4_en_cq *rx_cq;
76532d0c7e7424 drivers/net/ethernet/mellanox/mlx4/en_cq.c Alexander Guller  2011-10-09  125  
76532d0c7e7424 drivers/net/ethernet/mellanox/mlx4/en_cq.c Alexander Guller  2011-10-09  126  		cq_idx = cq_idx % priv->rx_ring_num;
41d942d56cfd21 drivers/net/ethernet/mellanox/mlx4/en_cq.c Eugenia Emantayev 2013-11-07  127  		rx_cq = priv->rx_cq[cq_idx];
76532d0c7e7424 drivers/net/ethernet/mellanox/mlx4/en_cq.c Alexander Guller  2011-10-09  128  		cq->vector = rx_cq->vector;
1fb9876e9bf895 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2011-03-22  129  	}
1fb9876e9bf895 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2011-03-22  130  
ccc109b8ed24c6 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2016-11-02  131  	if (cq->type == RX)
41d942d56cfd21 drivers/net/ethernet/mellanox/mlx4/en_cq.c Eugenia Emantayev 2013-11-07  132  		cq->size = priv->rx_ring[cq->ring]->actual_size;
38aab07c14adbf drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2009-05-24  133  
ccc109b8ed24c6 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2016-11-02  134  	if ((cq->type != RX && priv->hwtstamp_config.tx_type) ||
ccc109b8ed24c6 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2016-11-02  135  	    (cq->type == RX && priv->hwtstamp_config.rx_filter))
ec693d47010e83 drivers/net/ethernet/mellanox/mlx4/en_cq.c Amir Vadai        2013-04-23  136  		timestamp_en = 1;
ec693d47010e83 drivers/net/ethernet/mellanox/mlx4/en_cq.c Amir Vadai        2013-04-23  137  
f3301870161ca2 drivers/net/ethernet/mellanox/mlx4/en_cq.c Moshe Shemesh     2017-06-21  138  	cq->mcq.usage = MLX4_RES_USAGE_DRIVER;
ec693d47010e83 drivers/net/ethernet/mellanox/mlx4/en_cq.c Amir Vadai        2013-04-23  139  	err = mlx4_cq_alloc(mdev->dev, cq->size, &cq->wqres.mtt,
ec693d47010e83 drivers/net/ethernet/mellanox/mlx4/en_cq.c Amir Vadai        2013-04-23  140  			    &mdev->priv_uar, cq->wqres.db.dma, &cq->mcq,
e45678973dcbb1 drivers/net/ethernet/mellanox/mlx4/en_cq.c Daniel Jurgens    2018-11-21 @141  			    cq->vector, 0, timestamp_en, &cq->wqres.buf, false);
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22  142  	if (err)
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  143  		goto free_eq;
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22  144  
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22  145  	cq->mcq.event = mlx4_en_cq_event;
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22  146  
6c78511b0503c9 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2017-06-15  147  	switch (cq->type) {
6c78511b0503c9 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2017-06-15  148  	case TX:
6c78511b0503c9 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2017-06-15  149  		cq->mcq.comp = mlx4_en_tx_irq;
16d083e28f1a4f drivers/net/ethernet/mellanox/mlx4/en_cq.c Jakub Kicinski    2022-05-04  150  		netif_napi_add_tx(cq->dev, &cq->napi, mlx4_en_poll_tx_cq);
6c78511b0503c9 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2017-06-15  151  		napi_enable(&cq->napi);
6c78511b0503c9 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2017-06-15  152  		break;
6c78511b0503c9 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2017-06-15  153  	case RX:
6c78511b0503c9 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2017-06-15  154  		cq->mcq.comp = mlx4_en_rx_irq;
b48b89f9c189d2 drivers/net/ethernet/mellanox/mlx4/en_cq.c Jakub Kicinski    2022-09-27  155  		netif_napi_add(cq->dev, &cq->napi, mlx4_en_poll_rx_cq);
0276a330617a0c drivers/net/ethernet/mellanox/mlx4/en_cq.c Eugenia Emantayev 2013-12-19  156  		napi_enable(&cq->napi);
6c78511b0503c9 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2017-06-15  157  		break;
6c78511b0503c9 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2017-06-15  158  	case TX_XDP:
6c78511b0503c9 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2017-06-15  159  		/* nothing regarding napi, it's shared with rx ring */
6c78511b0503c9 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2017-06-15  160  		cq->xdp_busy = false;
6c78511b0503c9 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2017-06-15  161  		break;
6c78511b0503c9 drivers/net/ethernet/mellanox/mlx4/en_cq.c Tariq Toukan      2017-06-15  162  	}
0276a330617a0c drivers/net/ethernet/mellanox/mlx4/en_cq.c Eugenia Emantayev 2013-12-19  163  
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22  164  	return 0;
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  165  
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  166  free_eq:
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  167  	if (assigned_eq)
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  168  		mlx4_release_eq(mdev->dev, cq->vector);
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  169  	cq->vector = mdev->dev->caps.num_comp_vectors;
c66fa19c405a36 drivers/net/ethernet/mellanox/mlx4/en_cq.c Matan Barak       2015-05-31  170  	return err;
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22  171  }
c27a02cd94d669 drivers/net/mlx4/en_cq.c                   Yevgeny Petrilin  2008-10-22  172  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

