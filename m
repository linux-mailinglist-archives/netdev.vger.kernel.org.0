Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1273FF462
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242479AbhIBTzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244551AbhIBTzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 15:55:38 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026D8C061575;
        Thu,  2 Sep 2021 12:54:40 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id f22so3485325qkm.5;
        Thu, 02 Sep 2021 12:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zIApn+pVyxRyKvTHD5IYjvS4FfZyz2qp0mFhAC5RqDE=;
        b=RYAAw82B2YZo6aPonx+n8OdCrki0Dpl7PdxB4iZ9xXa/dROrWmA53lFC63z4HBDZIp
         U9wfa4y+DZbW/0qyAGbjxFndBLzk/qUE+lMtsBZNu8K3tuvfneRuHaH6iwpuv3CIYtLD
         BSn6UPgi+zg/vETCOJNkI95bjTCBMhYYQ1gfM8BNK8tfxHXX45WGapo4gpKZ8tYNb0Se
         ctDjyIwEzhxxj1mYiuboySLhhzHd5+6JgH8iK7k120DUPrEZzT22O74pS3du2L1pzOCI
         08CFREuZ0Ns1tj4rEa6ZUpeBCuZZxw7PrjoVEJCEkCQtZcl0IiBTS9gVds+5aMWK3fMh
         qg/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zIApn+pVyxRyKvTHD5IYjvS4FfZyz2qp0mFhAC5RqDE=;
        b=CWgC6vmhgSGeS1TOYaVr/HEJokWTrfZsCI1OWdicTxLDmcO+6/SlzoTHb4Sq4/SvVK
         varNbnkGi8HATB8CF863al/ReA/IMEcwzWjrVWR6GudM8XsBxSDLCpXoW9VEyo1jb2G/
         e6DxDfNxbP7V6XNsABbVbfI3QinMPLXGHaAknPQQ3itGO6gNrhWI90FhfpR+rTPpyESz
         wgsI4eDRN31q7nK68eFfLtkxE/2WCfHKsVzSYt4eUeLob06xvIVHqCsBQKmhZ+RalrPp
         RmG/uOIK9a5PIcUUgF6DrLD9Z8RBheEFXB7CFP0yW/C0ojyZZPCG/iY8vwFuWxbwgrfH
         0xhg==
X-Gm-Message-State: AOAM5334cpUlgyarF8n8vf1Si06q6i7R/xTfxchVSlJOoCrCKSS/LJYo
        9o96sck5/v00BWPxTsn/9Xfzf54j8rro6Q==
X-Google-Smtp-Source: ABdhPJxBA/wWSn+nXtBLSSV61lcyPYd2x2WJshaC0nVveSwUICm/yOnKZQnNKmRqltq/Gpr1QLd7hQ==
X-Received: by 2002:a05:620a:983:: with SMTP id x3mr4809407qkx.151.1630612478996;
        Thu, 02 Sep 2021 12:54:38 -0700 (PDT)
Received: from ?IPv6:2620:6e:6000:3100:dedd:4a4a:8e3e:2af5? ([2620:6e:6000:3100:dedd:4a4a:8e3e:2af5])
        by smtp.gmail.com with ESMTPSA id n14sm1679493qti.47.2021.09.02.12.54.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 12:54:38 -0700 (PDT)
