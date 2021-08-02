Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91C43DDB84
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbhHBOvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbhHBOvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 10:51:02 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4209C06175F;
        Mon,  2 Aug 2021 07:50:51 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id nd39so31328944ejc.5;
        Mon, 02 Aug 2021 07:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1ph9hQhMwEqNButCr5CskWxFJEGxZutn4sCtVTGhgYs=;
        b=W5vv/4prhp/ridiCyw+pvwNegXZFQlhTzyBPeKsdPdCjXT6F5Os7fb3ooRNf4MuJZX
         guUUrjG8ZZcBTXzJXWSGmNJLbtnavhUHxfDxOJvIDR0GjjSvsXVtEbH7mTva0BAVuCF0
         iDCyWeAOd+G+t+hEa9rkSL2/8RHr/k66ke61LptNxLqdsM96YVuZSque4YsZdYIGNKT3
         u3gNQERstrv4+4vlVlpEV9sfN4lhSLAFli3KX0efsBB+65qsgY6KxgpPZn5OWSb952f+
         DVhme/a3QGS8FlHoCP99ZwYz8yMjQZXGw1NmkFE9UylTOClUs8Wj2HznzblDf8MOO9ZX
         JxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1ph9hQhMwEqNButCr5CskWxFJEGxZutn4sCtVTGhgYs=;
        b=EebFvkA08GIDvJjIqQPIG7lfioetSgsx60yOq7MfDneDCgLSU7xOyt9i7N3bPyzWs2
         kq+NSdzWHTWTGe3yNKDaNywsvwddxlfRZdTXZRkUicjg2Dc+CXDQPRDTEgCQCmiTiPEi
         66UFtfa3YRnsUKWkOTdqPyJjqcAElYWchOSiW6AvITtv0HraUw1tcZSuj5FV6eQzoZCG
         0jkF9nYHRlmfNQh1IbZ2w0BYZaCJTxh+IoEfJt5Tk/ulu2+mXiTQts7hNEckixGj5y2J
         3mQz75c94MRNoHS8QGGpOKIbqYxJaTnftLHIKNpFe+CApNf0CWnb6NiUPu4Cn/tcErs8
         kB8A==
X-Gm-Message-State: AOAM530SuywAXLrFQXIyvw6Smum9K9qsDFfd1saLoCwIulR/AoWQpsk5
        U99oZhVqlntSqRxRWRcgZPk=
X-Google-Smtp-Source: ABdhPJwqFoE4bESSPuP3hjkHQd4fZgpILveFe9RSqsqzUweqmrdMOZttcV1xQqtCavizHno4dLW1MQ==
X-Received: by 2002:a17:906:8248:: with SMTP id f8mr16137876ejx.229.1627915850313;
        Mon, 02 Aug 2021 07:50:50 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id q23sm1225473ejc.0.2021.08.02.07.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 07:50:49 -0700 (PDT)
Date:   Mon, 2 Aug 2021 17:50:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v3 6/6] net: dsa: qca: ar9331: add vlan support
Message-ID: <20210802145048.la6f4u45mguobxnp@skbuf>
References: <20210802131037.32326-1-o.rempel@pengutronix.de>
 <20210802131037.32326-7-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802131037.32326-7-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 03:10:37PM +0200, Oleksij Rempel wrote:
> This switch provides simple VLAN resolution database for 16 entries.
> With this database we can cover typical functionalities as port based
> VLANs, untagged and tagged egress. Port based ingress filtering.
> 
> The VLAN database is working on top of forwarding database. So,
> potentially, we can have multiple VLANs on top of multiple bridges.
> Hawing one VLAN on top of multiple bridges will fail on different
> levels, most probably DSA framework should warn if some one won't to make
> something likes this.

Please define the levels in which it will fail for ar9331.

I opened the AR9331 manual and I see that the only forwarding isolation
mechanism is the PORT_VID_MEMBER, the "port base VLAN", which defines
which other ports can each port forward to. Otherwise, it seems that
when two ports are in 802.1Q mode (VLAN-aware) and in the same VLAN,
they can forward packets in that VLAN regardless of PORT_VID_MEMBER.
If correct, it means you only support a single VLAN-aware bridge, I
recommend you copy what sja1105_prechangeupper does to block a second
one.

