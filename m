Return-Path: <netdev+bounces-4557-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 735E870D37D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A834F28123E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F01961B912;
	Tue, 23 May 2023 06:00:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB31EEDD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:00:51 +0000 (UTC)
Received: from out-1.mta0.migadu.com (out-1.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F96E115
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 23:00:48 -0700 (PDT)
Message-ID: <3cc9f12a-d680-e05c-72c6-d4cb559fe5ee@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684821647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tGELPRx86ep04iXrD8HrqkTjc/I4h979qXOX39g1jec=;
	b=ncO15s15ZTiwVJSjAUCCczEg/KIQWPixg78CaGWozLn3L0OcWbrU+fsxO4bw5iMvdTxTSB
	O2aEj1XokqUR7jhIL9/LEDweaMTHYyEZU0HQCLi9HMtGMqDKrQKDT6FqXz1G7dBR+6tl2a
	S/QhPxlOsmist80tqTVzaeyu6ZV02e0=
Date: Tue, 23 May 2023 14:00:43 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [syzbot] [rdma?] INFO: trying to register non-static key in
 skb_dequeue (2)
Content-Language: en-US
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: syzbot <syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com>,
 jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <000000000000a589d005fc52ee2d@google.com>
 <13528f21-0f36-4fa2-d34f-eecee6720bc1@linux.dev>
 <CAD=hENeCo=-Pk9TWnqxOWP9Pg-JXWk6n6J19gvPo9_h7drROGg@mail.gmail.com>
 <CAD=hENdoyBZaRz7aTy4mX5Kq1OYmWabx2vx8vPH0gQfHO1grzw@mail.gmail.com>
 <0d515e17-5386-61ba-8278-500620969497@linux.dev>
 <CAD=hENcqa0jQvLjuXw9bMtivCkKpQ9=1e0-y-1oxL23OLjutuw@mail.gmail.com>
 <63b9f740-3762-2ec0-9750-eb8709c886a5@linux.dev>
 <CAD=hENfRW7stx0c_uTh6KXwLwovv3wA9q-hKA6Xz6UNcEPYcNA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CAD=hENfRW7stx0c_uTh6KXwLwovv3wA9q-hKA6Xz6UNcEPYcNA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/23/23 13:55, Zhu Yanjun wrote:
> On Tue, May 23, 2023 at 1:50 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>
>>
>> On 5/23/23 12:29, Zhu Yanjun wrote:
>>> On Tue, May 23, 2023 at 12:10 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>>>
>>>> On 5/23/23 12:02, Zhu Yanjun wrote:
>>>>> On Tue, May 23, 2023 at 11:47 AM Zhu Yanjun <zyjzyj2000@gmail.com> wrote:
>>>>>> On Tue, May 23, 2023 at 10:26 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>>>>>> On 5/23/23 10:13, syzbot wrote:
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> syzbot tried to test the proposed patch but the build/boot failed:
>>>>>>>>
>>>>>>>> failed to apply patch:
>>>>>>>> checking file drivers/infiniband/sw/rxe/rxe_qp.c
>>>>>>>> patch: **** unexpected end of file in patch
>>>>>> This is not the root cause. The fix is not good.
>>>>> This problem is about "INFO: trying to register non-static key. The
>>>>> code is fine but needs lockdep annotation, or maybe"
>>> This warning is from "lock is not initialized". This is a
>>> use-before-initialized problem.
>> Right, and it also applies to qp->sq.queue which is set to NULL while do
>> cleanup
>> still de-reference it.
>>
>>> The correct fix is to initialize the lock that is complained before it is used.
>> The thing is it can't be initialized due to error, so I guess you want
>> to always init them
>> even for error cases.
> The complaining is about "spinlock is not initialized".

There was another null-ptr-deref, no?

general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 1 PID: 31038 Comm: syz-executor.3 Not tainted 6.3.0-syzkaller-12728-g348551ddaf31 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
RIP: 0010:flush_send_queue drivers/infiniband/sw/rxe/rxe_comp.c:597 [inline]
RIP: 0010:rxe_completer+0x255c/0x3cc0 drivers/infiniband/sw/rxe/rxe_comp.c:653
Code: 80 3c 02 00 0f 85 81 10 00 00 49 8b af 88 03 00 00 48 8d 45 30 48 89 c2 48 89 04 24 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 83 11 00 00 48 8d 45 2c 44 8b
RSP: 0018:ffffc90003526938 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffffed100e3fe800 RCX: ffffc9000b403000
RDX: 0000000000000006 RSI: ffffffff877e467a RDI: ffff888071ff4388
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: fffffbfff1cf3682 R11: fffffffffffda5b0 R12: ffff888071ff41a0
R13: 0000000000000000 R14: 0000000000000000 R15: ffff888071ff4000
FS:  00007fede029f700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2d822000 CR3: 000000002c7e6000 CR4: 00000000003506e0
Call Trace:
  <TASK>
  rxe_qp_do_cleanup+0x1be/0x820 drivers/infiniband/sw/rxe/rxe_qp.c:761
  execute_in_process_context+0x3b/0x150 kernel/workqueue.c:3473
  __rxe_cleanup+0x21e/0x370 drivers/infiniband/sw/rxe/rxe_pool.c:233
  rxe_create_qp+0x3f6/0x5f0 drivers/infiniband/sw/rxe/rxe_verbs.c:583
  create_qp+0x5ac/0x970 drivers/infiniband/core/verbs.c:1235
  ib_create_qp_kernel+0xa1/0x310 drivers/infiniband/core/verbs.c:1346
  ib_create_qp include/rdma/ib_verbs.h:3743 [inline]
  create_mad_qp+0x177/0x380 drivers/infiniband/core/mad.c:2905
  ib_mad_port_open drivers/infiniband/core/mad.c:2986 [inline]
  ib_mad_init_device+0xf40/0x1a90 drivers/infiniband/core/mad.c:3077
  add_client_context+0x405/0x5e0 drivers/infiniband/core/device.c:721
  enable_device_and_get+0x1cd/0x3b0 drivers/infiniband/core/device.c:1332
  ib_register_device drivers/infiniband/core/device.c:1420 [inline]
  ib_register_device+0x8b1/0xbc0 drivers/infiniband/core/device.c:1366
  rxe_register_device+0x302/0x3e0 drivers/infiniband/sw/rxe/rxe_verbs.c:1485
  rxe_net_add+0x90/0xf0 drivers/infiniband/sw/rxe/rxe_net.c:527
  rxe_newlink+0xf0/0x1b0 drivers/infiniband/sw/rxe/rxe.c:197
  nldev_newlink+0x332/0x5e0 drivers/infiniband/core/nldev.c:1731
  rdma_nl_rcv_msg+0x371/0x6a0 drivers/infiniband/core/netlink.c:195
  rdma_nl_rcv_skb.constprop.0.isra.0+0x2fc/0x440 drivers/infiniband/core/netlink.c:239
  netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
  netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
  netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1913
  sock_sendmsg_nosec net/socket.c:724 [inline]
  sock_sendmsg+0xde/0x190 net/socket.c:747
  ____sys_sendmsg+0x71c/0x900 net/socket.c:2503
  ___sys_sendmsg+0x110/0x1b0 net/socket.c:2557
  __sys_sendmsg+0xf7/0x1c0 net/socket.c:2586
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7feddf48c169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fede029f168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007feddf5abf80 RCX: 00007feddf48c169
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 00007feddf4e7ca1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe1bb3e01f R14: 00007fede029f300 R15: 0000000000022000
  </TASK>
Modules linked in:


Guoqing


