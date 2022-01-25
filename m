Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344F949BF70
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbiAYXPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiAYXPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:15:00 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F65C06161C;
        Tue, 25 Jan 2022 15:14:59 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id me13so34389296ejb.12;
        Tue, 25 Jan 2022 15:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=q5VLqcrh9GZ84w4V1MohAq9OWkQFjccEm/5qIckKhKU=;
        b=dqtVL3JANDbjJojb4f9BOPQ7FbMjR8V1axBSlMFArHoCKc0km6MTjSRqAV4GyrZE8P
         Mk0b62uHXI4khu9Ync7K0g6ZUYvwx9l7LiYXDvVmC2F2kzoBS0yWOdg+Ol0jELAWpJlv
         My0b7cJQBX65ZdLkOqIp3YVBAgnmg+cKMEE7D7DPaElSIEj1nP6zIeqXs5d+ulUn71Ve
         77OdfJxcNYnqcgi3s6wQuf/TA3HYGaEWazYUv6T0up7R0DCrwIJR8KTeBKquuyOHvZsU
         zudkZXD+3ZZaMYGXsxrpXVP3LqF3ArFes1U/lNevhPgePcMpws5N+pdwAfQMvBboAyoG
         o4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=q5VLqcrh9GZ84w4V1MohAq9OWkQFjccEm/5qIckKhKU=;
        b=cdGJtMU2nprXKa5zWCtjOxmcdnMvFMoMyH4pOA0gKmEWTXFj1UCIxvuDxK7MhdbtT9
         dUvdP0maGe+zTArCyDeKr8lxFcWwxzFuIM2ml/yeMSupTaJM7MYJ6bnUxzAanXFISskM
         OCcglKXRm66DM7id9pyzvAh7K74eE+M+ys7pnJZDOAdp3D4c2CbLImd/fqJ8hJgeL46W
         64CbnrHrX+se774gXK/n2G8hqdC35iCmfEiuNaDjvfofOpiBd/xW27a1/qhvcpqsXubg
         dTrPgBq1YWmGYZypTV7fl2uguKQdFETo+lWjhX0XNv7PqjgJZliwV4WhvFAg+zZoHgf+
         UFNg==
X-Gm-Message-State: AOAM5301iHEz71lzD0cknyiUiAc+W9n2ncYMh0LhnZt9XtuhYHl0gdJ8
        8eszAno1bmA2omn6OBrxojKJB6KoWYU=
X-Google-Smtp-Source: ABdhPJzraNs8BOKFjseeT/e/iTJtYOSdlMJ0cSGbXqG+lgvmdLr3SvqLvmD1mi+gvhUXpNOw8ePsQQ==
X-Received: by 2002:a17:907:6e87:: with SMTP id sh7mr9769573ejc.446.1643152498081;
        Tue, 25 Jan 2022 15:14:58 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id s9sm8933414edj.48.2022.01.25.15.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 15:14:57 -0800 (PST)
Message-ID: <61f08471.1c69fb81.a3d6.4d94@mx.google.com>
X-Google-Original-Message-ID: <YfCEb7jPE3vUOY4w@Ansuel-xps.>
Date:   Wed, 26 Jan 2022 00:14:55 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 12/16] net: dsa: qca8k: add support for phy
 read/write with mgmt Ethernet
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-13-ansuelsmth@gmail.com>
 <20220125150355.5ywi4fe3puxaphq3@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125150355.5ywi4fe3puxaphq3@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 05:03:55PM +0200, Vladimir Oltean wrote:
> On Sun, Jan 23, 2022 at 02:33:33AM +0100, Ansuel Smith wrote:
> > Use mgmt Ethernet also for phy read/write if availabale. Use a different
> > seq number to make sure we receive the correct packet.
> 
> At some point, you'll have to do something about those sequence numbers.
> Hardcoding 200 and 400 isn't going to get you very far, it's prone to
> errors. How about dealing with it now? If treating them as actual
> sequence numbers isn't useful because you can't have multiple packets in
> flight due to reordering concerns, at least create a macro for each
> sequence number used by the driver for packet identification.
>

Is documenting define and adding some inline function acceptable? That
should make the separation more clear and also prepare for a future
implementation. The way I see an use for the seq number is something
like a global workqueue that would handle all this stuff and be the one
that handle the seq number.
I mean another way would be just use a counter that will overflow and
remove all this garbage with hardcoded seq number.
(think will follow this path and just implement a correct seq number...)

