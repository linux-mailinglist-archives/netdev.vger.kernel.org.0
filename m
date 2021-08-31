Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEDF3FC0C0
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 04:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239387AbhHaCP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 22:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239380AbhHaCP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 22:15:26 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45E3C061764
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 19:14:31 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id m11so14403296ioo.6
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 19:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=w45JWDlt0vhgUxESpT+B1nBJn2/Ywxu3Hd7D6mtFCsk=;
        b=pUC1K9sZnqws5HK4X1IGqMHX3153nlTXaKgAUvcUy+u0ju6CK56m6ssTgOQ5JzurbV
         mcZRSv6W45fwP6JHg9y4UALfHb/+W/QTxuTuhMeqo4jgBBiQDs14vL6tG1TZ27aAo+pE
         19r8xcQ4pviy1o2JIbO3WU3PcfXrRbudZGiUK2U8qZYWqVmAKzttvF01A0eU8YvZoJTR
         MHBm+/6pvMqmo9y32Lg9hDes14zgdoKb6lEfRwt0TL6yqAKKABjEPqF6m7g6LRrFLFep
         DMCGGG7+d7B2eQMp7wQERoKLu8c7b0dkaVJaMrVGFvvOJ+IPkjpdQOcCM5Cy0jXQYPz2
         U5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w45JWDlt0vhgUxESpT+B1nBJn2/Ywxu3Hd7D6mtFCsk=;
        b=mMZNpCuy6H1VXmKeF/ZENNVtJ/bh3gitMqSky2XFWmq5ED0kmJQy9799X7fgj1ruCG
         Xc60AIIISi9zt4W1CYplizlJeJIj+ZJdqBqRYm3ujTExP+smfeHQVaIZqsTaCG8LiWc5
         jN8S8R+V5t6zH+gkwT11aZyH7UdYL5wBh9f/gSwSI96O3AsYzxuqjdRtofIRhrp/MwFz
         T+ins/eZk7wEMF+SXdr0m5TJQtB3I5pM6zGkOV4a43MOrnTu49guvn3nDgHp+lqVFRHt
         y73sPFnkzH/EdzNNMXbxcE+BpSigFEChfnOGNoFrhZzNASEhzes1WxK0GVoixAa8WA+9
         WOzA==
X-Gm-Message-State: AOAM533Y2iVj5bYwMvFQ0ZfPOvTVDQ8W5LulRXJxr6CaaF1wwDwUEN2L
        nfkZrTmmYghvTZMlC7gbY4qp7Yv59Gsusw==
X-Google-Smtp-Source: ABdhPJwOWL0ElFafqXDsaz7jVNEJ5b5BIc0bzOV1mLUrHPTeFfp83rpZxizK43GqJbuZnSLCDbmW5w==
X-Received: by 2002:a02:ce37:: with SMTP id v23mr567877jar.81.1630376071173;
        Mon, 30 Aug 2021 19:14:31 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id p16sm9618230ilg.32.2021.08.30.19.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 19:14:30 -0700 (PDT)
Subject: Re: [syzbot] general protection fault in sock_from_file
To:     syzbot <syzbot+f9704d1878e290eddf73@syzkaller.appspotmail.com>,
        andrii@kernel.org, asml.silence@gmail.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        dvyukov@google.com, io-uring@vger.kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        Hao Xu <haoxu@linux.alibaba.com>
References: <00000000000059117905cacce99e@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7949b7a0-fec1-34a7-aaf5-cbe07c6127ed@kernel.dk>
Date:   Mon, 30 Aug 2021 20:14:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000059117905cacce99e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/21 2:45 PM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    93717cde744f Add linux-next specific files for 20210830
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15200fad300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c643ef5289990dd1
> dashboard link: https://syzkaller.appspot.com/bug?extid=f9704d1878e290eddf73
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111f5f9d300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1651a415300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f9704d1878e290eddf73@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
> CPU: 0 PID: 6548 Comm: syz-executor433 Not tainted 5.14.0-next-20210830-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:sock_from_file+0x20/0x90 net/socket.c:505
> Code: f5 ff ff ff c3 0f 1f 44 00 00 41 54 53 48 89 fb e8 85 e9 62 fa 48 8d 7b 28 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 4f 45 31 e4 48 81 7b 28 80 f1 8a 8a 74 0c e8 58 e9
> RSP: 0018:ffffc90002caf8e8 EFLAGS: 00010206
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000005 RSI: ffffffff8713203b RDI: 0000000000000028
> RBP: ffff888019fc0780 R08: ffffffff899aee40 R09: ffffffff81e21978
> R10: 0000000000000027 R11: 0000000000000009 R12: dffffc0000000000
> R13: 1ffff110033f80f9 R14: 0000000000000003 R15: ffff888019fc0780
> FS:  00000000013b5300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000004ae0f0 CR3: 000000001d355000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  io_sendmsg+0x98/0x640 fs/io_uring.c:4681
>  io_issue_sqe+0x14de/0x6ba0 fs/io_uring.c:6578
>  __io_queue_sqe+0x90/0xb50 fs/io_uring.c:6864
>  io_req_task_submit+0xbf/0x1b0 fs/io_uring.c:2218
>  tctx_task_work+0x166/0x610 fs/io_uring.c:2143
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>  tracehook_notify_signal include/linux/tracehook.h:212 [inline]
>  handle_signal_work kernel/entry/common.c:146 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>  exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:209
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
>  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43fd49

Hao, this is due to:

commit a8295b982c46d4a7c259a4cdd58a2681929068a9
Author: Hao Xu <haoxu@linux.alibaba.com>
Date:   Fri Aug 27 17:46:09 2021 +0800

    io_uring: fix failed linkchain code logic

which causes some weirdly super long chains from that single sqe.
Can you take a look, please?

-- 
Jens Axboe

