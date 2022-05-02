Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7EB551772B
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 21:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiEBTMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 15:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiEBTMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 15:12:43 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2107.outbound.protection.outlook.com [40.107.114.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BE9DE9A;
        Mon,  2 May 2022 12:09:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dMzfi22gHcJm+vIwPCpRZwjkKHGgwZn2GEtQovImP/XTr9jAuCWRUeIXfF12n+JtX9mGCH0jC8JTKNwqkfjdBiolmfprV9j2TMSOvSot1d3DFaxI3gXzIcdGQo8Lq+0W95qFxb8OjToI2ftP3zK2TUFHKLa56P7jQ3WruFbao60BG/F3vMDRxG2vabELcQJV8SzhvlceCBUCw5pxcfXzZ0/jH3WTwfivwwf0LhmEzTfGoultd/vbz+OiOVvhFlf4rhz/jjj4gmVF7VJIZJZtvwjxe9h/ECaJPpUpaBOwoQ2jB15wrcWWEn2F0xkoW22Or2LHmNuuI15bvtl8KkIrSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mRnWBh+RPFONWFZTMYXeKUWOe4hFTfgmGy+nwq8DLiU=;
 b=EpuyEylfDsGlTlLreRXzZLbdIhlvedxo8hir3bgcMZEH719FdemnrVEissYmrRo7Cw73v/zBV9qIDZQ7wNJS3pLhOvyTjWCKmS2+gpZhUOEWVLjY0vW6yaJRr8tyN6W2HylO0tRXGWQmyp3gLfIUuu4qp7fkdymDPt9lnOp84/X0Pj0tmFtf04ruqX6vww11UzEAkIqF5lBKD2i3oYSJJpahaKrwiIKTB3eyB511hbExV6932sIe/OUmX0hpeCDQul/7bBdtDQX9IaExGg044JYIR5RrjLYKPZk5pYVsunislgO9LZIP/hM0NlEn/fOMrpGA8IRgtutZHCLYeQGvdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRnWBh+RPFONWFZTMYXeKUWOe4hFTfgmGy+nwq8DLiU=;
 b=io3NEP/Xz0eUrU0fQYqqWx9uOnSld5Y/G9q3LnM4M5JidPaV412rOuWani7bLbgWRhoLokgnK+Gj/nhP/fK1iVR5+PuCdtdrVyxi8IA8gVyM3xgqRPmkiM63FVscCBWz3Kjce25eUkG4qL01w1FZeKMPsBE8LYRojnxfIPEX9PI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by TYCPR01MB9570.jpnprd01.prod.outlook.com (2603:1096:400:191::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 19:09:11 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663%9]) with mapi id 15.20.5206.012; Mon, 2 May 2022
 19:09:11 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net v3 2/2] ptp: ptp_clockmatrix: return -EBUSY if phase pull-in is in progress