> > On any error, we fallback to the legacy mdio read/write.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >  drivers/net/dsa/qca8k.c | 191 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/net/dsa/qca8k.h |   1 +
> >  2 files changed, 192 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index f51a6d8993ff..e7bc0770bae9 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -848,6 +848,166 @@ qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
> >  		regmap_clear_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
> >  }
> >  
> > +static int
> > +qca8k_phy_eth_busy_wait(struct qca8k_mgmt_hdr_data *phy_hdr_data,
> > +			struct sk_buff *read_skb, u32 *val)
> > +{
> > +	struct sk_buff *skb = skb_copy(read_skb, GFP_KERNEL);
> > +	bool ack;
> > +	int ret;
> > +
> > +	reinit_completion(&phy_hdr_data->rw_done);
> > +	phy_hdr_data->seq = 400;
> > +	phy_hdr_data->ack = false;
> > +
> > +	dev_queue_xmit(skb);
> > +
> > +	ret = wait_for_completion_timeout(&phy_hdr_data->rw_done,
> > +					  QCA8K_ETHERNET_TIMEOUT);
> > +
> > +	ack = phy_hdr_data->ack;
> > +
> > +	if (ret <= 0)
> > +		return -ETIMEDOUT;
> > +
> > +	if (!ack)
> > +		return -EINVAL;
> > +
> > +	*val = phy_hdr_data->data[0];
> > +
> > +	return 0;
> > +}
> > +
> > +static int
> > +qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
> > +		      int regnum, u16 data)
> > +{
> > +	struct sk_buff *write_skb, *clear_skb, *read_skb;
> > +	struct qca8k_mgmt_hdr_data *phy_hdr_data;
> > +	const struct net_device *mgmt_master;
> > +	u32 write_val, clear_val = 0, val;
> > +	int seq_num = 400;
> > +	int ret, ret1;
> > +	bool ack;
> > +
> > +	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
> > +		return -EINVAL;
> > +
> > +	phy_hdr_data = &priv->mgmt_hdr_data;
> > +
> > +	write_val = QCA8K_MDIO_MASTER_BUSY | QCA8K_MDIO_MASTER_EN |
> > +		    QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
> > +		    QCA8K_MDIO_MASTER_REG_ADDR(regnum);
> > +
> > +	if (read) {
> > +		write_val |= QCA8K_MDIO_MASTER_READ;
> > +	} else {
> > +		write_val |= QCA8K_MDIO_MASTER_WRITE;
> > +		write_val |= QCA8K_MDIO_MASTER_DATA(data);
> > +	}
> > +
> > +	/* Prealloc all the needed skb before the lock */
> > +	write_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL,
> > +					    &write_val, seq_num, QCA8K_ETHERNET_PHY_PRIORITY);
> > +	if (!write_skb)
> > +		return -ENOMEM;
> > +
> > +	clear_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL,
> > +					    &clear_val, seq_num, QCA8K_ETHERNET_PHY_PRIORITY);
> > +	if (!write_skb)
> 
> Clean up the resources!!! (not just here but everywhere)
> 

Sorry!!! I'm checking all the skb to free and wow this is a mess...
Hope when I will send v8 you won't have a stoke checking this mess ahahahah

> > +		return -ENOMEM;
> > +
> > +	read_skb = qca8k_alloc_mdio_header(MDIO_READ, QCA8K_MDIO_MASTER_CTRL,
> > +					   &clear_val, seq_num, QCA8K_ETHERNET_PHY_PRIORITY);
> > +	if (!write_skb)
> > +		return -ENOMEM;
> > +
> > +	/* Actually start the request:
> > +	 * 1. Send mdio master packet
> > +	 * 2. Busy Wait for mdio master command
> > +	 * 3. Get the data if we are reading
> > +	 * 4. Reset the mdio master (even with error)
> > +	 */
> > +	mutex_lock(&phy_hdr_data->mutex);
> 
> Shouldn't qca8k_master_change() also take phy_hdr_data->mutex?
> 

Is actually the normal mgmg_hdr_data. 

phy_hdr_data = &priv->mgmt_hdr_data;

Should I remove this and use mgmt_hdr_data directly to remove any
confusion? 

