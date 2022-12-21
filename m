Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F289652B88
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 03:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbiLUCmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 21:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLUCmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 21:42:54 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71E51D0EE
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 18:42:52 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id x3so6843pjv.4
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 18:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=OStSd32YplqutNgXvFahsrXJGNlcVFLY4LscMZH0nv0=;
        b=sN1cz4J6eT7EFe157PmafvjLNvNPsz4rEiWWNtSqYpqGQvtGm8KN5CnOv7jf6YKehs
         p6OmOUv53NIQgxFBpS0urwKIseyuGyzk/SW1jONEO7T/y+p1gM04ntOt1iRhemzw6gWU
         8iFxe74N3zHDbbhULKnsXdBY7WGHFAjTmEWqabZwbBmoC6V3XZXhE18Oop3JWJaGiuKh
         +4zfj5TZ88e2lQToLPpZ8Dd1L8DhIcj7xZ0/R+te0D1MzFhRyvYeGzHwstPKJWJDGTbH
         ilE46U3zMaBACcbFGDzGiQbjxBnYclFHhvF4g+Dp37AKjcyhrIyXi9dZtDAL2ScsyZoK
         PTMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OStSd32YplqutNgXvFahsrXJGNlcVFLY4LscMZH0nv0=;
        b=AU6IEeLoI1Hd8XaZCkTI80U9OnLxq4d/Rk7W7Pmu5/ZsswIwF8+li92y3bMPP6YZZT
         kf3+V9JFSyxgRS1uYBCOBOlVSsSOG5GT1/O2B4mwXF1Mi0uSe78uCYKdcQkh0C62jhKd
         6WkIAvhpEenMmb7Zrq7RoH3Vd0xe+Ycw4ElMmywprjKL3Lod5QI/LQ0dShuCNkQHzvj8
         m1OUmP3vFJK/S8IxgnLn0PbuLVwDXGeYdZd58i1urSHLHu2uE2lDL0dJhvhSHBocxylW
         nWAxlGLu/5iskhOdKu9Z3Y4UaIaZ4vh6a8Q26eI/BnvYR+WIAX84q1g9CQyM8H5hihBy
         oUmg==
X-Gm-Message-State: AFqh2kq/AXiVSqxMekmWeCxbV0MocuDwB7vtbOnr8SHBp5FgO4d2rXnq
        V+c/5lH1oKCHQPqrc8Bgo04THA==
X-Google-Smtp-Source: AMrXdXv1vJnW/Jn0Li+PENUoxvt8jTtf8bCjDmR5JOo5WmyOvS1uIP4t83g1WW9EekMeo72A8LQSWw==
X-Received: by 2002:a05:6a20:d39a:b0:9d:efbf:6618 with SMTP id iq26-20020a056a20d39a00b0009defbf6618mr605811pzb.38.1671590572269;
        Tue, 20 Dec 2022 18:42:52 -0800 (PST)
Received: from ?IPV6:2409:8a28:e63:2da0:b0e9:bb47:3cf6:6095? ([2409:8a28:e63:2da0:b0e9:bb47:3cf6:6095])
        by smtp.gmail.com with ESMTPSA id h10-20020a62830a000000b00574ffc5976fsm9354886pfe.159.2022.12.20.18.42.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 18:42:51 -0800 (PST)
From:   Chengming Zhou <zhouchengming@bytedance.com>
X-Google-Original-From: Chengming Zhou <chengming.zhou@linux.dev>
Message-ID: <3a5a4738-2868-8f2f-f8b2-a28c10fbe25b@linux.dev>
Date:   Wed, 21 Dec 2022 10:42:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [syzbot] KASAN: use-after-free Read in put_pmu_ctx
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        syzbot <syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000a20a2e05f029c577@google.com>
 <Y6B3xEgkbmFUCeni@hirez.programming.kicks-ass.net>
In-Reply-To: <Y6B3xEgkbmFUCeni@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/12/19 22:40, Peter Zijlstra wrote:
> On Mon, Dec 19, 2022 at 12:04:43AM -0800, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    13e3c7793e2f Merge tag 'for-netdev' of https://git.kernel...
>> git tree:       bpf
>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=177df7e0480000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=b0e91ad4b5f69c47
>> dashboard link: https://syzkaller.appspot.com/bug?extid=b8e8c01c8ade4fe6e48f
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e87100480000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ceeb13880000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/373a99daa295/disk-13e3c779.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/7fa71ed0fe17/vmlinux-13e3c779.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/2842ad5c698b/bzImage-13e3c779.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com
>>
>> ==================================================================
>> BUG: KASAN: use-after-free in __lock_acquire+0x3ee7/0x56d0 kernel/locking/lockdep.c:4925
>> Read of size 8 at addr ffff8880237d6018 by task syz-executor287/8300
>>
>> CPU: 0 PID: 8300 Comm: syz-executor287 Not tainted 6.1.0-syzkaller-09661-g13e3c7793e2f #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
>> Call Trace:
>>  <TASK>
>>  __dump_stack lib/dump_stack.c:88 [inline]
>>  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>>  print_address_description mm/kasan/report.c:284 [inline]
>>  print_report+0x15e/0x45d mm/kasan/report.c:395
>>  kasan_report+0xbf/0x1f0 mm/kasan/report.c:495
>>  __lock_acquire+0x3ee7/0x56d0 kernel/locking/lockdep.c:4925
>>  lock_acquire kernel/locking/lockdep.c:5668 [inline]
>>  lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
>>  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>>  _raw_spin_lock_irqsave+0x3d/0x60 kernel/locking/spinlock.c:162
>>  put_pmu_ctx kernel/events/core.c:4913 [inline]
>>  put_pmu_ctx+0xad/0x390 kernel/events/core.c:4893
>>  _free_event+0x3c5/0x13d0 kernel/events/core.c:5196
>>  free_event+0x58/0xc0 kernel/events/core.c:5224
>>  __do_sys_perf_event_open+0x66d/0x2980 kernel/events/core.c:12701
>>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Does this help?
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index e47914ac8732..bbff551783e1 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -12689,7 +12689,8 @@ SYSCALL_DEFINE5(perf_event_open,
>  	return event_fd;
>  
>  err_context:
> -	/* event->pmu_ctx freed by free_event() */
> +	put_pmu_ctx(event->pmu_ctx);
> +	event->pmu_ctx = NULL; /* _free_event() */
>  err_locked:
>  	mutex_unlock(&ctx->mutex);
>  	perf_unpin_context(ctx);

Tested-by: Chengming Zhou <zhouchengming@bytedance.com>

While reviewing the code, I found perf_event_create_kernel_counter()
has the similar problem in the "err_pmu_ctx" error handling path:

CPU0					CPU1
perf_event_create_kernel_counter()
  // inc ctx refcnt
  find_get_context(task, event) (1)

  // inc pmu_ctx refcnt
  pmu_ctx = find_get_pmu_context()

  event->pmu_ctx = pmu_ctx
  ...
  goto err_pmu_ctx:
    // dec pmu_ctx refcnt
    put_pmu_ctx(pmu_ctx) (2)

    mutex_unlock(&ctx->mutex)
    // dec ctx refcnt
    put_ctx(ctx)
					perf_event_exit_task_context()
					  mutex_lock()
					  mutex_unlock()
					  // last refcnt put
					  put_ctx()
    free_event(event)
      if (event->pmu_ctx) // True
        put_pmu_ctx() (3)
          // will access freed pmu_ctx or ctx

      if (event->ctx) // False
        put_ctx()

(3) has UAF problem since the pmu_ctx maybe freed in (2), so also
should have "event->pmu_ctx = NULL;" in (2).

