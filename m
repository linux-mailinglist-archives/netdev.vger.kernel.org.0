Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54FD4AEDFE
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbiBIJ0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:26:21 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiBIJ0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:26:19 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on061c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::61c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E47E01D5E1
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 01:26:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8rBmSoauhr/PasxH15iGOHtl4p5TrTjQlvxODgVz4ppr1C465srhvQoUpxip/o8gpg2kMYs3o+2sZhgnKyb6j1NeSwaA8P7eHMGiWsDJbuYcZPj9SjxsLyQvp93ZEkoML3pBWTwgHZuzLhSGZoj9SsYFb9n9yXtAnXnar33hHZZJpe+VUNHhPw+ZCgfmnku3cXrboG/n0qp3AbGFft9alHvZU6QJtKgOiRJmvyerHJKvP1UvJao2WzeNJl9snNxmafnxGdPvH1PmV4PNYhP8vM0j7kO5eohm8LOWLA/DOxVF2nwGYjiARZifNL6kufSTL9Q74gfssLh0TDjXLmRmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBRvrC5HV19StHSkA7eYj1O1NylUgmjqtq3L9xgUOfo=;
 b=egyTcxKSF424qOuBaxxEzLx0G9049OoM65BkEwl+2mt0vdFBLvw2SLnk8PSm+gEiFTsbk57jpJ1ePQAyH2PUVljb6pMMDKpDnqPSha0q7CP3q/kadW782wkVaV+Faivs8Y8tI5/yLZRtGTmeKGV9rsPl2fQIDq3/S28PSFikDf9YBtIVesvS5VEPaIf7BdJ6Ej0rOFkbCEHOKFhVdkvTSqRT+WoCa59YrswhDDKPaMP7zab6I+xQfc/1gSzcUFKECaHoq/RMVRoXJCPPHN+cRwibseyzxBJecvUJDSSl8D1cYtPpmvI+mRRv7f6XtL1XIG/TH6xZfXrcnwsAG2+7Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBRvrC5HV19StHSkA7eYj1O1NylUgmjqtq3L9xgUOfo=;
 b=OvTpG4+kYdaa4BvekXVShpyOmq8QseMfWWipXN+uoLimfEM9bU/633ss1wm+Rw6t8Gg5Cmu/MGKJcryM1eNhd/Xmqvdzu+p0Bw/1ijQ4cqM/FBO2gjDb/oaVT+GZBI8l8wvYLAMKGxegCjmjucypKXnwIqdMdbAYp1LemlbfgV8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM0PR04MB5972.eurprd04.prod.outlook.com (2603:10a6:208:120::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 09:24:05 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793%9]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 09:24:05 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 7/7] soc: fsl: dpio: read the consumer index from the cache inhibited area
Date:   Wed,  9 Feb 2022 11:23:35 +0200
Message-Id: <20220209092335.3064731-8-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
References: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0037.eurprd03.prod.outlook.com (2603:10a6:208::14)
 To AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 567d8c67-8642-4611-6742-08d9ebadeb33
