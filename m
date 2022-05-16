Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7F6528762
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 16:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbiEPOre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 10:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiEPOra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 10:47:30 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2119.outbound.protection.outlook.com [40.107.113.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5593C2EA10;
        Mon, 16 May 2022 07:47:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AI1Pxn4gUNkkfooti3MBGKTa0hcRP/HFcO+9gRiFynh0vnUt+55wJ5sIGJUV+j1rLa9pzEBz6Uo1GzCmXehwbwQp5wsaUOW9cqaNONcFuo3WqxV1E5xIChRs7YYv7NCV8rtvCwpHuhs6V8XevOECLu25b9DcXcEaCCT/EWc06nmULM2b+7oac/JqpIKUdWPQWtHIe2S2wa25PVPk2/Wxuty59Tn+ZpJF8nMvgikTmCXvD14AfiuGMnNF7pJw/Wx6X5jf0GsPoYNlxqIa484NLWtUXsPrFv+QoPSITdrhufY5HrfCR5WW2U6bNQ9xxxuYq+/49GZm2A7EKb8EeYspiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHDraZbYNfFr/ErYDX8RPJLBItXaZzjEuxRB5KTWApg=;
 b=np1F5jE4VEhjhoM0Vvs9RxpQF2b9yRS5pACJXKb6ox0R8xchAkjONbAotHo6pyo2q8VuC+jOAwi7+2KTkg7rXGiIkiiWNmPlg64QL+BX/sR/3xYp5mLPvOrJdGI2eoVOvhhfNpUM5P5RYm/vwJ9QKn8BTKq4IzMKNHRtKToRA16PXKHM/bkIh7Yg6R+q+bklfjuVnlJCWWe8v9qx2nH62Eb2CAhvllkB+K7XiCmCKmkCukNouZHHazV+pBZccvFvhUFHYNoYHbBGFls9DMyJpMJhRu0ZDVJCfjp1FNQ7JwaGj6Qoq8abyp4jyAxWQAagN9fwl3B7qe57Q4BZnvdJoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHDraZbYNfFr/ErYDX8RPJLBItXaZzjEuxRB5KTWApg=;
 b=H1jCx+Lm/yfz0nZMDbr9PkpWDxIIyvnEdMHxgMXNtPx+Tghp2U387HX/qu62UDMrqfjGZ77BfT2RmbWKeth7S2qhVzN4XDH86QnKftmfYY6GFR4iRcyM76y1dnc+iqWzwjDhIuWPEMJtuXVbdxoBUtkY96CmJr+/eBFcmaOPD2U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OS3PR01MB8588.jpnprd01.prod.outlook.com (2603:1096:604:19b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Mon, 16 May
 2022 14:47:26 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663%9]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 14:47:26 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net v6 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS support
Date:   Mon, 16 May 2022 10:47:06 -0400
Message-Id: <1652712427-14703-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0139.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:1::39) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 817ad28f-0c07-4167-982a-08da374afe37
X-MS-TrafficTypeDiagnostic: OS3PR01MB8588:EE_
X-Microsoft-Antispam-PRVS: <OS3PR01MB85885662FED7684DE0780B09BACF9@OS3PR01MB8588.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vGpomMMWGCOkCVQ30hdktwfeNFT/E0Ogvw1jKor+ce5M8mAIsYF8c25r+1ZUx0WDQJvt4wdxvXwmvy0YI7cKoGBQ0BVF3UiMfksiYa3UhO/1AxVGkl55VXAY4OClmTkJz5px2OIqtIMZOGbKJP/fi6iKw/CcK1wiMqmiv+hAMH9ASvvXyKfumHY4G0ObE7peYfG9hI2MuA7lzLu18EFyvo4IcgD+9rXWmpCfcH/4hK3sPgEcRtpfHUjVtX7ys3xBZyUV7V0P4jQKzRq4IvfQaC2Vx2kNJV6L2ek71yfTQYYy5ioth/0Vy2OJYM4lVqRyYP4t2RsuIBp4L7fjtu/P9fqogskdgNFlBRIKUD/4yTNGG0LnH3nFPsle5Xhfu1NLyLoKYPfmvG7yQ4f5AzZ90yoagrl+FOGLgkQmuOFR6ZiT5j4LYNWZJPTwjk0JjhWbo4Mco9n8BtcwFZEgmuvah3etJ+m92ilfzQcwAsn4zw3G4LZiQvEhfW56dQKVQK9LMh1gUIAcP2/FnM4hUBJJq2275Lb+bsGp6Vz+l7FwoTJWgKSDCNvMrjGRm/e9v7993dlgaTY7Gl62UJyPbKr89gmyFcSN3aZeEGG1sZ1GuEHm36PB/3jVJC1jK5zVNt8nG8WIb/fbhl/rA79zlQCvSa1hFCMJUDqgpfqHfg5ONKkYUtE/f7liTqSicsBS9wDlOiP3ZsJmcUmu7GnPF43nWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(107886003)(2616005)(186003)(38350700002)(5660300002)(83380400001)(4326008)(66556008)(66946007)(66476007)(8676002)(36756003)(86362001)(6486002)(316002)(508600001)(30864003)(38100700002)(52116002)(8936002)(6666004)(6506007)(26005)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4vLWvCsx4ot1EbWzTsPqJqqjjBt4ttycLFcem8xhXJ5QjlUEfpi4VQzq1Mzl?=
 =?us-ascii?Q?MWeWzgXjuFyHtvJ3EOcODOoyfErEqwvxvYGlXNkr4m8WeDGseHsIbPb0qaIc?=
 =?us-ascii?Q?WbCmcg0Z8LElGxibvwsmVYdLWCeM8ABr6vVpR0uFppYy22Tkkikj0fCrIkAL?=
 =?us-ascii?Q?F+iVhPmTi5LGUpioOaWw2yJq2zORDdavVfJycBSoY/+Hd2zZPVhAerIvRZwv?=
 =?us-ascii?Q?Pp0DAOyUZLso6k7wabjz3nIUPfeZn3YOfwQVqsYLr24wupaKQAmeT2IqQwLM?=
 =?us-ascii?Q?jjeCVbf1LQjbYYWw9A6WyVOzYFLE/ra2OUrRbjrHTT04L1tY15rfiRZmbMCg?=
 =?us-ascii?Q?KXutNBciXs2hAZjpN+tIJUQjMD7qXTqdzB6H7F9NY31a8vY74nxKhWtPwXKX?=
 =?us-ascii?Q?bEc8x9cu6FZJkNa/WBN6qcVA6ry8HqJ4ZD33e8prQgTQXN77LP/2nxVaSPCt?=
 =?us-ascii?Q?HLgCL85cWU4Abolo1fJcpW8LiVdPPlaNhKbYdzH3Fo3AlKYDd5kHE4LwsBBw?=
 =?us-ascii?Q?AtM2einzV2Muf1qXEnJAVyd/Fi2RslGtym0xweH08lX9qp6LaRf9dNElU6Ef?=
 =?us-ascii?Q?tqAb5oYS70Aoh8kWadEt30+es1TisBXKrZrw+Yb430qGH5bIJN/w4srNcaMc?=
 =?us-ascii?Q?kr4Oks0rHS9E5+AITjq03GGQDhQPjUAz59zDDDm8XDlHydE9WncvgBmsWTie?=
 =?us-ascii?Q?3aBGjii/Ibwax3/gn86bmowgz1l+a2HLGa/6sybzxiUzECWZquvKH17qzOwN?=
 =?us-ascii?Q?n4LR7FVQGL8o0GJRpwuXT1fll3kiV4aZs6vJvDfF4vcAPb/GEZrCHsHyenCh?=
 =?us-ascii?Q?ZNWy2xGCLN6M1NBCWTYFsCp7x3AbPOHAymoFjg2zQ5Dt3VPR1DITMr9OovUF?=
 =?us-ascii?Q?HvcISNIeLDCmtO3VNahrJMP2vvD/WAd9UWfiDO7BRP4tNZSt3k337ROO8gKd?=
 =?us-ascii?Q?G45MlNN8+ZUSNezjsQHJHaFfQK6n0StqEAZNe4l2mH3swfcy6ddpk8xoTFVS?=
 =?us-ascii?Q?3KsEiaxMu/ghKyfo4Vcvrw5zgVpHdQ3MQP75UBv+HLTSWswJZU14dwBZkX6r?=
 =?us-ascii?Q?e2nwbR9knPpz/tK0eDPtaY2GpPRaUTqjcGw1V8mRx99sgpZdpLoUoAnjaXwW?=
 =?us-ascii?Q?et6briQVAytMuMJ94BYLnaUpwwuEeFC40Uis361a986b/szlurqBCI2mtsWj?=
 =?us-ascii?Q?E6m8sJB3+zLFiIveGOWPuOzJj0yIegHFHlexNji3+Ok7lD2Sl+BnRCxq5Ysq?=
 =?us-ascii?Q?spibbjS6hCt1Dsl0LZpirPMj3bxazqU5fAy3nOuL6G4/mPAZZZCP1hw0gvkR?=
 =?us-ascii?Q?CwYsRmimBpe8pMZyl1tHNsM0US/ZJQQRWonGUlae0FzETOyuQvFX9qoZSA6Z?=
 =?us-ascii?Q?V8RiN6WZvYCvdE/bnoGZLLZPd/7r0K88SZyKzg/T8wz8DcZHahi1qnTwCkOA?=
 =?us-ascii?Q?c8APuRXoSn0CSnEaeyRqxpk1+RzSKfEcfNswxaoEJGrtQyDv++W/yJfxIGmb?=
 =?us-ascii?Q?uE1CeySn/NbQg5mhuRm00OLgx6XPpKedTo9WIv+Z2Khwk7CN8WXE7GsHixqR?=
 =?us-ascii?Q?ujCToc1jrwy320E0HpEgiNrql/Z3STJWYGJXBVY8OoTW04JXEHokaK6ju/wJ?=
 =?us-ascii?Q?5nxwSzrpbE9ojSnhw0y3px3r20mgD9Fa0Edxb9DL0x769I4u/qNWaUxJ9XWo?=
 =?us-ascii?Q?s+DI1/K4c/uZiLdWnVcT7cKg1QB7i7vQ93DQpfl7ZrPfmjbTnjXuSSUi2JzP?=
 =?us-ascii?Q?HDQQSBBGy+TlZ63Crz88w6IbhVlqt+0=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 817ad28f-0c07-4167-982a-08da374afe37
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 14:47:26.1166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C0R9w3oMUJaaFGMfDpy715NCOiAFjXIBB2zuqPzs+hwXgt7KTDyNsYOzOW0O55p9z6dCAB7zGZbPs5hKlh1LSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB8588
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
for gettime and settime exclusively. Before this change,
TOD_READ_PRIMARY was used for both extts and gettime/settime,
which would result in changing TOD read/write triggers between
operations. Using TOD_READ_SECONDARY would make extts
independent of gettime/settime operation

