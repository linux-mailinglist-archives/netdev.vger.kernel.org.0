Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30843F41D0
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 23:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhHVVz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 17:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbhHVVz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 17:55:27 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F269CC061575;
        Sun, 22 Aug 2021 14:54:45 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id d6so23172738edt.7;
        Sun, 22 Aug 2021 14:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=JnvHjdS1PTn3LtRlqktycusB5LnBrGsBiINWNTLOPpI=;
        b=bHr4tk+x95RH3YmWzIOr6hzsJa1eidelP+H4k0fa0XUuPJlmBJw3cdU1c0MXs8Zcfj
         fzxy5n6gI+DsAKLaSuHY9+YXxtqqsyl9S2hdnODDyaqvvq3pTD1cy/CiOpnFLoix/A/b
         s4LPGbEKsdN6Zno8YU0z2GWhKUx1R6jomKUIP8BbgOm11xRZGNvKnnDP9XdtbPhClFw6
         rs0AcWeixReOR5Rzg2L+3zKuNSXPOjNQKAMCHBvVJN4dhMF9sQJwc6hRMsI6su80t5dB
         tuVESIO/x28HqZTB1zw1jD5URrxIRl4x9BPOu7ZPdlwj4/CrdlS2eH/s4YCEmJLVHLef
         Njnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JnvHjdS1PTn3LtRlqktycusB5LnBrGsBiINWNTLOPpI=;
        b=tuMtly2Qw6becdvOjO7XDqqIIKJUl6oP4IQDPvaVMXE5cXNaKg8dZDmrdK0jGJYFTN
         mBAYL9b0p4KoCCP9QHCeG/WCQce2P4CjqQqa79qsHvfg/CaeUPIareiiXqPN2avD3L7W
         JP5n1PdDifj+ZLardymxmXMsiQKexD2ZwfoxnZ7bb9FSBPmv8Ys5G/3MfFq3079Cgfmr
         yZjTpPUp45nrBGltidwDxJrZ902A8aNlxPw8KtgZtCWDWEuIU+XbfK307OsdbxkQ4rDS
         phPlM2uq/myKZgAm8XOkgzFQMnHVs2FtY37mtTBDKX+nsYrW6dYuHEE37x/o9q8kHWcJ
         QQhg==
X-Gm-Message-State: AOAM530IZ+fvTME5t5VstB2iA2X2n4hhPQQVRrcPU+XSOBK2U5393E1E
        peD6qO6wtixR3n4C8nuABHI=
X-Google-Smtp-Source: ABdhPJysnDhtbtNFUHQ5RFwNJcUd2UUtr6VYQisZB+0Uj2I9H8rrBULZcW1jcj3lIrvFIxXQYTJZ9Q==
X-Received: by 2002:a05:6402:184a:: with SMTP id v10mr33397631edy.324.1629669284487;
        Sun, 22 Aug 2021 14:54:44 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id m12sm6297898ejd.21.2021.08.22.14.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 14:54:44 -0700 (PDT)
Date:   Mon, 23 Aug 2021 00:54:42 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, mir@bang-olufsen.dk,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 1/5] net: dsa: realtek-smi: fix mdio_free
 bug on module unload
