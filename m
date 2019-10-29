Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F10E7E77
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 03:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730335AbfJ2CNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 22:13:12 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:46697 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfJ2CNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 22:13:12 -0400
Received: by mail-io1-f72.google.com with SMTP id y25so9981539ioc.13
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 19:13:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=MYK2QjPsZfhKlvVB/dbEhri650u1tnAwJaSEV0S0z+0=;
        b=UKxvTVxs7fTXd4Z8rodkfZNMiaD/LsH45B7TWuuwq4L8+KhNeadmT8KPGdUU6Hs3hT
         /KgIA492GAUk0mJU2L1Ee8FE/vzxVIuI8zIUc9I1N8xB87MzJ3Fhn2QcAporkpyYlGry
         DaqdJKKyFAfB3hjZOdjYxJoIqzHOdEUmYaYfcA/XcR1CkaeYSD3Elwpqcn44CTmEGkdc
         9BCkFg/mbhxHdYtY/YdzEKBoxlF8QywFd3/UM7VwYvzTDWxHvPn9JrY/u2q70gIABWBq
         0DpSilj5CbLWJvrAaOJY0HJkzIfwZ9cTi9JP31wr1zT6AuxLhW3/yNycqpaXmDXj7yV6
         /9jA==
X-Gm-Message-State: APjAAAWmFRiIIxDUatFByp6c//IK6OLMjiU+QwOZulK6d/nZxvtCSURe
        fHFeMtfqrkvqGPmd88XNw0OVGBNIZvp0UQZT+vjP7ikMZarM
X-Google-Smtp-Source: APXvYqy5P9currk4o1LlHYz5mjaL4cUCzWcuNxJB4vDY7hMJgD0uppA78El5Sp9sbOS6xBpM+jH8Vrp8P/iB74JOGVu0RoZdlhmo
MIME-Version: 1.0
X-Received: by 2002:a6b:e30f:: with SMTP id u15mr1104643ioc.96.1572315189425;
 Mon, 28 Oct 2019 19:13:09 -0700 (PDT)
Date:   Mon, 28 Oct 2019 19:13:09 -0700
In-Reply-To: <0000000000009ea5720595dc03a3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000057532105960328f9@google.com>
Subject: Re: BUG: MAX_LOCKDEP_KEYS too low!
From:   syzbot <syzbot+692f39f040c1f415567b@syzkaller.appspotmail.com>
To:     allison@lohutok.net, ap420073@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, idosch@mellanox.com,
        ivan.khoronzhuk@linaro.org, jiri@mellanox.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        petrm@mellanox.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    60c1769a Add linux-next specific files for 20191028
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1593654ce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb86688f30db053d
dashboard link: https://syzkaller.appspot.com/bug?extid=692f39f040c1f415567b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10be9ed0e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+692f39f040c1f415567b@syzkaller.appspotmail.com

