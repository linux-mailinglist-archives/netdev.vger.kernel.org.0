Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DFA33CE16
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 07:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhCPGsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 02:48:41 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:47609 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbhCPGsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 02:48:13 -0400
Received: by mail-io1-f71.google.com with SMTP id o4so22604526ioh.14
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 23:48:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=WuZiddlhWjyixnWUAvcAwtP4U5EdkgGf4jw6+WDTIi8=;
        b=EBot+9nyC2jY+UUAiNHtrk81e5JsN3g3PKdr7FIB2rlIoLhP6p6eg5V6F9J807VchG
         dj1glLH+g1XnVuUfwvf2PKwxlIj1/55DCa8BrXpMhoLuBsZLnZhKKhYwiqteIYgId9+O
         F9uUOENHlBf7ehbuOMbUu43IUV0qjUt2Ruryi+Pnn12tjpVlI+dqMSEG3rGh6i6kh+Ar
         S2hzUouEDdqxGECm4YODpCYQ4Q6euTZnbxkte67zUqHXlyVpg6uwb4FF1AeDlK8EXSmv
         cR0qZye/locd4mxY4sPzQczBCzplRhzzBaccrkAXSo1foyhs2NYifVTFExMmGfKrMKfT
         ydDw==
X-Gm-Message-State: AOAM531uQB77X7YeHQH26Hmu4U07iKukQzQCx3DBX1hE3N9PafzAMR8r
        k99u/ExOg4dzr83rYZYFGEZwRPDq3inOP2iPI9U3LRveWJ1D
X-Google-Smtp-Source: ABdhPJzI9tz1Qm71YI1ggnGgklvoxmExe2I9C6nuY8wqygsLITXHRWZ60FpCwWreka25zWylzLR92yx3SYMGo4XKApbqcZcoB9fs
MIME-Version: 1.0
X-Received: by 2002:a5e:8d01:: with SMTP id m1mr2319176ioj.72.1615877292614;
 Mon, 15 Mar 2021 23:48:12 -0700 (PDT)
Date:   Mon, 15 Mar 2021 23:48:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000006e7be05bda1c084@google.com>
Subject: [syzbot] general protection fault in scatterwalk_copychunks (4)
From:   syzbot <syzbot+66e3ea42c4b176748b9c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    47142ed6 net: dsa: bcm_sf2: Qualify phydev->dev_flags base..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17fb9376d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eec733599e95cd87
dashboard link: https://syzkaller.appspot.com/bug?extid=66e3ea42c4b176748b9c

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+66e3ea42c4b176748b9c@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 25 Comm: kworker/u4:1 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: pencrypt_parallel padata_parallel_worker
RIP: 0010:scatterwalk_start include/crypto/scatterwalk.h:68 [inline]
RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:93 [inline]
RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:77 [inline]
RIP: 0010:scatterwalk_copychunks+0x4db/0x6a0 crypto/scatterwalk.c:50
Code: ff df 80 3c 02 00 0f 85 b4 01 00 00 49 8d 44 24 08 4d 89 26 48 89 c2 48 89 44 24 18 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 77 01 00 00 48 b8 00 00 00 00
RSP: 0018:ffffc90000dff620 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff83c45a33 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88801ba09d1b
R10: ffffffff83c459e3 R11: 000000000000d9e6 R12: 0000000000000000
R13: 0000000000000001 R14: ffffc90000dff880 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000540198 CR3: 0000000018d08000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 skcipher_next_slow crypto/skcipher.c:278 [inline]
 skcipher_walk_next+0x7af/0x1680 crypto/skcipher.c:363
 skcipher_walk_first+0xf8/0x3c0 crypto/skcipher.c:446
 skcipher_walk_aead_common+0x7a5/0xbc0 crypto/skcipher.c:539
 gcmaes_crypt_by_sg+0x323/0x8a0 arch/x86/crypto/aesni-intel_glue.c:658
Modules linked in:
---[ end trace 15593fd836276143 ]---
RIP: 0010:scatterwalk_start include/crypto/scatterwalk.h:68 [inline]
RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:93 [inline]
RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:77 [inline]
RIP: 0010:scatterwalk_copychunks+0x4db/0x6a0 crypto/scatterwalk.c:50
Code: ff df 80 3c 02 00 0f 85 b4 01 00 00 49 8d 44 24 08 4d 89 26 48 89 c2 48 89 44 24 18 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 77 01 00 00 48 b8 00 00 00 00
RSP: 0018:ffffc90000dff620 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff83c45a33 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88801ba09d1b
R10: ffffffff83c459e3 R11: 000000000000d9e6 R12: 0000000000000000
R13: 0000000000000001 R14: ffffc90000dff880 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000540198 CR3: 0000000018d08000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
