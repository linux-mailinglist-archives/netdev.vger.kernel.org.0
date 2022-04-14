Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0907C50144C
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 17:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242337AbiDNOZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 10:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348015AbiDNORh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 10:17:37 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9624E15726;
        Thu, 14 Apr 2022 07:08:26 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id c6so6493093edn.8;
        Thu, 14 Apr 2022 07:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VKAGTVudGRy4HcB9l5vebptdpongU9LNNg0Y13bPPlM=;
        b=RMXEv7drgQD67+ERI0zrhQwGBwfCGMbg/GYLE4M5vy18ic1oiIEIcA6qntRehKbvXk
         VFXV+SuHtujfO1WvK8niBLF+0LDE+4oUhM/Bc7G4X6e03bIRoT92YXk1FAACi2V8ZL78
         TCGjqXkuY7GibuktNFIwK/7VJw1qNNI2OYk+L0ssaZmZ5jCLsvR0m6asLGyKeNaemysy
         pxLLvs1ixnuPOKKAR6lJ9Zp9WaOHq9Q+0PInQCpa0/BBHmIhneri2ylbhjwYSJ5Tk92Y
         BGRqHl4/RB4tVevJBpd1zRJDslFhbB/pCHsNJG210L8aeUCwEPJN+5NdUP8EtJz4bYo1
         /3wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VKAGTVudGRy4HcB9l5vebptdpongU9LNNg0Y13bPPlM=;
        b=4NHjcMZaHseX8/sHrMqDGHIIRKEi/LFKjL7/6v/7iJwCL38/ocfSe8iZdVf7Y5wjVL
         tqs/+vxVBzZtYYHP4GhO0nuy4Ob7uU/Yp61hZREl/F/U8ZTzc+BCxEvP2dp7O+e8N7FB
         3HmsBVUBNNzSykdcQtgfXOvZoivEkm2rByvr97Tq2WUfzX5n1/P7jxTL05Sd6MybK1I2
         MfRSbFdrTgiVbFOd7JsMnMRGjkNgn5LhpcplMnTY/J2WfGNefa80x0+p1xSzhpvRhDRm
         HIzzwkta3MR0FwkoQeD/iSijFYz+Z9riz/xAETM5MBokgsboNhsE7cnU5s1JkSOEc89i
         usGA==
X-Gm-Message-State: AOAM533udyzMvRelsaeNgXW2K7HogHLnX/DbAW5kKDlUhAjwsQJGlj85
        q7oQaPt3BDdCblHQjlh75HU=
X-Google-Smtp-Source: ABdhPJzS9F5vzt8xwzgHrX0bMFynD2Y0gnSNfZhO7BVlIgo/YrIbRaK/dqiuLCIq1FzR8cZnLGwVWw==
X-Received: by 2002:a50:fa90:0:b0:41d:8c32:838 with SMTP id w16-20020a50fa90000000b0041d8c320838mr3231941edr.140.1649945304913;
        Thu, 14 Apr 2022 07:08:24 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id gl2-20020a170906e0c200b006a767d52373sm647576ejb.182.2022.04.14.07.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 07:08:24 -0700 (PDT)
Date:   Thu, 14 Apr 2022 17:08:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 3/4] drivers: net: dsa: qca8k: rework and
 simplify mdiobus logic
Message-ID: <20220414140823.btcvlebraynaw6wr@skbuf>
References: <20220412173019.4189-1-ansuelsmth@gmail.com>
 <20220412173019.4189-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173019.4189-4-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 07:30:18PM +0200, Ansuel Smith wrote:
> In an attempt to reduce qca8k_priv space, rework and simplify mdiobus
> logic.
> We now declare a mdiobus instead of relying on DSA phy_read/write even
> if a mdio node is not present. This is all to make the qca8k ops static
> and not switch specific. With a legacy implementation where port doesn't
> have a phy map declared in the dts with a mdio node, we declare a
> 'qca8k-legacy' mdiobus. The conversion logic is used as legacy read and
> write ops are used instead of the internal one.
> While at it also improve the bus id to support multiple switch.
> Also drop the legacy_phy_port_mapping as we now declare mdiobus with ops
> that already address the workaround.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 101 ++++++++++++++--------------------------
>  drivers/net/dsa/qca8k.h |   1 -
>  2 files changed, 34 insertions(+), 68 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 5f447b586cfa..9c4c5af79f9a 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1287,87 +1287,71 @@ qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
>  	if (ret >= 0)
>  		return ret;
>  
> -	return qca8k_mdio_read(priv, phy, regnum);
> +	ret = qca8k_mdio_read(priv, phy, regnum);
> +
> +	if (ret < 0)
> +		return 0xffff;
> +
> +	return ret;

Unrelated change?

