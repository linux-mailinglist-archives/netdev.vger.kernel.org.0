Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6F32C11F9
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 18:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388300AbgKWRbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:31:17 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:37039 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729740AbgKWRbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 12:31:17 -0500
Received: by mail-il1-f199.google.com with SMTP id u17so14491151ilb.4
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 09:31:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=p06mNsn62UzYbRGqsC6k1rWTPNotjmZgU3HzwqNYA9c=;
        b=PqMQMz85dU35O20rye4abwUeo2EUBTEd1sszEqdoQPYRNH0aoGdGh5nEC5VDzHkmb7
         EcF18fjkk/ViyQKHq1W/s0YCItV9yhayuXHA6ZY4d0vs5Y0F1hdfYxdlKtXWyi9hUiQ0
         NyWTgATZ6gz/JiSIFfgvPI2EU1THhp5jJZ1IUsS37XlNlcXEdRg9pKhc2G4N/JOMDE3l
         snZCmT2PQnWcTDLUUfZCd/8MEzVI3/ww40FyOD37JmFLwOTF387kr2ARfpZnke2Yao34
         YLhsoweOyumHdHg0mooatl1PbDIfJKgg+Wssez9ZDgZvnOYR1/rOa8zbYf3c8rFbucrT
         qS8w==
X-Gm-Message-State: AOAM533Svp86/626ZaH6CWTAThIVelpB2tBwflsRMh1aMFS3zWjq16ca
        sr8JGDphDttzqO1ofgBPNloWbR3RXhReZwDw0iOozSZwlWRi
X-Google-Smtp-Source: ABdhPJwGHghLPmVCAsZYpQebAewIJWlH+DfzNLEnKt6Vvz1+IoacryC4wBZD/HsCCQrvc8CJj3PmuikKrR2xMi8wIjtrG9WyLe6/
MIME-Version: 1.0
X-Received: by 2002:a05:6638:58a:: with SMTP id a10mr529969jar.51.1606152676379;
 Mon, 23 Nov 2020 09:31:16 -0800 (PST)
Date:   Mon, 23 Nov 2020 09:31:16 -0800
In-Reply-To: <0000000000007bf88805a445f729@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bb145805b4c98ff2@google.com>
Subject: Re: memory leak in inet_create (2)
From:   syzbot <syzbot+bb7ba8dd62c3cb6e3c78@syzkaller.appspotmail.com>
To:     andrii@kernel.org, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    418baf2c Linux 5.10-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=161c84ed500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5524c10373633a9c
dashboard link: https://syzkaller.appspot.com/bug?extid=bb7ba8dd62c3cb6e3c78
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1514cfa3500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11a52fc1500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bb7ba8dd62c3cb6e3c78@syzkaller.appspotmail.com

executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88810e85adc0 (size 1728):
  comm "syz-executor376", pid 8506, jiffies 4294946899 (age 13.430s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    02 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
  backtrace:
    [<00000000cb2829d9>] sk_prot_alloc+0x3e/0x1c0 net/core/sock.c:1660
    [<0000000023bd8ef8>] sk_alloc+0x30/0x3f0 net/core/sock.c:1720
    [<00000000a4a7ed0a>] inet_create net/ipv4/af_inet.c:322 [inline]
    [<00000000a4a7ed0a>] inet_create+0x16a/0x560 net/ipv4/af_inet.c:248
    [<000000003b729101>] __sock_create+0x1ab/0x2b0 net/socket.c:1427
    [<00000000ebee6fd5>] sock_create net/socket.c:1478 [inline]
    [<00000000ebee6fd5>] __sys_socket+0x6f/0x140 net/socket.c:1520
    [<00000000bcf20e68>] __do_sys_socket net/socket.c:1529 [inline]
    [<00000000bcf20e68>] __se_sys_socket net/socket.c:1527 [inline]
    [<00000000bcf20e68>] __x64_sys_socket+0x1a/0x20 net/socket.c:1527
    [<00000000732fe45a>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000091e76b15>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810fec3c80 (size 768):
  comm "syz-executor376", pid 8506, jiffies 4294946899 (age 13.430s)
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 c0 72 a0 0e 81 88 ff ff  .........r......
  backtrace:
    [<00000000681cd6ae>] sock_alloc_inode+0x18/0x90 net/socket.c:253
    [<00000000fa9d2004>] alloc_inode+0x27/0x100 fs/inode.c:234
    [<00000000f3a018c7>] new_inode_pseudo+0x13/0x70 fs/inode.c:930
    [<00000000549f715a>] sock_alloc+0x18/0x90 net/socket.c:573
    [<00000000a044e0d4>] __sock_create+0xb8/0x2b0 net/socket.c:1391
    [<00000000973ca39c>] mptcp_subflow_create_socket+0x57/0x280 net/mptcp/subflow.c:1152
    [<00000000a3724864>] __mptcp_socket_create net/mptcp/protocol.c:97 [inline]
    [<00000000a3724864>] mptcp_init_sock net/mptcp/protocol.c:1859 [inline]
    [<00000000a3724864>] mptcp_init_sock+0x12f/0x270 net/mptcp/protocol.c:1844
    [<00000000c97baf32>] inet_create net/ipv4/af_inet.c:380 [inline]
    [<00000000c97baf32>] inet_create+0x2ed/0x560 net/ipv4/af_inet.c:248
    [<000000003b729101>] __sock_create+0x1ab/0x2b0 net/socket.c:1427
    [<00000000ebee6fd5>] sock_create net/socket.c:1478 [inline]
    [<00000000ebee6fd5>] __sys_socket+0x6f/0x140 net/socket.c:1520
    [<00000000bcf20e68>] __do_sys_socket net/socket.c:1529 [inline]
    [<00000000bcf20e68>] __se_sys_socket net/socket.c:1527 [inline]
    [<00000000bcf20e68>] __x64_sys_socket+0x1a/0x20 net/socket.c:1527
    [<00000000732fe45a>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000091e76b15>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810de87bb8 (size 24):
  comm "syz-executor376", pid 8506, jiffies 4294946899 (age 13.430s)
  hex dump (first 24 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00                          ........
  backtrace:
    [<00000000bea9ec8c>] kmem_cache_zalloc include/linux/slab.h:654 [inline]
    [<00000000bea9ec8c>] lsm_inode_alloc security/security.c:589 [inline]
    [<00000000bea9ec8c>] security_inode_alloc+0x2a/0xb0 security/security.c:972
    [<00000000543365c5>] inode_init_always+0x10c/0x250 fs/inode.c:171
    [<000000004da5c777>] alloc_inode+0x44/0x100 fs/inode.c:241
    [<00000000f3a018c7>] new_inode_pseudo+0x13/0x70 fs/inode.c:930
    [<00000000549f715a>] sock_alloc+0x18/0x90 net/socket.c:573
    [<00000000a044e0d4>] __sock_create+0xb8/0x2b0 net/socket.c:1391
    [<00000000973ca39c>] mptcp_subflow_create_socket+0x57/0x280 net/mptcp/subflow.c:1152
    [<00000000a3724864>] __mptcp_socket_create net/mptcp/protocol.c:97 [inline]
    [<00000000a3724864>] mptcp_init_sock net/mptcp/protocol.c:1859 [inline]
    [<00000000a3724864>] mptcp_init_sock+0x12f/0x270 net/mptcp/protocol.c:1844
    [<00000000c97baf32>] inet_create net/ipv4/af_inet.c:380 [inline]
    [<00000000c97baf32>] inet_create+0x2ed/0x560 net/ipv4/af_inet.c:248
    [<000000003b729101>] __sock_create+0x1ab/0x2b0 net/socket.c:1427
    [<00000000ebee6fd5>] sock_create net/socket.c:1478 [inline]
    [<00000000ebee6fd5>] __sys_socket+0x6f/0x140 net/socket.c:1520
    [<00000000bcf20e68>] __do_sys_socket net/socket.c:1529 [inline]
    [<00000000bcf20e68>] __se_sys_socket net/socket.c:1527 [inline]
    [<00000000bcf20e68>] __x64_sys_socket+0x1a/0x20 net/socket.c:1527
    [<00000000732fe45a>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000091e76b15>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810ea072c0 (size 2208):
  comm "syz-executor376", pid 8506, jiffies 4294946899 (age 13.430s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    02 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
  backtrace:
    [<00000000cb2829d9>] sk_prot_alloc+0x3e/0x1c0 net/core/sock.c:1660
    [<0000000023bd8ef8>] sk_alloc+0x30/0x3f0 net/core/sock.c:1720
    [<00000000a4a7ed0a>] inet_create net/ipv4/af_inet.c:322 [inline]
    [<00000000a4a7ed0a>] inet_create+0x16a/0x560 net/ipv4/af_inet.c:248
    [<000000003b729101>] __sock_create+0x1ab/0x2b0 net/socket.c:1427
    [<00000000973ca39c>] mptcp_subflow_create_socket+0x57/0x280 net/mptcp/subflow.c:1152
    [<00000000a3724864>] __mptcp_socket_create net/mptcp/protocol.c:97 [inline]
    [<00000000a3724864>] mptcp_init_sock net/mptcp/protocol.c:1859 [inline]
    [<00000000a3724864>] mptcp_init_sock+0x12f/0x270 net/mptcp/protocol.c:1844
    [<00000000c97baf32>] inet_create net/ipv4/af_inet.c:380 [inline]
    [<00000000c97baf32>] inet_create+0x2ed/0x560 net/ipv4/af_inet.c:248
    [<000000003b729101>] __sock_create+0x1ab/0x2b0 net/socket.c:1427
    [<00000000ebee6fd5>] sock_create net/socket.c:1478 [inline]
    [<00000000ebee6fd5>] __sys_socket+0x6f/0x140 net/socket.c:1520
    [<00000000bcf20e68>] __do_sys_socket net/socket.c:1529 [inline]
    [<00000000bcf20e68>] __se_sys_socket net/socket.c:1527 [inline]
    [<00000000bcf20e68>] __x64_sys_socket+0x1a/0x20 net/socket.c:1527
    [<00000000732fe45a>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000091e76b15>] entry_SYSCALL_64_after_hwframe+0x44/0xa9


