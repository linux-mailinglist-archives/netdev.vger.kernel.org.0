Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30B04984DE
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243763AbiAXQcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235823AbiAXQck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:32:40 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA8BC06173B;
        Mon, 24 Jan 2022 08:32:40 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id c24so55385884edy.4;
        Mon, 24 Jan 2022 08:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HzLJQNY/qBOTL2lrjMIzXTHcsgCSncCV9vAqiAagz2o=;
        b=npOcTh0uCwA1grOperMI7KF/Yxv3hsd0G7pW/rX3ZA9Uop/sz6WCFLaOeIUIC/SNWP
         D4GTZGYlUFVJUDbnSXBYXFjJeVG/PnQHjNLQdUkzO0hKhiU3DZ8957SOi8zbV2g30pPB
         llMM3+/3kPg8nws0cWe8fPaF3pK+b6bk1XwuNDd+0T2JouI5vlV7fYk8U948N2AH3VUd
         jrahBgCa8i4MEvbL6uywHJK2fEx9KrLZl03KP7Y3cqKpqi8ttsZTXSt080QTLwRmggSB
         Axyb/O4LElFVwuAZE+4nytpePv43qy5cEdolejUQgF8GpGxqQxOGPo00qY1g1H8+n9dM
         qD+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HzLJQNY/qBOTL2lrjMIzXTHcsgCSncCV9vAqiAagz2o=;
        b=5J1dpPcheizBhtvuZ2dVQLe+SnoWzJjokyUk2gssc0pTH7QKFZaV9MfBxVjhtDZ/OT
         jiVP5shJCkWnCzQVDPthPIrY2wumzZjVJVeI0cxdzehIS7DQNzq5Csb0xm+yJYJ1gQ+f
         GKYUfH8gVAY6dMcx0YY0T4DQ1ER9B3/IRR5Xusc2xeWbjJsBNkwA5/89gF9kPf3un4UU
         hcBO0IzXXHvJahK8Wsi0Jo0sDPh/d6/5hwWU7SayGtiGKghs6dlB+kYxg1GisnCIt2vl
         r/ayp+vDzp5J/eKPu9BqRtS143RnPP2FiUbn2tEaAsXLWiNtI8oI9zXf5fD9CUZtm/NJ
         ugBA==
X-Gm-Message-State: AOAM532cyJcOFSWBOQNimlkW366onGOIDq3siY7xwEbvgw36ilg0YCYC
        hR/NQL/bDH+fzXj49k/V1Sc=
X-Google-Smtp-Source: ABdhPJyndymBVTuXJCRKn99Ucp2ZDN351nLBHr0hQmqHfvsF+GdIscXlCuYbL8su9OY7jqqCqu6y2g==
X-Received: by 2002:a50:cb8b:: with SMTP id k11mr6273196edi.183.1643041958635;
        Mon, 24 Jan 2022 08:32:38 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id p21sm5081016ejj.156.2022.01.24.08.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 08:32:38 -0800 (PST)
Date:   Mon, 24 Jan 2022 18:32:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 10/16] net: dsa: qca8k: add support for mgmt
 read/write in Ethernet packet
