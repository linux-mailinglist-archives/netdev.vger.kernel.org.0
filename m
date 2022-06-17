Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCF354FEE0
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383299AbiFQUhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381373AbiFQUfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:35:38 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150041.outbound.protection.outlook.com [40.107.15.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0085E152;
        Fri, 17 Jun 2022 13:34:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8LbO9XGOyTih7rpI+B01AMmTOi53r0coZhlgFoCE8FirnBngZNHlnwxe2QEnItiobM6H4FUNMsOLMzksXdAAbY76pFu7FiWT9N4IhZ4yMCPmz0aJ4Fskz7MCPXglVdcxgeOoqHg9PUG32Sn34xveRTKJrNgWxa3gWMHaXl3R5AWF9VowylgWFc/Vuf89jSoykE+yN0QCaw9mcTT2ehpx8FX/sGJbi+l6p499sb/I0oTSgQ9XmyruDTxgjxOis6pJkU8xWqjrVLlLEnsKYzant/+MUZe5rgdR98G76EPSiFW3dyI00B8mvR8Td88jpFBsRh/x7e1lGTDwVaHCUUuFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knf8F4siXxtCncC3B93OaHHxgIiSqV8hDBSDjUjkcCU=;
 b=PbKq6wuRInpP6UtznZtRFr2LlsuQ2GfrqsdwBwSXrlVk0TjwlgNslJogd2LJK56ZJjR4yxsDsXT6W1i6OgQ/TMONoSLnj1ceWYNxxLYyzfat7uVNsCh6oV5xSOdC88S4NxOrwi/VUxGGk9rViNQMJSGmNSy5NwmdAmF158HYnk1ojCCYLeqEOgzj0pavjoUuNeTziD7isgbF+o0b298V84+QCrVmVeF617E1KOYgXgb34X/ofENC/HyIwXZz0y3peGusBXeSxbv4inhl9CQxfNRjI74uGmzWKOEYnTnzr9OPVIipeN4U4sPzE4aNQlVexpPc55j3m+AddUCrfLqKKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knf8F4siXxtCncC3B93OaHHxgIiSqV8hDBSDjUjkcCU=;
 b=TrLGeKjxhjZcLJ2t6IIo+Mv/J5nG26PFwgOC7eSxS/l+CpAcPCTpIzQV5bwZi4LgAtTrc1qun+pOFz5iEvkOURK4IcR6cVW0U8S+JW+O+zEWpKGtdVnoQJ9VjTjXaTomKqawrCVnHUtBoWHITtlBGASUxaZJlo2AKyVk6lypLhcB4PYRmacRdJx2w5W9sV/ZeEZL1+n8SxGXgSUHDuValo29cxm2+JiRvX/CEDPcQPvsZxQoAdO4bNGZOvYSPCQSuMi5W54Pj7ORs8VA7JXiXoFOS2yrv84Pe5OqDH6xL5BaKGQhXdiSVr/ovNqNaa/zz2yDBadElM+ld8/rqi/brQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:14 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:14 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 20/28] net: fman: Use mac_dev for some params
