Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3673EEA1E
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbhHQJls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239087AbhHQJlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:41:47 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307C2C061764;
        Tue, 17 Aug 2021 02:41:14 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id h9so37419025ejs.4;
        Tue, 17 Aug 2021 02:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xfs/l8KNPldYvYSfsE5tioy382KDShw/nZNTXXTrdnc=;
        b=RVACI4CdE27rO43ekpdJkhagh1GNeqQuDCt+kYuwwLoJjnvR7h5gszWPYgUuOq6i98
         CMjoNiwwN1M9Y7jFNVeKQUw1zhHSOnJ2cxztNCo3GSF0gjErJ93c9O5L/wbj6n8C/8Eg
         OUzdTJ++cUmemxAN4zwCQmkeMVloypqy1sVnAybNwvQddcJY1bbztvh/w/DZPycDvjoz
         SxY1oXidrd9lHXzRl43HO8DoIcvUan8vIY0KzeYvmVMLIRKab0Uka7pYD2C119SdkATF
         RaMMLlXB9NWlYyLj5QKTbGVfanwFybqryoR+Nc43BK5CXx3si6/HWbaThR45YVNpUbZt
         ofug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xfs/l8KNPldYvYSfsE5tioy382KDShw/nZNTXXTrdnc=;
        b=PfDzkv3TJSTv7E+H2HfHL1Z9wwt3HxkG2STspm3wxR3vUhARHjdYsnvNW+6v2JvutB
         CtkuulxpUq74C1cuwV/oXtQ/pRMyHcydxuzvT4zn6Obj34Uiok+FyBUndErMJpAx1Fda
         jWyh+xX0/qvJOmSK7cVa+ZhSiN/I9UlfAQFKwTg6WFnT0UJPH+p6/8V+UZ/ywHhQw79W
         eLQ21mh9ZDGTa9Sh7stXRmUEO7nH3R8/6ii6VQZCnuGeWmFSTlsUlxng9QSRpBuDVzrY
         reslyyLyi8cQZsqZLsBnxphbqpErPpb3pKUde0GfLjthTabuCLq4ggbR8LOLNpFCdijc
         etRQ==
X-Gm-Message-State: AOAM530QWfx8o1RolXaHNcACZ12T5gL4ohF+cqEzCkP/n+MbELayAbqF
        TFdznWpue7qzZtaCwXyujDw=
X-Google-Smtp-Source: ABdhPJwd8chO9kxq2L9cysozEO//ABcYOVkuf3f/I/bF8amsiBAxRgt4lVD/+Y9McWwLImO/qLBf+Q==
X-Received: by 2002:a17:907:2cf0:: with SMTP id hz16mr2991670ejc.466.1629193272716;
        Tue, 17 Aug 2021 02:41:12 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id g10sm517357ejj.44.2021.08.17.02.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 02:41:12 -0700 (PDT)
Date:   Tue, 17 Aug 2021 12:41:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [RFC PATCH v3 net-next 09/10] net: dsa: ocelot: felix: add
 support for VSC75XX control over SPI
Message-ID: <20210817094110.vfrrbt264trmn7ri@skbuf>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-10-colin.foster@in-advantage.com>
 <20210814114329.mycpcfwoqpqxzsyl@skbuf>
 <20210814120211.v2qjqgi6l3slnkq2@skbuf>
 <20210815204149.GB3328995@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815204149.GB3328995@euler>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 15, 2021 at 01:41:49PM -0700, Colin Foster wrote:
> I also came across some curious code in Seville where it is callocing a
> struct phy_device * array instead of struct lynx_pcs *. I'm not sure if
> that's technically a bug or if the thought is "a pointer array is a
> pointer array."

