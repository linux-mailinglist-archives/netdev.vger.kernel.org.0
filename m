Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0022E3FC4F2
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 11:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240645AbhHaJUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 05:20:31 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:56104 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239716AbhHaJUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 05:20:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0Umjsu07_1630401571;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Umjsu07_1630401571)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 31 Aug 2021 17:19:32 +0800
Subject: Re: [syzbot] general protection fault in sock_from_file
To:     Jens Axboe <axboe@kernel.dk>,
        syzbot <syzbot+f9704d1878e290eddf73@syzkaller.appspotmail.com>,
        andrii@kernel.org, asml.silence@gmail.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        dvyukov@google.com, io-uring@vger.kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <00000000000059117905cacce99e@google.com>
 <7949b7a0-fec1-34a7-aaf5-cbe07c6127ed@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <d881d3fa-4df5-1862-bc2b-9420649ba3c8@linux.alibaba.com>
Date:   Tue, 31 Aug 2021 17:19:31 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <7949b7a0-fec1-34a7-aaf5-cbe07c6127ed@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2021/8/31 上午10:14, Jens Axboe 写道:
> On 8/30/21 2:45 PM, syzbot wrote:
>> syzbot has found a reproducer for the following issue on:
>>
>> HEAD commit:    93717cde744f Add linux-next specific files for 20210830
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=15200fad300000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=c643ef5289990dd1
>> dashboard link: https://syzkaller.appspot.com/bug?extid=f9704d1878e290eddf73
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111f5f9d300000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1651a415300000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+f9704d1878e290eddf73@syzkaller.appspotmail.com
>>
>> general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
>> KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
>> CPU: 0 PID: 6548 Comm: syz-executor433 Not tainted 5.14.0-next-20210830-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:sock_from_file+0x20/0x90 net/socket.c:505
>> Code: f5 ff ff ff c3 0f 1f 44 00 00 41 54 53 48 89 fb e8 85 e9 62 fa 48 8d 7b 28 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 4f 45 31 e4 48 81 7b 28 80 f1 8a 8a 74 0c e8 58 e9
>> RSP: 0018:ffffc90002caf8e8 EFLAGS: 00010206
>> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
>> RDX: 0000000000000005 RSI: ffffffff8713203b RDI: 0000000000000028
>> RBP: ffff888019fc0780 R08: ffffffff899aee40 R09: ffffffff81e21978
>> R10: 0000000000000027 R11: 0000000000000009 R12: dffffc0000000000
>> R13: 1ffff110033f80f9 R14: 0000000000000003 R15: ffff888019fc0780
>> FS:  00000000013b5300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00000000004ae0f0 CR3: 000000001d355000 CR4: 00000000001506f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>   io_sendmsg+0x98/0x640 fs/io_uring.c:4681
>>   io_issue_sqe+0x14de/0x6ba0 fs/io_uring.c:6578
>>   __io_queue_sqe+0x90/0xb50 fs/io_uring.c:6864
>>   io_req_task_submit+0xbf/0x1b0 fs/io_uring.c:2218
>>   tctx_task_work+0x166/0x610 fs/io_uring.c:2143
>>   task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>>   tracehook_notify_signal include/linux/tracehook.h:212 [inline]
>>   handle_signal_work kernel/entry/common.c:146 [inline]
>>   exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>>   exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:209
>>   __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>>   syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
>>   do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x43fd49
> 
> Hao, this is due to:
> 
> commit a8295b982c46d4a7c259a4cdd58a2681929068a9
> Author: Hao Xu <haoxu@linux.alibaba.com>
> Date:   Fri Aug 27 17:46:09 2021 +0800
> 
>      io_uring: fix failed linkchain code logic
> 
> which causes some weirdly super long chains from that single sqe.
> Can you take a look, please?
Sure, I'm working on this.
> 

