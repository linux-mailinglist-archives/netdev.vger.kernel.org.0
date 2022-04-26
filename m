Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64E9510925
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 21:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353803AbiDZTg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 15:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354165AbiDZTgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 15:36:25 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2102.outbound.protection.outlook.com [40.107.113.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD0119F411;
        Tue, 26 Apr 2022 12:33:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7Peq7ljkDtvZUKXZ41R8RAtyZwnQrUjBCdslRYXibI+4KScYMyViSrIuCfruQYcvWmSgVLKlKoQWekuQbd1quSVFvKG4JRn1H2mCFh6FvTJj2Ws2hhIjkf6WwbIx4UNAfirPNwRQBnOj3M97MMPxm6gDeOoVjG4j+srlGc5trUc095uTQMAwHbhy4c+w4hnGSNNSerm9+/fvjwBK64B6K4OSAZfrV74pz49b4O2mt7NMT12TMVd317r8BBBCFa9qW3FBOmNpoNIeS9fHa5KP9e2dPA+biLZvKWs7gLDomAHBRjOtxQGIby+7pWzlEUs1XApEdg7TADe2XhTPiLfFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AszbztA/VNRi1bF+UGa7MeyE8QbbTciaOZgz9KOuLWM=;
 b=MlKoa+PXg9uXkcqT0Rrq5Z+5fvAH8lA+BfQLIm4xe0ADokHo6ARSw2frfudqQs2ajAiAwUmVXCiYPF9NuBzISzEefkG0iA+bX3f7TyF+ESZy2CqL9KG8UVHiADUDI+6GP6dj3CxG94UOQFZYrRtK35DZ9wGEbJm5yspYsbLHhLDIWbHF+V8SHTGRIhlqzLYF9tW4APjPi/Sx8hYWexFlPMkKxluSNFL4/ltW63AssMNENis4t3aHWlyz/06lmQxsx5My/vCGgxkBDuelkj+4amx5YaTqm1upQwRgzZS5+ttzbDjCqWDrJJxHnOuJ4HcyiySvTk7dFn74yGzwEOYM/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AszbztA/VNRi1bF+UGa7MeyE8QbbTciaOZgz9KOuLWM=;
 b=PqAaTKczbgHhzTarC/cAcVa46YwpbJI8FgNBS2H7NUjrJRO9bIEStB2U1OVVPtjRFnMgcJwxaAbcS4TeSZfHvbB9OCLrGnxglmgWKz3jONXQA2VKj0F9YCEY4p3KXvaciSXMufX+GpCcZHc4IigRes9o0MytCHUJIvprbTbJWN8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by TYAPR01MB6475.jpnprd01.prod.outlook.com (2603:1096:400:a2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 19:33:14 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663%8]) with mapi id 15.20.5186.023; Tue, 26 Apr 2022
 19:33:12 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS support
Date:   Tue, 26 Apr 2022 15:32:53 -0400
Message-Id: <1651001574-32457-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: BN8PR04CA0044.namprd04.prod.outlook.com
 (2603:10b6:408:d4::18) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c5014b6-af00-492e-5058-08da27bb9a01
