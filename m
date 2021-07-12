Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE6E3C5F24
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235552AbhGLPZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:25 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:46304
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235528AbhGLPZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KW5ne6WN5ynBtOjVltMew4jPyK2Ot7kcGsL14orimlL/mjhwf2vqatrs0AGrok/vw4yZNtZAPTLEcoARJbrtpK+1o9mQlAKmBhyILVozqwDWJLiC6SmGXK+a20W3yKxoUj+VgBG22wHbuU4VkVV11OL5QSEUmYa4oT3C3ED6j+TH3zl/Z5tICRqnFQas4T8nRIXvKT5JJSv8jJqGcCQx7NSW07t2grQwFhBEWeENOi8umVrGl6eE1+AAfuqC3znCFEAcpFYrP5M6chxGSmRABfVlrg1q2WyXKv+2y/VIP4C+WvzT6xfZe2lTHpVdeS1ob/DFMfbG/Gmzeq/PkVRK+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJtISRQwqEYwY3zuU92Rf7AGd7DBy2+7is3NX6MZN+Y=;
 b=iz95a1DCTKLRURlFMSk5XAVFogzS/7WrnTqZ7hkLP/aJ5fEPl0jJcnucXnsxRaqqkxQZiFOgkDblkF5IXpxYrJPoExzLMX5phanmHTN9Vh9Y2k7uBuZTk7P04bCbBTaeSUgvhsDKIEpHz7xOLkrjkblWxpdL/kWdClgjVVe5+n0FzqxgujsrUj08yE1DX3Cv+4EdTyI9FKHcKt515nzqiwFNww7D1OTw9o6jBpsb6zamwbj1uZ8xHdhiLhTLk7FVyxk0lJzOPtqrwJOUvpbOSZeY/zisRndCzDrSLeFIy0AcLb5p1sbuNi57zUR2cS1D7MPgawj7qq44ASKemPifZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJtISRQwqEYwY3zuU92Rf7AGd7DBy2+7is3NX6MZN+Y=;
 b=VDha82fyW9ItugiiorcaikB8GIiyhI1HPsftUYfG/yYhXPzZDejWK7bXB9F8D5lcNeIvfTMiV2rTG37Eh9vkITkJwnnmWdzYLZQjrOu/lkgrPrwHSODI/qEjlZRmguqcuscnsNeDDRg8brVfXCWyG5rmq7dWht78LPJdkvnI60A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 11/24] net: mlxsw: guard against multiple switchdev obj replays on same bridge port
