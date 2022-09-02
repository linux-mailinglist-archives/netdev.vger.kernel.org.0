Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541835ABA8D
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 00:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiIBWAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 18:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiIBV6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:48 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150079.outbound.protection.outlook.com [40.107.15.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2625CF824B;
        Fri,  2 Sep 2022 14:58:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HacGdyYWBxZQ1OAEFThn5jlRqd6PiUJ1g3riSTBIZ+OJgsMQQe5ACN7pI+GokmLuuYpbF3VySiVH/TEal+cOqMQMR6hooWnGj4d4egZzKU/DkyJq1Q1vMEJYj/EhPoVd+kbFFpqtWjj07HZwrUFYq10xA6icTV/YWpb6fJVihrZgHMXxctAdZY043lPoCK16AG44ssIHQVRNJ7mPTYuV/pPs8FyD4YwnpUHKg3ccBHebaM9a5kHcVjw6uy5GukmxBhDF2TP6eL4pJqB1YDM8bfPr9VZx4jUe2X8NIuXWXLNutZobSLXeA40LJ/tkSN0nQxKwaWRZxDKOLnWrOtHMCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Vl+X+CzEIoTOyrwUa6t9RkbFIR1sPkScboy4MAV6lQ=;
 b=dYCgeCS4EVgDhESjtDfjZkNK5b3E1RH8wrB+czoYr3/XhtOuKJUwq6MuvhT/zL9Spw9WhNuELzmfQujznnVvUxsTg5O9J0Co6mOMA11l23OIG+iDpGiuOxtgRwvgwAn6f0PMHRDAt5+ULKMomZVyxXsGy+w9RJ6IlZojgqiDITy3JrKteUlOad1ZA4ghY9fqjYuLcGTKpRXW1HDTFfG5EmOspAFUWsDIEtK96imvwWp9iVnwVDobPFTu/RfL19AA4c0p/wUwBve5bd30IOI5/RMIUlxiCVElmsHrUcHudhw+EUIuVp+7ZnmzBAbJ+6ydi357fBmfqfzYONzYIqkgVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Vl+X+CzEIoTOyrwUa6t9RkbFIR1sPkScboy4MAV6lQ=;
 b=vIoWbbikm7EHO6OpEfnhjjZ/PCc7UoqIY+gxK4T66ELBoC2LCFvKrqr6DPN2mfYxTvb2vYmkp7EZavizue83YqczvfKwn9Z6LB0AoIUtTHZ+/TrEy/jD2PQXjhNx/OluzUUazEcV8To5UqFd5nMGBxc+nlpPfdv/n8VjZH6jBGvB7h2c0+9PZBuqOcCmDWG8wVubbaREYzU49U4LrSOayTARPVr9Whq1GU8iN2AW+nHprS+iQtR9XuFrrn+BtdbtXE+S9AyHCoTptGW3vB9Llb/hCMb4pZr/abcqIkwW/EEfjPjXESP3An1Y8YvpzYaulBoepkFaW7pKIk9WE6xDHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:58:15 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:58:14 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Sean Anderson <sean.anderson@seco.com>,
        Li Yang <leoyang.li@nxp.com>
Subject: [PATCH net-next v5 13/14] soc: fsl: qbman: Add CGR update function
Date:   Fri,  2 Sep 2022 17:57:35 -0400
Message-Id: <20220902215737.981341-14-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220902215737.981341-1-sean.anderson@seco.com>
References: <20220902215737.981341-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0315.namprd03.prod.outlook.com
 (2603:10b6:610:118::15) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12644857-848b-4794-eb96-08da8d2e3c60
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dOsuvnyi3F6l02JXJFoAaOsqqxLw6WTPYnZ2RiZs6KK9/PWt56wlu4pSiImP6jockSYdokpjjWMusOxb3rwo9fbTQwh5nwEvEWNStKYlEdkPju5HeBeLi5/vPZMbiiuFFvmCaUtoVxTygDDl7PVWhZ2emLxGI4G8FXZi7YMqW3A2M2/zvRJzzIXpGKZa63lGC/9zzCHHR/nmfL9RisR7mKPG8fCchThvkiHxvWafL0/FECeswIJ5sExp0ND+L7LZY8KWvwyuTIiZ1nlQBKMo1KJc55hbgNASRqWEHlA8gaD4a48DPSEljBDGaN4Qq3nRtEXvHU+exSoKE+f70lA7NjHN0YXrXbWqknCtDIM4TzakVLZR4j8QAl4XGZVuLjAfYvEmF7ShXLgzfYmddUIO60C6yyMd5zmW37Y336qJlZVu3rAFGeJivHtFessk9R3WgLldWbqCgSWxNlpTJmpnGfLfbaQR3eLJP3JnB4oso3nKtjlEqKObyz5/NBR9jxu9/pjQzMcHHUq+ZoTOKZARoCd+xR9mO/plzTfO3Sq2sfF84vI4JxaZQql0zlw1ZqHkC2wUp529hrAYWv6HATO5PA7903PWBuqSkoTAmSiJmMlAAySTbP+tfATm/ln5gO7E0dAu36RVQ+BTH/l7QkJvaegn4EQW8W/qH+y7DB2TloIDBvL3QQidlne92lRcVRO34B1MwJq1IFB9GEsKgoerlBw1WtDIjjjiRqKpYFmP/rzU+X95GEh/UAiBB1GMhvhRRM6omSW+lJgetHqWFIgFnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(41300700001)(6666004)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(15650500001)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WiAwCs3/CdXhQhLDwRb3yqIBDU2QHAb3x9/cdljyPCzqnHbOY+xDv7gcVpjL?=
 =?us-ascii?Q?FAvomKeTPsNndBON+I+v8ML8hw4XdHqrykBvvIB7G/nV99Ri26gGBjJ7fL/Y?=
 =?us-ascii?Q?YLCoozpKBqgJwdSBTQ+3rbhqWcQC8ZNLx/QcHPYfJL12K0CTp0bqMSekeXsa?=
 =?us-ascii?Q?CJt/Evk/aySUew6iVzDJ8F8T9T6r4HNsGF1yfx9O5f+HRpCvuv78dukiJCq5?=
 =?us-ascii?Q?PFTEiIRzoPzgYULSxoO1lcVY/jYwO0gZVyHLPjF9eMwhHxdrQuRatPISF/o8?=
 =?us-ascii?Q?QeGhIp0GRsDG4t1hdthqLgAoIKp+VZdHLGPmJnRfoaUcxZMiHLm5nZOEBe34?=
 =?us-ascii?Q?ufJ9YhHG3zjEPfpA3oJE95KPDujlGeWKGstOW+ut0nbBFoaxdro9VY2wcpzI?=
 =?us-ascii?Q?h2dgC4+D3Slhfw5PxYyAkqm1U+CQq4ZWDyDWGXWWw0t/s9L36azy/kXOFYdp?=
 =?us-ascii?Q?HVQPzYs4JgrKYrxuY88b3anBtNpHgWLBrqEBOFFbmYrsqz82uRoOkxEAO/SC?=
 =?us-ascii?Q?AWVfqXsA8Kda7G2xEDE3xzZxpO/vgpwRZu6YY/xGMKCMjXBfpszYY0w4o3dh?=
 =?us-ascii?Q?77xBsQPYpYL6WqPB/n7xXfCOL6ZXRVyq/jg1XqWw6fsIvhJT58ut8ljsW28m?=
 =?us-ascii?Q?zeqWxel/8700TwXzuTqpa/BO1GysIz7WryPr2R+wPsvRhPqUFuyFO9Say/Y/?=
 =?us-ascii?Q?oB9RfYPcb1x/Jagt/29fn3nWTzBuOcjQ1R6Sm8LGp0w0cBUONUSRvVSi0VWJ?=
 =?us-ascii?Q?qofulStSeDkrHueYRi9WTtgwOh+JRAJyMGbrH9FkRX+VEsvT8RoKEeWG0js1?=
 =?us-ascii?Q?/MzOtNRpkNws5TWLeBVBEQwn/K3cWdxQmJNZjANmnEvS8OWxtdIfIfjXwXYm?=
 =?us-ascii?Q?moUfjduMMSr2GceZd9fLYCp0ygUTzDUtV1lnw/WtrtDxY01m0+aS+Z6Js+I8?=
 =?us-ascii?Q?yujd7yen9bumEvz72oA2T3S8wzyVefW/0A2fE/3bHTvldHrcEGRRnAS+aLND?=
 =?us-ascii?Q?enEUtu0HNGiTRRpD/sTKkZKUKViR41orvw2k3/00rduZ9CjGwHfZq+xj/B2G?=
 =?us-ascii?Q?N+i3pdudM82zG/rhndMfJcBmbEcWN67mUM2qe5DN9dJp/c2vdUVi2XzLS+pS?=
 =?us-ascii?Q?MAn3DD3mazLZAljjBggyzDRLGUvYRw7aZPjLSumRZNOh9JOw/4qniDL/H0ur?=
 =?us-ascii?Q?VgNSRQT9BUVbPOeZUaRa6c6FWuFTYpP2JRxqDteQNVmoff8D/0ZEj285669c?=
 =?us-ascii?Q?jTHHgQdXUCzduhsTouitg6ScMJTYbbAdW4+mUqiqBH5OcPLzRW4/GcJF4BT9?=
 =?us-ascii?Q?1NGMr9t7B66UtR+wwZLhmwCombNv+MVL/yK96M25CRhs8Fb6GLFE8RLLjVnb?=
 =?us-ascii?Q?aiPGHQzT/84Br/r/OGTL3iEsoUTYhNICp5urI2Qx+Gvx5qUNW4bN0JTop34e?=
 =?us-ascii?Q?aZpU9boud0UtuamC9fJo7GiYSmfNRcJxg+RyAjErE0irygieB08hcprPAu6U?=
 =?us-ascii?Q?r37YXNv0+geXHoKKi814jrsFCW8dt/9ZicPUfyNOOxSaWkTLXwPTtW/ywQKZ?=
 =?us-ascii?Q?rUgUiJ5VpE8h3p7jCHxxejNOAirAdCBQS5TrWidxuUs/a39fomgVzUef0RMo?=
 =?us-ascii?Q?eQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12644857-848b-4794-eb96-08da8d2e3c60
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:58:14.9061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ZsIj4A/v5oSIcqaRhQU0BFcHbF+YFSqs9RKpPrekUWGT3vK2cgpz2Uyd6GnhbLUdplwHgbyb1K5PEWCxtdFjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

Changes in v5:
- Reduce line length of qman_update_cgr_safe

Changes in v4:
- qman_cgr_create -> qman_create_cgr

Changes in v2:
- New

 drivers/soc/fsl/qbman/qman.c | 48 ++++++++++++++++++++++++++++++++++++
 include/soc/fsl/qman.h       |  9 +++++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/soc/fsl/qbman/qman.c b/drivers/soc/fsl/qbman/qman.c
index eb6600aab09b..739e4eee6b75 100644
--- a/drivers/soc/fsl/qbman/qman.c
+++ b/drivers/soc/fsl/qbman/qman.c
@@ -2568,6 +2568,54 @@ void qman_delete_cgr_safe(struct qman_cgr *cgr)
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
+					 qman_update_cgr_smp_call, &params,
+					 true);
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

