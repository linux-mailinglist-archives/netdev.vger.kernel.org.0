Return-Path: <netdev+bounces-4571-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A368370D41F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A4F51C20C87
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CCAC12B90;
	Tue, 23 May 2023 06:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0619879CA
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:40:20 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C63C132;
	Mon, 22 May 2023 23:40:16 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-50bcb00a4c2so730160a12.1;
        Mon, 22 May 2023 23:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684824014; x=1687416014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=05PYQIqc1/LG4MpcpgxX4qZCPUA9BBDLXYeaZ9CxRL0=;
        b=FC5PUqiuBCO1EWUETlXAWbpKgRwauZWU+hx+jslhU+wMcj39Ip9pJhpTtP3IEWtWyY
         aE4kxJCvffjMdQ/N3U25siuE8p1Yq47r+yOVEMsejY8h/w5RtzzrI61ac0tUYu4gylu9
         l9BooYTh4MIPyG33jJzcHlH1h2McJWkYR8WPb3VQtiaMAJRGcmzs2X/+gylpboKycVGS
         J4z+ssPCCU9FyeYImEtVSYKC28kzKvjzjoQb+FdRXMv2/cYWruX6lichyKaLngRj7I/5
         yc4lMIRySaVvspXDyRTuJ1T8hgAK4JjdnxA49AJXZOJCFEnY6oC+PfqLV8Qa7hQ9ZazJ
         GOGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684824014; x=1687416014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=05PYQIqc1/LG4MpcpgxX4qZCPUA9BBDLXYeaZ9CxRL0=;
        b=krHnyEI9Q3VPprRTHTKcx83NL7dJFxkEVtZRreqA03ZQfTmr4svZS05e8ahMw9b+Tf
         1iDUxUxXmNe961pvGesaqd+WCYvMHX9RVcL5ArAEI9QAPksUNbFFNUko+8MyY8ptZYNs
         2dvY4wkR1pv3huMvsl5r/t5LJTOvjOqvrklhbUdOTccHYa4VKEKbuWfw/TAK3YBcIa/b
         gw0rhyKqe144+/l5Em8hZt2lVNbCvMWMWKXcpfmxky+B2uTFqE5/eBv6mpefP1Lc8OrA
         GVJFpcbm8yih5zrOWdhGUb9Lsm6GJItPOSBQ7Z0DXWcYxCoyHLxGMNzLWuZzoCna21uh
         kOQQ==
X-Gm-Message-State: AC+VfDz5WW9QhDOO6CSss+1SorXtRVLQC4rpr8RiDdcW2o3KzWvbqgPn
	o0PTZySiHzNRLPY3ZK8hYDnrsI/iqd6GBUA3XmM=
X-Google-Smtp-Source: ACHHUZ6eA7dKSre1GYwWpkG3iCKvGSNZFoqkPUUf+UsMr21p7HIURG5FwHWch3enwDRvNDA3EK3EmeYf6zVY5L8rIQ8=
X-Received: by 2002:a17:907:2d2c:b0:96f:e5af:ac73 with SMTP id
 gs44-20020a1709072d2c00b0096fe5afac73mr5711178ejc.66.1684824014384; Mon, 22
 May 2023 23:40:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000a589d005fc52ee2d@google.com> <13528f21-0f36-4fa2-d34f-eecee6720bc1@linux.dev>
 <CAD=hENeCo=-Pk9TWnqxOWP9Pg-JXWk6n6J19gvPo9_h7drROGg@mail.gmail.com>
 <CAD=hENdoyBZaRz7aTy4mX5Kq1OYmWabx2vx8vPH0gQfHO1grzw@mail.gmail.com>
 <0d515e17-5386-61ba-8278-500620969497@linux.dev> <CAD=hENcqa0jQvLjuXw9bMtivCkKpQ9=1e0-y-1oxL23OLjutuw@mail.gmail.com>
 <63b9f740-3762-2ec0-9750-eb8709c886a5@linux.dev> <CAD=hENfRW7stx0c_uTh6KXwLwovv3wA9q-hKA6Xz6UNcEPYcNA@mail.gmail.com>
 <3cc9f12a-d680-e05c-72c6-d4cb559fe5ee@linux.dev> <CAD=hENcJnt_Xfcu3ES+Fe0-esWuxNSeUwHApNySqYn=0hNRf-A@mail.gmail.com>
 <75012ed7-4935-b41d-0888-176e4f3158c2@linux.dev>
