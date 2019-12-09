Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23534116DB8
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 14:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfLINLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 08:11:35 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:52102 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727513AbfLINLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 08:11:35 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5D3AC9DB6D125A02467D;
        Mon,  9 Dec 2019 21:11:31 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Mon, 9 Dec 2019 21:11:22 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <davem@davemloft.net>, <gregkh@linuxfoundation.org>,
        <alexios.zavras@intel.com>, <oneukum@suse.com>,
        <tglx@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Mao Wenan <maowenan@huawei.com>,
        "Hulk Robot" <hulkci@huawei.com>
Subject: [PATCH v2 -next] NFC: port100: Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().
Date:   Mon, 9 Dec 2019 21:08:45 +0800
Message-ID: <20191209130845.47777-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert cpu_to_le16(le16_to_cpu(frame->datalen) + len) to
use le16_add_cpu(), which is more concise and does the same thing. 

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 v2: change log as julia suggest.
 drivers/nfc/port100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 604dba4..8e4d355 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -565,7 +565,7 @@ static void port100_tx_update_payload_len(void *_frame, int len)
 {
 	struct port100_frame *frame = _frame;
 
-	frame->datalen = cpu_to_le16(le16_to_cpu(frame->datalen) + len);
+	le16_add_cpu(&frame->datalen, len);
 }
 
 static bool port100_rx_frame_is_valid(void *_frame)
-- 
2.7.4

