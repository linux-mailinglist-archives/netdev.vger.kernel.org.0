Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87F030A7C0
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 13:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbhBAMim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 07:38:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8680 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229633AbhBAMik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 07:38:40 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 111CWPFv192703;
        Mon, 1 Feb 2021 07:37:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=KJZk3N4cqWLCM+6mNIeSVbmwjEXs9eS/abWq9A7xuoU=;
 b=VAaVG2XKteNtKYWH3xM8a8lQy2qHZSioUUI1tiRMrBAyEQ6aLpu2iR4kYtZI9XdQHPFz
 b3RtkyQ51LPIRCXx/SmensRKtgeI1I8O/CqRWwo27hgqz8lT6emXBFMwtrhYYuxkHaFo
 5hfczBKp9pqKUt1Rlodmikohcn8SAUSfCmbatx1tmx9ens1ZdzQwBQbujVWL6w3FQy1s
 AKwszebi5MbO69cmNYVrcsLh4ih5GfLL0jBpK3BFUbgp6zWQVRHT5lg2UbXLt/oN20EY
 BAqqREASxve/fePegGYKSAYpM/0bYR8SklcGv6g3ocm34Gxb1FJ+IYIeduIsZ8jd5fgj kg== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36egn2thtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 07:37:39 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 111CXGpr018408;
        Mon, 1 Feb 2021 12:37:36 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 36cy388xu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 12:37:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 111CbY1G38863138
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Feb 2021 12:37:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 691F1A4060;
        Mon,  1 Feb 2021 12:37:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24FDDA4065;
        Mon,  1 Feb 2021 12:37:32 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.52.63])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  1 Feb 2021 12:37:31 +0000 (GMT)
Date:   Mon, 1 Feb 2021 14:37:28 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     syzbot <syzbot+2ae0ca9d7737ad1a62b7@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, davem@davemloft.net, hagen@jauu.net,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Subject: Re: possible deadlock in cfg80211_netdev_notifier_call
Message-ID: <20210201123728.GF299309@linux.ibm.com>
References: <000000000000c3a1b705ba42d1ca@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000c3a1b705ba42d1ca@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_05:2021-01-29,2021-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 phishscore=0 clxscore=1011 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 01:17:13AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b01f250d Add linux-next specific files for 20210129
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14daa408d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=725bc96dc234fda7
> dashboard link: https://syzkaller.appspot.com/bug?extid=2ae0ca9d7737ad1a62b7
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1757f2a0d00000
> 
> The issue was bisected to:
> 
> commit cc9327f3b085ba5be5639a5ec3ce5b08a0f14a7c
> Author: Mike Rapoport <rppt@linux.ibm.com>
> Date:   Thu Jan 28 07:42:40 2021 +0000
> 
>     mm: introduce memfd_secret system call to create "secret" memory areas
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1505d28cd00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1705d28cd00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1305d28cd00000

Sounds really weird to me. At this point the memfd_secret syscall is not
even wired to arch syscall handlers. I cannot see how it can be a reason of
deadlock in wireless...
 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2ae0ca9d7737ad1a62b7@syzkaller.appspotmail.com
> Fixes: cc9327f3b085 ("mm: introduce memfd_secret system call to create "secret" memory areas")
> 
> ============================================
> WARNING: possible recursive locking detected
> 5.11.0-rc5-next-20210129-syzkaller #0 Not tainted
> --------------------------------------------
> syz-executor.1/27924 is trying to acquire lock:
> ffff88801c7305e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5267 [inline]
> ffff88801c7305e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: cfg80211_netdev_notifier_call+0x68c/0x1180 net/wireless/core.c:1407
> 
> but task is already holding lock:
> ffff88801c7305e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5267 [inline]
> ffff88801c7305e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: nl80211_pre_doit+0x347/0x5a0 net/wireless/nl80211.c:14837
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&rdev->wiphy.mtx);
>   lock(&rdev->wiphy.mtx);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 3 locks held by syz-executor.1/27924:
>  #0: ffffffff8cd04eb0 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:810
>  #1: ffffffff8cc75248 (rtnl_mutex){+.+.}-{3:3}, at: nl80211_pre_doit+0x22/0x5a0 net/wireless/nl80211.c:14793
>  #2: ffff88801c7305e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5267 [inline]
>  #2: ffff88801c7305e8 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: nl80211_pre_doit+0x347/0x5a0 net/wireless/nl80211.c:14837
> 
> stack backtrace:
> CPU: 1 PID: 27924 Comm: syz-executor.1 Not tainted 5.11.0-rc5-next-20210129-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>  print_deadlock_bug kernel/locking/lockdep.c:2829 [inline]
>  check_deadlock kernel/locking/lockdep.c:2872 [inline]
>  validate_chain kernel/locking/lockdep.c:3661 [inline]
>  __lock_acquire.cold+0x14c/0x3b4 kernel/locking/lockdep.c:4899
>  lock_acquire kernel/locking/lockdep.c:5509 [inline]
>  lock_acquire+0x1a8/0x720 kernel/locking/lockdep.c:5474
>  __mutex_lock_common kernel/locking/mutex.c:956 [inline]
>  __mutex_lock+0x134/0x1110 kernel/locking/mutex.c:1103
>  wiphy_lock include/net/cfg80211.h:5267 [inline]
>  cfg80211_netdev_notifier_call+0x68c/0x1180 net/wireless/core.c:1407
>  notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2040
>  call_netdevice_notifiers_extack net/core/dev.c:2052 [inline]
>  call_netdevice_notifiers net/core/dev.c:2066 [inline]
>  unregister_netdevice_many+0x943/0x1750 net/core/dev.c:10704
>  unregister_netdevice_queue+0x2dd/0x3c0 net/core/dev.c:10638
>  register_netdevice+0x109f/0x14a0 net/core/dev.c:10013
>  cfg80211_register_netdevice+0x11d/0x2a0 net/wireless/core.c:1349
>  ieee80211_if_add+0xfb8/0x18f0 net/mac80211/iface.c:1990
>  ieee80211_add_iface+0x99/0x160 net/mac80211/cfg.c:125
>  rdev_add_virtual_intf net/wireless/rdev-ops.h:45 [inline]
>  nl80211_new_interface+0x541/0x1100 net/wireless/nl80211.c:3977
>  genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
>  genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
>  genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:654 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:674
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2437
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45e219
> Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f5dce348c68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e219
> RDX: 0000000000000000 RSI: 0000000020000400 RDI: 0000000000000004
> RBP: 000000000119c110 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119c0dc
> R13: 00007ffdf00f97ff R14: 00007f5dce3499c0 R15: 000000000119c0dc
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

-- 
Sincerely yours,
Mike.
