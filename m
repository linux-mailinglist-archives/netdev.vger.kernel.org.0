Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233003E5971
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237791AbhHJLvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:51:04 -0400
Received: from mail-eopbgr30048.outbound.protection.outlook.com ([40.107.3.48]:17390
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234975AbhHJLvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:51:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1JfGAFSl84SmslV2b5pTJdpvsKzrD5c0Smpq+YTErn6f2yNoziq46IM+a6fJB6F6mKqTdqPjCCSLo9gC3YRYDmxZrXTTMN0PGwAcB8mGgRt+Ha0eVD5t+w4rdae5ys3cY2z7V8OqZ4e4SCqzCkEtdeVwa0BIQI0qwzJktiK4CjVm7SS2Yj+JL9QGu2vgZb3iSSvA90rgY7+WdEjphEZsXv7VsuvDizpI7lc/+h/44IVwtYy2jw+VU6ra4hO6nj3AGgW/LZANcjrApfcUuGQreHN9i1JFnjZ5f1r8miY3LzGB2HSiRp03aDh5mYJ9wHf34YFWxkgeIbW/rEX7X4T/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rp78oVL7S1vqc2mkZWkh8pbR4xD1LuPn5XunSdx1m50=;
 b=X7WpgvoR4pBTHX0JtabaA0LuUm4qR2051UXOF+GtIzvGBFv5NgcqtCwdpe57lECbORRvtOJY7st3eltJ993HEOPRZjg1JlKuAFiIOtHEkPolA6ocfd1xcosI/YEiUzXTxM4BBUx36Kkqth3simmopJHXm7mT1Bbhvd1ls+/Jk0S4RqOCAOYRa1vFgcH2TJXcUOqskkgKQYzPrcnVWBurz282MVDIWk98VyaiiYwkdY690nxGnCpLEKReUIPg85/naowUqWKL0SsHr6Vi/iN0LA3kPbngPjHp1g8QbX46T5hQQ1+6UI95vrh5GyST6Vm3mUx332qat97D3N0kgD7e4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rp78oVL7S1vqc2mkZWkh8pbR4xD1LuPn5XunSdx1m50=;
 b=nzsf8oP3mG7LYc7XThxV0xhCh9OqZrRzM8VB4PYyFU+e1EbTLE2fKpyOhQjgIfjVeKfteNrZECTy+T5qdFc92nzBKosDQVMudq8KNug4Y3d7UqG8qa7pu/HYXP6jxD0oKLgaAOpZRVuE3X4qt9dzl8/wknFsr1pROGTzYHA3lxg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2510.eurprd04.prod.outlook.com (2603:10a6:800:54::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 11:50:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 11:50:37 +0000
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
        linux-s390@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Ido Schimmel <idosch@idosch.org>
Subject: [PATCH v2 net] net: switchdev: zero-initialize struct switchdev_notifier_fdb_info emitted by drivers towards the bridge
Date:   Tue, 10 Aug 2021 14:50:24 +0300
Message-Id: <20210810115024.1629983-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0014.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by FR0P281CA0014.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:15::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.5 via Frontend Transport; Tue, 10 Aug 2021 11:50:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d132849b-0c2d-4412-38c2-08d95bf51170
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2510:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB25102B10FBF3A7597AE523B8E0F79@VI1PR0401MB2510.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UgY0ZSliPpSjxz5Zc/SZ8Ucr7owktTPAIggxVAI9i6n+79jqMZMuHIKbs3ZhpCBbyiMOBEB56v7lO51XTIVC+gBLnf2W+pEQ5TAkr71mDu2lGLGikOZrKmTjGq3EX+rQ3R6GJWi/2BXw5rC2orZkzXlPTOFlvYlDtGvDwAGU2a0bl4DJBOALPyaRsQS+9heDeyZuvp6v8ThFcE06JDr6koke1wWnPgp/5bY7Scx3nvos9aN3SlzWb+TnJkxpaqJ/DraRzzHdRIWmIg9OMSHN52oKFe01y+gOut0vMnNvmR+x2vYKBTIRMtXM3Bdlu7H6p5h6wbqSeL7f3LxakZsKkZv54C9omegSD0oksz9u4zTc/YqMxtDy4neKPpHcBl9cSeTtzw8MVF/1cT97/Fedao9+5HNANJNJLxjeOyiHr8Q059QKMZGbKzkoAsmRDtpjRSxIax6b/0uCQ+dFa+NZ/gtQdm+AcVlMeFpNfyb2TIfWvS3qDWJcuEhXHF09HXf7jgtJhRtOFG++kePxPrpj38rLFo9Hv1TipvvZXg9FjjavIIoslGkMHtr83vnDZnF5Ep5UhRGcRiQk131aoF8f265m13IPI2U4EsYghRpWTgyWHXdHVxji368K99XUhsuJ1cSwEvOenYu4h+0a54H18yrLyzCUgOtAmykwltgKtJOfD9/mWOBleWZpdDIDKO85I0hM27cWBlMFgBRZAboOzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(36756003)(66574015)(8936002)(26005)(186003)(86362001)(6506007)(2906002)(4326008)(316002)(6666004)(956004)(44832011)(7416002)(7406005)(2616005)(66946007)(52116002)(54906003)(38100700002)(478600001)(38350700002)(66476007)(1076003)(83380400001)(6512007)(110136005)(5660300002)(66556008)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I5qR3VlFoQt4I2qX6LqjQ655lKjgP5Q4ZUCHNWjDnOBakcOLVLzhSsw71Ha+?=
 =?us-ascii?Q?4OdiYuF+skUzHvlrCdIpjmTHvfAtNzlQ4b/y9hP8c9QgAF9DBzKsxL+3UXnR?=
 =?us-ascii?Q?h9rikHf9uhv3fU/F21PBU4lzKyd20iZwF1CKnEkM7A4hY60ao0prUx4Tjyu/?=
 =?us-ascii?Q?PFCziukKpKs7x0SWfMyq4FmcUOnw5at7zcKBfEj+wWwX3lx/hKJrG3TwFIn3?=
 =?us-ascii?Q?99gbZug38CV2195Ir0gAfHikBP8JL7YsBROYavMNuaKNPAWXj2OyRsm3ftTd?=
 =?us-ascii?Q?vZq2u59O05yJW9nN8ujvhgMa65H4MhOsCdccV+0k6MrHOG0kmok35X6g9KIr?=
 =?us-ascii?Q?VvTckedGA5oNytM0C5RcZLVqzEtHFs8bKBeEESKUBctxDQBMwtdLFZD9uCWJ?=
 =?us-ascii?Q?ZWrn/ZO1yOzvBgDRfIP9BzhyCsYQp+Gcx4LfcjBx2hMdZiUsMWto3pQZTY1K?=
 =?us-ascii?Q?njhMmQYJaS4CEFU9XOnLe8O30uu5usHCY78gECXndd4othhyMMCSbCfQMtTn?=
 =?us-ascii?Q?0fyoMgac2sVFmOcO+DEARVKZcepzXVK7+DBTnrE3GZ5shOZr46VRUbyoidtS?=
 =?us-ascii?Q?xaANmRSk5HFmpxjV2nyinKL6LV57m7AoQJFmYvKPNv4EZxDBVbgvHNl/1B59?=
 =?us-ascii?Q?kNDBgRidzxMLTyyHG9VucTAxTl/aXh4AAp5Htb9w+1H3vmthiTZTpcxJ31a1?=
 =?us-ascii?Q?1q8/PH739La3CIhoX30+SfvM13NDQqINFj/v/H6kJrf80nMTwLHE3JdhKX7x?=
 =?us-ascii?Q?zKm4pRDx4EECUCQol7aF2v4B6Tp0Rqv0T8gbjvr3li32v3VVD/iUpHJv9o9i?=
 =?us-ascii?Q?tTcK/mf2WnDlAb30JPLDA0MNLdUXzzdlTqiZ9jzhC4ICSZTg1Fc/QShmHpQM?=
 =?us-ascii?Q?64xwkHnK6SYbNnlsn2eOjJjhnxIyFlI/urdtkdKOnYlqXAKMxhKD/CFask5R?=
 =?us-ascii?Q?4TUt6j8rym9GR62jB/dJwQjqxVX9j30z6B7p3RXdMyScHJdrZOfYEXjsJRs7?=
 =?us-ascii?Q?4rAfetgDKdgwY/LTFgrQlv8NbytWFNP1abazxvcA2F7Y5usgxxvrSeRW4Ov6?=
 =?us-ascii?Q?8PGvd2WWhio9iLEwBIel9VDFeMbwofyCs0xxRRk+YlhXAAeDJ2wcae+CGI0l?=
 =?us-ascii?Q?QWe54jDAQ1wceorOTcRIAT2BcAHR/Qtch40glCk6Gg4QlErEe8MWJTLyA/NS?=
 =?us-ascii?Q?NaqGXeGueNwc8P1KZPPOUxl/4ZyGJK34qjZNi1Z2Bd0k12Bh8V5MEmobnvGG?=
 =?us-ascii?Q?f2LB5SeFHoRd4wQ+ONZdJ98+3lGsEUXVSDXV95mLtd17DoRwb0aSzDwN0+jt?=
 =?us-ascii?Q?W5h3jTsrWeRb0Z3cbp4TxrgK?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d132849b-0c2d-4412-38c2-08d95bf51170
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:50:36.8807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFwF+uuAfXLlX7zgvEIphgiXf6X7EirVWRtwDjjYC6Jw8I9IB7efmD5hgSEcfmEz703SmObqV88XOJMEpyaEpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2510
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
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
---
v1->v2: use an empty struct initializer as opposed to memset, as
        suggested by Leon Romanovsky

 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c       | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c      | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c   | 2 +-
 drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c    | 2 +-
 drivers/net/ethernet/rocker/rocker_main.c                  | 2 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c                 | 2 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c              | 2 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c                   | 2 +-
 drivers/s390/net/qeth_l2_main.c                            | 4 ++--
 net/dsa/slave.c                                            | 2 +-
 11 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 0b3e8f2db294..9a309169dbae 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -748,7 +748,7 @@ static void
 prestera_fdb_offload_notify(struct prestera_port *port,
 			    struct switchdev_notifier_fdb_info *info)
 {
-	struct switchdev_notifier_fdb_info send_info;
+	struct switchdev_notifier_fdb_info send_info = {};
 
 	send_info.addr = info->addr;
 	send_info.vid = info->vid;
@@ -1123,7 +1123,7 @@ static int prestera_switchdev_blk_event(struct notifier_block *unused,
 static void prestera_fdb_event(struct prestera_switch *sw,
 			       struct prestera_event *evt, void *arg)
 {
-	struct switchdev_notifier_fdb_info info;
+	struct switchdev_notifier_fdb_info info = {};
 	struct net_device *dev = NULL;
 	struct prestera_port *port;
 	struct prestera_lag *lag;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index f3f56f32e435..69a3630818d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -69,7 +69,7 @@ static void
 mlx5_esw_bridge_fdb_offload_notify(struct net_device *dev, const unsigned char *addr, u16 vid,
 				   unsigned long val)
 {
-	struct switchdev_notifier_fdb_info send_info;
+	struct switchdev_notifier_fdb_info send_info = {};
 
 	send_info.addr = addr;
 	send_info.vid = vid;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 7e221ef01437..f69cbb3852d5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9079,7 +9079,7 @@ mlxsw_sp_rif_fid_fid_get(struct mlxsw_sp_rif *rif,
 
 static void mlxsw_sp_rif_fid_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
 {
-	struct switchdev_notifier_fdb_info info;
+	struct switchdev_notifier_fdb_info info = {};
 	struct net_device *dev;
 
 	dev = br_fdb_find_port(rif->dev, mac, 0);
@@ -9127,8 +9127,8 @@ mlxsw_sp_rif_vlan_fid_get(struct mlxsw_sp_rif *rif,
 
 static void mlxsw_sp_rif_vlan_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
 {
+	struct switchdev_notifier_fdb_info info = {};
 	u16 vid = mlxsw_sp_fid_8021q_vid(rif->fid);
-	struct switchdev_notifier_fdb_info info;
 	struct net_device *br_dev;
 	struct net_device *dev;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index c5ef9aa64efe..8f90cd323d5f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2508,7 +2508,7 @@ mlxsw_sp_fdb_call_notifiers(enum switchdev_notifier_type type,
 			    const char *mac, u16 vid,
 			    struct net_device *dev, bool offloaded)
 {
-	struct switchdev_notifier_fdb_info info;
+	struct switchdev_notifier_fdb_info info = {};
 
 	info.addr = mac;
 	info.vid = vid;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
index 0443f66b5550..9a8e4f201eb1 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
@@ -277,7 +277,7 @@ static void sparx5_fdb_call_notifiers(enum switchdev_notifier_type type,
 				      const char *mac, u16 vid,
 				      struct net_device *dev, bool offloaded)
 {
-	struct switchdev_notifier_fdb_info info;
+	struct switchdev_notifier_fdb_info info = {};
 
 	info.addr = mac;
 	info.vid = vid;
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index a46633606cae..1f06b92ee5bb 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2715,7 +2715,7 @@ static void
 rocker_fdb_offload_notify(struct rocker_port *rocker_port,
 			  struct switchdev_notifier_fdb_info *recv_info)
 {
-	struct switchdev_notifier_fdb_info info;
+	struct switchdev_notifier_fdb_info info = {};
 
 	info.addr = recv_info->addr;
 	info.vid = recv_info->vid;
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 967a634ee9ac..e33a9d283a4e 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1822,7 +1822,7 @@ static void ofdpa_port_fdb_learn_work(struct work_struct *work)
 		container_of(work, struct ofdpa_fdb_learn_work, work);
 	bool removing = (lw->flags & OFDPA_OP_FLAG_REMOVE);
 	bool learned = (lw->flags & OFDPA_OP_FLAG_LEARNED);
-	struct switchdev_notifier_fdb_info info;
+	struct switchdev_notifier_fdb_info info = {};
 
 	info.addr = lw->addr;
 	info.vid = lw->vid;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
index 9c29b363e9ae..599708a3e81d 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
@@ -358,7 +358,7 @@ static int am65_cpsw_port_obj_del(struct net_device *ndev, const void *ctx,
 static void am65_cpsw_fdb_offload_notify(struct net_device *ndev,
 					 struct switchdev_notifier_fdb_info *rcv)
 {
-	struct switchdev_notifier_fdb_info info;
+	struct switchdev_notifier_fdb_info info = {};
 
 	info.addr = rcv->addr;
 	info.vid = rcv->vid;
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index f7fb6e17dadd..a7d97d429e06 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -368,7 +368,7 @@ static int cpsw_port_obj_del(struct net_device *ndev, const void *ctx,
 static void cpsw_fdb_offload_notify(struct net_device *ndev,
 				    struct switchdev_notifier_fdb_info *rcv)
 {
-	struct switchdev_notifier_fdb_info info;
+	struct switchdev_notifier_fdb_info info = {};
 
 	info.addr = rcv->addr;
 	info.vid = rcv->vid;
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 2abf86c104d5..d7cdd9cfe485 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -279,7 +279,7 @@ static void qeth_l2_set_pnso_mode(struct qeth_card *card,
 
 static void qeth_l2_dev2br_fdb_flush(struct qeth_card *card)
 {
-	struct switchdev_notifier_fdb_info info;
+	struct switchdev_notifier_fdb_info info = {};
 
 	QETH_CARD_TEXT(card, 2, "fdbflush");
 
@@ -679,7 +679,7 @@ static void qeth_l2_dev2br_fdb_notify(struct qeth_card *card, u8 code,
 				      struct net_if_token *token,
 				      struct mac_addr_lnid *addr_lnid)
 {
-	struct switchdev_notifier_fdb_info info;
+	struct switchdev_notifier_fdb_info info = {};
 	u8 ntfy_mac[ETH_ALEN];
 
 	ether_addr_copy(ntfy_mac, addr_lnid->mac);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 532085da8d8f..23be8e01026b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2291,8 +2291,8 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 static void
 dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
 {
+	struct switchdev_notifier_fdb_info info = {};
 	struct dsa_switch *ds = switchdev_work->ds;
-	struct switchdev_notifier_fdb_info info;
 	struct dsa_port *dp;
 
 	if (!dsa_is_user_port(ds, switchdev_work->port))
-- 
2.25.1

