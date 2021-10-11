Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC39428522
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 04:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbhJKCaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 22:30:11 -0400
Received: from mail-eopbgr1310132.outbound.protection.outlook.com ([40.107.131.132]:62336
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233260AbhJKCaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 22:30:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gir5iXrZJorYArVYp9AlSe8r/NPoenqiUC7j+MP1y8UOdoOdcqA05ELnqCGfDs0AtMtVmFLKwsBwB+TJILRBnN35/NuMqX5rwrOhmoVPer2eoqXdXrBNykO1Hv6/DXb3iMjcwmw+W5gKGsRgENKPNOt8MUQ7u8RJ+5ImTAkEbmZ5JLDTTAGkterW/z41XlU9SpWBIx43z2YekmYA5ECV9pVOPTRb/J0+vFpqcgEY1r3v5OFBI5rE0UWoT3fPtkGxHxm6BS1BHavurYTWMSPZGr90uuxR/dTRzGJjmg/P+9bzfSzIGORqMqORm8wi90lE3hNj1mh9MVR2a3d1hrF8YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjInYpNr3RsQnOj+QeCc+il3I2BtaaLMI/3ysh9fd3c=;
 b=d9cF4lEE+b0WW8+itnX9/oj3SHbXmwWFOYy/jlrPiU8P9R03YHJNZ8Um+8hZd6UB8yfYyEQSVlR/orpU1hp2D/SfWRb4vF2L5uG5UGoHIeG4nsvA2jYOM2a/h4sPdm55mGYffCOhD/P162hDJfAatbxxMtsAxvlKTJobuhU1bF4rVL4ia3hQC5YTM2n42FrJjHIXHORaGmvDcAeQhBzvp/pg0NPg1xJwv+WGHxs14pVYcxnLeuIOxdkOdElc5GqbiCdDgdZTDWR6Hr/Awv++sPFuvT5v8IkIJMFpLFdxoLambshhRuAnCIqes+cryoUfuBExjaxUEQWC6q6mWatW8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjInYpNr3RsQnOj+QeCc+il3I2BtaaLMI/3ysh9fd3c=;
 b=lQmQA4SNXIHby7Ed2uwL6piEpcRFjZxcwaFQGjYmX+fW735HgMOJTCGzbGsNwUNgcJPkqHC0eAyv+ZbaByIc7FTwbKHfvSn/4C/oaIzo5cU8H2UWQISoZGFYWk4osyiJyngpyH63v8eYMX9Vh0TaFWMhRB9U9UNPfL24DLhFY4s=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SG2PR06MB2521.apcprd06.prod.outlook.com (2603:1096:4:5d::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.20; Mon, 11 Oct 2021 02:28:05 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0%6]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 02:28:05 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] net: mscc: ocelot: Fix dumplicated argument in ocelot
Date:   Mon, 11 Oct 2021 10:27:41 +0800
Message-Id: <20211011022742.3211-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0165.apcprd02.prod.outlook.com
 (2603:1096:201:1f::25) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
