Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C03250B8
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 15:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbfEUNkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 09:40:07 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:51919 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbfEUNkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 09:40:06 -0400
Received: by mail-io1-f71.google.com with SMTP id i20so14053822ioo.18
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 06:40:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=K4ds8cMxo1iXc8WzeVkbAabvNASPap6txWxba5dr+7A=;
        b=caVIpy9rUctDp0nPtlTbe05Wj6UTW6SfbONQ4PPviLV+jYJZAggaqGSUM/KnTNlZSo
         XEYVXV5KaFW2ezajZifMDQjrG8z2s0O/wkXBp02y8CpapnFjIeyideEyJsj/eGznwM6Z
         k/heBvDTVaftOMqPZSYsatYlbj1ORiljyBuIjLV0qGNUiTYUTjYsYknxc3AcDcNz1MnN
         C9VuUW/9ZbtQjdOWhADlcAqtP/HD+L1sxgXlgwalXrXus1jP+sRY0LDxcqVLMTJ2Uh3S
         kyVD34mXbcECqh+Xu+3YRPW8/I/QC/VFlGvk1577a+jcivQ78EeZOTFbsUAnzStImA0q
         DTHQ==
X-Gm-Message-State: APjAAAXttSXM2Yxs6F5QgO2yT/GA4UK7EBcieX3iexLoujsuCHC7qnP4
        7TSzjDelJdXcLtWHHBN8zQUbaUWfXfgitc1rZ4/W5Jd9TGwd
X-Google-Smtp-Source: APXvYqzspuOvi+vHsplGaSP0d+7NSlzKcyTf0DIR7haZL8LBBYvCtkq00YtKlZWtSNX6rVfsX7qkJ0CBxbpY3JHqwNrOhhQ2pJdL
MIME-Version: 1.0
X-Received: by 2002:a6b:b2c7:: with SMTP id b190mr10910519iof.14.1558446005778;
 Tue, 21 May 2019 06:40:05 -0700 (PDT)
Date:   Tue, 21 May 2019 06:40:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009382e7058965fc65@google.com>
Subject: memory leak in llc_ui_sendmsg
From:   syzbot <syzbot+31c16aa4202dace3812e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f49aa1de Merge tag 'for-5.2-rc1-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=117ba18aa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61dd9e15a761691d
dashboard link: https://syzkaller.appspot.com/bug?extid=31c16aa4202dace3812e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137f3d9ca00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=156389f8a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+31c16aa4202dace3812e@syzkaller.appspotmail.com

udit(1558395599.193:36): avc:  denied  { map } for  pid=7045  
comm="syz-executor641" path="/root/syz-executor641959542" dev="sda1"  
ino=1426 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023  
tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff888116270800 (size 224):
   comm "syz-executor641", pid 7047, jiffies 4294947360 (age 13.860s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 20 e1 2a 81 88 ff ff 00 40 3d 2a 81 88 ff ff  . .*.....@=*....
   backtrace:
     [<000000004d41b4cc>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000004d41b4cc>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000004d41b4cc>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000004d41b4cc>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
     [<00000000506a5965>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
     [<000000001ba5a161>] alloc_skb include/linux/skbuff.h:1058 [inline]
     [<000000001ba5a161>] alloc_skb_with_frags+0x5f/0x250  
net/core/skbuff.c:5327
     [<0000000047d9c78b>] sock_alloc_send_pskb+0x269/0x2a0  
net/core/sock.c:2225
     [<000000003828fe54>] sock_alloc_send_skb+0x32/0x40 net/core/sock.c:2242
     [<00000000e34d94f9>] llc_ui_sendmsg+0x10a/0x540 net/llc/af_llc.c:933
     [<00000000de2de3fb>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000de2de3fb>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<000000008fe16e7a>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000005b17a3ac>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000005b17a3ac>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000005b17a3ac>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<0000000094b2fa53>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000ea5a7233>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88812274ac00 (size 512):
   comm "syz-executor641", pid 7047, jiffies 4294947360 (age 13.860s)
   hex dump (first 32 bytes):
     08 c2 03 00 00 00 00 00 69 63 65 73 2f 76 69 72  ........ices/vir
     74 75 61 6c 2f 74 74 79 2f 74 74 79 71 37 00 41  tual/tty/ttyq7.A
   backtrace:
     [<000000009abfb07f>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009abfb07f>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009abfb07f>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000009abfb07f>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<000000001e6bdec9>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<000000001e6bdec9>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3634
     [<00000000dcf4f208>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:142
     [<0000000081158459>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:210
     [<000000001ba5a161>] alloc_skb include/linux/skbuff.h:1058 [inline]
     [<000000001ba5a161>] alloc_skb_with_frags+0x5f/0x250  
net/core/skbuff.c:5327
     [<0000000047d9c78b>] sock_alloc_send_pskb+0x269/0x2a0  
net/core/sock.c:2225
     [<000000003828fe54>] sock_alloc_send_skb+0x32/0x40 net/core/sock.c:2242
     [<00000000e34d94f9>] llc_ui_sendmsg+0x10a/0x540 net/llc/af_llc.c:933
     [<00000000de2de3fb>] sock_sendmsg_nosec net/socket.c:652 [inline]
     [<00000000de2de3fb>] sock_sendmsg+0x54/0x70 net/socket.c:671
     [<000000008fe16e7a>] __sys_sendto+0x148/0x1f0 net/socket.c:1964
     [<000000005b17a3ac>] __do_sys_sendto net/socket.c:1976 [inline]
     [<000000005b17a3ac>] __se_sys_sendto net/socket.c:1972 [inline]
     [<000000005b17a3ac>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1972
     [<0000000094b2fa53>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000ea5a7233>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

executing program
executing program


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
