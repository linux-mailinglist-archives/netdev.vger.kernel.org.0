Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A91C135471
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 09:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgAIIhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 03:37:20 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:30420 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728465AbgAIIhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 03:37:20 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0098ZDoM023182;
        Thu, 9 Jan 2020 00:36:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=8YbVc4k7jLla2B5DvAh4z4LCeDhfCbmBhB6qQ55BaxE=;
 b=DPX/Ij56T22gL91B1QogEUK+zouKovmzvdgUzFRpwwGb6dMt0Gjlq/yxxjZP/AY118oK
 z4dOoaJhubzdIXyrHtilIbtx8l+kQTXp5v0xDsAR3XD8q07rUT3/PStfapMZvSUMeY4u
 hU9yefO9+qeVwfqQTkeKFucyWJs2hk9XnWOHNS06fcXxCUp8F0CKTZPeiei/NwnvPRZY
 46CcyuAMK1ZSNU+m5aWGtuYTA2iu+Rs+WplOuyRHkIi7db8rKGe4piNjQjfBoKS6hm8T
 uqRzIn1Ex0/CVDFjmM/Lgqzqkm7Hfl+ytVC1bwNuQc7jrCvdGZbgug04U+rnO0s27PRc RQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2xaq62142m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jan 2020 00:36:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9DZllYJiuyOg1sS90NefwnZdVo8gyrusi3F4taq0FvpYKwgtdIro1ufsPndYpN9tx7M5Df5wtfgoiv9zMM7OaklY0YsooGTNNXHeDr/cz1YMjie84WNTSC2AGy0QPBnlA1wOQ7PHSe48twzAAWYWeVSRMkxUNSEq5NZPxQWujE1IZXWQp0zhSwrzbbrhPfKcfp2pk6FI7oK0DE1iwvJBnRLUvR7dRAm+e4OmWr5G6p+lH0X6TyXVRCNQjWQDBtBiVNucazfco++KMpx2Y8gOMWDfGJDERYDiEWnf7oaA4lsOzA6qE43+REh5C1onv8Qe0dkWGeGsA3tM+hxzUjvNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YbVc4k7jLla2B5DvAh4z4LCeDhfCbmBhB6qQ55BaxE=;
 b=a7DneohNXcdWCS0OTmW47db7o9z2x0PGMZplN6V7R3FXTehvcaWDAsfJ3qYEXDWstUrZnfMGEEeEWL8B3pNlihxcAMW0Ge84EicT2IWYjDrkRPMARZYbyxLH4dPX3UWkiy60L8abEbEnBlZTx7tyzzGWgsVn8WbHohi6tNPVT+GDQnsRy73Iji2sEgjCdh3rz/MGbyrxiM2AKNmM7s4srDksQMh271vZEhFzLknSNGikFyTFVubYbYDtqrZNb3UhhqcWnsGM7vAFrYbL485XfqTKpKnRWmABLjgwe8hRTPu67HDHZnqYYwPzfIJo9wtsCDxMLy3j0sCnhLfREa0HEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 199.43.4.28) smtp.rcpttodomain=gmail.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YbVc4k7jLla2B5DvAh4z4LCeDhfCbmBhB6qQ55BaxE=;
 b=BSrXksVYcyKrJh++b64MZaIsZEjWghFBZhXr/zzKDvfizYEemn53hKh11B+h033ZXYh13+EHoRLiF1e1diXcskMXivxqFxPa3SdfFQBRBuostI6WKHZFkAu8FwFPx2+pv8sWYACYvHlgIEbXsMZD6OMcH6NjZfkPpBvZ3MAc5Ss=
