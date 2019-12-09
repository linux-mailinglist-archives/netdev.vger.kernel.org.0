Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A966F116C1E
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 12:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfLILPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 06:15:42 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:11618 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727188AbfLILPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 06:15:42 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB9BD5ii010316;
        Mon, 9 Dec 2019 03:15:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=4vRtUnE3XysitoWgSGaWij+7gZphnZWB2sfqpGSjCX0=;
 b=ccIHxcVE5wgszQtqrsTewyAUVAYc0urFU38rcWWFgaaP7dy6T8A3H8VXicmSoG3E3l4k
 sUvp1utAAJmIDSppnXdniICgmVcjgJGk14S6KwzwEuiAMqETmxwZOwadOVrTMkVdNt/X
 Qv8r3AIPRlwCR/5aSxi6oRNpv9/TDK8+1LK8T9JD5MgO6lhncywqofAN4nKJfxQHNokF
 5MmcooJAwMZSkWECJ9ONNn4k+CfyROfxn9DRNajxMEm8poUWuHBzAf9mHclJm9HJY8xl
 He0ZcNMsEfGQegV01kPEmRklwgx9+kA1YNP2bCMArrPpfsD7SBoDCuOLA5WCmik8gPOb 6w== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2wra705acw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Dec 2019 03:15:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BuzlpAdBBsocbfqSOiyXZxe80H4UPNgkc8jqevB6l1a/ZpRfUyj2/QeJCprD5QuRXSyIODPw2STkZk7HVylLlnXliThCLivfBidWFd58L1Tn5XkAX9jiqj34tQ4K+BBEgcd6zb3WABdOJJdrrJeG1A4SUXOaodVXLWlMxXtug5i5WugHL1y4I7h2yReGuh5vfNV3nXPWT3XZLG8CrrfbLnsOPwgVkg80OUtEP9OVXrjawi1rBW01m0LJx4UHytv5jOBhlh4JM1jNBTSNlNDsafvSgoCJby0Zdaw3hGnejCbLDjXkxnht+1Xiul2TOAs39qAS9Vx9J1LeRv/YHwdU8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vRtUnE3XysitoWgSGaWij+7gZphnZWB2sfqpGSjCX0=;
 b=DTr7qjzEflYBlNVGZ4svuLzgK0g1N0EXizYRbZ8wJ6kMf5guYQLgbr6GwJNgNJZ94oHAfeIYUVxH2Vb0arp6AN7f5R3LAQFKNudX7i+bj/Od/LXcD9cw+ErpqcPjO7SihszCs9hSxLo5LVvFs7RaSwGtTHLUSY1kZhOfgl0bwnYgFY6r20We4xGKrzoDFiorEDCeslU3ymh26XnvE5t4nDe5Z97aJ3T9TlCs0BL9BSA+mQH/3OD6oFntWKDXwEHCcBU9+CmyAUHM8at4tT5Dz1J1v59f1PTxiYOKRlHq1EkIfdwtI97aRoX7rXCVzZ1oCRD90KURHUtUqdoo9IU6HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 199.43.4.28) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vRtUnE3XysitoWgSGaWij+7gZphnZWB2sfqpGSjCX0=;
 b=WhL+SQhA3uA72wXeCq71/PALqJFV0UBnqVSW3BdrP3UGzZCvasTOcAhO8btMaXQKMJi0cmn1eFxQnxuXpe78pO4MVSfK7li7a3KnTnyGXfymMs1gLs6TTKXd2IbCZv6HWtcHkarwvpcpzrNY2JELNdA7iTbCfUUWGYEsCLjqz1I=
