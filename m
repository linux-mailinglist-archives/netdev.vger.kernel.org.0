Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F18316E8F
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbhBJS0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbhBJSYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 13:24:23 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3728C061788;
        Wed, 10 Feb 2021 10:23:42 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id o15so834445wmq.5;
        Wed, 10 Feb 2021 10:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CdBsBnJwl+BS8FihCKmsZbFb/tYHU132d5H7XgeWACY=;
        b=U15VVGoljDYUQOaU5sDAIVb3uvCVyUMCPSOxjwCb1KzY2CR5gmGquUKhUvNOAtAAna
         Aag7dF9Gw+ei/FGbq+AImycLgpbKWiPVt7JIToQJCGQzg8E/zvb1EDrCequANh52psHg
         w0DYl6G8gscntTn7xS9iB0Aiy6irCAM91iEOHHGo2glsnhglGUBpr3VLOuVo4siv3u4W
         xhLbn1JV6iceK4cduDi38506bm68HQQ3OXxgrhu1w7SzX0FCIVdQi1r44L1Qp7dvYgiN
         qJw0xeYsja2IcuadajAzqi9gH3ObJpZmsOQ6lEWuEPUJneJE3CBBUn90/XWLbA7rL1oL
         oEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CdBsBnJwl+BS8FihCKmsZbFb/tYHU132d5H7XgeWACY=;
        b=V4yUE3MhTj48pREgn4GrvTpSnT7MrO6r0NHihey7udTx8OU0x0w98jx0uOOlOFhkf3
         un9rSLMae66KOuPe1rJCJG1eh2Hu5zjuKwJxWOl1iSS07wrGUMEOIdPk5Qz0HxNS2rom
         dWF/Oqbr8Zus8AUV+5cguhkZq5bjSXjnMSqyYRMv5hYJb74iuvzMiO2bhI6wtxydhNkk
         cSmvYm65b7a1+Lc6bkp7+5ihK6Ov7frnD2Nn8PsW7mrhnpSmP4E36keExuq9j53dN8E3
         DF5QLJc47tpsojwwtXU11GkLKZcM3NO6GzoI974yOVlYZwApr8Q0klR29E+DYx0+eH2Y
         gApQ==
X-Gm-Message-State: AOAM533Tz39lQDGZbZP1Nmd+N4HEQgTm5/eblRuBzIpaWKEOX7paa812
        aFINsgosnHVKtrj8/kPNxXY=
X-Google-Smtp-Source: ABdhPJyEsFslrLF8BdJCt4pySRMF+u9JLA9NjUEN2Q6w7mlB3R/gC1qzGh+mzGZt16qOecGbVo45nQ==
X-Received: by 2002:a1c:9c06:: with SMTP id f6mr214023wme.72.1612981421607;
        Wed, 10 Feb 2021 10:23:41 -0800 (PST)
Received: from [192.168.1.101] ([37.166.86.204])
        by smtp.gmail.com with ESMTPSA id 13sm3342087wmj.11.2021.02.10.10.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 10:23:41 -0800 (PST)
Subject: Re: KASAN: vmalloc-out-of-bounds Read in bpf_trace_run3
To:     Yonghong Song <yhs@fb.com>, Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, andrii@kernel.org,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@redhat.com>, mmullins@fb.com,
        netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <00000000000004500b05b31e68ce@google.com>
 <CACT4Y+aBVQ6LKYf9wCV=AUx23xpWmb_6-mBqwkQgeyfXA3SS2A@mail.gmail.com>
 <20201113053722.7i4xkiyrlymcwebg@hydra.tuxags.com>
 <c63f89b2-0627-91d8-a609-3f2a3b5b5a2d@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7b0fe079-bcd3-484d-fda6-12d962f584f8@gmail.com>
