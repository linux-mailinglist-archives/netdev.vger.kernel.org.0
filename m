Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D6D447954
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 05:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbhKHE1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 23:27:12 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:34397 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237426AbhKHE1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 23:27:11 -0500
Received: by mail-io1-f71.google.com with SMTP id k20-20020a5d97d4000000b005da6f3b7dc7so10650067ios.1
        for <netdev@vger.kernel.org>; Sun, 07 Nov 2021 20:24:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jj0xIfo2KzB7kQSJ9auzxPc3+VA8HLiH6Li4VX2HPn0=;
        b=ej2In+9YfuTBta1indl7ElZkVdceIHVJeUA8u+V9t9mVoFyhrzcuuoCf/ebk1RIXcH
         TlUcJ82wAWvudUNzhWBbIvvvGDZ/aXK49jcwNoaUg9dSKgME7EXniBc02vhTOOJsA7cr
         EIIim1gCTyriCj1z0J/S2sePsD71TvI8+rMUU7D8H4s4Oki3Myfs/RNd2JDtr5U36rFC
         myr+tyIp0fmRansB//4Ky5t/bLInex74t4NU6jA4S1yWi2a1WfnMVs7WI43UQDrU3yHZ
         wxUvrAOEKkIVurk/eV7+PgYhMPdezlFoT0YkFbAsVFA+SJDw6CiNseGK9J4vAqS8guJ4
         mq3Q==
X-Gm-Message-State: AOAM530IDlyC5D5RCgVgam7R4mbpVK6aA0snwVFbtVEBIVzOO/UpAGg2
        bkMRZmwcjBdC7qBr5wL88AB1PvwYgtBATuhmR/FXlwtIeahR
X-Google-Smtp-Source: ABdhPJyZCDMHcParfIhx8LnNuU6d+VIWK0tBzBPz6/McmA684K3l5loYaEejjZRbb/pXlM4kGMYhRxrTiIElRtUWttmuPpz7io+Y
MIME-Version: 1.0
X-Received: by 2002:a02:5b82:: with SMTP id g124mr21629365jab.89.1636345467120;
 Sun, 07 Nov 2021 20:24:27 -0800 (PST)
Date:   Sun, 07 Nov 2021 20:24:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004c317905d03f5e78@google.com>
Subject: [syzbot] WARNING: refcount bug in default_device_exit_batch
From:   syzbot <syzbot+5971b9b300c59af94177@syzkaller.appspotmail.com>
To:     changbin.du@intel.com, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    08fcdfa6e3ae nfc: port100: lower verbosity of cancelled UR..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=10325fb6b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5d447cdc3ae81d9
dashboard link: https://syzkaller.appspot.com/bug?extid=5971b9b300c59af94177
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5971b9b300c59af94177@syzkaller.appspotmail.com

bond0 (unregistering): (slave bond_slave_1): Releasing backup interface
bond0 (unregistering): (slave bond_slave_0): Releasing backup interface
bond0 (unregistering): Released all slaves
------------[ cut here ]------------
refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 0 PID: 15049 at lib/refcount.c:31 refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Modules linked in:
CPU: 0 PID: 15049 Comm: kworker/u4:8 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Code: 1d a9 13 82 09 31 ff 89 de e8 ad ae 9e fd 84 db 75 e0 e8 64 a8 9e fd 48 c7 c7 20 2a e4 89 c6 05 89 13 82 09 01 e8 c1 55 1b 05 <0f> 0b eb c4 e8 48 a8 9e fd 0f b6 1d 78 13 82 09 31 ff 89 de e8 78
RSP: 0018:ffffc900045dfa10 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888078fcba00 RSI: ffffffff815ef908 RDI: fffff520008bbf34
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815e96ee R11: 0000000000000000 R12: 0000000000000001
R13: ffffc900045dfb68 R14: ffff8880784105b0 R15: ffff88802a8bc5a0
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcf4f55b000 CR3: 000000001b5cc000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_dec include/linux/refcount.h:344 [inline]
 refcount_dec include/linux/refcount.h:359 [inline]
 dev_put include/linux/netdevice.h:4166 [inline]
 unregister_netdevice_many+0x12c9/0x1790 net/core/dev.c:11111
 default_device_exit_batch+0x2fa/0x3c0 net/core/dev.c:11604
 ops_exit_list+0x10d/0x160 net/core/net_namespace.c:171
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:593
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
