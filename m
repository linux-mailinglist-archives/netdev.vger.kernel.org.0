Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F45D6895BD
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 11:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbjBCKXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 05:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbjBCKXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 05:23:08 -0500
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF49D9EE08
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 02:22:50 -0800 (PST)
Received: from fsav311.sakura.ne.jp (fsav311.sakura.ne.jp [153.120.85.142])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 313AMjDr038827;
        Fri, 3 Feb 2023 19:22:45 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav311.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav311.sakura.ne.jp);
 Fri, 03 Feb 2023 19:22:45 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav311.sakura.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 313AMjZd038824
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 3 Feb 2023 19:22:45 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <9d9b9652-c1ac-58e9-2eab-9256c17b1da2@I-love.SAKURA.ne.jp>
Date:   Fri, 3 Feb 2023 19:22:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [syzbot] WARNING: locking bug in umh_complete
Content-Language: en-US
To:     Hillf Danton <hdanton@sina.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     linux-kernel@vger.kernel.org, mcgrof@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+6cd18e123583550cf469@syzkaller.appspotmail.com>
References: <20230127014137.4906-1-hdanton@sina.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20230127014137.4906-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/01/27 10:41, Hillf Danton wrote:
> On Thu, 26 Jan 2023 14:27:51 -0800
>> syzbot found the following issue on:
>>
>> HEAD commit:    71ab9c3e2253 net: fix UaF in netns ops registration error ..
>> git tree:       net
>> console output: https://syzkaller.appspot.com/x/log.txt?x=10f86a56480000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=899d86a7610a0ea0
>> dashboard link: https://syzkaller.appspot.com/bug?extid=6cd18e123583550cf469
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/54c953096fdb/disk-71ab9c3e.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/644d72265810/vmlinux-71ab9c3e.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/16e994579ca5/bzImage-71ab9c3e.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+6cd18e123583550cf469@syzkaller.appspotmail.com
>>
>> ------------[ cut here ]------------
>> DEBUG_LOCKS_WARN_ON(1)
>> WARNING: CPU: 0 PID: 46 at kernel/locking/lockdep.c:231 hlock_class kernel/locking/lockdep.c:231 [inline]
>> WARNING: CPU: 0 PID: 46 at kernel/locking/lockdep.c:231 hlock_class kernel/locking/lockdep.c:220 [inline]
>> WARNING: CPU: 0 PID: 46 at kernel/locking/lockdep.c:231 check_wait_context kernel/locking/lockdep.c:4729 [inline]
>> WARNING: CPU: 0 PID: 46 at kernel/locking/lockdep.c:231 __lock_acquire+0x13ae/0x56d0 kernel/locking/lockdep.c:5005
>> Modules linked in:
>> CPU: 0 PID: 46 Comm: kworker/u4:3 Not tainted 6.2.0-rc4-syzkaller-00191-g71ab9c3e2253 #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
>> Workqueue: events_unbound call_usermodehelper_exec_work
>> RIP: 0010:hlock_class kernel/locking/lockdep.c:231 [inline]
>> RIP: 0010:hlock_class kernel/locking/lockdep.c:220 [inline]
>> RIP: 0010:check_wait_context kernel/locking/lockdep.c:4729 [inline]
>> RIP: 0010:__lock_acquire+0x13ae/0x56d0 kernel/locking/lockdep.c:5005
>> Code: 08 84 d2 0f 85 56 41 00 00 8b 15 55 7b 0f 0d 85 d2 0f 85 d5 fd ff ff 48 c7 c6 c0 51 4c 8a 48 c7 c7 20 4b 4c 8a e8 92 e1 5b 08 <0f> 0b 31 ed e9 50 f0 ff ff 48 c7 c0 a8 2b 73 8e 48 ba 00 00 00 00
>> RSP: 0018:ffffc90000b77a30 EFLAGS: 00010082
>> RAX: 0000000000000000 RBX: ffff88801272a778 RCX: 0000000000000000
>> RDX: ffff888012729d40 RSI: ffffffff8166822c RDI: fffff5200016ef38
>> RBP: 0000000000001b2c R08: 0000000000000005 R09: 0000000000000000
>> R10: 0000000080000001 R11: 0000000000000001 R12: ffff88801272a7c8
>> R13: ffff888012729d40 R14: ffffc9000397fb28 R15: 0000000000040000
>> FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007fa5a95e81d0 CR3: 00000000284d2000 CR4: 00000000003506f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  <TASK>
>>  lock_acquire kernel/locking/lockdep.c:5668 [inline]
>>  lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
>>  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>>  _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
>>  complete+0x1d/0x1f0 kernel/sched/completion.c:32
>>  umh_complete+0x32/0x90 kernel/umh.c:59
>>  call_usermodehelper_exec_sync kernel/umh.c:144 [inline]
>>  call_usermodehelper_exec_work+0x115/0x180 kernel/umh.c:167
>>  process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
>>  worker_thread+0x669/0x1090 kernel/workqueue.c:2436
>>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>>  </TASK>
> 
> This is an interesting case - given done initialized on stack, no garbage
> should have been detected by lockdep.
> 
> One explanation to the report is uaf on the waker side, and it can be
> tested with the diff below when a reproducer is available.
> 
> Hillf
> 
> --- a/kernel/umh.c
> +++ b/kernel/umh.c
> @@ -452,6 +452,12 @@ int call_usermodehelper_exec(struct subp
>  		/* umh_complete() will see NULL and free sub_info */
>  		if (xchg(&sub_info->complete, NULL))
>  			goto unlock;
> +		else {
> +			/* wait for umh_complete() to finish in a bid to avoid
> +			 * uaf because done is destructed
> +			 */
> +			wait_for_completion(&done);
> +		}
>  	}
>  
>  wait_done:
> --

Yes, this bug is caused by commit f5d39b020809 ("freezer,sched: Rewrite core freezer
logic"), for that commit for unknown reason omits wait_for_completion(&done) call
when wait_for_completion_state(&done, state) returned -ERESTARTSYS.

Peter, is it safe to restore wait_for_completion(&done) call?

