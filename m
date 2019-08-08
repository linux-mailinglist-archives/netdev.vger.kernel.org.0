Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626FB8573C
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 02:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389026AbfHHAZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 20:25:07 -0400
Received: from mail-ot1-f69.google.com ([209.85.210.69]:49150 "EHLO
        mail-ot1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730382AbfHHAZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 20:25:07 -0400
Received: by mail-ot1-f69.google.com with SMTP id b4so58231276otf.15
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 17:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1A60PnqbP0Ql2yKqlJ3RIlroxIBztUP5S/L4CGHLiUw=;
        b=X2R+1x2GQFu/qYJN9+H3JH03bDq/zqSPJjzQNm9Kw9BJOIFIwiRbf2ylagiQknTrHM
         hUNIlVWbau9u8phKBJvn+dTyy0odDVVc2vdq75TVAEYJAC2LjhTDb8XdP/3v6WLisv17
         5PCfJJMFHJGzzqSKzdJ+hHzTXUq2xs0nD1WHbT+3NMqn5OnZAQ00AjUU/zScosYujbzD
         n7vPFQ5UGNhhBg4GrqaBHxqtFnQz4K2Asp0tB0mAI+wDU939B4ioHQodhQHFQoIQ9zKa
         s4bw/E57ikYFcmOkbyDJgbrq19YbJpzUEZVPIDGZ1X4mCRv6OzSNBcqiOSZdWQ2+CgTB
         BRDA==
X-Gm-Message-State: APjAAAXUpF4S0SeFA3s5MJMgKW7XyjKjMvpeXqyszG2Rf3m9vCaBimrZ
        Q7xMgfY26wbPd3BlTHV5NxxA6hrOluU8Ce5nXHyA+nhXhe3Z
X-Google-Smtp-Source: APXvYqw+NF40+vQ/3DS6uQwQOR78fru/CgaKCTpejWmRokRFmiBgcot6/1ryejq2NxWb/U4Ws1N7N45FpwPFPLcUjvHwO+aKwJqD
MIME-Version: 1.0
X-Received: by 2002:a5e:d618:: with SMTP id w24mr12136171iom.73.1565223906059;
 Wed, 07 Aug 2019 17:25:06 -0700 (PDT)
Date:   Wed, 07 Aug 2019 17:25:06 -0700
In-Reply-To: <000000000000d6a8ba058c0df076@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ea2c30058f901624@google.com>
Subject: Re: WARNING: ODEBUG bug in netdev_freemem (2)
From:   syzbot <syzbot+c4521ac872a4ccc3afec@syzkaller.appspotmail.com>
To:     alexander.h.duyck@intel.com, amritha.nambiar@intel.com,
        andriy.shevchenko@linux.intel.com, avagin@gmail.com,
        davem@davemloft.net, dmitry.torokhov@gmail.com, dvyukov@google.com,
        eric.dumazet@gmail.com, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, idosch@mellanox.com, jiri@mellanox.com,
        kimbrownkd@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, tyhicks@canonical.com, wanghai26@huawei.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    13dfb3fa Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1671e69a600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cf1ffb87d590d7
dashboard link: https://syzkaller.appspot.com/bug?extid=c4521ac872a4ccc3afec
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=170542c2600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c4521ac872a4ccc3afec@syzkaller.appspotmail.com

bond0 (unregistering): (slave bond_slave_1): Releasing backup interface
bond0 (unregistering): (slave bond_slave_0): Releasing backup interface
bond0 (unregistering): Released all slaves
------------[ cut here ]------------
ODEBUG: free active (active state 0) object type: timer_list hint:  
delayed_work_timer_fn+0x0/0x90 arch/x86/include/asm/paravirt.h:768
WARNING: CPU: 0 PID: 9919 at lib/debugobjects.c:481  
debug_print_object+0x168/0x250 lib/debugobjects.c:481
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9919 Comm: kworker/u4:6 Not tainted 5.3.0-rc3+ #122
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2dc/0x755 kernel/panic.c:219
  __warn.cold+0x20/0x4c kernel/panic.c:576
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:debug_print_object+0x168/0x250 lib/debugobjects.c:481
Code: dd e0 32 c6 87 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 b5 00 00 00 48  
8b 14 dd e0 32 c6 87 48 c7 c7 e0 27 c6 87 e8 70 cd 05 fe <0f> 0b 83 05 a3  
7c 67 06 01 48 83 c4 20 5b 41 5c 41 5d 41 5e 5d c3
RSP: 0018:ffff8880898ff838 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c3ba6 RDI: ffffed101131fef9
RBP: ffff8880898ff878 R08: ffff88808ece42c0 R09: ffffed1015d04101
R10: ffffed1015d04100 R11: ffff8880ae820807 R12: 0000000000000001
R13: ffffffff88db6660 R14: ffffffff8161da40 R15: ffff88808f639af0
  __debug_check_no_obj_freed lib/debugobjects.c:963 [inline]
  debug_check_no_obj_freed+0x2d4/0x43f lib/debugobjects.c:994
  kfree+0xf8/0x2c0 mm/slab.c:3755
  kvfree+0x61/0x70 mm/util.c:488
  netdev_freemem+0x4c/0x60 net/core/dev.c:9093
  netdev_release+0x86/0xb0 net/core/net-sysfs.c:1635
  device_release+0x7a/0x210 drivers/base/core.c:1064
  kobject_cleanup lib/kobject.c:693 [inline]
  kobject_release lib/kobject.c:722 [inline]
  kref_put include/linux/kref.h:65 [inline]
  kobject_put.cold+0x289/0x2e6 lib/kobject.c:739
  netdev_run_todo+0x53b/0x7b0 net/core/dev.c:8998
  rtnl_unlock+0xe/0x10 net/core/rtnetlink.c:112
  default_device_exit_batch+0x358/0x410 net/core/dev.c:9781
  ops_exit_list.isra.0+0xfc/0x150 net/core/net_namespace.c:175
  cleanup_net+0x4e2/0xa70 net/core/net_namespace.c:594
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Kernel Offset: disabled
Rebooting in 86400 seconds..

