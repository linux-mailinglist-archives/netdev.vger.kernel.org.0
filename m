Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4806E58B5F4
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 16:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbiHFOMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 10:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiHFOMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 10:12:02 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E10412082;
        Sat,  6 Aug 2022 07:11:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZcqzgq2xE6snLAQgWMrf2NOHJ0nQJDx42e32h56vZQKnXd6CvV/ipP9n8ljJyKrPcQ5g17NQhrT2+alRNmDdvVbUIyGVVFUAqQx2HSUW2jH16U48/efXjG4lWEaMyGQGJLYJidgLi3jk4KitW5Ka3RpS1/GgFB/GUQaaheDSJrjqZndOBcCsmaqIR9MaWg51D0I0AeVgQT1PU93IeNs3BJrDdJtOzlwRPnvrp5saBG7MJx1TQkkTmx5IUT4XBbEP+NtywoqeALGWjuYUK0tJMgef8pEvTcGJAXvu6+rhJZTdNWjQxaqMBtVKqOsC5rVi7kbENftrD/fQno+8tnIFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MOaTerI7qocPUhUSUkcP8OhrT5LH6S5X89g3peRpI8=;
 b=Q8764W/4RSQ9/jVxiNifWHY3InKhTpdwm2i0/1Vt4NJ/a+PlxF5PezVaeTC5bSQjRHA7VPfJroiaQ+/iNSocfK5ME6RH7MtomtlNUNfT2M1ajHNnLCRf06fJIrM1QEa6U4AsUWNJ5s7hCnnGARXuv+dqVw5M3QRRJxHSGONIZoIHdDlDBM110LsWR8jV+QjilPDXRCNV6/mVIl5MngSqPWMkPVQ83MCCCO+iO9Nbf2d6wV+WHOM7GepI33w5nvVLupOlfGsYY4tP7ZavsD7b5IU/nNTlrUFMUyRY/OcvBxC1RZh0VbgWWXyo9uIvK/d0lBhzdLSiPFubU9//Ujx3Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/MOaTerI7qocPUhUSUkcP8OhrT5LH6S5X89g3peRpI8=;
 b=VaxEzIWRRBPOmAw5RVFC1XuMnxjf8Yb/KdYaAuwM8W7dzPvyBihenBnO0RV62+o/pVEiZYCb2O4xMMTYDyT8DFOhiapiu/TUzqRCLCDdztjIyZvTYygZkcr53/PkqZ7Tt+ef1To2luxKh+IB/oMRhvjYTCujDFXATvI9Yrdn9UM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6988.eurprd04.prod.outlook.com (2603:10a6:10:117::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Sat, 6 Aug
 2022 14:11:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5504.017; Sat, 6 Aug 2022
 14:11:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, Marek Vasut <marex@denx.de>,
        linux-renesas-soc@vger.kernel.org
Subject: [RFC PATCH v3 net-next 09/10] net: dsa: rename dsa_port_link_{,un}register_of
Date:   Sat,  6 Aug 2022 17:10:58 +0300
Message-Id: <20220806141059.2498226-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0016.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3139638-854b-4a37-4037-08da77b59a00
X-MS-TrafficTypeDiagnostic: DB8PR04MB6988:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MMMyMZ4gBbOewKNm8bsRWp/eO6M3IxOW2gmuMYpMTROn3H5msTqKWHzq9vWju3eGYO3DPOy3kaRRpPkr58qsggJpDCEJmGTTV8PqpY2GCOp8PfQJzv8VWLM7U3kY3N40bhLl+YqlX0kbThIw4koTELB3OMp/4fGeNOV8YxwfD6PvIdUdp6uNS/O15s14TsRxAa4Xt2NVgZfsIjxmL4Y0IRTw4Jh1mAv1Id1T+3K7rjKqMYWQpMVKsi7H1t0JHX0mNalQIWqf+HsprfsqpR2ttdr48NWQ50Rs371DuVzpnO3qwqwFN2KWHsbw9dzNwG+1E8oRUcXyqY7Ba2nIOVUYTNj3na4fFGMJ3EWcll7W0n8ro/7/uOh35rRCfTuqtbgECZ+ylh5HCWzMGmFYj17zMZ2sS/gr3pdJNMyCTkD+dggk5/4KhVwzKC9Uh9QjonYlzFfqG6UuJQ8NXw3QO5HZ/iciT+iFl7uuOk07uO2kaqWdtlVDG11/xITcrctQDi0M3CLzTNrjLX6uA86QiQ39JQYloxAWPeQz2/xbW0WSNiu9W13X8UM8lTbOEXCQAOrh5wIBaS4+7tU0fgOBY5J1WKZxnJ5RS/TUshZFJXxoh8h1VssOub9tXrCoPBoxfa3W8GPS46NiVW3YkTlh+V7fDISy3PV8nH3JQntLtrwxJ4waGNmrx83wf74dI+9ar0j84fr20pAFciST8Ah+dKroVV1VZEjGKWyoQ5U1UcYp6Oh7XtDKo5f832KW8zWObk/euuDkB+bdshy+9Qc96fax/mCpk2dm7/qG2SCvGXzwer4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(5660300002)(44832011)(7416002)(7406005)(186003)(1076003)(2616005)(38100700002)(38350700002)(83380400001)(6666004)(52116002)(6486002)(41300700001)(316002)(36756003)(6916009)(54906003)(6506007)(26005)(6512007)(66946007)(66556008)(66476007)(4326008)(8676002)(8936002)(478600001)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RcjXVd2plhgNBegFUZdkVwX0PViQnloSXYeJ/J1hAeCgWTWGe5uyXd8x//YB?=
 =?us-ascii?Q?4U3GMoPSUytd002NY2ZNtjQq3Qx6zVrbaLOgKx8wPwkjlYTK+sCB9yEAicS1?=
 =?us-ascii?Q?H4E5i9do6ui8UFxWUQshGtfqkOJeR0sdHleUfSGUSClrh1ExaSVFxOyBQWkv?=
 =?us-ascii?Q?fXrO1a3jeuYLh5MHNjfErpK6C2Hq4bijjYBO3igNRbVU456gKUUvrjBUFr1r?=
 =?us-ascii?Q?QvGRiX8vSCrUmCDxa4Y+/WweiMFNcBqokGU6Pkgg6tkLkCwJLNniA5ZEgx6S?=
 =?us-ascii?Q?UfhOPP3VKVEIAG0ggjymFC+ZMHRNfqLnS6ThXwUORQ/RkjwQHA+MdE5KYEQM?=
 =?us-ascii?Q?hHP4lx5GGqMdZqNgJAvBHU2P9AFDSHKmw8Vs2BqkS056rjc8ic67f7bfBd3y?=
 =?us-ascii?Q?052PZHrtTKeUT3bawWOf8VhNMqrWw7e0CJ0cZ9wP/Q2d4gnrtglkHAxN1y08?=
 =?us-ascii?Q?kw5FB88QFElBX9YkIM3BNoe1F7FeQ1INgYWqYA+y+88rWrwJV+z4TtayG3nt?=
 =?us-ascii?Q?wGQW29fbdK34SQ1I+QccwD8xvmk1bEeLjwwgzECSCi9E6Vzoi8AEsqzQKZv9?=
 =?us-ascii?Q?o7/B+78FBU52ELt00rLhJoZZXEyU0wt6JBYrI710XLUuDMVAx64AtOXyOMvg?=
 =?us-ascii?Q?IqIBmrurxj+UBFfqVb4mzxT8bkRswQbxaJEz8WUxsFe70VnsQv0jwChQ0JbJ?=
 =?us-ascii?Q?RODIumF90eyjXCEWE979XGfgSfsugI18e5ctucYkxWVoWyGNWrdYirow6HEm?=
 =?us-ascii?Q?snc3oyi5IwFA+i8P5JI5d69zSj4G22Ne9XQYrQMpmMyTlo5X9Ta7yirhvume?=
 =?us-ascii?Q?fI/jnmPS3Kgfuzw2h6dG9oaBIJ7ZPYkDQ69gPOKOenytiidlkU2QNlz7KMNw?=
 =?us-ascii?Q?4sLfMexYcMTTMBL57e44qLnsfNl+gJBhHQUzSsEf2n2/jJrjjdakdDG2TGxS?=
 =?us-ascii?Q?FsH3hA6HY9F9E3i9d8vNIXGNyX3YcxcfsOy9M/l6AWnEHNGbGHisc+lSK6rJ?=
 =?us-ascii?Q?XvNDbVirCEzTMVZGjkWhSmYXkV/2fumC3ChKi0J3Vqw+sdEtrPmZs8Sf5wdp?=
 =?us-ascii?Q?D5z6ipWRpRpVF9Rb+owfOHXvuQTgyhs0wEmK/7rgSuMi+gjT0UA9Qlb4zmmS?=
 =?us-ascii?Q?W3AvWG5infukABXtW4T3WfGqx/P0SGHwHfyVnRfUxUlGXMbJwcAwU6OfsaPa?=
 =?us-ascii?Q?CC8hH3ll7NItCnorC8nw9g3IYC0zUxdzZBD2C6i+2VQ3ZcBBs8EKoZd37Ab7?=
 =?us-ascii?Q?zXVe5IAI26yUW5r1FMTSGoRADRN/QXm5Etv0I7xDs+qYTIAv0mukrhhGZ8hO?=
 =?us-ascii?Q?c8z39AhC02MhMLuYhEMHiLvLs2hACNuOV3JApizzI01NxtPhxMmB1Hg++K14?=
 =?us-ascii?Q?1Cz5+gVI3vZZis7hIoKZUN+bibI1AeJ478gNHJRRINMDIFmw2leFSf0kwKQL?=
 =?us-ascii?Q?3zD/RpDzIOijhvSWCFEgn+WJRsSwkgiKf9ZZG8o2pDKuPrOk+w64SdE01s3W?=
 =?us-ascii?Q?vnWYbVZ5oJ5jz0CSlQaNJXgkiKNN46TyKWsPfMaH0m/ZVUynotmbkzgCKQQ9?=
 =?us-ascii?Q?zfGbmLFeyJBFxLYasT7Xno7AGtl58ZiDGWYr6uhBJ75PBaVDzzQnN7YBu/jM?=
 =?us-ascii?Q?aA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3139638-854b-4a37-4037-08da77b59a00
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 14:11:48.6277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1TGglyAB9jdGw7N9G4wKyuSCPTXUjMlU+m4t4yIIkKdqBgShupBbTRHBXTnqtPvePNGTi/DKpUDbhUTRKZqtVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6988
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a subset of functions that applies only to shared (DSA and CPU)
ports, yet this is difficult to comprehend by looking at their code alone.
These are dsa_port_link_register_of(), dsa_port_link_unregister_of(),
and the functions that only these 2 call.

Rename this class of functions to dsa_shared_port_* to make this fact
more evident, even if this goes against the apparent convention that
function names in port.c must start with dsa_port_.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new
v2->v3: none

 net/dsa/dsa2.c     | 10 +++++-----
 net/dsa/dsa_priv.h |  4 ++--
 net/dsa/port.c     | 18 +++++++++---------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 12479707bf96..055a6d1d4372 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -470,7 +470,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_CPU:
 		if (dp->dn) {
-			err = dsa_port_link_register_of(dp);
+			err = dsa_shared_port_link_register_of(dp);
 			if (err)
 				break;
 			dsa_port_link_registered = true;
@@ -488,7 +488,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_DSA:
 		if (dp->dn) {
-			err = dsa_port_link_register_of(dp);
+			err = dsa_shared_port_link_register_of(dp);
 			if (err)
 				break;
 			dsa_port_link_registered = true;
@@ -517,7 +517,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (err && dsa_port_enabled)
 		dsa_port_disable(dp);
 	if (err && dsa_port_link_registered)
-		dsa_port_link_unregister_of(dp);
+		dsa_shared_port_link_unregister_of(dp);
 	if (err) {
 		if (ds->ops->port_teardown)
 			ds->ops->port_teardown(ds, dp->index);
@@ -590,12 +590,12 @@ static void dsa_port_teardown(struct dsa_port *dp)
 	case DSA_PORT_TYPE_CPU:
 		dsa_port_disable(dp);
 		if (dp->dn)
-			dsa_port_link_unregister_of(dp);
+			dsa_shared_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_DSA:
 		dsa_port_disable(dp);
 		if (dp->dn)
-			dsa_port_link_unregister_of(dp);
+			dsa_shared_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_USER:
 		if (dp->slave) {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d9722e49864b..8924366467e0 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -285,8 +285,8 @@ int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
 int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
 			       const struct switchdev_obj_ring_role_mrp *mrp);
 int dsa_port_phylink_create(struct dsa_port *dp);
-int dsa_port_link_register_of(struct dsa_port *dp);
-void dsa_port_link_unregister_of(struct dsa_port *dp);
+int dsa_shared_port_link_register_of(struct dsa_port *dp);
+void dsa_shared_port_link_unregister_of(struct dsa_port *dp);
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
 void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 2dd76eb1621c..4b6139bff217 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1552,7 +1552,7 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	return 0;
 }
 
-static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
+static int dsa_shared_port_setup_phy_of(struct dsa_port *dp, bool enable)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct phy_device *phydev;
@@ -1590,7 +1590,7 @@ static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
 	return err;
 }
 
-static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
+static int dsa_shared_port_fixed_link_register_of(struct dsa_port *dp)
 {
 	struct device_node *dn = dp->dn;
 	struct dsa_switch *ds = dp->ds;
@@ -1624,7 +1624,7 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 	return 0;
 }
 
-static int dsa_port_phylink_register(struct dsa_port *dp)
+static int dsa_shared_port_phylink_register(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct device_node *port_dn = dp->dn;
@@ -1650,7 +1650,7 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 	return err;
 }
 
-int dsa_port_link_register_of(struct dsa_port *dp)
+int dsa_shared_port_link_register_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct device_node *phy_np;
@@ -1663,7 +1663,7 @@ int dsa_port_link_register_of(struct dsa_port *dp)
 				ds->ops->phylink_mac_link_down(ds, port,
 					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
 			of_node_put(phy_np);
-			return dsa_port_phylink_register(dp);
+			return dsa_shared_port_phylink_register(dp);
 		}
 		of_node_put(phy_np);
 		return 0;
@@ -1673,12 +1673,12 @@ int dsa_port_link_register_of(struct dsa_port *dp)
 		 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
 
 	if (of_phy_is_fixed_link(dp->dn))
-		return dsa_port_fixed_link_register_of(dp);
+		return dsa_shared_port_fixed_link_register_of(dp);
 	else
-		return dsa_port_setup_phy_of(dp, true);
+		return dsa_shared_port_setup_phy_of(dp, true);
 }
 
-void dsa_port_link_unregister_of(struct dsa_port *dp)
+void dsa_shared_port_link_unregister_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 
@@ -1694,7 +1694,7 @@ void dsa_port_link_unregister_of(struct dsa_port *dp)
 	if (of_phy_is_fixed_link(dp->dn))
 		of_phy_deregister_fixed_link(dp->dn);
 	else
-		dsa_port_setup_phy_of(dp, false);
+		dsa_shared_port_setup_phy_of(dp, false);
 }
 
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr)
-- 
2.34.1

