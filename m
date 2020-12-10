Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984242D500E
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 02:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbgLJBGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 20:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731691AbgLJBFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 20:05:46 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AF1C0613D6
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 17:05:05 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id g20so4965769ejb.1
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 17:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=arQX23FFYOKD530tB7JtgYJDwWJ1ryZixBhYowZJcPk=;
        b=pdZik8g70cxG6LL41geYQp+9LEjX/6pI/nS74k7CMyxqSjQQZdB9SewlTVCjSRmXIj
         R0G9LsZ7LGN/IHASSl01NUcxcQp0XxWmgDdLZGRjtrTNSQ+B67fNywGvCdaN4w69vLJ1
         h80Me1LVQw5WEB5RKW/y1xL97/o6TL3K1elHAoj8LG1eNidf+Tgn1Qdn+5uHwQRdOEdU
         0bxppDXLjRRQgR77dR5Rz7DUsakbUOR7RFU3ocIIjVhHLPWrAJhX7RDEsXdKXq2JESFU
         2SNAOzVdorkjZceUswlG+HtJYhwNz/ctvzYHfdutHyUieNGo8gj58lrXkrV8xSOsIzGi
         N9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=arQX23FFYOKD530tB7JtgYJDwWJ1ryZixBhYowZJcPk=;
        b=XMMlBSrNN69zocJKfFKrtEgXD3ktc5YO9Cn+yhW2TmH4n48uusv0xUe8V/9TenlW5R
         44RIiL4D/ZY80XvNEoq+p9hXCLX041m+ymPBC4jK0SN0sTq6UXydYWk2TpeB6YhYRRDJ
         QYe1G3otQBt+CHE/9QVremrXJGpxB34E5EQhMisaKkZI7RX92Im/kWnwGRIj/Cydq8XR
         HSiWUNZGaJj8R57ql1S4pjCbZKNOhFKkPqruK2bX6EpIfq28f3dkjBIr0MfavhDQbZKh
         vo8hRbpDQLQAuH8oDkU7PSsg39dkBxTG6YHUnG72uJnHWARB6k1K4VcfqsAd3dYJce+F
         KfJg==
X-Gm-Message-State: AOAM531FUyIg8TXOmm5Z/+ojJWttSxS2nRVUMDabjdEoovUGaQxVohFl
        ryVYN1nzUwo5S01RD3p7X3g6vdBCuCk=
X-Google-Smtp-Source: ABdhPJzyXz5enQULOy960JiBFQ3crj4PHdqzZD9cJThJ4STc7UL0nDfCcNvbqb2/4BHgYyBmhj1A0g==
X-Received: by 2002:a17:907:b09:: with SMTP id h9mr4378520ejl.155.1607562304614;
        Wed, 09 Dec 2020 17:05:04 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id c12sm3222411edw.55.2020.12.09.17.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 17:05:03 -0800 (PST)
Date:   Thu, 10 Dec 2020 03:05:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201210010502.ts56e76wuxyj2qg3@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201208112350.kuvlaxqto37igczk@skbuf>
 <87mtyo5n40.fsf@waldekranz.com>
 <20201208163751.4c73gkdmy4byv3rp@skbuf>
 <87k0tr5q98.fsf@waldekranz.com>
 <20201209105326.boulnhj5hoaooppz@skbuf>
 <87eejz5asi.fsf@waldekranz.com>
 <20201209160440.evuv26c7cnkqdb22@skbuf>
 <20201209225950.GC2649111@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209225950.GC2649111@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 11:59:50PM +0100, Andrew Lunn wrote:
> > so basically my point was that I think you are adding a lot of infra
> > in core DSA that only mv88e6xxx will use.
>
> That is true already, since mv88e6xxx is currently the only driver
> which supports D in DSA. And it has been Marvell devices which
> initially inspired the DSA framework, and has pushed it forward.

Well actually, if you remember...
https://patchwork.ozlabs.org/project/netdev/list/?series=175986&state=*
This is pretty "D in DSA" too, even if the three switches are in three
disjoint trees due to tagger incompatibility.

Actually I have this novelty idea in the back of my head, where, once I
send the tag_8021q patches for ocelot, I make my ocelot+3x sja1105 board
use a single DSA switch tree, just to see how it works. That would be
the first instance of "D in DSA" with different drivers, just tagger
compatibility.

> But I someday expect another vendors switches will get added which
> also have a D in DSA concept, and hopefully we can reuse the code. And
> is Marvells implementation of LAGs truly unique? With only two drivers
> with WIP code, it is too early to say that.

Exactly, it is too early to say what is truly reusable and what isn't,
so I would incline towards trying to push as much out of DSA as possible.
When we'll see 3-4 LAG offload implementations, we can decide to share
more. But the other way around, pushing from the DSA core into drivers,
later down the road? That sounds more difficult to me. We aren't done
with the configure_vlans_while_not_filtering transition yet.

