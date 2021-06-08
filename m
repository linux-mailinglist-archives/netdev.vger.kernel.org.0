Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5BC39F08E
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhFHIR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:17:56 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3788 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhFHIRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:17:45 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fzjc45Nx8zWskM;
        Tue,  8 Jun 2021 16:11:00 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:51 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:51 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 05/16] net: farsync: remove redundant initialization for statics
Date:   Tue, 8 Jun 2021 16:12:31 +0800
Message-ID: <1623139962-34847-6-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
References: <1623139962-34847-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Should not initialise statics to 0.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/farsync.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 8db9c84..7e408d5 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -76,7 +76,7 @@ MODULE_LICENSE("GPL");
 static int fst_txq_low = FST_LOW_WATER_MARK;
 static int fst_txq_high = FST_HIGH_WATER_MARK;
 static int fst_max_reads = 7;
-static int fst_excluded_cards = 0;
+static int fst_excluded_cards;
 static int fst_excluded_list[FST_MAX_CARDS];
 
 module_param(fst_txq_low, int, 0);
@@ -2401,7 +2401,7 @@ static const struct net_device_ops fst_ops = {
 static int
 fst_add_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	static int no_of_cards_added = 0;
+	static int no_of_cards_added;
 	struct fst_card_info *card;
 	int err = 0;
 	int i;
-- 
2.8.1

