Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFDF2A857C
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 18:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731682AbgKER7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 12:59:15 -0500
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:22950 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726214AbgKER7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 12:59:15 -0500
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A5Hr4fJ026971;
        Thu, 5 Nov 2020 09:58:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=sizQm/QGuX9QkD4HAsSprjdaOtRlTnI8F8JM85QKkgY=;
 b=oVjCt3dIAR97WctP5cs5XHNi4lLFAiIT8YccWEmlYNOiPUy4oZIhO8X8+nAXFeH4wgma
 62hPgca2UT6NdKAMdlRenOS67dDqX082GMoWYydI9tEMs0+3qmhUQtl04w6w8uD1AHRu
 cdVLgYK8B9K2a8/8Wu2IAm4iKdGWdk2LZKXo6uNJvuj/lz0t+PXXXKkBqotD0GMqL+bZ
 LAspCFxziNdlb8YRkRbzwBSMXakL7hNQgYv2TAODkr0QNIGQqEt9w/889KIoxQnHY8o+
 JDnJnIYMFqfUJi/f+QLvOP1f4VXo6gi5dYXSnlq2j75SOJKiX/OWCCeJGDi1FuSCeU1R Xg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0a-0014ca01.pphosted.com with ESMTP id 34h4fvpak5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 09:58:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jo/c9UlvXV6k2rjSSO8K6EwN4QM8z1ERPH1MMynNREMwOEI01XPsA2eLMXkteq77aXpVBqi5lax/hfj9qR722ba4fs1Z8htvvYhNoqFkDq0hOymFQ7UtWHBT/GgVqDuJ8myr7L/YzeZgxYD1u0gAQdpA7WtLg749h34mGYsiBreLLi1TQH6bDjAFp/yUccT86I05emgF3WEpmRpWkZ5yg32GsnhW+zX8+nIywZ3mtgj3aIkKZO6XrmuibNuiyFIf0rVUYVBMWBEeJbciGnvhndMSM+CXsCnNDbYDIxr6pNjWaiVBwOxp6AdwjwPIAgtrHltvXO7aFGE9s9aL9U5Dxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sizQm/QGuX9QkD4HAsSprjdaOtRlTnI8F8JM85QKkgY=;
 b=WzNZAgt3Sh4Z9tUlt5IRNG3l78+cdn6rS619UNrlB6RKNqcVyt3jBLI3vq14Ak9aLtO1WaMfr0VkTv7Ri4DpWsHna3IrSCv4nxxlWfJ1K+5v0Px+/3+9CDtr0VXoyQDLN8b8piK37Cz3JWMONng79yGfv5Lh0G/YlvELT3VXRgc76Kxl0U9XMJxKr9i3unqT3Kl/OwopJa0lF5jRM5uoq+W5SGteiL37hyggcIr+ISqiLh+Teanx+VM2t2Q6jv2gRe45r1DFs5zaZ3+JrAyGHt+cPbBYbvBD1YbQj761qaWR0D8ZKonL/KYoM03r62126d/+2tmk8b6DsdTO118yjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.147) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sizQm/QGuX9QkD4HAsSprjdaOtRlTnI8F8JM85QKkgY=;
 b=lgHNX5D6ETqOxkmFgl3TqQeE5a0x9zIvNJCTofHloQx1FyW55g9rsbc7vG1EUzZg83syY40nuKuN10xOJMVVsegaskIXeECKbrkfxlqQkP7iQ4CNsSAZMfr+bdgS/EBjmva+FgMSJY/eFCVCPM3yVhYcJAbbJQ2QkDEtFJX17G0=