X-MS-TrafficTypeDiagnostic: AM0PR04MB5972:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB5972C1EF70274B3FE913016CE02E9@AM0PR04MB5972.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tJf/uioi/kcYMDUwslTJEotxDoIBeaq1tqjmWY2/mt5eQeaJDNKwDuJhCwfxN/vGNhE7uiGSCfuK8LC5OOlQdnoIR2t1bx/uQwYbbkx0DfY8pJOegSjUY4gVegfP7J+kLU1+GRDNpuZGSlLmF4YAKUwfBU6ej1zBZGbcb38YnVotMIXSEL5ZDZJqIUT/FDgNR+OFaR5sGziFW/JQInrp5oGvVbfmD7PycEXzcyYplJKCgznusuxSP0XwWIxVa3zQdgKlqGlrovekNyRNkz8xhkp/3Zp+zqAIjZn90FDK3FbupQUmldkKt7546rw+qTzfhXmNJ+knaPn26e9LIa0OouQfZBBvXjkLoGwxCfnMqEVgXLFrf/7xRYgZVBnQM+zXKT9Xpk+oUSwKl1wCH+eUYkT9gnDxgVTh1kAGow+wYs2t59poA+zJ2KswnPvqrf4QDNSW3l9ZfUomalaaGRZCINLJGDSxX5LRVfN7vTX80k1tOlpOuxFDcgSypy8wmOcrCg81fcvGs2Ei8rhExhuc2KgOCw14UMuc2WXcL5/HAhmNpTTmWgGDnL6uCX50FaqPb6ac4OdobYBm5Anl6L8ODjkwtqx8b5hMC7B0AFRqvbL9qs98t5WlKpRQJvPvnVY+ES1jRjJx4yO7S19PDndSwzErXMyPwTtiZRN1DrsYvqvkK1WDawQNgIusHh+ZcWZRC+xKbQCFVjnybyu4q4y2Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(38100700002)(2906002)(2616005)(5660300002)(38350700002)(44832011)(83380400001)(52116002)(6506007)(6512007)(36756003)(186003)(6666004)(1076003)(316002)(86362001)(66946007)(66556008)(508600001)(4326008)(66476007)(8676002)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HBMaCA4cDWvc1PIx76sukwVieoQpIZc24V13NKnQ48ECr3u6xAChKmJKtfjb?=
 =?us-ascii?Q?NSqBNaAYnNjX1NXxvDkJIMBEVOpq67X3NHU5DHJ8/Cr5Zi2KzRKzLm4au2pt?=
 =?us-ascii?Q?5hNMoyo8rxhi2DvXqYB8WQcXtbrJrr1dJsGdI6NeLzwVtgmtp60uoVcgHlYt?=
 =?us-ascii?Q?/My7AW2tt+vk2FjclAnCBUM+Le37E4jJLN6ZjbVGpcqVrkgQxNHa/ifVmQ3L?=
 =?us-ascii?Q?5uCTkgvXTHymCBEPwYePebLtCqMUvaNse0NUH+rmsVIdAWMn8/OYnLMMsTKb?=
 =?us-ascii?Q?9T7T+ipbkoe9dzSAPmVqIPSyqqNRvSLI3eX3F+gfVs8x0VvWsigS5VaJBLE/?=
 =?us-ascii?Q?gt57CVqPEmb1FgPMZ0LC7+e/4nH75GeompROO8C9WaIn1p0+QgiDA7XwTRzG?=
 =?us-ascii?Q?e7oD1r6/B0E6if9cJD1niHuLRjukkTAet1/KgStoftsCELodOIeBC0iSyQxt?=
 =?us-ascii?Q?Z2q+W8lnry8ecz9an2iTnie2O6klmPF04VVofZwIofZw5xyRpLiVZEGdmgL4?=
 =?us-ascii?Q?7n3LYDhnYBEv0b2ptSMDHQdz8xL66YdDQj3NbRAQRkUmnYVc9NNXD8RxINtL?=
 =?us-ascii?Q?JmRNxLw9LzyTsUQxuXJjpHFicXGAbM1W66tPjoystaUwrXLM5ESfMQ5TBxAW?=
 =?us-ascii?Q?Jp3OlCiSiNBGapQYHcvbTV2InF7PtwIIrNXCBFPTPgbMx7nzYW6dE76+qhFd?=
 =?us-ascii?Q?3Z2BnnhTmXUPKinr/RPKT4dSyjwWXgMLAVxW0lI+fds2fmvm1aLuwit0sIrK?=
 =?us-ascii?Q?m0l1cJTSGsbvAz/Sepzq5HL1xEIjgj/shT4iVEcPuvA7VmuKfH3MqK6qxJUh?=
 =?us-ascii?Q?NcYMCSDzMRRCbh0ll+BNWNGN7x+rOEz1f6vCL4EoKaKK7P3NZqp7VkyzMyxU?=
 =?us-ascii?Q?RgDv8UKtg0gBMXaV9fq9TBdtzbPR4X7Y9Dw8Z4QXlcF7Fue9w6UvY842VEXd?=
 =?us-ascii?Q?t4PX1t0WS7ANMRcVeWnVL51I3SDC6mzcWkoyMIEk1nvMkHvjdn94NMC+ERhG?=
 =?us-ascii?Q?+rphNiSr9JJH9wpM9prB2H0tWf2Py0Qf17hezt81sxcdOj5nHyJLIzOBey3V?=
 =?us-ascii?Q?rc3vWR2SrWrB2G2yQI+K8dgSqPr0vk+jvmJ0504WKOPoHBAw4WzxWdbJEXdj?=
 =?us-ascii?Q?RxtKPXc26r7/XcArp+nCAS2ZiYr5izmVespqn5fQrYEwS1aHpcVFC86tFlLd?=
 =?us-ascii?Q?EbA69zLfOTY+6L1EyGUx4NBpLEBtzPGdN3DNnVl1k0QOZRLmmlhHrLfU5xex?=
 =?us-ascii?Q?2f/ACDuRC6TPFXemGJdZlAarBaS/AB/x+OwLBmYJrJFK/F2q2sThwDRNbS4F?=
 =?us-ascii?Q?hxnlOQH1GIM27X16HTVzuF5xQYiYEX8FlU3nL+RK7qA30Epg0OsG+iIbT6jH?=
 =?us-ascii?Q?0t+w1ej0pokqbU1Y4Tiv2fofWVFEmEAjWMMdbtQdxtLpEqqP8n3ONjoV0wfg?=
 =?us-ascii?Q?zcdkaAz+UQOIXurzjoAk50AE0jV2lt5iyQHp4zpRAZvRFI/I3TxSq+Q/koX4?=
 =?us-ascii?Q?z76QPCw2uwY7sUXMXHkD9v7wuxVnQ5sQ9yoaUtH6gHkfnvOrVoqymQtvQ+aO?=
 =?us-ascii?Q?Hj98gEKkAhiPXNxyVrl8UC1U5D02WG73vLDIbgjktsmmCnu/wwp8iebs6OMx?=
 =?us-ascii?Q?+eCkGIkuq3/eClRzr+otwZY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 567d8c67-8642-4611-6742-08d9ebadeb33
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 09:24:05.8769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8qDj0YtTo+92/q5G3/0Cx1rmSOm60ElJl7hyYIxfH0sWEWYQYJWiPDeqmFRovIuXAEw+4DunP5M0EPs9FMcZWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5972
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once we added support in the dpaa2-eth for driver level software TSO we
observed the following situation: if the EQCR CI (consumer index) is
read from the cache-enabled area we sometimes end up with a computed
value of available enqueue entries bigger than the size of the ring.

