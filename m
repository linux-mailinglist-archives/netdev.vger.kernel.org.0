Return-Path: <netdev+bounces-11665-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F939733DB7
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 05:10:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F2521C21077
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 03:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3399BA3D;
	Sat, 17 Jun 2023 03:10:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257EBA29
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 03:10:14 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BF61A4;
	Fri, 16 Jun 2023 20:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686971412; x=1718507412;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5k95Dp86/Uy3rBDuNE1x/r3ou/qVh4vGNpZK36uaSuU=;
  b=UKKloB7kQewfLOlbG8BnUtE21ad82fBYfyRxQMFDwGpjK47DtQED1QhN
   /bc+NNiPBWXp+JnuDYmP9lUB6wcD2jT8sFEycr4rKOTD+ns4pUS7WTWM0
   AQr805ad69UMNmimTgkgoYDrC/UJm2oGTeg2RchiO9zNaoNa9SuIYohHK
   lLTBJGd2KXr/x4a62NFiSNPCECcoA3/jars1mchREbmmmgCdL8yXSz0oo
   hs5bmsmW/GNHA7zRhb9X69D79/9mWgaorCsH2NcqsvpKSpWkPg3YJgpEb
   Pu+CsN90OCUMhx6AkMWHwwWA2Ng9dAGEYJrrcfoRxoIF3rI/QkwoxA28I
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="425296005"
X-IronPort-AV: E=Sophos;i="6.00,249,1681196400"; 
   d="scan'208";a="425296005"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 20:10:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="1043294511"
X-IronPort-AV: E=Sophos;i="6.00,249,1681196400"; 
   d="scan'208";a="1043294511"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jun 2023 20:10:08 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qAMKF-00028i-2b;
	Sat, 17 Jun 2023 03:10:07 +0000
Date: Sat, 17 Jun 2023 11:09:45 +0800
From: kernel test robot <lkp@intel.com>
To: alexis.lothore@bootlin.com, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Nicolas Carrier <nicolas.carrier@nav-timing.safrangroup.com>
Subject: Re: [PATCH net-next 3/8] net: stmmac: move PTP interrupt handling to
 IP-specific DWMAC file
