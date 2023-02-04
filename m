Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B16B68A756
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 01:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbjBDAyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 19:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbjBDAyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 19:54:24 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8101A6C10;
        Fri,  3 Feb 2023 16:54:22 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id lu11so19960651ejb.3;
        Fri, 03 Feb 2023 16:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4oL40kNAiMaL+xOpKVWO5indpFyXlVlXyaN2nNR+BeQ=;
        b=HVwhYnPQ3zQdujs8cxAkgO+osyQDg5aDvi3bRilg+Rqg6pjUMOuBJvVchW1EgC/ZAP
         j1h0YcEsfJDvA4Rclf2rbWphL84jgW4dQb/8RbAhZhbxhpWJfYWoD7u3Hh+nADWS2mGB
         Xib6RW3W09xBN0EPNv7iOy+v2a3xoXX5Yu0wA75u00ZTPxB7FN3mMg93OoqnoT4ThO6i
         rvzIP0jpO0FfgY+nYhDeLKBtxmMSDveARPHY1QutaXu0Lyqxc12VxBLK7v77U+oVbcJQ
         GaqIyC3Mj9mZ/zOHjnnWzvXRbgn+M/KKGUPdKjUMdi0DhpqwjOxlwJuJJSVgGalxRi1X
         SPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4oL40kNAiMaL+xOpKVWO5indpFyXlVlXyaN2nNR+BeQ=;
        b=qE2YR1FhSPFRR0czNi+RxSZ5B/I98H5hiHUxaCOvHlnmOrNLfImwmRfOxpW5AoY9oa
         p96Y8mKunAwb4pzCIvRZ5sFyXWdOAO76OhT2ciU2GYgFcbOhd9SSUSJIGMdEPAsYUucK
         OiMDIOivS7+8GHDdFyQTJ9dFL30FVF75kAhQ4py4eB6L6x+w8Xmfp9OOEG8/UnLc/JgC
         /ulnkSNQALhwg2OQfOOVPPW1A0Ls68TtuoEV0LDkdY3Y116zj5ahDOd6r8rRKVPiWO2p
         5/RRJw+gJSiy7mkRxbsfJKakpeXxmRBduZx3OXU0LQ3UyCxAn7ZYctpw82SoQsemEdgJ
         x/pQ==
X-Gm-Message-State: AO0yUKXSoPwW74a8jfDR9p+aVegn5LuVP5cq0N1mkSEk902v+d1On5le
        iW7rUlM+tJu5N3zX8LheBRMLu7jd/q3vFQ==
X-Google-Smtp-Source: AK7set87tJPiUw887KGFIxbysb6vG/TbuGMX8TrEJXjqvVOm7leNM0Bf1nu/3TKM2QqGkM8OW9eVcA==
X-Received: by 2002:a17:906:d7b6:b0:885:d02f:d4ad with SMTP id pk22-20020a170906d7b600b00885d02fd4admr12833019ejb.43.1675472061294;
        Fri, 03 Feb 2023 16:54:21 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id u4-20020aa7db84000000b0049f88f00f70sm1853469edt.7.2023.02.03.16.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 16:54:20 -0800 (PST)
Date:   Sat, 4 Feb 2023 02:54:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v4 02/23] net: phy: add
 genphy_c45_read_eee_abilities() function
Message-ID: <20230204005418.7ryb4ihuzxlbs2nl@skbuf>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230201145845.2312060-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201145845.2312060-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 03:58:24PM +0100, Oleksij Rempel wrote:
> Add generic function for EEE abilities defined by IEEE 802.3
> specification. For now following registers are supported:
> - IEEE 802.3-2018 45.2.3.10 EEE control and capability 1 (Register 3.20)
> - IEEE 802.3cg-2019 45.2.1.186b 10BASE-T1L PMA status register
>   (Register 1.2295)
> 
> Since I was not able to find any flag signaling support of this

these registers

> registers, we should detect link mode abilities first and then based on
> this abilities doing EEE link modes detection.

these abilities

> 
> Results of EEE ability detection will be stored in to new variable

stored into