Message-ID: <20220124163236.yrrjn32jylc2kx6o@skbuf>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-11-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123013337.20945-11-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 02:33:31AM +0100, Ansuel Smith wrote:
> Add qca8k side support for mgmt read/write in Ethernet packet.
> qca8k supports some specially crafted Ethernet packet that can be used
> for mgmt read/write instead of the legacy method uart/internal mdio.
> This add support for the qca8k side to craft the packet and enqueue it.
> Each port and the qca8k_priv have a special struct to put data in it.
> The completion API is used to wait for the packet to be received back
> with the requested data.
> 
> The various steps are:
> 1. Craft the special packet with the qca hdr set to mgmt read/write
>    mode.
> 2. Set the lock in the dedicated mgmt struct.
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
> Locking is added to qca8k_master_change() to make sure no mgmt Ethernet
> are in progress.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 206 ++++++++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/qca8k.h |  13 +++
>  2 files changed, 219 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 4bc5064414b5..35711d010eb4 100644
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
> @@ -170,6 +171,174 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
>  	return regmap_update_bits(priv->regmap, reg, mask, write_val);
>  }
>  
> +static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
> +{
> +	struct qca8k_mgmt_hdr_data *mgmt_hdr_data;
> +	struct qca8k_priv *priv = ds->priv;
> +	struct mgmt_ethhdr *mgmt_ethhdr;
> +	u8 len, cmd;
> +
> +	mgmt_ethhdr = (struct mgmt_ethhdr *)skb_mac_header(skb);
> +	mgmt_hdr_data = &priv->mgmt_hdr_data;
> +
> +	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, mgmt_ethhdr->command);
> +	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, mgmt_ethhdr->command);
> +
> +	/* Make sure the seq match the requested packet */
> +	if (mgmt_ethhdr->seq == mgmt_hdr_data->seq)
> +		mgmt_hdr_data->ack = true;
> +
> +	if (cmd == MDIO_READ) {
> +		mgmt_hdr_data->data[0] = mgmt_ethhdr->mdio_data;
> +
> +		/* Get the rest of the 12 byte of data */
> +		if (len > QCA_HDR_MGMT_DATA1_LEN)
> +			memcpy(mgmt_hdr_data->data + 1, skb->data,
> +			       QCA_HDR_MGMT_DATA2_LEN);
> +	}
> +
> +	complete(&mgmt_hdr_data->rw_done);
> +}
> +
> +static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
> +					       int seq_num, int priority)
> +{
> +	struct mgmt_ethhdr *mgmt_ethhdr;
> +	struct sk_buff *skb;
> +	u16 hdr;
> +
> +	skb = dev_alloc_skb(QCA_HDR_MGMT_PKG_LEN);
> +	if (!skb)
> +		return NULL;
> +
> +	skb_reset_mac_header(skb);
> +	skb_set_network_header(skb, skb->len);
> +
> +	mgmt_ethhdr = skb_push(skb, QCA_HDR_MGMT_HEADER_LEN + QCA_HDR_LEN);
> +
> +	hdr = FIELD_PREP(QCA_HDR_XMIT_VERSION, QCA_HDR_VERSION);
> +	hdr |= FIELD_PREP(QCA_HDR_XMIT_PRIORITY, priority);
> +	hdr |= QCA_HDR_XMIT_FROM_CPU;
> +	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(0));
> +	hdr |= FIELD_PREP(QCA_HDR_XMIT_CONTROL, QCA_HDR_XMIT_TYPE_RW_REG);
> +
> +	mgmt_ethhdr->seq = FIELD_PREP(QCA_HDR_MGMT_SEQ_NUM, seq_num);
> +
> +	mgmt_ethhdr->command = FIELD_PREP(QCA_HDR_MGMT_ADDR, reg);
> +	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, 4);
> +	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CMD, cmd);
> +	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CHECK_CODE,
> +					   QCA_HDR_MGMT_CHECK_CODE_VAL);
> +
> +	if (cmd == MDIO_WRITE)
> +		mgmt_ethhdr->mdio_data = *val;
> +
> +	mgmt_ethhdr->hdr = htons(hdr);
> +
> +	skb_put_zero(skb, QCA_HDR_MGMT_DATA2_LEN + QCA_HDR_MGMT_PADDING_LEN);
> +
> +	return skb;
> +}
> +
> +static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
> +{
> +	struct qca8k_mgmt_hdr_data *mgmt_hdr_data = &priv->mgmt_hdr_data;
> +	struct sk_buff *skb;
> +	bool ack;
> +	int ret;
> +
> +	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	mutex_lock(&mgmt_hdr_data->mutex);
> +
> +	/* Recheck mgmt_master under lock to make sure it's operational */
> +	if (!priv->mgmt_master)

mutex_unlock and kfree_skb

Also, why "recheck under lock"? Why not check just under lock?

> +		return -EINVAL;
> +
> +	skb->dev = (struct net_device *)priv->mgmt_master;
> +
> +	reinit_completion(&mgmt_hdr_data->rw_done);
> +	mgmt_hdr_data->seq = 200;
> +	mgmt_hdr_data->ack = false;
> +
> +	dev_queue_xmit(skb);
> +
> +	ret = wait_for_completion_timeout(&mgmt_hdr_data->rw_done,
> +					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
> +
> +	*val = mgmt_hdr_data->data[0];
> +	ack = mgmt_hdr_data->ack;
> +
> +	mutex_unlock(&mgmt_hdr_data->mutex);
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
> +	struct qca8k_mgmt_hdr_data *mgmt_hdr_data = &priv->mgmt_hdr_data;
> +	struct sk_buff *skb;
> +	bool ack;
> +	int ret;
> +
> +	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, &val, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	mutex_lock(&mgmt_hdr_data->mutex);
> +
> +	/* Recheck mgmt_master under lock to make sure it's operational */
> +	if (!priv->mgmt_master)

mutex_unlock and kfree_skb

> +		return -EINVAL;
> +
> +	skb->dev = (struct net_device *)priv->mgmt_master;
> +
> +	reinit_completion(&mgmt_hdr_data->rw_done);
> +	mgmt_hdr_data->ack = false;
> +	mgmt_hdr_data->seq = 200;
> +
> +	dev_queue_xmit(skb);
> +
> +	ret = wait_for_completion_timeout(&mgmt_hdr_data->rw_done,
> +					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
> +
> +	ack = mgmt_hdr_data->ack;
> +
> +	mutex_unlock(&mgmt_hdr_data->mutex);
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
> @@ -178,6 +347,9 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
>  	u16 r1, r2, page;
>  	int ret;
>  
> +	if (priv->mgmt_master && !qca8k_read_eth(priv, reg, val))

What happens if you remove this priv->mgmt_master check from outside the
lock, and reorder the skb allocation with the priv->mgmt_master check?

> +		return 0;
> +
>  	qca8k_split_addr(reg, &r1, &r2, &page);
>  
>  	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> @@ -201,6 +373,9 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
>  	u16 r1, r2, page;
>  	int ret;
>  
> +	if (priv->mgmt_master && !qca8k_write_eth(priv, reg, val))
> +		return 0;
> +
>  	qca8k_split_addr(reg, &r1, &r2, &page);
>  
>  	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> @@ -225,6 +400,10 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
>  	u32 val;
>  	int ret;
>  
> +	if (priv->mgmt_master &&
> +	    !qca8k_regmap_update_bits_eth(priv, reg, mask, write_val))
> +		return 0;
> +
>  	qca8k_split_addr(reg, &r1, &r2, &page);
>  
>  	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> @@ -2394,10 +2573,33 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
>  	if (dp->index != 0)
>  		return;
>  
> +	mutex_lock(&priv->mgmt_hdr_data.mutex);
> +
>  	if (operational)
>  		priv->mgmt_master = master;
>  	else
>  		priv->mgmt_master = NULL;
> +
> +	mutex_unlock(&priv->mgmt_hdr_data.mutex);
> +}
> +
> +static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
> +				      enum dsa_tag_protocol proto)
> +{
> +	struct qca_tagger_data *tagger_data;
> +
> +	switch (proto) {
> +	case DSA_TAG_PROTO_QCA:
> +		tagger_data = ds->tagger_data;
> +
> +		tagger_data->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
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
> @@ -2436,6 +2638,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.port_lag_join		= qca8k_port_lag_join,
>  	.port_lag_leave		= qca8k_port_lag_leave,
>  	.master_state_change	= qca8k_master_change,
> +	.connect_tag_protocol	= qca8k_connect_tag_protocol,
>  };
>  
>  static int qca8k_read_switch_id(struct qca8k_priv *priv)
> @@ -2515,6 +2718,9 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
>  	if (!priv->ds)
>  		return -ENOMEM;
>  
> +	mutex_init(&priv->mgmt_hdr_data.mutex);
> +	init_completion(&priv->mgmt_hdr_data.rw_done);
> +
>  	priv->ds->dev = &mdiodev->dev;
>  	priv->ds->num_ports = QCA8K_NUM_PORTS;
>  	priv->ds->priv = priv;
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index 9437369c60ca..a358a67044d3 100644
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
> +struct qca8k_mgmt_hdr_data {
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
>  	const struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
> +	struct qca8k_mgmt_hdr_data mgmt_hdr_data;
>  };
>  
>  struct qca8k_mib_desc {
> -- 
> 2.33.1
> 