This eventually will lead to the multiple enqueue of the same FD which
will determine the same FD to end up on the Tx confirmation path and the
same skb being freed twice.

Just read the consumer index from the cache inhibited area so that we
avoid this situation.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/soc/fsl/dpio/qbman-portal.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/fsl/dpio/qbman-portal.c b/drivers/soc/fsl/dpio/qbman-portal.c
index 058b78fac5e3..0a3fb6c115f4 100644
--- a/drivers/soc/fsl/dpio/qbman-portal.c
+++ b/drivers/soc/fsl/dpio/qbman-portal.c
@@ -743,8 +743,8 @@ int qbman_swp_enqueue_multiple_mem_back(struct qbman_swp *s,
 	full_mask = s->eqcr.pi_ci_mask;
 	if (!s->eqcr.available) {
 		eqcr_ci = s->eqcr.ci;
-		p = s->addr_cena + QBMAN_CENA_SWP_EQCR_CI_MEMBACK;
-		s->eqcr.ci = *p & full_mask;
+		s->eqcr.ci = qbman_read_register(s, QBMAN_CINH_SWP_EQCR_CI);
+		s->eqcr.ci &= full_mask;
 		s->eqcr.available = qm_cyc_diff(s->eqcr.pi_ring_size,
 					eqcr_ci, s->eqcr.ci);
 		if (!s->eqcr.available) {
@@ -887,8 +887,8 @@ int qbman_swp_enqueue_multiple_desc_mem_back(struct qbman_swp *s,
 	full_mask = s->eqcr.pi_ci_mask;
 	if (!s->eqcr.available) {
 		eqcr_ci = s->eqcr.ci;
-		p = s->addr_cena + QBMAN_CENA_SWP_EQCR_CI_MEMBACK;
-		s->eqcr.ci = *p & full_mask;
+		s->eqcr.ci = qbman_read_register(s, QBMAN_CINH_SWP_EQCR_CI);
+		s->eqcr.ci &= full_mask;
 		s->eqcr.available = qm_cyc_diff(s->eqcr.pi_ring_size,
 					eqcr_ci, s->eqcr.ci);
 		if (!s->eqcr.available)
-- 
2.33.1

