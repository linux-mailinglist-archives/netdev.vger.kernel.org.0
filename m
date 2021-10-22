Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA1C4378EB
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 16:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhJVOUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 10:20:19 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:37344
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233067AbhJVOUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 10:20:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJUn2+IlM5xMKoYbWrb6PLbEfWWtG6KGS+SDnnPfiOgbUzc7ocwIrOOAoPUJFnr6x6gAaf+nm6Zu7EMKCXk6+yBOyYiQaODSfKzFY6o67/qkTP8dGC0MNYvphDhuFjfjy04xAXegXxClvjmoSLUwHpcw674UmsSrhLifLOSGiietsiIYlK1QZ8QD1r2mNx2NWGAKTVStuso8dSB0Erh/PwTxrIaFUOWR2Qn2jnNKGxc73Hv4rnUJuQWDbzQDhNqVP80CubzczCFTfcuKsIQ8Fulf9GnPt6hAM/NK9T38rA4JC+xJlg+iahpXTIp03WJMBk9pzEi39zShimnkUpkX/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1r/hWaELiKMk4wJCp+yQTDgHdoJ9nno2Eq/ONGDI0k=;
 b=T/L90C+DnSK2l+7I3OKtA4+L2LO7HzMuDdPaP7G7WKoZkaDtB8RmPvjGsdTa/B+kP1RHxcoTHWfSFaVWFh2+GEKGqwu67wxlW4UZCvoM6pQmHDzRVmFzeBOqKcpsUXIr+4N+Qju0uymxKroV9kjYtRB+XSwncsvyJLUbsH2TmL29byyVpgwt1efl4GTFSn6Ur9PA2oTNn/DKjNkhe+oJo1ljkBQZQubDCdQsAjsJ/8jjLUeK8NMTEfvepTDVw0Ig5XVe9V/qgYWSYy9A9tWV4aMEj9kXgCxSFzGLgCult4zxrujW2yEfX4UnHaQKOTcvGaWGiyg/623sZ+kvUN2g1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1r/hWaELiKMk4wJCp+yQTDgHdoJ9nno2Eq/ONGDI0k=;
 b=YbNBSb1B3Qbec1Hn6AdT20i0vEInjALKq2LaWeqQA2jC4lM8T6NY0KZVU0rVfdwIx2RcS55QwW5QB9geHIcALuczD+MoYM4Tm7hk/NQ/d9nmItv3tDgOgDPFbqBqGLS/5PiAmqI5CICfATw9WPs83EG0Q5350Z7pUeOUPSTTdic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 14:17:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 14:17:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v2 net-next 5/9] net: dsa: lantiq_gswip: serialize access to the PCE table