In-Reply-To: <75012ed7-4935-b41d-0888-176e4f3158c2@linux.dev>
From: Zhu Yanjun <zyjzyj2000@gmail.com>
Date: Tue, 23 May 2023 14:40:00 +0800
Message-ID: <CAD=hENeRwNEi=0kSJ2oVLiqay+hdhyj6+tEm72+z-_+JxFLMmA@mail.gmail.com>
Subject: Re: [syzbot] [rdma?] INFO: trying to register non-static key in
 skb_dequeue (2)
To: Guoqing Jiang <guoqing.jiang@linux.dev>
Cc: syzbot <syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com>, jgg@ziepe.ca, 
	leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 2:11=E2=80=AFPM Guoqing Jiang <guoqing.jiang@linux.=
dev> wrote:
>
>
>
> On 5/23/23 14:07, Zhu Yanjun wrote:
>
> >> There was another null-ptr-deref, no?
> > Please show me the link. So I can delve into it.
>
> Just the first mail of the thread ...
>
> >> general protection fault, probably for non-canonical address 0xdffffc0=
000000006: 0000 [#1] PREEMPT SMP KASAN
> >> KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
> >> CPU: 1 PID: 31038 Comm: syz-executor.3 Not tainted 6.3.0-syzkaller-127=
28-g348551ddaf31 #0
> >> Hardware name: Google Google Compute Engine/Google Compute Engine, BIO=
S Google 04/14/2023
> >> RIP: 0010:flush_send_queue drivers/infiniband/sw/rxe/rxe_comp.c:597 [i=
nline]
> >> RIP: 0010:rxe_completer+0x255c/0x3cc0 drivers/infiniband/sw/rxe/rxe_co=
mp.c:653
> >> Code: 80 3c 02 00 0f 85 81 10 00 00 49 8b af 88 03 00 00 48 8d 45 30 4=
8 89 c2 48 89 04 24 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02=
 84 c0 74 08 3c 03 0f 8e 83 11 00 00 48 8d 45 2c 44 8b
> >> RSP: 0018:ffffc90003526938 EFLAGS: 00010206
> >> RAX: dffffc0000000000 RBX: ffffed100e3fe800 RCX: ffffc9000b403000
> >> RDX: 0000000000000006 RSI: ffffffff877e467a RDI: ffff888071ff4388
> >> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> >> R10: fffffbfff1cf3682 R11: fffffffffffda5b0 R12: ffff888071ff41a0
> >> R13: 0000000000000000 R14: 0000000000000000 R15: ffff888071ff4000
> >> FS:  00007fede029f700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000=
000000
> >> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> CR2: 0000001b2d822000 CR3: 000000002c7e6000 CR4: 00000000003506e0
> >> Call Trace:
> >>    <TASK>
> >>    rxe_qp_do_cleanup+0x1be/0x820 drivers/infiniband/sw/rxe/rxe_qp.c:76=
1
> >>    execute_in_process_context+0x3b/0x150 kernel/workqueue.c:3473
> >>    __rxe_cleanup+0x21e/0x370 drivers/infiniband/sw/rxe/rxe_pool.c:233
> >>    rxe_create_qp+0x3f6/0x5f0 drivers/infiniband/sw/rxe/rxe_verbs.c:583
> >>    create_qp+0x5ac/0x970 drivers/infiniband/core/verbs.c:1235
> >>    ib_create_qp_kernel+0xa1/0x310 drivers/infiniband/core/verbs.c:1346
> >>    ib_create_qp include/rdma/ib_verbs.h:3743 [inline]
> >>    create_mad_qp+0x177/0x380 drivers/infiniband/core/mad.c:2905
> >>    ib_mad_port_open drivers/infiniband/core/mad.c:2986 [inline]
> >>    ib_mad_init_device+0xf40/0x1a90 drivers/infiniband/core/mad.c:3077
> >>    add_client_context+0x405/0x5e0 drivers/infiniband/core/device.c:721
> >>    enable_device_and_get+0x1cd/0x3b0 drivers/infiniband/core/device.c:=
1332
> >>    ib_register_device drivers/infiniband/core/device.c:1420 [inline]
> >>    ib_register_device+0x8b1/0xbc0 drivers/infiniband/core/device.c:136=
6
> >>    rxe_register_device+0x302/0x3e0 drivers/infiniband/sw/rxe/rxe_verbs=
.c:1485
> >>    rxe_net_add+0x90/0xf0 drivers/infiniband/sw/rxe/rxe_net.c:527
> >>    rxe_newlink+0xf0/0x1b0 drivers/infiniband/sw/rxe/rxe.c:197
> >>    nldev_newlink+0x332/0x5e0 drivers/infiniband/core/nldev.c:1731
> >>    rdma_nl_rcv_msg+0x371/0x6a0 drivers/infiniband/core/netlink.c:195
> >>    rdma_nl_rcv_skb.constprop.0.isra.0+0x2fc/0x440 drivers/infiniband/c=
ore/netlink.c:239
> >>    netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
> >>    netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
> >>    netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1913
> >>    sock_sendmsg_nosec net/socket.c:724 [inline]
> >>    sock_sendmsg+0xde/0x190 net/socket.c:747
> >>    ____sys_sendmsg+0x71c/0x900 net/socket.c:2503
> >>    ___sys_sendmsg+0x110/0x1b0 net/socket.c:2557
> >>    __sys_sendmsg+0xf7/0x1c0 net/socket.c:2586
> >>    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >>    do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> >>    entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >> RIP: 0033:0x7feddf48c169
> >> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 8=
9 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0=
 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> >> RSP: 002b:00007fede029f168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> >> RAX: ffffffffffffffda RBX: 00007feddf5abf80 RCX: 00007feddf48c169
> >> RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
> >> RBP: 00007feddf4e7ca1 R08: 0000000000000000 R09: 0000000000000000
> >> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> >> R13: 00007ffe1bb3e01f R14: 00007fede029f300 R15: 0000000000022000
> >>    </TASK>
> >> Modules linked in:
> >>
>
> Anyway, pls check above in the link.
>
> https://lore.kernel.org/linux-rdma/3cc9f12a-d680-e05c-72c6-d4cb559fe5ee@l=
inux.dev/T/#m2d374949d62b017074545c2f2a1df9251e0bde32
>

Based on the following analysis, the problem in the link is the same
with this problem.

infiniband syz2: set active
infiniband syz2: added bond_slave_1
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
         <----This means that this is a use-before-initialization
problem
turning off the locking correctness validator.
CPU: 1 PID: 31038 Comm: syz-executor.3 Not tainted
6.3.0-syzkaller-12728-g348551ddaf31 #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 04/14/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 assign_lock_key kernel/locking/lockdep.c:982 [inline]
 register_lock_class+0xdb6/0x1120 kernel/locking/lockdep.c:1295
 __lock_acquire+0x10a/0x5df0 kernel/locking/lockdep.c:4951
 lock_acquire kernel/locking/lockdep.c:5691 [inline]
 lock_acquire+0x1b1/0x520 kernel/locking/lockdep.c:5656
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
 skb_dequeue+0x20/0x180 net/core/skbuff.c:3631
 drain_resp_pkts drivers/infiniband/sw/rxe/rxe_comp.c:555 [inline]
                    <----- when skb_dequeue is called, spin lock of
resp_pkts is not initialized.
 rxe_completer+0x250d/0x3cc0 drivers/infiniband/sw/rxe/rxe_comp.c:652
 rxe_qp_do_cleanup+0x1be/0x820 drivers/infiniband/sw/rxe/rxe_qp.c:761
 execute_in_process_context+0x3b/0x150 kernel/workqueue.c:3473
 __rxe_cleanup+0x21e/0x370 drivers/infiniband/sw/rxe/rxe_pool.c:233

 rxe_create_qp+0x3f6/0x5f0 drivers/infiniband/sw/rxe/rxe_verbs.c:583 <---- =
Here.

 "
 573         err =3D rxe_qp_from_init(rxe, qp, pd, init, uresp, ibqp->pd, u=
data);
 574         if (err) {
 575                 rxe_dbg_qp(qp, "create qp failed, err =3D %d", err);
 576                 goto err_cleanup;
 577         }
 578
 579         rxe_finalize(qp);
 580         return 0;
 581
 582 err_cleanup:
 583         cleanup_err =3D rxe_cleanup(qp);    <--- this is error handler=
.

 "
  create_qp+0x5ac/0x970 drivers/infiniband/core/verbs.c:1235
  ib_create_qp_kernel+0xa1/0x310 drivers/infiniband/core/verbs.c:1346

Zhu Yanjun
> Guoqing

