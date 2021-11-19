Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9356F4567E3
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhKSCQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbhKSCQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:16:27 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47F4C061574;
        Thu, 18 Nov 2021 18:13:26 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id x15so35948575edv.1;
        Thu, 18 Nov 2021 18:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H2cyb+c38LT4Pcdjf4ornce2n8zGkJkEM84hWSAeB1E=;
        b=JFfdyDSoCQX3aQdiwnHL6v2YL/Ox8EXwNuz/QVsKycDqNgFbT1fliW2RbyIs4ooX5g
         fv7bT7hTUI/DbIrdh28cdClPIS98laCr3PFnH6ALTfVpsT3X+prvFnWibVlQfpZFMtM7
         gZmQk4205QW2iu83TUoZMaByJZRCgNWC1V8w5oN6rc6Q4SpEx+0eYOJ22Qv+EHQ2xpCK
         jIzZP3r20QarMUDk+7iKhP3VAVA1Tk7DCe9+jfkyqJVBCdzUlsMdPhAegD+kqlnjTCjm
         r3KcC9AvXZQoBm9qP3e4Zr1U4iCwpLk2A9QRHYJTnKoqq4kkrYddDNk3SszINiMKiij0
         J2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H2cyb+c38LT4Pcdjf4ornce2n8zGkJkEM84hWSAeB1E=;
        b=b1jFVcVU7IF5/V5YdV4madpT1ZiX3jWtbDkpAsaFqakCXHB47/h4VVcPAc0IIjT+3+
         tL+9UABgq4ecmkU5UtKLV5wYRxyKMe0Olw4s+M76fT16+55ONssorQ/3wHZzSfPPE+33
         rmBXEwpStfnr6K1H/VVbNvb7YZ5iTt7Ghw5pG9yKodXJZ3ZJes5Z+8ywrRhhJKsr5P3z
         vQLYoD6IapVj/rp04qFv/rB5dEMcnq5esSrqToh/3Rdj6xjalvhoLJ0ysJ/IH5DosfC4
         r6iA8eGoutP2u0+eoK2ck1IJP8yOa8MP+qla2Qm2jJ5Ycw8QQSzKkqvJOwuuivQqOCXV
         Nhlg==
X-Gm-Message-State: AOAM530YeIQtr9q1IFSxDRu8Cd4VNsww4xYhbt39QtZE1YlpiLnyMLHP
        Gkzt231aUhJ4CDa1bq7QDsc=
X-Google-Smtp-Source: ABdhPJwI4ub0tt1MHJ5rvjz3UMayKaYN5QItgyAqYGzvXMIfag6XiU3aw5qWpKsUfqs1KA79HSpscw==
X-Received: by 2002:a17:907:6287:: with SMTP id nd7mr2930462ejc.152.1637288005080;
        Thu, 18 Nov 2021 18:13:25 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id ho30sm568257ejc.30.2021.11.18.18.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:13:24 -0800 (PST)