>  }
>  
>  static int
> -qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
> +qca8k_legacy_mdio_write(struct mii_bus *slave_bus, int port, int regnum, u16 data)
>  {
> -	struct qca8k_priv *priv = ds->priv;
> -	int ret;
> -
> -	/* Check if the legacy mapping should be used and the
> -	 * port is not correctly mapped to the right PHY in the
> -	 * devicetree
> -	 */
> -	if (priv->legacy_phy_port_mapping)
> -		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
> -
> -	/* Use mdio Ethernet when available, fallback to legacy one on error */
> -	ret = qca8k_phy_eth_command(priv, false, port, regnum, 0);
> -	if (!ret)
> -		return ret;
> +	port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
>  
> -	return qca8k_mdio_write(priv, port, regnum, data);
> +	return qca8k_internal_mdio_write(slave_bus, port, regnum, data);
>  }
>  
>  static int
> -qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
> +qca8k_legacy_mdio_read(struct mii_bus *slave_bus, int port, int regnum)
>  {
> -	struct qca8k_priv *priv = ds->priv;
> -	int ret;
> -
> -	/* Check if the legacy mapping should be used and the
> -	 * port is not correctly mapped to the right PHY in the
> -	 * devicetree
> -	 */
> -	if (priv->legacy_phy_port_mapping)
> -		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
> -
> -	/* Use mdio Ethernet when available, fallback to legacy one on error */
> -	ret = qca8k_phy_eth_command(priv, true, port, regnum, 0);
> -	if (ret >= 0)
> -		return ret;
> -
> -	ret = qca8k_mdio_read(priv, port, regnum);
> -
> -	if (ret < 0)
> -		return 0xffff;
> +	port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
>  
> -	return ret;
> +	return qca8k_internal_mdio_read(slave_bus, port, regnum);
>  }
>  
>  static int
> -qca8k_mdio_register(struct qca8k_priv *priv, struct device_node *mdio)
> +qca8k_mdio_register(struct qca8k_priv *priv)
>  {
>  	struct dsa_switch *ds = priv->ds;
> +	struct device_node *mdio;
>  	struct mii_bus *bus;
>  
>  	bus = devm_mdiobus_alloc(ds->dev);
> -
>  	if (!bus)
>  		return -ENOMEM;
>  
>  	bus->priv = (void *)priv;
> -	bus->name = "qca8k slave mii";
> -	bus->read = qca8k_internal_mdio_read;
> -	bus->write = qca8k_internal_mdio_write;
> -	snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d",
> -		 ds->index);
> -
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d.%d",
> +		 ds->dst->index, ds->index);

So the bus->id here is the same, regardless if this is the OF-based MDIO
bus or the legacy slave MII bus. dsa_slave_mii_bus_init() used to set
the bus->id to "dsa-%d.%d", ds->dst->index, ds->index), so you're doing
this to kind of preserve the structure (although not completely).

In any case, this is an unrelated change, because not only are you
modifying the bus->id of the legacy MII bus, but also the bus->id of the
OF-based one. I would rather have it be a separate patch just for that.

Does the MDIO bus id constitute unbreakable ABI? I hope not, otherwise
as you say, we couldn't support multiple switches.

>  	bus->parent = ds->dev;
>  	bus->phy_mask = ~ds->phys_mii_mask;
> -
>  	ds->slave_mii_bus = bus;
>  
> -	return devm_of_mdiobus_register(priv->dev, bus, mdio);
> +	/* Check if the devicetree declare the port:phy mapping */
> +	mdio = of_get_child_by_name(priv->dev->of_node, "mdio");
> +	if (of_device_is_available(mdio)) {
> +		bus->name = "qca8k slave mii";
> +		bus->read = qca8k_internal_mdio_read;
> +		bus->write = qca8k_internal_mdio_write;
> +		return devm_of_mdiobus_register(priv->dev, bus, mdio);
> +	}
> +
> +	/* If a mapping can't be found the legacy mapping is used,
> +	 * using the qca8k_port_to_phy function
> +	 */
> +	bus->name = "qca8k-legacy slave mii";
> +	bus->read = qca8k_legacy_mdio_read;
> +	bus->write = qca8k_legacy_mdio_write;
> +	return devm_mdiobus_register(priv->dev, bus);
>  }
>  
>  static int
>  qca8k_setup_mdio_bus(struct qca8k_priv *priv)
>  {
>  	u32 internal_mdio_mask = 0, external_mdio_mask = 0, reg;
> -	struct device_node *ports, *port, *mdio;
> +	struct device_node *ports, *port;
>  	phy_interface_t mode;
>  	int err;
>  
> @@ -1429,24 +1413,7 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
>  					 QCA8K_MDIO_MASTER_EN);
>  	}
>  
> -	/* Check if the devicetree declare the port:phy mapping */
> -	mdio = of_get_child_by_name(priv->dev->of_node, "mdio");
> -	if (of_device_is_available(mdio)) {
> -		err = qca8k_mdio_register(priv, mdio);
> -		if (err)
> -			of_node_put(mdio);
> -
> -		return err;
> -	}
> -
> -	/* If a mapping can't be found the legacy mapping is used,
> -	 * using the qca8k_port_to_phy function
> -	 */
> -	priv->legacy_phy_port_mapping = true;
> -	priv->ops.phy_read = qca8k_phy_read;
> -	priv->ops.phy_write = qca8k_phy_write;
> -
> -	return 0;
> +	return qca8k_mdio_register(priv);
>  }
>  
>  static int
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index 12d8d090298b..8bbe36f135b5 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -388,7 +388,6 @@ struct qca8k_priv {
>  	 * Bit 1: port enabled. Bit 0: port disabled.
>  	 */
>  	u8 port_enabled_map;
> -	bool legacy_phy_port_mapping;
>  	struct qca8k_ports_config ports_config;
>  	struct regmap *regmap;
>  	struct mii_bus *bus;
> -- 
> 2.34.1
> 

