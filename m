Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3524C0F1F
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 10:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238624AbiBWJYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 04:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiBWJYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 04:24:11 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2408303E;
        Wed, 23 Feb 2022 01:23:43 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id j17so11789620wrc.0;
        Wed, 23 Feb 2022 01:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jbq10nLonOoQIWUDU4MM+CGkApLNOTNDOJQzwLbfqW0=;
        b=oPNM/G3uSPpuBebgefqdbWMgRiFhcsduaOPEq9qNwzcd74ZUcXRSMgNHCith4Gw+H2
         pmts7S2pLGO5jsaODMKe6qEVR/Cru3BOY3zsP/9/O1OakDRRmmW0BYFlhDTvz7sHtM3d
         SbI5AO0g5a8+epvFXKA2oNZLWZTG8lJC7VhNV0JOcXZ/Jj2SufRKBF6tXP4ic1picRHm
         Dk0zT50yj8E8fvOi2bruCmB0Ki+RHTgjK9602ikrnd4ThBKi1KsmDB1IddSNODwLd4xb
         /MYnY8BSifay5sU8OAJ7ca1UeqBValBBjX3357pY5HH3lsmBqPZfijLgdQPBq4fNLVkV
         YRpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jbq10nLonOoQIWUDU4MM+CGkApLNOTNDOJQzwLbfqW0=;
        b=sz278/CxGNLohC9pvYluSYyaakYWgpcUKiDyOOj1JdoPuBoVnm/ovVDqaWkC6SLcK2
         oDqlPg7ha7KR5Jb3Tkf2O5VW/UswR1CW/51vVtJhNZwDiyT93OYOVRA/BWyuaA150jvI
         5975hTNAG2Eq0DGX/K2Pe2aDjiDvs/n61C0lSkZN3r6q3tKnLbdCu2xswllgyYhn0PLo
         d0Rv4WmyAtP+z76H6iM4ihtmMKGqg29iw94PdfCFXoxSSJcBvJ2UQrrEAobdPJxakRdk
         gHfMKOfU7Ssvt8KwonBz5KqyHvdCfX0M8+8Rf3ax2H+AlsMCKZlQK1fTHB7Oo4il/Dts
         e3rA==
X-Gm-Message-State: AOAM532AAfi7dQlsnJftmxNZKstC45fGWKbKMMaVVjSqm4unfs9qALf2
        k2ivOD25i5qz1S/vnaNnkdo=
X-Google-Smtp-Source: ABdhPJxs2prQPovpRJskBs7NX1FZLDN9J5+qdma86yzWRGsRk/UeaEICxzQv5xQaBFb0qLJ3EEIWvg==
X-Received: by 2002:adf:f583:0:b0:1ed:b63a:819a with SMTP id f3-20020adff583000000b001edb63a819amr1230188wro.104.1645608221328;
        Wed, 23 Feb 2022 01:23:41 -0800 (PST)
Received: from leap.localnet (host-79-27-0-81.retail.telecomitalia.it. [79.27.0.81])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c4e8d00b0037bc5ce6042sm7190098wmq.27.2022.02.23.01.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 01:23:40 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     jgg@ziepe.ca, liangwenpeng@huawei.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        liweihang@huawei.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in smc_pnet_apply_ib
Date:   Wed, 23 Feb 2022 10:23:38 +0100
Message-ID: <2174944.iZASKD2KPV@leap>
In-Reply-To: <0000000000008bcf6e05d83ab885@google.com>
References: <0000000000008bcf6e05d83ab885@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1886803.PYKUYFuaPT"
Content-Transfer-Encoding: 7Bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart1886803.PYKUYFuaPT
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

