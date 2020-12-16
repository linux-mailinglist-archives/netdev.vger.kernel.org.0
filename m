Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8223B2DC6BD
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 19:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732125AbgLPSuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 13:50:01 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:44463 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728161AbgLPSuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 13:50:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D71A65801EE;
        Wed, 16 Dec 2020 13:48:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 16 Dec 2020 13:48:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rLfxoh
        ttutvlbknQJNbt5XIPzGbO3X8XBzmxRaIi+10=; b=BxO0OZ5OtNDJkZ4l79kvFn
        0iWLZRenGZiSfZvaRkhw7I97X83pOIEyW5LaLSMql/TiS69rEOSYR0PvjgoAhpxR
        g0lksqyjh6ph7tJxo0ZU7upniyaTEXTd9GToY0NrjOXvd/4CWVo/hCEbIW6wTfDh
        DWkvM2qho2qPkm3ZUgTHImz4ApiQz3wQMwvqpWgt/aNh/uzoTXd1EhrfIhxV0k20
        C/SkLZsMGTL2Q0chO97FLHW0X4yiDHIW56OJUL/U3bTtqwsnQ6ziPXlIylJb6WHq
        fPxRKGAmkRTEvWIaVn8u0a/dLUF0joxEC3UA5L7cLnCio0cwIbNJyk2KB66DIlag
        ==
X-ME-Sender: <xms:k1baX-_NmMnUqTB66KIaGYGTxw8QwJhaBQ5F1VsNzPEubfNJ87X3fg>
    <xme:k1baX-uEXoGziAu-rZuRwYpGSct1gV7aixxo0x3llI484rmPU1KukjUF-Et8a4wbG
    Ui0MguN9rIaxWs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudelvddguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepleeuvddvkeekffejudeuleetgffhjefgieffleekteetgeeltdffgeeugfdt
    iedvnecuffhomhgrihhnpehoiihlrggsshdrohhrghdpsghoohhtlhhinhdrtghomhdpgh
    hithhhuhgsrdgtohhmpdhkvghrnhgvlhdrohhrghdpfihikhhiphgvughirgdrohhrghdp
    sggvrhhnrghtrdgthhenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:k1baX0ASrkoF0k4546qhozA10-ozAv1OxUfvR0VlsG4d-7ZM45FKhg>
    <xmx:k1baX2exZsgH8_iPa9dANMfEz2BpZlJ7GDJnTfY5QhQTG6gz87ViqA>
    <xmx:k1baXzPXU7DmdqApsEbMkS8pbH_56Kv7QvymvskP3gB0AZ_7E-wOIA>
    <xmx:lVbaX-cf7-JtWrFifOzLf2R9Yd8dyNW7aW6bzvwGXtKhSnATMjdnNw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id BFD76108005F;
        Wed, 16 Dec 2020 13:48:50 -0500 (EST)
Date:   Wed, 16 Dec 2020 20:48:48 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201216184848.GA3381782@shredder.lan>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201208112350.kuvlaxqto37igczk@skbuf>
 <87a6uk5apb.fsf@waldekranz.com>
 <20201212142622.diijil65gjkxde4n@skbuf>
 <878sa1h0bg.fsf@waldekranz.com>
 <20201214001231.nswz23hqjkf227rf@skbuf>
 <20201214114237.GA2789489@shredder.lan>
 <87y2hxbx54.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2hxbx54.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 04:15:03PM +0100, Tobias Waldekranz wrote:
