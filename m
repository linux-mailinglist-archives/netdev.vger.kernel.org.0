Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2617E49852D
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243888AbiAXQsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbiAXQsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:48:36 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B6CC06173B;
        Mon, 24 Jan 2022 08:48:36 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id h7so23064660ejf.1;
        Mon, 24 Jan 2022 08:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=AO//yXSSd8olvAy3BiGnax8jCG+dxsLs/CUQMKQy1qU=;
        b=a1Hv4Sxb9ArJWMiF3u2mcPJYemXUOWNbp3r8AZ+m10iSQiFdLRGnfjNiF+Pdkt0vW4
         5M2nZweCnmbu33U7L+/6uHCaJyr10ftKc1MG5XS8+RnDMmDokf5QlvqRDqbV4BSGX+zp
         i4z5OGFH/0mI55Tdl8baM7TAOz1uPs7JO2k8WWabHhCr4geva1hX5nIgyfso/Fgf/IB8
         dYb9BOvG7Ph93uhpauH/9iw2BXCAVKjEJDYyuVJbiTQ25vG6CD75zwokXppNXb/dmDeP
         opjSLexuuAeV1airFw33u3wwHfWVe9bTBlG4AWws6pSMxwXhSLnokId5I9KZnqttGuZr
         DcGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=AO//yXSSd8olvAy3BiGnax8jCG+dxsLs/CUQMKQy1qU=;
        b=5NIdw5Hikdxl1C86V+XPHhWSpblyvsRqM8JFZqQqO8PyjdxppyVS0LVWL1LDKDn3qh
         Yi8LKdQ3QpdWzE5pzofZCOyG1POY4TUrcm2DIknplk4Ce0mVcv6AvTx9Bj+JnZKZ8nNT
         1NG+JpWqnWok3uiWS0O7uyRFNEOozJ9SIC/avif7lPGoia9PJJJIygbYPZMHHrL8tY9h
         0MoKCOHhiqajBk38sJJ6TNrpMi6ihDAROPouIWk7QSDSgYOWMwTIdtYpF0ifi4pac+ct
         L/R/JYztNepjZhnAFoPnvrhtWxryOs7PEtXgyaxW+6EIPpR1ewjAVniseBGEiploVw33
         r2jQ==
X-Gm-Message-State: AOAM532KxNm2kYtiAjy2bCrVLkpsbIG8n8mboS5kPNZrV952qdC0L6Ds
        jwhhp6yRmcPb30A/dGMTnTDAlmdX/eM=
X-Google-Smtp-Source: ABdhPJzoaTTYdAK7Mgi2z3TWpEuPd6vO5Fk4+M/KC4/DUChSn8zmXEabPYUi0l5lIRoKY9KRGHkIfA==
X-Received: by 2002:a17:906:2856:: with SMTP id s22mr13359863ejc.330.1643042914364;
        Mon, 24 Jan 2022 08:48:34 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id q5sm5105227ejc.115.2022.01.24.08.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 08:48:33 -0800 (PST)
Message-ID: <61eed861.1c69fb81.d14ad.62cf@mx.google.com>
X-Google-Original-Message-ID: <Ye7YYGqXG2Ro7tjC@Ansuel-xps.>
Date:   Mon, 24 Jan 2022 17:48:32 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 10/16] net: dsa: qca8k: add support for mgmt
 read/write in Ethernet packet
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-11-ansuelsmth@gmail.com>
 <20220124163236.yrrjn32jylc2kx6o@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124163236.yrrjn32jylc2kx6o@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 06:32:36PM +0200, Vladimir Oltean wrote:
