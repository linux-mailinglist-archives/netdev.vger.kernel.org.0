Return-Path: <netdev+bounces-1921-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C03106FF917
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:00:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80FC71C20FEC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 18:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164948F74;
	Thu, 11 May 2023 18:00:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24D32068B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 18:00:17 +0000 (UTC)
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55375FD7;
	Thu, 11 May 2023 10:59:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1683827790; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=dQNDErFqxAcH2atIqmRYuzIFQtFDtybk0ITgq3nyLOJd2mrCcq1zv3ZeH2y4wDaDNu
    YWZzpU5XD3QDYia2jloFpvNyPZ2Pqq+VBRqkEO6CaBCvqlTwHrwtAspYkBBnPhhvv1eH
    Pkl/Y/6pUaq5CRgvDjJXE1EgXepFuyhxBvopMZcIFT2OuQPOuZ3dBBc32AGrbuVjBMT3
    YROYm/BjL95od1sZ5//cCwVqB9m+smWiyLjwatoKoEplY7dc/abE/pMsPQAtoLGPEI/x
    KZN3egoW/stT9SF/igVwKHCV81UV6oxJTt5j3xGT/MvKLVmWrE+eNBM7Yf2FDjR+iu00
    tllg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1683827790;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=gLwUj8aS+Q4cABfQXUURa/vgdUsc7M5AAVAFpsKhw+g=;
    b=M7s5L367o/SSEBi0T3+YtseAe+J65MRz97u0jjgqEFXqgbViP2fc68Bh12M8ffUszy
    gqNjgTrPB9rCqW4TRehMJ3NERL/MWfNpEkpXeZOSYZ7YBYNBMaVTSTdbZbkjCseApfqR
    QEWOOHUw/YGxNEbqJoiEc52R0koEZ3TYkzkAG7ODSWTTA0ENy1QhcNQ9TfWocclxne/T
    aWsBwlln1of/CmjnoWuTcW2f1AsWivrPEnN0LADauMzaQUR9YqhmKKtkDDRGRnVQL4p/
    jZmI0kyzu+fQiUGS3C2JKvKHc0at1FZ9DcSZUBHJmfajglVBrNn7xmbvJ4U4Z9GlEcKs
    rNpw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1683827790;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=gLwUj8aS+Q4cABfQXUURa/vgdUsc7M5AAVAFpsKhw+g=;
    b=I3sTb6v0sd6IZlaxzMnt9xRCqf1Im8DOwkPD6AKIkmZMpXE0d8p77E8iU2+0UcaqU4
    vYAmY+EwHkUBNzoJA09nv+B6GX+sZixbfeQukDGoQqNao8ctYWQeWhW7YE0lAl0xiHFv
    RUZVmVUQ8EibdF9qf5EsKV2sGFVaKYqoDAWlW40pecrhNE85jSQG2JFxMgvbK7ipuvJr
    F4csEFrOBWKWhFxV8S25Gxiswywysi8jnfua1qUXWisnkta1KHmITjJ6ZDZFxbeEvGvg
    06pTZ0l0//MkFWu3aoHjwUQqW5xFKwxdHLbRDpCX5HeSJiqtiWmk10ywQmQb3WRL+d0d
    Om4A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1683827790;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=gLwUj8aS+Q4cABfQXUURa/vgdUsc7M5AAVAFpsKhw+g=;
    b=/j0g5f5wj6iftljg1QE+ZWDmFDE6DArsYJgi6CC4IoJCUoIfaD+5DIqYznUw0MmnFn
    39/Yng99ngCpSVg/49Dg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusl129OHEdFq0USEbDUQnQ=="
Received: from [IPV6:2a00:6020:4a8e:5000::923]
    by smtp.strato.de (RZmta 49.4.0 AUTH)
    with ESMTPSA id x06214z4BHuTaJA
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 11 May 2023 19:56:29 +0200 (CEST)
Message-ID: <886183c2-8910-d6cd-92db-f650a0ab202e@hartkopp.net>
Date: Thu, 11 May 2023 19:56:29 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [syzbot] [can?] KCSAN: data-race in bcm_can_tx / bcm_tx_setup (3)
Content-Language: en-US
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+e1786f049e71693263bf@syzkaller.appspotmail.com>,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 linux-can@vger.kernel.org, linux-kernel@vger.kernel.org, mkl@pengutronix.de,
 netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com
