Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE50E5667B
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfFZKRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:17:06 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:41200 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZKRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 06:17:06 -0400
Received: by mail-io1-f70.google.com with SMTP id x17so2004001iog.8
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 03:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=91FCmbybaGN9w/7LNvVmFsN27kOzGRkQsPRxpuyt5OM=;
        b=G4f4U8cjxD+dfl/rGqhxFDwsfxEGEmbf1v7LsKJmmGP9isrvb8mt37MY5ibuAlVTBy
         bHpRNNpBZWTeLndSJe4GmtrcMzYOLyh7nxG9G0uFurWAfYU0BTb3p/sAPbGyxzkRTW0g
         863FIU5aNkLrC0SigwVhU6wK4wWIYuAZf9v3fzYrTYbjBZM53J5VacbTFHFpWPJB+NQ1
         1cRrkG2L0z9OAIp1kZWMDqfUwWsPt9OXD0mqO8+uD81Y40LjMLMiGv15UyY9FTMkvc/P
         GZKmbfklc1HlDgri8uDGJUTFqNAbXJbvjOTpAnFjRVvEY2HzWI9p4Hw6ZncDAEtIIoMB
         89ag==
X-Gm-Message-State: APjAAAXhu+YncnbAaEV5Xzy8+LYCoQq7O11GD2Ug45vz6p2uizozNQ11
        4fZzti3doU9I7B+/kTwCQBIMFVgvWO/blsshk/bcamwwP8Xr
X-Google-Smtp-Source: APXvYqwmMqFd7Zrv7uivTuMwUupMdddjh6PbrPVaFbpsDMCOcx01ndNPhgG6wQjoa8ok3+NaWrPgqrbxvmaOcJgAXCsu+mFRb7oD
MIME-Version: 1.0
X-Received: by 2002:a02:ca57:: with SMTP id i23mr3795303jal.25.1561544225173;
 Wed, 26 Jun 2019 03:17:05 -0700 (PDT)
