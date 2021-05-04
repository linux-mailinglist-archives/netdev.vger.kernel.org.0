Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8137E373240
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhEDWNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbhEDWNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:13:15 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A2BC061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 15:12:19 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id v5so4351523ljg.12
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 15:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=gVQmufPwKJtCQC2u2kfaalH0EtY79vcshm5uX6ahfOE=;
        b=Z6IF5X7hfmSyH+IZCb9KmKUYUj2RwtXF0I1HQFJG5l9mqGSplduBk9JjfiAp9WXOnm
         sUkUCJRf4X3WhL48q+pcJyaf17BQahzmsjqUrmSFUJA7S6XAa7CmG7bv5vD5p2lYLXM2
         3qCIXu+gemlBBbZlH8nT67iDve0G3jzurKThOjepG4zrMLdjeDTgeTUNAP2tNg4O2Ngp
         YscBQx9dTAJI5pxlCyYhkACj4vouEv8kUlZTAr6O2KjZ88KQ4gYC3i6Ywi/+BJTHHD5S
         DetLpUJYERMbO24QuoGh/YVZy1wxe2r7IMRaKxTWMLQWy+JI4RpX2sXMkAIP8lhLF7lo
         tW2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gVQmufPwKJtCQC2u2kfaalH0EtY79vcshm5uX6ahfOE=;
        b=QTpDwZssvJNs/JQ3PPVzsl6OXJF6S475wNKkF4h6PH7FrIJyv92bbHvNsJTArI3n45
         mvvgbzjSZgWheS1GrDwN+t4XoZX2Gd+KAP/8dq0xP7Wc2Vx3YXeuDppes4C5GYph6wsr
         6tAjXMzILb1fzwVBp/TxYqwMh66BM3UJWzugwxGvaa5GiGEjOuHRQG/KTb5hWASKFtAn
         xWOTwjSNeTjfXDFSU7YyFPhBtOxu1TA390uTovUiz8xghGVYXme9A7AaRmJMAdGa8Kn4
         XCDf1qOQUBXYseJVEQazzD7H44V2F5eJznr0Xh/oggEvWMegxDL74QK4KbWFzQy3fL5n
         8k4w==
X-Gm-Message-State: AOAM530K5G4Bkhxwe4CX4fPS6V4/XCAMYuuxIXXNs/pGacnWBgLlxieQ
        p67yGHOK5nYV5zxbh9XDorsRog==
X-Google-Smtp-Source: ABdhPJwtJh6aAJ1yIf5atzwSsXELsfulOMLP4DBoKxRmdTDxt9vokgYKbQQtSSdbnf9sLGw0ZUZsvg==
X-Received: by 2002:a05:651c:316:: with SMTP id a22mr8754131ljp.255.1620166337733;
        Tue, 04 May 2021 15:12:17 -0700 (PDT)
Received: from wkz-x280 (h-90-88.A259.priv.bahnhof.se. [212.85.90.88])
        by smtp.gmail.com with ESMTPSA id u27sm371593lfm.239.2021.05.04.15.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:12:17 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@resnulli.us, idosch@idosch.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 6/9] net: dsa: Forward offloading
