Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE33230FBC
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbgG1QfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731759AbgG1QfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 12:35:01 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698A9C061794;
        Tue, 28 Jul 2020 09:35:01 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l23so1592310edv.11;
        Tue, 28 Jul 2020 09:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6HpEoPRxh4FB43M7DHOmLkKGN135ONDPH9WC7AJ0g0o=;
        b=haOMLqOFPcEu+10in75XGOa6zMlHEQkZsdEsTfgDnCccpTLDWmH+F4/sHkropnOYdb
         6HOhXo3zPeVx9VqlIL/gQs42i3wZm7kRPcXFs+IpjDJWWs5b6BffO4oQ8jYq8reTjPKP
         +zdraKmQRX8pO+jQ2BRS0sMTzhrIb4AMK40IdINbhSYIzmzfSxxXDSLkFqAmCLdDkd0+
         vkh3kERxB5hIj2+kQp2/5CSAMpmbOh01fZuUF9DWG6nNk9Ajz8ZANl/fgruPOV17v5dv
         pTJyhQJtnsXflDeGWuKv20S3AIy3VrYPRWzOx7wlECvCdCD+WfqTtxW3jemGr4rQb43S
         UdOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6HpEoPRxh4FB43M7DHOmLkKGN135ONDPH9WC7AJ0g0o=;
        b=Xd0rBZ5aEBUpiaEigzhdNjOUidKVm0mF7ht38OTwadY2obbtlMIE9AcSw+eah6Sg4W
         30GcEihZh65tEh0lLAsaaBB5HZSWWg/FLfYho+BE2SeVydNCbsSzzoccMe0Gu5n/0xDf
         LvgOsHK8FemK8jaPgRep1JTXLY8387uH+Lb9pDtBoKWVEqJpbXyE9BZt0CYOw1nHAEbK
         r4OxQlvFyB8jEgeq8kch/hFjphDoJQTTuhjQgf/dtLTVbjHsJnsD6bBUVxXleeNjOybQ
         2ROk79HktgnPvzuLO4fN0OxcxdVe5+PWeO0gSL+HSZEZm9NTZSyJ2ENvsbKZRafgVdr/
         /x/Q==
X-Gm-Message-State: AOAM530B0B3fJSnWWLbgtbbjLVYsbLYBIF8dknPIu0xjTrUoL3Y9suIX
        P8Y/EXARWzsqU5jeuyJ0vFA=
X-Google-Smtp-Source: ABdhPJyAQeWroLka6H8rh+GzFUTcHP8d2oF0uVvBtdl+vUV05X0VoUZCuItZeQaXerPlrVc5MKaF3w==
X-Received: by 2002:a05:6402:cb3:: with SMTP id cn19mr27894525edb.368.1595954100025;
        Tue, 28 Jul 2020 09:35:00 -0700 (PDT)
Received: from skbuf ([188.25.95.40])
        by smtp.gmail.com with ESMTPSA id j5sm4088297ejk.87.2020.07.28.09.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 09:34:59 -0700 (PDT)
Date:   Tue, 28 Jul 2020 19:34:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Matthew Hagan <mnhagan88@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: qca8k: Add 802.1q VLAN support
Message-ID: <20200728163457.imcrsuj7w2la5inp@skbuf>
References: <20200721171624.GK23489@earth.li>
 <20200726145611.GA31479@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726145611.GA31479@earth.li>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonathan,

On Sun, Jul 26, 2020 at 03:56:11PM +0100, Jonathan McDowell wrote:
> This adds full 802.1q VLAN support to the qca8k, allowing the use of
> vlan_filtering and more complicated bridging setups than allowed by
> basic port VLAN support.
> 
> Tested with a number of untagged ports with separate VLANs and then a
> trunk port with all the VLANs tagged on it.
> 
> v2:
> - Return sensible errnos on failure rather than -1 (rmk)
> - Style cleanups based on Florian's feedback
> - Silently allow VLAN 0 as device correctly treats this as no tag
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>
> ---

This generally looks ok. The integration with the APIs is fine.
Some comments below.

