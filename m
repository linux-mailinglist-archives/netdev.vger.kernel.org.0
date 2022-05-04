Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37BB451AFC5
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378390AbiEDUyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356615AbiEDUyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:54:53 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2092.outbound.protection.outlook.com [40.107.114.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE16506C8;
        Wed,  4 May 2022 13:51:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FaKt4meJiJqU4GiAoAK7BSElkMmM1d4I3sGKbEOlzIDmxSKl3jf1YLRhv5WkNvx8wORccqZJd0zPUYgawQrGvH9RMfrgjjXEuWQgS1TatI93FlQSaFdpP4OknZNturSi6br+c+g6PmQsR5bWGV87ClJU8n6G/mI20L4Y0gh86HrJYxR/VuyvcGdvqXRwmOm/QS5z6HRPH4CNWLaJjWNSl1g1K0RPRMD2qh17aPxsr9MwXXr8xS4iAvyDEJmzlAmVL0YqetK0fZ9AjRHeQBqTnnqu6Xdbml8BYGy5fq+VHDJZi/+nRHBm1KdXsM8YmVNbQe6ny0pOHNtxvrE9ZP2qrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SF94BerCkYWbC//Ll7KRW4PAEmAoN2c/rjCIcqLKdfE=;
 b=oPqTF0MZmqzWTkQSe6FCEq/8PEIo1d3t0Fa+UDJxeSASqMq+OOFCz8cG79v5/7V9IVMxT1VxzEt8K+nqs8i1DFsumobPAMNjo1IWE0FVGxDtZ53wWiRc2asbtc52fKsj4V1SSRTVeFa0mbg8lKWdOIFKiYEVXomieomwKYbr/WflFwRtBVd8bszLVnKwT+cTKmS+Lmb6vIVrI5Dp5FZPIwIyeT6Kn7bqgUqP229aTbCf8C+EcU+fwGu3JY7ip7Fy+SdQSjaW4hDQEjEZqNc7M5sD1YCHmia8NYGiGEsxkMfhwoyZHl+pgyn3uvWu7XJdKC8z7AMCAMPORTBX8e4Eqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SF94BerCkYWbC//Ll7KRW4PAEmAoN2c/rjCIcqLKdfE=;
 b=TFGkGkXSOR52Skl7mkH6S5YPn4Jgk3rFUtNsqTq6Qd9XszKANjufZqQzUjqZBcdtlIiZ/15P8DdJl6/YVuK2uFeiQ3J2NHt4t+eVl+OPr2ILE3GKi7HKzO4WFCNL/Ykd9wVRHpoR0RsvJg8FSUPpo0tfrPm2YeZFjcurLb1isuE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by TYAPR01MB4431.jpnprd01.prod.outlook.com (2603:1096:404:12d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 20:51:11 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663%9]) with mapi id 15.20.5206.027; Wed, 4 May 2022
 20:51:10 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net v4 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS support
Date:   Wed,  4 May 2022 16:50:54 -0400
Message-Id: <1651697455-1588-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0779.namprd03.prod.outlook.com
 (2603:10b6:408:13a::34) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90c0c9c0-3b0c-4971-72bc-08da2e0fd16c
