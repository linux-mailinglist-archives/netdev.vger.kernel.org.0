Return-Path: <netdev+bounces-2466-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB4487021D5
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 04:45:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E31E6281035
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 02:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2195139B;
	Mon, 15 May 2023 02:45:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE89EA0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:45:26 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B5ED9;
	Sun, 14 May 2023 19:45:24 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QKNwz27qgzLmGM;
	Mon, 15 May 2023 10:44:03 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 10:45:21 +0800
Message-ID: <ae4c68c8-e798-778f-f53c-9c455c6a9f6c@huawei.com>
Date: Mon, 15 May 2023 10:45:20 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [syzbot] [wireless?] memory leak in hwsim_new_radio_nl
To: syzbot <syzbot+904ce6fbb38532d9795c@syzkaller.appspotmail.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <johannes@sipsolutions.net>,
	<kuba@kernel.org>, <kvalo@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <syzkaller-bugs@googlegroups.com>
References: <000000000000383da505fb8509b7@google.com>
From: shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <000000000000383da505fb8509b7@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/5/13 4:34, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    105131df9c3b Merge tag 'dt-fixes-6.4' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1193dc92280000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fa9562c0bfb72fa2
> dashboard link: https://syzkaller.appspot.com/bug?extid=904ce6fbb38532d9795c
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10b4577c280000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a9e29e280000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/029c9c553eb9/disk-105131df.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/c807843227d1/vmlinux-105131df.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/dfce3441d47b/bzImage-105131df.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+904ce6fbb38532d9795c@syzkaller.appspotmail.com
> 
> Warning: Permanently added '10.128.1.177' (ECDSA) to the list of known hosts.
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff88810e2ac920 (size 32):
>    comm "syz-executor238", pid 4983, jiffies 4294944120 (age 14.000s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<ffffffff815458a4>] kmalloc_trace+0x24/0x90 mm/slab_common.c:1057
>      [<ffffffff830fc4fb>] kmalloc include/linux/slab.h:559 [inline]
>      [<ffffffff830fc4fb>] hwsim_new_radio_nl+0x43b/0x660 drivers/net/wireless/virtual/mac80211_hwsim.c:5962
>      [<ffffffff83f4aa6e>] genl_family_rcv_msg_doit.isra.0+0xee/0x150 net/netlink/genetlink.c:968
>      [<ffffffff83f4ada7>] genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
>      [<ffffffff83f4ada7>] genl_rcv_msg+0x2d7/0x430 net/netlink/genetlink.c:1065
>      [<ffffffff83f49111>] netlink_rcv_skb+0x91/0x1e0 net/netlink/af_netlink.c:2546
>      [<ffffffff83f4a118>] genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
>      [<ffffffff83f4805b>] netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
>      [<ffffffff83f4805b>] netlink_unicast+0x39b/0x4d0 net/netlink/af_netlink.c:1365
>      [<ffffffff83f4852a>] netlink_sendmsg+0x39a/0x720 net/netlink/af_netlink.c:1913
>      [<ffffffff83db5258>] sock_sendmsg_nosec net/socket.c:724 [inline]
>      [<ffffffff83db5258>] sock_sendmsg+0x58/0xb0 net/socket.c:747
>      [<ffffffff83db5817>] ____sys_sendmsg+0x397/0x430 net/socket.c:2503
>      [<ffffffff83db9e08>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2557
>      [<ffffffff83db9fac>] __sys_sendmsg+0x8c/0x100 net/socket.c:2586
>      [<ffffffff84a127b9>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>      [<ffffffff84a127b9>] do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>      [<ffffffff84c0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> BUG: memory leak
> unreferenced object 0xffff88810e2ac800 (size 32):
>    comm "syz-executor238", pid 4984, jiffies 4294944700 (age 8.200s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<ffffffff815458a4>] kmalloc_trace+0x24/0x90 mm/slab_common.c:1057
>      [<ffffffff830fc4fb>] kmalloc include/linux/slab.h:559 [inline]
>      [<ffffffff830fc4fb>] hwsim_new_radio_nl+0x43b/0x660 drivers/net/wireless/virtual/mac80211_hwsim.c:5962
>      [<ffffffff83f4aa6e>] genl_family_rcv_msg_doit.isra.0+0xee/0x150 net/netlink/genetlink.c:968
>      [<ffffffff83f4ada7>] genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
>      [<ffffffff83f4ada7>] genl_rcv_msg+0x2d7/0x430 net/netlink/genetlink.c:1065
>      [<ffffffff83f49111>] netlink_rcv_skb+0x91/0x1e0 net/netlink/af_netlink.c:2546
>      [<ffffffff83f4a118>] genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
>      [<ffffffff83f4805b>] netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
>      [<ffffffff83f4805b>] netlink_unicast+0x39b/0x4d0 net/netlink/af_netlink.c:1365
>      [<ffffffff83f4852a>] netlink_sendmsg+0x39a/0x720 net/netlink/af_netlink.c:1913
>      [<ffffffff83db5258>] sock_sendmsg_nosec net/socket.c:724 [inline]
>      [<ffffffff83db5258>] sock_sendmsg+0x58/0xb0 net/socket.c:747
>      [<ffffffff83db5817>] ____sys_sendmsg+0x397/0x430 net/socket.c:2503
>      [<ffffffff83db9e08>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2557
>      [<ffffffff83db9fac>] __sys_sendmsg+0x8c/0x100 net/socket.c:2586
>      [<ffffffff84a127b9>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>      [<ffffffff84a127b9>] do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>      [<ffffffff84c0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the bug is already fixed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to change bug's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the bug is a duplicate of another bug, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 
> 

This issue is introduced by 92d13386ec55 ("mac80211_hwsim: add PMSR
capability support")
When parse_pmsr_capa failed in hwsim_new_radio_nl, the memory resources
applied for by pmsr_capa are not released. It should replace
param.pmsr_capa with pmsr_capa to release memory.

I will fix it today.

Zhengchao Shao

