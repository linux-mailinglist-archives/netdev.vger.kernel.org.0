Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC061B6F68
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 09:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgDXHu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 03:50:26 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:40744 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbgDXHu0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 03:50:26 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 45A10EA8B14049E568E8;
        Fri, 24 Apr 2020 15:50:23 +0800 (CST)
Received: from huawei.com (10.175.101.78) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 15:50:15 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <richardcochran@gmail.com>, <vincent.cheng.xh@renesas.com>,
        <davem@davemloft.net>, <yangyingliang@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] ptp: clockmatrix: remove unnecessary comparison
Date:   Fri, 24 Apr 2020 16:14:18 +0800
Message-ID: <1587716058-1840-1-git-send-email-yangyingliang@huawei.com>
X-Mailer: git-send-email 1.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.78]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The type of loaddr is u8 which is always '<=' 0xff, so the
loaddr <= 0xff is always true, we can remove this comparison.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/ptp/ptp_clockmatrix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 032e112..56aee4f 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -780,7 +780,7 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
 
 			/* Page size 128, last 4 bytes of page skipped */
 			if (((loaddr > 0x7b) && (loaddr <= 0x7f))
-			     || ((loaddr > 0xfb) && (loaddr <= 0xff)))
+			     || loaddr <= 0xff)
 				continue;
 
 			err = idtcm_write(idtcm, regaddr, 0, &val, sizeof(val));
-- 
1.8.3

