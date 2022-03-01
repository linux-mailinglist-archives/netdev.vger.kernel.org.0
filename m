Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307944C9031
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 17:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbiCAQV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 11:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbiCAQV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 11:21:28 -0500
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4342AE3A
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 08:20:46 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3CA255803C2;
        Tue,  1 Mar 2022 11:20:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 01 Mar 2022 11:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=puCegnvXXBE4aPPru
        t7Je71qYeo5eDhY1ihmiOUF38g=; b=OhDHDMGNTNtbpsgFbIR9KlPcXGFAdaNU/
        dTIcX+4QjzNQt6wdsS4zj8QjixYqhQoo0yv/yf0ZcaIMf00+Us9Nw6dkHgGKBq8t
        UrqerxZZUgaAvgMTUQ4FFBmDl1RnXfm/4XzQQQ3w4ENQ/fVBsY3ItkVF6CGTBSGM
        OhZsioOViGBWqb6UU+BU37sY5yEYxdR/lkvTdOFO/HeqakAEZL6ZXCWBTBGeegPl
        XTk0PfVqNUvz21Xej46haEBWG0Hbc/tfOBgLoSwfCCVrJjVTrmGQYczbVYsRD6fz
        5Csi3lUT/hLSO+446hOSAYksoUCuxWBKDsoTT/BPEMlPofAvx2AJg==
X-ME-Sender: <xms:20ceYpNjZkcYd9hLdi7ftHk653PeIOkqDPfS-EAaTemG2UXZ412OPw>
    <xme:20ceYr-TiPEtFZpoQQHpy8BRl1wR2Ab-cpX4KqoagoYPbH3Atn-buLOiox0hjjvb1
    2eFB3227fQ9DsU>
X-ME-Received: <xmr:20ceYoTaWFlRu7yBoa7Uw1OYeVXbQO4_bhLwCqDHm4ZXJ83_lrfM4IdNWHA0FhySCzh_8GZ5usp08KjXUm6r34PXipc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddtvddgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeehhfdthfduueehgfekkefhhedutddvveefteehteekleevgfegteevueelheek
    ueenucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:20ceYlsOuw1kxcfS1P9kojMtWfsbJpgiAUhyOAVmmbmhQKBGT0Wvwg>
    <xmx:20ceYhejskkkBaAe1PThnK83FUb4TlHwDnQRLCE4PuckQQw9jDCYgw>
    <xmx:20ceYh23sKvBlAHvcivzDMLG657DDz37Nm6xWLSWPAKrMhKUml8LbQ>
    <xmx:3EceYt577LBkXrg61yyHc9_mgaVSUcPxjaeLAWEM5qgMEXfuDwtJSw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Mar 2022 11:20:43 -0500 (EST)
Date:   Tue, 1 Mar 2022 18:20:39 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [RFC PATCH v2 net-next 05/17] net: bridge: implement unicast
 filtering for the bridge device
Message-ID: <Yh5H1zexT0/Q2bc4@shredder>
References: <20210224114350.2791260-1-olteanv@gmail.com>
 <20210224114350.2791260-6-olteanv@gmail.com>
 <YD0GyJfbhqpPjhVd@shredder.lan>
 <CA+h21hrtnXr11VXsRXokkZHQ3AQ8nNCLsWTC4ztoLMmNmQoxxg@mail.gmail.com>
 <YhUVNc58trg+r3V9@shredder>
 <20220222171810.bpoddx7op3rivenm@skbuf>
 <YheGlwjp849dhcpq@shredder>
 <20220224135241.ne6c64segpt6azed@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224135241.ne6c64segpt6azed@skbuf>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 03:52:41PM +0200, Vladimir Oltean wrote:
