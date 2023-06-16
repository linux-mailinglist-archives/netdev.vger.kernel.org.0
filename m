Return-Path: <netdev+bounces-11454-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BCA3733294
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:54:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5000A1C20FC6
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F3819BBE;
	Fri, 16 Jun 2023 13:53:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807F919BBC
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:53:59 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2080.outbound.protection.outlook.com [40.107.6.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBDD30E1;
	Fri, 16 Jun 2023 06:53:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8yBCIrFeFfozkm7itoga40kpA5kSxQISDpyeh5KyOrNDGEqExXi/O6CnE+gzSgXScU+2iC83g8gpYHYL6cSKvBmQgIPSs1hWNdMzLJ5epsZjfyddT2UOyp865vU8tX38hCrN7tmjAO1napqIx7s7qh1dz214E+4Rhh/nsL4MEZRsvdwu71Drjsey2DrN1HMxak0Tgq7ONpXWOkVNV7n1lHZvU9ynlw43qPbXxRmKFo0d2ZGZOHq63FsFckUtgSOapdRye6tRhKhLcm5OWi2o/u1pAOq+7ipYC4mHALGSLPnne9CpfUn2kOCYa5Jo9NGrdSqYsEnrxKFiFWhggk4jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cKDDXI7iHZPHpsZrNbsFSU0Z5I8BG7ZUHE9W8dIte5E=;
 b=HvOEFa6cmMDxNMGpr9Zc7K250DGLKG5UZJHjzcpRO5pCUGL2JkDqzEAcxAAtJG2K5O7aDK2iCBaJBxeRgVt/wi++A7T22Pq7R0ihocEDJZbl1KyOVLB34/AQJxReyUUj3SqxFEZBL/Tj0KjPEohvSDxCvV79cUbToDD+lqA3eQStZGETG5Pao1FSYqPqBzZ6OjpbPrGhfCRi1+ut64Y/j1h8NRbgPUF81mbu0MMXgPjTs1aIFw2KY3H58N7n0CGe0Kk0Puq9sp5wEMlymvt/UX/azB97dx/vc+wbpUU22njMDP4x2ZprCEgCK/q9/W7L/myIfUgbSdpD20rCtLwVRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cKDDXI7iHZPHpsZrNbsFSU0Z5I8BG7ZUHE9W8dIte5E=;
 b=Sbl8pSd8CjEZZFUkuX2ct6SEN3xRmEltTc3uWX90LHVrlN/d5kSj61lUwaYRqSV/VLUK0e/DfYmnGs5vwD9W+gFrQsvJYab1ka0zjGsKMvrnqSpJt0r+ruZ0N1SIKi/6XYzSOx1ZL4yUzWE83bzMGqEntlO2b2FyhhTo4B2fXqk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9318.eurprd04.prod.outlook.com (2603:10a6:102:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 13:53:55 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 13:53:55 +0000
From: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	richardcochran@gmail.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sebastian.tobuschat@nxp.com,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>,
	stable@vger.kernel.org
Subject: [PATCH net-next v1 01/14] net: phy: nxp-c45-tja11xx: fix the PTP interrupt enablig/disabling
Date: Fri, 16 Jun 2023 16:53:10 +0300
Message-Id: <20230616135323.98215-2-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::47) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PA4PR04MB9318:EE_
X-MS-Office365-Filtering-Correlation-Id: 86830ac1-62d2-4f9f-8e98-08db6e711fc2
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SS2PbCXaJ6JIpIHfKSHvMIQagDu+k5GAx0/GJRALjr6l+NN383uumfPBahTQ7EuBIwOGjt6Pnrzyl1eIZXKSnakivQO8UG6QPO6NgCMV5/8VvC1qXO9JkyOvVtOmrwbEfvrGT3ak7oVpv0dwOMCwQ98a9oqCzBoWwLMq2H7ceyAPZv7obvsveXnBAxz35GGC0HZfSD4sIzdTSpbmubMNBqNRK9y0SZrG7n8KDNSDwealFAYyVAiFNeX8O/Kuf0tA7Tmm9zZkFXArqP8y1UhOclv5cQCB2NkQ0to3q4xQtjmKBBXgU9WNsDI+NewdCCFoIdvIXzPchA1zlxDuvns4fvwkDGOHXMXYeuVF47FLB+eqnQ73s4hFz8iLEyGh7vgcVzPfaNi5161TILd/22fBap0RzMrhkiJ/idlnGq5DXz26pGn3QBSe03t6544m+uuAum1gwu9JHGKzIpV58hhb2zyT1nngHg6W6CBJ5gfBgM4XxoRTtNAUSRROaME8Gotvb/Hw2fqcTHbbI5ydeziYiNLmOUYg8NiheVMrrfxYZOUKnOCfduTnYVvz0X/CJaPEUa2Od4FMIP3veFZeoht/n4oXhYUuRXCzIZvWsMIyj66sir8G5dotuvPAvAR5XXhI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(52116002)(86362001)(66556008)(66946007)(316002)(6486002)(8676002)(8936002)(6666004)(66476007)(4326008)(478600001)(7416002)(6512007)(5660300002)(26005)(83380400001)(6506007)(1076003)(2906002)(186003)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ICNGlSXTCC670Q3Mf9XdwFoa8eAmrJZEsfku6BQ+mpa/R05IKaps1H1pjW0z?=
 =?us-ascii?Q?eWtFEgyg/dLL9Z4x1abTpYY5Wtf+oVpYw2r2XrNrMPSlVT3Hl3iEoBGH41mY?=
 =?us-ascii?Q?FXxpumy6u+43DxlDw/eVp0OchwkSkI6oKCDlb9MUwX0az2s/k4YTTX6q8C/K?=
 =?us-ascii?Q?XPYl/Bwmp5CCrBf5tnFkmxxgA13FKfwuzkUjOyqzus5830fAOwNUa7Dt7nnY?=
 =?us-ascii?Q?gBdaOQznAxNDE6jh7DayKprqc8ehP0Hk+2Okr0M5SV62/fSR7+fwNC1HPbdl?=
 =?us-ascii?Q?k861ko/K2g/W/lY3rkErYV4j6PcqTJ57Bs5m7/haXhvttj2fDx33T03T99n9?=
 =?us-ascii?Q?+D94nXyTk4cGWFIWnxvWUfFQQZnERTQHAOxhyfnX7OqiXKmRBd8fkrMafE4r?=
 =?us-ascii?Q?3ldZWYaq9wg2wNM9tF8duC981ZxRFTmJ3INMnFo0ffNkUR1lEvQsPqLChhAy?=
 =?us-ascii?Q?Niv5v5P75d2dBiSKFYngZg+RXjN5A4aAqfKpxOuYrR9TJFPniXwFQTOCB1f3?=
 =?us-ascii?Q?1iczQCbw8K9xRQ0V08WYTJ/raZX6rlkofj7kOLDwxkHJigNuhau3hny8QpUP?=
 =?us-ascii?Q?fM8CTsFvxe3VQQSrA5jnJ6DlSxILhmch88oZi8y2WJa7sPWUuaqM9seXAhMb?=
 =?us-ascii?Q?pUuu1UjIM9t6jrwniiNRaDvDuxJXTK9un7IGLqYN3eeLGZfdT+IxiJYNDNE4?=
 =?us-ascii?Q?ysYtrojW0WS/NvlAFO6uQynC6Z2CmsI5rLZg6zXwkmUTqf7TeDd8KYZ7Md2U?=
 =?us-ascii?Q?DEsdAhneWNPirpoXocG9N11l+j7waBd7dP9fdDuiSEdNC73oHDNMeJSXtRW2?=
 =?us-ascii?Q?fCA3b5geru9LZklEbE965pqidR+eVTAaViO0HurMuMGB2yT9bi5PkEMdwmXg?=
 =?us-ascii?Q?f16jVSpozoUNR4aD50+Z0cmKsXudecTPIB9Zzc/qs3g40vDMVR30uiY+Li2t?=
 =?us-ascii?Q?fH33FqI/amw/fRcVuE73+Be95Wn9YAWGXc7DHOZA6w4zYKUKO+qd8m09ZfU5?=
 =?us-ascii?Q?EtksfODzo8Y1WJkPtjEoaotyeAk3WUijT4daWt1G9dfP7woeXqzls6lbmW3a?=
 =?us-ascii?Q?+WKaN9AjudmO+fc/MYuAyTVmMR9rkjVUiJh6AcXLdCf6WSFtoUYgWb40FHXZ?=
 =?us-ascii?Q?bEcZKZHoggbSmbJOVbVQU09RaKD9L81eLgXMVdRsp0CAcfCokH4VAdNBIJUx?=
 =?us-ascii?Q?dvZe/sTVXYxO1MBl6r9VMS5Wp+dwhZNG5IlfH1cyXlJm3ZgxynOYpbDkRC7n?=
 =?us-ascii?Q?2jYR367Gv8fIq7ECfvZiUAlNvbY5SYsq27u7GRq11HbbehUNG90YDcOJRZSg?=
 =?us-ascii?Q?0P6SRc6zX3BTAMsLW1Ri44eDzff5xHZZxAqJ5F3QdxwMG5dDYQZVj7Dl2EUn?=
 =?us-ascii?Q?2GjlH2CncZITliqdm1fq/IDTKy3lc7lRfLmkn1jwUy90vj7vcfiRAl+xw9LF?=
 =?us-ascii?Q?4JutLU8A4lhRdqarNwrAZZ4YAFyw4eJWWYIgcSBVEAhhLL4K7uiAsCqoCZ+N?=
 =?us-ascii?Q?qLVe+PWyQsQlbdAeVwjgi4qJhDHXpk8mGVDmUjwWve7JY4WQGuYLt8wJlsAj?=
 =?us-ascii?Q?Y2Ud51/ulFUHE+Xqz+6aY3reY8IkaHDEPrrbTR6DGPIkr0A8F4gbbcipxUz/?=
 =?us-ascii?Q?gg=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86830ac1-62d2-4f9f-8e98-08db6e711fc2
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:53:54.9411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yVfoYhVY7bnvArGjPkqM/CkEcM/Cu9qVhUd7vjKmANRS2RgZVt5ZlAvgr7V9k4uRl+XNN5MUG7suHVjQmxNNVm6O7d6kWMqYZvYYdQSLiqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

.config_intr() handles only the link event interrupt and should
disable/enable the PTP interrupt also.

It's safe to disable/enable the PTP irq even if the egress ts irq
is disabled. This interrupt, the PTP one, acts as a global switch for all
PTP irqs.

Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 029875a59ff8..7b213c3f4536 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -63,6 +63,9 @@
 #define VEND1_PORT_ABILITIES		0x8046
 #define PTP_ABILITY			BIT(3)
 
+#define VEND1_PORT_FUNC_IRQ_EN		0x807A
+#define PTP_IRQS			BIT(3)
+
 #define VEND1_PORT_INFRA_CONTROL	0xAC00
 #define PORT_INFRA_CONTROL_EN		BIT(14)
 
@@ -890,12 +893,20 @@ static int nxp_c45_start_op(struct phy_device *phydev)
 
 static int nxp_c45_config_intr(struct phy_device *phydev)
 {
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	/* The return value is ignored on purpose. It might be < 0.
+	 * 0x807A register is not present on SJA1110 PHYs.
+	 */
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+				 VEND1_PORT_FUNC_IRQ_EN, PTP_IRQS);
 		return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
 					VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
-	else
+	} else {
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+				   VEND1_PORT_FUNC_IRQ_EN, PTP_IRQS);
 		return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
 					  VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
+	}
 }
 
 static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
-- 
2.34.1


