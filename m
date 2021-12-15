Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D35C47556D
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 10:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241282AbhLOJtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 04:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241278AbhLOJtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 04:49:16 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0999EC061574;
        Wed, 15 Dec 2021 01:49:16 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r11so71861711edd.9;
        Wed, 15 Dec 2021 01:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mr4/eJL1nEAM36IH9iztQH07NpQPmtVpZI9MCHDHkxQ=;
        b=hNf0PEAn3MlbdJfq5nqXm5yjh3SESapCQyFIxZ/VsbmHnkP3Pb274K9pgoXLhRhnCC
         Cu6/6e+BSdrty2YuAM4ean65IZ4x9txwGANHlSqAnJTDOq7CdbhAsdk9iVZ8Afg+mNrT
         r8ubhG5qPUDzL1NTl9wCkqqlQDHp/CHT0eXbYR0rqnp6McrjK9sUmmjM1pQ1HJkmoxGe
         SgbZejEu1W2AUeMS07lxJv3VFaZdiYcF7S97tm7wtHVGstqrB6zLkJX6074uws4A62IY
         jrKAx6jz394/C7G4U8wOX7rfqG+RSgnpFAHw7VeJbyS0lPu2roToCoMVO1TrYHxS08HY
         9How==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mr4/eJL1nEAM36IH9iztQH07NpQPmtVpZI9MCHDHkxQ=;
        b=n/y1j9TI33OyohIUFpcNKNVfnDuiYnVDSA3UySIBxhsHO3naVZnsc2CWNL9vXlANeR
         Rp7EslwSbFGLUqnJuD9e2HA6rdfMMgcfVzv78wXVkSgQFwXhHLQBTaax9o3033eQguUy
         81I7B45CdqP68MXzJtn1uQyf/gMm5JwDIP4lv5qO84KnSdSMM9FSYPpwZLQgwWdraI+P
         dvn8+VDThO11MYIgJQDBfOgRr9LU0KH1TydQbyrfvqO0oAONUbuA5Y6Gq2DsL7K3v2ml
         gqOmBDOkVMMfRP5uVsZuDsB0nvGfNVrMNyaO1QRLbBk0EgAAEt+AC0YpZ7LE7wXAVeKM
         KW9A==
X-Gm-Message-State: AOAM530fMmqN1BcIDAK0sbvCMVykVZwQYKtzvCTLivaTZ6whJqw1V04z
        XrUlqKY89J87HhkQ942u4oLX9jdW7A4=
X-Google-Smtp-Source: ABdhPJxT3PIavDEKuWa6l1JEcuQ5QLG+REQ1mUoehDpoC8rt+A0bP5y/zSiD/UttVPZd3+NsANefMA==
X-Received: by 2002:a05:6402:1453:: with SMTP id d19mr13550651edx.388.1639561754358;
        Wed, 15 Dec 2021 01:49:14 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id k16sm710040edq.77.2021.12.15.01.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 01:49:13 -0800 (PST)
Date:   Wed, 15 Dec 2021 11:49:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH RFC v6 12/16] net: dsa: qca8k: add support for
 mdio read/write in Ethernet packet