On gioved=C3=AC 17 febbraio 2022 19:13:19 CET syzbot wrote:
> syzbot has found a reproducer for the following issue on:
>=20
> HEAD commit:    5740d0689096 net: sched: limit TC_ACT_REPEAT loops
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1474360e700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D88e226f0197ae=
ba5
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D4f322a6d84e991c=
38775
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binuti=
ls for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D13dd93f2700=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16a497e2700000
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com
>=20
> infiniband syz1: set active
> infiniband syz1: added lo
> RDS/IB: syz1: added
> smc: adding ib device syz1 with port count 1
> BUG: sleeping function called from invalid context at kernel/locking/mute=
x.c:577
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3589, name: syz-ex=
ecutor180
> preempt_count: 1, expected: 0
> RCU nest depth: 0, expected: 0
> 6 locks held by syz-executor180/3589:
>  #0: ffffffff90865838 (&rdma_nl_types[idx].sem){.+.+}-{3:3}, at: rdma_nl_=
rcv_msg+0x161/0x690 drivers/infiniband/core/netlink.c:164
>  #1: ffffffff8d04edf0 (link_ops_rwsem){++++}-{3:3}, at: nldev_newlink+0x2=
5d/0x560 drivers/infiniband/core/nldev.c:1707
>  #2: ffffffff8d03e650 (devices_rwsem){++++}-{3:3}, at: enable_device_and_=
get+0xfc/0x3b0 drivers/infiniband/core/device.c:1321
>  #3: ffffffff8d03e510 (clients_rwsem){++++}-{3:3}, at: enable_device_and_=
get+0x15b/0x3b0 drivers/infiniband/core/device.c:1329
>  #4: ffff8880790445c0 (&device->client_data_rwsem){++++}-{3:3}, at: add_c=
lient_context+0x3d0/0x5e0 drivers/infiniband/core/device.c:718
>  #5: ffff88814a29c818 (&pnettable->lock){++++}-{2:2}, at: smc_pnetid_by_t=
able_ib+0x18c/0x470 net/smc/smc_pnet.c:1159
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 0 PID: 3589 Comm: syz-executor180 Not tainted 5.17.0-rc3-syzkaller-0=
0174-g5740d0689096 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  __might_resched.cold+0x222/0x26b kernel/sched/core.c:9576
>  __mutex_lock_common kernel/locking/mutex.c:577 [inline]
>  __mutex_lock+0x9f/0x12f0 kernel/locking/mutex.c:733
>  smc_pnet_apply_ib+0x28/0x160 net/smc/smc_pnet.c:251
>  smc_pnetid_by_table_ib+0x2ae/0x470 net/smc/smc_pnet.c:1164
>  smc_ib_add_dev+0x4d7/0x900 net/smc/smc_ib.c:940
>  add_client_context+0x405/0x5e0 drivers/infiniband/core/device.c:720
>  enable_device_and_get+0x1cd/0x3b0 drivers/infiniband/core/device.c:1331
>  ib_register_device drivers/infiniband/core/device.c:1419 [inline]
>  ib_register_device+0x814/0xaf0 drivers/infiniband/core/device.c:1365
>  rxe_register_device+0x2fe/0x3b0 drivers/infiniband/sw/rxe/rxe_verbs.c:11=
46
>  rxe_add+0x1331/0x1710 drivers/infiniband/sw/rxe/rxe.c:246
>  rxe_net_add+0x8c/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:538
>  rxe_newlink drivers/infiniband/sw/rxe/rxe.c:268 [inline]
>  rxe_newlink+0xa9/0xd0 drivers/infiniband/sw/rxe/rxe.c:249
>  nldev_newlink+0x30a/0x560 drivers/infiniband/core/nldev.c:1717
>  rdma_nl_rcv_msg+0x36d/0x690 drivers/infiniband/core/netlink.c:195
>  rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
>  rdma_nl_rcv+0x2ee/0x430 drivers/infiniband/core/netlink.c:259
>  netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
>  netlink_unicast+0x539/0x7e0 net/netlink/af_netlink.c:1343
>  netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:705 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:725
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2413
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f7ef25bed59
> Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffcd0ce91d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7ef25bed59
> RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000005
> RBP: 00007f7ef25827c0 R08: 0000000000000014 R09: 0000000000000000
> R10: 0000000000000041 R11: 0000000000000246 R12: 00007f7ef2582850
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> [ BUG: Invalid wait context ]
> 5.17.0-rc3-syzkaller-00174-g5740d0689096 #0 Tainted: G        W       =20
> -----------------------------
> syz-executor180/3589 is trying to lock:
> ffffffff8d7100d8 (smc_ib_devices.mutex){+.+.}-{3:3}, at: smc_pnet_apply_i=
b+0x28/0x160 net/smc/smc_pnet.c:251
> other info that might help us debug this:
> context-{4:4}
> 6 locks held by syz-executor180/3589:
>  #0: ffffffff90865838 (&rdma_nl_types[idx].sem){.+.+}-{3:3}, at: rdma_nl_=
rcv_msg+0x161/0x690 drivers/infiniband/core/netlink.c:164
>  #1: ffffffff8d04edf0 (link_ops_rwsem){++++}-{3:3}, at: nldev_newlink+0x2=
5d/0x560 drivers/infiniband/core/nldev.c:1707
>  #2: ffffffff8d03e650 (devices_rwsem){++++}-{3:3}, at: enable_device_and_=
get+0xfc/0x3b0 drivers/infiniband/core/device.c:1321
>  #3: ffffffff8d03e510 (clients_rwsem){++++}-{3:3}, at: enable_device_and_=
get+0x15b/0x3b0 drivers/infiniband/core/device.c:1329
>  #4: ffff8880790445c0 (&device->client_data_rwsem){++++}-{3:3}, at: add_c=
lient_context+0x3d0/0x5e0 drivers/infiniband/core/device.c:718
>  #5: ffff88814a29c818 (&pnettable->lock){++++}-{2:2}, at: smc_pnetid_by_t=
able_ib+0x18c/0x470 net/smc/smc_pnet.c:1159
> stack backtrace:
> CPU: 0 PID: 3589 Comm: syz-executor180 Tainted: G        W         5.17.0=
=2Drc3-syzkaller-00174-g5740d0689096 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_lock_invalid_wait_context kernel/locking/lockdep.c:4678 [inline]
>  check_wait_context kernel/locking/lockdep.c:4739 [inline]
>  __lock_acquire.cold+0x213/0x3ab kernel/locking/lockdep.c:4977
>  lock_acquire kernel/locking/lockdep.c:5639 [inline]
>  lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5604
>  __mutex_lock_common kernel/locking/mutex.c:600 [inline]
>  __mutex_lock+0x12f/0x12f0 kernel/locking/mutex.c:733
>  smc_pnet_apply_ib+0x28/0x160 net/smc/smc_pnet.c:251
>  smc_pnetid_by_table_ib+0x2ae/0x470 net/smc/smc_pnet.c:1164
>  smc_ib_add_dev+0x4d7/0x900 net/smc/smc_ib.c:940
>  add_client_context+0x405/0x5e0 drivers/infiniband/core/device.c:720
>  enable_device_and_get+0x1cd/0x3b0 drivers/infiniband/core/device.c:1331
>  ib_register_device drivers/infiniband/core/device.c:1419 [inline]
>  ib_register_device+0x814/0xaf0 drivers/infiniband/core/device.c:1365
>  rxe_register_device+0x2fe/0x3b0 drivers/infiniband/sw/rxe/rxe_verbs.c:11=
46
>  rxe_add+0x1331/0x1710 drivers/infiniband/sw/rxe/rxe.c:246
>  rxe_net_add+0x8c/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:538
>  rxe_newlink drivers/infiniband/sw/rxe/rxe.c:268 [inline]
>  rxe_newlink+0xa9/0xd0 drivers/infiniband/sw/rxe/rxe.c:249
>  nldev_newlink+0x30a/0x560 drivers/infiniband/core/nldev.c:1717
>  rdma_nl_rcv_msg+0x36d/0x690 drivers/infiniband/core/netlink.c:195
>  rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
>  rdma_nl_rcv+0x2ee/0x430 drivers/infiniband/core/netlink.c:259
>  netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
>  netlink_unicast+0x539/0x7e0 net/netlink/af_netlink.c:1343
>  netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:705 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:725
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2413
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f7ef25bed59
> Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffcd0ce91d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7ef25bed59
> RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000005
> RBP: 00007f7ef25827c0 R08: 0000000000000014 R09: 0000000000000000
> R10: 0000000000000041 R11: 0000000000000246 R12: 00007f7ef2582850
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> smc:    ib device syz1 port 1 has pnetid SYZ2 (user defined)
>=20
As confirmed by Tony Lu (thanks!), replace rwlocks with mutexes for locking=
=20
"struct smc_pnettable".

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git=
 master

