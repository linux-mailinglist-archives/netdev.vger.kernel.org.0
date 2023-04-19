Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8086E7023
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 02:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjDSAAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 20:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjDSAAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 20:00:17 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E156449F
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 17:00:15 -0700 (PDT)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 438863F22C
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 00:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681862411;
        bh=XNiAOpy1i+hyAv92Fk0mNFIJj+FqEwiNffmjePQROhs=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=SpdcIgWbjHuIIziJUM95pa67tYQ91qjl2y6zTGIMVa2Bpt+vP4zMiIIcKN9scp0Qv
         NA2rWsOD1iDLeZf7fHRlTDO8JoPqs3UKDKU442vm7NSOwMSjfgbbzXS6jojrI0puqO
         ECVVJgjjxoJJ8tYyVZxSkCOnyJ9OX2XAMBKatLWOHWElVYa/dGPeTrZmQaBHb2h95l
         pVkfZWPKxFHsFX19thWQ6RSyJNpx1KfhJ5q8KZasVoISuFrW4I+i9b3j/whOx5AFYn
         vPG1lQaJEHsLRW+V7MErmf51rmJk8x1iLipPLwCVrqSn/gV7aXTyZHQdt5OnUvIsVK
         k2yzMPLCZO8uQ==
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2476a718feeso1396389a91.2
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 17:00:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681862408; x=1684454408;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNiAOpy1i+hyAv92Fk0mNFIJj+FqEwiNffmjePQROhs=;
        b=ZyxFupP6ngH0pi3g382uyP28UtkH+LX5arr56jHuj4cuSO76eGiTSnJpM6Pjo4QWWk
         0SVIlQ4IdtpvdUoe5AyZ1XwHyla4ofOtWsoGlxBvsIXxxuzZy3I5D6ZMRhS+9R22D6nL
         7Nn4p3oPs0s2f8r0FIcTN5I8N8HyLEHEYU7o597Nd17iuLO9WW/V9FM562xwbUYXPxdM
         XpJ6Z8niUPeqp61/0+uf7CE8J/Ecid7o101+j9N+OU7EzOOv4pt9Z1P/0/SbM4/O00vx
         qu+gjO1zg4Zyy4E0ZvsyHHQVPAoR+Btz53BCTROCvbptiH47AV9u5EhRaIYm0/sOCxz8
         7Dqw==
X-Gm-Message-State: AAQBX9dmjjyEKydLzHiey4ASCJRxu0zh2HlctQVbRAG8ZW3PQaCCBnNw
        0tC0Fgr7HjNtBL3wRX+FzPswp6DwoRPgetLzqVbazbLJ1H5tKuBwL4DnYh4ZBCpwebgo1x1hrzZ
        P20jHMDcJDNseNwxMOlanvsKLNpds5om3xw==
X-Received: by 2002:a17:90b:3b4e:b0:246:c223:14ab with SMTP id ot14-20020a17090b3b4e00b00246c22314abmr991143pjb.41.1681862407691;
        Tue, 18 Apr 2023 17:00:07 -0700 (PDT)
X-Google-Smtp-Source: AKy350b2rxRXCjHfra6nMJVqr3+K5cTWMGyHbKdhW3l50Dl3wBNWi33cSzP87HQ9pEsSmCLWH6fBBQ==
X-Received: by 2002:a17:90b:3b4e:b0:246:c223:14ab with SMTP id ot14-20020a17090b3b4e00b00246c22314abmr991128pjb.41.1681862407262;
        Tue, 18 Apr 2023 17:00:07 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090a94c900b00246f856d678sm151175pjw.1.2023.04.18.17.00.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Apr 2023 17:00:06 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 492B6607E6; Tue, 18 Apr 2023 17:00:06 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 4241C9FB79;
        Tue, 18 Apr 2023 17:00:06 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Ido Schimmel <idosch@nvidia.com>
cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy@greyhouse.net,
        monis@Voltaire.COM, razor@blackwall.org,
        mirsad.todorovac@alu.unizg.hr
