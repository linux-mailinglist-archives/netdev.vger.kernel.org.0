Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B352E305A
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 08:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgL0HJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 02:09:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:19096 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgL0HJn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Dec 2020 02:09:43 -0500
IronPort-SDR: haalM36epSrAik50pB8TANoVhlJUebsPERh+7SDgzKsWtuua973kKoORjoP3siUbVrKgf7dnPK
 LdB1rvHg30OA==
X-IronPort-AV: E=McAfee;i="6000,8403,9846"; a="176389300"
X-IronPort-AV: E=Sophos;i="5.78,452,1599548400"; 
   d="gz'50?scan'50,208,50";a="176389300"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2020 23:09:00 -0800
IronPort-SDR: f2g3G0deIODDqeuhoBNgS0mRKLJCcUmUCkzHaUINntBNM09tBaicWc/eTcW/tehUS4CgsrOpi+
 S2k0X5dUj9KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,452,1599548400"; 
   d="gz'50?scan'50,208,50";a="394696322"
Received: from lkp-server02.sh.intel.com (HELO 4242b19f17ef) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 26 Dec 2020 23:08:56 -0800
Received: from kbuild by 4242b19f17ef with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1ktQAi-0002Kz-9r; Sun, 27 Dec 2020 07:08:56 +0000
Date:   Sun, 27 Dec 2020 15:08:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Holger Assmann <h.assmann@pengutronix.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        kernel@pengutronix.de, Holger Assmann <h.assmann@pengutronix.de>
Subject: Re: [PATCH 1/2] net: stmmac: retain PTP-clock at hwtstamp_set
Message-ID: <202012271401.zkocaNOk-lkp@intel.com>
References: <20201216113239.2980816-1-h.assmann@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20201216113239.2980816-1-h.assmann@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Holger,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9]

url:    https://github.com/0day-ci/linux/commits/Holger-Assmann/net-stmmac-retain-PTP-clock-at-hwtstamp_set/20201216-194127
base:    3db1a3fa98808aa90f95ec3e0fa2fc7abf28f5c9
config: arm-randconfig-r021-20201221 (attached as .config)
compiler: arm-linux-gnueabi-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/303da978c0e8ad80e7577245b7c399f601a29b7a
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Holger-Assmann/net-stmmac-retain-PTP-clock-at-hwtstamp_set/20201216-194127
        git checkout 303da978c0e8ad80e7577245b7c399f601a29b7a
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=arm 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function 'stmmac_hwtstamp_set':
>> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:528:7: warning: variable 'xmac' set but not used [-Wunused-but-set-variable]
     528 |  bool xmac;
         |       ^~~~


vim +/xmac +528 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c

