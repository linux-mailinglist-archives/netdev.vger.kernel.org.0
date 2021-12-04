Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEF64681A7
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383960AbhLDBEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:04:34 -0500
Received: from mail-dm6nam11on2113.outbound.protection.outlook.com ([40.107.223.113]:36640
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1383954AbhLDBEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 20:04:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZurpFYFCgBvc7VXLM8EsaO8yo6NixSb93O1/lKQ/HceWtN6qum8+8ES9+T3M1BHSlfnR7B4rpwVlAX9ZSQH0PonI9eoIT0WKkFuapHGmPukv/9j4MdCG1nwtz0tcruwJ8A8Kk1OXIlfwklOpGPlCfM/smJv/svns+ZMEfu8VWPDHkWm93B5nbOA+eOKnqinRW8Jg7360TYm14WaIb0I/q71P2NNceNv5hLJLnPOl+cFyASUAeDXgEgMMhKDM+DjPec9a0NlWO0DeW5MrRp94I0JvnmG+Or9JYF9eJskE+ekXqeGbg2x5l2+kVlCvxZnMh22/rd4ozcVcRfo/rLqwWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ezPiOT8Ha9UfJZWvxAns1+9lWYMgev4bvsL6230H6E8=;
 b=mWcThNxSqMXw6lckCOsrkU3WUAqLb/S62cB6N8AYgFWinXHdUSaTFlfcx4hhprSL5s52I1mYQOIkgBwOlf9WxmnBnsiKFsdntrFcV3hbVFy/4y6IQodzKMqJbMAmyns8pXf/qB+MzFRI/tu1QoXiYOs2nYirhRs/2WliMwcTKsKtESYMxsCa0RVGbWomZhz/W+CPpTHos2BAjHS/mf1/pyVk7l/W2jJn9E7xgBF4pmpiVcHgqhpih8itYIu24ivAd98s8pClZ4Cz6C8TGq+KCfjW2AG0X8qasNYccQsNc5bbX8JxpKwq2dpS16jZA+ZZ7vvdx/wi5E/5fvaPFhtuUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezPiOT8Ha9UfJZWvxAns1+9lWYMgev4bvsL6230H6E8=;
 b=pRRzm4TXaxKJsHwAE6lJSs0OtiHt/L01m5Sn8gG/K+khHsEZwh3vsdA7Z37sqjMCz2JJsJXvv/dg6HtfguZDC/asU6W6SH2u61RKAN341XQAHUDyf+mkDoYvlUJhLd7LubWdZGM8E3TOi2IiTkqlnzU9CkEPd1e52twIHdAJo3o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5701.namprd10.prod.outlook.com
 (2603:10b6:303:18b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Sat, 4 Dec
 2021 01:01:05 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.028; Sat, 4 Dec 2021
 01:01:05 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v2 net-next 5/5] net: mscc: ocelot: expose ocelot wm functions
Date:   Fri,  3 Dec 2021 17:00:50 -0800
Message-Id: <20211204010050.1013718-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204010050.1013718-1-colin.foster@in-advantage.com>
References: <20211204010050.1013718-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:300:4b::30) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR02CA0020.namprd02.prod.outlook.com (2603:10b6:300:4b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Sat, 4 Dec 2021 01:01:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 394383b3-0d8d-4016-01a7-08d9b6c18ca4
X-MS-TrafficTypeDiagnostic: MW4PR10MB5701:
X-Microsoft-Antispam-PRVS: <MW4PR10MB570198850A9761D6F20E2F70A46B9@MW4PR10MB5701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b83vNREgQoQ1NmMkuRoQcNLuGvJIja03T/+vbf9qD4wngWXOgsOupGPueE1lpIUqfMq//6HF/pq3lfnVxA7uWGY2p7MoTcC3XFZg6zhNunGwyJ3k+wchHNSL6gpDZPSGYgdmMz7csl4/sUX5pp8Gu0VbYs17QVQIa3yUJSILYh6Rn4C+rtbNBEhkoXdSACKaTs4L34JZmKq+bUHz474oiLDc9Mv+w+ZGlVlYQh7LDfJq3l4kFGzcImhgbUKvsukVjf0ahAnPawoMER63yt03gnf1dDbQDiJldD1JZF8nNpn3SN4dNhk2wuhKorG3hu4v0tnlEClvmltHXAVdG5QcNRy5J/Seb4Iy8H7agMdgNAoDXLjuWPsJX6AilMvCrl7etXUCzaAQzJKTt+HCDaplM4MSmMfX3ooPtOGXu5xcyiw4jfiY0i3Bev2T/OLiUPmoJywze9xjzhegd4NFXi3s0Hg8n1v25CnpAzy1eltgjSAgNKZupdafckbnZtCHJE7L0XCqYyjkWftkC7sUBf14BJYxsJfrIRJKkWTLhTSVZ1AGt2YzRcIhtuCNTmogNNGTO5Vh/9Et7uT5BnosBoq6LN8N0KOsP3JcZ7sZElUrJurOqUNKM3+H0n/JDHhmLML6103BtLfZwXUCIffXjnXyDFqA/pXAtsfSg0P4Gb4w9w0EzKD0bUDrsQG3gx6dH7H6GzW1GLcGz9+7VYKmZuXVSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39830400003)(376002)(346002)(5660300002)(7416002)(6666004)(83380400001)(6512007)(2906002)(8936002)(66946007)(6486002)(66556008)(1076003)(66476007)(316002)(186003)(8676002)(4326008)(54906003)(36756003)(86362001)(38100700002)(44832011)(956004)(52116002)(508600001)(26005)(38350700002)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?auwuI5reP9eYGQcJ4t9HxcngjMZ5rcHeeYDgdZy2/uEcH8FNufpdeEPEAeXv?=
 =?us-ascii?Q?F3Ynf7TuZK+m8YKPQ+cndcZ8luL77ilf9AEng5wiki3EqQ4EV18haikCn6l/?=
 =?us-ascii?Q?bqOdwbB5nLg7lwcebGoXgU7Tu8swkeCd2BH/YekeDEMr8NZk3OmvONqkrPVS?=
 =?us-ascii?Q?B7yfDtvfa+qVrRCFOGLkbOr9WiYeqwXO8ejNLcVoK3opx/+Yzgg/5IFKzrd1?=
 =?us-ascii?Q?BFneAo1faq5ZejpUwuwjlfbFI5+3Hg14UnkZFGo1CVZ/ahi0TRkbtcDbupFe?=
 =?us-ascii?Q?7f3ph7rLhGHkbME+x+Z6z978yXF2axtPUh0robSqkYvdeVuUd4tgfOekFLeC?=
 =?us-ascii?Q?y/3WBiF3vuC5iZv7Ln2KlOi6CAjnHt8h+o0aeEGg+d/RnoMBggS1K8cZI1YX?=
 =?us-ascii?Q?Ie1LLCAA/GY+mD01SfUDtYggYy7mp9AVq2RheIg39oQVMtu71xmpwqqwRvJu?=
 =?us-ascii?Q?QF71zrKOVIz9KfVOHmbSe+h16+P3dhnWrEYFfHhTzC1YmEbncgJ2qLtQQdWp?=
 =?us-ascii?Q?G+X9Jo3mzvLVVWeOap2e0UuK62jFhSBM6WIglZwTGlAgOE9SUfiossieJsMk?=
 =?us-ascii?Q?m1Z4FElijEKyyVBwAGS98noMCAWz6f+9eXQ6OMsTN5/tRwDOhq3byHNu3gAB?=
 =?us-ascii?Q?VgldP8EMhotwxFEX3YPrCu3OlUNmd8gYwNAyMAbfBV+OKjsa80iLPG+CYIgl?=
 =?us-ascii?Q?kdqYdBSfaSu0l8H0wds1tvGYpvujKSuWgjmw10G9u+lxDlgGDM7p9WhDxyho?=
 =?us-ascii?Q?QKiYQxfc1qpN1wywJZiTeh1LnXzhYjFxR9v4DZoZ5Tx3GwQGEkMCcalBxqoc?=
 =?us-ascii?Q?xrd4ZgeVVhmi2w6P2fjHm5QQRaLOAjHHVxvNGnGoF6m3qKyGNgXINabZKFuv?=
 =?us-ascii?Q?lsjKEiYA8IUghwPNE4xFFxC8+S/0SjaaoXRYGiDIw/2CNClmZd/LPFoS7eBJ?=
 =?us-ascii?Q?5HeyTcgxW3GWUuPgJ1J0SR8LaHc0g5nbZP/JPHsZAzTRmw5eZ87Rok2taoCA?=
 =?us-ascii?Q?GQHXIeKy4ESfq6t/hN6xRA4CSWltfdk9+VR8k+ubBwrBn9/RHrEcxzl4Hfxk?=
 =?us-ascii?Q?9YgW0b9/P7egX6YyjBDW37iOLmurWJqDyhAGqX16T4MFl10BtVjV6WddIIrt?=
 =?us-ascii?Q?fa2Z5CoSWPPu1PXuMlUEr3KQ0M3yL+U2bsPn5tuLML2b7xUp9DOdAc9iEcbQ?=
 =?us-ascii?Q?0R8i5tUVwzaXu0Uiw9YCsKTvXW/UsVz1YyHlCFW41EedsqhDSw1GKBnkFkJ9?=
 =?us-ascii?Q?9Wl0J19SO9C4CDGIyMpfV2ilNeW/g40nOqAZcYP4BgHRjd9cUscB0gZOXqb1?=
 =?us-ascii?Q?mrYRSylL7p0YKJPAkpjwH8w5ZOj4kl8jyeWY6Eudzm30LXzmXjzpUmolRQEF?=
 =?us-ascii?Q?EQVQLR3r6lozDpjUpODtb8bpmpD4ViliO/Z2LvTPRUZS0U/H2t8oXEHY9f7f?=
 =?us-ascii?Q?fg5+wQW8sI3NZIE7SUo14WS0XDaDxaflPPIb9k0zr2dFqq3CZhOt4nJik+Jd?=
 =?us-ascii?Q?TCwi0XOTY5sHPRRS6sBhendg05fsoxW6J+quhwRRuBHvCESmGVtwjW3XAy82?=
 =?us-ascii?Q?Rfbq6z5ujaA60D/ZKgiQo04nmn99h6RLkTVRpVHaJMKGzyATb/rOeFO0AaS4?=
 =?us-ascii?Q?btrvE5maLnYKk9e3eMw7mBtPs53/Vzdw8FEI2xth1GcNWCf3b6rJ9Ltvp9nX?=
 =?us-ascii?Q?4SucsBzjqP5twLxgLS8gSZDPGzY=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 394383b3-0d8d-4016-01a7-08d9b6c18ca4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 01:01:05.5716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bKt8gVOWdXirKoNDG57ehasKzHe/F6SiPyOREATll1bS235dt0zHPxOk8PmqWqgEgad/nRdkezMlkr2Na9qUoCXaniKNGlOc1hzVzTOgP5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose ocelot_wm functions so they can be shared with other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_devlink.c | 31 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 28 -------------------
 include/soc/mscc/ocelot.h                  |  5 ++++
 3 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_devlink.c b/drivers/net/ethernet/mscc/ocelot_devlink.c
index b8737efd2a85..d9ea75a14f2f 100644
--- a/drivers/net/ethernet/mscc/ocelot_devlink.c
+++ b/drivers/net/ethernet/mscc/ocelot_devlink.c
@@ -487,6 +487,37 @@ static void ocelot_watermark_init(struct ocelot *ocelot)
 	ocelot_setup_sharing_watermarks(ocelot);
 }
 
