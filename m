Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C92D5ABA89
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 00:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiIBWAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 18:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiIBV6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:48 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150043.outbound.protection.outlook.com [40.107.15.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671EBF7B07;
        Fri,  2 Sep 2022 14:58:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYZqSlucoq9Jm5SGhHaL9ZFeOFmgRXGLZBfUhJTOoHuYf1EB4py9wp1VFGYMkBIrrcEnrQeajNrE846J6gTSo3F4RDkxYIGQYNPquLTN6dpVQuUubCrCrDGRwHQ/+8X8wfqnMVlNfDZFcV/aqmB31+eNCOhq/W4IfltgJQHM9h7DpxZPrhkpR+6GgwTASSOwvxBUIXXmbWENPika0s8H3tyiV3XZWyNuj30xxTpJL8h0mfjvpzc3jjqjWmEDRoC/SupiMdVTUPfYb86yDAejK/vJsE7LcYDGaiteC5XjPgNyBOWsGQqbFmECL75MwOfYhsLNdttaYvyQOaGMbcpIcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0iVIpavMKo9hh8B6pZsnQSMzDiNhLM+JGQPoO6Zp1c=;
 b=gup+O3CBr+q8PEOrtKj0huFm7XlCpig+IMa0gsn+7ND5yZ4Wza7Uw4JNinQ8k+5f8KABEpdkNuIQtCf3gbk4zxCO3D0e9GDTldEWXS5JTC9EFkYLomooI5FM4C+oU/fLKOA7IzUtSL1LTOnuvTRlIGEPX+FZ4nunzyVWlmX+ffu9B4O6kixpjIkyZ66LMZikTMxr5ErfpszFNpJmX20DnnoGFv4gIm+L5gmn/sXt1/rAIe/EnzKPEZpB4liSJtsIC4ji8jtH4xaE1pjWuCQtVvhWJrASMgVmu+DMBXegSlKpUjsqBz+YR1bCFPK6XEN7Ihf/Kagtegl8zfyfF1LYkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0iVIpavMKo9hh8B6pZsnQSMzDiNhLM+JGQPoO6Zp1c=;
 b=tgk4qz4EFSm5+1CWfPudS1Ih/c1GdPH5ga33fLgS4Fhx4bRmHVunZIRNeIBRJUUxvV4swLmAr5OfVZzDH28wd8PMW5NsT0S6qY7XKlhNISat+oekvida2GnNIalbXYFfMlUv3xlHb/2oU0qCB0hZ2AvCrwiMSFZCQf40WZ2MVk0Md8LOhBhBXO1qJmT/hW7Kx4DCQdfzK0x2uaiHpH8YJDaNkZp9ZTvJk9OyFqPK4042Yu6MUU8ksS1q+/ERo4hi6LwZLHjhLIypfz2sPiyznwscXclAcbuOWudVZSUXJVsbafn12cieZEdIBE3/42X+peKCh5RlmaJDxQnawc2H2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:58:13 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:58:12 +0000
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
Subject: [PATCH net-next v5 12/14] soc: fsl: qbman: Add helper for sanity checking cgr ops
Date:   Fri,  2 Sep 2022 17:57:34 -0400
Message-Id: <20220902215737.981341-13-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: fc088082-cdfd-41ed-8854-08da8d2e3b34
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0yAMrzV+6IeZzeIn7a0jg+LEf4GDglNIK6+AyvvUBcmGgo5RHRuI2+tPiol/542M19cjZIkKm9fRHPeJVy38begBG8rQIj642bwh9kVeY872ssGp+wox9L9k2EBzrOKARXNTBVdXPNaUWGf+wVBoIQYB6nlwM0qlT4xTkK9lsrxfc8T/Atw3dwhlhfq5YUo+N4tlO2zndRFPs3WWUalpM24pdM/LaXagg+Dm5GoPR2JlQsu/7gpFP/zUbNNscKNsfUQJxlwH4O/1yNxKdRPFrcuR95k5U5HLqpmoUUxBAtZM/gldbVCqCk34XylA/yedwz/Td48TwWgd5Su0sKRqjDWJim8frv13dZZ3xpkk/SXOMwV6NswGH93/bOWW35k5w9GaXYZSAS4e/vFlIt3qcaBcWO9CGUz2JKzcRd8ACrtksAYFs4LsmkP0K3yvfnpr4+IMkKOe3FjqzCD0aPcSvNQOE2/7x2r2z8CbwGN9IzsyIfJX6LqS/R2XNJWTvONwAndcYIzEaVjS4WU+VJqH3xandAKY214RBz45+hA+QHbvkNHhedv7b6F7k6SYhy8RZZ8YiB3IM4BbjnZeKSRsnLgJkYLislriyTyHYreTqeRImgFk4RYifXH3DdVmFka21DnJWV5/gX0G0qdDcVrvoj7iLkxWtOYWUhN2NxpGBSRXnZkRFFLPMaKV/mx1DGgBqeXwa+1deq1dibdt0er73/tay1PzYp0PwznvAmVzjcHDS3rNru/nBOylU9Wk10C84SflWOxmVq6f7/w7IZYj6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(41300700001)(6666004)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qx3dM7Iq/CMosLRqUMiZ+0zJx/qKki4my0zPF1ZwVJ491vhubF+M5Thg3Qiy?=
 =?us-ascii?Q?RmXKi8Su8LP4CV69jmG9Zm7vnZCV42AOEbgkhhTfq8bjiwoaPkZPqhnEQa6B?=
 =?us-ascii?Q?ZajKcqm/K7rPiuvgFwPKy5+I8nSz26Un7UhDVskXEeG/2v4uHsuxNm2+FucV?=
 =?us-ascii?Q?BclCDZaqgJEngEfUGO+hnubXyWx0hLw98zr7onfWsDHttLGv09lDNrkBhuO/?=
 =?us-ascii?Q?HoSx+wuHsdM94riK+BoaKtK8FyBIPtQ9EzRk7lNbPrdo1OyQXJJ74u8+HRtJ?=
 =?us-ascii?Q?rDgKq7FrP8wIP/LQkQa/xeQ3N1c9+hUAXN/8kEDU3ekN0ddgnKCiGsHZVw1i?=
 =?us-ascii?Q?/cCsIIBLJnSCFXG/bRz7i1Z3yJ245DNoPCCEDFINBKLtUIYpzXjCuYw0iIjx?=
 =?us-ascii?Q?HeaQRDxaBFOtyT4bjNF5G6wlrkLkFd+AN3dsJX7TYTyVW6O8eMj7nmhwasil?=
 =?us-ascii?Q?IQU82PY5Oj4RsDWiQa+6KdCT5R41vmPt0Uz2O7Srk93M+VLclGpWtKjvZ5QG?=
 =?us-ascii?Q?BkJli91x1PcKE6kokE7rQn7WZaD/PhT8CNJ+NZeutujSLhB4YoNp+Wv6H5MJ?=
 =?us-ascii?Q?0rQCTjhJ6rWF4GkD0m+k0LG9DMsqdGWjNIhMHU5rD8Z+sRIQqkB2M2nObg+C?=
 =?us-ascii?Q?ZY+TKX3e1nzMOtJfRH9mqucJZhskgD+/2UQ55Mf2eCJerDzeCGpPfmTYvnWj?=
 =?us-ascii?Q?r8UgF7VRgbF6E/v2MWh9fklCfEiIl8Umxwrz4DKDEEKzzYWgOFyZgVTe330a?=
 =?us-ascii?Q?2en+/+uatwoOfYj37sB98Em8EwiWU3J4OMtwz72KZcdb5YkwFOzC4xIIR0mH?=
 =?us-ascii?Q?hxV5qjOnCbPq4L6ZOUtaYAvhkSkZx9RJE53XeZHfyqEf6aA6Li21lnHA8nXR?=
 =?us-ascii?Q?w22V5t7s1okPIvHMSrQnImqxwV9SCtnub+KAFpNVJdhk2eDYXBx6Fwr+TLp7?=
 =?us-ascii?Q?6aAIrzBfl2AFBfUcyYN8WhD3t6sgHfxHxJ95mTW0CjELQ9p14EPauxaIxpvl?=
 =?us-ascii?Q?FrT21P6EMUv9+nh2EGtogLFqRa+HLELmlDz4snV7fHU/FAU+yzv8vANZTZgO?=
 =?us-ascii?Q?fv1n92OJuIQUnj7s2OU1MVmCcGNzU9GHv9r1Ga1NGAiUGjMpu9wzvKdhwrnz?=
 =?us-ascii?Q?iCbJE/vca6xpdgagYdjUbLcoZQTRYFYGNTB0Mvf85zlgSCZubLqla9tCtHiG?=
 =?us-ascii?Q?pgEWAot4yCpTha/PWPTzNrsM+YFabgGO38jSBwIM5G91CgXzC1IZiQLBOFPA?=
 =?us-ascii?Q?8TWsKHug6DsEYVTRDZ3kdDZNUZSp4dqkriEfk0RqP10sASJS3Lye2bKdF4F0?=
 =?us-ascii?Q?ZWxOucPXTilb+mdmul7P8VG4aV7jxMDo/pK9R+uc4wlCLgHESse6n6hRawYd?=
 =?us-ascii?Q?VjEs7fs8NY4rSFUhRVdK97y9Ex86OSTZbvqWTQX4PgPGvsn2exDJSaBtHA2m?=
 =?us-ascii?Q?Sb7IajEXqV6g2K6QqQBWA2s+DFm07YlCB4aIBScejJD1C7y6m8a6n+KjK93G?=
 =?us-ascii?Q?Q/SIeGAGuGKZFp50vJlAgvfD6uECrMsi5IfN4LsnXVhEi4K64fLGdWX1R427?=
 =?us-ascii?Q?TX3wXcGGC2DF8yy3ssReD3OfHNxJyVCAv5RrRPbMmwUNQ/zmSGhz+R7DWYt3?=
 =?us-ascii?Q?MQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc088082-cdfd-41ed-8854-08da8d2e3b34
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:58:12.8750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+dXAU2qJbYXseDxrsviVP3U+SvGyeWC/whveBvReNK9/UzREwlGa3y3WeumdnI7BccRWVrVS7glLQbdfdt4SQ==
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