>  drivers/net/dsa/qca8k.c | 191 ++++++++++++++++++++++++++++++++++++++--
>  drivers/net/dsa/qca8k.h |  28 ++++++
>  2 files changed, 214 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index a5566de82853..1cc61bc8929f 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -408,6 +408,111 @@ qca8k_fdb_flush(struct qca8k_priv *priv)
>  	mutex_unlock(&priv->reg_mutex);
>  }
>  
> +static int
> +qca8k_vlan_access(struct qca8k_priv *priv, enum qca8k_vlan_cmd cmd, u16 vid)
> +{
> +	u32 reg;
> +
> +	/* Set the command and VLAN index */
> +	reg = QCA8K_VTU_FUNC1_BUSY;
> +	reg |= cmd;
> +	reg |= vid << QCA8K_VTU_FUNC1_VID_S;
> +
> +	/* Write the function register triggering the table access */
> +	qca8k_write(priv, QCA8K_REG_VTU_FUNC1, reg);
> +
> +	/* wait for completion */
> +	if (qca8k_busy_wait(priv, QCA8K_REG_VTU_FUNC1, QCA8K_VTU_FUNC1_BUSY))
> +		return -ETIMEDOUT;
> +
> +	/* Check for table full violation when adding an entry */
> +	if (cmd == QCA8K_VLAN_LOAD) {
> +		reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC1);
> +		if (reg & QCA8K_VTU_FUNC1_FULL)
> +			return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool tagged)

It is customary to keep referring to this bool as 'untagged' for
consistency with many other parts of the kernel.

> +{
> +	u32 reg;
> +	int ret;
> +
> +	/* We do the right thing with VLAN 0 and treat it as untagged */

...while also preserving the tag on egress.

> +	if (vid == 0)
> +		return 0;
> +
> +	mutex_lock(&priv->reg_mutex);

Unrelated, but what's the purpose of this mutex?

> +	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
> +	if (ret < 0)
> +		goto out;
> +
> +	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
> +	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
> +	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
> +	if (tagged)
> +		reg |= QCA8K_VTU_FUNC0_EG_MODE_TAG <<
> +				QCA8K_VTU_FUNC0_EG_MODE_S(port);
> +	else
> +		reg |= QCA8K_VTU_FUNC0_EG_MODE_UNTAG <<
> +				QCA8K_VTU_FUNC0_EG_MODE_S(port);
> +

Not thrilled about the "3 <<" thing, maybe a definition like the one
below would look better:

#define QCA8K_VTU_FUNC_REG0_EG_VLAN_MODE_MASK(port) \
	GENMASK(5 + (port) * 2, 4 + (port) * 2)

...

	int eg_vlan_mode = QCA8K_VTU_FUNC_REG0_EG_MODE_TAG;

	reg &= ~QCA8K_VTU_FUNC_REG0_EG_VLAN_MODE_MASK(port);
	if (tagged)
		eg_vlan_mode = QCA8K_VTU_FUNC_REG0_EG_MODE_UNTAG;
	reg |= QCA8K_VTU_FUNC_REG0_EG_MODE(eg_vlan_mode, port);

Your call if you want to change this, though.

> +	qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
> +	ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
> +
> +out:
> +	mutex_unlock(&priv->reg_mutex);
> +
> +	return ret;
> +}
> +
> +static int
> +qca8k_vlan_del(struct qca8k_priv *priv, u8 port, u16 vid)
> +{
> +	u32 reg;
> +	u32 mask;
> +	int ret;
> +	int i;
> +	bool del;

How about:

	u32 reg, mask;
	int ret, i;
	bool del;

> +
> +	mutex_lock(&priv->reg_mutex);
> +	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
> +	if (ret < 0)
> +		goto out;
> +
> +	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
> +	reg &= ~(3 << QCA8K_VTU_FUNC0_EG_MODE_S(port));
> +	reg |= QCA8K_VTU_FUNC0_EG_MODE_NOT <<
> +			QCA8K_VTU_FUNC0_EG_MODE_S(port);
> +
> +	/* Check if we're the last member to be removed */
> +	del = true;
> +	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
> +		mask = QCA8K_VTU_FUNC0_EG_MODE_NOT;
> +		mask <<= QCA8K_VTU_FUNC0_EG_MODE_S(i);
> +
> +		if ((reg & mask) != mask) {
> +			del = false;
> +			break;
> +		}
> +	}
> +
> +	if (del) {
> +		ret = qca8k_vlan_access(priv, QCA8K_VLAN_PURGE, vid);
> +	} else {
> +		qca8k_write(priv, QCA8K_REG_VTU_FUNC0, reg);
> +		ret = qca8k_vlan_access(priv, QCA8K_VLAN_LOAD, vid);
> +	}
> +
> +out:
> +	mutex_unlock(&priv->reg_mutex);
> +
> +	return ret;
> +}
> +
>  static void
>  qca8k_mib_init(struct qca8k_priv *priv)
>  {
> @@ -663,10 +768,11 @@ qca8k_setup(struct dsa_switch *ds)
>  			 * default egress vid
>  			 */
>  			qca8k_rmw(priv, QCA8K_EGRESS_VLAN(i),
> -				  0xffff << shift, 1 << shift);
> +				  0xffff << shift,
> +				  QCA8K_PORT_VID_DEF << shift);

