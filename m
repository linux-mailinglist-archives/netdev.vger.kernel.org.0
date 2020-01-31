Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD5814F190
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 18:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbgAaRtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 12:49:45 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:32898 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgAaRtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 12:49:45 -0500
Received: by mail-ed1-f66.google.com with SMTP id r21so8731361edq.0;
        Fri, 31 Jan 2020 09:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CRde8lug95fUnvAZI7M7MKEoKmkbHaiMNt/ylPwFEvM=;
        b=bmSXbrNXvtDAcoTrXLpTR+SLXhUyiNKYdP3B2J+XvzYEN8WMK4BY31r+nG6rt1ctwt
         JkQclpW83RMXcU0W+dc6NeIOj5eVDQzfG7/KMO7RBIGNlqZsrpWkVbxDUrL0CX7OX1/p
         dfvYYMg3v7PwHSO5R8H2s3VQ1lRzveNuCnj9sO/l58UOkpQo7FCrGR1spgX8HJO1yn9S
         OFiXPJjgM8hT0td0/8XoBlAexTsI1vrxLffPrtaxko4kX9F4qEbp6MhnWlQ6yr6bHco9
         Rsq3fp8Mct6pYrGk8TJvOXh9Yd1c2XY6ps5p7WAHfXxOQmK09TrX9Tx+efJL26zVtP7x
         ZsMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=CRde8lug95fUnvAZI7M7MKEoKmkbHaiMNt/ylPwFEvM=;
        b=MZ2gHtoWGRQ6QvF1ixUUerG1oCybdgooh0511Q5PFXCMNAStk/DmxTqlqvaPITqjOp
         3i+t5yaVcl2rsXwGf2ewU10Xv5bs/JFh+T2qP0R7BCrdy4yWos5umgS5diKMDDdE8zQB
         3WcbAb2MGDHLX3gzt1yx81ST8cuwmttJvnqRBfV6YCrlV+INGMS0uQfNldVv9hMN5dqK
         a9yKGiXs0G0Blh4j8FetzqPzxULeezvVXzgnNB2iEMCzRv4BSpSK5CGvu55f1+IFhMvH
         +kVpF2aKcupYakKkgM/HTQVEXjTJkqsQCwMckTfTTDp25k2Yv6pNMDb7MUQsY+ehSgOU
         eMOQ==
X-Gm-Message-State: APjAAAVFQWXW19SPLZOTXpRx/Di4UGx7WxIaguyD3BtXHgBRYpKoklpP
        u1rEZbhMATlmB3EFKycH3/0=
X-Google-Smtp-Source: APXvYqy45mKIQ3esnG0SlD6nCDkOwTeTzW052AF2U8uhQUG1/GlnxNMYLY1GJGdMVvez2cgluixb/w==
X-Received: by 2002:a17:906:d8b3:: with SMTP id qc19mr10083964ejb.110.1580492983088;
        Fri, 31 Jan 2020 09:49:43 -0800 (PST)
Received: from [10.67.48.234] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o14sm529889edq.65.2020.01.31.09.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 09:49:42 -0800 (PST)
Subject: Re: [PATCH net-master 1/1] net: phy: dp83867: Add speed optimization
 feature
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        bunk@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, grygorii.strashko@ti.com
References: <20200131151110.31642-1-dmurphy@ti.com>
 <20200131151110.31642-2-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <8f0e7d61-9433-4b23-5563-4dde03cd4b4a@gmail.com>
Date:   Fri, 31 Jan 2020 09:49:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200131151110.31642-2-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/20 7:11 AM, Dan Murphy wrote:
> Set the speed optimization bit on the DP83867 PHY.
> This feature can also be strapped on the 64 pin PHY devices
> but the 48 pin devices do not have the strap pin available to enable
> this feature in the hardware.  PHY team suggests to have this bit set.

OK, but why and how does that optimization work exactly? Departing from
the BMSR reads means you possibly are going to introduce bugs and/or
incomplete information. For instance, you set phydev->pause and
phydev->asym_pause to 0 now, is there no way to extract what the link
partner has advertised?

> 
> With this bit set the PHY will auto negotiate and report the link
> parameters in the PHYSTS register and not in the BMCR. 

That should be BMSR, the BMCR is about control, not status.

> So we need to
> over ride the genphy_read_status with a DP83867 specific read status.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  drivers/net/phy/dp83867.c | 48 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index 967f57ed0b65..695aaf4f942f 100644
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
> @@ -287,6 +297,36 @@ static int dp83867_config_intr(struct phy_device *phydev)
>  	return phy_write(phydev, MII_DP83867_MICR, micr_status);
>  }
>  
> +static int dp83867_read_status(struct phy_device *phydev)
> +{
> +	int status = phy_read(phydev, MII_DP83867_PHYSTS);
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
> +	if (status & DP83867_PHYSTS_LINK)
> +		phydev->link = 1;
> +	else
> +		phydev->link = 0;
> +
> +	phydev->pause = 0;
> +	phydev->asym_pause = 0;
> +
> +	return 0;
> +}
> +
>  static int dp83867_config_port_mirroring(struct phy_device *phydev)
>  {
>  	struct dp83867_private *dp83867 =
> @@ -467,6 +507,12 @@ static int dp83867_config_init(struct phy_device *phydev)
>  	int ret, val, bs;
>  	u16 delay;
>  
> +	/* Force speed optimization for the PHY even if it strapped */
> +	ret = phy_modify(phydev, DP83867_CFG2, DP83867_SPEED_OPTIMIZED_EN,
> +			 DP83867_SPEED_OPTIMIZED_EN);
> +	if (ret)
> +		return ret;
> +
>  	ret = dp83867_verify_rgmii_cfg(phydev);
>  	if (ret)
>  		return ret;
> @@ -655,6 +701,8 @@ static struct phy_driver dp83867_driver[] = {
>  		.config_init	= dp83867_config_init,
>  		.soft_reset	= dp83867_phy_reset,
>  
> +		.read_status	= dp83867_read_status,
> +
>  		.get_wol	= dp83867_get_wol,
>  		.set_wol	= dp83867_set_wol,
>  
> 


-- 
Florian
