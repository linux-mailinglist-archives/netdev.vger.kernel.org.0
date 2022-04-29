Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3658E514EB2
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239491AbiD2PL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 11:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238173AbiD2PL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 11:11:28 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2139.outbound.protection.outlook.com [40.107.114.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D67D3DBB;
        Fri, 29 Apr 2022 08:08:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nb+3FaN7z9voo5CIaxHL6sSbZOL4Mlr7w3WSvsVw/7vTJZiKkfeZRijSJJ7Njyzq26GV8NbQJRIK0maZGupEQbmT8q/EV7vKfc/6GHju9mAKWjfPrQVcMjLvFpJFZPb4RYPFAz4Ftm12277R1Ru6APMhWtz0wg2rIskYzug5/NDna721Vr8M17U1lBbsAnkiaEHfOpt1uKJyeBnDboqk1pJZ+pxvS8v7k7wIo/LZDWKsivZHyJv99PeKoYVFB2SZsoE0sIAQfhV5EppObeYjzrJLz9x+1JRoUrLspYxTKTxCKOoHkqGParDv4f/Ww6GOHfk1E/MTKmaXYPEjVYd7Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QRC+vrmiIjEF0IIDyAC9MIHi3lNmoY2kXYxBmzIA25k=;
 b=T6azsiAyMMbYYMbxGqYO8kFE1eO5X2eiGlx955UA8yGrMQR37OUwZtK7Jo6prsIPnwCqfTcZZfp5pNH0PBcnEJSDveFPdpXDaGVS7ATKNTW0Bz6oVV+7JxwdE27FGLm6uPrFl8FeCTxYCf9IqsP2bAyEPv0w0AJTJowd333SYDlVssr92g+D8Li+CKcnjJ4maEMZlmyBuLy6Cl0FdX/gyuw/sP2fcPqzpyX1IDTo0EL/mMH8U7Q8arkAXdDt5PYczTcfjICInfJYkDcpYFsq9rCr6MwbZd066jPRKzSBk9xoLCZ7AVt0qFGJ1P8lRCCjhTdDoV7ghl8okywd5LtAtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRC+vrmiIjEF0IIDyAC9MIHi3lNmoY2kXYxBmzIA25k=;
 b=kMKLAZOI3ncecd+PgRTeUzVzN86UhBKPCArxFDiGv5ye9xBM4bX20Xy0DnL3+SIV5SVAeKptJt+BXrZUbXcjw2uKvbFIu4qJKnE/y/Ewq25bboXG93YsmPPaaPVxWxJFmxkJl7taZmBMyzR7yeqNMk52qBZMAV5Q9/Ujs3TTXj8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by TY3PR01MB9667.jpnprd01.prod.outlook.com (2603:1096:400:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 15:08:05 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663%9]) with mapi id 15.20.5206.012; Fri, 29 Apr 2022
 15:08:05 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net v2 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS support
Date:   Fri, 29 Apr 2022 11:07:43 -0400
Message-Id: <1651244864-14297-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: BN0PR08CA0007.namprd08.prod.outlook.com
 (2603:10b6:408:142::32) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 103ce947-9b3c-41d9-d89c-08da29f20c26
