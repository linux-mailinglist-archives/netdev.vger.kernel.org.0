Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258F16EE983
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236344AbjDYVSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbjDYVSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:18:39 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B39D7DB0;
        Tue, 25 Apr 2023 14:18:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682457491; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=r3gc6NAuujfzQRJA8bSJXgd8xYKO8di/cs4bssBmO4/JMFfQ7i/XS+gdaP5cKft4aN
    z+XVgLdPJI79O26WUXuzD9BKi/DDURVElisoiDSjzv5OfdVzmWNbCEzAyPGDoZR9mb3F
    50BmzjBtv/LECwXKa0/eX7+qZre9h6U9y4Cm1sGOtbS/Yxz0d/01cXxX+RHmWm6RSlV6
    9K5egzkvQW8NLh3qLdy5myx4J1qBkV62F5iWXcfQQg9j9YUYUoOQ5239dleCvw6Ewh54
    hE67TCrqcW+ad+dhm/D2p2QMCCtZvwlNY2wUMppJA6eWfogmJSc00xvTT2Kiox5jQhpR
    pJmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1682457491;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=+w6GIGOh5NfsuDozFr0Usa5XzZnEsjYkFhnak19XyFg=;
    b=Wv5S3QtMPcyVe0+Ov0DMh0neG0AQyRkg7QLUzloSxraNQjDezhfnQ13Fv6YLgSaqGd
    X7aPEpB9wnZisZvLI3uL9HT03Y3aee9yZQS1yHDmWBoMbVQg7pQJ2RAmYpuNl2UOB2nL
    N09qJ0m83OjKfbxUoIMbhxuM0XpcLrWyJXuSy6/Fj5XwkSknG/+jX0daegZMalOrmC87
    dHUElaeWD+9hu/5LkuLLFS9ADuBOdLfO69+g3IThzPyrLKbs0DXbv7mP30M+4BCQ7Dj4
    +3Lz5kmoKPtQvOzCrLW4HCh5rHYGzJfO5mlfBe72zBR7RV5eZ+kZFU/sB9pO7Mbep1hF
    d1wg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1682457491;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=+w6GIGOh5NfsuDozFr0Usa5XzZnEsjYkFhnak19XyFg=;
    b=X09IPxccDMqNBbql7DIZBehBxAJbpZJ6pmhW75nAAd5azXOlFjehczh+N6AQe/dtlc
    k6EtTXnufWQWx7+I5OS5WJfOd2hexYZA0G4umJYHR+cEmTku0OLPyhvQ8CHr5cJi2Mq+
    pnoFHy+bHiX+17qs7UX+Uj8OX7bnSGQMeMArbuFn12AE/5DMrEunLgKBdDnctu2BnvDs
    zpwbOHudHjVbvUJ+wK0xL3RgcjitvfOpLlcM1pDUvvwj/TpWdtFagt8O2d24yCxhMrJl
    3ETnRwY4xfXBlLVW4/f6/WXFjt6PsUsUHSzOFHnsXg9Mp6LNeC2CnpNoEm6NPCpSS6uu
    eM0A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1682457491;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=+w6GIGOh5NfsuDozFr0Usa5XzZnEsjYkFhnak19XyFg=;
    b=6VVIaiEsg3qW//nuKqbD7PnRGm7XChw2QoG8pTVqjNeDGJO1h9HtfgBgjCpx7gnC5j
    O8Cqm/OHqORKXP4xmsCw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusl129OHEdFq1USEbMhpqw=="
Received: from [IPV6:2a00:6020:4a8e:5004::923]
    by smtp.strato.de (RZmta 49.4.0 AUTH)
    with ESMTPSA id x06214z3PLIBscx
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 25 Apr 2023 23:18:11 +0200 (CEST)
Message-ID: <b4306f50-08e4-d41d-1e59-5be1f9735dd6@hartkopp.net>
Date:   Tue, 25 Apr 2023 23:18:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [syzbot] [can?] KCSAN: data-race in bcm_can_tx / bcm_tx_setup (3)
To:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+e1786f049e71693263bf@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkl@pengutronix.de, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
References: <00000000000059e1b705fa2494e4@google.com>
 <CACT4Y+YDzXb6WoMtBu5O-dpWOkVYwhUNKM7szC5gJ9ewtMUPDQ@mail.gmail.com>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <CACT4Y+YDzXb6WoMtBu5O-dpWOkVYwhUNKM7szC5gJ9ewtMUPDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dmitry,

On 25.04.23 10:36, Dmitry Vyukov wrote:
> On Tue, 25 Apr 2023 at 10:05, syzbot
> <syzbot+e1786f049e71693263bf@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    1a0beef98b58 Merge tag 'tpmdd-v6.4-rc1' of git://git.kerne..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1485f1dbc80000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=501f7c86f7a05a13
>> dashboard link: https://syzkaller.appspot.com/bug?extid=e1786f049e71693263bf
>> compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/f06c11683242/disk-1a0beef9.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/5c0a1cd5a059/vmlinux-1a0beef9.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/e4c318183ce3/bzImage-1a0beef9.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+e1786f049e71693263bf@syzkaller.appspotmail.com
> 
> op->currframe and probably other op fields are concurrently
> read/modified by both bcm_tx_setup() and bcm_can_tx().
> If I am reading the code correctly, it can lead to a wide range of
> misbehavior, e.g. sending wrong/uninit data, reading/writing data
> out-of-bounds, etc.
> I think these functions need to be somehow serialized (stopping timers
> before doing any modifications to op?).

