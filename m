Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015D22E89DF
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 02:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbhACBhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 20:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbhACBhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jan 2021 20:37:06 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BCDC061573;
        Sat,  2 Jan 2021 17:36:26 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4D7hDF28NyzQlWg;
        Sun,  3 Jan 2021 02:35:57 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1609637754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WAdMaJwjcc2yfaR82pX6X65vm+J+1jLuYf/duIFxcp4=;
        b=kWcnHrO0AU/XnF5sS207eTiljYP53E/Tu79Kd+QqBF0WevubkFx16epDLhfR9V3KWcKO9Z
        b4JuhKKZANRUord+nPm8F3wX5JhF1j7v9ZUf/JBk1SAeqgGrrsOGqJR1roKn1ivhCE3AYW
        DHQOxbRNNXqtvCqG7U+uSjUkffuI2ytMI8SLUArlFvWvKY3WPuPXsHwDHY1UtVhJArZdOF
        Eb5cft3iAcWjjFffhHSgD7EU9s7Cm8gDydaB/MoZOcDO8hqUTnp2iNvtHck245OEcoosmq
        cDBRbhN/ukyOi+w8YU79tkPKtUEu6+X97X0GXN0khr3lpmzHOSnzKFgcRjewaQ==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id xl50MIJRqUhf; Sun,  3 Jan 2021 02:35:52 +0100 (CET)
Subject: Re: [PATCH 1/2] net: dsa: lantiq_gswip: Enable GSWIP_MII_CFG_EN also
 for internal PHYs
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210103012544.3259029-1-martin.blumenstingl@googlemail.com>
 <20210103012544.3259029-2-martin.blumenstingl@googlemail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <41f43642-d4a6-01fa-4427-50fa695df594@hauke-m.de>
Date:   Sun, 3 Jan 2021 02:35:50 +0100
MIME-Version: 1.0
In-Reply-To: <20210103012544.3259029-2-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -5.50 / 15.00 / 15.00
X-Rspamd-Queue-Id: 0E05B17DD
X-Rspamd-UID: ff18dc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/3/21 2:25 AM, Martin Blumenstingl wrote:
> Enable GSWIP_MII_CFG_EN also for internal PHYs to make traffic flow.
> Without this the PHY link is detected properly and ethtool statistics
> for TX are increasing but there's no RX traffic coming in.
> 
> Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Cc: stable@vger.kernel.org
> Suggested-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>   drivers/net/dsa/lantiq_gswip.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
> index 09701c17f3f6..5d378c8026f0 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -1541,9 +1541,7 @@ static void gswip_phylink_mac_link_up(struct dsa_switch *ds, int port,
>   {
>   	struct gswip_priv *priv = ds->priv;
>   
> -	/* Enable the xMII interface only for the external PHY */
> -	if (interface != PHY_INTERFACE_MODE_INTERNAL)
> -		gswip_mii_mask_cfg(priv, 0, GSWIP_MII_CFG_EN, port);
> +	gswip_mii_mask_cfg(priv, 0, GSWIP_MII_CFG_EN, port);
>   }
>   
>   static void gswip_get_strings(struct dsa_switch *ds, int port, u32 stringset,
> 

