Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E59646D2B9
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhLHLyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhLHLyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:54:50 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5804C061746;
        Wed,  8 Dec 2021 03:51:18 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id r25so7463343edq.7;
        Wed, 08 Dec 2021 03:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yhq+BRerCQdQ01LSwCv0LJncqMQLfzE7/JA4/r9npiI=;
        b=qZoOPA0N0LX1AyeWlLRvc7w0ibfRzd9RnK0+gBN7iZDMu/Ikx2Sc6WPDCdo9K6lpjY
         cXb4vkQ4rjFkwyRvQFeFY/EKLBM8pr8p4Q7wmTscXCCQdlzUaTrmzwXo/33p9cQGRrzv
         t7Hkp+Ho5R0rQttEHr9pyZjH6kw+76Gw4a82RPRQf7cYoZx4li61rjq70nshb4VyRGhA
         jjDKT2hxBw/tJ/NxkpRstIZwBuUHmOD9twl+5iXWB3ZfwByPsSvilqVbK9oBG/iqf9MT
         qe+B8DDxGa2YVW3kLAqkmgIUTNHbP45C3vRr+P3KsT40r8xD8o0ZDRNba3SbskzG4M3H
         a92g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yhq+BRerCQdQ01LSwCv0LJncqMQLfzE7/JA4/r9npiI=;
        b=uGl7EGzcWroqCdGlfTZuclY/WRL976D1ihvi2KvJ1r1t6NXYDKFlNeyai+odX7xeoU
         g5kqTmi0I7AW5kQbO2cAsh9ES6QSckWwAKBd70+9ORIr3tHejRx7cr3CLCcXV1wGBdeo
         Rt7Cd2gGWUwoUib8PTLL7MUilREVmdbHaMy18N2Q9Eg3z/SFGCIH/iZf9pBadbmXtWfT
         2C2B6v3eMHQap0yxlluq7seKiaP5uINfVMawfBMMAo9rD4Ejb0itz+fTIt7kP27SoLV8
         7OtcU8JosNs+mlXwd3hrVHP0gInZnHvojkDOd4I/fzuSVKbx0TUTCA4xYjLCFx6Z6SRj
         cP9g==
X-Gm-Message-State: AOAM531PnnDQWR5I9jwIa4YsDIrXYZev9xSsGmP4Ik2Fmuv3BMTaklX8
        gW+kSHGklfNjeCeJEkRfpH4=
X-Google-Smtp-Source: ABdhPJwZm5EALGjYdI2OUASfj+HErk9naeKPOQxD764MnCX01BCAxS5cnrGwaV9ySewjK9B1CdSLsg==
X-Received: by 2002:a05:6402:5206:: with SMTP id s6mr18826533edd.286.1638964277313;
        Wed, 08 Dec 2021 03:51:17 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id jy28sm1345704ejc.118.2021.12.08.03.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:51:16 -0800 (PST)
Date:   Wed, 8 Dec 2021 13:51:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <20211208115115.ein52qfkde7es7ji@skbuf>
References: <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <20211207224525.ckdn66tpfba5gm5z@skbuf>
 <Ya/mD/KUYDLb7qed@lunn.ch>
 <20211207231449.bk5mxg3z2o7mmtzg@skbuf>
 <YbAL5pP6IrN1ey5e@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbAL5pP6IrN1ey5e@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 02:35:34AM +0100, Andrew Lunn wrote:
> On Wed, Dec 08, 2021 at 01:14:49AM +0200, Vladimir Oltean wrote:
> > On Tue, Dec 07, 2021 at 11:54:07PM +0100, Andrew Lunn wrote:
> > > > I considered a simplified form like this, but I think the tagger private
> > > > data will still stay in dp->priv, only its ownership will change.
> > > 
> > > Isn't dp a port structure. So there is one per port?
> > 
> > Yes, but dp->priv is a pointer. The thing it points to may not
> > necessarily be per port.
> > 
> > > This is where i think we need to separate shared state from tagger
> > > private data. Probably tagger private data is not per port. Shared
> > > state between the switch driver and the tagger maybe is per port?
> > 
> > I don't know whether there's such a big difference between
> > "shared state" vs "private data"?
> 
> The difference is to do with stopping the kernel exploding when the
> switch driver is not using the tagger it expects.
> 
> Anything which is private to the tagger is not a problem. Only the
> tagger uses it, so it cannot be wrong.
> 
> Anything which is shared between the tagger and the switch driver we
> have to be careful about. We are just passing void * pointers
> about. There is no type checking. If i'm correct about the 1:N
> relationship, we can store shared state in the tagger. The tagger
> should be O.K, because it only ever needs to deal with one format of
> shared state. The switch driver needs to handle N different formats of
> shared state, depending on which of the N different taggers are in
> operation. Ideally, when it asks for the void * pointer for shared
> information, some sort of checking is performed to ensure the void *
> is what the switch driver actually expects. Maybe it needs to pass the
> tag driver it thinks it is talking to, or as well as getting the void
> * back, it also gets the tag enum and it verifies it actually knows
> about that tag driver.

