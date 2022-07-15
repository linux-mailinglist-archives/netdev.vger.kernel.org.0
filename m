Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FFB57699A
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbiGOWFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiGOWDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:03:46 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00040.outbound.protection.outlook.com [40.107.0.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAA08BAB2;
        Fri, 15 Jul 2022 15:01:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iAjdUvxFsMirX1shYx6W1B5wWZgDM/RTHfNraPVjRbK0D3cntIQyM4yjYY2TRjfD/X9qZucyWjzZkAMu+llGaFZzOXV/jfvoqnjpySOQIlQbuAexki88lc/KvCqmDXgG2Q0B/P4CifWB0+yOoMA4KpstmjpCu/vN94FeOEU6crSCeM9AEyTuzF4SXt+RDRlwuCIcE9FMCIAFuFTDXkiUx0mqfUTpzdXEq41cun0w5CPB9I+n2Zn+fzEI9iFFVsa3ig9UkSShgiGCM56CfbHOlWquORVQ1HT8dL7yy1bHgJIrYIPKpHodXDgryi8CjsabaLP2dM1o18njZnuh/65j6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hasT6hbSKpYPEJ2OuGoSIn5aDqRn8ixuLqCWErCLeDo=;
 b=g61V41b5o8j7N0u1e439VYWMOV5YroSwsu82cFCnA5+rhcX+csxJKK0/QEKjkG6rGiWsAOdGFSvSx9S6cCBAOAF8IqPuBoab0xutscY9GDpjsNnR8OQaf++IMDlb3SErFS9fpQC/9gfao1vakfmbCNB+ZLU6J6T5qKTQIFsYHiFbRlrsH58bCUW4NttTYRyVVCZk3rcnoa3pb9ft3tGykFSXJaJFUThL5k8LI4M8xon5oxFl19N8iiIG+w9+rRmKa4vzx/ksSTG+xLmdIdqZQi5myoAWFHcAt/slziB4vBHHqhxysxYW4SZW4hJLbKty/JxgKrMt3UfqLCXfRYZTow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hasT6hbSKpYPEJ2OuGoSIn5aDqRn8ixuLqCWErCLeDo=;
 b=yRAZSwXrj+hu1fyu67UtunOwRhTPeiNSxRB2siz/DXKyp3mokQsMQma25pnbBApWCI7dbQpS1xKdeCftObvdBjoVJ14j6YYkI06JtYMRxMTs6S9kC4hingCIlUI82lYclSrwu8HNFWNQuEI2KFe0F3S8g5HwgVsV3QYijhmkB+pNFV6yWKWdEeAEtRvqsan0UxzHBhUj+/KYWplgkzRK/yUrkWpvQpEG3RgbFEuRTBFf8j9TuiY0XMssYWaCOYI8ujzZVt9EAB1XgiBpuc3ngEd+KCwr3tyhNVGvhkJJ1y63dTqFH9TeCKu6jbkWuhLuNhAbYNvrpG1I1OHQ8NEnmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS4PR03MB8433.eurprd03.prod.outlook.com (2603:10a6:20b:518::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Fri, 15 Jul
 2022 22:01:34 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:34 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Li Yang <leoyang.li@nxp.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next v3 36/47] soc: fsl: qbman: Add helper for sanity checking cgr ops
Date:   Fri, 15 Jul 2022 17:59:43 -0400
Message-Id: <20220715215954.1449214-37-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db3bb590-b0e3-45c1-5fe8-08da66ad94d8
X-MS-TrafficTypeDiagnostic: AS4PR03MB8433:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PkajheBA/FAfx1ROI5aT5JdX4ta1f518g8x/EBx0Bt/JTFE3A6Vymb43slhJkmKuHgEeXz8TiaXHYgwHVuuLv6PspWZF/bt9omMYOSSLGbFKp6K6/DakxjwYQ+5HOlHd2RJvczmEVAApqMzApISgPSj7Gjff1vz2m6uvr1/JxUAIJnNZ7HsVw5Tyz9oFZilgaP6Ip5ZZ60sskgOez+ruhhf+9kBPYP7/PPorLsWkl+YzdcecCy/Wbs3fOSavTzyzX0vDM9ZYuo16v5kC9QbbwIj1baeQe8kmlpMG8jWaCaa237Fr1wXI2YAITqY+b4qynuTb6nGiyrioxWlIc+DmWKdkT9K7wG3KMh8FL8NVzsQR7a6YAUWDahafRCu0iJLABy/hXBayTCWJWlofsw5L5L99R1F2MuxD+xIbOfr9djKcA7+UeUE2h2VVFH572lfE7EY7pfxQxf2Nw97vJz+pFWithLSiknXGRuttHOTSUOwiQrYBNMoHhlAN+kO3aamRXR7IpbgKMmt1qGa5r92KgRWn8ofl/oYj4pyrXIH4OqrcuO4v5P9RGQrcSh703yHMyMeDGQekEl28/2DQcvGY2DJPZuZa1oLXtkmuxXYuLpjcpHT/Shz5e4NlsoZKpFpgNN8jSD+j9sxFHuNPj1TMqlirTIZaDq0S6xUt1yLzbLWo6Qk0SElZbv0NhuvukilzN6Z1Z6i1OjKD0qev4sAFeLtvBom/AYMj4R3TphH8PKZUeorx6zjSYku4haHCIMLj3YlZ24/F3iTrMwLcJm6wlVSwcoMFuJcqDpTiMg7RrH1YJhTG1QwZKhtVR+q5c4Yr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(39850400004)(396003)(366004)(136003)(6486002)(478600001)(86362001)(6506007)(41300700001)(6666004)(52116002)(6512007)(26005)(83380400001)(2616005)(54906003)(1076003)(316002)(186003)(110136005)(66946007)(2906002)(7416002)(66476007)(4326008)(66556008)(44832011)(8676002)(5660300002)(8936002)(38350700002)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ldXyVvx9BMmKoG3jpYddFHeF9uJEAw1Mrhnz0fdcEuLXFYJ0ALYczouA1WUq?=
 =?us-ascii?Q?USWiy+ixWYaBn47qud03UCUFmdEuM5yfQqpamSSLGT7qWcYn5hsHhMmtOIrr?=
 =?us-ascii?Q?a7h77gErB8xvszlGPtHze3mFiBS0ibwcqaS9i7leBvxLdtb8yfHv8NAdAEsJ?=
 =?us-ascii?Q?cVY8hXxCtfXPjXQchWcsA+ZQ8GhLrzV3y/XMf6Fzd0SwuMOiqLWQSkyHq7MF?=
 =?us-ascii?Q?qYFd9stPMTQitB1vRbXB08K43zRyjeeMcBLfoBhAmjSUZ0NBInoQ/aPKMsCU?=
 =?us-ascii?Q?O/sd1H/qfgOOjluRn9pFMALtIDPT6ljiP1z8RujqlFRplU3yJ2XvbY4iETYC?=
 =?us-ascii?Q?pzMgOmoknsfPLfxiDr1qr/qE9PemHINvYrQlWC4f5Df6hul09HT4F0RGbvip?=
 =?us-ascii?Q?ugEtSpf69Dykl8ibyGfiJZ+HiULpfZ1hxTgFcONqwrmKf3jm+DiGmHafBBwu?=
 =?us-ascii?Q?8dwZar9kI5O+ZEoRNpr73hYjgLVyLcNgcvt5SngSQftPpFt2Fw/0rzAfiyEx?=
 =?us-ascii?Q?EfBzdPkjhCY/S5env2Y9WTgeyyDt4G24p4YwQAdH64XiLIz0HJKNJU+9jCyb?=
 =?us-ascii?Q?Kf88gVZCUgsmRiUOyyM3enpKER0oNLUvfiFLMvKY2eKALYR2kF2T1pLbwm9W?=
 =?us-ascii?Q?Q3r4/myHfdrz4VAVUK4eiw272LRMxvpIDrR2rQgFe5NuLQb2kG8Q2NdTL2JI?=
 =?us-ascii?Q?hbFeZrSUZJL85GRXE+f9sPvVVqDcra63+BtltV1ThR0c3g0cIRZkgJQm+4sP?=
 =?us-ascii?Q?ixNbcwLVMudCe30GGYKm4gHIz0hpQ/L/oQrtnnbKboywHPqDOki24YCLv5/7?=
 =?us-ascii?Q?8gG+FiezW/MMnB27yv9NjO8No3SVxVqIHbk5Wp7/2I95fYIc9Sj717Wnk2G4?=
 =?us-ascii?Q?CL8mhRkvzVQjW8uQf59c+lXV5RgbeTnIIIrKpLMgZnie5XGr0b427GeZdvjR?=
 =?us-ascii?Q?ro0KbOI/pT010NGobtwMdzt+LhduwuGUSQbaPmqdx6vqsUd43K5tYNF9RF9k?=
 =?us-ascii?Q?Jv61IrOFXx8AuxbF5y9PrLAKZ76uyXMMfusY7Aif1b626AaZvkyOfqfAxHKR?=
 =?us-ascii?Q?HVbWH9HekJim62qhxRjemTm28h23jSmX5mas+Otcm59mWT1OF9oSDKQFi4Nt?=
 =?us-ascii?Q?0TAX8Z9LSzm5UNmyx8xEtO5cugxk3r2kKotaQTucWGUKos8h8t/yJrpEYk6K?=
 =?us-ascii?Q?ldCQOuO+ONO6XqqvWe96yFNAUykCOClAx5o2QIDKOXJ78A1k/a4n5AN3maNj?=
 =?us-ascii?Q?4FrZyGQ4/BAqyvUm8z3fXdZCPKTK85GDGhyTys/ZQ8FF5pzBDOp6abA+1VhQ?=
 =?us-ascii?Q?vMUn137jKPekLg9hOQC1zo0qsD8ps9UnocLfPOWH+wfUQRbwsjbvfM3RXdE6?=
 =?us-ascii?Q?PrvPGpcrpREedEUBqVPNkWPk/mYdObV+IP+KbW5tL0hVsOhRTEB2OSqoHc9y?=
 =?us-ascii?Q?Yy3jAPRnquzMgUGmYP76psavt2TlqHmwujnadsoPQig42ECVSIwdu8854tGV?=
 =?us-ascii?Q?y5uV8Jm/FV7v96TFGCj/2iDA9RG6v/t/m8gLmhLF/5jEJhm+l3JBfEbmg1EQ?=
 =?us-ascii?Q?ZZhM7Qpfc4gs/UjjUinsolJ/6qb7P8V+9uHRzfSycVkCIV+W2NNdYB5j2h26?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db3bb590-b0e3-45c1-5fe8-08da66ad94d8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:34.0023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7mIyAnRXk7Zbtp4/R6+c63KJj99jXsoWc2ZXg23Ecn+KLvoOsW9tSwpcxKeu1YzPyZe00QUy+abzVhCAU1Wxjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR03MB8433
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This breaks out/combines get_affine_portal and the cgr sanity check in
preparation for the next commit. No functional change intended.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
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

