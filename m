Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6071B3C5F25
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbhGLPZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:26 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:42723
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235496AbhGLPZT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdgYEc6N5Ib2CYoV8ZN6a7y2Bv1oFeTat+Vtc8diOxI4bfsaUvK9RGcJuIYFGw8Y91nUEofONmbUWFY84Ui8KrXVdf9rkD5QJo1JfxZQPwhRlLhx3teTMUAiQQHk3HXnEenP4ZbKPXo1GPSNDgIod3xJEV3pwvFZ3uQW80c3UkPL1G4+rZQcggXXz3mlQgVyO0E7E3ZIsKipP4E6dEGiYjuFHqvw0f1nmKoyBJt+umK4syKdSuxo4cV2NdaeP4pVk67vMZNlzXh9zJ5kOpukmcCsz1ypMSDmsZw6mZnA3kSkjjNjr3So9xesa+Ev575IL7J1pZ4UH8tCvp/4ZWEdIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ab4neqNso9HPVLudAtgiKoIKBgR3rYQRHaMn/xx3sss=;
 b=ScqzCjpyggv0p36KQG/xu4tiouU9IyceBt+Npl7O9R/TIPaDVN2Ks9WFpy1UD55RxCW+DbUA7pWCZhuQGZvUHKsDpj4bU54ozajNNou4SJdNQOSOofTdmpf48oyjj9nmDduB6JHCNTbWSMp7QsJe+OkN98aGdkUdXmcXJfumnVR+gybY/fBE23862xEXj9HOV91gXquehikd8OvzLA/wbX5YlQPKU3k2/K1vkKk+vCnyVluhVJEbvGjvlYznA6Y2JRpbABFBylBASiys3mpLtgqYWvEqgf8LlrTpcF/lm+OSmt2f/6cZ5a6VeconpGeQLKy8B0a/40bPrxv8JUAxog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ab4neqNso9HPVLudAtgiKoIKBgR3rYQRHaMn/xx3sss=;
 b=Fu+/ydRgpynQP1/3cQxL82H04Ts+mhgKAoXrhMmWU7+onSJTqpBpCiu4QLBjFmEp+Rk4/9XO5FCtZu4m5bayl7Jy/bIAuQzCo7/OgXfxMILusMWwCClG9mY1yEqe0Ug3ypgyqUTcW9QLv6qn0wxBCt/7utW9cynuqzoo3jHOOVs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:20 +0000
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
Subject: [RFC PATCH v3 net-next 10/24] net: prestera: guard against multiple switchdev obj replays on same bridge port
Date:   Mon, 12 Jul 2021 18:21:28 +0300
Message-Id: <20210712152142.800651-11-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 859df2bd-6f86-450f-52a3-08d94548d799
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB627124E39D6F01E28A985A67E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oJ0pLvn373TGr0H8QkyKshYIQtTzPtZuQk/dyeEB7vH0Sb4jXc/e59jYz0bDG39q0oKAdnD8bz3YnlkPA84pGSTUHY8bSLwug9XhVSkBpFBZ2pvK77ahR4SPaCHruq898jn9AbLst2pniNaZjC0VgEa4p2bns/Cf8+uiWE4zanHs2YKdL4W7gWjruq4A0jGGl3hjCLI167KTb8I2ByFKgNhn4q0DXNfWlKXA52oR/YTX/341GtoFdvE9EpQvuaPAaVOjG6hkHA9aBj+707nMOiQAWpAZNA/HZ7VDuUqSz9O7IFMicQ1dXpaxYMm6P/EBIrUBe8lvD9Q+xvOECgqPMerGKcK3hWGoRxWP8KClV8ngc/AX1OrFdjFVE7aNa70bG6iS/9RhjLK8EiZwR3I0+YnQF2RpveLGHrQ1F0tgdi13zQLDBW9PDqfq1BJ/4NOO9qMY9polzfi/zg8GGXucrE1NRvl8k81FJijnkU7mC3oP+RaB5nD8RS3TfUHhUSoReoadQY9x4dusZ8fePh06CC7vIiYhq6FnmXRfOOht7LVWgJquJJrZmTgSnQp4vWWdnsU1ugaNGpnO6exDA4urOGRhCwN2HgTJ5NstYeWJrdVY84UK7ya1EsRHRILWMXl8crq70lBK+5vbHhPR02elZp1W8a9uCqt8MtjL1D1LKIllsyfZVyD9PmL2EjIhhdyNkCrGxiPfZsHyHETccfU1gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(6666004)(66556008)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5seQHW5VdXhab7PjlgyXRFSzd4b/Ir3NhyxY8c0Qeo3XcS8KP/MB9Qp4mcDE?=
 =?us-ascii?Q?UTFlgdtdzNtbXkeVxrv5mqKjDZGH+FGyv85TZJCe4IvlgQCxFRx3xAj8AQ8X?=
 =?us-ascii?Q?aJiIQfmez1s28YVYvMvp74Dfi0ofC46wktt3oJOzX6NFKq/oUF6GftLEpX2c?=
 =?us-ascii?Q?9j/aA99m02XdLiQ2LmE6ELZbQ3wthx/VYPDFsGA+6PVYge1VbKaGraaehaLy?=
 =?us-ascii?Q?RVs5C9vMGaLyMW0NCfc3QmA/rBSaCYZBkXiIoW+g0kV0Hc4dJM0zK9Eh/CJ8?=
 =?us-ascii?Q?mm9Id3Xdw3dio1sPAn4CyLbTThUWPl+IrK9RfrI+GeKSbnBVrgdV45wOa2ZQ?=
 =?us-ascii?Q?o2Z8RGmQuh9dLSfG/YcwW/G9XKqTsQBfLLsKqdZbJHYSIaVIqwlzJEQiSEX5?=
 =?us-ascii?Q?Kym0M8gMbew8QcUEArt8isOrp+VRMgBcwJXF3ZPA0x9pWr9CSnv6JJAiDYxk?=
 =?us-ascii?Q?ESslQxzMcnJxOoc9Irh3GXl5yoDn7GFJ6VgkaogHKJeHWIXRnc7V0Ud3qboo?=
 =?us-ascii?Q?8eiemnly96XIaBI8QfkBM5lHKilDJYFfjr+l11dpB4BClNQLR6odhD8VMejg?=
 =?us-ascii?Q?rf1MtP+yzGuOdoUyHuSHBesUhNfoMPBh4dFoU9qYHIl2lWeHYyHeHgTftgkA?=
 =?us-ascii?Q?knt7ZJrQMUhjNZQ2h9H7L9UmQdKQzq3XXN2O7soYevOHlgX6yB3rtOl2rnHH?=
 =?us-ascii?Q?0ypWHTiFeZljU5uK7P/+RaVvqEJUxzLLZ62b7gh9f6w3DBgL8G5LdE0rve5S?=
 =?us-ascii?Q?/pvJpdO8dfrLneG0f+x2ZKDOKJ9L5qptMEi7GAmPEM5B3OIvx00p7HqWq7rQ?=
 =?us-ascii?Q?0Qo7r1C8iGTJYDENCsk5mIuFDt0+e6FVJ3WuByc/vvKM30zwNIZHcTGlvsd9?=
 =?us-ascii?Q?B9RtsYqyWv6xKKfmxzO8WPKw4JsxhitHTZ9tpaOgv9rIZE6jCXwl/Bp2Ghxc?=
 =?us-ascii?Q?yKRxQe0h8U9TrxMiLQBrt0EHv44nhdgcTR0lb4VwJTxqeoPWT15qZd1QBCGU?=
 =?us-ascii?Q?6Jag1/crrE9aVUCDk5Y1QVyQ3SC3GZXPgRFeFY/+M5H1OM2nsxVcmZT8Hwpn?=
 =?us-ascii?Q?f3A3BOsNEe63hmbhp/gYKZCS1u1op++IvMNty9cwHOqGIH7ymMXDZ2bpC/ZP?=
 =?us-ascii?Q?rSJ/xAL+cmLJVpUgdzEMonUQSjwtXcPR4p43dkCTAMo3yKRsHY6RWVrOMnm/?=
 =?us-ascii?Q?THPfPYW8RGGQh0yPF7xfkcU/0G29uEO3e3zjtBolx+sDuGja0yvLy6pXv7Oi?=
 =?us-ascii?Q?sN3eI2sYdE0jyVyOOjdmjtP2YVJrhlNaeNzewwMIo3Fev7wtnfvVPP8blJd/?=
 =?us-ascii?Q?tHrUi68xXOTyPSrC0hra/t5o?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 859df2bd-6f86-450f-52a3-08d94548d799
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:20.8476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n5F6iVe6/D/ZWLiLzMg2+p/PTcCF7kM82A6N+jgJEdPvlZ4aSMzDrURtF9dsrVNtj3l6qwyo/E71vI0vBHEPsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare the prestera driver, which supports LAG offload, to deal with
bridge switchdev objects being replayed on the LAG bridge port multiple
times, once for each time a physical port beneath the LAG calls
switchdev_bridge_port_offload().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index ae117104a23a..4be82c043991 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -1074,6 +1074,9 @@ static int prestera_port_obj_add(struct net_device *dev, const void *ctx,
 	struct prestera_port *port = netdev_priv(dev);
 	const struct switchdev_obj_port_vlan *vlan;
 
+	if (ctx && ctx != port)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
@@ -1110,6 +1113,9 @@ static int prestera_port_obj_del(struct net_device *dev, const void *ctx,
 {
 	struct prestera_port *port = netdev_priv(dev);
 
+	if (ctx && ctx != port)
+		return 0;
+
 	switch (obj->id) {
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		return prestera_port_vlans_del(port, SWITCHDEV_OBJ_PORT_VLAN(obj));
-- 
2.25.1