X-MS-TrafficTypeDiagnostic: TYAPR01MB6475:EE_
X-Microsoft-Antispam-PRVS: <TYAPR01MB6475DBD88BD14BB47567F36DBAFB9@TYAPR01MB6475.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XwemEd5JuRoTPQvToHR+W4naSUamixSKVq04Nd7h6e/ggA2qQ44Zr2rIsObk2QAvIC1pLRy35lBErCaTtnhVloiNZwEexoq4viRgE5ipGhGXyB4Hbdgsab4Zjys+a2iKvTCeMJKIf18XT/D6OtJm1j6c90gbD6IM8rNdbP7pNicdlmbBK6Ks2QQV8LVUCwgsft+0M5RzmwM042BiqIa+OOmXql8O5RvXbbvEmwA9c3vCqEfCIx7Fw6AicMKU88GxZmTORKw1C8p9zIqc+ijfL7EgFOrgjxHRP0rziOt1jUc29OfcOCeARETmZUZf1Gtfk76BBG9Ix61tjnbcrwvl3oI1Zs8gmVo8odGGfTFDLs2DQRpCdxHFFWGY3tDmP16MeAZ4lr1Ya4GDbrYAF+4NkkHPbp0qnJBZWr86ulfrFMbh8YCUvteDpXk4acTQ5v5nOHe9GD1Mbs/r2wYZCJ3Hc+RaneXIlfkhjv+XLFar8lcb5LFrF3HaohO9OqZcq0CD0mb6B6sLp99OwK6PM1BOdS8utKkQ58++qOERibR2WJ2ltVbOimlsCJEiKXVGIQfMHLB+cBq4s+IF2JTaVwswPirU/UPdP9TdaikA0eAAvY+AO4d12ptCThp30A44vsvfPZI2nCBfdIwMu7liI+2KxaAs2HxQTISyt1qfmqxN8joJIHx+xLNgsWQuwvyvWjt/wDjZu798YVC9bqOAchBMsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(8936002)(36756003)(83380400001)(5660300002)(26005)(4326008)(66476007)(186003)(8676002)(2906002)(107886003)(30864003)(2616005)(38350700002)(52116002)(86362001)(508600001)(38100700002)(6486002)(316002)(66556008)(66946007)(6666004)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iuKyskgFujdqByRYgtW9JNaftcuhvvvYjRrwTCK6xESfSAeHoTWcXV/P9nRM?=
 =?us-ascii?Q?vqkiUkwxwwmjdrPdHC5y5qPcOtNKjxhIk/zwPUwxyweMdpdQocXB0kUFmyG1?=
 =?us-ascii?Q?SHPlbn33p74HW03sdHeji/9C1d5msznj39mDeg7+mALpfdNrAuehHHFhyo9g?=
 =?us-ascii?Q?8JPZ7esbTPrT/NEHvp6VuPDjjV1Te5tHKvHSiVemXdC/BdHjzR1yqBAL1D+w?=
 =?us-ascii?Q?PM31Vvh3Ww+KDmDqnXqYWYHXy3J9CeV4h2J5L/3etF8vLUgoHCtCpXCIXz/g?=
 =?us-ascii?Q?UihCWBghcZPZD8N7C+96ebFgBEYEiWp4NNi3yI+1Ck4tWAWNU86ItUbqfHZc?=
 =?us-ascii?Q?kYbaHuUxmd/qtZ4rnHSrGkOA1uTfEPt7n/Ru5L/dMY6WZAO2mrKfaX6DcSY6?=
 =?us-ascii?Q?xsghpQNyrpw45g7zcjQQegRsGOFKWwaegKp1FxD3PIGOqrS3RJrSTH1NSVF7?=
 =?us-ascii?Q?J6jDPAyDZQRZqLkTESdrcCs/5pb0mpsnutNN2hsvetPt7P+pivAeQPSrCsTQ?=
 =?us-ascii?Q?Iif1GyMDuUTF94UlJJXw5FdZGAjO1r2NT41TLLI4TPqBKlHTQtatAFo7WaSQ?=
 =?us-ascii?Q?sQ5RkPshgIDduM8t3GSjk5QYBPqVGyiRGWEYOBF+XSxgoEYF6joGBi3wqSmu?=
 =?us-ascii?Q?sAIV+IU2eNt5QgDtkxeB316bNL4mT7EtMsH3j5UrTNbE3ugCpKFidBEdn51l?=
 =?us-ascii?Q?QIY/ZQKMe3aH98Dz/YQuJv37mDYYF4gYudWelXdTYl7Ob0v5gZFOPyXwQKJm?=
 =?us-ascii?Q?HQzsCEyMRTP5JWGtjrProBZwlxOXXfawVNX6Xrmz/HVZnScJB4GDPQB3Qhhu?=
 =?us-ascii?Q?ImqkZcWXPwjR6mG8awpqTsQlhfGbSICOGqxVaFabkYyPZDrE7coA9Vn3cxss?=
 =?us-ascii?Q?8Uzo5dhA7jLQjKaI8ktMeWxS4i0QP9Liq0Qz/d5+fW83KjYtBA6R5CcTjuSq?=
 =?us-ascii?Q?dvdDXf/BztFLiocZl7hXkbWQIWonBOlX6SKbTpdJ09q31BRjpR85bnCYJ7kg?=
 =?us-ascii?Q?l4s4T1+hIR6myPqtBem1PbkBrstK+pHmCk7imwsm9x6UrmxaKPLE9+Bvf5+h?=
 =?us-ascii?Q?f/mTF+veZYLNv4Tr7EBhd08AdDcfM9lOvSSekMLrNcIVVVJZzctnPs5T64v6?=
 =?us-ascii?Q?aEN4J3ujNOnsqMCQ3QMtJPBD6KN5e/v5zOQ+raQowheuSJUHmkdHQIRFGMPk?=
 =?us-ascii?Q?GGpJt0vSbIQIX0iGJOrKymvIGKm3L/aEofEp2zg2Jlg/KaZLBsWQ/1SxpBfq?=
 =?us-ascii?Q?j8JSqmoD/E0EUjprkCZ91+1He2B1mV02fydqcMefkEirSrWiqXsZtOL2zYVZ?=
 =?us-ascii?Q?u/sRTx+m7pnOchqh4jJRkWvEnyiM7cq81MUt6yPR06qdynQi0r/lYJW6PvZq?=
 =?us-ascii?Q?HwrZoXvnbjNCJ/+1uDbQA6L7ZcxClUgje3fAz2FC2k6qpzRAQg0PF1YCHR0T?=
 =?us-ascii?Q?sw05Qa/+lFBp1pjI7b1py6uA9ccttYyEhUbp2h7ZI4XfV6G4iVc9cLRFAANX?=
 =?us-ascii?Q?xL5NUP6FlgYyj2dAuaKCktDZle4fA/zA/ca/JtqnTwNZbJjm+GrkFTY1CyhI?=
 =?us-ascii?Q?EZM8AzT+tpo1IxZIl8OYILIjrR5X3ITLITonKZecOFnzlqYEcn6jGpEeTgm2?=
 =?us-ascii?Q?xYi8jnfgV0ZQprHKTDD0huXoc37YyQ+Pa1c79OMVEnml4r1oXGDvB90eZz9n?=
 =?us-ascii?Q?DGWDt1zfKjS7ML80XYlWF25b1PNJwFezfMPD1a6SQeucbmIeoTAe9dY8lcZf?=
 =?us-ascii?Q?l65SofrM3kLW0t/oPy6X709at+BkkL4=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c5014b6-af00-492e-5058-08da27bb9a01
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 19:33:12.5302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PX0NeFbUWlvG2osbjmK8MMrW75EibWx3hCdqsiAPQdRpLu/+Yg6zSeGJAZKGF4fwSsfB5EN3wc9ewltKTdgb/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB6475
X-Spam-Status: No, score=0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use TOD_READ_SECONDARY for extts to keep TOD_READ_PRIMARY
for gettime and settime exclusively

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c    | 303 +++++++++++++++++++++++++--------------
 drivers/ptp/ptp_clockmatrix.h    |   5 +
 include/linux/mfd/idt8a340_reg.h |  12 +-
 3 files changed, 209 insertions(+), 111 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 08e429a..0e8e698 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -239,73 +239,101 @@ static int wait_for_boot_status_ready(struct idtcm *idtcm)
 	return -EBUSY;
 }
 