> > +
> > +	/* Recheck mgmt_master under lock to make sure it's operational */
> > +	mgmt_master = priv->mgmt_master;
> > +	if (!mgmt_master)
> > +		return -EINVAL;
> > +
> > +	read_skb->dev = (struct net_device *)mgmt_master;
> > +	clear_skb->dev = (struct net_device *)mgmt_master;
> > +	write_skb->dev = (struct net_device *)mgmt_master;
> 
> If you need the master to be a non-const pointer, just make the DSA
> method give you a non-const pointer.
> 
> > +
> > +	reinit_completion(&phy_hdr_data->rw_done);
> > +	phy_hdr_data->ack = false;
> > +	phy_hdr_data->seq = seq_num;
> > +
> > +	dev_queue_xmit(write_skb);
> > +
> > +	ret = wait_for_completion_timeout(&phy_hdr_data->rw_done,
> > +					  QCA8K_ETHERNET_TIMEOUT);
> > +
> > +	ack = phy_hdr_data->ack;
> > +
> > +	if (ret <= 0) {
> > +		ret = -ETIMEDOUT;
> > +		goto exit;
> > +	}
> > +
> > +	if (!ack) {
> > +		ret = -EINVAL;
> > +		goto exit;
> > +	}
> > +
> > +	ret = read_poll_timeout(qca8k_phy_eth_busy_wait, ret1,
> > +				!(val & QCA8K_MDIO_MASTER_BUSY), 0,
> > +				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
> > +				phy_hdr_data, read_skb, &val);
> > +
> > +	if (ret < 0 && ret1 < 0) {
> > +		ret = ret1;
> > +		goto exit;
> > +	}
> > +
> > +	if (read) {
> > +		reinit_completion(&phy_hdr_data->rw_done);
> > +		phy_hdr_data->ack = false;
> > +
> > +		dev_queue_xmit(read_skb);
> > +
> > +		ret = wait_for_completion_timeout(&phy_hdr_data->rw_done,
> > +						  QCA8K_ETHERNET_TIMEOUT);
> > +
> > +		ack = phy_hdr_data->ack;
> > +
> > +		if (ret <= 0) {
> > +			ret = -ETIMEDOUT;
> > +			goto exit;
> > +		}
> > +
> > +		if (!ack) {
> > +			ret = -EINVAL;
> > +			goto exit;
> > +		}
> > +
> > +		ret = phy_hdr_data->data[0] & QCA8K_MDIO_MASTER_DATA_MASK;
> > +	}
> > +
> > +exit:
> > +	reinit_completion(&phy_hdr_data->rw_done);
> > +	phy_hdr_data->ack = false;
> > +
> > +	dev_queue_xmit(clear_skb);
> > +
> > +	wait_for_completion_timeout(&phy_hdr_data->rw_done,
> > +				    QCA8K_ETHERNET_TIMEOUT);
> > +
> > +	mutex_unlock(&phy_hdr_data->mutex);
> > +
> > +	return ret;
> > +}
> > +
> >  static u32
> >  qca8k_port_to_phy(int port)
> >  {
> > @@ -970,6 +1130,14 @@ qca8k_internal_mdio_write(struct mii_bus *slave_bus, int phy, int regnum, u16 da
> >  {
> >  	struct qca8k_priv *priv = slave_bus->priv;
> >  	struct mii_bus *bus = priv->bus;
> > +	int ret;
> > +
> > +	/* Use mdio Ethernet when available, fallback to legacy one on error */
> > +	if (priv->mgmt_master) {
> > +		ret = qca8k_phy_eth_command(priv, false, phy, regnum, data);
> > +		if (!ret)
> > +			return 0;
> > +	}
> >  
> >  	return qca8k_mdio_write(bus, phy, regnum, data);
> >  }
> > @@ -979,6 +1147,14 @@ qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
> >  {
> >  	struct qca8k_priv *priv = slave_bus->priv;
> >  	struct mii_bus *bus = priv->bus;
> > +	int ret;
> > +
> > +	/* Use mdio Ethernet when available, fallback to legacy one on error */
> > +	if (priv->mgmt_master) {
> > +		ret = qca8k_phy_eth_command(priv, true, phy, regnum, 0);
> > +		if (ret >= 0)
> > +			return ret;
> > +	}
> >  
> >  	return qca8k_mdio_read(bus, phy, regnum);
> >  }
> > @@ -987,6 +1163,7 @@ static int
> >  qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
> >  {
> >  	struct qca8k_priv *priv = ds->priv;
> > +	int ret;
> >  
> >  	/* Check if the legacy mapping should be used and the
> >  	 * port is not correctly mapped to the right PHY in the
> > @@ -995,6 +1172,13 @@ qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
> >  	if (priv->legacy_phy_port_mapping)
> >  		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
> >  
> > +	/* Use mdio Ethernet when available, fallback to legacy one on error */
> > +	if (priv->mgmt_master) {
> > +		ret = qca8k_phy_eth_command(priv, true, port, regnum, 0);
> > +		if (!ret)
> > +			return ret;
> > +	}
> > +
> >  	return qca8k_mdio_write(priv->bus, port, regnum, data);
> >  }
> >  
> > @@ -1011,6 +1195,13 @@ qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
> >  	if (priv->legacy_phy_port_mapping)
> >  		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
> >  
> > +	/* Use mdio Ethernet when available, fallback to legacy one on error */
> > +	if (priv->mgmt_master) {
> > +		ret = qca8k_phy_eth_command(priv, true, port, regnum, 0);
> > +		if (ret >= 0)
> > +			return ret;
> > +	}
> > +
> >  	ret = qca8k_mdio_read(priv->bus, port, regnum);
> >  
> >  	if (ret < 0)
> > diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> > index dc1365542aa3..952217db2047 100644
> > --- a/drivers/net/dsa/qca8k.h
> > +++ b/drivers/net/dsa/qca8k.h
> > @@ -14,6 +14,7 @@
> >  #include <linux/dsa/tag_qca.h>
> >  
> >  #define QCA8K_ETHERNET_MDIO_PRIORITY			7
> > +#define QCA8K_ETHERNET_PHY_PRIORITY			6
> >  #define QCA8K_ETHERNET_TIMEOUT				100
> >  
> >  #define QCA8K_NUM_PORTS					7
> > -- 
> > 2.33.1
> > 

-- 
	Ansuel
