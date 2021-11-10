Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68D444C165
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 13:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhKJMjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 07:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhKJMjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 07:39:31 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EF2C061764;
        Wed, 10 Nov 2021 04:36:43 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id b15so9895124edd.7;
        Wed, 10 Nov 2021 04:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GDxRI+AJ4cja7OAY/H+al8KUo25cBcnolGcz42vNvR4=;
        b=dkSvy/1ut1BWwDCoqUAO3eXzbIS/U+PGmEdI9CslS7Ib5yOLjd+pxMDSZuZV8RpfDt
         ElxAcYALOYZncXQ6Oz7I+ifubu5UCGorkyWJRhIgQm8eWwEviqHqZljZQTl67Wtt9i7J
         x5z3mwfGTLgyf0tnbdC5GN9LnWu7vlWeZsT+YN+cWNZ6OU9xTVophfYlJV/ybtw+nUHj
         oA5afz3vq9Q1hUWeoQUKBjrNhJE9D9zJMc6N3w3yK+uCCUHqYouZBXejNPqGaSuToobT
         h/QycaHQi+y4Uu/B+zkvUJvdZHqCnflFDdkOQwwF7yL3Kc7LE2aNVItzD3aFExOkCB4q
         gYAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GDxRI+AJ4cja7OAY/H+al8KUo25cBcnolGcz42vNvR4=;
        b=6rmJxtqNZBKpiciDa+aKbwN5d+HhXGM13eRFPe24s9+0m4qhQr4fp3yf7mP4psDHMD
         Asht7F2KVy+a/VDgBImsxtljxI6m2fZke6Nu9EoQ7jdR5yV5Cf/b2CrFvCPFB2yMhieM
         tFb5dVK41u6ah9PlAucVBUwPRf0cDxr2awMjZdJApZswfoMWcXMOWw6cPp/CHVLoBEjt
         SdjcTNHg1hj8ijO//Xp2D428m7tJm5tPoHoUxLJ4hSz2H/lZDx3PozZE+iYgbFdtBKk/
         fmL8vrljnbSekMDdtr+iBC/st9jTMOwN6YtoVg3QyKJf4UGoWJThVbsYi8HUVgkO/SCE
         hsAQ==
X-Gm-Message-State: AOAM532aV4QzmCXB+qEKhMcWhUUTBRUh6X6TfO3irOwPKlL6RY3e9G4F
        hyruwMwvUVm4zbczimSCuPA=
X-Google-Smtp-Source: ABdhPJySQ+2xHe2yiRRGCkt/aBM9r6BIRBqdvca5LyJwuEGQ4Ww1Jd9nzpmdgBB4vtNscwtxkJxarA==
X-Received: by 2002:a17:907:7d94:: with SMTP id oz20mr21046725ejc.410.1636547801961;
        Wed, 10 Nov 2021 04:36:41 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id u14sm12929937edj.74.2021.11.10.04.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 04:36:41 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:36:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] net: dsa: microchip: implement multi-bridge
 support
Message-ID: <20211110123640.z5hub3nv37dypa6m@skbuf>
References: <20211108111034.2735339-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108111034.2735339-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 08, 2021 at 12:10:34PM +0100, Oleksij Rempel wrote:
> Current driver version is able to handle only one bridge at time.
> Configuring two bridges on two different ports would end up shorting this
> bridges by HW. To reproduce it:
> 
> 	ip l a name br0 type bridge
> 	ip l a name br1 type bridge
> 	ip l s dev br0 up
> 	ip l s dev br1 up
> 	ip l s lan1 master br0
> 	ip l s dev lan1 up
> 	ip l s lan2 master br1
> 	ip l s dev lan2 up
> 
> 	Ping on lan1 and get response on lan2, which should not happen.
> 
> This happened, because current driver version is storing one global "Port VLAN
> Membership" and applying it to all ports which are members of any
> bridge.
> To solve this issue, we need to handle each port separately.
> 
> This patch is dropping the global port member storage and calculating
> membership dynamically depending on STP state and bridge participation.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Because there wasn't any restriction in the driver against multiple
bridges, I would be tempted to send to the "net" tree and provide a
Fixes: tag.