-static int _idtcm_set_scsr_read_trig(struct idtcm_channel *channel,
-				     enum scsr_read_trig_sel trig, u8 ref)
+static int arm_tod_read_trig_sel_refclk(struct idtcm_channel *channel, u8 ref)
 {
 	struct idtcm *idtcm = channel->idtcm;
-	u16 tod_read_cmd = IDTCM_FW_REG(idtcm->fw_ver, V520, TOD_READ_PRIMARY_CMD);
-	u8 val;
+	u16 tod_read_cmd = IDTCM_FW_REG(idtcm->fw_ver, V520, TOD_READ_SECONDARY_CMD);
+	u8 val = 0;
 	int err;
 
-	if (trig == SCSR_TOD_READ_TRIG_SEL_REFCLK) {
-		err = idtcm_read(idtcm, channel->tod_read_primary,
-				 TOD_READ_PRIMARY_SEL_CFG_0, &val, sizeof(val));
-		if (err)
-			return err;
-
-		val &= ~(WR_REF_INDEX_MASK << WR_REF_INDEX_SHIFT);
-		val |= (ref << WR_REF_INDEX_SHIFT);
+	val &= ~(WR_REF_INDEX_MASK << WR_REF_INDEX_SHIFT);
+	val |= (ref << WR_REF_INDEX_SHIFT);
 
-		err = idtcm_write(idtcm, channel->tod_read_primary,
-				  TOD_READ_PRIMARY_SEL_CFG_0, &val, sizeof(val));
-		if (err)
-			return err;
-	}
-
-	err = idtcm_read(idtcm, channel->tod_read_primary,
-			 tod_read_cmd, &val, sizeof(val));
+	err = idtcm_write(idtcm, channel->tod_read_secondary,
+			  TOD_READ_SECONDARY_SEL_CFG_0, &val, sizeof(val));
 	if (err)
 		return err;
 
-	val &= ~(TOD_READ_TRIGGER_MASK << TOD_READ_TRIGGER_SHIFT);
-	val |= (trig << TOD_READ_TRIGGER_SHIFT);
-	val &= ~TOD_READ_TRIGGER_MODE; /* single shot */
+	val = 0 | (SCSR_TOD_READ_TRIG_SEL_REFCLK << TOD_READ_TRIGGER_SHIFT);
+
+	err = idtcm_write(idtcm, channel->tod_read_secondary, tod_read_cmd,
+			  &val, sizeof(val));
+
+	if (err)
+		dev_err(idtcm->dev, "%s: err = %d", __func__, err);
 
-	err = idtcm_write(idtcm, channel->tod_read_primary,
-			  tod_read_cmd, &val, sizeof(val));
 	return err;
 }
 
