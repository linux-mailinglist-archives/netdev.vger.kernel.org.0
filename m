Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7B111E10D
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 10:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfLMJmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 04:42:21 -0500
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:1258 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725799AbfLMJmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 04:42:21 -0500
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBD9eVN4009865;
        Fri, 13 Dec 2019 01:42:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=Fpq9Ao6PpjM0ty//hCtZWpiiq9Tkp9mEzG7mYPoPFmU=;
 b=syOcWH2HywPk65SDqNj+Qu8PeYOMLX1MAx6E1/7HfNJlq96R4nFpjdWaxs2GM4avMCWz
 9TDn1SqpSoGxZAvuuGNTE1vwJ+pFd62mNEoTd66WV0MVDKLPZshHekHdlf/oK5pkTIFf
 DQX8Gg+M/93f4lPCz3dTSFqzRSF+6K9rKjOd8xwtdJBQqStENrsGMWt3M5YyTTLX48Jc
 BTpcOGCPuDUXm3TuDDwsb538wLlDLoE9EfUMHCGWo8VmjJbVTAYVaQL3BWaKmV/mWUGB
 OHYOECGnSOHFsPUmIcSRMYn7JHMOgNi5XzFxFIkwYP2KwHnaxPHYFMYjrKjiYgTGDi0o iA== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by mx0b-0014ca01.pphosted.com with ESMTP id 2wr9dfx4kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Dec 2019 01:42:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aD5dcfKhqo2Jrnst+Zaioh56aayW7ofIxd6sl3TLd+5flXiCQIqaZdDCbSj92lpuxhRaoH0sBqGfLkWACNMW/FAbJDFOHlljaMRPHMhTGogA+0Bxo+BZ6++xTJGCkv+eczIZUjcDXYYxZAciQWg53ebYbqP0T7tWXmA/a2/G8gDPDk0JN2q8tHEZPCPQ+bYV67YKEAPluwDFw3NuzD/JhIo1bnBIn3if1gCXcH/LUeCTY45sZoqpJzFv+lnG6DWQAe8AR3rCL2g1Qb2BO/Jg+/wFFj4/bSL2r0jG6yESiOnINihYLYQhICvWTcpmAzg4kl9yaI9bev5ytHOxvxrApA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fpq9Ao6PpjM0ty//hCtZWpiiq9Tkp9mEzG7mYPoPFmU=;
 b=PjX/oYheU0SpyYKCcnV/D5qJ7v1d1wMhOmpY2b/DJKu54dP6x9ssQRi8gf6BqF3XWPes3CdpPwONQ4aO0q0cXf2mG8vMUSip8KDyWv0IRrPsk97J0pg3sQQdbVcH8J5IGjjyzW0McR0Oi02c0eP0oXRM9CEJet21R11i5Y30lTntWjjpcmlUuVcOiVQ2v1iQbfCyepdV0dHnZ1fYwKrjuGhwwdXMI4Yeg5vlsE1ijTkiqMKyLF/70oFE03R3ozHEZyzsrFTug68vVYBOmim337Wr/985mTLg8ZyHdawiw6Yiw60K9TRbSdBuXu/oC99SEdpESgQVxzDoA7uFRiyC0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.243) smtp.rcpttodomain=gmail.com smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fpq9Ao6PpjM0ty//hCtZWpiiq9Tkp9mEzG7mYPoPFmU=;
 b=KMQhZDs6haVClmN9c1YsCVw7688cekwzX5aTtp241w4HkAA7psxDD33eO29ZDv6XNyQ95jptTcPdjtMtSJYun+QmzTbSL1tt2EQhHtoakH7IJzpA0Lys2UtV5J3A31ITr0z/iiDa36I/lYZAA2lFl8nAFv27Re6PWiyX9TtMgoA=
