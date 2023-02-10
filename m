Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FD5692232
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 16:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbjBJPaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 10:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbjBJPaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 10:30:07 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BF32200C
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:30:05 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id j25so5436547wrc.4
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 07:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ARNnrLec9gQ/6nw5VQ+vr45Rs0TpDIMj6FlzqfpjTb4=;
        b=lon3i3BGFCmZldZ29QWjJmkqfnYGbkJSQoYENbOj/sfLXenfa+CMoo+K/+E6pBH5yi
         YhofsPmgfdU0t3NKOnfA8WM8yb+nnNSEm3B0rMhKbhy/EcIpcQcEuZ3EB8ORfoY7I0nU
         8esIp6SudqDTrEouV2nRCdBMENzEZDuT8E4m3kxBIOahIt3AR5V+L9wbKd6JEvA/4BzC
         7pWbnpIiaX6EldavHxezQTw2d+v/69j/yqGdcwvf++FaUE/OtxpnZeszNOgHTtN+t+e2
         Oiov7zpHwghgqexT/n550pTAzxRmsiplMjz5n4a/ITNiTvKY7frUQ+fq4VscCS33TJ6x
         UV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ARNnrLec9gQ/6nw5VQ+vr45Rs0TpDIMj6FlzqfpjTb4=;
        b=0pXmpILGBV4ANhykpjEzoAeTVPpq7kFFsfZEQMu0dOwJOc6aHAgo4nYhU24VoAM0CI
         PmKMEVeNFX/3M/6iMp/FJwKyIlAjAND4TR2pSOi/pVUcHhsToQveZjRNF5Qelskwq3As
         vxDLVErjZEdvsKNcBvWh8LYkLoIhabY3nEfL64QS3R1g2qtgyGYSxH+Csll2udH6oFwX
         CtO5cWK3rvXAS/K6nYdpiZh2umVERZYEqIuuGxqdv+V796clfqq84+FwaI1RONXCpUo8
         5BqguP37jbV4GC4wePjqWiVq8CR+iydg1al2OE0F08HhE43pJTv4CQB8euszM2pJSzKQ
         4TbA==
X-Gm-Message-State: AO0yUKWkQj9BLhWVprBFlCq1tCgvP0KdSUcrKREqdIgIuNFMsFmzuEfS
        Lu2soV0+tk6Xz28OLk1g2rSrDuv2kad7vfxN4zgeZg==
X-Google-Smtp-Source: AK7set8sUvE0udcQE5mLbvERtWOGOeK4/mw7rCePKHejo2TnJl82JfTdz3VeZKy3Ul8k0oKn9sgijLdl2USXXb5aE+s=
X-Received: by 2002:a5d:6583:0:b0:2c4:936:f423 with SMTP id
 q3-20020a5d6583000000b002c40936f423mr480775wru.113.1676043003982; Fri, 10 Feb
 2023 07:30:03 -0800 (PST)
MIME-Version: 1.0
References: <00000000000033d42a05f45a155e@google.com>
In-Reply-To: <00000000000033d42a05f45a155e@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Feb 2023 16:29:52 +0100
Message-ID: <CANn89iL5SxbxDiff9DpxgAJxk6iQ1AfL6wR8FkHN=g=HDtKQgw@mail.gmail.com>
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in atm_tc_destroy
To:     syzbot <syzbot+d44d88f1d11e6ca8576b@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
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