Date:   Fri, 17 Jun 2022 16:33:04 -0400
Message-Id: <20220617203312.3799646-21-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f3b51a3-181d-4441-90b3-08da50a0be00
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB68384BF9F9FFD74491CDD70A96AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r8lqS4Z5VuvipCt+OQxGqSDdjka6BFGUgheUVlHK2/9t0ugh+rso1A77Z4Rg1NASteSFcpo8dXO3OwX9ap83IZQjaOyPApxQhhO2VIArO+S+SaQmeiOeZZpUrWSffR38fKiQaOMncGNTzSG/VNYhHmSMfJGn38AOz4udhHrIKT1Nlx/nERQhsVkJ5uWfYMppeGgM/JIw0t70peIu//VvfSblsbaA69pHm64Golc+uAHIjxpZQHU86/T4gsTFiso67EXNUutXrKZZpl2eUv7yXxlmORVTkRom1CBKBPOTkyjco4TUnri6UEhTyFU5FhYvj945g2yVZME8CNZFp05tKAIWxZYMSqrb/sChKfMJta/uh7MBwkxm3EYFPn2wr+LU6vPpIFL8K2wLO7na0/6HpvhYGxDUa14qQJ3qSSOdycImh+3kH2me0IMbVJDkDTVRCKaUW9x1IKu6P49sFH+1Z4LevaeNQvZKGHr2NHxdlbdFsAmQGnI4nmE8NoIxDOar8xWnmTEMen7hziuzE6TrCJoGJg0F1/JRUfK5e5R1wlHbcSs5YcEnpdda81rlzL1/JX+tj7Sjx6iUm+RObwvFVtMBTChHkMWpiWNJlASeITI63O/axoc7Xa4TKLpj7C4nkXv5LSKoPghQs7i1mOZ0HPI2+QdgNIZ4otBpdLxy6kN/vwJWv5fyMyFFFK+AphU6FzouRnD1wb/Soi/+/78NUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(6512007)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(107886003)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0S0gYxQfHBIcE9AFk9X9iAHJfk91aG5DC3QLpsYuIq1VZjLEjfoNB3BJ13o/?=
 =?us-ascii?Q?Q+3QiqKIwEr+YhMuhtoWnkdu1uCMraOxNpP/3tS4i905xrpAPq4er0iYuhhi?=
 =?us-ascii?Q?8zR/ydqKl+dhmOjYIt6rdkEjnc5QA7f9tRKQ2rYJmeYZ2+YTMCvDYrrYKEDH?=
 =?us-ascii?Q?RADXRQVJoMEiRw+FuswqGogCaa/rcioJSKTGjx1niQMnl2EtkL/ENhLjFqC1?=
 =?us-ascii?Q?+bLOslEET2DFZZZDIKOPnJ8eTkLQOnY4dr3FFYsObEiA9GqomqzKyfkck31T?=
 =?us-ascii?Q?yilRA0K4N6bdIq0xuzYbKCU4eaL1/vVd/BTofoSRX33rZoWPTBQM4I7HxqMP?=
 =?us-ascii?Q?15qOxVegs8Kqrlh5sAmt/CkrmDoM7CLsMqUnFrg4DOy9yTKymaixMlf9X50W?=
 =?us-ascii?Q?3SOO4Y24PkfA1TAnsz4+fScVdmMZYBagN/irAPwL2tqt4s2Wtg8Kp541umJH?=
 =?us-ascii?Q?wxfun+TfsLKkIupaYOo4CtF8AzhXqxaagHWAs7DB24Ub5rNLV3qQvTSy+z63?=
 =?us-ascii?Q?JrmQzNbSpn5Gn2TNKAT88BwNXrnTIPfxY9771k+rSQQAh83AKESyBYgSXQ1l?=
 =?us-ascii?Q?S6nWMIwL9LpqN1/gGzoDjXDhag/kdifTeOa5OviwFB88y7ra8vGOO9yAiBLD?=
 =?us-ascii?Q?cIVyc/kqi3gNDpIlf9QVTEFHJrrYU1FXxYYZYTHD4Og8Obpf+oMvuDR+919x?=
 =?us-ascii?Q?WyXkVsj6h+RGvAI+89J4daT84H1SFb/nFbdhT2xiNek60eurXS+yWsCMzUR1?=
 =?us-ascii?Q?z0YkDA9NLu5UReZa6PL/ZC2us4O9XAl8yu2wekBYtvsih1iptBUynMKCKlbf?=
 =?us-ascii?Q?rbyF7/YJjmYJHekl/yB9XQZk/CXZirfaTs8d23lQmynBW84IJDmq/wZvILre?=
 =?us-ascii?Q?YnnHJFsFOLyGg9x6zJ0hHFZWDoz68j1pnabP33uP6v/9rfXJWnYYlOib/PBq?=
 =?us-ascii?Q?kP2ueYx8x2pWUM/FaT3Hzv0WjqzRs73kDdoU4zX7OZdiUlSDqK4Fb4sbFhQz?=
 =?us-ascii?Q?t2t2c5v6YJs5TWm77Mws6ig4JS5YOD7euABV2NTU/qtYvQdRTnI42kcH6mBa?=
 =?us-ascii?Q?E5XWJNqt+g5yldpSYwt9IdrW6bskB4+8cafvVv6roiKxhmvy/I1YuHh6AR3l?=
 =?us-ascii?Q?1Qo8sNkzaNsgEg8gXrK6s4aMlaValf20bH/PaK22Nq852Gjwrk+VWbMRTWSh?=
 =?us-ascii?Q?NiUv41wojpFB+hdjZYCPRo3Ud7hwZm1nu9SN7dPLcBd2hpzFseAvo+zAbupV?=
 =?us-ascii?Q?vS7eCDIUB1jhnhNifvcin6bTOtjReo9ha2P/NTg7p++SWdogQ7HIY8YN/sxi?=
 =?us-ascii?Q?iusrg3fktWjd9QvwzjBCIGrpYpXM/odyRcKquVO7Gsg6XVxo4hvW2X8LbW2Z?=
 =?us-ascii?Q?r2L9FK1l6jwYN82DbSBbYU2S6HI+rrQVNGPtYjJZtNfH7wVi5h7qkzrbF+pm?=
 =?us-ascii?Q?5E/LCrg0exOZhilPLjbHVSO54tVyKxrXFgJCZiyrOJV0D261Q9YH3AMMHpAk?=
 =?us-ascii?Q?FBo34CkvtybokUR9I66U+miMBBL94vaPUSSu1Q3KJ7b7CNTeNOTUEzwdNDP7?=
 =?us-ascii?Q?T67WUJN3SnXXU17xmHubdknAZU4UUCZPnHWJMIU/5ZzGjMhE7zV3rl4OosD+?=
 =?us-ascii?Q?kVCphjN04eFGpjKEifFRhpmLYRUBzYAtSyLnC+ls70KYP+nJ0mXMDLanjNH0?=
 =?us-ascii?Q?jtXzgfB4VZT5oqlVuHHgThdSK4+8wb0cdi1R5PBwlEsdq0JSn1xKOJtShHVa?=
 =?us-ascii?Q?oRMck7ymHZqq+I3VIbLlJGSH5XfUZ/Q=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3b51a3-181d-4441-90b3-08da50a0be00
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:14.1543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RInXRH7apvkIVlFoGFHVJqlQAz3O0/b5VFbvYRvGOR0j/n8ocr/sH5RsfSy/9cTUnbFbC5Wwhu2jkZ3dTAaRCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some params are already present in mac_dev. Use them directly instead of
passing them through params.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../net/ethernet/freescale/fman/fman_dtsec.c    | 16 +++++++---------
 drivers/net/ethernet/freescale/fman/fman_mac.h  |  7 -------
 .../net/ethernet/freescale/fman/fman_memac.c    | 17 ++++++++---------
 drivers/net/ethernet/freescale/fman/fman_tgec.c | 12 +++++-------
 drivers/net/ethernet/freescale/fman/mac.c       | 10 ++--------
 5 files changed, 22 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 7acdaed67d9d..c5cc20b9ebed 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1413,13 +1413,11 @@ static int dtsec_free(struct fman_mac *dtsec)
 	return 0;
 }
 
