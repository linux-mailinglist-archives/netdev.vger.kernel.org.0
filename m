Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8BFA51AFC6
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378396AbiEDUy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378367AbiEDUyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:54:54 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2092.outbound.protection.outlook.com [40.107.114.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440D350E39;
        Wed,  4 May 2022 13:51:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lC5AOlFMLExwRmA6FKtyKNvMqt0b2Xhxa0M3n9sDqSBXq/QTbWRW6T4fT+VePpOVr1tsANtmYFoUgK3p+vsGDAZ3QqVGJpGZnwpy1mpbVK6woIPPXj+qjLYrUs5hl7Qiyp+JQmhV66y4mz1ScUy9YVuSdDMzW7UCVn++Or6XdM5Ix4J37fiZM35GuPhwdeploG+R6n3bvzNpAGLo+Ko6GnMD5jm91cvz0T809fKtT/3O1usdCWZ47EJSKbhqS9meW0PNo4QkLl0R3BbpdIoumC1GzoXoJJT/d71c/+RHYNfTACMn9gdyv5Kc1sMvyThELSfQJKZF6vDIljKSm/fniQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eHmW/3NjCsZ+jsLLKTd4YOnktpHtSC/8EXAsz4L1BMg=;
 b=NpCtZJY4a4k5tsSRg0cJwvvG2J/IXtPGMUXfZnZa8K2IsvSGlcW4FyB/Rc+dxz1Z6z2+u7biuANhFGQals4gaw4/r72Vj98coqAeCWcGkwBl89Qw8MvwxZ0P3r2V9fr5mhmGWebXWAmu5hadbK/+QA2Rmk0OzYIs/7WnlvrUaiCnIzBXc0Gz9/qT8v3TAMcC3X4t4PJHBG+z5PzbHGa8zAG2L7RuWX4Dg432KGhm9FLd9iIBwJSfHPhAXgAHo8+vG/D2Mw5XMXEUiFICOD/wJCFiafOsxPoT7QNfEJ97skqC8dXmCt+YhUsZ2/H8lPwpY1NEcz9xny1RFbLVKiso8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eHmW/3NjCsZ+jsLLKTd4YOnktpHtSC/8EXAsz4L1BMg=;
 b=iRkR1V/0MNtPvrE6xBq6P2z+9jnAlNlBW5W3lGNJL1Ntb3/XpjXFuuQvE43tfIXfTROfHI8VmK3xi0pAPLJs9YFfFqkwlrNLZbUGFJCW1eivRPGalnw3pkl5H8pvb5slrdqcwddGEccUVfQKlx5rNupkQ6i51Ml9+X5dT9CsawE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by TYAPR01MB4431.jpnprd01.prod.outlook.com (2603:1096:404:12d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 20:51:15 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663%9]) with mapi id 15.20.5206.027; Wed, 4 May 2022
 20:51:15 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net v4 2/2] ptp: ptp_clockmatrix: return -EBUSY if phase pull-in is in progress
Date:   Wed,  4 May 2022 16:50:55 -0400
Message-Id: <1651697455-1588-2-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1651697455-1588-1-git-send-email-min.li.xe@renesas.com>
References: <1651697455-1588-1-git-send-email-min.li.xe@renesas.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0779.namprd03.prod.outlook.com
 (2603:10b6:408:13a::34) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 864e2046-3383-41e3-c07c-08da2e0fd44f