Date:   Fri, 19 Nov 2021 04:13:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 15/19] net: dsa: qca8k: add LAG support
Message-ID: <20211119021323.jdrgxqq27cqvkwn6@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-16-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-16-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:04:47PM +0100, Ansuel Smith wrote:
> Add LAG support to this switch. In Documentation this is described as
> trunk mode. A max of 4 LAGs are supported and each can support up to 4
> port. The only tx mode supported is Hash mode and no reference is
> present for active backup or any other mode in Documentation.
> When no port are present in the trunk, the trunk is disabled in the
> switch.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 117 ++++++++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/qca8k.h |  24 +++++++++
>  2 files changed, 141 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index a217c842ab45..c3234988aabf 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1312,6 +1312,9 @@ qca8k_setup(struct dsa_switch *ds)
>  	ds->ageing_time_min = 7000;
>  	ds->ageing_time_max = 458745000;
>  
> +	/* Set max number of LAGs supported */
> +	ds->num_lag_ids = QCA8K_NUM_LAGS;
> +
>  	return 0;
>  }
>  
> @@ -2220,6 +2223,118 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
>  	return DSA_TAG_PROTO_QCA;
>  }
>  
> +static bool
> +qca8k_lag_can_offload(struct dsa_switch *ds,
> +		      struct net_device *lag,
> +		      struct netdev_lag_upper_info *info)
> +{
> +	struct dsa_port *dp;
> +	int id, members = 0;
> +
> +	id = dsa_lag_id(ds->dst, lag);
> +	if (id < 0 || id >= ds->num_lag_ids)
> +		return false;
> +
> +	dsa_lag_foreach_port(dp, ds->dst, lag)
> +		/* Includes the port joining the LAG */
> +		members++;
> +
> +	if (members > QCA8K_NUM_PORTS_FOR_LAG)
> +		return false;
> +
> +	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
> +		return false;

You'll get bonus points if you also validate info->hash_type.

> +
> +	return true;
> +}
> +
> +static int
> +qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
> +			  struct net_device *lag, bool delete)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	int ret, id, i;
> +	u32 val;
> +
> +	id = dsa_lag_id(ds->dst, lag);
> +
> +	/* Read current port member */
> +	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
> +	if (ret)
> +		return ret;
> +
> +	/* Shift val to the correct trunk */
> +	val >>= QCA8K_REG_GOL_TRUNK_SHIFT(id);
> +	val &= QCA8K_REG_GOL_TRUNK_MEMBER_MASK;
> +	if (delete)
> +		val &= ~BIT(port);
> +	else
> +		val |= BIT(port);
> +
> +	/* Update port member. With empty portmap disable trunk */
> +	ret = regmap_update_bits(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0,
> +				 QCA8K_REG_GOL_TRUNK_MEMBER(id) |
> +				 QCA8K_REG_GOL_TRUNK_EN(id),
> +				 !val << QCA8K_REG_GOL_TRUNK_SHIFT(id) |
> +				 val << QCA8K_REG_GOL_TRUNK_SHIFT(id));
> +
> +	/* Search empty member if adding or port on deleting */
> +	for (i = 0; i < 4; i++) {
> +		ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL(id), &val);
> +		if (ret)
> +			return ret;
> +
> +		val >>= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i);
> +		val &= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_MASK;
> +
> +		if (delete) {
> +			/* If port flagged to be disabled assume this member is
> +			 * empty
> +			 */
> +			if (val != QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK)
> +				continue;
> +
> +			val &= QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT_MASK;
> +			if (val != port)
> +				continue;
> +		} else {
> +			/* If port flagged to be enabled assume this member is
> +			 * already set
> +			 */
> +			if (val == QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK)
> +				continue;
> +		}
> +
> +		/* We find the member to remove */
> +		break;
> +	}
> +
> +	/* Set port in the correct port mask or disable port if in delate mode */
> +	return regmap_update_bits(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL(id),
> +				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN(id, i) |
> +				  QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT(id, i),
> +				  !delete << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i) |
> +				  port << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(id, i));
> +}
> +
> +static int
> +qca8k_port_lag_join(struct dsa_switch *ds, int port,
> +		    struct net_device *lag,
> +		    struct netdev_lag_upper_info *info)
> +{
> +	if (!qca8k_lag_can_offload(ds, lag, info))
> +		return -EOPNOTSUPP;
> +
> +	return qca8k_lag_refresh_portmap(ds, port, lag, false);
> +}
> +
> +static int
> +qca8k_port_lag_leave(struct dsa_switch *ds, int port,
> +		     struct net_device *lag)
> +{
> +	return qca8k_lag_refresh_portmap(ds, port, lag, true);
> +}
> +
>  static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.get_tag_protocol	= qca8k_get_tag_protocol,
>  	.setup			= qca8k_setup,
> @@ -2253,6 +2368,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.phylink_mac_link_down	= qca8k_phylink_mac_link_down,
>  	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
>  	.get_phy_flags		= qca8k_get_phy_flags,
> +	.port_lag_join		= qca8k_port_lag_join,
> +	.port_lag_leave		= qca8k_port_lag_leave,