-static int idtcm_enable_extts(struct idtcm_channel *channel, u8 todn, u8 ref,
-			      bool enable)
+static bool is_single_shot(u8 mask)
 {
-	struct idtcm *idtcm = channel->idtcm;
-	u8 old_mask = idtcm->extts_mask;
-	u8 mask = 1 << todn;
+	/* Treat single bit ToD masks as continuous trigger */
+	if ((mask == 1) || (mask == 2) || (mask == 4) || (mask == 8))
+		return false;
+	else
+		return true;
+}
+
+static int idtcm_extts_enable(struct idtcm_channel *channel,
+			      struct ptp_clock_request *rq, int on)
+{
+	u8 index = rq->extts.index;
+	struct idtcm *idtcm;
+	u8 mask = 1 << index;
 	int err = 0;
+	u8 old_mask;
+	int ref;
 
-	if (todn >= MAX_TOD)
+	idtcm = channel->idtcm;
+	old_mask = idtcm->extts_mask;
+
+	/* Reject requests with unsupported flags */
+	if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
+				PTP_RISING_EDGE |
+				PTP_FALLING_EDGE |
+				PTP_STRICT_FLAGS))
+		return -EOPNOTSUPP;
+
+	/* Reject requests to enable time stamping on falling edge */
+	if ((rq->extts.flags & PTP_ENABLE_FEATURE) &&
+	    (rq->extts.flags & PTP_FALLING_EDGE))
+		return -EOPNOTSUPP;
+
+	if (index >= MAX_TOD)
 		return -EINVAL;
 
-	if (enable) {
-		if (ref > 0xF) /* E_REF_CLK15 */
-			return -EINVAL;
-		if (idtcm->extts_mask & mask)
-			return 0;
-		err = _idtcm_set_scsr_read_trig(&idtcm->channel[todn],
-						SCSR_TOD_READ_TRIG_SEL_REFCLK,
-						ref);
+	if (on) {
+		/* Support triggering more than one TOD_0/1/2/3 by same pin */
+		/* Use the pin configured for the channel */
+		ref = ptp_find_pin(channel->ptp_clock, PTP_PF_EXTTS, channel->tod);
+
+		if (ref < 0) {
+			dev_err(idtcm->dev, "%s: No valid pin found for TOD%d!\n",
+				__func__, channel->tod);
+			return -EBUSY;
+		}
+
+		err = arm_tod_read_trig_sel_refclk(&idtcm->channel[index], ref);
+
 		if (err == 0) {
 			idtcm->extts_mask |= mask;
-			idtcm->event_channel[todn] = channel;
-			idtcm->channel[todn].refn = ref;
+			idtcm->event_channel[index] = channel;
+			idtcm->channel[index].refn = ref;
+			idtcm->extts_single_shot = is_single_shot(idtcm->extts_mask);
+
+			if (old_mask)
+				return 0;
+
+			schedule_delayed_work(&idtcm->extts_work,
+					      msecs_to_jiffies(EXTTS_PERIOD_MS));
 		}
-	} else
+	} else {
 		idtcm->extts_mask &= ~mask;
+		idtcm->extts_single_shot = is_single_shot(idtcm->extts_mask);
 
-	if (old_mask == 0 && idtcm->extts_mask)
-		schedule_delayed_work(&idtcm->extts_work,
-				      msecs_to_jiffies(EXTTS_PERIOD_MS));
+		if (idtcm->extts_mask == 0)
+			cancel_delayed_work(&idtcm->extts_work);
+	}
 
 	return err;
 }
@@ -371,6 +399,34 @@ static void wait_for_chip_ready(struct idtcm *idtcm)
 			 "Continuing while SYS APLL/DPLL is not locked");
 }
 
