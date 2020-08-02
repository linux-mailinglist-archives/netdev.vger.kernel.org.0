Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A7D23570F
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 15:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgHBNVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 09:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgHBNVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 09:21:14 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA02C06174A;
        Sun,  2 Aug 2020 06:21:14 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id v22so14604538edy.0;
        Sun, 02 Aug 2020 06:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jwoo2TS7fsitinGpR1YTbyKPKRvA86wze2AcFk3x8ZQ=;
        b=UgR1pIvSxTkkHthYGkTsDWRj04NkAmEay1t85MTOpXlEhuL0nnVPARezHhiqXr6GZl
         gMyN34kPmmQ+LeFdKI1cG7P3x1TzbocdZsfwIQK7HkmRQW5ZxfXnHGv4zm0pWkIcGNo9
         Aeu9aemjq2n8RpSSJdc/x7+RsGKrNUwoHD7/ijY4zlUBKoShifH0oh2nTfrW7lCASUg0
         AW2EB0jasqO6+MPe0pzA5mg+V4DHdafwSRY5Iq4fnkDnOkAWOmRPBWUtks5By/fSU1Ug
         iehiaMOfhKQvaX/mS6feEFRKRblS4P1kXOrWOpmwwmRnk/rjvB2xJisIXfbCAvryesmD
         iN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jwoo2TS7fsitinGpR1YTbyKPKRvA86wze2AcFk3x8ZQ=;
        b=TdhNu3dOEmPW7CctzE+nsQyAlfRDbRmGWycPb4SfyNK1nNA3xsVqkFV7XFTiP5Kwli
         iObBM8yuU8pWIpBkJWLL5IzUF7DXZm+LqByRez8apXRL+7YX/JNZk0y9RsXXvrTltQfM
         dS0zicBNDKTKKYegjTrQXTosyfGeiE7wYXrijZtCl6lKVX3WwDPBSyT3cH9AeOiNEad7
         nLD4VWnBN4sp8R4WYal/AJc3C8ck6k3y7gOipaWQZfoE6QCPuze1N9gCiUMQMPBpT8Ot
         +HNPpqa/CewRq88BHIUkhYAJWD7JdfVsxImRvFu6m3rHEW3WP1jZ4V38nTuOud9r9KDN
         3Y7w==
X-Gm-Message-State: AOAM53016sp6fWXeKXfH4HLsv73pBKnaTclvWCqX27xOX3WbsDfM7ZUQ
        QRe1eU44rkt7wicuTj9uNhY=
X-Google-Smtp-Source: ABdhPJzL3p405vPIdYKnez83BYY452XPj8BaYw9e+nZeZuW7Lts2UJ6v/Bj0BV820k15Brij8fECXA==
X-Received: by 2002:a50:ccd0:: with SMTP id b16mr11597404edj.148.1596374470817;
        Sun, 02 Aug 2020 06:21:10 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id r19sm13523063edi.85.2020.08.02.06.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 06:21:10 -0700 (PDT)
Date:   Sun, 2 Aug 2020 16:21:07 +0300
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
Subject: Re: [PATCH net-next v3 2/2] net: dsa: qca8k: Add 802.1q VLAN support
Message-ID: <20200802132107.bf2zqj4mva2vqt47@skbuf>
References: <20200721171624.GK23489@earth.li>
 <ec320e8e5a9691b85ee79f6ef03f1b0b6a562655.1596301468.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec320e8e5a9691b85ee79f6ef03f1b0b6a562655.1596301468.git.noodles@earth.li>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 01, 2020 at 06:06:46PM +0100, Jonathan McDowell wrote:
> This adds full 802.1q VLAN support to the qca8k, allowing the use of
> vlan_filtering and more complicated bridging setups than allowed by
> basic port VLAN support.
> 
> Tested with a number of untagged ports with separate VLANs and then a
> trunk port with all the VLANs tagged on it.
> 
> v3:
> - Pull QCA8K_PORT_VID_DEF changes into separate cleanup patch
> - Reverse Christmas tree notation for variable definitions
> - Use untagged instead of tagged for consistency
> v2:
> - Return sensible errnos on failure rather than -1 (rmk)
> - Style cleanups based on Florian's feedback
> - Silently allow VLAN 0 as device correctly treats this as no tag
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>
> ---

My comments have been addressed, thanks.

