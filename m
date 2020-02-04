Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E4515216A
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 21:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbgBDUIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 15:08:17 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38222 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgBDUIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 15:08:17 -0500
Received: by mail-wr1-f67.google.com with SMTP id y17so24738498wrh.5;
        Tue, 04 Feb 2020 12:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PHx4gmYSsjhkcb+YYunSIVKUTRkmzceHIgudcZVaYjY=;
        b=jOzf6L7FM4VQs0rJDocs2tJJqsE5W6K4dqb4y2g7BdzD521M5RZT8ywJzGPfGZLFst
         lfswUpx1v9hNLG/rIl2pwEmtylSrHBb4J6KCGduSZ51dkE+wYYJELLMD2SqRHEL949Zw
         BDXjIhmcOeBu5xJ70qYTRAKT1jU+xJ2msI+FEomo9s+tUYEU90GsHl//wZfOmwG++ohL
         RBfgv1B6+4Hfs9tet/50S5vYWFnVUPzH5APKpc7ZyJ8Nigd/rRbc2lGgI2xUpI2cB4NE
         XJJhvSwd0oD9+bcQrtm490lyhsT1In+rv/p8mMNt7gA8gH8PPdQAWoK8fTNXkzppwgI2
         WQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PHx4gmYSsjhkcb+YYunSIVKUTRkmzceHIgudcZVaYjY=;
        b=N6oHIVLmL0v6g0GJthCzNYyYKH85fkDdDRqD8FYilAu39aoXqlpAu+JIOxOYYbIpPR
         rgej9r2J5v4F6RgYwePUzchB0B1OIZG38koNG/wL0eRD/ibqEWEmrpv1tz3Yt86pkfSy
         rNtVh9C9Tu5XTJBTPzCjMvU+ptBFFmuFR1VALZIV6txF790sWTdgjs8r3PuVfExkJuqO
         COplZ8Yv/QfVT44ILgC3psG/toq1N0XUiK/1E4P3G9yDAltfUnzzSoMGVHTQti+p3iPf
         EnG4Ia+Z6TflKkZMcGJPxx/jjB58PbMHUciRUAImx45Ta3yTrmEeptumQgTZ0pslqbbY
         INRQ==
X-Gm-Message-State: APjAAAWykPnN9duKAQkt7v4msEZkLjVYrt0JgkmM/9yp3ZBV2eLcNkbN
        yExJ+jfdZ9qCm0TaroplH9tzVvhm
X-Google-Smtp-Source: APXvYqzxZzrY8ceiVvGKbtHfxrjbMOZd1WNUPXE4zfI9fQCuTXYJgWlKPYzQumPdzVXk25tVTPfSEw==
X-Received: by 2002:adf:e686:: with SMTP id r6mr23927442wrm.177.1580846895441;
        Tue, 04 Feb 2020 12:08:15 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:bce3:a6b1:8ca3:57b9? (p200300EA8F296000BCE3A6B18CA357B9.dip0.t-ipconnect.de. [2003:ea:8f29:6000:bce3:a6b1:8ca3:57b9])
        by smtp.googlemail.com with ESMTPSA id y7sm29419255wrr.56.2020.02.04.12.08.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 12:08:14 -0800 (PST)
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Add speed optimization
 feature
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux@armlinux.org.uk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200204181319.27381-1-dmurphy@ti.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f977a302-16fc-de68-e84b-d41a0eca4c12@gmail.com>
Date:   Tue, 4 Feb 2020 21:08:07 +0100
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

net-next is closed currently. See here for details:
https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt
Reopening will be announced on the netdev mailing list, you can also
check net-next status here: http://vger.kernel.org/~davem/net-next.html

> ---
> v2 - Updated read status to call genphy_read_status first, added link_change
> callback to notify of speed change and use phy_set_bits - https://lore.kernel.org/patchwork/patch/1188348/ 
> 
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

