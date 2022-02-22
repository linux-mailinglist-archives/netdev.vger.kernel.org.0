Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462124BFF61
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 17:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbiBVQys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 11:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbiBVQyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 11:54:45 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71507CD5E0
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 08:54:19 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id D4ABF5803AE;
        Tue, 22 Feb 2022 11:54:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 22 Feb 2022 11:54:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2nhhRPC1/nnV2qR9o
        B+PKt1J53HAsprynbc1gsUVv3w=; b=m1CW6Pe3eEkX5W2fffYk6bnO6DCk3Ltfx
        7rOuliulpQccNwCc0S+a6Iy4sfk6VuQxXbjZyE6R3blgGIYkmxQIW0gsApJIes/n
        IGaC0OKK9r3It7ImcM9tEuHANk7t0zc5TR1zLJRQGGqcromYbx2zG05EksMOtELL
        nY38ARZWan87vNj37d6QOLdyUjp1HyPFLnJnLZ2OYoYvbtR2Ku6D5/xIdmepgSCr
        52QhYG9+DRMoVKY6d6imwrjZ/mTELMjEZDXu+4GRypuaCojF+Vle1jwQev3LuSZM
        7ubeyIhFLdyTKSdWvg5Qi+zmgrqAKAsG6tgPLAoOk2wlXNdIFGSqw==
X-ME-Sender: <xms:OhUVYiVM1w2K64-KoPTVeUBwoH-7j1fNLHdfTOVpu7nLMy1a4meWLQ>
    <xme:OhUVYunFJuOkg3_6McK5gd3cVK3wRjuQzV0xb5Os0LSjtvai1ROhSjWQGulFu4lGW
    inax7Q0s6K68qI>
X-ME-Received: <xmr:OhUVYmbyfQWGWSqF5Nz6fogKH6RlQLN0SIz0ERfGC7FfIkD5mbK--XO3ttsONtpAFBuwvCbdIrHInO8-H7CAKgVJZm0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeekgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephefhtdfhudeuhefgkeekhfehuddtvdevfeetheetkeelvefggeetveeuleehkeeu
    necuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:OhUVYpVFU61VkIZqt0FpqRVdMZY6dWMUcRoTSg8X9oghE7nXbOVaSA>
    <xmx:OhUVYslCmDSaAyQqVoh38fpAqzga0juKWOahAUyyzZu_0C3wbdIv8g>
    <xmx:OhUVYuehB5GkBiSmnlfkvjc6kYr13R0LqkL7L2Y71w6yQkDPEZboKw>
    <xmx:OhUVYpj1SC2YgJxIJhq2UAx-63WgPt0fIlSr5UQJo0jnc1kRlIi7UQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Feb 2022 11:54:17 -0500 (EST)
Date:   Tue, 22 Feb 2022 18:54:13 +0200
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
Message-ID: <YhUVNc58trg+r3V9@shredder>
References: <20210224114350.2791260-1-olteanv@gmail.com>
 <20210224114350.2791260-6-olteanv@gmail.com>
 <YD0GyJfbhqpPjhVd@shredder.lan>
 <CA+h21hrtnXr11VXsRXokkZHQ3AQ8nNCLsWTC4ztoLMmNmQoxxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrtnXr11VXsRXokkZHQ3AQ8nNCLsWTC4ztoLMmNmQoxxg@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 01:21:53PM +0200, Vladimir Oltean wrote:
> Hi Ido,
> 
> On Mon, 1 Mar 2021 at 17:22, Ido Schimmel <idosch@idosch.org> wrote:
> >
> > On Wed, Feb 24, 2021 at 01:43:38PM +0200, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > The bridge device currently goes into promiscuous mode when it has an
> > > upper with a different MAC address than itself. But it could do better:
> > > it could sync the MAC addresses of its uppers to the software FDB, as
> > > local entries pointing to the bridge itself. This is compatible with
> > > switchdev, since drivers are now instructed to trap these MAC addresses
> > > to the CPU.
> > >
> > > Note that the dev_uc_add API does not propagate VLAN ID, so this only
> > > works for VLAN-unaware bridges.
> >
> > IOW, it breaks VLAN-aware bridges...
> >
> > I understand that you do not want to track bridge uppers, but once you
> > look beyond L2 you will need to do it anyway.
> >
> > Currently, you only care about getting packets with specific DMACs to
> > the CPU. With L3 offload you will need to send these packets to your
> > router block instead and track other attributes of these uppers such as
> > their MTU so that the hardware will know to generate MTU exceptions. In
> > addition, the hardware needs to know the MAC addresses of these uppers
> > so that it will rewrite the SMAC of forwarded packets.
> 
> Ok, let's say I want to track bridge uppers. How can I track the changes to
> those interfaces' secondary addresses, in a way that keeps the association
> with their VLAN ID, if those uppers are VLAN interfaces?

Hi,

I'm not sure what you mean by "secondary addresses", but the canonical
way that I'm familiar with of adding MAC addresses to a netdev is to use
macvlan uppers. For example:

# ip link add name br0 up type bridge vlan_filtering 1
# ip link add link br0 name br0.10 type vlan id 10
# ip link add link br0.10 name br0.10-v address 00:11:22:33:44:55 type macvlan mode private

keepalived uses it in VRRP virtual MAC mode (for example):
https://github.com/acassen/keepalived/blob/master/doc/NOTE_vrrp_vmac.txt

In the software data path, this will result in br0 transitioning to
promisc mode and passing all the packets to upper devices that will
filter them.

In the hardware data path, you can apply promisc mode by flooding to
your CPU port (I believe this is what you are trying to avoid) or
install an FDB entry <00:11:22:33:44:55,10> that points to your CPU
port.
