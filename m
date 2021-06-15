Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268D43A8189
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhFON7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:59:48 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:6381 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhFON7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:59:41 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G48t93jCMz63cB;
        Tue, 15 Jun 2021 21:53:37 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 21:57:35 +0800
From:   Peng Li <lipeng321@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/6] net: pci200syn: replace comparison to NULL with "!card"
Date:   Tue, 15 Jun 2021 21:54:20 +0800
Message-ID: <1623765263-36775-4-git-send-email-lipeng321@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623765263-36775-1-git-send-email-lipeng321@huawei.com>
References: <1623765263-36775-1-git-send-email-lipeng321@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the chackpatch.pl, comparison to NULL could
be written "!card".

Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/wan/pci200syn.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/pci200syn.c b/drivers/net/wan/pci200syn.c
index a7eac90..cee3d65 100644
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -279,7 +279,7 @@ static int pci200_pci_init_one(struct pci_dev *pdev,
 	}
 
 	card = kzalloc(sizeof(card_t), GFP_KERNEL);
-	if (card == NULL) {
+	if (!card) {
 		pci_release_regions(pdev);
 		pci_disable_device(pdev);
 		return -ENOBUFS;
@@ -310,9 +310,7 @@ static int pci200_pci_init_one(struct pci_dev *pdev,
 	ramphys = pci_resource_start(pdev,3) & PCI_BASE_ADDRESS_MEM_MASK;
 	card->rambase = pci_ioremap_bar(pdev, 3);
 
-	if (card->plxbase == NULL ||
-	    card->scabase == NULL ||
-	    card->rambase == NULL) {
+	if (!card->plxbase || !card->scabase || !card->rambase) {
 		pr_err("ioremap() failed\n");
 		pci200_pci_remove_one(pdev);
 		return -EFAULT;
-- 
2.8.1

