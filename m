Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B8915CB6F
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 20:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgBMTzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 14:55:10 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:33852 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbgBMTzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 14:55:09 -0500
X-Greylist: delayed 3145 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Feb 2020 14:55:09 EST
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j2Jl2-0004CO-R6; Thu, 13 Feb 2020 12:02:41 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j2Jl1-0002Zb-Nk; Thu, 13 Feb 2020 12:02:40 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     syzbot <syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com>
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@gmail.com,
        hawk@kernel.org, jiri@mellanox.com, johannes.berg@intel.com,
        john.fastabend@gmail.com, kafai@fb.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <000000000000c54420059e4f08ff@google.com>
Date:   Thu, 13 Feb 2020 13:00:45 -0600
In-Reply-To: <000000000000c54420059e4f08ff@google.com> (syzbot's message of
        "Tue, 11 Feb 2020 08:06:10 -0800")
Message-ID: <878sl6fh2a.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j2Jl1-0002Zb-Nk;;;mid=<878sl6fh2a.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18DhSl2YmraRdbkJikHNBP6o0gRLE/AP5E=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: ****
X-Spam-Status: No, score=4.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,LotsOfNums_01,SORTED_RECIPS,T_TM2_M_HEADER_IN_MSG,
        XMGappySubj_01 autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4959]
        *  0.5 XMGappySubj_01 Very gappy subject
        *  2.5 SORTED_RECIPS Recipient list is sorted by address
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;syzbot
        <syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 696 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 2.9 (0.4%), b_tie_ro: 2.0 (0.3%), parse: 1.02
        (0.1%), extract_message_metadata: 21 (3.0%), get_uri_detail_list: 4.1
        (0.6%), tests_pri_-1000: 17 (2.4%), tests_pri_-950: 1.29 (0.2%),
        tests_pri_-900: 1.08 (0.2%), tests_pri_-90: 47 (6.8%), check_bayes: 45
        (6.5%), b_tokenize: 15 (2.1%), b_tok_get_all: 17 (2.5%), b_comp_prob:
        4.2 (0.6%), b_tok_touch_all: 5 (0.8%), b_finish: 0.68 (0.1%),
        tests_pri_0: 588 (84.5%), check_dkim_signature: 1.01 (0.1%),
        check_dkim_adsp: 6 (0.8%), poll_dns_idle: 0.44 (0.1%), tests_pri_10:
        2.5 (0.4%), tests_pri_500: 11 (1.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: WARNING in dev_change_net_namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com> writes:

> Hello,

Has someone messed up the network device kobject support.
I don't have the exact same code as listed here so I may
be misreading things.  But the only WARN_ON I see in
dev_change_net_namespaces is from kobject_rename.

It is not supposed to be possible for that to fail.

Historically it only failed when network devices were put into sysfs
in a way that required network devices to have names separate from
sysfs files.  We fixed that ages ago, so I don't have a clue why
kobject_rename would be failing now.

szybot any idea what network device was changing network namespaces?

Eric


> syzbot found the following crash on:
>
> HEAD commit:    0a679e13 Merge branch 'for-5.6-fixes' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15142701e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6780df5a5f208964
> dashboard link: https://syzkaller.appspot.com/bug?extid=830c6dbfc71edc4f0b8f
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
>
> RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000004
> RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000007
> R13: 00000000000009cb R14: 00000000004cb3dd R15: 0000000000000016
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 24839 at net/core/dev.c:10108 dev_change_net_namespace+0x155f/0x16b0 net/core/dev.c:10108
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 24839 Comm: syz-executor.4 Not tainted 5.6.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1fb/0x318 lib/dump_stack.c:118
>  panic+0x264/0x7a9 kernel/panic.c:221
>  __warn+0x209/0x210 kernel/panic.c:582
>  report_bug+0x1b6/0x2f0 lib/bug.c:195
>  fixup_bug arch/x86/kernel/traps.c:174 [inline]
>  do_error_trap+0xcf/0x1c0 arch/x86/kernel/traps.c:267
>  do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:286
>  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> RIP: 0010:dev_change_net_namespace+0x155f/0x16b0 net/core/dev.c:10108
> Code: b7 f9 02 01 48 c7 c7 5d 66 e6 88 48 c7 c6 b4 42 04 89 ba 25 27 00 00 31 c0 e8 6d a6 dc fa 0f 0b e9 0d eb ff ff e8 a1 e6 0a fb <0f> 0b e9 2f fe ff ff e8 95 e6 0a fb c6 05 05 b7 f9 02 01 48 c7 c7
> RSP: 0018:ffffc90001ae7140 EFLAGS: 00010246
> RAX: ffffffff866c18df RBX: 00000000fffffff4 RCX: 0000000000040000
> RDX: ffffc90012028000 RSI: 000000000003ffff RDI: 0000000000040000
> RBP: ffffc90001ae7240 R08: ffffffff866c1700 R09: fffffbfff1406318
> R10: fffffbfff1406318 R11: 0000000000000000 R12: ffff8880918d2b60
> R13: ffff8880918d20b8 R14: ffffc90001ae71e8 R15: ffffc90001ae71e0
>  do_setlink+0x196/0x3880 net/core/rtnetlink.c:2501
>  __rtnl_newlink net/core/rtnetlink.c:3252 [inline]
>  rtnl_newlink+0x1509/0x1c00 net/core/rtnetlink.c:3377
>  rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5438
>  netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2477
>  rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:5456
>  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>  netlink_unicast+0x766/0x920 net/netlink/af_netlink.c:1328
>  netlink_sendmsg+0xa2b/0xd40 net/netlink/af_netlink.c:1917
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg net/socket.c:672 [inline]
>  ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2343
>  ___sys_sendmsg net/socket.c:2397 [inline]
>  __sys_sendmsg+0x1ed/0x290 net/socket.c:2430
>  __do_sys_sendmsg net/socket.c:2439 [inline]
>  __se_sys_sendmsg net/socket.c:2437 [inline]
>  __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2437
>  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x45b3b9
> Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f483611ac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f483611b6d4 RCX: 000000000045b3b9
> RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000004
> RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000007
> R13: 00000000000009cb R14: 00000000004cb3dd R15: 0000000000000016
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
