Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD8A7109AC5
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 10:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfKZJKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 04:10:12 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:62576 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726346AbfKZJKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 04:10:11 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAQ99HkP008842;
        Tue, 26 Nov 2019 01:09:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=Yd04vNpTe4X+kyZfH7BmCbD6zSKxJdJ2b2hlSN8Isqw=;
 b=O2rSeZnz1n+cdMgHj5NZWke7RjfuLuve1x/Bk0Z0LqmfkWTXotgDyhXMBBDbPhV8K6fa
 x50Pn10mt4T3+ODfNDZIz3guULOBYYSGbbh127z1ck6pHW/TT2encmZxBAULD9pIQK74
 +46sJ1X1y4CE2PTtrQol8BnGhBXmkOptdLG9mYUgktKEtsB6dDR3nVNvQKXFBjxRlmr4
 QCYlIld+AXr8NjErUz+1HAPmeB8RrghsI9X6H53WbWyor8uyZvhbB/dQybZYYbesZZOy
 xmePAVgDsUXXbKDqO3RBUBSI1pjwBkZ5pBNXRayAI3XcyuHf4mvlSk02Vm8XJqR2XzfA JA== 
Received: from nam05-co1-obe.outbound.protection.outlook.com (mail-co1nam05lp2051.outbound.protection.outlook.com [104.47.48.51])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2wf180bemu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Nov 2019 01:09:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWgnoVs50xhzGlWZgTf5E9azfq2oe1wKkqk4cF2xIPT2wsGCDe1tboWhU6clOBPje7OpJN+Ki7vBtkUT1vdRSZR15LjAC1Pd0vM32QqMBDhCQD5NT5d4lM5vMHcX82bPkKy6bzeyYSZNmLZwK6Zi0Q7GQsV/OapyDGmrHSdjosASvsyl9dzc4fJ6SLW11oizZqnNKBxU2IZyB+gYTXw8wx73K6HW/M7C/j5PrIuqgfne6veNbn3XIcwTXSl4Cp6H9mWoq+WipudtVjY4om27n1PTDVKru9eVTlspZHNTD2grLOdBZ5ZFf4AJ8wANPPd+Lbx6xu8z7qnubK4CDbYrpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yd04vNpTe4X+kyZfH7BmCbD6zSKxJdJ2b2hlSN8Isqw=;
 b=BNAxgEHPqpOUh3JYATUyCTJAMk5TjKr2pTuSOKfGicj4eGH7PD2ORwqZr6erQx3ec9ug3+ZoObBAEmLy2bQcB28xe2waGlffDktHpBzv8CYyRA9FiSa1NMr9D33eTfj6UqZypRQ3XHGmpjZX7q7nKOjKn0ddbFIR/XoD3kF1wqe3Ag2cmSbF1XON9/Jub96stxtDaknibyZk4G+MPTvT8GKQlbJm3J9JWb8N0JGbiRk30SKyq29KVfq3FEzeFq18cwkndyhNxPeKPVd+7TdA9rRy0dc93FbXQbR2joVgR1hUxzh1xclyvVjTUbOzX5VyU8GrjaKQ9LwB+XaCwBWoKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 158.140.1.28) smtp.rcpttodomain=gmail.com smtp.mailfrom=cadence.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yd04vNpTe4X+kyZfH7BmCbD6zSKxJdJ2b2hlSN8Isqw=;
 b=K9Zk1DCMAct2iPgg77lsuLa1rDEuuh6pjyYrROPsx96H2HJhX+Cnd7KHV5dKmaY/djzLtI9CeL3wjlvkFmCSIGdCM0O2QIWOUNF12ScFsCUKNVOSuQxYKbYAaN38Hl1p5fia8wR6sIh6QciqKXu4nvOc0zk+N0eRGxiJoQI92g8=