Received: from NJ-11126903.vivo.xyz (203.90.234.87) by HK2PR02CA0165.apcprd02.prod.outlook.com (2603:1096:201:1f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Mon, 11 Oct 2021 02:28:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34037557-39c4-4952-1598-08d98c5ec146
X-MS-TrafficTypeDiagnostic: SG2PR06MB2521:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SG2PR06MB2521D7DDD2473DAA38766B39ABB59@SG2PR06MB2521.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:425;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2IXDjGxQAJU7F5n2kHmzgxrf59+LABf3aJHHPIzv+g46/ESdkCYnBbIkco9OSpFlX/e1vo9Oz6IBjpqfL+XiInRKb+rSlYDjIRU+LAfPys9dT027MNHvsq0+o5XwaL6mcW3JXI6qJGTY9KHvNEq33WOupev8eo57jURHC21RVhy2pYFL1odFPpAn9Uv/cAtIRJ6fPa783+Ibw13EROHb1YUOoShi4fd/LEs5bk3uUdP8EuskZwX96qBC5nWmlQF/v9pWCdV8j6/qNsi7Px4EAS1wL56lygu98tskdjRRFLjUmOc5U7mc51kkn0h5W3Np5zp1u9oAe7OBGlY2kMgmv6SpWtykBrl+lhKr8qlRrJWDbcS/oaKot8dsb/+E2iLiSVNberzs3YNRGZRsjIPlrFubXjIwNZ6BDc/JvRW1BMZxoWJ8lqBLs6EHwgTTyiNLDpTyPSGh/ldXeXTd0MR9futoAweZX5rtTrj3aKWt4vP90pyIPAAASjC1E6jvK1xjoW7vYQBshOUTeeIUa02wdAS3IZogbc2G9bcdmgNiTNFrxIzywe2+e3XEmO9hAfOIIJybj49/YiJinBKvqwPw34vM/GqwOy9CTorh+3zwFMg0XjPbxDS1DRmJafZnZI3zJI7gM4ghVDw2zmSdW60riA52id+YpAHBzA8mHirWmmflx04qmM5Esa5IoZ3YjpW3654JyQycYopwXkp/aAMB2q/iDCZ0aKTQN0e6N0YTFlo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(2616005)(1076003)(66556008)(6486002)(956004)(66946007)(8936002)(66476007)(6512007)(107886003)(83380400001)(186003)(26005)(52116002)(7416002)(6506007)(38350700002)(110136005)(38100700002)(316002)(36756003)(8676002)(5660300002)(4326008)(2906002)(508600001)(86362001)(4730100016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FaulhbnZ6LUkUp49Wyz8VgwwrS3awFsUF/7yDaZ2TXyG0Ojdt0oxUiOggH0w?=
 =?us-ascii?Q?V7btoLvHAtt8MY5hkF2SDYEATjnwkGuV8bz7AaaX7ZZXr5JdTXUvIO55p4HO?=
 =?us-ascii?Q?za3vLI3Sg+HMGiVZWghmFoxasyi8E5+8a0T1htJr+SIAyS7KEnKxhSfSgh5w?=
 =?us-ascii?Q?hnI02OtnnUuGxHUJc6HCRa3/Cmiq4fJMFmwG5qdZih45yUvjeau0gcQulPLI?=
 =?us-ascii?Q?SFlLaAPj2QX2ItkLb5NDmZLclmxJTz6qvGB+qWDFIjGwvS7YCwgCSt1fCU5i?=
 =?us-ascii?Q?NAlXdgcNsPx3MC6RRQwJaBRwC9GyRYC1VYib3qo7B5LlHCEdgLTa5kuPQU1J?=
 =?us-ascii?Q?nDwS5tNYPazfksLDf2A9oJMBY742R65oQuDxehtS+poKPudDyPI1jYSJV8ia?=
 =?us-ascii?Q?wYNhQ+bR8K6/G/Qz3HeO9WTEBaivye9MSgHtHxcADcQQ21zGniZQ0mModANK?=
 =?us-ascii?Q?B8MC+WBsLx22Lisofm/jfOHj01lRcLBOfo0r/i/YfR6weX4Qg96wV+3D59i7?=
 =?us-ascii?Q?X4iz4Nwgcud1za2XaXNNUrdl65Ec5IlzL1rGa2eSjvUJriWcHOJ82RVyL/HC?=
 =?us-ascii?Q?e2PpfXXON0PKmhoMPkcbKeXfEx3VKHBxksmNw3xuJzaFnNUacndxxpxa+R+T?=
 =?us-ascii?Q?bokUfEbY595mIoeFFuspysxGMN6iTyRue2CIjCv0GNe1wHxhOUu1WzevyEVo?=
 =?us-ascii?Q?QavXVNXDVavsLORUSmYOh+PcFtEZd9U1+HdC1S9Imz39e7Zam+EvdOqlpkz1?=
 =?us-ascii?Q?aNcR4REUQvauA/1a/kYcNTjyiNr93nKGHG6S0jj2hfiZin5jnlzKkNlmema2?=
 =?us-ascii?Q?zBZIqdR6MxSlSMq7YETVTkxXkFQSEOuZeR0QRWec7iYr8EW5ZNaS7B9+zzR2?=
 =?us-ascii?Q?5ij0HVf7HBD9J7NzdHuNZWWO8VSvCu528KYAsvXQeovbO6b1X36sb2NwgoKf?=
 =?us-ascii?Q?EE7mimIuZ0RClaeenLqxTnjF2nm/eqBJEJdYfZqjicPkKSrg3g/+6s4EeMLA?=
 =?us-ascii?Q?YqP/ii9hM3dzsjTwbHpi4lxZVMaRMI+kKut5p3vy9Cj1Evyv1R6d3Nj3AA7y?=
 =?us-ascii?Q?e5Nt/zgGbZK7ZNB0bUCLbZHAPoMktt3UtyzMJHD6kbc0S38sf7+nj9fAp0G4?=
 =?us-ascii?Q?Okg98/zbOy4d6tCauVUxf6APTZWWuADLIUGJovf+l0pogzbqJITsAsa5NeWo?=
 =?us-ascii?Q?z67/kAzgsG/yORmzCtVbuckMurP/xgDG+zW3a2bJ+coVqCEaQXo9jXvy1JtH?=
 =?us-ascii?Q?u2h2cDCY/lRIVjCf/oVUvbi8R/iGP70tf4GO7W8LFdKYEhdoqoGn/bZjvNKH?=
 =?us-ascii?Q?S+2jsCmoGaIAQeVtht0C1Js7?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34037557-39c4-4952-1598-08d98c5ec146
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 02:28:05.0094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z8WyPjMSolvLZhWb0BB2NPHgEn1IlPdMSrPw2LlmaESS0ozqmQMBXl17u7d/R5PXua9oj20GeNBz8R8vPU/4UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB2521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
drivers/net/ethernet/mscc/ocelot.c:474:duplicated argument to & or |
drivers/net/ethernet/mscc/ocelot.c:476:duplicated argument to & or |
drivers/net/ethernet/mscc/ocelot_net.c:1627:duplicated argument 
to & or |

These DEV_CLOCK_CFG_MAC_TX_RST are duplicate here.
Here should be DEV_CLOCK_CFG_MAC_RX_RST.

Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/ethernet/mscc/ocelot.c     | 4 ++--
 drivers/net/ethernet/mscc/ocelot_net.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 559177e6ded4..4de58321907c 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -472,9 +472,9 @@ void ocelot_phylink_mac_link_down(struct ocelot *ocelot, int port,
 	    !(quirks & OCELOT_QUIRK_QSGMII_PORTS_MUST_BE_UP))
 		ocelot_port_rmwl(ocelot_port,
 				 DEV_CLOCK_CFG_MAC_TX_RST |
-				 DEV_CLOCK_CFG_MAC_TX_RST,
+				 DEV_CLOCK_CFG_MAC_RX_RST,
 				 DEV_CLOCK_CFG_MAC_TX_RST |
-				 DEV_CLOCK_CFG_MAC_TX_RST,
+				 DEV_CLOCK_CFG_MAC_RX_RST,
 				 DEV_CLOCK_CFG);
 }
 EXPORT_SYMBOL_GPL(ocelot_phylink_mac_link_down);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index e54b9fb2a97a..2a85bcb5d0c2 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1625,7 +1625,7 @@ static int ocelot_port_phylink_create(struct ocelot *ocelot, int port,
 	if (phy_mode == PHY_INTERFACE_MODE_QSGMII)
 		ocelot_port_rmwl(ocelot_port, 0,
 				 DEV_CLOCK_CFG_MAC_TX_RST |
-				 DEV_CLOCK_CFG_MAC_TX_RST,
+				 DEV_CLOCK_CFG_MAC_RX_RST,
 				 DEV_CLOCK_CFG);
 
 	ocelot_port->phy_mode = phy_mode;
-- 
2.30.2