+static int _idtcm_gettime_triggered(struct idtcm_channel *channel,
+				    struct timespec64 *ts)
+{
+	struct idtcm *idtcm = channel->idtcm;
+	u16 tod_read_cmd = IDTCM_FW_REG(idtcm->fw_ver, V520, TOD_READ_SECONDARY_CMD);
+	u8 buf[TOD_BYTE_COUNT];
+	u8 trigger;
+	int err;
+
+	err = idtcm_read(idtcm, channel->tod_read_secondary,
+			 tod_read_cmd, &trigger, sizeof(trigger));
+	if (err)
+		return err;
+
+	if (trigger & TOD_READ_TRIGGER_MASK)
+		return -EBUSY;
+
+	err = idtcm_read(idtcm, channel->tod_read_secondary,
+			 TOD_READ_SECONDARY_BASE, buf, sizeof(buf));
+
+	if (err)
+		return err;
+
+	err = char_array_to_timespec(buf, sizeof(buf), ts);
+
+	return err;
+}
+
 static int _idtcm_gettime(struct idtcm_channel *channel,
 			  struct timespec64 *ts, u8 timeout)
 {
@@ -396,7 +452,7 @@ static int _idtcm_gettime(struct idtcm_channel *channel,
 	} while (trigger & TOD_READ_TRIGGER_MASK);
 
 	err = idtcm_read(idtcm, channel->tod_read_primary,
-			 TOD_READ_PRIMARY, buf, sizeof(buf));
+			 TOD_READ_PRIMARY_BASE, buf, sizeof(buf));
 	if (err)
 		return err;
 
@@ -415,65 +471,40 @@ static int idtcm_extts_check_channel(struct idtcm *idtcm, u8 todn)
 
 	extts_channel = &idtcm->channel[todn];
 	ptp_channel = idtcm->event_channel[todn];
+
 	if (extts_channel == ptp_channel)
 		dco_delay = ptp_channel->dco_delay;
 
-	err = _idtcm_gettime(extts_channel, &ts, 1);
-	if (err == 0) {
-		event.type = PTP_CLOCK_EXTTS;
-		event.index = todn;
-		event.timestamp = timespec64_to_ns(&ts) - dco_delay;
-		ptp_clock_event(ptp_channel->ptp_clock, &event);
-	}
-	return err;
-}
+	err = _idtcm_gettime_triggered(extts_channel, &ts);
 
-static u8 idtcm_enable_extts_mask(struct idtcm_channel *channel,
-				    u8 extts_mask, bool enable)
-{
-	struct idtcm *idtcm = channel->idtcm;
-	int i, err;
+	if (err)
+		return err;
 
-	for (i = 0; i < MAX_TOD; i++) {
-		u8 mask = 1 << i;
-		u8 refn = idtcm->channel[i].refn;
-
-		if (extts_mask & mask) {
-			/* check extts before disabling it */
-			if (enable == false) {
-				err = idtcm_extts_check_channel(idtcm, i);
-				/* trigger happened so we won't re-enable it */
-				if (err == 0)
-					extts_mask &= ~mask;
-			}
-			(void)idtcm_enable_extts(channel, i, refn, enable);
-		}
-	}
+	/* Triggered - save timestamp */
+	event.type = PTP_CLOCK_EXTTS;
+	event.index = todn;
+	event.timestamp = timespec64_to_ns(&ts) - dco_delay;
+	ptp_clock_event(ptp_channel->ptp_clock, &event);
 
-	return extts_mask;
+	return err;
 }
 
 static int _idtcm_gettime_immediate(struct idtcm_channel *channel,
 				    struct timespec64 *ts)
 {
 	struct idtcm *idtcm = channel->idtcm;
-	u8 extts_mask = 0;
+
+	u16 tod_read_cmd = IDTCM_FW_REG(idtcm->fw_ver, V520, TOD_READ_PRIMARY_CMD);
+	u8 val = (SCSR_TOD_READ_TRIG_SEL_IMMEDIATE << TOD_READ_TRIGGER_SHIFT);
 	int err;
 
-	/* Disable extts */
-	if (idtcm->extts_mask) {
-		extts_mask = idtcm_enable_extts_mask(channel, idtcm->extts_mask,
-						     false);
-	}
+	err = idtcm_write(idtcm, channel->tod_read_primary,
+			  tod_read_cmd, &val, sizeof(val));
 
-	err = _idtcm_set_scsr_read_trig(channel,
-					SCSR_TOD_READ_TRIG_SEL_IMMEDIATE, 0);
-	if (err == 0)
-		err = _idtcm_gettime(channel, ts, 10);
+	if (err)
+		return err;
 
-	/* Re-enable extts */
-	if (extts_mask)
-		idtcm_enable_extts_mask(channel, extts_mask, true);
+	err = _idtcm_gettime(channel, ts, 10);
 
 	return err;
 }