=46abio M. De Francesco

P.S.: I have just sent another diff but it has a stupid mistake so it canno=
t compile.


--nextPart1886803.PYKUYFuaPT
Content-Disposition: attachment; filename="diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="diff"

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 0599246c0376..29f0a559d884 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -113,7 +113,7 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 	pnettable = &sn->pnettable;
 
 	/* remove table entry */
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist,
 				 list) {
 		if (!pnet_name ||
@@ -131,7 +131,7 @@ static int smc_pnet_remove_by_pnetid(struct net *net, char *pnet_name)
 			rc = 0;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	/* if this is not the initial namespace, stop here */
 	if (net != &init_net)
@@ -192,7 +192,7 @@ static int smc_pnet_add_by_ndev(struct net_device *ndev)
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && !pnetelem->ndev &&
 		    !strncmp(pnetelem->eth_name, ndev->name, IFNAMSIZ)) {
@@ -206,7 +206,7 @@ static int smc_pnet_add_by_ndev(struct net_device *ndev)
 			break;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -224,7 +224,7 @@ static int smc_pnet_remove_by_ndev(struct net_device *ndev)
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry_safe(pnetelem, tmp_pe, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && pnetelem->ndev == ndev) {
 			dev_put_track(pnetelem->ndev, &pnetelem->dev_tracker);
@@ -237,7 +237,7 @@ static int smc_pnet_remove_by_ndev(struct net_device *ndev)
 			break;
 		}
 	}
-	write_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -370,7 +370,7 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 	strncpy(new_pe->eth_name, eth_name, IFNAMSIZ);
 	rc = -EEXIST;
 	new_netdev = true;
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_ETH &&
 		    !strncmp(tmp_pe->eth_name, eth_name, IFNAMSIZ)) {
@@ -385,9 +385,9 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 					     GFP_ATOMIC);
 		}
 		list_add_tail(&new_pe->list, &pnettable->pnetlist);
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 	} else {
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 		kfree(new_pe);
 		goto out_put;
 	}
