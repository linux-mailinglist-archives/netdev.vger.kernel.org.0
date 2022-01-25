Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F69149B73F
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 16:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581342AbiAYPG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 10:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358220AbiAYPEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 10:04:00 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07008C06173E;
        Tue, 25 Jan 2022 07:03:59 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id u24so17812659eds.11;
        Tue, 25 Jan 2022 07:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Icd00DXUnvT4OhJ5Dtj/Mhzd8ev3bR5KgPoYf+MM5Aw=;
        b=IoZBp98z2HVLioBM12g1s3zqj3TViYlGeT2UAOSGNKnn5hOO1MlzlZZmgVj8jFzEu1
         X+/hPuz0XVizhHxT6i37w7Q9lD2UanOhopGcxY9sae9qwKkAguEx21pBA2QxagoFrca7
         HYAxyeYYv93OgnoUC9QdVem+PSppMpBQpMKSxO3TNQHJMBMUFOQPvnIWPI1xNaos/qus
         SPigZwlQtZ1pa2IQBhW0oC9UohLFy1/ZzvxE1kS4fdMgsIFf1OX7MzlmLJ5ALmhxQEmp
         0zZ4uAPweXFRagfAvwxdrdl1XQavaLFAhKsWV7NsOZpDso6TCkJntZU9Mu1OwwrTq/cL
         /YqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Icd00DXUnvT4OhJ5Dtj/Mhzd8ev3bR5KgPoYf+MM5Aw=;
        b=hmFhuWorgUAlRe71RGL7N9vP8rcXkEoIIU+TPVf+FrxtwjPgtI+M9fxklCgrmLXG7z
         rsiC+Uw4lmQ0sM7LPuk4pToaPjVDLPBITRbd9usT0Gf4P0EoFekglqwXxEjXdN8t5G3z
         XlYFC4DcPszTARObPCM7Wbgu227ijPGW4XZpZIr/POP17bHvE7YVCNexfFOlulISEVDO
         yFQrZ1HsIkZt1tWVazQi6aQQvYQqnuT+3EZa8F65Sbba2oO1VLjszEx8nWWqkOXzNN3u
         TOu5QrogSGTaQ50YL9yeAt1gXjKR29iV/yPGz+gL0OMzjnMaulPvFlZOKQFvl8/Uqp8/
         I3xg==
X-Gm-Message-State: AOAM530sSPXLI9od1aP0lI9H7GUZUQYFWS+xbGR2f9BhsEYsi7uxBf6T
        vqZB94psn3vgKyNC3/GC8cmeZBAcqM4=
X-Google-Smtp-Source: ABdhPJydGPDOAnKWj2BbpCwo6U25axikMLxRgsNzOsgSVJ68HFriRfxJdUNJ4lJpT0PvutJai49BIg==
X-Received: by 2002:a05:6402:1bcc:: with SMTP id ch12mr21223807edb.227.1643123037358;
        Tue, 25 Jan 2022 07:03:57 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id l2sm8314416eds.28.2022.01.25.07.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 07:03:56 -0800 (PST)
Date:   Tue, 25 Jan 2022 17:03:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 12/16] net: dsa: qca8k: add support for phy
 read/write with mgmt Ethernet
Message-ID: <20220125150355.5ywi4fe3puxaphq3@skbuf>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-13-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123013337.20945-13-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 02:33:33AM +0100, Ansuel Smith wrote:
> Use mgmt Ethernet also for phy read/write if availabale. Use a different
> seq number to make sure we receive the correct packet.

At some point, you'll have to do something about those sequence numbers.
Hardcoding 200 and 400 isn't going to get you very far, it's prone to
errors. How about dealing with it now? If treating them as actual
sequence numbers isn't useful because you can't have multiple packets in
flight due to reordering concerns, at least create a macro for each
sequence number used by the driver for packet identification.

