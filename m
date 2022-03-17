Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC1D4DC86C
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiCQOL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiCQOL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:11:56 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296761FDFF1
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:10:40 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8DBF45C01F4;
        Thu, 17 Mar 2022 10:10:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 17 Mar 2022 10:10:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EM/EaadoJeMn03+1V
        Xz8JupSmIhoAMXOUHmgiAQU3LQ=; b=ktFhWcaJFkT4pCHYie7+3qWhR/jUTihfn
        XumBm73rpPQXi0RH34AEC+4IMad9j/ql8dicCj12TCzGhI4RU6ZyEsBQ+3zIYrKQ
        bGDn1Slw3FRxz4vOFCGgajWuMgTtiLJ8ZAXLLclxvcdF6J5o3H1fLy7Mxhqz7syZ
        Vy73ZX1Uem2GFzpFr1Ng0oQGGSPVYzbyJQH54xjTBc1d+KmJJrbovWbkhxy9reBU
        IRjDlO7lZf/4UWye7mmDKCzAXC+nL9egI3KOV3lDAtXyLx21F+gTDieprBaIcHWm
        JhwUW66cXOWVgdq7cosxhUmYuCqd2f4mgr/buo2nvyGUloSo01RGg==
X-ME-Sender: <xms:X0EzYpKgsVM5jpxDzO5MhzkFi2RkrCw8PbYN39Gc-2rvBMdP7PBZzQ>
    <xme:X0EzYlKmciNmXCMVP5sXsy5eJ4Bv3Hayx-24P_uDv0Mayxvl2rRIeYuJlaBCjssQw
    sbCT832BzVeDzU>
X-ME-Received: <xmr:X0EzYhvVNoA4OOhHvR8EDy1yZvcK-d4cB9Bs8ltV6apzJBpfVy877ibhT37j2XaxVX1nAg7NqL567x5MDd6piZlnH3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudefgedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgjeevhfdvgeeiudekteduveegueejfefffeefteekkeeuueehjeduledtjeeu
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:X0EzYqZqlv5efyqpKDoseUdNWUkmAdZNmar-QoVP63aGU7g0iAOlyA>
    <xmx:X0EzYgZRKAtKpmZEH-S5y8iEZlpUq27tRGqs9qgnsZ6Cg-7gixqnMA>
    <xmx:X0EzYuB_ZF8YR5Qy5m-RS_7AW9lUq2MWkmV6ro94HAyVTWOr8-2NZg>
    <xmx:X0EzYumAU4EANEB1RPU-ymzQvhTpzd82Gz2g8Y173hrzIScjG4lWoQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Mar 2022 10:10:38 -0400 (EDT)
Date:   Thu, 17 Mar 2022 16:10:34 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH 2/5] net: bridge: Implement bridge flood flag
Message-ID: <YjNBWsAsOidtTtIB@shredder>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
 <20220317065031.3830481-3-mattias.forsblad@gmail.com>
 <87r1717xrz.fsf@gmail.com>
 <50f4e8b0-4eea-d202-383b-bf2c2824322d@gmail.com>
 <cf7af730-1f98-f845-038b-43104fa060cd@blackwall.org>
 <YjMo9xyoycXgSWXS@shredder>
 <87r170k8i9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r170k8i9.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 02:34:38PM +0100, Tobias Waldekranz wrote:
> On Thu, Mar 17, 2022 at 14:26, Ido Schimmel <idosch@idosch.org> wrote:
> > On Thu, Mar 17, 2022 at 01:42:55PM +0200, Nikolay Aleksandrov wrote:
> >> On 17/03/2022 13:39, Mattias Forsblad wrote:
> >> > On 2022-03-17 10:07, Joachim Wiberg wrote:
> >> >> On Thu, Mar 17, 2022 at 07:50, Mattias Forsblad <mattias.forsblad@gmail.com> wrote:
> >> >>> This patch implements the bridge flood flags. There are three different
> >> >>> flags matching unicast, multicast and broadcast. When the corresponding
> >> >>> flag is cleared packets received on bridge ports will not be flooded
> >> >>> towards the bridge.
> >> >>
> >> >> If I've not completely misunderstood things, I believe the flood and
> >> >> mcast_flood flags operate on unknown unicast and multicast.  With that
> >> >> in mind I think the hot path in br_input.c needs a bit more eyes.  I'll
> >> >> add my own comments below.
> >> >>
> >> >> Happy incident I saw this patch set, I have a very similar one for these
> >> >> flags to the bridge itself, with the intent to improve handling of all
> >> >> classes of multicast to/from the bridge itself.
> >> >>
> >> >>> [snip]
> >> >>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> >> >>> index e0c13fcc50ed..fcb0757bfdcc 100644
> >> >>> --- a/net/bridge/br_input.c
> >> >>> +++ b/net/bridge/br_input.c
> >> >>> @@ -109,11 +109,12 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
> >> >>>  		/* by definition the broadcast is also a multicast address */
> >> >>>  		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
> >> >>>  			pkt_type = BR_PKT_BROADCAST;
> >> >>> -			local_rcv = true;
> >> >>> +			local_rcv = true && br_opt_get(br, BROPT_BCAST_FLOOD);
> >> >>
> >> >> Minor comment, I believe the preferred style is more like this:
> >> >>
> >> >> 	if (br_opt_get(br, BROPT_BCAST_FLOOD))
> >> >>         	local_rcv = true;
> >> >>
> >> >>>  		} else {
> >> >>>  			pkt_type = BR_PKT_MULTICAST;
> >> >>> -			if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
> >> >>> -				goto drop;
> >> >>> +			if (br_opt_get(br, BROPT_MCAST_FLOOD))
> >> >>> +				if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
> >> >>> +					goto drop;
> >> >>
> >> >> Since the BROPT_MCAST_FLOOD flag should only control uknown multicast,
> >> >> we cannot bypass the call to br_multicast_rcv(), which helps with the
> >> >> classifcation.  E.g., we want IGMP/MLD reports to be forwarded to all
> >> >> router ports, while the mdb lookup (below) is what an tell us if we
> >> >> have uknown multicast and there we can check the BROPT_MCAST_FLOOD
> >> >> flag for the bridge itself.
> >> > 
> >> > The original flag was name was local_receive to separate it from being
> >> > mistaken for the flood unknown flags. However the comment I've got was
> >> > to align it with the existing (port) flags. These flags have nothing to do with
> >> > the port flood unknown flags. Imagine the setup below:
> >> > 
> >> >            vlan1
> >> >              |
> >> >             br0             br1
> >> >            /   \           /   \
> >> >          swp1 swp2       swp3 swp4
> >> > 
> >> > We want to have swp1/2 as member of a normal vlan filtering bridge br0 /w learning on. 
> >> > On br1 we want to just forward packets between swp3/4 and disable learning. 
> >> > Additional we don't want this traffic to impact the CPU. 
> >> > If we disable learning on swp3/4 all traffic will be unknown and if we also 
> >> > have flood unknown on the CPU-port because of requirements for br0 it will
> >> > impact the traffic to br1. Thus we want to restrict traffic between swp3/4<->CPU port
> >> > with the help of the PVT.
> >> > 
> >> > /Mattias
> >> 
> >> The feedback was correct and we all assumed unknown traffic control.
> >> If you don't want any local receive then use filtering rules. Don't add unnecessary flags.
> >
> > Yep. Very easy with tc:
> >
> > # tc qdisc add dev br1 clsact
> > # tc filter add dev br1 ingress pref 1 proto all matchall action drop
> >
> > This can be fully implemented inside the relevant device driver, no
> > changes needed in the bridge driver.
> 
> Interesting. Are you saying that a switchdev driver can offload rules
> for a netdev that it does not directly control (e.g. bridge that it is
> connected to)? It thought that you had to bind the relevant ports to the
> same block to approximate that. If so, are any drivers implementing
> this? I did a quick scan of mlxsw, but could not find anything obvious.

Yes, currently mlxsw only supports filters configured on physical
netdevs, but the HW can support more advanced configurations such as
filters on a bridge device (or a VLAN upper). These would be translated
to ACLs configured on the ingress/egress router interface (RIF) backing
the netdev. NIC drivers support much more advanced tc offloads due to
the prevalent usage of OVS in this space, so might be better to check
them instead.

TBH, I never looked too deeply into this, but assumed it's supported via
the indirect tc block infra. See commit 7f76fa36754b ("net: sched:
register callbacks for indirect tc block binds") for more details.

Even if I got it wrong, it would be beneficial to extend the tc offload
infra rather than patching the bridge driver to achieve a functionality
that is already supported in the SW data path via tc.
