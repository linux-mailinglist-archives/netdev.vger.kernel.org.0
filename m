Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD2411F53C
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 02:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfLOBLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 20:11:09 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:36801 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfLOBLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 20:11:08 -0500
Received: by mail-io1-f70.google.com with SMTP id 144so2971006iou.3
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 17:11:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=alNfUoEkuWSRZdtIqrjjboQiyrHVQRKKxp0yHeYHVEQ=;
        b=gq36uJ/AfdIzWH9m/mbdjDiawwwpl0GuQFqEC8kcAZYWGyjIumjxZKHX9Re/is9VI+
         eXOyQoM4iemnDtEIOu6IrZ1xDdXG0/YP56pYL01fybMtEXZeSpmYLd8/KVgmdINmsiMr
         TeXC0OR8qQzb4bcjewwKf1MklHJ+id1l6PajZE2sDFt03uQBjrFJfPELatSeIF0LpyjK
         ZnKixQa97pQ3/fLEAcCRw+MdJGwZLCBZzbVpezXq3peUN+cmqn+A5JmEVrzYyopCMoNG
         vy03U1CConKGJ+5dYi3y/spXugKA+PhHAxQieerqGGi772apgcwVg0UESxviyIlXtEUI
         UhQQ==
X-Gm-Message-State: APjAAAXtZQUzwc1p5fjOG3bfNMHljGKonLleuCqyFZIN0XV9gy6EW5AW
        M9TVxo/13P+wU4O5V0jKJIOR84OYUlEhJNc7CxzpMkk/QyqY
X-Google-Smtp-Source: APXvYqx689btpc1Zs3b3Q4nyZddXNrIGdxI5GN8tfxAvKmBfnCtUfVPP/uZ+1LfPmh+730t8JtM6pbT4s0a3lLOT2LO4Y0k/tetw
MIME-Version: 1.0
X-Received: by 2002:a92:3a9b:: with SMTP id i27mr3385385ilf.39.1576372268022;
 Sat, 14 Dec 2019 17:11:08 -0800 (PST)
Date:   Sat, 14 Dec 2019 17:11:08 -0800
In-Reply-To: <000000000000ca89a80598db0ae5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000011c6720599b3c5ae@google.com>
Subject: Re: general protection fault in gcmaes_crypt_by_sg (2)
From:   syzbot <syzbot+675c45cea768b3819803@syzkaller.appspotmail.com>
To:     bp@alien8.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        hpa@zytor.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    1d1997db Revert "nfp: abm: fix memory leak in nfp_abm_u32_..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1051508ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cef1fd5032faee91
dashboard link: https://syzkaller.appspot.com/bug?extid=675c45cea768b3819803
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d635a6e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=114489a9e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+675c45cea768b3819803@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 183 Comm: kworker/u4:3 Not tainted 5.5.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: pencrypt_parallel padata_parallel_worker
RIP: 0010:scatterwalk_start include/crypto/scatterwalk.h:68 [inline]
RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:93 [inline]
RIP: 0010:scatterwalk_done include/crypto/scatterwalk.h:101 [inline]
RIP: 0010:gcmaes_crypt_by_sg.constprop.0+0x1035/0x1aa0  
arch/x86/crypto/aesni-intel_glue.c:786
Code: e8 90 e8 52 02 48 89 84 24 a8 00 00 00 48 83 c0 08 48 89 c2 48 89 84  
24 90 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 08 3c 03 0f 8e 30 09 00 00 48 8b 84 24 a8 00
RSP: 0018:ffffc900012e7750 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000004000 RCX: ffffffff838cc029
RDX: 0000000000000001 RSI: ffffffff838cc07b RDI: 0000000000000007
RBP: ffffc900012e7b20 R08: ffff8880a8c46080 R09: 000000000000000d
R10: ffff8880a3efe660 R11: 00000000000000d0 R12: 0000000000004000
R13: 0000000000000000 R14: ffff8880a3efe300 R15: 0000000000004000
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff220a2d90 CR3: 00000000a8d5d000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  gcmaes_encrypt arch/x86/crypto/aesni-intel_glue.c:840 [inline]
  generic_gcmaes_encrypt+0x10d/0x160 arch/x86/crypto/aesni-intel_glue.c:1019
  crypto_aead_encrypt+0xaf/0xf0 crypto/aead.c:94
  simd_aead_encrypt+0x1a6/0x2b0 crypto/simd.c:335
  crypto_aead_encrypt+0xaf/0xf0 crypto/aead.c:94
  pcrypt_aead_enc+0x19/0x80 crypto/pcrypt.c:76
  padata_parallel_worker+0x28f/0x470 kernel/padata.c:81
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
------------[ cut here ]------------
WARNING: CPU: 1 PID: 183 at kernel/locking/mutex.c:1419  
mutex_trylock+0x279/0x2f0 kernel/locking/mutex.c:1427

