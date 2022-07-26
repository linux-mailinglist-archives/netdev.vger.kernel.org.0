Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4110A581179
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 12:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238831AbiGZKu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 06:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238835AbiGZKuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 06:50:51 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6452B636;
        Tue, 26 Jul 2022 03:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=o737jh1CI0Sq/bokMsq5W44ePCie6sUIvtAOxalVPhY=; b=MQs2WsZn0k/8bfuNNUly5awXbH
        QL89GxFjuFrI24dt1udvaPMNELu958ETNHqFKXzlPAgWhXq5PEojKM4qFSmahNN4w/fMeH692OlIR
        qlpI4VkwLL+b4I6mlT27oby6i2FspL6rdE+85mgobGTxqUQjIQ51d7nwD1RR8BhzozPDa+K1QegrH
        8XWw/GMg1CXUR/o4XvadkEwrTnAKAOC+uEYaRJXale9QrAuf2WloRberz7B45fCKv7VrVGCmwaijq
        GsZA6GyLJBAZwOrvsD9HpF8g4mkUXFdaGfM0Yu2R4PnfUfBJrofSMwEnS/lixORDSK42ZGzJgD6vX
        WXROq0+w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33570)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oGI96-00042O-5Z; Tue, 26 Jul 2022 11:50:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oGI93-00019s-D2; Tue, 26 Jul 2022 11:50:33 +0100
Date:   Tue, 26 Jul 2022 11:50:33 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next v1 1/2] net: asix: ax88772: migrate to phylink
Message-ID: <Yt/G+QuQPbafbaHT@shell.armlinux.org.uk>
References: <20220723174711.1539574-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723174711.1539574-1-o.rempel@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 23, 2022 at 07:47:10PM +0200, Oleksij Rempel wrote:
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

Sorry, I missed this.

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
> +

As Paolo points out, you need to clean this up with a call to
phylink_disconnect_phy() in the error paths in this function. Sorting
that out doesn't look like it would be sufficient, however. Looking at
usbnet_open(), there are a bunch of paths after ->reset() has been
called, where failures can occur and the chip specific driver doesn't
get notified to clean up, so in that case, the PHY would remain
attached.

So, I would say that the usbnet code is not structured to allow a call
to bind the PHY at this point.

However, this is also a functional change to the code - moving the call
to connect the PHY to (presumably) the .ndo_open() stage of the network
device lifetime, rather than the probe stage. In other words, this now
happens when the device is actually opened rather than when the device
is being bound to the driver.

That should have at least been described in the commit description, but
much better would be a separate patch to make that change. However, as
I say above, I think the usbnet code would need additional work to
permit this.

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

I'd much rather this was:

	m |= duplex == DUPLEX_FULL ? AX_MEDIUM_FD : 0;

which is much clearer, and doesn't result in other values of duplex
resulting in full duplex. If you do want that behaviour (because the
original code used to), then please use:

	m |= duplex != DUPLEX_HALF ? AX_MEDIUM_FD : 0;

Either of these make the intention here explicit.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