> phydev->supported_eee.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/phy-c45.c    | 49 ++++++++++++++++++++++++++++++++++++
>  drivers/net/phy/phy_device.c | 16 ++++++++++++
>  include/linux/mdio.h         | 17 +++++++++++++
>  include/linux/phy.h          |  5 ++++
>  4 files changed, 87 insertions(+)
> 
> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index 9f9565a4819d..ae87f5856650 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -661,6 +661,55 @@ int genphy_c45_read_mdix(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL_GPL(genphy_c45_read_mdix);
>  
> +/**
> + * genphy_c45_read_eee_abilities - read supported EEE link modes
> + * @phydev: target phy_device struct
> + *
> + * Read supported EEE link modes.
> + */
> +int genphy_c45_read_eee_abilities(struct phy_device *phydev)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
> +	int val;
> +
> +	linkmode_and(common, phydev->supported, PHY_EEE_100_10000_FEATURES);
> +	/* There is not indicator if optional register

no indicator whether

> +	 * "EEE control and capability 1" (3.20) is supported. Read it only
> +	 * on devices with appropriate linkmodes.
> +	 */
> +	if (!linkmode_empty(common)) {

if (linkmode_intersects(phydev->supported, PHY_EEE_100_10000_FEATURES))?

> +		/* IEEE 802.3-2018 45.2.3.10 EEE control and capability 1
> +		 * (Register 3.20)
> +		 */
> +		val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_ABLE);
> +		if (val < 0)
> +			return val;

Might the PHY also return 0xffff for an unsupported register? That would
be interpreted as "EEE is supported for all link modes", no?

> +
> +		mii_eee_100_10000_adv_mod_linkmode_t(phydev->supported_eee, val);
> +
> +		/* Some buggy devices claim not supported EEE link modes */

unsupported

> +		linkmode_and(phydev->supported_eee, phydev->supported_eee,
> +			     phydev->supported);
> +	}
> +
> +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
> +			      phydev->supported)) {
> +		/* IEEE 802.3cg-2019 45.2.1.186b 10BASE-T1L PMA status register
> +		 * (Register 1.2295)
> +		 */
> +		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_10T1L_STAT);
> +		if (val < 0)
> +			return val;
> +
> +		linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
> +				 phydev->supported_eee,
> +				 val & MDIO_PMA_10T1L_STAT_EEE);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(genphy_c45_read_eee_abilities);
> +
>  /**
>   * genphy_c45_pma_read_abilities - read supported link modes from PMA
>   * @phydev: target phy_device struct
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 9ba8f973f26f..3651f1fd8fc9 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -132,6 +132,18 @@ static const int phy_10gbit_full_features_array[] = {
>  	ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
>  };
>  
> +static const int phy_eee_100_10000_features_array[6] = {

Don't need array length unless the array is sparse, which isn't the case here.

> +	ETHTOOL_LINK_MODE_100baseT_Full_BIT,
> +	ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
> +	ETHTOOL_LINK_MODE_10000baseT_Full_BIT,
> +	ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
> +	ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
> +	ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,

Why stop at 10GBase-KR? Register 3.20 defines EEE abilities up to 100G
(for speeds >10G, there seem to be 2 modes, "deep sleep" or "fast wake",
with "deep sleep" being essentially equivalent to the only mode
available for <=10G modes).

> +};
> +
> +__ETHTOOL_DECLARE_LINK_MODE_MASK(phy_eee_100_10000_features) __ro_after_init;
> +EXPORT_SYMBOL_GPL(phy_eee_100_10000_features);
> +
>  static void features_init(void)
>  {
>  	/* 10/100 half/full*/
> @@ -213,6 +225,10 @@ static void features_init(void)
>  	linkmode_set_bit_array(phy_10gbit_fec_features_array,
>  			       ARRAY_SIZE(phy_10gbit_fec_features_array),
>  			       phy_10gbit_fec_features);
> +	linkmode_set_bit_array(phy_eee_100_10000_features_array,
> +			       ARRAY_SIZE(phy_eee_100_10000_features_array),
> +			       phy_eee_100_10000_features);
> +
>  }
>  
>  void phy_device_free(struct phy_device *phydev)