> On any error, we fallback to the legacy mdio read/write.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 191 ++++++++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/qca8k.h |   1 +
>  2 files changed, 192 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index f51a6d8993ff..e7bc0770bae9 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -848,6 +848,166 @@ qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
>  		regmap_clear_bits(priv->regmap, QCA8K_REG_PORT_STATUS(port), mask);
>  }
>  
> +static int
> +qca8k_phy_eth_busy_wait(struct qca8k_mgmt_hdr_data *phy_hdr_data,
> +			struct sk_buff *read_skb, u32 *val)
> +{
> +	struct sk_buff *skb = skb_copy(read_skb, GFP_KERNEL);
> +	bool ack;
> +	int ret;
> +
> +	reinit_completion(&phy_hdr_data->rw_done);
> +	phy_hdr_data->seq = 400;
> +	phy_hdr_data->ack = false;
> +
> +	dev_queue_xmit(skb);
> +
> +	ret = wait_for_completion_timeout(&phy_hdr_data->rw_done,
> +					  QCA8K_ETHERNET_TIMEOUT);
> +
> +	ack = phy_hdr_data->ack;
> +
> +	if (ret <= 0)
> +		return -ETIMEDOUT;
> +
> +	if (!ack)
> +		return -EINVAL;
> +
> +	*val = phy_hdr_data->data[0];
> +
> +	return 0;
> +}
> +
> +static int
> +qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
> +		      int regnum, u16 data)
> +{
> +	struct sk_buff *write_skb, *clear_skb, *read_skb;
> +	struct qca8k_mgmt_hdr_data *phy_hdr_data;
> +	const struct net_device *mgmt_master;
> +	u32 write_val, clear_val = 0, val;
> +	int seq_num = 400;
> +	int ret, ret1;
> +	bool ack;
> +
> +	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
> +		return -EINVAL;
> +
> +	phy_hdr_data = &priv->mgmt_hdr_data;
> +
> +	write_val = QCA8K_MDIO_MASTER_BUSY | QCA8K_MDIO_MASTER_EN |
> +		    QCA8K_MDIO_MASTER_PHY_ADDR(phy) |
> +		    QCA8K_MDIO_MASTER_REG_ADDR(regnum);
> +
> +	if (read) {
> +		write_val |= QCA8K_MDIO_MASTER_READ;
> +	} else {
> +		write_val |= QCA8K_MDIO_MASTER_WRITE;
> +		write_val |= QCA8K_MDIO_MASTER_DATA(data);
> +	}
> +
> +	/* Prealloc all the needed skb before the lock */
> +	write_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL,
> +					    &write_val, seq_num, QCA8K_ETHERNET_PHY_PRIORITY);
> +	if (!write_skb)
> +		return -ENOMEM;
> +
> +	clear_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL,
> +					    &clear_val, seq_num, QCA8K_ETHERNET_PHY_PRIORITY);
> +	if (!write_skb)

Clean up the resources!!! (not just here but everywhere)

> +		return -ENOMEM;
> +
> +	read_skb = qca8k_alloc_mdio_header(MDIO_READ, QCA8K_MDIO_MASTER_CTRL,
> +					   &clear_val, seq_num, QCA8K_ETHERNET_PHY_PRIORITY);
> +	if (!write_skb)
> +		return -ENOMEM;
> +
> +	/* Actually start the request:
> +	 * 1. Send mdio master packet
> +	 * 2. Busy Wait for mdio master command
> +	 * 3. Get the data if we are reading
> +	 * 4. Reset the mdio master (even with error)
> +	 */
> +	mutex_lock(&phy_hdr_data->mutex);

Shouldn't qca8k_master_change() also take phy_hdr_data->mutex?

> +
> +	/* Recheck mgmt_master under lock to make sure it's operational */
> +	mgmt_master = priv->mgmt_master;
> +	if (!mgmt_master)
> +		return -EINVAL;
> +
> +	read_skb->dev = (struct net_device *)mgmt_master;
> +	clear_skb->dev = (struct net_device *)mgmt_master;
> +	write_skb->dev = (struct net_device *)mgmt_master;

If you need the master to be a non-const pointer, just make the DSA
method give you a non-const pointer.

