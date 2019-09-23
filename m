Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4730BBB5BA
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 15:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406985AbfIWNsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 09:48:31 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2770 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfIWNsa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 09:48:30 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0410E57D6B7700CD05A3;
        Mon, 23 Sep 2019 21:48:29 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Mon, 23 Sep 2019 21:48:20 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-bluetooth@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] Bluetooth: SMP: remove set but not used variable 'smp'
Date:   Mon, 23 Sep 2019 14:05:16 +0000
Message-ID: <20190923140516.166241-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

net/bluetooth/smp.c: In function 'smp_irk_matches':
net/bluetooth/smp.c:505:18: warning:
 variable 'smp' set but not used [-Wunused-but-set-variable]

net/bluetooth/smp.c: In function 'smp_generate_rpa':
net/bluetooth/smp.c:526:18: warning:
 variable 'smp' set but not used [-Wunused-but-set-variable]

It is not used since commit 28a220aac596 ("bluetooth: switch
to AES library")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/bluetooth/smp.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 26e8cfad22b8..6b42be4b5861 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -502,15 +502,12 @@ bool smp_irk_matches(struct hci_dev *hdev, const u8 irk[16],
 		     const bdaddr_t *bdaddr)
 {
 	struct l2cap_chan *chan = hdev->smp_data;
-	struct smp_dev *smp;
 	u8 hash[3];
 	int err;
 
 	if (!chan || !chan->data)
 		return false;
 
-	smp = chan->data;
-
 	BT_DBG("RPA %pMR IRK %*phN", bdaddr, 16, irk);
 
 	err = smp_ah(irk, &bdaddr->b[3], hash);
@@ -523,14 +520,11 @@ bool smp_irk_matches(struct hci_dev *hdev, const u8 irk[16],
 int smp_generate_rpa(struct hci_dev *hdev, const u8 irk[16], bdaddr_t *rpa)
 {
 	struct l2cap_chan *chan = hdev->smp_data;
-	struct smp_dev *smp;
 	int err;
 
 	if (!chan || !chan->data)
 		return -EOPNOTSUPP;
 
-	smp = chan->data;
-
 	get_random_bytes(&rpa->b[3], 3);
 
 	rpa->b[5] &= 0x3f;	/* Clear two most significant bits */



