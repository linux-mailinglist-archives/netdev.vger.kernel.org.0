Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98C1011196
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 04:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfEBCiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 22:38:06 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:40357 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfEBCiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 22:38:06 -0400
Received: by mail-io1-f69.google.com with SMTP id y10so717641ioj.7
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 19:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xtXw2lupwkVjqX6efEcOaASU6ebh70LIWoergDKWJSw=;
        b=cuj5vhwsqR5Wbh1hKBPa1Ip08tMGq3RCGr4fmOIlNRiDt5FkxJK5yQsC6P65ehY0BH
         HEYekat6Rpz5KTHT+HpmumJnsQh5B1A9ezQLs77dcBqIz5eBhaKihwAvMG+knzCGzqpK
         EONqQn4B2Bg3wahEYoKJMg4qiU580rNQoAOgWnsZZHwrL7x8yAsUPlE+UlCWASmEWjl9
         C/b33LpKxbQPLXqChzVj/0cA4SFQDptrvBJ9/Kg8UTvR/ytKRNd3ib0+s/ZrwA0zHTiM
         28RsfZrKy4Dq4QYVkYt8Zp89ScLxAwewkdgwAg6523KeRK5IguxRHtEkB6UQsWGaXfs+
         3WKA==
X-Gm-Message-State: APjAAAXr7a46I3DUuBPk7xKQGlYdhc89WF75PS8G8+IqttRelODsq/Bj
        U2sV/c00EADDBW3cRMCmAbHzZX/ZNlXHEwlpN8fHSFbOV1X3
X-Google-Smtp-Source: APXvYqwQqZI+dOYyfu+U0r6fq/+CcfSqb4y1MWdnmVWFreVqywSXoJDTxuiE6SA1+xZcYWY9y+SAgmmGSNCZZOO6qEp0cHUzU/nJ
MIME-Version: 1.0
X-Received: by 2002:a5d:83d7:: with SMTP id u23mr897843ior.56.1556764685538;
 Wed, 01 May 2019 19:38:05 -0700 (PDT)
Date:   Wed, 01 May 2019 19:38:05 -0700
In-Reply-To: <000000000000eb6a8e057ab79f82@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000149c440587de8693@google.com>
Subject: Re: WARNING: refcount bug in p9_req_put
From:   syzbot <syzbot+edec7868af5997928fe9@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, ericvh@gmail.com,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    459e3a21 gcc-9: properly declare the {pv,hv}clock_page sto..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=136c9284a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ef1b87b455c397cf
dashboard link: https://syzkaller.appspot.com/bug?extid=edec7868af5997928fe9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1642ee48a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+edec7868af5997928fe9@syzkaller.appspotmail.com

WARNING: CPU: 1 PID: 7959 at lib/refcount.c:190  
refcount_sub_and_test_checked lib/refcount.c:190 [inline]
WARNING: CPU: 1 PID: 7959 at lib/refcount.c:190  
refcount_sub_and_test_checked+0x1d0/0x200 lib/refcount.c:180
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 7959 Comm: syz-executor.1 Not tainted 5.1.0-rc7+ #96
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2cb/0x65c kernel/panic.c:214
  __warn.cold+0x20/0x45 kernel/panic.c:571
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
RIP: 0010:refcount_sub_and_test_checked lib/refcount.c:190 [inline]
RIP: 0010:refcount_sub_and_test_checked+0x1d0/0x200 lib/refcount.c:180
Code: 1d c8 30 2a 06 31 ff 89 de e8 0c 32 40 fe 84 db 75 94 e8 c3 30 40 fe  
48 c7 c7 60 79 a1 87 c6 05 a8 30 2a 06 01 e8 ae de 12 fe <0f> 0b e9 75 ff  
ff ff e8 a4 30 40 fe e9 6e ff ff ff 48 89 df e8 37
RSP: 0018:ffff888089ce7860 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815afcb6 RDI: ffffed101139cefe
RBP: ffff888089ce78f8 R08: ffff8880a4c584c0 R09: ffffed1015d25011
R10: ffffed1015d25010 R11: ffff8880ae928087 R12: 00000000ffffffff
R13: 0000000000000001 R14: ffff888089ce78d0 R15: 0000000000000000
  refcount_dec_and_test_checked+0x1b/0x20 lib/refcount.c:220
  kref_put include/linux/kref.h:66 [inline]
  p9_req_put+0x20/0x60 net/9p/client.c:401
  p9_conn_destroy net/9p/trans_fd.c:880 [inline]
  p9_fd_close+0x2ee/0x570 net/9p/trans_fd.c:913
  p9_client_create+0x998/0x1400 net/9p/client.c:1083
  v9fs_session_init+0x1e7/0x1960 fs/9p/v9fs.c:421
  v9fs_mount+0x7d/0x920 fs/9p/vfs_super.c:135
  legacy_get_tree+0xf2/0x200 fs/fs_context.c:584
  vfs_get_tree+0x123/0x450 fs/super.c:1481
  do_new_mount fs/namespace.c:2622 [inline]
  do_mount+0x1436/0x2c40 fs/namespace.c:2942
  ksys_mount+0xdb/0x150 fs/namespace.c:3151
  __do_sys_mount fs/namespace.c:3165 [inline]
  __se_sys_mount fs/namespace.c:3162 [inline]
  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3162
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458da9
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f2e68c68c78 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f2e68c68c90 RCX: 0000000000458da9
RDX: 0000000020000100 RSI: 00000000200000c0 RDI: 0000000000000000
RBP: 000000000073bf00 R08: 00000000200013c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f2e68c696d4
R13: 00000000004c4da7 R14: 00000000004d8a20 R15: 0000000000000005
Kernel Offset: disabled
Rebooting in 86400 seconds..