Received: from DM5PR15CA0068.namprd15.prod.outlook.com (2603:10b6:3:ae::30) by
 MN2PR07MB6975.namprd07.prod.outlook.com (2603:10b6:208:1ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Thu, 5 Nov
 2020 17:58:47 +0000
Received: from DM6NAM12FT046.eop-nam12.prod.protection.outlook.com
 (2603:10b6:3:ae:cafe::e2) by DM5PR15CA0068.outlook.office365.com
 (2603:10b6:3:ae::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend
 Transport; Thu, 5 Nov 2020 17:58:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.147)
 smtp.mailfrom=cadence.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.147 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.147; helo=sjmaillnx1.cadence.com;
Received: from sjmaillnx1.cadence.com (158.140.1.147) by
 DM6NAM12FT046.mail.protection.outlook.com (10.13.178.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.7 via Frontend Transport; Thu, 5 Nov 2020 17:58:46 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 0A5HwoNR007640
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Thu, 5 Nov 2020 09:58:51 -0800
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Thu, 5 Nov 2020 18:58:40 +0100
Received: from vleu-orange.cadence.com (10.160.88.83) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 5 Nov 2020 18:58:40 +0100
Received: from vleu-orange.cadence.com (localhost.localdomain [127.0.0.1])
        by vleu-orange.cadence.com (8.14.4/8.14.4) with ESMTP id 0A5Hwe4i002525;
        Thu, 5 Nov 2020 18:58:40 +0100
Received: (from pthombar@localhost)
        by vleu-orange.cadence.com (8.14.4/8.14.4/Submit) id 0A5HwZBK002524;
        Thu, 5 Nov 2020 18:58:36 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <nicolas.ferre@microchip.com>, <kuba@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
CC:     <Claudiu.Beznea@microchip.com>, <Santiago.Esteban@microchip.com>,
        <andrew@lunn.ch>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <harini.katakam@xilinx.com>, <michal.simek@xilinx.com>,
        Parshuram Thombare <pthombar@cadence.com>
Subject: [RESEND PATCH] net: macb: fix NULL dereference due to no pcs_config method
Date:   Thu, 5 Nov 2020 18:58:33 +0100
Message-ID: <1604599113-2488-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74bd3063-014e-4dfa-3bf9-08d881b47132
X-MS-TrafficTypeDiagnostic: MN2PR07MB6975:
X-Microsoft-Antispam-PRVS: <MN2PR07MB6975881D2DD7D35741A1BE32C1EE0@MN2PR07MB6975.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GUaC9gWY8/w9Jn4Ag+UQWJQbOY+PjJQGsolM2308JdxTCjrcW8YMUIOb4Uz9LUiDHovbegYbyq8shOQGAl33AvkfeVERbw5VJ9mUdMTNWeQ814O7sMS6+/cc+UAiE+vFyZmEPyl7/OZ2FBD4LZhJXasqy/ihgdMH5y6s/29FcNfV8b6DG1BPnPoIMszf9+9UlEgWrnpw7zcqUJR2/1p65ikCfVLVXQqmzr7eFrI+j9XhPXnXtm7d55TlT49JreW7HDCyIVwV9eiMR40k0Z0Ymh4fQYtm7MSPSQkBCsSrrQi5e5q0qcVcEEobrLY0mh7JFreDS7GX9e1rBVMRNKEwzNlZKuisJfQx8UUPODZB8wwl3V8EvPfGJT0U2ZDT91D4dB43y5/RZvM54hZjePRmowj2/3hh21S+iLYkiG3Sfnpt618CHB3XcwSgxo+ZJ2Qaym0O7NcQjue7nALcTnVbUdjVqdLRvcO78WTvkqv9XQu5CSTcmCHUTskx1SePj9+q
X-Forefront-Antispam-Report: CIP:158.140.1.147;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx1.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(36092001)(46966005)(2616005)(8936002)(478600001)(70586007)(82740400003)(47076004)(5660300002)(86362001)(42186006)(316002)(356005)(7636003)(107886003)(70206006)(186003)(26005)(110136005)(54906003)(966005)(36756003)(7416002)(6666004)(336012)(426003)(36906005)(83380400001)(2906002)(8676002)(4326008)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2020 17:58:46.5139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74bd3063-014e-4dfa-3bf9-08d881b47132
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.147];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM12FT046.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR07MB6975
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_11:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 phishscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 impostorscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes NULL pointer dereference due to NULL pcs_config
in pcs_ops.

Reported-by: Nicolas Ferre <Nicolas.Ferre@microchip.com>
Link: https://lore.kernel.org/netdev/2db854c7-9ffb-328a-f346-f68982723d29@microchip.com/
Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index b7bc160..130a5af 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -633,6 +633,15 @@ static void macb_pcs_an_restart(struct phylink_pcs *pcs)
 	/* Not supported */
 }
 
+static int macb_pcs_config(struct phylink_pcs *pcs,
+			   unsigned int mode,
+			   phy_interface_t interface,
+			   const unsigned long *advertising,
+			   bool permit_pause_to_mac)
+{
+	return 0;
+}
+
 static const struct phylink_pcs_ops macb_phylink_usx_pcs_ops = {
 	.pcs_get_state = macb_usx_pcs_get_state,
 	.pcs_config = macb_usx_pcs_config,
@@ -642,6 +651,7 @@ static const struct phylink_pcs_ops macb_phylink_usx_pcs_ops = {
 static const struct phylink_pcs_ops macb_phylink_pcs_ops = {
 	.pcs_get_state = macb_pcs_get_state,
 	.pcs_an_restart = macb_pcs_an_restart,
+	.pcs_config = macb_pcs_config,
 };
 
 static void macb_mac_config(struct phylink_config *config, unsigned int mode,
@@ -776,10 +786,13 @@ static int macb_mac_prepare(struct phylink_config *config, unsigned int mode,
 
 	if (interface == PHY_INTERFACE_MODE_10GBASER)
 		bp->phylink_pcs.ops = &macb_phylink_usx_pcs_ops;
-	else
+	else if (interface == PHY_INTERFACE_MODE_SGMII)
 		bp->phylink_pcs.ops = &macb_phylink_pcs_ops;
+	else
+		bp->phylink_pcs.ops = NULL;
 
-	phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
+	if (bp->phylink_pcs.ops)
+		phylink_set_pcs(bp->phylink, &bp->phylink_pcs);
 
 	return 0;
 }
-- 
2.7.4