Signed-off-by: Min Li <min.li.xe@renesas.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
-use div helpers to do 64b division
-change comments to comply with kernel-doc format -Fix Jakub comments
-add more description to address the user problem
-improvements suggested by Jakub

 drivers/ptp/ptp_clockmatrix.c    | 289 ++++++++++++++++++++++++---------------
 drivers/ptp/ptp_clockmatrix.h    |   5 +
 include/linux/mfd/idt8a340_reg.h |  12 +-
 3 files changed, 196 insertions(+), 110 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 08e429a..2507576 100644
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
@@ -371,6 +395,31 @@ static void wait_for_chip_ready(struct idtcm *idtcm)
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
+	if (err)
+		return err;
+
+	return char_array_to_timespec(buf, sizeof(buf), ts);
+}
+
 static int _idtcm_gettime(struct idtcm_channel *channel,
 			  struct timespec64 *ts, u8 timeout)
 {
@@ -396,7 +445,7 @@ static int _idtcm_gettime(struct idtcm_channel *channel,
 	} while (trigger & TOD_READ_TRIGGER_MASK);
 
 	err = idtcm_read(idtcm, channel->tod_read_primary,
-			 TOD_READ_PRIMARY, buf, sizeof(buf));
+			 TOD_READ_PRIMARY_BASE, buf, sizeof(buf));
 	if (err)
 		return err;
 