KCSAN has detected a very special case here:

The content of the CAN frames (in a running tx-job) has been altered and 
the number of CAN frames has been reduced. (Increasing if the number of 
CAN frames is not possible with an active tx-job/running hrtimer).

Or (alternatively) the TX_RESET_MULTI_IDX flag has been set.

In both cases op->currframe is set to zero to start the sequence of the 
CAN frames in op->frames in the next(!) hrtimer execution.

So setting values in op->currframe to zero (as pointed out by KCSAN) is 
always a good move.

When there would be a race between the op->currframe++ in bcm_can_tx() 
and the test for
if (op->nframes != msg_head->nframes) in bcm_tx_setup() this would be 
fixed with
if (op->currframe >= op->nframes) in bcm_can_tx().

But looking at the code again I'm not sure if we might /potentially/ 
lose the TX_RESET_MULTI_IDX feature when the unlocked op->currframe++ is 
performed concurrently in bcm_can_tx().

So a short local locking around the op->currframe r/w operations in 
bcm_can_tx() and bcm_tx_setup() would make sense IMO.

The code is intended to update CAN frame content (with a fixed 
non-increasing length) lock-less on the fly and there should be no other 
"wide range of misbehavior" cases here.

I will take a look and send a patch for the op->currframe locking.

Many thanks for looking into this and best regards,
Oliver

> 
>> ==================================================================
>> BUG: KCSAN: data-race in bcm_can_tx / bcm_tx_setup
>>
>> write to 0xffff888137fcff10 of 4 bytes by task 10792 on cpu 0:
>>   bcm_tx_setup+0x698/0xd30 net/can/bcm.c:995
>>   bcm_sendmsg+0x38b/0x470 net/can/bcm.c:1355
>>   sock_sendmsg_nosec net/socket.c:724 [inline]
>>   sock_sendmsg net/socket.c:747 [inline]
>>   ____sys_sendmsg+0x375/0x4c0 net/socket.c:2501
>>   ___sys_sendmsg net/socket.c:2555 [inline]
>>   __sys_sendmsg+0x1e3/0x270 net/socket.c:2584
>>   __do_sys_sendmsg net/socket.c:2593 [inline]
>>   __se_sys_sendmsg net/socket.c:2591 [inline]
>>   __x64_sys_sendmsg+0x46/0x50 net/socket.c:2591
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> write to 0xffff888137fcff10 of 4 bytes by interrupt on cpu 1:
>>   bcm_can_tx+0x38a/0x410
>>   bcm_tx_timeout_handler+0xdb/0x260
>>   __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
>>   __hrtimer_run_queues+0x217/0x700 kernel/time/hrtimer.c:1749
>>   hrtimer_run_softirq+0xd6/0x120 kernel/time/hrtimer.c:1766
>>   __do_softirq+0xc1/0x265 kernel/softirq.c:571
>>   invoke_softirq kernel/softirq.c:445 [inline]
>>   __irq_exit_rcu+0x57/0xa0 kernel/softirq.c:650
>>   sysvec_apic_timer_interrupt+0x6d/0x80 arch/x86/kernel/apic/apic.c:1107
>>   asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:645
>>   kcsan_setup_watchpoint+0x3fe/0x410 kernel/kcsan/core.c:696
>>   string_nocheck lib/vsprintf.c:648 [inline]
>>   string+0x16c/0x200 lib/vsprintf.c:726
>>   vsnprintf+0xa09/0xe20 lib/vsprintf.c:2796
>>   add_uevent_var+0xf0/0x1c0 lib/kobject_uevent.c:665
>>   kobject_uevent_env+0x225/0x5b0 lib/kobject_uevent.c:539
>>   kobject_uevent+0x1c/0x20 lib/kobject_uevent.c:642
>>   __loop_clr_fd+0x1e0/0x3b0 drivers/block/loop.c:1167
>>   lo_release+0xe4/0xf0 drivers/block/loop.c:1745
>>   blkdev_put+0x3fb/0x470
>>   kill_block_super+0x83/0xa0 fs/super.c:1410
>>   deactivate_locked_super+0x6b/0xd0 fs/super.c:331
>>   deactivate_super+0x9b/0xb0 fs/super.c:362
>>   cleanup_mnt+0x272/0x2e0 fs/namespace.c:1177
>>   __cleanup_mnt+0x19/0x20 fs/namespace.c:1184
>>   task_work_run+0x123/0x160 kernel/task_work.c:179
>>   resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
>>   exit_to_user_mode_loop+0xd1/0xe0 kernel/entry/common.c:171
>>   exit_to_user_mode_prepare+0x6c/0xb0 kernel/entry/common.c:204
>>   __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
>>   syscall_exit_to_user_mode+0x26/0x140 kernel/entry/common.c:297
>>   do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> value changed: 0x00000059 -> 0x00000000
>>
>> Reported by Kernel Concurrency Sanitizer on:
>> CPU: 1 PID: 3096 Comm: syz-executor.5 Not tainted 6.3.0-syzkaller-00113-g1a0beef98b58 #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
>> ==================================================================
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>
>> --
>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/00000000000059e1b705fa2494e4%40google.com.
