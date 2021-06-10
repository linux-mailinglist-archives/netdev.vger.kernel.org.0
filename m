Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9183A36F3
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhFJWY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 18:24:56 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50654 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhFJWYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 18:24:55 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210610222256euoutp026c144152efe8211799d63e39d97907e1~HWMEAPPGZ2501225012euoutp02L
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 22:22:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210610222256euoutp026c144152efe8211799d63e39d97907e1~HWMEAPPGZ2501225012euoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623363776;
        bh=poyn9dHD5RqCV1XpJrNOKXbO2e1N8eoPLi+JPYKOJhI=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=dnZaSQhrWCCpxtMY8vTjECDreW6TQWT2zFxDNIajbYWQXXXEx0vXrgIRkhhZa6XrY
         mMWx6bDJ8WV1t+unPSudNXjHr/8oRhqqeV0eycoZaWrBNwBhnIZUDAHdvNzDTRuLxU
         9QzliucNytXGZFsXZwIkrfIzs81jc4cYS+PN4qLI=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210610222255eucas1p1b75114d25b06cd7534ed17b2b69c6c53~HWMCuRh4g2034220342eucas1p16;
        Thu, 10 Jun 2021 22:22:55 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 7F.A5.09439.FB092C06; Thu, 10
        Jun 2021 23:22:55 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210610222254eucas1p1d8cdccfa1befe370be30c7b8d9312230~HWMBj8WJk0602306023eucas1p1w;
        Thu, 10 Jun 2021 22:22:54 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210610222253eusmtrp1a5c9b28324eed2f8ce8ebeeb2af06915~HWMBgH16c2475224752eusmtrp1D;
        Thu, 10 Jun 2021 22:22:53 +0000 (GMT)
X-AuditID: cbfec7f5-c03ff700000024df-f0-60c290bf1fb6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 83.68.08696.DB092C06; Thu, 10
        Jun 2021 23:22:53 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210610222253eusmtip1c73d70c9aaccda3fd0b9f20ca34b9d21~HWMA3wfJO1363213632eusmtip1m;
        Thu, 10 Jun 2021 22:22:53 +0000 (GMT)
