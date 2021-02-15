Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3859031C2DC
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhBOUKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhBOUJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 15:09:42 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55088C061786;
        Mon, 15 Feb 2021 12:09:01 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o15so7131605wmq.5;
        Mon, 15 Feb 2021 12:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mhl8fAiI0GpJC/JWuRJBDgh/SNjy5lnp8Ubz2OgdyUk=;
        b=lGsLrNf9owuTcpYtz3wKw5KqeM6DUa86PHoFV8lUEzfhC75CLWTwd2XbDzpveIAXBu
         qS4FsN7yNus0xbU7nuiXqyu308J8zZ1bxWc96I20CXxPCWPGqEzFPaZq1B/od+kTYND/
         A7yGR4tXoowwxPdljFP1+yDOJroEEuMZB6ANwKE8FKtYaYxrjTo5i9Wx5x/AfdVRcjCt
         8eHPCDeZqpy9xjCAh9IrsDhmRAzGpvhP4F0BFVR8PykUv5Wl8gQiYl3UdUjE29M3lAwD
         56zvzUaQiU9q6oljEHx8W/SR/lqq4PNuAfhsOIixT/JsFJcKzTXT5oEAvJewxDcM07Ra
         7VeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mhl8fAiI0GpJC/JWuRJBDgh/SNjy5lnp8Ubz2OgdyUk=;
        b=O6dkPjN0Z55LlD3r+YlcTfqt+/SDGTjynUfLKzdXvY1B1GdewQ4M9W32rRCASjdAIg
         fay+rZ//N8iq1P5hZwZ3YRWOi7IXixJpg1DjAMpid5/3KweuIFI5RiTGBcmsoGwAUTy6
         7X9Ku45EGG8+A4y4s0E36X7DBy8UY8/9OpZ2t3+Nt5Tyxbbt8U0MxUEbxA8rxt6RhKNA
         aAexeSA6qzZm/GF/O686ryzz0Zv8mf9DwUKEtTTxEhbaHuE5lld5Fe5MCEGRpONr8Oks
         /2oEUcSDTniqdO1Vs/yAY3rVhCf4uabWTuA2Q64mM/7lceSI3UyIt3ZB49MzgXibIfA9
         NcQw==
X-Gm-Message-State: AOAM533QcJmKcydyzmzErfMJX/1n04XN1rLh0L4XcuZy5JhzkIaq5GHR
        1Fx3BKHm5gn1lmvmYs4Ni88=
X-Google-Smtp-Source: ABdhPJzddAD+mvBu5P8dKYp+IAhuG01Cy0eP9AXsxponMqgTI5dugpT5xQtGX8iLOyO+XNxt//KKMg==
X-Received: by 2002:a1c:f417:: with SMTP id z23mr424848wma.29.1613419739983;
        Mon, 15 Feb 2021 12:08:59 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:ace1:3140:5214:77e3? (p200300ea8f395b00ace13140521477e3.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:ace1:3140:5214:77e3])
        by smtp.googlemail.com with ESMTPSA id n3sm24571323wrv.22.2021.02.15.12.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Feb 2021 12:08:59 -0800 (PST)
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
References: <20210215165800.14580-1-bjarni.jonasson@microchip.com>
 <20210215165800.14580-3-bjarni.jonasson@microchip.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2 3/3] net: phy: mscc: coma mode disabled for
 VSC8514
Message-ID: <a3a7c583-e881-58d2-6c94-b68809a8b675@gmail.com>
Date:   Mon, 15 Feb 2021 21:08:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210215165800.14580-3-bjarni.jonasson@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.02.2021 17:58, Bjarni Jonasson wrote:
> The 'coma mode' (configurable through sw or hw) provides an
> optional feature that may be used to control when the PHYs become active.
> The typical usage is to synchronize the link-up time across
> all PHY instances. This patch releases coma mode if not done by hardware,
> otherwise the phys will not link-up
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> Fixes: e4f9ba642f0b ("net: phy: mscc: add support for VSC8514 PHY.")
> ---
> v1 -> v2:
>   Modified coma mode config 
>   Changed net to net-next
> 
>  drivers/net/phy/mscc/mscc.h      |  3 +++
>  drivers/net/phy/mscc/mscc_main.c | 16 ++++++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
> index 9d8ee387739e..2b70ccd1b256 100644
> --- a/drivers/net/phy/mscc/mscc.h
> +++ b/drivers/net/phy/mscc/mscc.h
> @@ -160,6 +160,9 @@ enum rgmii_clock_delay {
>  #define MSCC_PHY_PAGE_TR		  0x52b5 /* Token ring registers */
>  #define MSCC_PHY_GPIO_CONTROL_2	  14
>  
> +#define MSCC_PHY_COMA_MODE		  0x2000 /* input(1) / output(0) */
> +#define MSCC_PHY_COMA_OUTPUT		  0x1000 /* value to output */
> +
>  /* Extended Page 1 Registers */
>  #define MSCC_PHY_CU_MEDIA_CRC_VALID_CNT	  18
>  #define VALID_CRC_CNT_CRC_MASK		  GENMASK(13, 0)
> diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
> index 03181542bcb7..29302ccf7e7b 100644
> --- a/drivers/net/phy/mscc/mscc_main.c
> +++ b/drivers/net/phy/mscc/mscc_main.c
> @@ -1520,6 +1520,21 @@ static void vsc8584_get_base_addr(struct phy_device *phydev)
>  	vsc8531->addr = addr;
>  }
>  
> +static void vsc85xx_coma_mode_release(struct phy_device *phydev)
> +{
> +	/* The coma mode (pin or reg) provides an optional feature that
> +	 * may be used to control when the PHYs become active.
> +	 * Alternatively the COMA_MODE pin may be connected low
> +	 * so that the PHYs are fully active once out of reset.
> +	 */
> +	phy_unlock_mdio_bus(phydev);
> +	/* Enable output (mode=0) and write zero to it */
> +	phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_GPIO,
> +			 MSCC_PHY_GPIO_CONTROL_2,
> +			 MSCC_PHY_COMA_MODE | MSCC_PHY_COMA_OUTPUT, 0);
> +	phy_lock_mdio_bus(phydev);

The temporary unlock is a little bit hacky. Better do:
vsc85xx_phy_write_page(MSCC_PHY_PAGE_EXTENDED_GPIO)
__phy_modify()
vsc85xx_phy_write_page(default page)

Alternatively we could add __phy_modify_paged(). But this may not
be worth the effort for now.

> +}
> +
>  static int vsc8584_config_init(struct phy_device *phydev)
>  {
>  	struct vsc8531_private *vsc8531 = phydev->priv;
> @@ -2604,6 +2619,7 @@ static int vsc8514_config_init(struct phy_device *phydev)
>  		ret = vsc8514_config_host_serdes(phydev);
>  		if (ret)
>  			goto err;
> +		vsc85xx_coma_mode_release(phydev);
>  	}
>  
>  	phy_unlock_mdio_bus(phydev);
> 

