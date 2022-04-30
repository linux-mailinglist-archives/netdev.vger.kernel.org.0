Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8E0515981
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 03:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381963AbiD3BNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 21:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346943AbiD3BNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 21:13:32 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9082184
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 18:10:12 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23TNXo4O010377;
        Fri, 29 Apr 2022 18:10:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=su1eNsWBeRFNA9EOipyHjI5PSjI56Eq8oiycF3OL4nI=;
 b=hcHerM5wOWO+nPvFF+tO1beTb6WHgNKJPie/YMpqQnMIAtiA5m+5hb42fAVxfUEAvIyv
 q+jZ5u5VhXWt9ZVRLP7CztPNpxBmbR8g0YUNlgeq+m8bX1lBELgIfmBMjH+LNufEe0Qo
 G9DRQsLmgsT2hNjuwjfB7XvWrCvrrZhFAH3j4hfO5W+PrJbbVBAcdf7XZ+WNwuFNqBgJ
 4/4feBMJNtg2E6CJSXGt80WYHK3b2cqHlDZbX4D546bnChxc23oL9pNyCwunXlqmythN
 YdO2oyRV7RFocwSMIwg71S924MhCkS7ji4RHYzgzh5K6DSnoj+xxC3qrYOyJDsMyZQjp HA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3fr49gw5a3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 18:10:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Apr
 2022 18:05:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 29 Apr 2022 18:05:21 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (unknown [10.5.220.141])
        by maili.marvell.com (Postfix) with ESMTP id 3D8343F706F;
        Fri, 29 Apr 2022 18:05:19 -0700 (PDT)
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <palok@marvell.com>, <aelior@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <manishc@marvell.com>
Subject: [PATCH net-next][v2] qede: Reduce verbosity of ptp tx timestamp
Date:   Sat, 30 Apr 2022 04:05:13 +0300
Message-ID: <20220430010513.20655-1-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: -dIMxMX08kyStxIVRlwSnayf6ZrxpL9M
X-Proofpoint-GUID: -dIMxMX08kyStxIVRlwSnayf6ZrxpL9M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_10,2022-04-28_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce verbosity of ptp tx timestamp error to reduce excessive log
messages.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
---
Changes for v2: Update tag in subject.

 drivers/net/ethernet/qlogic/qede/qede_ptp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_ptp.c b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
index 39176e765767..c9c8225f04d6 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ptp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ptp.c
@@ -496,19 +496,19 @@ void qede_ptp_tx_ts(struct qede_dev *edev, struct sk_buff *skb)
 
 	if (test_and_set_bit_lock(QEDE_FLAGS_PTP_TX_IN_PRORGESS,
 				  &edev->flags)) {
-		DP_ERR(edev, "Timestamping in progress\n");
+		DP_VERBOSE(edev, QED_MSG_DEBUG, "Timestamping in progress\n");
 		edev->ptp_skip_txts++;
 		return;
 	}
 
 	if (unlikely(!test_bit(QEDE_FLAGS_TX_TIMESTAMPING_EN, &edev->flags))) {
-		DP_ERR(edev,
-		       "Tx timestamping was not enabled, this packet will not be timestamped\n");
+		DP_VERBOSE(edev, QED_MSG_DEBUG,
+			   "Tx timestamping was not enabled, this pkt will not be timestamped\n");
 		clear_bit_unlock(QEDE_FLAGS_PTP_TX_IN_PRORGESS, &edev->flags);
 		edev->ptp_skip_txts++;
 	} else if (unlikely(ptp->tx_skb)) {
-		DP_ERR(edev,
-		       "The device supports only a single outstanding packet to timestamp, this packet will not be timestamped\n");
+		DP_VERBOSE(edev, QED_MSG_DEBUG,
+			   "Device supports a single outstanding pkt to ts, It will not be ts\n");
 		clear_bit_unlock(QEDE_FLAGS_PTP_TX_IN_PRORGESS, &edev->flags);
 		edev->ptp_skip_txts++;
 	} else {
-- 
2.27.0

