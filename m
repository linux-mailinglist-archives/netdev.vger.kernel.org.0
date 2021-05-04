Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE5E3731B0
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 22:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbhEDU7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 16:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhEDU7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 16:59:22 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8D4C061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 13:58:26 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id i24so12036804edy.8
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 13:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BOYKBuZRJDbnnKXC7x8lqvP/cMCF6N41p+a+mjYpo7Q=;
        b=Rc80ATLRiIJBFOz426Sho77/hatvwZj0CiB+n73qKhlbZSW+Qa+oCjucM8K96rHj46
         HAe/FkSDdAm0Wz+jdHReKxbUm6LA1aiYgCzL63il9xVTPynl9VhDLd80HV0M6t7YLShN
         bVEIIlk0FvICtUJi06+Aysj/Y0CYjuQeKRoFBcKyfzHz0DSkfJehbEI1rz2NO19svOux
         sQ85B3i9IeGE6gzr8ixzM/VoYAPAmgmG5Ih9F39a93AKOKjN4fXN2k7eAgmk7vwNbKAr
         5aiBRsNpD83fOzQHDegi4leBj1Kt07JUIIxWmlcm0trIjQC4v2OPT/NrjB363NbIvST/
         Xp/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BOYKBuZRJDbnnKXC7x8lqvP/cMCF6N41p+a+mjYpo7Q=;
        b=CxiB4tG2gx5vVT1xf26IsREojmjmhT0GPlgKznjhRr/ixKcKHvwAaAeB5dvDn+0P3n
         vveVOu8EUmUMmbICJ6tDEIv0ACWo7WNiULJFdLiQcJrCkAhKxzbfl4FDYRl24zLq1mWI
         P/+bNeKRXEYwSw3qm6/BIIXKmaU+P36SaufwEC2UVfUyhqMwo8xu9IMoxL1ZkToZRwbL
         EwanfSnqS5p6kDBMegbWP9vCOjB6Uu3OUURW5ZjnwOQNo8w1aaHLrXTVLcWl4gENm2gs
         lSW5Bf/v/xeMZ61FcBztkCKTnjGHsfpqprr0k1kYXlUslK2yW/1NULetRWsyfe3vLONQ
         +RLA==
X-Gm-Message-State: AOAM530d9TC5qMj7/JPxolKbjtvrZ7xR25GK0NkiPmueyrxGzsZSIfp3
        ZXYJ1e2DDxy2ryu6KAeWibxYCtZpoVc=
X-Google-Smtp-Source: ABdhPJySVo+NFOi75pswUNHEMMknWDB+RdmHjasna57IXz0ExIxKQClYQ4IWjwgNxVhKIoV9uqnT0w==
X-Received: by 2002:aa7:cb0a:: with SMTP id s10mr27998588edt.36.1620161905334;
        Tue, 04 May 2021 13:58:25 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id kx3sm1893442ejc.44.2021.05.04.13.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 13:58:25 -0700 (PDT)
Date:   Tue, 4 May 2021 23:58:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     andrew@lunn.ch, davem@davemloft.net, kuba@kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@resnulli.us, idosch@idosch.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 6/9] net: dsa: Forward offloading
Message-ID: <20210504205823.j5wg547lgyw776rl@skbuf>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-7-tobias@waldekranz.com>
 <20210427101747.n3y6w6o7thl5cz3r@skbuf>
 <878s4uo8xc.fsf@waldekranz.com>
 <20210504152106.oppawchuruapg4sb@skbuf>
 <874kfintzh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kfintzh.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 10:07:14PM +0200, Tobias Waldekranz wrote:
> On Tue, May 04, 2021 at 18:21, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Tue, May 04, 2021 at 04:44:31PM +0200, Tobias Waldekranz wrote:
> >> On Tue, Apr 27, 2021 at 13:17, Vladimir Oltean <olteanv@gmail.com> wrote:
> >> > On Mon, Apr 26, 2021 at 07:04:08PM +0200, Tobias Waldekranz wrote:
> >> >> Allow DSA drivers to support forward offloading from a bridge by:
> >> >> 
> >> >> - Passing calls to .ndo_dfwd_{add,del}_station to the drivers.
> >> >> 
> >> >> - Recording the subordinate device of offloaded skbs in the control
> >> >>   buffer so that the tagger can take the appropriate action.
> >> >> 
> >> >> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> >> >> ---
> >> >>  include/net/dsa.h |  7 +++++++
> >> >>  net/dsa/slave.c   | 36 ++++++++++++++++++++++++++++++++++--
> >> >>  2 files changed, 41 insertions(+), 2 deletions(-)
> >> >> 
> >> >> diff --git a/include/net/dsa.h b/include/net/dsa.h
> >> >> index 1f9ba9889034..77d4df819299 100644
> >> >> --- a/include/net/dsa.h
> >> >> +++ b/include/net/dsa.h
> >> >> @@ -119,6 +119,7 @@ struct dsa_netdevice_ops {
> >> >>  
> >> >>  struct dsa_skb_cb {
> >> >>  	struct sk_buff *clone;
> >> >> +	struct net_device *sb_dev;
> >> >>  };
> >> >>  
> >> >>  struct __dsa_skb_cb {
> >> >> @@ -828,6 +829,12 @@ struct dsa_switch_ops {
> >> >>  					  const struct switchdev_obj_ring_role_mrp *mrp);
> >> >>  	int	(*port_mrp_del_ring_role)(struct dsa_switch *ds, int port,
> >> >>  					  const struct switchdev_obj_ring_role_mrp *mrp);
> >> >> +
> >> >> +	/* L2 forward offloading */
> >> >> +	void *	(*dfwd_add_station)(struct dsa_switch *ds, int port,
> >> >> +				    struct net_device *sb_dev);
> >> >> +	void	(*dfwd_del_station)(struct dsa_switch *ds, int port,
> >> >> +				    struct net_device *sb_dev);
> >> >>  };
> >> >>  
> >> >>  #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
> >> >> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> >> >> index 77b33bd161b8..3689ffa2dbb8 100644
> >> >> --- a/net/dsa/slave.c
> >> >> +++ b/net/dsa/slave.c
> >> >> @@ -657,6 +657,13 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
> >> >>  	return dsa_enqueue_skb(nskb, dev);
> >> >>  }
> >> >>  
> >> >> +static u16 dsa_slave_select_queue(struct net_device *dev, struct sk_buff *skb,
> >> >> +				  struct net_device *sb_dev)
> >> >> +{
> >> >> +	DSA_SKB_CB(skb)->sb_dev = sb_dev;
> >> >> +	return netdev_pick_tx(dev, skb, sb_dev);
> >> >> +}
> >> >> +
> >> >
> >> > DSA_SKB_CB is going away:
> >> > https://patchwork.kernel.org/project/netdevbpf/patch/20210427042203.26258-5-yangbo.lu@nxp.com/
> >> >
> >> > Let's either negotiate with Yangbo on keeping it, or make
> >> > .ndo_select_queue a bypass towards the tagger, where it can use its own
> >> > SKB_CB structure and be more flexible in general (I think I'm leaning
> >> > towards the latter).
> >> 
> >> Thus far, Yangbo is a tough negotiator, giving me the silent treatment:
> >> 
> >> https://lore.kernel.org/netdev/87y2d2noe5.fsf@waldekranz.com/
> >> 
> >> :)
> >> 
> >> That memset is giving me a hard time. I have just disabled it on my
> >> branch at the moment. Any ideas on how to get rid of it without breaking
> >> timestamping?
> >
> > :)
> >
> > Is there any guarantee written somewhere that the ownership of skb->cb
> > belongs to the NIC driver at the time of the ndo_select_queue call?
> >
> > If there is, then the trivial solution is to just move the memset in
> > ndo_select_queue.
> >
> > If there isn't, then we've got bigger issues (such as, for example, the
> > qdisc layer being able to overwrite your DSA_SKB_CB(skb)->sb_dev).
> 
> The comment says:
> 
>    "This is owned by whoever has the skb queued ATM."
> 
> But qdisc_skb_cb is a thing as it turns out - so I think I can kiss the
> idea of stashing the pointer in the CB goodbye.
> 
> Looking at some of the other users of .ndo_select_queue, I get the
> feeling that we should really:
> 
> - Pre-generate a FROM_CPU tag template and store it under "TxQ 0"
> - Pre-generate a FORWARD tag template and store it under "TxQ 1"
> - Redfine tag_dsa's .ndo_select_queue to be: `return sb_dev ? 1 : 0;`
> - Fetch the template using skb_queue_mapping, fill in the VID, and send
>   it.