@@ -448,7 +448,7 @@ static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
 	new_pe->ib_port = ib_port;
 
 	new_ibdev = true;
-	write_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX)) {
@@ -458,9 +458,9 @@ static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
 	}
 	if (new_ibdev) {
 		list_add_tail(&new_pe->list, &pnettable->pnetlist);
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 	} else {
-		write_unlock(&pnettable->lock);
+		mutex_unlock(&pnettable->lock);
 		kfree(new_pe);
 	}
 	return (new_ibdev) ? 0 : -EEXIST;
@@ -605,7 +605,7 @@ static int _smc_pnet_dump(struct net *net, struct sk_buff *skb, u32 portid,
 	pnettable = &sn->pnettable;
 
 	/* dump pnettable entries */
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(pnetelem, &pnettable->pnetlist, list) {
 		if (pnetid && !smc_pnet_match(pnetelem->pnet_name, pnetid))
 			continue;
@@ -620,7 +620,7 @@ static int _smc_pnet_dump(struct net *net, struct sk_buff *skb, u32 portid,
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return idx;
 }
 
@@ -864,7 +864,7 @@ int smc_pnet_net_init(struct net *net)
 	struct smc_pnetids_ndev *pnetids_ndev = &sn->pnetids_ndev;
 
 	INIT_LIST_HEAD(&pnettable->pnetlist);
-	rwlock_init(&pnettable->lock);
+	mutex_init(&pnettable->lock);
 	INIT_LIST_HEAD(&pnetids_ndev->list);
 	rwlock_init(&pnetids_ndev->lock);
 
@@ -944,7 +944,7 @@ static int smc_pnet_find_ndev_pnetid_by_table(struct net_device *ndev,
 	sn = net_generic(net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(pnetelem, &pnettable->pnetlist, list) {
 		if (pnetelem->type == SMC_PNET_ETH && ndev == pnetelem->ndev) {
 			/* get pnetid of netdev device */
@@ -953,7 +953,7 @@ static int smc_pnet_find_ndev_pnetid_by_table(struct net_device *ndev,
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 	return rc;
 }
 
@@ -1156,7 +1156,7 @@ int smc_pnetid_by_table_ib(struct smc_ib_device *smcibdev, u8 ib_port)
 	sn = net_generic(&init_net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX) &&
@@ -1166,7 +1166,7 @@ int smc_pnetid_by_table_ib(struct smc_ib_device *smcibdev, u8 ib_port)
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	return rc;
 }
@@ -1185,7 +1185,7 @@ int smc_pnetid_by_table_smcd(struct smcd_dev *smcddev)
 	sn = net_generic(&init_net, smc_net_id);
 	pnettable = &sn->pnettable;
 
-	read_lock(&pnettable->lock);
+	mutex_lock(&pnettable->lock);
 	list_for_each_entry(tmp_pe, &pnettable->pnetlist, list) {
 		if (tmp_pe->type == SMC_PNET_IB &&
 		    !strncmp(tmp_pe->ib_name, ib_name, IB_DEVICE_NAME_MAX)) {
@@ -1194,7 +1194,7 @@ int smc_pnetid_by_table_smcd(struct smcd_dev *smcddev)
 			break;
 		}
 	}
-	read_unlock(&pnettable->lock);
+	mutex_unlock(&pnettable->lock);
 
 	return rc;
 }
diff --git a/net/smc/smc_pnet.h b/net/smc/smc_pnet.h
index 14039272f7e4..80a88eea4949 100644
--- a/net/smc/smc_pnet.h
+++ b/net/smc/smc_pnet.h
@@ -29,7 +29,7 @@ struct smc_link_group;
  * @pnetlist: List of PNETIDs
  */
 struct smc_pnettable {
-	rwlock_t lock;
+	struct mutex lock;
 	struct list_head pnetlist;
 };
 

--nextPart1886803.PYKUYFuaPT--



