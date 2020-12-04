Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A572CEF0A
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 14:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbgLDNwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 08:52:18 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:60581 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgLDNwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 08:52:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607089937; x=1638625937;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ck/uu08xuRYdD8AcD/ZXVJ8Zeup1t0ngXLoX1ZNCizk=;
  b=1gJkdzheqKjV/JlXz5DZxZkyac1AaVR7/0AHCMKtYgeYJ0hwD5IUW4L8
   efauTQRBdKWB1D2Y7KPlveFVfaHem7kFBA/mQ0ICZ2UphjzXwxLWj6vnl
   wLXRxT18OCUeCKVtlBJpCzfsIhdX5NDS7th8XnI2CgMz/E45AszpGqxB1
   iNzBKuejBJ6sGJykMNwqnTEkFL5Lt1gQinWWZxpNPJsuHdGfPiMqnaBws
   xUNxVRLKOWX1HvF7VVgZuN7AXh0v8unQ16F/I5vO9mjTugsxW8f7tMna5
   80T4I+9HaOgF42zitwmT1afKHnNBkwp0DMzBG1kmBF6plwa++Iony+s8V
   g==;
IronPort-SDR: 7KKCuq7zDvodWckmI6RAQQ9MrOeg96i4TLPR41wNH5Sm43aeNZoqG4hD8n/kUOUDwwH3uaU2Uu
 Bv5LjC5sUwTtNtAHhT5cATUsLrAQGjOUZx+7hRbSSaoLoD7QbpDp4YldyMzZR/nBStcWujgelX
 ne+WetyNeAkollwoq0NXpb0a/h2Jq/FpuhHW6brcFeJdz7HoofwI2FsYWjfnVzkbzxCFC7Njqr
 VsiosUM4udBwhxLMSoPZuT88NUhBj5DLnw5fuQPVOGDim5IHOFPsbBeInQxR7145SbEP1/JsbA
 VI8=
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="100924024"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 06:51:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 06:51:11 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 06:51:11 -0700
Date:   Fri, 4 Dec 2020 14:51:10 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20201204135110.p5kdyvhxmuplao2u@mchp-dev-shegelun>
References: <20201203103015.3735373-1-steen.hegelund@microchip.com>
 <20201203103015.3735373-4-steen.hegelund@microchip.com>
 <20201203215253.GL2333853@lunn.ch>
 <20201203225232.GI1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201203225232.GI1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.12.2020 22:52, Russell King - ARM Linux admin wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On Thu, Dec 03, 2020 at 10:52:53PM +0100, Andrew Lunn wrote:
>> > +/* map from SD25G28 interface width to configuration value */
>> > +static u8 sd25g28_get_iw_setting(const u8 interface_width)
>> > +{
>> > +   switch (interface_width) {
>> > +   case 10: return 0;
>> > +   case 16: return 1;
>> > +   case 32: return 3;
>> > +   case 40: return 4;
>> > +   case 64: return 5;
>> > +   default:
>> > +           pr_err("%s: Illegal value %d for interface width\n",
>> > +                  __func__, interface_width);
>>
>> Please make use of dev_err(phy->dev, so we know which PHY has
>> configuration problems.
>>
>> > +static int sparx5_serdes_validate(struct phy *phy, enum phy_mode mode,
>> > +                                   int submode,
>> > +                                   union phy_configure_opts *opts)
>> > +{
>> > +   struct sparx5_serdes_macro *macro = phy_get_drvdata(phy);
>> > +   struct sparx5_serdes_private *priv = macro->priv;
>> > +   u32 value, analog_sd;
>> > +
>> > +   if (mode != PHY_MODE_ETHERNET)
>> > +           return -EINVAL;
>> > +
>> > +   switch (submode) {
>> > +   case PHY_INTERFACE_MODE_1000BASEX:
>> > +   case PHY_INTERFACE_MODE_SGMII:
>> > +   case PHY_INTERFACE_MODE_QSGMII:
>> > +   case PHY_INTERFACE_MODE_10GBASER:
>> > +           break;
>> > +   default:
>> > +           return -EINVAL;
>> > +   }
>> > +   if (macro->serdestype == SPX5_SDT_6G) {
>> > +           value = sdx5_rd(priv, SD6G_LANE_LANE_DF(macro->stpidx));
>> > +           analog_sd = SD6G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(value);
>> > +   } else if (macro->serdestype == SPX5_SDT_10G) {
>> > +           value = sdx5_rd(priv, SD10G_LANE_LANE_DF(macro->stpidx));
>> > +           analog_sd = SD10G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(value);
>> > +   } else {
>> > +           value = sdx5_rd(priv, SD25G_LANE_LANE_DE(macro->stpidx));
>> > +           analog_sd = SD25G_LANE_LANE_DE_LN_PMA_RXEI_GET(value);
>> > +   }
>> > +   /* Link up is when analog_sd == 0 */
>> > +   return analog_sd;
>> > +}
>
>You still have not Cc'd me on your patches. Please can you either:
>
>1) use get_maintainer.pl to find out whom you should be sending
>   your patches to
>or
>2) include me in your cc for this patch set as phylink maintainer in
>   your patch set so I can review your use of phylink.
>
>Consider your patches NAK'd until you send them to me so that I can
>review them.
>
>Thanks.

Hi Russell,

I will CC you on the next version of this series.  In reality I was
just asked by Vladimir Oltean to crosspost to netdev.  This is a
series for the Generic PHY subsystem.
Sorry about the confusion.
>
>--
>RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
>FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
