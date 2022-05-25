Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0EE7533AB5
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 12:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbiEYKhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 06:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242320AbiEYKhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 06:37:16 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2048.outbound.protection.outlook.com [40.107.20.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE70986EA;
        Wed, 25 May 2022 03:37:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mEsysh/OvXsO91bLzi6p8nfoaHCFDR+lxOD3Xe3uovv3j8aIaUsM6xiiaEKtby1sDpwQA4jwdEuO1jl3TlGQquK3Hb09U5888j3An63VWg/V2ZTZzdzLqJ707Ck9PIRAq1GYtxOfR3XCKG4RrRKwtbtEo4jF9gRtuVMWKgxiNJWhwLzfdJ9ACBEaTVYcVh7WbwLcIA9Yq/svEDlRWa3hKEgBdUMOY+HKlF2bgWKz2pVeJOCYrv3Ra2Ch/csrH3U5uZBBPlq0jjfkvZoOfzoPzUXE8HKADjcaD9iF2iL8pHlH2svpYyRfVUTYuv0GObKVcz1xFGVDIqKhPsgjCTAqxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GMjZmzGA7RxfzNh/nS/sArZPTqGT8YJXZOUBwW73elA=;
 b=F2ek141wu+nRPP+3Bv6ozantm1RPGVxBFlUtkNUD23HzkJfWvelb8c+R3X9m/RXNwTH4bX/Am513okunUyO3ZutRohmcNJQ6PHR061q6+bBN8r2HMLlZ8wVKlIYrnRDVvnnkKrwcLPB5Q+jdIGRw173pVhhsuURFEChyRlipb1dPPYgmMXP3HXNbQM60ZAl4hlfNdvVX+RdY5G0n4QHSNvOliH3hKeg2c/NPqi0sx6lqmxXvcq61FiBntwos3zxKOTbJvw8HyyTEj1CgKGY24kYiShsrc9lB5RNUJS82+arEIy6wXYXpBRmQ6LF+M68JnTZKAzSQz9LhOsE1ZtifDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GMjZmzGA7RxfzNh/nS/sArZPTqGT8YJXZOUBwW73elA=;
 b=AGpEGwSwhADf54twlsBBvXRGS+9fQok1XNJNe8wC3OSRiUL3okMi8COYXqfjORtaeifFTxRNSImMxZMubjNQMBeAYh4oVVLDGkwYXyyA1rgWSCn/mWTzdYyGxPz6PV9NjhENjoqgx5N4svvB851+AcvePeaTAGvzlvbzY/OeNQc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5005.eurprd04.prod.outlook.com (2603:10a6:803:57::30)
 by HE1PR0401MB2539.eurprd04.prod.outlook.com (2603:10a6:3:7d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 10:37:11 +0000
Received: from VI1PR04MB5005.eurprd04.prod.outlook.com
 ([fe80::b116:46f0:f42b:cf19]) by VI1PR04MB5005.eurprd04.prod.outlook.com
 ([fe80::b116:46f0:f42b:cf19%3]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 10:37:11 +0000
From:   "Viorel Suman (OSS)" <viorel.suman@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Luo Jie <luoj@codeaurora.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linux-imx@nxp.com, Viorel Suman <viorel.suman@nxp.com>
Subject: [PATCH] net: phy: at803x: disable WOL at probe
Date:   Wed, 25 May 2022 13:36:57 +0300
Message-Id: <20220525103657.22384-1-viorel.suman@oss.nxp.com>
X-Mailer: git-send-email 2.35.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0013.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::18) To VI1PR04MB5005.eurprd04.prod.outlook.com
 (2603:10a6:803:57::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 374c81cf-ec37-4288-1b57-08da3e3a8667
X-MS-TrafficTypeDiagnostic: HE1PR0401MB2539:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <HE1PR0401MB2539687457740EB0E7500320D3D69@HE1PR0401MB2539.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RQTF5jmdeF8tboTxBfH/FcsM5WHLLVZ7uJUb/18kPR04ZRPz+TAALg6Zmu3C4riUwPvgSBboE0zRv/TKpRQUPwwLy7ypZoS/fBTAwanClOAf+Bp4+ZU42zlM2TfoAlbkqn7Regb7UyLI+CEDeqHaC6E4es0wx9BJmoa7ZRbMJPt6g0B4X4WfKOqE0S76BY8yGX3vhN5phwLbyGHj76A9YNBqIQeKtPSU4i73hBCDdOfNoDnbr2WeeuRAKR/bhHGduHCkn8GLdAnbN8gAhPHJ9rRlwNrigm6P4vu2pIfoGriPLMrmmjqoVdeiwp06Qqao7JcGdGdcINewezywGClvvNisOnxNTEKWTo6++W4uyXcPiNCCb5eknwxyYsJniDwkL5ZCo4wXx4yyBZRx3VmdGFAt/FyUHIFkhJj+kP2zRqaKrsR1AA4hLR4mCg7vTUjexHOONJulOT0Qs+cAbDEZ9kHuI9gdTAGCB9pJ3SjQMXazSLEjseWZG8z5swfEtY6LOAHaDdYUvdkXjxD61ZLOAwXtI4ktw8JqLUlh37DDG507QvEytSeaezOHYLX9ju76RGkcQye9vHRSY3gERrW8Kg9pth9fAr84XY1BN+Vnx/da5YLHu85dBn5snHb2aPYJZdJ2J+R7iwx1Tq+2yhnxy8jpChS24NPUWRtFYOVjjtiVdD7LC34p1V6mv7LHt9TuWgi6CdYfiuLdZ+K8aC9pdN4X2kvhdjNGlA/BMxn2hNg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5005.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(316002)(110136005)(4326008)(5660300002)(6512007)(6506007)(26005)(66946007)(1076003)(7416002)(86362001)(2616005)(66556008)(66476007)(8936002)(8676002)(921005)(6486002)(2906002)(38350700002)(83380400001)(186003)(6666004)(38100700002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wGb+MIaQZ+cWMGBiroqApl16R1DO2nNuUxz4iUoiZJCcUjqicpkXLOVxjwC8?=
 =?us-ascii?Q?ba1990YU6x0+9lXLiw7eikadUAALKgL0oQzMtP2wn5dy/cejT4HitR8QYVqn?=
 =?us-ascii?Q?VU56V7hXZDvJJeW7DPGFZOWmyLhM4MRRZr4cbiwJD3zro6B5r4yyhoZTPG6w?=
 =?us-ascii?Q?HnBsZGsivzVyNnXXC7/acNmMZDjomA4kd1opwxSpgTwlxAVpD2gZRDHwIXba?=
 =?us-ascii?Q?2AeybXy14LqXh7USn+5YQxFuUduIiSXjfCaS341WAOJ5aBIxx/wSF26PEPuP?=
 =?us-ascii?Q?IS5gJ5d6s4NHAC0VVHRhKPVm5K9nFGanNWV4+4B0xoUTBXSn47491g8hNx+l?=
 =?us-ascii?Q?XFYqHYB8a4/jSRLARVAWrc9xbzPZfJFEp013kVIc3JEMEiXiOOdaNd/qbxMU?=
 =?us-ascii?Q?C7jqYpSDgnBy9EpV75/66cPa3SiCJqWpIE/bw/UsWxPyCdQhX0Mk73Rlaegb?=
 =?us-ascii?Q?+u7OqhLXCK6zexQUO3Vhk229uJzmaSKiKtAgRzSI+Dgg9tb7lbH7Sp1FRK8F?=
 =?us-ascii?Q?1hSNQFywB1IVDPJI2yPmGZEVS9misBfErhLKFbINvb6Zn7/4FKMYJFBf51o3?=
 =?us-ascii?Q?+OPIzeqgEBsEGmgYfnP1GM1WcL4118Dm+33KVUpnCQLsAb+zzT5CQ58KinFW?=
 =?us-ascii?Q?4PLEIlG/B8HmolLBmW2gL6j+Xi361PXry1YFtjI7LfNFJIM03knUZWWQ/39t?=
 =?us-ascii?Q?jgIPE2O6S9sQfNP+2odII6HKi5OKFa+LZc5BjdFzmhvAGr/fjqLZIaR9OT4z?=
 =?us-ascii?Q?nCy+yg2vXs/XMLNzhNoyuPfOAoR29s6PsNbL5exbG+yNGufjzW+mtVD8qCxR?=
 =?us-ascii?Q?C9CwitF8jDW1Q+JU8kT4wA5djLOfq5MwIom4bo+niCwKyLK25d2m4LAiG7Pp?=
 =?us-ascii?Q?oR+lH3PGTLU1ACgRWUfrg6kYPbzmQCW2mFeC1guD+Auc9KdQyfbMkod7jBmD?=
 =?us-ascii?Q?XedGUCjE7XQ0WKuqQadvRz+IyE2yE2A3k38BCXB4FBLQPtUkdEuPHV0XaUOw?=
 =?us-ascii?Q?Bql3ujHvitN2hNqvy8kUvqowcoHpTxlGv4X9e/6zje4Of2Yuej1hvgnVtdis?=
 =?us-ascii?Q?wfX+DW/qXwd0hii82DSvnhCAr0tUOKyKXGq4oFdLPVfx95HVC1r8Q4p+0coh?=
 =?us-ascii?Q?7SjnKZGr4wzSWwTXNJhPDnNhF3Wd72eBZU2qbU8q4ikMj3cqIsBKUEQzE9Kc?=
 =?us-ascii?Q?Rg4Xi0lPAfVt6DJE8atidZLkFCeCWmnlqQM5416WdGHim3UZGXTG2LqgNzwO?=
 =?us-ascii?Q?jQuyHG9pfalLZD1G6nRz76PpxuUrEO9NTr1sPb3jLklUfhiCo9hVKYTd9p9p?=
 =?us-ascii?Q?gqKeTloIMDmpXvYc8fPseaBwqkExVdCHKcm0LmeIKt0gcahemk7Gr53p1MZm?=
 =?us-ascii?Q?FqdBoxyoRheGYrGO0xqjSFKzsXysT8a7rGDEnGQU3nlk5JsMITKikfnlhqBa?=
 =?us-ascii?Q?FGov/sdNTL/9Yit7flAYsWl0PidK6jvCMfKovJyHqPYGJyEXzaSTBIqaYtZo?=
 =?us-ascii?Q?OsBpz06ayCSAFIPLIZlQoimxBDo2ULtnHXXYxFgvb9nS/L57BIN/SL6WvRfb?=
 =?us-ascii?Q?KD3m/TiAQ4fDg5vrswRUHSM30BxQP41edid2bWoH2paPBCAsJKCb5cyeNjnK?=
 =?us-ascii?Q?fVll7PY3kgnVj9hU68jqTO2Vv4mYRLQVfuCcFvMRX7In8UKzBGE+bIuTdpG0?=
 =?us-ascii?Q?73MMACvEa1wnDTkwu4uTHDRt+YWcau1EIUL32gE8uN2W77tGT3Npwmx4SnhY?=
 =?us-ascii?Q?3NXTjIh2wfK9L+LYGLTo0XFyZezWHmg=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 374c81cf-ec37-4288-1b57-08da3e3a8667
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5005.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2022 10:37:11.2619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qMTOhO0obSN0hmvIWtOhq7CkY4pOWfmfsjhheU9f7qvlBRrDW8wRmxEE9CTZ1d4ohDQHLnacyUyUkrhjp+QqRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2539
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Viorel Suman <viorel.suman@nxp.com>

Before 7beecaf7d507b ("net: phy: at803x: improve the WOL feature") patch
"at803x_get_wol" implementation used AT803X_INTR_ENABLE_WOL value to set
WAKE_MAGIC flag, and now AT803X_WOL_EN value is used for the same purpose.
The problem here is that the value of these two bits is different after
hardware reset: AT803X_INTR_ENABLE_WOL=0 after hardware reset, but
AT803X_WOL_EN=1. So now, if called right after boot, "at803x_get_wol" will
set WAKE_MAGIC flag, even if WOL function is not enabled via
"at803x_set_wol" call. The patch disables WOL function on probe using
"at803x_set_wol" call thus the behavior is consistent.

Fixes: 7beecaf7d507b ("net: phy: at803x: improve the WOL feature")
Signed-off-by: Viorel Suman <viorel.suman@nxp.com>
---
 drivers/net/phy/at803x.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 73926006d319..6277d1b1d814 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -443,10 +443,10 @@ static int at803x_set_wol(struct phy_device *phydev,
 		AT803X_LOC_MAC_ADDR_0_15_OFFSET,
 	};
 
-	if (!ndev)
-		return -ENODEV;
-
 	if (wol->wolopts & WAKE_MAGIC) {
+		if (!ndev)
+			return -ENODEV;
+
 		mac = (const u8 *) ndev->dev_addr;
 
 		if (!is_valid_ether_addr(mac))
@@ -857,6 +857,9 @@ static int at803x_probe(struct phy_device *phydev)
 	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
 		int ccr = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
 		int mode_cfg;
+		struct ethtool_wolinfo wol = {
+			.wolopts = 0,
+		};
 
 		if (ccr < 0)
 			goto err;
@@ -872,6 +875,13 @@ static int at803x_probe(struct phy_device *phydev)
 			priv->is_fiber = true;
 			break;
 		}
+
+		/* Disable WOL by default */
+		ret = at803x_set_wol(phydev, &wol);
+		if (ret < 0) {
+			phydev_err(phydev, "failed to disable WOL on probe: %d\n", ret);
+			return ret;
+		}
 	}
 
 	return 0;
-- 
2.35.3

