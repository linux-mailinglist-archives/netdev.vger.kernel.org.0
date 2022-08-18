Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96A959887E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344491AbiHRQRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344493AbiHRQRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:19 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70070.outbound.protection.outlook.com [40.107.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CCCBD0A6;
        Thu, 18 Aug 2022 09:17:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IiUFZrlVFvyAbmOzJA/SqFk7eNbyzzf+ff8PFPST6Ti2FuY8GqIB82SIWO3XBekUapiGbhA6e36Sv2QYIu+KjWmnG42ESn/1CCqx/Tdu6evxVcFGmEJBeSPtyTZdZ6z0RGRdAimXoZMbq10rqp4NvNAxRv0VP3IAty/RgLB7Xci4vNCB2wFNq6ujDRxzkr99i18voeAy6E8CGPaXHMAp105145b//Scs/Y0ZEjUotlCHttS0l5yMtVsTt9PcEQ0kOGOmuVf2IkZJNQCBSNiEjpb3KZ6P9yvOBrOKdwONqBK7Uby609vvqLtykiIY9gU3yc+KejklXPH+XSlFhfo1kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8om8eH2QedUZdijrrSK77S2858Mj/v8BVIBqUQfR/qc=;
 b=LsAYFqv3rxCD4aWy4tEDhL52LFFBh7PQfIeHv+lB6QMB1IsQmxiCeGKJ/p+dVjzHCDJVbSy8S414O6msiPlsNhqwK00V4lbvCR23ZTeh34WSLFU0rZ+Ysln5mnLPpOp46yjY8BGr7IIBhIRatL0j9u2n7fPMUJNTyMtQxLY8WO1pDJRgt9T4+bCCkdxaDsbw3Mxb7twQ24F7SgDF2Pyn7phwSF1kWfCXG7o7k0+Jp6AodBo33iIzqOUrkUpRCo/SL8v3piQA9hPsyCPU9G1/Aah8ddxKC0x7YV+ce6kbOAz0CtnZpK46Z0tsCBZ113G3dSxLiT/aqX2InNbMxa1ycw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8om8eH2QedUZdijrrSK77S2858Mj/v8BVIBqUQfR/qc=;
 b=iCaIRFGUiiOuxSHjhSxWyKjljnYcdX2OQ0fC7zzCsiP3eKPNHrxFbtyfQBu4XC7EmDvvvCx25yPUP2XIrTifkLI5ge/HGh81CkW1KbG/nwzDixwgZSdmGSZHjciSdAstJPy3inSzzT8PtjVQDVclJtGEFmveGTZVFzKIysVksw3y7zvZfbdomRLQD6E4lIFFEnbU+XFVd8zMCurHraN9d5oF97qQO037nMNHrqiY8GnKiCuYZ/an6x33F20VzV0IF7xJy3H9MIhZMm5pYBgWNn1g1ZVAaixCXjceb/GCxpd2ohGnFbnJmMdTDyN4dW5KzrzlX+Min/7HSuSDcV9FVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:13 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:13 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RESEND PATCH net-next v4 04/25] net: fman: Store en/disable in mac_device instead of mac_priv_s