X-MS-TrafficTypeDiagnostic: TYAPR01MB4431:EE_
X-Microsoft-Antispam-PRVS: <TYAPR01MB4431099EDB6832A2A6F2E4D7BAC39@TYAPR01MB4431.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F++T24OP9aMWkM1tK3mPCAPs/V9T44SpgBRVvNu2KmmFnIZmHx1ow1W6bW1AEUoxnXzLAGtRu016hYZ7WAyvWwjjl8eoIgcjspnKMofcUKqTprGQV/LM6qsSjfE2bOQxLtatqRTOxOAsBEjxMxUA82pW+t6/fzWlEYDbn09j6zf2JVZ7iAJIfAUhvCev68SEGcIAse4+TcRLJ+q3LBoBIKjxtWW3BFoEZrYX+Ms9Ys5Lyd1b7umew1Ir9GHpZc1spYQFhrthXHkGUclrXGpeTo42R6RT0FCs16fF7uZyQ10LFyODcZIShRVVnubaJZ8xxva5Aipdw5r7hslyeQPS6Bi04GohoNXAMWjZC+cAglc6AtWE470zhGXrqupWG4Op0X6LYXSaT311sWqFXHWpsN8ZziMgrIXOdmomyLLu/7igTSI7t9+1WdXnfmeploORk5bZiEfI4CpnB41bmURp22muOG8jGEuCxfVJlysoEUH2uRDlhSVmWOTl8xyzMXggY4S4wDHuhiaHjt9u5A9bYZZBGjwhFSvw3bTAiNGKcl+24Bd+cetcofq+nChCNsQseCryYn4hv8a6AWCNAmHnjKlpPFdUDw1TVzdbSFAUqix3/VM2Co5e75DFVW7CqyOjhKnGVJqd8TtpgtJAaB/IHu+vjg2CWAPDVIZdfNnA5MgMDBdxdlIWDFJ2EXWzG+PrZAj82Y/H25MKbPAOwY4Pqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(36756003)(6486002)(6512007)(52116002)(26005)(6506007)(2906002)(107886003)(38100700002)(2616005)(38350700002)(186003)(316002)(86362001)(8676002)(66946007)(66556008)(66476007)(4326008)(6666004)(83380400001)(30864003)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/a10mzW2HdactfPAewOiGaHgRmVBbIKcW0r6NeDGf0rr3yZU9VGUaldnXquO?=
 =?us-ascii?Q?u2SAgsSslvMiCDdNCDxFhcwJThADaXtZMhzlVTX2CrYabOvM6wKjHWHTzWSd?=
 =?us-ascii?Q?JZq/fjMjeIN7zGGutW/yqp6XkAzUrQ2rJYsnOhQ8TwL9kVbcbgR0G8nnWxLe?=
 =?us-ascii?Q?Xv4YOKQ0+emB5w6S2ffxZKdNxHN6HDPH3H1AF4QVpnO3yhSqUdX705GqfSBF?=
 =?us-ascii?Q?goUjEDys2G7w3Y4l+nj9+AO715plLi9yqQzJx+m0EXdSK5m60aqsuCKZw+p0?=
 =?us-ascii?Q?XKbU/3p/wAXE97rSeNX+GUzNtE2+k5wT7rOJ263NI0wnLSxYjvNW5+HbdMTW?=
 =?us-ascii?Q?N0FvmL2lJpR+ugyVmuzrZw/o5fngiy5IcqU+1RZ6vPuR7pfrdvn0/+LToHaL?=
 =?us-ascii?Q?7JbbDROatm8QfPGRgcQKnuAKFsZlrUEbBID2tVKP/3p2XGgtS4h2F80LeTwz?=
 =?us-ascii?Q?PsI9cJWwA7afuIv9zNpzNtz1a6DYGUuYroe1d1vmU5vf3vmbvYfNQ2geQXEi?=
 =?us-ascii?Q?8jx773T9x1ba+pzpscWUU3lyCAbKkm603FuQT9jmd2pjjwkgbuZVZTp29O+6?=
 =?us-ascii?Q?JnsA6ZRyEdK71dMlN27AdxahyGhk7H4lYcU+DAeTqo6L/Do4Bd+8b/MuNUvC?=
 =?us-ascii?Q?u/nPySSv0XFqhFa7NtmYMVxEQRtnTcVVsyP9ar9IFyq1WckS+rPyeyQBaKZ+?=
 =?us-ascii?Q?ZuTL5zosd63b51tCDAcgqJaNxpDcdFnADQ6UUEa8Z/Yd9A+86RUacnkW5jCt?=
 =?us-ascii?Q?i59+pivrAeweRCCrgRNz2zTWbk1AlwIOtdnF9IJNGAQxsyLVk3eT9xm6++AT?=
 =?us-ascii?Q?5VjCWkeObcq8ZP4wCFjLmR9wavMFkLW8jpCOYc+Iz1fowRfN6nEm5H21Q2n4?=
 =?us-ascii?Q?h6crpKTCdf0IedBiB6jgRlrDwAxidaXGjm8Kz96sItONXUwdYMB/tzWByDNy?=
 =?us-ascii?Q?NHh9n8fdWx03RDoe3VOwu0o0c0X5WNX2qITUQnbD4l8JGWaG7d7KB3cFGqct?=
 =?us-ascii?Q?A3IW0j9m7q4U98U5T8EfYIegHj6xL8NxSFf3vqpmyEeZZ4sgqlQIsIIlZu8h?=
 =?us-ascii?Q?Azc4RU5bmo1UjrieB1Yq78y0OLaiw55qVBg1olUjqHyWD9MGqSB3H1XptrIg?=
 =?us-ascii?Q?w/uOvTbSPX6UhaXU4oDdUD9/kbvS0ZkX/YEqVSaX1QM9+d8tH8il37iPYZrq?=
 =?us-ascii?Q?hDuNjqvA7okDp3JNo7R/Ag31JKbfyFujihcAT3yu2KIK/noL6brsGuiVUzbr?=
 =?us-ascii?Q?JpubJqWBf1OhAqc0sTM5ARvo7ww1xRlMe0pZnqITU428YXHUW8oyEXgUe7Yt?=
 =?us-ascii?Q?waE2aMsWEWyLv71J46sxR8pf5gVFABu6gCnlk1ZoJMU9rRmeThMS2JLJNEpt?=
 =?us-ascii?Q?KZSNhV2LFqXHvqccaT8TnRTA83SPvXhmMh2asRjByTvgHKJI2lkY/jYnvlWp?=
 =?us-ascii?Q?mC23rsHTnpWwJ8kSXiVTxE556BbGLgKGOXXf6txJQFUcPzA3cbcC2ScDUBIC?=
 =?us-ascii?Q?dHPoQD8KEH6RjrkwaSWO8D0KlUFKl973FNBiP6iEZYaNY7tXhmb1kEUSLt2P?=
 =?us-ascii?Q?9ApQF7N/GdtMzoTRqNbOTWECzmp8/TwWE9ANEeQRU1F87YwiIBHy+hIVbghX?=
 =?us-ascii?Q?S6baWgfstiDiTvdMxMfRF2hGtHjOB7Y+cDuFYAhHExZq0IAW5lTh8Oud0Kn1?=
 =?us-ascii?Q?L7FWYtME+THNbXhtMs83dflVKvKP4ifm4qsfJSMfqB2cBz13fV1BVeditQYO?=
 =?us-ascii?Q?9yhm81IKT4VWyBpOjEdOHqblaq6oRF4=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90c0c9c0-3b0c-4971-72bc-08da2e0fd16c
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 20:51:10.2403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gtwoajHkteLqq8ag20hDoT5CO3oaYFweopzW2Pr8ft1eaQLxTQQ0xT+EoaFL6kdGrbht/GjIvzf974ROHyabUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4431
X-Spam-Status: No, score=0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use TOD_READ_SECONDARY for extts to keep TOD_READ_PRIMARY
for gettime and settime exclusively

