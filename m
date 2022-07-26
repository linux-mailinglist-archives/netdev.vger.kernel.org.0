Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270C9581133
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 12:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238639AbiGZKd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 06:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbiGZKd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 06:33:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1CCFA2C661
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 03:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658831604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jECiOq0E3ywwe79d1zTfZoKz4jXt6DMQSmkfo1EKKqo=;
        b=U/aNHSAdARjr7E5CEfk8uD/70n0LHGyQwugEGsXSdrPsm0304GINwFZtz+yJt9Ld3jPYMC
        ypA2WdKfwULjYFZX4cHhtOrKzQBznW7CzlftQkPNzPuINy1W3lnz4CUkWkejf4AUOOoZMa
        KrGA3/RlS34i3ryK2mRxbcdq/O1lOyA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-XCtDlUmYOIiHUa5gkuhWxw-1; Tue, 26 Jul 2022 06:33:23 -0400
X-MC-Unique: XCtDlUmYOIiHUa5gkuhWxw-1
Received: by mail-wm1-f72.google.com with SMTP id z20-20020a1c4c14000000b003a3020da654so5219705wmf.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 03:33:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=jECiOq0E3ywwe79d1zTfZoKz4jXt6DMQSmkfo1EKKqo=;
        b=KfPVN6WbJqyi3/0mqehZnOajn5+lxBsZMyXbpKVaig9Ny2ebK9gmfPLqbyqU3sKWOc
         hmZTinVBUHYKH6YXe5KdKqu55ncWNjQY9Mb7NkP6Pg8LRPzI7Zo3DJqI8oSCCv/aIl/D
         e2hteXM64gAiRwLgV/Z7KB6d2OWFi2uem73/SaNVKcLibvCj6o90UgF+G0qJs5TKV2Ca
         JJ3OcEpFEIk1SJ9cUHghvXKEsF/OpNX54fu2p0acEVfB162RzEXxl0n+pxoHBAHZ6gdI
         sdeNWYJQd/xmmONeGyldr1367lA9dBoTxzeFF17P6FSIJA1RihhXfkpiY0XL9FHBJI12
         leHQ==
X-Gm-Message-State: AJIora+WKIcLGrvgbfUTbRqXJTW9tJtQcl6Xzva0gxWBJp3E/dhDX1Ay
        L86syXMGDtouxoLfdwv1vOjVVPjtftmnt2ST5khWhmrI/1Sgy3aJ0HutYLzDj0BubZKWmLbLPMY
        u00VdF/7k97D+10DL
X-Received: by 2002:a05:6000:1541:b0:21d:b298:96be with SMTP id 1-20020a056000154100b0021db29896bemr10132064wry.206.1658831601867;
        Tue, 26 Jul 2022 03:33:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tTQ/OcdsegKe5OGqBkLomcrzDjzWC9phkXjmP0MUcp3Qss3S4w5JJ0BWvgekckWmI9RvVtvw==
X-Received: by 2002:a05:6000:1541:b0:21d:b298:96be with SMTP id 1-20020a056000154100b0021db29896bemr10132031wry.206.1658831601234;
        Tue, 26 Jul 2022 03:33:21 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id r11-20020a0560001b8b00b0021e6baea4ffsm10137380wru.29.2022.07.26.03.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 03:33:20 -0700 (PDT)