Date:   Thu, 18 Aug 2022 12:16:28 -0400
Message-Id: <20220818161649.2058728-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9f93b7d-72d9-41f0-c488-08da81351c2f
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bsr1iB/Qk7yIfKhCiITbAwoAlq1ORmk8l0ySSCd3T0hfOoo8Ist+pcB+6b5Jvgje/sCriYu/JM2MP449p4tO63pj353/GcKBrRTPKsdVhcGs8KZPwvICUQ89WHfLJ78tgqyQ2oIiBgBzHsOgvKfdkYxscD67/a9b+nijzyuEf2VkjFf6pIkmd33spQ4zF1OYQrBkzm86nOeimSS++s8Apn1LVlzzX22cFZtXZ7ZE9kJQQV4KmbA+oHOHNloaB6qydmi6xPN6qdm6HNZEsTRhHVOs9rakH4rr6XW8Vk+BRqDKWOZ+AC/Ycw/iX6joOtP4x66samqP2omq//DoS8Dfp4SAZIW7L7KwHi3PcmJSB+QTW0UCG6TzYB5eU22N2rPj2DmGOVOkPwJw18pnMYIBACwAQgI6FmXhWrw4529f1jxba7ELyZbot9ZUVoyDtYaHOAZCDJGUhejEbQD4/D9hVzttqE1YOOQSqSLYa0PJ+deP7EIqj+JXQp3P9ZYoF6VK0RNr7g9ABcXzq74sStBkf1qRU3TxDD0obwu8pgWGPyPk3/qgiHvV/Z+OpWDGm6fbkoEfZmI8Je5ly9lV7HN97uDVtYnTSQJkVTq/k3aS6ugVkiZRo97IlUjCtgxjjRR25OxamCMU5odlYXfZvOOaGW4XJjiW2RIndcXtrs6BOz7F82GoRdFjtUBK8Ze3ymF8pLOJM7MMc0uLKQjyKFVuvX/+LLgrwqxFUaO4ieLhsfQcYDrjUWzSH6Vwmpn2P3yf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(86362001)(41300700001)(6486002)(316002)(107886003)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?97n/tCi9j+yTcArto9/SHEon+d2UxRrjgNi8Li8sr6u/AmEHVrr5l/y8wHRX?=
 =?us-ascii?Q?TgTZ84BrTnpkg7UMJniP/Q+dGoaH6wo7QOmaoN+p5r4fA8Eb4DQyJa2f9d8V?=
 =?us-ascii?Q?A5uNHtp7nAngO3xzvZ+bL077dEdYEcdaHO+7XVnInjWna82V6R72ShTAku6I?=
 =?us-ascii?Q?b1jKvOXjbwU5MJTrKx5e3pi5R4RhPNa6W0k5RXaYEtoSe15uXa9hLO5AdG/o?=
 =?us-ascii?Q?rMVImXJArE1Kbfn7rpz4KZWfAMVmHXhkM3l8IE3MlFWbrkEWfBQi5j826Vdx?=
 =?us-ascii?Q?FGRvc/k9fnobCngN/f73sLZzsytX3zAIJkB5U0jKvp6NLOnyRyGB/XajDdtC?=
 =?us-ascii?Q?eRCAO3OKG2qarA8coZErLJzi6lNHqGhE+/YVYJkesmlrT+4ZiTQpxQfEqQcX?=
 =?us-ascii?Q?lScybQDKxBlZT0cTQZMRvwbraJ4uR9T+aPESuqf4w27pFn/1A1k5fNjmVxS3?=
 =?us-ascii?Q?dn/l6hrb4JtrBTIfHFredo6X+cxTYg832yeOWr8SGwiKh7Kb0SrMD5Rr+vCj?=
 =?us-ascii?Q?NEjCNYzPA1sG5RuK+f9LFhPJKBLMs5ZzyMgajAkvbSKQKU3XRg3+FF01li5N?=
 =?us-ascii?Q?9CcKY4q2Cfh3fKRFHYgqAllGDwqvg+/jZQUODS620NgTo1PWX62riKho7YPc?=
 =?us-ascii?Q?x4BPOvPsCPBMQxYJjvNKmi70+RLFHwPWDGxSi0xINslvt5VvY8nVYSv3I3MS?=
 =?us-ascii?Q?q3b84yWkCSUWFM9v6WJ2BA2cPQjS922lKEWUUG3xtG800xIGsz5om+V9GOfY?=
 =?us-ascii?Q?V1yYAbI7ZKWbpc9rtZxICa9y/+K2oiUuwE0dtQHBmE0mD5vm6RisQ12Wpoj5?=
 =?us-ascii?Q?xgLeHZCHXMu7WwbTghViZ51kdJzF6z4GpDoXWqW0A2/7EnVpsRV2ul3eq1ZR?=
 =?us-ascii?Q?bSJEa4f/VNHQ/eQxMNK7Hy66rEvYRTyInwydQDCSzNtuYmHwPXVpxW3BGeii?=
 =?us-ascii?Q?suMTJe0MYxzdXpJ4irQFrjVpr9tfCLN6fnTXZj4Xv36dsNrPyJuyzglQZFej?=
 =?us-ascii?Q?46hZWaDJ0y6DUx4j6VNXdJWhiinBzN8oKN1Twob0JZpNlL8h46xjmR2OW64P?=
 =?us-ascii?Q?RV1oQAgOKRZuwXuhlLiIQuaJOST3QC8S25i57GXCRGK7C65nrtgep9+GSV02?=
 =?us-ascii?Q?9tmcWEWIsE6hUMKLXA1WKFBHgnKlx3IFSIvmY9rzukrmD8UlEof31K8ug/PG?=
 =?us-ascii?Q?FPqi0Di9tU++yYbXQY3DBNjYWUiIfnmo9Vjvp9qNv6lzQTzc8dxQsI+k5ogH?=
 =?us-ascii?Q?88lw0IJi+DlTNkOdnU5jveeeEeukl6iJo2zVXIRZJnwtX/d32nzeiGgfL0Oj?=
 =?us-ascii?Q?K2C93yDqSkAum6zMu7Ul89SYWyXQjg5aUvfT1CJo2LEwvS0FBtH46HVMkezb?=
 =?us-ascii?Q?+cKH7j935ivzQQa9TMJXmN9NEq3vJGBzDzvGcgvxWIF7Z1xGqfiao0hhc/vq?=
 =?us-ascii?Q?V+d1jY4dLBjQykKclo1tzX8JSKfDxH2VAkmlUkf6zzQYIhI+Q0yJJd1OXFJs?=
 =?us-ascii?Q?YoeP8O7ecp45A1Wdu+ixpB0XHXf2jo/4h4ijUdVFm1KaHZFKZy2zdU+hZT2O?=
 =?us-ascii?Q?+KqQa/PMCFyN7kX3C58xv0pVop5FR/izUX8LPmGfUCH0GZxe0G+ApnRBEsnJ?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f93b7d-72d9-41f0-c488-08da81351c2f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:13.4519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X6P4KuB8LjBa4RamrvYCpYyKX2fy/t/X4xYJQpetJf50TfVk3QtoJKOf/4xo7HDrhiMUN6Z0NnKcVwpzBx+MDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0302MB3211
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All macs use the same start/stop functions. The actual mac-specific code
lives in enable/disable. Move these functions to an appropriate struct,
and inline the phy enable/disable calls to the caller of start/stop.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
Tested-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 11 +++--
 drivers/net/ethernet/freescale/fman/mac.c     | 44 +++----------------
 drivers/net/ethernet/freescale/fman/mac.h     |  4 +-
 3 files changed, 15 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 45634579adb6..a548598b2e2d 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -288,9 +288,11 @@ static int dpaa_stop(struct net_device *net_dev)
 	 */
 	msleep(200);
 
