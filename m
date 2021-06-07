Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A67739E116
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhFGPrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:47:25 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:52992 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhFGPrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 11:47:24 -0400
Received: by mail-io1-f69.google.com with SMTP id e20-20020a6b50140000b02904b13c0d0212so7271426iob.19
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 08:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vggOEuSYGh0DPtk53CZVVjPXOtkcKPmtX+CgwTmSW6g=;
        b=HCdg9a+q98QoC+8+tgzfZx3XbpjrlZxWfedLSofBpgahFRw9n0Krdc5INSdzIa++Tm
         tfTjeLb8rjJ+MW5HbGP83F52yowy9GEp6uWxMozmOmoU4ezce2kv1ETSKpMwdlf8LKWW
         e1oMhbgrOKOcUzFWA/iISrG3x2TGvtVL53dXlk4a0hJObe3g+cieKI4Yu9VC+fQJ4CTv
         bDlvKAn9EDhLm+xuIa41VtpT+3+7FUsAIlBNUuCITvh7+M1LWQ+LcKlGIiqXIE+HBxQF
         IIQqaBqsiPcIG76gkDRA0TjG74CRgZMbqyY5X1PAAbak/qn7dFTt5ahrEPYWujpjLy8V
         JfnA==
X-Gm-Message-State: AOAM532HzKdwSsK3JUYode673TOvBpKPQC0wmGZ3y6/fj3eSkIHBa11C
        +hzx/hSqTMJTgIIaoiUiLh1brc5gZlFk6D7On3NM9CNxK4lx
X-Google-Smtp-Source: ABdhPJzBjp1H1H5Rcq6hgUBBT5DH5nKDd6JV1aYFnIgk0t8alMMGkJhQlDag1SIR/5qmGXs7eZADVee/XppNy+FXAoyfGGlKKyUW
MIME-Version: 1.0
X-Received: by 2002:a02:445:: with SMTP id 66mr16613269jab.11.1623080720530;
 Mon, 07 Jun 2021 08:45:20 -0700 (PDT)
Date:   Mon, 07 Jun 2021 08:45:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ca047005c42eedaf@google.com>
Subject: [syzbot] memory leak in hwsim_add_one
From:   syzbot <syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9d32fa5d Merge tag 'net-5.13-rc5' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15dee1bbd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=de8efb0998945e75
dashboard link: https://syzkaller.appspot.com/bug?extid=b80c9959009a9325cdff
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1706bbb5d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d708afd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com