@@ -1557,8 +1588,8 @@ static s32 phase_pull_in_scaled_ppm(s32 current_ppm, s32 phase_pull_in_ppb)
 	/* ppb = scaled_ppm * 125 / 2^13 */
 	/* scaled_ppm = ppb * 2^13 / 125 */
 
-	s64 max_scaled_ppm = div_s64((s64)PHASE_PULL_IN_MAX_PPB << 13, 125);
-	s64 scaled_ppm = div_s64((s64)phase_pull_in_ppb << 13, 125);
+	s64 max_scaled_ppm = (PHASE_PULL_IN_MAX_PPB << 13) / 125;
+	s64 scaled_ppm = (phase_pull_in_ppb << 13) / 125;
 
 	current_ppm += scaled_ppm;
 
@@ -1699,9 +1730,12 @@ static int initialize_dco_operating_mode(struct idtcm_channel *channel)
 
 /* PTP Hardware Clock interface */
 
-/*
+/**
  * Maximum absolute value for write phase offset in picoseconds
  *
+ * @channel:  channel
+ * @delta_ns: delta in nanoseconds
+ *
  * Destination signed register is 32-bit register in resolution of 50ps
  *
  * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
@@ -1958,8 +1992,7 @@ static int idtcm_enable(struct ptp_clock_info *ptp,
 			err = idtcm_perout_enable(channel, &rq->perout, true);
 		break;
 	case PTP_CLK_REQ_EXTTS:
-		err = idtcm_enable_extts(channel, rq->extts.index,
-					 rq->extts.rsv[0], on);
+		err = idtcm_extts_enable(channel, rq, on);
 		break;
 	default:
 		break;
@@ -1982,13 +2015,6 @@ static int idtcm_enable_tod(struct idtcm_channel *channel)
 	u8 cfg;
 	int err;
 
-	/* STEELAI-366 - Temporary workaround for ts2phc compatibility */
-	if (0) {
-		err = idtcm_output_mask_enable(channel, false);
-		if (err)
-			return err;
-	}
-
 	/*
 	 * Start the TOD clock ticking.
 	 */
@@ -2038,17 +2064,35 @@ static void idtcm_set_version_info(struct idtcm *idtcm)
 		 product_id, hw_rev_id, config_select);
 }
 
+static int idtcm_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
+			    enum ptp_pin_function func, unsigned int chan)
+{
+	switch (func) {
+	case PTP_PF_NONE:
+	case PTP_PF_EXTTS:
+		break;
+	case PTP_PF_PEROUT:
+	case PTP_PF_PHYSYNC:
+		return -1;
+	}
+	return 0;
+}
+
+static struct ptp_pin_desc pin_config[MAX_TOD][MAX_REF_CLK];
+
 static const struct ptp_clock_info idtcm_caps = {
 	.owner		= THIS_MODULE,
 	.max_adj	= 244000,
 	.n_per_out	= 12,
 	.n_ext_ts	= MAX_TOD,
+	.n_pins		= MAX_REF_CLK,
 	.adjphase	= &idtcm_adjphase,
 	.adjfine	= &idtcm_adjfine,
 	.adjtime	= &idtcm_adjtime,
 	.gettime64	= &idtcm_gettime,
 	.settime64	= &idtcm_settime,
 	.enable		= &idtcm_enable,
+	.verify		= &idtcm_verify_pin,
 	.do_aux_work	= &idtcm_work_handler,
 };
 
@@ -2057,12 +2101,14 @@ static const struct ptp_clock_info idtcm_caps_deprecated = {
 	.max_adj	= 244000,
 	.n_per_out	= 12,
 	.n_ext_ts	= MAX_TOD,
+	.n_pins		= MAX_REF_CLK,
 	.adjphase	= &idtcm_adjphase,
 	.adjfine	= &idtcm_adjfine,
 	.adjtime	= &idtcm_adjtime_deprecated,
 	.gettime64	= &idtcm_gettime,
 	.settime64	= &idtcm_settime_deprecated,
 	.enable		= &idtcm_enable,
+	.verify		= &idtcm_verify_pin,
 	.do_aux_work	= &idtcm_work_handler,
 };
 
@@ -2173,9 +2219,10 @@ static u32 idtcm_get_dco_delay(struct idtcm_channel *channel)
 	if (n == 0)
 		n = 1;
 
