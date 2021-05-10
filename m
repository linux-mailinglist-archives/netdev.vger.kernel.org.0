Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD463792D0
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 17:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbhEJPgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 11:36:07 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:37541
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232558AbhEJPf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 11:35:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsGx2y6CdhUbRru/kCi+ONQ1Kvk11LFUpFuoNru6JHrPAzwMoH8zY9+wVb6nbcrff54wmab/0e9xCpiXQSDK5OLtrO1pDiTcUAjUhU16fNKEnLiioglc5tqgZruE4s+wSmOioWR2eDis2N1GT7iV2KKiIjG4CpLCTS0sWxjHZ2+ZsU9ECeXipNVcy4gjHWBSnHh64utMnddc1/QJ/Oz5bZuDDCBl5HgDV6kJaRLnL06pI2mkrOTecmDX+Yzmpmxj+iRqPKrHehQyVBhxlWf5aW2Ozx22gdUlPZurAqeixbDYSBfTROn8jP24Dz1Ab/dhLTtjrMGI8jKbuYrAiTxmdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqA6BGT0O6emdfOw5T8s20VDee5lTRWU3mqIbN4cfLk=;
 b=bniK3VAQ4tS/I3Z4lOsf89W5hZNdLg9iZMUre7y/c96NeQdWQWKlMxVwniRk2/WRBteeSCI/l2WIXqeJ9/X5rV3/Pr4TrwDZ1x8Uo/9vddDSWpYm+mBZaYtzGKwxPKpss2bqx/szLDtR74Jq+G+ndgX58S3fvQ2CJwIOCXlk+QlasmGgufVsY8rF4D2BMTqyfflqgLJ2nsJGtNEl7aO8gGFdeFs/AoxeT3Nxll04ps9DQ2HfCyVON199DhGsXzjjT92V0TJJzivqJFIxomtRgKn1vmoriVURFigcBRnIR/ff1fFDE8L2E4EhK+rn7pdAFaxyVr9+LZmeNQQG9ZXq6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqA6BGT0O6emdfOw5T8s20VDee5lTRWU3mqIbN4cfLk=;
 b=bTWdvmNccpHhKmePrvIhO7Y9vznkFCMiebqF6ReIGUQ4ufrRz27/nC/JDneGyupCVjkbcHcS+Q2Wkd1O4n4jTfbkw36RAFUx2SyqFFhOsDb6wUX+JtrxH2zvXFnsdzsKY/D0TLq0SHNgZ0501xoDdNoz7cCSkry6on64G+1eFA4=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR0402MB3470.eurprd04.prod.outlook.com (2603:10a6:803:10::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Mon, 10 May
 2021 15:34:46 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::34f6:6011:99b7:ec68]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::34f6:6011:99b7:ec68%5]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 15:34:46 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v2 1/2] ptp: ptp_clock: make scaled_ppm_to_ppb static inline