> +
> +	reinit_completion(&phy_hdr_data->rw_done);
> +	phy_hdr_data->ack = false;
> +	phy_hdr_data->seq = seq_num;
> +
> +	dev_queue_xmit(write_skb);
> +
> +	ret = wait_for_completion_timeout(&phy_hdr_data->rw_done,
> +					  QCA8K_ETHERNET_TIMEOUT);
> +
> +	ack = phy_hdr_data->ack;
> +
> +	if (ret <= 0) {
> +		ret = -ETIMEDOUT;
> +		goto exit;
> +	}
> +
> +	if (!ack) {
> +		ret = -EINVAL;
> +		goto exit;
> +	}
> +
> +	ret = read_poll_timeout(qca8k_phy_eth_busy_wait, ret1,
> +				!(val & QCA8K_MDIO_MASTER_BUSY), 0,
> +				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
> +				phy_hdr_data, read_skb, &val);
> +
> +	if (ret < 0 && ret1 < 0) {
> +		ret = ret1;
> +		goto exit;
> +	}
> +
> +	if (read) {
> +		reinit_completion(&phy_hdr_data->rw_done);
> +		phy_hdr_data->ack = false;
> +
> +		dev_queue_xmit(read_skb);
> +
> +		ret = wait_for_completion_timeout(&phy_hdr_data->rw_done,
> +						  QCA8K_ETHERNET_TIMEOUT);
> +
> +		ack = phy_hdr_data->ack;
> +
> +		if (ret <= 0) {
> +			ret = -ETIMEDOUT;
> +			goto exit;
> +		}
> +
> +		if (!ack) {
> +			ret = -EINVAL;
> +			goto exit;
> +		}
> +
> +		ret = phy_hdr_data->data[0] & QCA8K_MDIO_MASTER_DATA_MASK;
> +	}
> +
> +exit:
> +	reinit_completion(&phy_hdr_data->rw_done);
> +	phy_hdr_data->ack = false;
> +
> +	dev_queue_xmit(clear_skb);
> +
> +	wait_for_completion_timeout(&phy_hdr_data->rw_done,
> +				    QCA8K_ETHERNET_TIMEOUT);
> +
> +	mutex_unlock(&phy_hdr_data->mutex);
> +
> +	return ret;
> +}
> +
>  static u32
>  qca8k_port_to_phy(int port)
>  {
> @@ -970,6 +1130,14 @@ qca8k_internal_mdio_write(struct mii_bus *slave_bus, int phy, int regnum, u16 da
>  {
>  	struct qca8k_priv *priv = slave_bus->priv;
>  	struct mii_bus *bus = priv->bus;
> +	int ret;
> +
> +	/* Use mdio Ethernet when available, fallback to legacy one on error */
> +	if (priv->mgmt_master) {
> +		ret = qca8k_phy_eth_command(priv, false, phy, regnum, data);
> +		if (!ret)
> +			return 0;
> +	}
>  
>  	return qca8k_mdio_write(bus, phy, regnum, data);
>  }
> @@ -979,6 +1147,14 @@ qca8k_internal_mdio_read(struct mii_bus *slave_bus, int phy, int regnum)
>  {
>  	struct qca8k_priv *priv = slave_bus->priv;
>  	struct mii_bus *bus = priv->bus;
> +	int ret;
> +
> +	/* Use mdio Ethernet when available, fallback to legacy one on error */
> +	if (priv->mgmt_master) {
> +		ret = qca8k_phy_eth_command(priv, true, phy, regnum, 0);
> +		if (ret >= 0)
> +			return ret;
> +	}
>  
>  	return qca8k_mdio_read(bus, phy, regnum);
>  }
> @@ -987,6 +1163,7 @@ static int
>  qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
>  {
>  	struct qca8k_priv *priv = ds->priv;
> +	int ret;
>  
>  	/* Check if the legacy mapping should be used and the
>  	 * port is not correctly mapped to the right PHY in the
> @@ -995,6 +1172,13 @@ qca8k_phy_write(struct dsa_switch *ds, int port, int regnum, u16 data)
>  	if (priv->legacy_phy_port_mapping)
>  		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
>  
> +	/* Use mdio Ethernet when available, fallback to legacy one on error */
> +	if (priv->mgmt_master) {
> +		ret = qca8k_phy_eth_command(priv, true, port, regnum, 0);
> +		if (!ret)
> +			return ret;
> +	}
> +
>  	return qca8k_mdio_write(priv->bus, port, regnum, data);
>  }
>  
> @@ -1011,6 +1195,13 @@ qca8k_phy_read(struct dsa_switch *ds, int port, int regnum)
>  	if (priv->legacy_phy_port_mapping)
>  		port = qca8k_port_to_phy(port) % PHY_MAX_ADDR;
>  
> +	/* Use mdio Ethernet when available, fallback to legacy one on error */
> +	if (priv->mgmt_master) {
> +		ret = qca8k_phy_eth_command(priv, true, port, regnum, 0);
> +		if (ret >= 0)
> +			return ret;
> +	}
> +
>  	ret = qca8k_mdio_read(priv->bus, port, regnum);
>  
>  	if (ret < 0)
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index dc1365542aa3..952217db2047 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -14,6 +14,7 @@
>  #include <linux/dsa/tag_qca.h>
>  
>  #define QCA8K_ETHERNET_MDIO_PRIORITY			7
> +#define QCA8K_ETHERNET_PHY_PRIORITY			6
>  #define QCA8K_ETHERNET_TIMEOUT				100
>  
>  #define QCA8K_NUM_PORTS					7
> -- 
> 2.33.1
> 