The manual also says "The AR9331 only supports shared VLAN learning (SVL)."
So there isn't in fact all that much that the DSA core can save the day.
Even with a single bridge, the standalone ports will still attempt to
look up the FDB, and even though packets from standalone ports should
always reach the CPU port, that might not happen if that MAC DA is in
the bridge FDB of a bridged port. Example: you have a software LAG
interface on top of your standalone ports, and this is in a software
bridge with other ar9331 ports that directly offload the bridge:
https://patchwork.kernel.org/project/netdevbpf/patch/20210731191023.1329446-3-dqfext@gmail.com/

DSA cannot (easily) help you in that case either, but I agree that
tracking all possible constellations of unoffloaded LAG interfaces on
top of ar9331 switches that also have ports in a hardware bridge is
tricky too. I will give this some thought.

> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/qca/ar9331.c | 235 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 233 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> index a0324fed2136..0865ffbc2c74 100644
> --- a/drivers/net/dsa/qca/ar9331.c
> +++ b/drivers/net/dsa/qca/ar9331.c
> @@ -67,6 +67,27 @@
>  #define AR9331_SW_REG_GLOBAL_CTRL		0x30
>  #define AR9331_SW_GLOBAL_CTRL_MFS_M		GENMASK(13, 0)
>  
> +#define AR9331_SW_NUM_VLAN_RECORDS		16
> +
> +#define AR9331_SW_REG_VLAN_TABLE_FUNCTION0	0x40
> +#define AR9331_SW_VT0_PRI_EN			BIT(31)
> +#define AR9331_SW_VT0_PRI			GENMASK(30, 28)
> +#define AR9331_SW_VT0_VID			GENMASK(27, 16)
> +#define AR9331_SW_VT0_PORT_NUM			GENMASK(11, 8)
> +#define AR9331_SW_VT0_FULL_VIO			BIT(4)
> +#define AR9331_SW_VT0_BUSY			BIT(3)
> +#define AR9331_SW_VT0_FUNC			GENMASK(2, 0)
> +#define AR9331_SW_VT0_FUNC_NOP			0
> +#define AR9331_SW_VT0_FUNC_FLUSH_ALL		1
> +#define AR9331_SW_VT0_FUNC_LOAD_ENTRY		2
> +#define AR9331_SW_VT0_FUNC_PURGE_ENTRY		3
> +#define AR9331_SW_VT0_FUNC_DEL_PORT		4
> +#define AR9331_SW_VT0_FUNC_GET_NEXT		5
> +
> +#define AR9331_SW_REG_VLAN_TABLE_FUNCTION1	0x44
> +#define AR9331_SW_VT1_VALID			BIT(11)
> +#define AR9331_SW_VT1_VID_MEM			GENMASK(9, 0)
> +
>  /* Size of the address resolution table (ARL) */
>  #define AR9331_SW_NUM_ARL_RECORDS		1024
>  
> @@ -309,6 +330,11 @@ struct ar9331_sw_port {
>  	struct spinlock stats_lock;
>  };
>  
> +struct ar9331_sw_vlan_db {
> +	u16 vid;
> +	u8 port_mask;
> +};
> +
>  struct ar9331_sw_fdb {
>  	u8 port_mask;
>  	u8 aging;
> @@ -327,6 +353,7 @@ struct ar9331_sw_priv {
>  	struct regmap *regmap;
>  	struct reset_control *sw_reset;
>  	struct ar9331_sw_port port[AR9331_SW_PORTS];
> +	struct ar9331_sw_vlan_db vdb[AR9331_SW_NUM_VLAN_RECORDS];
>  };
>  
>  static struct ar9331_sw_priv *ar9331_sw_port_to_priv(struct ar9331_sw_port *port)
> @@ -557,8 +584,6 @@ static int ar9331_sw_setup(struct dsa_switch *ds)
>  			goto error;
>  	}
>  
> -	ds->configure_vlan_while_not_filtering = false;
> -
>  	return 0;
>  error:
>  	dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> @@ -1144,6 +1169,209 @@ static void ar9331_sw_port_bridge_leave(struct dsa_switch *ds, int port,
>  	ar9331_sw_port_bridge_mod(ds, port, br, false);
>  }
>  
> +static int ar9331_port_vlan_filtering(struct dsa_switch *ds, int port,
> +				      bool vlan_filtering,
> +				      struct netlink_ext_ack *extack)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	u32 mode;
> +	int ret;
> +
> +	if (vlan_filtering)
> +		mode = AR9331_SW_8021Q_MODE_SECURE;
> +	else
> +		mode = AR9331_SW_8021Q_MODE_NONE;
> +
> +	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_VLAN(port),
> +				 AR9331_SW_PORT_VLAN_8021Q_MODE,
> +				 FIELD_PREP(AR9331_SW_PORT_VLAN_8021Q_MODE,
> +					    mode));
> +	if (ret)
> +		dev_err(priv->dev, "%s: error: %pe\n", __func__, ERR_PTR(ret));
> +
> +	return ret;
> +}
> +
> +static int ar9331_sw_vt_wait(struct ar9331_sw_priv *priv, u32 *f0)
> +{
> +	struct regmap *regmap = priv->regmap;
> +
> +	return regmap_read_poll_timeout(regmap,
> +					AR9331_SW_REG_VLAN_TABLE_FUNCTION0,
> +					*f0, !(*f0 & AR9331_SW_VT0_BUSY),
> +					100, 2000);
> +}
> +
> +static int ar9331_sw_port_vt_rmw(struct ar9331_sw_priv *priv, u16 vid,
> +				 u8 port_mask_set, u8 port_mask_clr)
> +{
> +	struct regmap *regmap = priv->regmap;
> +	u32 f0, f1, port_mask = 0, port_mask_new, func;

Reverse Christmas tree ordering?

> +	struct ar9331_sw_vlan_db *vdb = NULL;
> +	int ret, i;
> +
> +	if (!vid)
> +		return 0;

Explanation?

> +
> +	ret = ar9331_sw_vt_wait(priv, &f0);
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_write(regmap, AR9331_SW_REG_VLAN_TABLE_FUNCTION0, 0);
> +	if (ret)
> +		goto error;
> +
> +	ret = regmap_write(regmap, AR9331_SW_REG_VLAN_TABLE_FUNCTION1, 0);
> +	if (ret)
> +		goto error;
> +
> +	for (i = 0; i < ARRAY_SIZE(priv->vdb); i++) {
> +		if (priv->vdb[i].vid == vid) {
> +			vdb = &priv->vdb[i];
> +			break;
> +		}
> +	}
> +
> +	ret = regmap_read(regmap, AR9331_SW_REG_VLAN_TABLE_FUNCTION1, &f1);
> +	if (ret)
> +		return ret;
> +
> +	if (vdb)
> +		port_mask = vdb->port_mask;
> +
> +	port_mask_new = port_mask & ~port_mask_clr;
> +	port_mask_new |= port_mask_set;
> +
> +	if (port_mask_new && port_mask_new == port_mask)
> +		return 0;
> +
> +	if (port_mask_new) {
> +		func = AR9331_SW_VT0_FUNC_LOAD_ENTRY;
> +	} else {
> +		func = AR9331_SW_VT0_FUNC_PURGE_ENTRY;
> +		port_mask_new = port_mask;
> +	}
> +
> +	if (vdb) {
> +		vdb->port_mask = port_mask_new;
> +
> +		if (!port_mask_new)
> +			vdb->vid = 0;
> +	} else {
> +		for (i = 0; i < ARRAY_SIZE(priv->vdb); i++) {
> +			if (!priv->vdb[i].vid) {
> +				vdb = &priv->vdb[i];
> +				break;
> +			}
> +		}
> +
> +		if (!vdb)
> +			return -ENOMEM;
> +
> +		vdb->vid = vid;
> +		vdb->port_mask = port_mask_new;
> +	}
> +
> +	f0 = FIELD_PREP(AR9331_SW_VT0_VID, vid) |
> +	     FIELD_PREP(AR9331_SW_VT0_FUNC, func) |
> +	     AR9331_SW_VT0_BUSY;
> +	f1 = FIELD_PREP(AR9331_SW_VT1_VID_MEM, port_mask_new) |
> +		AR9331_SW_VT1_VALID;
> +
> +	ret = regmap_write(regmap, AR9331_SW_REG_VLAN_TABLE_FUNCTION1, f1);
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_write(regmap, AR9331_SW_REG_VLAN_TABLE_FUNCTION0, f0);
> +	if (ret)
> +		return ret;
> +
> +	ret = ar9331_sw_vt_wait(priv, &f0);
> +	if (ret)
> +		return ret;
> +
> +	if (f0 & AR9331_SW_VT0_FULL_VIO) {
> +		/* cleanup error status */
> +		regmap_write(regmap, AR9331_SW_REG_VLAN_TABLE_FUNCTION0, 0);
> +		return -ENOMEM;

s/ENOMEM/ENOSPC/ since ENOMEM is for kernel memory allocation AFAIK
Also, what about "ret = -ENOSPC; goto error;" to get the print for this
too and be consistent?

> +	}
> +
> +	return 0;
> +
> +error:
> +	dev_err(priv->dev, "%s: error: %pe\n", __func__, ERR_PTR(ret));
> +
> +	return ret;
> +}
> +
> +static int ar9331_port_vlan_set_pvid(struct ar9331_sw_priv *priv, int port,
> +				     u16 pvid)
> +{
> +	struct regmap *regmap = priv->regmap;
> +	int ret;
> +	u32 mask, val;
> +
> +	mask = AR9331_SW_PORT_VLAN_8021Q_MODE |
> +		AR9331_SW_PORT_VLAN_FORCE_DEFALUT_VID_EN |
> +		AR9331_SW_PORT_VLAN_FORCE_PORT_VLAN_EN;
> +	val = AR9331_SW_PORT_VLAN_FORCE_DEFALUT_VID_EN |
> +		AR9331_SW_PORT_VLAN_FORCE_PORT_VLAN_EN |
> +		FIELD_PREP(AR9331_SW_PORT_VLAN_8021Q_MODE,
> +			   AR9331_SW_8021Q_MODE_FALLBACK);
> +
> +	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_VLAN(port),
> +				 mask, val);
> +	if (ret)
> +		return ret;
> +
> +	return regmap_update_bits(regmap, AR9331_SW_REG_PORT_VLAN(port),
> +				  AR9331_SW_PORT_VLAN_PORT_VID,
> +				  FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID,
> +					     pvid));
> +}
> +
> +static int ar9331_port_vlan_add(struct dsa_switch *ds, int port,
> +				const struct switchdev_obj_port_vlan *vlan,
> +				struct netlink_ext_ack *extack)
> +{
> +	struct ar9331_sw_priv *priv = ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	int ret, mode;
> +
> +	ret = ar9331_sw_port_vt_rmw(priv, vlan->vid, BIT(port), 0);
> +	if (ret)
> +		goto error;
> +
> +	if (vlan->flags & BRIDGE_VLAN_INFO_PVID)
> +		ret = ar9331_port_vlan_set_pvid(priv, port, vlan->vid);
> +
> +	if (ret)
> +		goto error;
> +
> +	if (vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED)
> +		mode = AR9331_SW_PORT_CTRL_EG_VLAN_MODE_STRIP;
> +	else
> +		mode = AR9331_SW_PORT_CTRL_EG_VLAN_MODE_ADD;
> +
> +	ret = regmap_update_bits(regmap, AR9331_SW_REG_PORT_CTRL(port),
> +				 AR9331_SW_PORT_CTRL_EG_VLAN_MODE, mode);
> +	if (ret)
> +		goto error;
> +
> +	return 0;
> +error:
> +	dev_err(priv->dev, "%s: error: %pe\n", __func__, ERR_PTR(ret));
> +
> +	return ret;
> +}
> +
> +static int ar9331_port_vlan_del(struct dsa_switch *ds, int port,
> +				const struct switchdev_obj_port_vlan *vlan)
> +{
> +	return ar9331_sw_port_vt_rmw(ds->priv, vlan->vid, 0, BIT(port));
> +}
> +
>  static const struct dsa_switch_ops ar9331_sw_ops = {
>  	.get_tag_protocol	= ar9331_sw_get_tag_protocol,
>  	.setup			= ar9331_sw_setup,
> @@ -1162,6 +1390,9 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
>  	.set_ageing_time	= ar9331_sw_set_ageing_time,
>  	.port_bridge_join	= ar9331_sw_port_bridge_join,
>  	.port_bridge_leave	= ar9331_sw_port_bridge_leave,
> +	.port_vlan_filtering	= ar9331_port_vlan_filtering,
> +	.port_vlan_add		= ar9331_port_vlan_add,
> +	.port_vlan_del		= ar9331_port_vlan_del,
>  };
>  
>  static irqreturn_t ar9331_sw_irq(int irq, void *data)
> -- 
> 2.30.2
> 

