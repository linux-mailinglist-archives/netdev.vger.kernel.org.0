Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A38A36D75A
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 14:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbhD1MbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 08:31:21 -0400
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:28549
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236815AbhD1MbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 08:31:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCvXQM8PLCain9hQQTBurALFTlLM/M46dQ/8gPVQBpbJBBrWlf+LEKfsw69jReJJrnD2NPsGK9JzEjVkAzBvEdihhkTwTecH4hUinISUHmMJXqfOsZ6gGIfPJECknfWA4pnTzC/g8zI6TDoXQwdx2Fee9FYDtJP2Gvty/v7z4VBVKo749ubE3AfdjCIMUQDO4OU7XyeL0Sdf6bIpQlHkDLuh9d/5LSwHAcrkxQE42s1ee3Aq0HPuUucQ/IKcHkp1n7rnAzikWqjl0eiUGImEiIO+SNNGDVEX5o7e17df8MgUndmubxX66f6dkGl4HZ8Fmyc0HzCGPe7mcE4/7olWKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqA6BGT0O6emdfOw5T8s20VDee5lTRWU3mqIbN4cfLk=;
 b=SCXnBLagB0fDdUxwpqD8GAT4aDeOi3fLlPNWT6Du6RT4JGmMMwCQBxN+hcSapQEm66e7OSb8g48RkTbF3ki0Fs8TvlYwuKg73pXGCrXtFX4NWSmD8WQD572dl+WI+iNWSFeR8ukf5mx64lPBRKOXLUPRY2X8CK1V6IsfagA0Lz1BSlw8rdlWUge3YU+urK/4WRBSSNxORb0kiZrKXrbf7jKAje709yB3UWmVKR94JlkQcKPcQ5+RsQuLR45SZiK1VgQIJ3l9bHhqxyrTPwvKk9xo4kdLpNbHVLcpCqy+b4lqLg8u8fqilVQoH8yDokTLDvQ3J9D+7T/9HYDQI2sQzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqA6BGT0O6emdfOw5T8s20VDee5lTRWU3mqIbN4cfLk=;
 b=jhR6xkRJUkfP2vspAujM/MgGmK67xOLcQ7ucb5WlsQ67pFUCX/1WWJcdINLzwP6mQizqAkQJd0n6i40bHM03CzGPj8DtkB4bOFBFg8uDQT6Ldr4gtDqpST6Zhm7/9VcsdvBsdOnFMkhN2CrVipO8nDvKx3YkLsrHKfEwOORiaHA=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR04MB4512.eurprd04.prod.outlook.com (2603:10a6:803:69::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Wed, 28 Apr
 2021 12:30:30 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 12:30:30 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v1 1/2] ptp: ptp_clock: make scaled_ppm_to_ppb static inline