Message-ID: <9cdb7fadf35fc7b7c07d3f3f0fc036da9fd81277.camel@redhat.com>
Subject: Re: [PATCH net-next v1 1/2] net: asix: ax88772: migrate to phylink
From:   Paolo Abeni <pabeni@redhat.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Russell King <linux@armlinux.org.uk>
Date:   Tue, 26 Jul 2022 12:33:19 +0200
In-Reply-To: <20220723174711.1539574-1-o.rempel@pengutronix.de>
References: <20220723174711.1539574-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-07-23 at 19:47 +0200, Oleksij Rempel wrote:
> There are some exotic ax88772 based devices which may require
> functionality provide by the phylink framework. For example:
> - US100A20SFP, USB 2.0 auf LWL Converter with SFP Cage
> - AX88772B USB to 100Base-TX Ethernet (with RMII) demo board, where it
>   is possible to switch between internal PHY and external RMII based
>   connection.
> 
> So, convert this driver to phylink as soon as possible.
> 
> Tested with:
> - AX88772A + internal PHY
> - AX88772B + external DP83TD510E T1L PHY
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/usb/Kconfig        |   2 +-
>  drivers/net/usb/asix.h         |   3 +
>  drivers/net/usb/asix_devices.c | 123 ++++++++++++++++++++++++++++-----
>  3 files changed, 110 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
> index e62fc4f2aee0..3d46b5f9287a 100644
> --- a/drivers/net/usb/Kconfig
> +++ b/drivers/net/usb/Kconfig
> @@ -168,7 +168,7 @@ config USB_NET_AX8817X
>  	tristate "ASIX AX88xxx Based USB 2.0 Ethernet Adapters"
>  	depends on USB_USBNET
>  	select CRC32
> -	select PHYLIB
> +	select PHYLINK
>  	select AX88796B_PHY
>  	imply NET_SELFTESTS
>  	default y
> diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
> index 21c1ca275cc4..74162190bccc 100644
> --- a/drivers/net/usb/asix.h
> +++ b/drivers/net/usb/asix.h
> @@ -27,6 +27,7 @@
>  #include <linux/if_vlan.h>
>  #include <linux/phy.h>
>  #include <net/selftests.h>
> +#include <linux/phylink.h>
>  
>  #define DRIVER_VERSION "22-Dec-2011"
>  #define DRIVER_NAME "asix"
> @@ -185,6 +186,8 @@ struct asix_common_private {
>  	struct mii_bus *mdio;
>  	struct phy_device *phydev;
>  	struct phy_device *phydev_int;
> +	struct phylink *phylink;
> +	struct phylink_config phylink_config;
>  	u16 phy_addr;
>  	bool embd_phy;
>  	u8 chipcode;
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 5b5eb630c4b7..3f93bc46a7eb 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -327,6 +327,12 @@ static int ax88772_reset(struct usbnet *dev)
>  	struct asix_common_private *priv = dev->driver_priv;
>  	int ret;
>  
> +	ret = phylink_connect_phy(priv->phylink, priv->phydev);
> +	if (ret) {
> +		netdev_err(dev->net, "Could not connect PHY\n");
> +		return ret;
> +	}

Don't you need to additionally call phylink_disconnect_phy() in later
error paths? why?

> +
>  	/* Rewrite MAC address */
>  	ether_addr_copy(data->mac_addr, dev->net->dev_addr);
>  	ret = asix_write_cmd(dev, AX_CMD_WRITE_NODE_ID, 0, 0,
> @@ -343,7 +349,7 @@ static int ax88772_reset(struct usbnet *dev)
>  	if (ret < 0)
>  		goto out;
>  
> -	phy_start(priv->phydev);
> +	phylink_start(priv->phylink);
>  
>  	return 0;
>  
> @@ -590,8 +596,11 @@ static void ax88772_suspend(struct usbnet *dev)
>  	struct asix_common_private *priv = dev->driver_priv;
>  	u16 medium;
>  
> -	if (netif_running(dev->net))
> -		phy_stop(priv->phydev);
> +	if (netif_running(dev->net)) {
> +		rtnl_lock();
> +		phylink_suspend(priv->phylink, false);
> +		rtnl_unlock();
> +	}
>  
>  	/* Stop MAC operation */
>  	medium = asix_read_medium_status(dev, 1);
> @@ -622,8 +631,11 @@ static void ax88772_resume(struct usbnet *dev)
>  		if (!priv->reset(dev, 1))
>  			break;
>  
> -	if (netif_running(dev->net))
> -		phy_start(priv->phydev);
> +	if (netif_running(dev->net)) {
> +		rtnl_lock();
> +		phylink_resume(priv->phylink);
> +		rtnl_unlock();
> +	}
>  }
>  
>  static int asix_resume(struct usb_interface *intf)
> @@ -659,7 +671,6 @@ static int ax88772_init_mdio(struct usbnet *dev)
>  static int ax88772_init_phy(struct usbnet *dev)
>  {
>  	struct asix_common_private *priv = dev->driver_priv;
> -	int ret;
>  
>  	priv->phydev = mdiobus_get_phy(priv->mdio, priv->phy_addr);
>  	if (!priv->phydev) {
> @@ -667,13 +678,6 @@ static int ax88772_init_phy(struct usbnet *dev)
>  		return -ENODEV;
>  	}
>  
> -	ret = phy_connect_direct(dev->net, priv->phydev, &asix_adjust_link,
> -				 PHY_INTERFACE_MODE_INTERNAL);
> -	if (ret) {
> -		netdev_err(dev->net, "Could not connect PHY\n");
> -		return ret;
> -	}
> -
>  	phy_suspend(priv->phydev);
>  	priv->phydev->mac_managed_pm = 1;
>  
> @@ -698,6 +702,89 @@ static int ax88772_init_phy(struct usbnet *dev)
>  	return 0;
>  }
>  
> +static void ax88772_mac_config(struct phylink_config *config, unsigned int mode,
> +			      const struct phylink_link_state *state)
> +{
> +	/* Nothing to do */
> +}
> +
> +static void ax88772_mac_link_down(struct phylink_config *config,
> +				 unsigned int mode, phy_interface_t interface)
> +{
> +	struct usbnet *dev = netdev_priv(to_net_dev(config->dev));
> +
> +	asix_write_medium_mode(dev, 0, 0);
> +	usbnet_link_change(dev, false, false);
> +}
> +
> +static void ax88772_mac_link_up(struct phylink_config *config,
> +			       struct phy_device *phy,
> +			       unsigned int mode, phy_interface_t interface,
> +			       int speed, int duplex,
> +			       bool tx_pause, bool rx_pause)
> +{
> +	struct usbnet *dev = netdev_priv(to_net_dev(config->dev));
> +	u16 m = AX_MEDIUM_AC | AX_MEDIUM_RE;
> +
> +	m |= duplex ? AX_MEDIUM_FD : 0;
> +
> +	switch (speed) {
> +	case SPEED_100:
> +		m |= AX_MEDIUM_PS;
> +		break;
> +	case SPEED_10:
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	if (tx_pause)
> +		m |= AX_MEDIUM_TFC;
> +
> +	if (rx_pause)
> +		m |= AX_MEDIUM_RFC;
> +
> +	asix_write_medium_mode(dev, m, 0);
> +	usbnet_link_change(dev, true, false);
> +}
> +
> +static const struct phylink_mac_ops ax88772_phylink_mac_ops = {
> +	.validate = phylink_generic_validate,
> +	.mac_config = ax88772_mac_config,
> +	.mac_link_down = ax88772_mac_link_down,
> +	.mac_link_up = ax88772_mac_link_up,
> +};
> +
> +static int ax88772_phylink_setup(struct usbnet *dev)
> +{
> +	struct asix_common_private *priv = dev->driver_priv;
> +	phy_interface_t phy_if_mode;
> +	struct phylink *phylink;
> +
> +	priv->phylink_config.dev = &dev->net->dev;
> +	priv->phylink_config.type = PHYLINK_NETDEV;
> +	priv->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
> +		MAC_10 | MAC_100;
> +
> +	__set_bit(PHY_INTERFACE_MODE_INTERNAL,
> +		  priv->phylink_config.supported_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_RMII,
> +		  priv->phylink_config.supported_interfaces);
> +
> +	if (priv->embd_phy)
> +		phy_if_mode = PHY_INTERFACE_MODE_INTERNAL;
> +	else
> +		phy_if_mode = PHY_INTERFACE_MODE_RMII;
> +
> +	phylink = phylink_create(&priv->phylink_config, dev->net->dev.fwnode,
> +				 phy_if_mode, &ax88772_phylink_mac_ops);
> +	if (IS_ERR(phylink))
> +		return PTR_ERR(phylink);
> +
> +	priv->phylink = phylink;

Who will call phylink_destroy() on priv->phylink? It looks like you are
leaking it ?!?

Thanks!

Paolo

