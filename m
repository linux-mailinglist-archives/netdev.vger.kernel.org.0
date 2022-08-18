Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55F15988B8
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344251AbiHRQVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344775AbiHRQUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:20:33 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150082.outbound.protection.outlook.com [40.107.15.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AC1C579A;
        Thu, 18 Aug 2022 09:17:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEZx3KX7xjcjGVJNcZK1qRTxPfwEM7SjPDRAV8XPf8Ufux9HCxDu0urmbsSC1rtzSxXnQzNSEAtvPVyVccRgqFS0iBUg49Y/rhbR27AuR0Hg3vHS+9RwuvMfpWWkYKRSZKISnRYmgDJIxMwyDIW03QFpNMbn05awX61L0woU7Xr03bF62j9F32eyew3TN72OUsdQIpLV5L5139pCp/UgSF/zAj/9tXfJ0HjQjJOCi4dTauetigAc8bdSCkAS5cHAS/j2FJatb8JRlbIPcfAnd7EHuOhNrrgZk80UbOjJVZkQnZo4+eT8AeXE92CBvOgKpj6takDdQsi0IB9KS1S22g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F9wh0bRuhapaBW5PoYNdr8D20ugPy+FDu31lyvMXzPE=;
 b=Y5dMazuMB2iv/6a/rvXwQ8WUL2MebUyFWXVhRkFjraSbVAJUwZdwZoNrT241cIQdf1XK14l0OBNIbpbUdqlHThngQyl0b2SEyoMgouVwJKTOkYHuHGwR8ORWhCsRX6iv1sO54vA7tXKpu+Fu5QV4OfMjv0wTW35ZYpWddBFzq9HSNFXooeTU+69ol6P8qWrRDoeI7ryzPGUpDfzBM/HZGgaX1LO4jWzofEKBAZGnPux0u/pRGqLTJPigzCWq5HFpzUqEwfQ4oImjEKtRKqtm2BV8banBDheMmGvPGGwcu5uBFjG7m1p1sHafLfQNCP2hRXx3JFzcruMyuSVISGMEVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9wh0bRuhapaBW5PoYNdr8D20ugPy+FDu31lyvMXzPE=;
 b=WeG0W70gOZKNyZof0r5EEawoiwfegN4ggzsEs+Lv45hCxz1SslRbQc4q8VgIeFZVvkF4gLkoFdk+Bywytjjmw1ckb8EvVniYKpau6pi6BjPCjxEM0ROu8QOKTVdVHbNXhDcezpNkBQypNEw5gd1em1TIsvISCOzvAl4LiCyH1qpbJIBWsIs8Mdp14U0P1lJt92ldWI5GSzpXTivx05NfS5k2mSC32CzdBphbRU95bCyh8C0mOqCpHA3pdIxWnD27qlR8zgElJbful5NohIW59b+frdPN9J/tFpw/e+23yM4egQCysvmjlB5liYp4rgP3fN5GCzceTTpwCoauQ93qIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5621.eurprd03.prod.outlook.com (2603:10a6:20b:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 16:17:42 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:42 +0000
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
Subject: [RESEND PATCH net-next v4 24/25] soc: fsl: qbman: Add CGR update function
Date:   Thu, 18 Aug 2022 12:16:48 -0400
Message-Id: <20220818161649.2058728-25-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: f07e994c-f2bc-4a01-8072-08da81352db6
X-MS-TrafficTypeDiagnostic: AM6PR03MB5621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6dj8G9p7Xx1kjjMU0PUT8xTYUPsgrizqp1rOftQeKthWkvtMyH8IfnIr/sMy+b+s468f1cdDT/YB7evZi2tJY2jWU5i4SLP+fHRAezw9ZJbXnPfLYFqpD578pkX+xKad/a6hZUPPJjRHHYl+7FHmmc4LpvnvxpahEXhL4kv95P1amhUW4H6nKe5iRDLv/f7AlMa6Nr5l/ZOQf8BmfpDRH2VpbgCS4CtTCj0PvNUvqa5lv+cE+CRjkkV5om0AH1iEjwz5wf92bKTrUtERNyTGvTZRfBWM27pVOEzKQhCzHSj4TXxjfRAHbdvTQNxzXlXRw1bSBLsnZBcU+h+Ah9d+aYEpj/60IqnioBEzDU9KrDfBxkgmSKWQ0b53nOBJhAnTUET7NdW8KAdFtEfAx7FHLJhfEKkAusLPA2WQNhukNHjkoqwmzpjcW49v8NahsV46lrVb76E17jaM/4Qr+p8EJOBy4OmYm94+jZJc9CBfuC1Pi47YFwYsLLX/mhvz+7pk2KQX1n42+qXG+hJaIFeMr5g5snZQ9ppvip4W/0+x9wUcvzC7f4rwe24BGAoYLApEo8S8ZKACt6tQJekRWX6BXw4ABx/IxRhM3lcDDoYifVcHvTq8mZTiU+8ip0rwlF8sX9CH+dil+tZmFE2PuXM7x5sv9RUHxJ9HpZdxcChqOYp8akzZZCQBXP0cduL6QCGXO9dWaZ8Ls7uzE0tj3dpVd3SfodACiUvrfrPq9wiH9L0ennGy7gD9i6zleDBOWeyzxw+IoZ28NwUwRL5iXex1CA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(396003)(376002)(39850400004)(41300700001)(316002)(478600001)(54906003)(38350700002)(5660300002)(38100700002)(6486002)(66946007)(7416002)(110136005)(66556008)(66476007)(8936002)(44832011)(8676002)(4326008)(15650500001)(2906002)(36756003)(6506007)(186003)(86362001)(26005)(1076003)(2616005)(52116002)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u8ZaoRgA7rQStUS7isG/m2NjeBYuMmQMjIkZZCntrDyIe6xuE5RYiy4/MUil?=
 =?us-ascii?Q?kaRCwoeTHl7oKB+oePnzOnOgAQDLtqh4ZswUZLxYz3FdA6ISeg7QtLoOeZ3Q?=
 =?us-ascii?Q?t6tn+mE/O4spjD1UWz2OpVk2sdvjfS9p864xtRxeWMSTCSo+UUMS+G3okq4g?=
 =?us-ascii?Q?vi5YCsq8NvZURvykRJN9SxBgH9zHtWSXvBBeyxiv/u15+l2nS9bvDY9RxuPY?=
 =?us-ascii?Q?gQMvTAy11UIO+wqt2Mj1gBKm7WQpmMkrb7QxlBD3YsBO/WA9haBzCKUAvi+M?=
 =?us-ascii?Q?Q0pLHEcNy4EGj300q1FZDbLCkEI69MA4t6NUlJzWLLMxa6jYVrx38WdcOc0y?=
 =?us-ascii?Q?RUIzQ2Ow+lz7YnW+VGbvBCYp0hi8egQ88eivckWkrIasRgJxvzjPSv6Lc8Pa?=
 =?us-ascii?Q?2ZyQ3kyyF0sXd9/y8IdGpCjGFr456j1vFwHNiWv0gmLa1qLmpkwgOcEkDWGi?=
 =?us-ascii?Q?7oKe4GuGffeSjBZO00ffdYkhGOcmlpZkzwqcET99jofsQnMT9fA1CDK/EAfk?=
 =?us-ascii?Q?pYTXsKHieedwtRth03MaVj3rt2TuYPkSoZUiq1RHeHWGFu2/4cphkt6UD/DJ?=
 =?us-ascii?Q?KsgT2djZxZ5JO9hbYUiC1PvkXV7jCjzcGPT/4d2xmkAMUYyAwrLySG1+Ddfb?=
 =?us-ascii?Q?zL/WsmXMeG5hz9IcxTPCc6vfLVX7Zb5f1IwWSfh56YS09tSuOevUbLTuNWko?=
 =?us-ascii?Q?hMn55fLYp2+phwNnPozEMkX9VUUxFns1oKhoY6GuYkk1rNeOtuXJk2xZV9x2?=
 =?us-ascii?Q?Rb64IhNRID9ik2ndrTMVS97ygbWAGTLOWs1roKxDOzErrafCp6psRdcsGITF?=
 =?us-ascii?Q?dyi8W4I00XwbC/Rs+vpDP4B8QRrik2MekTnlN4wF8c/ZNQcqRtGLVqRlYbw7?=
 =?us-ascii?Q?P9Vi1yDauFCWydECiyFnqPNlIzzpiBVPH9FW6GhsaYG97qdSXu2G4ph199XR?=
 =?us-ascii?Q?Ad4wm6v3wcJvgKWBRXl6vA6rcG5OKgosnC7c1B2xNNFcjjdFwL2XGfEnhVl0?=
 =?us-ascii?Q?uxqgoCVHIlzuipQ72a6JC7lQ9vZAVok1N2Izqcruo3d9/VzxS8LJvExK0O8/?=
 =?us-ascii?Q?Y3jHgVg02wfUmR6Gj+r/kYX/iWD1eiTXg9N/HNqQzfJswv+NGDQJ+soL/O7U?=
 =?us-ascii?Q?renf4MZVnYh3qmLeExE5/nbb7yYlCi6EHUpTWbcYRnSaoCCN3YOTdJ6et2T+?=
 =?us-ascii?Q?lqhcPFbg37GLfP2LPe2P8FXR8LaDU25NuVNMJeXTECGIhEyUDd1+kK7UB458?=
 =?us-ascii?Q?VnaiTRuI3PDLk91vouxam9v+OHSXJOPJ1rBHWiDuic+jmbGJQ6m7efjWPOPV?=
 =?us-ascii?Q?WlxZR+VsISOqSLtA3dNUbFcumLkXQhFHNlje+L6k5Q9S41qTNbm5MAaedkF5?=
 =?us-ascii?Q?WW/OJe5HOIu0UHkXrBkzLH8ecnTOhcIAE4ompUX0+26mKzuHCMTmW9zrj4+H?=
 =?us-ascii?Q?sqOocNqYUf9xHxEaiWMmHNUwtyFMIe6tqJkSnFC/BZ4X6uAQw2QUNXfSEY3J?=
 =?us-ascii?Q?DINBOkxey7KID0uLASA1RV3FtKrImpIRDbHSSbxPbdckgY9A6vZ/rm4xZYVd?=
 =?us-ascii?Q?gmc6Ax6R7MZVIvduFzK/xAOkjIYkg5fJscnFmlEVsIGiVdaCOFPhognWWSeg?=
 =?us-ascii?Q?ng=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f07e994c-f2bc-4a01-8072-08da81352db6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:42.8250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nju4vEsqRIdsl4r2EhsYLDXLJ7N8grLZBIcJBn2pKenF/CW2oe6USd8lnHMkWrIQkYphU75tz75qzJRq7VgIFg==
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

This adds a function to update a CGR with new parameters. qman_create_cgr
can almost be used for this (with flags=0), but it's not suitable because
it also registers the callback function. The _safe variant was modeled off
of qman_cgr_delete_safe. However, we handle multiple arguments and a return
value.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

Changes in v4:
- qman_cgr_create -> qman_create_cgr

Changes in v2:
- New

 drivers/soc/fsl/qbman/qman.c | 47 ++++++++++++++++++++++++++++++++++++
 include/soc/fsl/qman.h       |  9 +++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/soc/fsl/qbman/qman.c b/drivers/soc/fsl/qbman/qman.c
index eb6600aab09b..68b825ea10f1 100644
--- a/drivers/soc/fsl/qbman/qman.c
+++ b/drivers/soc/fsl/qbman/qman.c
@@ -2568,6 +2568,53 @@ void qman_delete_cgr_safe(struct qman_cgr *cgr)
 }
 EXPORT_SYMBOL(qman_delete_cgr_safe);
 
+static int qman_update_cgr(struct qman_cgr *cgr, struct qm_mcc_initcgr *opts)
+{
+	int ret;
+	unsigned long irqflags;
+	struct qman_portal *p = qman_cgr_get_affine_portal(cgr);
+
+	if (!p)
+		return -EINVAL;
+
+	spin_lock_irqsave(&p->cgr_lock, irqflags);
+	ret = qm_modify_cgr(cgr, 0, opts);
+	spin_unlock_irqrestore(&p->cgr_lock, irqflags);
+	put_affine_portal();
+	return ret;
+}
+
+struct update_cgr_params {
+	struct qman_cgr *cgr;
+	struct qm_mcc_initcgr *opts;
+	int ret;
+};
+
+static void qman_update_cgr_smp_call(void *p)
+{
+	struct update_cgr_params *params = p;
+
+	params->ret = qman_update_cgr(params->cgr, params->opts);
+}
+
+int qman_update_cgr_safe(struct qman_cgr *cgr, struct qm_mcc_initcgr *opts)
+{
+	struct update_cgr_params params = {
+		.cgr = cgr,
+		.opts = opts,
+	};
+
+	preempt_disable();
+	if (qman_cgr_cpus[cgr->cgrid] != smp_processor_id())
+		smp_call_function_single(qman_cgr_cpus[cgr->cgrid],
+					 qman_update_cgr_smp_call, &params, true);
+	else
+		params.ret = qman_update_cgr(cgr, opts);
+	preempt_enable();
+	return params.ret;
+}
+EXPORT_SYMBOL(qman_update_cgr_safe);
+
 /* Cleanup FQs */
 
 static int _qm_mr_consume_and_match_verb(struct qm_portal *p, int v)
diff --git a/include/soc/fsl/qman.h b/include/soc/fsl/qman.h
index 59eeba31c192..0d3d6beb7fdb 100644
--- a/include/soc/fsl/qman.h
+++ b/include/soc/fsl/qman.h
@@ -1171,6 +1171,15 @@ int qman_delete_cgr(struct qman_cgr *cgr);
  */
 void qman_delete_cgr_safe(struct qman_cgr *cgr);
 
+/**
+ * qman_update_cgr_safe - Modifies a congestion group object from any CPU
+ * @cgr: the 'cgr' object to modify
+ * @opts: state of the CGR settings
+ *
+ * This will select the proper CPU and modify the CGR settings.
+ */
+int qman_update_cgr_safe(struct qman_cgr *cgr, struct qm_mcc_initcgr *opts);
+
 /**
  * qman_query_cgr_congested - Queries CGR's congestion status
  * @cgr: the 'cgr' object to query
-- 
2.35.1.1320.gc452695387.dirty