git blame will show you that it is a harmless leftover of commit
588d05504d2d ("net: dsa: ocelot: use the Lynx PCS helpers in Felix and
Seville"). Before that patch, the pcs was a struct phy_device.

> @@ -1062,12 +1062,12 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
>  	int port;
>
>  	for (port = 0; port < ocelot->num_phys_ports; port++) {
> -		struct lynx_pcs *pcs = felix->pcs[port];
> +		struct phylink_pcs *pcs = felix->pcs[port];
>
>  		if (!pcs)
>  			continue;
>
> -		mdio_device_free(pcs->mdio);
> +		mdio_device_free(lynx_pcs_get_mdio(pcs));

Don't really have a better suggestion than lynx_pcs_get_mdio.

>  		lynx_pcs_destroy(pcs);
>  	}
>  	felix_mdio_bus_free(ocelot);
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> index ccaf7e35abeb..484f0d4efefe 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -270,10 +270,11 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
>
>  static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
>  {
> -	struct lynx_pcs *pcs = mac->pcs;
> +	struct phylink_pcs *pcs = mac->pcs;
>
>  	if (pcs) {
> -		struct device *dev = &pcs->mdio->dev;
> +		struct mdio_device *mdio = lynx_get_mdio_device(pcs);
> +		struct device *dev = &mdio->dev;
>  		lynx_pcs_destroy(pcs);
>  		put_device(dev);

Ideally dpaa2 would call mdio_device_free too, just like the others.

>  		mac->pcs = NULL;
> @@ -336,7 +337,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  	mac->phylink = phylink;
>
>  	if (mac->pcs)
> -		phylink_set_pcs(mac->phylink, &mac->pcs->pcs);
> +		phylink_set_pcs(mac->phylink, mac->pcs);
>
>  	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
>  	if (err) {
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> index 31274325159a..cc2ca51ac984 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -823,7 +823,7 @@ static int enetc_imdio_create(struct enetc_pf *pf)
>  {
>  	struct device *dev = &pf->si->pdev->dev;
>  	struct enetc_mdio_priv *mdio_priv;
> -	struct lynx_pcs *pcs_lynx;
> +	struct phylink_pcs *pcs_phylink;
>  	struct mdio_device *pcs;

Agree with Russell's suggestion to replace "pcs" with "mdiodev" wherever
it refers to a struct mdio_device. Likely as a separate patch.

>  	struct mii_bus *bus;
>  	int err;
> @@ -341,13 +355,13 @@ struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio)
>  	lynx_pcs->pcs.ops = &lynx_pcs_phylink_ops;
>  	lynx_pcs->pcs.poll = true;
>
> -	return lynx_pcs;
> +	return lynx_to_phylink_pcs(lynx_pcs);

I would probably write another patch to convert all occurrences of
"struct lynx_pcs" variables to the same naming scheme. Currently we have
"lynx", "pcs", "lynx_pcs" only within the pcs-lynx.c file itself. "lynx"
seems to be the predominant name so all others could be replaced with
that too.

>  }
>  EXPORT_SYMBOL(lynx_pcs_create);
>
> -void lynx_pcs_destroy(struct lynx_pcs *pcs)
> +void lynx_pcs_destroy(struct phylink_pcs *pcs)
>  {
> -	kfree(pcs);
> +	kfree(phylink_pcs_to_lynx(pcs));

I would perhaps do this in two stages

	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);

	kfree(lynx);

>  }
>  EXPORT_SYMBOL(lynx_pcs_destroy);
>
> diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
> index a6440d6ebe95..5712cc2ce775 100644
> --- a/include/linux/pcs-lynx.h
> +++ b/include/linux/pcs-lynx.h
> @@ -9,13 +9,10 @@
>  #include <linux/mdio.h>
>  #include <linux/phylink.h>
>
> -struct lynx_pcs {
> -	struct phylink_pcs pcs;
> -	struct mdio_device *mdio;
> -};

Good that this structure is no longer exposed.

> +struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs);
>
> -struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio);
> +struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
>
> -void lynx_pcs_destroy(struct lynx_pcs *pcs);
> +void lynx_pcs_destroy(struct phylink_pcs *pcs);

We don't want the few phylink_pcs drivers going in different directions,
so we should modify pcs-xpcs.c too such that it no longer exposes struct
dw_xpcs to the outside world. I think I hid most of that away already,
and grepping for "xpcs->" in drivers/net/dsa and drivers/net/ethernet,
I only see xpcs->mdiodev and xpcs->pcs being accessed, so converting
khat should be a walk in the park.

Anyway, I would focus for now on getting the ocelot hardware to work and
writing the phylink_pcs driver for that. That is one part where I can't
help a lot with.
