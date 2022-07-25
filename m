Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0E15801FE
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbiGYPhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbiGYPht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:37:49 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2053.outbound.protection.outlook.com [40.107.22.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D033DEF2;
        Mon, 25 Jul 2022 08:37:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XihnsPN6TURuFr9hYY73kFr2YjfrxcsQVoeUker2NxdhbX5fTVijdLRdyOUUoD4MNErC9ip5OgymNsy9Y9FQcfakT7WVvytghqcbgFZ5517XW032eeczHGqz+J0sQhKht7yVJ454iJ3nMjAiM6Yxgo1w4X831pOaiWfbCqvy1ZZgcMvFdjqQSAg+pFH7fsAxdXTRqfjinOkWnhA120FMXWi7cvgasi3yUoWVYihsoDJOrN3gvIkh+qCfTcC5kG7lQ/jbOWf0aaCyalCOUyJIfPreSY8VFWYxCez7ZSGTlocsb8wM9Tcf0Xgj6MGYS3TeoaMjEFqPfxLePZbeyH8nVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u9vXb9is760/g8GXDINzfwto2ZlelCN8/EaE5pLRu2U=;
 b=Y5ClRNxM0F8fWO7D4+rq20Q6E4V2nofDcA55xYjg7X0vK7ZO1xOEoZTyvOITxi1OKXVfKiOcnhlCI8BRvN8hjTng9WtaUmU8YwFzHKZJttyJGhwm7zcXBL/USAbgk45Ucuzxp0v9nrRXJpz5Ywu1ghmej8ajyn57KpA6k/zRZ6FMmpXV6npMVu1XHEYbAZFcLVDT79uP4w/Mag2NvzWgBLN1yYvpDLh68qQoSMWpwKXX10Q4GmrwHcXnCSB/8TAuA7COupawSyn5HOP2gCs+vdIEJMjJT70jDwxcGPNeBfphHgC4ogC5Ulz7AEbBQI3BK+Hu7eDS57tWufE03ttlzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u9vXb9is760/g8GXDINzfwto2ZlelCN8/EaE5pLRu2U=;
 b=bsiQDhPcSmOrlMqvwt/s1sH4d8IoTR1W+4T64GlayAF2bZJFubcCjx1NFnZQJ/XGjbXAQgOCH9fsv7w4KAzJX6mTClJdck8doQTeGzm4ozGJ+IGFM7qFPaw2Uly55z9ERkgopD7yiXj0BsKMbS171Ym+lYL7ZchosIripQNdphM7pX/TCsNbQac7dxB1QbaEOCUNJRxXkul7m+WMEPHJ2Ja5ZFIj+U9nwz0TES9vpnJrSx6S+QK2KZD1tKvcXytpD7hiCB1SNHwIp36RYITDRhf1deg2MakKJSQxabgqG5hfMCJAadss2y1u1L6SYy4yCdxSeqAmNSPFHale1BB0wA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4394.eurprd03.prod.outlook.com (2603:10a6:10:1b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 15:37:45 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:37:45 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH v3 01/11] net: dpaa: Fix <1G ethernet on LS1046ARDB
Date:   Mon, 25 Jul 2022 11:37:19 -0400
Message-Id: <20220725153730.2604096-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725153730.2604096-1-sean.anderson@seco.com>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:208:32e::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7b585de-f0ce-48c6-6261-08da6e539e99
X-MS-TrafficTypeDiagnostic: DB7PR03MB4394:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nlOEKkObY9Gm2ocWOgprsL1a9QfpFWFh4bHRPnDe8edHE4jv3/FIzYB4hdPJ4FmOopsvwziyX9I4KlXsgTvOCSSd+Gk/4Nvj/8yXmWL946cwIxMPkt5xT/VE9kW1IoKWh+3ScQjfg83FVEsnjdOf9fJBeP+at4aSRQTgiFYMcsCTTpuj1AGa/cVlQJ2oNFfhoRjvjkKN3NlgoRXzhCyPWHI7TPxAwp/Oh3LQkYMLdENatUsbVbL6HjFex7U7tca0K207Ji20FK5LKzEvBnZgg6Ws/qAdJJD8AL9zTBGknUTjEFeXiijb0BrcgDszhI7Ao6oNxFp8brhc7X+bsD4efVt86DGF/6tg26AXb/mUF+LI2VexkwT9GctSe/Jy3ZuZr2zu4CJ92XpeZgDxzBsawhdi0pglPI8Hnau3GVQ8Gd8kyn+ZoBmY5jIwbxbkIEEZwATIKgnT6okoCgTqMt5EpGdLBrmFmjZuIohthl68C7plEYX9vv+D97/xbVaowepJ9TqqpAoZrpDZ9+l9dAgYozrZS0FQfjfBI+IppVhxU9wfpMG5WWBYsv99PXhP6Jm6almnVBjLymAEzlYVMz419kxxk4VPOreviuEUmuCThnfNvlyvOlJkOGxrliuKTSFCzPEiJirri27A68eVgflVm0+D+kcBQj7ZNMWNGKWWKbSx2IGi+Ntv3KdrSEcv0bf/2/s/6kDx6YgKYdtjs65ipAo4wBOZkCF6GeGUJikM+/gmFe/yCkl+VQi2mR/LvYZsNSVAJc2K8MsctYKJghNVa6y8pCF9u4kkF3OiTQH5++8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(136003)(366004)(39850400004)(346002)(54906003)(110136005)(6486002)(4326008)(6506007)(83380400001)(41300700001)(2906002)(86362001)(478600001)(7416002)(52116002)(36756003)(6666004)(38350700002)(26005)(2616005)(38100700002)(6512007)(66946007)(1076003)(66476007)(8936002)(44832011)(5660300002)(66556008)(186003)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E56MibVwWOwghkFwfdQhZjdhZwcZz0z5kmmvODRhlz/jpfzYag/bTc7Xn7XS?=
 =?us-ascii?Q?DQrEWv8uBu0T8F1lYHda8mAMH0u9BGW1EJCSJjwHFxFIl1GCVYlwcoSgkWiz?=
 =?us-ascii?Q?oDrypDCx5K0cjTN4li27LCzk/taZz+gfovvV0G4ljLZ+uv9UZOvFII89Uyj3?=
 =?us-ascii?Q?zjckXbTGnHZVNB9kEaKri3Tu1iuinvNO+UxGt/+SxGpD6VMz1NgzD2oajcNo?=
 =?us-ascii?Q?iOEIwkNruatJntbEW6lFxQgE9ht8C6TtzPfabUb/9/BKpyh7odNMwod2dwXI?=
 =?us-ascii?Q?EUAVKPhLsHF6TnueiRYJGG28p/fLfzIj0vA8nsHE3sl9L2XMjn6SFoawh1Q+?=
 =?us-ascii?Q?ammxUDT0p/0K14iv1Y9rzVKMi5N2liB3r+7g93/o8MV2kHJrfs8q+Py6cDh0?=
 =?us-ascii?Q?egYIgVhX+lIennNrqBIIQWMhmtardlzSXUhNgtVOv6e5QgkOebN4vZdgplfm?=
 =?us-ascii?Q?XFe0rEgliaFLim9oylHCqg67E/67wE1wPqd5VXvOHJxvYAD6A8IHC0KIivMl?=
 =?us-ascii?Q?6HaM2FSdv7sj/oej6zyu1xEmt97KEB4YtafAl/fZAGtsqgCu/exc7X4lWCps?=
 =?us-ascii?Q?ROo6AuROPMQ8t1IMHheOVusIeLjo3sccb9riy6Y8f1jIIw2G2II/4lkUQLw0?=
 =?us-ascii?Q?ggqbJF7nUgJEqzSlFYQ+d2tT7gnGxCFBm9ujPEmeUxEjUakV/cp1RGnSJfHz?=
 =?us-ascii?Q?MWg3igzvFD2bxQzbIyn7q6xKwAGuPOvIs+Y8jzZUjMe7Tj9rzsyOsAJlOZXR?=
 =?us-ascii?Q?PTwOGQ+7K+pTQPnz0U4cU10JuS24erZGL3PcFsVXtwMhr9BUB6oN0U0j1nkA?=
 =?us-ascii?Q?OUsjRlAqL79bz69zYYtItzaLnAw1fQiC9eD3cu4bIChDQXZWwowJk5AH6n4K?=
 =?us-ascii?Q?s0q5H8jQwtDt8HzPlRXCMheXlKmfghlR3jiE7cMTgfyCW6c170mTa2/Mfugn?=
 =?us-ascii?Q?zQyb1oPhOA194Ackrrc8fgGdNaHTQhf993PAqywPeNhuwWQPwYkyppYkYeRA?=
 =?us-ascii?Q?phPTKEMHUbeBdNWZFpQU/Sl3XPIQnjjk7QCDHaC4oCM0ETV8V/SWhY0i5/Hq?=
 =?us-ascii?Q?8YkZNeyukowAqoq+xkhEcheoiZ8BwiPz0hrcSgTH/VT5XvJHbd0DeX0GATOW?=
 =?us-ascii?Q?cmmNHusa8wflmmLhy94ksd6ZZhKua6zZMYKpi794peang/wV5viDkKvQ93xk?=
 =?us-ascii?Q?5Q+6O3C+z4mFSu0v9wValB++TntkFEv3zlvUZyFGaHY4g0lF/xQSniYJVdNy?=
 =?us-ascii?Q?j4uYlSJtYz8zmSOhmbUk30qjgzYpD0ByKybL86xhvAo89z92nx1SthjmEBg8?=
 =?us-ascii?Q?mN82VxAn4jVvWwDfHt/EM0irXP2bggshQEc1EiU8efE1bUoNzSSzO7IzhZwo?=
 =?us-ascii?Q?Bx4MS7S758lD2jTRSQDj7GsKaZ1lrnd/h2xmNOCvrh9HOfKYpKjHixIruQ/t?=
 =?us-ascii?Q?bOoFdQMkVFJIbM6/xIOpWFgS7nRc/4MdukBIoT+z3Bvw42VKmwLxQOq7vr2E?=
 =?us-ascii?Q?EdBWgjwo5rWtEE+l4KNZ3ZePRu/7rSc1Lg6AMMW4ZO4HXKvGxK7NrC5Nma01?=
 =?us-ascii?Q?VBvXGuowplGvv/FolMEpmhd2jNXPGJtYdPG976OST/seBrCqknP7ogA8oPHc?=
 =?us-ascii?Q?uA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7b585de-f0ce-48c6-6261-08da6e539e99
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:37:45.0102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ezb2nrrt4A9UFVAXidxpFxy7wQhQfW9YkccMOgs8ra4c+xX0eHdUGBzLXNqqYmFthik/iWwIDhquJWJMLlEwgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4394
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As discussed in commit 73a21fa817f0 ("dpaa_eth: support all modes with
rate adapting PHYs"), we must add a workaround for Aquantia phys with
in-tree support in order to keep 1G support working. Update this
workaround for the AQR113C phy found on revision C LS1046ARDB boards.

Fixes: 12cf1b89a668 ("net: phy: Add support for AQR113C EPHY")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---
In a previous version of this commit, I referred to an AQR115, however
on further inspection this appears to be an AQR113C. Confusingly, the
higher-numbered phys support lower data rates.

(no changes since v1)

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index f643009cac5f..0a180d17121c 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2916,6 +2916,7 @@ static void dpaa_adjust_link(struct net_device *net_dev)
 
 /* The Aquantia PHYs are capable of performing rate adaptation */
 #define PHY_VEND_AQUANTIA	0x03a1b400
+#define PHY_VEND_AQUANTIA2	0x31c31c00
 
 static int dpaa_phy_init(struct net_device *net_dev)
 {
@@ -2923,6 +2924,7 @@ static int dpaa_phy_init(struct net_device *net_dev)
 	struct mac_device *mac_dev;
 	struct phy_device *phy_dev;
 	struct dpaa_priv *priv;
+	u32 phy_vendor;
 
 	priv = netdev_priv(net_dev);
 	mac_dev = priv->mac_dev;
@@ -2935,9 +2937,11 @@ static int dpaa_phy_init(struct net_device *net_dev)
 		return -ENODEV;
 	}
 
+	phy_vendor = phy_dev->drv->phy_id & GENMASK(31, 10);
 	/* Unless the PHY is capable of rate adaptation */
 	if (mac_dev->phy_if != PHY_INTERFACE_MODE_XGMII ||
-	    ((phy_dev->drv->phy_id & GENMASK(31, 10)) != PHY_VEND_AQUANTIA)) {
+	    (phy_vendor != PHY_VEND_AQUANTIA &&
+	     phy_vendor != PHY_VEND_AQUANTIA2)) {
 		/* remove any features not supported by the controller */
 		ethtool_convert_legacy_u32_to_link_mode(mask,
 							mac_dev->if_support);
-- 
2.35.1.1320.gc452695387.dirty