Date:   Fri, 22 Oct 2021 17:16:12 +0300
Message-Id: <20211022141616.2088304-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
References: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0159.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR02CA0159.eurprd02.prod.outlook.com (2603:10a6:20b:28d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 14:17:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e2017c8-d83f-42b4-cf2e-08d99566be25
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3406:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB340643540244A162539BB88DE0809@VI1PR0402MB3406.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MyWEN+hdpj0XIgi4fQKN1AnX+aepTXLVwqu+etXVTJeDqUjxrxZL5IlfhLCfttGoTBijdoIkF7Mkqp8akcULKw2Z3oL0U0Ur8Gw6oRDcyqmEIm7QUY6snZNBFZ1EeHdgB7+ftIGRGTmIoF/QZFBwnp8UMiZIxL1jXmjqOllkqev9nk1WBkYar/6JdEnzO5jH0ueq9YEn7frOTXclXyolXUm90PlN4FSTMn8gcw/8PuKFK/2DwpGrHpEweMu3XAXvB68uriNISsAdjELLG6N5fDR5PUz+NZc6hoeyNguCkO+jwYa84nmLZ3gOBSKZPOq3eyH+oBNO3bHvKKstxq59WqI8nik8fFBENws82O6lRV/c58c4Eq53GbFpgA3dhmXz+ubSCJ+3hCNOLDLmxQasmyCeXviw/TwnxJAaaZdbNBu5g9G59QRD1Cl2HTyzQF3R/Swv1QaowhC2goLJKPSdud1piS6hCTALwvr7lOoHL4zQEAFebZvZ0sULAcPMmWqCq6BNY6fX8/xwtjN6UCPrBUf8pqb20Oad2e5xig1NQ1TCK+pTYuC3ksnuMQlkflrfCycPJJqChd2pacMQe0z7oPN+fBNOY0YvWedDFOpqONZ+mdSaqkMQwyiCP2h2zeuOvFMpOhxtlhtqM7YomXsgbrYK5ZqfCIvTlGfxKw+O9n9vaU7JfgxG+6ZTZ2jONtsltiL1gaIkl6OzsCzLjtMPhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(8936002)(44832011)(38350700002)(6916009)(956004)(83380400001)(54906003)(66556008)(508600001)(66476007)(66946007)(6512007)(86362001)(4326008)(6486002)(52116002)(5660300002)(2616005)(316002)(6506007)(1076003)(8676002)(36756003)(2906002)(186003)(38100700002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GyFopCwJ2N5fg7NtFeZoBCjF3q3ME6+KQBPRVJv+OyNTBIrZh3+8am0OmEXR?=
 =?us-ascii?Q?LbqKwSF4NxAz68accppFML8ESkloZaV8euuxjGE/LCpjnDhSIAHiElqgo1pJ?=
 =?us-ascii?Q?7UNGgWAvYEcthBsGLL6PTN6zEWy64PpnPylJiDu3pCou/QUhXcOg4Wfz1T+q?=
 =?us-ascii?Q?71VUmdcJwFwMjV7TXDAbbDvEg3x0KxN9L3+PCaiSnzPE1bU/2NvAM7IUDmSx?=
 =?us-ascii?Q?i74NiLsezJEL7YbHBxD+s/LGfXtZXa0ixOpM4SX4RWlAiYriTsp56IcFp1z+?=
 =?us-ascii?Q?JeHt47bMu9hRy3vaAL5G7m8Ug397P0DEMLUzekSZK1S/Lilvx5ZnXqrSkLjm?=
 =?us-ascii?Q?b82JWasX7N3vR+oGZg9ftoSUSHW1+mtHSzYbwH3eSeJCplRJXezi7V0NgC+a?=
 =?us-ascii?Q?d2rr6L8dft1fJmtS42MyNpO+0bMRyu7uxeZdFnu9fgyfRuUJsfDf0ZmsxQb7?=
 =?us-ascii?Q?UAYYOHfnbmFHQYE/3DDeza59WWGibfPVWhZlYyS7lDSvNcsOgvtLue8mgVh7?=
 =?us-ascii?Q?A7CVBWE31uyuEM22JrMfW0xJxNu2vyCB2JBzwPUlWmO6+ZqTlzcVckCDssmY?=
 =?us-ascii?Q?mNUQjp4/gYdvg+GqOpR5buukRoihaefEeiM/dt31kArxzidk/fFodDYHQHKx?=
 =?us-ascii?Q?c5rHM1Behqn6AoAYedhMu2taPgaDxHVe3bNqU6gl2bHTcbP4rS4Q8b4z3r+m?=
 =?us-ascii?Q?qPZXUfzFI92R9dp0MCnJzYaiqD09Z5lxgltC6MfxkujrQ5+LiS0bObrLS00j?=
 =?us-ascii?Q?VhB/uTLhx9PJncKwrMUfsqllT296TSBcVhxkoLwAalJq9g+d/B/FVEvvu6jm?=
 =?us-ascii?Q?tAHD9g4zkokMrqqHXKXJSmvxYLcUUvb9s3+ccsx4R7ozKeeOHIkjvKJ81ndp?=
 =?us-ascii?Q?cfpWbsJ9Dk0jNDFur9f044Q0pT3B2K7U7DbH+5T2yKECR0iztRdzQ+WN+NiP?=
 =?us-ascii?Q?2A0fxzOgiTncM48ay/sk7BzWU4CqUlnY9S9NG+U4rRqsv7fHjNWHzyXzk9ni?=
 =?us-ascii?Q?jLGDNaXIDARjQD7kYN3ncDdhXpNHut7i+o4ABSrp0Wzy1da57PQFvwmvVJQJ?=
 =?us-ascii?Q?USKNXzqwB3AvlFM1yo+6drMiPpnj0lndaiprJbbz2x+V/+u4u19jGlw312Ta?=
 =?us-ascii?Q?4nwPo4jciansVE2yi8fFYo349nPnPzufIREU3uuYuE9cWxMGpXId9gFzzLc4?=
 =?us-ascii?Q?AFYpCjDj1N4E0a4ZkeqFwgH32eF6aNVGxkDHHcQ5sCSJS+KyZtE80LHKSwWD?=
 =?us-ascii?Q?khU+GY4OIk6Pzd2oMoSpqfdhsVs/pMASCgstyeS9/fKUtLoq6E85xT5tkHwz?=
 =?us-ascii?Q?/nV4yntmHBaIiHk9lwmH2Snr0vaLXi5Fp1BbQ6/wl2ZxkbG2i6PSIXr0Yw7y?=
 =?us-ascii?Q?vwlryjPI9YKUVLw8WerTgBYEiSDROrP2d7iejfUqRWMkngpt850dA6W5I6Gi?=
 =?us-ascii?Q?GSRb9CBzN5m/y6WTXHiUGdCuQIGZ3BGX?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e2017c8-d83f-42b4-cf2e-08d99566be25
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 14:17:56.0276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looking at the code, the GSWIP switch appears to hold bridging service
structures (VLANs, FDBs, forwarding rules) in PCE table entries.
Hardware access to the PCE table is non-atomic, and is comprised of
several register reads and writes.

These accesses are currently serialized by the rtnl_lock, but DSA is
changing its driver API and that lock will no longer be held when
calling ->port_fdb_add() and ->port_fdb_del().

So this driver needs to serialize the access to the PCE table using its
own locking scheme. This patch adds that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/lantiq_gswip.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 3ff4b7e177f3..d0900abc10d1 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -276,6 +276,7 @@ struct gswip_priv {
 	int num_gphy_fw;
 	struct gswip_gphy_fw *gphy_fw;
 	u32 port_vlan_filter;
+	struct mutex pce_table_lock;
 };
 
 struct gswip_pce_table_entry {
@@ -523,10 +524,14 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 	u16 addr_mode = tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSRD :
 					GSWIP_PCE_TBL_CTRL_OPMOD_ADRD;
 
+	mutex_lock(&priv->pce_table_lock);
+
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
 	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
@@ -536,8 +541,10 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(tbl->key); i++)
 		tbl->key[i] = gswip_switch_r(priv, GSWIP_PCE_TBL_KEY(i));
@@ -553,6 +560,8 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 	tbl->valid = !!(crtl & GSWIP_PCE_TBL_CTRL_VLD);
 	tbl->gmap = (crtl & GSWIP_PCE_TBL_CTRL_GMAP_MASK) >> 7;
 
+	mutex_unlock(&priv->pce_table_lock);
+
 	return 0;
 }
 
@@ -565,10 +574,14 @@ static int gswip_pce_table_entry_write(struct gswip_priv *priv,
 	u16 addr_mode = tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSWR :
 					GSWIP_PCE_TBL_CTRL_OPMOD_ADWR;
 
+	mutex_lock(&priv->pce_table_lock);
+
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
 	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
@@ -600,8 +613,12 @@ static int gswip_pce_table_entry_write(struct gswip_priv *priv,
 	crtl |= GSWIP_PCE_TBL_CTRL_BAS;
 	gswip_switch_w(priv, crtl, GSWIP_PCE_TBL_CTRL);
 
-	return gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
-				      GSWIP_PCE_TBL_CTRL_BAS);
+	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
+				     GSWIP_PCE_TBL_CTRL_BAS);
+
+	mutex_unlock(&priv->pce_table_lock);
+
+	return err;
 }
 
 /* Add the LAN port into a bridge with the CPU port by
-- 
2.25.1