If you unplug a cable from the LAG, does the traffic that was going
through that port automatically get rebalanced towards the other ports
that are left? If not, shouldn't you also implement ->port_lag_change?

>  };
>  
>  static int
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index e1298179d7cb..5310022569f3 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -15,6 +15,8 @@
>  #define QCA8K_NUM_PORTS					7
>  #define QCA8K_NUM_CPU_PORTS				2
>  #define QCA8K_MAX_MTU					9000
> +#define QCA8K_NUM_LAGS					4
> +#define QCA8K_NUM_PORTS_FOR_LAG				4
>  
>  #define PHY_ID_QCA8327					0x004dd034
>  #define QCA8K_ID_QCA8327				0x12
> @@ -204,6 +206,28 @@
>  #define   QCA8K_PORT_LOOKUP_LEARN			BIT(20)
>  #define   QCA8K_PORT_LOOKUP_ING_MIRROR_EN		BIT(25)
>  
> +#define QCA8K_REG_GOL_TRUNK_CTRL0			0x700
> +/* 4 max trunk first
> + * first 6 bit for member bitmap
> + * 7th bit is to enable trunk port
> + */
> +#define QCA8K_REG_GOL_TRUNK_SHIFT(_i)			((_i) * 8)
> +#define QCA8K_REG_GOL_TRUNK_EN_MASK			BIT(7)
> +#define QCA8K_REG_GOL_TRUNK_EN(_i)			(QCA8K_REG_GOL_TRUNK_EN_MASK << QCA8K_REG_GOL_TRUNK_SHIFT(_i))
> +#define QCA8K_REG_GOL_TRUNK_MEMBER_MASK			GENMASK(6, 0)
> +#define QCA8K_REG_GOL_TRUNK_MEMBER(_i)			(QCA8K_REG_GOL_TRUNK_MEMBER_MASK << QCA8K_REG_GOL_TRUNK_SHIFT(_i))
> +/* 0x704 for TRUNK 0-1 --- 0x708 for TRUNK 2-3 */
> +#define QCA8K_REG_GOL_TRUNK_CTRL(_i)			(0x704 + (((_i) / 2) * 4))
> +#define QCA8K_REG_GOL_TRUNK_ID_MEM_ID_MASK		GENMASK(3, 0)
> +#define QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK		BIT(3)
> +#define QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT_MASK		GENMASK(2, 0)
> +#define QCA8K_REG_GOL_TRUNK_ID_SHIFT(_i)		(((_i) / 2) * 16)
> +#define QCA8K_REG_GOL_MEM_ID_SHIFT(_i)			((_i) * 4)
> +/* Complex shift: FIRST shift for port THEN shift for trunk */
> +#define QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(_i, _j)	(QCA8K_REG_GOL_MEM_ID_SHIFT(_j) + QCA8K_REG_GOL_TRUNK_ID_SHIFT(_i))
> +#define QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN(_i, _j)	(QCA8K_REG_GOL_TRUNK_ID_MEM_ID_EN_MASK << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(_i, _j))
> +#define QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT(_i, _j)	(QCA8K_REG_GOL_TRUNK_ID_MEM_ID_PORT_MASK << QCA8K_REG_GOL_TRUNK_ID_MEM_ID_SHIFT(_i, _j))
> +
>  #define QCA8K_REG_GLOBAL_FC_THRESH			0x800
>  #define   QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK		GENMASK(24, 16)
>  #define   QCA8K_GLOBAL_FC_GOL_XON_THRES(x)		FIELD_PREP(QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK, x)
> -- 
> 2.32.0
> 