References: <00000000000059e1b705fa2494e4@google.com>
 <CACT4Y+YDzXb6WoMtBu5O-dpWOkVYwhUNKM7szC5gJ9ewtMUPDQ@mail.gmail.com>
 <b4306f50-08e4-d41d-1e59-5be1f9735dd6@hartkopp.net>
 <CACT4Y+b_3q-AjxKj3zF7JuXyZb5cttCX8hzVb0QMfq+aOnGSpA@mail.gmail.com>
From: Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <CACT4Y+b_3q-AjxKj3zF7JuXyZb5cttCX8hzVb0QMfq+aOnGSpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Dmitry,

On 26.04.23 09:04, Dmitry Vyukov wrote:
> On Tue, 25 Apr 2023 at 23:18, Oliver Hartkopp <socketcan@hartkopp.net> wrote:
>>
>> Hello Dmitry,
>>
>> On 25.04.23 10:36, Dmitry Vyukov wrote:
>>> On Tue, 25 Apr 2023 at 10:05, syzbot
>>> <syzbot+e1786f049e71693263bf@syzkaller.appspotmail.com> wrote:
>>>>
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    1a0beef98b58 Merge tag 'tpmdd-v6.4-rc1' of git://git.kerne..
>>>> git tree:       upstream
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1485f1dbc80000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=501f7c86f7a05a13
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=e1786f049e71693263bf
>>>> compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
>>>>
>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>
>>>> Downloadable assets:
>>>> disk image: https://storage.googleapis.com/syzbot-assets/f06c11683242/disk-1a0beef9.raw.xz
>>>> vmlinux: https://storage.googleapis.com/syzbot-assets/5c0a1cd5a059/vmlinux-1a0beef9.xz
>>>> kernel image: https://storage.googleapis.com/syzbot-assets/e4c318183ce3/bzImage-1a0beef9.xz
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+e1786f049e71693263bf@syzkaller.appspotmail.com
>>>
>>> op->currframe and probably other op fields are concurrently
>>> read/modified by both bcm_tx_setup() and bcm_can_tx().
>>> If I am reading the code correctly, it can lead to a wide range of
>>> misbehavior, e.g. sending wrong/uninit data, reading/writing data
>>> out-of-bounds, etc.
>>> I think these functions need to be somehow serialized (stopping timers
>>> before doing any modifications to op?).
>>
>> KCSAN has detected a very special case here:
>>
>> The content of the CAN frames (in a running tx-job) has been altered and
>> the number of CAN frames has been reduced. (Increasing if the number of
>> CAN frames is not possible with an active tx-job/running hrtimer).
>>
>> Or (alternatively) the TX_RESET_MULTI_IDX flag has been set.
>>
>> In both cases op->currframe is set to zero to start the sequence of the
>> CAN frames in op->frames in the next(!) hrtimer execution.
>>
>> So setting values in op->currframe to zero (as pointed out by KCSAN) is
>> always a good move.
>>
>> When there would be a race between the op->currframe++ in bcm_can_tx()
>> and the test for
>> if (op->nframes != msg_head->nframes) in bcm_tx_setup() this would be
>> fixed with
>> if (op->currframe >= op->nframes) in bcm_can_tx().
>>
>> But looking at the code again I'm not sure if we might /potentially/
>> lose the TX_RESET_MULTI_IDX feature when the unlocked op->currframe++ is
>> performed concurrently in bcm_can_tx().
>>
>> So a short local locking around the op->currframe r/w operations in
>> bcm_can_tx() and bcm_tx_setup() would make sense IMO.
>>
>> The code is intended to update CAN frame content (with a fixed
>> non-increasing length) lock-less on the fly and there should be no other
>> "wide range of misbehavior" cases here.
>>
>> I will take a look and send a patch for the op->currframe locking.
>>
>> Many thanks for looking into this and best regards,
>> Oliver
> 
> bcm_tx_timeout_handler() must also be racing with bcm_tx_setup() and
> it reads more fields (kt_ival1, kt_ival2, flags, count) while they are
> being changed.
> Can bcm_tx_timeout_handler() read unint/partially
> init/inconsistent/stale values for these fields?
> Also can't bcm_can_tx() read partially overwritten/messed cf data when
> sending, since it's already being overwritten by bcm_tx_setup()?

I needed to stare on the code some more time to boil it down to the 
relevant and critical variables and functions that are concurrently 
modified and executed from user context and the soft hrtimer.

And finally I had to figure out which kind of locking has to be used here:

https://docs.kernel.org/kernel-hacking/locking.html
"Locking Between User Context and Timers"

The RFC patch can be found here:
https://lore.kernel.org/linux-can/20230511174644.8849-1-socketcan@hartkopp.net/T/#u