In-Reply-To: <20210504205823.j5wg547lgyw776rl@skbuf>
References: <20210426170411.1789186-1-tobias@waldekranz.com> <20210426170411.1789186-7-tobias@waldekranz.com> <20210427101747.n3y6w6o7thl5cz3r@skbuf> <878s4uo8xc.fsf@waldekranz.com> <20210504152106.oppawchuruapg4sb@skbuf> <874kfintzh.fsf@waldekranz.com> <20210504205823.j5wg547lgyw776rl@skbuf>
Date:   Wed, 05 May 2021 00:12:15 +0200
Message-ID: <87y2cum9mo.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 23:58, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, May 04, 2021 at 10:07:14PM +0200, Tobias Waldekranz wrote:
>> On Tue, May 04, 2021 at 18:21, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Tue, May 04, 2021 at 04:44:31PM +0200, Tobias Waldekranz wrote:
>> >> On Tue, Apr 27, 2021 at 13:17, Vladimir Oltean <olteanv@gmail.com> wrote:
>> >> > On Mon, Apr 26, 2021 at 07:04:08PM +0200, Tobias Waldekranz wrote:
>> >> >> Allow DSA drivers to support forward offloading from a bridge by:
>> >> >> 
>> >> >> - Passing calls to .ndo_dfwd_{add,del}_station to the drivers.
>> >> >> 
>> >> >> - Recording the subordinate device of offloaded skbs in the control
>> >> >>   buffer so that the tagger can take the appropriate action.
>> >> >> 
>> >> >> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> >> >> ---
>> >> >>  include/net/dsa.h |  7 +++++++
>> >> >>  net/dsa/slave.c   | 36 ++++++++++++++++++++++++++++++++++--
>> >> >>  2 files changed, 41 insertions(+), 2 deletions(-)
>> >> >> 
>> >> >> diff --git a/include/net/dsa.h b/include/net/dsa.h
>> >> >> index 1f9ba9889034..77d4df819299 100644
>> >> >> --- a/include/net/dsa.h
>> >> >> +++ b/include/net/dsa.h
>> >> >> @@ -119,6 +119,7 @@ struct dsa_netdevice_ops {
>> >> >>  
>> >> >>  struct dsa_skb_cb {
>> >> >>  	struct sk_buff *clone;
>> >> >> +	struct net_device *sb_dev;
>> >> >>  };
>> >> >>  
>> >> >>  struct __dsa_skb_cb {
>> >> >> @@ -828,6 +829,12 @@ struct dsa_switch_ops {
>> >> >>  					  const struct switchdev_obj_ring_role_mrp *mrp);
>> >> >>  	int	(*port_mrp_del_ring_role)(struct dsa_switch *ds, int port,
>> >> >>  					  const struct switchdev_obj_ring_role_mrp *mrp);
>> >> >> +
>> >> >> +	/* L2 forward offloading */
>> >> >> +	void *	(*dfwd_add_station)(struct dsa_switch *ds, int port,
>> >> >> +				    struct net_device *sb_dev);
>> >> >> +	void	(*dfwd_del_station)(struct dsa_switch *ds, int port,
>> >> >> +				    struct net_device *sb_dev);
>> >> >>  };
>> >> >>  
>> >> >>  #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
>> >> >> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>> >> >> index 77b33bd161b8..3689ffa2dbb8 100644
>> >> >> --- a/net/dsa/slave.c
>> >> >> +++ b/net/dsa/slave.c
>> >> >> @@ -657,6 +657,13 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
>> >> >>  	return dsa_enqueue_skb(nskb, dev);
>> >> >>  }
>> >> >>  
>> >> >> +static u16 dsa_slave_select_queue(struct net_device *dev, struct sk_buff *skb,
>> >> >> +				  struct net_device *sb_dev)
>> >> >> +{
>> >> >> +	DSA_SKB_CB(skb)->sb_dev = sb_dev;
>> >> >> +	return netdev_pick_tx(dev, skb, sb_dev);
>> >> >> +}
>> >> >> +
>> >> >
>> >> > DSA_SKB_CB is going away:
>> >> > https://patchwork.kernel.org/project/netdevbpf/patch/20210427042203.26258-5-yangbo.lu@nxp.com/
>> >> >
>> >> > Let's either negotiate with Yangbo on keeping it, or make
>> >> > .ndo_select_queue a bypass towards the tagger, where it can use its own
>> >> > SKB_CB structure and be more flexible in general (I think I'm leaning
>> >> > towards the latter).
>> >> 
>> >> Thus far, Yangbo is a tough negotiator, giving me the silent treatment:
>> >> 
>> >> https://lore.kernel.org/netdev/87y2d2noe5.fsf@waldekranz.com/
>> >> 
>> >> :)
>> >> 
>> >> That memset is giving me a hard time. I have just disabled it on my
>> >> branch at the moment. Any ideas on how to get rid of it without breaking
>> >> timestamping?
>> >
>> > :)
>> >
>> > Is there any guarantee written somewhere that the ownership of skb->cb
>> > belongs to the NIC driver at the time of the ndo_select_queue call?
>> >
>> > If there is, then the trivial solution is to just move the memset in
>> > ndo_select_queue.
>> >
>> > If there isn't, then we've got bigger issues (such as, for example, the
>> > qdisc layer being able to overwrite your DSA_SKB_CB(skb)->sb_dev).
>> 
>> The comment says:
>> 
>>    "This is owned by whoever has the skb queued ATM."
>> 
>> But qdisc_skb_cb is a thing as it turns out - so I think I can kiss the
>> idea of stashing the pointer in the CB goodbye.
>> 
>> Looking at some of the other users of .ndo_select_queue, I get the
>> feeling that we should really:
>> 
>> - Pre-generate a FROM_CPU tag template and store it under "TxQ 0"
>> - Pre-generate a FORWARD tag template and store it under "TxQ 1"
>> - Redfine tag_dsa's .ndo_select_queue to be: `return sb_dev ? 1 : 0;`
>> - Fetch the template using skb_queue_mapping, fill in the VID, and send
>>   it.
>
> Different drivers use TX queues in different ways. For example, for the
> switches with TSN offloads, we set ds->num_tx_queues to a value equal to
> the number of hardware traffic classes, so that the CPU can inject
> packets with a specific QOS_CLASS field in the DSA header (think VLAN PCP).
> This is really visible with tc-taprio where some traffic classes can be
> completely turned off, so you can easily tell which TC was a packet
> enqueued to. Other switches use TX queues in other ways. Some Broadcom
> tagging protocols use the skb queue_mapping to direct the packets to one
> of multiple TX queues of the DSA master, in order to apply backpressure
> in case there is congestion on the front port.
>
> Selecting a TX queue based on which upper netdev the packet is coming
> form sounds to me like the oddest of the bunch. It really adds one more
> dimension to the existing uses, I am not sure that this is how it was
> intended to be done [ and why, for example, if the sb_dev was propagated
> so deeply into dev_queue_xmit, why was it not propagated all the way to
> .ndo_start_xmit ], but on the other hand, you have more working
> experience with the dev_queue_xmit_accel API than the zero I have.

