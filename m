Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F400625E6A8
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 11:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgIEJQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 05:16:11 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52730 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726302AbgIEJQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 05:16:10 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 349ED62A50FAD10BA682;
        Sat,  5 Sep 2020 17:16:08 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Sat, 5 Sep 2020
 17:16:00 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <steffen.klassert@secunet.com>,
        <willemb@google.com>, <mstarovoitov@marvell.com>,
        <kuba@kernel.org>, <mchehab+huawei@kernel.org>,
        <antoine.tenart@bootlin.com>, <edumazet@google.com>,
        <Jason@zx2c4.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Fix some comments
Date:   Sat, 5 Sep 2020 05:14:48 -0400
Message-ID: <20200905091448.48165-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 8d7017fd621d ("blackhole_netdev: use blackhole_netdev to
invalidate dst entries"), we use blackhole_netdev to invalidate dst entries
instead of loopback device anymore. Also fix broken NETIF_F_HW_CSUM spell.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 include/linux/netdev_features.h | 2 +-
 net/core/dst.c                  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 2cc3cf80b49a..0b17c4322b09 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -193,7 +193,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 #define NETIF_F_GSO_MASK	(__NETIF_F_BIT(NETIF_F_GSO_LAST + 1) - \
 		__NETIF_F_BIT(NETIF_F_GSO_SHIFT))
 
-/* List of IP checksum features. Note that NETIF_F_ HW_CSUM should not be
+/* List of IP checksum features. Note that NETIF_F_HW_CSUM should not be
  * set in features when NETIF_F_IP_CSUM or NETIF_F_IPV6_CSUM are set--
  * this would be contradictory
  */
diff --git a/net/core/dst.c b/net/core/dst.c
index d6b6ced0d451..0c01bd8d9d81 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -144,7 +144,7 @@ static void dst_destroy_rcu(struct rcu_head *head)
 
 /* Operations to mark dst as DEAD and clean up the net device referenced
  * by dst:
- * 1. put the dst under loopback interface and discard all tx/rx packets
+ * 1. put the dst under blackhole interface and discard all tx/rx packets
  *    on this route.
  * 2. release the net_device
  * This function should be called when removing routes from the fib tree
-- 
2.19.1

