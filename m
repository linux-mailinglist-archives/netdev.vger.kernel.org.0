Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E7C634051
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 16:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiKVPgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 10:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbiKVPgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 10:36:02 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C916F359
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 07:35:43 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id 13-20020a056e0216cd00b003023e8b7d03so10813097ilx.7
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 07:35:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FybAGmp4BbsPjSoEeGjsL2UWXFm29CqL7tXapCANqIc=;
        b=dosQdRnSNbv8Puqkc5WEbZeNRL7p9jfDjiwtEKZnC77q6c4vkNudMafDEld6EIvqhD
         JG5ZDSCuP32G8Dvd2okhuEkiwBwaZDsq4uy14TrH6SHpw4Gh5/52XZBRmiFkIh8JRlsg
         qc26J4Pql8Hc25mB4z2ImX0dUHz3eyJPZ8NI+HrOjU3NklLokGw98vw6nCpA93C0XPWj
         m1Ls+vQqOHvrMD/Okop3K71pYTxp1FPSGW4O8WcHe9pgxWs1RIYvJ3C6g1B7WJ8yWrmc
         h0IGmVXR3/ctszNXjcvYvAghVXto/ikUUzROjqJa8zY5h0P7yc/v9WLwK5kpBzBIVGNT
         GLfQ==
X-Gm-Message-State: ANoB5pnY1/yeigY8Lu6vueZkb+f8s62g6cBAGBQh8q7JS4HKYuAN6nLI
        8CvLGf7tDs2yyj8iZvZEjhv7kfbu4e643E93k9YzmRVTGumo
X-Google-Smtp-Source: AA0mqf5g7k/nFJPRGTnZdfeeydh62nJVXo1KeUOY4LE5TL48czuCU3II59FpuD8+o24q7J6r7iFr+EoA3rSuYkEnEjXJw9BuTqpf
MIME-Version: 1.0
X-Received: by 2002:a5e:a604:0:b0:6de:353:ab43 with SMTP id
 q4-20020a5ea604000000b006de0353ab43mr2182230ioi.40.1669131343153; Tue, 22 Nov
 2022 07:35:43 -0800 (PST)
Date:   Tue, 22 Nov 2022 07:35:43 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cad14205ee10ec87@google.com>
Subject: [syzbot] BUG: unable to handle kernel paging request in p9_client_disconnect
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

Hello,

syzbot found the following issue on:

HEAD commit:    a77d28d13789 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=113a41f9880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c4c990190d758078
dashboard link: https://syzkaller.appspot.com/bug?extid=ea8b28e8dca42fc3bcbe
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7c4b04ddbeb3/disk-a77d28d1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3ecedb0cf6ca/vmlinux-a77d28d1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/44c59c4393c7/Image-a77d28d1.gz.xz

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
CPU: 1 PID: 3127 Comm: syz-executor.1 Not tainted 6.1.0-rc6-syzkaller-32651-ga77d28d13789 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : p9_client_disconnect+0x1c/0x30 net/9p/client.c:1067
lr : p9_client_disconnect+0x18/0x30 net/9p/client.c:1065
sp : ffff800013c43ca0
x29: ffff800013c43ca0 x28: ffff0000f2cc8000 x27: 0000000000000000
x26: 00000000000000c0 x25: 0000000000000002 x24: ffff80000d3ad050
x23: ffff80000d3a9000 x22: 0000000000000000 x21: 0000000000000000
x20: ffff000105870300 x19: 3032503900080002 x18: 0000000000000369
x17: 53006964623d4d45 x16: ffff80000dc18158 x15: ffff0000f2cc8000
x14: 0000000000000008 x13: 00000000ffffffff x12: ffff0000f2cc8000
x11: ff8080000be9c0e0 x10: 0000000000000000 x9 : ffff80000be9c0e0
x8 : 0000000000000002 x7 : ffff80000c058c98 x6 : 0000000000000000
x5 : 0000000000000080 x4 : 0000000000000001 x3 : 0000000000000000
x2 : ffff0000f2cc8000 x1 : ffff80000cede3e6 x0 : 3032503900080002
Call trace:
 p9_client_disconnect+0x1c/0x30
 v9fs_session_cancel+0x20/0x30 fs/9p/v9fs.c:530
 v9fs_kill_super+0x2c/0x50 fs/9p/vfs_super.c:225
 deactivate_locked_super+0x70/0xe8 fs/super.c:332
 deactivate_super+0xd0/0xd4 fs/super.c:363
 cleanup_mnt+0x184/0x1c0 fs/namespace.c:1186
 __cleanup_mnt+0x20/0x30 fs/namespace.c:1193
 task_work_run+0x100/0x148 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 do_notify_resume+0x174/0x1f0 arch/arm64/kernel/signal.c:1127
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0x9c/0x150 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
Code: 910003fd aa0003f3 9710261f 52800048 (b9005268) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	910003fd 	mov	x29, sp
   4:	aa0003f3 	mov	x19, x0
   8:	9710261f 	bl	0xfffffffffc409884
   c:	52800048 	mov	w8, #0x2                   	// #2
* 10:	b9005268 	str	w8, [x19, #80] <-- trapping instruction


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
