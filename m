Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12AF58016E
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiGYPPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236192AbiGYPOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:14:48 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130088.outbound.protection.outlook.com [40.107.13.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92E01D30E;
        Mon, 25 Jul 2022 08:12:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNbm3KN57kiFp4D/+nqQ5E0Ye5oQo3ejTL4GFAiMSIFmFwHrMk17YP3EeB4DIOC35tNO70SKvR5DtMcEgWUpW8RzXdUUmtRpfUvOhia4/xkmyXuEtKb8/Xr/TrvXg2czeRUjTv2wjxwQMEkHpdDFTM3R0gg9HFNExSK0NOQHKl0FfN3wKS+w8Ea7vIcEaD9VgtsEmcWwk/R50rMY9UDNd82dRy9UFb3geFfmL2kWMuIrhShnlT4o9dLiwJlwqjef4Z7U/jg5zsLMjEGfixBl+4xlSOZdcTs4o9jUUsGcnSuifAN9ev4cdpch/7gRgh8BxAD9AITGkKzNba1NRLir4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F9wh0bRuhapaBW5PoYNdr8D20ugPy+FDu31lyvMXzPE=;
 b=IjCChOlMfLhau294qQIB2w+owVCJq+s321YA5C771jdLLngzGwgZIn174FwqHrMQPe23Vw9swcoGh1ho8ohC12JmFgN2MDmnXe0tdVaPCLsgMRjeyPTt0bUGJgoO4tzFHMBcdpzHG+3u1rNsRiI93AYGhwsqqVcT47+BeADaCOyx4pE5zUOKqMVjyKaws9cApY78yu2PvM4ha3aOx9pDfXTWib5KYwgkdu/vZ9CUY+4IhLSwP8uKBGrVECnD6Jiosxr3KMKvnfQaP+nsR0krY1YyKtIvJAaQq69MCHe/QNhX8QIGXsGSJVF1NUXHf/xcQIakvcfDHNJ7aTpnEF00XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9wh0bRuhapaBW5PoYNdr8D20ugPy+FDu31lyvMXzPE=;
 b=d1viq9uteUnYi7iMZntXRSFBhD/r4bJLIC1jeXEuTeyjWp7k+0TKQ99e4ap4SiRG+g6oHEo+qaREUWRUbDqwexv1CW6Gx6/JeEdBD9uOII5IT+RFZg8AI3c3ZqgOsl1S4OU90sZxrGXDnoevRoPBOgHqDFGvluVvAhYK22kISQZGSC+f1yxy8wZRKA3pIIpfyUaxFP1vPC86Ri/C5GHZJYXTNDRIpaR2gWSoiKriUU/QBwwzVzOGsQAjD6cgKYpTUeUIajiX6z4WWxBKzvYl9TNXh5TOzKwWNbg5BG94TkooHpXQIzZBtJmg5NkEBY9cGcjgJvYiPI4D04Iw+fVNVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3723.eurprd03.prod.outlook.com (2603:10a6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Mon, 25 Jul 2022 15:11:42 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:42 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>,
        Li Yang <leoyang.li@nxp.com>
Subject: [PATCH v4 24/25] soc: fsl: qbman: Add CGR update function
Date:   Mon, 25 Jul 2022 11:10:38 -0400
Message-Id: <20220725151039.2581576-25-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6d2a981-299a-46ed-145f-08da6e4ffb3c
X-MS-TrafficTypeDiagnostic: DB7PR03MB3723:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: euBQRCzwxnvTpmfnVDYHGBkaHP8EVq9laDOlWDWPoZM6hUJy45qFb+d88TR329LlpASlg9kwAkTrmhgYVmwZxhSsVevLw1aORH/5BweOT1DrrKFY9ORY/qytXIfHZ4Lv6rNrs2CNy9CdwIvhEtUXkuVGHCgnRFo/sl3U32ffGnpsNtf0VaUVPLSmZwE0czCHEvXDj11nzYZ1hT7wuzgx/zUQoBQLASSvkZGxeBZo+m2FIq8gZ2AM1g3sjlRu18b0kqCokX0J1+Go52cRNclcEkS36PJUC+SdanGe38l27vdxmWKKl8pwUtvwExFzOs4SXf24UWDxN3hqvgOgMEBwq2fKA3d9u3aVwaJguthaI0YfNyG/NHbIdEb4RwcSO/yCa+kKVsK1EfG9HpMRqEuKJ8qD/9ygoNDe59HSCi6unGom2qNPhRNId/6hvL+pJEeAq2R77Jqlo/ACWM1jxXUZxma5v+WMuvTASDK4rPi9pdCs+PKnofWai2vpGkUErIsbCywOJqe1dAbj9sdEIxm/0Isu5jbR36mwRDqsm9DK0ivHP2hvkwg0oBqPSzIa66L4KQZjwBTtCRwiVhlw9X7Cdg/dNb4QLdRv6Sn2IgP2OOsInQoCQPig4XbYHSw8YoR8AsNZ5OeYwCe/+mEgw389R+i4anEFTXQztUt0ZFSzVvYvdR9hixUjgkQoisHudzL752oHYEQ+/oQ2BNQHZrsYY4ubf/P2a69ltKFZbRxbYrSoCxbNKaRCDa/LxOhGE0JoD+ZGbrrQSrbzR/JvimQxpmrDep2LBuBaFkssGL4Je18=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(2616005)(66946007)(1076003)(316002)(5660300002)(44832011)(66556008)(15650500001)(4326008)(66476007)(8936002)(6506007)(7416002)(52116002)(54906003)(110136005)(6666004)(26005)(8676002)(6486002)(2906002)(38350700002)(86362001)(83380400001)(38100700002)(36756003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/f5GchLw+zo/VRQnUtT4bbJYPqnRgrpTrTkPxm1ZZJ6LzNcA2RLPKxaYqNMI?=
 =?us-ascii?Q?T1etHVS2oqq4IjgVlqISqfs0K5qFaEAeL2ukFYVSJrUjDE7W25runWKKrn4C?=
 =?us-ascii?Q?AqFqesj1mlq4TgES5qcZ3LDY6Hpwzpkqc1PilU+zU4bbOQX18lza7fuO8c9w?=
 =?us-ascii?Q?7YlxNCDO/duf0P8ocJjFUURQ0WFmfTP94SDBJA0PaQEZhkNuqtvxxQOycvBQ?=
 =?us-ascii?Q?YDqSROdBiqXRsJIBiKDUKUxOgHkcn5ohgXifr5lvYEa7wbbXt6ObKQmpLHX3?=
 =?us-ascii?Q?lCgsv0nbV9NHnB/0alarFaoHiUXjqZPQ5rd5lz9Gp1nHPJ25GBrlgAcLYceN?=
 =?us-ascii?Q?4Zci7cCfBBc7WlRyGvD76qvcHqiYnndCE7jDhirdUD0zxsfT+3o//dKkgDxI?=
 =?us-ascii?Q?Tp4nQU3Ara6iMXNRTvJA3rmmQBXXQjA1dxmY+0Jw1S+rZMOeMRXQbhXi36XS?=
 =?us-ascii?Q?htJaiu0n+suPhHIGxGFJGwYy/KAytir5U5ZOajTiobLqRw7TXqX8twofAzTd?=
 =?us-ascii?Q?oz0iM0hh7SIdinzOZo91+EqSJWueEvWFCK+fOBjG+lEs4x4NfRq8or/zKQy+?=
 =?us-ascii?Q?e+jV1q5hAxbD3fuYnKUZsFyLwvUyJR9ym8L+VqgKmJhFFPw/nQqjGzcSG9HG?=
 =?us-ascii?Q?5wmAl0UNutjAGNv7tP6aWtR0J26TsxaToJhkJSoqweE/21npTdKWLckfPdf7?=
 =?us-ascii?Q?Td7IJNMJ8mzhJ90R9QOc8soSaZw4annh291TPQDe+lE4Etc9fZlJAmp/ltQh?=
 =?us-ascii?Q?glZtKwRGcN6UlxHK8YQACFhF6MRXX08rOWNz+Z4iaaqBmgtmMyPpUKTzjBEs?=
 =?us-ascii?Q?XSLW7ScshrQ6G+8Kb0TjR2c4tdNkyvpkbXuNz0lU8lUEVXnLmRvdSSxyYwEf?=
 =?us-ascii?Q?dTL8SyvZLS9jZ46J4iN//SOi6uAZzuryR/nBYzQvlnl9P5513UmeLEqxUk0Q?=
 =?us-ascii?Q?JsgODbsEMyRQQ3ewtj0wosyYArPkq6KXStm4a0/bhJVhNVtxZlhVR22V4JTw?=
 =?us-ascii?Q?imXuwDT8S7UQXTQ2qtTi5q+l4CQsSSGnv7WbHtN6yQcQKPzzICMSx8SnuYKD?=
 =?us-ascii?Q?Y71wNPpQQe2c6S4R0nUrIUO19gs4vBsLcX8MynuPcYAE1nlM4yWelP87HrEf?=
 =?us-ascii?Q?oEvUQ8wiYNv1irzHWU/KHSPgxP+6vEp3+KIBc9zLbGUxgOsjKSHjAaWlqCHE?=
 =?us-ascii?Q?X2adb6MoAefOSj6yKkLEb/tgt+KS/ijkeGSTxumRsqvuzGbF8NHcas1+cRoG?=
 =?us-ascii?Q?lsCSoBl0o535S2aJFTZJ5eRefNF87jT1NHuokoiJNrlS8H39RiZwHYUs6WZ3?=
 =?us-ascii?Q?TdX9LyJW0qTRl8hyu1wc6dVlKIzMSutJ10HBx8St5L2v9UFWGtVkSgHGZfKH?=
 =?us-ascii?Q?c0s6Z2TW2APIas5zDrYUH6sxIa+aR1eRI5t/TD8t3wbldr3i0IX+Kyfx34cG?=
 =?us-ascii?Q?YmQr/V2BKuGz6dVXWpkvYLZK4M+2JeEwvDtB+rfeXHg6z9H2toW65PSl8r1P?=
 =?us-ascii?Q?5kogQW5mTCfC3Sw2UY6AhXMolXhp6KkWKuau4sCjb7IYAgqP9uQM5aMN5UwL?=
 =?us-ascii?Q?yvWzKY0zEV/5BcQAesv+BGjYs+ITIGoB6TO9+p7n6fliV1SVoA+hgQeP3cjD?=
 =?us-ascii?Q?Sw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6d2a981-299a-46ed-145f-08da6e4ffb3c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:42.3774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHHdup6OzcWyzH80ehxL0rvyGXSAVULX46TrBsX7ge2UmiJ85df2Q/6X9D4cX+Y9GwspTekHAQi8AZY5dICTcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3723
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