Understood what you mean now (actually I don't know what was unclear yesterday).
I should start doing something else past a certain hour...

What I've started doing now is something like this:

/* include/linux/dsa/ocelot.h */
struct ocelot_8021q_tagger_data {
	void (*xmit_work_fn)(struct kthread_work *work);
};

static inline struct ocelot_8021q_tagger_data *
ocelot_8021q_tagger_data(struct dsa_switch *ds)
{
	BUG_ON(ds->dst->tag_ops->proto != DSA_TAG_PROTO_OCELOT_8021Q);

	return ds->tagger_data;
}

/* net/dsa/tag_ocelot_8021q.c */
struct ocelot_8021q_tagger_private {
	struct ocelot_8021q_tagger_data data; /* Must be first */
	struct kthread_worker *xmit_worker;
};

static struct sk_buff *ocelot_defer_xmit(struct dsa_port *dp,
					 struct sk_buff *skb)
{
	struct ocelot_8021q_tagger_private *priv = dp->ds->tagger_data;
	struct ocelot_8021q_tagger_data *data = &priv->data;
	void (*xmit_work_fn)(struct kthread_work *work);
	struct felix_deferred_xmit_work *xmit_work;
	struct kthread_worker *xmit_worker;

	xmit_work_fn = data->xmit_work_fn;
	xmit_worker = priv->xmit_worker;

	if (!xmit_work_fn || !xmit_worker)
		return NULL;

	xmit_work = kzalloc(sizeof(*xmit_work), GFP_ATOMIC);
	if (!xmit_work)
		return NULL;

	/* Calls felix_port_deferred_xmit in felix.c */
	kthread_init_work(&xmit_work->work, xmit_work_fn);
	/* Increase refcount so the kfree_skb in dsa_slave_xmit
	 * won't really free the packet.
	 */
	xmit_work->dp = dp;
	xmit_work->skb = skb_get(skb);

	kthread_queue_work(xmit_worker, &xmit_work->work);

	return NULL;
}

static void ocelot_disconnect(struct dsa_switch_tree *dst)
{
	struct ocelot_8021q_tagger_private *priv;
	struct dsa_port *dp;

	list_for_each_entry(dp, &dst->ports, list) {
		priv = dp->ds->tagger_data;

		if (!priv)
			continue;

		if (priv->xmit_worker)
			kthread_destroy_worker(priv->xmit_worker);

		kfree(priv);
		dp->ds->tagger_data = NULL;
	}
}

static int ocelot_connect(struct dsa_switch_tree *dst)
{
	struct ocelot_8021q_tagger_private *priv;
	struct dsa_port *dp;
	int err;

	list_for_each_entry(dp, &dst->ports, list) {
		if (dp->ds->tagger_data)
			continue;

		priv = kzalloc(sizeof(*priv), GFP_KERNEL);
		if (!priv) {
			err = -ENOMEM;
			goto out;
		}

		priv->xmit_worker = kthread_create_worker(0, "felix_xmit");
		if (IS_ERR(priv->xmit_worker)) {
			err = PTR_ERR(priv->xmit_worker);
			goto out;
		}

		dp->ds->tagger_data = priv;
	}

	return 0;

out:
	ocelot_disconnect(dst);
	return err;
}

/* drivers/net/dsa/felix.c */
static int felix_connect_tag_protocol(struct dsa_switch *ds,
				      enum dsa_tag_protocol proto)
{
	struct ocelot_8021q_tagger_data *tagger_data;

	switch (proto) {
	case DSA_TAG_PROTO_OCELOT_8021Q:
		tagger_data = ocelot_8021q_tagger_data(ds);
		tagger_data->xmit_work_fn = felix_port_deferred_xmit;
		return 0;
	case DSA_TAG_PROTO_OCELOT:
	case DSA_TAG_PROTO_SEVILLE:
		return 0;
	default:
		return -EPROTONOSUPPORT;
	}
}

Something like this shares memory between what's private and what's
public (it's part of the same allocation), but there's type checking at
least, and private data isn't exposed directly. Is this ok?
