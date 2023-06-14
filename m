Return-Path: <netdev+bounces-10887-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BAA8730A7B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 00:17:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F2152813EE
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B56134D8;
	Wed, 14 Jun 2023 22:17:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25622134A7
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 22:17:01 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C601FE8;
	Wed, 14 Jun 2023 15:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686781019; x=1718317019;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=71XOEFVoYYfCOvsQxiZyX2FI+NKqd8f4Yj5ogkZkfLU=;
  b=ZeG8yEe7lt3f15LknHkMyov97kVHv3mEUx6pqDdv8W+PSje7unH4fHa2
   jsvrh534mZ6i7PtsWeHGbOsu4nWNzlZiwEcpp3Oymli+mPgSg1jyZpIbH
   UmCRu9UGP532CyMAKFnUqI5H4OKdu4SHm2YSAvzxBS4Zei/iEdI5cUbx3
   v6UMBVT4ewNCu6J6OKgLpQiKiW/pO1VE4UTYqUJ4UrlpeSk6+gEx3HaHl
   /q/w6ab1kYZbBq+EhPsY1GEHK2k92EZyIggqbAZygOOAbSjUhCjFhAKGh
   DlLbvWMhPLhNODQWiFgxP/gpLCt+62FM03Jy2b4EdXrnWjpfDcTILUV/L
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="356239805"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="356239805"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 15:16:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="777441927"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="777441927"
Received: from lkp-server02.sh.intel.com (HELO d59cacf64e9e) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 14 Jun 2023 15:16:54 -0700
Received: from kbuild by d59cacf64e9e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q9YnN-00017f-13;
	Wed, 14 Jun 2023 22:16:53 +0000
Date: Thu, 15 Jun 2023 06:16:07 +0800
From: kernel test robot <lkp@intel.com>
To: Jisheng Zhang <jszhang@kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 3/3] net: stmmac: use pcpu statistics where necessary
Message-ID: <202306150658.XLO1cHJU-lkp@intel.com>
References: <20230614161847.4071-4-jszhang@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614161847.4071-4-jszhang@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jisheng,

kernel test robot noticed the following build errors:

[auto build test ERROR on sunxi/sunxi/for-next]
[also build test ERROR on linus/master v6.4-rc6]
[cannot apply to next-20230614]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jisheng-Zhang/net-stmmac-don-t-clear-network-statistics-in-ndo_open/20230615-003137
base:   https://git.kernel.org/pub/scm/linux/kernel/git/sunxi/linux.git sunxi/for-next
patch link:    https://lore.kernel.org/r/20230614161847.4071-4-jszhang%40kernel.org
patch subject: [PATCH 3/3] net: stmmac: use pcpu statistics where necessary
config: riscv-randconfig-r006-20230612 (https://download.01.org/0day-ci/archive/20230615/202306150658.XLO1cHJU-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        git remote add sunxi https://git.kernel.org/pub/scm/linux/kernel/git/sunxi/linux.git
        git fetch sunxi sunxi/for-next
        git checkout sunxi/sunxi/for-next
        b4 shazam https://lore.kernel.org/r/20230614161847.4071-4-jszhang@kernel.org
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/net/ethernet/stmicro/stmmac/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306150658.XLO1cHJU-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

>> drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c:564:49: warning: variable 'start' is uninitialized when used here [-Wuninitialized]
     564 |                 } while (u64_stats_fetch_retry(&stats->syncp, start));
         |                                                               ^~~~~
   drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c:551:20: note: initialize the variable 'start' to silence this warning
     551 |         unsigned int start;
         |                           ^
         |                            = 0
   1 warning generated.
--
>> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:7243:13: error: no member named 'xstas' in 'struct stmmac_priv'; did you mean 'xstats'?
    7243 |         if (!priv->xstas.pstats)
         |                    ^~~~~
         |                    xstats
   drivers/net/ethernet/stmicro/stmmac/stmmac.h:247:28: note: 'xstats' declared here
     247 |         struct stmmac_extra_stats xstats ____cacheline_aligned_in_smp;
         |                                   ^
   1 error generated.