@@ -415,67 +464,38 @@ static int idtcm_extts_check_channel(struct idtcm *idtcm, u8 todn)
 
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
-
-static u8 idtcm_enable_extts_mask(struct idtcm_channel *channel,
-				    u8 extts_mask, bool enable)
-{
-	struct idtcm *idtcm = channel->idtcm;
-	int i, err;
+	err = _idtcm_gettime_triggered(extts_channel, &ts);
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
-	int err;
 
-	/* Disable extts */
-	if (idtcm->extts_mask) {
-		extts_mask = idtcm_enable_extts_mask(channel, idtcm->extts_mask,
-						     false);
-	}
-
-	err = _idtcm_set_scsr_read_trig(channel,
-					SCSR_TOD_READ_TRIG_SEL_IMMEDIATE, 0);
-	if (err == 0)
-		err = _idtcm_gettime(channel, ts, 10);
+	u16 tod_read_cmd = IDTCM_FW_REG(idtcm->fw_ver, V520, TOD_READ_PRIMARY_CMD);
+	u8 val = (SCSR_TOD_READ_TRIG_SEL_IMMEDIATE << TOD_READ_TRIGGER_SHIFT);
+	int err;
 
-	/* Re-enable extts */
-	if (extts_mask)
-		idtcm_enable_extts_mask(channel, extts_mask, true);
+	err = idtcm_write(idtcm, channel->tod_read_primary,
+			  tod_read_cmd, &val, sizeof(val));
+	if (err)
+		return err;
 
-	return err;
+	return _idtcm_gettime(channel, ts, 10);
 }
 
 static int _sync_pll_output(struct idtcm *idtcm,
@@ -1702,6 +1722,9 @@ static int initialize_dco_operating_mode(struct idtcm_channel *channel)
 /*
  * Maximum absolute value for write phase offset in picoseconds
  *
+ * @channel:  channel
+ * @delta_ns: delta in nanoseconds
+ *
  * Destination signed register is 32-bit register in resolution of 50ps
  *
  * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
@@ -1958,8 +1981,7 @@ static int idtcm_enable(struct ptp_clock_info *ptp,
 			err = idtcm_perout_enable(channel, &rq->perout, true);
 		break;
 	case PTP_CLK_REQ_EXTTS:
-		err = idtcm_enable_extts(channel, rq->extts.index,
-					 rq->extts.rsv[0], on);
+		err = idtcm_extts_enable(channel, rq, on);
 		break;
 	default:
 		break;
@@ -1982,13 +2004,6 @@ static int idtcm_enable_tod(struct idtcm_channel *channel)
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
@@ -2038,17 +2053,35 @@ static void idtcm_set_version_info(struct idtcm *idtcm)
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
 
@@ -2057,12 +2090,14 @@ static const struct ptp_clock_info idtcm_caps_deprecated = {
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
 
@@ -2174,8 +2209,9 @@ static u32 idtcm_get_dco_delay(struct idtcm_channel *channel)
 		n = 1;
 
 	fodFreq = (u32)div_u64(m, n);
+
 	if (fodFreq >= 500000000)
-		return 18 * (u32)div_u64(NSEC_PER_SEC, fodFreq);
+		return (u32)div_u64(18 * (u64)NSEC_PER_SEC, fodFreq);
 
 	return 0;
 }
@@ -2188,24 +2224,28 @@ static int configure_channel_tod(struct idtcm_channel *channel, u32 index)
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
@@ -2221,6 +2261,7 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
 {
 	struct idtcm_channel *channel;
 	int err;
+	int i;
 
 	if (!(index < MAX_TOD))
 		return -EINVAL;
@@ -2248,6 +2289,17 @@ static int idtcm_enable_channel(struct idtcm *idtcm, u32 index)
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
@@ -2302,26 +2354,40 @@ static int idtcm_enable_extts_channel(struct idtcm *idtcm, u32 index)
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
 
@@ -2342,6 +2408,11 @@ static void set_default_masks(struct idtcm *idtcm)
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
@@ -2420,8 +2491,8 @@ static int idtcm_remove(struct platform_device *pdev)
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