Date:   Mon, 12 Jul 2021 18:21:29 +0300
Message-Id: <20210712152142.800651-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93262c89-fb08-4edc-e87f-08d94548d86d
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6271148972F2EF59A3942896E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V5D7nrZaStc9TE6/Jv7GxugVE/WGWv3VlsSzb6J6nOtP0IRtpWzIm8DVyMtbOps42gYxzS4GtJu4AobRv/Z5Tf8euMhn6ny14Wt7P4GORjDV3UJ2jv3WQE5TVgT33mhWHTbWvoPw+ykk52uRZTxSywyxLHJKoTUxORhpSv8v1Xzkkcol1Wvpx44OD5tqY8a/Hc9q6eUUObDIjfBtAkNqlHuq3St6tEpqofWaeAe9PCQMJfWKUH4pun2wmgMAk/phr6KwjskmHOh40ueLzrE8EswYh42ldP+yHSCugTg6o+/cvWpiESrfeTQwkyTZV/QUyA9+LebT0vKGt8dG2NHqlUNksTPVAD0+b33qGZ34T21gR0Unfx59OeJrt3oxiyWsO/QnoXIWZm5Ws1JgEYogyMeKeDhtkgSa7nZK4QJj02cxU52chz/KJ+Eb2U3vy6IbE1D3h+QXHXeV/Wokmj3m7sSoZzM269lEKyz+xbV1J6KmUey6t7N45wAbx0q+UeuCDwQ5ncfxtEMlflRueWdF+orjgTGTMYCrj9k+comWoY6t6kinD2LS2JQlv7EhOYeqbLww7WSbA0NyktkVbo4ZaIQprqmPYLYXBfefsuS4fxvp9TuRTSHFnIqixCuj3O4P5TZKFsr4l4M/7iHd88YtADIKRQVqoKIhdjt6OjvF84s+JW8PxNWcBK+wO8NfCwIFWexVrIb2ePoC0uzLaapcrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(66556008)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E6GXu2ndgdVkeDGSptIv8nX62qcbaiUIC+Bf4ep385UvHh7VAg7n9izHkKDy?=
 =?us-ascii?Q?2uZunaz0fGE6sBJzktJCA8HrkfwoNSAwztEWH7k/j88ZwEzCzU+AyAzVv54A?=
 =?us-ascii?Q?qeLHU9n0+UiqSTdc05LOldEfHNG/+KWhKfhl0OeCe8WUKMlIwtQUYtTu5ye8?=
 =?us-ascii?Q?lkSzutHz7knT4X7n64vjR/lxuQo2/TEyx/KL0yvHJo5lRSbF9uMy06nkbZ5E?=
 =?us-ascii?Q?4fS+LJCWoP17XZEvBojENozWOt5Ldba6+g32/41m2GDIaIsWL6SZIZYcL1L4?=
 =?us-ascii?Q?0EJysf1BnxxjaBmC1Y8dMh89aZrQdPvEATtWET2tylXcWhCOLVwxc80AlEqL?=
 =?us-ascii?Q?K5Ijp/VPOByjWkDhyVt5BkziGZeNWlCNd7v4mHD3KPKm5iT9iMnTqv7wd3UQ?=
 =?us-ascii?Q?vy5tJQicB55Nx+PqyhiUvl8aqqWDW6x34xDeVfLj6CCxNFU1HBjpjSUdY/Zz?=
 =?us-ascii?Q?UTwETfssw+XdMKcEIoDX2Tz25Qqr7oUyowcGjgy6sWt4RLkND0O16KZJzYQY?=
 =?us-ascii?Q?/w31c9RshOwo/fhbL6WPh2GEbEB/cBxRLvzIFyRh5YbxQQXeVwBWhTMFWj5o?=
 =?us-ascii?Q?Rmhtt0MGaMCEXjDkAy3bwyBQWsUVnS3o838ygKEeN+4fryOJOWhhMjP98k1L?=
 =?us-ascii?Q?y8pg+USeYIWudb7kn6GT5d88j0gHz160wW+YC6WkZYmxwnqSD7TpC9a82RWu?=
 =?us-ascii?Q?0hmBtGHn0Aogast3ux8dOsxqL+n/BGPUrGy0RofqZoU6La53SMvwfpdgt+y6?=
 =?us-ascii?Q?25pzz/aIIelPEMb7JYtctsqmXEnRjUr/lfPQl/Y/hv0DoCuSmoj6xdq7SOzP?=
 =?us-ascii?Q?IsNIe1AHIjvwbBtQcXog8ZBme1jLNLdSs7CnwNBNREUsPLr2qF/fC6hfoQeE?=
 =?us-ascii?Q?5LypmCyvvm5/8OPgJKjJgbswt5C82NCJCK3olBaRSGHVt+Nmi82sZB7ruWME?=
 =?us-ascii?Q?0X8e4YzI5dT4q4hyta14c/eU4kW41j5Y0lrebgwjf/nj25YQufRkHx1vKuiE?=
 =?us-ascii?Q?jDuxbxh5XLwY0lcIuPFQXE/AergjbBPGnU4jT46zR5+/0PfLta+/W6fFVCIG?=
 =?us-ascii?Q?5PjsC+MyfV/BgEMvSs8UE+Nd3Qt1cSdWC4wgN6FV4PgnupZ0YKxg9qS/xw3s?=
 =?us-ascii?Q?lxwokMXY+yDChzWF06wOjKAAS53mT+zNjQCWfQMnocc6GLNHRTTrG4thEKr4?=
 =?us-ascii?Q?Qiw5sq3gzTvxVpOVcee9+jq4PhBvIlWp/Ry4mMM4HZDPuKoQKG3dZgceaHZT?=
 =?us-ascii?Q?I29mrKHG0h/mFnhJc2ZcGi6Xf09VBUXuT88UG3d8kZPn47jn7azerY/4C+Xf?=
 =?us-ascii?Q?rROeyTpNp41kp5dGFs22Y14e?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93262c89-fb08-4edc-e87f-08d94548d86d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:22.2468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jcVlE0KpMWc6eC1fEPn2V96wyOYUr+mzjGPwMrOKT/Mo8R+b5Zna86iEEGG1gzS8E9vUnhzn7q6FH1k2YviKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare the mlxsw driver, which supports LAG offload, to deal with
bridge switchdev objects being replayed on the LAG bridge port multiple
times, once for each time a physical port beneath the LAG calls
switchdev_bridge_port_offload().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index cbcf38338f3e..9f72912e4982 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1774,6 +1774,9 @@ static int mlxsw_sp_port_obj_add(struct net_device *dev, const void *ctx,
 	const struct switchdev_obj_port_vlan *vlan;
 	int err = 0;
 
+	if (ctx && ctx != mlxsw_sp_port)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
@@ -1922,6 +1925,9 @@ static int mlxsw_sp_port_obj_del(struct net_device *dev, const void *ctx,
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	int err = 0;
 
+	if (ctx && ctx != mlxsw_sp_port)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		err = mlxsw_sp_port_vlans_del(mlxsw_sp_port,
-- 
2.25.1