Date:   Mon,  2 May 2022 15:08:50 -0400
Message-Id: <1651518530-25128-2-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1651518530-25128-1-git-send-email-min.li.xe@renesas.com>
References: <1651518530-25128-1-git-send-email-min.li.xe@renesas.com>
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0306.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::28) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 616d6c87-31f8-4866-444f-08da2c6f3d88
X-MS-TrafficTypeDiagnostic: TYCPR01MB9570:EE_
X-Microsoft-Antispam-PRVS: <TYCPR01MB9570E365627FE3CD28C2C0DDBAC19@TYCPR01MB9570.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 64wRGYfXDw+kzQjiz7s39RPUtS84DpOZbSm/ohDZAisl5yuPNhI2WpswrCLBGOb82tZdmhBLfTX/5ZvoWbR57nVHwXFricFpSK8aInIdciMS8tbuWQS9ru9cg64egXT3D1UPMiPYxlV+SNWdhVRGfb9dWApM8Yvbl9fL2u2RRV/8nIEH7r453taR1S0TlE8X5xqJDhmbCSuDWm5vzxXDM8cbB4jJ9SZwG92HPBrnxgk/pXBFJvv7ZswJP+8nJ55TjswR4mNC1YI0Ee7oF+aPpGxzQ1HaM6IqguopF3mjDo0Dj/PIE5AUNPfuQTXlMF7eot348E8/r4+SE8NyPYqHMarwZSDql97dHmvXt7i6xiFcbYzNJSHwUbtUI3CDR3FajwauaBost5JpjqatwhxyR+J1wnCpUo4gGj0jjkSrCppTviB3bGuT3S28IE+CU+e7OfmMLXyC/m7dJIF5L7Z8eBNAOIRRuMtO08s9FYwuBxPnWU4Mo+83IUoU035farOugZLPGXy6Zj6DZbm/RRXAHVwLtiaUQesgxLAmTsir1cHFjZdMfrujWVMszZVAxsKnaolfzhM/tqYzcNYL1+Wsdzm/TX+gLsfpJAOhlTFoaGBTENpmHuyJbQ6CeKSHHF/pElEu7zFLzVLQPGpl43jKndY/2q+eRK6mwjLbLVu7vcJSJKEG1ed6ud82mVuPmuIvrQxewRxwQCQ4y6s0/aVeTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(508600001)(8676002)(66556008)(83380400001)(2616005)(8936002)(6486002)(66946007)(86362001)(36756003)(2906002)(316002)(52116002)(6506007)(6666004)(38350700002)(6512007)(38100700002)(26005)(5660300002)(107886003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kL95XJfq3L2RcKHyPql3wwFDAxuzB3hZ/e6pPTOpMg5MWuyQwyPXdzvwIjo+?=
 =?us-ascii?Q?XGqwMercyIzZHdv9ZnLa08Kc+I5ALpTNx7sHLAnxK8GanhSqIB3qsThewqIE?=
 =?us-ascii?Q?Mk0STDbxgHiWWrb/rWjQLvwHjk7e/zWYr5/10ahq89Rr43REQfyV2FNreqTp?=
 =?us-ascii?Q?7+04ZELsP2EzKdv7pHjDuAOS7QnatEsqTSv74JVHoOFkczEImzfo8lTeVSrF?=
 =?us-ascii?Q?8WduYV+TtbgRE4AAYmYnSwH86maTEZpy4rMDz59I5oQNKLfBI3Z8b0SmB2LG?=
 =?us-ascii?Q?KNLxENyxhkg/sQLPYNbyvR+RY9mliph0LQOaC4lrpcFdrX6ZeSu5CZA6S0pF?=
 =?us-ascii?Q?WHLRmcRVxLCk6hwC7W1Wcg5gIPgrG5FbDz4mBfFOy/QeHHRSeNQZrnPxQ1I4?=
 =?us-ascii?Q?sIJV3jUa8g8PQzdZNhi3RveIDLKmkm7fOEOW2DCFmmC0mqbbaBFCc9nhzUS1?=
 =?us-ascii?Q?kc5rGje2m5x8Udhp7j2fiBLN4HMeKUWGhv8FMaQ3FAkAI/KBzcWknV8xCQKt?=
 =?us-ascii?Q?epLvZituuMTUqQDJPoNGQIgPF8lu+wS8fcbblSBR0R/sy++lAbkpVy6KehaC?=
 =?us-ascii?Q?5mPmkTmpqDivLm/CWOq/yYeDCnr94rny5okeRUZTEvu+8/FwM5Hgb4AI6UBV?=
 =?us-ascii?Q?aqYx/BMWq8YsVz+DghNGAgXCIvc5gPBHGYu+xwpKo7s/wibDMdiZb49ai7KF?=
 =?us-ascii?Q?E9xUeLn7bx6H/MLkUqIH+D44OLPuzgwutk4VpsN++IMLxr/alFl7qfwwDCCh?=
 =?us-ascii?Q?qcrMFGAnuwYY3cPHS62b/6cZcU/7TfySFMKFstMAEPxJaVzPvCpiTDLIK0AB?=
 =?us-ascii?Q?FtSF/YsgwQxmLV5CmGcbcPIF+lHD/XdshvgNvCg56MOJn3I4VHhUiufPZXpW?=
 =?us-ascii?Q?GQ/yGNcVEujVlCVHtSTDCNmOmANn1MhNuYuQ9J9POFKa1qpuGAxSULMq0MI+?=
 =?us-ascii?Q?lie+Pf7JnBqh2kiRIWCLFxUn4xfpG1awYaPxMcgimD86JK+14P6hcTR+ubJr?=
 =?us-ascii?Q?JLLgRJn4ME9LXO+ZKC0JJwWpwErcWXiyofukePmQdESyOVmkzSBYAHub+rgs?=
 =?us-ascii?Q?zOW6DKq+T83bnkT6O1oHNcX3q7/7EnWKumSTaZhOBQl5wushIScsCM1PO5rw?=
 =?us-ascii?Q?Ys05LCXrr5kLVii5ujDRx68S5MsntgVwijVTlWdWO7dcGCxfhSRRyzAS45KW?=
 =?us-ascii?Q?gFQEHWA4tQjHEfmqEBdIpgsYe39Yoi4t8DwtWlTS+vd5lsc4GILoFxFh9RBn?=
 =?us-ascii?Q?j5O+m4iZ8A50Yv8ehBZFiTRdVAZbiEA5r/0B/IGdJtcjZnpTYLJZidh3L/pL?=
 =?us-ascii?Q?Lxkcuyli3d1atH9WBUNJIZ42dYaQz/HkDjAlv9TsjBy/kS0n9IxwzqehSlDx?=
 =?us-ascii?Q?kvgj4rp1desj3ep77/HQC7Ug99UFUaxJXTZICiCmyjBdM8hf0nonvDqBhB2J?=
 =?us-ascii?Q?88Gik3mZ7XlBT3dhJEyKaPavaFxB5fcClETs9MDETnacUDJoenbXS1+PZZjx?=
 =?us-ascii?Q?vBvNx8AnWs3FXovGuarclZsRZl6Ksn5Sj1JFHDWwQZFX6VW+cLkc0BOeG31O?=
 =?us-ascii?Q?HZxoKfT9usKWTAav1EfaXXH3tP2jElbzs+0c5VuXUBxoprW0v4IEHUwofA6U?=
 =?us-ascii?Q?KDYjTxPil+qhWMM65OQNVGgV38x+rRYHShx2FgI9iSouaHiuxHY3xugAMT8U?=
 =?us-ascii?Q?m66ksiIlgocH3d8gW57DuzgcvKFl/u0uXoFFk4ST2fEANC48gx5isStVMxC2?=
 =?us-ascii?Q?xPuLtjfn2bn0K3t0qM5Sne0n88mi4bk=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 616d6c87-31f8-4866-444f-08da2c6f3d88
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 19:09:11.4022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FtVpa5fJRx0PAW3H6eC27YdVFhe7LQndER0Rrfso8ZQ1JT+z2J/weWvYr30Ke8Qry6grE7ANVOxsI0zh0TKoUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB9570
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also removes PEROUT_ENABLE_OUTPUT_MASK

Signed-off-by: Min Li <min.li.xe@renesas.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_clockmatrix.c | 32 ++------------------------------
 drivers/ptp/ptp_clockmatrix.h |  2 --
 2 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index d8c7e80..201e5a9 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -1363,43 +1363,15 @@ static int idtcm_output_enable(struct idtcm_channel *channel,
 	return idtcm_write(idtcm, (u16)base, OUT_CTRL_1, &val, sizeof(val));
 }
 
-static int idtcm_output_mask_enable(struct idtcm_channel *channel,
-				    bool enable)
-{
-	u16 mask;
-	int err;
-	u8 outn;
-
-	mask = channel->output_mask;
-	outn = 0;
-
-	while (mask) {
-		if (mask & 0x1) {
-			err = idtcm_output_enable(channel, enable, outn);
-			if (err)
-				return err;
-		}
-
-		mask >>= 0x1;
-		outn++;
-	}
-
-	return 0;
-}
-
 static int idtcm_perout_enable(struct idtcm_channel *channel,
 			       struct ptp_perout_request *perout,
 			       bool enable)
 {
 	struct idtcm *idtcm = channel->idtcm;
-	unsigned int flags = perout->flags;
 	struct timespec64 ts = {0, 0};
 	int err;
 
-	if (flags == PEROUT_ENABLE_OUTPUT_MASK)
-		err = idtcm_output_mask_enable(channel, enable);
-	else
-		err = idtcm_output_enable(channel, enable, perout->index);
+	err = idtcm_output_enable(channel, enable, perout->index);
 
 	if (err) {
 		dev_err(idtcm->dev, "Unable to set output enable");
@@ -1903,7 +1875,7 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	int err;
 
 	if (channel->phase_pull_in == true)
-		return 0;
+		return -EBUSY;
 
 	mutex_lock(idtcm->lock);
 
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index 4379650..bf1e49409 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -54,8 +54,6 @@
 #define LOCK_TIMEOUT_MS			(2000)
 #define LOCK_POLL_INTERVAL_MS		(10)
 
-#define PEROUT_ENABLE_OUTPUT_MASK	(0xdeadbeef)
-
 #define IDTCM_MAX_WRITE_COUNT		(512)
 
 #define PHASE_PULL_IN_MAX_PPB		(144000)
-- 
2.7.4

