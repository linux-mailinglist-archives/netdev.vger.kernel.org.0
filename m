Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D62E70E5
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 13:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388767AbfJ1MBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 08:01:49 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5210 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726466AbfJ1MBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 08:01:48 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4D7F0CFBA305898AA362;
        Mon, 28 Oct 2019 20:01:46 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Mon, 28 Oct 2019 20:01:37 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        "David S . Miller" <davem@davemloft.net>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] ionic: Remove set but not used variable 'sg_desc'
Date:   Mon, 28 Oct 2019 12:01:21 +0000
Message-ID: <20191028120121.20743-1-yuehaibing@huawei.com>
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

drivers/net/ethernet/pensando/ionic/ionic_txrx.c: In function 'ionic_rx_empty':
drivers/net/ethernet/pensando/ionic/ionic_txrx.c:405:28: warning:
 variable 'sg_desc' set but not used [-Wunused-but-set-variable]

It is never used, so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 0aeac3157160..97e79949b359 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -402,7 +402,6 @@ static void ionic_rx_fill_cb(void *arg)
 
 void ionic_rx_empty(struct ionic_queue *q)
 {
-	struct ionic_rxq_sg_desc *sg_desc;
 	struct ionic_desc_info *cur;
 	struct ionic_rxq_desc *desc;
 	unsigned int i;
@@ -412,7 +411,6 @@ void ionic_rx_empty(struct ionic_queue *q)
 		desc->addr = 0;
 		desc->len = 0;
 
-		sg_desc = cur->sg_desc;
 		for (i = 0; i < cur->npages; i++) {
 			if (likely(cur->pages[i].page)) {
 				ionic_rx_page_free(q, cur->pages[i].page,