Signed-off-by: Min Li <min.li.xe@renesas.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
changelog
-use div helpers to do 64b division
-change comments to comply with kernel-doc format
-Fix Jakub comments

 drivers/ptp/ptp_clockmatrix.c    | 290 ++++++++++++++++++++++++---------------
 drivers/ptp/ptp_clockmatrix.h    |   5 +
 include/linux/mfd/idt8a340_reg.h |  12 +-
 3 files changed, 198 insertions(+), 109 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 08e429a..70791dc 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -239,73 +239,97 @@ static int wait_for_boot_status_ready(struct idtcm *idtcm)
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
-
-		err = idtcm_write(idtcm, channel->tod_read_primary,
-				  TOD_READ_PRIMARY_SEL_CFG_0, &val, sizeof(val));
-		if (err)
-			return err;
-	}
+	val &= ~(WR_REF_INDEX_MASK << WR_REF_INDEX_SHIFT);
+	val |= (ref << WR_REF_INDEX_SHIFT);
 
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
+	return mask <= 8 && is_power_of_2(mask);
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
+
+	idtcm = channel->idtcm;
+	old_mask = idtcm->extts_mask;
 
-	if (todn >= MAX_TOD)
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
@@ -371,6 +395,32 @@ static void wait_for_chip_ready(struct idtcm *idtcm)
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
+	return char_array_to_timespec(buf, sizeof(buf), ts);
+}
+
 static int _idtcm_gettime(struct idtcm_channel *channel,
 			  struct timespec64 *ts, u8 timeout)
 {
@@ -396,13 +446,11 @@ static int _idtcm_gettime(struct idtcm_channel *channel,
 	} while (trigger & TOD_READ_TRIGGER_MASK);
 
 	err = idtcm_read(idtcm, channel->tod_read_primary,
-			 TOD_READ_PRIMARY, buf, sizeof(buf));
+			 TOD_READ_PRIMARY_BASE, buf, sizeof(buf));
 	if (err)
 		return err;
 
