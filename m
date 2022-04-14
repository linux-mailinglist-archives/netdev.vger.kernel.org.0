Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE355017DB
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244260AbiDNPvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 11:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245754AbiDNPKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 11:10:16 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B321B996A3;
        Thu, 14 Apr 2022 07:47:13 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id g18so10475223ejc.10;
        Thu, 14 Apr 2022 07:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=q7ISUzyklvKGI84CL+7xQ9PKZp96mRwZFvZ9wWWf2PY=;
        b=L9zItOE+6XOW6XflOnge7upgtH/NLeWUBgGLCt5OyxKHSWl48WUe9GmBkrwN4tRve0
         MV4OoPkCz8xuhX04l+2SKpFBQuMa1s1HV/mbP0WL9S6fy4h6u4i60XR/lTdqtDybgpN6
         kFwq0XxCLq1HmRanS6G1UgH9zjW0m86Y5KdS6UMFUste/pZoTfckFYlSmYQsR9SZAExd
         BvDQ3sy/2tawF5a+QgEpBiifrZEZ6G/QNH/cZCBb4u/aJGKPT6R/6gVlPyIux7glHHnE
         W9fHSu3UEeFL03XCyGoy7Zi+0rXxDb3TbOV3eYFSP3Y70vQt6Q8Rwzzy+fBoMHoQ7PTV
         WBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=q7ISUzyklvKGI84CL+7xQ9PKZp96mRwZFvZ9wWWf2PY=;
        b=WvYLM8A7DBWQROW3xSdh4MGzm3qXtwI/wiyksg0gKijvL/yaDKsg0a6vyQkzkOA142
         X/DTw6NAorAqo4RFG5cXu57uTbo7fujqzaNAAMgkk2zYpeMS9Se8j2+9B/qEQL9u6196
         ItxpQMebU5vYEQYBaV/1aGNIb7ZkYHk5blOVlLZJxIfEdPhSDXN0lSj0Q0jNmTznYhqY
         TzBGIdtRFHC4SdO/YXeQ8n658ktDSJnlEtotm+vnWVbOvMOHa2VqoUJO3rnQFkNfBNkw
         wfFLMuyFCwcfeFo52z1KLsFFpf5NQFhdKvI2SGFjcVFZpWYn7r6+hVU4OCAMkiL0+2jv
         IZqw==
X-Gm-Message-State: AOAM533Yjm5ZfHsVv7wCcI/efV9DrwURUIYPLOjqxvmSEqEiT2Qz+/BB
        a296F7mPYgJZ7+X5L9qB13s=
X-Google-Smtp-Source: ABdhPJwZ8Ui/g3K+RmdYm6d8WEKfBpeTMwz+WXAt6LHgRMdhetputdoYV4rK3iRmAxuvQyN/r60Zew==
X-Received: by 2002:a17:906:174f:b0:6d0:5629:e4be with SMTP id d15-20020a170906174f00b006d05629e4bemr2618921eje.525.1649947632081;
        Thu, 14 Apr 2022 07:47:12 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id l10-20020a170906938a00b006e88c811016sm667841ejx.145.2022.04.14.07.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 07:47:11 -0700 (PDT)
Date:   Thu, 14 Apr 2022 17:47:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Laurent Gonzales <laurent.gonzales@non.se.com>,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next 06/12] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
Message-ID: <20220414144709.tpxiiaiy2hu4n7fd@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-7-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414122250.158113-7-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 02:22:44PM +0200, Clément Léger wrote:
> Add Renesas RZ/N1 advanced 5 port switch driver. This switch handles 5
> ports including 1 CPU management port. A MDIO bus is also exposed by
> this switch and allows to communicate with PHYs connected to the ports.
> Each switch port (except for the CPU management ports) are connected to

s/are/is/

> the MII converter.
> 
> This driver include basic bridging support, more support will be added

s/include/includes/

> later (vlan, etc).
> 
> Suggested-by: Laurent Gonzales <laurent.gonzales@non.se.com>
> Suggested-by: Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>
> Suggested-by: Phil Edworthy <phil.edworthy@renesas.com>

Suggested? What did they suggest? "You should write a driver"?
We have a Co-developed-by: tag, maybe it's more appropriate here?

> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  drivers/net/dsa/Kconfig      |   9 +
>  drivers/net/dsa/Makefile     |   2 +
>  drivers/net/dsa/rzn1_a5psw.c | 676 +++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/rzn1_a5psw.h | 196 ++++++++++
>  4 files changed, 883 insertions(+)
>  create mode 100644 drivers/net/dsa/rzn1_a5psw.c
>  create mode 100644 drivers/net/dsa/rzn1_a5psw.h
> 
> diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
> index 37a3dabdce31..0896c5fd9dec 100644
> --- a/drivers/net/dsa/Kconfig
> +++ b/drivers/net/dsa/Kconfig
> @@ -70,6 +70,15 @@ config NET_DSA_QCA8K
>  
>  source "drivers/net/dsa/realtek/Kconfig"
>  
> +config NET_DSA_RZN1_A5PSW
> +	tristate "Renesas RZ/N1 A5PSW Ethernet switch support"
> +	depends on NET_DSA
> +	select NET_DSA_TAG_RZN1_A5PSW
> +	select PCS_RZN1_MIIC
> +	help
> +	  This driver supports the A5PSW switch, which is embedded in Renesas
> +	  RZ/N1 SoC.
> +
>  config NET_DSA_SMSC_LAN9303
>  	tristate
>  	depends on VLAN_8021Q || VLAN_8021Q=n
> diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
> index e73838c12256..5daf3da4344e 100644
> --- a/drivers/net/dsa/Makefile
> +++ b/drivers/net/dsa/Makefile
> @@ -9,12 +9,14 @@ obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
>  obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530.o
>  obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
>  obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
> +obj-$(CONFIG_NET_DSA_RZN1_A5PSW) += rzn1_a5psw.o
>  obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
>  obj-$(CONFIG_NET_DSA_SMSC_LAN9303_I2C) += lan9303_i2c.o
>  obj-$(CONFIG_NET_DSA_SMSC_LAN9303_MDIO) += lan9303_mdio.o
>  obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX) += vitesse-vsc73xx-core.o
>  obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM) += vitesse-vsc73xx-platform.o
>  obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_SPI) += vitesse-vsc73xx-spi.o
> +

Unrelated change.

>  obj-y				+= b53/
>  obj-y				+= hirschmann/
>  obj-y				+= microchip/
> diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> new file mode 100644
> index 000000000000..5bee999f7050
> --- /dev/null
> +++ b/drivers/net/dsa/rzn1_a5psw.c
> @@ -0,0 +1,676 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2022 Schneider-Electric
> + *
> + * Clément Léger <clement.leger@bootlin.com>
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/etherdevice.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_mdio.h>
> +#include <net/dsa.h>
> +#include <uapi/linux/if_bridge.h>

Why do you need to include this header?

> +
> +#include "rzn1_a5psw.h"
> +
> +static void a5psw_reg_writel(struct a5psw *a5psw, int offset, u32 value)
> +{
> +	writel(value, a5psw->base + offset);
> +}
> +
> +static u32 a5psw_reg_readl(struct a5psw *a5psw, int offset)
> +{
> +	return readl(a5psw->base + offset);
> +}
> +
> +static void a5psw_reg_rmw(struct a5psw *a5psw, int offset, u32 mask, u32 val)
> +{
> +	u32 reg;
> +
> +	spin_lock(&a5psw->reg_lock);
> +
> +	reg = a5psw_reg_readl(a5psw, offset);
> +	reg &= ~mask;
> +	reg |= val;
> +	a5psw_reg_writel(a5psw, offset, reg);
> +
> +	spin_unlock(&a5psw->reg_lock);
> +}
> +
> +static enum dsa_tag_protocol a5psw_get_tag_protocol(struct dsa_switch *ds,
> +						    int port,
> +						    enum dsa_tag_protocol mp)
> +{
> +	return DSA_TAG_PROTO_RZN1_A5PSW;
> +}
> +
> +static void a5psw_port_pattern_set(struct a5psw *a5psw, int port, int pattern,
> +				   bool enable)
> +{
> +	u32 rx_match = 0;
> +
> +	if (enable)
> +		rx_match |= A5PSW_RXMATCH_CONFIG_PATTERN(pattern);
> +
> +	a5psw_reg_rmw(a5psw, A5PSW_RXMATCH_CONFIG(port),
> +		      A5PSW_RXMATCH_CONFIG_PATTERN(pattern), rx_match);
> +}
> +
> +static void a5psw_port_mgmtfwd_set(struct a5psw *a5psw, int port, bool enable)

Some explanation on what "management forward" means/does?

