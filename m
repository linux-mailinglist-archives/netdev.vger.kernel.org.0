Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E37E456784
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 02:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhKSBpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 20:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhKSBpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 20:45:15 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC945C061574;
        Thu, 18 Nov 2021 17:42:13 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z5so35676700edd.3;
        Thu, 18 Nov 2021 17:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=US4bBBQw8jWW3YlHOADLdGGcsGDE5tgV3v7GUN08OX8=;
        b=K2oTjJ3ddluDGh2lio+3j13PzmAjA2YQbnSrzZ5Agh1DfYnZZgUJeRw4bjkfCtR43a
         TLovnm6wvF+uVZ3Jkwz8eFvlPlnikpymxXDdKqk3r5jD+QmjiQTdx/lQskpC+zVL5ZCs
         +WA50y599X0Tf5tz4WSJmtC7SaNmujVGH9yK84UKESb2QRWBzIrmYu6n0OThTerI5AbF
         LQ/b/z8Bh3BaPyr3HGjeLOF0YG7ZnsoqizSLfKMh6D5XnD5n2g9kqpJDlhBRlvgLMmxa
         XFqSHBH36PwEdXYgoSopAAHcZJMUPtdFpmtH27kgZYmJVEfSEVYV3hX6YW3SiLaKHZVh
         FJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=US4bBBQw8jWW3YlHOADLdGGcsGDE5tgV3v7GUN08OX8=;
        b=FmALkig+YmY6G3endDx8jEg6OITKC9BliUboeufh6I+oMWg2GCUfTJc2fROLqDKO2/
         araIW46av5RKnatHxbdlcllPYV8ApELVmXOPC6TgVzz79xfJ+ar4xt5sUJUXVYcClmBP
         JSMWGEwD5AhfvihCfCslMDD8ME6O+ZAYVKHt2SEWwg5vxQ3VRNyAUP9YG1KKs03KwaQX
         lU6REZYUPHW+hx/+Jw6R3B3x20nXnrJudNMMZm1VEETOnLLBjlHJBspf49w0KTXsrWZz
         VvUSfYT69WOK/CUkiQarvArAUUU9z2frAngaVZY9DYT98VbWwZp6HYCNryJ3e07hVzgY
         i3uA==
X-Gm-Message-State: AOAM530YomfSeHAe5tueQ5cRLSVLdGrxcoRxvtG1qRVWjhF+hG1DFzd2
        w+sE10Up+pDpMfge4gI/Q44=
X-Google-Smtp-Source: ABdhPJx89OaLWwRUekm+myrerO/9KORwQAPOZLUku+GN9vZw+eWhq1NjveY0UWY/4J26l5vweKYUOA==
X-Received: by 2002:a17:906:619:: with SMTP id s25mr2640638ejb.237.1637286132490;
        Thu, 18 Nov 2021 17:42:12 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id x7sm828552edd.28.2021.11.18.17.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 17:42:12 -0800 (PST)
Date:   Fri, 19 Nov 2021 03:42:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 11/19] net: dsa: qca8k: add support for mirror
 mode
Message-ID: <20211119014211.ogm4m2x3omn3dyhe@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-12-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-12-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:04:43PM +0100, Ansuel Smith wrote:
> The switch support mirror mode. Only one port can set as mirror port and
> every other port can set to both ingress and egress mode. The mirror
> port is disabled and reverted to normal operation once every port is
> removed from sending packet to the mirror mode.

> Also modify the fdb logit to send packet to both destination and mirror
> port by default to support mirror mode.

I don't see any FDB logic being modified by this patch. Also, port-based
mirroring should not require it.

> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 95 +++++++++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/qca8k.h |  5 +++
>  2 files changed, 100 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index d73886b36e6a..a74099131e3d 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1938,6 +1938,99 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
>  	return 0;
>  }
>  
> +static int
> +qca8k_port_mirror_add(struct dsa_switch *ds, int port,
> +		      struct dsa_mall_mirror_tc_entry *mirror,
> +		      bool ingress)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	int monitor_port, ret;
> +	u32 reg, val;
> +
> +	/* Check for existent entry */
> +	if ((ingress ? priv->mirror_rx : priv->mirror_tx) & BIT(port))
> +		return -EEXIST;
> +
> +	ret = regmap_read(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0, &val);
> +	if (ret)
> +		return ret;
> +
> +	/* QCA83xx can have only one port set to mirror mode.
> +	 * Check that the correct port is requested and return error otherwise.
> +	 * When no mirror port is set, the values is set to 0xF
> +	 */
> +	monitor_port = FIELD_GET(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
> +	if (monitor_port != 0xF && monitor_port != mirror->to_local_port)
> +		return -EEXIST;
> +
> +	/* Set the monitor port */
> +	val = FIELD_PREP(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM,
> +			 mirror->to_local_port);
> +	ret = regmap_update_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
> +				 QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
> +	if (ret)
> +		return ret;
> +
> +	if (ingress) {
> +		reg = QCA8K_PORT_LOOKUP_CTRL(port);
> +		val = QCA8K_PORT_LOOKUP_ING_MIRROR_EN;
> +	} else {
> +		reg = QCA8K_REG_PORT_HOL_CTRL1(port);
> +		val = QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN;
> +	}
> +
> +	ret = regmap_update_bits(priv->regmap, reg, val, val);
> +	if (ret)
> +		return ret;
> +
> +	/* Track mirror port for tx and rx to decide when the
> +	 * mirror port has to be disabled.
> +	 */
> +	if (ingress)
> +		priv->mirror_rx |= BIT(port);
> +	else
> +		priv->mirror_tx |= BIT(port);
> +
> +	return 0;
> +}
> +
> +static void
> +qca8k_port_mirror_del(struct dsa_switch *ds, int port,
> +		      struct dsa_mall_mirror_tc_entry *mirror)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	u32 reg, val;
> +	int ret;
> +
> +	if (mirror->ingress) {
> +		reg = QCA8K_PORT_LOOKUP_CTRL(port);
> +		val = QCA8K_PORT_LOOKUP_ING_MIRROR_EN;
> +	} else {
> +		reg = QCA8K_REG_PORT_HOL_CTRL1(port);
> +		val = QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN;
> +	}
> +
> +	ret = regmap_clear_bits(priv->regmap, reg, val);
> +	if (ret)
> +		goto err;
> +
> +	if (mirror->ingress)
> +		priv->mirror_rx &= ~BIT(port);
> +	else
> +		priv->mirror_tx &= ~BIT(port);
> +
> +	/* No port set to send packet to mirror port. Disable mirror port */
> +	if (!priv->mirror_rx && !priv->mirror_tx) {
> +		val = FIELD_PREP(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, 0xF);
> +		ret = regmap_update_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
> +					 QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
> +		if (ret)
> +			goto err;
> +	}
> +err:
> +	dev_err(priv->dev, "Failed to del mirror port from %d", port);
> +}
> +
>  static int
>  qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
>  			  struct netlink_ext_ack *extack)
> @@ -2045,6 +2138,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.port_fdb_add		= qca8k_port_fdb_add,
>  	.port_fdb_del		= qca8k_port_fdb_del,
>  	.port_fdb_dump		= qca8k_port_fdb_dump,
> +	.port_mirror_add	= qca8k_port_mirror_add,
> +	.port_mirror_del	= qca8k_port_mirror_del,
>  	.port_vlan_filtering	= qca8k_port_vlan_filtering,
>  	.port_vlan_add		= qca8k_port_vlan_add,
>  	.port_vlan_del		= qca8k_port_vlan_del,
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index c5d83514ad2e..d25afdab4dea 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -177,6 +177,7 @@
>  #define   QCA8K_VTU_FUNC1_FULL				BIT(4)
>  #define QCA8K_REG_GLOBAL_FW_CTRL0			0x620
>  #define   QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN		BIT(10)
> +#define   QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM		GENMASK(7, 4)
>  #define QCA8K_REG_GLOBAL_FW_CTRL1			0x624
>  #define   QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_MASK		GENMASK(30, 24)
>  #define   QCA8K_GLOBAL_FW_CTRL1_BC_DP_MASK		GENMASK(22, 16)
> @@ -198,6 +199,7 @@
>  #define   QCA8K_PORT_LOOKUP_STATE_LEARNING		QCA8K_PORT_LOOKUP_STATE(0x3)
>  #define   QCA8K_PORT_LOOKUP_STATE_FORWARD		QCA8K_PORT_LOOKUP_STATE(0x4)
>  #define   QCA8K_PORT_LOOKUP_LEARN			BIT(20)
> +#define   QCA8K_PORT_LOOKUP_ING_MIRROR_EN		BIT(25)
>  
>  #define QCA8K_REG_GLOBAL_FC_THRESH			0x800
>  #define   QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK		GENMASK(24, 16)
> @@ -262,6 +264,7 @@ enum qca8k_fdb_cmd {
>  	QCA8K_FDB_FLUSH	= 1,
>  	QCA8K_FDB_LOAD = 2,
>  	QCA8K_FDB_PURGE = 3,
> +	QCA8K_FDB_FLUSH_PORT = 5,

This portion seems like the missing piece required for the previous
patch to actually compile.

>  	QCA8K_FDB_NEXT = 6,
>  	QCA8K_FDB_SEARCH = 7,
>  };
> @@ -302,6 +305,8 @@ struct qca8k_ports_config {
>  struct qca8k_priv {
>  	u8 switch_id;
>  	u8 switch_revision;
> +	u8 mirror_rx;
> +	u8 mirror_tx;
>  	bool legacy_phy_port_mapping;
>  	struct qca8k_ports_config ports_config;
>  	struct regmap *regmap;
> -- 
> 2.32.0
> 

