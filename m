Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CCD2D5B11
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 14:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387816AbgLJM6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 07:58:23 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:13488 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728462AbgLJM6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 07:58:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607605103; x=1639141103;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7/x/yFQiiPNThWsHIOSSDLGsN15fJdWKDeooz0EvczQ=;
  b=Sn3/8x345nd66AtOFpxo7eZnirrcMQ3PLVXo8esmrfiYpwozOhyMsctt
   +aKYMEDSphDVUBj8glX61skD9wbM64AES/6vJ00DrVd+LK+cA4kGP1IwX
   3NF+oj/mU9bEnyuPbq1hHI64Id++mvq+Zz/Zpcz7twwpVNas6YMpuYxtq
   uhrHE8dXvDl4eWHPNMela9mcWJz3kd5ja68m4Dv8eiKg+XBptkr1E9VJw
   uiPXvAaif1OhC9c6guxzRZrFCTIJmsA1Ih5KhRik0Qti3vHPviaBo9yq2
   14rf5ml3twFgCZ9uUoxpECNMFbmnNmgGkzOwZzc6/Nnq9+P3H4zSr6HcA
   w==;
IronPort-SDR: 3xtPlJZZMuFLse+KfoBEnohNvjaXIfB9fw1LT61pjWZ+/uHNo3pZtmnl0ozuTp0p8K3QvBiIn+
 XjGCu6rH0yGGnZYRGm+YsvVVK7m/p4mtE0jwWHw/5zTqNv1YerNXeTrzLaNmUujdiZ3qh+IATy
 5inGsB3PN4TJ7lFODrY3ilr7Jx+/XG3mczkvOt6n5LxI3R8b+VbOwMkDXojL3nnkziV06ley94
 vgk244SVdfAcCVziQ6Eal4/lnz8c4bYHrJHEsj2HmXwrqWdGGJvBMzdf8hh/tPoGwl5Z6cbdq0
 T78=
X-IronPort-AV: E=Sophos;i="5.78,408,1599548400"; 
   d="scan'208";a="102262184"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 05:57:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 05:57:07 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 05:57:06 -0700
Date:   Thu, 10 Dec 2020 13:57:06 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20201210125706.saub7c2rarifhbx4@mchp-dev-shegelun>
References: <20201207121345.3818234-1-steen.hegelund@microchip.com>
 <20201207121345.3818234-4-steen.hegelund@microchip.com>
 <20201210021134.GD2638572@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201210021134.GD2638572@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.12.2020 03:11, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 01b53f86004c..f6a094c81e86 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -66,9 +66,11 @@ source "drivers/phy/broadcom/Kconfig"
>>  source "drivers/phy/cadence/Kconfig"
>>  source "drivers/phy/freescale/Kconfig"
>>  source "drivers/phy/hisilicon/Kconfig"
>> +source "drivers/phy/intel/Kconfig"
>
>That looks odd.
>
>>  source "drivers/phy/lantiq/Kconfig"
>>  source "drivers/phy/marvell/Kconfig"
>>  source "drivers/phy/mediatek/Kconfig"
>> +source "drivers/phy/microchip/Kconfig"
>>  source "drivers/phy/motorola/Kconfig"
>>  source "drivers/phy/mscc/Kconfig"
>>  source "drivers/phy/qualcomm/Kconfig"
>> @@ -80,7 +82,6 @@ source "drivers/phy/socionext/Kconfig"
>>  source "drivers/phy/st/Kconfig"
>>  source "drivers/phy/tegra/Kconfig"
>>  source "drivers/phy/ti/Kconfig"
>> -source "drivers/phy/intel/Kconfig"
>>  source "drivers/phy/xilinx/Kconfig"
>
>Ah. Please make that a separate patch.

