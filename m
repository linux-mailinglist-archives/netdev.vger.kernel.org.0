Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF492D3EB6
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgLIJ1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:27:48 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9045 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728986AbgLIJ1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:27:48 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CrWrp525Gzhnlx;
        Wed,  9 Dec 2020 17:26:34 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Wed, 9 Dec 2020 17:26:58 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: marvell: octeontx2: simplify the otx2_ptp_adjfine()
Date:   Wed, 9 Dec 2020 17:27:26 +0800
Message-ID: <20201209092726.20576-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
index 7bcf5246350f..56390a664517 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
@@ -12,7 +12,6 @@ static int otx2_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
 	struct otx2_ptp *ptp = container_of(ptp_info, struct otx2_ptp,
 					    ptp_info);
 	struct ptp_req *req;
-	int err;
 
 	if (!ptp->nic)
 		return -ENODEV;
@@ -24,11 +23,7 @@ static int otx2_ptp_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
 	req->op = PTP_OP_ADJFINE;
 	req->scaled_ppm = scaled_ppm;
 
-	err = otx2_sync_mbox_msg(&ptp->nic->mbox);
-	if (err)
-		return err;
-
-	return 0;
+	return otx2_sync_mbox_msg(&ptp->nic->mbox);
 }
 
 static u64 ptp_cc_read(const struct cyclecounter *cc)
-- 
2.22.0