BUG: MAX_LOCKDEP_KEYS too low!
turning off the locking correctness validator.
CPU: 1 PID: 9023 Comm: kworker/u4:1 Not tainted 5.4.0-rc5-next-20191028 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  register_lock_class.cold+0x1b/0x27 kernel/locking/lockdep.c:1222
  __lock_acquire+0xf4/0x4a00 kernel/locking/lockdep.c:3837
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  netif_addr_lock_bh include/linux/netdevice.h:4071 [inline]
  dev_uc_flush+0x1e/0x40 net/core/dev_addr_lists.c:710
  rollback_registered_many+0x903/0x10d0 net/core/dev.c:8753
  unregister_netdevice_many.part.0+0x1b/0x1f0 net/core/dev.c:9906
  unregister_netdevice_many+0x3b/0x50 net/core/dev.c:9905
  ip6_tnl_exit_batch_net+0x513/0x700 net/ipv6/ip6_tunnel.c:2267
  ops_exit_list.isra.0+0x10c/0x160 net/core/net_namespace.c:175
  cleanup_net+0x538/0xaf0 net/core/net_namespace.c:597
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
kobject: 'rx-0' (00000000eea8c3d2): kobject_cleanup, parent 00000000367cd820
kobject: 'rx-0' (00000000eea8c3d2): auto cleanup 'remove' event
kobject: 'rx-0' (00000000eea8c3d2): kobject_uevent_env
kobject: 'rx-0' (00000000eea8c3d2): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000eea8c3d2): auto cleanup kobject_del
kobject: 'rx-0' (00000000eea8c3d2): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (000000002b8904d7): kobject_cleanup, parent 00000000367cd820
kobject: 'tx-0' (000000002b8904d7): auto cleanup 'remove' event
kobject: 'tx-0' (000000002b8904d7): kobject_uevent_env
kobject: 'tx-0' (000000002b8904d7): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (000000002b8904d7): auto cleanup kobject_del
kobject: 'tx-0' (000000002b8904d7): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000367cd820): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000367cd820): calling ktype release
kobject: 'queues' (00000000367cd820): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (000000001b7e467a): kobject_uevent_env
kobject: 'ip6tnl0' (000000001b7e467a): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000ba7f8910): kobject_cleanup, parent 00000000bb14840e
kobject: 'rx-0' (00000000ba7f8910): auto cleanup 'remove' event
kobject: 'rx-0' (00000000ba7f8910): kobject_uevent_env
kobject: 'rx-0' (00000000ba7f8910): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000ba7f8910): auto cleanup kobject_del
kobject: 'rx-0' (00000000ba7f8910): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000cea9eaa9): kobject_cleanup, parent 00000000bb14840e
kobject: 'tx-0' (00000000cea9eaa9): auto cleanup 'remove' event
kobject: 'tx-0' (00000000cea9eaa9): kobject_uevent_env
kobject: 'tx-0' (00000000cea9eaa9): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000cea9eaa9): auto cleanup kobject_del
kobject: 'tx-0' (00000000cea9eaa9): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000bb14840e): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000bb14840e): calling ktype release
kobject: 'queues' (00000000bb14840e): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (0000000080876c83): kobject_uevent_env
kobject: 'ip6tnl0' (0000000080876c83): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000005e3a1f09): kobject_cleanup, parent 000000009526650e
kobject: 'rx-0' (000000005e3a1f09): auto cleanup 'remove' event
kobject: 'rx-0' (000000005e3a1f09): kobject_uevent_env
kobject: 'rx-0' (000000005e3a1f09): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000005e3a1f09): auto cleanup kobject_del
kobject: 'rx-0' (000000005e3a1f09): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (000000007013d9ba): kobject_cleanup, parent 000000009526650e
kobject: 'tx-0' (000000007013d9ba): auto cleanup 'remove' event
kobject: 'tx-0' (000000007013d9ba): kobject_uevent_env
kobject: 'tx-0' (000000007013d9ba): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (000000007013d9ba): auto cleanup kobject_del
kobject: 'tx-0' (000000007013d9ba): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (000000009526650e): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (000000009526650e): calling ktype release
kobject: 'queues' (000000009526650e): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (0000000040bf3e5c): kobject_uevent_env
kobject: 'ip6tnl0' (0000000040bf3e5c): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000bcd086e7): kobject_cleanup, parent 00000000133f4245
kobject: 'rx-0' (00000000bcd086e7): auto cleanup 'remove' event
kobject: 'rx-0' (00000000bcd086e7): kobject_uevent_env
kobject: 'rx-0' (00000000bcd086e7): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000bcd086e7): auto cleanup kobject_del
kobject: 'rx-0' (00000000bcd086e7): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000195f0781): kobject_cleanup, parent 00000000133f4245
kobject: 'tx-0' (00000000195f0781): auto cleanup 'remove' event
kobject: 'tx-0' (00000000195f0781): kobject_uevent_env
kobject: 'tx-0' (00000000195f0781): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000195f0781): auto cleanup kobject_del
kobject: 'tx-0' (00000000195f0781): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000133f4245): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000133f4245): calling ktype release
kobject: 'queues' (00000000133f4245): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (000000003d151ae3): kobject_uevent_env
kobject: 'ip6tnl0' (000000003d151ae3): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000004c4745e2): kobject_cleanup, parent 0000000009f6d619
kobject: 'rx-0' (000000004c4745e2): auto cleanup 'remove' event
kobject: 'rx-0' (000000004c4745e2): kobject_uevent_env
kobject: 'rx-0' (000000004c4745e2): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000004c4745e2): auto cleanup kobject_del
kobject: 'rx-0' (000000004c4745e2): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000090e69b65): kobject_cleanup, parent 0000000009f6d619
kobject: 'tx-0' (0000000090e69b65): auto cleanup 'remove' event
kobject: 'tx-0' (0000000090e69b65): kobject_uevent_env
kobject: 'tx-0' (0000000090e69b65): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (0000000090e69b65): auto cleanup kobject_del
kobject: 'tx-0' (0000000090e69b65): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (0000000009f6d619): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (0000000009f6d619): calling ktype release
kobject: 'queues' (0000000009f6d619): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000b1708dc5): kobject_uevent_env
kobject: 'ip6tnl0' (00000000b1708dc5): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000fdf119dd): kobject_cleanup, parent 00000000f9c16576
kobject: 'rx-0' (00000000fdf119dd): auto cleanup 'remove' event
kobject: 'rx-0' (00000000fdf119dd): kobject_uevent_env
kobject: 'rx-0' (00000000fdf119dd): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000fdf119dd): auto cleanup kobject_del
kobject: 'rx-0' (00000000fdf119dd): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000094edacde): kobject_cleanup, parent 00000000f9c16576
kobject: 'tx-0' (0000000094edacde): auto cleanup 'remove' event
kobject: 'tx-0' (0000000094edacde): kobject_uevent_env
kobject: 'tx-0' (0000000094edacde): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (0000000094edacde): auto cleanup kobject_del
kobject: 'tx-0' (0000000094edacde): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000f9c16576): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000f9c16576): calling ktype release
kobject: 'queues' (00000000f9c16576): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (000000009428021b): kobject_uevent_env
kobject: 'ip6tnl0' (000000009428021b): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000380884c2): kobject_cleanup, parent 00000000026a04e8
kobject: 'rx-0' (00000000380884c2): auto cleanup 'remove' event
kobject: 'rx-0' (00000000380884c2): kobject_uevent_env
kobject: 'rx-0' (00000000380884c2): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000380884c2): auto cleanup kobject_del
kobject: 'rx-0' (00000000380884c2): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000c12e0932): kobject_cleanup, parent 00000000026a04e8
kobject: 'tx-0' (00000000c12e0932): auto cleanup 'remove' event
kobject: 'tx-0' (00000000c12e0932): kobject_uevent_env
kobject: 'tx-0' (00000000c12e0932): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000c12e0932): auto cleanup kobject_del
kobject: 'tx-0' (00000000c12e0932): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000026a04e8): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000026a04e8): calling ktype release
kobject: 'queues' (00000000026a04e8): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (0000000080c317a2): kobject_uevent_env
kobject: 'ip6tnl0' (0000000080c317a2): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000f9ffec35): kobject_cleanup, parent 00000000d21715b8
kobject: 'rx-0' (00000000f9ffec35): auto cleanup 'remove' event
kobject: 'rx-0' (00000000f9ffec35): kobject_uevent_env
kobject: 'rx-0' (00000000f9ffec35): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000f9ffec35): auto cleanup kobject_del
kobject: 'rx-0' (00000000f9ffec35): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000aba4c88a): kobject_cleanup, parent 00000000d21715b8
kobject: 'tx-0' (00000000aba4c88a): auto cleanup 'remove' event
kobject: 'tx-0' (00000000aba4c88a): kobject_uevent_env
kobject: 'tx-0' (00000000aba4c88a): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000aba4c88a): auto cleanup kobject_del
kobject: 'tx-0' (00000000aba4c88a): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000d21715b8): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000d21715b8): calling ktype release
kobject: 'queues' (00000000d21715b8): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (000000000766e6b7): kobject_uevent_env
kobject: 'ip6tnl0' (000000000766e6b7): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000002587a4e2): kobject_cleanup, parent 0000000098d54016
kobject: 'rx-0' (000000002587a4e2): auto cleanup 'remove' event
kobject: 'rx-0' (000000002587a4e2): kobject_uevent_env
kobject: 'rx-0' (000000002587a4e2): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000002587a4e2): auto cleanup kobject_del
kobject: 'rx-0' (000000002587a4e2): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (000000000d09491a): kobject_cleanup, parent 0000000098d54016
kobject: 'tx-0' (000000000d09491a): auto cleanup 'remove' event
kobject: 'tx-0' (000000000d09491a): kobject_uevent_env
kobject: 'tx-0' (000000000d09491a): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (000000000d09491a): auto cleanup kobject_del
kobject: 'tx-0' (000000000d09491a): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (0000000098d54016): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (0000000098d54016): calling ktype release
kobject: 'queues' (0000000098d54016): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (0000000085ed4d9f): kobject_uevent_env
kobject: 'ip6tnl0' (0000000085ed4d9f): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000c16965ca): kobject_cleanup, parent 000000000d68d6c8
kobject: 'rx-0' (00000000c16965ca): auto cleanup 'remove' event
kobject: 'rx-0' (00000000c16965ca): kobject_uevent_env
kobject: 'rx-0' (00000000c16965ca): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000c16965ca): auto cleanup kobject_del
kobject: 'rx-0' (00000000c16965ca): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (000000008c4e8b90): kobject_cleanup, parent 000000000d68d6c8
kobject: 'tx-0' (000000008c4e8b90): auto cleanup 'remove' event
kobject: 'tx-0' (000000008c4e8b90): kobject_uevent_env
kobject: 'tx-0' (000000008c4e8b90): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (000000008c4e8b90): auto cleanup kobject_del
kobject: 'tx-0' (000000008c4e8b90): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (000000000d68d6c8): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (000000000d68d6c8): calling ktype release
kobject: 'queues' (000000000d68d6c8): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000f18ef779): kobject_uevent_env
kobject: 'ip6tnl0' (00000000f18ef779): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000a1a0f829): kobject_cleanup, parent 00000000cb72b73b
kobject: 'rx-0' (00000000a1a0f829): auto cleanup 'remove' event
kobject: 'rx-0' (00000000a1a0f829): kobject_uevent_env
kobject: 'rx-0' (00000000a1a0f829): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000a1a0f829): auto cleanup kobject_del
kobject: 'rx-0' (00000000a1a0f829): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000296e42bc): kobject_cleanup, parent 00000000cb72b73b
kobject: 'tx-0' (00000000296e42bc): auto cleanup 'remove' event
kobject: 'tx-0' (00000000296e42bc): kobject_uevent_env
kobject: 'tx-0' (00000000296e42bc): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000296e42bc): auto cleanup kobject_del
kobject: 'tx-0' (00000000296e42bc): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000cb72b73b): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000cb72b73b): calling ktype release
kobject: 'queues' (00000000cb72b73b): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000ce9f8f54): kobject_uevent_env
kobject: 'ip6tnl0' (00000000ce9f8f54): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000030328650): kobject_cleanup, parent 0000000089e07b8e
kobject: 'rx-0' (0000000030328650): auto cleanup 'remove' event
kobject: 'rx-0' (0000000030328650): kobject_uevent_env
kobject: 'rx-0' (0000000030328650): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000030328650): auto cleanup kobject_del
kobject: 'rx-0' (0000000030328650): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (000000009866c942): kobject_cleanup, parent 0000000089e07b8e
kobject: 'tx-0' (000000009866c942): auto cleanup 'remove' event
kobject: 'tx-0' (000000009866c942): kobject_uevent_env
kobject: 'tx-0' (000000009866c942): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (000000009866c942): auto cleanup kobject_del
kobject: 'tx-0' (000000009866c942): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (0000000089e07b8e): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (0000000089e07b8e): calling ktype release
kobject: 'queues' (0000000089e07b8e): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000c755475e): kobject_uevent_env
kobject: 'ip6tnl0' (00000000c755475e): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000ea560299): kobject_cleanup, parent 000000000a4a28aa
kobject: 'rx-0' (00000000ea560299): auto cleanup 'remove' event
kobject: 'rx-0' (00000000ea560299): kobject_uevent_env
kobject: 'rx-0' (00000000ea560299): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000ea560299): auto cleanup kobject_del
kobject: 'rx-0' (00000000ea560299): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (000000006f6c82de): kobject_cleanup, parent 000000000a4a28aa
kobject: 'tx-0' (000000006f6c82de): auto cleanup 'remove' event
kobject: 'tx-0' (000000006f6c82de): kobject_uevent_env
kobject: 'tx-0' (000000006f6c82de): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (000000006f6c82de): auto cleanup kobject_del
kobject: 'tx-0' (000000006f6c82de): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (000000000a4a28aa): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (000000000a4a28aa): calling ktype release
kobject: 'queues' (000000000a4a28aa): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000e7ef1e92): kobject_uevent_env
kobject: 'ip6tnl0' (00000000e7ef1e92): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000112327c3): kobject_cleanup, parent 000000004e9f87b0
kobject: 'rx-0' (00000000112327c3): auto cleanup 'remove' event
kobject: 'rx-0' (00000000112327c3): kobject_uevent_env
kobject: 'rx-0' (00000000112327c3): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000112327c3): auto cleanup kobject_del
kobject: 'rx-0' (00000000112327c3): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (000000006bf26d5d): kobject_cleanup, parent 000000004e9f87b0
kobject: 'tx-0' (000000006bf26d5d): auto cleanup 'remove' event
kobject: 'tx-0' (000000006bf26d5d): kobject_uevent_env
kobject: 'tx-0' (000000006bf26d5d): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (000000006bf26d5d): auto cleanup kobject_del
kobject: 'tx-0' (000000006bf26d5d): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (000000004e9f87b0): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (000000004e9f87b0): calling ktype release
kobject: 'queues' (000000004e9f87b0): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (0000000039625f75): kobject_uevent_env
kobject: 'ip6tnl0' (0000000039625f75): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000a10df21b): kobject_cleanup, parent 00000000421ba6cf
kobject: 'rx-0' (00000000a10df21b): auto cleanup 'remove' event
kobject: 'rx-0' (00000000a10df21b): kobject_uevent_env
kobject: 'rx-0' (00000000a10df21b): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000a10df21b): auto cleanup kobject_del
kobject: 'rx-0' (00000000a10df21b): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000107519e4): kobject_cleanup, parent 00000000421ba6cf
kobject: 'tx-0' (00000000107519e4): auto cleanup 'remove' event
kobject: 'tx-0' (00000000107519e4): kobject_uevent_env
kobject: 'tx-0' (00000000107519e4): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000107519e4): auto cleanup kobject_del
kobject: 'tx-0' (00000000107519e4): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000421ba6cf): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000421ba6cf): calling ktype release
kobject: 'queues' (00000000421ba6cf): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000f20b5ca4): kobject_uevent_env
kobject: 'ip6tnl0' (00000000f20b5ca4): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000075d33cd4): kobject_cleanup, parent 00000000e8cacb0b
kobject: 'rx-0' (0000000075d33cd4): auto cleanup 'remove' event
kobject: 'rx-0' (0000000075d33cd4): kobject_uevent_env
kobject: 'rx-0' (0000000075d33cd4): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000075d33cd4): auto cleanup kobject_del
kobject: 'rx-0' (0000000075d33cd4): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000c34e2b92): kobject_cleanup, parent 00000000e8cacb0b
kobject: 'tx-0' (00000000c34e2b92): auto cleanup 'remove' event
kobject: 'tx-0' (00000000c34e2b92): kobject_uevent_env
kobject: 'tx-0' (00000000c34e2b92): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000c34e2b92): auto cleanup kobject_del
kobject: 'tx-0' (00000000c34e2b92): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000e8cacb0b): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000e8cacb0b): calling ktype release
kobject: 'queues' (00000000e8cacb0b): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (000000009e8b221b): kobject_uevent_env
kobject: 'ip6tnl0' (000000009e8b221b): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000788110a5): kobject_cleanup, parent 000000000143a596
kobject: 'rx-0' (00000000788110a5): auto cleanup 'remove' event
kobject: 'rx-0' (00000000788110a5): kobject_uevent_env
kobject: 'rx-0' (00000000788110a5): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000788110a5): auto cleanup kobject_del
kobject: 'rx-0' (00000000788110a5): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000003109053): kobject_cleanup, parent 000000000143a596
kobject: 'tx-0' (0000000003109053): auto cleanup 'remove' event
kobject: 'tx-0' (0000000003109053): kobject_uevent_env
kobject: 'tx-0' (0000000003109053): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (0000000003109053): auto cleanup kobject_del
kobject: 'tx-0' (0000000003109053): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (000000000143a596): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (000000000143a596): calling ktype release
kobject: 'queues' (000000000143a596): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (000000001ad078c4): kobject_uevent_env
kobject: 'ip6tnl0' (000000001ad078c4): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000040dfcfb4): kobject_cleanup, parent 000000002781a3bb
kobject: 'rx-0' (0000000040dfcfb4): auto cleanup 'remove' event
kobject: 'rx-0' (0000000040dfcfb4): kobject_uevent_env
kobject: 'rx-0' (0000000040dfcfb4): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000040dfcfb4): auto cleanup kobject_del
kobject: 'rx-0' (0000000040dfcfb4): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000cb09ba64): kobject_cleanup, parent 000000002781a3bb
kobject: 'tx-0' (00000000cb09ba64): auto cleanup 'remove' event
kobject: 'tx-0' (00000000cb09ba64): kobject_uevent_env
kobject: 'tx-0' (00000000cb09ba64): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000cb09ba64): auto cleanup kobject_del
kobject: 'tx-0' (00000000cb09ba64): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (000000002781a3bb): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (000000002781a3bb): calling ktype release
kobject: 'queues' (000000002781a3bb): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (0000000097e26490): kobject_uevent_env
kobject: 'ip6tnl0' (0000000097e26490): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000c5fb1c4d): kobject_cleanup, parent 00000000b3dc3a4a
kobject: 'rx-0' (00000000c5fb1c4d): auto cleanup 'remove' event
kobject: 'rx-0' (00000000c5fb1c4d): kobject_uevent_env
kobject: 'rx-0' (00000000c5fb1c4d): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000c5fb1c4d): auto cleanup kobject_del
kobject: 'rx-0' (00000000c5fb1c4d): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000082798dba): kobject_cleanup, parent 00000000b3dc3a4a
kobject: 'tx-0' (0000000082798dba): auto cleanup 'remove' event
kobject: 'tx-0' (0000000082798dba): kobject_uevent_env
kobject: 'tx-0' (0000000082798dba): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (0000000082798dba): auto cleanup kobject_del
kobject: 'tx-0' (0000000082798dba): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000b3dc3a4a): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000b3dc3a4a): calling ktype release
kobject: 'queues' (00000000b3dc3a4a): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000ade0fb2e): kobject_uevent_env
kobject: 'ip6tnl0' (00000000ade0fb2e): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000d0db84b9): kobject_cleanup, parent 00000000092581ca
kobject: 'rx-0' (00000000d0db84b9): auto cleanup 'remove' event
kobject: 'rx-0' (00000000d0db84b9): kobject_uevent_env
kobject: 'rx-0' (00000000d0db84b9): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000d0db84b9): auto cleanup kobject_del
kobject: 'rx-0' (00000000d0db84b9): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000ece4bb1b): kobject_cleanup, parent 00000000092581ca
kobject: 'tx-0' (00000000ece4bb1b): auto cleanup 'remove' event
kobject: 'tx-0' (00000000ece4bb1b): kobject_uevent_env
kobject: 'tx-0' (00000000ece4bb1b): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000ece4bb1b): auto cleanup kobject_del
kobject: 'tx-0' (00000000ece4bb1b): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000092581ca): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000092581ca): calling ktype release
kobject: 'queues' (00000000092581ca): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000f2aa5438): kobject_uevent_env
kobject: 'ip6tnl0' (00000000f2aa5438): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000081624947): kobject_cleanup, parent 00000000f8df54db
kobject: 'rx-0' (0000000081624947): auto cleanup 'remove' event
kobject: 'rx-0' (0000000081624947): kobject_uevent_env
kobject: 'rx-0' (0000000081624947): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000081624947): auto cleanup kobject_del
kobject: 'rx-0' (0000000081624947): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000d407f9bd): kobject_cleanup, parent 00000000f8df54db
kobject: 'tx-0' (00000000d407f9bd): auto cleanup 'remove' event
kobject: 'tx-0' (00000000d407f9bd): kobject_uevent_env
kobject: 'tx-0' (00000000d407f9bd): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000d407f9bd): auto cleanup kobject_del
kobject: 'tx-0' (00000000d407f9bd): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000f8df54db): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000f8df54db): calling ktype release
kobject: 'queues' (00000000f8df54db): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000a4cd34ec): kobject_uevent_env
kobject: 'ip6tnl0' (00000000a4cd34ec): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000e3f91292): kobject_cleanup, parent 00000000103d3017
kobject: 'rx-0' (00000000e3f91292): auto cleanup 'remove' event
kobject: 'rx-0' (00000000e3f91292): kobject_uevent_env
kobject: 'rx-0' (00000000e3f91292): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000e3f91292): auto cleanup kobject_del
kobject: 'rx-0' (00000000e3f91292): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000a1453585): kobject_cleanup, parent 00000000103d3017
kobject: 'tx-0' (00000000a1453585): auto cleanup 'remove' event
kobject: 'tx-0' (00000000a1453585): kobject_uevent_env
kobject: 'tx-0' (00000000a1453585): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000a1453585): auto cleanup kobject_del
kobject: 'tx-0' (00000000a1453585): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000103d3017): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000103d3017): calling ktype release
kobject: 'queues' (00000000103d3017): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000739c342c): kobject_uevent_env
kobject: 'ip6tnl0' (00000000739c342c): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000b71d7ef5): kobject_cleanup, parent 00000000fac547b1
kobject: 'rx-0' (00000000b71d7ef5): auto cleanup 'remove' event
kobject: 'rx-0' (00000000b71d7ef5): kobject_uevent_env
kobject: 'rx-0' (00000000b71d7ef5): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000b71d7ef5): auto cleanup kobject_del
kobject: 'rx-0' (00000000b71d7ef5): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (000000005503186a): kobject_cleanup, parent 00000000fac547b1
kobject: 'tx-0' (000000005503186a): auto cleanup 'remove' event
kobject: 'tx-0' (000000005503186a): kobject_uevent_env
kobject: 'tx-0' (000000005503186a): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (000000005503186a): auto cleanup kobject_del
kobject: 'tx-0' (000000005503186a): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000fac547b1): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000fac547b1): calling ktype release
kobject: 'queues' (00000000fac547b1): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000e7604124): kobject_uevent_env
kobject: 'ip6tnl0' (00000000e7604124): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000030ff8165): kobject_cleanup, parent 0000000045b54a43
kobject: 'rx-0' (0000000030ff8165): auto cleanup 'remove' event
kobject: 'rx-0' (0000000030ff8165): kobject_uevent_env
kobject: 'rx-0' (0000000030ff8165): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000030ff8165): auto cleanup kobject_del
kobject: 'rx-0' (0000000030ff8165): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000e9c950fe): kobject_cleanup, parent 0000000045b54a43
kobject: 'tx-0' (00000000e9c950fe): auto cleanup 'remove' event
kobject: 'tx-0' (00000000e9c950fe): kobject_uevent_env
kobject: 'tx-0' (00000000e9c950fe): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000e9c950fe): auto cleanup kobject_del
kobject: 'tx-0' (00000000e9c950fe): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (0000000045b54a43): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (0000000045b54a43): calling ktype release
kobject: 'queues' (0000000045b54a43): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (0000000032807634): kobject_uevent_env
kobject: 'ip6tnl0' (0000000032807634): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000078ce5917): kobject_cleanup, parent 00000000f127625e
kobject: 'rx-0' (0000000078ce5917): auto cleanup 'remove' event
kobject: 'rx-0' (0000000078ce5917): kobject_uevent_env
kobject: 'rx-0' (0000000078ce5917): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000078ce5917): auto cleanup kobject_del
kobject: 'rx-0' (0000000078ce5917): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000b02a1607): kobject_cleanup, parent 00000000f127625e
kobject: 'tx-0' (00000000b02a1607): auto cleanup 'remove' event
kobject: 'tx-0' (00000000b02a1607): kobject_uevent_env
kobject: 'tx-0' (00000000b02a1607): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000b02a1607): auto cleanup kobject_del
kobject: 'tx-0' (00000000b02a1607): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000f127625e): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000f127625e): calling ktype release
kobject: 'queues' (00000000f127625e): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000c1664d19): kobject_uevent_env
kobject: 'ip6tnl0' (00000000c1664d19): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000008ef3bbd8): kobject_cleanup, parent 00000000e0706d64
kobject: 'rx-0' (000000008ef3bbd8): auto cleanup 'remove' event
kobject: 'rx-0' (000000008ef3bbd8): kobject_uevent_env
kobject: 'rx-0' (000000008ef3bbd8): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000008ef3bbd8): auto cleanup kobject_del
kobject: 'rx-0' (000000008ef3bbd8): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (000000002a752e56): kobject_cleanup, parent 00000000e0706d64
kobject: 'tx-0' (000000002a752e56): auto cleanup 'remove' event
kobject: 'tx-0' (000000002a752e56): kobject_uevent_env
kobject: 'tx-0' (000000002a752e56): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (000000002a752e56): auto cleanup kobject_del
kobject: 'tx-0' (000000002a752e56): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000e0706d64): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000e0706d64): calling ktype release
kobject: 'queues' (00000000e0706d64): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000dce565aa): kobject_uevent_env
kobject: 'ip6tnl0' (00000000dce565aa): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000008f448495): kobject_cleanup, parent 00000000e739e9a7
kobject: 'rx-0' (000000008f448495): auto cleanup 'remove' event
kobject: 'rx-0' (000000008f448495): kobject_uevent_env
kobject: 'rx-0' (000000008f448495): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000008f448495): auto cleanup kobject_del
kobject: 'rx-0' (000000008f448495): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000ed1a8074): kobject_cleanup, parent 00000000e739e9a7
kobject: 'tx-0' (00000000ed1a8074): auto cleanup 'remove' event
kobject: 'tx-0' (00000000ed1a8074): kobject_uevent_env
kobject: 'tx-0' (00000000ed1a8074): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000ed1a8074): auto cleanup kobject_del
kobject: 'tx-0' (00000000ed1a8074): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000e739e9a7): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000e739e9a7): calling ktype release
kobject: 'queues' (00000000e739e9a7): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000363c96b4): kobject_uevent_env
kobject: 'ip6tnl0' (00000000363c96b4): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000006bf7aa0f): kobject_cleanup, parent 000000004e1620d9
kobject: 'rx-0' (000000006bf7aa0f): auto cleanup 'remove' event
kobject: 'rx-0' (000000006bf7aa0f): kobject_uevent_env
kobject: 'rx-0' (000000006bf7aa0f): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000006bf7aa0f): auto cleanup kobject_del
kobject: 'rx-0' (000000006bf7aa0f): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000024f44adb): kobject_cleanup, parent 000000004e1620d9
kobject: 'tx-0' (0000000024f44adb): auto cleanup 'remove' event
kobject: 'tx-0' (0000000024f44adb): kobject_uevent_env
kobject: 'tx-0' (0000000024f44adb): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (0000000024f44adb): auto cleanup kobject_del
kobject: 'tx-0' (0000000024f44adb): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (000000004e1620d9): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (000000004e1620d9): calling ktype release
kobject: 'queues' (000000004e1620d9): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000ba749c65): kobject_uevent_env
kobject: 'ip6tnl0' (00000000ba749c65): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000005ee8aba): kobject_cleanup, parent 00000000d473a23a
kobject: 'rx-0' (0000000005ee8aba): auto cleanup 'remove' event
kobject: 'rx-0' (0000000005ee8aba): kobject_uevent_env
kobject: 'rx-0' (0000000005ee8aba): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000005ee8aba): auto cleanup kobject_del
kobject: 'rx-0' (0000000005ee8aba): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000d93f7c83): kobject_cleanup, parent 00000000d473a23a
kobject: 'tx-0' (00000000d93f7c83): auto cleanup 'remove' event
kobject: 'tx-0' (00000000d93f7c83): kobject_uevent_env
kobject: 'tx-0' (00000000d93f7c83): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000d93f7c83): auto cleanup kobject_del
kobject: 'tx-0' (00000000d93f7c83): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000d473a23a): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000d473a23a): calling ktype release
kobject: 'queues' (00000000d473a23a): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (000000002d4c243c): kobject_uevent_env
kobject: 'ip6tnl0' (000000002d4c243c): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000c7c7c7cc): kobject_cleanup, parent 00000000a94adb00
kobject: 'rx-0' (00000000c7c7c7cc): auto cleanup 'remove' event
kobject: 'rx-0' (00000000c7c7c7cc): kobject_uevent_env
kobject: 'rx-0' (00000000c7c7c7cc): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000c7c7c7cc): auto cleanup kobject_del
kobject: 'rx-0' (00000000c7c7c7cc): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000f1d8d94c): kobject_cleanup, parent 00000000a94adb00
kobject: 'tx-0' (00000000f1d8d94c): auto cleanup 'remove' event
kobject: 'tx-0' (00000000f1d8d94c): kobject_uevent_env
kobject: 'tx-0' (00000000f1d8d94c): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000f1d8d94c): auto cleanup kobject_del
kobject: 'tx-0' (00000000f1d8d94c): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000a94adb00): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000a94adb00): calling ktype release
kobject: 'queues' (00000000a94adb00): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (000000002e5f7694): kobject_uevent_env
kobject: 'ip6tnl0' (000000002e5f7694): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000e7ab9125): kobject_cleanup, parent 0000000003b0e079
kobject: 'rx-0' (00000000e7ab9125): auto cleanup 'remove' event
kobject: 'rx-0' (00000000e7ab9125): kobject_uevent_env
kobject: 'rx-0' (00000000e7ab9125): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000e7ab9125): auto cleanup kobject_del
kobject: 'rx-0' (00000000e7ab9125): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000037cfd3d0): kobject_cleanup, parent 0000000003b0e079
kobject: 'tx-0' (0000000037cfd3d0): auto cleanup 'remove' event
kobject: 'tx-0' (0000000037cfd3d0): kobject_uevent_env
kobject: 'tx-0' (0000000037cfd3d0): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (0000000037cfd3d0): auto cleanup kobject_del
kobject: 'tx-0' (0000000037cfd3d0): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (0000000003b0e079): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (0000000003b0e079): calling ktype release
kobject: 'queues' (0000000003b0e079): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000f5b20f05): kobject_uevent_env
kobject: 'ip6tnl0' (00000000f5b20f05): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000083cf88e5): kobject_cleanup, parent 00000000bf11412b
kobject: 'rx-0' (0000000083cf88e5): auto cleanup 'remove' event
kobject: 'rx-0' (0000000083cf88e5): kobject_uevent_env
kobject: 'rx-0' (0000000083cf88e5): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000083cf88e5): auto cleanup kobject_del
kobject: 'rx-0' (0000000083cf88e5): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000068b85ec1): kobject_cleanup, parent 00000000bf11412b
kobject: 'tx-0' (0000000068b85ec1): auto cleanup 'remove' event
kobject: 'tx-0' (0000000068b85ec1): kobject_uevent_env
kobject: 'tx-0' (0000000068b85ec1): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (0000000068b85ec1): auto cleanup kobject_del
kobject: 'tx-0' (0000000068b85ec1): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000bf11412b): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000bf11412b): calling ktype release
kobject: 'queues' (00000000bf11412b): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (0000000093b58c60): kobject_uevent_env
kobject: 'ip6tnl0' (0000000093b58c60): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000077834b68): kobject_cleanup, parent 00000000c986f201
kobject: 'rx-0' (0000000077834b68): auto cleanup 'remove' event
kobject: 'rx-0' (0000000077834b68): kobject_uevent_env
kobject: 'rx-0' (0000000077834b68): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000077834b68): auto cleanup kobject_del
kobject: 'rx-0' (0000000077834b68): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000bee8b729): kobject_cleanup, parent 00000000c986f201
kobject: 'tx-0' (00000000bee8b729): auto cleanup 'remove' event
kobject: 'tx-0' (00000000bee8b729): kobject_uevent_env
kobject: 'tx-0' (00000000bee8b729): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000bee8b729): auto cleanup kobject_del
kobject: 'tx-0' (00000000bee8b729): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000c986f201): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000c986f201): calling ktype release
kobject: 'queues' (00000000c986f201): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (0000000091aef4c6): kobject_uevent_env
kobject: 'ip6tnl0' (0000000091aef4c6): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000f39a52d9): kobject_cleanup, parent 00000000a73f4759
kobject: 'rx-0' (00000000f39a52d9): auto cleanup 'remove' event
kobject: 'rx-0' (00000000f39a52d9): kobject_uevent_env
kobject: 'rx-0' (00000000f39a52d9): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000f39a52d9): auto cleanup kobject_del
kobject: 'rx-0' (00000000f39a52d9): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000651416d7): kobject_cleanup, parent 00000000a73f4759
kobject: 'tx-0' (00000000651416d7): auto cleanup 'remove' event
kobject: 'tx-0' (00000000651416d7): kobject_uevent_env
kobject: 'tx-0' (00000000651416d7): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000651416d7): auto cleanup kobject_del
kobject: 'tx-0' (00000000651416d7): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000a73f4759): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000a73f4759): calling ktype release
kobject: 'queues' (00000000a73f4759): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000c1469f01): kobject_uevent_env
kobject: 'ip6tnl0' (00000000c1469f01): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000cc125fec): kobject_cleanup, parent 000000004f65ed89
kobject: 'rx-0' (00000000cc125fec): auto cleanup 'remove' event
kobject: 'rx-0' (00000000cc125fec): kobject_uevent_env
kobject: 'rx-0' (00000000cc125fec): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000cc125fec): auto cleanup kobject_del
kobject: 'rx-0' (00000000cc125fec): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000aa3d87a5): kobject_cleanup, parent 000000004f65ed89
kobject: 'tx-0' (00000000aa3d87a5): auto cleanup 'remove' event
kobject: 'tx-0' (00000000aa3d87a5): kobject_uevent_env
kobject: 'tx-0' (00000000aa3d87a5): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000aa3d87a5): auto cleanup kobject_del
kobject: 'tx-0' (00000000aa3d87a5): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (000000004f65ed89): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (000000004f65ed89): calling ktype release
kobject: 'queues' (000000004f65ed89): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (0000000009f46b44): kobject_uevent_env
kobject: 'ip6tnl0' (0000000009f46b44): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000004fd79cba): kobject_cleanup, parent 00000000f418ad6d
kobject: 'rx-0' (000000004fd79cba): auto cleanup 'remove' event
kobject: 'rx-0' (000000004fd79cba): kobject_uevent_env
kobject: 'rx-0' (000000004fd79cba): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000004fd79cba): auto cleanup kobject_del
kobject: 'rx-0' (000000004fd79cba): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000056c3d2d5): kobject_cleanup, parent 00000000f418ad6d
kobject: 'tx-0' (0000000056c3d2d5): auto cleanup 'remove' event
kobject: 'tx-0' (0000000056c3d2d5): kobject_uevent_env
kobject: 'tx-0' (0000000056c3d2d5): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (0000000056c3d2d5): auto cleanup kobject_del
kobject: 'tx-0' (0000000056c3d2d5): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000f418ad6d): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000f418ad6d): calling ktype release
kobject: 'queues' (00000000f418ad6d): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (000000001ec2e741): kobject_uevent_env
kobject: 'ip6tnl0' (000000001ec2e741): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000a13f4620): kobject_cleanup, parent 000000001c0eb7a0
kobject: 'rx-0' (00000000a13f4620): auto cleanup 'remove' event
kobject: 'rx-0' (00000000a13f4620): kobject_uevent_env
kobject: 'rx-0' (00000000a13f4620): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000a13f4620): auto cleanup kobject_del
kobject: 'rx-0' (00000000a13f4620): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (000000004c060262): kobject_cleanup, parent 000000001c0eb7a0
kobject: 'tx-0' (000000004c060262): auto cleanup 'remove' event
kobject: 'tx-0' (000000004c060262): kobject_uevent_env
kobject: 'tx-0' (000000004c060262): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (000000004c060262): auto cleanup kobject_del
kobject: 'tx-0' (000000004c060262): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (000000001c0eb7a0): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (000000001c0eb7a0): calling ktype release
kobject: 'queues' (000000001c0eb7a0): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000644379f0): kobject_uevent_env
kobject: 'ip6tnl0' (00000000644379f0): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000cc3c2bde): kobject_cleanup, parent 000000001d60cc97
kobject: 'rx-0' (00000000cc3c2bde): auto cleanup 'remove' event
kobject: 'rx-0' (00000000cc3c2bde): kobject_uevent_env
kobject: 'rx-0' (00000000cc3c2bde): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000cc3c2bde): auto cleanup kobject_del
kobject: 'rx-0' (00000000cc3c2bde): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000ec04bf4e): kobject_cleanup, parent 000000001d60cc97
kobject: 'tx-0' (00000000ec04bf4e): auto cleanup 'remove' event
kobject: 'tx-0' (00000000ec04bf4e): kobject_uevent_env
kobject: 'tx-0' (00000000ec04bf4e): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000ec04bf4e): auto cleanup kobject_del
kobject: 'tx-0' (00000000ec04bf4e): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (000000001d60cc97): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (000000001d60cc97): calling ktype release
kobject: 'queues' (000000001d60cc97): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000fab6cfac): kobject_uevent_env
kobject: 'ip6tnl0' (00000000fab6cfac): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000a1cc7759): kobject_cleanup, parent 00000000a453fa18
kobject: 'rx-0' (00000000a1cc7759): auto cleanup 'remove' event
kobject: 'rx-0' (00000000a1cc7759): kobject_uevent_env
kobject: 'rx-0' (00000000a1cc7759): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000a1cc7759): auto cleanup kobject_del
kobject: 'rx-0' (00000000a1cc7759): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (000000001ffeed35): kobject_cleanup, parent 00000000a453fa18
kobject: 'tx-0' (000000001ffeed35): auto cleanup 'remove' event
kobject: 'tx-0' (000000001ffeed35): kobject_uevent_env
kobject: 'tx-0' (000000001ffeed35): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (000000001ffeed35): auto cleanup kobject_del
kobject: 'tx-0' (000000001ffeed35): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000a453fa18): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000a453fa18): calling ktype release
kobject: 'queues' (00000000a453fa18): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (000000009dd7a75c): kobject_uevent_env
kobject: 'ip6tnl0' (000000009dd7a75c): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000009031384a): kobject_cleanup, parent 0000000027e7567d
kobject: 'rx-0' (000000009031384a): auto cleanup 'remove' event
kobject: 'rx-0' (000000009031384a): kobject_uevent_env
kobject: 'rx-0' (000000009031384a): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000009031384a): auto cleanup kobject_del
kobject: 'rx-0' (000000009031384a): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000050aa2c2d): kobject_cleanup, parent 0000000027e7567d
kobject: 'tx-0' (0000000050aa2c2d): auto cleanup 'remove' event
kobject: 'tx-0' (0000000050aa2c2d): kobject_uevent_env
kobject: 'tx-0' (0000000050aa2c2d): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (0000000050aa2c2d): auto cleanup kobject_del
kobject: 'tx-0' (0000000050aa2c2d): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (0000000027e7567d): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (0000000027e7567d): calling ktype release
kobject: 'queues' (0000000027e7567d): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (000000002e882b3f): kobject_uevent_env
kobject: 'ip6tnl0' (000000002e882b3f): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000a2ffc16d): kobject_cleanup, parent 00000000b94864d9
kobject: 'rx-0' (00000000a2ffc16d): auto cleanup 'remove' event
kobject: 'rx-0' (00000000a2ffc16d): kobject_uevent_env
kobject: 'rx-0' (00000000a2ffc16d): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000a2ffc16d): auto cleanup kobject_del
kobject: 'rx-0' (00000000a2ffc16d): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (000000009e5a1673): kobject_cleanup, parent 00000000b94864d9
kobject: 'tx-0' (000000009e5a1673): auto cleanup 'remove' event
kobject: 'tx-0' (000000009e5a1673): kobject_uevent_env
kobject: 'tx-0' (000000009e5a1673): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (000000009e5a1673): auto cleanup kobject_del
kobject: 'tx-0' (000000009e5a1673): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000b94864d9): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000b94864d9): calling ktype release
kobject: 'queues' (00000000b94864d9): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000a094afa4): kobject_uevent_env
kobject: 'ip6tnl0' (00000000a094afa4): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000f1d11fd3): kobject_cleanup, parent 00000000f07688cc
kobject: 'rx-0' (00000000f1d11fd3): auto cleanup 'remove' event
kobject: 'rx-0' (00000000f1d11fd3): kobject_uevent_env
kobject: 'rx-0' (00000000f1d11fd3): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000f1d11fd3): auto cleanup kobject_del
kobject: 'rx-0' (00000000f1d11fd3): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (000000008e9c989a): kobject_cleanup, parent 00000000f07688cc
kobject: 'tx-0' (000000008e9c989a): auto cleanup 'remove' event
kobject: 'tx-0' (000000008e9c989a): kobject_uevent_env
kobject: 'tx-0' (000000008e9c989a): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (000000008e9c989a): auto cleanup kobject_del
kobject: 'tx-0' (000000008e9c989a): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000f07688cc): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000f07688cc): calling ktype release
kobject: 'queues' (00000000f07688cc): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (000000007bf38efe): kobject_uevent_env
kobject: 'ip6tnl0' (000000007bf38efe): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000367e22e6): kobject_cleanup, parent 00000000b7635fd6
kobject: 'rx-0' (00000000367e22e6): auto cleanup 'remove' event
kobject: 'rx-0' (00000000367e22e6): kobject_uevent_env
kobject: 'rx-0' (00000000367e22e6): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000367e22e6): auto cleanup kobject_del
kobject: 'rx-0' (00000000367e22e6): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000966701e0): kobject_cleanup, parent 00000000b7635fd6
kobject: 'tx-0' (00000000966701e0): auto cleanup 'remove' event
kobject: 'tx-0' (00000000966701e0): kobject_uevent_env
kobject: 'tx-0' (00000000966701e0): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000966701e0): auto cleanup kobject_del
kobject: 'tx-0' (00000000966701e0): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000b7635fd6): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000b7635fd6): calling ktype release
kobject: 'queues' (00000000b7635fd6): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000c703baf3): kobject_uevent_env
kobject: 'ip6tnl0' (00000000c703baf3): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000031e989c4): kobject_cleanup, parent 00000000a1f82989
kobject: 'rx-0' (0000000031e989c4): auto cleanup 'remove' event
kobject: 'rx-0' (0000000031e989c4): kobject_uevent_env
kobject: 'rx-0' (0000000031e989c4): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000031e989c4): auto cleanup kobject_del
kobject: 'rx-0' (0000000031e989c4): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000036212232): kobject_cleanup, parent 00000000a1f82989
kobject: 'tx-0' (0000000036212232): auto cleanup 'remove' event
kobject: 'tx-0' (0000000036212232): kobject_uevent_env
kobject: 'tx-0' (0000000036212232): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (0000000036212232): auto cleanup kobject_del
kobject: 'tx-0' (0000000036212232): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000a1f82989): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000a1f82989): calling ktype release
kobject: 'queues' (00000000a1f82989): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000cea9f291): kobject_uevent_env
kobject: 'ip6tnl0' (00000000cea9f291): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000dfb126f4): kobject_cleanup, parent 00000000a75197e4
kobject: 'rx-0' (00000000dfb126f4): auto cleanup 'remove' event
kobject: 'rx-0' (00000000dfb126f4): kobject_uevent_env
kobject: 'rx-0' (00000000dfb126f4): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000dfb126f4): auto cleanup kobject_del
kobject: 'rx-0' (00000000dfb126f4): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000099a08174): kobject_cleanup, parent 00000000a75197e4
kobject: 'tx-0' (0000000099a08174): auto cleanup 'remove' event
kobject: 'tx-0' (0000000099a08174): kobject_uevent_env
kobject: 'tx-0' (0000000099a08174): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (0000000099a08174): auto cleanup kobject_del
kobject: 'tx-0' (0000000099a08174): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000a75197e4): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000a75197e4): calling ktype release
kobject: 'queues' (00000000a75197e4): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000a23c10bd): kobject_uevent_env
kobject: 'ip6tnl0' (00000000a23c10bd): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000009c0856b5): kobject_cleanup, parent 0000000044176829
kobject: 'rx-0' (000000009c0856b5): auto cleanup 'remove' event
kobject: 'rx-0' (000000009c0856b5): kobject_uevent_env
kobject: 'rx-0' (000000009c0856b5): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000009c0856b5): auto cleanup kobject_del
kobject: 'rx-0' (000000009c0856b5): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (000000001d80b4b4): kobject_cleanup, parent 0000000044176829
kobject: 'tx-0' (000000001d80b4b4): auto cleanup 'remove' event
kobject: 'tx-0' (000000001d80b4b4): kobject_uevent_env
kobject: 'tx-0' (000000001d80b4b4): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (000000001d80b4b4): auto cleanup kobject_del
kobject: 'tx-0' (000000001d80b4b4): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (0000000044176829): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (0000000044176829): calling ktype release
kobject: 'queues' (0000000044176829): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (0000000078979785): kobject_uevent_env
kobject: 'ip6tnl0' (0000000078979785): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000008ae9ac25): kobject_cleanup, parent 000000000422c50d
kobject: 'rx-0' (000000008ae9ac25): auto cleanup 'remove' event
kobject: 'rx-0' (000000008ae9ac25): kobject_uevent_env
kobject: 'rx-0' (000000008ae9ac25): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (000000008ae9ac25): auto cleanup kobject_del
kobject: 'rx-0' (000000008ae9ac25): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000071f0bfcf): kobject_cleanup, parent 000000000422c50d
kobject: 'tx-0' (0000000071f0bfcf): auto cleanup 'remove' event
kobject: 'tx-0' (0000000071f0bfcf): kobject_uevent_env
kobject: 'tx-0' (0000000071f0bfcf): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (0000000071f0bfcf): auto cleanup kobject_del
kobject: 'tx-0' (0000000071f0bfcf): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (000000000422c50d): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (000000000422c50d): calling ktype release
kobject: 'queues' (000000000422c50d): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (0000000011b2c2f8): kobject_uevent_env
kobject: 'ip6tnl0' (0000000011b2c2f8): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000cda2e597): kobject_cleanup, parent 00000000f4b57b05
kobject: 'rx-0' (00000000cda2e597): auto cleanup 'remove' event
kobject: 'rx-0' (00000000cda2e597): kobject_uevent_env
kobject: 'rx-0' (00000000cda2e597): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000cda2e597): auto cleanup kobject_del
kobject: 'rx-0' (00000000cda2e597): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000057c14c85): kobject_cleanup, parent 00000000f4b57b05
kobject: 'tx-0' (0000000057c14c85): auto cleanup 'remove' event
kobject: 'tx-0' (0000000057c14c85): kobject_uevent_env
kobject: 'tx-0' (0000000057c14c85): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (0000000057c14c85): auto cleanup kobject_del
kobject: 'tx-0' (0000000057c14c85): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000f4b57b05): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000f4b57b05): calling ktype release
kobject: 'queues' (00000000f4b57b05): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000e3b903ae): kobject_uevent_env
kobject: 'ip6tnl0' (00000000e3b903ae): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000ed15b910): kobject_cleanup, parent 00000000e8d41101
kobject: 'rx-0' (00000000ed15b910): auto cleanup 'remove' event
kobject: 'rx-0' (00000000ed15b910): kobject_uevent_env
kobject: 'rx-0' (00000000ed15b910): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000ed15b910): auto cleanup kobject_del
kobject: 'rx-0' (00000000ed15b910): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000325978f0): kobject_cleanup, parent 00000000e8d41101
kobject: 'tx-0' (00000000325978f0): auto cleanup 'remove' event
kobject: 'tx-0' (00000000325978f0): kobject_uevent_env
kobject: 'tx-0' (00000000325978f0): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000325978f0): auto cleanup kobject_del
kobject: 'tx-0' (00000000325978f0): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000e8d41101): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000e8d41101): calling ktype release
kobject: 'queues' (00000000e8d41101): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (00000000fc92043f): kobject_uevent_env
kobject: 'ip6tnl0' (00000000fc92043f): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000077af794e): kobject_cleanup, parent 00000000648fea44
kobject: 'rx-0' (0000000077af794e): auto cleanup 'remove' event
kobject: 'rx-0' (0000000077af794e): kobject_uevent_env
kobject: 'rx-0' (0000000077af794e): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (0000000077af794e): auto cleanup kobject_del
kobject: 'rx-0' (0000000077af794e): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (0000000033d0f2a1): kobject_cleanup, parent 00000000648fea44
kobject: 'tx-0' (0000000033d0f2a1): auto cleanup 'remove' event
kobject: 'tx-0' (0000000033d0f2a1): kobject_uevent_env
kobject: 'tx-0' (0000000033d0f2a1): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (0000000033d0f2a1): auto cleanup kobject_del
kobject: 'tx-0' (0000000033d0f2a1): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (00000000648fea44): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (00000000648fea44): calling ktype release
kobject: 'queues' (00000000648fea44): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (0000000071ed4092): kobject_uevent_env
kobject: 'ip6tnl0' (0000000071ed4092): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000139c0100): kobject_cleanup, parent 000000002ea432c2
kobject: 'rx-0' (00000000139c0100): auto cleanup 'remove' event
kobject: 'rx-0' (00000000139c0100): kobject_uevent_env
kobject: 'rx-0' (00000000139c0100): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'rx-0' (00000000139c0100): auto cleanup kobject_del
kobject: 'rx-0' (00000000139c0100): calling ktype release
kobject: 'rx-0': free name
kobject: 'tx-0' (00000000df8de706): kobject_cleanup, parent 000000002ea432c2
kobject: 'tx-0' (00000000df8de706): auto cleanup 'remove' event
kobject: 'tx-0' (00000000df8de706): kobject_uevent_env
kobject: 'tx-0' (00000000df8de706): kobject_uevent_env: uevent_suppress  
caused the event to drop!
kobject: 'tx-0' (00000000df8de706): auto cleanup kobject_del
kobject: 'tx-0' (00000000df8de706): calling ktype release
kobject: 'tx-0': free name
kobject: 'queues' (000000002ea432c2): kobject_cleanup, parent  
00000000ba847286
kobject: 'queues' (000000002ea432c2): calling ktype release
kobject: 'queues' (000000002ea432c2): kset_release
kobject: 'queues': free name
kobject: 'ip6tnl0' (0000000089f2a543): kobject_uevent_env
kobject: 'ip6tnl0' (0000000089f2a543): kobject_uevent_env: uevent_suppres
