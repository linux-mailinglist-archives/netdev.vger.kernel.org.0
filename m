Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88A02D8E0C
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403870AbgLMOxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 09:53:52 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:34978 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729513AbgLMOxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 09:53:51 -0500
Received: by mail-il1-f198.google.com with SMTP id l11so11480472ilq.2
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 06:53:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=fWF53rcHi8QspkjztKtg7fthAltlqOrg0gZKXd1Tx+4=;
        b=jKlX0Hz+CdAALE6M9CwHLBnVj/IVDr7HKLEJDiNtV0fwOPGgibazc52FmiKmQaVnEg
         8Pm3vBvSI8vNoEeoD/cnp13GFW9wep1jkKPMS+oWxNswyF0KDtfn2yuYoSiwwtsyaOQE
         4nvNgyqOK40MywMF3uSXzFAx4RQlzDqzlpjunJonJ3/M3fmoidqLQ6Z75aZr9TK0I64e
         Q+JPN5anAuIq7KZwQ05LgN9jkdNbchmpZR7eBd455CiKx32klAISHawI6uC3/pjqVJra
         H3gj+5TacEBoTBuVOvVQ7uG7rayK6eDsWK4pEFEGZf89S9KxKBJH6eJW9mipviOpRw3v
         /5iA==
X-Gm-Message-State: AOAM531h56UYpWmYZxjcETfQ5TL8BG3UEBWNuN1nmu4XBiCDk+cYqt32
        1o1jo44mlLyw6lOCImQzmUmezCDQJ74+KR4REa8/zk0vZ/9s
X-Google-Smtp-Source: ABdhPJzrJnVwLKuT4IGifrvkCv9PDEMjNNrq6FMGbcr0krUHEsKI3sBFDe0MTfP+Ug664/YEqs0v9dxinAyACJKe5RpnNxro4nSk
MIME-Version: 1.0
X-Received: by 2002:a92:5802:: with SMTP id m2mr4547791ilb.271.1607871190712;
 Sun, 13 Dec 2020 06:53:10 -0800 (PST)
Date:   Sun, 13 Dec 2020 06:53:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002aca2e05b659af04@google.com>
Subject: memory leak in xskq_create
From:   syzbot <syzbot+cfa88ddd0655afa88763@syzkaller.appspotmail.com>
To:     ast@kernel.org, bjorn.topel@intel.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, jonathan.lemon@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a68a0262 mm/madvise: remove racy mm ownership check
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=165b9413500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4305fa9ea70c7a9f
dashboard link: https://syzkaller.appspot.com/bug?extid=cfa88ddd0655afa88763
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1180a237500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=114067cf500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cfa88ddd0655afa88763@syzkaller.appspotmail.com

Debian GNU/Linux 9 syzkaller ttyS0
Warning: Permanently added '10.128.0.50' (ECDSA) to the list of known hosts.
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88810f897940 (size 64):
  comm "syz-executor991", pid 8502, jiffies 4294942194 (age 14.080s)
  hex dump (first 32 bytes):
    7f 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00  ................
    00 a0 37 0c 81 88 ff ff 00 00 00 00 00 00 00 00  ..7.............
  backtrace:
    [<00000000639d0dd1>] xskq_create+0x23/0xd0 include/linux/slab.h:552
    [<00000000b680b035>] xsk_init_queue net/xdp/xsk.c:508 [inline]
    [<00000000b680b035>] xsk_setsockopt+0x1c4/0x590 net/xdp/xsk.c:875
    [<000000002b302260>] __sys_setsockopt+0x1b0/0x360 net/socket.c:2132
    [<00000000ae03723e>] __do_sys_setsockopt net/socket.c:2143 [inline]
    [<00000000ae03723e>] __se_sys_setsockopt net/socket.c:2140 [inline]
    [<00000000ae03723e>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2140
    [<0000000005c2b4a0>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000003db140f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810f8979c0 (size 64):
  comm "syz-executor991", pid 8503, jiffies 4294942194 (age 14.080s)
  hex dump (first 32 bytes):
    ff 03 00 00 00 04 00 00 00 00 00 00 00 00 00 00  ................
    00 00 13 12 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000639d0dd1>] xskq_create+0x23/0xd0 include/linux/slab.h:552
    [<00000000b680b035>] xsk_init_queue net/xdp/xsk.c:508 [inline]
    [<00000000b680b035>] xsk_setsockopt+0x1c4/0x590 net/xdp/xsk.c:875
    [<000000002b302260>] __sys_setsockopt+0x1b0/0x360 net/socket.c:2132
    [<00000000ae03723e>] __do_sys_setsockopt net/socket.c:2143 [inline]
    [<00000000ae03723e>] __se_sys_setsockopt net/socket.c:2140 [inline]
    [<00000000ae03723e>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2140
    [<0000000005c2b4a0>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<0000000003db140f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