Yes - it was really a separate change as a result of my sorting...
>
>> +     value = sdx5_rd(priv, SD25G_LANE_CMU_C0(sd_index));
>> +     value = SD25G_LANE_CMU_C0_PLL_LOL_UDL_GET(value);
>> +
>> +     if (value) {
>> +             dev_err(macro->priv->dev, "CMU_C0 pll_lol_udl: 0x%x\n", value);
>> +             ret = -EINVAL;
>> +     }
>> +
>> +     value = sdx5_rd(priv, SD_LANE_25G_SD_LANE_STAT(sd_index));
>> +     value = SD_LANE_25G_SD_LANE_STAT_PMA_RST_DONE_GET(value);
>> +
>> +     if (value != 0x1) {
>> +             dev_err(macro->priv->dev, "sd_lane_stat pma_rst_done: 0x%x\n", value);
>> +             ret = -EINVAL;
>> +     }
>
>These error messages are not very helpful. Could you be a bit more
>descriptive. Or do you think there is sufficient black magic in the
>hardware that nobody outside of Microchip will be able to debug it?

I will dig up some better descriptions...

>
>> +static int sparx5_serdes_get_serdesmode(phy_interface_t portmode,
>> +                                     struct phy_configure_opts_eth_serdes *conf)
>> +{
>> +     switch (portmode) {
>> +     case PHY_INTERFACE_MODE_1000BASEX:
>> +             if (conf->speed == SPEED_2500)
>> +                     return SPX5_SD_MODE_2G5;
>> +             if (conf->speed == SPEED_100)
>> +                     return SPX5_SD_MODE_100FX;
>> +             return SPX5_SD_MODE_1000BASEX;
>
>Please could you explain this. Why different speeds for 1000BaseX?

I will remove this.  It was taken from our bare-metal API (MESA) and
only relevant in that context because it did not have an explicit 2500G
mode.

>
>> +     case PHY_INTERFACE_MODE_SGMII:
>> +             return SPX5_SD_MODE_1000BASEX;
>
>Here there could be some oddities, depending on how 10Mbps and 100Mbps
>is implemented. But 1000BASEX only supports 1Gbps.
>
The same Serdes mode is used for SGMII and 1000BaseX.  Speeds 10M/100M
is handled by repeating the byte sequence 100/10 times to get to 1G
serdes speed.

>> +static int sparx5_serdes_validate(struct phy *phy, enum phy_mode mode,
>> +                                     int submode,
>> +                                     union phy_configure_opts *opts)
>> +{
>> +     struct sparx5_serdes_macro *macro = phy_get_drvdata(phy);
>> +     struct sparx5_serdes_private *priv = macro->priv;
>> +     u32 value, analog_sd;
>> +
>> +     if (mode != PHY_MODE_ETHERNET)
>> +             return -EINVAL;
>> +
>> +     switch (submode) {
>> +     case PHY_INTERFACE_MODE_1000BASEX:
>> +     case PHY_INTERFACE_MODE_SGMII:
>> +     case PHY_INTERFACE_MODE_QSGMII:
>> +     case PHY_INTERFACE_MODE_10GBASER:
>> +             break;
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +     if (macro->serdestype == SPX5_SDT_6G) {
>> +             value = sdx5_rd(priv, SD6G_LANE_LANE_DF(macro->stpidx));
>> +             analog_sd = SD6G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(value);
>> +     } else if (macro->serdestype == SPX5_SDT_10G) {
>> +             value = sdx5_rd(priv, SD10G_LANE_LANE_DF(macro->stpidx));
>> +             analog_sd = SD10G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(value);
>> +     } else {
>> +             value = sdx5_rd(priv, SD25G_LANE_LANE_DE(macro->stpidx));
>> +             analog_sd = SD25G_LANE_LANE_DE_LN_PMA_RXEI_GET(value);
>> +     }
>> +     /* Link up is when analog_sd == 0 */
>> +     return analog_sd;
>
>The documentation says:
>
>        /**
>         * @validate:
>         *
>         * Optional.
>         *
>         * Used to check that the current set of parameters can be
>         * handled by the phy. Implementations are free to tune the
>         * parameters passed as arguments if needed by some
>         * implementation detail or constraints. It must not change
>         * any actual configuration of the PHY, so calling it as many
>         * times as deemed fit by the consumer must have no side
>         * effect.
>         *
>         * Returns: 0 if the configuration can be applied, an negative
>         * error code otherwise
>         */
>
>So why are returning link up information?

Yes that was a bit of a hijacking of the function.  I will remove that.
I also removed the dependency on this behaviour in the client driver in the
meantime.

I think a status function on the generic phy would be useful, but I will
take that as separate issue.

>
>   Andrew

Thanks for the comments.

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
