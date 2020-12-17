Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E499F2DCAC0
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgLQCAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:00:33 -0500
Received: from mail-am6eur05on2074.outbound.protection.outlook.com ([40.107.22.74]:61436
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727246AbgLQCA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 21:00:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hz7ENiCVJbEmWWVkgZ/fZWUGBA6oR8Ru1vmrepCACQrTWG0gmlbE5QIKiBXzaVHq4ZdjnKyUFcoZV5u22dHeuZzHNR8kUblCg+anEV1JWtu7FuLmQ2k2l9hYpMzAkxoA99banhoD8oepstqvhDJKF9jNfVs2CDZS9n0SkvaR61d2QDVUCGDx9ppsZ4KpXOS8qlvAVrJswMMRTet1y07ggAb5oIh36V5JrvQKjJUQ5AmAbeWI580+D/Dninq8NFVTRjHLhsZlTG4P8RPXGXZX+If9yuu50UDZ7ARZNOK/b/QTkh/FmxnvukLDP7RKZWikzbfhuLU2TXp1tRAK0+ntIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGLVzAGIGCBVP6Kf9H7Ni/JempNH+qGzEvDEnxDVbbM=;
 b=bU7jw947aMsfEAJLzGgMXERof9lrJgDg/mviymfFyK+ZSZ4ihlW7RVFleQvBxi/TWLaSiVodn55JadMbGR6KADgocItnTxYiF5KfrZtWI5jkcHK+7j/Q8T9ulHlYjQV4CNyZTXUvThEzpII3CnMlfhlWFS5y4aN04cCxKXAm3YQD5zuU05Bx0nuR1Rav6Zr48co530WF2BGmNvp+GlMr+sUK2z7yN57419SAHWWAi/6qeFMkIDhscsEFIyL9DY3Jj58jZfsHDDW/ox2hzqbDx1NLVz31pvfe8jb5FpnN8vo4vtxOzT+J05TQsI8QXVGYHKJxoIu7fIecDzu5Z4Pfjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGLVzAGIGCBVP6Kf9H7Ni/JempNH+qGzEvDEnxDVbbM=;
 b=Vn1TVhW2QKRpopaOlUTiGsUVlGlJ+glITkRcYvjLYKhTRSW7m367PUMNWR5Yv/jmpE5d4dHVJ7H9w7fLbcjs663dWsAQjnaLePWZY8FxTORvGE7IvQKmryGUSpjR+zD2c4IbPNIN3I5adJxH4lR/y6zoioNF2QJO04lMa1Y/ZPI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6943.eurprd04.prod.outlook.com (2603:10a6:803:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Thu, 17 Dec
 2020 01:59:04 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 01:59:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [RFC PATCH net-next 2/9] net: switchdev: delete switchdev_port_obj_add_now
Date:   Thu, 17 Dec 2020 03:58:15 +0200
Message-Id: <20201217015822.826304-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201217015822.826304-1-vladimir.oltean@nxp.com>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VE1PR08CA0028.eurprd08.prod.outlook.com
 (2603:10a6:803:104::41) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VE1PR08CA0028.eurprd08.prod.outlook.com (2603:10a6:803:104::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 01:59:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a3095351-3d81-46c4-a077-08d8a22f54d8
X-MS-TrafficTypeDiagnostic: VI1PR04MB6943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6943109EB93085E5E52A3EDCE0C40@VI1PR04MB6943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0eNTbWUjiIxGCDC1c6HHHzy1d9HqpJ1o0aTqpKrUz2OYMdl4SmGeZEZXIs3cMsXWNjrG/F/aI+IZ71pcedymUyOiBI2M2UEJeIHURXqLyXqMmvpX1tED7khxVAvzk6hJCeCBD1NrHzhwMvvloEufxKJR05FumMta80NKmqEoYNCT1bSBP+1JoB695lhNhN2XBW7AAL89JonST1Gvszb/PghCiBPOW3ZENW2+Zm5uWE8xrYRpf41tH58MYzKl7RkbSePPMEv7yCgmhCvF7VpkCDrl0f1b3paqtazhP/Df56S8FmaRqfDeVr3BSidxCTXWT2bYyyGO/xNKcoFfgBwItrDVXjAU3+q9w8ogWqA00IqjnbdQtonUhW0hmwY2yQBA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39850400004)(396003)(6666004)(6506007)(16526019)(478600001)(956004)(2616005)(26005)(7416002)(83380400001)(36756003)(66476007)(66556008)(110136005)(86362001)(1076003)(5660300002)(66946007)(316002)(186003)(52116002)(6486002)(54906003)(69590400008)(6512007)(44832011)(2906002)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7uR8jfxix0Mt2Wlgy2Iud0SSd/r1oWlQTvP/OzyA1XKWfmrPOBau8MW+S4cN?=
 =?us-ascii?Q?WW/6NAiZriFaxmi+FwUdLpBPQK6XbACiaSveepoHYiONkv+qam2zuPSjKxQu?=
 =?us-ascii?Q?dSz8X3CHXS/2ysJUy1KBnoRsbgfcScUQFY5ulCLmO86eqAubrgqwrd5R+QaW?=
 =?us-ascii?Q?DZWafY9zaP0xawa3WVfO2YnbPoA3KChsJJrNwFhDOObIAxY9SvGZ/xV+HqUy?=
 =?us-ascii?Q?cP5kv7k6iZr83h0+j4LjQdu+Bqu4SLr3ci+HzCPnC7rmISEC3O4YtDPxHr+Q?=
 =?us-ascii?Q?zVLRB6PyTTJMT4fLjrber9ayM0F0c5df40jr0yND/VXeV4i75iZSHN9mjsZK?=
 =?us-ascii?Q?pkPY3b7wQckopp1KYMTBalZ5rZI+K91oc0qrA8FiIfwxAxcyqaV867W23UiV?=
 =?us-ascii?Q?wI4QWy+1mH1BtQI1zB37+G611x2wcBFfF+BgW1l9uh182HCyQVeaixXwSxWX?=
 =?us-ascii?Q?d6fvGxxAVXRyg9t5quiyYmWwbJl9o7ZXvOz4t30ebPJO3vyiib40Bz4RGI9l?=
 =?us-ascii?Q?zgiUpsQgIOxghKbbkkLLZAdXCCWV7bucqmai1B40SbOO2RafiJfVLaD1OWaI?=
 =?us-ascii?Q?5jitOFbVW3LCHKZX5wE6zwZuhL4d8MVgNjNP7NjalRBh1Oi+UXE7dfThPq4J?=
 =?us-ascii?Q?PZ4MSxmeSDtWe1+u+htqPFQ2mLifvfgAszq1jGr7+7su1Y1jy9gV3mmkP69j?=
 =?us-ascii?Q?cM4jJ9k4wzjnLHqTynT3hViCCDX/856G9HfNlV7LSiE38nZilA0JyCafh+kR?=
 =?us-ascii?Q?DrB9M/SeMRspaM2smLDUbDtv0H5upN38MVsr7Wkjtkg4JwACvWPXMuCGIgF6?=
 =?us-ascii?Q?Hx4I/xTO/mmjx1mqoIm7aTxEaszgUVdXn1JgHKCA0bywVR+Oq3IWkDzIfLZG?=
 =?us-ascii?Q?J0w1mEYyB1jEmh3UjZ3pyhwHPfmDte/+Fl1kr672T0+vtvLHCninm1gdMQKn?=
 =?us-ascii?Q?CLESoX9bmk2Pr9upjJIIsQI0tzeQ0NQ9lEkv6mIlMp3Go1A6u8TPVTb77CSO?=
 =?us-ascii?Q?dP4J?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 01:59:04.2141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: a3095351-3d81-46c4-a077-08d8a22f54d8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wD1Ge37xKNTEc/8m0pe/3+Oc2f/77svcv10p+FP9PnRq7yWopwYkMiQnvaDVHZ0D1pbpXSsdw/LnPtvWHZaKFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the removal of the transactional model inside
switchdev_port_obj_add_now, it has no added value and we can just call
switchdev_port_obj_notify directly, bypassing this function. Let's
delete it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/switchdev/switchdev.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index a575bb33ee6c..3509d362056d 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -242,23 +242,15 @@ static int switchdev_port_obj_notify(enum switchdev_notifier_type nt,
 	return 0;
 }
 
-static int switchdev_port_obj_add_now(struct net_device *dev,
-				      const struct switchdev_obj *obj,
-				      struct netlink_ext_ack *extack)
-{
-	ASSERT_RTNL();
-
-	return switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
-					 dev, obj, extack);
-}
-
 static void switchdev_port_obj_add_deferred(struct net_device *dev,
 					    const void *data)
 {
 	const struct switchdev_obj *obj = data;
 	int err;
 
-	err = switchdev_port_obj_add_now(dev, obj, NULL);
+	ASSERT_RTNL();
+	err = switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
+					dev, obj, NULL);
 	if (err && err != -EOPNOTSUPP)
 		netdev_err(dev, "failed (err=%d) to add object (id=%d)\n",
 			   err, obj->id);
@@ -290,7 +282,8 @@ int switchdev_port_obj_add(struct net_device *dev,
 	if (obj->flags & SWITCHDEV_F_DEFER)
 		return switchdev_port_obj_add_defer(dev, obj);
 	ASSERT_RTNL();
-	return switchdev_port_obj_add_now(dev, obj, extack);
+	return switchdev_port_obj_notify(SWITCHDEV_PORT_OBJ_ADD,
+					 dev, obj, extack);
 }
 EXPORT_SYMBOL_GPL(switchdev_port_obj_add);
 
-- 
2.25.1

