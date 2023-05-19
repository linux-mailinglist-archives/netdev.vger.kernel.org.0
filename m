Return-Path: <netdev+bounces-4039-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FD3D70A365
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 01:36:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C18BC281A7A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 23:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11706ABB;
	Fri, 19 May 2023 23:36:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCBE3D3BA
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 23:36:19 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1AFEA;
	Fri, 19 May 2023 16:36:17 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-969f90d71d4so588707966b.3;
        Fri, 19 May 2023 16:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684539376; x=1687131376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1o4S7TLQJdG0vUVlIlsfVbzWeohoViWnpGpu2q/BU0E=;
        b=NBv9pLhYFf383wZEJBorDj2D+d6JCSiuQ9A6wql5ijUYffNyf5bG8D4GxgBwuJ8fnh
         APnBhZEetEOOBRCO31yh+noi3/r/9Zip0IDA8Skx+PFjr0R5imxxltqt7VNekH+6RuoH
         A7PG04j7mBgCnGucSMkD2TqPyXmJMIhAOjmyYPtw5v9pZr7an5C8ZckuvgY05RdQ9mKn
         8LT3Oo3WMPjeaRbJLL8ATXETnO9g41qOf2Goc5GJw8ULiFvi1us0VhMsDGg1nAxjMvyK
         kjQ/mibCqdgExB90i8clIxpiewa5QzBLdsnR1U/FmbdY4SvgA/+zsjNo+ZEozi22m0LM
         cGMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684539376; x=1687131376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1o4S7TLQJdG0vUVlIlsfVbzWeohoViWnpGpu2q/BU0E=;
        b=HUWzC8QPyqFsNLoNVZcK9dseQUZR73ox93ciQYxpd0p2SFE/DUtyj9pGPNfM2Wv2R7
         190KyKGdoN8R0rhO2zHq52hQJ3r64/JB0joCg9TbCEoSLrjO+7puIIEwyJ6MJ1PCw12F
         wKR5a7TsU6bBpmKiIyUYKYTHrqdFTNt+5tLPC32XO8CRJizMczCkJGuMdGHMG1ET0F62
         YhEdC8VwN68VsB+/D5mZQ9mP668zpzLLPEQ38yIRERSGcqpI/JPLb1CSdcHZvaPDZ9Rk
         TBbbAVpgUFvxz0fV36y6Z1zJoPN5ENxSfCD8ZFLfLSegO1AjvIJzfiI5Ie4wJBq0EkUD
         SKtA==
X-Gm-Message-State: AC+VfDxdfo9qG2FHQ37978sC+TTkzU2VBpPmGK8xD1M+VpNEf12/COx2
	FbL9S/EeqEBh+iTeizMVQ8c=
X-Google-Smtp-Source: ACHHUZ7KXB9ZogpXmaJ0seP4leCF2fwX8PNZ2SdaDQEMYlbnlh8Z5j7alZgFSgcLdYk9PeQ7OGWzeQ==
X-Received: by 2002:a17:907:8a20:b0:96a:861:a2ac with SMTP id sc32-20020a1709078a2000b0096a0861a2acmr3587865ejc.0.1684539376027;
        Fri, 19 May 2023 16:36:16 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id p12-20020a17090635cc00b0096a2eaa508asm154969ejb.168.2023.05.19.16.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 16:36:15 -0700 (PDT)
Date: Sat, 20 May 2023 02:36:13 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Simon Horman <simon.horman@corigine.com>, kernel@pengutronix.de,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v4 2/2] net: dsa: microchip: ksz8: Add function
 to configure ports with integrated PHYs
Message-ID: <20230519233613.op7ziqzy5wu6zjv6@skbuf>
References: <20230519124700.635041-1-o.rempel@pengutronix.de>
 <20230519124700.635041-1-o.rempel@pengutronix.de>
 <20230519124700.635041-3-o.rempel@pengutronix.de>
 <20230519124700.635041-3-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519124700.635041-3-o.rempel@pengutronix.de>
 <20230519124700.635041-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 02:47:00PM +0200, Oleksij Rempel wrote:
> This patch introduces the function 'ksz8_phy_port_link_up' to the
> Microchip KSZ8xxx driver. This function is responsible for setting up
> flow control and duplex settings for the ports that are integrated with
> PHYs.
> 
> The KSZ8795 switch supports asynchronous pause control, which can't be

s/asynchronous/asymmetric/

> fully utilized since a single bit controls both RX and TX pause. Despite
> this, the flow control can be adjusted based on the auto-negotiation
> process, taking into account the capabilities of both link partners.
> 
> On the other hand, the KSZ8873's PORT_FORCE_FLOW_CTRL bit can be set by
> the hardware bootstrap, which ignores the auto-negotiation result.
> Therefore, even in auto-negotiation mode, we need to ensure that this
> bit is correctly set.
> 
> When auto-negotiation isn't in use, we enforce synchronous pause control