-	fodFreq = (u32)div_u64(m, n);
+	fodFreq = m / n;
+
 	if (fodFreq >= 500000000)
-		return 18 * (u32)div_u64(NSEC_PER_SEC, fodFreq);
+		return 18 * (u64)NSEC_PER_SEC / fodFreq;
 
 	return 0;
 }
@@ -2188,24 +2235,28 @@ static int configure_channel_tod(struct idtcm_channel *channel, u32 index)
 	switch (index) {
 	case 0:
 		channel->tod_read_primary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_PRIMARY_0);
+		channel->tod_read_secondary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_SECONDARY_0);
 		channel->tod_write = IDTCM_FW_REG(fw_ver, V520, TOD_WRITE_0);
 		channel->tod_n = IDTCM_FW_REG(fw_ver, V520, TOD_0);
 		channel->sync_src = SYNC_SOURCE_DPLL0_TOD_PPS;
 		break;
 	case 1:
 		channel->tod_read_primary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_PRIMARY_1);
+		channel->tod_read_secondary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_SECONDARY_1);
 		channel->tod_write = IDTCM_FW_REG(fw_ver, V520, TOD_WRITE_1);
 		channel->tod_n = IDTCM_FW_REG(fw_ver, V520, TOD_1);
 		channel->sync_src = SYNC_SOURCE_DPLL1_TOD_PPS;
 		break;
 	case 2:
 		channel->tod_read_primary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_PRIMARY_2);
+		channel->tod_read_secondary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_SECONDARY_2);
 		channel->tod_write = IDTCM_FW_REG(fw_ver, V520, TOD_WRITE_2);
 		channel->tod_n = IDTCM_FW_REG(fw_ver, V520, TOD_2);
 		channel->sync_src = SYNC_SOURCE_DPLL2_TOD_PPS;
 		break;
 	case 3:
 		channel->tod_read_primary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_PRIMARY_3);
+		channel->tod_read_secondary = IDTCM_FW_REG(fw_ver, V520, TOD_READ_SECONDARY_3);
 		channel->tod_write = IDTCM_FW_REG(fw_ver, V520, TOD_WRITE_3);
 		channel->tod_n = IDTCM_FW_REG(fw_ver, V520, TOD_3);
 		channel->sync_src = SYNC_SOURCE_DPLL3_TOD_PPS;
