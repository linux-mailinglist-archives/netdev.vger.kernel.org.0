Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8CA4C2CE3
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbiBXNXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiBXNXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:23:09 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CD7128640
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:22:39 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1DAA658023D;
        Thu, 24 Feb 2022 08:22:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 24 Feb 2022 08:22:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mVYKUdExDVBx8hnKG
        59CK5Smsath/7gScBAqvRz6zaw=; b=NeQUBmSPGYJXqyH47mUtSmGL2Pt6+8mH9
        nl5YML5d5ckYFwHdcclBA0rpo/flqdMIKSzNXNOlWhDSktWJM6FBjyEcgmPg3qd+
        vkoVg/BXBURiQc5poxDk5gGKEh54cksxd9FZYRrkcbmXB2dnR8zzoNDUbDKZd9HV
        5r8kT4YB3+vuqryMlfbitlw1FYVWL9JzVDe6YkDAR6almNOhNV373lHv55ODs5bd
        wSxsx4NsVeNKVl4kbxwGWp8YYEqcOnRVq8ytUDu8nADf7THQ1INB+tPTid53CVIK
        52maMu+FCSGuPahF7YKRdjra0hWLqPZ+OhtHVSs4/nQ/1LsTfJWNQ==
X-ME-Sender: <xms:nIYXYnb9fgBv4olAvMVFJn89v8rzlaOHBDoNTTKkKJLmik3oDFkJ3A>
    <xme:nIYXYmYLiJKO_t5Hge8ASBlNlOYViP4ujMOLog1WihUH86H1bjwW91KqqM9y3uWaX
    guyErNb6_EzFwY>
X-ME-Received: <xmr:nIYXYp_WkovsIZVfjsrE0JWjNKUVgX_SAGGf9XBxBaBxyEO8PgRjwsbFNM4FngTEbdcDZkSyvw7ewj0sdMTRkF7Q5uY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrledvgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephefhtdfhudeuhefgkeekhfehuddtvdevfeetheetkeelvefggeetveeuleehkeeu
    necuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:nIYXYtqnz1vrnLsTD_cS7buOQ6kqLOZ1GA8Ia-cIEqBpY6oTy_x0HQ>
    <xmx:nIYXYioYdK3xCk6MN_7vVh5gffqTsuufJbVWiSEH5pvqpDqXKWVlew>
    <xmx:nIYXYjSiwlupOnkt7uDU2ord23swMC73S4hETUY3MwtdrMQEeN-RaA>
    <xmx:nYYXYh1z5tpIAi4y3vQXt3_xXPJ-p42wo6ldsIJ2wNybhonBBPbKtg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Feb 2022 08:22:35 -0500 (EST)
Date:   Thu, 24 Feb 2022 15:22:31 +0200
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
Message-ID: <YheGlwjp849dhcpq@shredder>
References: <20210224114350.2791260-1-olteanv@gmail.com>
 <20210224114350.2791260-6-olteanv@gmail.com>
 <YD0GyJfbhqpPjhVd@shredder.lan>
 <CA+h21hrtnXr11VXsRXokkZHQ3AQ8nNCLsWTC4ztoLMmNmQoxxg@mail.gmail.com>
 <YhUVNc58trg+r3V9@shredder>
 <20220222171810.bpoddx7op3rivenm@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222171810.bpoddx7op3rivenm@skbuf>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 07:18:10PM +0200, Vladimir Oltean wrote:
