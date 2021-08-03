Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E573DF66D
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 22:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhHCUeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 16:34:44 -0400
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:60396
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229800AbhHCUek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 16:34:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfnaX0ozGZbMp2BoVCrZ8whuuT3brrkRpc6m1ztNKh/E6ZonqgziH9+zcTGWJtaYl1+DWi7KKEFEmS+zrqcK1nISiF0r3ezeJx6hnQqN/A2BOnzhtAfGPvW07FrbH5CIxVhS4elo9mK5mmstUBc0oAv9szkTlmX+6Pi0XYUEHWjgni3M2O96FdgQIWvUddQWuW30QBJyTmbFRMgg3GyW6Be4SW0Q53tB5Eg2Yw1PAz2HyCv7Bc2YfTnbvfxatGkw7wcZxR6WeknPrC91HXp4brY57LF9wR72fQxngCJDN65Zo9bEemck3eH7vd8O/DteJfbD2WW5hd3ImsESiZR2aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSEdaH4cuHRWJsWtf+PMBbdHlrGh/IhGMYCeF1k9rUo=;
 b=h2P5GxSst59eBxCJg+Q9CAl2CHzF3BlKLFatw0ZDXmDceAemv3MhkliehHrwm3NVQFfq6ctJZGyQsA4ygheqtn2U24AVi5z/eE+jesROtvj8KAnGAonAEDfGXi4/dZyJsQmEDS/xUDo6ZTQtSn+gOtqm2Mwiyoosc7utawXneutYqQXTyvqSDKV+FLBmYxzqb4OC8BOxbW27BjdSuqMzlbGlFCn6fr28vZ54E10znQS223XBLz1PHEz7aj1cDYT+zKvX3gicrtsBGpl3UjeHYciVvVPQ+AglpMjUhk0divONoyMl78SLtkkfp3/xEbYZN/8lZ4MAIGh1A8awdh0XJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSEdaH4cuHRWJsWtf+PMBbdHlrGh/IhGMYCeF1k9rUo=;
 b=O29udEaQ2dYjB398BcmZv8pLYqiCGhczvvDT+9/Yc5VsKApDbmuhNRjXk1IR31YkdwAlbSmJEmFzOwMxKEGgXIsQyIT++/jXgM+r3F1gtmzmLoUzVbzzpz/C8u8mheOvpXd90z63rnm7zlZEnnn/9eNEnImC1x/XloPQ49HLh3k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB6465.eurprd04.prod.outlook.com (2603:10a6:208:16e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Tue, 3 Aug
 2021 20:34:26 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62%5]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 20:34:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH v2 net-next 2/2] Revert "net: build all switchdev drivers as modules when the bridge is a module"
