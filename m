Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66066305428
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbhA0HNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbhA0HJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 02:09:24 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356F7C06174A
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 23:08:44 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id e9so538706plh.3
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 23:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KvJIrN7dpSbC4mUaeerHgUdiYjp0w1FZlCWyLCYz8BY=;
        b=bPY8wty7wmMyTe/xjPgUdFU8kOd+VjestEJzdGhbLFZZnD3JFK3wQxL0jhwkEY/y9J
         PHDJCRZ/CBgJuJvoT5CKO7vWZxRhIC7oDMyil3/FMfo1ZemGer7PmqEJVutgh6wnyWH8
         tNYvZRfX4859X4FQKlB89ppMetSaWmDQCZMHJ1FlYyxNmyOy+CJp76JjFJg9P8i9h9Uo
         JMK4Us6f+/55aICxlDrLflrNnowxLDsvQkyReyHAO19TmHWb1nIdP8AlwJ8H30+AJE+k
         u9U+7oQaLXKHQf/Uk288FWnMKxaiLmuosnvpc+cmDzQjN5aNtQIDWLJMTOOE6M8ybguF
         ctEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KvJIrN7dpSbC4mUaeerHgUdiYjp0w1FZlCWyLCYz8BY=;
        b=OnxV16KLWVjqGo74KHgA8Gz8CohqYa8fBfhjkc+ACZvUjr+kNZJv0JdcqaxObRwYYU
         ClMpcvybTW4WwWCIvtCqlzz6M2iRm0EWXUVV54UfnTgjqWaPnOVkoxAU1lph8FJkSRVs
         AgVCEP6wKESNiM/WhdafrWxU1e3fTadLihT6113g6R/OONSLVU0uJ4ZSlVWLKgy9l5MA
         m1ZgQIPm9WZ3PhCXpHkSgWF86kVEIAW011sRsLMmV2qXsi5RiGh3KgzsjWe8d1N9Yyr2
         qFMdo3vW3mx3c2WrLwrxTLFSQHlyBC2RqaUVxNiQNKRXfLdTb7AJCWMkR+9mNzXZjr/O
         7+LQ==
X-Gm-Message-State: AOAM530fod183nPmofRokgiyp3x8EgqTls8diRkQkRATryHx4ja+3J05
        e6t/M4HH8TDjPzCeELp+XLJiBQ==
X-Google-Smtp-Source: ABdhPJxf7E8TMdjCREOKDfxVGq51H1oIeHNFvyDpg3tVz9oRQ/Q1abQVbWmKf+uEK9bFnkvTnQBGjw==
X-Received: by 2002:a17:90a:4209:: with SMTP id o9mr4223181pjg.75.1611731323537;
        Tue, 26 Jan 2021 23:08:43 -0800 (PST)
Received: from [192.168.10.23] (124-171-107-241.dyn.iinet.net.au. [124.171.107.241])
        by smtp.gmail.com with UTF8SMTPSA id 21sm1134342pfh.56.2021.01.26.23.08.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 23:08:42 -0800 (PST)
Subject: Re: [PATCH v2] tracepoint: Do not fail unregistering a probe due to
 memory allocation
To:     Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Matt Mullins <mmullins@mmlx.us>, paulmck <paulmck@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20201117211836.54acaef2@oasis.local.home>
 <CAADnVQJekaejHo0eTnnUp68tOhwUv8t47DpGoOgc9Y+_19PpeA@mail.gmail.com>
 <20201118074609.20fdf9c4@gandalf.local.home>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Message-ID: <5ca3fcc1-b8fb-546e-5e75-3684efb19a6f@ozlabs.ru>
