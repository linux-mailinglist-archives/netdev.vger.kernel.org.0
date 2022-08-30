Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F9E5A67AC
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiH3Prp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiH3Pro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:47:44 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB184B2D9A
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 08:47:41 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id qh18so2772567ejb.7
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 08:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=sFioudYa8F7v3PoLEE3UntBcxa49zByR20vnYZmNPhw=;
        b=HtXEyr0+EvTrXwwj05OW6cfn96M6NiE43BgGdsr84+z2Kf3yTvnigJZu+iJ2DrTSrx
         Q/sNzv52Bmj2UDTBcxhUV785X29RaBF95S6j4Grs1C4ov1BT8kZGY7UweZ9hj1pevciz
         PpLQ+hEVKpqbnOU8QXxBvLxf55+3mCSB9IBKIIyJ4WiqAs/qA6lwI3xK3skCxMA0u1HZ
         NmBQLoYRx86KQuwZ/WtyP7xqGhY9jy4Q9VtSHhsniXK91h83Xxq8mxNmLjVJORPK24KT
         Hx474CvM6LgkVshh9eJKBvQ54DR8j788RELUu1LOMK0s7U2gzkY+VaPstXolzDNpj5IH
         0k9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=sFioudYa8F7v3PoLEE3UntBcxa49zByR20vnYZmNPhw=;
        b=25YqIWnc4IZzMd/m0uDnGmoE9tqP/OUGV8+soPGxeHUylYjmwsuUVThL/9Bayx9dgT
         zqbOyNbUWSWgHzCGyJhu/jAFKFb8L/IBpgjnwatEGYNrAVcQpnHCEdqS79S5Q7WIY+dq
         dUbSIfYjHYOFmpqvF0vJst4d9oxYQPylAqyWUI3o9P0LX9/dTZE53wRU7cIJzc5jmHGS
         yRFOf5cwjiKdWjbi+taOgWSw/SGbcoR2rJz0Bix7dL41xj3YtrvwHGJyw60A6taBayih
         kXd9Dm8FtsAV25WMm2x/jjMkP+zyVpSSNx9hvJZdGSyFsIIVDk9KFaxwGsF2C5sYOmN8
         FB9g==
X-Gm-Message-State: ACgBeo1klYs9264d1jXrUEPQLeoqwpGcvqb/tCWtSIYja10SlDCc6Wov
        IEpI9yW9tpWaJhLOz/YiV3w=
X-Google-Smtp-Source: AA6agR7tAtiUHbX00dmVL5lqbKC8iX183DbJhDJA1N+mLY05cOrJJy0LgpVuFMji9LMh1ptwdGc3Qg==
X-Received: by 2002:a17:907:7faa:b0:741:7674:5ea1 with SMTP id qk42-20020a1709077faa00b0074176745ea1mr8581220ejc.27.1661874459733;
        Tue, 30 Aug 2022 08:47:39 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id h8-20020a50ed88000000b004463b99bc09sm7550410edr.88.2022.08.30.08.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 08:47:39 -0700 (PDT)
Date:   Tue, 30 Aug 2022 18:47:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 1/3] dsa: Implement RMU layer in DSA
Message-ID: <20220830154737.no5rd5k4ateu56zs@skbuf>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
 <20220826063816.948397-2-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826063816.948397-2-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 08:38:14AM +0200, Mattias Forsblad wrote:
> Support handling of layer 2 part for RMU frames which is
> handled in-band with other DSA traffic.

Great explanation, everything is clear!

> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  include/net/dsa.h             |   7 +++
>  include/uapi/linux/if_ether.h |   1 +
>  net/dsa/tag_dsa.c             | 109 +++++++++++++++++++++++++++++++++-
>  3 files changed, 114 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index f2ce12860546..54f7f3494f84 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -92,6 +92,7 @@ struct dsa_switch;
>  struct dsa_device_ops {
>  	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
>  	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev);
> +	int (*inband_xmit)(struct sk_buff *skb, struct net_device *dev, int seq_no);

There isn't a reason that I can see to expand the DSA tagger ops with an
inband_xmit(). DSA tagging protocol ops are reactive hooks to modify
packets belonging to slave interfaces, rather than initiators of traffic.