Date:   Wed, 10 Feb 2021 19:23:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <c63f89b2-0627-91d8-a609-3f2a3b5b5a2d@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/13/20 5:08 PM, Yonghong Song wrote:
> 
> 
> On 11/12/20 9:37 PM, Matt Mullins wrote:
>> On Wed, Nov 11, 2020 at 03:57:50PM +0100, Dmitry Vyukov wrote:
>>> On Mon, Nov 2, 2020 at 12:54 PM syzbot
>>> <syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com> wrote:
>>>>
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    080b6f40 bpf: Don't rely on GCC __attribute__((optimize)) ..
>>>> git tree:       bpf
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=1089d37c500000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=58a4ca757d776bfe
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=d29e58bb557324e55e5e
>>>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f4b032500000
>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1371a47c500000
>>>>
>>>> The issue was bisected to:
>>>>
>>>> commit 9df1c28bb75217b244257152ab7d788bb2a386d0
>>>> Author: Matt Mullins <mmullins@fb.com>
>>>> Date:   Fri Apr 26 18:49:47 2019 +0000
>>>>
>>>>      bpf: add writable context for raw tracepoints
>>>
>>>
>>> We have a number of kernel memory corruptions related to bpf_trace_run now:
>>> https://groups.google.com/g/syzkaller-bugs/search?q=kernel/trace/bpf_trace.c
>>>
>>> Can raw tracepoints "legally" corrupt kernel memory (a-la /dev/kmem)?
>>> Or they shouldn't?
>>>
>>> Looking at the description of Matt's commit, it seems that corruptions
>>> should not be possible (bounded buffer, checked size, etc). Then it
>>> means it's a real kernel bug?
>>
>> This bug doesn't seem to be related to the writability of the
>> tracepoint; it bisected to that commit simply because it used
>> BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE for the reproducer and it EINVAL's
>> before that program type was introduced.  The BPF program it loads is
>> pretty much a no-op.
>>
>> The problem here is a kmalloc failure injection into
>> tracepoint_probe_unregister, but the error is ignored -- so the bpf
>> program is freed even though the tracepoint is never unregistered.
>>
>> I have a first pass at a patch to pipe through the error code, but it's
>> pretty ugly.  It's also called from the file_operations ->release(), for
> 
> Maybe you can still post the patch, so people can review and make suggestions which may lead to a *better* solution.


ping

This bug is still there.


> 
>> which errors are solidly ignored in __fput(), so I'm not sure what the
>> best way to handle ENOMEM is...
>>
>>>
>>>
>>>
>>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12b6c4da500000
>>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=11b6c4da500000
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=16b6c4da500000
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+d29e58bb557324e55e5e@syzkaller.appspotmail.com
>>>> Fixes: 9df1c28bb752 ("bpf: add writable context for raw tracepoints")
>>>>
>>>> ==================================================================
>>>> BUG: KASAN: vmalloc-out-of-bounds in __bpf_trace_run kernel/trace/bpf_trace.c:2045 [inline]
>>>> BUG: KASAN: vmalloc-out-of-bounds in bpf_trace_run3+0x3e0/0x3f0 kernel/trace/bpf_trace.c:2083
>>>> Read of size 8 at addr ffffc90000e6c030 by task kworker/0:3/3754
>>>>
>>>> CPU: 0 PID: 3754 Comm: kworker/0:3 Not tainted 5.9.0-syzkaller #0
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>> Workqueue:  0x0 (events)
>>>> Call Trace:
>>>>   __dump_stack lib/dump_stack.c:77 [inline]
>>>>   dump_stack+0x107/0x163 lib/dump_stack.c:118
>>>>   print_address_description.constprop.0.cold+0x5/0x4c8 mm/kasan/report.c:385
>>>>   __kasan_report mm/kasan/report.c:545 [inline]
>>>>   kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
>>>>   __bpf_trace_run kernel/trace/bpf_trace.c:2045 [inline]
>>>>   bpf_trace_run3+0x3e0/0x3f0 kernel/trace/bpf_trace.c:2083
>>>>   __bpf_trace_sched_switch+0xdc/0x120 include/trace/events/sched.h:138
>>>>   __traceiter_sched_switch+0x64/0xb0 include/trace/events/sched.h:138
>>>>   trace_sched_switch include/trace/events/sched.h:138 [inline]
>>>>   __schedule+0xeb8/0x2130 kernel/sched/core.c:4520
>>>>   schedule+0xcf/0x270 kernel/sched/core.c:4601
>>>>   worker_thread+0x14c/0x1120 kernel/workqueue.c:2439
>>>>   kthread+0x3af/0x4a0 kernel/kthread.c:292
>>>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
>>>>
>>>>
>>>> Memory state around the buggy address:
>>>>   ffffc90000e6bf00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>>>>   ffffc90000e6bf80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>>>>> ffffc90000e6c000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>>>>                                       ^
>>>>   ffffc90000e6c080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>>>>   ffffc90000e6c100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>>>> ==================================================================
> [...]