Date:   Wed, 28 Apr 2021 15:30:12 +0300
Message-Id: <20210428123013.127571-2-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210428123013.127571-1-radu-nicolae.pirea@oss.nxp.com>
References: <20210428123013.127571-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM4PR0302CA0023.eurprd03.prod.outlook.com
 (2603:10a6:205:2::36) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by AM4PR0302CA0023.eurprd03.prod.outlook.com (2603:10a6:205:2::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 12:30:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5322f06e-3fbf-4e17-4c9d-08d90a416944
X-MS-TrafficTypeDiagnostic: VI1PR04MB4512:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4512BAC63A7D8907B091A4179F409@VI1PR04MB4512.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJpQ1uYWUOox/A9TbCeU4D3eK5XEuWR0jqkzv0ggBmPmsf8IEKQJEBKq31acTdCu05U8beZ3eYegIdVLgKXxQTy9VUY9mNZ3t6afJz12ZtCeTer4w4Ferjr7pp2oprRjuB+Qv6MMs8y2mgPxzthz6USC2tl9bQTHNfnsbXOAMrdt2Cp/4kNME4jYCc1GTJSH84YY9t2q6jQSOgmsGnn5sSGtcXwj4PXLIzituBtIf8Bk5P3ZShX3CPVZHXY7laO0n2TDvBgCcsPMXwwhZQwkG4dwZMHciw9O24Umoh8CnFFx93HVNcXaynOUxy0pJpiV88vX1hZW0ULDN0K9v31rGSpFqRXq6AiixZUJdLXwuzsDQfnVDrMePtmTCdzUav1oCa9go8p/qohbEbpXpw32otmIFoFun3+mh63cDWgxJubqlzyjQE9ikXY4QI3c3R0qqvrGi3MeCuCBNbH+wcqgtEGMXvmb5Swbu3kOCO89/mNwD31kNk2QRuHccSsnHT4LTrVZsDkPVtGPJD0GB0arVVwsUXBjy72m0Uj1ES1A3fWpSnYb+yf7Z5vA6ELQP7EF9CYLCD92UwLQM4XMgWIKrRXMP1gG3XJLsIEWVrjJOwRsqooSv6dSKDgbHhRyT16xsaNLHZsMsFnEv91EpxVOIMQRIq+tUvPtrfgwIPJLdbsKVnPBjp06tkyFVQNplRycRc3zGKDUHUIhwG96/5q8jQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(478600001)(316002)(6666004)(52116002)(956004)(6512007)(26005)(2906002)(186003)(4326008)(16526019)(8936002)(2616005)(1076003)(38100700002)(8676002)(83380400001)(5660300002)(6506007)(66556008)(86362001)(66476007)(66946007)(6486002)(38350700002)(69590400013)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?N10rIG0C0wvk4H8EVNXKEgHfuBv/mDY1Fbqv7SVDVgBa/hzt45uStM/r7uxU?=
 =?us-ascii?Q?XwkBjkFmwjGWZcGuYoG8CNuqzrC7Rj7ntsjy3mK10nTXwtePFuypdHP/qPAy?=
 =?us-ascii?Q?zm5cQzuug52pLaG/i7fxKxZoghM1HfD6/+SDdCcW9PEaCiGtGVvy2xJ1Vi0/?=
 =?us-ascii?Q?sIOC9XD8dVkFEgOhFBfL7eGE9iq3XE8Vge14D7WTpU8C3S4f8iCRTdwB2nNU?=
 =?us-ascii?Q?QnqWOVQ0WJ/mjaIzQn8WhmKd8ZPWiTUOJPpcHcLvUYDD2Q2EyEUSRYdzNs7/?=
 =?us-ascii?Q?avW8PdVd4/jHERAlN/+l5B2EAVMsd+dqh3kcHR9dOrMWDV4NaGzDgyxsnTkA?=
 =?us-ascii?Q?0jwHuh1jK6fUSYOTFvIqQDLARrL66lTQPlRywwZz2D6SCa8RZHMEnwOBdvoU?=
 =?us-ascii?Q?S/aYBbtZbAh3iMCJw0dXBBMQuHp2V5Eb2bwVJnMjMO2JMt1WOGHcfzF//wH1?=
 =?us-ascii?Q?vv1GWHyFlgdYBw/n6f0ZpLpv2TBZEGzRGSYGYZAYvV7+TwGCUGYsUX810TpO?=
 =?us-ascii?Q?ppmuFgzhL54A79Czj5cjGp8J246TUNPgWQn22JfA7Z0vRCmQqGoIT4adhIEs?=
 =?us-ascii?Q?SGwJaaRRFkHb6yrghE5A6cXpcs5o1wQdMk0dyoupuqMpOQVl0z4/ff2ksEY8?=
 =?us-ascii?Q?0YHaUr3e750dlMFAyy+vJT5ynHWEJ6UJWGCL3WqWYpURiXPLL08E5dsez0Xq?=
 =?us-ascii?Q?aPpDdlsuMiFn1JSXjcsNwGahRIv59mW9GSQXCAvryV97oySKt++cxk0Kvt3k?=
 =?us-ascii?Q?yM13whegoqGA1w7kdPKWkhPGG4M19koulGligLF/TrC5zyJ0PlAvCqHIlIVp?=
 =?us-ascii?Q?RXzKjGxBbfECLT8r4nLj3vP13EzQAVhyBbMR7sNCg+f3kf6d0ddgu9hyOvM8?=
 =?us-ascii?Q?6BNC01jUayx+88DG5QIClhoOjpxBeMRwRKCOk9pUsOqi1fb9oJtesb/tbqi/?=
 =?us-ascii?Q?CbbZsSzJfru+xUj2ei4NW5iyXu280iNdbrDNVRgXs6qOvFlN/E62Jk94BYmN?=
 =?us-ascii?Q?z1W4Tx+tLZJaxwn2qPmD8LQgFr0cUnBV2iJ9t33hpYJxpunuZpE6F41AqoIx?=
 =?us-ascii?Q?TWFHSs4/FT0tKc3zzSlV2qv+6AnJu6KIXpD7ORsI0pYhGvp9d7xJasrJnmu2?=
 =?us-ascii?Q?ENc7JslBSY47veKGUGAMjDmRdQDOZ8eJ4fCHhHUbl6tl1adRf+OFQdt1G1AR?=
 =?us-ascii?Q?mWCbdgV+WpdDWfIclkhUxszOie3WhezJRGLa0pRugMVO8XcayDYJE47WVz3O?=
 =?us-ascii?Q?DmDJBFejVxrLOP3wc+e0OyqKtof98srNhkE/P2PL0m6I7IgTVBQoSSNUod/r?=
 =?us-ascii?Q?Qm/qKEhqUKFuYTw0A9xt8gBo?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5322f06e-3fbf-4e17-4c9d-08d90a416944
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 12:30:30.7430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FzntP1GzU7JAjUegJiUXMsDiG/wSz+YgFH/wO/1Y3vkZBoXafOPtpOfXdPx0sfUbm4bDySttTtGFB8AHO9kOGeh+XNyhRa3Zcuu7ejifr4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4512
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