Here you are calling tag_ops->inband_xmit() from mv88e6xxx_rmu_tx(),
i.e. this operation is never invoked from the DSA core, but from a code
path fully in control of the hardware driver. We don't usually (ever?)
use DSA ops in this way, but rather just a way for the framework to
invoke driver-specific code.

Is there a reason why dsa_inband_xmit_ll() cannot simply live within the
mv88e6xxx driver (the direct caller) rather than within the dsa/edsa tagger?

Tagging protocols can be changed at driver runtime, but only while the
DSA master is down. So when the master goes up, you can also check which
tagging protocol is in use, and cache/use that to construct the skb.

Furthermore, there is no slave interface associated with RMU traffic,
although in your proposed implementation here, there is (that's what
"struct net_device *dev" passed here is).

Which slave @dev are you passing? That's right, dev_get_by_name(&init_net, "chan0").
I think it's pretty obvious there is a systematic problem with your approach.
Not everyone has a slave net device called chan0 in the main netns.

The qca8k implementation, as opposed to yours, calls dev_queue_xmit()
with skb->dev directly on the DSA master, and forgoes the DSA tagger on
TX. I don't see a problem with that approach, on the contrary, I think
it's better and simpler.

>  	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
>  			     int *offset);
>  	int (*connect)(struct dsa_switch *ds);
> @@ -1193,6 +1194,12 @@ struct dsa_switch_ops {
>  	void	(*master_state_change)(struct dsa_switch *ds,
>  				       const struct net_device *master,
>  				       bool operational);
> +
> +	/*
> +	 * RMU operations
> +	 */
> +	int (*inband_receive)(struct dsa_switch *ds, struct sk_buff *skb,
> +			int seq_no);
>  };
>  
>  #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
> diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
> index d370165bc621..9de1bdc7cccc 100644
> --- a/include/uapi/linux/if_ether.h
> +++ b/include/uapi/linux/if_ether.h
> @@ -158,6 +158,7 @@
>  #define ETH_P_MCTP	0x00FA		/* Management component transport
>  					 * protocol packets
>  					 */
> +#define ETH_P_RMU_DSA   0x00FB          /* RMU DSA protocol */

I think it's more normal to set skb->protocol = eth->h_proto = htons(the actual EtherType),
rather than introducing a new skb->protocol which won't be used anywhere.

>  
>  /*
>   *	This is an Ethernet frame header.
> diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
> index e4b6e3f2a3db..36f02e7dd3c3 100644
> --- a/net/dsa/tag_dsa.c
> +++ b/net/dsa/tag_dsa.c
> @@ -123,6 +123,90 @@ enum dsa_code {
>  	DSA_CODE_RESERVED_7    = 7
>  };
>  
> +#define DSA_RMU_RESV1   0x3e
> +#define DSA_RMU         1
> +#define DSA_RMU_PRIO    6
> +#define DSA_RMU_RESV2   0xf
> +
> +static int dsa_inband_xmit_ll(struct sk_buff *skb, struct net_device *dev,
> +			      const u8 *header, int header_len, int seq_no)
> +{
> +	static const u8 dest_addr[ETH_ALEN] = { 0x01, 0x50, 0x43, 0x00, 0x00, 0x00 };
> +	struct dsa_port *dp;
> +	struct ethhdr *eth;
> +	u8 *data;
> +
> +	if (!dev)
> +		return -ENODEV;
> +
> +	dp = dsa_slave_to_port(dev);
> +	if (!dp)
> +		return -ENODEV;
> +
> +	/* Create RMU L2 header */
> +	data = skb_push(skb, 6);
> +	data[0] = (DSA_CMD_FROM_CPU << 6) | dp->ds->index;
> +	data[1] = DSA_RMU_RESV1 << 2 | DSA_RMU << 1;
> +	data[2] = DSA_RMU_PRIO << 5 | DSA_RMU_RESV2;
> +	data[3] = seq_no;
> +	data[4] = 0;
> +	data[5] = 0;
> +
> +	/* Add header if any */
> +	if (header) {
> +		data = skb_push(skb, header_len);
> +		memcpy(data, header, header_len);
> +	}
> +
> +	/* Create MAC header */
> +	eth = (struct ethhdr *)skb_push(skb, 2 * ETH_ALEN);
> +	memcpy(eth->h_source, dev->dev_addr, ETH_ALEN);
> +	memcpy(eth->h_dest, dest_addr, ETH_ALEN);
> +
> +	skb->protocol = htons(ETH_P_RMU_DSA);
> +
> +	dev_queue_xmit(skb);