Message-ID: <20210822215442.a2xywnodg7qwf2b5@skbuf>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-2-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210822193145.1312668-2-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 09:31:39PM +0200, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> realtek-smi-core fails to unregister the slave MII bus on module unload,
> raising the following BUG warning:
> 
>     mdio_bus.c:650: BUG_ON(bus->state != MDIOBUS_UNREGISTERED);
> 
>     kernel BUG at drivers/net/phy/mdio_bus.c:650!
>     Internal error: Oops - BUG: 0 [#1] PREEMPT_RT SMP
>     Call trace:
>      mdiobus_free+0x4c/0x50
>      devm_mdiobus_free+0x18/0x20
>      release_nodes.isra.0+0x1c0/0x2b0
>      devres_release_all+0x38/0x58
>      device_release_driver_internal+0x124/0x1e8
>      driver_detach+0x54/0xe0
>      bus_remove_driver+0x60/0xd8
>      driver_unregister+0x34/0x60
>      platform_driver_unregister+0x18/0x20
>      realtek_smi_driver_exit+0x14/0x1c [realtek_smi]
> 
> Fix this by duly unregistering the slave MII bus with
> mdiobus_unregister. We do this in the DSA teardown path, since
> registration is performed in the DSA setup path.
> 
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---
>  drivers/net/dsa/realtek-smi-core.c | 6 ++++++
>  drivers/net/dsa/realtek-smi-core.h | 1 +
>  drivers/net/dsa/rtl8366rb.c        | 8 ++++++++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
> index 8e49d4f85d48..6992b6b31db6 100644
> --- a/drivers/net/dsa/realtek-smi-core.c
> +++ b/drivers/net/dsa/realtek-smi-core.c
> @@ -383,6 +383,12 @@ int realtek_smi_setup_mdio(struct realtek_smi *smi)
>  	return ret;
>  }
>  
> +void realtek_smi_teardown_mdio(struct realtek_smi *smi)
> +{
> +	if (smi->slave_mii_bus)
> +		mdiobus_unregister(smi->slave_mii_bus);
> +}
> +
>  static int realtek_smi_probe(struct platform_device *pdev)
>  {
>  	const struct realtek_smi_variant *var;
> diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
> index fcf465f7f922..6cfa5f2df7ea 100644
> --- a/drivers/net/dsa/realtek-smi-core.h
> +++ b/drivers/net/dsa/realtek-smi-core.h
> @@ -119,6 +119,7 @@ struct realtek_smi_variant {
>  int realtek_smi_write_reg_noack(struct realtek_smi *smi, u32 addr,
>  				u32 data);
>  int realtek_smi_setup_mdio(struct realtek_smi *smi);
> +void realtek_smi_teardown_mdio(struct realtek_smi *smi);
>  
>  /* RTL8366 library helpers */
>  int rtl8366_mc_is_used(struct realtek_smi *smi, int mc_index, int *used);
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index a89093bc6c6a..6537fac7aba4 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -982,6 +982,13 @@ static int rtl8366rb_setup(struct dsa_switch *ds)
>  	return 0;
>  }
>  
> +static void rtl8366rb_teardown(struct dsa_switch *ds)
> +{
> +	struct realtek_smi *smi = ds->priv;
> +
> +	realtek_smi_teardown_mdio(smi);
> +}
> +

Objection: dsa_switch_teardown has:

	if (ds->slave_mii_bus && ds->ops->phy_read)
		mdiobus_unregister(ds->slave_mii_bus);

The realtek_smi_setup_mdio function does:

	smi->ds->slave_mii_bus = smi->slave_mii_bus;

so I would expect that this would result in a double unregister on some
systems.

I haven't went through your new driver, but I wonder whether you have
the phy_read and phy_write methods implemented? Maybe that is the
difference?

>  static enum dsa_tag_protocol rtl8366_get_tag_protocol(struct dsa_switch *ds,
>  						      int port,
>  						      enum dsa_tag_protocol mp)
> @@ -1505,6 +1512,7 @@ static int rtl8366rb_detect(struct realtek_smi *smi)
>  static const struct dsa_switch_ops rtl8366rb_switch_ops = {
>  	.get_tag_protocol = rtl8366_get_tag_protocol,
>  	.setup = rtl8366rb_setup,
> +	.teardown = rtl8366rb_teardown,
>  	.phylink_mac_link_up = rtl8366rb_mac_link_up,
>  	.phylink_mac_link_down = rtl8366rb_mac_link_down,
>  	.get_strings = rtl8366_get_strings,
> -- 
> 2.32.0
> 