Date:   Mon, 10 May 2021 18:34:32 +0300
Message-Id: <20210510153433.224723-2-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510153433.224723-1-radu-nicolae.pirea@oss.nxp.com>
References: <20210510153433.224723-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM4PR0202CA0011.eurprd02.prod.outlook.com
 (2603:10a6:200:89::21) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by AM4PR0202CA0011.eurprd02.prod.outlook.com (2603:10a6:200:89::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 15:34:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d5161f8-5e4f-45a9-4f98-08d913c923ff
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3470:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3470E9577F74CF2C5DA828A69F549@VI1PR0402MB3470.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cce2D+wRa9wjdrPrqgCZiHrlhzSsvnDH/Gw3FpjVhE5PxdpJtW8WIj1IYsD6RbVrIxEBzmLCxRr34aFGQXqD+idSvehD7izV3yT0mbIkbPr+bsVj2PSH2OzogwEC0J3mLAvWk1S1e7/5gQDGq1AKmvEQMh7Tzy1Gi5rh3RIxSXQ+Bfu/ksAZiuxTtP2WGyHkXnOeAjqns951HFGs8KQ3vqhPjE8vm0ziJ+wgm0ZCFf0Y9I2tVVEEpmn7dzp/aAumTtdwWyJKDFALabRtcOaUZeWU+38r9pwQvIUC256A6TYcBFRQBjI3AdlB/eGD/an6Chg7kdadJ8tbmfBkzNKp0u2DYReLm7YmsvGi1DKcJgjtvlJ2cPznq+hMUsHF6m5cdWzIm8HbKGU45Q/yc0qCj7h2YCpKOYmmDamGmBxFr5iSy02q0i6hOkNcT8RJ4zUZv9rnduHAU50puE6I+1M9nVtWg9G4xYWG3JdhKFs9ba6V8ipUQc00IREkCGIIEc2xSZtJzLZoPKBm4jz6Co52WZ/v9lU1VBI+KHIaNBPVXW3DlDXrkUihU16XR/Sje5IHZTSIV2WHbalOviJ1G0kaMu738d7++t1Bq0hJ8k8xn1j19nFpPqr+caRM4p1LxxEG3fsIkdyUGunv+nUxGXed4E6ZtPVsWVptEluL9tgraIvj2p+1Zo78KR86t6HkdRLzBGVthISvI7tteWDWSyWCEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(478600001)(66556008)(66946007)(86362001)(66476007)(8936002)(5660300002)(4326008)(6666004)(38350700002)(8676002)(1076003)(52116002)(16526019)(186003)(6512007)(6486002)(316002)(956004)(38100700002)(2906002)(6506007)(83380400001)(26005)(2616005)(69590400013)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YnSchR+QkDMdWv+mJM3jOk1c4mflMa9MQPzHZVy+yxICHnYkJ7UHINx/yPdi?=
 =?us-ascii?Q?/afAf2MeatH+aCs+eYnScvmQVC2dYrGBjS1uP+QmYsZ5X3KcT6P0KAN8bAo+?=
 =?us-ascii?Q?24GkfLSHmShIODHJxCS2F2KXh/qra4LSH7Cdy2ViaOpqGYU6Q/Z8KCnyKlCY?=
 =?us-ascii?Q?yYd33PAfoh2XMT2pqzDjZkrDAegX8YYTeS0ChqmamMb871bn2gLCJTqXXTnG?=
 =?us-ascii?Q?zLnExRFa8gbv+llI09Mk/UmQSKZ946n4eG0EPPkbLKYLjhM++J/+oc0xLKGI?=
 =?us-ascii?Q?KNDIrI2TKBe9tq+grz4jUaxxRB3ZT3UAYvOjU757WLIz3p0WaHb40ZdvYBL2?=
 =?us-ascii?Q?7gkFxvcDfXh4uuQrFn52tX5qfNJxGnuhg0SQ9V2qLPXN04leTXHyLeKfJQ0m?=
 =?us-ascii?Q?AWSdtkdJQIDq3ei5vUWwIm/g70g4ogcegVeTacTKIZ6boeqf+8imm5E93dV8?=
 =?us-ascii?Q?1eUVWtfJ4cElL3gcNBvIJDmMmXwBHTvJW3oeCEgV4PcmLOC1rrVjHfCrWRrj?=
 =?us-ascii?Q?6OPo7tJHuHUE54Sp/AUgB2dLZXDNBBxnDhGhSyjspRfESjJQBxbkpVzwVrEB?=
 =?us-ascii?Q?pVzowD20PsXQZCaUvpFsnJ+nY7XktZbH3FH1OfJmnMW0nairZ5xjm5/54QM5?=
 =?us-ascii?Q?wvIZ1Ia+TC05aElI3hA3XjzEP6TzW/Jm0wrWPpBvbpGb9sb6TZYU624+G0WX?=
 =?us-ascii?Q?qv8S5WLDJ0rkrR1vPyhvvuLBoWFB6xiZJXPvQy/XZVMvh2JUnj9cEoB0qMY2?=
 =?us-ascii?Q?C70XLpHVO9bGsY6Q2Ujs6kD8CuQEFRykvzQrciZs07MnfYpykO3L7Rjprr1c?=
 =?us-ascii?Q?owalxAz1rchNacJXiVM9c306zTRFqvJErK1rh8hoCbosLOhEh8lswKjhX+n5?=
 =?us-ascii?Q?+LMYfODgDk4W8w9MRl7pFyz2bGT9sJhrcwif+ji/YBABZbDntcdS6nAfpF7G?=
 =?us-ascii?Q?eGM/dM2Mt8TyODRbZF3/BUhPI3rPH/bcDxIf2pne2UvRCHyPjVBeFpuaQIOQ?=
 =?us-ascii?Q?cZb9xd9L9ohHWhedns9GurVas2bs0uCk04V1ullS6EmE5manzpLYG8OH3M09?=
 =?us-ascii?Q?BrlSsa1Y4RLm7sioxgYNJFP3XgR3914PZcPwfR2quDzMQJpizgIlK9Y2Po3B?=
 =?us-ascii?Q?xqMie/pT1X5BEt+/eHXuRZa7lwHDQkzTNle0eJxXhOqIBxpqd7TfrSopEDBb?=
 =?us-ascii?Q?pN2q4FV5hyez7ss3wBXdbTGsO/IJoA7sUZ1BUflJQPXH98aZmV+jZMYFj6FC?=
 =?us-ascii?Q?hcF8rYPVWoo9q7mucXqUE73nIBy2JT0VxwmrvK/oIPeQ9mk4tpoWYgjFRiQg?=
 =?us-ascii?Q?3oEn/0Kh/8BxnGFpu1kW1YXc?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d5161f8-5e4f-45a9-4f98-08d913c923ff
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 15:34:46.6122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZE9OEA4+fAGuUWBN6rk/W00Xgm3R7lbYRnEeMh8mcLmCyAtci2y5YJQ1HxfsmIEawrQe7+zspWe1r5O7u8ruZGqt6xmPnjsP3ByrbuG7y+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3470
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make scaled_ppm_to_ppb static inline to be able to build drivers that
use this function even with PTP_1588_CLOCK disabled.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/ptp/ptp_clock.c          | 21 --------------------
 include/linux/ptp_clock_kernel.h | 34 ++++++++++++++++++++++++--------
 2 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 03a246e60fd9..a780435331c8 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -63,27 +63,6 @@ static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
 	spin_unlock_irqrestore(&queue->lock, flags);
 }
 
