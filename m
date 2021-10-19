Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0E1433F18
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 21:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbhJSTTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 15:19:23 -0400
Received: from mail-eopbgr50120.outbound.protection.outlook.com ([40.107.5.120]:49983
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230432AbhJSTTX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 15:19:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDFdMSID6k2WmNWWWLhePJt+9G5kj0rXDjeCixUHipXCAZkmPOigovj2NJgzy2kQ6J8iIo7W4uff0OlLYIvjrR8sVNtdHcsTtKqzn2sE0WvAkav7k+cZ5lRJBN9D5p52ObkPJdsugSuOFaOiMew5vB+fz+bfXORgzF9BDHYpTla9KzmGGXG28YMZM+OAc/aVY3aQ2D09WkI7TvY05r/R/qt5fDklVAxw7vqHE+NWLn5rTW6DZ0CpTAcUTKykfy6jKWvinfs+qc6j8tM+omjb3xZGTUh+uOZMVCmmIX6MclZKPvYHfRkt9tbZMqEuNWTAlDVFHMhbe5LJlxt0Sd/6nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NWJ3iPHc50qzdI/mgRXHNFsW9UKC7kPgKsNWo4EYrR0=;
 b=iUrkbefpHfvK3uVJhAhCk2FHe8XwP2+rOG4cIrAaMZNkk3IedKd6G16x8cFY+rxA9J0hCS0jMNGOJC42xTigCwSTHkQhiG92la+QjqyUL/R5kTKvF5ErM2Cc8yaihuV4m/0aP28pl7YpjoJBtH+DeCgYuPJXqRa0C0JndPad9KrBJyVvgk33EqPRLydco4QyXi6e9rg7g0zkLA3pjiuz1rHU7WxBT4GiPq6w9ubGAvH2rUlyqXY62/FvVgdGr2wks3grhIiEcpm7k8nAID7axty3GcCJLsIJB8TqauWd4uIEwYpFV8NbPfG8rk3MujPg7TKbKRE9puIUR31EVKqtWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NWJ3iPHc50qzdI/mgRXHNFsW9UKC7kPgKsNWo4EYrR0=;
 b=JfmSQd8iono3VvIUHAQECkGzkg+ba1xfbkV9WW2SRxADcovk+HvcfShXZIkcU3zoGS7Aji0vDEI/1joJDvLqGK9uNJ5IWCSmeiYH5jfT/wv+HOt81P/3yObzWTD1mb2sLQIQkWx2u/R8gYltqff13baSxVoa4MOv8XRH+3RwXGU=
Authentication-Results: agner.ch; dkim=none (message not signed)
 header.d=none;agner.ch; dmarc=none action=none header.from=toradex.com;
Received: from DBAPR05MB7445.eurprd05.prod.outlook.com (2603:10a6:10:1a0::8)
 by DB9PR05MB8654.eurprd05.prod.outlook.com (2603:10a6:10:2c4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Tue, 19 Oct
 2021 19:17:06 +0000
Received: from DBAPR05MB7445.eurprd05.prod.outlook.com
 ([fe80::98f8:53ac:8110:c783]) by DBAPR05MB7445.eurprd05.prod.outlook.com
 ([fe80::98f8:53ac:8110:c783%3]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 19:17:06 +0000
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Patrice Vilchez <patrice.vilchez@atmel.com>
Cc:     Stefan Agner <stefan@agner.ch>, f.fainelli@gmail.com,
        christophe.leroy@csgroup.eu, sergei.shtylyov@gmail.com,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] phy: micrel: ksz8041nl: do not use power down mode
Date:   Tue, 19 Oct 2021 21:16:47 +0200
Message-Id: <20211019191647.346361-1-francesco.dolcini@toradex.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV0P278CA0010.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:26::20) To DBAPR05MB7445.eurprd05.prod.outlook.com
 (2603:10a6:10:1a0::8)
MIME-Version: 1.0
Received: from francesco-nb.toradex.int (93.49.2.63) by GV0P278CA0010.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:26::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Tue, 19 Oct 2021 19:17:05 +0000
Received: by francesco-nb.toradex.int (Postfix, from userid 1000)       id 84B3E10A072C; Tue, 19 Oct 2021 21:17:03 +0200 (CEST)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad213ff0-3ed7-4307-47e3-08d993350a03
X-MS-TrafficTypeDiagnostic: DB9PR05MB8654:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR05MB8654F50865FDFBC73E78E4EFE2BD9@DB9PR05MB8654.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Im05YS/3tLxyRM1qbiHDElKHZIGqcn25+T4DGctIgk/BqNbnD+gjia0j16A1mt+oXw3tfKEmJjQs7z8CEnKfSN+xHnQ6cb444w7IWN5s4Wa7Vsd1I3I11WxzNpaIorGuP3uYgr5XkuInwNZ8F3v/ErG+qw9nEd3sa0gzb0bNM6uKUtbZpiDqMoeTcz6If8tSiOKuQgB3vL2Z/n46Zd3FdPbwEY8cqHNJAw9ZUWccQsDhYs0Xu1v2gljpVIExVn1kbv6lN8yAQm7HCF8zy4VRXA8JuLDfFanNWLGmnikK0jkDRvFhMcnFWI5DPMswtsUXxF9kypCmBXwFsQZKPeX6fIclhu/lKlFD04tJ1nOHAR0nt180QRvJM3QoedG3BLbeNk8MKjVd6jhH78FXWydkqVd2IQuV0nHMPPTd6s9UPehhCXdXLS9wHYnCTj9P87ShiGhYBhXAfpKyki8iIPcahNToDwDOvjPM3Jq657YKjbJ80ZA51TPDUZ9ntlhuLuzNSIXfKjdI8sF316eBc03E9KvH0IG9NuXSUewwCcLt0uEOULDWiEOVCxGF+N73Njp6o8UIg0W+R8NbXdmt2l2+9oINz0LS7Yx5w4OjaRI9DRYkRWCSeLKUzvN9zyMMTT5CSFiuaHFLEWDJh3enTAlTlCMVI1vUU8+zZHmfaFgSrN4nhUJ9oD+EVZoXbqjwO9PxCt4aZS1P0FaAz+xsTdYc96KYSFlPx6WG4LT3CFgqLd1PjMwKXlEGw9t5XP9qGyvcCJc1O+oVxP7Bqibizvun9Yvxs/mlNNl90bBF5sH/6Qg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR05MB7445.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(136003)(376002)(346002)(396003)(508600001)(966005)(110136005)(8936002)(8676002)(2906002)(26005)(5660300002)(54906003)(186003)(38350700002)(86362001)(6266002)(2616005)(44832011)(36756003)(7416002)(42186006)(66476007)(66946007)(66556008)(4326008)(38100700002)(6666004)(1076003)(83380400001)(52116002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fSY1mVvy37xOle+KZNI/LnEAEO+1zXARWIjmmMfUOxudAUOFVo2N7yGAp3V4?=
 =?us-ascii?Q?di9QVCxtWUQB+53EZ3cTV/2kcy3hoHke1IOdZHPN28mepCuTaAKqWtHDd2my?=
 =?us-ascii?Q?sPhFPKFnWpEWvGRPE2SqtXNDq2euoaFhZ0asWoV9GF40UA9HimUMOPmBLnfT?=
 =?us-ascii?Q?peNMpCDz/LEp7ACdv7m1rhVZSTiYeU1Obfz91tQLZvjdrPyTtdbO9xDhPGXj?=
 =?us-ascii?Q?tgNppU5HX2ANIG3xw9CYaLzRbsW3NQpv8Vuwd9d9z4lO8DzLKKiEwi7The4c?=
 =?us-ascii?Q?kR+gi/XVU5fXWQchmwd8hBAwZkovoH2TXlvhtUKAsHT0U96LjBfLj7dgERIq?=
 =?us-ascii?Q?ZPyntY31iixXtz321zvb8fwhtnvKgJYBk1n/uvyzoZanm8yHqqJ1Y8sjIfDu?=
 =?us-ascii?Q?K5UUmRfRmcDVK1ZfRtvyHwDYVkeOfX5Iybjpmw8Z4f6uCc3M2j5vB60I1czg?=
 =?us-ascii?Q?C+tUF/eEAqlZmBYzqx2V0DXt43FCJQOzPOfV3ANPf+NUHKopJ6JCDaFmDO+A?=
 =?us-ascii?Q?61gG0PTNFLe3+mmF7R4cIGmS1cOs4b+Xx1KYWyCkYUO6+tAi8+TU43Uvtg1v?=
 =?us-ascii?Q?vy5Jv1FrvGqYdQjU139nVGBQAJwlv/7Z4MyuvLJVvD7d0IO7Jqe1LY4lVY/d?=
 =?us-ascii?Q?mNZEjr/KRr9rxuycB/wiM4Y1ozKyEg+BAaKZJ2ziWNTqot3/nex3GhpexZUy?=
 =?us-ascii?Q?+9ZKSNXSol9haFAzjUctJJv5UKd9oBua1sj2ywW0rFR48IJDHi7CKYaEi1ZN?=
 =?us-ascii?Q?Hcg6Wz830bGWNKMiUXvcCAlfEluN/dKXbWJmslbqPfv/VlNJOBrXR5Patx99?=
 =?us-ascii?Q?siQiynao0zKH9dknzXySsKFtqchZNhUnFfTLbQ8b3JJdW5M0hzeI9jtWpOdk?=
 =?us-ascii?Q?J8c2BFJTRH49LqRHA85vm/0nkhXuxTkH/pZQLc+QbIUTbZt7Ge1gaWG9USzK?=
 =?us-ascii?Q?LbJ2WnnVanHAxD3IDVrN4BZTQT/dI5dmt8zPa4celB82gsltauYvjMnlBxKd?=
 =?us-ascii?Q?tPFyQmJ3bNDEOLO1Fj4V3+T/0k5XEV4eflwkt8xQqXhuCE7NjG2wVymEsWHH?=
 =?us-ascii?Q?ID7Ier7j4xLKk6z7/ZloPE0HPcJFDPis5myEnCMFqGxwJMxPI5IB4EDHU9tp?=
 =?us-ascii?Q?HusYMehtVwuDLblDPcSCmLq9TURO0F7WfCS5HfaeV/9mu3q3JuOi5y4R8/hq?=
 =?us-ascii?Q?o57kSo9hHpeVs7Le4sPvc8miIrpkau/R0UsymadtjjcCn9qvkHEHKTuecfiU?=
 =?us-ascii?Q?OZQq62+Sk18WSxo+SqaU9qvreRwgaJVM2cNhkmMkAl6b2irNp58d8eP5/JPy?=
 =?us-ascii?Q?KO9Cfho5FTZUwjmsqBy+KTM5?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad213ff0-3ed7-4307-47e3-08d993350a03
X-MS-Exchange-CrossTenant-AuthSource: DBAPR05MB7445.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 19:17:06.5718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YEC0fjeGohAmA7nhqlsUiu/A0WKkPkYALn9mvl5OOfAMrYxV5fl2XhbkjL+YCkKItL8bFujcVrnYyrqHn68mlsrH9ZjTaon+rYJ/IJhHcag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB8654
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

Some Micrel KSZ8041NL PHY chips exhibit continuous RX errors after using
the power down mode bit (0.11). If the PHY is taken out of power down
mode in a certain temperature range, the PHY enters a weird state which
leads to continuously reporting RX errors. In that state, the MAC is not
able to receive or send any Ethernet frames and the activity LED is
constantly blinking. Since Linux is using the suspend callback when the
interface is taken down, ending up in that state can easily happen
during a normal startup.

Micrel confirmed the issue in errata DS80000700A [*], caused by abnormal
clock recovery when using power down mode. Even the latest revision (A4,
Revision ID 0x1513) seems to suffer that problem, and according to the
errata is not going to be fixed.

Remove the suspend/resume callback to avoid using the power down mode
completely.

[*] https://ww1.microchip.com/downloads/en/DeviceDoc/80000700A.pdf

Fixes: 1a5465f5d6a2 ("phy/micrel: Add suspend/resume support to Micrel PHYs")
Signed-off-by: Stefan Agner <stefan@agner.ch>
Acked-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
There was a previous attempt to merge a similar patch, see
https://lore.kernel.org/all/2ee9441d-1b3b-de6d-691d-b615c04c69d0@gmail.com/.

I have not addressed (yet) a comment from Christophe Leroy, he suggested to
remove the suspend/resume callback also from PHY_ID_KSZ8041RNLI, however this
specific entry is for an undocumented phyid, while according to the datasheet
the entry I changed already cover the KSZ8041RNLI. I have no way to verify
anything about that so I took an extra conservative approach.

Changes in v2:
 Fixed commit message typos
 Added fixes tag (Jakub)
 Added comment with reference to the errata in place of the removed callback (Jakub)
---
 drivers/net/phy/micrel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index ff452669130a..44a24b99c894 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1676,8 +1676,9 @@ static struct phy_driver ksphy_driver[] = {
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	/* No suspend/resume callbacks because of errata DS80000700A,
+	 * receiver error following software power down.
+	 */
 }, {
 	.phy_id		= PHY_ID_KSZ8041RNLI,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-- 
2.25.1