Message-ID: <20211215094912.gkqq4pfwac7gqeaa@skbuf>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
 <20211214224409.5770-13-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214224409.5770-13-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 11:44:05PM +0100, Ansuel Smith wrote:
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
> Locking is added to qca8k_master_change() to make sure no mdio Ethernet
> are in progress.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 192 ++++++++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/qca8k.h |  13 +++
>  2 files changed, 205 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index f317f527dd6d..b35ba26a0696 100644
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
> @@ -170,6 +171,158 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
>  	return regmap_update_bits(priv->regmap, reg, mask, write_val);
>  }
>  
> +static void qca8k_rw_reg_ack_handler(struct dsa_port *dp, struct sk_buff *skb)
> +{
> +	struct qca8k_mdio_hdr_data *mdio_hdr_data;
> +	struct qca8k_priv *priv = dp->ds->priv;
> +	struct mdio_ethhdr *mdio_ethhdr;
> +	u8 len, cmd;
> +
> +	mdio_ethhdr = (struct mdio_ethhdr *)skb_mac_header(skb);
> +	mdio_hdr_data = &priv->mdio_hdr_data;
> +
> +	cmd = FIELD_GET(QCA_HDR_MDIO_CMD, mdio_ethhdr->command);
> +	len = FIELD_GET(QCA_HDR_MDIO_LENGTH, mdio_ethhdr->command);
> +
> +	/* Make sure the seq match the requested packet */
> +	if (mdio_ethhdr->seq == mdio_hdr_data->seq)
> +		mdio_hdr_data->ack = true;
> +
> +	if (cmd == MDIO_READ) {
> +		mdio_hdr_data->data[0] = mdio_ethhdr->mdio_data;
> +
> +		/* Get the rest of the 12 byte of data */
> +		if (len > QCA_HDR_MDIO_DATA1_LEN)
> +			memcpy(mdio_hdr_data->data + 1, skb->data,
> +			       QCA_HDR_MDIO_DATA2_LEN);
> +	}
> +
> +	complete(&mdio_hdr_data->rw_done);
> +}
> +
> +static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
> +					       int seq_num, int priority)
> +{
> +	struct mdio_ethhdr *mdio_ethhdr;
> +	struct sk_buff *skb;
> +	u16 hdr;
> +
> +	skb = dev_alloc_skb(QCA_HDR_MDIO_PKG_LEN);

Still no if (!skb) checking... Not only here, but also at the call sites
of this.

> +
> +	skb_reset_mac_header(skb);
> +	skb_set_network_header(skb, skb->len);
> +
> +	mdio_ethhdr = skb_push(skb, QCA_HDR_MDIO_HEADER_LEN + QCA_HDR_LEN);
> +
> +	hdr = FIELD_PREP(QCA_HDR_XMIT_VERSION, QCA_HDR_VERSION);
> +	hdr |= FIELD_PREP(QCA_HDR_XMIT_PRIORITY, priority);
> +	hdr |= QCA_HDR_XMIT_FROM_CPU;
> +	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(0));
> +	hdr |= FIELD_PREP(QCA_HDR_XMIT_CONTROL, QCA_HDR_XMIT_TYPE_RW_REG);
> +
> +	mdio_ethhdr->seq = FIELD_PREP(QCA_HDR_MDIO_SEQ_NUM, seq_num);
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

Maybe a single call to skb_put_zero, and pass the sum as argument?

> +
> +	return skb;
> +}
> +
> +static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
> +{
> +	struct qca8k_mdio_hdr_data *mdio_hdr_data = &priv->mdio_hdr_data;
> +	struct sk_buff *skb;
> +	bool ack;
> +	int ret;
> +
> +	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200, QCA8K_ETHERNET_MDIO_PRIORITY);

You hardcode "seq" to 200? Aren't you supposed to increment it or
something?

> +	skb->dev = (struct net_device *)priv->master;

You access priv->master outside of priv->mdio_hdr_data.mutex from
qca8k_master_change(), that can't be good.

> +
> +	mutex_lock(&mdio_hdr_data->mutex);
> +
> +	reinit_completion(&mdio_hdr_data->rw_done);
> +	mdio_hdr_data->seq = 200;

Why do you rewrite the seq here?