> +{
> +	a5psw_port_pattern_set(a5psw, port, A5PSW_PATTERN_MGMTFWD, enable);
> +}
> +
> +static void a5psw_port_enable_set(struct a5psw *a5psw, int port, bool enable)
> +{
> +	u32 port_ena = 0;
> +
> +	if (enable)
> +		port_ena |= A5PSW_PORT_ENA_TX_RX(port);
> +
> +	a5psw_reg_rmw(a5psw, A5PSW_PORT_ENA, A5PSW_PORT_ENA_TX_RX(port),
> +		      port_ena);
> +}
> +
> +static int a5psw_lk_execute_ctrl(struct a5psw *a5psw, u32 *ctrl)
> +{
> +	int ret;
> +
> +	a5psw_reg_writel(a5psw, A5PSW_LK_ADDR_CTRL, *ctrl);
> +
> +	ret = readl_poll_timeout(a5psw->base + A5PSW_LK_ADDR_CTRL,
> +				 *ctrl,
> +				 !(*ctrl & A5PSW_LK_ADDR_CTRL_BUSY),
> +				 A5PSW_LK_BUSY_USEC_POLL,
> +				 A5PSW_CTRL_TIMEOUT);
> +	if (ret)
> +		dev_err(a5psw->dev, "LK_CTRL timeout waiting for BUSY bit\n");
> +
> +	return ret;
> +}
> +
> +static void a5psw_port_fdb_flush(struct a5psw *a5psw, int port)
> +{
> +	u32 ctrl = A5PSW_LK_ADDR_CTRL_DELETE_PORT | BIT(port);
> +
> +	spin_lock(&a5psw->lk_lock);
> +	a5psw_lk_execute_ctrl(a5psw, &ctrl);
> +	spin_unlock(&a5psw->lk_lock);
> +}
> +
> +static void a5psw_port_authorize_set(struct a5psw *a5psw, int port,
> +				     bool authorize)
> +{
> +	u32 reg = a5psw_reg_readl(a5psw, A5PSW_AUTH_PORT(port));
> +
> +	if (authorize)
> +		reg |= A5PSW_AUTH_PORT_AUTHORIZED;
> +	else
> +		reg &= ~A5PSW_AUTH_PORT_AUTHORIZED;
> +
> +	a5psw_reg_writel(a5psw,  A5PSW_AUTH_PORT(port), reg);
> +}
> +
> +static void a5psw_port_disable(struct dsa_switch *ds, int port)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +
> +	a5psw_port_authorize_set(a5psw, port, false);
> +	a5psw_port_enable_set(a5psw, port, false);
> +	a5psw_port_fdb_flush(a5psw, port);
> +}
> +
> +static int a5psw_port_enable(struct dsa_switch *ds, int port,
> +			     struct phy_device *phy)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +
> +	a5psw_port_authorize_set(a5psw, port, true);
> +	a5psw_port_enable_set(a5psw, port, true);
> +
> +	return 0;
> +}
> +
> +static int a5psw_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +
> +	new_mtu += ETH_HLEN + A5PSW_EXTRA_MTU_LEN + ETH_FCS_LEN;
> +	a5psw_reg_writel(a5psw, A5PSW_FRM_LENGTH(port), new_mtu);
> +
> +	return 0;
> +}
> +
> +static int a5psw_port_max_mtu(struct dsa_switch *ds, int port)
> +{
> +	return A5PSW_JUMBO_LEN - A5PSW_TAG_LEN;
> +}

