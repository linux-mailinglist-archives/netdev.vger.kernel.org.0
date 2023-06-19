Return-Path: <netdev+bounces-11843-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E70A734CB6
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F7571C208B7
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 07:53:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604CF539C;
	Mon, 19 Jun 2023 07:53:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536AB5395
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:53:29 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF9CFA;
	Mon, 19 Jun 2023 00:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1687161207; x=1718697207;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MiB/if3MwjUhaxKHqfTF5j5XLIhDj9DbE/a/MWuxAUI=;
  b=Og9JYVciaH4dGSm2tSYwomtoqTbbDJHSgtlDQzLCELJKym65Kp6gyRMU
   jxAeBnMgMee9UbaDbCMieWnT9PjWYZBYn8D+TE1xx5dFJhic/lL54m4c0
   CA7rcKm2mKCBc98S/sw+eUlmu1Woaz9Gd2mW+ZSCajlzdwimyGb3760af
   Qg4OPG2rCdV2i+Hp1pCj5d0RKyXTiC6JtPlQQYgP0xR6qR4AVfw6uwpiJ
   VDbc+XzJbmQ0rJTrd4iMt6m8s9dBGvER4bdQnDJQdJ1CncDaJsjnUFCYZ
   o8SB+PSthiwfXuMPy993XeOvSLEg0eQzdWHQq0PfuulnHAOegmkXVao5/
   w==;
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="219214935"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jun 2023 00:53:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 19 Jun 2023 00:53:26 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 19 Jun 2023 00:53:26 -0700
Date: Mon, 19 Jun 2023 09:53:25 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
CC: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <sebastian.tobuschat@nxp.com>
Subject: Re: [PATCH net-next v1 05/14] net: phy: nxp-c45-tja11xx: prepare the
 ground for TJA1120
Message-ID: <20230619075325.ywg4jv6h2hifqjx4@soft-dev3-1>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-6-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230616135323.98215-6-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 06/16/2023 16:53, Radu Pirea (NXP OSS) wrote:

Hi Radu,

> 
> 
> -struct nxp_c45_phy_stats {
> -       const char      *name;
> -       u8              mmd;
> -       u16             reg;
> -       u8              off;
> -       u16             mask;
> -};
> +static inline

It is recommended not to use inline inside .c files.

> +const struct nxp_c45_phy_data *nxp_c45_get_data(struct phy_device *phydev)
> +{
> +       return phydev->drv->driver_data;
> +}
> +
> +static inline
> +const struct nxp_c45_regmap *nxp_c45_get_regmap(struct phy_device *phydev)
> +{
> +       const struct nxp_c45_phy_data *phy_data = nxp_c45_get_data(phydev);
> +
> +       return phy_data ? phy_data->regmap : NULL;

From what I can see nxp_c45_get_data(phydev) can't return a NULL pointer
so then I don't think you need the above check. And then maybe you can
remove more of the checks in the code where you check for data to not be
NULL.
The reason why I say nxp_c45_get_data(phydev) can't return a NULL is
because few lines bellow you have:

.driver_data            = &tja1103_phy_data,

...

> +}
> @@ -806,6 +835,7 @@ static int nxp_c45_hwtstamp(struct mii_timestamper *mii_ts,
>         struct nxp_c45_phy *priv = container_of(mii_ts, struct nxp_c45_phy,
>                                                 mii_ts);
>         struct phy_device *phydev = priv->phydev;
> +       const struct nxp_c45_phy_data *data;
>         struct hwtstamp_config cfg;
> 
>         if (copy_from_user(&cfg, ifreq->ifr_data, sizeof(cfg)))
> @@ -814,6 +844,7 @@ static int nxp_c45_hwtstamp(struct mii_timestamper *mii_ts,
>         if (cfg.tx_type < 0 || cfg.tx_type > HWTSTAMP_TX_ON)
>                 return -ERANGE;
> 
> +       data = nxp_c45_get_data(phydev);
>         priv->hwts_tx = cfg.tx_type;
> 
>         switch (cfg.rx_filter) {
> @@ -831,27 +862,26 @@ static int nxp_c45_hwtstamp(struct mii_timestamper *mii_ts,
>         }
> 
>         if (priv->hwts_rx || priv->hwts_tx) {
> -               phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_EVENT_MSG_FILT,
> +               phy_write_mmd(phydev, MDIO_MMD_VEND1,
> +                             data->regmap->vend1_event_msg_filt,
>                               EVENT_MSG_FILT_ALL);
> -               phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
> -                                  VEND1_PORT_PTP_CONTROL,
> -                                  PORT_PTP_CONTROL_BYPASS);
> +               if (data && data->ptp_enable)

Like here

> +                       data->ptp_enable(phydev, true);
>         } else {
> -               phy_write_mmd(phydev, MDIO_MMD_VEND1, VEND1_EVENT_MSG_FILT,
> +               phy_write_mmd(phydev, MDIO_MMD_VEND1,
> +                             data->regmap->vend1_event_msg_filt,
>                               EVENT_MSG_FILT_NONE);
> -               phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PORT_PTP_CONTROL,
> -                                PORT_PTP_CONTROL_BYPASS);
> +               if (data && data->ptp_enable)

And here and few other places bellow:

> +                       data->ptp_enable(phydev, false);
>         }
> 
>         if (nxp_c45_poll_txts(priv->phydev))
>                 goto nxp_c45_no_ptp_irq;
> 
>         if (priv->hwts_tx)
> -               phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
> -                                VEND1_PTP_IRQ_EN, PTP_IRQ_EGR_TS);
> +               nxp_c45_set_reg_field(phydev, &data->regmap->irq_egr_ts_en);
>         else
> -               phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
> -                                  VEND1_PTP_IRQ_EN, PTP_IRQ_EGR_TS);
> +               nxp_c45_clear_reg_field(phydev, &data->regmap->irq_egr_ts_en);
> 

...

> 
> +static const struct nxp_c45_phy_data tja1103_phy_data = {
> +       .regmap = &tja1103_regmap,
> +       .stats = tja1103_hw_stats,
> +       .n_stats = ARRAY_SIZE(tja1103_hw_stats),
> +       .ptp_clk_period = PTP_CLK_PERIOD_100BT1,
> +       .counters_enable = tja1103_counters_enable,
> +       .ptp_init = tja1103_ptp_init,
> +       .ptp_enable = tja1103_ptp_enable,
> +};
> +
>  static struct phy_driver nxp_c45_driver[] = {
>         {
>                 PHY_ID_MATCH_MODEL(PHY_ID_TJA_1103),
>                 .name                   = "NXP C45 TJA1103",
>                 .features               = PHY_BASIC_T1_FEATURES,
> +               .driver_data            = &tja1103_phy_data,
>                 .probe                  = nxp_c45_probe,
>                 .soft_reset             = nxp_c45_soft_reset,
>                 .config_aneg            = genphy_c45_config_aneg,
> --
> 2.34.1
> 
> 

-- 
/Horatiu

