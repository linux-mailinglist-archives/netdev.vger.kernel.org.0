Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1769054F4C
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 14:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731795AbfFYMtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 08:49:20 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34964 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731674AbfFYMtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 08:49:20 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so2868098wml.0;
        Tue, 25 Jun 2019 05:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4xUgT7aGCNMiM6+pJAlVCJdOnTAGvivpttC+lajH2Zk=;
        b=RMxaRX3I/OLifYCmIHSU3kqJ4b168Vo8N0BFMol+hKTY5YTpZkBTumY1mFAzZmD+O4
         P3C/8SdsZN8w4r1GdaHOyg8esQC10POUI0rK/YsnV1XEDZbE2jAhBKFSoWspCLnENx+O
         JjeQB9G4Q+fX7ijFEMK7wctWvU87pg0egPw/wFITvDu/I7HvDuR2zzQDy4VuyevGFn+Q
         Hlqywucr9eFmU96ieUVWKGBGKixuX9Dape1GLEUKrni5+dIPuvLyD9tQAf4PTe4kBdup
         wJhbxdgOwXSzLI+jf7NaX4ey0s0yIzpQ3JtSzxGoi4SIe6jXcGorwXuxTRbzycIelR8a
         fXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4xUgT7aGCNMiM6+pJAlVCJdOnTAGvivpttC+lajH2Zk=;
        b=jzkJqROruOaHumk2x+je3mjCQ1jKfx6zH5kiM+lR3WgIVK19I7qsEgRT0ZKfDmmFAN
         DdW34WaUuXCfDy2aJbuabkuEGm9bnHlGbbaLHuHhexu4LpMG33Wz57KaQRukFq/BRuPX
         QSjOt+UL9hA26WB0japPCVZCrLv327dsachmleQTeSS8GBiu1Kg7D2rbxkthBbcgPhHn
         BZDcSbA8/TIhesltloX6P+dfi0oZJ1k8ScTso48IXvhEvkSndrkaZ3EfRQ40mBCiL0LH
         qLjTd04gkaSS9QRJMFeXP1U/hTrz+wejgv0Mkr/jkTkMgsUFB/7lnhc2uAgU0BEBSzq+
         S43A==
X-Gm-Message-State: APjAAAUvdD6xYLFYeBJO0E4oZIR0BGSkZBmWYueil9Ll0mOO5DqVKa12
        dEhpvitYasO9kcgWrnTkw6jSu0Kq+XBHRol+vE0=
X-Google-Smtp-Source: APXvYqyK85BEt2usCU7nw683iQobdf3iUJnWwug9lnkrvy8wxZuZVoJRuIvq18hVNehfFJJUI7xcH4zBY28i/ubYmXg=
X-Received: by 2002:a7b:cd15:: with SMTP id f21mr18613977wmj.99.1561466957977;
 Tue, 25 Jun 2019 05:49:17 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000069c3140589f6d3b7@google.com>
In-Reply-To: <00000000000069c3140589f6d3b7@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 25 Jun 2019 20:49:06 +0800
Message-ID: <CADvbK_efF3owbMbeQbRMOvMZY3mzevxR7nzEcAJgJrEEdAYrpQ@mail.gmail.com>
Subject: Re: memory leak in sctp_get_port_local
To:     syzbot <syzbot+079bf326b38072f849d9@syzkaller.appspotmail.com>
Cc:     davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org,
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

On Wed, May 29, 2019 at 2:28 AM syzbot
<syzbot+079bf326b38072f849d9@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    cd6c84d8 Linux 5.2-rc2
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=101a184aa00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=64479170dcaf0e11
> dashboard link: https://syzkaller.appspot.com/bug?extid=079bf326b38072f849d9
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b5dbbca00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1038444aa00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+079bf326b38072f849d9@syzkaller.appspotmail.com
>
> : Permanently added '10.128.0.127' (ECDSA) to the list of known hosts.
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff8881288ca380 (size 64):
>    comm "softirq", pid 0, jiffies 4294944468 (age 13.410s)
>    hex dump (first 32 bytes):
>      21 4e 00 00 00 00 00 00 00 00 00 00 00 00 00 00  !N..............
>      28 ae 85 23 81 88 ff ff 00 00 00 00 00 00 00 00  (..#............
>    backtrace:
>      [<0000000054ece54d>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:55 [inline]
>      [<0000000054ece54d>] slab_post_alloc_hook mm/slab.h:439 [inline]
>      [<0000000054ece54d>] slab_alloc mm/slab.c:3326 [inline]
>      [<0000000054ece54d>] kmem_cache_alloc+0x134/0x270 mm/slab.c:3488
>      [<00000000d992ea84>] sctp_bucket_create net/sctp/socket.c:8395 [inline]
>      [<00000000d992ea84>] sctp_get_port_local+0x189/0x5b0
> net/sctp/socket.c:8142
>      [<0000000099206d90>] sctp_do_bind+0xcc/0x1e0 net/sctp/socket.c:402
>      [<00000000b8795757>] sctp_bind+0x44/0x70 net/sctp/socket.c:302
>      [<00000000672a44aa>] inet6_bind+0x40/0xb7 net/ipv6/af_inet6.c:445
>      [<0000000001400e1c>] __sys_bind+0x11c/0x140 net/socket.c:1659
>      [<00000000e69e8036>] __do_sys_bind net/socket.c:1670 [inline]
>      [<00000000e69e8036>] __se_sys_bind net/socket.c:1668 [inline]
>      [<00000000e69e8036>] __x64_sys_bind+0x1e/0x30 net/socket.c:1668
>      [<000000001644bb1f>] do_syscall_64+0x76/0x1a0
> arch/x86/entry/common.c:301
>      [<00000000199a1ea2>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
will post a fix for this:

@@ -4816,6 +4816,7 @@ static int sctp_setsockopt(struct sock *sk, int
level, int optname,
 static int sctp_connect(struct sock *sk, struct sockaddr *addr,
                        int addr_len, int flags)
 {
+       struct sctp_bind_addr *bp = &sctp_sk(sk)->ep->base.bind_addr;
        struct inet_sock *inet = inet_sk(sk);
        struct sctp_af *af;
        int err = 0;
@@ -4826,12 +4827,13 @@ static int sctp_connect(struct sock *sk,
struct sockaddr *addr,
                 addr, addr_len);

        /* We may need to bind the socket. */
-       if (!inet->inet_num) {
+       if (!bp->port) {
                if (sk->sk_prot->get_port(sk, 0)) {
                        release_sock(sk);
                        return -EAGAIN;
                }
                inet->inet_sport = htons(inet->inet_num);
+               bp->port = inet->inet_sport;
        }

>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
