Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95CD74BF41
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfFSRGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:06:03 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35201 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfFSRGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:06:03 -0400
Received: by mail-wm1-f66.google.com with SMTP id c6so276570wml.0
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 10:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zeXh/Ro65LQc5uvcve+gyhUQ9cliS1x+BAON+3PoZgM=;
        b=QpxpoPeI2rvNksq0DDfgSyQsu765Y60qMh131MvhLuak/kzzJ/V5ZipZb/EJKvkhVx
         WvL+TLFveZES9V+bCHENdOZsccOSBwzybEPXR0ExDNxWDukFj/CypZ73DdtJ9u1EhA6V
         5IReu9oCVW53ZEVhczLxKkuin7uOkkIBwaUmaP7WhhzDHqqtwELxk1f4EgKQ3iBWQKNK
         U22JbFD36KlZDdYqReIf2wJf/suhY8rj75X08UABX+GORkEdgse6P6J7E2K6LQY/FH8k
         Qw64SaVd92QoKgNegn10FnHC0zPkSjZ/5kBc+5yFF30ynK81Ez5RqovFo7JyB2+sUGdP
         jyGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zeXh/Ro65LQc5uvcve+gyhUQ9cliS1x+BAON+3PoZgM=;
        b=UCx123CpWnUH4uy7qhcMGX+Q91vMhohTNP96DafzbuNdj0dv3asLPqvla7DHGxcJ0H
         MgjknUXsF+Tki4EMxsMgHyRRyFZorJCzdeXXrFbQbQ+dPmJr4JGSQVYGFi6PEVczEWOU
         2PbkijKl+Xw1IQ6LOXM2MCmWBnXTV5POkgjZbEYdSi+AbFgaogNPx5wz6BmD9jf7t2yQ
         qCTd08aqvRt0ZIUl3NDoyh0w8ipg53tz5GmnnSGjgCHXe9DPXFEuHGEZyuyvIxJMrdJR
         TQv6DdQ9JTdLdczjvLSN0Os2EPku3Tv7eifCH4/nLYEBmvnJT0qvVOEvGbu0jG4lfYbS
         LNeA==
X-Gm-Message-State: APjAAAUiT+59nfzh++9oWUQLhO/w41ilQNBazTQ6rUED4FxSNu4xTn+g
        xjNBgpDKAQLQNF54XK8bWx/LNg==
X-Google-Smtp-Source: APXvYqyEuwcoiOYRwwHbfn9qOJfacaKslCWAXjb9fgbsjM8Qm+62s15ZI3aXa38T0jo+s+a9e90TIw==
X-Received: by 2002:a1c:b757:: with SMTP id h84mr9711003wmf.127.1560963960192;
        Wed, 19 Jun 2019 10:06:00 -0700 (PDT)
Received: from localhost.localdomain ([212.91.227.56])
        by smtp.gmail.com with ESMTPSA id 35sm2940609wrj.87.2019.06.19.10.05.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 10:05:59 -0700 (PDT)
From:   Christian Brauner <christian@brauner.io>
To:     syzbot+43a3fa52c0d9c5c94f41@syzkaller.appspotmail.com,
        pablo@netfilter.org
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, a.hajda@samsung.com,
        airlied@linux.ie, airlied@redhat.com, alexander.deucher@amd.com,
        bridge@lists.linux-foundation.org, christian.koenig@amd.com,
        coreteam@netfilter.org, daniel@ffwll.ch, davem@davemloft.net,
        dri-devel@lists.freedesktop.org, enric.balletbo@collabora.com,
        fw@strlen.de, harry.wentland@amd.com, heiko@sntech.de,
        intel-gfx@lists.freedesktop.org, jani.nikula@linux.intel.com,
        jerry.zhang@amd.com, jonas@kwiboo.se,
        joonas.lahtinen@linux.intel.com, kadlec@netfilter.org,
        laurent.pinchart@ideasonboard.com,
        maarten.lankhorst@linux.intel.com, marc.zyngier@arm.com,
        maxime.ripard@bootlin.com, narmstrong@baylibre.com,
        nikolay@cumulusnetworks.com, patrik.r.jakobsson@gmail.com,
        rodrigo.vivi@intel.com, roopa@cumulusnetworks.com,
        sam@ravnborg.org, sean@poorly.run, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com,
        Christian Brauner <christian@brauner.io>
Subject: [PATCH net-next] br_netfilter: prevent UAF in brnf_exit_net()
Date:   Wed, 19 Jun 2019 19:05:47 +0200
Message-Id: <20190619170547.6290-1-christian@brauner.io>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prevent a UAF in brnf_exit_net().

When unregister_net_sysctl_table() is called the ctl_hdr pointer will
obviously be freed and so accessing it righter after is invalid. Fix
this by stashing a pointer to the table we want to free before we
unregister the sysctl header.