Subject: Re: [syzbot] INFO: task can't die in __lock_sock
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+7d51f807c81b190a127d@syzkaller.appspotmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000b1c39505c99bd67c@google.com>
 <20210902031752.2502-1-hdanton@sina.com>
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Message-ID: <a43c3f8f-66b5-164f-c299-53d15c015845@gmail.com>
Date:   Thu, 2 Sep 2021 15:54:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210902031752.2502-1-hdanton@sina.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/9/21 11:17 pm, Hillf Danton wrote:
> On Wed, 01 Sep 2021 10:34:21 -0700
>> syzbot has found a reproducer for the following issue on:
>>
>> HEAD commit:    c1b13fe76e95 Add linux-next specific files for 20210901
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12c6034d300000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=e2afff7bc32736e5
>> dashboard link: https://syzkaller.appspot.com/bug?extid=7d51f807c81b190a127d
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d42469300000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1107d815300000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+7d51f807c81b190a127d@syzkaller.appspotmail.com
>>
>> INFO: task syz-executor157:6562 blocked for more than 143 seconds.
>>        Not tainted 5.14.0-next-20210901-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:syz-executor157 state:D stack:26880 pid: 6562 ppid:  6530 flags:0x00004006
>> Call Trace:
>>   context_switch kernel/sched/core.c:4955 [inline]
>>   __schedule+0x940/0x26f0 kernel/sched/core.c:6302
>>   schedule+0xd3/0x270 kernel/sched/core.c:6381
>>   __lock_sock+0x13d/0x260 net/core/sock.c:2644
>>   lock_sock_nested+0xf6/0x120 net/core/sock.c:3185
>>   lock_sock include/net/sock.h:1612 [inline]
> 
> This is due to b7ce436a5d79 ("Bluetooth: switch to lock_sock in RFCOMM").
> 
>>   rfcomm_sk_state_change+0xb4/0x390 net/bluetooth/rfcomm/sock.c:73
>>   __rfcomm_dlc_close+0x1b6/0x8a0 net/bluetooth/rfcomm/core.c:489
>>   rfcomm_dlc_close+0x1ea/0x240 net/bluetooth/rfcomm/core.c:520
>>   __rfcomm_sock_close+0xac/0x260 net/bluetooth/rfcomm/sock.c:220
>>   rfcomm_sock_shutdown+0xe9/0x210 net/bluetooth/rfcomm/sock.c:931
>>   rfcomm_sock_release+0x5f/0x140 net/bluetooth/rfcomm/sock.c:951
>>   __sock_release+0xcd/0x280 net/socket.c:649
>>   sock_close+0x18/0x20 net/socket.c:1314
>>   __fput+0x288/0x9f0 fs/file_table.c:280
>>   task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>>   exit_task_work include/linux/task_work.h:32 [inline]
>>   do_exit+0xbae/0x2a30 kernel/exit.c:825
>>   do_group_exit+0x125/0x310 kernel/exit.c:922
>>   get_signal+0x47f/0x2160 kernel/signal.c:2868
>>   arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
>>   handle_signal_work kernel/entry/common.c:148 [inline]
>>   exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>>   exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
>>   __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>>   syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
>>   do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x445fe9
>> RSP: 002b:00007fff85049fe8 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
>> RAX: fffffffffffffffc RBX: 0000000000000003 RCX: 0000000000445fe9
>> RDX: 0000000000000080 RSI: 0000000020000000 RDI: 0000000000000004
>> RBP: 0000000000000003 R08: 000000ff00000001 R09: 000000ff00000001
>> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000014112b8
>> R13: 0000000000000072 R14: 00007fff8504a040 R15: 0000000000000003
>>
>> Showing all locks held in the system:
>> 1 lock held by khungtaskd/26:
>>   #0: ffffffff8b97fbe0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
>> 1 lock held by krfcommd/2876:
>>   #0: ffffffff8d31ede8 (rfcomm_mutex){+.+.}-{3:3}, at: rfcomm_process_sessions net/bluetooth/rfcomm/core.c:1979 [inline]
>>   #0: ffffffff8d31ede8 (rfcomm_mutex){+.+.}-{3:3}, at: rfcomm_run+0x2ed/0x4a20 net/bluetooth/rfcomm/core.c:2086
>> 1 lock held by in:imklog/6232:
>> 4 locks held by syz-executor157/6562:
>>   #0: ffff888145e26210 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:786 [inline]
>>   #0: ffff888145e26210 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: __sock_release+0x86/0x280 net/socket.c:648
>>   #1: ffff88801d622120 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1612 [inline]
>>   #1: ffff88801d622120 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: rfcomm_sock_shutdown+0x54/0x210 net/bluetooth/rfcomm/sock.c:928
> 
> But sk is already locked before b7ce436a5d79.
> 
> What is wierd here is lock_sock() fails to complain about recursive locking
> like this one if syzbot turned lockdep on. Any light on this, Eric?
> 
> Thanks
> Hillf
> 

Sorry, this one was my bad. The patch swapped out spin_lock_bh for 
lock_sock, to provide synchronization with other functions that use 
lock_sock.

Problem is that in one of the call traces, we hit the following deadlock:

   rfcomm_sock_close():
     lock_sock();
     __rfcomm_sock_close():
       rfcomm_dlc_close():
         __rfcomm_dlc_close():
           rfcomm_sk_state_change():
             lock_sock();

But we don't always hold onto the socket lock before calling 
rfcomm_sk_state_change.

I'm still working and testing a fix, but I think one possibility is to 
schedule rfcomm_sk_state_change on a workqueue. This seems to fit with 
the rest of the code, since in rfcomm_sock_shutdown we call 
rfcomm_sock_close then wait for the sk state to change to BT_CLOSED.