Received: from CH2PR07CA0016.namprd07.prod.outlook.com (2603:10b6:610:20::29)
 by MWHPR0701MB3787.namprd07.prod.outlook.com (2603:10b6:301:79::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.15; Thu, 9 Jan
 2020 08:36:56 +0000
Received: from BN8NAM12FT051.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5b::206) by CH2PR07CA0016.outlook.office365.com
 (2603:10b6:610:20::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend
 Transport; Thu, 9 Jan 2020 08:36:56 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 199.43.4.28 as permitted sender) receiver=protection.outlook.com;
 client-ip=199.43.4.28; helo=rmmaillnx1.cadence.com;
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 BN8NAM12FT051.mail.protection.outlook.com (10.13.182.230) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.4 via Frontend Transport; Thu, 9 Jan 2020 08:36:55 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 0098amgF000537
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 9 Jan 2020 03:36:50 -0500
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Thu, 9 Jan 2020 09:36:48 +0100
Received: from lvlabc.cadence.com (10.165.128.101) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 9 Jan 2020 09:36:48 +0100
Received: from lvlabc.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabc.cadence.com (8.14.4/8.14.4) with ESMTP id 0098alD2016386;
        Thu, 9 Jan 2020 08:36:47 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <andrew@lunn.ch>, <jakub.kicinski@netronome.com>,
        <rmk+kernel@armlinux.org.uk>, <nicolas.ferre@microchip.com>
CC:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dkangude@cadence.com>,
        <pthombar@cadence.com>, Milind Parab <mparab@cadence.com>
Subject: [PATCH net-next] net: macb: add support for C45 MDIO read/write
Date:   Thu, 9 Jan 2020 08:36:46 +0000
Message-ID: <1578559006-16343-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39850400004)(346002)(136003)(199004)(189003)(36092001)(26005)(4326008)(478600001)(70586007)(36756003)(70206006)(356004)(5660300002)(26826003)(7696005)(54906003)(8936002)(426003)(110136005)(2616005)(7126003)(186003)(2906002)(107886003)(336012)(316002)(81156014)(8676002)(81166006)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR0701MB3787;H:rmmaillnx1.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:InfoDomainNonexistent;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42765479-362d-4828-525a-08d794df15a1
X-MS-TrafficTypeDiagnostic: MWHPR0701MB3787:
X-Microsoft-Antispam-PRVS: <MWHPR0701MB37877CE7A9A68FFA0805259BD3390@MWHPR0701MB3787.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 02778BF158
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m4khgsBDKTPTiux9iBGW6peR4A2J79O2O1y7ktQM1yMIpVbZwornTHJJOxU52qC3bTA+Mo2q51WDnJmwGKElxUGIe4klOdR6GD7HT3XeREitDB28Uknd+9mZFpDj46wbWxooF6dfHoBHxXOdvxy1yagsjS1gfBij7K5IObgd8akNDr5zEu+kyfzODJvwrXRIk4qGGB314RU8wmrQM9wkvY/CDYii5mIeerJ8LmrBnXT/EBAS1RYAQrg4R4WTYp5eYnuyAmLNG+akkYwq+gHH0bRB3iXlrRpxPVnp5sGMPIYLzsQW09KZwCvePtmKdsnNbfwjvBvVKARLtcYmsXequrDsLzkMozQ8TxpV9ssQd5ys8g70YabJ5xfUC1jHH1rlZBGAdIixp7j7eWiW46P7aOOaWawv9mqnMQ+2eH/5RbRGfYNQta+gyBonunN+xfW2/hfq1w8Xj7+E3aEp8cjN93PBU0jVYcr448LV3RYLD1d1sErtjR+TFw7rfcVlrQU1
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2020 08:36:55.6745
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42765479-362d-4828-525a-08d794df15a1
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0701MB3787
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_02:2020-01-08,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxlogscore=857
 impostorscore=0 suspectscore=0 clxscore=1011 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001090074
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch modify MDIO read/write functions to support
communication with C45 PHY.

Signed-off-by: Milind Parab <mparab@cadence.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/cadence/macb.h      | 15 ++++--
 drivers/net/ethernet/cadence/macb_main.c | 61 +++++++++++++++++++-----
 2 files changed, 61 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 19fe4f4867c7..dbf7070fcdba 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -630,10 +630,17 @@
 #define GEM_CLK_DIV96				5
 
 /* Constants for MAN register */