Note that syzkaller falsely chased this down to the drm tree so the
Fixes tag that syzkaller requested would be wrong. This commit uses a
different but the correct Fixes tag.

/* Splat */

BUG: KASAN: use-after-free in br_netfilter_sysctl_exit_net
net/bridge/br_netfilter_hooks.c:1121 [inline]
BUG: KASAN: use-after-free in brnf_exit_net+0x38c/0x3a0
net/bridge/br_netfilter_hooks.c:1141
Read of size 8 at addr ffff8880a4078d60 by task kworker/u4:4/8749

CPU: 0 PID: 8749 Comm: kworker/u4:4 Not tainted 5.2.0-rc5-next-20190618 #17
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google
01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
 __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
 kasan_report+0x12/0x20 mm/kasan/common.c:614
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
 br_netfilter_sysctl_exit_net net/bridge/br_netfilter_hooks.c:1121 [inline]
 brnf_exit_net+0x38c/0x3a0 net/bridge/br_netfilter_hooks.c:1141
 ops_exit_list.isra.0+0xaa/0x150 net/core/net_namespace.c:154
 cleanup_net+0x3fb/0x960 net/core/net_namespace.c:553
 process_one_work+0x989/0x1790 kernel/workqueue.c:2269
 worker_thread+0x98/0xe40 kernel/workqueue.c:2415
 kthread+0x354/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 11374:
 save_stack+0x23/0x90 mm/kasan/common.c:71
 set_track mm/kasan/common.c:79 [inline]
 __kasan_kmalloc mm/kasan/common.c:489 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
 __do_kmalloc mm/slab.c:3645 [inline]
 __kmalloc+0x15c/0x740 mm/slab.c:3654
 kmalloc include/linux/slab.h:552 [inline]
 kzalloc include/linux/slab.h:743 [inline]
 __register_sysctl_table+0xc7/0xef0 fs/proc/proc_sysctl.c:1327
 register_net_sysctl+0x29/0x30 net/sysctl_net.c:121
 br_netfilter_sysctl_init_net net/bridge/br_netfilter_hooks.c:1105 [inline]
 brnf_init_net+0x379/0x6a0 net/bridge/br_netfilter_hooks.c:1126
 ops_init+0xb3/0x410 net/core/net_namespace.c:130
 setup_net+0x2d3/0x740 net/core/net_namespace.c:316
 copy_net_ns+0x1df/0x340 net/core/net_namespace.c:439
 create_new_namespaces+0x400/0x7b0 kernel/nsproxy.c:103
 unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:202
 ksys_unshare+0x444/0x980 kernel/fork.c:2822
 __do_sys_unshare kernel/fork.c:2890 [inline]
 __se_sys_unshare kernel/fork.c:2888 [inline]
 __x64_sys_unshare+0x31/0x40 kernel/fork.c:2888
 do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 9:
 save_stack+0x23/0x90 mm/kasan/common.c:71
 set_track mm/kasan/common.c:79 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
 __cache_free mm/slab.c:3417 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3746
 __rcu_reclaim kernel/rcu/rcu.h:215 [inline]
 rcu_do_batch kernel/rcu/tree.c:2092 [inline]
 invoke_rcu_callbacks kernel/rcu/tree.c:2310 [inline]
 rcu_core+0xcc7/0x1500 kernel/rcu/tree.c:2291
 __do_softirq+0x25c/0x94c kernel/softirq.c:292

The buggy address belongs to the object at ffff8880a4078d40
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 32 bytes inside of
 512-byte region [ffff8880a4078d40, ffff8880a4078f40)
The buggy address belongs to the page:
page:ffffea0002901e00 refcount:1 mapcount:0 mapping:ffff8880aa400a80
index:0xffff8880a40785c0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea0001d636c8 ffffea0001b07308 ffff8880aa400a80
raw: ffff8880a40785c0 ffff8880a40780c0 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a4078c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a4078c80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> ffff8880a4078d00: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                                       ^
 ffff8880a4078d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a4078e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Reported-by: syzbot+43a3fa52c0d9c5c94f41@syzkaller.appspotmail.com
Fixes: 22567590b2e6 ("netfilter: bridge: namespace bridge netfilter sysctls")
Signed-off-by: Christian Brauner <christian@brauner.io>
---
 net/bridge/br_netfilter_hooks.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index fd9e991c1189..d3f9592f4ff8 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -1116,9 +1116,11 @@ static int br_netfilter_sysctl_init_net(struct net *net)
 static void br_netfilter_sysctl_exit_net(struct net *net,
 					 struct brnf_net *brnet)
 {
+	struct ctl_table *table = brnet->ctl_hdr->ctl_table_arg;
+
 	unregister_net_sysctl_table(brnet->ctl_hdr);
 	if (!net_eq(net, &init_net))
-		kfree(brnet->ctl_hdr->ctl_table_arg);
+		kfree(table);
 }
 
 static int __net_init brnf_init_net(struct net *net)
-- 
2.21.0

