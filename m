Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610125797F4
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 12:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbiGSKxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 06:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237164AbiGSKxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 06:53:05 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD5A2714D;
        Tue, 19 Jul 2022 03:53:03 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id m8so5584174edd.9;
        Tue, 19 Jul 2022 03:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RCwtQ+WO02leu9oWS9PPPUJXjwgAtwBAQuSMBG13QCM=;
        b=n4t5D7783Okh4he+5yCQAJdyOxGPWhYdHw3ZyttkmQxjNDgstwrnVemImfjdYT/0Ze
         peC9c6EihkR1hsWUPmZzeZDKobmeeJbS+M44/iysXkdEOU7jpBObXjbCDU3w06QUEM0u
         RE5bdy1tswQC3UGSbuPM7ZmV5HfH7H9aJq0iEcqOpoYPem/ImW2NiSErVuN2D8ghSDeK
         mA6WRFi0HIKpLRW8jwGza/qFy6f5cCx20VdTOp04hgUn1NIpQ4TIo9R/P6V5mH6SGbaO
         oAwGRNkOJ8YYDAJMI55/fuqTxe+zwAk0qQYp9hFGgZXkNW3pE4LGux8hRXpbOzwxILN8
         /MUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RCwtQ+WO02leu9oWS9PPPUJXjwgAtwBAQuSMBG13QCM=;
        b=QkpWvnGLPRjvwKGoO33ofu6fVJJpfPcaGZ5JlI9p61aFjzK70bMfgtjqsyowLBTtfm
         Bp9cwu+g68llyeBCGtlF4wPPXMCmFbol3/0Xd/LJOipDkrbE2SUTNoEKEdJrEAs9nRS6
         V6vfZ/4aSSDbU9uBP2tO4AqLu5xlXsB1DMprH89SPqDlcrvlC+JBhsRHEDHWdFwgS2n7
         RER4yMwE0a7igiwf4Q525Nu95xxC9avxXdZ94HCSq8fBYVvFPTtRbQ3kimMW8ZeoUDDy
         JELwI/aVYyuCIvYivDE9I5Xc1MH9g7enfxIYZurT2vD8unyTKB9j9ErTQztRmaRYV2p2
         RtuA==
X-Gm-Message-State: AJIora/atiD/rOD/2HzOajrM+Y6x7OZoLNFv+iBeimJE9LIe4lWpRl6B
        qtl/FzIcNgrz9mwIDAQpobwMX1OCR8U=
X-Google-Smtp-Source: AGRyM1vcWlHL5O1QumWoJ5e5aSuGTz1RF/ZHn65dG7Xz0FFtIRjTpV+fzKbdOu2r9jho/GEY1dTqvw==
X-Received: by 2002:a05:6402:51cb:b0:43a:e94c:a841 with SMTP id r11-20020a05640251cb00b0043ae94ca841mr43121442edd.212.1658227982232;
        Tue, 19 Jul 2022 03:53:02 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id g23-20020a170906539700b006fef0c7072esm6664658ejo.144.2022.07.19.03.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 03:53:01 -0700 (PDT)
Date:   Tue, 19 Jul 2022 13:52:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC Patch net-next 04/10] net: dsa: microchip: add common
 duplex and flow control function
Message-ID: <20220719105259.h2pbg4jdjhblbkv5@skbuf>
References: <20220712160308.13253-1-arun.ramadoss@microchip.com>
 <20220712160308.13253-1-arun.ramadoss@microchip.com>
 <20220712160308.13253-5-arun.ramadoss@microchip.com>
 <20220712160308.13253-5-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712160308.13253-5-arun.ramadoss@microchip.com>
 <20220712160308.13253-5-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 09:33:02PM +0530, Arun Ramadoss wrote:
> This patch add common function for configuring the Full/Half duplex and
> transmit/receive flow control. KSZ8795 uses the Global control register
> 4 for configuring the duplex and flow control, whereas all other KSZ9477
> based switch uses the xMII Control 0 register.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz9477_reg.h  |  1 -
>  drivers/net/dsa/microchip/ksz_common.c   | 64 ++++++++++++++++++++++++
>  drivers/net/dsa/microchip/ksz_common.h   |  8 +++
>  drivers/net/dsa/microchip/lan937x_main.c | 24 +++------
>  drivers/net/dsa/microchip/lan937x_reg.h  |  3 --
>  5 files changed, 80 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
> index 2649fdf0bae1..6ca859345932 100644
> --- a/drivers/net/dsa/microchip/ksz9477_reg.h
> +++ b/drivers/net/dsa/microchip/ksz9477_reg.h
> @@ -1178,7 +1178,6 @@
>  #define REG_PORT_XMII_CTRL_0		0x0300
>  
>  #define PORT_SGMII_SEL			BIT(7)
> -#define PORT_MII_FULL_DUPLEX		BIT(6)
>  #define PORT_GRXC_ENABLE		BIT(0)
>  
>  #define REG_PORT_XMII_CTRL_1		0x0301
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index f41cd2801210..4ef0ee9a245d 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -280,6 +280,8 @@ static const u32 ksz8795_masks[] = {
>  	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(26, 20),
>  	[DYNAMIC_MAC_TABLE_SRC_PORT]	= GENMASK(26, 24),
>  	[DYNAMIC_MAC_TABLE_TIMESTAMP]	= GENMASK(28, 27),
> +	[P_MII_TX_FLOW_CTRL]		= BIT(5),
> +	[P_MII_RX_FLOW_CTRL]		= BIT(5),

The masks are the same for TX and RX flow control and the writes are to
the same register (regs[P_XMII_CTRL_0]), is this an error?

>  };
>  
>  static const u8 ksz8795_values[] = {
> @@ -287,6 +289,8 @@ static const u8 ksz8795_values[] = {
>  	[P_MII_NOT_1GBIT]		= 0,
>  	[P_MII_100MBIT]			= 0,
>  	[P_MII_10MBIT]			= 1,
> +	[P_MII_FULL_DUPLEX]		= 0,
> +	[P_MII_HALF_DUPLEX]		= 1,
>  };
>  
>  static const u8 ksz8795_shifts[] = {
> @@ -366,6 +370,8 @@ static const u16 ksz9477_regs[] = {
>  static const u32 ksz9477_masks[] = {
>  	[ALU_STAT_WRITE]		= 0,
>  	[ALU_STAT_READ]			= 1,
> +	[P_MII_TX_FLOW_CTRL]		= BIT(5),
> +	[P_MII_RX_FLOW_CTRL]		= BIT(3),
>  };
>  
>  static const u8 ksz9477_shifts[] = {
> @@ -377,6 +383,8 @@ static const u8 ksz9477_values[] = {
>  	[P_MII_NOT_1GBIT]		= 1,
>  	[P_MII_100MBIT]			= 1,
>  	[P_MII_10MBIT]			= 0,
> +	[P_MII_FULL_DUPLEX]		= 1,
> +	[P_MII_HALF_DUPLEX]		= 0,
>  };
>  
>  static const u8 ksz9893_values[] = {
> @@ -384,11 +392,15 @@ static const u8 ksz9893_values[] = {
>  	[P_MII_NOT_1GBIT]		= 0,
>  	[P_MII_100MBIT]			= 1,
>  	[P_MII_10MBIT]			= 0,
> +	[P_MII_FULL_DUPLEX]		= 1,
> +	[P_MII_HALF_DUPLEX]		= 0,
>  };
>  
>  static const u32 lan937x_masks[] = {
>  	[ALU_STAT_WRITE]		= 1,
>  	[ALU_STAT_READ]			= 2,
> +	[P_MII_TX_FLOW_CTRL]		= BIT(5),
> +	[P_MII_RX_FLOW_CTRL]		= BIT(3),
>  };
>  
>  static const u8 lan937x_shifts[] = {
> @@ -1447,6 +1459,58 @@ void ksz_set_100_10mbit(struct ksz_device *dev, int port, int speed)
>  	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
>  }
>  
> +void ksz_set_fullduplex(struct ksz_device *dev, int port, bool val)
> +{
> +	const u8 *bitval = dev->info->bitval;
> +	const u16 *regs = dev->info->regs;
> +	u8 data8;
> +
> +	ksz_pread8(dev, port, regs[P_XMII_CTRL_0], &data8);
> +
> +	data8 &= ~P_MII_DUPLEX_M;
> +
> +	if (val)
> +		data8 |= FIELD_PREP(P_MII_DUPLEX_M,
> +				    bitval[P_MII_FULL_DUPLEX]);
> +	else
> +		data8 |= FIELD_PREP(P_MII_DUPLEX_M,
> +				    bitval[P_MII_HALF_DUPLEX]);
> +
> +	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
> +}
> +
> +void ksz_set_tx_pause(struct ksz_device *dev, int port, bool val)
> +{
> +	const u32 *masks = dev->info->masks;
> +	const u16 *regs = dev->info->regs;
> +	u8 data8;
> +
> +	ksz_pread8(dev, port, regs[P_XMII_CTRL_0], &data8);
> +
> +	if (val)
> +		data8 |= masks[P_MII_TX_FLOW_CTRL];
> +	else
> +		data8 &= ~masks[P_MII_TX_FLOW_CTRL];
> +
> +	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
> +}
> +
> +void ksz_set_rx_pause(struct ksz_device *dev, int port, bool val)
> +{
> +	const u32 *masks = dev->info->masks;
> +	const u16 *regs = dev->info->regs;
> +	u8 data8;
> +
> +	ksz_pread8(dev, port, regs[P_XMII_CTRL_0], &data8);
> +
> +	if (val)
> +		data8 |= masks[P_MII_RX_FLOW_CTRL];
> +	else
> +		data8 &= ~masks[P_MII_RX_FLOW_CTRL];
> +
> +	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
> +}
> +
>  static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
>  				    unsigned int mode,
>  				    phy_interface_t interface,
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index f1fa6feca559..851ee50895a4 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -198,6 +198,8 @@ enum ksz_masks {
>  	DYNAMIC_MAC_TABLE_TIMESTAMP,
>  	ALU_STAT_WRITE,
>  	ALU_STAT_READ,
> +	P_MII_TX_FLOW_CTRL,
> +	P_MII_RX_FLOW_CTRL,
>  };
>  
>  enum ksz_shifts {
> @@ -218,6 +220,8 @@ enum ksz_values {
>  	P_MII_NOT_1GBIT,
>  	P_MII_100MBIT,
>  	P_MII_10MBIT,
> +	P_MII_FULL_DUPLEX,
> +	P_MII_HALF_DUPLEX,
>  };
>  
>  struct alu_struct {
> @@ -308,6 +312,9 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
>  bool ksz_get_gbit(struct ksz_device *dev, int port);
>  void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit);
>  void ksz_set_100_10mbit(struct ksz_device *dev, int port, int speed);
> +void ksz_set_fullduplex(struct ksz_device *dev, int port, bool val);
> +void ksz_set_tx_pause(struct ksz_device *dev, int port, bool val);
> +void ksz_set_rx_pause(struct ksz_device *dev, int port, bool val);
>  extern const struct ksz_chip_data ksz_switch_chips[];
>  
>  /* Common register access functions */
> @@ -472,6 +479,7 @@ static inline int is_lan937x(struct ksz_device *dev)
>  #define SW_START			0x01
>  
>  /* xMII configuration */
> +#define P_MII_DUPLEX_M			BIT(6)
>  #define P_MII_100MBIT_M			BIT(4)
>  
>  #define P_MII_1GBIT_M			BIT(6)
> diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
> index 37f63110e5bb..67b03ab0ede3 100644
> --- a/drivers/net/dsa/microchip/lan937x_main.c
> +++ b/drivers/net/dsa/microchip/lan937x_main.c
> @@ -234,6 +234,8 @@ int lan937x_reset_switch(struct ksz_device *dev)
>  
>  void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
>  {
> +	const u32 *masks = dev->info->masks;
> +	const u16 *regs = dev->info->regs;
>  	struct dsa_switch *ds = dev->ds;
>  	u8 member;
>  
> @@ -254,8 +256,9 @@ void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
>  	lan937x_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_PRIO_ENABLE, true);
>  
>  	if (!dev->info->internal_phy[port])
> -		lan937x_port_cfg(dev, port, REG_PORT_XMII_CTRL_0,
> -				 PORT_MII_TX_FLOW_CTRL | PORT_MII_RX_FLOW_CTRL,
> +		lan937x_port_cfg(dev, port, regs[P_XMII_CTRL_0],
> +				 masks[P_MII_TX_FLOW_CTRL] |
> +				 masks[P_MII_RX_FLOW_CTRL],
>  				 true);
>  
>  	if (cpu_port)
> @@ -346,29 +349,18 @@ static void lan937x_config_interface(struct ksz_device *dev, int port,
>  				     int speed, int duplex,
>  				     bool tx_pause, bool rx_pause)
>  {
> -	u8 xmii_ctrl0;
> -
> -	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_0, &xmii_ctrl0);
> -
> -	xmii_ctrl0 &= ~(PORT_MII_FULL_DUPLEX | PORT_MII_TX_FLOW_CTRL |
> -			PORT_MII_RX_FLOW_CTRL);
> -
>  	if (speed == SPEED_1000)
>  		ksz_set_gbit(dev, port, true);
>  
>  	if (speed == SPEED_100 || speed == SPEED_10)
>  		ksz_set_100_10mbit(dev, port, speed);
>  
> -	if (duplex)
> -		xmii_ctrl0 |= PORT_MII_FULL_DUPLEX;
> +	ksz_set_fullduplex(dev, port, duplex);
>  
> -	if (tx_pause)
> -		xmii_ctrl0 |= PORT_MII_TX_FLOW_CTRL;
> +	ksz_set_tx_pause(dev, port, tx_pause);
>  
> -	if (rx_pause)
> -		xmii_ctrl0 |= PORT_MII_RX_FLOW_CTRL;
> +	ksz_set_rx_pause(dev, port, rx_pause);
>  
> -	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_0, xmii_ctrl0);
>  }
>  
>  void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
> diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
> index b9364f6a4f8f..d5eb6dc3a739 100644
> --- a/drivers/net/dsa/microchip/lan937x_reg.h
> +++ b/drivers/net/dsa/microchip/lan937x_reg.h
> @@ -133,9 +133,6 @@
>  /* 3 - xMII */
>  #define REG_PORT_XMII_CTRL_0		0x0300
>  #define PORT_SGMII_SEL			BIT(7)
> -#define PORT_MII_FULL_DUPLEX		BIT(6)
> -#define PORT_MII_TX_FLOW_CTRL		BIT(5)
> -#define PORT_MII_RX_FLOW_CTRL		BIT(3)
>  #define PORT_GRXC_ENABLE		BIT(0)
>  
>  #define REG_PORT_XMII_CTRL_1		0x0301
> -- 
> 2.36.1
> 