>  drivers/net/dsa/microchip/ksz8795.c    | 53 ++++-----------------
>  drivers/net/dsa/microchip/ksz9477.c    | 64 ++++----------------------
>  drivers/net/dsa/microchip/ksz_common.c | 56 +++++++++++++---------
>  drivers/net/dsa/microchip/ksz_common.h |  1 -
>  4 files changed, 51 insertions(+), 123 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
> index 43fc3087aeb3..b5f6dff70c89 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -1008,51 +1008,27 @@ static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
>  static void ksz8_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
>  {
>  	struct ksz_device *dev = ds->priv;
> -	int forward = dev->member;
>  	struct ksz_port *p;
> -	int member = -1;
>  	u8 data;
>  
> -	p = &dev->ports[port];
> -
>  	ksz_pread8(dev, port, P_STP_CTRL, &data);
>  	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
>  
>  	switch (state) {
>  	case BR_STATE_DISABLED:
>  		data |= PORT_LEARN_DISABLE;
> -		if (port < dev->phy_port_cnt)
> -			member = 0;
>  		break;
>  	case BR_STATE_LISTENING:
>  		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
> -		if (port < dev->phy_port_cnt &&
> -		    p->stp_state == BR_STATE_DISABLED)
> -			member = dev->host_mask | p->vid_member;
>  		break;
>  	case BR_STATE_LEARNING:
>  		data |= PORT_RX_ENABLE;
>  		break;
>  	case BR_STATE_FORWARDING:
>  		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
> -
> -		/* This function is also used internally. */
> -		if (port == dev->cpu_port)
> -			break;
> -
> -		/* Port is a member of a bridge. */
> -		if (dev->br_member & BIT(port)) {
> -			dev->member |= BIT(port);
> -			member = dev->member;
> -		} else {
> -			member = dev->host_mask | p->vid_member;
> -		}
>  		break;
>  	case BR_STATE_BLOCKING:
>  		data |= PORT_LEARN_DISABLE;
> -		if (port < dev->phy_port_cnt &&
> -		    p->stp_state == BR_STATE_DISABLED)
> -			member = dev->host_mask | p->vid_member;
>  		break;
>  	default:
>  		dev_err(ds->dev, "invalid STP state: %d\n", state);
> @@ -1060,22 +1036,11 @@ static void ksz8_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
>  	}
>  
>  	ksz_pwrite8(dev, port, P_STP_CTRL, data);
> +
> +	p = &dev->ports[port];
>  	p->stp_state = state;
> -	/* Port membership may share register with STP state. */
> -	if (member >= 0 && member != p->member)
> -		ksz8_cfg_port_member(dev, port, (u8)member);
> -
> -	/* Check if forwarding needs to be updated. */
> -	if (state != BR_STATE_FORWARDING) {
> -		if (dev->br_member & BIT(port))
> -			dev->member &= ~BIT(port);
> -	}
>  
> -	/* When topology has changed the function ksz_update_port_member
> -	 * should be called to modify port forwarding behavior.
> -	 */
> -	if (forward != dev->member)
> -		ksz_update_port_member(dev, port);
> +	ksz_update_port_member(dev, port);
>  }
>  
>  static void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
> @@ -1341,7 +1306,7 @@ static void ksz8795_cpu_interface_select(struct ksz_device *dev, int port)
>  
>  static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
>  {
> -	struct ksz_port *p = &dev->ports[port];
> +	struct dsa_switch *ds = dev->ds;
>  	struct ksz8 *ksz8 = dev->priv;
>  	const u32 *masks;
>  	u8 member;
> @@ -1364,14 +1329,15 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
>  	/* enable 802.1p priority */
>  	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_ENABLE, true);
>  
> -	if (cpu_port) {
> +	if (dsa_is_cpu_port(ds, port)) {
>  		if (!ksz_is_ksz88x3(dev))
>  			ksz8795_cpu_interface_select(dev, port);
>  
> -		member = dev->port_mask;
> +		member = dsa_user_ports(ds);
>  	} else {
> -		member = dev->host_mask | p->vid_member;
> +		member = BIT(dsa_upstream_port(ds, port));
>  	}
> +
>  	ksz8_cfg_port_member(dev, port, member);
>  }
>  
> @@ -1392,11 +1358,9 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
>  	ksz_cfg(dev, regs[S_TAIL_TAG_CTRL], masks[SW_TAIL_TAG_ENABLE], true);
>  
>  	p = &dev->ports[dev->cpu_port];
> -	p->vid_member = dev->port_mask;
>  	p->on = 1;
>  
>  	ksz8_port_setup(dev, dev->cpu_port, true);
> -	dev->member = dev->host_mask;
>  
>  	for (i = 0; i < dev->phy_port_cnt; i++) {
>  		p = &dev->ports[i];
> @@ -1404,7 +1368,6 @@ static void ksz8_config_cpu_port(struct dsa_switch *ds)
>  		/* Initialize to non-zero so that ksz_cfg_port_member() will
>  		 * be called.
>  		 */
> -		p->vid_member = BIT(i);
>  		p->member = dev->port_mask;
>  		ksz8_port_stp_state_set(ds, i, BR_STATE_DISABLED);
>  
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index 854e25f43fa7..3e7df6c0dc72 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -400,8 +400,6 @@ static void ksz9477_port_stp_state_set(struct dsa_switch *ds, int port,
>  	struct ksz_device *dev = ds->priv;
>  	struct ksz_port *p = &dev->ports[port];
>  	u8 data;
> -	int member = -1;
> -	int forward = dev->member;
>  
>  	ksz_pread8(dev, port, P_STP_CTRL, &data);
>  	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
> @@ -409,40 +407,18 @@ static void ksz9477_port_stp_state_set(struct dsa_switch *ds, int port,
>  	switch (state) {
>  	case BR_STATE_DISABLED:
>  		data |= PORT_LEARN_DISABLE;
> -		if (port != dev->cpu_port)
> -			member = 0;
>  		break;
>  	case BR_STATE_LISTENING:
>  		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
> -		if (port != dev->cpu_port &&
> -		    p->stp_state == BR_STATE_DISABLED)
> -			member = dev->host_mask | p->vid_member;
>  		break;
>  	case BR_STATE_LEARNING:
>  		data |= PORT_RX_ENABLE;
>  		break;
>  	case BR_STATE_FORWARDING:
>  		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
> -
> -		/* This function is also used internally. */
> -		if (port == dev->cpu_port)
> -			break;
> -
> -		member = dev->host_mask | p->vid_member;
> -		mutex_lock(&dev->dev_mutex);
> -
> -		/* Port is a member of a bridge. */
> -		if (dev->br_member & (1 << port)) {
> -			dev->member |= (1 << port);
> -			member = dev->member;
> -		}
> -		mutex_unlock(&dev->dev_mutex);
>  		break;
>  	case BR_STATE_BLOCKING:
>  		data |= PORT_LEARN_DISABLE;
> -		if (port != dev->cpu_port &&
> -		    p->stp_state == BR_STATE_DISABLED)
> -			member = dev->host_mask | p->vid_member;
>  		break;
>  	default:
>  		dev_err(ds->dev, "invalid STP state: %d\n", state);
> @@ -451,23 +427,8 @@ static void ksz9477_port_stp_state_set(struct dsa_switch *ds, int port,
>  
>  	ksz_pwrite8(dev, port, P_STP_CTRL, data);
>  	p->stp_state = state;
> -	mutex_lock(&dev->dev_mutex);
> -	/* Port membership may share register with STP state. */
> -	if (member >= 0 && member != p->member)
> -		ksz9477_cfg_port_member(dev, port, (u8)member);
> -
> -	/* Check if forwarding needs to be updated. */
> -	if (state != BR_STATE_FORWARDING) {
> -		if (dev->br_member & (1 << port))
> -			dev->member &= ~(1 << port);
> -	}
>  
> -	/* When topology has changed the function ksz_update_port_member
> -	 * should be called to modify port forwarding behavior.
> -	 */
> -	if (forward != dev->member)
> -		ksz_update_port_member(dev, port);
> -	mutex_unlock(&dev->dev_mutex);
> +	ksz_update_port_member(dev, port);
>  }
>  
>  static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
> @@ -1168,10 +1129,10 @@ static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
>  
>  static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
>  {
> -	u8 data8;
> -	u8 member;
> -	u16 data16;
>  	struct ksz_port *p = &dev->ports[port];
> +	struct dsa_switch *ds = dev->ds;
> +	u8 data8, member;
> +	u16 data16;
>  
>  	/* enable tag tail for host port */
>  	if (cpu_port)
> @@ -1250,12 +1211,12 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
>  		ksz_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
>  		p->phydev.duplex = 1;
>  	}
> -	mutex_lock(&dev->dev_mutex);
> -	if (cpu_port)
> -		member = dev->port_mask;
> +
> +	if (dsa_is_cpu_port(ds, port))
> +		member = dsa_user_ports(ds);
>  	else
> -		member = dev->host_mask | p->vid_member;
> -	mutex_unlock(&dev->dev_mutex);
> +		member = BIT(dsa_upstream_port(ds, port));
> +
>  	ksz9477_cfg_port_member(dev, port, member);
>  
>  	/* clear pending interrupts */
> @@ -1276,8 +1237,6 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
>  			const char *prev_mode;
>  
>  			dev->cpu_port = i;
> -			dev->host_mask = (1 << dev->cpu_port);
> -			dev->port_mask |= dev->host_mask;
>  			p = &dev->ports[i];
>  
>  			/* Read from XMII register to determine host port
> @@ -1312,13 +1271,10 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
>  
>  			/* enable cpu port */
>  			ksz9477_port_setup(dev, i, true);
> -			p->vid_member = dev->port_mask;
>  			p->on = 1;
>  		}
>  	}
>  
> -	dev->member = dev->host_mask;
> -
>  	for (i = 0; i < dev->port_cnt; i++) {
>  		if (i == dev->cpu_port)
>  			continue;
> @@ -1327,8 +1283,6 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
>  		/* Initialize to non-zero so that ksz_cfg_port_member() will
>  		 * be called.
>  		 */
> -		p->vid_member = (1 << i);
> -		p->member = dev->port_mask;
>  		ksz9477_port_stp_state_set(ds, i, BR_STATE_DISABLED);
>  		p->on = 1;
>  		if (i < dev->phy_port_cnt)
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 7c2968a639eb..84b7ef511ff4 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -22,21 +22,46 @@
>  
>  void ksz_update_port_member(struct ksz_device *dev, int port)
>  {
> -	struct ksz_port *p;
> +	struct ksz_port *p = &dev->ports[port];
> +	struct dsa_switch *ds = dev->ds;
> +	const struct dsa_port *dp;
> +	u8 port_member = 0;
>  	int i;
>  
> -	for (i = 0; i < dev->port_cnt; i++) {
> -		if (i == port || i == dev->cpu_port)
> +	if (!dsa_is_user_port(ds, port))
> +		return;
> +
> +	dp = dsa_to_port(ds, port);
> +
> +	for (i = 0; i < ds->num_ports; i++) {
> +		const struct dsa_port *dpi = dsa_to_port(ds, i);

Other drivers name this "other_dp", I don't think that name is too bad.
Also, you can use "dsa_switch_for_each_user_port", which is also more
efficient, although you can't if you target 'stable' with this change,
since it has been introduced rather recently.

> +		struct ksz_port *pi = &dev->ports[i];

and this could be "other_p" rather than "pi".

> +		u8 val = 0;
> +
> +		if (!dsa_is_user_port(ds, i))
>  			continue;
> -		p = &dev->ports[i];
> -		if (!(dev->member & (1 << i)))
> +		if (port == i)
>  			continue;
> +		if (!dp->bridge_dev || dp->bridge_dev != dpi->bridge_dev)
> +			continue;
> +
> +		pi = &dev->ports[i];
> +		if (pi->stp_state != BR_STATE_DISABLED)
> +			val |= BIT(dsa_upstream_port(ds, i));
>  

This is saying:
For each {user port, other port} pair, if the other port isn't DISABLED,
then allow the user port to forward towards the CPU port of the other port.
What sense does that make? You don't support multiple CPU ports, so this
port's CPU port is that port's CPU port, and you have one more (broken)
forwarding rule towards the CPU port below.

> -		/* Port is a member of the bridge and is forwarding. */
> -		if (p->stp_state == BR_STATE_FORWARDING &&
> -		    p->member != dev->member)
> -			dev->dev_ops->cfg_port_member(dev, i, dev->member);
> +		if (pi->stp_state == BR_STATE_FORWARDING &&
> +		    p->stp_state == BR_STATE_FORWARDING) {
> +			val |= BIT(port);
> +			port_member |= BIT(i);
> +		}
> +
> +		dev->dev_ops->cfg_port_member(dev, i, val);
>  	}
> +
> +	if (p->stp_state != BR_STATE_DISABLED)
> +		port_member |= BIT(dsa_upstream_port(ds, port));

Why != DISABLED? I expect that dev_ops->cfg_port_member() affects only
data packet forwarding, not control packet forwarding, right?

> +
> +	dev->dev_ops->cfg_port_member(dev, port, port_member);
>  }
>  EXPORT_SYMBOL_GPL(ksz_update_port_member);
>  
> @@ -175,12 +200,6 @@ EXPORT_SYMBOL_GPL(ksz_get_ethtool_stats);
>  int ksz_port_bridge_join(struct dsa_switch *ds, int port,
>  			 struct net_device *br)
>  {
> -	struct ksz_device *dev = ds->priv;
> -
> -	mutex_lock(&dev->dev_mutex);
> -	dev->br_member |= (1 << port);
> -	mutex_unlock(&dev->dev_mutex);
> -
>  	/* port_stp_state_set() will be called after to put the port in
>  	 * appropriate state so there is no need to do anything.
>  	 */
> @@ -192,13 +211,6 @@ EXPORT_SYMBOL_GPL(ksz_port_bridge_join);
>  void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
>  			   struct net_device *br)
>  {
> -	struct ksz_device *dev = ds->priv;
> -
> -	mutex_lock(&dev->dev_mutex);
> -	dev->br_member &= ~(1 << port);
> -	dev->member &= ~(1 << port);
> -	mutex_unlock(&dev->dev_mutex);
> -
>  	/* port_stp_state_set() will be called after to put the port in
>  	 * forwarding state so there is no need to do anything.
>  	 */
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 1597c63988b4..18c9b2e34cd1 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -26,7 +26,6 @@ struct ksz_port_mib {
>  
>  struct ksz_port {
>  	u16 member;
> -	u16 vid_member;
>  	bool remove_tag;		/* Remove Tag flag set, for ksz8795 only */
>  	int stp_state;
>  	struct phy_device phydev;
> -- 
> 2.30.2
> 