This has telltale signs of copy-pasted code. ROUTER_DEFAULT_VID is a
12-bit register, so 0xffff is probably not the right mask. But, it is
true that the upper 4 bits are reserved, so it isn't quite a bug to
zero them out, just something that sticks out as not correct.

>  			qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(i),
> -				    QCA8K_PORT_VLAN_CVID(1) |
> -				    QCA8K_PORT_VLAN_SVID(1));
> +				    QCA8K_PORT_VLAN_CVID(QCA8K_PORT_VID_DEF) |
> +				    QCA8K_PORT_VLAN_SVID(QCA8K_PORT_VID_DEF));
>  		}
>  	}
>  
> @@ -1133,7 +1239,7 @@ qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
>  {
>  	/* Set the vid to the port vlan id if no vid is set */
>  	if (!vid)
> -		vid = 1;
> +		vid = QCA8K_PORT_VID_DEF;
>  
>  	return qca8k_fdb_add(priv, addr, port_mask, vid,
>  			     QCA8K_ATU_STATUS_STATIC);
> @@ -1157,7 +1263,7 @@ qca8k_port_fdb_del(struct dsa_switch *ds, int port,
>  	u16 port_mask = BIT(port);
>  
>  	if (!vid)
> -		vid = 1;
> +		vid = QCA8K_PORT_VID_DEF;

Maybe you could split out this s/1/QCA8K_PORT_VID_DEF/g patch into a
separate one? For the purpose of the introduction of VLAN callbacks,
it's just noise.

>  
>  	return qca8k_fdb_del(priv, addr, port_mask, vid);
>  }
> @@ -1186,6 +1292,76 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
>  	return 0;
>  }
>  
> +static int
> +qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +
> +	if (vlan_filtering) {
> +		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> +			  QCA8K_PORT_LOOKUP_VLAN_MODE,
> +			  QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE);
> +	} else {
> +		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
> +			  QCA8K_PORT_LOOKUP_VLAN_MODE,
> +			  QCA8K_PORT_LOOKUP_VLAN_MODE_NONE);
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +qca8k_port_vlan_prepare(struct dsa_switch *ds, int port,
> +			const struct switchdev_obj_port_vlan *vlan)
> +{
> +	return 0;
> +}
> +
> +static void
> +qca8k_port_vlan_add(struct dsa_switch *ds, int port,
> +		    const struct switchdev_obj_port_vlan *vlan)
> +{
> +	struct qca8k_priv *priv = ds->priv;

Reverse Christmas notation please.

> +	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> +	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
> +	u16 vid;
> +	int ret = 0;

here too.

> +
> +	for (vid = vlan->vid_begin; vid <= vlan->vid_end && !ret; ++vid)
> +		ret = qca8k_vlan_add(priv, port, vid, !untagged);
> +
> +	if (ret)
> +		dev_err(priv->dev, "Failed to add VLAN to port %d (%d)", port, ret);
> +

If for some reason there is a temporary failure in qca8k_vlan_add, you'd
be swallowing it instead of printing the error and stopping the
execution.

> +	if (pvid) {
> +		int shift = 16 * (port % 2);
> +
> +		qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),

What's up with this name? Why not "ROUTER_DEFAULT_VID" which is how the
hardware calls it? I had some trouble finding it.

> +			  0xffff << shift,
> +			  vlan->vid_end << shift);
> +		qca8k_write(priv, QCA8K_REG_PORT_VLAN_CTRL0(port),
> +			    QCA8K_PORT_VLAN_CVID(vlan->vid_end) |
> +			    QCA8K_PORT_VLAN_SVID(vlan->vid_end));
> +	}
> +}
> +
> +static int
> +qca8k_port_vlan_del(struct dsa_switch *ds, int port,
> +		    const struct switchdev_obj_port_vlan *vlan)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	u16 vid;
> +	int ret = 0;

Reverse Christmas notation please.

> +
> +	for (vid = vlan->vid_begin; vid <= vlan->vid_end && !ret; ++vid)
> +		ret = qca8k_vlan_del(priv, port, vid);
> +
> +	if (ret)
> +		dev_err(priv->dev, "Failed to delete VLAN from port %d (%d)", port, ret);

Same comment, could you move the "if" inside the "for"?

