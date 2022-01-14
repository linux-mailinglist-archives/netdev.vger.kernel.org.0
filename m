Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF4748F17B
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 21:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244568AbiANUf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 15:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244797AbiANUeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 15:34:15 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA16C061574;
        Fri, 14 Jan 2022 12:34:14 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id f141-20020a1c1f93000000b003497aec3f86so7802398wmf.3;
        Fri, 14 Jan 2022 12:34:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=PjikHxdu0mISOqtrWdj4/szGo6v35TIQfdPPlpfzmlE=;
        b=brJGRwJeUNOMXm6JSTvcPBVcCRZweJn+/aM3reyB9sujVb36otfdmEgK/OinG4tMxV
         iNo2Mo3YmlHKKANGK88VZXglAnuormpxLj5mcpV8X8TlqhflZD57YUUItUSEax+RWPuq
         h7tJJ/Alx8cPKEytqj1g+yIWWm1koH8G6GrGMxrMQw0iK/1pUfgGrVckX11epqI9i6bf
         s9J9nrU6fytSxcKPVIxGdEeuACNaF5VoWFFIc+1s3mkY5eKXBPVoaiuwiclfbQn4LfBF
         mG68Ergj0yiZx+ceEChEU/b3sIMTnMx/JUbaBHoO9k+5GETOS3KaYVpi4P6TOf4xbZwD
         /9jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=PjikHxdu0mISOqtrWdj4/szGo6v35TIQfdPPlpfzmlE=;
        b=Zr8RaftFPWh9IXsT9ox4vgytpqotrSz9b5/lBRo2RgIJumyutzJOQS5Txpruv1H+Lp
         56sqcs7svyda+3vq8o5czjNpMCWv4qk0a6Aq92C3/Jy+USjULHlaTZWQWzkFCgS2WyA+
         QTUmxho9sClYD84P1rkkYhyA5Ev3O0oXF7YJus0Ui/UkQzyGAkr1kg9ARPNipPu7E9dO
         5iie1kgSZ4JuGqRQKYE6ypzQtHbPtfWFnvJzuXeqDVWV/k7g3ogTYPtlOWXOHSEkdcR7
         AhDnOt5qYLK1fpxiI6/8qwHiKVYcDAKcEt2yr3iDyHxiyP2nE6IT9xmCSeZqj2iYBuIB
         +FIQ==
X-Gm-Message-State: AOAM5317QtTUYEtQ8gVCov1XiViH4wVQt8O7Gslz6Ujl4ESsS+itCURv
        6po856uViBFMxYFITTF6eYA=
X-Google-Smtp-Source: ABdhPJwovGOmRex/6G1mlMrsrq+6R3LK9/PLEV2ibcrpyNO1YvqRFr05mfnJKt1uAp2z2Asw1X1bPg==
X-Received: by 2002:a05:600c:33a7:: with SMTP id o39mr9481830wmp.6.1642192453519;
        Fri, 14 Jan 2022 12:34:13 -0800 (PST)
Received: from ?IPV6:2003:ea:8f2f:5b00:8dca:5ce5:b6ef:4dea? (p200300ea8f2f5b008dca5ce5b6ef4dea.dip0.t-ipconnect.de. [2003:ea:8f2f:5b00:8dca:5ce5:b6ef:4dea])
        by smtp.googlemail.com with ESMTPSA id e12sm3340985wrg.33.2022.01.14.12.34.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 12:34:12 -0800 (PST)
Message-ID: <cdd16632-d9ea-3556-f7b4-6909289b593c@gmail.com>
Date:   Fri, 14 Jan 2022 21:34:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Content-Language: en-US
To:     Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220113095604.31827-1-mohammad.athari.ismail@intel.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net v3] net: phy: marvell: add Marvell specific PHY
 loopback
