Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F01739F09D
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhFHISQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:18:16 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:4399 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhFHIRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:17:47 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FzjdG4B6Zz6vZW;
        Tue,  8 Jun 2021 16:12:02 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:52 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 16/16] net: farsync: replace comparison to NULL with "fst_card_array[i]"
Date:   Tue, 8 Jun 2021 16:12:42 +0800
Message-ID: <1623139962-34847-17-git-send-email-huangguangbin2@huawei.com>
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

According to the chackpatch.pl, comparison to NULL could
be written "fst_card_array[i]".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/farsync.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 10208f0..b3466e0 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -611,7 +611,7 @@ fst_process_tx_work_q(struct tasklet_struct *unused)
 	 */
 	for (i = 0; i < FST_MAX_CARDS; i++) {
 		if (work_txq & 0x01) {
-			if (fst_card_array[i] != NULL) {
+			if (fst_card_array[i]) {
 				dbg(DBG_TX, "Calling tx bh for card %d\n", i);
 				do_bottom_half_tx(fst_card_array[i]);
 			}
@@ -639,7 +639,7 @@ fst_process_int_work_q(struct tasklet_struct *unused)
 	 */
 	for (i = 0; i < FST_MAX_CARDS; i++) {
 		if (work_intq & 0x01) {
-			if (fst_card_array[i] != NULL) {
+			if (fst_card_array[i]) {
 				dbg(DBG_INTR,
 				    "Calling rx & tx bh for card %d\n", i);
 				do_bottom_half_rx(fst_card_array[i]);
-- 
2.8.1

