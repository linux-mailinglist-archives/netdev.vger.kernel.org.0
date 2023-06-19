Return-Path: <netdev+bounces-11846-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AC87734D33
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:10:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8AEB280FAF
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 320CC6ABD;
	Mon, 19 Jun 2023 08:10:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2397E6FA5
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:10:10 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7967D10FF;
	Mon, 19 Jun 2023 01:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1687162204; x=1718698204;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bdyjboCvWW1rFiLeY1lR8Uam7LXcv5Dt7KtGdVPBM/Y=;
  b=pTx+BGDmZKlMbH+5QE5JQzSvuxXjHIorPwunY2uT/GVT3iC9IjI6GTdR
   D9qTa8BRTku6AOCS3U0DLF8ILarsfSW88aqHWwP56eOdkCfrKyp2c48CZ
   rV9KgMjp1gYo333uH0MTTY/w1QI3sSJmG3HFmGi6Slf5f6KFes1oOk6i1
   9AgxcvUCOhR0SRHb6FwcwAqkqFobormSc5FYmewI14LUAOIy8oAFdPypR
   0TjBsB4mTFIONhRIvBXAHm4Y34TCGf78psXdyYzxb8Fwa1UN81GmG2lbA
   jgimWAVIt7Cnq+9nng6ZjABYsqeFLWR8nWUqUP6BNKeO3y892MC5ppZRT
   w==;
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="157547885"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jun 2023 01:10:03 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 19 Jun 2023 01:10:03 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 19 Jun 2023 01:10:03 -0700
Date: Mon, 19 Jun 2023 10:10:02 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
CC: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <sebastian.tobuschat@nxp.com>
Subject: Re: [PATCH net-next v1 08/14] net: phy: nxp-c45-tja11xx: enable LTC
 sampling on both ext_ts edges
Message-ID: <20230619081002.x6crxnx7c66z4hhe@soft-dev3-1>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-9-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230616135323.98215-9-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 06/16/2023 16:53, Radu Pirea (NXP OSS) wrote:

Hi Radu,

> 
> The external trigger configuration for TJA1120 has changed. The PHY
> supports sampling of the LTC on rising and on falling edge.

> 
> Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
> ---
>  drivers/net/phy/nxp-c45-tja11xx.c | 64 +++++++++++++++++++++++++++----
>  1 file changed, 56 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
> index 2160b9f8940c..6aa738396daf 100644
> --- a/drivers/net/phy/nxp-c45-tja11xx.c
> +++ b/drivers/net/phy/nxp-c45-tja11xx.c
> @@ -104,6 +104,10 @@
>  #define VEND1_PTP_CONFIG               0x1102
>  #define EXT_TRG_EDGE                   BIT(1)
> 
> +#define TJA1120_SYNC_TRIG_FILTER       0x1010
> +#define PTP_TRIG_RISE_TS               BIT(3)
> +#define PTP_TRIG_FALLING_TS            BIT(2)
> +
>  #define CLK_RATE_ADJ_LD                        BIT(15)
>  #define CLK_RATE_ADJ_DIR               BIT(14)
> 
> @@ -240,6 +244,7 @@ struct nxp_c45_phy_data {
>         const struct nxp_c45_phy_stats *stats;
>         int n_stats;
>         u8 ptp_clk_period;
> +       bool ext_ts_both_edges;
>         void (*counters_enable)(struct phy_device *phydev);
>         void (*ptp_init)(struct phy_device *phydev);
>         void (*ptp_enable)(struct phy_device *phydev, bool enable);
> @@ -682,9 +687,52 @@ static int nxp_c45_perout_enable(struct nxp_c45_phy *priv,
>         return 0;
>  }
> 
> +static void nxp_c45_set_rising_or_falling(struct phy_device *phydev,
> +                                         struct ptp_extts_request *extts)
> +{
> +       /* Some enable request has only the PTP_ENABLE_FEATURE flag set and in
> +        * this case external ts should be enabled on rising edge.
> +        */
> +       if (extts->flags & PTP_RISING_EDGE ||
> +           extts->flags == PTP_ENABLE_FEATURE)
> +               phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
> +                                  VEND1_PTP_CONFIG, EXT_TRG_EDGE);

With this patch, are you not changing the behaviour for TJA1103?
In the way, before there was not check for extts->flags ==
PTP_ENABLE_FEATURE and now if that is set you configure to trigger on
raising edge. If that is the case, shouldn't be this in a different
patch?

> +
> +       if (extts->flags & PTP_FALLING_EDGE)
> +               phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
> +                                VEND1_PTP_CONFIG, EXT_TRG_EDGE);
> +}
> +
 

-- 
/Horatiu

