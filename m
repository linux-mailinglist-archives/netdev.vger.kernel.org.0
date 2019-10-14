Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80B06D59EF
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 05:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbfJNDZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 23:25:53 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37702 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729621AbfJNDZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 23:25:52 -0400
Received: by mail-pf1-f195.google.com with SMTP id y5so9566803pfo.4
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 20:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=GA5CMCYv+aCORsobJciBjW8WSvyPJCL/etTu+2Xao0E=;
        b=unP7vvJRnu+zMoulLwliLfv2kJBe3WrUAVyNfCnYlfsyOJ4w5864+4p+IRekmEXVS2
         cJrmIrKwR0Px8qUOMtVuUql5asPPC1APvNGnix1BMIWVsK79y7tnRhDtRORWmjtruGgJ
         WCYAvbIarNXqC2eWkfcIb8S37xdYcVRf7YiQmL5+LgiEKS3f45BPrbml5IE5ot+Xmhlt
         u1cXe8t9y7bFYJGZ/u9TmXYYBS9DbrccxeMLgxaX8AZk9aclyY7QfPWhKcHswDbTTMcD
         mebdscoYaQm/CoyEI945SnMqxnBnTcWTFOnkVrQAJOUtcYq0v29VwDx1YFBfuDkbLgrI
         /4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GA5CMCYv+aCORsobJciBjW8WSvyPJCL/etTu+2Xao0E=;
        b=RQfSynQuDtvbndq8KxsQVGI3XeOUv5jH0EpzbHo4l56NnZZX6VAGVITCo89t6QxCbY
         QUkqHEX5ajJO2ePFmYCipk0O19ej0CpUSg1qVAEgLNruJxzzAPWXmFR6XyxlYcN49Fkd
         D6norqzKjzIdTghhhZ/0FEU4bIzo9ukrIz9Xk0UeTyp26Dz3zrgzKP457Ff1weXMAvpP
         0J3oTujpO2BzSZfKX556q2a+G7fs2eQYEHXkX9Q7qC5hIUyeuQQjTr9Vn2UnNKkEs0hX
         /yxfrSZ22gELVsv+U/+at+CltkbIHPczqD/VdFg95PI4F9JiSrJn26I+vfgXAGtarVZQ
         VUVA==
X-Gm-Message-State: APjAAAXFU3lIF9l+KMU9V+MoctGwJURBZyCk743a82EIoKj0/L4VGXU5
        u+dC8EbLiKVS0utTd8cMPulFHw==
X-Google-Smtp-Source: APXvYqyrzC+bej9uNMmO5Sy36j9cfD3J8fx+Gtc5WDiLSGk8AjEAHUr479E7aeA/mgRIo9joiXXdAg==
X-Received: by 2002:a63:b551:: with SMTP id u17mr2076746pgo.88.1571023550387;
        Sun, 13 Oct 2019 20:25:50 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id k15sm16983899pgt.25.2019.10.13.20.25.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Oct 2019 20:25:49 -0700 (PDT)
Subject: Re: WARNING: refcount bug in sock_wfree (2)
To:     syzbot <syzbot+c0ba5b9e742f049a2edf@syzkaller.appspotmail.com>,
        davem@davemloft.net, hare@suse.com, jmoyer@redhat.com,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <0000000000006819150594d5e956@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0ba7cb74-507e-7fb5-6147-1d5fee34155f@kernel.dk>
