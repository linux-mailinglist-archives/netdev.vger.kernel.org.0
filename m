Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16EBEDC24E
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 12:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633415AbfJRKN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 06:13:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4688 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2633402AbfJRKN4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 06:13:56 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EE449446BAD95BC5B566;
        Fri, 18 Oct 2019 18:13:53 +0800 (CST)
Received: from RH5885H-V3.huawei.com (10.90.53.225) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 18 Oct 2019 18:13:46 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <igor.russkikh@aquantia.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <chenwandun@huawei.com>
Subject: [PATCH v2] net: aquantia: add an error handling in aq_nic_set_multicast_list
Date:   Fri, 18 Oct 2019 18:20:37 +0800
Message-ID: <1571394037-19978-1-git-send-email-chenwandun@huawei.com>
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

add an error handling in aq_nic_set_multicast_list, it may not
work when hw_multicast_list_set error; and at the same time
it will remove gcc Wunused-but-set-variable warning.

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