Different drivers use TX queues in different ways. For example, for the
switches with TSN offloads, we set ds->num_tx_queues to a value equal to
the number of hardware traffic classes, so that the CPU can inject
packets with a specific QOS_CLASS field in the DSA header (think VLAN PCP).
This is really visible with tc-taprio where some traffic classes can be
completely turned off, so you can easily tell which TC was a packet
enqueued to. Other switches use TX queues in other ways. Some Broadcom
tagging protocols use the skb queue_mapping to direct the packets to one
of multiple TX queues of the DSA master, in order to apply backpressure
in case there is congestion on the front port.

Selecting a TX queue based on which upper netdev the packet is coming
form sounds to me like the oddest of the bunch. It really adds one more
dimension to the existing uses, I am not sure that this is how it was
intended to be done [ and why, for example, if the sb_dev was propagated
so deeply into dev_queue_xmit, why was it not propagated all the way to
.ndo_start_xmit ], but on the other hand, you have more working
experience with the dev_queue_xmit_accel API than the zero I have.

By the way (to show how little I know) what does "d" in "dfwd" stand for?
It almost sounds to me like a typo that was carried along from
NETIF_F_HW_L2FW_DOFFLOAD_BIT.

We might need to ask for the input of some people from Intel who worked
on this offload framework. For example, I just added Alexander Duyck
hoping he can provide some suggestions. We just want the sb_dev in
ndo_start_xmit, and abusing ndo_select_queue seems like a huge hack just
to obtain that.

> There is really no need to recompute the static parts of the tags on
> each skb. It would mean moving some knowledge of the tagging format to
> the driver. But that boundary is pretty artificial for
> mv88e6xxx. tag_dsa has no use outside of mv88e6xxx, and mv88e6xxx does
> not work with any other tagger. I suppose you could even move the whole
> tagger to drivers/net/dsa/mv88e6xxx/?
> 
> What do you think?
> 
> Andrew?

[ not Andrew, but ]

I made that mistake so that you don't have to. You don't actually gain
as much as you think (performance is about the same, what you win in
instruction count and conditionals you lose in the memcpy), and you
create a dependency between the tagger and the switch driver which was
supposed by design to not exist. For my drivers I tried to remove this
dependency - see commit 7c4bb540e917 ("net: dsa: tag_ocelot: create
separate tagger for Seville"). Also, in the case of Ocelot switches,
a template was used to mask out handling differences between switch
generations, and present them to user space as "the same tagger".
Another bad idea. In general, if a tagging protocol is testable with
dsa_loop this is a plus. People at NXP wanted to see how their drivers
perform with Marvell switches (what are their options for balancing with
RFS/RSS) and this is what they did, changed DSA_TAG_PROTO_NONE from what
dsa_loop advertises. If they need the actual switch driver to initialize
the tagger's template, suddenly it's not so fun anymore.

If it ever becomes important enough, I suppose dsa_loop could even gain
support for the new .change_tag_protocol API to advertise the
feasibility of the idea in general, although given how DYI dsa_loop is
in general, maybe changing the tag protocol at runtime isn't so
important.
