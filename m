Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81E3217DBF
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 05:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgGHDuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 23:50:54 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41094 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728888AbgGHDuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 23:50:54 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 67EB0B45272C22956C04;
        Wed,  8 Jul 2020 11:50:52 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Wed, 8 Jul 2020 11:50:43 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RFC net-next 1/2] udp: add NETIF_F_GSO_UDP_L4 to NETIF_F_SOFTWARE_GSO
Date:   Wed, 8 Jul 2020 11:48:55 +0800
Message-ID: <1594180136-15912-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594180136-15912-1-git-send-email-tanhuazhong@huawei.com>
References: <1594180136-15912-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add NETIF_F_SOFTWARE_GSO to the the list of GSO features with
a software fallback.  This allows UDP GSO to be used even if
the hardware does not support it, and for virtual device such
as VxLAN device, this UDP segmentation will be postponed to
physical device.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 include/linux/netdev_features.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 2cc3cf8..c7eef16 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -207,7 +207,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 				 NETIF_F_FSO)
 
 /* List of features with software fallbacks. */
-#define NETIF_F_GSO_SOFTWARE	(NETIF_F_ALL_TSO | \
+#define NETIF_F_GSO_SOFTWARE	(NETIF_F_ALL_TSO | NETIF_F_GSO_UDP_L4 | \
 				 NETIF_F_GSO_SCTP)
 
 /*
-- 
2.7.4