-	err = mac_dev->stop(mac_dev);
+	if (mac_dev->phy_dev)
+		phy_stop(mac_dev->phy_dev);
+	err = mac_dev->disable(mac_dev->fman_mac);
 	if (err < 0)
-		netif_err(priv, ifdown, net_dev, "mac_dev->stop() = %d\n",
+		netif_err(priv, ifdown, net_dev, "mac_dev->disable() = %d\n",
 			  err);
 
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
@@ -2942,11 +2944,12 @@ static int dpaa_open(struct net_device *net_dev)
 			goto mac_start_failed;
 	}
 
-	err = priv->mac_dev->start(mac_dev);
+	err = priv->mac_dev->enable(mac_dev->fman_mac);
 	if (err < 0) {
-		netif_err(priv, ifup, net_dev, "mac_dev->start() = %d\n", err);
+		netif_err(priv, ifup, net_dev, "mac_dev->enable() = %d\n", err);
 		goto mac_start_failed;
 	}
+	phy_start(priv->mac_dev->phy_dev);
 
 	netif_tx_start_all_queues(net_dev);
 
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index a8d521760ffc..6a4eaca83700 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -39,9 +39,6 @@ struct mac_priv_s {
 	struct fixed_phy_status		*fixed_link;
 	u16				speed;
 	u16				max_speed;
-
-	int (*enable)(struct fman_mac *mac_dev);
-	int (*disable)(struct fman_mac *mac_dev);
 };
 
 struct mac_address {
@@ -241,29 +238,6 @@ static int memac_initialization(struct mac_device *mac_dev)
 	return err;
 }
 