Just for things to be 100% clear for everyone. Per your design, we have
dsa_inband_xmit() which gets called by the driver with a slave @dev, and
this constructs an skb without the DSA/EDSA header. Then dev_queue_xmit()
will invoke the ndo_start_xmit of DSA, dsa_slave_xmit(). In turn this
will enter the tagging protocol driver a second time, through p->xmit() ->
dsa_xmit_ll(). The second time is when the DSA/EDSA header is actually
introduced.

This is way more complicated than it needs to be.

> +
> +	return 0;
> +}
> +
> +static int dsa_inband_rcv_ll(struct sk_buff *skb, struct net_device *dev)
> +{
> +	struct dsa_switch *ds;
> +	int source_device;
> +	u8 *dsa_header;
> +	int rcv_seqno;
> +	int ret = 0;
> +
> +	if (!dev || !dev->dsa_ptr)
> +		return 0;

Way too defensive programming which wastes CPU cycles for nothing. The
DSA rcv hook runs as an ETH_P_XDSA packet_type handler on the DSA master,
based on eth_type_trans() which had set skb->protocol to ETH_P_XDSA
based on the presence of dev->dsa_ptr. So yes, the DSA master is not NULL,
and yes, the DSA master's dev->dsa_ptr is not NULL either.

> +
> +	ds = dev->dsa_ptr->ds;
> +	if (!ds)
> +		return 0;

We don't have NULL pointers in cpu_dp->ds lying around. dp->ds is set by
dsa_port_touch(), which runs earlier than dsa_master_setup() sets
dev->dsa_ptr in such a way that we start processing RX packets.

> +
> +	dsa_header = skb->data - 2;

Please use dsa_etype_header_pos_rx(). In fact, this pointer was already
available in dsa_rcv_ll().

> +
> +	source_device = dsa_header[0] & 0x1f;
> +	ds = dsa_switch_find(ds->dst->index, source_device);
> +	if (!ds) {
> +		net_dbg_ratelimited("DSA inband: Didn't find switch with index %d", source_device);
> +		return -EINVAL;
> +	}
> +
> +	/* Get rcv seqno */
> +	rcv_seqno = dsa_header[3];
> +
> +	skb_pull(skb, DSA_HLEN);
> +
> +	if (ds->ops && ds->ops->inband_receive(ds, skb, rcv_seqno)) {

I think the reason why Andrew is asking you to find common aspects with
qca8k which can be further generalized is because your proposed code is
very ambitious, introducing a generic ds->ops->inband_receive() like this.

I personally wouldn't be so ambitious for myself. The way the qca8k
driver and tagging protocol work together is that they set up a group of
driver-specific function pointers, rw_reg_ack_handler and mib_autocast_handler,
through which the switch driver connected to the tagger may subscribe as
a consumer to the received Ethernet management packets. Whereas you are
proposing a one-size-fits-all ds->ops->inband_receive with no effort to
see if it fits even the single other user of this concept, qca8k.

What I would do is introduce one more case of driver-specific consumer
of RMU packets, specific to the dsa/edsa tagger <-> mv88e6xxx driver pair.
I'd let things sit for a while, maybe wait for a third user, then see
how/if the prototype for consuming Ethernet management packets can be
made generic.

But in general, we need drivers to handle non-data RX packets coming
from the switch for all sorts of reasons. For example SJA1110 delivers
back TX timestamps as Ethernet packets, and I wouldn't consider
expanding ds->ops for that. This driver-specific hook mechanism
("tagger owned storage" as I named it) is flexible enough to allow each
driver to respond to the needs of its hardware, without needing
everybody else to follow suit or suffer of ops bloat because of it.
I wouldn't rush.

> +		dev_dbg_ratelimited(ds->dev, "DSA inband: error decoding packet");
> +		ret = -EIO;
> +	}
> +
> +	return ret;