> +static int a5psw_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +	unsigned long rate;
> +	u64 max, tmp;
> +	u32 agetime;
> +
> +	rate = clk_get_rate(a5psw->clk);
> +	max = div64_ul(((u64)A5PSW_LK_AGETIME_MASK * A5PSW_TABLE_ENTRIES * 1024),
> +		       rate) * 1000;
> +	if (msecs > max)
> +		return -EINVAL;
> +
> +	tmp = div_u64(rate, MSEC_PER_SEC);
> +	agetime = div_u64(msecs * tmp, 1024 * A5PSW_TABLE_ENTRIES);
> +
> +	a5psw_reg_writel(a5psw, A5PSW_LK_AGETIME, agetime);
> +
> +	return 0;
> +}
> +
> +static void a5psw_flooding_set_resolution(struct a5psw *a5psw, int port,
> +					  bool set)
> +{
> +	u8 offsets[] = {A5PSW_UCAST_DEF_MASK, A5PSW_BCAST_DEF_MASK,
> +		       A5PSW_MCAST_DEF_MASK};
> +	int i;
> +
> +	if (set)
> +		a5psw->flooding_ports |= BIT(port);
> +	else
> +		a5psw->flooding_ports &= ~BIT(port);
> +
> +	for (i = 0; i < ARRAY_SIZE(offsets); i++)
> +		a5psw_reg_writel(a5psw, offsets[i], a5psw->flooding_ports);
> +}
> +
> +static int a5psw_port_bridge_join(struct dsa_switch *ds, int port,
> +				  struct dsa_bridge bridge,
> +				  bool *tx_fwd_offload,
> +				  struct netlink_ext_ack *extack)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +
> +	a5psw_flooding_set_resolution(a5psw, port, true);
> +	a5psw_port_mgmtfwd_set(a5psw, port, false);
> +
> +	return 0;
> +}
> +
> +static void a5psw_port_bridge_leave(struct dsa_switch *ds, int port,
> +				    struct dsa_bridge bridge)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +
> +	a5psw_flooding_set_resolution(a5psw, port, false);
> +	a5psw_port_mgmtfwd_set(a5psw, port, true);
> +}
> +
> +static void a5psw_port_stp_state_set(struct dsa_switch *ds, int port,
> +				     u8 state)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +	u32 reg = 0;
> +	u32 mask = A5PSW_INPUT_LEARN_DIS(port) | A5PSW_INPUT_LEARN_BLOCK(port);
> +
> +	switch (state) {
> +	case BR_STATE_DISABLED:
> +	case BR_STATE_BLOCKING:
> +		reg |= A5PSW_INPUT_LEARN_DIS(port);
> +		reg |= A5PSW_INPUT_LEARN_BLOCK(port);
> +		break;
> +	case BR_STATE_LISTENING:
> +		reg |= A5PSW_INPUT_LEARN_DIS(port);
> +		break;
> +	case BR_STATE_LEARNING:
> +		reg |= A5PSW_INPUT_LEARN_BLOCK(port);
> +		break;
> +	case BR_STATE_FORWARDING:
> +	default:
> +		break;
> +	}
> +
> +	a5psw_reg_rmw(a5psw, A5PSW_INPUT_LEARN, mask, reg);
> +}
> +
> +static void a5psw_port_fast_age(struct dsa_switch *ds, int port)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +
> +	a5psw_port_fdb_flush(a5psw, port);
> +}
> +
> +static int a5psw_setup(struct dsa_switch *ds)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +	int port, vlan, ret;
> +	u32 reg;
> +
> +	/* Configure management port */
> +	reg = A5PSW_CPU_PORT | A5PSW_MGMT_CFG_DISCARD;
> +	a5psw_reg_writel(a5psw, A5PSW_MGMT_CFG, reg);

Perhaps you should validate the DT blob that the CPU port is the one
that you think it is?

