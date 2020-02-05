Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23DDA153179
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 14:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgBENLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 08:11:17 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4422 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727051AbgBENLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 08:11:16 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 015D5gIF028212;
        Wed, 5 Feb 2020 05:11:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=40s3k6jFQhVZWxURP8VvNOKHWnIHUNWxe60CSgzShfE=;
 b=gfyYSdcbaYTiflg9LZeQMlW3z9B0+zdDICn8XAM1k+T2iAUV+aoQ3ZCDJKA3n5MfUfJy
 T1GrueThQiHC6GWAXo/ppFG9wMNzSb7nHEptG3BT2du88Ru0yF7TteLtgZi/dl9VeR3e
 6ZTg7nPIPOlSYj3HmoXNvWILershgQWJQtJgaysG4g9y9s/IZ2XDkq9XLJ+E3A82VLBU
 X4yNoL9V6SPo4a7Oq38y2U7IcBuPlwg7gMIklVAzgdRzfzilZrtHzoXTNUV9Y+RdqYbd
 K8ZzjFuDQz1A6tTH/yJufsB2db90Gz6QetxM6YwjUq3AGGRF6DyOcHhcJllax/HUZ7t3 uQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xyhn12w9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 05 Feb 2020 05:11:14 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 5 Feb
 2020 05:11:12 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 5 Feb 2020 05:11:12 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 1A3783F71CA;
        Wed,  5 Feb 2020 05:11:12 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 015DBBca017264;
        Wed, 5 Feb 2020 05:11:11 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 015DBBGD017263;
        Wed, 5 Feb 2020 05:11:11 -0800
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net 1/1] qed: Fix timestamping issue for L2 unicast ptp packets.
Date:   Wed, 5 Feb 2020 05:10:55 -0800
Message-ID: <20200205131055.17227-1-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_03:2020-02-04,2020-02-05 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit cedeac9df4b8 ("qed: Add support for Timestamping the unicast
PTP packets.") handles the timestamping of L4 ptp packets only.
This patch adds driver changes to detect/timestamp both L2/L4 unicast
PTP packets.

Fixes: cedeac9df4b8 ("qed: Add support for Timestamping the unicast PTP packets.")
Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ptp.c b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
index 0dacf2c..3e61305 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ptp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
@@ -44,8 +44,8 @@
 /* Add/subtract the Adjustment_Value when making a Drift adjustment */
 #define QED_DRIFT_CNTR_DIRECTION_SHIFT		31
 #define QED_TIMESTAMP_MASK			BIT(16)
-/* Param mask for Hardware to detect/timestamp the unicast PTP packets */
-#define QED_PTP_UCAST_PARAM_MASK		0xF
+/* Param mask for Hardware to detect/timestamp the L2/L4 unicast PTP packets */
+#define QED_PTP_UCAST_PARAM_MASK              0x70F
 
 static enum qed_resc_lock qed_ptcdev_to_resc(struct qed_hwfn *p_hwfn)
 {
-- 
1.8.3.1