In-Reply-To: <20220113095604.31827-1-mohammad.athari.ismail@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.01.2022 10:56, Mohammad Athari Bin Ismail wrote:
> Existing genphy_loopback() is not applicable for Marvell PHY. Besides
> configuring bit-6 and bit-13 in Page 0 Register 0 (Copper Control
> Register), it is also required to configure same bits  in Page 2
> Register 21 (MAC Specific Control Register 2) according to speed of
> the loopback is operating.
> 
> Tested working on Marvell88E1510 PHY for all speeds (1000/100/10Mbps).
> 
> FIXME: Based on trial and error test, it seem 1G need to have delay between
> soft reset and loopback enablement.
> 
> Fixes: 014068dcb5b1 ("net: phy: genphy_loopback: add link speed configuration")
> Cc: <stable@vger.kernel.org> # 5.15.x
> Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> ---
> v3 changelog:
> - Use phy_write() to configure speed for BMCR.
> - Add error handling.
> All commented by Russell King <linux@armlinux.org.uk>
> 
> v2 changelog:
> - For loopback enabled, add bit-6 and bit-13 configuration in both Page
>   0 Register 0 and Page 2 Register 21. Commented by Heiner Kallweit
> <hkallweit1@gmail.com>.
> - For loopback disabled, follow genphy_loopback() implementation
> ---
>  drivers/net/phy/marvell.c | 56 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 4fcfca4e1702..5c371c2de9a0 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -189,6 +189,8 @@
>  #define MII_88E1510_GEN_CTRL_REG_1_MODE_RGMII_SGMII	0x4
>  #define MII_88E1510_GEN_CTRL_REG_1_RESET	0x8000	/* Soft reset */
>  
> +#define MII_88E1510_MSCR_2		0x15
> +
>  #define MII_VCT5_TX_RX_MDI0_COUPLING	0x10
>  #define MII_VCT5_TX_RX_MDI1_COUPLING	0x11
>  #define MII_VCT5_TX_RX_MDI2_COUPLING	0x12
> @@ -1932,6 +1934,58 @@ static void marvell_get_stats(struct phy_device *phydev,
>  		data[i] = marvell_get_stat(phydev, i);
>  }
>  
> +static int marvell_loopback(struct phy_device *phydev, bool enable)

Marvell PHY's use different bits for the loopback speed, e.g.:

88E1510 bits 13, 6
88E1545 bits 2..0

Your function is usable with certain Marvell PHY's only, therefore
the function name is misleading. At a first glance I see two options:

1. Leave the function name and add a version-specific section that returns
   an error for (not yet) supported versions.
2. Name it m88e1510_loopback()

> +{
> +	int err;
> +
> +	if (enable) {
> +		u16 bmcr_ctl = 0, mscr2_ctl = 0;
> +
> +		if (phydev->speed == SPEED_1000)
> +			bmcr_ctl = BMCR_SPEED1000;
> +		else if (phydev->speed == SPEED_100)
> +			bmcr_ctl = BMCR_SPEED100;
> +
> +		if (phydev->duplex == DUPLEX_FULL)
> +			bmcr_ctl |= BMCR_FULLDPLX;
> +
> +		err = phy_write(phydev, MII_BMCR, bmcr_ctl);
> +		if (err < 0)
> +			return err;
> +
> +		if (phydev->speed == SPEED_1000)
> +			mscr2_ctl = BMCR_SPEED1000;
> +		else if (phydev->speed == SPEED_100)
> +			mscr2_ctl = BMCR_SPEED100;
> +
> +		err = phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
> +				       MII_88E1510_MSCR_2, BMCR_SPEED1000 |
> +				       BMCR_SPEED100, mscr2_ctl);
> +		if (err < 0)
> +			return err;
> +
> +		/* Need soft reset to have speed configuration takes effect */
> +		err = genphy_soft_reset(phydev);
> +		if (err < 0)
> +			return err;
> +
> +		/* FIXME: Based on trial and error test, it seem 1G need to have
> +		 * delay between soft reset and loopback enablement.
> +		 */
> +		if (phydev->speed == SPEED_1000)
> +			msleep(1000);
> +
> +		return phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
> +				  BMCR_LOOPBACK);
> +	} else {
> +		err = phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK, 0);
> +		if (err < 0)
> +			return err;
> +
> +		return phy_config_aneg(phydev);
> +	}
> +}
> +
>  static int marvell_vct5_wait_complete(struct phy_device *phydev)
>  {
>  	int i;
> @@ -3078,7 +3132,7 @@ static struct phy_driver marvell_drivers[] = {
>  		.get_sset_count = marvell_get_sset_count,
>  		.get_strings = marvell_get_strings,
>  		.get_stats = marvell_get_stats,
> -		.set_loopback = genphy_loopback,
> +		.set_loopback = marvell_loopback,
>  		.get_tunable = m88e1011_get_tunable,
>  		.set_tunable = m88e1011_set_tunable,
>  		.cable_test_start = marvell_vct7_cable_test_start,