I'll do some more tests to check if the locking creates some 'real world 
problems'.

Many thanks for your support!

Oliver

> 
>>>> ==================================================================
>>>> BUG: KCSAN: data-race in bcm_can_tx / bcm_tx_setup
>>>>
>>>> write to 0xffff888137fcff10 of 4 bytes by task 10792 on cpu 0:
>>>>    bcm_tx_setup+0x698/0xd30 net/can/bcm.c:995
>>>>    bcm_sendmsg+0x38b/0x470 net/can/bcm.c:1355
>>>>    sock_sendmsg_nosec net/socket.c:724 [inline]
>>>>    sock_sendmsg net/socket.c:747 [inline]
>>>>    ____sys_sendmsg+0x375/0x4c0 net/socket.c:2501
>>>>    ___sys_sendmsg net/socket.c:2555 [inline]
>>>>    __sys_sendmsg+0x1e3/0x270 net/socket.c:2584
>>>>    __do_sys_sendmsg net/socket.c:2593 [inline]
>>>>    __se_sys_sendmsg net/socket.c:2591 [inline]
>>>>    __x64_sys_sendmsg+0x46/0x50 net/socket.c:2591
>>>>    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>    do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
>>>>    entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>
>>>> write to 0xffff888137fcff10 of 4 bytes by interrupt on cpu 1:
>>>>    bcm_can_tx+0x38a/0x410
>>>>    bcm_tx_timeout_handler+0xdb/0x260
>>>>    __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
>>>>    __hrtimer_run_queues+0x217/0x700 kernel/time/hrtimer.c:1749
>>>>    hrtimer_run_softirq+0xd6/0x120 kernel/time/hrtimer.c:1766
>>>>    __do_softirq+0xc1/0x265 kernel/softirq.c:571
>>>>    invoke_softirq kernel/softirq.c:445 [inline]
>>>>    __irq_exit_rcu+0x57/0xa0 kernel/softirq.c:650
>>>>    sysvec_apic_timer_interrupt+0x6d/0x80 arch/x86/kernel/apic/apic.c:1107
>>>>    asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:645
>>>>    kcsan_setup_watchpoint+0x3fe/0x410 kernel/kcsan/core.c:696
>>>>    string_nocheck lib/vsprintf.c:648 [inline]
>>>>    string+0x16c/0x200 lib/vsprintf.c:726
>>>>    vsnprintf+0xa09/0xe20 lib/vsprintf.c:2796
>>>>    add_uevent_var+0xf0/0x1c0 lib/kobject_uevent.c:665
>>>>    kobject_uevent_env+0x225/0x5b0 lib/kobject_uevent.c:539
>>>>    kobject_uevent+0x1c/0x20 lib/kobject_uevent.c:642
>>>>    __loop_clr_fd+0x1e0/0x3b0 drivers/block/loop.c:1167
>>>>    lo_release+0xe4/0xf0 drivers/block/loop.c:1745
>>>>    blkdev_put+0x3fb/0x470
>>>>    kill_block_super+0x83/0xa0 fs/super.c:1410
>>>>    deactivate_locked_super+0x6b/0xd0 fs/super.c:331
>>>>    deactivate_super+0x9b/0xb0 fs/super.c:362
>>>>    cleanup_mnt+0x272/0x2e0 fs/namespace.c:1177
>>>>    __cleanup_mnt+0x19/0x20 fs/namespace.c:1184
>>>>    task_work_run+0x123/0x160 kernel/task_work.c:179
>>>>    resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
>>>>    exit_to_user_mode_loop+0xd1/0xe0 kernel/entry/common.c:171
>>>>    exit_to_user_mode_prepare+0x6c/0xb0 kernel/entry/common.c:204
>>>>    __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
>>>>    syscall_exit_to_user_mode+0x26/0x140 kernel/entry/common.c:297
>>>>    do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
>>>>    entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>
>>>> value changed: 0x00000059 -> 0x00000000
>>>>
>>>> Reported by Kernel Concurrency Sanitizer on:
>>>> CPU: 1 PID: 3096 Comm: syz-executor.5 Not tainted 6.3.0-syzkaller-00113-g1a0beef98b58 #0
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
>>>> ==================================================================
>>>>
>>>>
>>>> ---
>>>> This report is generated by a bot. It may contain errors.
>>>> See https://goo.gl/tpsmEJ for more information about syzbot.
>>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>>
>>>> syzbot will keep track of this issue. See:
>>>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>>>
>>>> --
>>>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>>>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>>>> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/00000000000059e1b705fa2494e4%40google.com.

