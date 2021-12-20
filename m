Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09E047A935
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 13:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbhLTMJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 07:09:13 -0500
Received: from mail-am6eur05on2074.outbound.protection.outlook.com ([40.107.22.74]:43712
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229533AbhLTMJN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 07:09:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yvr3DCVXjsCJLk8O5etiN3ejzsX3HJFrnl/3xe5TnLMjBLhuvw+W8mrPF+CiRJMTRyPmEIsS9oOjVgGQyoCc9a/YX/NDcvtw7exQOpJAcjAg/dhGvmDYuAqlo4oqWnZ+92hqk9c741ed0Sn4gaLgzIBmIxKtw4lRuGVYzK6l4YgjGDAvwTufzMZyHeMrJ45INSknIFNVB3hyIKuQfLoEm32ZNEZVDAHNek45A4QC6KYMRxuRbyhiDpbu/3XJF1HgdUbBfWB3oPG+7EYOCq5LcjOSFOEbZ9Q+Uhewxm+P3hkiofoh61GKwrfsuwuqCxYwEe3+dWh+ecKAlYBCzkFHNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4D6wC0+f7akCKlFQaQh2iwY7yJyOWUJfjBq2lDhFJHo=;
 b=UTDKKc2J3bKk/8tcqQ0Wxm/eult7gpT0yMOmSjkZYpVf/lUqDEv9AaRNQVtSEOxYsrLXfan0trtdk9MkioJlQC6eB8piNz+5OerssyKQyc+ghpUqOwiHCaH3h6nUtYHu19uP9iD37zkGc0lA/aC7opM2GEpKX95WGd2lL0f13rBhhrPNs10xKtebrOCix0sYAVvACa0rKNzrErksLROtNX09wLUYC2sihIIdvzGr3IEDT5m9hXjEbc+qnxWfOOF/m6c8+4pZHHIHeHDZ/fsoGdHr2JAb6pMt8iorLgFAHqXRqnU6c35jYAPyGiqOsZyeTf1VROFYJQVZ9hWfVN54Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4D6wC0+f7akCKlFQaQh2iwY7yJyOWUJfjBq2lDhFJHo=;
 b=AIQ4F/84lfvDf+p126UKwKvkTR2lA9MmLcuhuegpwPCSkioLE7lg+McMAB/4DVE3j96f3jtJ6STlsVtRjCes+m2k3LUuUOwA1VG+2W8RXyZYGgqO3qAm6zz/uDX4TWRdqZVmWPjvXJmS3tAlYAojxK0WpXQ30Fo2/5Yt9SSWxNo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AM9PR04MB8825.eurprd04.prod.outlook.com (2603:10a6:20b:408::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Mon, 20 Dec
 2021 12:09:08 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce%7]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 12:09:08 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     christian.herber@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH 1/3] ptp: add PTP_PEROUT_REVERSE_POLARITY flag
