Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1635A5608D0
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 20:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiF2SOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 14:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiF2SOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 14:14:03 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A4834678;
        Wed, 29 Jun 2022 11:14:01 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id w24so16401242pjg.5;
        Wed, 29 Jun 2022 11:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=C258cRyl5UWzTKvylMmLG3MCSyuB6tgFP9sHV+YoG8Y=;
        b=CEQ9lL2j3pp6O8ZO2gX4t+08rLRbrgmTTlcead1YygHVKQpGYT+OeN7ouHClLfJyX3
         chkn1hfSrlS2IUafhAE1MBHkOBJfD0rrUkDnqX1iykBa9FnV67OfvcgrrQ/Ts3owS3AR
         YNaHrF/8WQ7kOj9pEqcsImkWCy1kken3JlFx5A+WLaUP9gXKcEIJzPODbY8tpLH/3sns
         55PPq8rta2pDArJgMaK9d2QjOGqD27OGhTX7pk6oCPKmXgj9MBOye7cNfbiainq+AgGJ
         yPnc+uIVDA3vMAPbuuBI8NnsTsSBMnp/QN/nZwAEO1VZ9bQ6XGGl6hrdO0fA20Oeb5t0
         YMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=C258cRyl5UWzTKvylMmLG3MCSyuB6tgFP9sHV+YoG8Y=;
        b=auLRaqU/fFyafvrnTwr5YDDAhGdbLUG7/6/EabibB3rz++LfFGIwo6v0Tcv1IhDLn8
         WZJ6bPhYpr1iAE3rt70TjQLaFjauq/UHFSdzXkpaG8xLGDoUfyH81QCt+QLmAhQbh956
         a4rf2qLyXGI52eNRwyEfHNyKi6QF/sv24nPFw0MqbfcnJXvsVj+CXidk1HprpIpnkz0H
         X2pmswaqG7xe3ujWIqlhxAKBABtfZz4oPrXirIvH7Y5ivpj12YdMzqAMrZ8YclZaQuNy
         0p31/1uRHVwcHqivpj+sYzCZjH1Q8eBQRyZ7X0X8O3rG62D50DsoGQFOP2FjuLTGdW/Z
         wOSQ==
X-Gm-Message-State: AJIora8KZnrljLeVc/cA7uJBuDgPWp54y4XRMdYGd11fC8JeBeNyp4FU
        hSE0hDIwBnRiI5zYw9uNE80=
X-Google-Smtp-Source: AGRyM1tyxe5F3OWS3/WKjxfYYZKfXVBgflCFWhgFiKjlQdRSVkeHMNjhfxQcpCVrYrrkd+Q16gQNTw==
X-Received: by 2002:a17:902:ef4f:b0:16b:8744:6c5f with SMTP id e15-20020a170902ef4f00b0016b87446c5fmr8411836plx.60.1656526441282;
        Wed, 29 Jun 2022 11:14:01 -0700 (PDT)
Received: from localhost ([98.97.119.237])
        by smtp.gmail.com with ESMTPSA id v23-20020a62a517000000b00525b61fc3f8sm6780181pfm.40.2022.06.29.11.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 11:14:00 -0700 (PDT)
Date:   Wed, 29 Jun 2022 11:13:59 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Wei Wang <weiwan@google.com>
Message-ID: <62bc966740c4c_5ddc20893@john.notmuch>
In-Reply-To: <CANn89iLvG0QBVkdhbC-x59ac=B=j+ZxXitBGanBo+8ThMJGG1g@mail.gmail.com>
References: <000000000000b06e5505e299a9b6@google.com>
 <CANn89iLuGKyVcNAAjvwWk8HoJrNgZ5HM4itXEsnqzU=+xZLKOQ@mail.gmail.com>
 <CANn89iLvG0QBVkdhbC-x59ac=B=j+ZxXitBGanBo+8ThMJGG1g@mail.gmail.com>
