Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13F069402A
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 09:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjBMI6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 03:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjBMI6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 03:58:12 -0500
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932A913D62
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 00:58:03 -0800 (PST)
Received: by mail-vk1-xa30.google.com with SMTP id a12so3176599vkl.8
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 00:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JvcbLvXxozu2YBfWqtS3HpY4TsoHNMWTjV1ENQbL6no=;
        b=e+SnJBd7R6UCjkchzm722hGlca5ssCKYt6muIwH/ewMqaRPlLJLLUtYVgHY3hkisMH
         XqxALcsEvd/oTocKZOurAlWGJWzipVyPNet5R342X/0zb2LNbEqXPKVhRx6YeNN/AiCq
         dfxuykZkh0m0fpwclYce3W5cp1tWxL6Cq9dA5tlMAnTMGoeStAIos1o9PbuVN5lZET4N
         J3Od4e2efXZHpsOK0WQ/uiKU7oPCkMnT//da5f7gDTsRFwKQDOE1bZCCKS/JY6jcdias
         NU8jcsHWh4WUAYGmqJ2mwMWMyLe1/qT43VlJH9K0G9cEH/6B7ARyk94piW82PqcdJ69v
         8FZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JvcbLvXxozu2YBfWqtS3HpY4TsoHNMWTjV1ENQbL6no=;
        b=mO7jhD43JXX0vVwbSuUcVckEBy6iLJKkG/ZRPlV0r2Vj6S39YzWgfxIpqBHeXesPbL
         Qk0q567qTO5xSLybAz7zuJNp8fsXfuYU5KBXkNUvvZ/ZmBWhmMAezwc5RG6o1XdBxT68
         DcqINZieTD6gkkhtuYIdl2AnZSttTqBdydB1iTsbWLIUFDP13uCBk3VPkAwujX5UZVcK
         Aro5egpy4ZoSQcIEX8d9P5ZY9XHfxxgeb06zbCZHGS0N1enwpKv0ZBrZWI5Z3elKNQtO
         ji4tKNZdQKR7Zu/QCTm1BBw2v9QE8ZYG+Iw+77NNBYRSVK6PXzPM+wLyeACKkouYNc13
         wNZA==
X-Gm-Message-State: AO0yUKViU/8K+Ku5n1FkQ1LBwy8/eofHoqNNzHBqLprwxEZDLScxJVnE
        d/QasZLACDNe1KoRpErBU+FDoZMB1Cot2vbwE7oRzN9C97i9ahD64Bw=
X-Google-Smtp-Source: AK7set+k9jHV1zZeMhMGfI+qFlT1skoTcqVhkLvBYefS8ZKb8HrJl9hf5iOD1WTp23SCqhyFAMa7yt0/9K3YxJf5aiw=
X-Received: by 2002:a1f:2c15:0:b0:400:f6da:4a05 with SMTP id
 s21-20020a1f2c15000000b00400f6da4a05mr3239718vks.22.1676278682425; Mon, 13
 Feb 2023 00:58:02 -0800 (PST)
MIME-Version: 1.0
References: <000000000000279ebd05f05cc339@google.com> <0000000000000b3f7405f48c0ad6@google.com>
In-Reply-To: <0000000000000b3f7405f48c0ad6@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 13 Feb 2023 09:57:51 +0100
Message-ID: <CANn89iJKYT6htHFgZLvVLkq=21CapD1YMwn2q+4Xh8B=OviVag@mail.gmail.com>
Subject: Re: [syzbot] INFO: trying to register non-static key in __timer_delete_sync
To:     syzbot <syzbot+1e164be619b690a43d79@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, deshantm@xen.org, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 3:59 AM syzbot
<syzbot+1e164be619b690a43d79@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    75da437a2f17 Merge branch '40GbE' of git://git.kernel.org/..
> git tree:       net-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=179ffde0c80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6e5fc864153bbc8c
> dashboard link: https://syzkaller.appspot.com/bug?extid=1e164be619b690a43d79
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d2dfb7480000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a81a07480000
>

Probably a dup

patch under review :
https://patchwork.kernel.org/project/netdevbpf/patch/20230210152605.1852743-1-edumazet@google.com/

#syz dup: BUG: unable to handle kernel paging request in atm_tc_destroy

> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/1ee7fdbb5171/disk-75da437a.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/74233a046cf5/vmlinux-75da437a.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a59b1d7b14b0/bzImage-75da437a.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1e164be619b690a43d79@syzkaller.appspotmail.com
>
> INFO: trying to register non-static key.
> The code is fine but needs lockdep annotation, or maybe
> you didn't initialize this object before use?
> turning off the locking correctness validator.
> CPU: 0 PID: 5075 Comm: syz-executor387 Not tainted 6.2.0-rc7-syzkaller-01590-g75da437a2f17 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>  assign_lock_key kernel/locking/lockdep.c:981 [inline]
>  register_lock_class+0xf1b/0x1120 kernel/locking/lockdep.c:1294
>  __lock_acquire+0x109/0x56d0 kernel/locking/lockdep.c:4934
>  lock_acquire kernel/locking/lockdep.c:5668 [inline]
>  lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
>  __timer_delete_sync+0x5d/0x1c0 kernel/time/timer.c:1555
>  del_timer_sync include/linux/timer.h:200 [inline]
>  sfq_destroy+0x82/0x140 net/sched/sch_sfq.c:725
>  qdisc_create+0xaca/0x1150 net/sched/sch_api.c:1329
>  tc_modify_qdisc+0x488/0x19c0 net/sched/sch_api.c:1679
>  rtnetlink_rcv_msg+0x43e/0xca0 net/core/rtnetlink.c:6174
>  netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
>  netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
>  netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
>  netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1942
>  sock_sendmsg_nosec net/socket.c:722 [inline]
>  sock_sendmsg+0xde/0x190 net/socket.c:745
>  ____sys_sendmsg+0x71c/0x900 net/socket.c:2501
>  ___sys_sendmsg+0x110/0x1b0 net/socket.c:2555
>  __sys_sendmsg+0xf7/0x1c0 net/socket.c:2584
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fcf276b9e69
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdba938b58 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fcf276b9e69
> RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
> RBP: 00007fcf2767e010 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000002 R11: 0000000000000246 R12: 00007fcf2767e0a0
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> ------------[ cut here ]------------
> ODEBUG: assert_init not available (active state 0) object: ffff88802ba73540 object type: timer_list hint: 0x0
> WARNING: CPU: 0 PID: 5075 at lib/debugobjects.c:509 debug_print_object+0x194/0x2c0 lib/debugobjects.c:509
> Modules linked in:
> CPU: 0 PID: 5075 Comm: syz-executor387 Not tainted 6.2.0-rc7-syzkaller-01590-g75da437a2f17 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
> RIP: 0010:debug_print_object+0x194/0x2c0 lib/debugobjects.c:509
> Code: df 48 89 fe 48 c1 ee 03 80 3c 16 00 0f 85 c7 00 00 00 48 8b 14 dd a0 d1 a6 8a 50 4c 89 ee 48 c7 c7 60 c5 a6 8a e8 56 68 b4 05 <0f> 0b 58 83 05 ee 4c 64 0a 01 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e
> RSP: 0018:ffffc90003b5f210 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
> RDX: ffff888020570000 RSI: ffffffff8166195c RDI: fffff5200076be34
> RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000080000000 R11: 203a47554245444f R12: ffffffff8a4ea980
> R13: ffffffff8aa6cc00 R14: ffffc90003b5f2c8 R15: ffffffff816f9ff0
> FS:  00005555573c4300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000004585c0 CR3: 00000000299a3000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  debug_object_assert_init lib/debugobjects.c:899 [inline]
>  debug_object_assert_init+0x1f8/0x2e0 lib/debugobjects.c:870
>  debug_timer_assert_init kernel/time/timer.c:792 [inline]
>  debug_assert_init kernel/time/timer.c:837 [inline]
>  __try_to_del_timer_sync+0x72/0x160 kernel/time/timer.c:1412
>  __timer_delete_sync+0x144/0x1c0 kernel/time/timer.c:1573
>  del_timer_sync include/linux/timer.h:200 [inline]
>  sfq_destroy+0x82/0x140 net/sched/sch_sfq.c:725
>  qdisc_create+0xaca/0x1150 net/sched/sch_api.c:1329
>  tc_modify_qdisc+0x488/0x19c0 net/sched/sch_api.c:1679
>  rtnetlink_rcv_msg+0x43e/0xca0 net/core/rtnetlink.c:6174
>  netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
>  netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
>  netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
>  netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1942
>  sock_sendmsg_nosec net/socket.c:722 [inline]
>  sock_sendmsg+0xde/0x190 net/socket.c:745
>  ____sys_sendmsg+0x71c/0x900 net/socket.c:2501
>  ___sys_sendmsg+0x110/0x1b0 net/socket.c:2555
>  __sys_sendmsg+0xf7/0x1c0 net/socket.c:2584
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fcf276b9e69
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdba938b58 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fcf276b9e69
> RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
> RBP: 00007fcf2767e010 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000002 R11: 0000000000000246 R12: 00007fcf2767e0a0
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
>
