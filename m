Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337086DC0D2
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 19:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjDIRO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 13:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjDIRO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 13:14:28 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B787030F8;
        Sun,  9 Apr 2023 10:14:23 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 4E54132001C6;
        Sun,  9 Apr 2023 13:14:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Apr 2023 13:14:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1681060457; x=1681146857; bh=EVicW71akCt/y
        1tM1F+st9STMxkjr4NI+o/dAkIr1Hg=; b=BqsKBC2SNkqVqZL4/ojSOoypccc/2
        /s+8VG7Km1OEtSeynHaJ6tykzbwk2N2aodNOGHPSnCrQytK81XUr3WeSetwo7IQv
        2p9ac0Zpci54Foc/I39kg33J0Bg9NbDWghxbDmVhvj8lT+FCRywypjgn+QavaK5E
        8g2Ioty3h+Fndpy5YEvFaF6uQ/1dsa4WnH2VYGg2KaznAGTGNQ3qjOogWVWfTu/3
        +YzWRFjZ3IQCM315l1OzSU8gYyMEqD275TNNzh2U72dcmyxA3CIH8K00vRTX8eZg
        9yVTX7sHhsJKSX0r/nVyxKOqrwnwW0POnnqOeYYn3qDzmGx+WMZ+U4ysQ==
X-ME-Sender: <xms:afIyZC2OztArIhuBY9CHGzyWtemBaqkzWYi8q0m72rXIV-szwUiPnQ>
    <xme:afIyZFETIduFyrY_Rc9wEomr7ueyPN4-4VlkOKQEiY6gXHrdkDseZNxBs5yprb3XJ
    Fu7ncfwI6d5IZc>
X-ME-Received: <xmr:afIyZK5XfAjBcYt_AJTJblVPrC-nOxUP9zPDTFz5WlcXyU5LARewtJfDYCKJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdektddgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedtueeggeelgffgveehfeeftefhjeejveeltdfgjeekhefgueehvdeiffeg
    heffffenucffohhmrghinhepsggvlhhofidrtggrthenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:afIyZD0VA1HM3cgW9FS3P5h0kXAVdDMBNUiuO0N5wWt2Wk3-x8b3pA>
    <xmx:afIyZFGd5Pk84hlcU1CVoc9DfnbTkAaJJsEkewLyuJ6i3-f6kYrBAw>
    <xmx:afIyZM9dQJEX8nPy1ZGr28n8UfgFGP80gRNcgW0ijR__xhTNI6mXmQ>
    <xmx:afIyZHHst-dWFdsoDTxD8UPGy4vu6-gUL0xni820S9bDORxcFRvciQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 9 Apr 2023 13:14:16 -0400 (EDT)
Date:   Sun, 9 Apr 2023 20:14:13 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [BUG] kmemleak in rtnetlink_rcv() triggered by
 selftests/drivers/net/team in build cdc9718d5e59
Message-ID: <ZDLyZX545Cw+aLhE@shredder>
References: <78a8a03b-6070-3e6b-5042-f848dab16fb8@alu.unizg.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78a8a03b-6070-3e6b-5042-f848dab16fb8@alu.unizg.hr>
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 09, 2023 at 01:49:30PM +0200, Mirsad Goran Todorovac wrote:
> Hi all,
> 
> There appears to be a memleak triggered by the selftest drivers/net/team.

Thanks for the report. Not sure it's related to team, see below.

