Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE574B4AE1
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 11:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347674AbiBNKbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 05:31:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348139AbiBNKar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 05:30:47 -0500
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D5E9BF5F
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 01:59:22 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0B9DA580301;
        Mon, 14 Feb 2022 04:59:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 14 Feb 2022 04:59:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ALv+wNAig2IC3Ttrk
        758vmpJpIX+XZqzlw0FkOmg1aY=; b=dw6T1B3XxllZPnBHrPV9ITP39zuXcgYTa
        /Xv4p4XH27qIcPmQJH12+QznbmF0K52lf8MKKT/ZMw9h5gJjDvYn6hV3jsvw0hoX
        RfXT7w3QcCxghiiny/KlHGzUBnpfahy/AQQOGUc7ke55Um8tQ2naTuV0b9HBHUh+
        5gjPGnEWRyvvl+1lWukmaUIav/T9i9FXucstidzg5UJCts4nIW5mXDyaDj4tZhw+
        0nGzc2xTkp/pp5X1Qyz/7z3HjoO0rs4Yu+b8xtbrZ9Gq7NtDWRWJfPl/wTmUmmQd
        LdAHmWkR8G1juM3DXvpj8WQJi5J7hymxq0CmzmUO0AlDQ0CE3vReg==
X-ME-Sender: <xms:6ScKYquia_SouOebetv6Ylek25YhsHqO5BlsZySNb0nY_3xphlyJmQ>
    <xme:6ScKYvcAlE1YNo45VTM__d4BKN0oS5s10ldJmZeldGNGUYw5WzGKmxucbX8xa34PZ
    JznVYkx0sS0Qyk>
X-ME-Received: <xmr:6ScKYlyr9g2HtWfjsx_FP14NnpEJZT7KWSESnMKyT5PdHHG3lYo9P0qZsXAEXKtdxm9UDLgnPudpD4l19V3jjsJbvzo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjedvgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:6ScKYlMKr5W5VrLfq6ApbqJ-JpU8vgb_I08t-jGmPf2WZGgFPtJmKw>
    <xmx:6ScKYq-7lbkN9AgoQ3xPs3BB_JX3-N9o0CDZpNB2_0RXxHKYQq8_qA>
    <xmx:6ScKYtW_mtNKR6thYmKZ3Vcx-FdaV5Q6xdmBlGXtFKTCuzy6pEMhAw>
    <xmx:6icKYlVZsKA3DUBGX47uG9UDh33X-1nM-VW1OhRRYUvmtC7rpPz3rA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Feb 2022 04:59:05 -0500 (EST)
Date:   Mon, 14 Feb 2022 11:59:02 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Message-ID: <Ygon5v7r0nerBxG7@shredder>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
 <7b3c0c29-428b-061d-8a30-6817f0caa8da@nvidia.com>
 <20220213200255.3iplletgf4daey54@skbuf>
 <ac47ea65-d61d-ea60-287a-bdeb97495ade@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac47ea65-d61d-ea60-287a-bdeb97495ade@nvidia.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 11:05:54AM +0200, Nikolay Aleksandrov wrote:
> On 13/02/2022 22:02, Vladimir Oltean wrote:
> > Hi Nikolay,
> > 
> > On Sun, Feb 13, 2022 at 08:54:50PM +0200, Nikolay Aleksandrov wrote:
> >> Hi,
> >> I don't like the VLAN delete on simple flags change to workaround some devices'
> >> broken behaviour, in general I'd like to avoid adding driver workarounds in the bridge.
> >> Either those drivers should be fixed (best approach IMO), or the workaround should only
> >> affect them, and not everyone. The point is that a vlan has much more state than a simple
> >> fdb, and deleting it could result in a lot more unnecessary churn which can be avoided
> >> if these flags can be changed properly.
> > 
> > Agree, but the broken drivers was just an added bonus I thought I'd mention,
> > since the subtle implications of the API struck me as odd the first time
> > I realized them.
> > 
> > The point is that it's impossible for a switchdev driver to do correct
> > refcounting for this example (taken from Tobias):
> > 
> >    br0
> >    / \
> > swp0 tap0
> >  ^     ^
> > DSA   foreign interface
> > 
> > (1) ip link add br0 type bridge
> > (2) ip link set swp0 master br0
> > (3) ip link set tap0 master br0
> > (4) bridge vlan add dev tap0 vid 100
> > (5) bridge vlan add dev br0 vid 100 self
> > (6) bridge vlan add dev br0 vid 100 pvid self
> > (7) bridge vlan add dev br0 vid 100 pvid untagged self
> > (8) bridge vlan del dev br0 vid 100 self
> > (8) bridge vlan del dev tap0 vid 100
> > 
> > basically, if DSA were to keep track of the host-facing users of VID 100
> > in order to keep the CPU port programmed in that VID, it needs a way to
> > detect the fact that commands (6) and (7) operate on the same VID as (5),
> > and on a different VID than (8). So practically, it needs to keep a
> > shadow copy of each bridge VLAN so that it can figure out whether a
> > switchdev notification is for an existing VLAN or for a new one.
> > 
> > This is really undesirable in my mind as well, and I see two middle grounds
> > (both untested):
> > 
> > (a) call br_vlan_get_info() from the DSA switchdev notification handler
> >     to figure out whether the VLAN is new or not. As far as I can see in
> >     __vlan_add(), br_switchdev_port_vlan_add() is called before the
> >     insertion of the VLAN into &vg->vlan_hash, so the absence from there
> >     could be used as an indicator that the VLAN is new, and that the
> >     refcount needs to be bumped, regardless of knowing exactly which
> >     bridge or bridge port the VLAN came from. The important part is that
> >     it isn't just a flag change, for which we don't want to bump the
> >     refcount, and that we can rely on the bridge database and not keep a
> >     separate one. The disadvantage seems to be that the solution is a
> >     bit fragile and puts a bit too much pressure on the bridge code
> >     structure, if it even works (need to try).
> > 
> 
> This is undesirable for many reasons, one of which you already noted. :)
> 
> > (b) extend struct switchdev_obj_port_vlan with a "bool existing" flag
> >     which is set to true by the "_add_existing" bridge code paths.
> >     This flag can be ignored by non-interested parties, and used by DSA
> >     and others as a hint whether to bump a refcount on the VID or not.
> > 
> > (c) (just a variation of b) I feel there should have been a
> >     SWITCHDEV_PORT_OBJ_CHANGE instead of just SWITCHDEV_PORT_OBJ_ADD,
> >     but it's probably too late for that.
> > 
> > So what do you think about option (b)?
> 
> (b) sounds good if it will be enough for DSA, it looks like the least
> intrusive way to do it. Also passing that information would make simpler
> some inferring by other means that the vlan already exists in drivers.

Sounds good to me as well. I assume it means patches #1 and #2 will be
changed to make use of this flag and patch #3 will be dropped?

> 
> Cheers,
>  Nik