Acked-by: Vladimir Oltean <olteanv@gmail.com>

>  drivers/net/dsa/qca8k.c | 181 ++++++++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/qca8k.h |  27 ++++++
>  2 files changed, 208 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 3ebc4da63074..f1e484477e35 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -408,6 +408,112 @@ qca8k_fdb_flush(struct qca8k_priv *priv)
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
> +qca8k_vlan_add(struct qca8k_priv *priv, u8 port, u16 vid, bool untagged)
> +{
> +	u32 reg;
> +	int ret;
> +
> +	/*
> +	   We do the right thing with VLAN 0 and treat it as untagged while
> +	   preserving the tag on egress.
> +	 */
> +	if (vid == 0)
> +		return 0;
> +
> +	mutex_lock(&priv->reg_mutex);
> +	ret = qca8k_vlan_access(priv, QCA8K_VLAN_READ, vid);
> +	if (ret < 0)
> +		goto out;
> +
> +	reg = qca8k_read(priv, QCA8K_REG_VTU_FUNC0);
> +	reg |= QCA8K_VTU_FUNC0_VALID | QCA8K_VTU_FUNC0_IVL_EN;
> +	reg &= ~(QCA8K_VTU_FUNC0_EG_MODE_MASK << QCA8K_VTU_FUNC0_EG_MODE_S(port));
> +	if (untagged)
> +		reg |= QCA8K_VTU_FUNC0_EG_MODE_UNTAG <<
> +				QCA8K_VTU_FUNC0_EG_MODE_S(port);
> +	else
> +		reg |= QCA8K_VTU_FUNC0_EG_MODE_TAG <<
> +				QCA8K_VTU_FUNC0_EG_MODE_S(port);
> +
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
> +	u32 reg, mask;
> +	int ret, i;
> +	bool del;
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
> @@ -1187,6 +1293,76 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
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
> +	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> +	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
> +	struct qca8k_priv *priv = ds->priv;
> +	int ret = 0;
> +	u16 vid;
> +
> +	for (vid = vlan->vid_begin; vid <= vlan->vid_end && !ret; ++vid)
> +		ret = qca8k_vlan_add(priv, port, vid, untagged);
> +
> +	if (ret)
> +		dev_err(priv->dev, "Failed to add VLAN to port %d (%d)", port, ret);
> +
> +	if (pvid) {
> +		int shift = 16 * (port % 2);
> +
> +		qca8k_rmw(priv, QCA8K_EGRESS_VLAN(port),
> +			  0xfff << shift,
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
> +	int ret = 0;
> +	u16 vid;
> +
> +	for (vid = vlan->vid_begin; vid <= vlan->vid_end && !ret; ++vid)
> +		ret = qca8k_vlan_del(priv, port, vid);
> +
> +	if (ret)
> +		dev_err(priv->dev, "Failed to delete VLAN from port %d (%d)", port, ret);
> +
> +	return ret;
> +}
> +
>  static enum dsa_tag_protocol
>  qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
>  		       enum dsa_tag_protocol mp)
> @@ -1212,6 +1388,10 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
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
> @@ -1262,6 +1442,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
>  
>  	priv->ds->dev = &mdiodev->dev;
>  	priv->ds->num_ports = QCA8K_NUM_PORTS;
> +	priv->ds->configure_vlan_while_not_filtering = true;
>  	priv->ds->priv = priv;
>  	priv->ops = qca8k_switch_ops;
>  	priv->ds->ops = &priv->ops;
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index 92216a52daa5..7ca4b93e0bb5 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -128,6 +128,19 @@
>  #define   QCA8K_ATU_FUNC_FULL				BIT(12)
>  #define   QCA8K_ATU_FUNC_PORT_M				0xf
>  #define   QCA8K_ATU_FUNC_PORT_S				8
> +#define QCA8K_REG_VTU_FUNC0				0x610
> +#define   QCA8K_VTU_FUNC0_VALID				BIT(20)
> +#define   QCA8K_VTU_FUNC0_IVL_EN			BIT(19)
> +#define   QCA8K_VTU_FUNC0_EG_MODE_S(_i)			(4 + (_i) * 2)
> +#define   QCA8K_VTU_FUNC0_EG_MODE_MASK			3
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
> @@ -137,6 +150,11 @@
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
> @@ -180,6 +198,15 @@ enum qca8k_fdb_cmd {
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
> 
