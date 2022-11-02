Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D202615EE1
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 10:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiKBJHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 05:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiKBJGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 05:06:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FBE286D9;
        Wed,  2 Nov 2022 02:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667379861; x=1698915861;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2y36wopekY/PRkNF2CE6hHuB05RYLqpv0O0dYrPYkxY=;
  b=UKV9TRI/tLMbftC3nD98Dx2OCnCbK+Zrs3KPujushOWiA3qvaY3gjEjk
   wJWn8CgeUb82hk/eiKmHFIpNzzmesvmM9E2iL3NqUdkT+qtt/0966TO3A
   6jxCQ3T7VPNsocmzYX6PxPTA1W0Vn9vNJmWX1BUJhusaQ9oro8uLWYyxy
   45his6u214rscVHk8eEkDzA2chqSuJvu2rVEuLz/80waS1wVeQDAgFZG5
   dDoQyCPJxCQfS8b6+07hcS1I+MllHRol7FJX59B2/yu4B8DrbCNezlSZp
   +MZ7QluyBt3sLxwSyVR7FjQ9COmhraNW5BziM2UrbpKfWq4Yo904ApqpL
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="181560616"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Nov 2022 02:04:20 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 2 Nov 2022 02:04:19 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 2 Nov 2022 02:04:19 -0700
Date:   Wed, 2 Nov 2022 10:09:02 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <pabeni@redhat.com>, <edumazet@google.com>, <olteanv@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next V5] net: lan743x: Add support to SGMII register
 dump for PCI11010/PCI11414 chips
Message-ID: <20221102090902.kv7kgynxpo6zihus@soft-dev3-1>
References: <20221102052802.5460-1-Raju.Lakkaraju@microchip.com>
 <20221102083154.jjf5ht5s7ekvwd4n@soft-dev3-1>
 <20221102084642.GA27153@raju-project-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221102084642.GA27153@raju-project-pc>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/02/2022 14:16, Raju Lakkaraju wrote:
> > > +static void lan743x_sgmii_regs(struct net_device *dev, void *p)
> > > +{
> > > +	struct lan743x_adapter *adp = netdev_priv(dev);
> > > +	u32 *rb = p;
> > > +	u16 idx;
> > > +	int val;
> > > +	struct {
> > > +		u8 id;
> > > +		u8 dev;
> > > +		u16 addr;
> > > +	} regs[] = {
> > > +		{ ETH_SR_VSMMD_DEV_ID1,                MDIO_MMD_VEND1, 0x0002},
> > > +		{ ETH_SR_VSMMD_DEV_ID2,                MDIO_MMD_VEND1, 0x0003},
> > > +		{ ETH_SR_VSMMD_PCS_ID1,                MDIO_MMD_VEND1, 0x0004},
> > > +		{ ETH_SR_VSMMD_PCS_ID2,                MDIO_MMD_VEND1, 0x0005},
> > > +		{ ETH_SR_VSMMD_STS,                    MDIO_MMD_VEND1, 0x0008},
> > > +		{ ETH_SR_VSMMD_CTRL,                   MDIO_MMD_VEND1, 0x0009},
> > > +		{ ETH_SR_MII_CTRL,                     MDIO_MMD_VEND2, 0x0000},
> > > +		{ ETH_SR_MII_STS,                      MDIO_MMD_VEND2, 0x0001},
> > > +		{ ETH_SR_MII_DEV_ID1,                  MDIO_MMD_VEND2, 0x0002},
> > > +		{ ETH_SR_MII_DEV_ID2,                  MDIO_MMD_VEND2, 0x0003},
> > > +		{ ETH_SR_MII_AN_ADV,                   MDIO_MMD_VEND2, 0x0004},
> > > +		{ ETH_SR_MII_LP_BABL,                  MDIO_MMD_VEND2, 0x0005},
> > > +		{ ETH_SR_MII_EXPN,                     MDIO_MMD_VEND2, 0x0006},
> > > +		{ ETH_SR_MII_EXT_STS,                  MDIO_MMD_VEND2, 0x000F},
> > > +		{ ETH_SR_MII_TIME_SYNC_ABL,            MDIO_MMD_VEND2, 0x0708},
> > > +		{ ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_LWR, MDIO_MMD_VEND2, 0x0709},
> > > +		{ ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_UPR, MDIO_MMD_VEND2, 0x070A},
> > > +		{ ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_LWR, MDIO_MMD_VEND2, 0x070B},
> > > +		{ ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_UPR, MDIO_MMD_VEND2, 0x070C},
> > > +		{ ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_LWR, MDIO_MMD_VEND2, 0x070D},
> > > +		{ ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_UPR, MDIO_MMD_VEND2, 0x070E},
> > > +		{ ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_LWR, MDIO_MMD_VEND2, 0x070F},
> > > +		{ ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_UPR, MDIO_MMD_VEND2, 0x0710},
> > > +		{ ETH_VR_MII_DIG_CTRL1,                MDIO_MMD_VEND2, 0x8000},
> > > +		{ ETH_VR_MII_AN_CTRL,                  MDIO_MMD_VEND2, 0x8001},
> > > +		{ ETH_VR_MII_AN_INTR_STS,              MDIO_MMD_VEND2, 0x8002},
> > > +		{ ETH_VR_MII_TC,                       MDIO_MMD_VEND2, 0x8003},
> > > +		{ ETH_VR_MII_DBG_CTRL,                 MDIO_MMD_VEND2, 0x8005},
> > > +		{ ETH_VR_MII_EEE_MCTRL0,               MDIO_MMD_VEND2, 0x8006},
> > > +		{ ETH_VR_MII_EEE_TXTIMER,              MDIO_MMD_VEND2, 0x8008},
> > > +		{ ETH_VR_MII_EEE_RXTIMER,              MDIO_MMD_VEND2, 0x8009},
> > > +		{ ETH_VR_MII_LINK_TIMER_CTRL,          MDIO_MMD_VEND2, 0x800A},
> > > +		{ ETH_VR_MII_EEE_MCTRL1,               MDIO_MMD_VEND2, 0x800B},
> > > +		{ ETH_VR_MII_DIG_STS,                  MDIO_MMD_VEND2, 0x8010},
> > > +		{ ETH_VR_MII_ICG_ERRCNT1,              MDIO_MMD_VEND2, 0x8011},
> > > +		{ ETH_VR_MII_GPIO,                     MDIO_MMD_VEND2, 0x8015},
> > > +		{ ETH_VR_MII_EEE_LPI_STATUS,           MDIO_MMD_VEND2, 0x8016},
> > > +		{ ETH_VR_MII_EEE_WKERR,                MDIO_MMD_VEND2, 0x8017},
> > > +		{ ETH_VR_MII_MISC_STS,                 MDIO_MMD_VEND2, 0x8018},
> > > +		{ ETH_VR_MII_RX_LSTS,                  MDIO_MMD_VEND2, 0x8020},
> > > +		{ ETH_VR_MII_GEN2_GEN4_TX_BSTCTRL0,    MDIO_MMD_VEND2, 0x8038},
> > > +		{ ETH_VR_MII_GEN2_GEN4_TX_LVLCTRL0,    MDIO_MMD_VEND2, 0x803A},
> > > +		{ ETH_VR_MII_GEN2_GEN4_TXGENCTRL0,     MDIO_MMD_VEND2, 0x803C},
> > > +		{ ETH_VR_MII_GEN2_GEN4_TXGENCTRL1,     MDIO_MMD_VEND2, 0x803D},
> > > +		{ ETH_VR_MII_GEN4_TXGENCTRL2,          MDIO_MMD_VEND2, 0x803E},
> > > +		{ ETH_VR_MII_GEN2_GEN4_TX_STS,         MDIO_MMD_VEND2, 0x8048},
> > > +		{ ETH_VR_MII_GEN2_GEN4_RXGENCTRL0,     MDIO_MMD_VEND2, 0x8058},
> > > +		{ ETH_VR_MII_GEN2_GEN4_RXGENCTRL1,     MDIO_MMD_VEND2, 0x8059},
> > > +		{ ETH_VR_MII_GEN4_RXEQ_CTRL,           MDIO_MMD_VEND2, 0x805B},
> > > +		{ ETH_VR_MII_GEN4_RXLOS_CTRL0,         MDIO_MMD_VEND2, 0x805D},
> > > +		{ ETH_VR_MII_GEN2_GEN4_MPLL_CTRL0,     MDIO_MMD_VEND2, 0x8078},
> > > +		{ ETH_VR_MII_GEN2_GEN4_MPLL_CTRL1,     MDIO_MMD_VEND2, 0x8079},
> > > +		{ ETH_VR_MII_GEN2_GEN4_MPLL_STS,       MDIO_MMD_VEND2, 0x8088},
> > > +		{ ETH_VR_MII_GEN2_GEN4_LVL_CTRL,       MDIO_MMD_VEND2, 0x8090},
> > > +		{ ETH_VR_MII_GEN4_MISC_CTRL2,          MDIO_MMD_VEND2, 0x8093},
> > > +		{ ETH_VR_MII_GEN2_GEN4_MISC_CTRL0,     MDIO_MMD_VEND2, 0x8099},
> > > +		{ ETH_VR_MII_GEN2_GEN4_MISC_CTRL1,     MDIO_MMD_VEND2, 0x809A},
> > > +		{ ETH_VR_MII_SNPS_CR_CTRL,             MDIO_MMD_VEND2, 0x80A0},
> > > +		{ ETH_VR_MII_SNPS_CR_ADDR,             MDIO_MMD_VEND2, 0x80A1},
> > > +		{ ETH_VR_MII_SNPS_CR_DATA,             MDIO_MMD_VEND2, 0x80A2},
> > > +		{ ETH_VR_MII_DIG_CTRL2,                MDIO_MMD_VEND2, 0x80E1},
> > > +		{ ETH_VR_MII_DIG_ERRCNT,               MDIO_MMD_VEND2, 0x80E2},
> > > +	};
> > > +
> > > +	for (idx = 0; idx < ARRAY_SIZE(regs) / sizeof(regs[0]); idx++) {
> > 
> > Is this correct?
> 
> Yes.
> 
> > You have 62 entries but you go only over the first 15. Or am I
> > misunderstood something?
> 
> Your ethtool application don't have SGMII register dump register
> definitions.
> Once This patch accept by Linux community, I will submit ethtool application
> changes to "Ethtool development community".
> 
> For your reference, Please find the attached file
> (sgmii_sgmii_regdump_cmd.txt).

I don't think this has anything to do with ethtool.
Your array has 64 entries and the for loop goes from 0 to 15. So it
doesn't read all the registers. Of course ethtool will dump all the
registers but only first 15 might have a value different than 0. After
that all of them will be 0 regardless if in the HW is a different value.


> > 
> > > +		val = lan743x_sgmii_read(adp, regs[idx].dev, regs[idx].addr);
> > > +		if (val < 0)
> > > +			rb[regs[idx].id] = 0xFFFF;
> > > +		else
> > > +			rb[regs[idx].id] = val;
> > > +	}
> > > +}
> > > +

-- 
/Horatiu