> +
> +	/* Set pattern 0 to forward all frame to mgmt port */
> +	a5psw_reg_writel(a5psw, A5PSW_PATTERN_CTRL(0),
> +			 A5PSW_PATTERN_CTRL_MGMTFWD);
> +
> +	/* Enable port tagging */
> +	reg = FIELD_PREP(A5PSW_MGMT_TAG_CFG_TAGFIELD, A5PSW_MGMT_TAG_VALUE);
> +	reg |= A5PSW_MGMT_TAG_CFG_ENABLE | A5PSW_MGMT_TAG_CFG_ALL_FRAMES;
> +	a5psw_reg_writel(a5psw, A5PSW_MGMT_TAG_CFG, reg);
> +
> +	/* Enable normal switch operation */
> +	reg = A5PSW_LK_ADDR_CTRL_BLOCKING | A5PSW_LK_ADDR_CTRL_LEARNING |
> +	      A5PSW_LK_ADDR_CTRL_AGEING | A5PSW_LK_ADDR_CTRL_ALLOW_MIGR |
> +	      A5PSW_LK_ADDR_CTRL_CLEAR_TABLE;
> +	a5psw_reg_writel(a5psw, A5PSW_LK_CTRL, reg);
> +
> +	ret = readl_poll_timeout(a5psw->base + A5PSW_LK_CTRL,
> +				 reg,
> +				 !(reg & A5PSW_LK_ADDR_CTRL_CLEAR_TABLE),
> +				 A5PSW_LK_BUSY_USEC_POLL,
> +				 A5PSW_CTRL_TIMEOUT);
> +	if (ret) {
> +		dev_err(a5psw->dev, "Failed to clear lookup table\n");
> +		return ret;
> +	}
> +
> +	/* Reset learn count to 0 */
> +	reg = A5PSW_LK_LEARNCOUNT_MODE_SET;
> +	a5psw_reg_writel(a5psw, A5PSW_LK_LEARNCOUNT, reg);
> +
> +	/* Clear VLAN resource table */
> +	reg = A5PSW_VLAN_RES_WR_PORTMASK | A5PSW_VLAN_RES_WR_TAGMASK;
> +	for (vlan = 0; vlan < A5PSW_VLAN_COUNT; vlan++)
> +		a5psw_reg_writel(a5psw, A5PSW_VLAN_RES(vlan), reg);
> +
> +	/* Reset all ports */
> +	for (port = 0; port < ds->num_ports; port++) {

Because dsa_is_cpu_port() internally calls dsa_to_port() which iterates
through a list, we tend to avoid the pattern where we call a list
iterating function from a loop over essentially the same data.
Instead, we have:

	dsa_switch_for_each_port(dp, ds) {
		if (dsa_port_is_unused(dp))
			do stuff with dp->index
		if (dsa_port_is_cpu(dp))
			...
		if (dsa_port_is_user(dp))
			...
	}

> +		/* Reset the port */
> +		a5psw_reg_writel(a5psw, A5PSW_CMD_CFG(port),
> +				 A5PSW_CMD_CFG_SW_RESET);
> +
> +		/* Enable only CPU port */
> +		a5psw_port_enable_set(a5psw, port, dsa_is_cpu_port(ds, port));
> +
> +		if (dsa_is_unused_port(ds, port))
> +			continue;
> +
> +		/* Enable egress flooding for CPU port */
> +		if (dsa_is_cpu_port(ds, port))
> +			a5psw_flooding_set_resolution(a5psw, port, true);
> +
> +		/* Enable management forward only for user ports */
> +		if (dsa_is_user_port(ds, port))
> +			a5psw_port_mgmtfwd_set(a5psw, port, true);
> +	}
> +
> +	return 0;
> +}
> +
> +const struct dsa_switch_ops a5psw_switch_ops = {
> +	.get_tag_protocol = a5psw_get_tag_protocol,
> +	.setup = a5psw_setup,
> +	.port_disable = a5psw_port_disable,
> +	.port_enable = a5psw_port_enable,
> +	.phylink_validate = a5psw_phylink_validate,
> +	.phylink_mac_select_pcs = a5psw_phylink_mac_select_pcs,
> +	.phylink_mac_link_down = a5psw_phylink_mac_link_down,
> +	.phylink_mac_link_up = a5psw_phylink_mac_link_up,
> +	.port_change_mtu = a5psw_port_change_mtu,
> +	.port_max_mtu = a5psw_port_max_mtu,
> +	.set_ageing_time = a5psw_set_ageing_time,
> +	.port_bridge_join = a5psw_port_bridge_join,
> +	.port_bridge_leave = a5psw_port_bridge_leave,
> +	.port_stp_state_set = a5psw_port_stp_state_set,
> +	.port_fast_age = a5psw_port_fast_age,
> +

Stray empty line.

> +};
> +
> +static int a5psw_mdio_wait_busy(struct a5psw *a5psw)
> +{
> +	u32 status;
> +	int err;
> +
> +	err = readl_poll_timeout(a5psw->base + A5PSW_MDIO_CFG_STATUS,
> +				 status,
> +				 !(status & A5PSW_MDIO_CFG_STATUS_BUSY),
> +				 10,
> +				 1000 * USEC_PER_MSEC);
> +	if (err)
> +		dev_err(a5psw->dev, "MDIO command timeout\n");
> +
> +	return err;
> +}
> +
> +static int a5psw_mdio_read(struct mii_bus *bus, int phy_id, int phy_reg)
> +{
> +	struct a5psw *a5psw = bus->priv;
> +	u32 cmd, status;
> +	int ret;
> +
> +	cmd = A5PSW_MDIO_COMMAND_READ;
> +	cmd |= FIELD_PREP(A5PSW_MDIO_COMMAND_REG_ADDR, phy_reg);
> +	cmd |= FIELD_PREP(A5PSW_MDIO_COMMAND_PHY_ADDR, phy_id);
> +
> +	a5psw_reg_writel(a5psw, A5PSW_MDIO_COMMAND, cmd);
> +
> +	ret = a5psw_mdio_wait_busy(a5psw);
> +	if (ret)
> +		return ret;
> +
> +	ret = a5psw_reg_readl(a5psw, A5PSW_MDIO_DATA) & A5PSW_MDIO_DATA_MASK;
> +
> +	status = a5psw_reg_readl(a5psw, A5PSW_MDIO_CFG_STATUS);
> +	if (status & A5PSW_MDIO_CFG_STATUS_READERR)
> +		return -EIO;
> +
> +	return ret;
> +}
> +
> +static int a5psw_mdio_write(struct mii_bus *bus, int phy_id, int phy_reg,
> +			    u16 phy_data)
> +{
> +	struct a5psw *a5psw = bus->priv;
> +	u32 cmd;
> +
> +	cmd = FIELD_PREP(A5PSW_MDIO_COMMAND_REG_ADDR, phy_reg);
> +	cmd |= FIELD_PREP(A5PSW_MDIO_COMMAND_PHY_ADDR, phy_id);
> +
> +	a5psw_reg_writel(a5psw, A5PSW_MDIO_COMMAND, cmd);
> +	a5psw_reg_writel(a5psw, A5PSW_MDIO_DATA, phy_data);
> +
> +	return a5psw_mdio_wait_busy(a5psw);
> +}
> +
> +static int a5psw_mdio_reset(struct mii_bus *bus)
> +{
> +	struct a5psw *a5psw = bus->priv;
> +	unsigned long rate;
> +	unsigned long div;
> +	u32 cfgstatus;
> +
> +	rate = clk_get_rate(a5psw->hclk);
> +	div = ((rate / a5psw->mdio_freq) / 2);
> +	if (div >= 511 || div <= 5) {
> +		dev_err(a5psw->dev, "MDIO clock div %ld out of range\n", div);
> +		return -ERANGE;
> +	}
> +
> +	cfgstatus = FIELD_PREP(A5PSW_MDIO_CFG_STATUS_CLKDIV, div);
> +
> +	a5psw_reg_writel(a5psw, A5PSW_MDIO_CFG_STATUS, cfgstatus);
> +
> +	return 0;
> +}
> +
> +static int a5psw_probe_mdio(struct a5psw *a5psw)
> +{
> +	struct device *dev = a5psw->dev;
> +	struct device_node *mdio_node;
> +	struct mii_bus *bus;
> +	int err;
> +
> +	if (of_property_read_u32(dev->of_node, "clock-frequency",
> +				 &a5psw->mdio_freq))
> +		a5psw->mdio_freq = A5PSW_MDIO_DEF_FREQ;

Shouldn't the clock-frequency be a property of the "mdio" node?
At least I see it in Documentation/devicetree/bindings/net/mdio.yaml.

> +
> +	bus = devm_mdiobus_alloc(dev);
> +	if (!bus)
> +		return -ENOMEM;
> +
> +	bus->name = "a5psw_mdio";
> +	bus->read = a5psw_mdio_read;
> +	bus->write = a5psw_mdio_write;
> +	bus->reset = a5psw_mdio_reset;
> +	bus->priv = a5psw;
> +	bus->parent = dev;
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
> +
> +	a5psw->mii_bus = bus;
> +
> +	mdio_node = of_get_child_by_name(dev->of_node, "mdio");
> +	err = devm_of_mdiobus_register(dev, bus, mdio_node);
> +	of_node_put(mdio_node);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +

> +static int a5psw_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct dsa_switch *ds;
> +	struct a5psw *a5psw;
> +	int ret;
> +
> +	a5psw = devm_kzalloc(dev, sizeof(*a5psw), GFP_KERNEL);
> +	if (!a5psw)
> +		return -ENOMEM;
> +
> +	a5psw->dev = dev;
> +	spin_lock_init(&a5psw->lk_lock);
> +	spin_lock_init(&a5psw->reg_lock);
> +	a5psw->base = devm_platform_ioremap_resource(pdev, 0);
> +	if (!a5psw->base)
> +		return -EINVAL;
> +
> +	/* Probe PCS */
> +	ret = a5psw_pcs_get(a5psw);
> +	if (ret)
> +		return ret;
> +
> +	a5psw->hclk = devm_clk_get(dev, "hclk");
> +	if (IS_ERR(a5psw->hclk)) {
> +		dev_err(dev, "failed get hclk clock\n");
> +		ret = PTR_ERR(a5psw->hclk);
> +		goto free_pcs;
> +	}
> +
> +	a5psw->clk = devm_clk_get(dev, "clk");
> +	if (IS_ERR(a5psw->clk)) {
> +		dev_err(dev, "failed get clk_switch clock\n");
> +		ret = PTR_ERR(a5psw->clk);
> +		goto free_pcs;
> +	}
> +
> +	ret = clk_prepare_enable(a5psw->clk);
> +	if (ret)
> +		goto free_pcs;
> +
> +	ret = clk_prepare_enable(a5psw->hclk);
> +	if (ret)
> +		goto clk_disable;
> +
> +	ret = a5psw_probe_mdio(a5psw);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to register MDIO: %d\n", ret);
> +		goto hclk_disable;
> +	}
> +
> +	ds = &a5psw->ds;
> +	ds->dev = &pdev->dev;
> +	ds->num_ports = A5PSW_PORTS_NUM;
> +	ds->ops = &a5psw_switch_ops;
> +	ds->priv = a5psw;
> +
> +	ret = dsa_register_switch(ds);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to register DSA switch: %d\n", ret);
> +		goto hclk_disable;
> +	}
> +
> +	return 0;
> +
> +hclk_disable:
> +	clk_disable_unprepare(a5psw->hclk);
> +clk_disable:
> +	clk_disable_unprepare(a5psw->clk);
> +free_pcs:
> +	a5psw_pcs_free(a5psw);
> +
> +	return ret;
> +}
> +
> +static int a5psw_remove(struct platform_device *pdev)
> +{
> +	struct a5psw *a5psw = platform_get_drvdata(pdev);
> +
> +	dsa_unregister_switch(&a5psw->ds);
> +	a5psw_pcs_free(a5psw);
> +	clk_disable_unprepare(a5psw->hclk);
> +	clk_disable_unprepare(a5psw->clk);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id a5psw_of_mtable[] = {
> +	{ .compatible = "renesas,rzn1-a5psw", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, a5psw_of_mtable);
> +
> +static struct platform_driver a5psw_driver = {
> +	.driver = {
> +		.name	 = "rzn1_a5psw",
> +		.of_match_table = of_match_ptr(a5psw_of_mtable),
> +	},
> +	.probe = a5psw_probe,
> +	.remove = a5psw_remove,

Please implement .shutdown too, it's non-optional.

> +/**
> + * struct a5psw - switch struct
> + * @base: Base address of the switch
> + * @hclk_rate: hclk_switch clock rate
> + * @clk_rate: clk_switch clock rate
> + * @dev: Device associated to the switch
> + * @mii_bus: MDIO bus struct
> + * @mdio_freq: MDIO bus frequency requested
> + * @pcs: Array of PCS connected to the switch ports (not for the CPU)
> + * @ds: DSA switch struct
> + * @lk_lock: Lock for the lookup table
> + * @reg_lock: Lock for register read-modify-write operation

Interesting concept. Generally we see higher-level locking schemes
(i.e. a rmw lock won't really ensure much in terms of consistency of
settings if that's the only thing that serializes concurrent thread
accesses to some register).

Anyway, probably doesn't hurt to have it.

> + * @flooding_ports: List of ports that should be flooded
> + */
> +struct a5psw {
> +	void __iomem *base;
> +	struct clk* hclk;
> +	struct clk* clk;
> +	struct device *dev;
> +	struct mii_bus	*mii_bus;
> +	u32 mdio_freq;
> +	struct phylink_pcs *pcs[A5PSW_PORTS_NUM - 1];
> +	struct dsa_switch ds;
> +	spinlock_t lk_lock;
> +	spinlock_t reg_lock;
> +	u32 flooding_ports;
> +};
> -- 
> 2.34.1
> 

We have some selftests in tools/testing/selftests/net/forwarding/, like
for example bridge_vlan_unaware.sh. They create veth pairs by default,
but if you edit the NETIF_CREATE configuration you should be able to
pass your DSA interfaces.
The selftests don't cover nearly enough, but just to make sure that they
pass for your switch, when you use 2 switch ports as h1 and h2 (hosts),
and 2 ports as swp1 and swp2? There's surprisingly little that you do on
.port_bridge_join, I need to study the code more.
