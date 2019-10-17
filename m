Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6143DA38B
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 04:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395546AbfJQCSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 22:18:23 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60376 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2395502AbfJQCSX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 22:18:23 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CD3A6441A0FFA4E59464;
        Thu, 17 Oct 2019 10:18:20 +0800 (CST)
Received: from RH5885H-V3.huawei.com (10.90.53.225) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Thu, 17 Oct 2019 10:18:09 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <igor.russkikh@aquantia.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <chenwandun@huawei.com>
Subject: [PATCH] net: aquantia: add an error handling in aq_nic_set_multicast_list
Date:   Thu, 17 Oct 2019 10:25:16 +0800
Message-ID: <1571279116-4421-1-git-send-email-chenwandun@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chenwandun <chenwandun@huawei.com>

Signed-off-by: Chenwandun <chenwandun@huawei.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 2a18439..137c1de 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -664,6 +664,8 @@ int aq_nic_set_multicast_list(struct aq_nic_s *self, struct net_device *ndev)
 		err = hw_ops->hw_multicast_list_set(self->aq_hw,
 						    self->mc_list.ar,
 						    self->mc_list.count);
+		if (err < 0)
+			return err;
 	}
 	return aq_nic_set_packet_filter(self, packet_filter);
 }
-- 
2.7.4

