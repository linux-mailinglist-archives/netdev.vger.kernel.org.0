Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019AC515008
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245479AbiD2QAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235747AbiD2QAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:00:43 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38228303F
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 08:57:24 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23TB9USi028701;
        Fri, 29 Apr 2022 08:57:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=bcsG1cMhYctG/xAT72JF30tZ2C2BxjhHgFuhTToc0/I=;
 b=H7oY1X9jOeCFqXjTZp9L3uOfbDaUDyPYSOUYTePe9KeDXF5EIliKM+Lerql/y6DHt3Yu
 eSv/rwN70ifiGrRPEDbVfGBWpJabmgOjhC0ug8AS2qDxOIzssBk/yQ+B+hyj7XYq/ysk
 U3xpGhy21mWEsdASieHoMOWNNyIwQozuveZi8CCT03pc5QfS6lqQcbiFpc3sbKugarg1
 d3T3wBRoRlYMgYZuJ2skE+/Z2+OERl/4xSX5YuhOXIcS3/7S4oeXmuKgb8gWDW8HkrUD
 7nqu0SwnUZvIwk6Kw3eE1KCrDF1124qkEn7WnQ111IS623uSbXPBIgt6bL52O447ElSj SQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3fqpvy6g9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 08:57:20 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 29 Apr
 2022 08:57:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 29 Apr 2022 08:57:17 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (unknown [10.5.220.141])
        by maili.marvell.com (Postfix) with ESMTP id 208C73F7054;
        Fri, 29 Apr 2022 08:57:14 -0700 (PDT)
From:   Prabhakar Kushwaha <pkushwaha@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <palok@marvell.com>, <aelior@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <manishc@marvell.com>
Subject: [PATCH net] qede: Reduce verbosity of ptp tx timestamp
Date:   Fri, 29 Apr 2022 18:57:07 +0300
Message-ID: <20220429155707.4786-1-pkushwaha@marvell.com>
X-Mailer: git-send-email 2.16.6
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: ruKxghGnmtd1aeAOVUiWgWRaMMxaMKkd
X-Proofpoint-ORIG-GUID: ruKxghGnmtd1aeAOVUiWgWRaMMxaMKkd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_07,2022-04-28_01,2022-02-23_01
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

