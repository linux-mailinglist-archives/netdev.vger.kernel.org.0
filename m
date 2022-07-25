Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA1A580168
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236269AbiGYPO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbiGYPOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:14:15 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130075.outbound.protection.outlook.com [40.107.13.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021E819282;
        Mon, 25 Jul 2022 08:12:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T78+QRDfL8wdIPHsRWuql++Rn+aU8A/yf2OEpJJZPsRw4Mn2cZiTCoRLQbbofySrA1ykP3tGiHe8XzmkjVS4W2GavvFltvMDrzfP1E8LXh0RjyXqJrek/DsKSoZmYsTXxpuLEA4TL/9p/RNvl/Eu8pt9W4SgDfSZsTpmPrCpqO7sh6l7jZV3AjaXHPmSpPjIgmRgZq5WmguXv/2vrYPTKhs/ECrFJyTOc6XAYJy1oGWSz329uw2igyb2VY8ouAac1aeMINOP0DPu5GSDp3CyOo0cz0oEVFTqZ+O1j5jfUhqawIPlpg9ae/v7RzgPImNqeC4fnkZS8eQysyORyYKYyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0iVIpavMKo9hh8B6pZsnQSMzDiNhLM+JGQPoO6Zp1c=;
 b=VltbbXkMZZ1BVJKkWZ5CEjPZSUiOFfYs/gD9klz9vqv2zUzd7iyuM2Bw8EbvAKZ2293IAlQnV99ndkir0wEQJYSavYQNaQUJuwGHNcEL8LbLUklNDlelwngCEg7KK0IuskVXJZ7G1urPzU+2RFCaSCoJu72Xhk+sAtJQR/3A1cbo4tQ4kgdJHOP9D5pxyZFDaIEPT+1G6/2RANh3Wv3x+kp/SGOL0BvwnL5lyVtTJ0RJ6tRLJ9zH1MFd1LU4nA8mE/N03yOpvLQEDlRkgpG7L4dEiYwsca7kWQRx0BOOTvHEtLahlqBj9TWs89oFHXFEKgEgtalHGwfKr//6acFjOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0iVIpavMKo9hh8B6pZsnQSMzDiNhLM+JGQPoO6Zp1c=;
 b=xpPTrrqnvvLMDQ55olY9yA5jq9rz79oGKV6kWPPw9tpyFpCHXeo2o+PLTfmMLSXkiV5FdLLssN6Pia2Xo0YLtpF+w6yPtDjEjEXFbrz1FrbYXSwee3B3wr5ZKqISvsNLQK72UEgA15h7ogS8XnIt2W/Wz4HHC//nOJgsWJswS7pXL8Pd0oVmjqGeA1XZgUX7s8inchn0MXScdo9aLkxfQBHVZL8EtvxFLPnVtR+w6PQfGB8KxcFjZrSVexIs3oAAGDku8US6rJW69d5/vNc9JBC6NUtyf5XjRfPUh52gXOtBzeclKC8Bscml1paYloFQ0f1TwNA4RhRtj2KEesBKPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3723.eurprd03.prod.outlook.com (2603:10a6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Mon, 25 Jul 2022 15:11:40 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:40 +0000
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
Subject: [PATCH v4 23/25] soc: fsl: qbman: Add helper for sanity checking cgr ops
Date:   Mon, 25 Jul 2022 11:10:37 -0400
Message-Id: <20220725151039.2581576-24-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: df88cda3-1c21-4d5a-fef3-08da6e4ffa1d
X-MS-TrafficTypeDiagnostic: DB7PR03MB3723:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1EnW13eFRzfdCNNpQ277WrHRV+teiF7/WU0Z900yYUk5PZdd1T7a10dJw38CXQfDoILmh9XABSf58rHnaXTL0L6j2D2U4QbkeS/7TUvUKBxbQC76AAvgyMV7V34GYpfu+Ky+0R6V9JHFh5tkzbhdK02NCHojJOQ8Z8l/NR+U70BuKwBvQ4I3Tgt51PKmvTM/MSBgFdkIvz/LYXs2ZOyPFSgWtKzokiw84Ca5bxiQJTCqigB/6JXYz45W8CMXacYXXeMV/DnWac1zU1ebb59mvq8Zfxzl+4fVP5g87uL2fMWUFxtaYQvU3vyZLDyDboa0QBviMLGlQ1N96AzHnf4G71gcLTC70RCf1I1S2DPQVsaGcHcNA/xpjB+EnGMHdvUmP9vfjaH84Z5hq5lUif8FovdK4qwHdH3xA20Ove4uyTUrkE451YmwtGNLRXYU2pwIHSiFCyQ/jAuhcOzAibnkeLmBfMUCGDlYbydzgf3fZxWX7eqEKR7WtuHEK5qosvfKkdl3912wnVoq6CxQXwrWkY3ai8HwhDqZdGX+0OsvJRJL+ZXEwR4KZ5xh/IYY/LzqMjlQOBDn5/NsGziLTQoFhxC/p17DtdmhTbMv/7D8D5meJFSm7U4vZEAL0UKxjC5pH3txvFXGDbPLAwr4u6CYG77laUSAmwKx7MV/xkP/0ey+NTsPNOhTZKXghF25u2qcmx3fkK7aZmv7urTvw4v1HJ6rPO7qYLaYN+KpOaqDia9YPaBT/i/qBaoDOAv/sOrqcisR7JmHyHf48ZS8FYQVhd0W4rwusFuFTdqkdlLfJi8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(2616005)(66946007)(1076003)(316002)(5660300002)(44832011)(66556008)(4326008)(66476007)(8936002)(6506007)(7416002)(52116002)(54906003)(110136005)(6666004)(26005)(8676002)(6486002)(2906002)(38350700002)(86362001)(83380400001)(38100700002)(36756003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BZIPzoI46sfDdC9XcpfokmvCM+nRn7hGjlE/C4Hi9ioqMivb4hjGAvPupnuF?=
 =?us-ascii?Q?yjV02wBZjP+KJDo1J2yzXlTt5O29AOSMoni3M0oEGfdX7dOaks1kG9qD45AW?=
 =?us-ascii?Q?pvo246hSmvRUwscnjLdv5j2u11Bx8YMBjaHKB6cUliMYZZp0v/+HC/VuIGv8?=
 =?us-ascii?Q?unwEYbxPQE0I/S6VeWTa+dpwPXUNMVrblqNp6gFnd8ZoJs+07YpJrxg6gEfM?=
 =?us-ascii?Q?CbpLwW+gp2tNBor0rq/S7xbwiqlZciRHLhqqckl1bs20VUNE+lykceQ9LnqA?=
 =?us-ascii?Q?RcHOVDY52Mw67vZVNEAUr7fsSBE2+4nl39VgDzSZV6FKYT28d8qIMPa9aObK?=
 =?us-ascii?Q?kTENMn008mfPM/ngo79ySByowuuzD0zBsXPaEE8SPP1kFjPsB8cfNHCUboRv?=
 =?us-ascii?Q?Rh5R/0lbLsV5Y60Si4Uyt1lRDIW5BixCJ2YHqde/QjMuHjEF+HaT4y7h1AVt?=
 =?us-ascii?Q?G+bl0GsOm5Im74hfPoViokW15BfQNMH3ooje1enAEPdfUwFXtFakwZ8jGkJN?=
 =?us-ascii?Q?22jhIAYtPycop2INl14pjJj4azX7u2XuwLrR5dkwOYFXhyhHXDMMvIl2JRny?=
 =?us-ascii?Q?+gwaHwQ68d7p64D+4xAoo0fiR+f8+vk5FfR4BNgl9RlQVzYCwcinhrAllUYQ?=
 =?us-ascii?Q?nvauLZRe0WBTjQtyudga8PoObUJlXJyxqzy7Fvyn33N76k6GYabG6r0Srzta?=
 =?us-ascii?Q?Dv5CR59QBVESGQ5NAs+6AA3KaiXgmA6ezJFK4TIoNpwUFA5HvEFdF30GhaJ/?=
 =?us-ascii?Q?YTJwgVR7Ke/T97gOJLL7Z5aGeMTZd/5hnCHoivc4beanikIL2itqOuSu1z8S?=
 =?us-ascii?Q?Vu+P83Oq4pFMNy3AKECfa0hEoLHhZMy+lXB2wemCehSZQMFUvgeb22kPs+VU?=
 =?us-ascii?Q?sdlNLRpXiOXtwzutPeH31kwhVW639ZCz8QlcBnwTygcr/H1zJ5KHTGfbcQ6Q?=
 =?us-ascii?Q?HNE4fw4rSeXnliJ1Vy1vTeVWz1y3ZkhqDexcOooP7nLun3g4TyIIuyTs6r4Z?=
 =?us-ascii?Q?mNBIRnYTPMyopz0ATT328lJdZ58t61DPH6HT/M6caLqqt7P7yA9zAs8nP+8w?=
 =?us-ascii?Q?p35rlhStm9By46OuEtN/Bh1yNrXytyeRB4S8s+csdd4h+zSRAC+Mz/mNce8L?=
 =?us-ascii?Q?OK7UY8ZTb10KFw5lOtLUJkAdsraOLlBIu25LiFw0pn0IDIQpVSZ2V/i7U8iZ?=
 =?us-ascii?Q?piIgaxmoGU51qf3Qs6FC2odBmKO5rG2o0pdsA2ldTL5tenVWNJpnlTn6MfO3?=
 =?us-ascii?Q?INdMt0UU4d+g/HtLemnCJ4JfMSwXnj5WnyJ/Mh9WN/IzYv7ulZctzeh07KGx?=
 =?us-ascii?Q?7b+J418AYV2+xaScpIxVyeihelS4DmwkYCfC9f9PaguDrTpKn/1yF8FuFZJs?=
 =?us-ascii?Q?EIxS6NCFxtbTSlQswEGuJR5PUntdCkDkvMeV9L0e94yvU+mXkcXCB38OEcX/?=
 =?us-ascii?Q?/rpP5WHnkRY7+NpJF2SpNSJMBqLMS20mqvTYzimf3GrmKQbih33Y6o3WUMzt?=
 =?us-ascii?Q?hfgOqpo/L1d571Bot5WZQui2+VBWyqws8UYyIvIfImc6vYQbmwpNAS+IGji7?=
 =?us-ascii?Q?Ujqn2D0SZR96SVoIISff51LKnUHg+bu69ULhwWYafXZ6e1E0XSVOeuEV+ak1?=
 =?us-ascii?Q?7g=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df88cda3-1c21-4d5a-fef3-08da6e4ffa1d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:40.4869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9KpfY8HkkxFx4na7fOzrTh6BsTThQrHUoR/w+7D5gb5ngX0mzzcT9/QnQYW03pJmUZLJz4zEeVyod9Fb+sFDdg==
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

