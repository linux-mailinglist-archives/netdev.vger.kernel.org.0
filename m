Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB836976E1
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 08:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233626AbjBOHBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 02:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbjBOHBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 02:01:10 -0500
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809F93C38
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:00:48 -0800 (PST)
Received: by mail-io1-f77.google.com with SMTP id t185-20020a6bc3c2000000b00733ef3dabe3so11658856iof.14
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:00:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gkVHurq1Tzdby26mZNsHbKo1ABM0N0+6mPqsATRuffg=;
        b=TvQbUt4UEgDx9QJQIBKn2f5TYqOuutq2STsAhTY/x4ytO7f7uClX6TDbOJlWYT+Ln4
         G3u+IFA1FE6HOkFSxV4wRw+JCT01HQFxZg7UCE9JB5CvdkA9rOM/2eN4XYe8KHFo628F
         wturLmkf01sc4FLy/JCN3134GVmM05h1YQT0zdEzuX5zkC/NA7sKucZODJD5rgczgQp/
         /KeV6iJzoHAspV9BIzC2wgP81e97am+2g+q+C+KkBOz38VDBDtbDkhvueec9c0IUx/HS
         jDUhLIdwp+7lHpU44LkI/ILtNdzb5vjVUDYRFcHXXb10rOJIq/XIZ6xjUvgXWCgN0+IO
         ufnQ==
X-Gm-Message-State: AO0yUKX5NaQWhBtIirDDd0Ke2HGjKJYiGS98vo1yNyXKQcEPs69H43k/
        qAn5siU5HXlOOYRj1aq9Zdma4ImLbDrzsYpKCeSUriTNaXw1
X-Google-Smtp-Source: AK7set/YbAqV35eJ0s0AwHJYpdfXhNJUM6wxJa28B5vW4JZa69HMknumDLuvr9kTy8lrWiwY4BD0vaschqtgNTo3CfnKnIFYsFcj
MIME-Version: 1.0
X-Received: by 2002:a92:9413:0:b0:310:fb90:b618 with SMTP id
 c19-20020a929413000000b00310fb90b618mr442977ili.0.1676444447808; Tue, 14 Feb
 2023 23:00:47 -0800 (PST)
Date:   Tue, 14 Feb 2023 23:00:47 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cc25bd05f4b7a3d2@google.com>
Subject: [syzbot] WARNING in usb_tx_block/usb_submit_urb
From:   syzbot <syzbot+355c68b459d1d96c4d06@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kvalo@kernel.org, libertas-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f87b564686ee dt-bindings: usb: amlogic,meson-g12a-usb-ctrl..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=119f3aaf480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d59dd45f9349215
dashboard link: https://syzkaller.appspot.com/bug?extid=355c68b459d1d96c4d06
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17db7007480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1670f2b3480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/162f005fbb8d/disk-f87b5646.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/868c38dbb85a/vmlinux-f87b5646.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e560670dfb35/bzImage-f87b5646.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+355c68b459d1d96c4d06@syzkaller.appspotmail.com

usb 1-1: Product: syz
usb 1-1: Manufacturer: syz
usb 1-1: SerialNumber: syz
usb 1-1: config 0 descriptor??
------------[ cut here ]------------
URB ffff888112baaf00 submitted while active
WARNING: CPU: 0 PID: 12 at drivers/usb/core/urb.c:379 usb_submit_urb+0x14ec/0x1880 drivers/usb/core/urb.c:379
Modules linked in:
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 6.2.0-rc7-syzkaller-00232-gf87b564686ee #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
Workqueue: events request_firmware_work_func
RIP: 0010:usb_submit_urb+0x14ec/0x1880 drivers/usb/core/urb.c:379
Code: 89 de e8 87 86 88 fd 84 db 0f 85 a3 f3 ff ff e8 0a 8a 88 fd 4c 89 fe 48 c7 c7 00 2d a8 86 c6 05 14 8a 14 05 01 e8 18 06 19 02 <0f> 0b e9 81 f3 ff ff 48 89 7c 24 40 e8 e3 89 88 fd 48 8b 7c 24 40
RSP: 0018:ffffc900000cfa00 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8881002dd400 RSI: ffffffff812db84c RDI: fffff52000019f32
RBP: ffff888112baaf00 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: 00000000c0028200
R13: 0000000000000010 R14: 00000000fffffff0 R15: ffff888112baaf00
FS:  0000000000000000(0000) GS:ffff8881f6800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f165ac57130 CR3: 000000011215a000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 usb_tx_block+0x241/0x2e0 drivers/net/wireless/marvell/libertas/if_usb.c:436
 if_usb_issue_boot_command drivers/net/wireless/marvell/libertas/if_usb.c:766 [inline]
 if_usb_prog_firmware+0x531/0xe30 drivers/net/wireless/marvell/libertas/if_usb.c:859
 lbs_fw_loaded drivers/net/wireless/marvell/libertas/firmware.c:23 [inline]
 helper_firmware_cb drivers/net/wireless/marvell/libertas/firmware.c:80 [inline]
 helper_firmware_cb+0x1e9/0x2c0 drivers/net/wireless/marvell/libertas/firmware.c:64
 request_firmware_work_func+0x130/0x240 drivers/base/firmware_loader/main.c:1107
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2ee/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