891434b18ec0a21 Rayagond Kokatanur 2013-03-26  503  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  504  /**
d6228b7cdd6e790 Artem Panfilov     2019-01-20  505   *  stmmac_hwtstamp_set - control hardware timestamping.
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  506   *  @dev: device pointer.
8d45e42babb1c7b LABBE Corentin     2017-02-08  507   *  @ifr: An IOCTL specific structure, that can contain a pointer to
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  508   *  a proprietary structure used to pass information to the driver.
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  509   *  Description:
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  510   *  This function configures the MAC to enable/disable both outgoing(TX)
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  511   *  and incoming(RX) packets time stamping based on user input.
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  512   *  Return Value:
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  513   *  0 on success and an appropriate -ve integer on failure.
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  514   */
d6228b7cdd6e790 Artem Panfilov     2019-01-20  515  static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  516  {
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  517  	struct stmmac_priv *priv = netdev_priv(dev);
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  518  	struct hwtstamp_config config;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  519  	u32 ptp_v2 = 0;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  520  	u32 tstamp_all = 0;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  521  	u32 ptp_over_ipv4_udp = 0;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  522  	u32 ptp_over_ipv6_udp = 0;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  523  	u32 ptp_over_ethernet = 0;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  524  	u32 snap_type_sel = 0;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  525  	u32 ts_master_en = 0;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  526  	u32 ts_event_en = 0;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  527  	u32 value = 0;
7d9e6c5afab6bfb Jose Abreu         2018-08-08 @528  	bool xmac;
7d9e6c5afab6bfb Jose Abreu         2018-08-08  529  
7d9e6c5afab6bfb Jose Abreu         2018-08-08  530  	xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  531  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  532  	if (!(priv->dma_cap.time_stamp || priv->adv_ts)) {
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  533  		netdev_alert(priv->dev, "No support for HW time stamping\n");
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  534  		priv->hwts_tx_en = 0;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  535  		priv->hwts_rx_en = 0;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  536  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  537  		return -EOPNOTSUPP;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  538  	}
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  539  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  540  	if (copy_from_user(&config, ifr->ifr_data,
d6228b7cdd6e790 Artem Panfilov     2019-01-20  541  			   sizeof(config)))
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  542  		return -EFAULT;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  543  
38ddc59d65b6d97 LABBE Corentin     2016-11-16  544  	netdev_dbg(priv->dev, "%s config flags:0x%x, tx_type:0x%x, rx_filter:0x%x\n",
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  545  		   __func__, config.flags, config.tx_type, config.rx_filter);
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  546  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  547  	/* reserved for future extensions */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  548  	if (config.flags)
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  549  		return -EINVAL;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  550  
5f3da3281932a79 Ben Hutchings      2013-11-14  551  	if (config.tx_type != HWTSTAMP_TX_OFF &&
5f3da3281932a79 Ben Hutchings      2013-11-14  552  	    config.tx_type != HWTSTAMP_TX_ON)
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  553  		return -ERANGE;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  554  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  555  	if (priv->adv_ts) {
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  556  		switch (config.rx_filter) {
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  557  		case HWTSTAMP_FILTER_NONE:
ceb694997e1b5d4 Giuseppe CAVALLARO 2013-04-08  558  			/* time stamp no incoming packet at all */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  559  			config.rx_filter = HWTSTAMP_FILTER_NONE;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  560  			break;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  561  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  562  		case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
ceb694997e1b5d4 Giuseppe CAVALLARO 2013-04-08  563  			/* PTP v1, UDP, any kind of event packet */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  564  			config.rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
7d8e249f393a1ac Ilias Apalodimas   2019-02-05  565  			/* 'xmac' hardware can support Sync, Pdelay_Req and
7d8e249f393a1ac Ilias Apalodimas   2019-02-05  566  			 * Pdelay_resp by setting bit14 and bits17/16 to 01
7d8e249f393a1ac Ilias Apalodimas   2019-02-05  567  			 * This leaves Delay_Req timestamps out.
7d8e249f393a1ac Ilias Apalodimas   2019-02-05  568  			 * Enable all events *and* general purpose message
7d8e249f393a1ac Ilias Apalodimas   2019-02-05  569  			 * timestamping
7d8e249f393a1ac Ilias Apalodimas   2019-02-05  570  			 */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  571  			snap_type_sel = PTP_TCR_SNAPTYPSEL_1;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  572  			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  573  			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  574  			break;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  575  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  576  		case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
ceb694997e1b5d4 Giuseppe CAVALLARO 2013-04-08  577  			/* PTP v1, UDP, Sync packet */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  578  			config.rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_SYNC;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  579  			/* take time stamp for SYNC messages only */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  580  			ts_event_en = PTP_TCR_TSEVNTENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  581  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  582  			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  583  			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  584  			break;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  585  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  586  		case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
ceb694997e1b5d4 Giuseppe CAVALLARO 2013-04-08  587  			/* PTP v1, UDP, Delay_req packet */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  588  			config.rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  589  			/* take time stamp for Delay_Req messages only */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  590  			ts_master_en = PTP_TCR_TSMSTRENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  591  			ts_event_en = PTP_TCR_TSEVNTENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  592  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  593  			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  594  			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  595  			break;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  596  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  597  		case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
ceb694997e1b5d4 Giuseppe CAVALLARO 2013-04-08  598  			/* PTP v2, UDP, any kind of event packet */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  599  			config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  600  			ptp_v2 = PTP_TCR_TSVER2ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  601  			/* take time stamp for all event messages */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  602  			snap_type_sel = PTP_TCR_SNAPTYPSEL_1;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  603  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  604  			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  605  			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  606  			break;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  607  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  608  		case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
ceb694997e1b5d4 Giuseppe CAVALLARO 2013-04-08  609  			/* PTP v2, UDP, Sync packet */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  610  			config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_SYNC;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  611  			ptp_v2 = PTP_TCR_TSVER2ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  612  			/* take time stamp for SYNC messages only */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  613  			ts_event_en = PTP_TCR_TSEVNTENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  614  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  615  			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  616  			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  617  			break;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  618  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  619  		case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
ceb694997e1b5d4 Giuseppe CAVALLARO 2013-04-08  620  			/* PTP v2, UDP, Delay_req packet */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  621  			config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  622  			ptp_v2 = PTP_TCR_TSVER2ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  623  			/* take time stamp for Delay_Req messages only */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  624  			ts_master_en = PTP_TCR_TSMSTRENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  625  			ts_event_en = PTP_TCR_TSEVNTENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  626  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  627  			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  628  			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  629  			break;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  630  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  631  		case HWTSTAMP_FILTER_PTP_V2_EVENT:
ceb694997e1b5d4 Giuseppe CAVALLARO 2013-04-08  632  			/* PTP v2/802.AS1 any layer, any kind of event packet */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  633  			config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  634  			ptp_v2 = PTP_TCR_TSVER2ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  635  			snap_type_sel = PTP_TCR_SNAPTYPSEL_1;
f2fb6b6275eba9d Fugang Duan        2020-05-25  636  			if (priv->synopsys_id != DWMAC_CORE_5_10)
14f347334bf2320 Jose Abreu         2019-09-30  637  				ts_event_en = PTP_TCR_TSEVNTENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  638  			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  639  			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  640  			ptp_over_ethernet = PTP_TCR_TSIPENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  641  			break;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  642  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  643  		case HWTSTAMP_FILTER_PTP_V2_SYNC:
ceb694997e1b5d4 Giuseppe CAVALLARO 2013-04-08  644  			/* PTP v2/802.AS1, any layer, Sync packet */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  645  			config.rx_filter = HWTSTAMP_FILTER_PTP_V2_SYNC;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  646  			ptp_v2 = PTP_TCR_TSVER2ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  647  			/* take time stamp for SYNC messages only */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  648  			ts_event_en = PTP_TCR_TSEVNTENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  649  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  650  			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  651  			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  652  			ptp_over_ethernet = PTP_TCR_TSIPENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  653  			break;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  654  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  655  		case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
ceb694997e1b5d4 Giuseppe CAVALLARO 2013-04-08  656  			/* PTP v2/802.AS1, any layer, Delay_req packet */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  657  			config.rx_filter = HWTSTAMP_FILTER_PTP_V2_DELAY_REQ;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  658  			ptp_v2 = PTP_TCR_TSVER2ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  659  			/* take time stamp for Delay_Req messages only */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  660  			ts_master_en = PTP_TCR_TSMSTRENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  661  			ts_event_en = PTP_TCR_TSEVNTENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  662  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  663  			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  664  			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  665  			ptp_over_ethernet = PTP_TCR_TSIPENA;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  666  			break;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  667  
e3412575488ac24 Miroslav Lichvar   2017-05-19  668  		case HWTSTAMP_FILTER_NTP_ALL:
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  669  		case HWTSTAMP_FILTER_ALL:
ceb694997e1b5d4 Giuseppe CAVALLARO 2013-04-08  670  			/* time stamp any incoming packet */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  671  			config.rx_filter = HWTSTAMP_FILTER_ALL;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  672  			tstamp_all = PTP_TCR_TSENALL;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  673  			break;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  674  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  675  		default:
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  676  			return -ERANGE;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  677  		}
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  678  	} else {
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  679  		switch (config.rx_filter) {
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  680  		case HWTSTAMP_FILTER_NONE:
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  681  			config.rx_filter = HWTSTAMP_FILTER_NONE;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  682  			break;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  683  		default:
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  684  			/* PTP v1, UDP, any kind of event packet */
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  685  			config.rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  686  			break;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  687  		}
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  688  	}
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  689  	priv->hwts_rx_en = ((config.rx_filter == HWTSTAMP_FILTER_NONE) ? 0 : 1);
5f3da3281932a79 Ben Hutchings      2013-11-14  690  	priv->hwts_tx_en = config.tx_type == HWTSTAMP_TX_ON;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  691  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  692  	if (!priv->hwts_tx_en && !priv->hwts_rx_en)
303da978c0e8ad8 Holger Assmann     2020-12-16  693  		stmmac_config_hw_tstamping(priv, priv->ptpaddr, STMMAC_HWTS_ACTIVE);
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  694  	else {
303da978c0e8ad8 Holger Assmann     2020-12-16  695  		value = (STMMAC_HWTS_ACTIVE |
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  696  			 tstamp_all | ptp_v2 | ptp_over_ethernet |
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  697  			 ptp_over_ipv6_udp | ptp_over_ipv4_udp | ts_event_en |
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  698  			 ts_master_en | snap_type_sel);
cc4c9001ce31e0c Jose Abreu         2018-04-16  699  		stmmac_config_hw_tstamping(priv, priv->ptpaddr, value);
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  700  		
303da978c0e8ad8 Holger Assmann     2020-12-16  701  		/* Store flags for later use */
9a8a02c9d46dcd4 Jose Abreu         2018-05-31  702  		priv->systime_flags = value;
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  703  	}
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  704  
d6228b7cdd6e790 Artem Panfilov     2019-01-20  705  	memcpy(&priv->tstamp_config, &config, sizeof(config));
d6228b7cdd6e790 Artem Panfilov     2019-01-20  706  
891434b18ec0a21 Rayagond Kokatanur 2013-03-26  707  	return copy_to_user(ifr->ifr_data, &config,
d6228b7cdd6e790 Artem Panfilov     2019-01-20  708  			    sizeof(config)) ? -EFAULT : 0;
d6228b7cdd6e790 Artem Panfilov     2019-01-20  709  }
d6228b7cdd6e790 Artem Panfilov     2019-01-20  710  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--k1lZvvs/B4yU6o8G
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--k1lZvvs/B4yU6o8G--