Date:   Mon, 20 Dec 2021 14:08:57 +0200
Message-Id: <20211220120859.140453-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0069.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::37) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd60fa5b-2e54-450c-8818-08d9c3b1868a
X-MS-TrafficTypeDiagnostic: AM9PR04MB8825:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB8825FECEDAB9B1C738DD095C9F7B9@AM9PR04MB8825.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E9VwZpH0r25Xysvuc/eKS6arltWC+8QNYownFT4WOu76rsnbZZwDLOwTb17TwopyscRyzddXqzTLcIrpHTfXm05lXb5RhQAujjvFCPU/4Fjhr4SgieRMsGzm63F4njYV3VjxO5v3K1TrqYZ8knEf4Ou3qmzDRjdE3gWzq7YAz30FV0R5VlftUUdibR5z28CtGy/7vPCwU7ROsC71RwS3KOrpHBmA0zFFyAFoisHbRURp/J7uWN1Cn9TjH0tz8J2iKF6Eu85Qm0TvBh/oVTbCQStScph0HJDqXcVuTHEqcp5AkSQ8dOMN+yrCno0J1ojPvvOGPEv0Q5PsGsQGVsf867JyWTtpxXJtWinGlo/Zo2SYR7cUIQ+L0UJ46zq64wgSKN6R1tK/ZWMw2PLa9PL8P1dziarkezgwv0BpbMYSsWTt5yl9fsOGscYgTUWahGMf+f1VH9s3AXnYF9dWl/QFRtvuGVyH9rcsY8xniDjNRx2p+j3NZzI0G+5+VPgU0pUleXkgX7mIeBjf5y0oZL42kWOG7/9qxPh6ruVEPakBBOdD75IJA4eIaeTeDGtUdiEYfUoSkU63naPV6D1hEjgQPREjk7EYQDGSBUADNlMvYJwGSi3r7D/P7D95Q8Hb1QiSFV+xASGIM5HpOlesgraUw9O+ZOHOyaHCfnAV4vxcWr0ANh54pVyX7E4rE+YrT9FFUVf03F4a95skYxuuI/n/Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(6506007)(6666004)(26005)(5660300002)(52116002)(186003)(2616005)(8676002)(6512007)(2906002)(8936002)(86362001)(316002)(38100700002)(38350700002)(4326008)(6486002)(66946007)(508600001)(83380400001)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gvakov7KcmyrcG62shBj9KB6MzUbkStRwSN1SaWmgmrdlzeI6CztyVCWrPTD?=
 =?us-ascii?Q?raGayGRqGcPfsFp0x5hWLve9FNehz+ytvSo9tUUcUbSuBRVIP1vkl8DDEuEB?=
 =?us-ascii?Q?5fa4cZyOIbtcJj9vxD0LDose7Ekbfp1ff2uz/FepJ2OVKBBvCa6W7s5iiXux?=
 =?us-ascii?Q?RzHxsiA5GMfv/0V8qha3cKNiQJOCk6ThnS4m4/4JWSYBwOw6FZkkBcQU6siy?=
 =?us-ascii?Q?PbQNxOoeyg+6DqH29UZqYD6erIPsI+e+2swCZs14LqYiVk1y/tDe0cho2GmV?=
 =?us-ascii?Q?CAWAZlE3X81tKxewPzhF4mb0ckC7nOYZ6WtEpYenO+NQI8qNXRvEUs44sVS0?=
 =?us-ascii?Q?QR97XLB8Nilt3ujqX8cS54Z4hDD+0sKI2VS/+hOqHQtfpAk0J829j2x4F1IX?=
 =?us-ascii?Q?7PD//g+ssLHIjsB47jKJTXMXmEenEwgJ6xb54kYgUQB65dcYz53p5tY/5LqO?=
 =?us-ascii?Q?c5r86zJOdVI+423n20Qcad3vJvKcNMcxjm8sOifc0+joS2I2pZCYQxyoMxsr?=
 =?us-ascii?Q?u6SEfxAVBl7fEhgQs9dbSislkFeOdA2Jhs4yavEuJAC2cJfzYxO+WLLx2UR+?=
 =?us-ascii?Q?nHG+ghtcdHszjYZt90D5VuORQ0SBZdS1fIM0lU4UHlFouBZJe7Pv7nzyfpIl?=
 =?us-ascii?Q?xvm6KrPVJDqvcAN8k4SempW+T3JPmS24V7BL6i/vfHy94LAqxgl1XNO7vQR3?=
 =?us-ascii?Q?wx772IUZLkAHXb2/hNWQMYcZKXsdWbITrSKeSikIaMSyzmsJ9AY4a2qbDCwH?=
 =?us-ascii?Q?yKueHDupEu+yzZgw2UiLJv9M8iH/D6aNfbRuSCu5uPkZ5RUQZc1txeYKz9WZ?=
 =?us-ascii?Q?KD3AnZCZa0e4zanWtR7FtV5HG9HeERWQN2FkCVZk4gSp8j59h5Dyf9ALxBnc?=
 =?us-ascii?Q?JkiIWzFf6z0HvcSf8r0nFriqXkQrySQs3EKGPx6S4gfGufX463YYkKaUOc1a?=
 =?us-ascii?Q?PM1h+aUWrSqMZ7uVmSdX+WEvCopTLGiNvYSSxlk6aDxnVT8+GDOZ44Uo2ltn?=
 =?us-ascii?Q?MnhyJ7M4Pp+7w8sWUbkvEnCxYikBoPPNuESI6fh3IQIgdu6DFrLgbDdmgRwC?=
 =?us-ascii?Q?KpRTzXtoJrfuEtoL4piDJ7qQSD/hv2lfJHNfhljdNMvopX6r2pj9YrqgLfEn?=
 =?us-ascii?Q?MsBii293/dv/6v5Pn7BS7IrGq3GFGzBPOBywBDe0UXtaTDdwv3Dp8Nm3Zh5a?=
 =?us-ascii?Q?GyRMOG0YGJraRiEcSKZ3oJ+Usm9iO38YbAzhafRWGpwIgWw0ZD51cmIJAPlh?=
 =?us-ascii?Q?mUQ2BNJtyPWSa+Vi26vkG1z+dmoxTE1B8c4SRlLz0rVuOInOtxQiB+cfs7hP?=
 =?us-ascii?Q?CuD+iNDyo0s/t6Vw/foS3r0YcAltL+qj7PAms2QW1/LK3J7IMQ1ovi6z0AF5?=
 =?us-ascii?Q?84NBTT08V2UxOZ6iqdQOl7jUmTEbQxwF9reR3MP604nH6AkfSEZKhZxy57sy?=
 =?us-ascii?Q?YSL7QvtgALnvY+FIquQteN1zkB2MvIrYMXCnbnPSmb3nWZFJ+QLHtk1kt6Hv?=
 =?us-ascii?Q?EWYm3SytXu5JWidz25QaziJkIt1df31fAMiYvBUuQzgrs8fWrYxIs2UuAmyN?=
 =?us-ascii?Q?4wuEnwXLewt4WCOiwYAzwK8gPLV2EHvDWcpWWjhBdhSkpnRXZ2u3TH7nwLdq?=
 =?us-ascii?Q?oBcQSkXIUyjJuDNQqixf+8ymJAEhaVmSGY9oeaOEWZ0aJKMZIMK57QyRvT5T?=
 =?us-ascii?Q?vdlJyg=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd60fa5b-2e54-450c-8818-08d9c3b1868a
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 12:09:08.5490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sghjBlO7uT6rg7EhrWiE/xdTtQ2CwOL2rp+YAnSJYCa2MJFW4BcoRkklahUs3GwgRsnFlDpc88wFZNvSYU3tqX8bLaZrmXJeVaAiOB6v/DI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some ptp controllers may be able to reverse the polarity of the periodic
output signal. Using the PTP_PEROUT_REVERSE_POLARITY flag we can tell the
drivers to reverse the polarity of the signal.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 include/uapi/linux/ptp_clock.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 1d108d597f66..34bc4ff89341 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -56,13 +56,15 @@
 #define PTP_PEROUT_ONE_SHOT		(1<<0)
 #define PTP_PEROUT_DUTY_CYCLE		(1<<1)
 #define PTP_PEROUT_PHASE		(1<<2)
+#define PTP_PEROUT_REVERSE_POLARITY	(1<<3)
 
 /*
  * flag fields valid for the new PTP_PEROUT_REQUEST2 ioctl.
  */
 #define PTP_PEROUT_VALID_FLAGS		(PTP_PEROUT_ONE_SHOT | \
 					 PTP_PEROUT_DUTY_CYCLE | \
-					 PTP_PEROUT_PHASE)
+					 PTP_PEROUT_PHASE | \
+					 PTP_PEROUT_REVERSE_POLARITY)
 
 /*
  * No flags are valid for the original PTP_PEROUT_REQUEST ioctl
-- 
2.34.1