Yeah it does not feel right. I expect mv88e6xxx will also want to expose
the real number of queues in the future. Some of the newer devices have
support for time aware shapers for example.

As for why sb_dev is not propagated to .ndo_start_xmit: I chalked it up
to the existing users managing the macvlan offloads by directing those
flows to a particular TxQ. I.e. they simply had no need for it.

Or perhaps they did not have the nerve to send the commit that changed
the signature of _every_ driver's .ndo_start_xmit :)

> By the way (to show how little I know) what does "d" in "dfwd" stand for?
> It almost sounds to me like a typo that was carried along from
> NETIF_F_HW_L2FW_DOFFLOAD_BIT.

That has been bugging me as well! I have no idea.

> We might need to ask for the input of some people from Intel who worked
> on this offload framework. For example, I just added Alexander Duyck
> hoping he can provide some suggestions. We just want the sb_dev in
> ndo_start_xmit, and abusing ndo_select_queue seems like a huge hack just
> to obtain that.

I think you are right.

>> There is really no need to recompute the static parts of the tags on
>> each skb. It would mean moving some knowledge of the tagging format to
>> the driver. But that boundary is pretty artificial for
>> mv88e6xxx. tag_dsa has no use outside of mv88e6xxx, and mv88e6xxx does
>> not work with any other tagger. I suppose you could even move the whole
>> tagger to drivers/net/dsa/mv88e6xxx/?
>> 
>> What do you think?
>> 
>> Andrew?
>
> [ not Andrew, but ]
>
> I made that mistake so that you don't have to. You don't actually gain
> as much as you think (performance is about the same, what you win in
> instruction count and conditionals you lose in the memcpy),

That is valuable info, thank you. But I think the most important
improvement I see would be the ability to couple the tagger tighter to
the driver when we add more complicated features.

> and you
> create a dependency between the tagger and the switch driver which was
> supposed by design to not exist.

Sure, but _why_ should it not exist? Many fields in the tag can only be
correctly generated/interpreted in combination with knowledge of the
current configuration, which is the driver's domain. The dependency is
already there, etched in silicon.

> For my drivers I tried to remove this
> dependency - see commit 7c4bb540e917 ("net: dsa: tag_ocelot: create
> separate tagger for Seville"). Also, in the case of Ocelot switches,
> a template was used to mask out handling differences between switch
> generations, and present them to user space as "the same tagger".
> Another bad idea. In general, if a tagging protocol is testable with
> dsa_loop this is a plus. People at NXP wanted to see how their drivers
> perform with Marvell switches (what are their options for balancing with
> RFS/RSS) and this is what they did, changed DSA_TAG_PROTO_NONE from what
> dsa_loop advertises. If they need the actual switch driver to initialize
> the tagger's template, suddenly it's not so fun anymore.

I shall have to look more closely at dsa_loop, so far I have just seen
the name float by on a few occasions.

> If it ever becomes important enough, I suppose dsa_loop could even gain
> support for the new .change_tag_protocol API to advertise the
> feasibility of the idea in general, although given how DYI dsa_loop is
> in general, maybe changing the tag protocol at runtime isn't so
> important.
