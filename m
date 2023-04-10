Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09706DC6E4
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 14:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjDJMtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 08:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDJMti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 08:49:38 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2049.outbound.protection.outlook.com [40.107.7.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8552738;
        Mon, 10 Apr 2023 05:49:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8pSSoo52lbWL2JDUznPwd5c+Fppe9zWuzU3U/uP4YFSJvpwiRyQe3h0dge9RtF0H2oN6lkHlPLlno17I9hRNqOL+sh/+BUmfb07rxDpXs2K92e2wPKcU7H+HSCwRhqph9QeofV4xCSO7kxSgTt34Ue5x4ueWjiEYdBVdTBrjXSEG61kM0nWX9egESQEOz2itejvXgEsfgsv60w7l55+j9nRZUxqYrFO/Ux3hlfUVeTU6zW74QZmEI0msku42thr58vtEfXX4aSj1mqCg0slVwf4tF5tM3NIhQT0akD8EeITjJs8P9R4l2LObXxIaGXsaJXbWaWf9T/DRCRgZ2ujhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qoCUG7aIxDx9ZZ83tfYQ5fznWGb5QirS6EsyVHQgDM=;
 b=LI6PlDzBx92aRybU8Y1nzHwvHyYSzIIb5ewyLRWT0UgP6VyALh+RUqSXaq25XywwJRYNw9UpM89yAtV7+HhuwCUejqYy0ZiYHY6yP0hh6cY1ej1hbZq+nKXS3nmMSeuzTxYjdKcQOoMoRfcPlqFWy2GU18xx7xzyzmhYYljG/KR1Zhpeg8XU8OgS4trSkTr4tAGTqWgnNJCDyVJbKrFTvjXLoTf7uVij4WqOzIv+bHHLeIbpKytbY/rfu6mnh69wu52UMW5qOtMsU0ShqvqcOAW54+Jv0Wjdk0fCwjpm9FJbYxJHUuuJhqeusOJVRbC7DGvWS1UQPy2fbwoe6qJLmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qoCUG7aIxDx9ZZ83tfYQ5fznWGb5QirS6EsyVHQgDM=;
 b=GMji5LiSDz78VVlmGNik4syuHehM2Sm7iAWh4GU4ex/EGL+ztte/ZBOfEIwqYY42XIoH+phe2/IakdKPIp+RCp294HBI2K3hDf8FzNp8QqRkLHsjqXUpljj+4NNX/pGm/Z/3zpXjGjHkY+FOjccQcI4FAk3B7xdm0PVTnaB0R1Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AS8PR04MB8435.eurprd04.prod.outlook.com (2603:10a6:20b:346::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Mon, 10 Apr
 2023 12:49:34 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::9701:b3b3:e698:e733%7]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 12:49:33 +0000
From:   "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        stable@vger.kernel.org
Subject: [PATCH net] net: phy: nxp-c45-tja11xx: fix the PTP interrupt enabling/disabling
Date:   Mon, 10 Apr 2023 15:48:56 +0300
Message-Id: <20230410124856.287753-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0062.eurprd03.prod.outlook.com
 (2603:10a6:207:5::20) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|AS8PR04MB8435:EE_
X-MS-Office365-Filtering-Correlation-Id: e41b0721-e529-43aa-2b30-08db39c208c5
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AoS8oAcB67bT/gkXppYjfK0NQhEg954fxdezMgtqvg5md4R519LZvsIQB+bffXR2E05onRmeiGlLOLoA5n4lg4eDoehsKDmJ2Gl/p2qlB0WQUMHSTLWHDe9GtMWhuq5jKfHvfMWkV+DCSVM/tqeZllaSffZdovijZ3chDUEiQguwp9u74izh/9h+qYyIWoGdm9w+/0cYcN6BOWoXc79vS3++DaafS4orfaKW1P4LmtFsnVF53IvInC4TB/cNgAnCi0w9Iz5Jg2+q0vS3+weOBsNISx8puVVDjjM5mNLGVjIMpNSyEsdnzqF0n9qLpfC1EWB0upEWFru10fuR2o2MAazd8dKXkSiP+Ln//VX2w58PgM5mLR374kyjwM6XaS5FlA2eRKsfTWkwkk1VxB7fvkQsijV9P4JdwOyl+nVLOg9+H/9GT1oo7CnX8tTWmYlDXTbnjuBoId/ZJ23GFmAfTOiauL/JfMSh5c3H37GuVdprPtSBA0na+//GLIIX8ApoRa6uqbB1pp/rjpwgW4RHP4aR4kiHkOEwltYso0jXnfbu89dKlTrF1KGaplIpKoU5foCidEEkXIcogNIK9e0z3qnKrybIopuiUBgsXjieVJsHc6Yn6ufQJKnQ8Fo8vB5t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199021)(52116002)(478600001)(86362001)(83380400001)(38350700002)(38100700002)(2616005)(6486002)(6666004)(2906002)(7416002)(316002)(186003)(6512007)(6506007)(1076003)(26005)(66476007)(8676002)(66556008)(8936002)(5660300002)(41300700001)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sqrlGLr+HReyJ1PS4Ia8ClparUz0inc1AaPiPEnh9F6JGzOwV6G0+3yMBhD4?=
 =?us-ascii?Q?khDeMVDnZ/3WMwZZfIbO4uN5PphU1FcNRM9pYe1R3x5XjhRX9+eXHO8i/gXB?=
 =?us-ascii?Q?TjELTBdnOhmIe2WQRwrsCB0o/Gu/vHIQnZYpT46+PRlJE47/Zs2uoTOZ7nif?=
 =?us-ascii?Q?wgMI1Y7pCnGiL2NWezsdAk/hnPzKrtjBDgOKQC3HAfzzKx5XQMhPcsldbobU?=
 =?us-ascii?Q?oJpIriQGJrP6y6gD1iwk8cQ/qfqAhe/EgIHaL3576lnaCLKWfyFp8VQXS44X?=
 =?us-ascii?Q?e4mJQ5XAMd0QobrLUzOrSH2EokHy5T3ah2pHxVARjFr7AemZEivfVVivQAPq?=
 =?us-ascii?Q?DrlK25OrqFS7NJDbyvdcJQxu0blA01tyNTNvITUlA5BpN5KEyEjeeyyL/6uJ?=
 =?us-ascii?Q?I0KlUMkd2tTZhKN++f7hRT6ihDpmUcFNjgamOMO4pbXjNPpFZsoV4f2nOHeA?=
 =?us-ascii?Q?lGwp1ukB3NrKZL0x6Y43CjwBAm0qNSrNmKdHz0+LmCLYNPuVm79j9VkZdiVy?=
 =?us-ascii?Q?lFoWWrSEWdkrX4I+6T0j/+soewH3kRNFLoMVeKLSSjTpzLYrRlTEaHKXJgoz?=
 =?us-ascii?Q?5NYVcGcsv2aljG/q4ng65usJ1Jq+8/cpXqdY+1JkKvuxh2UJjFiRrJUeCHHN?=
 =?us-ascii?Q?e91QDNFBv9somolZ2QNMguhSq0hBkinll7Rghx8mrByJIBxzRNdvrmcCTRus?=
 =?us-ascii?Q?5Wsh/NL3/e16z0UHosK58vhu3lqOlbc2XbUr3Rw0M7Hpd1qFdqjzQbKhqye2?=
 =?us-ascii?Q?x+KVHc0xf49c5hFs+0U26ayMWWHS7OsRvXvEx061x/0OgWLjPdn+eQtjPGCm?=
 =?us-ascii?Q?i9epRMNWv/Oc2xfZ3XJwiXXtJUZENPJE4Fci6SxZlB6n94DlQiUBxx/4w73K?=
 =?us-ascii?Q?osmwc6ies2xC1X5z96LkSthZxPf4sN996FfqH8YLnmDfRBfKNPbyC2l1b6VD?=
 =?us-ascii?Q?z0wsjpCvbnOwmE0zBPFx3USd8Z4k8diZy6QaYIgGhqoVDAngrTtfSl+7wclA?=
 =?us-ascii?Q?WOwbzx5RAUD5KPKKq0QRytcrdv9cgQ4CnMzpr3xJYvholDGz+zSe4mHVGSXk?=
 =?us-ascii?Q?hIsdwpVH1jfmHTsDmp7TDCVFSTYzmNOGv/Y2oWudiizbwM8Fn80AyuVsfJXc?=
 =?us-ascii?Q?oilT8Q+BlfEP+Uf/YvY7XOsl+xXE+ZhHJJjAq7by3nSAuhBCI9jhAVbiuxAC?=
 =?us-ascii?Q?nvys/rVeEwQnC+k+0dbzoSXq2yI7d82YduQsE8honXUdt541TOUP+e6rsKOo?=
 =?us-ascii?Q?rJi5XZKwA5vKzROQxwPjV5OjGIbJUkSgY3moXaUAtVz+E7eIkba3ao/iMoUf?=
 =?us-ascii?Q?DE0nxlNWMgLaqwp6+Fm+e/SxukEc/2j/9VRVhqaL3LPAvi+/7kifKTrXOsMV?=
 =?us-ascii?Q?v83Dp8ELta51uFf2s5j9rs0+JI8pdZxdzIB8dB19H9im4m8b24RIsxvIVQDI?=
 =?us-ascii?Q?dlVmHjB2JA/bYVn528MPvWfWxzhQPYBQsLOdg/uMWgnai8Iod0Kwm+l0Y5TH?=
 =?us-ascii?Q?qGMj7zwQHJ0wAy3XzrGudhqwZn2eousA/6XAK399oUtu82xh8iijP2TULUAP?=
 =?us-ascii?Q?PxZRqYT5aRZjOqnY5RWwTkkGfNcE1fN5eid2dNZizznGMCGXSR+nw3eTMO9S?=
 =?us-ascii?Q?pA=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e41b0721-e529-43aa-2b30-08db39c208c5
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 12:49:33.8631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2zzjb+CK2t1dyB8MoBbcECHEp3Cn3AQhBTEuwpmNST4GEKQ33P3249asHqrPaMgEjVl+c9q8iJwuMSEi6y9GRV5GahmaOTK0La9g4e/kJeI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8435
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

.config_intr() handles only the link event interrupt and should also
disable/enable the PTP interrupt.

Even if the PTP irqs bit is toggled unconditionally, it is safe. This
interrupt acts as a global switch for all PTP irqs. By default, this bit
is set.

Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 5813b07242ce..4d7f4cb05f89 100644
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
 
@@ -890,12 +893,15 @@ static int nxp_c45_start_op(struct phy_device *phydev)
 
 static int nxp_c45_config_intr(struct phy_device *phydev)
 {
-	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, PTP_IRQS, PTP_IRQS);
 		return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
 					VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
-	else
+	} else {
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, PTP_IRQS, PTP_IRQS);
 		return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
 					  VEND1_PHY_IRQ_EN, PHY_IRQ_LINK_EVENT);
+	}
 }
 
 static irqreturn_t nxp_c45_handle_interrupt(struct phy_device *phydev)
-- 
2.34.1