> On Thu, Feb 24, 2022 at 03:22:31PM +0200, Ido Schimmel wrote:
> > On Tue, Feb 22, 2022 at 07:18:10PM +0200, Vladimir Oltean wrote:
> > > On Tue, Feb 22, 2022 at 06:54:13PM +0200, Ido Schimmel wrote:
> > > > On Tue, Feb 22, 2022 at 01:21:53PM +0200, Vladimir Oltean wrote:
> > > > > Hi Ido,
> > > > > 
> > > > > On Mon, 1 Mar 2021 at 17:22, Ido Schimmel <idosch@idosch.org> wrote:
> > > > > >
> > > > > > On Wed, Feb 24, 2021 at 01:43:38PM +0200, Vladimir Oltean wrote:
> > > > > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > > > >
> > > > > > > The bridge device currently goes into promiscuous mode when it has an
> > > > > > > upper with a different MAC address than itself. But it could do better:
> > > > > > > it could sync the MAC addresses of its uppers to the software FDB, as
> > > > > > > local entries pointing to the bridge itself. This is compatible with
> > > > > > > switchdev, since drivers are now instructed to trap these MAC addresses
> > > > > > > to the CPU.
> > > > > > >
> > > > > > > Note that the dev_uc_add API does not propagate VLAN ID, so this only
> > > > > > > works for VLAN-unaware bridges.
> > > > > >
> > > > > > IOW, it breaks VLAN-aware bridges...
> > > > > >
> > > > > > I understand that you do not want to track bridge uppers, but once you
> > > > > > look beyond L2 you will need to do it anyway.
> > > > > >
> > > > > > Currently, you only care about getting packets with specific DMACs to
> > > > > > the CPU. With L3 offload you will need to send these packets to your
> > > > > > router block instead and track other attributes of these uppers such as
> > > > > > their MTU so that the hardware will know to generate MTU exceptions. In
> > > > > > addition, the hardware needs to know the MAC addresses of these uppers
> > > > > > so that it will rewrite the SMAC of forwarded packets.
> > > > > 
> > > > > Ok, let's say I want to track bridge uppers. How can I track the changes to
> > > > > those interfaces' secondary addresses, in a way that keeps the association
> > > > > with their VLAN ID, if those uppers are VLAN interfaces?
> > > > 
> > > > Hi,
> > > > 
> > > > I'm not sure what you mean by "secondary addresses", but the canonical
> > > > way that I'm familiar with of adding MAC addresses to a netdev is to use
> > > > macvlan uppers. For example:
> > > > 
> > > > # ip link add name br0 up type bridge vlan_filtering 1
> > > > # ip link add link br0 name br0.10 type vlan id 10
> > > > # ip link add link br0.10 name br0.10-v address 00:11:22:33:44:55 type macvlan mode private
> > > > 
> > > > keepalived uses it in VRRP virtual MAC mode (for example):
> > > > https://github.com/acassen/keepalived/blob/master/doc/NOTE_vrrp_vmac.txt
> > > > 
> > > > In the software data path, this will result in br0 transitioning to
> > > > promisc mode and passing all the packets to upper devices that will
> > > > filter them.
> > > > 
> > > > In the hardware data path, you can apply promisc mode by flooding to
> > > > your CPU port (I believe this is what you are trying to avoid) or
> > > > install an FDB entry <00:11:22:33:44:55,10> that points to your CPU
> > > > port.
> > > 
> > > Maybe the terminology is not the best, but by secondary addresses I mean
> > > struct net_device :: uc and mc. To my knowledge, the MAC address of
> > > vlan/macvlan uppers is not the only way in which these lists can be
> > > populated. There is also AF_PACKET UAPI for PACKET_MR_MULTICAST and
> > > PACKET_MR_UNICAST, and this ends up calling dev_mc_add() and
> > > dev_uc_add(). User space may use this API to add a secondary address to
> > > a VLAN upper interface of a bridge.
> > 
> > OK, I see the problem... So you want the bridge to support
> > 'IFF_UNICAST_FLT' by installing local FDB entries? I see two potential
> > problems:
> > 
> > 1. For VLAN-unaware bridges this is trivial as VLAN information is of no
> > use. For VLAN-aware bridges we either need to communicate VLAN
> > information from upper layers or install a local FDB entry per each
> > configured VLAN (wasteful...). Note that VLAN information will not
> > always be available (in PACKET_MR_UNICAST, for example), in which case a
> > local FDB entry will need to be configured per each existing VLAN in
> > order to maintain existing behavior. Which lead to me think about the
> > second problem...
> >
> > 2. The bigger problem that I see is that if the bridge starts supporting
> > 'IFF_UNICAST_FLT' by installing local FDB entries, then packets that
> > were previously locally received and flooded will only be locally
> > received. Only locally receiving them makes sense, but I don't know what
> > will break if we change the existing behavior... Maybe this needs to be
> > guarded by a new bridge option?
> 
> I think it boils down to whether PACKET_MR_UNICAST on br0 is equivalent to
> 'bridge fdb add dev br0 self permanent' or not. Theoretically, the
> former means "if a packet enters the local termination path of br0,
> don't drop it", 

Trying to understand the first part of the sentence, are you saying that
if user space decides to use this interface, then it is up to it to
ensure that packets with the given unicast address are terminated on the
bridge? That is, it is up to user space to install the necessary
permanent FDB record? I think that is fair, it is just that right now
this operation does something else and causes all the packets forwarded
via the bridge to be locally terminated. Most of them will then be
dropped by upper layers. I don't think this was the author's intention,
it seems like an unfortunate side effect of current implementation. This
behavior is even more ridiculous when you take hardware offload into
account, as usually the CPU is unable to handle all these packets.

> while the other means "direct this MAC DA only towards
> the local termination path of br0".

This I agree with.

> I.o.w. the difference between "copy to CPU" and "trap to CPU".
> 
> If we agree they aren't equivalent, and we also agree that a macvlan on
> top of a bridge wants "trap to CPU" instead of "copy to CPU", I think
> the only logical conclusion is that the communication mechanism between
> the bridge and the macvlan that we're looking for doesn't exist -
> dev_uc_add() does something slightly different.
> 
> Which is why I want to better understand your idea of having the bridge
> track upper interfaces.

In my case these upper interfaces are actually router interfaces and I'm
interested in their MAC (in addition to other attributes) to know which
FDB entry to program towards the router port (your CPU port) on ingress
and which SA to use on egress (the hardware has limitations on SAs).

I'm pretty sure bridge maintainers will not agree to have this code in
the bridge driver in which case you can implement this in DSA. Should be
quite simple as I guess most configurations use VLANs/MACVLANs uppers.

> 
> Essentially, it isn't the bridge local FDB entries that I have a problem with.
> "Locally terminated packets that are also flooded on other bridge ports"
> is a problem that DSA users have tried to get rid of for years, I didn't
> hear a single complaint after we started fixing that. To me, a bridge
> VLAN is by definition an L2 broadcast domain and MAC addresses should be
> unique. I can't imagine what would break if we'd make the bridge deliver
> the packets only to their known destination.

I agree, can't come up with an example
