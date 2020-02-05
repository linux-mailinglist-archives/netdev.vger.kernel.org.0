Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC2A1539FB
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 22:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgBEVQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 16:16:16 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53813 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgBEVQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 16:16:16 -0500
Received: by mail-wm1-f66.google.com with SMTP id s10so4015412wmh.3;
        Wed, 05 Feb 2020 13:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ynqPK9O5c/fnULNbN+OoxL2G/QEDXaAaZBUdKRK1g+Q=;
        b=Tz6IfCTorokKtvwisezDI2uIyip1iyl/nKLcADWkM+/1qxpyWMENBRqANwdThMudJI
         dmUo+b4SN8HS5to4sMsguLHonGyUM1UI8jvqhk4LhS/6ehADQitn0XQV+IiVp1jKBMNb
         lGPbpEF7tgfflM/Rf3oP/F/lJko6cgZMp5HJ+okvTJmPG42ladqnz4A9xBc+KE0ZjJRL
         U2TuDB/bEadc/hBSDlFdiukMnH4bFKr/uMs9ksu3yYiE2eSSX72n3Ok8YLj/ABoMatVs
         IAm6wJP96GPN59BoR7R7JicoJsRoMSfNSuOJVm2a8+gKFzA/uXeRJiI91yDSrD66/MUO
         HVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ynqPK9O5c/fnULNbN+OoxL2G/QEDXaAaZBUdKRK1g+Q=;
        b=aLdYpQnJ0jwkcVjkA733HqubQuPpJyX5Iif0QMO4C4X8p6Q/939jyn9t/nvfj4g4+Y
         EEMMaeAl3wGyUawnATWq9Ed+0WoHnH9jrzDuOp8B+GUV+lzCT23fWeF58bwbdYPi7wQ0
         Bpka5Muk+2i2znX7Vh6VCbvcAlZkd6EbFUgfUT5xwRVI0/6PpfQtISI/ms7pgtxephSa
         2YYzwZ55USWM3rqfX+rI/TITX/2/Pdt0amJMs1CaPRD4eEwRF/cJievB3hyAaeS+Wv8R
         2mzhFiTiiURuPxcJPppSiR9QeEy/haC1AAyI7LgZG0+ShTCAhxFrh0Xe7L9g1AkJ20AB
         Aj6g==
X-Gm-Message-State: APjAAAV/+VrqManCSkCzANpAyh1vTaYMID5TDnYb6ezRhn59gBA086aN
        Kf+h7Iy5I9Y3FKJpi0idIM4mL28J
X-Google-Smtp-Source: APXvYqzs5lgsgIKJDb59pkNODg5+gl7rDek95kUmovCzXfQiBzH+1UF+Z8paCfII85GsfqDogqu+dg==
X-Received: by 2002:a7b:cf01:: with SMTP id l1mr7678705wmg.86.1580937373949;
        Wed, 05 Feb 2020 13:16:13 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:7c61:997a:8e60:9300? (p200300EA8F2960007C61997A8E609300.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7c61:997a:8e60:9300])
        by smtp.googlemail.com with ESMTPSA id r14sm1284563wrj.26.2020.02.05.13.16.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 13:16:13 -0800 (PST)
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Add speed optimization
 feature
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200204181319.27381-1-dmurphy@ti.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0ebcd40d-b9cc-1a76-bb18-91d8350aa1cd@gmail.com>
Date:   Wed, 5 Feb 2020 22:16:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200204181319.27381-1-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.02.2020 19:13, Dan Murphy wrote:
> Set the speed optimization bit on the DP83867 PHY.
> This feature can also be strapped on the 64 pin PHY devices
> but the 48 pin devices do not have the strap pin available to enable
> this feature in the hardware.  PHY team suggests to have this bit set.
> 
> With this bit set the PHY will auto negotiate and report the link
> parameters in the PHYSTS register.  This register provides a single
> location within the register set for quick access to commonly accessed
> information.
> 
> In this case when auto negotiation is on the PHY core reads the bits
> that have been configured or if auto negotiation is off the PHY core
> reads the BMCR register and sets the phydev parameters accordingly.
> 
> This Giga bit PHY can throttle the speed to 100Mbps or 10Mbps to accomodate a
> 4-wire cable.  If this should occur the PHYSTS register contains the
> current negotiated speed and duplex mode.
> 
> In overriding the genphy_read_status the dp83867_read_status will do a
> genphy_read_status to setup the LP and pause bits.  And then the PHYSTS
> register is read and the phydev speed and duplex mode settings are
> updated.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
> v2 - Updated read status to call genphy_read_status first, added link_change
> callback to notify of speed change and use phy_set_bits - https://lore.kernel.org/patchwork/patch/1188348/ 
> 

