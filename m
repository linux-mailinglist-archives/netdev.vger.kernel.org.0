Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4265988AF
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344660AbiHRQVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344170AbiHRQUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:20:15 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10088.outbound.protection.outlook.com [40.107.1.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52EABD0B7;
        Thu, 18 Aug 2022 09:17:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RrK2zhsWQwnY+dmAuS9EEUfsOmG27Ay02g0cPXHjIAWquZ8lXWPMLs8zh9JKJR2RTpwF7ZkO62uyu+l8RiS1imQycrUWuK2uBpUyaUAEfVk2gCfjkgTzqQ9eS0YVAPZRnCTBK13yGxNzz/cnPdDfYNplyW1E3c9OY9IBuzZmK3JTyj6rBVV+1k35DcG/RCBd0vvS0c5OXop6KHihwPZSVQmnC9Tb9K0N7ZBr8K9oKuAzWkRcjRNNAJDzvzzTsRxzmYsWaeyE8EaUvl1nYC2T61WEr79W3Hl84kSnuVapiX2SkNGUMj0V//GU1FG2/g2xKrTMpq+YDSR6Zaymuxl4Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0iVIpavMKo9hh8B6pZsnQSMzDiNhLM+JGQPoO6Zp1c=;
 b=AIJt/TCvfTPbdcMqFNMTFmL8p1t9g5zrX2rFVeU/Gkj0pv5UzIhmPM0zXvWn5hlgv/+byI547c6+wSJOZZj2cqNHWyI5ZhDuSYRfZKlzqxibn59WTXUHcTcTFOAZmOX/xZx74qo24R5hK6bVAx4z7NdAijv/M97fDSu2ArKztJYAjDxUUOcimm8HE5LG8j8aIwgwI7O7nagcgxeq2BtjTyMuWUEU+FvLG8Q2wfQL/pnYlqEsT4KXO3k1agw5rNMxPLYi4rm21cj4+qZeXod8z1jXMJtRIkq/Rw3NkoyGd6TNUdl1XJ8fnzWe5jsWNky1GbmMctaYwinE/8j407CRqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0iVIpavMKo9hh8B6pZsnQSMzDiNhLM+JGQPoO6Zp1c=;
 b=zkRtBVqeNzI8qHPcn/joB2fbAJXtCQEMPDQSWfMchXvV3oozLr6iZLDNbyIWn3k6+wgEUAUy355LEz5HjnWX46PJBdiWkb37btXnlgbp5r7OhvyEleOiCJ4a6LpEPdGY8t6y6/wuzG1VBIIw9la2qfXfxYwtpCYn2Nit/wzMPsig0QGrAhYocTVsBB5LoJ45+Tah2j8YWriRpPv3B6Mo++R0u3Xp+VFDJx/TkQqBdRFxlmfdp4W55FJrfxh1NVfBpSPXGW9+GJYpdpWofFpV4uFEMkXXxMe61/6AQ/0apjGnMd+Eoda+cyyGqflWy6TxTUJf8jEcWTFKr7I2rKlJpA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5621.eurprd03.prod.outlook.com (2603:10a6:20b:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 16:17:41 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:41 +0000
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
        Sean Anderson <sean.anderson@seco.com>,
        Li Yang <leoyang.li@nxp.com>
Subject: [RESEND PATCH net-next v4 23/25] soc: fsl: qbman: Add helper for sanity checking cgr ops
Date:   Thu, 18 Aug 2022 12:16:47 -0400
Message-Id: <20220818161649.2058728-24-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 338f12a6-4c5a-483a-c994-08da81352cd8
X-MS-TrafficTypeDiagnostic: AM6PR03MB5621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rg/YdMyHIyLDfGGX2eYxRMXsBQ7aut5F2AoUmRHunu+A3APQ5XwpaWU8jp5eH1KSlzWbOoxjUItPIkKYUVDCLrOSi7mSWpJFt2AboZcpypZyyNW/cUICwloDbfoK2PJYnjvJf+CcfEnhTWQ9RjOrqoMN4ZfSPam3lb0ifQIuXo0u8pO/jE7aP8nIlCkDuHXcJfDbDPg4i/ajALR2WK4kumruuxQC/NGxNT+qvmaNaosKx+zIpp+KSbB3hegdwMP2t58Vefo3Zpd5/+Zy2iaMfDj9ReKwEi7WDk3yQCWloOoR/Yzs32SK1VIJjX7oh4rCo8mLeXBI6IkYmqT0hjWI/xT7w/a0MVDRsHeXrqTAcVRH+H66mzpOdZzZdYmq8YEz9pupJqX8dPPFXhKDzXw2FdjeL1w+Kf+Hg86wRDJiH2PasaeJ9aEmxfVJgweLpIRebXMEm8kjapjZZjZ9MjgVJvKL3cxuC9ynNO08gty8Y022oUdaJ6Bekk4V2DMUVAHbxGZTcUdwsNLZOzd4tQ4Wssc1FWUDGE/WsZySfEe29zFB/s+CCKESl+GgedEHleOHwQQQll4L9RHUw3HWGU5TlvRzFkVYa3942pzzaaHNo7/KM5hy1/aCd1/Or5A3iV1jU10wdV6NG6a/PztH7onosWMGzISx1///X3EHg84arFNhE3bwIi76RkLVpryBLeVh1k6UnTODS0uzpLrajGGgVzcweNKTg6Lcgfj8Nbtz7sZJSOzGhV6i3DasDLdUp02n0KjZM6pF/McU8RoFov00uQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(396003)(376002)(39850400004)(41300700001)(316002)(478600001)(54906003)(38350700002)(5660300002)(38100700002)(6486002)(66946007)(7416002)(110136005)(66556008)(66476007)(8936002)(44832011)(8676002)(4326008)(2906002)(36756003)(6506007)(186003)(86362001)(26005)(1076003)(2616005)(52116002)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sf+S04h79gZI08c9VIdC/FnwBJ2hWR/BBeczfvvVbsmIkoK9OTsdrqi7faGQ?=
 =?us-ascii?Q?sbk2AqHdk8yQDwgaRLh514Tx0YsKgA7QG4hdz73pPMButefJPjJzv6dBa5T3?=
 =?us-ascii?Q?NphN4Fe0saG6GY0sH02c2LRuKVDGgB+gNts3eFuxi9/EZPM0+Qe9vIoWq/P7?=
 =?us-ascii?Q?cEyV0RtGTSVROnl/aqpAvUgZsukkBCZ39dR6Ke4nKmZbX56QF4WTVem5r4NG?=
 =?us-ascii?Q?z1CbGs8qXs1TljHWSc1IluDGtDIpQ14IwAfVrUxDh9QmgrvJUtXhP2muA0Jm?=
 =?us-ascii?Q?aQCBEa0XkGQT4Mplruug869NFUHYlwOM96iVisHFC4qEZsrTmzl1HLVhgOKy?=
 =?us-ascii?Q?UyrD83Am69XiqFqL5Vp/IPdHpclxnmc0PCIO4Dy1VGNqAHeO7k0vpOK9XjvP?=
 =?us-ascii?Q?Tz7zSY5bST9oYBp8EracSF8cqJmIkLwcH54W0I1SnyM3uSW1cVpLplxfa7eU?=
 =?us-ascii?Q?Ca0OHFa2W5SCDZMYDPklsaWczlRL9MKCbdvBSHFX1NjNhafdoNN5ox6esp6S?=
 =?us-ascii?Q?4Y0bkKIEAetK3nSuuRNl3cLaHy8Q2zCDwX5uQeRp7pOgVMSaf8l8yE+IRjm9?=
 =?us-ascii?Q?7dIJmq9RxghxWhHuVCwtW0FZfm27nlXErzs8EZiiKeGqir5clRkGLZqk2Fbo?=
 =?us-ascii?Q?o3Zk4U56c59V0SFDLOM75jPB4CtwBbFvuaCC7wyg0a97e3zDQuEQHyu0SOTA?=
 =?us-ascii?Q?jpraSrMP9KQvAn1iV5GLRM/aab4XyKW6bjWmQyZ0M1jDbZVTD8hvO3EsjJNh?=
 =?us-ascii?Q?vr+hukqKnxZwfN/O2FcAln+ardpS9NglyFyESsCbTwRwrrOVRESQZLgw9s0K?=
 =?us-ascii?Q?XQHuBq1Tr3zaOLOTLzlKcGYrqad890z/yAY2MjL37hjDfRH19h8VY2UQ+8iX?=
 =?us-ascii?Q?2/7gG6QRhJCNjsnYfL7PxZkBwWJNCenst3YRLCrB87T2+3aCJTS3RjSHv7mF?=
 =?us-ascii?Q?6LZM6Yd7HLXmNiiLQZHnSMa2ljUNClG/fhaWUSWHEgsDUMLa9E8pZsIJY5oQ?=
 =?us-ascii?Q?g7mLFRx6lQAreJgwn99rkyH8Js+Psv9f0Z8dWOwRhROEzoqhIAlwuDRV8sYS?=
 =?us-ascii?Q?f73yoYF3tWdhx/Bxh1RpigL8fLwWQsP/0yq5Ihh5vAL003FG7AqS3cNrIyvU?=
 =?us-ascii?Q?dX5y9Hl1/1YfXppagQOjOubdHCVrQeapwp9kj3kZONkPb8OQhZu4s6IGNS95?=
 =?us-ascii?Q?QKgBxAfPGuz23Bm9o/9Bw3sUA5MKPN2rertvJHgpEZAguBiSK+q4vUaHO8Zf?=
 =?us-ascii?Q?/GxuqQzOj4dnqbMf5X+jxBDoVdCi56Y7uU92v4kKRr9yzZDqD2/QVxOzVc8D?=
 =?us-ascii?Q?BNO/n3Tqs5NhWm4mpFHQpOMJLYhIF8EmNS2uGavFf0Rb/CgwSJMi9ss2cFfV?=
 =?us-ascii?Q?yYSbdxLcgRxHyAyJU7uV7iDO6pCQaLnn+In4/2MNrIkaYA+TRuyAEdKfi/JU?=
 =?us-ascii?Q?LTWSFw7nAlAeYQglcSfBlS4Uf1bkKtrSwo5Ul/shk6p2PJtBLUJTL1K1U2+Y?=
 =?us-ascii?Q?MicQ0wUynasenNDP4uh9tS2F+pqR1SQN/ZUP0IFVqmdYZBRDftyGyRUZvAgY?=
 =?us-ascii?Q?xAbgdmeeRjzg6oXYvsLWVE1kyeaevtnmXD29JgQe5tjK59X59DTYFMPaj7LF?=
 =?us-ascii?Q?bQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 338f12a6-4c5a-483a-c994-08da81352cd8
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:41.3094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aohile+D6bNeZirWoeNm9u31R1/RUBO9ZRhUNQGfHf6K5WkpBCfjsG1Un9dOOvB68pw5EAQB3kDpL/l5CUSshw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This breaks out/combines get_affine_portal and the cgr sanity check in
preparation for the next commit. No functional change intended.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v2)

Changes in v2:
- New

 drivers/soc/fsl/qbman/qman.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/soc/fsl/qbman/qman.c b/drivers/soc/fsl/qbman/qman.c
index fde4edd83c14..eb6600aab09b 100644
--- a/drivers/soc/fsl/qbman/qman.c
+++ b/drivers/soc/fsl/qbman/qman.c
@@ -2483,13 +2483,8 @@ int qman_create_cgr(struct qman_cgr *cgr, u32 flags,
 }
 EXPORT_SYMBOL(qman_create_cgr);
 
-int qman_delete_cgr(struct qman_cgr *cgr)
+static struct qman_portal *qman_cgr_get_affine_portal(struct qman_cgr *cgr)
 {
-	unsigned long irqflags;
-	struct qm_mcr_querycgr cgr_state;
-	struct qm_mcc_initcgr local_opts;
-	int ret = 0;
-	struct qman_cgr *i;
 	struct qman_portal *p = get_affine_portal();
 
 	if (cgr->chan != p->config->channel) {
@@ -2497,10 +2492,25 @@ int qman_delete_cgr(struct qman_cgr *cgr)
 		dev_err(p->config->dev, "CGR not owned by current portal");
 		dev_dbg(p->config->dev, " create 0x%x, delete 0x%x\n",
 			cgr->chan, p->config->channel);
-
-		ret = -EINVAL;
-		goto put_portal;
+		put_affine_portal();
+		return NULL;
 	}
+
+	return p;
+}
+
+int qman_delete_cgr(struct qman_cgr *cgr)
+{
+	unsigned long irqflags;
+	struct qm_mcr_querycgr cgr_state;
+	struct qm_mcc_initcgr local_opts;
+	int ret = 0;
+	struct qman_cgr *i;
+	struct qman_portal *p = qman_cgr_get_affine_portal(cgr);
+
+	if (!p)
+		return -EINVAL;
+
 	memset(&local_opts, 0, sizeof(struct qm_mcc_initcgr));
 	spin_lock_irqsave(&p->cgr_lock, irqflags);
 	list_del(&cgr->node);
@@ -2528,7 +2538,6 @@ int qman_delete_cgr(struct qman_cgr *cgr)
 		list_add(&cgr->node, &p->cgr_cbs);
 release_lock:
 	spin_unlock_irqrestore(&p->cgr_lock, irqflags);
-put_portal:
 	put_affine_portal();
 	return ret;
 }
-- 
2.35.1.1320.gc452695387.dirty