X-MS-TrafficTypeDiagnostic: TY3PR01MB9667:EE_
X-Microsoft-Antispam-PRVS: <TY3PR01MB96675341CCDC63DDCB94D6FEBAFC9@TY3PR01MB9667.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dhWbEx3592DPJBJ9tkDzkUY9J80JVDLXVAjHFYAM3vknIZlXWp74s122rh7Bx/I1DBXsy56pv6D6fYKfGCAJSTUujiCiuLiMoN3j3ImRoraIWXNKjipdGXVtcD52GVtCp6tt8xwFZ0aSCSL/IaFjKF0c0lYZLW8aKo7Nhsx7eC/EXI6BYaTdmdDuVjlRGDPMVOUOAhmumAC9Yc9RUUw7ZkGD73LLC3rNK/I8gKBEKvK1h2hDpm6QwZQJIUi7Jsdr/F3yj2CmTuvIap9uhi6AOG8GaoV8vS1nUrdzUb2QmAucOfo6iXJatkyOMs46AqXRMCpHgUlGsICnJ/hfaGrRAH11/lCJRZGUsn+jDQlQ99MavBAK5vbzNyqgykkwd4U67VrI5yMV5D+C6WCXepowMfnEVA9ScMmHZG8YWjHD/K5I+LCs5KHfjLScHKCZ72nVzsFEUei5qR4MYkS/aa6if7UdN5utQulEXtRY3IybsiiyHicxZGqA9KXaGAfVyrsNE0i//9OQAp1cHUoGxYpjDHq2m7r1eKWRIT44xJgPSqwDf9X2V+Bafi2KUEXJS1tc2uXeNkXDGkUz+FitPfbGCVIYGtI9ZMNwgsh0vDUBT+m1+hcLKWfo3HKPTSx0j8V0S/5MZ1mWAqINQGK7SmHWDHTmJUCDzik3usYHiE/bFviyOI6ILKzKC7A6OHdB6MBHMTTOftHAzwe8rmWfoPAwbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(186003)(2616005)(26005)(6512007)(66476007)(66556008)(66946007)(2906002)(8676002)(4326008)(30864003)(36756003)(5660300002)(8936002)(316002)(508600001)(6486002)(38100700002)(52116002)(6506007)(38350700002)(86362001)(83380400001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ppeyrR3Q3jbuc9uMUaDHuxzgN4Hi9sPewR3pk/4R8LDO0PkZeVnxyFxVQdPJ?=
 =?us-ascii?Q?TKe9FfApBxfG5sAreY6fAl1HQDOuICDsjAbgzQdHxkXIef0RZV2xKRE21OMX?=
 =?us-ascii?Q?+S0daKYZsKT3kIyVYb17kJh2jUZ46hCBDfbolsFXsJopoOyEvtuTdRRw8xpR?=
 =?us-ascii?Q?BGvxg5xCnwxeVsC88UTGqwnlWOrKG4ZTni4a4r2Y+jsTU9+nCIfK1mBgr1Fo?=
 =?us-ascii?Q?stIFr5Xb0kcKlxH77TfpCD+iX36aA+aQyyfoP8Ds3UXpLxM/95h6MzbIhmDC?=
 =?us-ascii?Q?8nFGalomcS20B7Yfcv0BEaLt01gkerWjY3PE+rCw1DKow6TV4r8WLCoT4xGy?=
 =?us-ascii?Q?wM7hXkCK7NbZjspaPwd3zyX+fugnYtVXBzyf2kgo0VM5RS23+0DMe97kKduP?=
 =?us-ascii?Q?jgMYnJBPRFfHl+wAH1YZgSw4fev1l9wKzxpR34LsZ2I/CX0uU6pD2wq+6fG1?=
 =?us-ascii?Q?13EXFFPwKKz1E/lPKkEiuIM4bRflfut49wjR708F8tT8ZH5z0eSAUAzJLAOi?=
 =?us-ascii?Q?okRuAgiLXtgDdYb0ih/Mb9/lR/qSr79Uz+dLXZrlrBOaImWM53AXRA2G2Fe7?=
 =?us-ascii?Q?5e32m1fDBuwABB1coq8X/T9cQIWJXCDC7gyqzGSN1KvehBQCR1a9mzD1iBEY?=
 =?us-ascii?Q?zGYxhXGNw9LsizDTUlmQX02kyHWNwckhEkWxIFYK5YUg/6f6dqmrZ3qCNJyV?=
 =?us-ascii?Q?3vcywzsDwi9Uh6wKCfg8IyRRwaB+pBF2Gx8un7Y+l9rqWQACT8l8KZ1ujq7t?=
 =?us-ascii?Q?F3Ces1asujxRYocX39rdUSzgCfSJyxdkHr1BOUIfYFztfEs2+v9fcLEJT4fz?=
 =?us-ascii?Q?swR3xsw/YyVar2cR914Xc3mSKfs/rsSNavu3ZQ+O1uD0nKOvg8F+z2cKvUz1?=
 =?us-ascii?Q?3qM87qY5zPQ6WTtW8XfvvpcV4hVgYPnmGGLBpd4dFOxShXruzDTELC9Q9iwM?=
 =?us-ascii?Q?fNijjqmQKjjLwkSMmXlUsVReo5ADX6zA6/68wugh/vKu2W9fmBIqQcdn7BsT?=
 =?us-ascii?Q?itVWSNhoxxSvMQHBjFdkzK2ibKRq6xsxYFYYSnc0r3th6eLi/Y635tZPolrS?=
 =?us-ascii?Q?PcKMokf3eKFisKeUgL5ahP5sfI9p8Gw9moUP/WnZq68aabIqkbXT+mrHXC6r?=
 =?us-ascii?Q?Ln0jIk3cEuHhwfEgqa4npGU8i1YgE5aOvxowdIySkrSv6wgHxl3f/TCqoPbu?=
 =?us-ascii?Q?ZbbENS/wZqIDIwFqwjI2uQYvYo8lU7KZmCbAiOuK/++t5OMSF6lEWCRC9ZKy?=
 =?us-ascii?Q?oNh89er3Ibmkjk5f9nFFWalTAswj7sP/99OlEOxGwhEUwD42BDPQegceGZcG?=
 =?us-ascii?Q?P5jFZfzuJy49RBGnhOP3uR/tXwG9BizTHYaFNPFxejO77LYil7BkaIhQbTin?=
 =?us-ascii?Q?0SV/EQg5yXzB6dpe5SxmaE8Wiv6XIE7SIm1Qx3RZL1pBxNIsgt9vemaHkEhC?=
 =?us-ascii?Q?dyyumFMc0y2Im2OvgD7DU2JpqMAUT2LxcmDf1JMsY5Phe7ymDfLTQWgiEI1a?=
 =?us-ascii?Q?HRCggr3BJxcZb1JKk3BZG5Kq4mBF+DoHu0gzVKGs3sbdEF4xovmjlJZzWdFd?=
 =?us-ascii?Q?zwi0qkv1Bbrqe200Jmv/eOvRAhMRdosxOfrpnIwjotRzvByGjbco+yEa201i?=
 =?us-ascii?Q?WXbfP57Gr2V97whuDcp5+POb5IJEcbCH8NE6pHRVw3sdPly737vDct6jm9g/?=
 =?us-ascii?Q?4bcfu5Yqvj0qq95nqlJxaav93x9PVeJuWWJsNE1BcyzvIiMJRVxNjsC57okk?=
 =?us-ascii?Q?4DP6XX09CH3ECpg+EW0EOqe3MxjuOdY=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 103ce947-9b3c-41d9-d89c-08da29f20c26
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 15:08:04.9527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EcMQW6Y6bNTxst1K/PD8buk5SIGvPrX9SwtS0qY6WA21dcbiLC3sShWqd8/76CbfwPj81ogm/lR4MWMM5qERbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB9667
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
changelog
-use div helpers to do 64b division

 drivers/ptp/ptp_clockmatrix.c    | 297 +++++++++++++++++++++++++--------------
 drivers/ptp/ptp_clockmatrix.h    |   5 +
 include/linux/mfd/idt8a340_reg.h |  12 +-
 3 files changed, 206 insertions(+), 108 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 08e429a..3a18f38 100644
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
 
@@ -2174,8 +2220,9 @@ static u32 idtcm_get_dco_delay(struct idtcm_channel *channel)
 		n = 1;
 
 	fodFreq = (u32)div_u64(m, n);
+
 	if (fodFreq >= 500000000)
-		return 18 * (u32)div_u64(NSEC_PER_SEC, fodFreq);
+		return (u32)div_u64(18 * (u64)NSEC_PER_SEC, fodFreq);
 
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

