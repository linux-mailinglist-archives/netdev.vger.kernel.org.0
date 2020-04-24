Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A901B74C1
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgDXM2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:28:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2896 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728827AbgDXM2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 08:28:36 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 25CA67D325C9B243DC51;
        Fri, 24 Apr 2020 20:28:34 +0800 (CST)
Received: from huawei.com (10.175.101.78) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 20:28:24 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <richardcochran@gmail.com>, <vincent.cheng.xh@renesas.com>,
        <davem@davemloft.net>, <yangyingliang@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2] ptp: clockmatrix: remove unnecessary comparison
Date:   Fri, 24 Apr 2020 20:52:26 +0800
Message-ID: <1587732746-98057-1-git-send-email-yangyingliang@huawei.com>
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
+			     || loaddr > 0xfb)
 				continue;
 
 			err = idtcm_write(idtcm, regaddr, 0, &val, sizeof(val));
-- 
1.8.3

