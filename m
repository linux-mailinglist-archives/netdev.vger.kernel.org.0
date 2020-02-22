Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E43C168FB9
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 16:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgBVPUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 10:20:22 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37941 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbgBVPUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 10:20:21 -0500
Received: by mail-pf1-f196.google.com with SMTP id x185so2904842pfc.5;
        Sat, 22 Feb 2020 07:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ru+Vw7agmhTG8W/a2nuoGJhud5Ehrgi8xpe/PFioVF8=;
        b=AM5DoAixRn7om8sDs4gKgHTSCYOEhVe5Ws9MDQVVjp6GazhqUd2waFdYjspZRwJlZg
         8qUh7mKpz3+I2HnrW2PM49+00T+VgWLeDtO7stKJfpxX1YnskhsxYMyND0bWs9SsTxvl
         sJyHuyEz0u7+XMlCrVvlOajxFf9inph5W5/0PtzYilfk0UhPJRt+pF0OODQwf9roAH2G
         vl43IC6NrJgp71LTla03fGC2lUt/3rv1mFMA4/nqk28+G22if4l8e52uDaRc7ufEUkDo
         sIGQ3aEuemmgIIOASqTAQGd2QBMMjenwI3PjYg4PESMxxBCSKfXJ6NQ5m7w9tH/Ew4Uo
         9rwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ru+Vw7agmhTG8W/a2nuoGJhud5Ehrgi8xpe/PFioVF8=;
        b=twAXszAlrIAmx/7nQoRQi6pEHAxUVXuj+ITJR2XbWTujhDaBuvc7lY5WiRoxjWAVF+
         Xu4Jb5aJqmb/J4C0iverU1oxGu6NI0Jm5qwwHIUdId0Db/dIDElhmEvN/EM2s3o0YFTg
         ckbLBrJS/R2rG3by3Ac4W9Ls/ogY/0nk6Us/HHJI+HSbftcvLfDNEjQkQ6uyobiO5B1s
         dhZ/XnGPzRyx7L4AfARQOCORd7cjAe9X/2QPR2uLDtG9/T4hWfoFZ5brJWrJwM+O68RO
         MvV9vTYwSgUVEzSHdLmWNC+/TBFHY2jxnNGcLB62Cr815rWTK+ictp/Nfj5KsASm2L76
         mQww==
X-Gm-Message-State: APjAAAUJYuZhOU1koti3UFmcKeMdRxHaV/Ft9Mfc3k2behIprl8K8CHW
        KqOUewQgOk8XtcLIuRQ/egw=
X-Google-Smtp-Source: APXvYqzt6ckMBM+Xq28rIhsFUCTt7v68fDAKIcqpZp3mktojwRqXQ9XQctowL5VzUxVFL8u6SPv3BA==
X-Received: by 2002:a63:78c7:: with SMTP id t190mr45988115pgc.416.1582384820625;
        Sat, 22 Feb 2020 07:20:20 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h3sm6598766pfo.102.2020.02.22.07.20.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2020 07:20:19 -0800 (PST)
Subject: Re: BUG: sleeping function called from invalid context in
 lock_sock_nested (2)
To:     syzbot <syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com>,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, daniel@zonque.org, davem@davemloft.net,
        devicetree@vger.kernel.org, jdelvare@suse.com,
        john.fastabend@gmail.com, kafai@fb.com, kuba@kernel.org,
        linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <000000000000acd115059f2b8188@google.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <a723bea9-9355-2df7-d786-b0c6be22e203@roeck-us.net>
Date:   Sat, 22 Feb 2020 07:20:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <000000000000acd115059f2b8188@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/20 7:08 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    0a44cac8 Merge tag 'dma-mapping-5.6' of git://git.infradea..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=152eba29e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a61f2164c515c07f
> dashboard link: https://syzkaller.appspot.com/bug?extid=a5df189917e79d5e59c9
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117a0931e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17d8c109e00000
> 
> The bug was bisected to:
> 
> commit 5ac6badc5aa057ceb1d50c93326a81db6e89ad2f
> Author: Daniel Mack <daniel@zonque.org>
> Date:   Thu Jul 11 12:45:03 2019 +0000
> 
>      device-tree: bindinds: add NXP PCT2075 as compatible device to LM75
> 

Guess syzbot's bisect mechanism needs a bit of work.

Guenter

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15924629e00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=17924629e00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=13924629e00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com
> Fixes: 5ac6badc5aa0 ("device-tree: bindinds: add NXP PCT2075 as compatible device to LM75")
> 
> BUG: sleeping function called from invalid context at net/core/sock.c:2935
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2687, name: kworker/1:3
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<ffffffff867b39c7>] sock_hash_free+0xd7/0x460 net/core/sock_map.c:869
> CPU: 1 PID: 2687 Comm: kworker/1:3 Not tainted 5.6.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events bpf_map_free_deferred
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x1fb/0x318 lib/dump_stack.c:118
>   ___might_sleep+0x449/0x5e0 kernel/sched/core.c:6798
>   __might_sleep+0x8f/0x100 kernel/sched/core.c:6751
>   lock_sock_nested+0x36/0x120 net/core/sock.c:2935
>   lock_sock include/net/sock.h:1516 [inline]
>   sock_hash_free+0x200/0x460 net/core/sock_map.c:872
>   bpf_map_free_deferred+0xb2/0x110 kernel/bpf/syscall.c:474
>   process_one_work+0x7f5/0x10f0 kernel/workqueue.c:2264
>   worker_thread+0xbbc/0x1630 kernel/workqueue.c:2410
>   kthread+0x332/0x350 kernel/kthread.c:255
>   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

