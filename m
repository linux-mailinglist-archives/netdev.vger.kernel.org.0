Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B323F46C7AB
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 23:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242303AbhLGWtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 17:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242298AbhLGWs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 17:48:59 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A2BC061574;
        Tue,  7 Dec 2021 14:45:28 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id t5so2042038edd.0;
        Tue, 07 Dec 2021 14:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mv2YzdvEcKnWynBtJ0zu8K4EGopTvu+UUigAf5oKgtI=;
        b=e1uQPkhjj6JuHWcMwoZ+qquFEA8V0yIuPJ5f7F/fxBdxvfV5ouXH6bpNF3ZYs3puvN
         i9BedRbdsUcJP3MShDXoUW/YSOTsCQX5XlYqHMbbg++60xFS1UA/h9mKF1IZI71+oYlI
         DKoPMn0QVnj1a/GVjXmJoqgWCa/WMbeHhsZNYDmFd9ugARkbvMuYemhLo6VMPpOqk56M
         F3riERYOsw7k8ypdMo+pkbID2EofPEipmDhcqLWIc1CdXwbGUzujYvQ74DaClgbUKK6s
         GZB2I4/8SNVFltgRsFRdqpMt2LMSu7IwRWs98LGXevg8aGauvEd7JSMyAPZrdgrolXO9
         Kpdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mv2YzdvEcKnWynBtJ0zu8K4EGopTvu+UUigAf5oKgtI=;
        b=ho+VGSNejy1mfu+QX1ax25Wcg7QH+ovrCQpGZ7HS4kVsBW9w+xrD+OUzr+JDrLWpjy
         bkrijzBrqY9aDGKcNqQz1tx7BFlVmFMRq1eeN1Jg44uYD/bSLkq9xilZK5Iyp/B24unC
         oRUExtUUmIEHZ+hfMLXezFTRSsDSlEKwrK83ThMJ4Svr1jGWMj03c0F0B5EaG0wqll6a
         iAgbn7JzgJSmu6bNrLW9nvwAx1FHTfxMNFfVwSmnqDv+mR5hc0IM16VDIJOFo0I3N9uM
         Sywm5di7998OjAypjfg7jlCrJc/gM7AsA+ywkFGUvyT1Qi4/lDPgdb74xH0YxPye4Fet
         o22w==
X-Gm-Message-State: AOAM532MU+xJVVKv3acJUn7b3aY73JJ8ELGELZ+EERFZF0fDVKuSzetV
        1bFsPvTrPVNkMUbB/4HVylc=
X-Google-Smtp-Source: ABdhPJz/HOfd/mNIBrDyJdaW4XfmgBDW096hi3RTGZu4klZTnXmAh8YejbLw5pQ1z4G89dGPgEub8Q==
X-Received: by 2002:a50:d543:: with SMTP id f3mr13199722edj.56.1638917127106;
        Tue, 07 Dec 2021 14:45:27 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id v3sm728604edc.69.2021.12.07.14.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 14:45:26 -0800 (PST)
Date:   Wed, 8 Dec 2021 00:45:25 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <20211207224525.ckdn66tpfba5gm5z@skbuf>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 10:47:59PM +0100, Ansuel Smith wrote:
> The main problem here is that we really need a way to have shared data
> between tagger and dsa driver. I also think that it would be limiting
> using this only for mdio. For example qca8k can autocast mib with
> Ethernet port and that would be another feature that the tagger would
> handle.

This is cool. I suppose this is what QCA_HDR_RECV_TYPE_MIB is for.
But it wouldn't work with your design because the tagger doesn't hold
any queues, it is basically a request/response which is always initiated
by the switch driver. The hardware can't automatically push anything to
software on its own. Maybe if the tagger wouldn't be stateless, that
would be better? What if the qca8k switch driver would just provide some
function pointers to the switch driver (these would be protocol
sub-handlers for QCA_HDR_RECV_TYPE_MIB, QCA_HDR_RECV_TYPE_RW_REG_ACK
etc), and your completion structure would be both initialized, as well
as finalized, all from within the switch driver itself?

