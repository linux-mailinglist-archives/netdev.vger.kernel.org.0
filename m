Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CED65FAF3
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 06:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjAFFix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 00:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjAFFiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 00:38:50 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725E65F90B
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 21:38:49 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id y24-20020a5ec818000000b006e2c0847835so323438iol.12
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 21:38:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9haJaoxzzlxIw80KSghijxYYontjX86CShnPu8UjfW4=;
        b=Oac7rOSpxLWIgaoGFbdeVTTq90W1wAOXWZ/afW7UHMiZv+kwJuMQGEergrT+HOBv4O
         xkwIwsfWI09X2V906/VrA4d1uG2OCw+0eaiPGXxhDQvufUjIQo+xTdk5sXFNLz688TM7
         0cBcTX0b2hWpg9JmSCA2k1oCgZvAGoJ7WzhWfWcLacchTn/1AQ+8vFi68NzYge7ySxOc
         GZYEjboSNVaixpe2keeI1F4zJleZ1s57kPcECNYu3wIOZ6uw4ke0cYtQ1aLjFYc7K5YH
         tYbXQxATbqcyrdKo9TQKY8CsRqGbFfYDpaHcnrngIZEvmzVamSFu0/uov2sVPscoFUw2
         MXVg==
X-Gm-Message-State: AFqh2kr+Jz//wujSh4+N8bjwCKj+G8EMbZ/CDzeo1H931e9rmpFVMcKO
        15ugPvh3lyaRaVkZeCfJ9pspCeTcz+vxXMxARn34hDxiwcEI
X-Google-Smtp-Source: AMrXdXsruXyrNEkCIYr6WYHzHNmYGVS2jLn5bC+W07DFgx/KzGjFaAh/wTFmxNS2SlEDLWf7FbBp2WpymlZEbGzufhoGGftuJW4I
MIME-Version: 1.0
X-Received: by 2002:a02:a510:0:b0:38a:1efa:7053 with SMTP id
 e16-20020a02a510000000b0038a1efa7053mr5097206jam.173.1672983528747; Thu, 05
 Jan 2023 21:38:48 -0800 (PST)
Date:   Thu, 05 Jan 2023 21:38:48 -0800
In-Reply-To: <000000000000cad14205ee10ec87@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f238aa05f191d4d6@google.com>
Subject: Re: [syzbot] BUG: unable to handle kernel paging request in p9_client_disconnect
From:   syzbot <syzbot+ea8b28e8dca42fc3bcbe@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, edumazet@google.com,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    247f34f7b803 Linux 6.1-rc2
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=145dcb52480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa9bed8d6a8992a0
dashboard link: https://syzkaller.appspot.com/bug?extid=ea8b28e8dca42fc3bcbe
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1360a90c480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1580e9e6480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/05f9a7fca332/disk-247f34f7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ec50c3ad7d48/vmlinux-247f34f7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1446f94b11ed/Image-247f34f7.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ea8b28e8dca42fc3bcbe@syzkaller.appspotmail.com

Unable to handle kernel paging request at virtual address 0032503900080052
Mem abort info:
  ESR = 0x0000000096000044
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000044
  CM = 0, WnR = 1
[0032503900080052] address between user and kernel address ranges
Internal error: Oops: 0000000096000044 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 3076 Comm: syz-executor424 Not tainted 6.1.0-rc2-syzkaller-154433-g247f34f7b803 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : p9_client_disconnect+0x1c/0x30 net/9p/client.c:1067
lr : p9_client_disconnect+0x18/0x30 net/9p/client.c:1065
sp : ffff800012e43ca0
x29: ffff800012e43ca0 x28: ffff0000cb48cec0 x27: 0000000000000000
x26: 00000000000000c0 x25: 0000000000000002 x24: ffff80000d37d050
x23: ffff80000d379000 x22: 0000000000000000 x21: 0000000000000000
x20: ffff0000cc82cf00 x19: 3032503900080002 x18: 0000000000000035
x17: 4553006964623d4d x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000000 x13: ffff0000c5860c18 x12: ffff0000ccb854d8
x11: ff8080000be7a520 x10: 0000000000000000 x9 : ffff80000be7a520
x8 : 0000000000000002 x7 : 0000000000000000 x6 : ffff80000c0374d8
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : ffff0000cb48cec0 x1 : 0000000000000000 x0 : 3032503900080002
Call trace:
 p9_client_disconnect+0x1c/0x30
 v9fs_session_cancel+0x20/0x30 fs/9p/v9fs.c:530
 v9fs_kill_super+0x2c/0x50 fs/9p/vfs_super.c:225
 deactivate_locked_super+0x70/0xe8 fs/super.c:331
 deactivate_super+0xd0/0xd4 fs/super.c:362
 cleanup_mnt+0x184/0x1c0 fs/namespace.c:1186
 __cleanup_mnt+0x20/0x30 fs/namespace.c:1193
 task_work_run+0x100/0x148 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x174/0x1f0 arch/arm64/kernel/signal.c:1127
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0x9c/0x150 arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:654
 el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581
Code: 910003fd aa0003f3 9710b2fd 52800048 (b9005268) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	910003fd 	mov	x29, sp
   4:	aa0003f3 	mov	x19, x0
   8:	9710b2fd 	bl	0xfffffffffc42cbfc
   c:	52800048 	mov	w8, #0x2                   	// #2
* 10:	b9005268 	str	w8, [x19, #80] <-- trapping instruction