Received: from BYAPR07CA0057.namprd07.prod.outlook.com (2603:10b6:a03:60::34)
 by DM6PR07MB6986.namprd07.prod.outlook.com (2603:10b6:5:1f0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.19; Tue, 26 Nov
 2019 09:09:55 +0000
Received: from DM6NAM12FT059.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe59::200) by BYAPR07CA0057.outlook.office365.com
 (2603:10b6:a03:60::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.18 via Frontend
 Transport; Tue, 26 Nov 2019 09:09:55 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 158.140.1.28 as permitted sender)
Received: from sjmaillnx1.cadence.com (158.140.1.28) by
 DM6NAM12FT059.mail.protection.outlook.com (10.13.179.1) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.18 via Frontend Transport; Tue, 26 Nov 2019 09:09:55 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id xAQ99pFJ013795
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Tue, 26 Nov 2019 01:09:52 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Tue, 26 Nov 2019 10:09:50 +0100
Received: from lvlabd.cadence.com (10.165.128.103) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 26 Nov 2019 10:09:50 +0100
Received: from lvlabd.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabd.cadence.com (8.14.4/8.14.4) with ESMTP id xAQ99oXv103154;
        Tue, 26 Nov 2019 09:09:50 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <andrew@lunn.ch>, <antoine.tenart@bootlin.com>
CC:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <pthombar@cadence.com>,
        Milind Parab <mparab@cadence.com>
Subject: [PATCH 2/3] net: macb: add support for C45 MDIO read/write
Date:   Tue, 26 Nov 2019 09:09:49 +0000
Message-ID: <1574759389-103118-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1574759354-102696-1-git-send-email-mparab@cadence.com>
References: <1574759354-102696-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:158.140.1.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(136003)(346002)(189003)(199004)(36092001)(4326008)(47776003)(54906003)(50466002)(76130400001)(107886003)(5660300002)(8936002)(86362001)(110136005)(356004)(316002)(305945005)(186003)(7636002)(70206006)(11346002)(426003)(53416004)(2906002)(446003)(246002)(76176011)(51416003)(36756003)(50226002)(8676002)(336012)(478600001)(26826003)(70586007)(7696005)(26005)(2616005)(7126003)(48376002)(16586007)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB6986;H:sjmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:corp.cadence.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc6b193d-3437-42fa-2ca8-08d772506761
X-MS-TrafficTypeDiagnostic: DM6PR07MB6986:
X-Microsoft-Antispam-PRVS: <DM6PR07MB6986DFD0477EDC13D3F5C772D3450@DM6PR07MB6986.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 0233768B38
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rHZgajFI00RBno6UpaoAXsDhbnHVLi0BWxsntkQIv6fQ2MAiLKXd/0ZcFu/dM3KuUw3GnIk8zsICuRfDFMEdBWxzdntae0dE+lHcf2orIpFciPbKk50Ad+LC+NZItzh+TqLt5FVPlbwDtrF3FND7a38VgRQSaHgBWahY7ZaZirmBP7mG2vVjXzsmvYhQNxTrtTHgx1ubuxstpqzzK8j7cDJqMx7DQDrqTaJ1zifzkNSWmVt0YA81xMr04wanB1Iz7Ep+C30aDQbBy448W7WMgok2nIRwOzDSZwrn/ZFhIF0e/fKdSjRC1VitqDG2/IIEa3zActDys6shdWp+dFZKRDEDsxwKeoAqcTjWya4FJAz+u8s90OdYJKwHwK9x9P6lh9XdMIJgCecKGgA9sLCsBnVRtmsdwNcREb7BJ6TZahsYaeCPdry3VWgRwCv8Y/zcuITgu5cU8CIFFhC4t3MaYQ==
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2019 09:09:55.2513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc6b193d-3437-42fa-2ca8-08d772506761
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.28];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6986
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-26_01:2019-11-26,2019-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=915 mlxscore=0 suspectscore=0 phishscore=0
 spamscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911260083
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
index 5e6d27d33d43..7cdadc200c28 100644
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