> The important thing for me, is that we don't make the API for other
> drivers more complex because if D in DSA, or the maybe odd way Marvell
> implements LAGs.

Well, at the end of the day, I don't believe we're here to define APIs,
at least not in DSA. The idea of monitoring netdev event notifiers in
order to offload certain operations is nothing new under the sun now. I
would expect that a driver writer does not see radically different APIs
between working on plain switchdev and on DSA.

> One of the long learnt lessons in kernel development. Put complexity
> in the core and make drivers simple. Because hopefully you have the
> best developers working on the core and they can deal with the
> complexity, and typically you have average developers working on
> drivers, and they are sometimes stretched getting drivers correct.

If anything, I would see "the core" here as being some sort of layer
that both switchdev and DSA could reuse. The thicker this layer would
be, the slimmer DSA and switchdev drivers would become. I am getting
tired of duplicating DSA code in the mscc/ocelot switchdev driver before
I could pass a one-liner function pointer from the felix DSA driver into
the common ocelot switch library. The "good developers/core code" vs
"average developers/hardware-specific code" dichotomy doesn't really
hold water when you take a look past the fence and see that what DSA
maintainers call core code, an "average" developer for a plain switchdev
driver calls just another Tuesday. But Tobias has nothing to do with
that and this is not the reason why I would like him to simplify.

> Given your work on ocelot driver, does this core code make the ocelot
> implementation more difficult? Or just the same?

It doesn't bother ocelot, and it doesn't help it either. I posted the
ocelot RFC series to prove that a driver can offload LAG without even
touching struct dsa_lag. And I don't even think I'm being unreasonable,
let me show you.

> struct dsa_lag {
> 	struct net_device *dev;
	^
	|
	This one we need. No doubt about it. If you don't have the ball
	you can't play.
> 
> 	int id;
	^
	|
	This one maybe or maybe not, since the driver might have a
	different understanding of a LAG ID than DSA had. Either way,
	this is low impact.
> 
> 	struct list_head ports;
	^
	|
	This is interesting. A struct dsa_port has a pointer to a
	struct dsa_lag. And a struct dsa_lag has a list of struct dsa_ports,
	on which the initial port can find itself. The mesh is too connected.
	And it doesn't provide useful information. You want to find the
	struct dsa_ports in the same LAG as you? You already can, without
	this list.
> 
> 	/* For multichip systems, we must ensure that each hash bucket
> 	 * is only enabled on a single egress port throughout the
> 	 * whole tree, lest we send duplicates. Therefore we must
> 	 * maintain a global list of active tx ports, so that each
> 	 * switch can figure out which buckets to enable on which
> 	 * ports.
> 	 */
> 	struct list_head tx_ports;
	^
	|
	First of all, my problem with this is the misplaced comment.
	When I read it, I expect it to explain why there's a list for
	ports and a separate one for tx_ports. But it doesn't do that.
	Then I need to read it diagonally to understand why multichip
	is even mentioned, since you would need to rebalance the LAGs
	only among the ports which are active regardless of multichip or
	not. The reason why multichip is mentioned can be found 4 lines
	later: "global" list.
	But as Tobias and I discussed earlier too, the port list in the
	DSA switch tree is already global. So it's not really a good
	justification. And adding a boolean "is this port active for LAG
	or not" is a lot simpler than Yet Another List. It doesn't even
	consume more memory. It consumes less, in fact, because it
	balances out with the pointers that struct dsa_port also needs
	to keep for these linked lists.
> 
> 	int num_tx;
	^
	|
	Why, just why? (To make implementation easier, yes, I was told.
	But again: why?)
> 
> 	refcount_t refcount;
	^
	|
	This is the glue that keeps all the DSA metadata associated with
	a upper bonding interface from falling apart. Of course it needs
	to be reference-counted. My only argument is: we can _easily_ do
	away with the ports and the tx_ports lists, and not really lose
	anything. All that remains is struct net_device *dev, and int
	id. If we only had the struct net_device *dev, we wouldn't need
	the reference count. You can have 10 pointers to the same
	structure, and you don't need to deal with its memory management,
	because it's not your structure. You only need to deal with
	memory management as soon as you keep metadata associated with
	it, like the LAG ID in this case. That's why I want to push back
	and see if we can't avoid computing and storing it in DSA too.
	Tobias made a good argument that he does need the int id in the
	RX data path. That should be the only place. And we settled at
	the compromise that he could keep an extra array, indexed by LAG
	ID, which returns the struct net_device *dev. So basically we'll
	have two references to a bonding interface now:
	- By port: dp->lag_dev (previously dp->lag->dev)
	- By ID: dst->lags[lag_id] (previously dst->lags.pool[id].dev)
	So basically the pool remains, but struct dsa_lag sublimates
	into a simple struct net_device *lag_dev pointer.
> };

That's it. If you're ok with having a convoluted structure that you
don't really need, fine. I mean, I could ignore it.
