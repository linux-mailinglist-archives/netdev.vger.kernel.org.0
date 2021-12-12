Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86E9471BED
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 18:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhLLRlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 12:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhLLRlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 12:41:12 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AE5C061714;
        Sun, 12 Dec 2021 09:41:11 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id x15so46061059edv.1;
        Sun, 12 Dec 2021 09:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=rgr1d/YrVpI7hbfeQOSnBR7NSoI2BGjuQbEFjp/yWMU=;
        b=Ch8V0hmdXzfeyR9Q5gBViPdn5DIvU5670++iUn3ZwV5/30kODvIMJn4nJLisga0Col
         wDb/JOZMp/9O7+b6Spx1J7vlh3Th2p9gxpZUOyoZyzA20W/EE7w5TGFs2x7bLppsWnDm
         k9F0WzN95E+keXB8DxQNx5kmoUjR59HooC0fuNp7FLLZd9FC1Nck9TXuxPW5NHK0k4a/
         TS1FCDk5HyRGTsYXEx8ECxaKUE9XxZKztYpT/ax3M1BnlZRdDSPFDCUxQ1SKm4KVHUDJ
         lmy+5hGiSlvYxAMIMNYdwQ+1GFnumLZpisFT6950GmJ8ZmxMmG5LvRyzEmFkFlCCPKZb
         q9mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=rgr1d/YrVpI7hbfeQOSnBR7NSoI2BGjuQbEFjp/yWMU=;
        b=ujSVGonS2/mIFLS8rBAMAizWEy76drlUJKW/2t5ILWKZTR0i3L9cVudvMBKmSRLBpI
         KOp+XtcrzY+wcs8ftt4HCu/7BcebVsBuIJTR105lsqVWCShjy2Gr/Gw0LcMEmw96QiWa
         72+s1AqIehq/Eh5Ug/eGyImPZNeGgb+fH8CSr0mczTk1WLhES+CHTGVDsSGKqD/VxN7q
         bGYPNpFTRiKwYHMWJL0ujZEbmhjrqjQif6CjnjeyFb0BTfbXJr0HipqXVF7s+szdBjS4
         sIgZXqqE3D3DJbat3e154KLKO3o4FiqK1DoSAy0HkEEkSbr3vyEPEbsptZhxRN/DyLUj
         urGg==
X-Gm-Message-State: AOAM5323K0LQSZgmDauyOiktxIGjtgwZSk9MMosSR9sSp8hryhrSnafy
        EYi67+lhjqzogNGlvZmipPW7AM0iK1vGEw==
X-Google-Smtp-Source: ABdhPJwYGQM9rDoGReXZbUJm4RDziAzupCnH7lhHRjSoqgbqx8h2QzMVqVDFzuF1b9G01MNjORqlQw==
X-Received: by 2002:a05:6402:1388:: with SMTP id b8mr56978541edv.171.1639330869695;
        Sun, 12 Dec 2021 09:41:09 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id cy26sm4972464edb.7.2021.12.12.09.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Dec 2021 09:41:09 -0800 (PST)
Message-ID: <61b63435.1c69fb81.c034e.3f94@mx.google.com>
X-Google-Original-Message-ID: <YbY0MwG7/q1zIDZ0@Ansuel-xps.>
Date:   Sun, 12 Dec 2021 18:41:07 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH v4 12/15] net: dsa: qca8k: add support for
 mdio read/write in Ethernet packet
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
 <20211211195758.28962-13-ansuelsmth@gmail.com>
 <1776b726-6a96-d522-e625-f0f6b108782a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1776b726-6a96-d522-e625-f0f6b108782a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 08:12:51PM -0800, Florian Fainelli wrote:
> 
> 
> On 12/11/2021 11:57 AM, Ansuel Smith wrote:
> > Add qca8k side support for mdio read/write in Ethernet packet.
> > qca8k supports some specially crafted Ethernet packet that can be used
> > for mdio read/write instead of the legacy method uart/internal mdio.
> > This add support for the qca8k side to craft the packet and enqueue it.
> > Each port and the qca8k_priv have a special struct to put data in it.
> > The completion API is used to wait for the packet to be received back
> > with the requested data.
> > 
> > The various steps are:
> > 1. Craft the special packet with the qca hdr set to mdio read/write
> >     mode.
> > 2. Set the lock in the dedicated mdio struct.
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
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> 
> [snip]
> 
> > +
> > +static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
> > +					       int seq_num)
> > +{
> > +	struct mdio_ethhdr *mdio_ethhdr;
> > +	struct sk_buff *skb;
> > +	u16 hdr;
> > +
> > +	skb = dev_alloc_skb(QCA_HDR_MDIO_PKG_LEN);
> 
> No out of memory condition handling?
>

Will add.

> > +
> > +	prefetchw(skb->data);
> 
> What's the point you are going to dirty the cache lines right below with
> your skb_push().
> 

Will drop.

> > +
> > +	skb_reset_mac_header(skb);
> > +	skb_set_network_header(skb, skb->len);
> > +
> > +	mdio_ethhdr = skb_push(skb, QCA_HDR_MDIO_HEADER_LEN + QCA_HDR_LEN);
> > +
> > +	hdr = FIELD_PREP(QCA_HDR_XMIT_VERSION, QCA_HDR_VERSION);
> > +	hdr |= QCA_HDR_XMIT_FROM_CPU;
> > +	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(0));
> > +	hdr |= FIELD_PREP(QCA_HDR_XMIT_CONTROL, QCA_HDR_XMIT_TYPE_RW_REG);
> > +
> > +	mdio_ethhdr->seq = FIELD_PREP(QCA_HDR_MDIO_SEQ_NUM, seq_num);
> > +
> > +	mdio_ethhdr->command = FIELD_PREP(QCA_HDR_MDIO_ADDR, reg);
> > +	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_LENGTH, 4);
> > +	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_CMD, cmd);
> > +	mdio_ethhdr->command |= FIELD_PREP(QCA_HDR_MDIO_CHECK_CODE, MDIO_CHECK_CODE_VAL);
> > +
> > +	if (cmd == MDIO_WRITE)
> > +		mdio_ethhdr->mdio_data = *val;
> > +
> > +	mdio_ethhdr->hdr = htons(hdr);
> > +
> > +	skb_put_zero(skb, QCA_HDR_MDIO_DATA2_LEN);
> > +	skb_put_zero(skb, QCA_HDR_MDIO_PADDING_LEN);
> > +
> > +	return skb;
> > +}
> > +
> > +static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
> > +{
> > +	struct qca8k_mdio_hdr_data *mdio_hdr_data = &priv->mdio_hdr_data;
> > +	struct sk_buff *skb;
> > +	bool ack;
> > +	int ret;
> > +
> > +	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200);
> > +	skb->dev = dsa_to_port(priv->ds, 0)->master;
> 
> Surely you should be checking that this is the CPU port and obtain it from
> DSA instead of hard coding it to 0.
> 

You are right as we can also have port6 as cpu port.

> > +
> > +	mutex_lock(&mdio_hdr_data->mutex);
> > +
> > +	reinit_completion(&mdio_hdr_data->rw_done);
> > +	mdio_hdr_data->seq = 200;
> > +	mdio_hdr_data->ack = false;
> > +
> > +	dev_queue_xmit(skb);
> > +
> > +	ret = wait_for_completion_timeout(&mdio_hdr_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
> 
> msec_to_jiffies(QCA8K_ETHERNET_TIMEOUT) at least?

Sorry got it work and misread that the conversion was implicit.

> -- 
> Florian

-- 
	Ansuel
