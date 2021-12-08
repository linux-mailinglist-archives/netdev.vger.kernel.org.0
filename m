Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624D146D324
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 13:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbhLHMW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 07:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhLHMWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 07:22:25 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92DAC061746;
        Wed,  8 Dec 2021 04:18:53 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z5so7806359edd.3;
        Wed, 08 Dec 2021 04:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m1gSbwYDbT85QXf1xY1ZWKqAzX+4LtPtjGP9JT3ENiw=;
        b=nVsVQOzu0tF4GQn9BuLlfxPY3jwhJdxY6g4CF9aezLSXMh9yjTjxlnYdVcrO+L2iSR
         IbR/L6XdTQEScWWuSCwyyiTJsNLqvguRQlfpgvawcYB9CWbrceE3BsVYzR7laO5vPMuz
         ltGv4/Y1bsHe33HqzGEB8txdSM1hweb8XXaftMkJrRFg39VQQ3Y1HhRHXv3S7T7WUqbY
         bDKZB6h/n8aPbOK0HgEvHkv3Y9bKpiARucSwG3Sh94ZzeQVW+ASuGN7x4AAFTUZ+cYEL
         zf3OXL8IZnwaK0MmZqWzomaNzoOZeSQy6dqqRbtqBlMDgGb+IEe7hTE1koIWgEVaDYka
         Bjsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m1gSbwYDbT85QXf1xY1ZWKqAzX+4LtPtjGP9JT3ENiw=;
        b=3w576Qxi10W08aEprpAm42r1EchtKlhcWioi0C5abMpBMfzgKqs8EYhT19m5BI7vBE
         KpKCKDbb4TNIEihrSZlquIN8YaBvhVXbdfzMv3o+lbQUdAmz2kkFsfg2zSdtZnUCOYil
         BQxhcdHTCsskaecz6Ppyofs206FwMzSk3SnB4B8SyUmevKfKkNdPsPP+WqwIlxS3yrMh
         TNIGZG0JBmT/7RYeMN7S3D0/tEhOxF/6xkgLLF4mPicbkgiAw5xLl3s6BZ80GPvXrv87
         AYMbqB61n1qF3OAoPQeuMPZvjrL8vIzECPPXOWTpZgdOc8zY8Nyo3pYish1ct7wtW6Au
         JSEA==
X-Gm-Message-State: AOAM5308WWbCrDN6XWS/GAzLtz+9AH3/ODSv/yENmseYyMNTWGJDyqeR
        nNJwprVVUGNYKKltsf1mNDTK4Fz8f4c=
X-Google-Smtp-Source: ABdhPJxTzoM6lXgEjL0dfUo4isbF7vzKLQunGrc0RRLGM8WKFfCiMxnmTy2GDjwh+0znd3of8i7t7Q==
X-Received: by 2002:a17:907:9156:: with SMTP id l22mr6952743ejs.220.1638965932182;
        Wed, 08 Dec 2021 04:18:52 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id n8sm2000230edy.4.2021.12.08.04.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 04:18:51 -0800 (PST)
Date:   Wed, 8 Dec 2021 14:18:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH v2 7/8] net: dsa: qca8k: Add support for
 mdio read/write in Ethernet packet
Message-ID: <20211208121850.b2khmvkqpygctaad@skbuf>
References: <20211208034040.14457-1-ansuelsmth@gmail.com>
 <20211208034040.14457-8-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208034040.14457-8-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:40:39AM +0100, Ansuel Smith wrote:
