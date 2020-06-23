Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F7F205AE9
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 20:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733170AbgFWSij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 14:38:39 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:47531 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732549AbgFWSij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 14:38:39 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 5D9E2AA0;
        Tue, 23 Jun 2020 14:38:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 23 Jun 2020 14:38:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6qtpPV
        dtygxrC0UBopcLFlft36s2DyA25g0QX8tfCA0=; b=idI00XT/f7FO6c/f7yNJMQ
        egVJMKFjnv9th4T7WVRINRDcPoDuuq8jDStOpskFGIVdQMeWRT2TqXvMckG547G4
        jTl/GkeOLVSzAG+tYbfjEHFr5CglKFicKpuSLrem6tjP9TxzK337IWySKzHhHDJP
        SNSP3f8mO9IAT1AYkLbxVt+uXQmISl4+srELkzmvOLvo2ohQtSmnMppW9ZGt8y0h
        Z0j6DR94Za4NiDtt0qcrI8yadhNDPrzLSRepYxYSKFgW9/TntzxDTVvmhZzPblI9
        YUpphWXbc5uTV9hXdvZxI6qhQ+8GCBxkHEpIQ12yTrgoiyosQ/UU4+NUc9wCAfQA
        ==
X-ME-Sender: <xms:LUzyXpM71W_Pwdd-DyW9PRUJuwg3DcFJvQ2jVrAkWU6Nogs5A_qYtg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpefgvefgveeuudeuffeiffehieffgf
    ejleevtdetueetueffkeevgffgtddugfekveenucffohhmrghinhepkhgvrhhnvghlrdho
    rhhgnecukfhppeejledrudekfedrieehrdekjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:LUzyXr-Lyt4ycnBt5us2jsRHZ0iedlPyhBASlZshg6jtbCMr9HpjVA>
    <xmx:LUzyXoRyP0M0VsRd4AK8x4VF7bKfukGzlMw9Ltvkbn8MsWLqmGcL4w>
    <xmx:LUzyXlvGefGuYGfERoFdQCORz4z0ZqDZZUsp8Xmy3j4LA1He8HBxzg>
    <xmx:LkzyXrplDFDBWqZ9ppjFM3YarUL9T8uIaZusTwAEd0dGD7W08WBaeQ>
Received: from localhost (bzq-79-183-65-87.red.bezeqint.net [79.183.65.87])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6B8D03280059;
        Tue, 23 Jun 2020 14:38:37 -0400 (EDT)
Date:   Tue, 23 Jun 2020 21:38:35 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Qiwei Wen <wenqiweiabcd@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: Multicast routing: wrong output interface selected unless VRF
 default route is added
Message-ID: <20200623183835.GA69452@shredder>
References: <CADxRGxBfaWWvtYJmEebdzSMkVk6-YTx+jff2bGwS+TXBUPM-LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADxRGxBfaWWvtYJmEebdzSMkVk6-YTx+jff2bGwS+TXBUPM-LA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 09:19:10AM +1000, Qiwei Wen wrote:
> Hi all,
> 
> While experimenting with FRRouting, I observed the following
> behaviour. I'm not sure whether it's intended or not.
> 
> In a virtual machine set up as a multicast router, I added two
> networks, created a VRF, and enslaved interfaces to both networks to
> the VRF, like so:
> 
> ip link add blue type vrf table 1001
> ip link set eth0 master blue
> ip link set eth1 master blue
> 
> I then set up PIM on the router VM (FRR configs attached) and started
> the multicast sender and receiver processes on two other VMs. The
> mroutes came up as expected (ip show mroute table 1001), but no
> packets came to the receiver. I added the following debug message to
> ipmr_queue_xmit, just before the NF_HOOK macro:
> 
> +    pr_info("calling NF_HOOK! vif->dev is %s,"
> +            " dev is %s, skb->dev is %s\n",
> +            vif->dev->name, dev->name, skb->dev->name);
> 
> and I found that "dev", the selected output interface, is in fact the
> output interface of the main table (unicast) default route. Running
> tcpdump on that (very wrong) output interface confirmed this.
> 
> I then went back to networking/vrf.txt, and found that I forgot to do this:
> 
> ip route add table 1001 unreachable default metric 4278198272
> 
> after this step, multicast routing began to work correctly.
> 
> Further debugging-by-printk lead to these observations:
> 1. Using the main table (without VRFs), multicast routing works fine
> with or without the default unicast route; but in the function "
> ip_route_output_key_hash_rcu", the call to "fib_lookup" in fact fails
> with -101, "network unreachable".
> 2. Using the VRF table 1001, the kernel stops routing multicast
> packets to the wrong interface once the unreachable default route is
> added. "fib_lookup" continues to fail, but with -113, "host
> unreachable".
> 
> My questions are:
> 1. is fib_lookup supposed to work with multicast daddr? If so, has
> multicast routing been working for the wrong reason?
> 2. Why does the addition of a unicast default route affect multicast
> routing behaviour?

I believe this was discussed in the past. See:
https://lore.kernel.org/netdev/20200115191920.GA1490933@splinter/#t