@@ -2221,6 +2272,7 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 {
 	struct idtcm_channel *channel;
 	int err;
+	int i;
 
 	if (!(index < MAX_TOD))
 		return -EINVAL;
@@ -2248,6 +2300,17 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 	snprintf(channel->caps.name, sizeof(channel->caps.name),
 		 "IDT CM TOD%u", index);
 
+	channel->caps.pin_config = pin_config[index];
+
+	for (i = 0; i < channel->caps.n_pins; ++i) {
+		struct ptp_pin_desc *ppd = &channel->caps.pin_config[i];
+
+		snprintf(ppd->name, sizeof(ppd->name), "input_ref%d", i);
+		ppd->index = i;
+		ppd->func = PTP_PF_NONE;
+		ppd->chan = index;
+	}
+
 	err = initialize_dco_operating_mode(channel);
 	if (err)
 		return err;
@@ -2302,26 +2365,40 @@ static int idtcm_enable_extts_channel(struct idtcm *idtcm, u32 index)
 static void idtcm_extts_check(struct work_struct *work)
 {
 	struct idtcm *idtcm = container_of(work, struct idtcm, extts_work.work);
-	int err, i;
+	struct idtcm_channel *channel;
+	u8 mask;
+	int err;
+	int i;
 
 	if (idtcm->extts_mask == 0)
 		return;
 
 	mutex_lock(idtcm->lock);
+
 	for (i = 0; i < MAX_TOD; i++) {
-		u8 mask = 1 << i;
+		mask = 1 << i;
+
+		if ((idtcm->extts_mask & mask) == 0)
+			continue;
 
-		if (idtcm->extts_mask & mask) {
-			err = idtcm_extts_check_channel(idtcm, i);
+		err = idtcm_extts_check_channel(idtcm, i);
+
+		if (err == 0) {
 			/* trigger clears itself, so clear the mask */
-			if (err == 0)
+			if (idtcm->extts_single_shot) {
 				idtcm->extts_mask &= ~mask;
+			} else {
+				/* Re-arm */
+				channel = &idtcm->channel[i];
+				arm_tod_read_trig_sel_refclk(channel, channel->refn);
+			}
 		}
 	}
 
 	if (idtcm->extts_mask)
 		schedule_delayed_work(&idtcm->extts_work,
 				      msecs_to_jiffies(EXTTS_PERIOD_MS));
+
 	mutex_unlock(idtcm->lock);
 }
 
@@ -2342,6 +2419,11 @@ static void set_default_masks(struct idtcm *idtcm)
 	idtcm->tod_mask = DEFAULT_TOD_MASK;
 	idtcm->extts_mask = 0;
 
+	idtcm->channel[0].tod = 0;
+	idtcm->channel[1].tod = 1;
+	idtcm->channel[2].tod = 2;
+	idtcm->channel[3].tod = 3;
+
 	idtcm->channel[0].pll = DEFAULT_TOD0_PTP_PLL;
 	idtcm->channel[1].pll = DEFAULT_TOD1_PTP_PLL;
 	idtcm->channel[2].pll = DEFAULT_TOD2_PTP_PLL;
@@ -2420,10 +2502,11 @@ static int idtcm_remove(struct platform_device *pdev)
 {
 	struct idtcm *idtcm = platform_get_drvdata(pdev);
 
-	ptp_clock_unregister_all(idtcm);
-
+	idtcm->extts_mask = 0;
 	cancel_delayed_work_sync(&idtcm->extts_work);
 
+	ptp_clock_unregister_all(idtcm);
+
 	return 0;
 }
 
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index 0f3059a..4379650 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -10,11 +10,13 @@
 
 #include <linux/ktime.h>
 #include <linux/mfd/idt8a340_reg.h>
+#include <linux/ptp_clock.h>
 #include <linux/regmap.h>
 
 #define FW_FILENAME	"idtcm.bin"
 #define MAX_TOD		(4)
 #define MAX_PLL		(8)
+#define MAX_REF_CLK	(16)
 
 #define MAX_ABS_WRITE_PHASE_PICOSECONDS (107374182350LL)
 
@@ -90,6 +92,7 @@ struct idtcm_channel {
 	u16			dpll_ctrl_n;
 	u16			dpll_phase_pull_in;
 	u16			tod_read_primary;
+	u16			tod_read_secondary;
 	u16			tod_write;
 	u16			tod_n;
 	u16			hw_dpll_n;
@@ -105,6 +108,7 @@ struct idtcm_channel {
 	/* last input trigger for extts */
 	u8			refn;
 	u8			pll;
+	u8			tod;
 	u16			output_mask;
 };
 
@@ -116,6 +120,7 @@ struct idtcm {
 	enum fw_version		fw_ver;
 	/* Polls for external time stamps */
 	u8			extts_mask;
+	bool			extts_single_shot;
 	struct delayed_work	extts_work;
 	/* Remember the ptp channel to report extts */
 	struct idtcm_channel	*event_channel[MAX_TOD];
diff --git a/include/linux/mfd/idt8a340_reg.h b/include/linux/mfd/idt8a340_reg.h
index a18c153..0c70608 100644
--- a/include/linux/mfd/idt8a340_reg.h
+++ b/include/linux/mfd/idt8a340_reg.h
@@ -407,7 +407,7 @@
 #define TOD_READ_PRIMARY_0                0xcc40
 #define TOD_READ_PRIMARY_0_V520           0xcc50
 /* 8-bit subns, 32-bit ns, 48-bit seconds */
-#define TOD_READ_PRIMARY                  0x0000
+#define TOD_READ_PRIMARY_BASE             0x0000
 /* Counter increments after TOD write is completed */
 #define TOD_READ_PRIMARY_COUNTER          0x000b
 /* Read trigger configuration */
@@ -424,6 +424,16 @@
 
 #define TOD_READ_SECONDARY_0              0xcc90
 #define TOD_READ_SECONDARY_0_V520         0xcca0
+/* 8-bit subns, 32-bit ns, 48-bit seconds */
+#define TOD_READ_SECONDARY_BASE           0x0000
+/* Counter increments after TOD write is completed */
+#define TOD_READ_SECONDARY_COUNTER        0x000b
+/* Read trigger configuration */
+#define TOD_READ_SECONDARY_SEL_CFG_0      0x000c
+/* Read trigger selection */
+#define TOD_READ_SECONDARY_CMD            0x000e
+#define TOD_READ_SECONDARY_CMD_V520       0x000f
+
 #define TOD_READ_SECONDARY_1              0xcca0
 #define TOD_READ_SECONDARY_1_V520         0xccb0
 #define TOD_READ_SECONDARY_2              0xccb0
-- 
2.7.4

