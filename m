Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503153E4649
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 15:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbhHINMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 09:12:33 -0400
Received: from mail-vi1eur05on2087.outbound.protection.outlook.com ([40.107.21.87]:38432
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234821AbhHINMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 09:12:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sk30NxUfr5h4ijNegkCSb+8x8nqZa3VRyvGKWm7eNG136uaqCbFRNgfsAiz1GVt0e4Epy/l6L0aJuOqgNvucb4DMdsFfhoiZeY5pIQ4cPu7JJ43kqSI9ls+5e/tqrLi/xPycKxy/GjaA7ZnLqr5FbwrRvPKrOJZHUnl682YzP8zAx3R0rMfzbkjVWC8HyeVKaWX3PO0PRAm2fNBNA/Y1wt4jOuLBSZlBRAMCE0fSDSC6+VbYjpDIpWcxapK/rFq7wMc05L/xb+qiR95sc1emm0G1oDVa3GuyoHXX4e63EYjO7EZUMYo+cso992eTCeEM143JGbQgZwiQpSxXwywxFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1wUQVKQA0iJ/qS+DMuUeq93qWV8MhNGV5uHO4WmCKk=;
 b=EiA6qqU2sLL9XhGcGz8U7MbH1Q48ZPE3eNxMSqLv1tgUPEEuHVhHOdLCJtd1Lv/1J5W1uNAPdyDtdANQ6+a/7CitFCfuE3Zx2zl2hagHNTvSqh21xXVOmqFAhtJna8c2zFV7BbfAAm0aTW8MOJ+kNDRI/SxolDyEzVG4jyIvziuMYE0g2DKEzXBgxxH3XyNs83mh2TYtFTy7SxeU5dr8kc2pZwSIrybRDwtnaJY5YX8AsKJSqlRXsiphwvjm9MZY20vEObAWJqd6RNfUMovI8DI31YmPcmZiBzZvU+mJMvnxn4OGvStWWH6IqjEHFdYzIG8rXzH8J0sS6JdgYIA+Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1wUQVKQA0iJ/qS+DMuUeq93qWV8MhNGV5uHO4WmCKk=;
 b=FVP6ECFmIwwrb2OOywTv0XzNKx45V3oGqk4yzZmOFHjXx1O4IjAVN1xNHk28i4LOQdUK5t0mp16LZi0AYMZzHlZ4KIELGoP2oDcP/juQuevUiV+/UeWeEp/8rBGIjm4wPWITf0F1XpRQHIliSxFFMJDH4G/NFyVBs1aWCa/JULA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Mon, 9 Aug
 2021 13:12:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 13:12:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-s390@vger.kernel.org, Ido Schimmel <idosch@idosch.org>
Subject: [PATCH net] net: switchdev: zero-initialize struct switchdev_notifier_fdb_info emitted by drivers towards the bridge
Date:   Mon,  9 Aug 2021 16:11:52 +0300
Message-Id: <20210809131152.509092-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0196.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0196.eurprd08.prod.outlook.com (2603:10a6:800:d2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Mon, 9 Aug 2021 13:12:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f250481-fbe7-4ef5-109e-08d95b374a6c
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-Microsoft-Antispam-PRVS: <VE1PR04MB73418C2BB02523D96149B3B0E0F69@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: APTbyeRE34Z386E99ZosFY7XFBxC/HKutZYl/nGSzZMH07t/fFSw3QaNaUifK4S6yhdCoX2FcJcF23UbwT89miaRmnZT7Vi75Z0LLXabjEu/a/zWjEZekl2x2Kbe/cc8Jsk/oMPl26nZxAFhKpDn4bsWQl/LYz4d9h4DF1VzhesR6EybZ+L3LYij8Arbo+biJ69vNpVqBTc2Wt5AQIptns8C3RLgz3R2/Rziuj/GtICRcMper/nmMknSKEZ8wLTLfzXdLyXN+3ADJhC3bsBLNn8TkZva7cHli9R6BE2ZjeOnsiP4VoasDpWKVVfCqNNOEsQkomwnZ0FAqRCM+FlHv+1KZ1kGuO8ZUjKi+lG2T4eCNMuYmrULTjnxQCXZY8Lo0Be/smswKPDyI4XRCQjhc9Rxe3mxRbRweb1UGjfQIfGuqcrwmlPZ33P+Hxvh0aGkpP3PJqkfqMuSgth4JIPLsoJvGCZE85xxMmVNqcolV23xxr9tp/Y8xWrLtMsIrEZciqKapQYIdX64H5r78cuuUWhUfi1R0cAE0j0brCx00n7Lm7KKzj9Nql1Fs56UkalNo4CTl6+R3w73VW44CUdsG11beX2NQW8ak4OyAkvi+CHKlS9xqkyaXDfTIulnOiCflUNgEdrM6YbqF80pfEC5fm4KqXRUdcXd+o9MwK7p6PGW46RXUP3j9fvA6FzyJSEPD8xKEeRRsCuh5F3QdC85fw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(6486002)(478600001)(8936002)(6666004)(86362001)(38350700002)(38100700002)(54906003)(956004)(110136005)(2616005)(7416002)(7406005)(316002)(186003)(44832011)(6506007)(4326008)(26005)(2906002)(5660300002)(83380400001)(52116002)(66476007)(66556008)(66946007)(8676002)(1076003)(36756003)(66574015)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JxrYF5HOUzZb6SrxzrL3lEi+wooNPBAiS7dF8uAn3pAEms+Te6+76DJSrOJk?=
 =?us-ascii?Q?LPbPaxs6fiaZYiK1HTMFxPor1JWaMTgREeFVBEq4vAImT4xR4qEjp5OYi2gA?=
 =?us-ascii?Q?4btdrwWuBi+7p1WUclhnVZ/TE3rh6do7dV2vOF7HCsNAbI19a9Wn98oabgsg?=
 =?us-ascii?Q?89oSdcyFmHRP1pflHcS78zGquxAtwD7u3T8DdE+eN/OM4xj+e86dDlaEnLca?=
 =?us-ascii?Q?awj09av5JrnLHZkz18zIF4Jnhl4ajlPDTwCNRbItHmaFPlX3idphcbhT23Rq?=
 =?us-ascii?Q?/LF3flsyE2Ven1gcWd+iqoDgLm7a5tjur6C0r7kqRVnc3alERgSjwLTMY7C1?=
 =?us-ascii?Q?LjdChgVfC7WLJRz0lHlpckxhbQ1f0AUvn/StXkiz+for3l9G0oqPzlFW2Tf8?=
 =?us-ascii?Q?RfA6lWDZo4NW6we5N+qX5CF1q7YNOmYAWCe3Q6UNUiwNgRpk0CH6nHNAU+cl?=
 =?us-ascii?Q?/w9GS0aAvh6NLwx14ehgiOH2YEeOSUA3/E1Tvg+Mg/ZehM7UyH5d34C+TdkF?=
 =?us-ascii?Q?QX3PJ0BOOugal5DgB+iEdUKGEsYgb6Ioyja3idO/FUIIMiVj+fZsJb58/t7I?=
 =?us-ascii?Q?wEuw3OIZKPHq9Hpt9DggXihlDnyRNqi95QNr/bui/2ogBE2eRpbf3yXu5yna?=
 =?us-ascii?Q?aHV7n+3qz6Vj8UkPMuZ4Elpbco2wiKOrZpoG+IT1dxlIcbjJO/RnXjyinxRI?=
 =?us-ascii?Q?5FZ3XpPDZvSqeVhU3PXuHZj27PVBCMI0oPSO8pHTJSnsUeyhOosLHvQnjNS/?=
 =?us-ascii?Q?MKTelezyRlHowg+iTic6bpCdlvsBSnpWBg7KlaxwsRnaSzi6nWOW7pQHvbnk?=
 =?us-ascii?Q?NKej3zcQIiGgB/b3wmpvYwe57e6qYC1HxVLkSSCZdApNBF9Twuc1BPvg7OU7?=
 =?us-ascii?Q?L9h7/kBa5D08l+Qigiv/0R9kHr7i8ZAOgEBRnlaJ9ecSx2t/s5iB/0YYUiJt?=
 =?us-ascii?Q?kMsv39KbUFxS6AdLaeSOIc1QTdPAJ1kAKmx/cTNuysGcQUwysdAFf9LzK/On?=
 =?us-ascii?Q?46gRKIesASwbIEHFKMVKBcN8QzvAloxUM/+A4h9Ee2zuqIG1VhWsqGVTO5es?=
 =?us-ascii?Q?wjqRn1k83vwIIVLE7VsjzYXPI97zIKy75BzWGVXIhZeIJRSQmJSr4QbJ9R5H?=
 =?us-ascii?Q?q33W/HYhR3670ebwv2Acixx1p9P6syeVIeeiC4+XFBDr5Rgyl0QJodwVJZPi?=
 =?us-ascii?Q?SO1LaIgk9MG+IUGf70pfhFH3+BUXCiwhlVGRkVUM308XdKbwcz2PJqR0DpiR?=
 =?us-ascii?Q?m9lmFzL3C8l88NYErfQXztF3OKegqsgjcd06Xx6YNlQbzAc/6GrKPgsllvBb?=
 =?us-ascii?Q?9otSRHpnnuZge7nPdoOPpPCI?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f250481-fbe7-4ef5-109e-08d95b374a6c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 13:12:08.1899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eMtDErpZSBrwA8UBHi4h8ulaiPFQvrLP5+0QhdsJNf6piQl0ieaLHPTC9i/OTHXmCUf3+cQuWWU2R1VsojkgSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed commit a new field to struct switchdev_notifier_fdb_info, but
did not make sure that all call paths set it to something valid. For
example, a switchdev driver may emit a SWITCHDEV_FDB_ADD_TO_BRIDGE
notifier, and since the 'is_local' flag is not set, it contains junk
from the stack, so the bridge might interpret those notifications as
being for local FDB entries when that was not intended.

To avoid that now and in the future, zero-initialize all
switchdev_notifier_fdb_info structures created by drivers such that all
newly added fields to not need to touch drivers again.

Fixes: 2c4eca3ef716 ("net: bridge: switchdev: include local flag in FDB notifications")
Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c       | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c      | 2 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c   | 1 +
 drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c    | 1 +
 drivers/net/ethernet/rocker/rocker_main.c                  | 1 +
 drivers/net/ethernet/rocker/rocker_ofdpa.c                 | 1 +
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c              | 1 +
 drivers/net/ethernet/ti/cpsw_switchdev.c                   | 1 +
 drivers/s390/net/qeth_l2_main.c                            | 2 ++
 net/dsa/slave.c                                            | 1 +
 11 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 0b3e8f2db294..cf60e80dd3ba 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -750,6 +750,7 @@ prestera_fdb_offload_notify(struct prestera_port *port,
 {
 	struct switchdev_notifier_fdb_info send_info;
 
+	memset(&send_info, 0, sizeof(send_info));
 	send_info.addr = info->addr;
 	send_info.vid = info->vid;
 	send_info.offloaded = true;
@@ -1146,6 +1147,7 @@ static void prestera_fdb_event(struct prestera_switch *sw,
 	if (!dev)
 		return;
 
+	memset(&info, 0, sizeof(info));
 	info.addr = evt->fdb_evt.data.mac;
 	info.vid = evt->fdb_evt.vid;
 	info.offloaded = true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index a6e1d4f78268..77e09397a062 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -71,6 +71,7 @@ mlx5_esw_bridge_fdb_offload_notify(struct net_device *dev, const unsigned char *
 {
 	struct switchdev_notifier_fdb_info send_info;
 
+	memset(&send_info, 0, sizeof(send_info));
 	send_info.addr = addr;
 	send_info.vid = vid;
 	send_info.offloaded = true;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 7e221ef01437..8a7660f2d048 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9086,6 +9086,7 @@ static void mlxsw_sp_rif_fid_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
 	if (!dev)
 		return;
 
+	memset(&info, 0, sizeof(info));
 	info.addr = mac;
 	info.vid = 0;
 	call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE, dev, &info.info,
@@ -9137,6 +9138,7 @@ static void mlxsw_sp_rif_vlan_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
 	if (!dev)
 		return;
 
+	memset(&info, 0, sizeof(info));
 	info.addr = mac;
 	info.vid = vid;
 	call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE, dev, &info.info,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index c5ef9aa64efe..f016d909bead 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2510,6 +2510,7 @@ mlxsw_sp_fdb_call_notifiers(enum switchdev_notifier_type type,
 {
 	struct switchdev_notifier_fdb_info info;
 
+	memset(&info, 0, sizeof(info));
 	info.addr = mac;
 	info.vid = vid;
 	info.offloaded = offloaded;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
index 0443f66b5550..fbc3f5e65882 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
@@ -279,6 +279,7 @@ static void sparx5_fdb_call_notifiers(enum switchdev_notifier_type type,
 {
 	struct switchdev_notifier_fdb_info info;
 
+	memset(&info, 0, sizeof(info));
 	info.addr = mac;
 	info.vid = vid;
 	info.offloaded = offloaded;
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index a46633606cae..49d548be9fe4 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2717,6 +2717,7 @@ rocker_fdb_offload_notify(struct rocker_port *rocker_port,
 {
 	struct switchdev_notifier_fdb_info info;
 
+	memset(&info, 0, sizeof(info));
 	info.addr = recv_info->addr;
 	info.vid = recv_info->vid;
 	info.offloaded = true;
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 967a634ee9ac..7d954fd24134 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1824,6 +1824,7 @@ static void ofdpa_port_fdb_learn_work(struct work_struct *work)
 	bool learned = (lw->flags & OFDPA_OP_FLAG_LEARNED);
 	struct switchdev_notifier_fdb_info info;
 
+	memset(&info, 0, sizeof(info));
 	info.addr = lw->addr;
 	info.vid = lw->vid;
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
index 9c29b363e9ae..81d2b1765a66 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
@@ -360,6 +360,7 @@ static void am65_cpsw_fdb_offload_notify(struct net_device *ndev,
 {
 	struct switchdev_notifier_fdb_info info;
 
+	memset(&info, 0, sizeof(info));
 	info.addr = rcv->addr;
 	info.vid = rcv->vid;
 	info.offloaded = true;
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index f7fb6e17dadd..446bdab06bdd 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -370,6 +370,7 @@ static void cpsw_fdb_offload_notify(struct net_device *ndev,
 {
 	struct switchdev_notifier_fdb_info info;
 
+	memset(&info, 0, sizeof(info));
 	info.addr = rcv->addr;
 	info.vid = rcv->vid;
 	info.offloaded = true;
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 2abf86c104d5..843dd4f4d8d7 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -283,6 +283,7 @@ static void qeth_l2_dev2br_fdb_flush(struct qeth_card *card)
 
 	QETH_CARD_TEXT(card, 2, "fdbflush");
 
+	memset(&info, 0, sizeof(info));
 	info.addr = NULL;
 	/* flush all VLANs: */
 	info.vid = 0;
@@ -693,6 +694,7 @@ static void qeth_l2_dev2br_fdb_notify(struct qeth_card *card, u8 code,
 	if (qeth_is_my_net_if_token(card, token))
 		return;
 
+	memset(&info, 0, sizeof(info));
 	info.addr = ntfy_mac;
 	/* don't report VLAN IDs */
 	info.vid = 0;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 532085da8d8f..1cb7f7e56784 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2298,6 +2298,7 @@ dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
 	if (!dsa_is_user_port(ds, switchdev_work->port))
 		return;
 
+	memset(&info, 0, sizeof(info));
 	info.addr = switchdev_work->addr;
 	info.vid = switchdev_work->vid;
 	info.offloaded = true;
-- 
2.25.1