Subject: Re: [PATCH net] bonding: Fix memory leak when changing bond type to Ethernet
In-reply-to: <20230417061216.2398529-1-idosch@nvidia.com>
References: <20230417061216.2398529-1-idosch@nvidia.com>
Comments: In-reply-to Ido Schimmel <idosch@nvidia.com>
   message dated "Mon, 17 Apr 2023 09:12:16 +0300."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10758.1681862406.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 18 Apr 2023 17:00:06 -0700
Message-ID: <10759.1681862406@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ido Schimmel <idosch@nvidia.com> wrote:

>When a net device is put administratively up, its 'IFF_UP' flag is set
>(if not set already) and a 'NETDEV_UP' notification is emitted, which
>causes the 8021q driver to add VLAN ID 0 on the device. The reverse
>happens when a net device is put administratively down.
>
>When changing the type of a bond to Ethernet, its 'IFF_UP' flag is
>incorrectly cleared, resulting in the kernel skipping the above process
>and VLAN ID 0 being leaked [1].
>
>Fix by restoring the flag when changing the type to Ethernet, in a
>similar fashion to the restoration of the 'IFF_SLAVE' flag.
>
>The issue can be reproduced using the script in [2], with example out
>before and after the fix in [3].
>
>[1]
>unreferenced object 0xffff888103479900 (size 256):
>  comm "ip", pid 329, jiffies 4294775225 (age 28.561s)
>  hex dump (first 32 bytes):
>    00 a0 0c 15 81 88 ff ff 00 00 00 00 00 00 00 00  ................
>    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>  backtrace:
>    [<ffffffff81a6051a>] kmalloc_trace+0x2a/0xe0
>    [<ffffffff8406426c>] vlan_vid_add+0x30c/0x790
>    [<ffffffff84068e21>] vlan_device_event+0x1491/0x21a0
>    [<ffffffff81440c8e>] notifier_call_chain+0xbe/0x1f0
>    [<ffffffff8372383a>] call_netdevice_notifiers_info+0xba/0x150
>    [<ffffffff837590f2>] __dev_notify_flags+0x132/0x2e0
>    [<ffffffff8375ad9f>] dev_change_flags+0x11f/0x180
>    [<ffffffff8379af36>] do_setlink+0xb96/0x4060
>    [<ffffffff837adf6a>] __rtnl_newlink+0xc0a/0x18a0
>    [<ffffffff837aec6c>] rtnl_newlink+0x6c/0xa0
>    [<ffffffff837ac64e>] rtnetlink_rcv_msg+0x43e/0xe00
>    [<ffffffff839a99e0>] netlink_rcv_skb+0x170/0x440
>    [<ffffffff839a738f>] netlink_unicast+0x53f/0x810
>    [<ffffffff839a7fcb>] netlink_sendmsg+0x96b/0xe90
>    [<ffffffff8369d12f>] ____sys_sendmsg+0x30f/0xa70
>    [<ffffffff836a6d7a>] ___sys_sendmsg+0x13a/0x1e0
>unreferenced object 0xffff88810f6a83e0 (size 32):
>  comm "ip", pid 329, jiffies 4294775225 (age 28.561s)
>  hex dump (first 32 bytes):
>    a0 99 47 03 81 88 ff ff a0 99 47 03 81 88 ff ff  ..G.......G.....
>    81 00 00 00 01 00 00 00 cc cc cc cc cc cc cc cc  ................
>  backtrace:
>    [<ffffffff81a6051a>] kmalloc_trace+0x2a/0xe0
>    [<ffffffff84064369>] vlan_vid_add+0x409/0x790
>    [<ffffffff84068e21>] vlan_device_event+0x1491/0x21a0
>    [<ffffffff81440c8e>] notifier_call_chain+0xbe/0x1f0
>    [<ffffffff8372383a>] call_netdevice_notifiers_info+0xba/0x150
>    [<ffffffff837590f2>] __dev_notify_flags+0x132/0x2e0
>    [<ffffffff8375ad9f>] dev_change_flags+0x11f/0x180
>    [<ffffffff8379af36>] do_setlink+0xb96/0x4060
>    [<ffffffff837adf6a>] __rtnl_newlink+0xc0a/0x18a0
>    [<ffffffff837aec6c>] rtnl_newlink+0x6c/0xa0
>    [<ffffffff837ac64e>] rtnetlink_rcv_msg+0x43e/0xe00
>    [<ffffffff839a99e0>] netlink_rcv_skb+0x170/0x440
>    [<ffffffff839a738f>] netlink_unicast+0x53f/0x810
>    [<ffffffff839a7fcb>] netlink_sendmsg+0x96b/0xe90
>    [<ffffffff8369d12f>] ____sys_sendmsg+0x30f/0xa70
>    [<ffffffff836a6d7a>] ___sys_sendmsg+0x13a/0x1e0
>
>[2]
>ip link add name t-nlmon type nlmon
>ip link add name t-dummy type dummy
>ip link add name t-bond type bond mode active-backup
>
>ip link set dev t-bond up
>ip link set dev t-nlmon master t-bond
>ip link set dev t-nlmon nomaster
>ip link show dev t-bond
>ip link set dev t-dummy master t-bond
>ip link show dev t-bond
>
>ip link del dev t-bond
>ip link del dev t-dummy
>ip link del dev t-nlmon
>
>[3]
>Before:
>
>12: t-bond: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noq=
ueue state DOWN mode DEFAULT group default qlen 1000
>    link/netlink
>12: t-bond: <BROADCAST,MULTICAST,MASTER,LOWER_UP> mtu 1500 qdisc noqueue =
state UP mode DEFAULT group default qlen 1000
>    link/ether 46:57:39:a4:46:a2 brd ff:ff:ff:ff:ff:ff
>
>After:
>
>12: t-bond: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noq=
ueue state DOWN mode DEFAULT group default qlen 1000
>    link/netlink
>12: t-bond: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noque=
ue state UP mode DEFAULT group default qlen 1000
>    link/ether 66:48:7b:74:b6:8a brd ff:ff:ff:ff:ff:ff
>
>Fixes: e36b9d16c6a6 ("bonding: clean muticast addresses when device chang=
es type")
>Fixes: 75c78500ddad ("bonding: remap muticast addresses without using dev=
_close() and dev_open()")
>Fixes: 9ec7eb60dcbc ("bonding: restore IFF_MASTER/SLAVE flags on bond ens=
lave ether type change")
>Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>Link: https://lore.kernel.org/netdev/78a8a03b-6070-3e6b-5042-f848dab16fb8=
@alu.unizg.hr/
>Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>Signed-off-by: Ido Schimmel <idosch@nvidia.com>

	Note that this has nothing to do with nlmon specifically, it's
related to anything that's not ARPHRD_ETHER.

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

>---
> drivers/net/bonding/bond_main.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 8cc9a74789b7..7a7d584f378a 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1777,14 +1777,15 @@ void bond_lower_state_changed(struct slave *slave=
)
> =

> /* The bonding driver uses ether_setup() to convert a master bond device
>  * to ARPHRD_ETHER, that resets the target netdevice's flags so we alway=
s
>- * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE if it=
 was set
>+ * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE and I=
FF_UP
>+ * if they were set
>  */
> static void bond_ether_setup(struct net_device *bond_dev)
> {
>-	unsigned int slave_flag =3D bond_dev->flags & IFF_SLAVE;
>+	unsigned int flags =3D bond_dev->flags & (IFF_SLAVE | IFF_UP);
> =

> 	ether_setup(bond_dev);
>-	bond_dev->flags |=3D IFF_MASTER | slave_flag;
>+	bond_dev->flags |=3D IFF_MASTER | flags;
> 	bond_dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
> }
> =

>-- =

>2.37.3

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
