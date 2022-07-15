Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D90576992
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbiGOWFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiGOWEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:04:04 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00040.outbound.protection.outlook.com [40.107.0.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B498E4F3;
        Fri, 15 Jul 2022 15:01:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fuk5QLLn7JFCl8+fEkpvBJZmKOsqW8Mfqj2BBlRessVsEFfq13wHUOzd37EULdd0HJm6UMAZHZnNDP/XSawAfD6mE9F+syhj66pO5KxeY/aOgNr27loeR08QLKY9PiFeeP5AK0/uqsishLwzyuxqtUyOngPx7dNcmA8F7lj6pxoI/ZCsYQjzj4SxzehwpO+sXE6C8pIsybz1z3vB4YzZt1hlZM964TWea8gXwzO8qoVbsdz4gJkxT2wDqSyAdjOSkk2MBOqVqdwYxFbski83f+atu1awQ+pSpe9gzA9xJaTcn/sqXDgYcNi0aWD3H3FYEv+Yy1PusiJrpRJb6gGmWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPsbQKyAEFveniIQIGzCajxgm6x6C6iIBd0jdZ0YqxI=;
 b=gKWmh/zlghRzIB0MHABJl2Pfl8K60+avNYCi0udSI/ehRbXEZTs8gqHFtPU2sMYypwfaMqdQ4HeTtIBUyVEHZ6v/3SpZkopa/o+iBfcFmhfjdjDvNxwkMcADaF4mr3PLYMM2jwIUlmAe+/W3iRjunUwqmPsK4Rg2FlyrG59oPD6bIcVmCd0ISzT7qnPj9NGKtmYY2AvrlFOD/teaZXvtPGhTQyCsqjkAnOhGaURnsZUb9Xz9utamAvTwqBHslybqPnXZkXkxdH1AvLmgmb/EiEuWLlr1/09RikuvY7l2/C+3hKTQ4y9TO6etW1PwpoPABGLXemRj+JwcCnbZ6ZLTng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPsbQKyAEFveniIQIGzCajxgm6x6C6iIBd0jdZ0YqxI=;
 b=OU+anSSteZa//yr3QMOH7a+wIEKxa/B/7euTw43UdmABwvy2fRVI7XgWabChwRQ1U0OXRe12xbXM35KQ9TA3Bdct4fcn/fZf4VEZyvcKq3v/37ebL9ZMfHHPq4E/9tPkKQp9EufOJy23wdLSZxTq9t1QwrbUv95nmDe3lHnZOyMTtvINLMKsvvQK0Kk0IBxC7P2t2YZjwowQHAzrDhdkTStfg6GxaX/QSzmPB5pYsFYIVfFktJBAaW3MS9CBbK9yR4K+15/Ser5dHpoPNApcl9hAnitXZFHPlW/L2qb4smOWMtivkGgylHpfLk+Mft7miPf3Ej8fUhfOQ5WBw3Mmow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS4PR03MB8433.eurprd03.prod.outlook.com (2603:10a6:20b:518::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Fri, 15 Jul
 2022 22:01:36 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:36 +0000
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
Subject: [PATCH net-next v3 37/47] soc: fsl: qbman: Add CGR update function
Date:   Fri, 15 Jul 2022 17:59:44 -0400
Message-Id: <20220715215954.1449214-38-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6822ba15-bcc2-4d1b-d5b7-08da66ad9636
X-MS-TrafficTypeDiagnostic: AS4PR03MB8433:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uCtOErf1Kl2GPkcKb26DcwHzw5CLjaFdLfQkZQ5K8kzWSX9V66FGMqvvaQs5k3NMtLiQIdmPojoTao4aftOZuv7IJ0XzF2PfGfqaDfUqcHyxHsoPpjB1jp2tcajG/WCQ1WUK53IBIKWSGiReQl0/GdC6LA3XVX/oFlDluS1+VkqzCBDII5mnwHLJi0AozQ2HqWI3o+ZAiy7YV9uvhVoqE31EI2YaWcnMcMbiEhmE3i+bUrmG5vo3C//wNEa/H1sgU6eJa+RDuJ5sOS0QTzaq9Z+QQkKPb46FKWPpKx2YVJ5q/PQpc/lrB8vVpyxu/UCR+fP7O3LnAWVxKPDZcAmVRMFYfJpMkZ/m2g3gp5k1JNXrBY2H/Cl/mUVgEcuE4fjccfypjam+H8fHTv2R8KgTyvdXoeTpbnlX0AlGEPeavKgFs53tuXftVACuecG9FZY6uZc0hlT6uuqRczomKNFwecgtUlLMkvZA0VEGmFI6V7wuFgAVxjSeryBkvCMjGBxl2iSesyZSxbA/5bWIYL4aLmrJtqPFlwNbt2SEszJqjY7fMnuIiONu0k+zv/gezlFlmgW0HPSgg96LUFRD9O7NFrjNeLI/wVhNKH6oyR1YOdsQoAGBlMVqZxIpfGboYgJihEmajZNTxdVjDs91V5LnXL6zj9BCYaRMvz3cCp+5aTHa4IUd+TqyYV9wUyFKHZEuxSIhYWL8U/H8up6Q1OiQDsEiYiqlTp8Mnwk2EYcr1wjBjdFjUYCQR1bQiIu6+bGq7Bwa8ojR+hAjjNrMUYGhZdrOqKA3C1VdWLuluD7KwJk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(39850400004)(396003)(366004)(136003)(6486002)(478600001)(86362001)(6506007)(41300700001)(6666004)(52116002)(6512007)(26005)(83380400001)(2616005)(54906003)(1076003)(316002)(186003)(110136005)(66946007)(15650500001)(2906002)(7416002)(66476007)(4326008)(66556008)(44832011)(8676002)(5660300002)(8936002)(38350700002)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9dqym1mDB2M6tFNK3Chgp/tTI2b924Byn0MkKv2VQ2xdENtU4zlAzn3dQWMN?=
 =?us-ascii?Q?ldY87uJVfmXkBwohPhFt/GSNK9Lw+ESnl1cp+ZOm9wTpyfnhnLF2LhgQg3pI?=
 =?us-ascii?Q?RWV3/JhxNOjonyBy4sfshcphkTP5Lq2kEO25ceue2ITa04QtJQ+9TBdpJmDi?=
 =?us-ascii?Q?NUN6yLHP6M8l/HMCk1AoPNiXLR9r7/1HHFcQcHBLExJ4IDDgd750I0xMNjG2?=
 =?us-ascii?Q?cdpleTvbAnpxJJQttUrXNUVLvfW1VIei/WQ9T2R2stkQbhgxInj4jQF6ZaEH?=
 =?us-ascii?Q?GV1c53ZaG3Go/cF+hQI/frlUu+n029qKWmsC1JSWf4y0AfwdjZ+0VzfdHmVJ?=
 =?us-ascii?Q?mLpTcaxpCK6wt5/BvdvdioYjZYMPrr9Yvyt2hlHGQPiMzmTi3vs0vvZ2gqh1?=
 =?us-ascii?Q?enmlfsmZJcFs0Rgdbvsf+NTmNqkIiGXb6pEPu10pme6hcnvviIwp+NV+LOW+?=
 =?us-ascii?Q?nc+z4yZNkkBP1I/+CF/LAa7UXkrAB0OZtX/h2gVX+GuWsnxOaCs+s5pzBh3z?=
 =?us-ascii?Q?SbaCJU8LGF1aalC2fBg/o1nf9OY04C1NQvrG1YODcssQ3ujzk4J3dglKL91t?=
 =?us-ascii?Q?7Qk7MxJ2xpYYi5QfFb4GrhwLiDlptWJkUEX+nbhNK+1t/YjFULuVxqJZCtQl?=
 =?us-ascii?Q?5xSnYMjQtBKGDeFOwm+b2SZ8FRKYgpRhPL3dsGoCqmoIk5oRsFvNtvNgSzb6?=
 =?us-ascii?Q?9emeQWezBaA9DCJOC/bpQKjNjM4/2OfVam/sMkxOSDMuf3VdQ4tN8n6ae0JQ?=
 =?us-ascii?Q?nPgDdSyVv6cSl6H4hC1isYH+u+xAgyIpRoX8zts7xoELqheN/XTT+bgKKl9M?=
 =?us-ascii?Q?TbT2Ww6UxYZLVrvDFpLSNKqUDHRtLM451b2gt1UymK3UfYviWpxD9p4B7NwN?=
 =?us-ascii?Q?7DLAK6ffxdWc4JlcpJTLGC/b4hnwQkGBJvY0DUaF1TQm5bUSy93sK2Zv8iMg?=
 =?us-ascii?Q?ksADC8S4SaxOGaxuJrnQqQ52Wp49ri1uiNiWD6EuSpFODaKrTH5IMVL47iWQ?=
 =?us-ascii?Q?icqMlDkeSGZC5ojHRoVwnSRzsdvbL7yovcf3Ece6c29AyjF42rc2DDE69bsf?=
 =?us-ascii?Q?TjjIQHGXvS7FBZ1llEpAtVir8cSVuW+5FeJiSgHjzhf/aFrdTBfblNd7JY4N?=
 =?us-ascii?Q?nBgry0IuOCpc19f586khtHH4uYvrV4M14gVHvXXWCUw28ZXlgMCqR6t90JTo?=
 =?us-ascii?Q?k8T1Zm82Gp7m+EfiXCTPZX9Xayuhz/TZr+vCtdtlmdDV/7AiPM32G1X1Rnsn?=
 =?us-ascii?Q?4Cp+WlmYmtRETXqW4M+XjebLvBDDqFc+jWenJUQpUs/anqKNMugRXQs6y5TZ?=
 =?us-ascii?Q?LLKscyyJZwxwPnunkZH9OEJ9fgD2YY7/0Ltk1iiPlgp3NjHc0FGkDBi0pBIP?=
 =?us-ascii?Q?9SNIxdP1uo0+jD+9DesWl6UYRpA2scl4MgePCiufAEKz5dZhMrzWSaiLc3Qc?=
 =?us-ascii?Q?mWsaquQsbNzNf8NaTHX41MJunkmpRLVnwzGrnSNXh4OT/B2pTH90IkMBPhPo?=
 =?us-ascii?Q?fR5OxlIMyPs131DKYhEYjRciwciAcfmJCPimDoA7+ZwBo5yRRZ+/w1N95OT5?=
 =?us-ascii?Q?vSUhkyXLYGFZUzBO6pLhQQeWJ51QoHi1NRRpgYD+dGF6gAo2e/qGajokZEtf?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6822ba15-bcc2-4d1b-d5b7-08da66ad9636
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:36.4085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wLOtwNEG8gYy2EOtDVGVn3PZXQCT2pYywdA0lhiIcEJZ+6pQ+xNT6+pq55EmyhvJAzXW9y2Q8blLsPQc+zDDiA==
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

This adds a function to update a CGR with new parameters.
qman_cgr_create can almost be used for this (with flags=0), but it's not
suitable because it also registers the callback function. The _safe
variant was modeled off of qman_cgr_delete_safe. However, we handle
multiple arguments and a return value.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v2)

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