-	err = char_array_to_timespec(buf, sizeof(buf), ts);
-
-	return err;
+	return char_array_to_timespec(buf, sizeof(buf), ts);
 }
 
 static int idtcm_extts_check_channel(struct idtcm *idtcm, u8 todn)
@@ -415,65 +463,40 @@ static int idtcm_extts_check_channel(struct idtcm *idtcm, u8 todn)
 
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
@@ -1702,6 +1725,9 @@ static int initialize_dco_operating_mode(struct idtcm_channel *channel)
 /*
  * Maximum absolute value for write phase offset in picoseconds
  *
+ * @channel:  channel
+ * @delta_ns: delta in nanoseconds
+ *
  * Destination signed register is 32-bit register in resolution of 50ps
  *
  * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
@@ -1958,8 +1984,7 @@ static int idtcm_enable(struct ptp_clock_info *ptp,
 			err = idtcm_perout_enable(channel, &rq->perout, true);
 		break;
 	case PTP_CLK_REQ_EXTTS:
-		err = idtcm_enable_extts(channel, rq->extts.index,
-					 rq->extts.rsv[0], on);
+		err = idtcm_extts_enable(channel, rq, on);
 		break;
 	default:
 		break;
@@ -1982,13 +2007,6 @@ static int idtcm_enable_tod(struct idtcm_channel *channel)
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
@@ -2038,17 +2056,35 @@ static void idtcm_set_version_info(struct idtcm *idtcm)
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
 
@@ -2057,12 +2093,14 @@ static const struct ptp_clock_info idtcm_caps_deprecated = {
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
 
@@ -2174,8 +2212,9 @@ static u32 idtcm_get_dco_delay(struct idtcm_channel *channel)
 		n = 1;
 
 	fodFreq = (u32)div_u64(m, n);
+
 	if (fodFreq >= 500000000)
-		return 18 * (u32)div_u64(NSEC_PER_SEC, fodFreq);
+		return (u32)div_u64(18 * (u64)NSEC_PER_SEC, fodFreq);
 
 	return 0;
 }
@@ -2188,24 +2227,28 @@ static int configure_channel_tod(struct idtcm_channel *channel, u32 index)
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
@@ -2221,6 +2264,7 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 {
 	struct idtcm_channel *channel;
 	int err;
+	int i;
 
 	if (!(index < MAX_TOD))
 		return -EINVAL;
@@ -2248,6 +2292,17 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
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
@@ -2302,26 +2357,40 @@ static int idtcm_enable_extts_channel(struct idtcm *idtcm, u32 index)
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
+
+		err = idtcm_extts_check_channel(idtcm, i);
 
-		if (idtcm->extts_mask & mask) {
-			err = idtcm_extts_check_channel(idtcm, i);
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
 
@@ -2342,6 +2411,11 @@ static void set_default_masks(struct idtcm *idtcm)
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
@@ -2420,8 +2494,8 @@ static int idtcm_remove(struct platform_device *pdev)
 {
 	struct idtcm *idtcm = platform_get_drvdata(pdev);
 
+	idtcm->extts_mask = 0;
 	ptp_clock_unregister_all(idtcm);
-
 	cancel_delayed_work_sync(&idtcm->extts_work);
 
 	return 0;
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