Received: from CO2PR07CA0067.namprd07.prod.outlook.com (2603:10b6:100::35) by
 MWHPR07MB2752.namprd07.prod.outlook.com (2603:10b6:300:28::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Mon, 9 Dec 2019 11:15:18 +0000
Received: from MW2NAM12FT035.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5a::207) by CO2PR07CA0067.outlook.office365.com
 (2603:10b6:100::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2516.14 via Frontend
 Transport; Mon, 9 Dec 2019 11:15:18 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 199.43.4.28 as permitted sender) receiver=protection.outlook.com;
 client-ip=199.43.4.28; helo=rmmaillnx1.cadence.com;
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 MW2NAM12FT035.mail.protection.outlook.com (10.13.181.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18 via Frontend Transport; Mon, 9 Dec 2019 11:15:18 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id xB9BFFMB009388
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 9 Dec 2019 06:15:16 -0500
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Mon, 9 Dec 2019 12:15:14 +0100
Received: from lvlabd.cadence.com (10.165.128.103) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 9 Dec 2019 12:15:14 +0100
Received: from lvlabd.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabd.cadence.com (8.14.4/8.14.4) with ESMTP id xB9BFEjO024923;
        Mon, 9 Dec 2019 11:15:14 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <nicolas.nerre@microchip.com>, <andrew@lunn.ch>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <a.fatoum@pengutronix.de>,
        <brad.mouring@ni.com>, <rmk+kernel@armlinux.org.uk>,
        <pthombar@cadence.com>, Milind Parab <mparab@cadence.com>
Subject: [PATCH 2/3] net: macb: add support for C45 MDIO read/write
Date:   Mon, 9 Dec 2019 11:15:12 +0000
Message-ID: <1575890112-24877-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1575890033-23846-1-git-send-email-mparab@cadence.com>
References: <1575890033-23846-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(376002)(39860400002)(396003)(189003)(36092001)(199004)(107886003)(7416002)(356004)(7126003)(2616005)(26826003)(305945005)(4326008)(478600001)(86362001)(2906002)(26005)(54906003)(336012)(7696005)(426003)(36756003)(110136005)(81166006)(76130400001)(186003)(5660300002)(70206006)(8676002)(70586007)(8936002)(81156014)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR07MB2752;H:rmmaillnx1.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a063e2e0-8675-465e-abf0-08d77c991302
X-MS-TrafficTypeDiagnostic: MWHPR07MB2752:
X-Microsoft-Antispam-PRVS: <MWHPR07MB275223900862CA3DA32106BED3580@MWHPR07MB2752.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 02462830BE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FoHjXBt8jnd4tjkhBSxUht2bCFSOjq03oE8a/F8sbsfkdZnw+OZwuEUWE3a7PWNcygjmrClFLYFz7vFk9/cIZhRC+man3MKN5NR78SDpPkZfcRdPh+dC1SjZB/uitJGSZJLYMLXcWodcHGHz3M1kci2sAlzCq3krmL+DIGyeZCf+yet3GPtxQ4DBcdAEF6N1uD0Xk4obIqUgOI1MO2DKOQGcxugTOaGDESlg9NZoiB51EYhSRiQOlBVKetFLVVJh70iwz6a0OqMVeRdYKU+JoWDoCtLDHZMyMOro1vl6bVlD2Zdwp8Kk/h6ogGg+6V1325e7CZpsZplWyDc0s4UiRMgtEu7pyXcHx13sCqfCstdjJNxP60zWK7rWP6zIpFBUpXXKS4PV+7icwu0WLeqnsi4DEP+71BVWZd/9HgpGsTTfPc1t3eqn5zM114MmHk6/31xnLq6okXuTSiNwDPKQjXfCTx22GP7hrdoGZcnyJyB1+8StNeg8bSCzltsDM3lG
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2019 11:15:18.5496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a063e2e0-8675-465e-abf0-08d77c991302
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR07MB2752
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_02:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxlogscore=936
 suspectscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912090096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch modify MDIO read/write functions to support
communication with C45 PHY.

Signed-off-by: Milind Parab <mparab@cadence.com>
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
index 6b68ef34ab19..17297b01e85e 100644
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