> Add qca8k side support for mdio read/write in Ethernet packet.
> qca8k supports some specially crafted Ethernet packet that can be used
> for mdio read/write instead of the legacy method uart/internal mdio.
> This add support for the qca8k side to craft the packet and enqueue it.
> Each port and the qca8k_priv have a special struct to put data in it.
> The completion API is used to wait for the packet to be received back
> with the requested data.
> 
> The various steps are:
> 1. Craft the special packet with the qca hdr set to mdio read/write
>    mode.
> 2. Set the lock in the dedicated mdio struct.
> 3. Reinit the completion.
> 4. Enqueue the packet.
> 5. Wait the packet to be received.
> 6. Use the data set by the tagger to complete the mdio operation.
> 
> If the completion timeouts or the ack value is not true, the legacy
> mdio way is used.
> 
> It has to be considered that in the initial setup mdio is still used and
> mdio is still used until DSA is ready to accept and tag packet.
> 
> tag_proto_connect() is used to fill the required handler for the tagger
> to correctly parse and elaborate the special Ethernet mdio packet.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c     | 214 +++++++++++++++++++++++++++++++++++-
>  drivers/net/dsa/qca8k.h     |   4 +
>  include/linux/dsa/tag_qca.h |  10 ++
>  3 files changed, 226 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 96a7fbf8700c..5b7508a6e4ba 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -20,6 +20,7 @@
>  #include <linux/phylink.h>
>  #include <linux/gpio/consumer.h>
>  #include <linux/etherdevice.h>
> +#include <linux/dsa/tag_qca.h>
>  
>  #include "qca8k.h"
>  
> @@ -170,14 +171,162 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
>  	return regmap_update_bits(priv->regmap, reg, mask, write_val);
>  }
>  
> +static struct sk_buff *qca8k_alloc_mdio_header(struct qca8k_port_tag *header, enum mdio_cmd cmd,
> +					       u32 reg, u32 *val)
> +{
> +	struct mdio_ethhdr *mdio_ethhdr;
> +	struct sk_buff *skb;
> +	u16 hdr;
> +
> +	skb = dev_alloc_skb(QCA_HDR_MDIO_PKG_LEN);
> +
> +	prefetchw(skb->data);
> +
> +	skb_reset_mac_header(skb);
> +	skb_set_network_header(skb, skb->len);
> +
> +	mdio_ethhdr = skb_push(skb, QCA_HDR_MDIO_HEADER_LEN + QCA_HDR_LEN);
> +
> +	hdr = FIELD_PREP(QCA_HDR_XMIT_VERSION, QCA_HDR_VERSION);
> +	hdr |= QCA_HDR_XMIT_FROM_CPU;
> +	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(0));
> +	hdr |= FIELD_PREP(QCA_HDR_XMIT_CONTROL, QCA_HDR_XMIT_TYPE_RW_REG);
> +
> +	mdio_ethhdr->seq = FIELD_PREP(QCA_HDR_MDIO_SEQ_NUM, 200);
> +
> +	mdio_ethhdr->command = FIELD_PREP(QCA_HDR_MDIO_ADDR, reg);
> +	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_LENGTH, 4);
> +	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_CMD, cmd);
> +	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_CHECK_CODE, MDIO_CHECK_CODE_VAL);
> +
> +	if (cmd == MDIO_WRITE)
> +		mdio_ethhdr->mdio_data = *val;
> +
> +	mdio_ethhdr->hdr = htons(hdr);
> +
> +	skb_put_zero(skb, QCA_HDR_MDIO_DATA2_LEN);
> +	skb_put_zero(skb, QCA_HDR_MDIO_PADDING_LEN);
> +
> +	return skb;
> +}
> +
> +static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
> +{
> +	struct qca8k_port_tag *header = priv->header_mdio;
> +	struct sk_buff *skb;
> +	bool ack;
> +	int ret;
> +
> +	skb = qca8k_alloc_mdio_header(header, MDIO_READ, reg, 0);
> +	skb->dev = dsa_to_port(priv->ds, 0)->master;
> +
> +	mutex_lock(&header->mdio_mutex);
> +
> +	reinit_completion(&header->rw_done);
> +	header->seq = 200;
> +	header->ack = false;
> +
> +	dev_queue_xmit(skb);
> +
> +	ret = wait_for_completion_timeout(&header->rw_done, QCA8K_MDIO_RW_ETHERNET);
> +
> +	*val = header->data[0];
> +	ack = header->ack;
> +
> +	mutex_unlock(&header->mdio_mutex);
> +
> +	if (ret <= 0)
> +		return -ETIMEDOUT;
> +
> +	if (!ack)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static void qca8k_rw_reg_ack_handler(struct dsa_port *dp, struct sk_buff *skb)
> +{
> +	struct qca8k_port_tag *header = dp->priv;
> +	struct mdio_ethhdr *mdio_ethhdr;
> +
> +	mdio_ethhdr = (struct mdio_ethhdr *)skb_mac_header(skb);
> +
> +	header->data[0] = mdio_ethhdr->mdio_data;
> +
> +	/* Get the rest of the 12 byte of data */
> +	memcpy(header->data + 1, skb->data, QCA_HDR_MDIO_DATA2_LEN);
> +
> +	/* Make sure the seq match the requested packet */
> +	if (mdio_ethhdr->seq == header->seq)
> +		header->ack = true;
> +
> +	complete(&header->rw_done);
> +}
> +
> +static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 val)
> +{
> +	struct qca8k_port_tag *header = priv->header_mdio;
> +	struct sk_buff *skb;
> +	bool ack;
> +	int ret;
> +
> +	skb = qca8k_alloc_mdio_header(header, MDIO_WRITE, reg, &val);
> +	skb->dev = dsa_to_port(priv->ds, 0)->master;
> +
> +	mutex_lock(&header->mdio_mutex);
> +
> +	dev_queue_xmit(skb);
> +
> +	reinit_completion(&header->rw_done);
> +	header->ack = false;
> +	header->seq = 200;
> +
> +	ret = wait_for_completion_timeout(&header->rw_done, QCA8K_MDIO_RW_ETHERNET);
> +
> +	ack = header->ack;
> +
> +	mutex_unlock(&header->mdio_mutex);
> +
> +	if (ret <= 0)
> +		return -ETIMEDOUT;
> +
> +	if (!ack)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int
> +qca8k_regmap_update_bits_eth(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
> +{
> +	u32 val = 0;
> +	int ret;
> +
> +	ret = qca8k_read_eth(priv, reg, &val);
> +	if (ret)
> +		return ret;
> +
> +	val &= ~mask;
> +	val |= write_val;
> +
> +	return qca8k_write_eth(priv, reg, val);
> +}
> +
>  static int
>  qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
>  {
>  	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
> +	struct qca8k_port_tag *header_mdio;
>  	struct mii_bus *bus = priv->bus;
>  	u16 r1, r2, page;
>  	int ret;
>  
> +	header_mdio = priv->header_mdio;
> +
> +	if (header_mdio)
> +		if (!qca8k_read_eth(priv, reg, val))
> +			return 0;
> +
>  	qca8k_split_addr(reg, &r1, &r2, &page);
>  
>  	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> @@ -197,10 +346,17 @@ static int
>  qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
>  {
>  	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
> +	struct qca8k_port_tag *header_mdio;
>  	struct mii_bus *bus = priv->bus;
>  	u16 r1, r2, page;
>  	int ret;
>  
> +	header_mdio = priv->header_mdio;
> +
> +	if (header_mdio)
> +		if (!qca8k_write_eth(priv, reg, val))
> +			return 0;
> +
>  	qca8k_split_addr(reg, &r1, &r2, &page);
>  
>  	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> @@ -220,11 +376,18 @@ static int
>  qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_val)
>  {
>  	struct qca8k_priv *priv = (struct qca8k_priv *)ctx;
> +	struct qca8k_port_tag *header_mdio;
>  	struct mii_bus *bus = priv->bus;
>  	u16 r1, r2, page;
>  	u32 val;
>  	int ret;
>  
> +	header_mdio = priv->header_mdio;
> +
> +	if (header_mdio)
> +		if (!qca8k_regmap_update_bits_eth(priv, reg, mask, write_val))
> +			return 0;
> +
>  	qca8k_split_addr(reg, &r1, &r2, &page);
>  
>  	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> @@ -1223,8 +1386,13 @@ qca8k_setup(struct dsa_switch *ds)
>  	 * Configure specific switch configuration for ports
>  	 */
>  	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
> +		struct dsa_port *dp = dsa_to_port(ds, i);
> +
> +		/* Set the header_mdio to be accessible by the qca tagger */
> +		dp->priv = priv->header_mdio;

Why are you setting up the dp->priv pointer from the switch driver?
I though the whole point of qca_tag_connect is to set up that memory by
itself.

> +
>  		/* CPU port gets connected to all user ports of the switch */
> -		if (dsa_is_cpu_port(ds, i)) {
> +		if (dsa_port_is_cpu(dp)) {
>  			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
>  					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
>  			if (ret)
> @@ -1232,7 +1400,7 @@ qca8k_setup(struct dsa_switch *ds)
>  		}
>  
>  		/* Individual user ports get connected to CPU port only */
> -		if (dsa_is_user_port(ds, i)) {
> +		if (dsa_port_is_user(dp)) {
>  			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
>  					QCA8K_PORT_LOOKUP_MEMBER,
>  					BIT(cpu_port));
> @@ -2382,6 +2550,38 @@ qca8k_port_lag_leave(struct dsa_switch *ds, int port,
>  	return qca8k_lag_refresh_portmap(ds, port, lag, true);
>  }
>  
> +static int qca8k_tag_proto_connect(struct dsa_switch *ds,
> +				   const struct dsa_device_ops *tag_ops)
> +{
> +	struct qca8k_priv *qca8k_priv = ds->priv;
> +	struct qca8k_port_tag *priv;
> +	struct dsa_port *dp;
> +	int i;
> +
> +	switch (tag_ops->proto) {
> +	case DSA_TAG_PROTO_QCA:
> +		for (i = 0; i < QCA8K_NUM_PORTS; i++) {
> +			dp = dsa_to_port(ds, i);
> +			priv = dp->priv;
> +
> +			if (!dsa_port_is_cpu(dp))
> +				continue;
> +
> +			mutex_init(&priv->mdio_mutex);
> +			init_completion(&priv->rw_done);
> +			/* Cache the header mdio */
> +			qca8k_priv->header_mdio = priv;
> +			priv->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
> +		}
> +
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
>  static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.get_tag_protocol	= qca8k_get_tag_protocol,
>  	.setup			= qca8k_setup,
> @@ -2417,6 +2617,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.get_phy_flags		= qca8k_get_phy_flags,
>  	.port_lag_join		= qca8k_port_lag_join,
>  	.port_lag_leave		= qca8k_port_lag_leave,
> +	.tag_proto_connect	= qca8k_tag_proto_connect,
>  };
>  
>  static int qca8k_read_switch_id(struct qca8k_priv *priv)
> @@ -2452,6 +2653,7 @@ static int qca8k_read_switch_id(struct qca8k_priv *priv)
>  static int
>  qca8k_sw_probe(struct mdio_device *mdiodev)
>  {
> +	struct qca8k_port_tag *header_mdio;
>  	struct qca8k_priv *priv;
>  	int ret;
>  
> @@ -2462,6 +2664,13 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
>  	if (!priv)
>  		return -ENOMEM;
>  
> +	header_mdio = devm_kzalloc(&mdiodev->dev, sizeof(*header_mdio), GFP_KERNEL);
> +	if (!header_mdio)
> +		return -ENOMEM;
> +
> +	mutex_init(&header_mdio->mdio_mutex);
> +	init_completion(&header_mdio->rw_done);
> +
>  	priv->bus = mdiodev->bus;
>  	priv->dev = &mdiodev->dev;
>  
> @@ -2501,6 +2710,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
>  	priv->ds->priv = priv;
>  	priv->ops = qca8k_switch_ops;
>  	priv->ds->ops = &priv->ops;
> +	priv->header_mdio = header_mdio;
>  	mutex_init(&priv->reg_mutex);
>  	dev_set_drvdata(&mdiodev->dev, priv);
>  
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index ab4a417b25a9..25aa1509e0c0 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -11,6 +11,9 @@
>  #include <linux/delay.h>
>  #include <linux/regmap.h>
>  #include <linux/gpio.h>
> +#include <linux/dsa/tag_qca.h>
> +
> +#define QCA8K_MDIO_RW_ETHERNET				100
>  
>  #define QCA8K_NUM_PORTS					7
>  #define QCA8K_NUM_CPU_PORTS				2
> @@ -353,6 +356,7 @@ struct qca8k_priv {
>  	struct dsa_switch_ops ops;
>  	struct gpio_desc *reset_gpio;
>  	unsigned int port_mtu[QCA8K_NUM_PORTS];
> +	struct qca8k_port_tag *header_mdio;
>  };
>  
>  struct qca8k_mib_desc {
> diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
> index f403fdab6f29..2b823d971ae9 100644
> --- a/include/linux/dsa/tag_qca.h
> +++ b/include/linux/dsa/tag_qca.h
> @@ -59,11 +59,21 @@ struct mdio_ethhdr {
>  	u16 hdr;		/* qca hdr */
>  } __packed;
>  
> +enum mdio_cmd {
> +	MDIO_WRITE = 0x0,
> +	MDIO_READ
> +};
> +
>  struct qca8k_port_tag {
>  	void (*rw_reg_ack_handler)(struct dsa_port *dp,
>  				   struct sk_buff *skb);
>  	void (*mib_autocast_handler)(struct dsa_port *dp,
>  				     struct sk_buff *skb);
> +	struct completion rw_done;
> +	struct mutex mdio_mutex; /* Enforce one mdio read/write at time */
> +	bool ack;
> +	u32 seq;
> +	u32 data[4];

None of these structures need to stay in the data structure shared with
the tagger. They can be in qca8k_priv. The tagger should only see the
function pointers. It doesn't care what is done with the packets.

>  };
>  
>  #endif /* __TAG_QCA_H */
> -- 
> 2.32.0
> 
