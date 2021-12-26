Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2120147F5B2
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 08:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhLZHPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 02:15:12 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19650 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229451AbhLZHPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 02:15:11 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BQ2k2UT015493;
        Sat, 25 Dec 2021 23:15:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=8Frq4rzjiBbH3777wRC0yaH8oszauaJ+gzbEiv/Jteo=;
 b=TjHHHDCK06D1RrluW0Mak+5s49EQbPIAKEcS6AqgAh/ESCRjdCK71/t2aK42GjcBrdui
 xu81ZpMotusQXjxos1bsTaJu7jz/a2DK7hofNW+aORRqmABq1apWMPWwPxFVEH0AJydF
 JGnmmIPNZne31AKlw5P4cBsQUC44g5XKonnBjuQO19FK6JvHBWuFOUGi/uUl3bibaAQ7
 qSxg2qYv6aEqC5VxnvvBCCsCs1/r9ztcSEvfmTHZO6AwQ4+dAjFLB2U8/+Lp2dasYdBW
 W+50i2oQCtm0RUC9XKSt2jg9cwvBG2rlk+Ydb8AkJDnCkVWv1PfuHfywyUmbdenxqPKI Ew== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3d67u0998j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 25 Dec 2021 23:15:02 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 25 Dec
 2021 23:15:00 -0800
Received: from ahp-hp.devlab.local (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sat, 25 Dec 2021 23:14:59 -0800
From:   Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>
Subject: [PATCH net-next 1/1] qed: add prints if request_firmware() failed
Date:   Sat, 25 Dec 2021 16:14:08 -0800
Message-ID: <20211226001408.107851-1-vbhavaraju@marvell.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: csque5n0iA6oatfweGlEa0Q878GETmvA
X-Proofpoint-ORIG-GUID: csque5n0iA6oatfweGlEa0Q878GETmvA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-26_02,2021-12-24_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If driver load failed due to request_firmware() not finding the device
firmware file, add prints that help remedy the situation.

Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Venkata Sudheer Kumar Bhavaraju <vbhavaraju@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 46d4207f22a3..4f5d5a1e786c 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -65,6 +65,9 @@ MODULE_LICENSE("GPL");
 
 MODULE_FIRMWARE(QED_FW_FILE_NAME);
 
+#define QED_FW_REPO		\
+	"https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git"
+
 /* MFW speed capabilities maps */
 
 struct qed_mfw_speed_map {
@@ -1285,6 +1288,9 @@ static int qed_slowpath_start(struct qed_dev *cdev,
 			DP_NOTICE(cdev,
 				  "Failed to find fw file - /lib/firmware/%s\n",
 				  QED_FW_FILE_NAME);
+			DP_NOTICE(cdev,
+				  "you may need to download firmware from %s",
+				  QED_FW_REPO);
 			goto err;
 		}
 
-- 
2.27.0