Subject: Re: [syzbot] WARNING in sk_stream_kill_queues (8)
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet wrote:
> On Wed, Jun 29, 2022 at 7:45 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Wed, Jun 29, 2022 at 7:41 PM syzbot
> > <syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    aab35c3d5112 Add linux-next specific files for 20220627
> > > git tree:       linux-next
> > > console+strace: https://syzkaller.appspot.com/x/log.txt?x=126fef90080000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=6a874f114a1e4a6b
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=a0e6f8738b58f7654417
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ae0c98080000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=145124f4080000
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com
> > >
> > > nf_conntrack: default automatic helper assignment has been turned off for security reasons and CT-based firewall rule not found. Use the iptables CT target to attach helpers instead.
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 1 PID: 3601 at net/core/stream.c:205 sk_stream_kill_queues+0x2ee/0x3d0 net/core/stream.c:205
> > > Modules linked in:
> > > CPU: 1 PID: 3601 Comm: syz-executor340 Not tainted 5.19.0-rc4-next-20220627-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > RIP: 0010:sk_stream_kill_queues+0x2ee/0x3d0 net/core/stream.c:205
> > > Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e ec 00 00 00 8b ab 28 02 00 00 e9 60 ff ff ff e8 3b 9a 29 fa 0f 0b eb 97 e8 32 9a 29 fa <0f> 0b eb a0 e8 29 9a 29 fa 0f 0b e9 6a fe ff ff e8 0d a1 75 fa e9
> > > RSP: 0018:ffffc90002e6fbf0 EFLAGS: 00010293
> > > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > > RDX: ffff88801e90ba80 RSI: ffffffff87511cce RDI: 0000000000000005
> > > RBP: 0000000000000b00 R08: 0000000000000005 R09: 0000000000000000
> > > R10: 0000000000000b00 R11: 0000000000000004 R12: ffff88801e0c8e28
> > > R13: ffffffff913121c0 R14: ffff88801e0c8c28 R15: ffff88801e0c8db8
> > > FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 000000000045b630 CR3: 000000000ba8e000 CR4: 00000000003506e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >  <TASK>
> > >  inet_csk_destroy_sock+0x1a5/0x440 net/ipv4/inet_connection_sock.c:1013
> > >  __tcp_close+0xb92/0xf50 net/ipv4/tcp.c:2963
> > >  tcp_close+0x29/0xc0 net/ipv4/tcp.c:2975
> > >  inet_release+0x12e/0x270 net/ipv4/af_inet.c:428
> > >  __sock_release+0xcd/0x280 net/socket.c:650
> > >  sock_close+0x18/0x20 net/socket.c:1365
> > >  __fput+0x277/0x9d0 fs/file_table.c:317
> > >  task_work_run+0xdd/0x1a0 kernel/task_work.c:177
> > >  exit_task_work include/linux/task_work.h:38 [inline]
> > >  do_exit+0xaf1/0x29f0 kernel/exit.c:795
> > >  do_group_exit+0xd2/0x2f0 kernel/exit.c:925
> > >  __do_sys_exit_group kernel/exit.c:936 [inline]
> > >  __se_sys_exit_group kernel/exit.c:934 [inline]
> > >  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
> > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> > >  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > > RIP: 0033:0x7f080e760989
> > > Code: Unable to access opcode bytes at RIP 0x7f080e76095f.
> > > RSP: 002b:00007ffcee785818 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> > > RAX: ffffffffffffffda RBX: 00007f080e7d4270 RCX: 00007f080e760989
> > > RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> > > RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000010
> > > R10: 0000000000000010 R11: 0000000000000246 R12: 00007f080e7d4270
> > > R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
> > >  </TASK>
> > >
> > >
> > > ---
> > > This report is generated by a bot. It may contain errors.
> > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > >
> > > syzbot will keep track of this issue. See:
> > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > > syzbot can test patches for this issue, for details see:
> > > https://goo.gl/tpsmEJ#testing-patches
> >
> > Stanislav has bisected the issue to:
> >
> > commit 965b57b469a589d64d81b1688b38dcb537011bb0
> > Author: Cong Wang <cong.wang@bytedance.com>
> > Date:   Wed Jun 15 09:20:12 2022 -0700
> >
> >     net: Introduce a new proto_ops ->read_skb()
> >
> >     Currently both splice() and sockmap use ->read_sock() to
> >     read skb from receive queue, but for sockmap we only read
> >     one entire skb at a time, so ->read_sock() is too conservative
> >     to use. Introduce a new proto_ops ->read_skb() which supports
> >     this sematic, with this we can finally pass the ownership of
> >     skb to recv actors.
> >
> >     For non-TCP protocols, all ->read_sock() can be simply
> >     converted to ->read_skb().
> >
> >     Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> >     Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> >     Reviewed-by: John Fastabend <john.fastabend@gmail.com>
> >     Link: https://lore.kernel.org/bpf/20220615162014.89193-3-xiyou.wangcong@gmail.com
> 
> Repro is doing something like:
> 
> 
> mmap(0x1ffff000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS,
> -1, 0) = 0x1ffff000
> mmap(0x20000000, 16777216, PROT_READ|PROT_WRITE|PROT_EXEC,
> MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x20000000
> mmap(0x21000000, 4096, PROT_NONE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS,
> -1, 0) = 0x21000000
> socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 3
> bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_SK_SKB, insn_cnt=4,
> insns=0x20000040, license="GPL", log_level=4, log_size=64912,
> log_buf="", kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0,
> prog_name="", prog_ifindex=0,
> expected_attach_type=BPF_CGROUP_INET_INGRESS}, 72) = 4
> bpf(BPF_MAP_CREATE, {map_type=BPF_MAP_TYPE_SOCKHASH, key_size=4,
> value_size=4, max_entries=18, map_flags=0, inner_map_fd=-1,
> map_name="", map_ifindex=0, btf_fd=-1, btf_key_type_id=0,
> btf_value_type_id=0, btf_vmlinux_value_type_id=0, map_extra=0}, 72) =
> 5
> bpf(BPF_PROG_ATTACH, {target_fd=5, attach_bpf_fd=4,
> attach_type=BPF_SK_SKB_STREAM_VERDICT, attach_flags=0}, 16) = 0
> bind(3, {sa_family=AF_INET, sin_port=htons(20000),
> sin_addr=inet_addr("224.0.0.2")}, 16) = 0
> sendto(3, NULL, 0, MSG_OOB|MSG_SENDPAGE_NOTLAST|MSG_FASTOPEN,
> {sa_family=AF_INET, sin_port=htons(20000),
> sin_addr=inet_addr("0.0.0.0")}, 16) = 0
> bpf(BPF_MAP_UPDATE_ELEM, {map_fd=5, key=0x200002c0, value=0x20000340,
> flags=BPF_ANY}, 32) = 0
> shutdown(3, SHUT_WR)                    = 0
> exit_group(0)                           = ?

Thanks Eric, Stanislav for the bisect. I'll take a look this afternoon. 