> On Tue, Feb 22, 2022 at 06:54:13PM +0200, Ido Schimmel wrote:
> > On Tue, Feb 22, 2022 at 01:21:53PM +0200, Vladimir Oltean wrote:
> > > Hi Ido,
> > > 
> > > On Mon, 1 Mar 2021 at 17:22, Ido Schimmel <idosch@idosch.org> wrote:
> > > >
> > > > On Wed, Feb 24, 2021 at 01:43:38PM +0200, Vladimir Oltean wrote:
> > > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > >
> > > > > The bridge device currently goes into promiscuous mode when it has an
> > > > > upper with a different MAC address than itself. But it could do better:
> > > > > it could sync the MAC addresses of its uppers to the software FDB, as
> > > > > local entries pointing to the bridge itself. This is compatible with
> > > > > switchdev, since drivers are now instructed to trap these MAC addresses
> > > > > to the CPU.
> > > > >
> > > > > Note that the dev_uc_add API does not propagate VLAN ID, so this only
> > > > > works for VLAN-unaware bridges.
> > > >
> > > > IOW, it breaks VLAN-aware bridges...
> > > >
> > > > I understand that you do not want to track bridge uppers, but once you
> > > > look beyond L2 you will need to do it anyway.
> > > >
> > > > Currently, you only care about getting packets with specific DMACs to
> > > > the CPU. With L3 offload you will need to send these packets to your
> > > > router block instead and track other attributes of these uppers such as
> > > > their MTU so that the hardware will know to generate MTU exceptions. In
> > > > addition, the hardware needs to know the MAC addresses of these uppers
> > > > so that it will rewrite the SMAC of forwarded packets.
> > > 
> > > Ok, let's say I want to track bridge uppers. How can I track the changes to
> > > those interfaces' secondary addresses, in a way that keeps the association
> > > with their VLAN ID, if those uppers are VLAN interfaces?
> > 
> > Hi,
> > 
> > I'm not sure what you mean by "secondary addresses", but the canonical
> > way that I'm familiar with of adding MAC addresses to a netdev is to use
> > macvlan uppers. For example:
> > 
> > # ip link add name br0 up type bridge vlan_filtering 1
> > # ip link add link br0 name br0.10 type vlan id 10
> > # ip link add link br0.10 name br0.10-v address 00:11:22:33:44:55 type macvlan mode private
> > 
> > keepalived uses it in VRRP virtual MAC mode (for example):
> > https://github.com/acassen/keepalived/blob/master/doc/NOTE_vrrp_vmac.txt
> > 
> > In the software data path, this will result in br0 transitioning to
> > promisc mode and passing all the packets to upper devices that will
> > filter them.
> > 
> > In the hardware data path, you can apply promisc mode by flooding to
> > your CPU port (I believe this is what you are trying to avoid) or
> > install an FDB entry <00:11:22:33:44:55,10> that points to your CPU
> > port.
> 
> Maybe the terminology is not the best, but by secondary addresses I mean
> struct net_device :: uc and mc. To my knowledge, the MAC address of
> vlan/macvlan uppers is not the only way in which these lists can be
> populated. There is also AF_PACKET UAPI for PACKET_MR_MULTICAST and
> PACKET_MR_UNICAST, and this ends up calling dev_mc_add() and
> dev_uc_add(). User space may use this API to add a secondary address to
> a VLAN upper interface of a bridge.

OK, I see the problem... So you want the bridge to support
'IFF_UNICAST_FLT' by installing local FDB entries? I see two potential
problems:

1. For VLAN-unaware bridges this is trivial as VLAN information is of no
use. For VLAN-aware bridges we either need to communicate VLAN
information from upper layers or install a local FDB entry per each
configured VLAN (wasteful...). Note that VLAN information will not
always be available (in PACKET_MR_UNICAST, for example), in which case a
local FDB entry will need to be configured per each existing VLAN in
order to maintain existing behavior. Which lead to me think about the
second problem...

2. The bigger problem that I see is that if the bridge starts supporting
'IFF_UNICAST_FLT' by installing local FDB entries, then packets that
were previously locally received and flooded will only be locally
received. Only locally receiving them makes sense, but I don't know what
will break if we change the existing behavior... Maybe this needs to be
guarded by a new bridge option?

> 
> The question was how can the bridge get notified of changes to those 2
> lists of its upper interfaces?
> 
> If it monitors NETDEV_CHANGEUPPER it has access to those lists only when
> an upper joins or leaves.
> If it monitors NETDEV_CHANGEADDR, it gets notified only to changes on
> the primary addresses of the uppers (dev_addr and dev_addrs).
> If it implements ndo_set_rx_mode (this patch), it has all the addresses
> synced to it, but they lack a VLAN ID, because every address lacks
> further information about which device added it.
> 
> If there's logic in the mlxsw driver that does this, unfortunately I
> haven't found it.