-static int start(struct mac_device *mac_dev)
-{
-	int	 err;
-	struct phy_device *phy_dev = mac_dev->phy_dev;
-	struct mac_priv_s *priv = mac_dev->priv;
-
-	err = priv->enable(mac_dev->fman_mac);
-	if (!err && phy_dev)
-		phy_start(phy_dev);
-
-	return err;
-}
-
-static int stop(struct mac_device *mac_dev)
-{
-	struct mac_priv_s *priv = mac_dev->priv;
-
-	if (mac_dev->phy_dev)
-		phy_stop(mac_dev->phy_dev);
-
-	return priv->disable(mac_dev->fman_mac);
-}
-
 static int set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
 {
 	struct mac_priv_s	*priv;
@@ -454,11 +428,9 @@ static void setup_dtsec(struct mac_device *mac_dev)
 	mac_dev->set_allmulti		= dtsec_set_allmulti;
 	mac_dev->set_tstamp		= dtsec_set_tstamp;
 	mac_dev->set_multi		= set_multi;
-	mac_dev->start			= start;
-	mac_dev->stop			= stop;
 	mac_dev->adjust_link            = adjust_link_dtsec;
-	mac_dev->priv->enable		= dtsec_enable;
-	mac_dev->priv->disable		= dtsec_disable;
+	mac_dev->enable			= dtsec_enable;
+	mac_dev->disable		= dtsec_disable;
 }
 
 static void setup_tgec(struct mac_device *mac_dev)
@@ -474,11 +446,9 @@ static void setup_tgec(struct mac_device *mac_dev)
 	mac_dev->set_allmulti		= tgec_set_allmulti;
 	mac_dev->set_tstamp		= tgec_set_tstamp;
 	mac_dev->set_multi		= set_multi;
-	mac_dev->start			= start;
-	mac_dev->stop			= stop;
 	mac_dev->adjust_link            = adjust_link_void;
-	mac_dev->priv->enable		= tgec_enable;
-	mac_dev->priv->disable		= tgec_disable;
+	mac_dev->enable			= tgec_enable;
+	mac_dev->disable		= tgec_disable;
 }
 
 static void setup_memac(struct mac_device *mac_dev)
@@ -494,11 +464,9 @@ static void setup_memac(struct mac_device *mac_dev)
 	mac_dev->set_allmulti		= memac_set_allmulti;
 	mac_dev->set_tstamp		= memac_set_tstamp;
 	mac_dev->set_multi		= set_multi;
-	mac_dev->start			= start;
-	mac_dev->stop			= stop;
 	mac_dev->adjust_link            = adjust_link_memac;
-	mac_dev->priv->enable		= memac_enable;
-	mac_dev->priv->disable		= memac_disable;
+	mac_dev->enable			= memac_enable;
+	mac_dev->disable		= memac_disable;
 }
 
 #define DTSEC_SUPPORTED \
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index 909faf5fa2fe..95f67b4efb61 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -36,8 +36,8 @@ struct mac_device {
 	bool allmulti;
 
 	int (*init)(struct mac_device *mac_dev);
-	int (*start)(struct mac_device *mac_dev);
-	int (*stop)(struct mac_device *mac_dev);
+	int (*enable)(struct fman_mac *mac_dev);
+	int (*disable)(struct fman_mac *mac_dev);
 	void (*adjust_link)(struct mac_device *mac_dev);
 	int (*set_promisc)(struct fman_mac *mac_dev, bool enable);
 	int (*change_addr)(struct fman_mac *mac_dev, const enet_addr_t *enet_addr);
-- 
2.35.1.1320.gc452695387.dirty