Subject: Re: [PATCH v1 1/1] net: usb: asix: ax88772: manage PHY PM from MAC
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Jon Hunter <jonathanh@nvidia.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <48ad8efd-e1c7-a352-8295-31bb14f85575@samsung.com>
Date:   Fri, 11 Jun 2021 00:22:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210610142009.16162-1-o.rempel@pengutronix.de>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsWy7djP87r7JxxKMDhyh9Pi/N1DzBZzzrew
        WCx6P4PVomXWIhaLVVN3slhc2NbHanF51xw2i0XLWpktDk3dy2hxbIGYxZN7jA7cHpevXWT2
        2LLyJpPHzll32T02repk89i54zOTR2/zOzaP/r8GHp83yQVwRHHZpKTmZJalFunbJXBlzFz1
        ga3gm0zFrtMbWRsYm8S7GDk5JARMJDY+Pc3WxcjFISSwglGicc9uRgjnC6PEsrZmKOczo0TH
        gQcsMC0L5h1mArGFBJYzSpy/HAxR9JFRYvKxNjaQhLCAt8T2h4vAGkQEXjJKrJ6XDVLELDCR
        UWLf+2/sIAk2AUOJrrddYA28AnYSP168A4uzCKhK/NjwF6iZg0NUIFni90ZdiBJBiZMzn4DN
        5BSwlWht/QXWyiwgL7H97RxmCFtc4taT+UwguyQE+jkl9nfeZoW42kViXfdzZghbWOLV8S3s
        ELaMxOnJPSwQDc2MEg/PrWWHcHoYJS43zWCEqLKWuHMOZB0H0ApNifW79CHCjhIzJj5gBQlL
        CPBJ3HgrCHEEn8SkbdOZIcK8Eh1tQhDVahKzjq+DW3vwwiXmCYxKs5C8NgvJO7OQvDMLYe8C
        RpZVjOKppcW56anFxnmp5XrFibnFpXnpesn5uZsYgUns9L/jX3cwrnj1Ue8QIxMH4yFGCQ5m
        JRHeHLVDCUK8KYmVValF+fFFpTmpxYcYpTlYlMR5d21dEy8kkJ5YkpqdmlqQWgSTZeLglGpg
        Ku65w2FV1pmiOkva5XZw1r7Sxonzc2p9Zk06FHb6XzfXZe+tVVevuXKKSv4UeODiEajMv672
        SrXc9Avq7n826k88cZR/cbuP+6uGunA/YYHMmZ1JWhx6y85yXPBtl5pYn5KYz5xuxNDiuzim
        csLBay6PZx9bd3HSloCre97nihxZfHP14qmSJz7oRktEzd+w9XhsEIND9873zalr7qhZKS5l
        MRSJzWpI4dY4fvTGKxb+ytvshzi3L8s4xuoTNUn44Ltzq59mcf9blfbm+RmWC7pzahcnyxUb
        H9JKuLb7d130nAU/134/bBSuKTN5xt4o7izFv0nia+577Z93fX3KUyWvricux3WnvvzafXTW
        PCWW4oxEQy3mouJEAHuhKxrRAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t/xu7p7JxxKMPgx28zi/N1DzBZzzrew
        WCx6P4PVomXWIhaLVVN3slhc2NbHanF51xw2i0XLWpktDk3dy2hxbIGYxZN7jA7cHpevXWT2
        2LLyJpPHzll32T02repk89i54zOTR2/zOzaP/r8GHp83yQVwROnZFOWXlqQqZOQXl9gqRRta
        GOkZWlroGZlY6hkam8daGZkq6dvZpKTmZJalFunbJehlzFz1ga3gm0zFrtMbWRsYm8S7GDk5
        JARMJBbMO8zUxcjFISSwlFHi3ITp7BAJGYmT0xpYIWxhiT/Xutggit4zSkyaupAZJCEs4C2x
        /eEiFpCEiMBLRolfW5+AVTELTARyni1jhmiZwCixfXcH2Cw2AUOJrrcgszg5eAXsJH68eAe2
        j0VAVeLHhr8sILaoQLLEhvb/rBA1ghInZz4Bi3MK2Eq0tv4C62UWMJOYt/khM4QtL7H97Rwo
        W1zi1pP5TBMYhWYhaZ+FpGUWkpZZSFoWMLKsYhRJLS3OTc8tNtIrTswtLs1L10vOz93ECIzd
        bcd+btnBuPLVR71DjEwcjIcYJTiYlUR4c9QOJQjxpiRWVqUW5ccXleakFh9iNAX6ZyKzlGhy
        PjB55JXEG5oZmBqamFkamFqaGSuJ85ocWRMvJJCeWJKanZpakFoE08fEwSnVwBTEq31N86fz
        5DK5up7PFdaRTvyPJ7Qs2RRTwHiZZd0Jp1u9zNsvrwh+yP3d6/9qzoftCizOf5fosy9z/yu2
        N83rcfC85KU/kxbsbwtj+qp498zp3BMW3Dtn60gxaNjc2HFsYccjrWl8uaxRXTsn71KZMYt5
        BafPnFpp1V1vbpzMWm9Y5qUkcrTw1fwEn3+PbE9udys9tj5g5csjjya4h54wNv+xzKF43Rel
        fyFzP99sP7SmY6mcoLPDpdK3lRMPfM27JO2sXpEs5Bg80cn3Ub3jlPr7n289fsHM8FF/19HH
        R5jfJ1umnQjILn/Hrxbeq7InylHn28YTx9nO1jCEf7rMLVYbp8jy/86u9SpN4gJKLMUZiYZa
        zEXFiQD2YYYnZgMAAA==
X-CMS-MailID: 20210610222254eucas1p1d8cdccfa1befe370be30c7b8d9312230
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210610142025eucas1p2f3377bf0dbf1b02e37513ab338adc384
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210610142025eucas1p2f3377bf0dbf1b02e37513ab338adc384
References: <CGME20210610142025eucas1p2f3377bf0dbf1b02e37513ab338adc384@eucas1p2.samsung.com>
        <20210610142009.16162-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On 10.06.2021 16:20, Oleksij Rempel wrote:
> Take over PHY power management, otherwise PHY framework will try to
> access ASIX MDIO bus before MAC resume was completed.
>
> Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reported-by: Jon Hunter <jonathanh@nvidia.com>
> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>

This fixes the issues observed on my test systems. Thanks!

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/net/usb/asix_devices.c | 43 ++++++++++------------------------
>   1 file changed, 12 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 8a477171e8f5..aec97b021a73 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -598,6 +598,9 @@ static void ax88772_suspend(struct usbnet *dev)
>   	struct asix_common_private *priv = dev->driver_priv;
>   	u16 medium;
>   
> +	if (netif_running(dev->net))
> +		phy_stop(priv->phydev);
> +
>   	/* Stop MAC operation */
>   	medium = asix_read_medium_status(dev, 1);
>   	medium &= ~AX_MEDIUM_RE;
> @@ -605,14 +608,6 @@ static void ax88772_suspend(struct usbnet *dev)
>   
>   	netdev_dbg(dev->net, "ax88772_suspend: medium=0x%04x\n",
>   		   asix_read_medium_status(dev, 1));
> -
> -	/* Preserve BMCR for restoring */
> -	priv->presvd_phy_bmcr =
> -		asix_mdio_read_nopm(dev->net, dev->mii.phy_id, MII_BMCR);
> -
> -	/* Preserve ANAR for restoring */
> -	priv->presvd_phy_advertise =
> -		asix_mdio_read_nopm(dev->net, dev->mii.phy_id, MII_ADVERTISE);
>   }
>   
>   static int asix_suspend(struct usb_interface *intf, pm_message_t message)
> @@ -626,39 +621,22 @@ static int asix_suspend(struct usb_interface *intf, pm_message_t message)
>   	return usbnet_suspend(intf, message);
>   }
>   
> -static void ax88772_restore_phy(struct usbnet *dev)
> -{
> -	struct asix_common_private *priv = dev->driver_priv;
> -
> -	if (priv->presvd_phy_advertise) {
> -		/* Restore Advertisement control reg */
> -		asix_mdio_write_nopm(dev->net, dev->mii.phy_id, MII_ADVERTISE,
> -				     priv->presvd_phy_advertise);
> -
> -		/* Restore BMCR */
> -		if (priv->presvd_phy_bmcr & BMCR_ANENABLE)
> -			priv->presvd_phy_bmcr |= BMCR_ANRESTART;
> -
> -		asix_mdio_write_nopm(dev->net, dev->mii.phy_id, MII_BMCR,
> -				     priv->presvd_phy_bmcr);
> -
> -		priv->presvd_phy_advertise = 0;
> -		priv->presvd_phy_bmcr = 0;
> -	}
> -}
> -
>   static void ax88772_resume(struct usbnet *dev)
>   {
> +	struct asix_common_private *priv = dev->driver_priv;
>   	int i;
>   
>   	for (i = 0; i < 3; i++)
>   		if (!ax88772_hw_reset(dev, 1))
>   			break;
> -	ax88772_restore_phy(dev);
> +
> +	if (netif_running(dev->net))
> +		phy_start(priv->phydev);
>   }
>   
>   static void ax88772a_resume(struct usbnet *dev)
>   {
> +	struct asix_common_private *priv = dev->driver_priv;
>   	int i;
>   
>   	for (i = 0; i < 3; i++) {
> @@ -666,7 +644,8 @@ static void ax88772a_resume(struct usbnet *dev)
>   			break;
>   	}
>   
> -	ax88772_restore_phy(dev);
> +	if (netif_running(dev->net))
> +		phy_start(priv->phydev);
>   }
>   
>   static int asix_resume(struct usb_interface *intf)
> @@ -722,6 +701,8 @@ static int ax88772_init_phy(struct usbnet *dev)
>   		return ret;
>   	}
>   
> +	priv->phydev->mac_managed_pm = 1;
> +
>   	phy_attached_info(priv->phydev);
>   
>   	return 0;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