Date:   Wed, 27 Jan 2021 18:08:34 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <20201118074609.20fdf9c4@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/11/2020 23:46, Steven Rostedt wrote:
> On Tue, 17 Nov 2020 20:54:24 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
>>>   extern int
>>> @@ -310,7 +312,12 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
>>>                  do {                                                    \
>>>                          it_func = (it_func_ptr)->func;                  \
>>>                          __data = (it_func_ptr)->data;                   \
>>> -                       ((void(*)(void *, proto))(it_func))(__data, args); \
>>> +                       /*                                              \
>>> +                        * Removed functions that couldn't be allocated \
>>> +                        * are replaced with TRACEPOINT_STUB.           \
>>> +                        */                                             \
>>> +                       if (likely(it_func != TRACEPOINT_STUB))         \
>>> +                               ((void(*)(void *, proto))(it_func))(__data, args); \
>>
>> I think you're overreacting to the problem.
> 
> I will disagree with that.
> 
>> Adding run-time check to extremely unlikely problem seems wasteful.
> 
> Show me a real benchmark that you can notice a problem here. I bet that
> check is even within the noise of calling an indirect function. Especially
> on a machine with retpolines.
> 
>> 99.9% of the time allocate_probes() will do kmalloc from slab of small
>> objects.
>> If that slab is out of memory it means it cannot allocate a single page.
>> In such case so many things will be failing to alloc that system
>> is unlikely operational. oom should have triggered long ago.
>> Imo Matt's approach to add __GFP_NOFAIL to allocate_probes()
> 
> Looking at the GFP_NOFAIL comment:
> 
>   * %__GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
>   * cannot handle allocation failures. The allocation could block
>   * indefinitely but will never return with failure. Testing for
>   * failure is pointless.
>   * New users should be evaluated carefully (and the flag should be
>   * used only when there is no reasonable failure policy) but it is
>   * definitely preferable to use the flag rather than opencode endless
>   * loop around allocator.
> 
> I realized I made a mistake in my patch for using it, as my patch is a
> failure policy. It looks like something we want to avoid in general.
> 
> Thanks, I'll send a v3 that removes it.
> 
>> when it's called from func_remove() is much better.
>> The error was reported by syzbot that was using
>> memory fault injections. ENOMEM in allocate_probes() was
>> never seen in real life and highly unlikely will ever be seen.
> 
> And the biggest thing you are missing here, is that if you are running on a
> machine that has static calls, this code is never hit unless you have more
> than one callback on a single tracepoint. That's because when there's only
> one callback, it gets called directly, and this loop is not involved.


I am running syzkaller and the kernel keeps crashing in 
__traceiter_##_name. This patch makes these crashes happen lot less 
often (and so did the v1) but the kernel still crashes (examples below 
but the common thing is that they crash in tracepoints). Disasm points 
to __DO_TRACE_CALL(name) and this fixes it:

========================
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -313,6 +313,7 @@ static inline struct tracepoint 
*tracepoint_ptr_deref(tracepoint_ptr_t *p)
                                                                         \
                 it_func_ptr =                                           \
 
rcu_dereference_raw((&__tracepoint_##_name)->funcs); \
+               if (it_func_ptr)                                        \
                 do {                                                    \
                         it_func = (it_func_ptr)->func;                  \
========================

I am running on a powerpc box which does not have CONFIG_HAVE_STATIC_CALL.

I wonder if it is still the same problem which mentioned v3 might fix or 
it is something different? Thanks,



[  285.072538] Kernel attempted to read user page (0) - exploit attempt? 
(uid: 0)
[  285.073657] BUG: Kernel NULL pointer dereference on read at 0x00000000
[  285.075129] Faulting instruction address: 0xc0000000002edf48
cpu 0xd: Vector: 300 (Data Access) at [c0000000115db530]
     pc: c0000000002edf48: lock_acquire+0x2e8/0x5d0
     lr: c0000000006ee450: step_into+0x940/0xc20
     sp: c0000000115db7d0
    msr: 8000000000009033
    dar: 0
  dsisr: 40000000
   current = 0xc0000000115af280
   paca    = 0xc00000005ff9fe00	 irqmask: 0x03	 irq_happened: 0x01
     pid   = 182, comm = systemd-journal
Linux version 5.11.0-rc5-le_syzkaller_a+fstn1 (aik@fstn1-p1) (gcc 
(Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0, GNU ld (GNU Binutils for Ubuntu) 
2.30) #65 SMP Wed Jan 27 16:46:46 AEDT 2021
enter ? for help
[c0000000115db8c0] c0000000006ee450 step_into+0x940/0xc20
[c0000000115db950] c0000000006efddc walk_component+0xbc/0x340
[c0000000115db9d0] c0000000006f0418 link_path_walk.part.29+0x3b8/0x5b0
[c0000000115dbaa0] c0000000006f0b1c path_openat+0x11c/0x1190
[c0000000115dbb40] c0000000006f4334 do_filp_open+0xb4/0x180
[c0000000115dbc80] c0000000006c83cc do_sys_openat2+0x48c/0x610
[c0000000115dbd20] c0000000006caf9c do_sys_open+0xcc/0x140
[c0000000115dbdb0] c00000000004ba48 system_call_exception+0x178/0x2b0
[c0000000115dbe10] c00000000000e060 system_call_common+0xf0/0x27c
--- Exception: c00 (System Call) at 00007fff7fb3e758
SP (7ffff28e2900) is in userspace




[   92.747130] FAT-fs (loop7): bogus number of reserved sectors
[   92.747193] Kernel attempted to read user page (0) - exploit attempt? 
(uid: 0)
[   92.748393] FAT-fs (loop7): Can't find a valid FAT filesystem
[   92.750579] BUG: Kernel NULL pointer dereference on read at 0x00000000
[   92.751855] Faulting instruction address: 0xc0000000002ed928
cpu 0xd: Vector: 300 (Data Access) at [c00000001138f5c0]
     pc: c0000000002ed928: lock_release+0x138/0x470
     lr: c0000000002e0084: up_write+0x34/0x1e0
     sp: c00000001138f860
    msr: 8000000000009033
    dar: 0
  dsisr: 40000000
   current = 0xc00000004fe7b480
   paca    = 0xc00000005ff9fe00	 irqmask: 0x03	 irq_happened: 0x01
     pid   = 10670, comm = syz-executor.3
Linux version 5.11.0-rc5-le_syzkaller_a+fstn1 (aik@fstn1-p1) (gcc 
(Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0, GNU ld (GNU Binutils for Ubuntu) 
2.30) #65 SMP Wed Jan 27 16:46:46 AEDT 2021
enter ? for help
[c00000001138f910] c0000000002e0084 up_write+0x34/0x1e0
[c00000001138f980] c0000000006151fc anon_vma_clone+0x1ec/0x370
[c00000001138f9f0] c00000000060180c __split_vma+0x11c/0x340
[c00000001138fa40] c000000000601cb0 __do_munmap+0x1c0/0x920
[c00000001138fad0] c000000000604d20 mmap_region+0x3b0/0xae0
[c00000001138fbd0] c0000000006059d4 do_mmap+0x584/0x830
[c00000001138fc60] c0000000005b0f90 vm_mmap_pgoff+0x170/0x260
[c00000001138fcf0] c000000000600818 ksys_mmap_pgoff+0x198/0x3a0
[c00000001138fd60] c0000000000155ec sys_mmap+0xcc/0x150
[c00000001138fdb0] c00000000004ba48 system_call_exception+0x178/0x2b0
[c00000001138fe10] c00000000000e060 system_call_common+0xf0/0x27c
--- Exception: c00 (System Call) at 0000000010058ad0
SP (7fffae45e1c0) is in userspace


-- 
Alexey
