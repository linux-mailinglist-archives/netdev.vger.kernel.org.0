Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310B343B790
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237530AbhJZQwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235947AbhJZQwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 12:52:13 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86688C061745;
        Tue, 26 Oct 2021 09:49:49 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id z5-20020a9d4685000000b005537cbe6e5aso13941697ote.1;
        Tue, 26 Oct 2021 09:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sRuL3CxFX90zCNukSdXsMn2x+b0/6Lbl9IdJAD2baLo=;
        b=MhPRSFcWUymBT04pH6NhO1Au8PprDBVZ5I+Nf/KLLMH/Zi+F+gzWJABz0PzZ3WvH50
         1LK48lUsSllTeFzMVIC77mCpd4L2GC8nBPceL4qwlx0r6mKX9tW7lsZpBCvJ3rFi5ecr
         xDBO/cYriiIdFoXR55V6PQJkdEDVOaenDuOy4RwA39yTcJGYcwlEPjBj+ln7jJp76KQt
         oke3w24aUugyGhe7ag6C9xtCzGf5pGkkODwk0wZyyxbw23QmW1rijl8tOVx2a9CHtmkQ
         Ck0ofXZ3Cg0gR0koWPJi5KaDG5/PFYUbcY04xUdmJ8VO1yqSFdXPNlUxa3V+6gvYM4yB
         G4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=sRuL3CxFX90zCNukSdXsMn2x+b0/6Lbl9IdJAD2baLo=;
        b=i6YR4fcDBUym4zJ3/IA72swZjNoIDHEmcUmsL63ZA76SBN/SUrOiF6q28QBwD+pQzY
         yoTJs+RBbLgY8Lq4QKkFj7pxIfaQJhSIU0oqeQjR/FtwSCwTuViJD5VM9qAfNsVWHtvh
         kgPhYAc/wBijdfSmMZP6LrodxPRJuYz5+d8IM3Ll+ECyzIBGB/GVCumWcgpU86qkCLBO
         S6yOv6/FKqognj8R0IIBZbZAzZ2uBQDnbcypLyJgtG4ykiy2QCdkzHgRSU93xIHsEx5B
         K0CEGUQv/qUcFeKBmAbhD5q/+aJgYlfbjE7WJxIS50NRa65IHx5ZRysG2oDqjvsOoAfw
         cDIA==
X-Gm-Message-State: AOAM532GNioKge6JjsJ4XFOnEU36WL0dZFtxBC6VNQbT2+3oZlE+WFma
        BAaFvTtX/n2HEWnoJw4a6Nw=
X-Google-Smtp-Source: ABdhPJyww4iMTciB3wH+7w/RkVCaAJEWeMghZBtRkPcjqAKbMBvqKa3dyd3d/NnP49JVkfXui4q+/g==
X-Received: by 2002:a9d:12f4:: with SMTP id g107mr20462135otg.77.1635266988973;
        Tue, 26 Oct 2021 09:49:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bj14sm5210168oib.3.2021.10.26.09.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 09:49:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Oct 2021 09:49:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 2/2] net: macb: Use mdio child node for MDIO bus
 if it exists
Message-ID: <20211026164947.GA3550285@roeck-us.net>
References: <20211022163548.3380625-1-sean.anderson@seco.com>
 <20211022163548.3380625-2-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022163548.3380625-2-sean.anderson@seco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

while bisecting I noticed the following.

On Fri, Oct 22, 2021 at 12:35:48PM -0400, Sean Anderson wrote:
> This allows explicitly specifying which children are present on the mdio
> bus. Additionally, it allows for non-phy MDIO devices on the bus.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
>  drivers/net/ethernet/cadence/macb_main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 029dea2873e3..30a65cac9e87 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -898,6 +898,17 @@ static int macb_mdiobus_register(struct macb *bp)
>  {
>  	struct device_node *child, *np = bp->pdev->dev.of_node;
>  
> +	/* If we have a child named mdio, probe it instead of looking for PHYs
> +	 * directly under the MAC node
> +	 */
> +	child = of_get_child_by_name(np, "mdio");
> +	if (np) {

s/np/child/ 

to avoid network interface failures with messages like

[   12.764530] macb 10090000.ethernet eth0: Could not attach PHY (-19)

I'll send a patch in a minute to fix this up, after bisect is complete
and after testing, to make sure that there is no additional problem.

Guenter

> +		int ret = of_mdiobus_register(bp->mii_bus, child);
> +
> +		of_node_put(child);
> +		return ret;
> +	}
> +
>  	if (of_phy_is_fixed_link(np))
>  		return mdiobus_register(bp->mii_bus);
>  
> -- 
> 2.25.1
> 
