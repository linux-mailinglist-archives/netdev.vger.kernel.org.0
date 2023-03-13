Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE11E6B6E4D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 05:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjCMEHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 00:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCMEHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 00:07:49 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E096B38B78
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 21:07:47 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id c7-20020a056e020cc700b0032305bab689so1148742ilj.14
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 21:07:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678680467;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6BxQX5geAW2yiyf23xq/5pz+19/W3Bs2jWf3P05nAMU=;
        b=VtcDfp6W/xKPIa98J80ZRTAuG6juNp6b37aX/S4GIWKSgjoJksBb3hbS6Hd8qYotDo
         sApiW0PdqmKu1b6Wzm1mlqjYMg24EqmN9a8RrAl9oOwEPfz/BpDaDsT5ZqwstbxwnV77
         CpGzyXPBIf2gsKsvsSZ3fK8XTQF7qQ/gXXrIOFHLZVa+F13/7veWq50EUGNVfUpvNKFj
         eWHEEjkX3oc6aToTsSfMF/cvLpGSflH6WTPp1PZWGQtNEmZn/+xKehn9AMJ55ykUJprB
         2TlDkrgxk2gihpbjbVlqCxK0I/J+ONv0iKEXFlQA8nN1Kyytls3Q74Sj77IHc2dumRFv
         lO+Q==
X-Gm-Message-State: AO0yUKWcIpAZVCwwUavmuxj1sBO+fmM7QHFPRZM8clDBATCp/H6YP9nf
        wz6nmCYHl9MimEw/pINykW3QYwZMyLg1rdozifKf3+RZufxq
X-Google-Smtp-Source: AK7set+6YmSoOsuZMNPbgTdK0SElCnNi2p+XuafXIIiCiFmnwNzUYFr2CYmBXIyoVxUJW6keCpIjHoBum8Pq1bsyIALA9IweD0GN
MIME-Version: 1.0
X-Received: by 2002:a02:7a45:0:b0:3ae:e73b:ff26 with SMTP id
 z5-20020a027a45000000b003aee73bff26mr16206005jad.1.1678680467173; Sun, 12 Mar
 2023 21:07:47 -0700 (PDT)
Date:   Sun, 12 Mar 2023 21:07:47 -0700
In-Reply-To: <0000000000009afa3c05f3c5988a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000effe1b05f6c04022@google.com>
Subject: Re: [syzbot] [scsi?] WARNING in remove_proc_entry (5)
From:   syzbot <syzbot+04a8437497bcfb4afa95@syzkaller.appspotmail.com>
To:     anna@kernel.org, chuck.lever@oracle.com, davem@davemloft.net,
        edumazet@google.com, jejb@linux.ibm.com, jlayton@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        trond.myklebust@hammerspace.com
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

HEAD commit:    134231664868 Merge tag 'staging-6.3-rc2' of git://git.kern..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16ae091ac80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8aef547e348b1ab8
dashboard link: https://syzkaller.appspot.com/bug?extid=04a8437497bcfb4afa95
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13f21b2ac80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ecb766c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/810b18cfd92d/disk-13423166.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/49409dbd680c/vmlinux-13423166.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c4a589bbe527/bzImage-13423166.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+04a8437497bcfb4afa95@syzkaller.appspotmail.com

name '2'
WARNING: CPU: 1 PID: 26 at fs/proc/generic.c:712 remove_proc_entry+0x38d/0x460 fs/proc/generic.c:712
Modules linked in:
CPU: 1 PID: 26 Comm: kworker/1:1 Not tainted 6.3.0-rc1-syzkaller-00274-g134231664868 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Workqueue: usb_hub_wq hub_event
RIP: 0010:remove_proc_entry+0x38d/0x460 fs/proc/generic.c:712
Code: e9 6d fe ff ff e8 c3 c2 7a ff 48 c7 c7 c0 68 99 8c e8 f7 e9 08 08 e8 b2 c2 7a ff 4c 89 e6 48 c7 c7 00 a8 5e 8a e8 33 df 42 ff <0f> 0b e9 a4 fe ff ff e8 97 c2 7a ff 48 8d bd d8 00 00 00 48 b8 00
RSP: 0018:ffffc90000a1f638 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 1ffff92000143ec9 RCX: 0000000000000000
RDX: ffff8880174e1d40 RSI: ffffffff814bf3a7 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffffc90000a1f710
R13: dffffc0000000000 R14: ffff88807abf4078 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f84e0c354b8 CR3: 00000000788c7000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 scsi_proc_host_rm+0x15d/0x1d0 drivers/scsi/scsi_proc.c:263
 scsi_remove_host+0x108/0x340 drivers/scsi/hosts.c:183
 quiesce_and_remove_host drivers/usb/storage/usb.c:867 [inline]
 usb_stor_disconnect+0x119/0x270 drivers/usb/storage/usb.c:1087
 usb_unbind_interface+0x1dc/0x8e0 drivers/usb/core/driver.c:458
 device_remove drivers/base/dd.c:542 [inline]
 device_remove+0x11f/0x170 drivers/base/dd.c:534
 __device_release_driver drivers/base/dd.c:1240 [inline]
 device_release_driver_internal+0x443/0x610 drivers/base/dd.c:1263
 bus_remove_device+0x22c/0x420 drivers/base/bus.c:574
 device_del+0x48a/0xb80 drivers/base/core.c:3775
 usb_disable_device+0x35a/0x7b0 drivers/usb/core/message.c:1420
 usb_disconnect+0x2db/0x8a0 drivers/usb/core/hub.c:2238
 hub_port_connect drivers/usb/core/hub.c:5246 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5551 [inline]
 port_event drivers/usb/core/hub.c:5711 [inline]
 hub_event+0x1fbf/0x4e40 drivers/usb/core/hub.c:5793
 process_one_work+0x991/0x1710 kernel/workqueue.c:2390
 process_scheduled_works kernel/workqueue.c:2453 [inline]
 worker_thread+0x858/0x1090 kernel/workqueue.c:2539
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

