Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07819353604
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 02:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbhDDAge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 20:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236526AbhDDAgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 20:36:31 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49184C061756;
        Sat,  3 Apr 2021 17:36:26 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id x21so9038265eds.4;
        Sat, 03 Apr 2021 17:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VuAZ5L5TvbDMgw40iIoZjKqEj7Oq0eGKxjJjtOB9Ek4=;
        b=LXUyAf7ltOnSpcS9IcpTgnh9kqJwaVo/bYXhPN5MYkga5n+q5kQ87IBAFkN3ao83li
         ITlDWIcJ0JpNgA77tsmox3AcpProAY/FZCyLf7DGtXs3HHyeQlTYKVPKQ6n5O6OaBcGr
         oT6sqIqU61cKJl9k+KDVx6xvAhYkBwGZd4YQ6RmKYsrMZsVCNdsIgvN8DpdI2a9zYHLQ
         iVABU1NTHzh2gjKqsTTnH57ahxbELiSpXZ8CqDUlWP7uw/P+gcWZ5met73CSRD4ehFlv
         5sHTPbwD0zc9aCf5hDOx2SwhFctW6RRqrhnANPd3Rpku1Rt6xtzhF59cY4FJPuRvPXvH
         rtAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VuAZ5L5TvbDMgw40iIoZjKqEj7Oq0eGKxjJjtOB9Ek4=;
        b=XwFgXIrTQqxm0qYzek50Q1erDeWtVd0uFEiHJ+fu55Rda8rw4aez7v+HHpQcKbdajn
         YWlQK+tztW3lCskdo496DCvq3gPEhwc0qctPs2I6TCF/x9uQSDoN0dL8Sicm01a/oghz
         MCmboomsp9DfZUPKTGJvKE7T6eZrgZ+0fZd/IZTnf2zk18HzrlScEOsGo9h0w/8DFbI7
         zlqPSkS7WlaLggs4/Lonfh9xtPwsRJAdLpTWZkm7KQxXLShProkGGCh7nQbaWbYyrgLv
         u6JR+qD3CeFUSvlH4Unuy1iEfXpG0mVy2CI39y4vP5wipZYJNsrglE01/TQA3LXe1qhe
         qhqQ==
X-Gm-Message-State: AOAM531JNBnQvZRTlKGDeZ1wnSzv9Ep3FjMZqKoXGvr8pCa/JgSxytXd
        zXkbpCC7xTPRWek8aYKPDV4=
X-Google-Smtp-Source: ABdhPJxstEyNliTadNZ5xPS9xWNP8/fhY7RUEb8QGpoL6dV8BFaPmbmjJ+iE/V0oR//dlMGv84IZZQ==
X-Received: by 2002:a05:6402:646:: with SMTP id u6mr23784737edx.250.1617496584898;
        Sat, 03 Apr 2021 17:36:24 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id s9sm7484554edd.16.2021.04.03.17.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 17:36:24 -0700 (PDT)
Date:   Sun, 4 Apr 2021 03:36:22 +0300
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
Subject: Re: [PATCH net-next v1 9/9] net: dsa: qca: ar9331: add vlan support
Message-ID: <20210404003622.sy3ma6rla2w7v2nh@skbuf>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-10-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210403114848.30528-10-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 01:48:48PM +0200, Oleksij Rempel wrote:
> This switch provides simple VLAN resolution database for 16 entries (VLANs).
> With this database we can cover typical functionalities as port based
> VLANs, untagged and tagged egress. Port based ingress filtering.
> 
> The VLAN database is working on top of forwarding database. So,

Define 'on top'.

> potentially, we can have multiple VLANs on top of multiple bridges.
> Hawing one VLAN on top of multiple bridges will fail on different

s/Hawing/Having/

> levels, most probably DSA framework should warn if some one wont to make

s/wont/wants/
s/some one/someone/

> something likes this.

Finally, why should the DSA framework warn?
Even in the default configuration of two bridges, the default_pvid (1)
will be the same. What problems do you have with that?