> On Mon, Dec 14, 2020 at 13:42, Ido Schimmel <idosch@idosch.org> wrote:
> > On Mon, Dec 14, 2020 at 02:12:31AM +0200, Vladimir Oltean wrote:
> >> On Sun, Dec 13, 2020 at 10:18:27PM +0100, Tobias Waldekranz wrote:
> >> > On Sat, Dec 12, 2020 at 16:26, Vladimir Oltean <olteanv@gmail.com> wrote:
> >> > > On Fri, Dec 11, 2020 at 09:50:24PM +0100, Tobias Waldekranz wrote:
> >> > >> 2. The issue Vladimir mentioned above. This is also a straight forward
> >> > >>    fix, I have patch for tag_dsa, making sure that offload_fwd_mark is
> >> > >>    never set for ports in standalone mode.
> >> > >>
> >> > >>    I am not sure if I should solve it like that or if we should just
> >> > >>    clear the mark in dsa_switch_rcv if the dp does not have a
> >> > >>    bridge_dev. I know both Vladimir and I were leaning towards each
> >> > >>    tagger solving it internally. But looking at the code, I get the
> >> > >>    feeling that all taggers will end up copying the same block of code
> >> > >>    anyway. What do you think?
> >> > >> As for this series, my intention is to make sure that (A) works as
> >> > >> intended, leaving (B) for another day. Does that seem reasonable?
> >> > >>
> >> > >> NOTE: In the offloaded case, (B) will of course also be supported.
> >> > >
> >> > > Yeah, ok, one can already tell that the way I've tested this setup was
> >> > > by commenting out skb->offload_fwd_mark = 1 altogether. It seems ok to
> >> > > postpone this a bit.
> >> > >
> >> > > For what it's worth, in the giant "RX filtering for DSA switches" fiasco
> >> > > https://patchwork.ozlabs.org/project/netdev/patch/20200521211036.668624-11-olteanv@gmail.com/
> >> > > we seemed to reach the conclusion that it would be ok to add a new NDO
> >> > > answering the question "can this interface do forwarding in hardware
> >> > > towards this other interface". We can probably start with the question
> >> > > being asked for L2 forwarding only.
> >> >
> >> > Very interesting, though I did not completely understand the VXLAN
> >> > scenario laid out in that thread. I understand that OFM can not be 0,
> >> > because you might have successfully forwarded to some destinations. But
> >> > setting it to 1 does not smell right either. OFM=1 means "this has
> >> > already been forwarded according to your current configuration" which is
> >> > not completely true in this case. This is something in the middle, more
> >> > like skb->offload_fwd_mark = its_complicated;
> >> 
> >> Very pertinent question. Given your observation that nbp_switchdev_mark_set()
> >> calls dev_get_port_parent_id() with recurse=true, this means that a vxlan
> >> upper should have the same parent ID as the real interface. At least the
> >> theory coincides with the little practice I applied to my setup where
> >> felix does not support vxlan offload:
> >> 
> >> I printed the p->offload_fwd_mark assigned by nbp_switchdev_mark_set:
> >> ip link add br0 type bridge
> >> ip link set swp1 master br0
> >> [   15.887217] mscc_felix 0000:00:00.5 swp1: offload_fwd_mark 1
> >> ip link add vxlan10 type vxlan id 10 group 224.10.10.10 dstport 4789 ttl 10 dev swp0
> >> ip link set vxlan10 master br0
> >> [  102.734390] vxlan10: offload_fwd_mark 1
> >> 
> >> So a clearer explanation needs to be found for how Ido's exception
> >> traffic due to missing neighbor in the vxlan underlay gets re-forwarded
> >> by the software bridge to the software vxlan interface. It cannot be due
> >> to a mismatch of bridge port offload_fwd_mark values unless there is
> >> some different logic applied for Mellanox hardware that I am not seeing.
> >> So after all, it must be due to skb->offload_fwd_mark being unset?
> >> 
> >> To be honest, I almost expect that the Mellanox switches are "all or
> >> nothing" in terms of forwarding. So if the vxlan interface (which is
> >> only one of the bridge ports) could not deliver the packet, it would
> >> seem cleaner to me that none of the other interfaces deliver the packet
> >> either. Then the driver picks up this exception packet on the original
> >> ingress interface, and the software bridge + software vxlan do the job.
> >> And this means that skb->offload_fwd_mark = it_isnt_complicated.
> >> 
> >> But this is clearly at odds with what Ido said, that "swp0 and vxlan0 do
> >> not have the same parent ID", and which was the center of his entire
> >> argument. It's my fault really, I should have checked. Let's hope that
> >> Ido can explain again.
> >
> > Problem is here:
> >
> > ip link add vxlan10 type vxlan id 10 group 224.10.10.10 dstport 4789 ttl 10 dev swp0
> >
> > We don't configure VXLAN with a bound device. In fact, we forbid it:
> > https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c#L46
> > https://elixir.bootlin.com/linux/latest/source/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh#L182
> >
> > Even if we were to support a bound device, it is unlikely to be a switch
> > port, but some dummy interface that we would enslave to a VRF in which
> > we would like the underlay lookup to be performed. We use this with GRE
> > tunnels:
> > https://github.com/Mellanox/mlxsw/wiki/L3-Tunneling#general-gre-configuration
> >
> > Currently, underlay lookup always happens in the default VRF.
> >
> > VXLAN recently got support for this as well. See this series:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=79dfab43a976b76713c40222987c48e32510ebc1
> 
> How do you handle multiple VXLAN interfaces?  I.e. in this setup:
> 
>          br0
>    .--' .' '. '----.
>   /    /     \      \
> swp0 swp1  vxlan0 vxlan1
> 
> Say that both VXLANs are offloaded, the nexthop of vxlan0 is in the
> hardware ARP cache, but vxlan1's is not.
> 
> If a broadcast is received on swp0, hardware will forward to swp1 and
> vxlan0, then trap the original frame to the CPU with offload_fwd_mark=1.
> 
> What prevents duplicates from being sent out through vxlan0 in that
> case?

We don't support multiple VXLAN devices in the same VLAN, but lets look
at a simpler topology:

         br0
   .--' .' '.
  /    /     \
swp0 swp1  vxlan0

VXLAN supports something called Head End Replication (HER) [1]. You can
flood a packet to multiple remote VTEPs. In Linux, this is configured
using the all-zero MAC address in the VXLAN's FDB [2]. It is possible
that after flooding a packet to 100 VTEPs, in the 101th VTEP, the packet
hit an exception in the underlay and was trapped to the CPU for
resolution via swp0. It won't be flooded to swp1 since it's marked, but
what prevents it from being flooded to all the other VTEPs again?
Nothing. Per-VTEP flood indication is not encoded in the skb and I'm not
aware of any hardware that can provide it.

[1] https://en.wikipedia.org/wiki/Broadcast,_unknown-unicast_and_multicast_traffic#BUM_handling_in_VxLAN
[2] https://vincent.bernat.ch/en/blog/2017-vxlan-linux#unicast-with-static-flooding
