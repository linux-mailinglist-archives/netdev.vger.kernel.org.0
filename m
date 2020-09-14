Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1320026834E
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 05:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgINDzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 23:55:16 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12245 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725965AbgINDzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Sep 2020 23:55:14 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0F836860BB16A348464B;
        Mon, 14 Sep 2020 11:55:12 +0800 (CST)
Received: from huawei.com (10.175.113.32) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Mon, 14 Sep 2020
 11:55:05 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH -next] can: peak_usb: convert to use le32_add_cpu()
Date:   Mon, 14 Sep 2020 12:17:44 +0800
Message-ID: <20200914041744.3701840-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert cpu_to_le32(le32_to_cpu(E1) + E2) to use le32_add_cpu().

Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index 1689ab387612..d8ebf35dea1c 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -186,7 +186,7 @@ static int pcan_msg_add_rec(struct pcan_usb_pro_msg *pm, int id, ...)
 
 	len = pc - pm->rec_ptr;
 	if (len > 0) {
-		*pm->u.rec_cnt = cpu_to_le32(le32_to_cpu(*pm->u.rec_cnt) + 1);
+		le32_add_cpu(pm->u.rec_cnt, 1);
 		*pm->rec_ptr = id;
 
 		pm->rec_ptr = pc;
-- 
2.25.1

