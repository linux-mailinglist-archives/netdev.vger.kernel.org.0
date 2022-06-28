Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0679455F137
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiF1WRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiF1WPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:15:49 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00086.outbound.protection.outlook.com [40.107.0.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5686D3AA50;
        Tue, 28 Jun 2022 15:15:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1QNadcAEOlSekF4vIipUr2WFxdjDIeUo3qxvGjILGoqabBDklp11k6xOj3FfrMyXD2yPUMX3mP5pAFW9dBwO7Fxrl3tigN1kXjMkDlyQJnx7+He/mbeakd5hWRtPivZtKeZ2gRGw27UOMDoLlhyWBeyXEVjCynxK14pEmXudFJHGxKdzi6a/nartleEGAl+PBgtW39tHcGNXyQbvDlTRgpl39+ZzWgcvVyxu9pq+Z3T2lditHazG350PLmfDQ2yKkn1qM3qxAU8byC0GJ/aUep4jj8/kauz4QdFgG0J34yirmkDRuQ3wYG+rvZVI4qQyz04KHUk024OeMIJbuekMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNP1bY9j13KooahRt99sue55XBhKiRQIhLd2AYN0Gbo=;
 b=QE18asQcIS1K36qafQRkQBsl/UOO19QDLgfOlr7hwMnYLtbbNYDo+ysOjoGIEXwpTG7JHiXZfHXUdrNUrRJKo/hzRyDLAfFZ1yTMnoUUBze2ApLsvyHptxek6J87SBT0+/6/LYs0Ef+FXPK3+WZOmVvI8OEoDQFYEXjoi0eqjw1+nogWA8AORwDNNCcHYE8TLF6RItbOacu7U24UhjhrJ1hCqQOZt3EIC63I67izYV2w80sq1TSkvIi5dhrRfk3iKAa9By+5WKr25bDeha1TEISBqRa7VxpVUeKGxQxl4vITPjJnTDf2ByFFmaXziEajuQYRDYl24DSOY3qJeluCcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNP1bY9j13KooahRt99sue55XBhKiRQIhLd2AYN0Gbo=;
 b=Hl+aNusrpwCBQsXTHQ7s78oohkn+MigCBHRxCDq2JSXi/1JHUAB18eoryRP3RkP5HChi0JaxQUxObfn58qpIVoUJ348Ve9lJbC7ELU10SscBOVlt/wG2JjeAOLbaKfVjrcdGZqR7bJz4QFd1EYlIJImWb4Gxp62t2WOiNFbYDm189qz5vuNWntrAqSTsmyWV51bf3JDxjRcvV9k1YCsOriARCYYJtL3ZFSfTY0YAWW/dg3oh5slUjeVxeatelWEAEf7SGrRk4GFAYrqR4OwRuymZRr2uyY/F+SfFE/wpr6d164p0FRG4/EBIfLjLbLRTLkUilS4XjnPtDSdkciRK8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR03MB3013.eurprd03.prod.outlook.com (2603:10a6:6:3c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:15:01 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:15:01 +0000
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
Subject: [PATCH net-next v2 27/35] soc: fsl: qbman: Add CGR update function
Date:   Tue, 28 Jun 2022 18:13:56 -0400
Message-Id: <20220628221404.1444200-28-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6ad23b44-cccf-4850-d1ce-08da5953a4ee
X-MS-TrafficTypeDiagnostic: DB6PR03MB3013:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OJGIvOSzH/z3AR4aDdCnQ0U1piecJEME9y50tQqsXW+gsXxpAucNPHqOgZalvEzGyr0SPtFu6pLj6oAOWIu/4cJyuMlICKwuv6UI6tCXUEzRXvv2dWGnbXNM/K9PkulnlBHwT3gVjldhfJidHoDEobNWoHUHEvOclRi8mL2pOrXLGuXob89bhN8urmyofnB9FKXH7Vd5NRctGZftcvV/W28PjDwRJeD9nqv1vwVekGkS9S/WoeHZyZi0ZjbCBeEj4IpQTiF/deaIehdKfcFwTW+kHmajzZLx8i0pqfJTpzsZh2jEOiYfzDHDfN2oj9uObQ4AyJtAnTe4akH71nRvYLdOrYUoePjueh+gCbBqzEZ55Z3ZVkq0s0Fgdu3oGJw022beFYoL86N3qtwNLH606ione3BQr2TxNXXiKLqgXXAt83u0noTXKKch2/Pteh/IriXxH2McppvA/QKzT0C4RV5EnSWqWN8hSA/P8o579g2qHjurdiLrLbWpWWFt3QZcOi4qm9KOky0GZrAQ1HpwJHAme7WfcKD6+6khMnBF88FYqxDSpuDPWDTZM2v2mW4hCjJn2ynsCWD8LzYVgH7dSolzskzFdrciwwpYqORqL0Hg0jdcO2pr9QOcm/U56eTU5BU5HVGu9VKuc+yxLTMktSe26cZZSviv2an3XFVXXokX0D/sV700kp/DbvTTGOALpUPAT0dasHsPzOpX01MiMXwS/D4NJDSjNHUCQJ9sj/ZslmZTZw348uH8ucy/cdUPYMA5XLhet551HTLktyXMMb2+PZ8obVpZrwrGPaPbZnU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39850400004)(376002)(366004)(136003)(346002)(2616005)(41300700001)(26005)(1076003)(66946007)(6666004)(8676002)(6506007)(6512007)(52116002)(186003)(38350700002)(83380400001)(44832011)(6486002)(8936002)(7416002)(66476007)(38100700002)(2906002)(66556008)(86362001)(5660300002)(15650500001)(54906003)(36756003)(110136005)(4326008)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hPySJtsRJqmbdkYkIWcuBWONSVpxZv/7v90mg61CBAUcsALhiMWzae6Yv2si?=
 =?us-ascii?Q?2uRgDJv3WEVoJa485y2KD2gT4D1PwKY7Pa6+JgwpR+MHjCb6RKrhbf7TtMyp?=
 =?us-ascii?Q?cl9wxK/GQuKcSkOZml75wsitzezYsnFQEqz4PJAiWAVRkOPiNiHb0XOGU0Yn?=
 =?us-ascii?Q?uDh+bMVf3UZ9O9AJuGveVm7D7fU5WGv6RNBvvDA7rTuChzVagNAt8VZqQoJv?=
 =?us-ascii?Q?C2PSUHgUEa/1+P90h9sQ7F8Owfoe5QmJOBM/AbP5JpJRFD1xaNrQ5oe1HbqO?=
 =?us-ascii?Q?c5xfU1UJFR+bY9b0L52OqSMo1n9POFLBBDXpv2Qi5BedgOhgun6dcOCo6waA?=
 =?us-ascii?Q?Irv08x9B1I0c1rTkNqfmrcd0Wn96QyBeQuimzdaV7bBTHxVbDK7Ea4OWvX2q?=
 =?us-ascii?Q?iM2IlpLyi1kZpj9FO2Yphoxb29wqfR11by8K+VkT5a7n0Xc3+A+UCtjvsRW0?=
 =?us-ascii?Q?y5vetRlXpBbX2x0ZZjwlSxH3OFpmmBUb95SHSYrJra1e7vsZXNAPw8cPdY+P?=
 =?us-ascii?Q?8nDm1W6DH0VqsxbiSJDmggBZs17aqyDkWK1DE7eWCUWoawrJ2anABPBpD9p4?=
 =?us-ascii?Q?F+tgRVHYDbBbmv8hLg/NKruT1whxADoorc+YZlNoSzQUDq7Dz6iABfw2yzpk?=
 =?us-ascii?Q?ec/WC+Uliogt9ogAUijEK7hT7RovAeGRE/6bUIVd7T/Km5J0LP7U8JgueV9V?=
 =?us-ascii?Q?Ese7TnDe4iky6PlR0aGEGlR0UBg9Pr5a+nkOMMrY5F6R9IECbKoCxIBcMUPv?=
 =?us-ascii?Q?AWHXO8MFKRwOWPoa5Ko24Jlkne5GESBOQnzslNKKIfGtdjZv1CyTRiOF965T?=
 =?us-ascii?Q?nwInHuOR2s+dwHgsBahKIAQt+P4gKTrjJPcRTibtvAVha+VLivpsqcKNcy72?=
 =?us-ascii?Q?mVU3aO4NntsmqIbCjKJ3EzF415el1wrl3mPJCU+alFI4cqhCtlsf8emqo+0P?=
 =?us-ascii?Q?RWPKBcRMTOqwMXesG4/7lyeffHDgc/cBqLq4dmJVRuWlJROn2OSyrghL5LPJ?=
 =?us-ascii?Q?PZHqVjN808cMuNuTsZUmB30Lm/bxf27X/cetJYO4rwbG92QrBiEoB5WQJRBs?=
 =?us-ascii?Q?lge38+JT2INY/ClenpsuCJlKxLoGan3oo36av948o0t+cIaGRX+Ngc15TYx+?=
 =?us-ascii?Q?N/67MRGt66TYMtC99AaQnkyYV7kUtfMhd2u5N+Ke2PjEmdY/rhqDqmp5sBwK?=
 =?us-ascii?Q?GBxYv98ZFv9iS50tru+L32jfDvWP3LQnQykYbFoQEEj83bmDLhgLIwdoHsl4?=
 =?us-ascii?Q?3tSlARkGjPMezmfk5W2GAgx4Fxg5LxVlIv0XVLl88U7xveAzxOurQr7QlmYb?=
 =?us-ascii?Q?nYhEUrO2Jn2iZ0aEX0K9k8jJTpGO9a5ewSmyFAC3hEAfJy3gSpKKTu3cBj5D?=
 =?us-ascii?Q?TxYN44BFR9OWc9b/7C7nxLQG2dBR5gDajj3nOai3Xf/aHz7PYHnw9dqQ5Gly?=
 =?us-ascii?Q?95/iP9urFZ5J95MLS3S0MQesODrnFjPZSaNZ2TohAeVXiskSPh3uimXJciq9?=
 =?us-ascii?Q?qhIBDBSLekaTRTIdgo0Gf7SCqoLfrxPhZzzXOmikJQXywJyggIk1ySIC39+b?=
 =?us-ascii?Q?0PK6IsUfH0B/KhZilBfXpA8A8ipsnHglsK4CtBJfO6W/K9hp0/yEkAcMOtto?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ad23b44-cccf-4850-d1ce-08da5953a4ee
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:15:01.1712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aLj3zYBOO5wxfwTqWQE9+pMExXbdA060oYxIMcb3YKYMw+OhVekowaJZpzHPmZ01vRCVYak1LTYz+TSLekHxTA==
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

This adds a function to update a CGR with new parameters.
qman_cgr_create can almost be used for this (with flags=0), but it's not
suitable because it also registers the callback function. The _safe
variant was modeled off of qman_cgr_delete_safe. However, we handle
multiple arguments and a return value.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

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

