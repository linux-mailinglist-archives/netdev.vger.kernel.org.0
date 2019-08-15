Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC468E770
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 10:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbfHOIwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 04:52:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:39516 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfHOIwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 04:52:25 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hyBUW-0002oE-KV; Thu, 15 Aug 2019 10:52:16 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hyBUW-0009OD-DW; Thu, 15 Aug 2019 10:52:16 +0200
Subject: Re: WARNING in is_bpf_text_address
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "dvyukov@google.com" <dvyukov@google.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "longman@redhat.com" <longman@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        will@kernel.org
References: <20190811083658.10748-1-hdanton@sina.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d76d7a63-7854-e92d-30cb-52546d333ffe@iogearbox.net>
Date:   Thu, 15 Aug 2019 10:52:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190811083658.10748-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25542/Thu Aug 15 10:25:56 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/19 10:36 AM, Hillf Danton wrote:
> On Sun, 11 Aug 2019 08:24:09 +0800
>>
>> syzbot has found a reproducer for the following crash on:
>>
>> HEAD commit:    451577f3 Merge tag 'kbuild-fixes-v5.3-3' of git://git.kern..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=120850a6600000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=2031e7d221391b8a
>> dashboard link: https://syzkaller.appspot.com/bug?extid=bd3bba6ff3fcea7a6ec6
>> compiler:       clang version 9.0.0 (/home/glider/llvm/clang 80fee25776c2fb61e74c1ecb1a523375c2500b69)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=130ffe4a600000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17137d2c600000
>>
>> The bug was bisected to:
>>
>> commit a0b0fd53e1e67639b303b15939b9c653dbe7a8c4
>> Author: Bart Van Assche <bvanassche@acm.org>
>> Date:   Thu Feb 14 23:00:46 2019 +0000
>>
>>       locking/lockdep: Free lock classes that are no longer in use

Hey Bart, don't think it's related in any way to your commit. I'll allocate some
time on working on this issue today, thanks!

>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152f6a9da00000
>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=172f6a9da00000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=132f6a9da00000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com
>> Fixes: a0b0fd53e1e6 ("locking/lockdep: Free lock classes that are no longer in use")
>>
>> WARNING: CPU: 0 PID: 9604 at kernel/bpf/core.c:851 bpf_jit_free+0x1a8/0x1f0
>> Kernel panic - not syncing: panic_on_warn set ...
>> CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> Google 01/01/2011
>> Workqueue: events bpf_prog_free_deferred
>> Call Trace:
>>    __dump_stack lib/dump_stack.c:77 [inline]
>>    dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
>>    panic+0x25c/0x799 kernel/panic.c:219
>>    __warn+0x22f/0x230 kernel/panic.c:576
>>    report_bug+0x190/0x290 lib/bug.c:186
>> BUG: unable to handle page fault for address: fffffbfff4001000
>> #PF: supervisor read access in kernel mode
>> #PF: error_code(0x0000) - not-present page
>> PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD 936de067 PTE 0
>> Oops: 0000 [#1] PREEMPT SMP KASAN
>> CPU: 0 PID: 9604 Comm: kworker/0:5 Not tainted 5.3.0-rc3+ #71
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> Google 01/01/2011
>> Workqueue: events bpf_prog_free_deferred
>> RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
>> RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
>> RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
>> RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
>> RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
>> RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
>> Code: 85 c4 f5 ff 4d 39 f4 76 10 e8 7b c2 f5 ff 49 83 c7 10 eb 46 0f 1f 44
>> 00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84
>> c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
>> RSP: 0018:ffff888097eff828 EFLAGS: 00010806
>> RAX: 1ffffffff4001000 RBX: 0000000000000001 RCX: dffffc0000000000
>> RDX: ffff88809f1e0280 RSI: ffffffffff7a5520 RDI: ffffffffa0008000
>> RBP: ffff888097eff860 R08: ffffffff817dc73b R09: 0000000000000001
>> R10: fffffbfff117be6d R11: 0000000000000000 R12: ffffffffa0008000
>> R13: 0000000000000000 R14: ffffffffff7a5520 R15: ffff88809a46b2f8
>> FS:  0000000000000000(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: fffffbfff4001000 CR3: 0000000095d73000 CR4: 00000000001406f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
> [pruned]
> 
> Pair bpf_prog_kallsyms_del_all() with bpf_prog_free() to silence
> WARNING at kernel/bpf/core.c:851, see __bpf_prog_release() in
> net/core/filter.c for why.
> 
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1987,6 +1987,7 @@ void bpf_prog_free(struct bpf_prog *fp)
>   {
>   	struct bpf_prog_aux *aux = fp->aux;
>   
> +	bpf_prog_kallsyms_del_all(fp);
>   	INIT_WORK(&aux->work, bpf_prog_free_deferred);
>   	schedule_work(&aux->work);
>   }
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1328,7 +1328,6 @@ static void __bpf_prog_put(struct bpf_pr
>   		perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_UNLOAD, 0);
>   		/* bpf_prog_free_id() must be called first */
>   		bpf_prog_free_id(prog, do_idr_lock);
> -		bpf_prog_kallsyms_del_all(prog);
>   		btf_put(prog->aux->btf);
>   		kvfree(prog->aux->func_info);
>   		bpf_prog_free_linfo(prog);
> --
> 