On Fri, Feb 10, 2023 at 4:23 PM syzbot
<syzbot+d44d88f1d11e6ca8576b@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    0b34d68049b0 net: enable usercopy for skb_small_head_cache
> git tree:       net-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=14cb251f480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bd3e305b3a7ab2b0
> dashboard link: https://syzkaller.appspot.com/bug?extid=d44d88f1d11e6ca8576b
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1259c7cb480000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1789967d480000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/e6e9cd443f49/disk-0b34d680.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/1d27805ca50d/vmlinux-0b34d680.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/0a3e607b6ca7/bzImage-0b34d680.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d44d88f1d11e6ca8576b@syzkaller.appspotmail.com
>
> BUG: unable to handle page fault for address: ffffffffffffffa0
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD c48f067 P4D c48f067 PUD c491067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 5075 Comm: syz-executor134 Not tainted 6.2.0-rc6-syzkaller-01486-g0b34d68049b0 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
> RIP: 0010:atm_tc_destroy+0x7d/0x250 net/sched/sch_atm.c:588
> Code: 0f 84 52 01 00 00 48 bd 00 00 00 00 00 fc ff df e8 88 0e 8b f9 4c 8d 73 28 4c 89 f0 48 c1 e8 03 80 3c 28 00 0f 85 70 01 00 00 <48> 8b 7b 28 e8 ea f4 f2 ff 4c 89 f0 48 c1 e8 03 80 3c 28 00 0f 85
> RSP: 0018:ffffc90003c0f3f0 EFLAGS: 00010246
> RAX: 1ffffffffffffff4 RBX: ffffffffffffff78 RCX: 0000000000000000
> RDX: ffff88802695d7c0 RSI: ffffffff87f5ed08 RDI: ffff888022026000
> RBP: dffffc0000000000 R08: 0000000000000007 R09: fffffffffffff000
> R10: ffffffffffffffea R11: 0000000000000000 R12: ffff888022026370
> R13: ffff888022026000 R14: ffffffffffffffa0 R15: ffff888021d6c000
> FS:  0000555555aee300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffa0 CR3: 000000001c561000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  qdisc_create+0xaca/0x1150 net/sched/sch_api.c:1329
>  tc_modify_qdisc+0x948/0x19c0 net/sched/sch_api.c:1662
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
> RIP: 0033:0x7f6162cddba9
> Code: 28 c3 e8 1a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe242b7018 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f6162d4bed0 RCX: 00007f6162cddba9
> RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
> RBP: 00007ffe242b7028 R08: 00007f6162d4be40 R09: 00007f6162d4be40
> R10: 00007f6162d4be40 R11: 0000000000000246 R12: 00007ffe242b7030
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> Modules linked in:
> CR2: ffffffffffffffa0
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:atm_tc_destroy+0x7d/0x250 net/sched/sch_atm.c:588
> Code: 0f 84 52 01 00 00 48 bd 00 00 00 00 00 fc ff df e8 88 0e 8b f9 4c 8d 73 28 4c 89 f0 48 c1 e8 03 80 3c 28 00 0f 85 70 01 00 00 <48> 8b 7b 28 e8 ea f4 f2 ff 4c 89 f0 48 c1 e8 03 80 3c 28 00 0f 85
> RSP: 0018:ffffc90003c0f3f0 EFLAGS: 00010246
> RAX: 1ffffffffffffff4 RBX: ffffffffffffff78 RCX: 0000000000000000
> RDX: ffff88802695d7c0 RSI: ffffffff87f5ed08 RDI: ffff888022026000
> RBP: dffffc0000000000 R08: 0000000000000007 R09: fffffffffffff000
> R10: ffffffffffffffea R11: 0000000000000000 R12: ffff888022026370
> R13: ffff888022026000 R14: ffffffffffffffa0 R15: ffff888021d6c000
> FS:  0000555555aee300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffa0 CR3: 000000001c561000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0:   0f 84 52 01 00 00       je     0x158
>    6:   48 bd 00 00 00 00 00    movabs $0xdffffc0000000000,%rbp
>    d:   fc ff df
>   10:   e8 88 0e 8b f9          callq  0xf98b0e9d
>   15:   4c 8d 73 28             lea    0x28(%rbx),%r14
>   19:   4c 89 f0                mov    %r14,%rax
>   1c:   48 c1 e8 03             shr    $0x3,%rax
>   20:   80 3c 28 00             cmpb   $0x0,(%rax,%rbp,1)
>   24:   0f 85 70 01 00 00       jne    0x19a
> * 2a:   48 8b 7b 28             mov    0x28(%rbx),%rdi <-- trapping instruction
>   2e:   e8 ea f4 f2 ff          callq  0xfff2f51d
>   33:   4c 89 f0                mov    %r14,%rax
>   36:   48 c1 e8 03             shr    $0x3,%rax
>   3a:   80 3c 28 00             cmpb   $0x0,(%rax,%rbp,1)
>   3e:   0f                      .byte 0xf
>   3f:   85                      .byte 0x85
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

Fix would be :

https://patchwork.kernel.org/project/netdevbpf/patch/20230210152605.1852743-1-edumazet@google.com/
