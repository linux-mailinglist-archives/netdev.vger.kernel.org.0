Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E845FDE59
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJMQjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiJMQjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:39:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B386C149DE1;
        Thu, 13 Oct 2022 09:39:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EDE0B81FAF;
        Thu, 13 Oct 2022 16:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9944CC433C1;
        Thu, 13 Oct 2022 16:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665679159;
        bh=ya/qoW0Gc2SmvObRy5ILWPsW2OUcbomZIOnJvy/U4sQ=;
        h=From:To:Cc:Subject:Date:From;
        b=a3XoNy5NBS/3tznQYf8G5r2gujwS6/zZdKkYyOJWQqMbJkdmcnIimsZqqK5brtxFi
         pg/sWILw09caD2h9P7kwI9g2AiafwwpFqmr/ZovZQXAJYBRTEn3/lWEo0OPcFQ00BE
         pxF8Q61J5dDNe2TjEVZtfOZZhaKdBQT8ozZDGAw17PK/6AxFvz+zYVfQARpgO7hXEY
         CcnL11BmsDON9Rwvg6bth70Q6Ntr3KyR8q5599UfMc8M2J2tBEttGQMIf0Ya/mzqwS
         q5agy8Jb36kgXkmMM28aZVK+EuY/VYSndwLK8o0ITcb1d5VKGnLg06laNK8KDoOOsL
         VGXpb+6UvZFjQ==
From:   guoren@kernel.org
To:     andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@rasmusvillemoes.dk, yury.norov@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Guo Ren <guoren@linux.alibaba.com>, Guo Ren <guoren@kernel.org>
Subject: [PATCH] net: Fixup netif_attrmask_next_and warning
Date:   Thu, 13 Oct 2022 12:38:57 -0400
Message-Id: <20221013163857.3086718-1-guoren@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

Don't pass nr_bits as arg1, cpu_max_bits_warn would cause warning
now.

------------[ cut here ]------------
WARNING: CPU: 2 PID: 1 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x14e/0x770
Modules linked in:
CPU: 2 PID: 1 Comm: swapper/0 Not tainted 6.0.0-rc4-00018-g854701ba4c39 #324
Hardware name: riscv-virtio,qemu (DT)
epc : __netif_set_xps_queue+0x14e/0x770
 ra : __netif_set_xps_queue+0x552/0x770
epc : ffffffff806fe448 ra : ffffffff806fe84c sp : ff600000023279d0
 gp : ffffffff815fff88 tp : ff600000023a0000 t0 : ff6000000308ab40
 t1 : 0000000000000003 t2 : 0000000000000000 s0 : ff60000002327a90
 s1 : 0000000000000000 a0 : ff6000000308ab00 a1 : ff6000000308ab00
 a2 : ff6000000308a8e8 a3 : 0000000000000004 a4 : 0000000000000000
 a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000000000000
 s2 : 0000000000000000 s3 : 0000000000000000 s4 : ff60000002327aa0
 s5 : ffffffff816031c8 s6 : 0000000000000000 s7 : 0000000000000001
 s8 : 0000000000000000 s9 : 0000000000000004 s10: ff6000000308a8c0
 s11: 0000000000000004 t3 : 0000000000000000 t4 : 0000000000000014
 t5 : 0000000000000000 t6 : 0000000000000000
status: 0000000200000120 badaddr: 0000000000000000 cause: 0000000000000003
[<ffffffff805e5824>] virtnet_set_affinity+0x14a/0x1c0
[<ffffffff805e7b04>] virtnet_probe+0x7fc/0xee2
[<ffffffff8050e120>] virtio_dev_probe+0x164/0x2de
[<ffffffff8055b69e>] really_probe+0x82/0x224
[<ffffffff8055b89a>] __driver_probe_device+0x5a/0xaa
[<ffffffff8055b916>] driver_probe_device+0x2c/0xb8
[<ffffffff8055bf34>] __driver_attach+0x76/0x108
[<ffffffff805597c0>] bus_for_each_dev+0x4a/0x8e
[<ffffffff8055b072>] driver_attach+0x1a/0x28
[<ffffffff8055ab8c>] bus_add_driver+0x13c/0x1a6
[<ffffffff8055c722>] driver_register+0x4a/0xfc
[<ffffffff8050dc34>] register_virtio_driver+0x1c/0x2c
[<ffffffff80a2bae4>] virtio_net_driver_init+0x7a/0xb0
[<ffffffff80002840>] do_one_initcall+0x66/0x2e4
[<ffffffff80a01212>] kernel_init_freeable+0x28a/0x304
[<ffffffff808b21e2>] kernel_init+0x1e/0x110
[<ffffffff80003c46>] ret_from_exception+0x0/0x10
---[ end trace 0000000000000000 ]---

Fixes: 944c417daeb6 ("net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
---
 net/core/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index fa53830d0683..9ec8b10ae329 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2589,8 +2589,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		copy = true;
 
 	/* allocate memory for queue storage */
-	for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
-	     j < nr_ids;) {
+	for (j = -1; j < nr_ids;
+	     j = netif_attrmask_next_and(j, online_mask, mask, nr_ids)) {
 		if (!new_dev_maps) {
 			new_dev_maps = kzalloc(maps_sz, GFP_KERNEL);
 			if (!new_dev_maps) {
-- 
2.36.1

