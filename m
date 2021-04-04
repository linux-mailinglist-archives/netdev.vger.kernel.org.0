Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB31E353820
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 14:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhDDMyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 08:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhDDMya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 08:54:30 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDC2C061756;
        Sun,  4 Apr 2021 05:54:25 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l4so13404729ejc.10;
        Sun, 04 Apr 2021 05:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+HizwM9vIpHqP1AxzNgaBq6kldlU51EQSuMtVEGZOEM=;
        b=fQM8s80dvfjHUExYqmdyQ2teO2Tp/YiL7PRpSflgvZ6OY5IAg61aYxC/IGkYWFGy9v
         2OscoeTlNbyhVxF1v8IZm2aCRPkMuE+G3p92hzEVEkIokhtPjxSY+wdXnnKLMyOuH3RM
         WjHAo64nwnzOeprbcqvYu+KBiUJIgMv4YLpbL81cumNtyiLNuVgOXxvdi+6nPccYOKtp
         NmvuqYPVJCPp97q2odwFefvU6RxpDwLTxqePmhDMfzGhyBAeajpjWgBbK0Z4BzOz3NBE
         JflputlM7d0rc86O1BpAstTCXSRGckKaVidBUuTg5gd5cBuX4dHWyxTn/q40pGL85kJ0
         JVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+HizwM9vIpHqP1AxzNgaBq6kldlU51EQSuMtVEGZOEM=;
        b=OJMdyPSSrb7ygQL9DIysDc/vKVj32dGQUfDiE0xB+A5LhFxs+oNgZhJQ1/kK+7g3Y7
         uc2AtR8KS2lZkOtDEwMgTxVneLoNytPCq/hwLaAPjSDIKRT7LDSTsoOEucced1P/k7Mo
         Rc1xi4maiPYftc6rtsdH8HfCeAV1nk9j2LL9aqYDq9/gyoWohx8GxsP5NIJ1MN0F29+8
         q148Q3F8vtU/QSWOYlEpb30TMo9M4CUamGXqA+4Wkm1q2SKeyOBLeH8nrJ0o322e7wo2
         REuGnaK/rgNPX96elDuZeEt4sI23Cnycn9l1H67NkkCoxqz25K+boYy3sOJEPo3EWYB7
         10yw==
X-Gm-Message-State: AOAM533MojOe86M0CPa2ZfmERzjURd52UUm4jhi+5+hVI4bdNAKT1k4/
        jiEpb0AhXQ1N3mWSN74OQIE=
X-Google-Smtp-Source: ABdhPJxqZxiZH9w1dtAEGfiGomK6i6zyau8jCjw5tfcQTuXFeLBmjnXcHl95LOalQVqLyPyl2P/uDw==
X-Received: by 2002:a17:906:811:: with SMTP id e17mr9052375ejd.535.1617540864050;
        Sun, 04 Apr 2021 05:54:24 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id dj8sm1490033edb.86.2021.04.04.05.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 05:54:22 -0700 (PDT)
Date:   Sun, 4 Apr 2021 15:54:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <linux@rempel-privat.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/9] net: dsa: add rcv_post call back
Message-ID: <20210404125421.ljc43lsa3pllji4q@skbuf>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-2-o.rempel@pengutronix.de>
 <20210403140534.c4ydlgu5hqh7bmcq@skbuf>
 <20210403232116.knf6d7gdrvamk2lj@skbuf>
 <14262704-5793-1483-9a6b-c6a29d88ebf7@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14262704-5793-1483-9a6b-c6a29d88ebf7@rempel-privat.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 04, 2021 at 07:49:03AM +0200, Oleksij Rempel wrote:
> Am 04.04.21 um 01:21 schrieb Vladimir Oltean:
> > On Sat, Apr 03, 2021 at 05:05:34PM +0300, Vladimir Oltean wrote:
> >> On Sat, Apr 03, 2021 at 01:48:40PM +0200, Oleksij Rempel wrote:
> >>> Some switches (for example ar9331) do not provide enough information
> >>> about forwarded packets. If the switch decision was made based on IPv4
> >>> or IPv6 header, we need to analyze it and set proper flag.
> >>>
> >>> Potentially we can do it in existing rcv path, on other hand we can
> >>> avoid part of duplicated work and let the dsa framework set skb header
> >>> pointers and then use preprocessed skb one step later withing the rcv_post
> >>> call back.
> >>>
> >>> This patch is needed for ar9331 switch.
> >>>
> >>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> >>> ---
> >>
> >> I don't necessarily disagree with this, perhaps we can even move
> >> Florian's dsa_untag_bridge_pvid() call inside a rcv_post() method
> >> implemented by the DSA_TAG_PROTO_BRCM_LEGACY, DSA_TAG_PROTO_BRCM_PREPEND
> >> and DSA_TAG_PROTO_BRCM taggers. Or even better, because Oleksij's
> >> rcv_post is already prototype-compatible with dsa_untag_bridge_pvid, we
> >> can already do:
> >>
> >> 	.rcv_post = dsa_untag_bridge_pvid,
> >>
> >> This should be generally useful for stuff that DSA taggers need to do
> >> which is easiest done after eth_type_trans() was called.
> >
> > I had some fun with an alternative method of parsing the frame for IGMP
> > so that you can clear skb->offload_fwd_mark, which doesn't rely on the
> > introduction of a new method in DSA. It should also have several other
> > advantages compared to your solution such as the fact that it should
> > work with VLAN-tagged packets.
> >
> > Background: we made Receive Packet Steering work on DSA master interfaces
> > (echo 3 > /sys/class/net/eth0/queues/rx-1/rps_cpus) even when the DSA
> > tag shifts to the right the IP headers and everything that comes
> > afterwards. The flow dissector had to be patched for that, just grep for
> > DSA in net/core/flow_dissector.c.
> >
> > The problem you're facing is that you can't parse the IP and IGMP
> > headers in the tagger's rcv() method, since the network header,
> > transport header offsets and skb->protocol are all messed up, since
> > eth_type_trans hasn't been called yet.
> >
> > And that's the trick right there, you're between a rock and a hard
> > place: too early because eth_type_trans wasn't called yet, and too late
> > because skb->dev was changed and no longer points to the DSA master, so
> > the flow dissector adjustment we made doesn't apply.
> >
> > But if you call the flow dissector _before_ you call "skb->dev =
> > dsa_master_find_slave" (and yes, while the DSA tag is still there), then
> > it's virtually as if you had called that while the skb belonged to the
> > DSA master, so it should work with __skb_flow_dissect.
> >
> > In fact I prototyped this idea below. I wanted to check whether I can
> > match something as fine-grained as an IGMPv2 Membership Report message,
> > and I could.
> >
> > I prototyped it inside the ocelot tagging protocol driver because that's
> > what I had handy. I used __skb_flow_dissect with my own flow dissector
> > which had to be initialized at the tagger module_init time, even though
> > I think I could have probably just called skb_flow_dissect_flow_keys
> > with a standard dissector, and that would have removed the need for the
> > custom module_init in tag_ocelot.c. One thing that is interesting is
> > that I had to add the bits for IGMP parsing to the flow dissector
> > myself (based on the existing ICMP code). I was too lazy to do that for
> > MLD as well, but it is really not hard. Or even better, if you don't
> > need to look at all inside the IGMP/MLD header, I think you can even
> > omit adding this parsing code to the flow dissector and just look at
> > basic.n_proto and basic.ip_proto.
> >
> > See the snippet below. Hope it helps.
> >
> > -----------------------------[ cut here ]-----------------------------
> > diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> > index ffd386ea0dbb..4c25fa47637a 100644
> > --- a/include/net/flow_dissector.h
> > +++ b/include/net/flow_dissector.h
> > @@ -190,6 +190,20 @@ struct flow_dissector_key_icmp {
> >  	u16 id;
> >  };
> >
> > +/**
> > + * flow_dissector_key_igmp:
> > + *		type: indicates the message type, see include/uapi/linux/igmp.h
> > + *		code: Max Resp Code, the maximum time in 1/10 second
> > + *		      increments before sending a responding report
> > + *		group: the multicast address being queried when sending a
> > + *		       Group-Specific or Group-and-Source-Specific Query.
> > + */
> > +struct flow_dissector_key_igmp {
> > +	u8 type;
> > +	u8 code; /* Max Resp Time in IGMPv2 */
> > +	__be32 group;
> > +};
> > +
> >  /**
> >   * struct flow_dissector_key_eth_addrs:
> >   * @src: source Ethernet address
> > @@ -259,6 +273,7 @@ enum flow_dissector_key_id {
> >  	FLOW_DISSECTOR_KEY_PORTS, /* struct flow_dissector_key_ports */
> >  	FLOW_DISSECTOR_KEY_PORTS_RANGE, /* struct flow_dissector_key_ports */
> >  	FLOW_DISSECTOR_KEY_ICMP, /* struct flow_dissector_key_icmp */
> > +	FLOW_DISSECTOR_KEY_IGMP, /* struct flow_dissector_key_igmp */
> >  	FLOW_DISSECTOR_KEY_ETH_ADDRS, /* struct flow_dissector_key_eth_addrs */
> >  	FLOW_DISSECTOR_KEY_TIPC, /* struct flow_dissector_key_tipc */
> >  	FLOW_DISSECTOR_KEY_ARP, /* struct flow_dissector_key_arp */
> > @@ -314,6 +329,7 @@ struct flow_keys {
> >  	struct flow_dissector_key_keyid keyid;
> >  	struct flow_dissector_key_ports ports;
> >  	struct flow_dissector_key_icmp icmp;
> > +	struct flow_dissector_key_igmp igmp;
> >  	/* 'addrs' must be the last member */
> >  	struct flow_dissector_key_addrs addrs;
> >  };
> > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > index 5985029e43d4..8cc8c34ea5cd 100644
> > --- a/net/core/flow_dissector.c
> > +++ b/net/core/flow_dissector.c
> > @@ -202,6 +202,30 @@ static void __skb_flow_dissect_icmp(const struct sk_buff *skb,
> >  	skb_flow_get_icmp_tci(skb, key_icmp, data, thoff, hlen);
> >  }
> >
> > +static void __skb_flow_dissect_igmp(const struct sk_buff *skb,
> > +				    struct flow_dissector *flow_dissector,
> > +				    void *target_container, const void *data,
> > +				    int thoff, int hlen)
> > +{
> > +	struct flow_dissector_key_igmp *key_igmp;
> > +	struct igmphdr *ih, _ih;
> > +
> > +	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_IGMP))
> > +		return;
> > +
> > +	ih = __skb_header_pointer(skb, thoff, sizeof(_ih), data, hlen, &_ih);
> > +	if (!ih)
> > +		return;
> > +
> > +	key_igmp = skb_flow_dissector_target(flow_dissector,
> > +					     FLOW_DISSECTOR_KEY_IGMP,
> > +					     target_container);
> > +
> > +	key_igmp->type = ih->type;
> > +	key_igmp->code = ih->code;
> > +	key_igmp->group = ih->group;
> > +}
> > +
> >  void skb_flow_dissect_meta(const struct sk_buff *skb,
> >  			   struct flow_dissector *flow_dissector,
> >  			   void *target_container)
> > @@ -1398,6 +1422,11 @@ bool __skb_flow_dissect(const struct net *net,
> >  					data, nhoff, hlen);
> >  		break;
> >
> > +	case IPPROTO_IGMP:
> > +		__skb_flow_dissect_igmp(skb, flow_dissector, target_container,
> > +					data, nhoff, hlen);
> > +		break;
> > +
> >  	default:
> >  		break;
> >  	}
> > diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
> > index f9df9cac81c5..a2cc824ddeec 100644
> > --- a/net/dsa/tag_ocelot.c
> > +++ b/net/dsa/tag_ocelot.c
> > @@ -2,9 +2,51 @@
> >  /* Copyright 2019 NXP Semiconductors
> >   */
> >  #include <linux/dsa/ocelot.h>
> > +#include <linux/igmp.h>
> >  #include <soc/mscc/ocelot.h>
> >  #include "dsa_priv.h"
> >
> > +static const struct flow_dissector_key ocelot_flow_keys[] = {
> > +	{
> > +		.key_id = FLOW_DISSECTOR_KEY_CONTROL,
> > +		.offset = offsetof(struct flow_keys, control),
> > +	},
> > +	{
> > +		.key_id = FLOW_DISSECTOR_KEY_BASIC,
> > +		.offset = offsetof(struct flow_keys, basic),
> > +	},
> > +	{
> > +		.key_id = FLOW_DISSECTOR_KEY_IGMP,
> > +		.offset = offsetof(struct flow_keys, igmp),
> > +	},
> > +};
> > +
> > +static struct flow_dissector ocelot_flow_dissector __read_mostly;
> > +
> > +static struct sk_buff *ocelot_drop_igmp(struct sk_buff *skb)
> > +{
> > +	struct flow_keys fk;
> > +
> > +	memset(&fk, 0, sizeof(fk));
> > +
> > +	if (!__skb_flow_dissect(NULL, skb, &ocelot_flow_dissector,
> > +				&fk, NULL, 0, 0, 0, 0))
> > +		return skb;
> > +
> > +	if (fk.basic.n_proto != htons(ETH_P_IP))
> > +		return skb;
> > +
> > +	if (fk.basic.ip_proto != IPPROTO_IGMP)
> > +		return skb;
> > +
> > +	if (fk.igmp.type != IGMPV2_HOST_MEMBERSHIP_REPORT)
> > +		return skb;
> > +
> > +	skb_dump(KERN_ERR, skb, true);
> > +
> > +	return NULL;
> > +}
> > +
> >  static void ocelot_xmit_ptp(struct dsa_port *dp, void *injection,
> >  			    struct sk_buff *clone)
> >  {
> > @@ -84,6 +126,10 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
> >  	u8 *extraction;
> >  	u16 vlan_tpid;
> >
> > +	skb = ocelot_drop_igmp(skb);
> > +	if (!skb)
> > +		return NULL;
> 
> I probably like this idea, but i need more understanding :)
> 
> In case of ocelot_drop_igmp() you wont to really drop it? Or it is just
> example on how it may potentially work?
> I ask, because IGMP should not be dropped.

Uhm, yeah, it is just an example of 'how to do X with IGMP packets from
the DSA receive path'. You don't have to drop them.