s/synchronous/symmetric/

> for the KSZ8795 switch.
> 
> Please note, forcing flow control disable on a port while still
> advertising pause support isn't possible. While this scenario
> might not be practical or desired, it's important to be aware of this
> limitation when working with the KSZ8873 and similar devices.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/dsa/microchip/ksz8795.c | 79 +++++++++++++++++++++++++++++
>  1 file changed, 79 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 9eedccbf5b7c..148a93f79538 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -1371,6 +1371,83 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
>  	}
>  }
>  
> +/**
> + * ksz8_phy_port_link_up - Configures ports with integrated PHYs
> + * @dev: The KSZ device instance.
> + * @port: The port number to configure.
> + * @duplex: The desired duplex mode.
> + * @tx_pause: If true, enables transmit pause.
> + * @rx_pause: If true, enables receive pause.
> + *
> + * Description:
> + * The function configures flow control settings for a given port based on the
> + * desired settings and current duplex mode.
> + *
> + * According to the KSZ8873 datasheet, the PORT_FORCE_FLOW_CTRL bit in the
> + * Port Control 2 register (0x1A for Port 1, 0x22 for Port 2, 0x32 for Port 3)
> + * determines how flow control is handled on the port:
> + *    "1 = will always enable full-duplex flow control on the port, regardless
> + *         of AN result.
> + *     0 = full-duplex flow control is enabled based on AN result."
> + *
> + * This means that the flow control behavior depends on the state of this bit:
> + * - If PORT_FORCE_FLOW_CTRL is set to 1, the switch will ignore AN results and
> + *   force flow control on the port.
> + * - If PORT_FORCE_FLOW_CTRL is set to 0, the switch will enable or disable
> + *   flow control based on the AN results.
> + *
> + * However, there is a potential limitation in this configuration. It is
> + * currently not possible to force disable flow control on a port if we still
> + * advertise pause support. While such a configuration is not currently
> + * supported by Linux, and may not make practical sense, it's important to be
> + * aware of this limitation when working with the KSZ8873 and similar devices.
> + */
> +static void ksz8_phy_port_link_up(struct ksz_device *dev, int port, int duplex,
> +				  bool tx_pause, bool rx_pause)
> +{
> +	const u16 *regs = dev->info->regs;
> +	u8 ctrl = 0;
> +	int ret;
> +
> +	/* The KSZ8795 switch differs from the KSZ8873 by supporting
> +	 * asynchronous pause control. However, since a single bit is used to

same

> +	 * control both RX and TX pause, we can't enforce asynchronous pause

same

> +	 * control - both TX and RX pause will be either enabled or disabled
> +	 * together.
> +	 *
> +	 * If auto-negotiation is enabled, we usually allow the flow control to
> +	 * be determined by the auto-negotiation process based on the
> +	 * capabilities of both link partners. However, for KSZ8873, the
> +	 * PORT_FORCE_FLOW_CTRL bit may be set by the hardware bootstrap,
> +	 * ignoring the auto-negotiation result. Thus, even in auto-negotiatio

auto-negotiation

> +	 * mode, we need to ensure that the PORT_FORCE_FLOW_CTRL bit is
> +	 * properly cleared.
> +	 *
> +	 * In the absence of auto-negotiation, we will enforce synchronous

same

> +	 * pause control for both variants of switches - KSZ8873 and KSZ8795.
> +	 */
> +	if (duplex) {
> +		bool aneg_en = false;
> +
> +		ret = ksz_pread8(dev, port, regs[P_FORCE_CTRL], &ctrl);
> +		if (ret)
> +			return;
> +
> +		if (ksz_is_ksz88x3(dev)) {
> +			if ((ctrl & PORT_AUTO_NEG_ENABLE))
> +				aneg_en = true;
> +		} else {
> +			if (!(ctrl & PORT_AUTO_NEG_DISABLE))
> +				aneg_en = true;
> +		}
> +
> +		if (!aneg_en && (tx_pause || rx_pause))
> +			ctrl |= PORT_FORCE_FLOW_CTRL;
> +	}
> +
> +	ksz_prmw8(dev, port, regs[P_STP_CTRL], PORT_FORCE_FLOW_CTRL, ctrl);
> +}
> +
>  /**
>   * ksz8_cpu_port_link_up - Configures the CPU port of the switch.
>   * @dev: The KSZ device instance.
> @@ -1420,6 +1497,8 @@ void ksz8_phylink_mac_link_up(struct ksz_device *dev, int port,
>  	 */
>  	if (dev->cpu_port == port)
>  		ksz8_cpu_port_link_up(dev, speed, duplex, tx_pause, rx_pause);
> +	else if (dev->info->internal_phy[port])
> +		ksz8_phy_port_link_up(dev, port, duplex, tx_pause, rx_pause);
>  }
>  
>  static int ksz8_handle_global_errata(struct dsa_switch *ds)
> -- 
> 2.39.2
> 