Date:   Tue,  3 Aug 2021 23:34:09 +0300
Message-Id: <20210803203409.1274807-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803203409.1274807-1-vladimir.oltean@nxp.com>
References: <20210803203409.1274807-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0013.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::18) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM8P251CA0013.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19 via Frontend Transport; Tue, 3 Aug 2021 20:34:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51f0e4bf-5d28-44cb-7d9a-08d956be15da
X-MS-TrafficTypeDiagnostic: AM0PR04MB6465:
X-Microsoft-Antispam-PRVS: <AM0PR04MB6465C458F43B1C4862530313E0F09@AM0PR04MB6465.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:238;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RU8RcRYvyXk+Ij2Q07PIZySyEJ2rCrZhzb/s5IA6kGfvpC0O61Im5Ku3YP06LamxnAbEoiQzBf2nxY5VFD0kHkoossEYlMDgThxtVskJGp0VIkerGDx4WJ+1FVexdfvbz4amQOgNTLkit8dMr5ciuDdgDjsXPZSNh4nuRZzl1IO6BnIxfhWps42onxC2tY890yNU7bb7Rc7Zl0QgvI0XguFX+ia77Ul+TuTCqYyyRdiDcilhLdQZf83FCccZPLR4yE7nAbn1X4du9KOG4j+XErXrGKdwwuI4fFQzsX0V8Efuruuru4upFcYDfLFuTXt7X+O2ypxeeJ2xZ9PTyG8DrF4KiJQfenoIB/FTgDwm9Gxqdkko5lQsDNG1D5EgO2IL809LbXabhV9MNd9fUYvk4ftfjCyOIMMdpRx9sLZRTV1qsqC+Lf0PYSzSrA0/astj0/TPBY277lZHdIqI6cst7+wGm7ke7s3i9bhVhT1oA03rE0lxZzLe1kzUEJsRgOh5gffHQ7lIIxnfwSbZkXmq9oa8PSk7xUPk+71wivvp3xNf3vn7sR+LLFZZ4JVruZoGt4eakvwsTFzduI3U/81ODGWgaHr7B52J6/NoErIRke4cIOO8gpwpvGeGygfxQcnznWIlOoW4SjkkeJLCgZsOwEkBzIq8O6OAKldCanpl126XXsRegfKbi+JwujIMfAevnAhSYd5qjcS0UJB5U3fPmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(366004)(396003)(376002)(136003)(44832011)(956004)(83380400001)(66556008)(1076003)(8936002)(6506007)(52116002)(186003)(110136005)(54906003)(2616005)(7416002)(478600001)(8676002)(5660300002)(26005)(66476007)(6512007)(38350700002)(6666004)(6486002)(4326008)(2906002)(86362001)(316002)(66946007)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ggaN0fKzb/vDLuc+/9JhIOVmBeu3OEQ3S7x+GImP6Te/HtdWicor6X2HSFfq?=
 =?us-ascii?Q?e4eP8r8ooc3C6MB3SHB3qq0sFQODzlZR65iTg4DqMBYcbTE96sC5oZOdv4tA?=
 =?us-ascii?Q?Ope3ROWBImK5n8Bc5cd9LC0qwcWpt1RuZa2BoiSTKnXX0MwbHALxXSJZn7qU?=
 =?us-ascii?Q?ihQRaCUjnqEFt/xbZ0QvN//NP505ZtyifGAzXeCmnNOOwXjObojHZT/fxrJ6?=
 =?us-ascii?Q?aw04kJa5bx4jsWz9762Jy7GDZWxQjolkMs6yYGrTJMWwXwVmt75fpPHo9iKZ?=
 =?us-ascii?Q?lpTCHNIoq+ChCDHoKC6KS1RY0kTVmy9ekm4mAKViv8AjWRZvoFOVuMyHLXiY?=
 =?us-ascii?Q?dDEF8p1NELanshSMaYp6qx91cUYoQ0UEOdnSfSFmYqIzEPiOEQskuyTn6JIH?=
 =?us-ascii?Q?/sTywHjhxBAyhyZjY2ucBeAT07+Wo4Xx65FK+9k76E5gDfvLNs2Nkd8PXB3H?=
 =?us-ascii?Q?rWbgrueY5bgWULTSkGE9INKZ1RSsYajsXHzFkVWz56YK1GSH0Wh+IB4WK9Nw?=
 =?us-ascii?Q?BR2I+YTXrD3IU9QOD0vI/abdta0CCi3Ov/ueiAATRe37lEGiKovH3LPy9Gka?=
 =?us-ascii?Q?UeVKhS6q/WsL9lS8IkwGRl80m0r72xd+7QpUoKQ6bCsVDEEYbEzFKQ/2KWKe?=
 =?us-ascii?Q?t2buBf76gm8pZ0xzEtCCVb1CPzdSAlxgRQdk3k1Jio/wGJN+XTlXKUJYMZcJ?=
 =?us-ascii?Q?PthiR5K6wcAzj1IvbJ0V75yx1yUOxYgYilk9Parfq/ZIDUoTgxIUsi0ZQKn5?=
 =?us-ascii?Q?dhxAo/2OJ3WzEUJNnqmnEATRShK6tRqxqfFlXAKyzgHcR9Up4d4VM8U98sjo?=
 =?us-ascii?Q?chKwXuUMHpYl86ztph3nBEGsv4TfpM49IOlKEyGtmTVkQ1M37hsat6IArWH5?=
 =?us-ascii?Q?fd0wQN0ZvvgvK/NoO9Hd6io+YaEh1BPAibKxk9FZH3+O7PHy3FC7xWwjNyRg?=
 =?us-ascii?Q?cuTfbWAPLJiJJGJL+yJKTmji5ZN8XdFVeGiZplAMdLlf8YY7KLRZBYAgCWVK?=
 =?us-ascii?Q?48xbcRi6cXrTWaee4YMHmriNoDjy9B4BVf0Af9y42hYGkTIMMegb457Jgq+r?=
 =?us-ascii?Q?k4JAY7M/KYJ97G3q+kwghjj/20yA8zT3mge2Q3V3QVivVHib9XJhuXMEUBwg?=
 =?us-ascii?Q?Q7Mrldyh/IYdHMtTLGq+wtFRa4SwPsBgVE7nQugayMsZ/o2mp9yUXsMoOVFX?=
 =?us-ascii?Q?DHkKnwCBrouLzGjttPZ3ShkmZHgLk5mnaSErNfpPBvh/2fgBLJCR/G2LeEJl?=
 =?us-ascii?Q?fIUBUZZfTjJTpUBUhu0fTd9eNGeUfps5pY1a3Gz6Lzo6Si1B3y2igP/8xqFO?=
 =?us-ascii?Q?KWc1xrLgSC6KpeBs4pj8uwAL?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f0e4bf-5d28-44cb-7d9a-08d956be15da
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 20:34:26.2290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2mqtE/TBvrNaKPJ2ADWnMShCrVeIEoe+wrcIJFUm6ILKjw5555ZKBiVs94J/tm0Z7YXfP4WzvcPu5gwpJtdurg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6465
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit b0e81817629a496854ff1799f6cbd89597db65fd. Explicit
driver dependency on the bridge is no longer needed since
switchdev_bridge_port_{,un}offload() is no longer implemented by the
bridge driver but by switchdev.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
v1->v2: none

 drivers/net/ethernet/microchip/sparx5/Kconfig | 1 -
 drivers/net/ethernet/ti/Kconfig               | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/Kconfig b/drivers/net/ethernet/microchip/sparx5/Kconfig
index d39ae2a6fb49..7bdbb2d09a14 100644
--- a/drivers/net/ethernet/microchip/sparx5/Kconfig
+++ b/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -1,6 +1,5 @@
 config SPARX5_SWITCH
 	tristate "Sparx5 switch driver"
-	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
 	depends on HAS_IOMEM
 	depends on OF
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 7ac8e5ecbe97..affcf92cd3aa 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -64,7 +64,6 @@ config TI_CPSW
 config TI_CPSW_SWITCHDEV
 	tristate "TI CPSW Switch Support with switchdev"
 	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
-	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
 	depends on TI_CPTS || !TI_CPTS
 	select PAGE_POOL
@@ -110,7 +109,6 @@ config TI_K3_AM65_CPSW_NUSS
 config TI_K3_AM65_CPSW_SWITCHDEV
 	bool "TI K3 AM654x/J721E CPSW Switch mode support"
 	depends on TI_K3_AM65_CPSW_NUSS
-	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
 	help
 	 This enables switchdev support for TI K3 CPSWxG Ethernet
-- 
2.25.1

