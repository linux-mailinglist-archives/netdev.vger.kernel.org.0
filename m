Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC68D5E2B2
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 13:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfGCLP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 07:15:59 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8135 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726621AbfGCLP7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 07:15:59 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 91DE721F7131172F8F4A;
        Wed,  3 Jul 2019 19:15:56 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Wed, 3 Jul 2019 19:15:48 +0800
From:   Yonglong Liu <liuyonglong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <shiju.jose@huawei.com>
Subject: [PATCH net] net: hns: add support for vlan TSO
Date:   Wed, 3 Jul 2019 19:12:30 +0800
Message-ID: <1562152350-14244-1-git-send-email-liuyonglong@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hip07 chip support vlan TSO, this patch adds NETIF_F_TSO
and NETIF_F_TSO6 flags to vlan_features to improve the
performance after adding vlan to the net ports.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index fe879c0..2235dd5 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -2370,6 +2370,7 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
 		ndev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
 			NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6;
+		ndev->vlan_features |= NETIF_F_TSO | NETIF_F_TSO6;
 		ndev->max_mtu = MAC_MAX_MTU_V2 -
 				(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
 		break;
-- 
2.8.1

