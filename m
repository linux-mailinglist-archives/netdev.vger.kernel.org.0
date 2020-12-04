Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C892CEEFE
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 14:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730284AbgLDNte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 08:49:34 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:60260 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgLDNte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 08:49:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607089774; x=1638625774;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aprRrheqIQcZfHyMK5qLYA6uJrrOjC/Y74/E7xSPl/0=;
  b=xfgfU+L0e+fVHwh4O+rQcnR8NECjv+W3NviSYiUmVTWRxcjEaKzF23GY
   Rs44rDsxpjq7/zJZ6kUCqb7ILjiO1HOPsZxftAXdslp0muUBeJPmMiM8h
   l9WfiSj21tqhQt0GwzxcFxuy7DxLQ9EzCsE2U5AGcez/CnFo6Wj7oyBWU
   7amf/HdxyodbigTARWiHMh5Ipq6U5spyKCwEHagJhbqSxISUS50G7wFsl
   XF3wfIKCIDFEzBBhxBwLX/Q9ma01bFuM68TUX8Dz8tyMsKEiMaWJoT1ZX
   0vx+AYKoiMfMMTMl0XuuqXClZ8MJpeTsQAXru7jBJwbvRK8iSufYxtdFN
   A==;
IronPort-SDR: JblvC20Jo3fFN8GCHWNKrx6lWcl1M2M6BxrfQgyG+w/3FFy6OFOJrLuF9QBabz5ivra7fSjlPz
 XJ2HjtDkMAvLaGaou6M49tL0VqgCa4RufTHPnN9WHqLFa2/tAg9dm50Znk8yJxbGcKKvYYwyxm
 fG1m4QnCyOM9UoskT8gXEX8dtfqfQd2azmHsQtlS+SpU1tGLB1b56l5/s/BVagYmru6zMKt16R
 3ngFO5FMssGujOtH36CyHsiyNBxUO5kB9eKGKs2Itv4lR+1SHfouFl6M6YhbVVFZsf37yv1B0D
 DHw=
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="100923591"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 06:48:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 06:48:27 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 06:48:27 -0700
Date:   Fri, 4 Dec 2020 14:48:26 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v8 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20201204134826.lnkdtj5nrygsngm2@mchp-dev-shegelun>
References: <20201203103015.3735373-1-steen.hegelund@microchip.com>
 <20201203103015.3735373-4-steen.hegelund@microchip.com>
 <20201203215253.GL2333853@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201203215253.GL2333853@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.12.2020 22:52, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>> +/* map from SD25G28 interface width to configuration value */
>> +static u8 sd25g28_get_iw_setting(const u8 interface_width)
>> +{
>> +     switch (interface_width) {
>> +     case 10: return 0;
>> +     case 16: return 1;
>> +     case 32: return 3;
>> +     case 40: return 4;
>> +     case 64: return 5;
>> +     default:
>> +             pr_err("%s: Illegal value %d for interface width\n",
>> +                    __func__, interface_width);
>
>Please make use of dev_err(phy->dev, so we know which PHY has
>configuration problems.

I will update that.

>
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
>> +}
>
>What i have not yet seen is how this code plugs together with
>phylink_pcs_ops?
>
>Can this hardware also be used for SATA, USB? As far as i understand,
>the Marvell Comphy is multi-purpose, it is used for networking, USB,
>and SATA, etc. Making it a generic PHY then makes sense, because
>different subsystems need to use it.
>
>But it looks like this is for networking only? So i'm wondering if it
>belongs in driver/net/pcs and it should be accessed using
>phylink_pcs_ops?
>
>        Andrew

This is a PHY that communicates on a SerDes link to an ethernet PHY or a
SFP. So I took the lead from earlier work: the Microsemi Ocelot SerDes driver,
and added the Sparx5 SerDes PHY driver here since it is very similar in intent.
It is not an ethernet PHY as such.

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
