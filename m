Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944A13B0A33
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 18:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFVQX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 12:23:27 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:51980 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhFVQX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 12:23:26 -0400
Received: by mail-io1-f70.google.com with SMTP id x21-20020a5d99150000b02904e00bb129f0so9418920iol.18
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 09:21:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=S0Tp5XpSZKTuxJJ0tsXd8pwi+RpOy4/AcJ5oSiTyOak=;
        b=jlXRtHhR0elGv3QmBGpp7EuicE0ZSDs704rwjpj6NUmsfvzfa5elE5BVIe5WpJAx9e
         T8e5tf3H53PNqtQtQmOZR+bl0J9exnw6MddVhASZvdYQDR08Vf8ODpMfQP1mCzfIW1kq
         57W+CnUhArvw9tAOTOJguv3t7wv/G9QYb4aAdrnIchlr3Sx6oEFUkay07KXCd22sOn4/
         v9OW/o+zFlChOLh4yRMX8P90Jpf22VkDq2by89SNe8Wz7LWg344fc9L+SGv6wZK3iQ0f
         txfCCa1oUs68RTInpkG71pSERiFxdpLlTQDoViS8PTl+RXBWN0b9vMcmI8YZ9PPmKD+K
         vZSg==
X-Gm-Message-State: AOAM532bAFUXNTo2WiTp78+cSE+wGn+EiO2sw4vh9w8Mnw3NZ+kn5uNu
        PKvgWk2/d633vEXwI57j1/JzROBk3d6JNwcXPlFa5QJWzrAo
X-Google-Smtp-Source: ABdhPJwWxSGPNIzNCWkUmGwlT2fCur8b24ojEAV03WwffUjlKpl2FKkZ77Ch8nhAw1lRoGpmXNS7EG8HwLp5hoCDv5aKnwnLUpu1
MIME-Version: 1.0
X-Received: by 2002:a5d:89d0:: with SMTP id a16mr3521165iot.76.1624378870348;
 Tue, 22 Jun 2021 09:21:10 -0700 (PDT)
Date:   Tue, 22 Jun 2021 09:21:10 -0700
In-Reply-To: <20210622190701.653d94ca@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008c408b05c55d2d50@google.com>
Subject: Re: [syzbot] INFO: task hung in port100_probe
From:   syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>
To:     krzysztof.kozlowski@canonical.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING: ODEBUG bug in release_nodes

------------[ cut here ]------------
ODEBUG: free active (active state 0) object type: work_struct hint: port100_wq_cmd_complete+0x0/0x3b0 drivers/nfc/port100.c:1174
WARNING: CPU: 1 PID: 10270 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 1 PID: 10270 Comm: kworker/1:8 Not tainted 5.13.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd a0 f6 c2 89 4c 89 ee 48 c7 c7 a0 ea c2 89 e8 2d ee 01 05 <0f> 0b 83 05 25 2d 76 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc9000af76fc8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff888017f11c40 RSI: ffffffff815ce3a5 RDI: fffff520015eedeb
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815c820e R11: 0000000000000000 R12: ffffffff896ae040
R13: ffffffff89c2f0e0 R14: ffffffff814a7730 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb6ceabf000 CR3: 000000001cbec000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __debug_check_no_obj_freed lib/debugobjects.c:987 [inline]
 debug_check_no_obj_freed+0x301/0x420 lib/debugobjects.c:1018
 slab_free_hook mm/slub.c:1558 [inline]
 slab_free_freelist_hook+0x174/0x240 mm/slub.c:1608
 slab_free mm/slub.c:3168 [inline]
 kfree+0xe5/0x7f0 mm/slub.c:4212
 release_nodes+0x4a3/0x8f0 drivers/base/devres.c:524
 devres_release_all+0x74/0xd0 drivers/base/devres.c:545
 really_probe+0x557/0xf60 drivers/base/dd.c:644
 driver_probe_device+0x298/0x410 drivers/base/dd.c:763
 __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4b0 drivers/base/dd.c:938
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbe0/0x2100 drivers/base/core.c:3324
 usb_set_configuration+0x113f/0x1910 drivers/usb/core/message.c:2164
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
 really_probe+0x291/0xf60 drivers/base/dd.c:576
 driver_probe_device+0x298/0x410 drivers/base/dd.c:763
 __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4b0 drivers/base/dd.c:938
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbe0/0x2100 drivers/base/core.c:3324
 usb_new_device.cold+0x721/0x1058 drivers/usb/core/hub.c:2558
 hub_port_connect drivers/usb/core/hub.c:5278 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5418 [inline]
 port_event drivers/usb/core/hub.c:5564 [inline]
 hub_event+0x2357/0x4330 drivers/usb/core/hub.c:5646
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2276
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2422
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


Tested on:

commit:         a96bfed6 Merge tag 'for-linus' of git://git.armlinux.org.u..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12448400300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3932cedd2c2d4a69
dashboard link: https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=15683230300000

