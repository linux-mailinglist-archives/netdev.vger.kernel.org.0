Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC9E55F141
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiF1WRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiF1WPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:15:42 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00064.outbound.protection.outlook.com [40.107.0.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BFA3A1AF;
        Tue, 28 Jun 2022 15:15:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9SQbVhxjACcI+DPQjgd3Mt5M1Hb3vYrhxS5OLHjkl+a1ZOGzSyJmnDWXMIPZt6Gt1OJqL0IjGvuvc0wEXq1JrJQ/6L/vsmNRu2Ms3QNOy76uh1YOD1N5dWoplOv+5ONrHrO3qRZrR1T2gFTLb6NvCkHb1n9zOWh+VjpOOmzMkJsAVNEcuKUQqpDXKgT3r4MkdS2srDNHRPEEhiMEgwnz3aIHhYB27DJt8KrWZ8V+qGgnrylyfdZOR9o83bFRsY0i+rObYVuMnuJOZ1AH6S3j5wkYA3JH5MC3O3gdjwY8ZP6rdukusPp4KmYQDqAccN8rD48+7ctDMPRx1O8DqF7pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXjsQxGekWL1pE7LAMA9xyMQz9IG0LkGJwFLh5BpV1E=;
 b=aX5lViST8rADHFaFGkLz1gWRbIkhEXxkpLc3w5P3Bo/MA8Lroouz1AdMqyDa35juBK+VH3/ScUskiOLlA8hn7sOMCp/9leD8EuqPfiW0Dhe2xGHfmZGgOpziApdcqecSEtneAEeSIKOuiS69u1itopLqXY6Ua3IKnTgjShNYeR/x7CFsyrN1Yp2yuXLMI5zwoBqcbL4AFdQlRuVm4wuCXZ9f2FeB/mFqpGsU7t5FiXG6XEfbUvi7wW4oA80wuCBIu2tGaQWXbcZssmc4KdlenUjN04eCcLQGnI5U5E5OrNoc7fkx7peXY0S3LuCjQ8olHIyNTFWIsCZUJdUQKrR8wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXjsQxGekWL1pE7LAMA9xyMQz9IG0LkGJwFLh5BpV1E=;
 b=0L1IIWGPRBo4YqORQodmdjL+3Y3pF8R4r5Nqt6AWnsIGwW46MMkZLdTWk/Gtc37LGnlFgXq/l2VdG5llM3b9fAkpTfd7UZdpOcxv77qBG4+Ij1h2yZbGn5avDsLhDeg7QLnrIQwRkrk0vV7sstX52d968AcXyunf9KAds0uzGvTSKNa8bPtU9wtDQ/qW53BXd3BMt/CQI9a15QqHnAUb6XQ7TJ6XUgJ43Xn1pmBJYA+OdpWQjYVOItv5pe5VnNxW2gso6A1KYXipOhlWCSmoRgx6qaySOR9UiqV6u73R6qVxMY3RYjjE644m2pdzOpp7fplEeKX6dT2BDyet+5+bHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR03MB3013.eurprd03.prod.outlook.com (2603:10a6:6:3c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:59 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:59 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Li Yang <leoyang.li@nxp.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net-next v2 26/35] soc: fsl: qbman: Add helper for sanity checking cgr ops
Date:   Tue, 28 Jun 2022 18:13:55 -0400
Message-Id: <20220628221404.1444200-27-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93d973d9-4565-4a01-6abb-08da5953a400
X-MS-TrafficTypeDiagnostic: DB6PR03MB3013:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DZDCuvLVU9quB/K1nYzMjMbSn/b6BD8UwYhEoapOo+tHyiuF788PUrdW30kRccymZ1Aqxe0rVVDpkGhJzzFDTVbKDH0flprsGIIm8VyGMWgGGy3eFi5lYiJcDy2JCE+S2VMC/sITfWfioTQELqvUecH92ypc43tjQFvv9c2tRv8gycseyI15EoqNImUnhNHCDVec++4eyKLRAxG3czV5h9Jf7sxtB4GfrCIKuv3pnTH/I0ftyao50oY5QlS4SC+r0Pkr/4SERBJatTmWsu/JnwrNyEal5if7uhxG4BKpEjSEM5RnPWlxJNfAPEy1na/YF8HuJm0CD8V/9ps4szHn5B2NEeaXaGBvLav/CHn6rUmfKEBsGXELhZD0XJDf5BtiMbWMWvcV0DOb7juGq5sMMz0vDz8FDX9lWYsNTNtkSCKfKgT7GNXG5ulSst9Qn+R1vk1NwDUzIqoqS4mxP0Ju/I4cK9OzkiAaKDfGQfVcw1MEhWE8CXiTSdjk5kS13bwLOzCbPZeD+wOuVcysZbinqTka99i+BahFQaOYQv6EgBffcr2MWSYOjAoNRMEJI7qHMaL6nzHe6ZB4CeHU0kQZn67mOD05XMQJUuKu+2g0OWxa5tzynqSc1K+WlUEjfk/cZQwYvCPhYDSNYyxShtkd3M1a03KUpNQpQADnspRJX0surX5vKkRiC0Zm9jD9BAwEwLvVvwTd223VgJbVLMasO3gtTWkHvZJNQU7Xq8vpV1X7Y7J0UWvjWSUpRHwNYsjU32LnNtDnO29E2kYXXMMnaytbovrwSq0/yCMb4R5C5aM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39850400004)(376002)(366004)(136003)(346002)(2616005)(41300700001)(26005)(1076003)(66946007)(6666004)(8676002)(6506007)(6512007)(52116002)(186003)(38350700002)(83380400001)(44832011)(6486002)(8936002)(7416002)(66476007)(38100700002)(2906002)(66556008)(86362001)(5660300002)(54906003)(36756003)(110136005)(4326008)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vEaaZh+TDP/XLv5nhIatnHtaCQoFVe9ISdIaEGKqina4pe4WCU+zo1Y3M8aN?=
 =?us-ascii?Q?bbKbtHFWmIYWMGWftiyZfTXr2XAKPxcsA3HcG8QHuxByCUPTeEtPCoeErOvF?=
 =?us-ascii?Q?HXPYiNbMn2fM3pbWQ6CnMKSvzVl26H3apj5/xVzWyeUQtCi0yP1+Um6BIZdR?=
 =?us-ascii?Q?NhdrqGm84w6Zg9k2/oknnX0VtT6EoPCJjYKKda8o95+pYFoR9/O5Dhjr0uVW?=
 =?us-ascii?Q?MS2IfgS7iexjwAG8zTEAs7LR4Q5W1wpEgX22ObGxURf8eLokpEK2Rlc/QW7G?=
 =?us-ascii?Q?D5QMoJAnStOO5oR8YyOlvWgYcViBTTqzv3oKGP3UKFhq13uaGDSijhNYstw2?=
 =?us-ascii?Q?EMHw1Neyivs8aMKeO6jQ1c1MikZnpJNyp2UCUbVs4gBFMh85dskXPZQFqUVt?=
 =?us-ascii?Q?VuLM4gZfc8RX0bM/gcddUvpa7TTGLEQ3+Ezv7MSfJedzq0u7/PEgCH4IOQ7T?=
 =?us-ascii?Q?vYcrkHRj3FLQG2vyL+7F+r1BJ2GuMpw3V3pX5zp2MuqbgpKK+vft7O4vB/kE?=
 =?us-ascii?Q?1xV8Evhf1LSynnQN9ZDcZe4UONHix/GJw8W3RpVtBkwQ4Hxk55k7DzVdnhDl?=
 =?us-ascii?Q?n78WqDM8auEvPYbKT0OZ/3B5Q37VlrkMk15bKWhLETGdHoThukRS8tfscUwU?=
 =?us-ascii?Q?AGH8uCmWAQfX49k5B2OPmcT0u3PzH5l+uk7SG9WCSiPdh03QCUUv5H/z6AaN?=
 =?us-ascii?Q?CahlGI7WeXkI7KISxeV7gYAbxq+6ydEPQAE3lgc5o/heTAUuofE+q/WkhSvz?=
 =?us-ascii?Q?3C2g5Z7q8tef7wi+EerxVSxIez8ds88SApbzDGnu45UDAosBv5sXvn6KXuVW?=
 =?us-ascii?Q?CNIETyVlZXUN7dnW0mM9rA6kUXixohVqBuI4gJoWL8s8tO0u9DUv/pt1uegZ?=
 =?us-ascii?Q?um5gZhBQjvP3kOR/4QAiil49/CffjG63S5neqKAhDK/LonVHFsB5Gv06VDr5?=
 =?us-ascii?Q?vJqKag+EOSR1MARhfrPVreP2pa742MPHsTmF9wCawrHIcUKBZ8uNAMYLvOYj?=
 =?us-ascii?Q?wsftojjdMsoiZN21NKSNsCDWMJbMWmZDxtyAIvDIRe94a04U7UpA7G76qKxY?=
 =?us-ascii?Q?cFs5CB4egLc8lj6ZC6yzADI3s5BDn81AtNCcsst1Ry1i7Se34YMVDbRZOWAp?=
 =?us-ascii?Q?yJQiQb8v4dreTu4ypyyL47HSIgnxHyjJnqtfXpZS/Pf/7ojsS9jQ6C1USD7e?=
 =?us-ascii?Q?tEeZlA1uLyGVYDpGzHTfGZ3vT8/r2/7fJVZVjp+eCm56Ef8HvaPpvBgopsgB?=
 =?us-ascii?Q?di8H1QllHem1axm3mdlEQQGn9laENaHjDupOAyaziythMLwiyVyivXLaWyl8?=
 =?us-ascii?Q?l9F9DAxyrxXvTCqMdWF8tQyzx9kgBiiImEdWiI1mwoBNa6NMPzjmMmiobEGo?=
 =?us-ascii?Q?G2MMg2xnweUM7KGu2hZC3ZCAoi9/cuc8ksG3HyR4POou2k+wiyL9xIbQko/0?=
 =?us-ascii?Q?5dI9iWI3t1XFSg3jabwZ9o3zY8hxuUVUWQFGt/CcCGTDBFn02G3zALTd5cIl?=
 =?us-ascii?Q?SCpqjfQMFnQPgceWSm30wHi9LwJxBhPPHcdTBB/hmRvXvEYqUEr+OjQDLvC5?=
 =?us-ascii?Q?WFFx6hudD4EtKvhEDF07dCsmNkb60KmoFWlsB247cbH6vIGve1BL2yCK5Fa1?=
 =?us-ascii?Q?Yw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d973d9-4565-4a01-6abb-08da5953a400
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:59.5776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +RTihn9HhXbNTCTe1f7qWra6EFBuP5fI3C/lQI+bVd15/npLqHdcZAV4pi+z9VpTbCumvcGREJl2bYMJ8iJVUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3013
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This breaks out/combines get_affine_portal and the cgr sanity check in
preparation for the next commit. No functional change intended.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

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

