Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B8E26D79
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733064AbfEVTmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732631AbfEVT2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:28:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFE81217D7;
        Wed, 22 May 2019 19:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553325;
        bh=q0iqfXqSsVsQgn1nzcmhyAhqDLUSaATH1tk86t9SNPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fELkA9av+4G6LubbQJCn2Dp/rAp0PIHdlOAlx9OJz68m4WCuOrWKis1VgPldD+de3
         +RLPNOy6PNaB9ZaESK1LVDYPrhJ/mQjvLdbgc6P9DmursxE7cboCKMZWGk/JCou6l9
         YPtSWgkakfatOoQxxUXShbwouwl6vlTa/kOuKi+k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 002/167] cxgb4: Fix error path in cxgb4_init_module
Date:   Wed, 22 May 2019 15:25:57 -0400
Message-Id: <20190522192842.25858-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192842.25858-1-sashal@kernel.org>
References: <20190522192842.25858-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit a3147770bea76c8dbad73eca3a24c2118da5e719 ]

BUG: unable to handle kernel paging request at ffffffffa016a270
PGD 3270067 P4D 3270067 PUD 3271063 PMD 230bbd067 PTE 0
Oops: 0000 [#1
CPU: 0 PID: 6134 Comm: modprobe Not tainted 5.1.0+ #33
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
RIP: 0010:atomic_notifier_chain_register+0x24/0x60
Code: 1f 80 00 00 00 00 55 48 89 e5 41 54 49 89 f4 53 48 89 fb e8 ae b4 38 01 48 8b 53 38 48 8d 4b 38 48 85 d2 74 20 45 8b 44 24 10 <44> 3b 42 10 7e 08 eb 13 44 39 42 10 7c 0d 48 8d 4a 08 48 8b 52 08
RSP: 0018:ffffc90000e2bc60 EFLAGS: 00010086
RAX: 0000000000000292 RBX: ffffffff83467240 RCX: ffffffff83467278
RDX: ffffffffa016a260 RSI: ffffffff83752140 RDI: ffffffff83467240
RBP: ffffc90000e2bc70 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 00000000014fa61f R12: ffffffffa01c8260
R13: ffff888231091e00 R14: 0000000000000000 R15: ffffc90000e2be78
FS:  00007fbd8d7cd540(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa016a270 CR3: 000000022c7e3000 CR4: 00000000000006f0
Call Trace:
 register_inet6addr_notifier+0x13/0x20
 cxgb4_init_module+0x6c/0x1000 [cxgb4
 ? 0xffffffffa01d7000
 do_one_initcall+0x6c/0x3cc
 ? do_init_module+0x22/0x1f1
 ? rcu_read_lock_sched_held+0x97/0xb0
 ? kmem_cache_alloc_trace+0x325/0x3b0
 do_init_module+0x5b/0x1f1
 load_module+0x1db1/0x2690
 ? m_show+0x1d0/0x1d0
 __do_sys_finit_module+0xc5/0xd0
 __x64_sys_finit_module+0x15/0x20
 do_syscall_64+0x6b/0x1d0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

If pci_register_driver fails, register inet6addr_notifier is
pointless. This patch fix the error path in cxgb4_init_module.

Fixes: b5a02f503caa ("cxgb4 : Update ipv6 address handling api")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 74a42f12064b6..0e13989608f19 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5399,15 +5399,24 @@ static int __init cxgb4_init_module(void)
 
 	ret = pci_register_driver(&cxgb4_driver);
 	if (ret < 0)
-		debugfs_remove(cxgb4_debugfs_root);
+		goto err_pci;
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (!inet6addr_registered) {
-		register_inet6addr_notifier(&cxgb4_inet6addr_notifier);
-		inet6addr_registered = true;
+		ret = register_inet6addr_notifier(&cxgb4_inet6addr_notifier);
+		if (ret)
+			pci_unregister_driver(&cxgb4_driver);
+		else
+			inet6addr_registered = true;
 	}
 #endif
 
+	if (ret == 0)
+		return ret;
+
+err_pci:
+	debugfs_remove(cxgb4_debugfs_root);
+
 	return ret;
 }
 
-- 
2.20.1