X-MS-TrafficTypeDiagnostic: TYAPR01MB4431:EE_
X-Microsoft-Antispam-PRVS: <TYAPR01MB443149BD841085F44734536BBAC39@TYAPR01MB4431.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S5PsV3Msh6ITmM9SYEHN4VANRQekjeY5q2uwxnF8SJDurVqadWdpjWoukrKb9srBUQ3T6bSdb+4CdBPE+9FBMXbWEAPI9gBrizF2DfS2l8YSnn/YmPAguTAznzdPZuHKvlKkCuhgFlXz9LsJKnQsEFJUKUF2gJJimaZBE8ipcBYrVeyDY6f1D3Ipj5JpAI99gawDOAVGTGqxxKH5bj5B5N8osziIkoZPePvzz/8+HJ94+HhthFgU27RoIr3iJSK2hboCiY4ZNjhBSkM7krGTjupZAcwMvfEX39AKWka6OmgFTPZIYIHAQrkrtLYC+Dwq//qOe2bv7hFE8DOX1zCFANqT2AQVTL9yM+dOjqR+Zl6ZqGpX3wtZIZBS8bq/4dStLXf6w44HPumY2qlu2EEMZa9Ae1b9e4K3UuH3zr7B/wnSygEyZleCYnt5SJO3rXEH7rgwmQdEQAqazqQD3F9T6xmJDBAL6iHrX5M1ODSqdib5FAWwEf3xzIuALXk+Lp929CT7V0fYJQAPQTwJ9Hl2eD/2sfDq9jcly9qHcG9ixRtFf5z23meIqdUGGRm2alsMouUjOKqNZ9NzlacK8XHg/qMbl5+AqP0BDdncpF6tIjRcfUPQW/T5owK3pX8B3PImmP0FfWhZZsBdKTYRjv0yVX7553dOXOOIlyl1sRxTJFJBmpz6Z9ocY+O/thzQB6EJHDhdL75YKxg2KJMgMSr1LA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(36756003)(6486002)(6512007)(52116002)(26005)(6506007)(2906002)(107886003)(38100700002)(2616005)(38350700002)(186003)(316002)(86362001)(8676002)(66946007)(66556008)(66476007)(4326008)(6666004)(83380400001)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kGy0GSk/fcHIaXCwjwZR0o+/wNEjKeL5X7s3zOx/tQGMmAF32otffB82MetI?=
 =?us-ascii?Q?Z4nPDvVc97wSgbBtyp2uDryPC0Dh1j4RcfruBQS2h+MmpUGgRbnjRycDxSCo?=
 =?us-ascii?Q?1FC6CXYTq6U9yP3BKx5nKEoE0LKACoFarKe7FOAgcAtKfc61scBlsBf2T9NQ?=
 =?us-ascii?Q?gXPwJSlZVKSTKB9QkQrA8Kyd+9DmOtgm03nysSjAG/3W66igQ3ZtdQ0h93h6?=
 =?us-ascii?Q?MolkJ9kaBwNv6c5MRM+IsbWmFUNV5BtPg4F2L0P/PeJOMZBVbJBl84Gzvo8g?=
 =?us-ascii?Q?+BzQ0uWyZO3mzCtVmyirj7OFBbhwKq6IFXB8N+11fJv+H3rm+MxTZwSad3uO?=
 =?us-ascii?Q?DoRu9S1k0VOwuEQIHjXbvUA3zdcauf9Mg3LdRJ5qCmJv+nsZVBBgWrXkdLXI?=
 =?us-ascii?Q?//8iEH7Rq6R7OLMdaSH2bhLfX8dEd1i0M9bXszHuA1p9h98L0Zb/BgEkokyo?=
 =?us-ascii?Q?ig0oNiP8cPh7J5TANewh1LC9FgcKjqxaxs627GgILZFAmwl5hN8FX8ZA5EXo?=
 =?us-ascii?Q?YPLCnutCIR8kClGNEgTwi5hCBBb9TFhZinPSLOlkItI7lRKLYWiMGUen7ffU?=
 =?us-ascii?Q?zPkZcsn9LcO8BVnov/44Nn+aXus/+37tZbb2pv+MtxjaOxy61OdZWscXBd2o?=
 =?us-ascii?Q?wtNdRx9B1gijyTBcWcn/OcqneqUxr7aWHT/UMBoSXJdyfN2D4vrZnJCGBIQm?=
 =?us-ascii?Q?sbm/iDpdzh+I3RsMwW0EVR3oIJdrUHSw2kO4TQFwUl6JZ/STKW9utlIxkRoN?=
 =?us-ascii?Q?Q3hCk4T+Q1NAv7Bht0AjG7VMmEpDYvuWwpoIRiM0SakchU8evKy3UJYf6jIc?=
 =?us-ascii?Q?pm2qmOw/ZtUZb5hM5CXTZGYR93wo7GCDp/KzeiIs0R8vpQTBuBRblZBVVBGN?=
 =?us-ascii?Q?Pf4k7wv/KckYUXih8HvWtGjVa35iKyv/YnlyjNoKSYSMt7SFmduM1Cd7fvp0?=
 =?us-ascii?Q?yfRhVxPo/5hbzKTwf1EqLtfLVoMKjPUR0eJKfYjIVPFToBIfKdqKdJQltMRt?=
 =?us-ascii?Q?F/t7kKVW4elfe1CrwMVNoAWeZsGvsdcni2bMDJKTMRdytNL7PSiyTDAKtBUS?=
 =?us-ascii?Q?DV7AmEzLxLrMva8tP07f9+nUU4xtGs6/s+tQNNZHmKxdKTYWtBTER84vQIBX?=
 =?us-ascii?Q?xP+shjrAfXasHymUA5vdnl9EWBMyOq9+2DYzKvK/zYPzmkfEoQ+lRfHfBvx4?=
 =?us-ascii?Q?JJrmx3Ox3XuilOiPNxaujsyCqv9Fbpu84zCoHE7tK9lqDxDOwu/xVUhFh45m?=
 =?us-ascii?Q?jLyOSwycujkHvSNnsSNAjUeP6wBctxAs88A4TC9yxNo4RVmMyBwSfZ45QGbJ?=
 =?us-ascii?Q?CrF2M3s3bOeL+y5qE7/v/5+o1eR+Y9w/m5fcKsr5BbmMN+iA61UL63F2xFUl?=
 =?us-ascii?Q?Pw8i7ptAQjR1wARaLAxq1NJ9Cvl/igf5Uelf52nB7pJ3Gvhzf2ArlcCd+YF8?=
 =?us-ascii?Q?Q4Xl4rXISX0Gsm5KzSlyRbv2vWUaH9jiZxEzDsfL+7ARo1vNm2tsZ9cQ9KG3?=
 =?us-ascii?Q?WcDlhSB91xCXAoi45pYo1pXszSk8D2GPp0L/LGeBfULShutEqUUc/N4xvc0r?=
 =?us-ascii?Q?+nm/9n/xkUfWmRv40AWn5amnHSZ3sDcJiZVh+w4o4FvrYKL1ikS4lmkx00Ch?=
 =?us-ascii?Q?z4PvYZwmi1fxazbLS/F2tkFMIdNs7AFfph1Z59gpomRhdrIZ6j6bUvbG3eYU?=
 =?us-ascii?Q?NYKaPI6CunMdlZNjg/lY8jEQ39XoHIWKJKtkk5dAJ/qo9ZN+PhvJVsRmX5XP?=
 =?us-ascii?Q?mbJ+kRheKymlsQSHEeSKHQ59VJxPEx0=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 864e2046-3383-41e3-c07c-08da2e0fd44f
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 20:51:15.0230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VGSALjVY34NbJ0gId3I2xl5zHardAXuINQunXDBE6chNRq5DwWWM6g4TLPMKA28sLAw2emZnjRUsl16JEES+IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4431
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
index 70791dc..e9257dd 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -1355,43 +1355,15 @@ static int idtcm_output_enable(struct idtcm_channel *channel,
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
@@ -1895,7 +1867,7 @@ static int idtcm_adjtime(struct ptp_clock_info *ptp, s64 delta)
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