As stated in the first review, it would be appreciated if you implement
also the downshift tunable. This could be a separate patch in this series.
Most of the implementation would be boilerplate code.

And I have to admit that I'm not too happy with the term "speed optimization".
This sounds like the PHY has some magic to establish a 1.2Gbps link.
Even though the vendor may call it this way in the datasheet, the standard
term is "downshift". I'm fine with using "speed optimization" in constants
to be in line with the datasheet. Just a comment in the code would be helpful
that speed optimization is the vendor's term for downshift.

>  drivers/net/phy/dp83867.c | 55 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index 967f57ed0b65..6f86ca1ebb51 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -21,6 +21,7 @@
>  #define DP83867_DEVADDR		0x1f
>  
>  #define MII_DP83867_PHYCTRL	0x10
> +#define MII_DP83867_PHYSTS	0x11
>  #define MII_DP83867_MICR	0x12
>  #define MII_DP83867_ISR		0x13
>  #define DP83867_CFG2		0x14
> @@ -118,6 +119,15 @@
>  #define DP83867_IO_MUX_CFG_CLK_O_SEL_MASK	(0x1f << 8)
>  #define DP83867_IO_MUX_CFG_CLK_O_SEL_SHIFT	8
>  
> +/* PHY STS bits */
> +#define DP83867_PHYSTS_1000			BIT(15)
> +#define DP83867_PHYSTS_100			BIT(14)
> +#define DP83867_PHYSTS_DUPLEX			BIT(13)
> +#define DP83867_PHYSTS_LINK			BIT(10)
> +
> +/* CFG2 bits */
> +#define DP83867_SPEED_OPTIMIZED_EN		(BIT(8) | BIT(9))
> +
>  /* CFG3 bits */
>  #define DP83867_CFG3_INT_OE			BIT(7)
>  #define DP83867_CFG3_ROBUST_AUTO_MDIX		BIT(9)
> @@ -287,6 +297,43 @@ static int dp83867_config_intr(struct phy_device *phydev)
>  	return phy_write(phydev, MII_DP83867_MICR, micr_status);
>  }
>  
> +static void dp83867_link_change_notify(struct phy_device *phydev)
> +{
> +	if (phydev->state != PHY_RUNNING)
> +		return;
> +
> +	if (phydev->speed == SPEED_100 || phydev->speed == SPEED_10)
> +		phydev_warn(phydev, "Downshift detected connection is %iMbps\n",
> +			    phydev->speed);

The link partner may simply not advertise 1Gbps. How do you know that
a link speed of e.g. 100Mbps is caused by a downshift?
Some PHY's I've seen with this feature have a flag somewhere indicating
that downshift occurred. How about the PHY here?

> +}
> +
> +static int dp83867_read_status(struct phy_device *phydev)
> +{
> +	int status = phy_read(phydev, MII_DP83867_PHYSTS);
> +	int ret;
> +
> +	ret = genphy_read_status(phydev);
> +	if (ret)
> +		return ret;
> +
> +	if (status < 0)
> +		return status;
> +
> +	if (status & DP83867_PHYSTS_DUPLEX)
> +		phydev->duplex = DUPLEX_FULL;
> +	else
> +		phydev->duplex = DUPLEX_HALF;
> +
> +	if (status & DP83867_PHYSTS_1000)
> +		phydev->speed = SPEED_1000;
> +	else if (status & DP83867_PHYSTS_100)
> +		phydev->speed = SPEED_100;
> +	else
> +		phydev->speed = SPEED_10;
> +
> +	return 0;
> +}
> +
>  static int dp83867_config_port_mirroring(struct phy_device *phydev)
>  {
>  	struct dp83867_private *dp83867 =
> @@ -467,6 +514,11 @@ static int dp83867_config_init(struct phy_device *phydev)
>  	int ret, val, bs;
>  	u16 delay;
>  
> +	/* Force speed optimization for the PHY even if it strapped */
> +	ret = phy_set_bits(phydev, DP83867_CFG2, DP83867_SPEED_OPTIMIZED_EN);
> +	if (ret)
> +		return ret;
> +
>  	ret = dp83867_verify_rgmii_cfg(phydev);
>  	if (ret)
>  		return ret;
> @@ -655,6 +707,9 @@ static struct phy_driver dp83867_driver[] = {
>  		.config_init	= dp83867_config_init,
>  		.soft_reset	= dp83867_phy_reset,
>  
> +		.read_status	= dp83867_read_status,
> +		.link_change_notify = dp83867_link_change_notify,
> +
>  		.get_wol	= dp83867_get_wol,
>  		.set_wol	= dp83867_set_wol,
>  
> 