> I like the idea of tagger-owend per-switch-tree private data.
> Do we really need to hook logic?
> Wonder if something like that would work:
> 1. Each tagger declare size of his private data (if any).
> 2. Change tag dsa helper make sure the privata data in dst gets
>    allocated and freed.
> 3. We create some helper to get the tagger private data pointer that
>    dsa driver will use. (an error is returned if no data is present)
> 4. Tagger will use the dst to access his own data.

I considered a simplified form like this, but I think the tagger private
data will still stay in dp->priv, only its ownership will change.
It is less flexible to just have an autoalloc size. Ok, you allocate a
structure the size you need, but which dp->priv gets to have it?
Maybe a certain tagging protocol will need dp1->priv == dp2->priv ==
dp3->priv == ..., whereas a different tagging protocol will need unique
different structures for each dp.

> 
> In theory that way we should be able to make a ""connection"" between
> dsa driver and the tagger and prevent any sort of strange stuff that
> could result in bug/kernel panic.
> 
> I mean for the current task (mdio in ethernet packet) we just need to
> put data, send the skb and wait for a response (and after parsing) get
> the data from a response skb.

It would be a huge win IMO if we could avoid managing the lifetime of
dp->priv _directly_. I'm thinking something along the lines of:

- every time we make the "dst->tag_ops = tag_ops;" assignment (see dsa2.c)
  there is a connection event between the switch tree and the tagging
  protocol (and also a disconnection event, if dst->tag_ops wasn't
  previously NULL).

- we could add a new tag_ops->connect(dst) and tag_ops->disconnect(dst)
  and call them. These could allocate/free the dp->priv memory for each
  dp in &dst->ports.

- _after_ the tag_ops->connect() has been called (this makes sure that
  the tagger memory has been allocated) we could also emit a cross-chip
  notifier event:

	/* DSA_NOTIFIER_TAG_PROTO_CONNECT */
	struct dsa_notifier_tag_proto_connect_info {
		const struct dsa_device_ops *tag_ops;
	};

	struct dsa_notifier_tag_proto_connect_info info;

	dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO, &info);

  The role of a cross-chip notifier is to fan-out a call exactly once to
  every switch within a tree. This particular cross-chip notifier could
  end up with an implementation in switch.c that lands with a call to:

  ds->ops->tag_proto_connect(ds, tag_ops);

  At this point, I'm a bit fuzzy on the details. I'm thinking of
  something like this:

	struct qca8k_tagger_private {
		void (*rw_reg_ack_handler)(struct dsa_port *dp, void *buf);
		void (*mib_autocast_handler)(struct dsa_port *dp, void *buf);
	};

	static void qca8k_rw_reg_ack_handler(struct dsa_port *dp, void *buf)
	{
		... (code moved from tagger)
	}

	static void qca8k_mib_autocast_handler(struct dsa_port *dp, void *buf)
	{
		... (code moved from tagger)
	}

	static int qca8k_tag_proto_connect(struct dsa_switch *ds,
					   const struct dsa_device_ops *tag_ops)
	{
		switch (tag_ops->proto) {
		case DSA_TAG_PROTO_QCA:
			struct dsa_port *dp;

			dsa_switch_for_each_port(dp, ds) {
				struct qca8k_tagger_private *priv = dp->priv;

				priv->rw_reg_ack_handler = qca8k_rw_reg_ack_handler;
				priv->mib_autocast_handler = qca8k_mib_autocast_handler;
			}

			break;
		default:
			return -EOPNOTSUPP;
		}
	}

	static const struct dsa_switch_ops qca8k_switch_ops = {
		...
		.tag_proto_connect	= qca8k_tag_proto_connect,
	};

  My current idea is maybe not ideal and a bit fuzzy, because the switch
  driver would need to be aware of the fact that the tagger private data
  is in dp->priv, and some code in one folder needs to be in sync with
  some code in another folder. But at least it should be safer this way,
  because we are in more control over the exact connection that's being
  made.

- to avoid leaking memory, we also need to patch dsa_tree_put() to issue
  a disconnect event on unbind.

- the tagging protocol driver would always need to NULL-check the
  function pointer before dereferencing it, because it may connect to a
  switch driver that doesn't set them up (dsa_loop):

	struct qca8k_tagger_private *priv = dp->priv;

	if (priv->rw_reg_ack_handler)
		priv->rw_reg_ack_handler(dp, skb_mac_header(skb));