-static struct fman_mac *dtsec_config(struct fman_mac_params *params)
+static struct fman_mac *dtsec_config(struct mac_device *mac_dev,
+				     struct fman_mac_params *params)
 {
 	struct fman_mac *dtsec;
 	struct dtsec_cfg *dtsec_drv_param;
-	void __iomem *base_addr;
-
-	base_addr = params->base_addr;
 
 	/* allocate memory for the UCC GETH data structure. */
 	dtsec = kzalloc(sizeof(*dtsec), GFP_KERNEL);
@@ -1436,10 +1434,10 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 
 	set_dflts(dtsec_drv_param);
 
-	dtsec->regs = base_addr;
-	dtsec->addr = ENET_ADDR_TO_UINT64(params->addr);
+	dtsec->regs = mac_dev->vaddr;
+	dtsec->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
 	dtsec->max_speed = params->max_speed;
-	dtsec->phy_if = params->phy_if;
+	dtsec->phy_if = mac_dev->phy_if;
 	dtsec->mac_id = params->mac_id;
 	dtsec->exceptions = (DTSEC_IMASK_BREN	|
 			     DTSEC_IMASK_RXCEN	|
@@ -1456,7 +1454,7 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 			     DTSEC_IMASK_RDPEEN);
 	dtsec->exception_cb = params->exception_cb;
 	dtsec->event_cb = params->event_cb;
-	dtsec->dev_id = params->dev_id;
+	dtsec->dev_id = mac_dev;
 	dtsec->ptp_tsu_enabled = dtsec->dtsec_drv_param->ptp_tsu_en;
 	dtsec->en_tsu_err_exception = dtsec->dtsec_drv_param->ptp_exception_en;
 
@@ -1497,7 +1495,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= dtsec_enable;
 	mac_dev->disable		= dtsec_disable;
 
-	mac_dev->fman_mac = dtsec_config(params);
+	mac_dev->fman_mac = dtsec_config(mac_dev, params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 7774af6463e5..730aae7fed13 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -163,25 +163,18 @@ typedef void (fman_mac_exception_cb)(void *dev_id,
 
 /* FMan MAC config input */
 struct fman_mac_params {
-	/* Base of memory mapped FM MAC registers */
-	void __iomem *base_addr;
-	/* MAC address of device; First octet is sent first */
-	enet_addr_t addr;
 	/* MAC ID; numbering of dTSEC and 1G-mEMAC:
 	 * 0 - FM_MAX_NUM_OF_1G_MACS;
 	 * numbering of 10G-MAC (TGEC) and 10G-mEMAC:
 	 * 0 - FM_MAX_NUM_OF_10G_MACS
 	 */
 	u8 mac_id;
-	/* PHY interface */
-	phy_interface_t	 phy_if;
 	/* Note that the speed should indicate the maximum rate that
 	 * this MAC should support rather than the actual speed;
 	 */
 	u16 max_speed;
 	/* A handle to the FM object this port related to */
 	void *fm;
-	void *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *event_cb;    /* MDIO Events Callback Routine */
 	fman_mac_exception_cb *exception_cb;/* Exception Callback Routine */
 	/* SGMII/QSGII interface with 1000BaseX auto-negotiation between MAC
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index fa84467e10da..4d4c235d5dbc 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1109,13 +1109,12 @@ static int memac_free(struct fman_mac *memac)
 	return 0;
 }
 
-static struct fman_mac *memac_config(struct fman_mac_params *params)
+static struct fman_mac *memac_config(struct mac_device *mac_dev,
+				     struct fman_mac_params *params)
 {
 	struct fman_mac *memac;
 	struct memac_cfg *memac_drv_param;
-	void __iomem *base_addr;
 
-	base_addr = params->base_addr;
 	/* allocate memory for the m_emac data structure */
 	memac = kzalloc(sizeof(*memac), GFP_KERNEL);
 	if (!memac)
@@ -1133,17 +1132,17 @@ static struct fman_mac *memac_config(struct fman_mac_params *params)
 
 	set_dflts(memac_drv_param);
 
-	memac->addr = ENET_ADDR_TO_UINT64(params->addr);
+	memac->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
 
-	memac->regs = base_addr;
+	memac->regs = mac_dev->vaddr;
 	memac->max_speed = params->max_speed;
-	memac->phy_if = params->phy_if;
+	memac->phy_if = mac_dev->phy_if;
 	memac->mac_id = params->mac_id;
 	memac->exceptions = (MEMAC_IMASK_TSECC_ER | MEMAC_IMASK_TECC_ER |
 			     MEMAC_IMASK_RECC_ER | MEMAC_IMASK_MGI);
 	memac->exception_cb = params->exception_cb;
 	memac->event_cb = params->event_cb;
-	memac->dev_id = params->dev_id;
+	memac->dev_id = mac_dev;
 	memac->fm = params->fm;
 	memac->basex_if = params->basex_if;
 
@@ -1179,9 +1178,9 @@ int memac_initialization(struct mac_device *mac_dev,
 	mac_dev->disable		= memac_disable;
 
 	if (params->max_speed == SPEED_10000)
-		params->phy_if = PHY_INTERFACE_MODE_XGMII;
+		mac_dev->phy_if = PHY_INTERFACE_MODE_XGMII;
 
-	mac_dev->fman_mac = memac_config(params);
+	mac_dev->fman_mac = memac_config(mac_dev, params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index f34f89e46a6f..2642a4c27292 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -728,13 +728,11 @@ static int tgec_free(struct fman_mac *tgec)
 	return 0;
 }
 
-static struct fman_mac *tgec_config(struct fman_mac_params *params)
+static struct fman_mac *tgec_config(struct mac_device *mac_dev, struct fman_mac_params *params)
 {
 	struct fman_mac *tgec;
 	struct tgec_cfg *cfg;
-	void __iomem *base_addr;
 
-	base_addr = params->base_addr;
 	/* allocate memory for the UCC GETH data structure. */
 	tgec = kzalloc(sizeof(*tgec), GFP_KERNEL);
 	if (!tgec)
@@ -752,8 +750,8 @@ static struct fman_mac *tgec_config(struct fman_mac_params *params)
 
 	set_dflts(cfg);
 
-	tgec->regs = base_addr;
-	tgec->addr = ENET_ADDR_TO_UINT64(params->addr);
+	tgec->regs = mac_dev->vaddr;
+	tgec->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
 	tgec->max_speed = params->max_speed;
 	tgec->mac_id = params->mac_id;
 	tgec->exceptions = (TGEC_IMASK_MDIO_SCAN_EVENT	|
@@ -773,7 +771,7 @@ static struct fman_mac *tgec_config(struct fman_mac_params *params)
 			    TGEC_IMASK_RX_ALIGN_ER);
 	tgec->exception_cb = params->exception_cb;
 	tgec->event_cb = params->event_cb;
-	tgec->dev_id = params->dev_id;
+	tgec->dev_id = mac_dev;
 	tgec->fm = params->fm;
 
 	/* Save FMan revision */
@@ -803,7 +801,7 @@ int tgec_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= tgec_enable;
 	mac_dev->disable		= tgec_disable;
 
-	mac_dev->fman_mac = tgec_config(params);
+	mac_dev->fman_mac = tgec_config(mac_dev, params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 5d08c4696c21..88b9174531a6 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -34,7 +34,6 @@ struct mac_priv_s {
 	struct list_head		mc_addr_list;
 	struct platform_device		*eth_dev;
 	u16				speed;
-	u16				max_speed;
 };
 
 struct mac_address {
@@ -443,7 +442,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	mac_dev->phy_if = phy_if;
 
 	priv->speed		= phy2speed[mac_dev->phy_if];
-	priv->max_speed		= priv->speed;
+	params.max_speed	= priv->speed;
 	mac_dev->if_support	= DTSEC_SUPPORTED;
 	/* We don't support half-duplex in SGMII mode */
 	if (mac_dev->phy_if == PHY_INTERFACE_MODE_SGMII)
@@ -451,7 +450,7 @@ static int mac_probe(struct platform_device *_of_dev)
 					SUPPORTED_100baseT_Half);
 
 	/* Gigabit support (no half-duplex) */
-	if (priv->max_speed == 1000)
+	if (params.max_speed == 1000)
 		mac_dev->if_support |= SUPPORTED_1000baseT_Full;
 
 	/* The 10G interface only supports one mode */
@@ -461,16 +460,11 @@ static int mac_probe(struct platform_device *_of_dev)
 	/* Get the rest of the PHY information */
 	mac_dev->phy_node = of_parse_phandle(mac_node, "phy-handle", 0);
 
-	params.base_addr = mac_dev->vaddr;
-	memcpy(&params.addr, mac_dev->addr, sizeof(mac_dev->addr));
-	params.max_speed	= priv->max_speed;
-	params.phy_if		= mac_dev->phy_if;
 	params.basex_if		= false;
 	params.mac_id		= priv->cell_index;
 	params.fm		= (void *)priv->fman;
 	params.exception_cb	= mac_exception;
 	params.event_cb		= mac_exception;
-	params.dev_id		= mac_dev;
 
 	err = init(mac_dev, mac_node, &params);
 	if (err < 0) {
-- 
2.35.1.1320.gc452695387.dirty