> +
> +	return ret;
> +}
> +
>  static enum dsa_tag_protocol
>  qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
>  		       enum dsa_tag_protocol mp)
> @@ -1211,6 +1387,10 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.port_fdb_add		= qca8k_port_fdb_add,
>  	.port_fdb_del		= qca8k_port_fdb_del,
>  	.port_fdb_dump		= qca8k_port_fdb_dump,
> +	.port_vlan_filtering	= qca8k_port_vlan_filtering,
> +	.port_vlan_prepare	= qca8k_port_vlan_prepare,
> +	.port_vlan_add		= qca8k_port_vlan_add,
> +	.port_vlan_del		= qca8k_port_vlan_del,
>  	.phylink_validate	= qca8k_phylink_validate,
>  	.phylink_mac_link_state	= qca8k_phylink_mac_link_state,
>  	.phylink_mac_config	= qca8k_phylink_mac_config,
> @@ -1261,6 +1441,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
>  
>  	priv->ds->dev = &mdiodev->dev;
>  	priv->ds->num_ports = QCA8K_NUM_PORTS;
> +	priv->ds->configure_vlan_while_not_filtering = true;

Nice that you've enabled this. Thanks.

>  	priv->ds->priv = priv;
>  	priv->ops = qca8k_switch_ops;
>  	priv->ds->ops = &priv->ops;
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index 31439396401c..4e96275cbc3e 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -22,6 +22,8 @@
>  
>  #define QCA8K_CPU_PORT					0
>  
> +#define QCA8K_PORT_VID_DEF				1
> +
>  /* Global control registers */
>  #define QCA8K_REG_MASK_CTRL				0x000
>  #define   QCA8K_MASK_CTRL_ID_M				0xff
> @@ -126,6 +128,18 @@
>  #define   QCA8K_ATU_FUNC_FULL				BIT(12)
>  #define   QCA8K_ATU_FUNC_PORT_M				0xf
>  #define   QCA8K_ATU_FUNC_PORT_S				8
> +#define QCA8K_REG_VTU_FUNC0				0x610
> +#define   QCA8K_VTU_FUNC0_VALID				BIT(20)
> +#define   QCA8K_VTU_FUNC0_IVL_EN			BIT(19)
> +#define   QCA8K_VTU_FUNC0_EG_MODE_S(_i)			(4 + (_i) * 2)
> +#define   QCA8K_VTU_FUNC0_EG_MODE_UNMOD			0
> +#define   QCA8K_VTU_FUNC0_EG_MODE_UNTAG			1
> +#define   QCA8K_VTU_FUNC0_EG_MODE_TAG			2
> +#define   QCA8K_VTU_FUNC0_EG_MODE_NOT			3
> +#define QCA8K_REG_VTU_FUNC1				0x614
> +#define   QCA8K_VTU_FUNC1_BUSY				BIT(31)
> +#define   QCA8K_VTU_FUNC1_VID_S				16
> +#define   QCA8K_VTU_FUNC1_FULL				BIT(4)
>  #define QCA8K_REG_GLOBAL_FW_CTRL0			0x620
>  #define   QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN		BIT(10)
>  #define QCA8K_REG_GLOBAL_FW_CTRL1			0x624
> @@ -135,6 +149,11 @@
>  #define   QCA8K_GLOBAL_FW_CTRL1_UC_DP_S			0
>  #define QCA8K_PORT_LOOKUP_CTRL(_i)			(0x660 + (_i) * 0xc)
>  #define   QCA8K_PORT_LOOKUP_MEMBER			GENMASK(6, 0)
> +#define   QCA8K_PORT_LOOKUP_VLAN_MODE			GENMASK(9, 8)
> +#define   QCA8K_PORT_LOOKUP_VLAN_MODE_NONE		(0 << 8)
> +#define   QCA8K_PORT_LOOKUP_VLAN_MODE_FALLBACK		(1 << 8)
> +#define   QCA8K_PORT_LOOKUP_VLAN_MODE_CHECK		(2 << 8)
> +#define   QCA8K_PORT_LOOKUP_VLAN_MODE_SECURE		(3 << 8)
>  #define   QCA8K_PORT_LOOKUP_STATE_MASK			GENMASK(18, 16)
>  #define   QCA8K_PORT_LOOKUP_STATE_DISABLED		(0 << 16)
>  #define   QCA8K_PORT_LOOKUP_STATE_BLOCKING		(1 << 16)
> @@ -178,6 +197,15 @@ enum qca8k_fdb_cmd {
>  	QCA8K_FDB_SEARCH = 7,
>  };
>  
> +enum qca8k_vlan_cmd {
> +	QCA8K_VLAN_FLUSH = 1,
> +	QCA8K_VLAN_LOAD = 2,
> +	QCA8K_VLAN_PURGE = 3,
> +	QCA8K_VLAN_REMOVE_PORT = 4,
> +	QCA8K_VLAN_NEXT = 5,
> +	QCA8K_VLAN_READ = 6,
> +};
> +
>  struct ar8xxx_port_status {
>  	int enabled;
>  };
> -- 
> 2.20.1

Thanks,
-Vladimir