> +	mdio_hdr_data->ack = false;
> +
> +	dev_queue_xmit(skb);
> +
> +	ret = wait_for_completion_timeout(&mdio_hdr_data->rw_done,
> +					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
> +
> +	*val = mdio_hdr_data->data[0];
> +	ack = mdio_hdr_data->ack;
> +
> +	mutex_unlock(&mdio_hdr_data->mutex);
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
> +static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 val)
> +{
> +	struct qca8k_mdio_hdr_data *mdio_hdr_data = &priv->mdio_hdr_data;
> +	struct sk_buff *skb;
> +	bool ack;
> +	int ret;
> +
> +	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, &val, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
> +	skb->dev = (struct net_device *)priv->master;
> +
> +	mutex_lock(&mdio_hdr_data->mutex);
> +
> +	reinit_completion(&mdio_hdr_data->rw_done);
> +	mdio_hdr_data->ack = false;
> +	mdio_hdr_data->seq = 200;
> +
> +	dev_queue_xmit(skb);
> +
> +	ret = wait_for_completion_timeout(&mdio_hdr_data->rw_done,
> +					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
> +
> +	ack = mdio_hdr_data->ack;
> +
> +	mutex_unlock(&mdio_hdr_data->mutex);
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
> @@ -178,6 +331,9 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
>  	u16 r1, r2, page;
>  	int ret;
>  
> +	if (priv->master && !qca8k_read_eth(priv, reg, val))
> +		return 0;
> +
>  	qca8k_split_addr(reg, &r1, &r2, &page);
>  
>  	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> @@ -201,6 +357,9 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
>  	u16 r1, r2, page;
>  	int ret;
>  
> +	if (priv->master && !qca8k_write_eth(priv, reg, val))
> +		return 0;
> +
>  	qca8k_split_addr(reg, &r1, &r2, &page);
>  
>  	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> @@ -225,6 +384,10 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
>  	u32 val;
>  	int ret;
>  
> +	if (priv->master &&
> +	    !qca8k_regmap_update_bits_eth(priv, reg, mask, write_val))
> +		return 0;
> +
>  	qca8k_split_addr(reg, &r1, &r2, &page);
>  
>  	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> @@ -2394,10 +2557,38 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
>  	if (dp->index != 0)
>  		return;
>  
> +	mutex_lock(&priv->mdio_hdr_data.mutex);
> +
>  	if (operational)
>  		priv->master = master;
>  	else
>  		priv->master = NULL;
> +
> +	mutex_unlock(&priv->mdio_hdr_data.mutex);
> +}
> +
> +static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
> +				      enum dsa_tag_protocol proto)
> +{
> +	struct qca8k_priv *qca8k_priv = ds->priv;
> +
> +	switch (proto) {
> +	case DSA_TAG_PROTO_QCA:
> +		struct tag_qca_priv *priv;
> +
> +		priv = ds->tagger_data;
> +
> +		mutex_init(&qca8k_priv->mdio_hdr_data.mutex);
> +		init_completion(&qca8k_priv->mdio_hdr_data.rw_done);

I think having these initializations here dilutes the purpose of this
callback. Could you please move these two lines to qca8k_sw_probe()?

> +
> +		priv->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
> +
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
>  }
>  
>  static const struct dsa_switch_ops qca8k_switch_ops = {
> @@ -2436,6 +2627,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.port_lag_join		= qca8k_port_lag_join,
>  	.port_lag_leave		= qca8k_port_lag_leave,
>  	.master_state_change	= qca8k_master_change,
> +	.connect_tag_protocol	= qca8k_connect_tag_protocol,
>  };
>  
>  static int qca8k_read_switch_id(struct qca8k_priv *priv)
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index 6edd6adc3063..dbe8c74c9793 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -11,6 +11,10 @@
>  #include <linux/delay.h>
>  #include <linux/regmap.h>
>  #include <linux/gpio.h>
> +#include <linux/dsa/tag_qca.h>
> +
> +#define QCA8K_ETHERNET_MDIO_PRIORITY			7
> +#define QCA8K_ETHERNET_TIMEOUT				100
>  
>  #define QCA8K_NUM_PORTS					7
>  #define QCA8K_NUM_CPU_PORTS				2
> @@ -328,6 +332,14 @@ enum {
>  	QCA8K_CPU_PORT6,
>  };
>  
> +struct qca8k_mdio_hdr_data {

What do you think about the "qca8k_eth_mgmt_data" name rather than
"mdio_hdr_data"? I don't think this has anything to do with MDIO.

> +	struct completion rw_done;
> +	struct mutex mutex; /* Enforce one mdio read/write at time */
> +	bool ack;
> +	u32 seq;
> +	u32 data[4];
> +};
> +
>  struct qca8k_ports_config {
>  	bool sgmii_rx_clk_falling_edge;
>  	bool sgmii_tx_clk_falling_edge;
> @@ -354,6 +366,7 @@ struct qca8k_priv {
>  	struct gpio_desc *reset_gpio;
>  	unsigned int port_mtu[QCA8K_NUM_PORTS];
>  	const struct net_device *master; /* Track if mdio/mib Ethernet is available */
> +	struct qca8k_mdio_hdr_data mdio_hdr_data;
>  };
>  
>  struct qca8k_mib_desc {
> -- 
> 2.33.1
> 