-#define MACB_MAN_SOF				1
-#define MACB_MAN_WRITE				1
-#define MACB_MAN_READ				2
-#define MACB_MAN_CODE				2
+#define MACB_MAN_C22_SOF			1
+#define MACB_MAN_C22_WRITE			1
+#define MACB_MAN_C22_READ			2
+#define MACB_MAN_C22_CODE			2
+
+#define MACB_MAN_C45_SOF			0
+#define MACB_MAN_C45_ADDR			0
+#define MACB_MAN_C45_WRITE			1
+#define MACB_MAN_C45_POST_READ_INCR		2
+#define MACB_MAN_C45_READ			3
+#define MACB_MAN_C45_CODE			2
 
 /* Capability mask bits */
 #define MACB_CAPS_ISR_CLEAR_ON_WRITE		0x00000001
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 41c485485619..7e7361761f8f 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -337,11 +337,30 @@ static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (status < 0)
 		goto mdio_read_exit;
 
-	macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_SOF)
-			      | MACB_BF(RW, MACB_MAN_READ)
-			      | MACB_BF(PHYA, mii_id)
-			      | MACB_BF(REGA, regnum)
-			      | MACB_BF(CODE, MACB_MAN_CODE)));
+	if (regnum & MII_ADDR_C45) {
+		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
+			    | MACB_BF(RW, MACB_MAN_C45_ADDR)
+			    | MACB_BF(PHYA, mii_id)
+			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
+			    | MACB_BF(DATA, regnum & 0xFFFF)
+			    | MACB_BF(CODE, MACB_MAN_C45_CODE)));
+
+		status = macb_mdio_wait_for_idle(bp);
+		if (status < 0)
+			goto mdio_read_exit;
+
+		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
+			    | MACB_BF(RW, MACB_MAN_C45_READ)
+			    | MACB_BF(PHYA, mii_id)
+			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
+			    | MACB_BF(CODE, MACB_MAN_C45_CODE)));
+	} else {
+		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C22_SOF)
+				| MACB_BF(RW, MACB_MAN_C22_READ)
+				| MACB_BF(PHYA, mii_id)
+				| MACB_BF(REGA, regnum)
+				| MACB_BF(CODE, MACB_MAN_C22_CODE)));
+	}
 
 	status = macb_mdio_wait_for_idle(bp);
 	if (status < 0)
@@ -370,12 +389,32 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	if (status < 0)
 		goto mdio_write_exit;
 
-	macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_SOF)
-			      | MACB_BF(RW, MACB_MAN_WRITE)
-			      | MACB_BF(PHYA, mii_id)
-			      | MACB_BF(REGA, regnum)
-			      | MACB_BF(CODE, MACB_MAN_CODE)
-			      | MACB_BF(DATA, value)));
+	if (regnum & MII_ADDR_C45) {
+		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
+			    | MACB_BF(RW, MACB_MAN_C45_ADDR)
+			    | MACB_BF(PHYA, mii_id)
+			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
+			    | MACB_BF(DATA, regnum & 0xFFFF)
+			    | MACB_BF(CODE, MACB_MAN_C45_CODE)));
+
+		status = macb_mdio_wait_for_idle(bp);
+		if (status < 0)
+			goto mdio_write_exit;
+
+		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
+			    | MACB_BF(RW, MACB_MAN_C45_WRITE)
+			    | MACB_BF(PHYA, mii_id)
+			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
+			    | MACB_BF(CODE, MACB_MAN_C45_CODE)
+			    | MACB_BF(DATA, value)));
+	} else {
+		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C22_SOF)
+				| MACB_BF(RW, MACB_MAN_C22_WRITE)
+				| MACB_BF(PHYA, mii_id)
+				| MACB_BF(REGA, regnum)
+				| MACB_BF(CODE, MACB_MAN_C22_CODE)
+				| MACB_BF(DATA, value)));
+	}
 
 	status = macb_mdio_wait_for_idle(bp);
 	if (status < 0)
-- 
2.17.1

