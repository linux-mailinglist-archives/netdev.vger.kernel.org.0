Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11EFC10084F
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 16:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbfKRPdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 10:33:47 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38839 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfKRPdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 10:33:46 -0500
Received: by mail-wr1-f65.google.com with SMTP id i12so20022379wro.5;
        Mon, 18 Nov 2019 07:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MC6hbelJpY2ihrrZxRWmuxB6g8NUSOV+ALxeQ6r9VWQ=;
        b=MBWGoonp2fPSzTPfLv5UodPdUBVdO9DNIjtTUdHD3x1++MPH69k+yr/Sj8x+Rswe1S
         3nH7BWI4t7TRnYcqvFeN/KhOQx2ufrjKQN+trqtHG3gy5Tdisd+EMCHcvSjSYThPWZwa
         GTTyaVnoxVqKu76XondIew0qvA/bQY3SeyOyth6Fa3dHA5T0ozIK6gVAugPdF0YkLDaT
         Q1GP2ehRir+tny0fyRrD6lMsjonbKT9jfHcpMUqfb8qZrJ8OBBadRQhZHAT3wwxLt0xZ
         rIZD/5oSRjubSmewpIN2UTf2VRfwE3ORB62jDn2tMRym/x0tviJvKoST2e3bQShGymkz
         maWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MC6hbelJpY2ihrrZxRWmuxB6g8NUSOV+ALxeQ6r9VWQ=;
        b=sp0BO9EXsyRlZ0hXY/Cwcz/SVblAC9BvjkDOieUxPxzv3cHDZBahPsAFc05ywdjokz
         MLOdpiSdR06fglWhYHvd0U8gQEMCV7OP/Gkm17QNgItJJGCxCwv6ncmuxh1iIsNQu+mz
         ISFIAKyh7WmE9oecL5MjRJWSp4LE1+0yXOslcpftpvWaDh/GWIJ7X3Wo8WsPuRdhCVjf
         gvTNpFP9bvUFxPmBb/uz1upP0JtT80IXTuJskdNyQbuAl0Mgy0S3/TM54vjwRKR7UJYW
         ZzwP5F4iWEfaDDifGz8DTtCR8Acu5URVwjmE0qGVENVROSYchMONEDOBlkdqT3gtCeZn
         NpXA==
X-Gm-Message-State: APjAAAWIJemLw9oGycBN1G+dUciktc+c1YcJZJIj2HPWhUeRPY7Yg0YK
        /jN5hntj4pKz87ykgZ78mqnYOVx9s/4Bj+zqDEhEUG/s
X-Google-Smtp-Source: APXvYqwMkQ61SZE/unmkSuy7n8X+6Fo7163ycOi1Eh3qM2kQnbY22m+fSOWQ7Y0wal0pClszXxLPGKpSxuONZWtrtfA=
X-Received: by 2002:a5d:5224:: with SMTP id i4mr15741630wra.303.1574091223130;
 Mon, 18 Nov 2019 07:33:43 -0800 (PST)
MIME-Version: 1.0
References: <0000000000005927bf0596c634a2@google.com>
In-Reply-To: <0000000000005927bf0596c634a2@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 18 Nov 2019 23:34:34 +0800
Message-ID: <CADvbK_fAqKgt0JLT+Bcmsqoqc81ehZJ-g6StMB+G3+WKO68SUw@mail.gmail.com>
Subject: Re: KCSAN: data-race in sctp_assoc_migrate / sctp_hash_obj
To:     syzbot <syzbot+e3b35fe7918ff0ee474e@syzkaller.appspotmail.com>
Cc:     davem <davem@davemloft.net>, elver@google.com,
        LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 2:56 AM syzbot
<syzbot+e3b35fe7918ff0ee474e@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    05f22368 x86, kcsan: Enable KCSAN for x86
> git tree:       https://github.com/google/ktsan.git kcsan
> console output: https://syzkaller.appspot.com/x/log.txt?x=1046796ce00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=87d111955f40591f
> dashboard link: https://syzkaller.appspot.com/bug?extid=e3b35fe7918ff0ee474e
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+e3b35fe7918ff0ee474e@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KCSAN: data-race in sctp_assoc_migrate / sctp_hash_obj
looks we need a better way to get netns in sctp_hash_obj(),
I believe in sctp_hash_cmp(), too.

>
> write to 0xffff8880b67c0020 of 8 bytes by task 18908 on cpu 1:
>   sctp_assoc_migrate+0x1a6/0x290 net/sctp/associola.c:1091
>   sctp_sock_migrate+0x8aa/0x9b0 net/sctp/socket.c:9465
>   sctp_accept+0x3c8/0x470 net/sctp/socket.c:4916
>   inet_accept+0x7f/0x360 net/ipv4/af_inet.c:734
>   __sys_accept4+0x224/0x430 net/socket.c:1754
>   __do_sys_accept net/socket.c:1795 [inline]
>   __se_sys_accept net/socket.c:1792 [inline]
>   __x64_sys_accept+0x4e/0x60 net/socket.c:1792
>   do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> read to 0xffff8880b67c0020 of 8 bytes by task 12003 on cpu 0:
>   sctp_hash_obj+0x4f/0x2d0 net/sctp/input.c:894
>   rht_key_get_hash include/linux/rhashtable.h:133 [inline]
>   rht_key_hashfn include/linux/rhashtable.h:159 [inline]
>   rht_head_hashfn include/linux/rhashtable.h:174 [inline]
>   head_hashfn lib/rhashtable.c:41 [inline]
>   rhashtable_rehash_one lib/rhashtable.c:245 [inline]
>   rhashtable_rehash_chain lib/rhashtable.c:276 [inline]
>   rhashtable_rehash_table lib/rhashtable.c:316 [inline]
>   rht_deferred_worker+0x468/0xab0 lib/rhashtable.c:420
>   process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
>   worker_thread+0xa0/0x800 kernel/workqueue.c:2415
>   kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
>
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 0 PID: 12003 Comm: kworker/0:6 Not tainted 5.4.0-rc3+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: events rht_deferred_worker
> ==================================================================
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