Received: from BN8PR07CA0014.namprd07.prod.outlook.com (2603:10b6:408:ac::27)
 by BYAPR07MB4534.namprd07.prod.outlook.com (2603:10b6:a02:c6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.15; Fri, 13 Dec
 2019 09:42:02 +0000
Received: from MW2NAM12FT010.eop-nam12.prod.protection.outlook.com
 (2a01:111:f400:fe5a::205) by BN8PR07CA0014.outlook.office365.com
 (2603:10b6:408:ac::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.16 via Frontend
 Transport; Fri, 13 Dec 2019 09:42:02 +0000
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.243 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.243; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.243) by
 MW2NAM12FT010.mail.protection.outlook.com (10.13.180.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16 via Frontend Transport; Fri, 13 Dec 2019 09:42:01 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id xBD9frkC079581
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 01:41:55 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Fri, 13 Dec 2019 10:41:52 +0100
Received: from lvlabc.cadence.com (10.165.128.101) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 13 Dec 2019 10:41:52 +0100
Received: from lvlabc.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlabc.cadence.com (8.14.4/8.14.4) with ESMTP id xBD9fqvV011360;
        Fri, 13 Dec 2019 09:41:52 GMT
From:   Milind Parab <mparab@cadence.com>
To:     <nicolas.nerre@microchip.com>, <andrew@lunn.ch>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        <rmk+kernel@armlinux.org.uk>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <a.fatoum@pengutronix.de>,
        <brad.mouring@ni.com>, <pthombar@cadence.com>,
        Milind Parab <mparab@cadence.com>
Subject: [PATCH v2 2/3] net: macb: add support for C45 MDIO read/write
Date:   Fri, 13 Dec 2019 09:41:51 +0000
Message-ID: <1576230111-11325-1-git-send-email-mparab@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1576230007-11181-1-git-send-email-mparab@cadence.com>
References: <1576230007-11181-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:64.207.220.243;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(376002)(39860400002)(36092001)(199004)(189003)(36906005)(426003)(2616005)(7416002)(5660300002)(70206006)(8936002)(2906002)(356004)(86362001)(7126003)(7696005)(316002)(70586007)(8676002)(478600001)(81156014)(54906003)(36756003)(81166006)(4326008)(26005)(110136005)(336012)(186003)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR07MB4534;H:wcmailrelayl01.cadence.com;FPR:;SPF:Pass;LANG:en;PTR:unused.mynethost.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07715488-977c-4b7a-4a50-08d77fb0b48f
X-MS-TrafficTypeDiagnostic: BYAPR07MB4534:
X-Microsoft-Antispam-PRVS: <BYAPR07MB45344CBA394AEAE5BBAE35B9D3540@BYAPR07MB4534.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 0250B840C1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sII+zwProaFjSJBmIfjlwdCLL5VZfXKAH7WkwzxrzRmM6o4g1EvFye+4BT0XEr2xl4wtiGVZQBVZszUWuBkQACfjg46RdMO5MdB232PJh766gcwcNmjIccZd3h/x75efqPpxPYUkVCabmZ89KJCVuJOQZmAMUAa9p6Snzb3bkj4IpexK3d17X59vWxdGw2o0u7D6g2/l6sJoiPDDOh1i72Ek6iUK9prgO/G0nft/xlVNfVAbIdyAVpmyIRsbPMdhx8zymUtUFdEFrAOuODHK44nUu/rd5F+IQ23Ef8qa1yxx8TXHNulITT7l1Vz2zl/ncziZKZ1fLPVgxN+ibbpvyIm4X5ez1D267ID2DPJ1JoempNJ0zpsxEf3MEDLaeu6dXcew3A3Pa9TKFuuyf2KGhBjhGU2pL9fcvXpy7n6pB0mYQKkKl5qSA3nqj9/49OhBIt/W2S59Q/isD0lss+VoJAvseO9/pd2g+cHWPjbful9T4EOIbUdtZNNDYvaJ0Sjc
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2019 09:42:01.5905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07715488-977c-4b7a-4a50-08d77fb0b48f
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.243];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB4534
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_02:2019-12-12,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=927
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130077
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
index 8c1812f39927..ced32d2a85e1 100644
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

