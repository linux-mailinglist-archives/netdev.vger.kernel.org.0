Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE9E39F097
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhFHISH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:18:07 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4516 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhFHIRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:17:46 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzjfR2lk1zZdFN;
        Tue,  8 Jun 2021 16:13:03 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:52 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 16:15:52 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 13/16] net: farsync: remove redundant parentheses
Date:   Tue, 8 Jun 2021 16:12:39 +0800
Message-ID: <1623139962-34847-14-git-send-email-huangguangbin2@huawei.com>
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

Unnecessary parentheses around 'port->hwif == X21'.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/farsync.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index bbe87d9..f6919cf 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -1075,7 +1075,7 @@ fst_intr_ctlchg(struct fst_card_info *card, struct fst_port_info *port)
 
 	signals = FST_RDL(card, v24DebouncedSts[port->index]);
 
-	if (signals & (((port->hwif == X21) || (port->hwif == X21D))
+	if (signals & ((port->hwif == X21 || port->hwif == X21D)
 		       ? IPSTS_INDICATE : IPSTS_DCD)) {
 		if (!netif_carrier_ok(port_to_dev(port))) {
 			dbg(DBG_INTR, "DCD active\n");
@@ -1233,7 +1233,7 @@ fst_intr_rx(struct fst_card_info *card, struct fst_port_info *port)
 	 * FST_MIN_DMA_LEN
 	 */
 
-	if ((len < FST_MIN_DMA_LEN) || (card->family == FST_FAMILY_TXP)) {
+	if (len < FST_MIN_DMA_LEN || card->family == FST_FAMILY_TXP) {
 		memcpy_fromio(skb_put(skb, len),
 			      card->mem + BUF_OFFSET(rxBuffer[pi][rxp][0]),
 			      len);
@@ -1326,8 +1326,8 @@ do_bottom_half_tx(struct fst_card_info *card)
 				 */
 				FST_WRW(card, txDescrRing[pi][port->txpos].bcnt,
 					cnv_bcnt(skb->len));
-				if ((skb->len < FST_MIN_DMA_LEN) ||
-				    (card->family == FST_FAMILY_TXP)) {
+				if (skb->len < FST_MIN_DMA_LEN ||
+				    card->family == FST_FAMILY_TXP) {
 					/* Enqueue the packet with normal io */
 					memcpy_toio(card->mem +
 						    BUF_OFFSET(txBuffer[pi]
@@ -2079,7 +2079,7 @@ fst_openport(struct fst_port_info *port)
 		port->run = 1;
 
 		signals = FST_RDL(port->card, v24DebouncedSts[port->index]);
-		if (signals & (((port->hwif == X21) || (port->hwif == X21D))
+		if (signals & ((port->hwif == X21 || port->hwif == X21D)
 			       ? IPSTS_INDICATE : IPSTS_DCD))
 			netif_carrier_on(port_to_dev(port));
 		else
@@ -2340,7 +2340,7 @@ fst_add_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		 *
 		 */
 		for (i = 0; i < fst_excluded_cards; i++) {
-			if ((pdev->devfn) >> 3 == fst_excluded_list[i]) {
+			if (pdev->devfn >> 3 == fst_excluded_list[i]) {
 				pr_info("FarSync PCI device %d not assigned\n",
 					(pdev->devfn) >> 3);
 				return -EBUSY;
@@ -2397,8 +2397,8 @@ fst_add_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	card->family = ((ent->driver_data == FST_TYPE_T2P) ||
 			(ent->driver_data == FST_TYPE_T4P))
 	    ? FST_FAMILY_TXP : FST_FAMILY_TXU;
-	if ((ent->driver_data == FST_TYPE_T1U) ||
-	    (ent->driver_data == FST_TYPE_TE1))
+	if (ent->driver_data == FST_TYPE_T1U ||
+	    ent->driver_data == FST_TYPE_TE1)
 		card->nports = 1;
 	else
 		card->nports = ((ent->driver_data == FST_TYPE_T2P) ||
-- 
2.8.1

