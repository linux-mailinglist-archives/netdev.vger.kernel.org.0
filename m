Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF7049C25D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbiAZD6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235579AbiAZD6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:58:00 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB530C06161C;
        Tue, 25 Jan 2022 19:57:59 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id p12so66973368edq.9;
        Tue, 25 Jan 2022 19:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KP4uWq0QeOW5Ia4UP5ZJMtL4L9PQT08IZKjbYTw6HS4=;
        b=a5nHgAbGuHdsDvalV3ulYVHh+F1AkBi7D4xvdgo8vjgBGDBNpMeEZ7Kh1rO27nGlJR
         mb5ahifZdue9eehkIJvAlubM1bMvEvUK/VMW/5SfD4hKgA/+wM34ZxK0NPSvzt8cZMTs
         Bgzh8y3w9SPZM07C+qImpZH0kTJQIS7GcFki1pSC7lGoNh2G2KzCpdpmgSLGACMmQADV
         MB9OTWR+KPbx75eAlRzInn10FKzhjN1G7W0azz/anZcDTp0mjRT1mAMLdH53oDCPLzM8
         El4G5GP1KHrjHOLi6yIBlQKPHgXZMp9jr+UBd5YtcEWHnOMRag/c9GYsR812NRm1BMlO
         6c5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KP4uWq0QeOW5Ia4UP5ZJMtL4L9PQT08IZKjbYTw6HS4=;
        b=ii5kGNDq/9agV6ZlZHXbvypyJizDptPUGAXlzB5wa34XQuUhpgbAT+yBTjmwreRsFQ
         xpIj6KzVDdzzEGQ+tmga9nvC8pd8lpHBMU5LZNjS7zeuJ6dgl1QQbfoyTnAYeTZLcgvO
         eHoFRCL0gDW0zq3A3D8K2l8jc+dzORqMjHP33VotNcfCOterb8VQuSjCQRwy64gamW55
         SHEChxPEAHjfvdSGsK29QwBklPSUWACKXBThKIts+h68ByFPMX7ehX3QJoPxl/i9HOZX
         6BrOHHED9k74ABVMYYh1wJSQ56wAFQoWkzGZ1T2RnnkNrAJXov4rSPA2GB+o0HDADcQQ
         LE2w==
X-Gm-Message-State: AOAM531/StTOl547P3UdMxAF3qF6ewJGuV9HuyNsdp+dyGtViq+nIxF3
        KBpajyblcC9yWdkFISsMVbE=
X-Google-Smtp-Source: ABdhPJxhF1UcSBfLkC/26usZ4e4zApS3y0H2vFkMmUbqAL+fTo2jr7YLh5XCDnTbl+wbJr1DInQc4w==
X-Received: by 2002:a05:6402:2294:: with SMTP id cw20mr23332046edb.178.1643169478148;
        Tue, 25 Jan 2022 19:57:58 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id fh23sm6940036ejc.176.2022.01.25.19.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 19:57:57 -0800 (PST)
Date:   Wed, 26 Jan 2022 04:57:56 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 15/16] net: da: qca8k: add support for larger
 read/write size with mgmt Ethernet
Message-ID: <YfDGxIKzvGlZnltP@Ansuel-xps.localdomain>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-16-ansuelsmth@gmail.com>
 <ce5891d1-d0ae-ba59-65ad-3ece92496c86@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce5891d1-d0ae-ba59-65ad-3ece92496c86@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 07:48:27PM -0800, Florian Fainelli wrote:
> 
> 
> On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> > mgmt Ethernet packet can read/write up to 16byte at times. The len reg
> > is limited to 15 (0xf). The switch actually sends and accepts data in 4
> > different steps of len values.
> > Len steps:
> > - 0: nothing
> > - 1-4: first 4 byte
> > - 5-6: first 12 byte
> > - 7-15: all 16 byte
> 
> This is really odd, it almost felt like the length was a byte enable
> bitmask, but it is not?
>

To me it seems like they match the size to the 3 different operation
that is
4: normal mdio / reg access
12: acl table to directly write and read it
16: offload table that is 16 byte long to directl write and read.

With this in mind, it does make sense why it bheave like that.