vim +7243 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c

  7211	
  7212	/**
  7213	 * stmmac_dvr_probe
  7214	 * @device: device pointer
  7215	 * @plat_dat: platform data pointer
  7216	 * @res: stmmac resource pointer
  7217	 * Description: this is the main probe function used to
  7218	 * call the alloc_etherdev, allocate the priv structure.
  7219	 * Return:
  7220	 * returns 0 on success, otherwise errno.
  7221	 */
  7222	int stmmac_dvr_probe(struct device *device,
  7223			     struct plat_stmmacenet_data *plat_dat,
  7224			     struct stmmac_resources *res)
  7225	{
  7226		struct net_device *ndev = NULL;
  7227		struct stmmac_priv *priv;
  7228		u32 rxq;
  7229		int i, ret = 0;
  7230	
  7231		ndev = devm_alloc_etherdev_mqs(device, sizeof(struct stmmac_priv),
  7232					       MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES);
  7233		if (!ndev)
  7234			return -ENOMEM;
  7235	
  7236		SET_NETDEV_DEV(ndev, device);
  7237	
  7238		priv = netdev_priv(ndev);
  7239		priv->device = device;
  7240		priv->dev = ndev;
  7241	
  7242		priv->xstats.pstats = devm_netdev_alloc_pcpu_stats(device, struct stmmac_pcpu_stats);
> 7243		if (!priv->xstas.pstats)
  7244			return -ENOMEM;
  7245	
  7246		stmmac_set_ethtool_ops(ndev);
  7247		priv->pause = pause;
  7248		priv->plat = plat_dat;
  7249		priv->ioaddr = res->addr;
  7250		priv->dev->base_addr = (unsigned long)res->addr;
  7251		priv->plat->dma_cfg->multi_msi_en = priv->plat->multi_msi_en;
  7252	
  7253		priv->dev->irq = res->irq;
  7254		priv->wol_irq = res->wol_irq;
  7255		priv->lpi_irq = res->lpi_irq;
  7256		priv->sfty_ce_irq = res->sfty_ce_irq;
  7257		priv->sfty_ue_irq = res->sfty_ue_irq;
  7258		for (i = 0; i < MTL_MAX_RX_QUEUES; i++)
  7259			priv->rx_irq[i] = res->rx_irq[i];
  7260		for (i = 0; i < MTL_MAX_TX_QUEUES; i++)
  7261			priv->tx_irq[i] = res->tx_irq[i];
  7262	
  7263		if (!is_zero_ether_addr(res->mac))
  7264			eth_hw_addr_set(priv->dev, res->mac);
  7265	
  7266		dev_set_drvdata(device, priv->dev);
  7267	
  7268		/* Verify driver arguments */
  7269		stmmac_verify_args();
  7270	
  7271		priv->af_xdp_zc_qps = bitmap_zalloc(MTL_MAX_TX_QUEUES, GFP_KERNEL);
  7272		if (!priv->af_xdp_zc_qps)
  7273			return -ENOMEM;
  7274	
  7275		/* Allocate workqueue */
  7276		priv->wq = create_singlethread_workqueue("stmmac_wq");
  7277		if (!priv->wq) {
  7278			dev_err(priv->device, "failed to create workqueue\n");
  7279			ret = -ENOMEM;
  7280			goto error_wq_init;
  7281		}
  7282	
  7283		INIT_WORK(&priv->service_task, stmmac_service_task);
  7284	
  7285		/* Initialize Link Partner FPE workqueue */
  7286		INIT_WORK(&priv->fpe_task, stmmac_fpe_lp_task);
  7287	
  7288		/* Override with kernel parameters if supplied XXX CRS XXX
  7289		 * this needs to have multiple instances
  7290		 */
  7291		if ((phyaddr >= 0) && (phyaddr <= 31))
  7292			priv->plat->phy_addr = phyaddr;
  7293	
  7294		if (priv->plat->stmmac_rst) {
  7295			ret = reset_control_assert(priv->plat->stmmac_rst);
  7296			reset_control_deassert(priv->plat->stmmac_rst);
  7297			/* Some reset controllers have only reset callback instead of
  7298			 * assert + deassert callbacks pair.
  7299			 */
  7300			if (ret == -ENOTSUPP)
  7301				reset_control_reset(priv->plat->stmmac_rst);
  7302		}
  7303	
  7304		ret = reset_control_deassert(priv->plat->stmmac_ahb_rst);
  7305		if (ret == -ENOTSUPP)
  7306			dev_err(priv->device, "unable to bring out of ahb reset: %pe\n",
  7307				ERR_PTR(ret));
  7308	
  7309		/* Init MAC and get the capabilities */
  7310		ret = stmmac_hw_init(priv);
  7311		if (ret)
  7312			goto error_hw_init;
  7313	
  7314		/* Only DWMAC core version 5.20 onwards supports HW descriptor prefetch.
  7315		 */
  7316		if (priv->synopsys_id < DWMAC_CORE_5_20)
  7317			priv->plat->dma_cfg->dche = false;
  7318	
  7319		stmmac_check_ether_addr(priv);
  7320	
  7321		ndev->netdev_ops = &stmmac_netdev_ops;
  7322	
  7323		ndev->xdp_metadata_ops = &stmmac_xdp_metadata_ops;
  7324	
  7325		ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
  7326				    NETIF_F_RXCSUM;
  7327		ndev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
  7328				     NETDEV_XDP_ACT_XSK_ZEROCOPY |
  7329				     NETDEV_XDP_ACT_NDO_XMIT;
  7330	
  7331		ret = stmmac_tc_init(priv, priv);
  7332		if (!ret) {
  7333			ndev->hw_features |= NETIF_F_HW_TC;
  7334		}
  7335	
  7336		if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
  7337			ndev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
  7338			if (priv->plat->has_gmac4)
  7339				ndev->hw_features |= NETIF_F_GSO_UDP_L4;
  7340			priv->tso = true;
  7341			dev_info(priv->device, "TSO feature enabled\n");
  7342		}
  7343	
  7344		if (priv->dma_cap.sphen && !priv->plat->sph_disable) {
  7345			ndev->hw_features |= NETIF_F_GRO;
  7346			priv->sph_cap = true;
  7347			priv->sph = priv->sph_cap;
  7348			dev_info(priv->device, "SPH feature enabled\n");
  7349		}
  7350	
  7351		/* Ideally our host DMA address width is the same as for the
  7352		 * device. However, it may differ and then we have to use our
  7353		 * host DMA width for allocation and the device DMA width for
  7354		 * register handling.
  7355		 */
  7356		if (priv->plat->host_dma_width)
  7357			priv->dma_cap.host_dma_width = priv->plat->host_dma_width;
  7358		else
  7359			priv->dma_cap.host_dma_width = priv->dma_cap.addr64;
  7360	
  7361		if (priv->dma_cap.host_dma_width) {
  7362			ret = dma_set_mask_and_coherent(device,
  7363					DMA_BIT_MASK(priv->dma_cap.host_dma_width));
  7364			if (!ret) {
  7365				dev_info(priv->device, "Using %d/%d bits DMA host/device width\n",
  7366					 priv->dma_cap.host_dma_width, priv->dma_cap.addr64);
  7367	
  7368				/*
  7369				 * If more than 32 bits can be addressed, make sure to
  7370				 * enable enhanced addressing mode.
  7371				 */
  7372				if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
  7373					priv->plat->dma_cfg->eame = true;
  7374			} else {
  7375				ret = dma_set_mask_and_coherent(device, DMA_BIT_MASK(32));
  7376				if (ret) {
  7377					dev_err(priv->device, "Failed to set DMA Mask\n");
  7378					goto error_hw_init;
  7379				}
  7380	
  7381				priv->dma_cap.host_dma_width = 32;
  7382			}
  7383		}
  7384	
  7385		ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
  7386		ndev->watchdog_timeo = msecs_to_jiffies(watchdog);
  7387	#ifdef STMMAC_VLAN_TAG_USED
  7388		/* Both mac100 and gmac support receive VLAN tag detection */
  7389		ndev->features |= NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_STAG_RX;
  7390		if (priv->dma_cap.vlhash) {
  7391			ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
  7392			ndev->features |= NETIF_F_HW_VLAN_STAG_FILTER;
  7393		}
  7394		if (priv->dma_cap.vlins) {
  7395			ndev->features |= NETIF_F_HW_VLAN_CTAG_TX;
  7396			if (priv->dma_cap.dvlan)
  7397				ndev->features |= NETIF_F_HW_VLAN_STAG_TX;
  7398		}
  7399	#endif
  7400		priv->msg_enable = netif_msg_init(debug, default_msg_level);
  7401	
  7402		priv->xstats.threshold = tc;
  7403	
  7404		/* Initialize RSS */
  7405		rxq = priv->plat->rx_queues_to_use;
  7406		netdev_rss_key_fill(priv->rss.key, sizeof(priv->rss.key));
  7407		for (i = 0; i < ARRAY_SIZE(priv->rss.table); i++)
  7408			priv->rss.table[i] = ethtool_rxfh_indir_default(i, rxq);
  7409	
  7410		if (priv->dma_cap.rssen && priv->plat->rss_en)
  7411			ndev->features |= NETIF_F_RXHASH;
  7412	
  7413		ndev->vlan_features |= ndev->features;
  7414		/* TSO doesn't work on VLANs yet */
  7415		ndev->vlan_features &= ~NETIF_F_TSO;
  7416	
  7417		/* MTU range: 46 - hw-specific max */
  7418		ndev->min_mtu = ETH_ZLEN - ETH_HLEN;
  7419		if (priv->plat->has_xgmac)
  7420			ndev->max_mtu = XGMAC_JUMBO_LEN;
  7421		else if ((priv->plat->enh_desc) || (priv->synopsys_id >= DWMAC_CORE_4_00))
  7422			ndev->max_mtu = JUMBO_LEN;
  7423		else
  7424			ndev->max_mtu = SKB_MAX_HEAD(NET_SKB_PAD + NET_IP_ALIGN);
  7425		/* Will not overwrite ndev->max_mtu if plat->maxmtu > ndev->max_mtu
  7426		 * as well as plat->maxmtu < ndev->min_mtu which is a invalid range.
  7427		 */
  7428		if ((priv->plat->maxmtu < ndev->max_mtu) &&
  7429		    (priv->plat->maxmtu >= ndev->min_mtu))
  7430			ndev->max_mtu = priv->plat->maxmtu;
  7431		else if (priv->plat->maxmtu < ndev->min_mtu)
  7432			dev_warn(priv->device,
  7433				 "%s: warning: maxmtu having invalid value (%d)\n",
  7434				 __func__, priv->plat->maxmtu);
  7435	
  7436		if (flow_ctrl)
  7437			priv->flow_ctrl = FLOW_AUTO;	/* RX/TX pause on */
  7438	
  7439		ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
  7440	
  7441		/* Setup channels NAPI */
  7442		stmmac_napi_add(ndev);
  7443	
  7444		mutex_init(&priv->lock);
  7445	
  7446		/* If a specific clk_csr value is passed from the platform
  7447		 * this means that the CSR Clock Range selection cannot be
  7448		 * changed at run-time and it is fixed. Viceversa the driver'll try to
  7449		 * set the MDC clock dynamically according to the csr actual
  7450		 * clock input.
  7451		 */
  7452		if (priv->plat->clk_csr >= 0)
  7453			priv->clk_csr = priv->plat->clk_csr;
  7454		else
  7455			stmmac_clk_csr_set(priv);
  7456	
  7457		stmmac_check_pcs_mode(priv);
  7458	
  7459		pm_runtime_get_noresume(device);
  7460		pm_runtime_set_active(device);
  7461		if (!pm_runtime_enabled(device))
  7462			pm_runtime_enable(device);
  7463	
  7464		if (priv->hw->pcs != STMMAC_PCS_TBI &&
  7465		    priv->hw->pcs != STMMAC_PCS_RTBI) {
  7466			/* MDIO bus Registration */
  7467			ret = stmmac_mdio_register(ndev);
  7468			if (ret < 0) {
  7469				dev_err_probe(priv->device, ret,
  7470					      "%s: MDIO bus (id: %d) registration failed\n",
  7471					      __func__, priv->plat->bus_id);
  7472				goto error_mdio_register;
  7473			}
  7474		}
  7475	
  7476		if (priv->plat->speed_mode_2500)
  7477			priv->plat->speed_mode_2500(ndev, priv->plat->bsp_priv);
  7478	
  7479		if (priv->plat->mdio_bus_data && priv->plat->mdio_bus_data->has_xpcs) {
  7480			ret = stmmac_xpcs_setup(priv->mii);
  7481			if (ret)
  7482				goto error_xpcs_setup;
  7483		}
  7484	
  7485		ret = stmmac_phy_setup(priv);
  7486		if (ret) {
  7487			netdev_err(ndev, "failed to setup phy (%d)\n", ret);
  7488			goto error_phy_setup;
  7489		}
  7490	
  7491		ret = register_netdev(ndev);
  7492		if (ret) {
  7493			dev_err(priv->device, "%s: ERROR %i registering the device\n",
  7494				__func__, ret);
  7495			goto error_netdev_register;
  7496		}
  7497	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