Message-ID: <202306171135.YYkItsr2-lkp@intel.com>
References: <20230616100409.164583-4-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616100409.164583-4-alexis.lothore@bootlin.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/alexis-lothore-bootlin-com/net-stmmac-add-IP-specific-callbacks-for-auxiliary-snapshot/20230616-180912
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230616100409.164583-4-alexis.lothore%40bootlin.com
patch subject: [PATCH net-next 3/8] net: stmmac: move PTP interrupt handling to IP-specific DWMAC file
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20230617/202306171135.YYkItsr2-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce: (https://download.01.org/0day-ci/archive/20230617/202306171135.YYkItsr2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306171135.YYkItsr2-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c: In function 'intel_crosststamp':
>> drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c:336:37: error: 'PTP_ACR' undeclared (first use in this function); did you mean 'PTP_TCR'?
     336 |         acr_value = readl(ptpaddr + PTP_ACR);
         |                                     ^~~~~~~
         |                                     PTP_TCR
   drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c:336:37: note: each undeclared identifier is reported only once for each function it appears in


vim +336 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c

76c16d3e19446d Wong Vee Khee  2022-07-14  303  
341f67e424e572 Tan Tee Min    2021-03-23  304  static int intel_crosststamp(ktime_t *device,
341f67e424e572 Tan Tee Min    2021-03-23  305  			     struct system_counterval_t *system,
341f67e424e572 Tan Tee Min    2021-03-23  306  			     void *ctx)
341f67e424e572 Tan Tee Min    2021-03-23  307  {
341f67e424e572 Tan Tee Min    2021-03-23  308  	struct intel_priv_data *intel_priv;
341f67e424e572 Tan Tee Min    2021-03-23  309  
341f67e424e572 Tan Tee Min    2021-03-23  310  	struct stmmac_priv *priv = (struct stmmac_priv *)ctx;
341f67e424e572 Tan Tee Min    2021-03-23  311  	void __iomem *ptpaddr = priv->ptpaddr;
341f67e424e572 Tan Tee Min    2021-03-23  312  	void __iomem *ioaddr = priv->hw->pcsr;
341f67e424e572 Tan Tee Min    2021-03-23  313  	unsigned long flags;
341f67e424e572 Tan Tee Min    2021-03-23  314  	u64 art_time = 0;
341f67e424e572 Tan Tee Min    2021-03-23  315  	u64 ptp_time = 0;
341f67e424e572 Tan Tee Min    2021-03-23  316  	u32 num_snapshot;
341f67e424e572 Tan Tee Min    2021-03-23  317  	u32 gpio_value;
341f67e424e572 Tan Tee Min    2021-03-23  318  	u32 acr_value;
341f67e424e572 Tan Tee Min    2021-03-23  319  	int i;
341f67e424e572 Tan Tee Min    2021-03-23  320  
341f67e424e572 Tan Tee Min    2021-03-23  321  	if (!boot_cpu_has(X86_FEATURE_ART))
341f67e424e572 Tan Tee Min    2021-03-23  322  		return -EOPNOTSUPP;
341f67e424e572 Tan Tee Min    2021-03-23  323  
341f67e424e572 Tan Tee Min    2021-03-23  324  	intel_priv = priv->plat->bsp_priv;
341f67e424e572 Tan Tee Min    2021-03-23  325  
f4da56529da602 Tan Tee Min    2021-04-14  326  	/* Both internal crosstimestamping and external triggered event
f4da56529da602 Tan Tee Min    2021-04-14  327  	 * timestamping cannot be run concurrently.
f4da56529da602 Tan Tee Min    2021-04-14  328  	 */
f4da56529da602 Tan Tee Min    2021-04-14  329  	if (priv->plat->ext_snapshot_en)
f4da56529da602 Tan Tee Min    2021-04-14  330  		return -EBUSY;
f4da56529da602 Tan Tee Min    2021-04-14  331  
76c16d3e19446d Wong Vee Khee  2022-07-14  332  	priv->plat->int_snapshot_en = 1;
76c16d3e19446d Wong Vee Khee  2022-07-14  333  
f4da56529da602 Tan Tee Min    2021-04-14  334  	mutex_lock(&priv->aux_ts_lock);
341f67e424e572 Tan Tee Min    2021-03-23  335  	/* Enable Internal snapshot trigger */
341f67e424e572 Tan Tee Min    2021-03-23 @336  	acr_value = readl(ptpaddr + PTP_ACR);
341f67e424e572 Tan Tee Min    2021-03-23  337  	acr_value &= ~PTP_ACR_MASK;
341f67e424e572 Tan Tee Min    2021-03-23  338  	switch (priv->plat->int_snapshot_num) {
341f67e424e572 Tan Tee Min    2021-03-23  339  	case AUX_SNAPSHOT0:
341f67e424e572 Tan Tee Min    2021-03-23  340  		acr_value |= PTP_ACR_ATSEN0;
341f67e424e572 Tan Tee Min    2021-03-23  341  		break;
341f67e424e572 Tan Tee Min    2021-03-23  342  	case AUX_SNAPSHOT1:
341f67e424e572 Tan Tee Min    2021-03-23  343  		acr_value |= PTP_ACR_ATSEN1;
341f67e424e572 Tan Tee Min    2021-03-23  344  		break;
341f67e424e572 Tan Tee Min    2021-03-23  345  	case AUX_SNAPSHOT2:
341f67e424e572 Tan Tee Min    2021-03-23  346  		acr_value |= PTP_ACR_ATSEN2;
341f67e424e572 Tan Tee Min    2021-03-23  347  		break;
341f67e424e572 Tan Tee Min    2021-03-23  348  	case AUX_SNAPSHOT3:
341f67e424e572 Tan Tee Min    2021-03-23  349  		acr_value |= PTP_ACR_ATSEN3;
341f67e424e572 Tan Tee Min    2021-03-23  350  		break;
341f67e424e572 Tan Tee Min    2021-03-23  351  	default:
53e35ebb9a17fd Dan Carpenter  2021-04-21  352  		mutex_unlock(&priv->aux_ts_lock);
76c16d3e19446d Wong Vee Khee  2022-07-14  353  		priv->plat->int_snapshot_en = 0;
341f67e424e572 Tan Tee Min    2021-03-23  354  		return -EINVAL;
341f67e424e572 Tan Tee Min    2021-03-23  355  	}
341f67e424e572 Tan Tee Min    2021-03-23  356  	writel(acr_value, ptpaddr + PTP_ACR);
341f67e424e572 Tan Tee Min    2021-03-23  357  
341f67e424e572 Tan Tee Min    2021-03-23  358  	/* Clear FIFO */
341f67e424e572 Tan Tee Min    2021-03-23  359  	acr_value = readl(ptpaddr + PTP_ACR);
341f67e424e572 Tan Tee Min    2021-03-23  360  	acr_value |= PTP_ACR_ATSFC;
341f67e424e572 Tan Tee Min    2021-03-23  361  	writel(acr_value, ptpaddr + PTP_ACR);
f4da56529da602 Tan Tee Min    2021-04-14  362  	/* Release the mutex */
f4da56529da602 Tan Tee Min    2021-04-14  363  	mutex_unlock(&priv->aux_ts_lock);
341f67e424e572 Tan Tee Min    2021-03-23  364  
341f67e424e572 Tan Tee Min    2021-03-23  365  	/* Trigger Internal snapshot signal
341f67e424e572 Tan Tee Min    2021-03-23  366  	 * Create a rising edge by just toggle the GPO1 to low
341f67e424e572 Tan Tee Min    2021-03-23  367  	 * and back to high.
341f67e424e572 Tan Tee Min    2021-03-23  368  	 */
341f67e424e572 Tan Tee Min    2021-03-23  369  	gpio_value = readl(ioaddr + GMAC_GPIO_STATUS);
341f67e424e572 Tan Tee Min    2021-03-23  370  	gpio_value &= ~GMAC_GPO1;
341f67e424e572 Tan Tee Min    2021-03-23  371  	writel(gpio_value, ioaddr + GMAC_GPIO_STATUS);
341f67e424e572 Tan Tee Min    2021-03-23  372  	gpio_value |= GMAC_GPO1;
341f67e424e572 Tan Tee Min    2021-03-23  373  	writel(gpio_value, ioaddr + GMAC_GPIO_STATUS);
341f67e424e572 Tan Tee Min    2021-03-23  374  
76c16d3e19446d Wong Vee Khee  2022-07-14  375  	/* Time sync done Indication - Interrupt method */
76c16d3e19446d Wong Vee Khee  2022-07-14  376  	if (!wait_event_interruptible_timeout(priv->tstamp_busy_wait,
76c16d3e19446d Wong Vee Khee  2022-07-14  377  					      stmmac_cross_ts_isr(priv),
76c16d3e19446d Wong Vee Khee  2022-07-14  378  					      HZ / 100)) {
76c16d3e19446d Wong Vee Khee  2022-07-14  379  		priv->plat->int_snapshot_en = 0;
76c16d3e19446d Wong Vee Khee  2022-07-14  380  		return -ETIMEDOUT;
341f67e424e572 Tan Tee Min    2021-03-23  381  	}
341f67e424e572 Tan Tee Min    2021-03-23  382  
341f67e424e572 Tan Tee Min    2021-03-23  383  	num_snapshot = (readl(ioaddr + GMAC_TIMESTAMP_STATUS) &
341f67e424e572 Tan Tee Min    2021-03-23  384  			GMAC_TIMESTAMP_ATSNS_MASK) >>
341f67e424e572 Tan Tee Min    2021-03-23  385  			GMAC_TIMESTAMP_ATSNS_SHIFT;
341f67e424e572 Tan Tee Min    2021-03-23  386  
341f67e424e572 Tan Tee Min    2021-03-23  387  	/* Repeat until the timestamps are from the FIFO last segment */
341f67e424e572 Tan Tee Min    2021-03-23  388  	for (i = 0; i < num_snapshot; i++) {
642436a1ad34a2 Yannick Vignon 2022-02-04  389  		read_lock_irqsave(&priv->ptp_lock, flags);
341f67e424e572 Tan Tee Min    2021-03-23  390  		stmmac_get_ptptime(priv, ptpaddr, &ptp_time);
341f67e424e572 Tan Tee Min    2021-03-23  391  		*device = ns_to_ktime(ptp_time);
642436a1ad34a2 Yannick Vignon 2022-02-04  392  		read_unlock_irqrestore(&priv->ptp_lock, flags);
341f67e424e572 Tan Tee Min    2021-03-23  393  		get_arttime(priv->mii, intel_priv->mdio_adhoc_addr, &art_time);
341f67e424e572 Tan Tee Min    2021-03-23  394  		*system = convert_art_to_tsc(art_time);
341f67e424e572 Tan Tee Min    2021-03-23  395  	}
341f67e424e572 Tan Tee Min    2021-03-23  396  
1c137d4777b5b6 Wong Vee Khee  2021-03-30  397  	system->cycles *= intel_priv->crossts_adj;
76c16d3e19446d Wong Vee Khee  2022-07-14  398  	priv->plat->int_snapshot_en = 0;
1c137d4777b5b6 Wong Vee Khee  2021-03-30  399  
341f67e424e572 Tan Tee Min    2021-03-23  400  	return 0;
341f67e424e572 Tan Tee Min    2021-03-23  401  }
341f67e424e572 Tan Tee Min    2021-03-23  402  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

