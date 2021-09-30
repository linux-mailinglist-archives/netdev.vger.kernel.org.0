Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E47E41E02F
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 19:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352684AbhI3R3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 13:29:11 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:38455 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352672AbhI3R3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 13:29:06 -0400
Received: by mail-io1-f69.google.com with SMTP id s21-20020a6bdc15000000b005db56ae6275so5984232ioc.5
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 10:27:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=gv72izE33dTTEKceIEpVEdBmjtFaKZ1ur9yqMhFllDo=;
        b=H/70+A2t8kNRec4SqPaEr8p4mTTDtsL+zP85TzwIGjAZSv4Q4+dlngxIu6TVt/3rHb
         xC2+SINAdTV6HlSi7JsqJvbkwW0KmwDaKvhqhg13gwcG23vsDwmssBJlncUGK0Yw7p5k
         kEhWuOXhiXuJgtSYO/boBDi6qaD3QlnsaM7D1tvcLJ9/MiVJMZVtFWC5USEwLWqywg4O
         JnaSMyv6Wqq7TPSpTFZFdoQSMc5U8Y73lw7BLnjv+5OFXM+TMf4hsxPdxGhST4K9Ep3r
         E1yxNRnIO+LrDmP9URliZDw7SDqx11UHIaw0RmndYsbIzTM5xrWdS5rXmC6Mvpf1ROKj
         UMbA==
X-Gm-Message-State: AOAM533LtXyYPrcWaVTVRUPty2L7BvFhyxKIh9t2bsxwXXVQou7QTHZu
        xaG3+sUSJ1aBdnhSp1wT6upwKJGCxw1eP/iuQzUIQbodcYkP
X-Google-Smtp-Source: ABdhPJzTKeu9j9ZBqZUXdfdt6ko9tQU8sPwwXxTOCH4fM2w78ltzGfeqSxRairbfrC4tMUNhURM6tX2167mf6NKJp4vqqvuJJMgv
MIME-Version: 1.0
X-Received: by 2002:a5d:9256:: with SMTP id e22mr4718594iol.152.1633022843884;
 Thu, 30 Sep 2021 10:27:23 -0700 (PDT)
Date:   Thu, 30 Sep 2021 10:27:23 -0700
In-Reply-To: <0000000000008ce91e05bf9f62bc@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008519a705cd39c2f2@google.com>
Subject: Re: [syzbot] WARNING in __nf_unregister_net_hook (4)
From:   syzbot <syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, dvyukov@google.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tonymarislogistics@yandex.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    02d5e016800d Merge tag 'sound-5.15-rc4' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=160132c0b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9290a409049988d4
dashboard link: https://syzkaller.appspot.com/bug?extid=154bd5be532a63aa778b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1400bf0f300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144eaf17300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+154bd5be532a63aa778b@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 2648 at net/netfilter/core.c:468 __nf_unregister_net_hook+0x4b1/0x600 net/netfilter/core.c:468
Modules linked in:
CPU: 0 PID: 2648 Comm: kworker/u4:6 Not tainted 5.15.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:__nf_unregister_net_hook+0x4b1/0x600 net/netfilter/core.c:468
Code: 00 00 00 e8 41 e9 16 fa 41 83 fc 05 74 5e e8 f6 e1 16 fa 44 89 e6 bf 05 00 00 00 e8 29 e9 16 fa e9 f5 fd ff ff e8 df e1 16 fa <0f> 0b 48 c7 c7 80 dd 17 8d e8 c1 a8 d7 01 e9 b1 fe ff ff 48 89 f7
RSP: 0018:ffffc9000b10f658 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888070c20b98 RCX: 0000000000000000
RDX: ffff888024aa9c80 RSI: ffffffff875f1991 RDI: 0000000000000003
RBP: 0000000000000005 R08: 0000000000000000 R09: ffffc9000b10f597
R10: ffffffff875f159f R11: 000000000000000e R12: 0000000000000001
R13: ffff88801d2b43d8 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2f45ae09b0 CR3: 000000000b68e000 CR4: 0000000000350ef0
Call Trace:
 nf_unregister_net_hook+0xd5/0x110 net/netfilter/core.c:502
 nft_netdev_unregister_hooks net/netfilter/nf_tables_api.c:230 [inline]
 nf_tables_unregister_hook.part.0+0x1ab/0x200 net/netfilter/nf_tables_api.c:273
 nf_tables_unregister_hook include/net/netfilter/nf_tables.h:1090 [inline]
 __nft_release_basechain+0x138/0x640 net/netfilter/nf_tables_api.c:9524
 nft_netdev_event net/netfilter/nft_chain_filter.c:351 [inline]
 nf_tables_netdev_event+0x521/0x8a0 net/netfilter/nft_chain_filter.c:382
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1996
 call_netdevice_notifiers_extack net/core/dev.c:2008 [inline]
 call_netdevice_notifiers net/core/dev.c:2022 [inline]
 unregister_netdevice_many+0x951/0x1790 net/core/dev.c:11043
 ieee80211_remove_interfaces+0x394/0x820 net/mac80211/iface.c:2140
 ieee80211_unregister_hw+0x47/0x1f0 net/mac80211/main.c:1391
 mac80211_hwsim_del_radio drivers/net/wireless/mac80211_hwsim.c:3457 [inline]
 hwsim_exit_net+0x50e/0xca0 drivers/net/wireless/mac80211_hwsim.c:4217
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:168
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:591
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

