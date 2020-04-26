Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 267D81B905D
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 15:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgDZNK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 09:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726135AbgDZNK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 09:10:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE5DC061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 06:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Mo7rU7Moed8f/W1q9bMztC+p9uTgRtMGZKLmfeq7Uq4=; b=tY614lWoxlp7Zkd+qWUQO+08R
        gORqzwVLjOJS89YG9wtwkydjwnloaM/Ja1JizrTn6kqri7tfF5tWUFCopfZ646AxZlSsG6dNEMPBl
        b8O+cy8h1aLMxfOqsdXnh3C1v/DIW//rPj/XvqTZFsZ+IVxmvcv0D4quvvt9oFQMuFMNSFp+wDFQE
        tHAhDQmFPoIJ8ib2R2KD+OVRHmXnnSGdigYPkmoAYsAhkHpNrqZ3NMcN1i6QpXwOOZhDExM++SeY+
        3yAseBMugiIzvWB3+PNVcL/P0qOPPSxwSrSu0qOtKWadgSC+HFZRLPJGhD0gFMXpJtjRrI8POofyU
        2gg2xsZYQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55760)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jSh3P-0005Vw-KL; Sun, 26 Apr 2020 14:10:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jSh3N-0005hj-4l; Sun, 26 Apr 2020 14:10:37 +0100
Date:   Sun, 26 Apr 2020 14:10:37 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH net v4] net: phy: marvell10g: fix temperature sensor on
 2110
Message-ID: <20200426131036.GA25745@shell.armlinux.org.uk>
References: <7f1ffa0c51d4f7be6867878e601037ae3326ac01.1587882126.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f1ffa0c51d4f7be6867878e601037ae3326ac01.1587882126.git.baruch@tkos.co.il>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 09:22:06AM +0300, Baruch Siach wrote:
> Read the temperature sensor register from the correct location for the
> 88E2110 PHY. There is no enable/disable bit on 2110, so make
> mv3310_hwmon_config() run on 88X3310 only.
> 
> Fixes: 62d01535474b61 ("net: phy: marvell10g: add support for the 88x2110 PHY")
> Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> ---
> v4:
>   * Combine two patches into one (RMK)
> 
>   * Add comments to mark PHY specific temperature registers (RMK)
> 
>   * Drop PHY check on mv3310_hwmon_probe() (RMK)
> 
> v3: Split temperature register read routine per variant (Andrew Lunn)
> 
> v2: Fix indentation (Andrew Lunn)
> ---
>  drivers/net/phy/marvell10g.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index 95e3f4644aeb..419301bfe8c6 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -66,6 +66,9 @@ enum {
>  	MV_PCS_CSSR1_SPD2_2500	= 0x0004,
>  	MV_PCS_CSSR1_SPD2_10000	= 0x0000,
>  
> +	/* Temperature read register (88E2110 only) */
> +	MV_PCS_TEMP		= 0x8042,
> +
>  	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
>  	 * registers appear to set themselves to the 0x800X when AN is
>  	 * restarted, but status registers appear readable from either.
> @@ -77,6 +80,7 @@ enum {
>  	MV_V2_PORT_CTRL		= 0xf001,
>  	MV_V2_PORT_CTRL_SWRST	= BIT(15),
>  	MV_V2_PORT_CTRL_PWRDOWN = BIT(11),
> +	/* Temperature control/read registers (88X3310 only) */
>  	MV_V2_TEMP_CTRL		= 0xf08a,
>  	MV_V2_TEMP_CTRL_MASK	= 0xc000,
>  	MV_V2_TEMP_CTRL_SAMPLE	= 0x0000,
> @@ -104,6 +108,24 @@ static umode_t mv3310_hwmon_is_visible(const void *data,
>  	return 0;
>  }
>  
> +static int mv3310_hwmon_read_temp_reg(struct phy_device *phydev)
> +{
> +	return phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP);
> +}
> +
> +static int mv2110_hwmon_read_temp_reg(struct phy_device *phydev)
> +{
> +	return phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_TEMP);
> +}
> +
> +static int mv10g_hwmon_read_temp_reg(struct phy_device *phydev)
> +{
> +	if (phydev->drv->phy_id == MARVELL_PHY_ID_88X3310)
> +		return mv3310_hwmon_read_temp_reg(phydev);
> +	else /* MARVELL_PHY_ID_88E2110 */
> +		return mv2110_hwmon_read_temp_reg(phydev);
> +}
> +
>  static int mv3310_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
>  			     u32 attr, int channel, long *value)
>  {
> @@ -116,7 +138,7 @@ static int mv3310_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
>  	}
>  
>  	if (type == hwmon_temp && attr == hwmon_temp_input) {
> -		temp = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP);
> +		temp = mv10g_hwmon_read_temp_reg(phydev);
>  		if (temp < 0)
>  			return temp;
>  
> @@ -169,6 +191,9 @@ static int mv3310_hwmon_config(struct phy_device *phydev, bool enable)
>  	u16 val;
>  	int ret;
>  
> +	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310)
> +		return 0;
> +
>  	ret = phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_V2_TEMP,
>  			    MV_V2_TEMP_UNKNOWN);
>  	if (ret < 0)
> -- 
> 2.26.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