Date:   Sun, 13 Oct 2019 21:25:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0000000000006819150594d5e956@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/19 8:49 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    442630f6 Add linux-next specific files for 20191008
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=158fa6bf600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=af1bfeef713eefdd
> dashboard link: https://syzkaller.appspot.com/bug?extid=c0ba5b9e742f049a2edf
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15a861b3600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1769f48b600000
> 
> The bug was bisected to:
> 
> commit 6c080ff07363389cb4092193eb333639f0392b8c
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Thu Oct 3 14:11:03 2019 +0000
> 
>       io_uring: allow sparse fixed file sets
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1344b993600000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=10c4b993600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1744b993600000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+c0ba5b9e742f049a2edf@syzkaller.appspotmail.com
> Fixes: 6c080ff07363 ("io_uring: allow sparse fixed file sets")
> 
> ------------[ cut here ]------------
> refcount_t: underflow; use-after-free.
> WARNING: CPU: 0 PID: 8691 at lib/refcount.c:190
> refcount_sub_and_test_checked lib/refcount.c:190 [inline]
> WARNING: CPU: 0 PID: 8691 at lib/refcount.c:190
> refcount_sub_and_test_checked+0x1d0/0x200 lib/refcount.c:180
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 0 PID: 8691 Comm: syz-executor322 Not tainted 5.4.0-rc2-next-20191008
> #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>    __dump_stack lib/dump_stack.c:77 [inline]
>    dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>    panic+0x2e3/0x75c kernel/panic.c:221
>    __warn.cold+0x2f/0x35 kernel/panic.c:582
>    report_bug+0x289/0x300 lib/bug.c:195
>    fixup_bug arch/x86/kernel/traps.c:174 [inline]
>    fixup_bug arch/x86/kernel/traps.c:169 [inline]
>    do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
>    do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
>    invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
> RIP: 0010:refcount_sub_and_test_checked lib/refcount.c:190 [inline]
> RIP: 0010:refcount_sub_and_test_checked+0x1d0/0x200 lib/refcount.c:180
> Code: 1d b0 f0 7f 06 31 ff 89 de e8 6c d7 30 fe 84 db 75 94 e8 23 d6 30 fe
> 48 c7 c7 20 81 e6 87 c6 05 90 f0 7f 06 01 e8 e8 15 02 fe <0f> 0b e9 75 ff
> ff ff e8 04 d6 30 fe e9 6e ff ff ff 48 89 df e8 e7
> RSP: 0018:ffff8880a8267a28 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff815cb676 RDI: ffffed101504cf37
> RBP: ffff8880a8267ac0 R08: ffff888090e363c0 R09: fffffbfff14eeb42
> R10: fffffbfff14eeb41 R11: ffffffff8a775a0f R12: 00000000fffffd02
> R13: 0000000000000001 R14: ffff8880a8267a98 R15: 0000000000000001
>    sock_wfree+0x10c/0x190 net/core/sock.c:1958
>    unix_destruct_scm+0x115/0x170 net/unix/scm.c:149
>    io_destruct_skb+0x62/0x80 fs/io_uring.c:2995
>    skb_release_head_state+0xeb/0x260 net/core/skbuff.c:652
>    skb_release_all+0x16/0x60 net/core/skbuff.c:663
>    __kfree_skb net/core/skbuff.c:679 [inline]
>    kfree_skb net/core/skbuff.c:697 [inline]
>    kfree_skb+0x101/0x3c0 net/core/skbuff.c:691
>    __io_sqe_files_scm+0x429/0x640 fs/io_uring.c:3049
>    io_sqe_files_scm fs/io_uring.c:3071 [inline]
>    io_sqe_files_register fs/io_uring.c:3154 [inline]
>    __io_uring_register+0x1f69/0x2d70 fs/io_uring.c:4152
>    __do_sys_io_uring_register fs/io_uring.c:4204 [inline]
>    __se_sys_io_uring_register fs/io_uring.c:4186 [inline]
>    __x64_sys_io_uring_register+0x193/0x1f0 fs/io_uring.c:4186
>    do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x440279
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffeeedc31e8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440279
> RDX: 0000000020000280 RSI: 0000000000000002 RDI: 0000000000000003
> RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000401b00
> R13: 0000000000401b90 R14: 0000000000000000 R15: 0000000000000000
> Kernel Offset: disabled
> Rebooting in 86400 seconds..

I think this will do it, but that's just from looking at the code,
haven't tried to reproduce anything yet.

I'll take a closer look tomorrow and verify.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0b20b3599b01..52daeb71ee27 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3016,7 +3016,6 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 	}
 
 	skb->sk = sk;
-	skb->destructor = io_destruct_skb;
 
 	nr_files = 0;
 	fpl->user = get_uid(ctx->user);
@@ -3031,6 +3030,7 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 	if (nr_files) {
 		fpl->max = fpl->count = nr_files;
 		UNIXCB(skb).fp = fpl;
+		skb->destructor = io_destruct_skb;
 		refcount_add(skb->truesize, &sk->sk_wmem_alloc);
 		skb_queue_head(&sk->sk_receive_queue, skb);
 

-- 
Jens Axboe

