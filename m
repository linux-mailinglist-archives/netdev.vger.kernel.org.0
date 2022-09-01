Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834255A9BD4
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 17:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbiIAPiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 11:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiIAPiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 11:38:14 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7887AC34;
        Thu,  1 Sep 2022 08:38:10 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5B4136000C;
        Thu,  1 Sep 2022 15:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662046689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o0DY5K2tOv8e0L2U0j2bDRtdMUYfu9YOVYg6PMh7/YM=;
        b=HR+WbvK59Zo16aCJfnTS4MAgS6YyKOdg5H7R5CHTmrWCJlbegHj25cxRfDpzu5CD/L0C/E
        IkZ1UrSDrDViRtDjnOLxHX02TJ4LgKl8sEp2pbJ+DPWh7LFTpLjoU1KCI02ijvXGRGSfnX
        QxxiT/hpn7cnWI8pNRNn2Ozw5djDHZfrSOPfZU/E8VlB/srUIfNicdKWrPy7qBN+rYEb52
        Ke/411iZfoDLzAxYufTmEEnou8RITgQhHFm6kSfqUeVQJmjy6fafYO/fiaijH+KMkc327/
        SuDpezv9RJps58PJCaogJ/VMcwbX+763jnc+/e7sphfb0yx0mPz/3YPHx2L7TQ==
Date:   Thu, 1 Sep 2022 17:38:07 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux@armlinux.org.uk>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: lan966x: Extend lan966x with RGMII
 support
Message-ID: <20220901173807.79c2e996@pc-10.home>
In-Reply-To: <20220901122346.245786-1-horatiu.vultur@microchip.com>
References: <20220901122346.245786-1-horatiu.vultur@microchip.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Horatiu,

On Thu, 1 Sep 2022 14:23:46 +0200
Horatiu Vultur <horatiu.vultur@microchip.com> wrote:

> Extend lan966x with RGMII support. The MAC supports all RGMII_* modes.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c    | 8 ++++++++
>  drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c | 3 +++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c index
> 1d6e3b641b2e..e2d250ed976b 100644 ---
> a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c +++
> b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c @@ -772,6
> +772,14 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32
> p, __set_bit(PHY_INTERFACE_MODE_MII,
>  		  port->phylink_config.supported_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_RGMII,
> +		  port->phylink_config.supported_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_RGMII_ID,
> +		  port->phylink_config.supported_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_RGMII_RXID,
> +		  port->phylink_config.supported_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_RGMII_TXID,
> +		  port->phylink_config.supported_interfaces);

Instead of defining each individual variant, you can use :

	phy_interface_set_rgmii(port->phylink_config.supported_interfaces);

>  	__set_bit(PHY_INTERFACE_MODE_GMII,
>  		  port->phylink_config.supported_interfaces);
>  	__set_bit(PHY_INTERFACE_MODE_SGMII,
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
> b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c index
> 38a7e95d69b4..fb6aee509656 100644 ---
> a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c +++
> b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c @@ -59,6
> +59,9 @@ static void lan966x_phylink_mac_link_up(struct
> phylink_config *config, port_config->pause |= tx_pause ? MLO_PAUSE_TX
> : 0; port_config->pause |= rx_pause ? MLO_PAUSE_RX : 0; 
> +	if (phy_interface_mode_is_rgmii(interface))
> +		phy_set_speed(port->serdes, speed);
> +
>  	lan966x_port_config_up(port);
>  }
>  

Best regards,

Maxime
