Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37925797DF
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 12:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbiGSKs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 06:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbiGSKs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 06:48:56 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2839402C5;
        Tue, 19 Jul 2022 03:48:53 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ss3so26360438ejc.11;
        Tue, 19 Jul 2022 03:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/n66qJBu+Ju2yJb4zfXK4jrNHmEkqlKKp1R/SkPg820=;
        b=jpvjsiO10fwp6VJsKFRNeHF2bt6s+F1Y7vB7fbTizulu+T+/lYv6NSpDge+kihY4tO
         l6uvc2QG4b38vObAbPo+3ZxBgZnffgyzPFJAYev6AVyKcbJ+sNm3B2lc+oZ9HYfD6qXr
         EeKaL1ADjRYDfcViOYk8oCNmcI4/0jQ3LrDqivlvh8JBgjzOlA1ie8wXL14rt/qPsuvu
         cPQkTdkYAYVP50F6volYQgABZ3i34OQi+sF05sr5otpfGE9Zgmk8Jq/M2kFAOAPa0RvZ
         HGzJRTbPGN44v6A/QA5RPxk5R5b9SsAPXkl+YLRm9eOJSNXBQY03mfuRmYXD2elkWf1x
         4mPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/n66qJBu+Ju2yJb4zfXK4jrNHmEkqlKKp1R/SkPg820=;
        b=i95L1JqwiUrQZuD5je+Fgs48kXphV6/kET1rYPX1W+8REBTh4LhVUsja3/OZoWjFvd
         /jIQBYSKeW9Ru5IxAB+3Utqt93rAy2YNKd+FLXaezV1UCrq/z+MzenLqf7YIAgjoylJ9
         j3hZUuv9FfT77+MI+8W6c3l2R/gTwGdT7VQQBbH5sizm4yco6HNp594ZFx9C2XR2KAFY
         BRIzy1AY1bMxIgL3fEfaXON7D23GHmkpd7vO5RDyPPEiAfZukBGqWYLch2kf4zm0ukCv
         +61XT/WDyDgyzY2m4IDpg2Y1cKxn+XFeAai9gjfdRro3aMhJltWgKH22HHtrPdz7E1Cs
         Atjg==
X-Gm-Message-State: AJIora+5hpsHNbs6uaUiwqvwL9kyNy5LIpwl1aVpPhDhbZaoXl3wrqIr
        1lHWoG7B+neoZfvFVuvXpSg=
X-Google-Smtp-Source: AGRyM1vuMRYpejzmtWfzPX/SOmzdrBlFMr8YRDnI4VxGC2GCSE+I/GCGjI7IM/iAW8bXroW2A7AFWw==
X-Received: by 2002:a17:907:7617:b0:72b:49fe:fdf7 with SMTP id jx23-20020a170907761700b0072b49fefdf7mr31342921ejc.25.1658227732193;
        Tue, 19 Jul 2022 03:48:52 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id kz20-20020a17090777d400b00704fa2748ffsm6636829ejc.99.2022.07.19.03.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 03:48:51 -0700 (PDT)
Date:   Tue, 19 Jul 2022 13:48:49 +0300
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
Subject: Re: [RFC Patch net-next 03/10] net: dsa: microchip: add common
 100/10Mbps selection function
Message-ID: <20220719104849.r2ko2oi6wyfb6d5i@skbuf>
References: <20220712160308.13253-1-arun.ramadoss@microchip.com>
 <20220712160308.13253-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712160308.13253-4-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 09:33:01PM +0530, Arun Ramadoss wrote:
> This patch adds the function for configuring the 100/10Mbps speed
> selection for the ksz switches. KSZ8795 switch uses Global control 4
> register 0x06 bit 4 for choosing 100/10Mpbs. Other switches uses xMII
> control 1 0xN300 for it.
> For KSZ8795, if the bit is set then 10Mbps is chosen and if bit is
> clear then 100Mbps chosen. For all other switches it is other way
> around, if the bit is set then 100Mbps is chosen.
> So, this patch add the generic function for ksz switch to select the
> 100/10Mbps speed selection. While configuring, first it disables the
> gigabit functionality and then configure the respective speed.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz9477_reg.h  |  1 -
>  drivers/net/dsa/microchip/ksz_common.c   | 29 ++++++++++++++++++++++++
>  drivers/net/dsa/microchip/ksz_common.h   |  6 +++++
>  drivers/net/dsa/microchip/lan937x_main.c | 14 ++++--------
>  drivers/net/dsa/microchip/lan937x_reg.h  |  1 -
>  5 files changed, 40 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
> index f23ed4809e47..2649fdf0bae1 100644
> --- a/drivers/net/dsa/microchip/ksz9477_reg.h
> +++ b/drivers/net/dsa/microchip/ksz9477_reg.h
> @@ -1179,7 +1179,6 @@
>  
>  #define PORT_SGMII_SEL			BIT(7)
>  #define PORT_MII_FULL_DUPLEX		BIT(6)
> -#define PORT_MII_100MBIT		BIT(4)
>  #define PORT_GRXC_ENABLE		BIT(0)
>  
>  #define REG_PORT_XMII_CTRL_1		0x0301
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 5ebcd87fc531..f41cd2801210 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -256,6 +256,7 @@ static const u16 ksz8795_regs[] = {
>  	[S_START_CTRL]			= 0x01,
>  	[S_BROADCAST_CTRL]		= 0x06,
>  	[S_MULTICAST_CTRL]		= 0x04,
> +	[P_XMII_CTRL_0]			= 0x06,
>  	[P_XMII_CTRL_1]			= 0x56,
>  };
>  
> @@ -284,6 +285,8 @@ static const u32 ksz8795_masks[] = {
>  static const u8 ksz8795_values[] = {
>  	[P_MII_1GBIT]			= 1,
>  	[P_MII_NOT_1GBIT]		= 0,
> +	[P_MII_100MBIT]			= 0,
> +	[P_MII_10MBIT]			= 1,

Can you namespace P_GMII_1GBIT/P_GMII_NOT_1GBIT separately from
P_MII_100MBIT/P_MII_10MBIT? Otherwise it's not obvious that the first
set writes to regs[P_XMII_CTRL_1] and the other to regs[P_XMII_CTRL_0].

>  };
>  
>  static const u8 ksz8795_shifts[] = {
> @@ -356,6 +359,7 @@ static const u16 ksz9477_regs[] = {
>  	[S_START_CTRL]			= 0x0300,
>  	[S_BROADCAST_CTRL]		= 0x0332,
>  	[S_MULTICAST_CTRL]		= 0x0331,
> +	[P_XMII_CTRL_0]			= 0x0300,
>  	[P_XMII_CTRL_1]			= 0x0301,
>  };
>  
> @@ -371,11 +375,15 @@ static const u8 ksz9477_shifts[] = {
>  static const u8 ksz9477_values[] = {
>  	[P_MII_1GBIT]			= 0,
>  	[P_MII_NOT_1GBIT]		= 1,
> +	[P_MII_100MBIT]			= 1,
> +	[P_MII_10MBIT]			= 0,
>  };
>  
>  static const u8 ksz9893_values[] = {
>  	[P_MII_1GBIT]			= 1,
>  	[P_MII_NOT_1GBIT]		= 0,
> +	[P_MII_100MBIT]			= 1,
> +	[P_MII_10MBIT]			= 0,
>  };
>  
>  static const u32 lan937x_masks[] = {
> @@ -1418,6 +1426,27 @@ void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit)
>  	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
>  }
>  
> +void ksz_set_100_10mbit(struct ksz_device *dev, int port, int speed)
> +{
> +	const u8 *bitval = dev->info->bitval;
> +	const u16 *regs = dev->info->regs;
> +	u8 data8;
> +
> +	ksz_pread8(dev, port, regs[P_XMII_CTRL_0], &data8);
> +
> +	data8 &= ~P_MII_100MBIT_M;
> +
> +	ksz_set_gbit(dev, port, false);
> +
> +	if (speed == SPEED_100)
> +		data8 |= FIELD_PREP(P_MII_100MBIT_M, bitval[P_MII_100MBIT]);
> +	else
> +		data8 |= FIELD_PREP(P_MII_100MBIT_M, bitval[P_MII_10MBIT]);
> +
> +	/* Write the updated value */
> +	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
> +}
> +
>  static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
>  				    unsigned int mode,
>  				    phy_interface_t interface,
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index a76dfef6309c..f1fa6feca559 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -172,6 +172,7 @@ enum ksz_regs {
>  	S_START_CTRL,
>  	S_BROADCAST_CTRL,
>  	S_MULTICAST_CTRL,
> +	P_XMII_CTRL_0,
>  	P_XMII_CTRL_1,
>  };
>  
> @@ -215,6 +216,8 @@ enum ksz_shifts {
>  enum ksz_values {
>  	P_MII_1GBIT,
>  	P_MII_NOT_1GBIT,
> +	P_MII_100MBIT,
> +	P_MII_10MBIT,
>  };
>  
>  struct alu_struct {
> @@ -304,6 +307,7 @@ void ksz_r_mib_stats64(struct ksz_device *dev, int port);
>  void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
>  bool ksz_get_gbit(struct ksz_device *dev, int port);
>  void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit);
> +void ksz_set_100_10mbit(struct ksz_device *dev, int port, int speed);
>  extern const struct ksz_chip_data ksz_switch_chips[];
>  
>  /* Common register access functions */
> @@ -468,6 +472,8 @@ static inline int is_lan937x(struct ksz_device *dev)
>  #define SW_START			0x01
>  
>  /* xMII configuration */
> +#define P_MII_100MBIT_M			BIT(4)
> +
>  #define P_MII_1GBIT_M			BIT(6)
>  
>  /* Regmap tables generation */
> diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
> index efca96b02e15..37f63110e5bb 100644
> --- a/drivers/net/dsa/microchip/lan937x_main.c
> +++ b/drivers/net/dsa/microchip/lan937x_main.c
> @@ -346,21 +346,18 @@ static void lan937x_config_interface(struct ksz_device *dev, int port,
>  				     int speed, int duplex,
>  				     bool tx_pause, bool rx_pause)
>  {
> -	u8 xmii_ctrl0, xmii_ctrl1;
> +	u8 xmii_ctrl0;
>  
>  	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_0, &xmii_ctrl0);
> -	ksz_pread8(dev, port, REG_PORT_XMII_CTRL_1, &xmii_ctrl1);
>  
> -	xmii_ctrl0 &= ~(PORT_MII_100MBIT | PORT_MII_FULL_DUPLEX |
> -			PORT_MII_TX_FLOW_CTRL | PORT_MII_RX_FLOW_CTRL);
> +	xmii_ctrl0 &= ~(PORT_MII_FULL_DUPLEX | PORT_MII_TX_FLOW_CTRL |
> +			PORT_MII_RX_FLOW_CTRL);
>  
>  	if (speed == SPEED_1000)
>  		ksz_set_gbit(dev, port, true);
> -	else
> -		ksz_set_gbit(dev, port, false);
>  
> -	if (speed == SPEED_100)
> -		xmii_ctrl0 |= PORT_MII_100MBIT;
> +	if (speed == SPEED_100 || speed == SPEED_10)
> +		ksz_set_100_10mbit(dev, port, speed);

Why don't you create a single ksz_port_set_xmii_speed() entry point, and
this decides whether to call ksz_set_gbit() with true or false depending
on whether the speed was 1000, and ksz_set_100_10mbit() as appropriate?

>  
>  	if (duplex)
>  		xmii_ctrl0 |= PORT_MII_FULL_DUPLEX;
> @@ -372,7 +369,6 @@ static void lan937x_config_interface(struct ksz_device *dev, int port,
>  		xmii_ctrl0 |= PORT_MII_RX_FLOW_CTRL;
>  
>  	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_0, xmii_ctrl0);
> -	ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, xmii_ctrl1);

Will these remaining ksz_pwrite8 calls to REG_PORT_XMII_CTRL_0 not
overwrite what ksz_set_gbit() is doing?

>  }
>  
>  void lan937x_phylink_get_caps(struct ksz_device *dev, int port,
> diff --git a/drivers/net/dsa/microchip/lan937x_reg.h b/drivers/net/dsa/microchip/lan937x_reg.h
> index 747295d34411..b9364f6a4f8f 100644
> --- a/drivers/net/dsa/microchip/lan937x_reg.h
> +++ b/drivers/net/dsa/microchip/lan937x_reg.h
> @@ -135,7 +135,6 @@
>  #define PORT_SGMII_SEL			BIT(7)
>  #define PORT_MII_FULL_DUPLEX		BIT(6)
>  #define PORT_MII_TX_FLOW_CTRL		BIT(5)
> -#define PORT_MII_100MBIT		BIT(4)
>  #define PORT_MII_RX_FLOW_CTRL		BIT(3)
>  #define PORT_GRXC_ENABLE		BIT(0)
>  
> -- 
> 2.36.1
> 