Date:   Wed, 26 Jun 2019 03:17:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d7bcbb058c3758a1@google.com>
Subject: BUG: unable to handle kernel paging request in tls_prots
From:   syzbot <syzbot+4207c7f3a443366d8aa2@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, john.fastabend@gmail.com,
        kafai@fb.com, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    904d88d7 qmi_wwan: Fix out-of-bounds read
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=14a8b865a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=137ec2016ea3870d
dashboard link: https://syzkaller.appspot.com/bug?extid=4207c7f3a443366d8aa2
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15576c71a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4207c7f3a443366d8aa2@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: 000000004125973f
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 92e1a067 P4D 92e1a067 PUD 0
Thread overran stack, or stack corrupted
Oops: 0002 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9943 Comm: blkid Not tainted 5.2.0-rc5+ #62
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:tls_prots+0x1a8a/0x3520
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  
00 00 00 00 00 00 00 00 00 70 0d 0f 86 ff ff ff ff 40 5d <28> 86 ff ff ff  
ff 60 6e 28 86 ff ff ff ff 00 de ed 85 ff ff ff ff
RSP: 0018:ffff888079bc7c10 EFLAGS: 00010082
RAX: ffff88808c5226c0 RBX: ffff88808cb36100 RCX: 1ffffffff116885c
RDX: 1ffff110118a44d8 RSI: 0000000041259740 RDI: ffff88808c523a70
RBP: ffff888079bc7c38 R08: ffff88808c5226c0 R09: ffffed1015d26c70
R10: ffffed1015d26c6f R11: ffff8880ae93637b R12: ffffffff860dd760
R13: ffffffff860dda75 R14: ffff888079bc7c08 R15: ffffffff8b1da9a0
FS:  00007fa341259740(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000004125973f CR3: 00000000907f6000 CR4: 00000000001406e0
Call Trace:
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
  tcp_bpf_unhash net/ipv4/tcp_bpf.c:550 [inline]
  tcp_bpf_unhash+0x315/0x390 net/ipv4/tcp_bpf.c:540
WARNING: kernel stack frame pointer at 00000000e809d5dc in blkid:9943 has  
bad value 000000009844d018
unwind stack type:0 next_sp:000000005f927a44 mask:0x2 graph_idx:0
000000002401cb95: ffff888079bc7c68 (0xffff888079bc7c68)
00000000c24ed912: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
00000000db5b548d: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
00000000479aff76: ffff88808cb36100 (0xffff88808cb36100)
000000004473e5aa: 0000000000000000 ...
000000009d12a602: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
00000000ba44e25c: ffff888079bc7c98 (0xffff888079bc7c98)
00000000e1eb23e4: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
00000000f7d29ffb: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
00000000dc871c27: ffff88808cb36100 (0xffff88808cb36100)
000000003824545e: 0000000000000000 ...
000000008a182c7c: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
000000001c7a51e7: ffff888079bc7cc8 (0xffff888079bc7cc8)
0000000049da0237: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
000000009c31c0da: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
0000000024f3129d: ffff88808cb36100 (0xffff88808cb36100)
0000000040823c88: 0000000000000000 ...
000000004c33f42e: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
00000000fa38e5a4: ffff888079bc7cf8 (0xffff888079bc7cf8)
0000000030a46a60: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
00000000313cd10c: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
000000003feafbe9: ffff88808cb36100 (0xffff88808cb36100)
00000000b2d0344c: 0000000000000000 ...
00000000a54c1af0: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
00000000d4027d6c: ffff888079bc7d28 (0xffff888079bc7d28)
000000009ee98499: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
00000000cc716643: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
00000000f66028fc: ffff88808cb36100 (0xffff88808cb36100)
00000000f1a9f4a4: 0000000000000000 ...
0000000093e98749: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
0000000069764410: ffff888079bc7d58 (0xffff888079bc7d58)
0000000099cc4d5e: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
000000008452556b: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
000000009d210107: ffff88808cb36100 (0xffff88808cb36100)
000000000b3d1c61: 0000000000000000 ...
0000000029482aba: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
000000000080c2ff: ffff888079bc7d88 (0xffff888079bc7d88)
000000004e072bc8: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
00000000049c3c65: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
00000000b89e7d9b: ffff88808cb36100 (0xffff88808cb36100)
000000004f6d4a66: 0000000000000000 ...
0000000062d2c1b7: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
0000000064dd81c9: ffff888079bc7db8 (0xffff888079bc7db8)
000000003089fca0: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
0000000080e7f1f9: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
00000000487c3ec3: ffff88808cb36100 (0xffff88808cb36100)
00000000291b99a5: 0000000000000000 ...
00000000879c3ace: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
0000000088f16e91: ffff888079bc7de8 (0xffff888079bc7de8)
00000000feaf9900: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
00000000699d8a79: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
00000000ea800749: ffff88808cb36100 (0xffff88808cb36100)
000000002c99629d: 0000000000000000 ...
00000000f89aef64: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
000000008a8c9aec: ffff888079bc7e18 (0xffff888079bc7e18)
0000000050ff6d78: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
000000008764d630: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
0000000091e33368: ffff88808cb36100 (0xffff88808cb36100)
00000000e1a0ace5: 0000000000000000 ...
00000000cbc751ab: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
00000000d4f9acf4: ffff888079bc7e48 (0xffff888079bc7e48)
0000000081fc1715: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
00000000aa6f1bc2: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
00000000d2a9e7ce: ffff88808cb36100 (0xffff88808cb36100)
000000006f96fab3: 0000000000000000 ...
00000000aeaeead6: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
00000000f35f95f5: ffff888079bc7e78 (0xffff888079bc7e78)
000000008c846b2f: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
000000001c6a7237: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
00000000799c1d50: ffff88808cb36100 (0xffff88808cb36100)
00000000447f9e03: 0000000000000000 ...
00000000ec08ab6f: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
0000000079b88671: ffff888079bc7ea8 (0xffff888079bc7ea8)
0000000057ceab90: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
00000000a3af49c4: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
00000000c8233266: ffff88808cb36100 (0xffff88808cb36100)
00000000a4346829: 0000000000000000 ...
00000000a77b30e0: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
000000009289d9ef: ffff888079bc7ed8 (0xffff888079bc7ed8)
0000000093a94b95: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
00000000bba52dcd: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
000000004ba72af3: ffff88808cb36100 (0xffff88808cb36100)
000000002713380e: 0000000000000000 ...
0000000082b4f5fe: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
00000000fd331aa8: ffff888079bc7f08 (0xffff888079bc7f08)
00000000a125cb7a: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
00000000b176b5fe: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
0000000021b424c8: ffff88808cb36100 (0xffff88808cb36100)
00000000c8aca3a7: 0000000000000000 ...
00000000ae0e04d5: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
00000000218dfe2f: ffff888079bc7f38 (0xffff888079bc7f38)
000000006f81db8c: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
000000005415d20a: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
00000000cd8b4d0d: ffff88808cb36100 (0xffff88808cb36100)
0000000028dde223: 0000000000000000 ...
00000000f1bac7a7: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
00000000819b4e09: ffff888079bc7f68 (0xffff888079bc7f68)
0000000040faf187: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
00000000d40fc060: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
000000002efea550: ffff88808cb36100 (0xffff88808cb36100)
0000000056721274: 0000000000000000 ...
000000008c6a3097: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
0000000039ab3cf0: ffff888079bc7f98 (0xffff888079bc7f98)
00000000b825c1f0: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
000000005d65596f: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
00000000a0cc451f: ffff88808cb36100 (0xffff88808cb36100)
00000000e7f05b41: 0000000000000000 ...
0000000049404ce5: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
000000001a81ddbb: ffff888079bc7fc8 (0xffff888079bc7fc8)
000000003afd376f: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
0000000067da2263: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
00000000951815ed: ffff88808cb36100 (0xffff88808cb36100)
00000000eb36eac9: 0000000000000000 ...
0000000084ea5e52: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
00000000e809d5dc: ffff888079bc7ff8 (0xffff888079bc7ff8)
00000000e50d63ae: ffffffff860dda75 (tcp_bpf_unhash+0x315/0x390)
00000000d90e11b6: ffffffff860dd760 (tcp_bpf_recvmsg+0xa40/0xa40)
000000000a06acca: ffff88808cb36100 (0xffff88808cb36100)
000000006c7f5c3c: 0000000000000000 ...
00000000e157dcd0: ffffffff8b1da9a0 (tls_prots+0x1a80/0x3520)
000000009844d018: ffff888079bc8028 (0xffff888079bc8028)
Modules linked in:
CR2: 000000004125973f
---[ end trace 79fdcdc2ec39f3e0 ]---
RIP: 0010:tls_prots+0x1a8a/0x3520
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  
00 00 00 00 00 00 00 00 00 70 0d 0f 86 ff ff ff ff 40 5d <28> 86 ff ff ff  
ff 60 6e 28 86 ff ff ff ff 00 de ed 85 ff ff ff ff
RSP: 0018:ffff888079bc7c10 EFLAGS: 00010082
RAX: ffff88808c5226c0 RBX: ffff88808cb36100 RCX: 1ffffffff116885c
RDX: 1ffff110118a44d8 RSI: 0000000041259740 RDI: ffff88808c523a70
RBP: ffff888079bc7c38 R08: ffff88808c5226c0 R09: ffffed1015d26c70
R10: ffffed1015d26c6f R11: ffff8880ae93637b R12: ffffffff860dd760
R13: ffffffff860dda75 R14: ffff888079bc7c08 R15: ffffffff8b1da9a0
FS:  00007fa341259740(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000004125973f CR3: 00000000907f6000 CR4: 00000000001406e0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
