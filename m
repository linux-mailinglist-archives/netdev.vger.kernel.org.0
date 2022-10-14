Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3645FF424
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 21:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiJNThj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 15:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiJNThh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 15:37:37 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7377218A3CE
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 12:37:36 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id s3-20020a5eaa03000000b006bbdfc81c6fso3763221ioe.4
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 12:37:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rX/AbI3L9evs+/oSuEXoC2wLpzx4WySJz83LC24vFuo=;
        b=MsXA7YBpI9YSb9F/SsweuSTSWe9buhUC9puzA35B4FHaKFgYbjElCeDYadHqPvzEBA
         kxFkSO5CWTtbScXTJHwCzlJpHAgBV0BQU3pn00YfbJKgDefXRZKGkarcsAdGP2RWTNps
         gx3nsX3xPJ34kjPM+sJL2HMeM/rPVhScTmWeFQMg4nOB9BlSJ0aS1SELL81CZXHA2SCk
         Z7JKS6izQ2IweHfIoOojqpwvGjacqvavNwoyxMKR3F8GNd6HIY2ghuStLxW1jxIATrsd
         rN30JkZrtG04TT3EePi/Jin0VNURzFA5443Cy8v0v1VHPmFwyZ0dNqnFDMCqk5ICfkOZ
         PpLw==
X-Gm-Message-State: ACrzQf0ohJF+iBtQnxl7uUu1K1wbcBnVGV0n09O02eKgxIdfk46HLkr6
        fTrEEScEUZ5qwki4TtWIT47KfmbQ2yPnkoQ6VoyJiaQ8g22s
X-Google-Smtp-Source: AMsMyM5NoSc6CvLYIBk7FYOQdzxNu5HK3T8IwaQn9Lik5mN8eb54I6qQIsyC1XwBROSTqXdEBU/LteIrrdlOZpLXfglgPtiTXWba
MIME-Version: 1.0
X-Received: by 2002:a5d:9452:0:b0:6a3:4fab:d98e with SMTP id
 x18-20020a5d9452000000b006a34fabd98emr2950724ior.185.1665776255682; Fri, 14
 Oct 2022 12:37:35 -0700 (PDT)
Date:   Fri, 14 Oct 2022 12:37:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fecefc05eb03c144@google.com>
Subject: [syzbot] WARNING: ODEBUG bug in ieee80211_led_exit
From:   syzbot <syzbot+25842f13c5ac135060f4@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    a6afa4199d3d Merge tag 'mailbox-v6.1' of git://git.linaro...
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=158ad462880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9e5376a2f09d6389
dashboard link: https://syzkaller.appspot.com/bug?extid=25842f13c5ac135060f4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122c5d1a880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1154e478880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ee555c567c15/disk-a6afa419.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2124bd57845b/vmlinux-a6afa419.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+25842f13c5ac135060f4@syzkaller.appspotmail.com

usb 2-1: USB disconnect, device number 13
------------[ cut here ]------------
ODEBUG: free active (active state 0) object type: timer_list hint: tpt_trig_timer+0x0/0x3c0 net/mac80211/led.c:145
WARNING: CPU: 1 PID: 1297 at lib/debugobjects.c:502 debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Modules linked in:
CPU: 1 PID: 1297 Comm: kworker/1:0 Not tainted 6.0.0-syzkaller-09039-ga6afa4199d3d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
Workqueue: usb_hub_wq hub_event
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 80 dd 62 86 4c 89 ee 48 c7 c7 20 d1 62 86 e8 51 e1 af 03 <0f> 0b 83 05 c5 24 ca 06 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc90001457638 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff888108e8b900 RSI: ffffffff812c9988 RDI: fffff5200028aeb9
RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8649fc20
R13: ffffffff8662d640 R14: ffffffff81357820 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a3505dc950 CR3: 000000010ed33000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __debug_check_no_obj_freed lib/debugobjects.c:989 [inline]
 debug_check_no_obj_freed+0x301/0x420 lib/debugobjects.c:1020
 slab_free_hook mm/slub.c:1734 [inline]
 slab_free_freelist_hook mm/slub.c:1785 [inline]
 slab_free mm/slub.c:3539 [inline]
 kfree+0x104/0x5c0 mm/slub.c:4567
 ieee80211_led_exit+0x15e/0x1b0 net/mac80211/led.c:210
 ieee80211_unregister_hw+0x192/0x1f0 net/mac80211/main.c:1491
 rt2x00lib_remove_hw drivers/net/wireless/ralink/rt2x00/rt2x00dev.c:1084 [inline]
 rt2x00lib_remove_dev+0x42b/0x600 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c:1546
 rt2x00usb_disconnect+0x6d/0x240 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c:874
 usb_unbind_interface+0x1d8/0x8e0 drivers/usb/core/driver.c:458
 device_remove drivers/base/dd.c:550 [inline]
 device_remove+0x11f/0x170 drivers/base/dd.c:542
 __device_release_driver drivers/base/dd.c:1249 [inline]
 device_release_driver_internal+0x4a1/0x700 drivers/base/dd.c:1275
 bus_remove_device+0x2e3/0x590 drivers/base/bus.c:529
 device_del+0x4f3/0xc80 drivers/base/core.c:3704
 usb_disable_device+0x356/0x7a0 drivers/usb/core/message.c:1419
 usb_disconnect.cold+0x259/0x6ed drivers/usb/core/hub.c:2235
 hub_port_connect drivers/usb/core/hub.c:5197 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5497 [inline]
 port_event drivers/usb/core/hub.c:5653 [inline]
 hub_event+0x1f86/0x45e0 drivers/usb/core/hub.c:5735
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 process_scheduled_works kernel/workqueue.c:2352 [inline]
 worker_thread+0x854/0x1080 kernel/workqueue.c:2438
 kthread+0x2ea/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