In commit 0ee2af4ebbe3 ("net: dsa: set configure_vlan_while_not_filtering
to true by default"), I did not notice that ar9331 does not have VLAN
operations, and I mistakenly set ds->configure_vlan_while_not_filtering
= false for your driver. Could you please delete that line and ensure the
following works?

ip link add br0 type bridge
ip link set lan0 master br0
bridge vlan add dev lan0 vid 100
ip link set br0 type bridge vlan_filtering 1
# make sure you can receive traffic with VLAN 100

> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/qca/ar9331.c | 255 +++++++++++++++++++++++++++++++++++
>  1 file changed, 255 insertions(+)
> 
> +static int ar9331_sw_vt_wait(struct ar9331_sw_priv *priv, u32 *f0)
> +{
> +	struct regmap *regmap = priv->regmap;
> +
> +	return regmap_read_poll_timeout(regmap,
> +				        AR9331_SW_REG_VLAN_TABLE_FUNCTION0,
> +				        *f0, !(*f0 & AR9331_SW_VT0_BUSY),
> +				        100, 2000);
> +}
> +
> +static int ar9331_sw_port_vt_rmw(struct ar9331_sw_priv *priv, u16 vid,
> +				 u8 port_mask_set, u8 port_mask_clr)
> +{
> +	struct regmap *regmap = priv->regmap;
> +	u32 f0, f1, port_mask = 0, port_mask_new, func;
> +	struct ar9331_sw_vlan_db *vdb = NULL;
> +	int ret, i;
> +
> +	if (!vid)
> +		return 0;
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
> +	if (vdb) {
> +		port_mask = vdb->port_mask;
> +	}
> +
> +	port_mask_new = port_mask & ~port_mask_clr;
> +	port_mask_new |= port_mask_set;
> +
> +	if (port_mask_new && port_mask_new == port_mask) {
> +		dev_info(priv->dev, "%s: no need to overwrite existing valid entry on %x\n",
> +				    __func__, port_mask_new);

With VLANs, the bridge is indeed much less strict compared to FDBs, due
to the old API having ranges baked in (which were never used).

That being said, is there actually any value in this message? Would you
mind deleting it (I see how it could annoy a user)?

You might want to look at devlink regions if you want to debug the VLAN
table of the hardware.

> +		return 0;
> +	}
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
> +		if (!vdb) {
> +			dev_err_ratelimited(priv->dev, "Local VDB is full\n");

You have a netlink extack at your disposal, use it.

> +			return -ENOMEM;
> +		}
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
> +		dev_err_ratelimited(priv->dev, "%s: can't add new entry, VT is full\n", __func__);

Similar comment as above.

> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +
> +error:
> +	dev_err_ratelimited(priv->dev, "%s: error: %pe\n", __func__,
> +			    ERR_PTR(ret));
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
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;

You don't need to cast a void pointer in the C language.

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
> +	dev_err_ratelimited(priv->dev, "%s: error: %pe\n", __func__,
> +			    ERR_PTR(ret));
> +
> +	return ret;
> +}
> +
> +static int ar9331_port_vlan_del(struct dsa_switch *ds, int port,
> +				const struct switchdev_obj_port_vlan *vlan)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	int ret;
> +
> +	ret = ar9331_sw_port_vt_rmw(priv, vlan->vid, 0, BIT(port));
> +	if (ret)
> +		goto error;
> +
> +	return 0;
> +
> +error:
> +	dev_err_ratelimited(priv->dev, "%s: error: %pe\n", __func__,
> +			    ERR_PTR(ret));
> +
> +	return ret;
> +}

This looks like a whole lot of boilerplate compared to:

	ret = vlan_table_read_modify_write
	if (ret)
		print_error

	return ret

> +
>  static const struct dsa_switch_ops ar9331_sw_ops = {
>  	.get_tag_protocol	= ar9331_sw_get_tag_protocol,
>  	.setup			= ar9331_sw_setup,
> @@ -1292,6 +1544,9 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
>  	.port_bridge_join	= ar9331_sw_port_bridge_join,
>  	.port_bridge_leave	= ar9331_sw_port_bridge_leave,
>  	.port_stp_state_set	= ar9331_sw_port_stp_state_set,
> +	.port_vlan_filtering	= ar9331_port_vlan_filtering,
> +	.port_vlan_add		= ar9331_port_vlan_add,
> +	.port_vlan_del		= ar9331_port_vlan_del,
>  };
>  
>  static irqreturn_t ar9331_sw_irq(int irq, void *data)
> -- 
> 2.29.2
> 