> > 
> > In the allock skb function we check if the len is 16 and we fix it to a
> > len of 15.
> 
> s/allock/alloc/
> 
> > It the read/write function interest to extract the real asked
> > data. The tagger handler will always copy the fully 16byte with a READ
> > command. This is useful for some big regs like the fdb reg that are
> > more than 4byte of data. This permits to introduce a bulk function that
> > will send and request the entire entry in one go.
> > Write function is changed and it does now require to pass the pointer to
> > val to also handle array val.
> > 
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> >   drivers/net/dsa/qca8k.c | 56 ++++++++++++++++++++++++++++++-----------
> >   1 file changed, 41 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > index 2a43fb9aeef2..0183ce2d5b74 100644
> > --- a/drivers/net/dsa/qca8k.c
> > +++ b/drivers/net/dsa/qca8k.c
> > @@ -219,7 +219,9 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
> >   	if (cmd == MDIO_READ) {
> >   		mgmt_hdr_data->data[0] = mgmt_ethhdr->mdio_data;
> > -		/* Get the rest of the 12 byte of data */
> > +		/* Get the rest of the 12 byte of data.
> > +		 * The read/write function will extract the requested data.
> > +		 */
> >   		if (len > QCA_HDR_MGMT_DATA1_LEN)
> >   			memcpy(mgmt_hdr_data->data + 1, skb->data,
> >   			       QCA_HDR_MGMT_DATA2_LEN);
> > @@ -229,16 +231,30 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
> >   }
> >   static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
> > -					       int seq_num, int priority)
> > +					       int seq_num, int priority, int len)
> 
> unsigned int len
> 
> >   {
> >   	struct mgmt_ethhdr *mgmt_ethhdr;
> >   	struct sk_buff *skb;
> > +	int real_len;
> 
> Likewise.
> 
> > +	u32 *data2;
> >   	u16 hdr;
> >   	skb = dev_alloc_skb(QCA_HDR_MGMT_PKG_LEN);
> >   	if (!skb)
> >   		return NULL;
> > +	/* Max value for len reg is 15 (0xf) but the switch actually return 16 byte
> > +	 * Actually for some reason the steps are:
> > +	 * 0: nothing
> > +	 * 1-4: first 4 byte
> > +	 * 5-6: first 12 byte
> > +	 * 7-15: all 16 byte
> > +	 */
> > +	if (len == 16)
> > +		real_len = 15;
> > +	else
> > +		real_len = len;
> > +
> >   	skb_reset_mac_header(skb);
> >   	skb_set_network_header(skb, skb->len);
> > @@ -253,7 +269,7 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
> >   	mgmt_ethhdr->seq = FIELD_PREP(QCA_HDR_MGMT_SEQ_NUM, seq_num);
> >   	mgmt_ethhdr->command = FIELD_PREP(QCA_HDR_MGMT_ADDR, reg);
> > -	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, 4);
> > +	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, real_len);
> >   	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CMD, cmd);
> >   	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CHECK_CODE,
> >   					   QCA_HDR_MGMT_CHECK_CODE_VAL);
> > @@ -263,19 +279,22 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
> >   	mgmt_ethhdr->hdr = htons(hdr);
> > -	skb_put_zero(skb, QCA_HDR_MGMT_DATA2_LEN + QCA_HDR_MGMT_PADDING_LEN);
> > +	data2 = skb_put_zero(skb, QCA_HDR_MGMT_DATA2_LEN + QCA_HDR_MGMT_PADDING_LEN);
> > +	if (cmd == MDIO_WRITE && len > QCA_HDR_MGMT_DATA1_LEN)
> > +		memcpy(data2, val + 1, len - QCA_HDR_MGMT_DATA1_LEN);
> >   	return skb;
> >   }
> > -static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
> > +static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
> >   {
> >   	struct qca8k_mgmt_hdr_data *mgmt_hdr_data = &priv->mgmt_hdr_data;
> >   	struct sk_buff *skb;
> >   	bool ack;
> >   	int ret;
> > -	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
> > +	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200,
> > +				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
> >   	if (!skb)
> >   		return -ENOMEM;
> > @@ -297,6 +316,9 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
> >   					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
> >   	*val = mgmt_hdr_data->data[0];
> > +	if (len > QCA_HDR_MGMT_DATA1_LEN)
> > +		memcpy(val + 1, mgmt_hdr_data->data + 1, len - QCA_HDR_MGMT_DATA1_LEN);
> > +
> >   	ack = mgmt_hdr_data->ack;
> >   	mutex_unlock(&mgmt_hdr_data->mutex);
> > @@ -310,14 +332,15 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
> >   	return 0;
> >   }
> > -static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 val)
> > +static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
> >   {
> >   	struct qca8k_mgmt_hdr_data *mgmt_hdr_data = &priv->mgmt_hdr_data;
> >   	struct sk_buff *skb;
> >   	bool ack;
> >   	int ret;
> > -	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, &val, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
> > +	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, val, 200,
> > +				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
> >   	if (!skb)
> >   		return -ENOMEM;
> > @@ -357,14 +380,14 @@ qca8k_regmap_update_bits_eth(struct qca8k_priv *priv, u32 reg, u32 mask, u32 wri
> >   	u32 val = 0;
> >   	int ret;
> > -	ret = qca8k_read_eth(priv, reg, &val);
> > +	ret = qca8k_read_eth(priv, reg, &val, 4);
> 
> sizeof(val) instead of 4.
> 
> >   	if (ret)
> >   		return ret;
> >   	val &= ~mask;
> >   	val |= write_val;
> > -	return qca8k_write_eth(priv, reg, val);
> > +	return qca8k_write_eth(priv, reg, &val, 4);
> 
> Likewise
> 
> >   }
> >   static int
> > @@ -376,7 +399,7 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
> >   	u16 r1, r2, page;
> >   	int ret;
> > -	if (priv->mgmt_master && !qca8k_read_eth(priv, reg, val))
> > +	if (priv->mgmt_master && !qca8k_read_eth(priv, reg, val, 4))
> 
> Likewise and everywhere below as well.
> -- 
> Florian

-- 
	Ansuel