> On Sun, Jan 23, 2022 at 02:33:31AM +0100, Ansuel Smith wrote:
> > Add qca8k side support for mgmt read/write in Ethernet packet.
> > qca8k supports some specially crafted Ethernet packet that can be used
> > for mgmt read/write instead of the legacy method uart/internal mdio.
> > This add support for the qca8k side to craft the packet and enqueue it.
> > Each port and the qca8k_priv have a special struct to put data in it.
> > The completion API is used to wait for the packet to be received back
> > with the requested data.
> > 
> > The various steps are:
> > 1. Craft the special packet with the qca hdr set to mgmt read/write
> >    mode.
> > 2. Set the lock in the dedicated mgmt struct.
> > 3. Reinit the completion.
> > 4. Enqueue the packet.
> > 5. Wait the packet to be received.
> > 6. Use the data set by the tagger to complete the mdio operation.
> > 
> > If the completion timeouts or the ack value is not true, the legacy
> > mdio way is used.
> > 
> > It has to be considered that in the initial setup mdio is still used and
> > mdio is still used until DSA is ready to accept and tag packet.
> > 
> > tag_proto_connect() is used to fill the required handler for the tagger
> > to correctly parse and elaborate the special Ethernet mdio packet.
> > 
> > Locking is added to qca8k_master_change() to make sure no mgmt Ethernet
> > are in progress.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 206 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/net/dsa/qca8k.h |  13 +++
> >  2 files changed, 219 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index 4bc5064414b5..35711d010eb4 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/phylink.h>
> >  #include <linux/gpio/consumer.h>
> >  #include <linux/etherdevice.h>
> > +#include <linux/dsa/tag_qca.h>
> >  
> >  #include "qca8k.h"
> >  
> > @@ -170,6 +171,174 @@ qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
> >  	return regmap_update_bits(priv->regmap, reg, mask, write_val);
> >  }
> >  
> > +static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
> > +{
> > +	struct qca8k_mgmt_hdr_data *mgmt_hdr_data;
> > +	struct qca8k_priv *priv = ds->priv;
> > +	struct mgmt_ethhdr *mgmt_ethhdr;
> > +	u8 len, cmd;
> > +
> > +	mgmt_ethhdr = (struct mgmt_ethhdr *)skb_mac_header(skb);
> > +	mgmt_hdr_data = &priv->mgmt_hdr_data;
> > +
> > +	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, mgmt_ethhdr->command);
> > +	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, mgmt_ethhdr->command);
> > +
> > +	/* Make sure the seq match the requested packet */
> > +	if (mgmt_ethhdr->seq == mgmt_hdr_data->seq)
> > +		mgmt_hdr_data->ack = true;
> > +
> > +	if (cmd == MDIO_READ) {
> > +		mgmt_hdr_data->data[0] = mgmt_ethhdr->mdio_data;
> > +
> > +		/* Get the rest of the 12 byte of data */
> > +		if (len > QCA_HDR_MGMT_DATA1_LEN)
> > +			memcpy(mgmt_hdr_data->data + 1, skb->data,
> > +			       QCA_HDR_MGMT_DATA2_LEN);
> > +	}
> > +
> > +	complete(&mgmt_hdr_data->rw_done);
> > +}
> > +
> > +static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
> > +					       int seq_num, int priority)
> > +{
> > +	struct mgmt_ethhdr *mgmt_ethhdr;
> > +	struct sk_buff *skb;
> > +	u16 hdr;
> > +
> > +	skb = dev_alloc_skb(QCA_HDR_MGMT_PKG_LEN);
> > +	if (!skb)
> > +		return NULL;
> > +
> > +	skb_reset_mac_header(skb);
> > +	skb_set_network_header(skb, skb->len);
> > +
> > +	mgmt_ethhdr = skb_push(skb, QCA_HDR_MGMT_HEADER_LEN + QCA_HDR_LEN);
> > +
> > +	hdr = FIELD_PREP(QCA_HDR_XMIT_VERSION, QCA_HDR_VERSION);
> > +	hdr |= FIELD_PREP(QCA_HDR_XMIT_PRIORITY, priority);
> > +	hdr |= QCA_HDR_XMIT_FROM_CPU;
> > +	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(0));
> > +	hdr |= FIELD_PREP(QCA_HDR_XMIT_CONTROL, QCA_HDR_XMIT_TYPE_RW_REG);
> > +
> > +	mgmt_ethhdr->seq = FIELD_PREP(QCA_HDR_MGMT_SEQ_NUM, seq_num);
> > +
> > +	mgmt_ethhdr->command = FIELD_PREP(QCA_HDR_MGMT_ADDR, reg);
> > +	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, 4);
> > +	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CMD, cmd);
> > +	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CHECK_CODE,
> > +					   QCA_HDR_MGMT_CHECK_CODE_VAL);
> > +
> > +	if (cmd == MDIO_WRITE)
> > +		mgmt_ethhdr->mdio_data = *val;
> > +
> > +	mgmt_ethhdr->hdr = htons(hdr);
> > +
> > +	skb_put_zero(skb, QCA_HDR_MGMT_DATA2_LEN + QCA_HDR_MGMT_PADDING_LEN);
> > +
> > +	return skb;
> > +}
> > +
> > +static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
> > +{
> > +	struct qca8k_mgmt_hdr_data *mgmt_hdr_data = &priv->mgmt_hdr_data;
> > +	struct sk_buff *skb;
> > +	bool ack;
> > +	int ret;
> > +
> > +	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
> > +	if (!skb)
> > +		return -ENOMEM;
> > +
> > +	mutex_lock(&mgmt_hdr_data->mutex);
> > +
> > +	/* Recheck mgmt_master under lock to make sure it's operational */
> > +	if (!priv->mgmt_master)
> 
> mutex_unlock and kfree_skb
> 
> Also, why "recheck under lock"? Why not check just under lock?
>

Tell me if the logic is wrong.
We use the mgmt_master (outside lock) to understand if the eth mgmt is
available. Then to make sure it's actually usable when the operation is
actually done (and to prevent any panic if the master is dropped or for
whatever reason mgmt_master is not available anymore) we do the check
another time under lock.

It's really just to save extra lock when mgmt_master is not available.
The check under lock is to handle case when the mgmt_master is removed
while a mgmt eth is pending (corner case but still worth checking).

If you have suggestions on how to handle this corner case without
introducing an extra lock in the read/write function, I would really
appreaciate it.
Now that I think about it, considering eth mgmt will be the main way and
mdio as a fallback... wonder if the extra lock is acceptable anyway.
In the near future ipq40xx will use qca8k, but will have his own regmap
functions so we they won't be affected by these extra locking.

Don't know what is worst. Extra locking when mgmt_master is not
avaialable or double check. (I assume for a cleaner code the extra lock
is preferred)

> > +		return -EINVAL;
> > +
> > +	skb->dev = (struct net_device *)priv->mgmt_master;
> > +
> > +	reinit_completion(&mgmt_hdr_data->rw_done);
> > +	mgmt_hdr_data->seq = 200;
> > +	mgmt_hdr_data->ack = false;
> > +
> > +	dev_queue_xmit(skb);
> > +
> > +	ret = wait_for_completion_timeout(&mgmt_hdr_data->rw_done,
> > +					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
> > +
> > +	*val = mgmt_hdr_data->data[0];
> > +	ack = mgmt_hdr_data->ack;
> > +
> > +	mutex_unlock(&mgmt_hdr_data->mutex);
> > +
> > +	if (ret <= 0)
> > +		return -ETIMEDOUT;
> > +
> > +	if (!ack)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 val)
> > +{
> > +	struct qca8k_mgmt_hdr_data *mgmt_hdr_data = &priv->mgmt_hdr_data;
> > +	struct sk_buff *skb;
> > +	bool ack;
> > +	int ret;
> > +
> > +	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, &val, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
> > +	if (!skb)
> > +		return -ENOMEM;
> > +
> > +	mutex_lock(&mgmt_hdr_data->mutex);
> > +
> > +	/* Recheck mgmt_master under lock to make sure it's operational */
> > +	if (!priv->mgmt_master)
> 
> mutex_unlock and kfree_skb
> 
> > +		return -EINVAL;
> > +
> > +	skb->dev = (struct net_device *)priv->mgmt_master;
> > +
> > +	reinit_completion(&mgmt_hdr_data->rw_done);
> > +	mgmt_hdr_data->ack = false;
> > +	mgmt_hdr_data->seq = 200;
> > +
> > +	dev_queue_xmit(skb);
> > +
> > +	ret = wait_for_completion_timeout(&mgmt_hdr_data->rw_done,
> > +					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
> > +
> > +	ack = mgmt_hdr_data->ack;
> > +
> > +	mutex_unlock(&mgmt_hdr_data->mutex);
> > +
> > +	if (ret <= 0)
> > +		return -ETIMEDOUT;
> > +
> > +	if (!ack)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +qca8k_regmap_update_bits_eth(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
> > +{
> > +	u32 val = 0;
> > +	int ret;
> > +
> > +	ret = qca8k_read_eth(priv, reg, &val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	val &= ~mask;
> > +	val |= write_val;
> > +
> > +	return qca8k_write_eth(priv, reg, val);
> > +}
> > +
> >  static int
> >  qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
> >  {
> > @@ -178,6 +347,9 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
> >  	u16 r1, r2, page;
> >  	int ret;
> >  
> > +	if (priv->mgmt_master && !qca8k_read_eth(priv, reg, val))
> 
> What happens if you remove this priv->mgmt_master check from outside the
> lock, and reorder the skb allocation with the priv->mgmt_master check?
> 
> > +		return 0;
> > +
> >  	qca8k_split_addr(reg, &r1, &r2, &page);
> >  
> >  	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> > @@ -201,6 +373,9 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
> >  	u16 r1, r2, page;
> >  	int ret;
> >  
> > +	if (priv->mgmt_master && !qca8k_write_eth(priv, reg, val))
> > +		return 0;
> > +
> >  	qca8k_split_addr(reg, &r1, &r2, &page);
> >  
> >  	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> > @@ -225,6 +400,10 @@ qca8k_regmap_update_bits(void *ctx, uint32_t reg, uint32_t mask, uint32_t write_
> >  	u32 val;
> >  	int ret;
> >  
> > +	if (priv->mgmt_master &&
> > +	    !qca8k_regmap_update_bits_eth(priv, reg, mask, write_val))
> > +		return 0;
> > +
> >  	qca8k_split_addr(reg, &r1, &r2, &page);
> >  
> >  	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> > @@ -2394,10 +2573,33 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
> >  	if (dp->index != 0)
> >  		return;
> >  
> > +	mutex_lock(&priv->mgmt_hdr_data.mutex);
> > +
> >  	if (operational)
> >  		priv->mgmt_master = master;
> >  	else
> >  		priv->mgmt_master = NULL;
> > +
> > +	mutex_unlock(&priv->mgmt_hdr_data.mutex);
> > +}
> > +
> > +static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
> > +				      enum dsa_tag_protocol proto)
> > +{
> > +	struct qca_tagger_data *tagger_data;
> > +
> > +	switch (proto) {
> > +	case DSA_TAG_PROTO_QCA:
> > +		tagger_data = ds->tagger_data;
> > +
> > +		tagger_data->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
> > +
> > +		break;
> > +	default:
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	return 0;
> >  }
> >  
> >  static const struct dsa_switch_ops qca8k_switch_ops = {
> > @@ -2436,6 +2638,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
> >  	.port_lag_join		= qca8k_port_lag_join,
> >  	.port_lag_leave		= qca8k_port_lag_leave,
> >  	.master_state_change	= qca8k_master_change,
> > +	.connect_tag_protocol	= qca8k_connect_tag_protocol,
> >  };
> >  
> >  static int qca8k_read_switch_id(struct qca8k_priv *priv)
> > @@ -2515,6 +2718,9 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
> >  	if (!priv->ds)
> >  		return -ENOMEM;
> >  
> > +	mutex_init(&priv->mgmt_hdr_data.mutex);
> > +	init_completion(&priv->mgmt_hdr_data.rw_done);
> > +
> >  	priv->ds->dev = &mdiodev->dev;
> >  	priv->ds->num_ports = QCA8K_NUM_PORTS;
> >  	priv->ds->priv = priv;
> > diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> > index 9437369c60ca..a358a67044d3 100644
> > --- a/drivers/net/dsa/qca8k.h
> > +++ b/drivers/net/dsa/qca8k.h
> > @@ -11,6 +11,10 @@
> >  #include <linux/delay.h>
> >  #include <linux/regmap.h>
> >  #include <linux/gpio.h>
> > +#include <linux/dsa/tag_qca.h>
> > +
> > +#define QCA8K_ETHERNET_MDIO_PRIORITY			7
> > +#define QCA8K_ETHERNET_TIMEOUT				100
> >  
> >  #define QCA8K_NUM_PORTS					7
> >  #define QCA8K_NUM_CPU_PORTS				2
> > @@ -328,6 +332,14 @@ enum {
> >  	QCA8K_CPU_PORT6,
> >  };
> >  
> > +struct qca8k_mgmt_hdr_data {
> > +	struct completion rw_done;
> > +	struct mutex mutex; /* Enforce one mdio read/write at time */
> > +	bool ack;
> > +	u32 seq;
> > +	u32 data[4];
> > +};
> > +
> >  struct qca8k_ports_config {
> >  	bool sgmii_rx_clk_falling_edge;
> >  	bool sgmii_tx_clk_falling_edge;
> > @@ -354,6 +366,7 @@ struct qca8k_priv {
> >  	struct gpio_desc *reset_gpio;
> >  	unsigned int port_mtu[QCA8K_NUM_PORTS];
> >  	const struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
> > +	struct qca8k_mgmt_hdr_data mgmt_hdr_data;
> >  };
> >  
> >  struct qca8k_mib_desc {
> > -- 
> > 2.33.1
> > 
> 

-- 
	Ansuel
