Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87E73CEDBD
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 22:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386803AbhGSTjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 15:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383393AbhGSRyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 13:54:09 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965EDC0610D3
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 11:17:19 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4GT9QG39sGzQjq4;
        Mon, 19 Jul 2021 20:30:46 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1626719444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sqMZx5PQPg6jhJwxacmvzn6kPQtSbFJHzI0JlT2/niY=;
        b=HylS2G7pXLPuKzt1p9mSQ4KcsTkkLEpjUUW02o2tp4mR0NUD/n+kS4qzacefR+HZeiBv9E
        OLsgNPXaJ9nCaZsnQoBdcdDCUyMKZ3ai66Bst/AhS1CmLl3I2J6j6HW4Rv55Rj3VjytMkI
        TVNPoTfZ7W7bXqJZiZ2+Yfw0fs7U8XIcpdawZzE5wF8ChRSUR9e56/VWnP76prLmGzK2VZ
        iLGAUYln1GNHXZjDRMvxYPnBJ+ad0eWVENB/ZnxBlYjUlcl4FY5Pq51Jvt68RNJj8n82Vr
        fwok+xF+Fv/LAUppaXjQAOXlUOpP1agzFwuD2mkH8j9rINKt7GDcOjxhI9tRfw==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id dVaRocw7w0L1; Mon, 19 Jul 2021 20:30:43 +0200 (CEST)
Subject: Re: [PATCH v6 1/2] net: phy: add API to read 802.3-c45 IDs
To:     Xu Liang <lxu@maxlinear.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        vee.khee.wong@linux.intel.com
Cc:     linux@armlinux.org.uk, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com, mohammad.athari.ismail@intel.com
References: <20210719053212.11244-1-lxu@maxlinear.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <560828fa-928a-7253-d875-7a137257445c@hauke-m.de>
Date:   Mon, 19 Jul 2021 20:30:41 +0200
MIME-Version: 1.0
In-Reply-To: <20210719053212.11244-1-lxu@maxlinear.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8743018B6
X-Rspamd-UID: 631439
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/21 7:32 AM, Xu Liang wrote:
> Add API to read 802.3-c45 IDs so that C22/C45 mixed device can use
> C45 APIs without failing ID checks.
> 
> Signed-off-by: Xu Liang <lxu@maxlinear.com>

Acked-by: Hauke Mehrtens <hmehrtens@maxlinear.com>

> ---
> v5 changes:
>   Fix incorrect prototype name in comment.
> 
>   drivers/net/phy/phy_device.c | 14 ++++++++++++++
>   include/linux/phy.h          |  1 +
>   2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 5d5f9a9ee768..107aa6d7bc6b 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -968,6 +968,20 @@ void phy_device_remove(struct phy_device *phydev)
>   }
>   EXPORT_SYMBOL(phy_device_remove);
>   
> +/**
> + * phy_get_c45_ids - Read 802.3-c45 IDs for phy device.
> + * @phydev: phy_device structure to read 802.3-c45 IDs
> + *
> + * Returns zero on success, %-EIO on bus access error, or %-ENODEV if
> + * the "devices in package" is invalid.
> + */
> +int phy_get_c45_ids(struct phy_device *phydev)
> +{
> +	return get_phy_c45_ids(phydev->mdio.bus, phydev->mdio.addr,
> +			       &phydev->c45_ids);
> +}
> +EXPORT_SYMBOL(phy_get_c45_ids);
> +
>   /**
>    * phy_find_first - finds the first PHY device on the bus
>    * @bus: the target MII bus
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 3b80dc3ed68b..736e1d1a47c4 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -1431,6 +1431,7 @@ static inline int phy_device_register(struct phy_device *phy)
>   static inline void phy_device_free(struct phy_device *phydev) { }
>   #endif /* CONFIG_PHYLIB */
>   void phy_device_remove(struct phy_device *phydev);
> +int phy_get_c45_ids(struct phy_device *phydev);
>   int phy_init_hw(struct phy_device *phydev);
>   int phy_suspend(struct phy_device *phydev);
>   int phy_resume(struct phy_device *phydev);
> 