Warning: Permanently added '10.128.1.19' (ECDSA) to the list of known hosts.
executing program
BUG: memory leak
unreferenced object 0xffff8881020ec480 (size 64):
  comm "swapper/0", pid 1, jiffies 4294937719 (age 53.000s)
  hex dump (first 32 bytes):
    60 5d 7c 06 81 88 ff ff c0 17 65 04 81 88 ff ff  `]|.......e.....
    80 35 12 42 81 88 ff ff 80 35 12 42 81 88 ff ff  .5.B.....5.B....
  backtrace:
    [<ffffffff82b09f12>] kmalloc include/linux/slab.h:556 [inline]
    [<ffffffff82b09f12>] kzalloc include/linux/slab.h:686 [inline]
    [<ffffffff82b09f12>] hwsim_alloc_edge.constprop.0+0x22/0x80 drivers/net/ieee802154/mac802154_hwsim.c:385
    [<ffffffff82b0b0f3>] hwsim_subscribe_all_others drivers/net/ieee802154/mac802154_hwsim.c:709 [inline]
    [<ffffffff82b0b0f3>] hwsim_add_one+0x3b3/0x640 drivers/net/ieee802154/mac802154_hwsim.c:802
    [<ffffffff82b0b3c4>] hwsim_probe+0x44/0xd0 drivers/net/ieee802154/mac802154_hwsim.c:848
    [<ffffffff82628bf1>] platform_probe+0x81/0x120 drivers/base/platform.c:1447
    [<ffffffff82625679>] really_probe+0x159/0x500 drivers/base/dd.c:576
    [<ffffffff82625aab>] driver_probe_device+0x8b/0x100 drivers/base/dd.c:763
    [<ffffffff82626325>] device_driver_attach+0x105/0x110 drivers/base/dd.c:1039
    [<ffffffff826263d1>] __driver_attach drivers/base/dd.c:1117 [inline]
    [<ffffffff826263d1>] __driver_attach+0xa1/0x140 drivers/base/dd.c:1070
    [<ffffffff82622459>] bus_for_each_dev+0xa9/0x100 drivers/base/bus.c:305
    [<ffffffff826244e0>] bus_add_driver+0x160/0x280 drivers/base/bus.c:622
    [<ffffffff82627233>] driver_register+0xc3/0x150 drivers/base/driver.c:171
    [<ffffffff874fa3dc>] hwsim_init_module+0xae/0x107 drivers/net/ieee802154/mac802154_hwsim.c:899
    [<ffffffff81001083>] do_one_initcall+0x63/0x2e0 init/main.c:1249
    [<ffffffff87489873>] do_initcall_level init/main.c:1322 [inline]
    [<ffffffff87489873>] do_initcalls init/main.c:1338 [inline]
    [<ffffffff87489873>] do_basic_setup init/main.c:1358 [inline]
    [<ffffffff87489873>] kernel_init_freeable+0x1f4/0x26e init/main.c:1560
    [<ffffffff84359255>] kernel_init+0xc/0x1a7 init/main.c:1447
    [<ffffffff810022ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

BUG: memory leak
unreferenced object 0xffff8881046517c0 (size 32):
  comm "swapper/0", pid 1, jiffies 4294937719 (age 53.000s)
  hex dump (first 32 bytes):
    ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff82b09f35>] kmalloc include/linux/slab.h:556 [inline]
    [<ffffffff82b09f35>] kzalloc include/linux/slab.h:686 [inline]
    [<ffffffff82b09f35>] hwsim_alloc_edge.constprop.0+0x45/0x80 drivers/net/ieee802154/mac802154_hwsim.c:389
    [<ffffffff82b0b0f3>] hwsim_subscribe_all_others drivers/net/ieee802154/mac802154_hwsim.c:709 [inline]
    [<ffffffff82b0b0f3>] hwsim_add_one+0x3b3/0x640 drivers/net/ieee802154/mac802154_hwsim.c:802
    [<ffffffff82b0b3c4>] hwsim_probe+0x44/0xd0 drivers/net/ieee802154/mac802154_hwsim.c:848
    [<ffffffff82628bf1>] platform_probe+0x81/0x120 drivers/base/platform.c:1447
    [<ffffffff82625679>] really_probe+0x159/0x500 drivers/base/dd.c:576
    [<ffffffff82625aab>] driver_probe_device+0x8b/0x100 drivers/base/dd.c:763
    [<ffffffff82626325>] device_driver_attach+0x105/0x110 drivers/base/dd.c:1039
    [<ffffffff826263d1>] __driver_attach drivers/base/dd.c:1117 [inline]
    [<ffffffff826263d1>] __driver_attach+0xa1/0x140 drivers/base/dd.c:1070
    [<ffffffff82622459>] bus_for_each_dev+0xa9/0x100 drivers/base/bus.c:305
    [<ffffffff826244e0>] bus_add_driver+0x160/0x280 drivers/base/bus.c:622
    [<ffffffff82627233>] driver_register+0xc3/0x150 drivers/base/driver.c:171
    [<ffffffff874fa3dc>] hwsim_init_module+0xae/0x107 drivers/net/ieee802154/mac802154_hwsim.c:899
    [<ffffffff81001083>] do_one_initcall+0x63/0x2e0 init/main.c:1249
    [<ffffffff87489873>] do_initcall_level init/main.c:1322 [inline]
    [<ffffffff87489873>] do_initcalls init/main.c:1338 [inline]
    [<ffffffff87489873>] do_basic_setup init/main.c:1358 [inline]
    [<ffffffff87489873>] kernel_init_freeable+0x1f4/0x26e init/main.c:1560
    [<ffffffff84359255>] kernel_init+0xc/0x1a7 init/main.c:1447
    [<ffffffff810022ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