> 
> # cat /sys/kernel/debug/kmemleak
> unreferenced object 0xffff8c18def8ee00 (size 256):
>   comm "ip", pid 5727, jiffies 4294961159 (age 954.244s)
>   hex dump (first 32 bytes):
>     00 20 09 de 18 8c ff ff 00 00 00 00 00 00 00 00  . ..............
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
>     [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
>     [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
>     [<ffffffffb6dbc00b>] vlan_vid_add+0x11b/0x290
>     [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
>     [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
>     [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
>     [<ffffffffb6ac7574>] dev_open+0x94/0xa0
>     [<ffffffffc176515e>] 0xffffffffc176515e

Don't know what this is. Might be another issue.

>     [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
>     [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
>     [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
>     [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
>     [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
>     [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
>     [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20
> unreferenced object 0xffff8c18250d3700 (size 32):
>   comm "ip", pid 5727, jiffies 4294961159 (age 954.244s)
>   hex dump (first 32 bytes):
>     a0 ee f8 de 18 8c ff ff a0 ee f8 de 18 8c ff ff  ................
>     81 00 00 00 01 00 00 00 cc cc cc cc cc cc cc cc  ................
>   backtrace:
>     [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
>     [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
>     [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
>     [<ffffffffb6dbc064>] vlan_vid_add+0x174/0x290
>     [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
>     [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
>     [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
>     [<ffffffffb6ac7574>] dev_open+0x94/0xa0
>     [<ffffffffc176515e>] 0xffffffffc176515e
>     [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
>     [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
>     [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
>     [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
>     [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
>     [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
>     [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20
> unreferenced object 0xffff8c1846e16800 (size 256):
>   comm "ip", pid 7837, jiffies 4295135225 (age 258.160s)
>   hex dump (first 32 bytes):
>     00 20 f7 de 18 8c ff ff 00 00 00 00 00 00 00 00  . ..............
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
>     [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
>     [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
>     [<ffffffffb6dbc00b>] vlan_vid_add+0x11b/0x290
>     [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
>     [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
>     [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
>     [<ffffffffb6ac7574>] dev_open+0x94/0xa0
>     [<ffffffffc177115e>] bond_enslave+0x34e/0x1840 [bonding]

This shows that the issue is related to the bond driver, not team.

>     [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
>     [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
>     [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
>     [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
>     [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
>     [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
>     [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20
> unreferenced object 0xffff8c184c5ff2a0 (size 32):

This is 'struct vlan_vid_info'

>   comm "ip", pid 7837, jiffies 4295135225 (age 258.160s)
>   hex dump (first 32 bytes):
>     a0 68 e1 46 18 8c ff ff a0 68 e1 46 18 8c ff ff  .h.F.....h.F....
>     81 00 00 00 01 00 00 00 cc cc cc cc cc cc cc cc  ................
            ^ VLAN ID 0

>   backtrace:
>     [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
>     [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
>     [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
>     [<ffffffffb6dbc064>] vlan_vid_add+0x174/0x290
>     [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
>     [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
>     [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
>     [<ffffffffb6ac7574>] dev_open+0x94/0xa0
>     [<ffffffffc177115e>] bond_enslave+0x34e/0x1840 [bonding]
>     [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
>     [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
>     [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
>     [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
>     [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
>     [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
>     [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20

VLAN ID 0 is automatically added by the 8021q driver when a net device
is opened. In this case it's a device being enslaved to a bond. I
believe the issue was exposed by the new bond test that was added in
commit 222c94ec0ad4 ("selftests: bonding: add tests for ether type
changes") as part of v6.3-rc3.

The VLAN is supposed to be removed by the 8021q driver when a net device
is closed and the bond driver indeed calls dev_close() when a slave is
removed. However, this function is a NOP when 'IFF_UP' is not set.
Unfortunately, when a bond changes its type to Ethernet this flag is
incorrectly cleared in bond_ether_setup(), causing this VLAN to linger.
As far as I can tell, it's not a new issue.

Temporary fix is [1]. Please test it although we might end up with a
different fix (needs more thinking and it's already late here).

Reproduced using [2]. You can see in the before/after output how the
flag is cleared/retained [3].

[1]
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 236e5219c811..50dc068dc259 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1777,14 +1777,15 @@ void bond_lower_state_changed(struct slave *slave)
 
 /* The bonding driver uses ether_setup() to convert a master bond device
  * to ARPHRD_ETHER, that resets the target netdevice's flags so we always
- * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE if it was set
+ * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE and IFF_UP
+ * if they were set
  */
 static void bond_ether_setup(struct net_device *bond_dev)
 {
-	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
+	unsigned int flags = bond_dev->flags & (IFF_SLAVE | IFF_UP);
 
 	ether_setup(bond_dev);
-	bond_dev->flags |= IFF_MASTER | slave_flag;
+	bond_dev->flags |= IFF_MASTER | flags;
 	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 }
 
[2]
#!/bin/bash

ip link add name t-nlmon type nlmon
ip link add name t-dummy type dummy
ip link add name t-bond type bond mode active-backup

ip link set dev t-bond up
ip link set dev t-nlmon master t-bond
ip link set dev t-nlmon nomaster
ip link show dev t-bond
ip link set dev t-dummy master t-bond
ip link show dev t-bond

ip link del dev t-bond
ip link del dev t-dummy
ip link del dev t-nlmon

[3]
Before:

12: t-bond: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/netlink
12: t-bond: <BROADCAST,MULTICAST,MASTER,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether ce:b2:31:0a:53:83 brd ff:ff:ff:ff:ff:ff

After:

12: t-bond: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/netlink
12: t-bond: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 5a:18:e7:85:11:73 brd ff:ff:ff:ff:ff:ff