-s32 scaled_ppm_to_ppb(long ppm)
-{
-	/*
-	 * The 'freq' field in the 'struct timex' is in parts per
-	 * million, but with a 16 bit binary fractional field.
-	 *
-	 * We want to calculate
-	 *
-	 *    ppb = scaled_ppm * 1000 / 2^16
-	 *
-	 * which simplifies to
-	 *
-	 *    ppb = scaled_ppm * 125 / 2^13
-	 */
-	s64 ppb = 1 + ppm;
-	ppb *= 125;
-	ppb >>= 13;
-	return (s32) ppb;
-}
-EXPORT_SYMBOL(scaled_ppm_to_ppb);
-
 /* posix clock implementation */
 
 static int ptp_clock_getres(struct posix_clock *pc, struct timespec64 *tp)
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 0d47fd33b228..a311bddd9e85 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -186,6 +186,32 @@ struct ptp_clock_event {
 	};
 };
 
+/**
+ * scaled_ppm_to_ppb() - convert scaled ppm to ppb
+ *
+ * @ppm:    Parts per million, but with a 16 bit binary fractional field
+ */
+static inline s32 scaled_ppm_to_ppb(long ppm)
+{
+	/*
+	 * The 'freq' field in the 'struct timex' is in parts per
+	 * million, but with a 16 bit binary fractional field.
+	 *
+	 * We want to calculate
+	 *
+	 *    ppb = scaled_ppm * 1000 / 2^16
+	 *
+	 * which simplifies to
+	 *
+	 *    ppb = scaled_ppm * 125 / 2^13
+	 */
+	s64 ppb = 1 + ppm;
+
+	ppb *= 125;
+	ppb >>= 13;
+	return (s32)ppb;
+}
+
 #if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
 
 /**
@@ -229,14 +255,6 @@ extern void ptp_clock_event(struct ptp_clock *ptp,
 
 extern int ptp_clock_index(struct ptp_clock *ptp);
 
-/**
- * scaled_ppm_to_ppb() - convert scaled ppm to ppb
- *
- * @ppm:    Parts per million, but with a 16 bit binary fractional field
- */
-
-extern s32 scaled_ppm_to_ppb(long ppm);
-
 /**
  * ptp_find_pin() - obtain the pin index of a given auxiliary function
  *
-- 
2.31.1