+/* Watermark encode
+ * Bit 8:   Unit; 0:1, 1:16
+ * Bit 7-0: Value to be multiplied with unit
+ */
+u16 ocelot_wm_enc(u16 value)
+{
+	WARN_ON(value >= 16 * BIT(8));
+
+	if (value >= BIT(8))
+		return BIT(8) | (value / 16);
+
+	return value;
+}
+EXPORT_SYMBOL(ocelot_wm_enc);
+
+u16 ocelot_wm_dec(u16 wm)
+{
+	if (wm & BIT(8))
+		return (wm & GENMASK(7, 0)) * 16;
+
+	return wm;
+}
+EXPORT_SYMBOL(ocelot_wm_dec);
+
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(23, 12)) >> 12;
+	*maxuse = val & GENMASK(11, 0);
+}
+EXPORT_SYMBOL(ocelot_wm_stat);
+
 /* Pool size and type are fixed up at runtime. Keeping this structure to
  * look up the cell size multipliers.
  */
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 2db59060f5ab..6f2d1d58a1ed 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -306,34 +306,6 @@ static int ocelot_reset(struct ocelot *ocelot)
 	return 0;
 }
 
-/* Watermark encode
- * Bit 8:   Unit; 0:1, 1:16
- * Bit 7-0: Value to be multiplied with unit
- */
-static u16 ocelot_wm_enc(u16 value)
-{
-	WARN_ON(value >= 16 * BIT(8));
-
-	if (value >= BIT(8))
-		return BIT(8) | (value / 16);
-
-	return value;
-}
-
-static u16 ocelot_wm_dec(u16 wm)
-{
-	if (wm & BIT(8))
-		return (wm & GENMASK(7, 0)) * 16;
-
-	return wm;
-}
-
-static void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
-{
-	*inuse = (val & GENMASK(23, 12)) >> 12;
-	*maxuse = val & GENMASK(11, 0);
-}
-
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 33f2e8c9e88b..0ac0ef116032 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -806,6 +806,11 @@ void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
 void ocelot_deinit_port(struct ocelot *ocelot, int port);
 
+/* Watermark interface */
+u16 ocelot_wm_enc(u16 value);
+u16 ocelot_wm_dec(u16 wm);
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse);
+
 /* DSA callbacks */
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
-- 
2.25.1