>>   #2: ffffffff8d31ede8 (rfcomm_mutex){+.+.}-{3:3}, at: rfcomm_dlc_close+0x34/0x240 net/bluetooth/rfcomm/core.c:507
>>   #3: ffff88807edd9928 (&d->lock){+.+.}-{3:3}, at: __rfcomm_dlc_close+0x162/0x8a0 net/bluetooth/rfcomm/core.c:487
>>
>> =============================================
>>
>> NMI backtrace for cpu 1
>> CPU: 1 PID: 26 Comm: khungtaskd Not tainted 5.14.0-next-20210901-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:88 [inline]
>>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>>   nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
>>   nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
>>   trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>>   check_hung_uninterruptible_tasks kernel/hung_task.c:254 [inline]
>>   watchdog+0xcb7/0xed0 kernel/hung_task.c:339
>>   kthread+0x3e5/0x4d0 kernel/kthread.c:319
>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>> Sending NMI from CPU 1 to CPUs 0:
>> NMI backtrace for cpu 0
>> CPU: 0 PID: 2958 Comm: systemd-journal Not tainted 5.14.0-next-20210901-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:check_kcov_mode kernel/kcov.c:163 [inline]
>> RIP: 0010:__sanitizer_cov_trace_pc+0x7/0x60 kernel/kcov.c:197
>> Code: fd ff ff b9 ff ff ff ff ba 08 00 00 00 4d 8b 03 48 0f bd ca 49 8b 45 00 48 63 c9 e9 64 ff ff ff 0f 1f 00 65 8b 05 39 e6 8b 7e <89> c1 48 8b 34 24 81 e1 00 01 00 00 65 48 8b 14 25 40 f0 01 00 a9
>> RSP: 0018:ffffc900014dfde0 EFLAGS: 00000282
>> RAX: 0000000080000000 RBX: ffffc900014dff58 RCX: 1ffff9200029bfc7
>> RDX: dffffc0000000000 RSI: 1ffff9200029bfcd RDI: ffffc900014dfe38
>> RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8176c71a
>> R10: ffffffff81765c97 R11: 0000000000000002 R12: 0000000000000053
>> R13: 0000000000000002 R14: 0000000000000000 R15: ffffc900014dfe30
>> FS:  00007f43756768c0(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f4372a49000 CR3: 000000001a5d4000 CR4: 00000000001506f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>   get_current arch/x86/include/asm/current.h:15 [inline]
>>   seccomp_run_filters kernel/seccomp.c:402 [inline]
>>   __seccomp_filter+0x88/0x1040 kernel/seccomp.c:1180
>>   __secure_computing+0xfc/0x360 kernel/seccomp.c:1311
>>   syscall_trace_enter.constprop.0+0x94/0x270 kernel/entry/common.c:68
>>   do_syscall_64+0x16/0xb0 arch/x86/entry/common.c:76
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x7f4374931687
>> Code: 00 b8 ff ff ff ff c3 0f 1f 40 00 48 8b 05 09 d8 2b 00 64 c7 00 5f 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 d7 2b 00 f7 d8 64 89 01 48
>> RSP: 002b:00007ffc79978938 EFLAGS: 00000293 ORIG_RAX: 0000000000000053
>> RAX: ffffffffffffffda RBX: 00007ffc7997b850 RCX: 00007f4374931687
>> RDX: 00007f43753a2a00 RSI: 00000000000001ed RDI: 00005646c59898a0
>> RBP: 00007ffc79978970 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000069 R11: 0000000000000293 R12: 0000000000000000
>> R13: 0000000000000000 R14: 00007ffc7997b850 R15: 00007ffc79978e60
>> ----------------
>> Code disassembly (best guess), 3 bytes skipped:
>>     0:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
>>     5:	ba 08 00 00 00       	mov    $0x8,%edx
>>     a:	4d 8b 03             	mov    (%r11),%r8
>>     d:	48 0f bd ca          	bsr    %rdx,%rcx
>>    11:	49 8b 45 00          	mov    0x0(%r13),%rax
>>    15:	48 63 c9             	movslq %ecx,%rcx
>>    18:	e9 64 ff ff ff       	jmpq   0xffffff81
>>    1d:	0f 1f 00             	nopl   (%rax)
>>    20:	65 8b 05 39 e6 8b 7e 	mov    %gs:0x7e8be639(%rip),%eax        # 0x7e8be660
>> * 27:	89 c1                	mov    %eax,%ecx <-- trapping instruction
>>    29:	48 8b 34 24          	mov    (%rsp),%rsi
>>    2d:	81 e1 00 01 00 00    	and    $0x100,%ecx
>>    33:	65 48 8b 14 25 40 f0 	mov    %gs:0x1f040,%rdx
>>    3a:	01 00
>>    3c:	a9                   	.byte 0xa9
>>
>>

