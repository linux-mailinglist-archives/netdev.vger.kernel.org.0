Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85713F2BA7
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 13:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240285AbhHTL7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 07:59:01 -0400
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:24941
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240271AbhHTL67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 07:58:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtreSImMEx0crMfcWt1mQ56IWPNzLrHkdz5v1fFV3JYCPyIaEbiRCK+bv29JPN3vTBjANf3xc4YoVymEcPxlvznOTIltbi4xoU88Obt0lt5/zp+LB/R9d3Bl/nKB7UAf4IrQeA236o+VHH4XI2kLL2lUad9TQjmqc/PTuISMl/guNqcKB9I6N6m9eedfMBh4WKkTtZMRqZlBC6N/XrPH190oImVd3LkYjvO6g5zVf5kGZlEmZAQqn3j8b6sbvbZGKaal0G3dZ08lJctIZe3FPfqE2WWtkACpuewM8etEd6hyAlSSb5GaNKEiQ1UIqjTuv1rFEJhxXDwr7U+tMDZR7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0pCbndSkhVXafOxbgUnBKgo7up2D4PXGAZVflKXTZQ=;
 b=mrIarxtE+gy6Ssg5ivfWJmMUBWjg8T4orQURe1bZlB+PTxlBTqLOhke/6SG90Lg7gJHVLfoiQ7kCJ2vdBRcmPXI5PgqhCJ94RZDO5x/SfaC4/KSdeSlicvKSx14gq4Hpmkgmm97yu0m9UoWjARoNn8g++uQnDsLSdyG6HGbvlxyNlxyGtQfz8WZYESzkPKK6LcD3K9QvCjzAh/X5VEZMbbAHK2J6bNAR1d3iIJF4YJD5OhvGlBmX0uXhEApaD/p00my4Xg11wVkwDuZ8NVBKjMHYDOk7pXK2KzvCLuu0R+tykF9Nyw3ni0jm7NRPBF7mgEu7z2StDpxyKEplJREg/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0pCbndSkhVXafOxbgUnBKgo7up2D4PXGAZVflKXTZQ=;
 b=gpRfzHyj6uIZ77ZK614/T/Oy1IXCo70Vc/BzwzjZKiiCLdH0UmsrGZnCkutJ0eV0e2kqZHD/AZWNuQInhhejDC9YVNCW+Lwgi5Bp84p/qsiQ23h5U8dg3A5URraDwvZAT8DUMbKWb427NEnV5SnORk7juR/kmMOs73tO+nEj37c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 11:58:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 11:58:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-s390@vger.kernel.org
Subject: [PATCH v3 net-next 6/7] net: switchdev: don't assume RCU context in switchdev_handle_fdb_{add,del}_to_device
Date:   Fri, 20 Aug 2021 14:57:45 +0300
Message-Id: <20210820115746.3701811-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
References: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0010.eurprd04.prod.outlook.com
 (2603:10a6:208:122::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR04CA0010.eurprd04.prod.outlook.com (2603:10a6:208:122::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 11:58:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9088a94e-61bd-4f63-f0da-08d963d1cd00
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB38391CC5C4636C28E9F75C9EE0C19@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r31HH8xLs4li+/w/fXptLXlv3RcxjvPLCjIGtoZx2vbjhWbmIza5/zXJ+6ooNmAuZ6rzwKOig52iSfevYiLsGBPHn5G41k9NQSQfBrpYDzrZpM62e9grp2F2kVLU9gLvkYFnGkXqDtYy5RUDMOTPpxeu+3Cq9aN6Tkifx6iHQrizrrxRjgnO73sExfgkszxv/Ve4Js4J6M8dPICoW2Eeg7td4rKjaHJIjlWYaXjCk0qwiJXhZTZEGDkEw2l8ZMjQLwhqN17t8FxHa9pwup5DwBUPSsjrgjMt0E6yI2Hvy9VBSkkC+5TqbJh/r9aoxIspmpnhHmedId5uGPV9R+mp3LJ5HmRwGycJnDHGiDy/mo9RCOkfZKEN6XOOEP4yRit/D+0OAfCnLzBziD9MRqUAYQbT4Um2Z312i9TvBA9Ecg5ARieYsu2jmlEUOMxiFlrIDWxI+tDD7UZqZuaO4QlbyrwScGYpoVGa9JiJkvNY4uRE2Yo4I3mvKJZqwKdzXVhUAzec67UTXcrLCuE8sbeTAyEukZChiqtFAGYiI+Vz4iUT8b3yuJvPizqpn3PTx6bdTadxGBJsIeOKfRtaEdDE9CwnEd9O8xuq+gyP89ZhojRsCMt5af3x81Xfl9pShQBz61+nD0YnxtAvE7W4XUK3pk00O1jQdExPhN6b0nv50pmqrg+6/x/AxHF2t4DDWXUPbzLgLaykg87N8QRQmj07rA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(8936002)(8676002)(26005)(6506007)(6486002)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(83380400001)(1076003)(6512007)(66946007)(52116002)(7416002)(7406005)(186003)(110136005)(36756003)(54906003)(478600001)(316002)(956004)(2616005)(44832011)(6666004)(2906002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EodU9qypXlz6ny4grJgkhAZElnKitBpzuOb8oI9fPaDR7OFHqDTrQsFcsabF?=
 =?us-ascii?Q?5xI/t39oBnEoKnt64J1ehork9i5KSOJ45tvoFtqNSCFxqLtF6GFgTCJtvPp9?=
 =?us-ascii?Q?J/oZBWuuBTw8WkY9Ol69H027N0mzsLfcAt7sTHvErbrzIiPzJUO7BofmgRdg?=
 =?us-ascii?Q?khovu3jW33BMoO3zjSDqNjiwhjLK7m7BZe4RhcDH/DhoeckA++ICC8bsuumK?=
 =?us-ascii?Q?WMU+68svx51Fuw/zRpLIjGCUb1XI8mgn30vuDWve8E50SHk5RaQyhVIO6PEo?=
 =?us-ascii?Q?KPW1V4EzWUbWpo4YiZu7gFz9UGB/EQM7zHInXw5fR69aDcQB3eqKy959X9uG?=
 =?us-ascii?Q?v3D/MA3bN65x9KdI43Edsqyn+SnD8SERGs1HjW74WJIpvt5YIGvPiuBqNBWH?=
 =?us-ascii?Q?TRB7rwEnN1V2duDiskH6UA+f5fmAIWVWhqC0DvpN8Zpi91VrQUICIp/WAjBs?=
 =?us-ascii?Q?IjgHIWA7f1s/lQyJYM31LleSwp7ugC1rdkhxrafPxVj5jIwuYRlgeUb3YNbq?=
 =?us-ascii?Q?cod7Gq+60NfcNdQQe4W/pAKH3XDQrH1QXsKaTf6fmskpUQlBfOI+AhP3TfcV?=
 =?us-ascii?Q?ISbOQ15cXMCu/rTbBpASYFDdI+zq7xBQu+VYSiUy/THRQaVo18tHCiBWOZVz?=
 =?us-ascii?Q?kOcw+l/gFlKMF9Wqdp8Mbeq/p/SxvVat4u51cNyXZCqzBzcihzgcYQBiqQa2?=
 =?us-ascii?Q?wsUvxT0qsU/p/JSOPCbrZ5VE9oRz2CLK23XN/d1AsVMcbhNq8YLqZ4gNZ5WV?=
 =?us-ascii?Q?khX+cTD24AoAC42hSXmirNMWuhXy418O4LT3BB88C70TEQdBdynVsyuXzk9X?=
 =?us-ascii?Q?5ScQYJO5pb0euIClXYIRXUiWSRpEoo8/YcHnc9jEcMHkGJziXf8o9xJAI5bB?=
 =?us-ascii?Q?S/gidRirp6KViVfngJmBX4GJ5mgUfKP/ZWHLCMi8J+V9GyWKY5PlM2souHn2?=
 =?us-ascii?Q?J73+fUmIYvj6mv3AulvkTlBlZ10IN3qeO5pzL5rP0xS8GujNCwgJKPZAijp7?=
 =?us-ascii?Q?v8K3AROfzNb7hdLU2W6MBkKzUZvriE36PsqrCfeh+1klGhx/s+h2CCxYJXL4?=
 =?us-ascii?Q?S6bUV1VhRUNC5FNQgog/ohCE0psYZGeSiqxbutdDDhm+Kd0ND5z1Nh/gMFLp?=
 =?us-ascii?Q?/gjql8cAgk+o+BBaozeaviKxQsIJKiN93iUB5zJMS6I6H+0srcRT+WK0ow6L?=
 =?us-ascii?Q?RnsDt11OoV0fsTi0+PsjD2qzkfTCFbkCmrKXNdozutzAn2Gye0md58qcNHAT?=
 =?us-ascii?Q?XCaXv+C7tk1jT035cuo7+VOVXnLdLczJ/S/U4OPe7sMy2wJFgLL6E5evIh62?=
 =?us-ascii?Q?t3nzCqVx7V8IdrnceJ3184d2?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9088a94e-61bd-4f63-f0da-08d963d1cd00
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 11:58:19.0470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bDPVBZg3nkMwZA9bw0jDenTcBAI7HPFtpG/PHANQ2VOoRvtYxca22xOqrCY9pCq8+hJ1KRKQcqm8UBae7ICFPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE events are blocking, it
would be nice if callers of the fan-out helper functions (i.e. DSA)
could benefit from that blocking context.

But at the moment, switchdev_handle_fdb_{add,del}_to_device use some
netdev adjacency list checking functions that assume RCU protection.
Switch over to their rtnl_mutex equivalents, since we are also running
with that taken, and drop the surrounding rcu_read_lock from the callers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none

 net/dsa/slave.c           |  4 ----
 net/switchdev/switchdev.c | 10 +++++++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 6601224f6a5a..196a0e1f4294 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2484,22 +2484,18 @@ static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
 						     dsa_slave_port_attr_set);
 		return notifier_from_errno(err);
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		rcu_read_lock();
 		err = switchdev_handle_fdb_add_to_device(dev, ptr,
 							 dsa_slave_dev_check,
 							 dsa_foreign_dev_check,
 							 dsa_slave_fdb_add_to_device,
 							 NULL);
-		rcu_read_unlock();
 		return notifier_from_errno(err);
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		rcu_read_lock();
 		err = switchdev_handle_fdb_del_to_device(dev, ptr,
 							 dsa_slave_dev_check,
 							 dsa_foreign_dev_check,
 							 dsa_slave_fdb_del_to_device,
 							 NULL);
-		rcu_read_unlock();
 		return notifier_from_errno(err);
 	}
 
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index d09e8e9df5b6..fdbb73439f37 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -470,7 +470,7 @@ switchdev_lower_dev_find(struct net_device *dev,
 		.data = &switchdev_priv,
 	};
 
-	netdev_walk_all_lower_dev_rcu(dev, switchdev_lower_dev_walk, &priv);
+	netdev_walk_all_lower_dev(dev, switchdev_lower_dev_walk, &priv);
 
 	return switchdev_priv.lower_dev;
 }
@@ -543,7 +543,7 @@ static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
 	/* Event is neither on a bridge nor a LAG. Check whether it is on an
 	 * interface that is in a bridge with us.
 	 */
-	br = netdev_master_upper_dev_get_rcu(dev);
+	br = netdev_master_upper_dev_get(dev);
 	if (!br || !netif_is_bridge_master(br))
 		return 0;
 
@@ -569,6 +569,8 @@ int switchdev_handle_fdb_add_to_device(struct net_device *dev,
 {
 	int err;
 
+	ASSERT_RTNL();
+
 	err = __switchdev_handle_fdb_add_to_device(dev, dev, fdb_info,
 						   check_cb,
 						   foreign_dev_check_cb,
@@ -648,7 +650,7 @@ static int __switchdev_handle_fdb_del_to_device(struct net_device *dev,
 	/* Event is neither on a bridge nor a LAG. Check whether it is on an
 	 * interface that is in a bridge with us.
 	 */
-	br = netdev_master_upper_dev_get_rcu(dev);
+	br = netdev_master_upper_dev_get(dev);
 	if (!br || !netif_is_bridge_master(br))
 		return 0;
 
@@ -674,6 +676,8 @@ int switchdev_handle_fdb_del_to_device(struct net_device *dev,
 {
 	int err;
 
+	ASSERT_RTNL();
+
 	err = __switchdev_handle_fdb_del_to_device(dev, dev, fdb_info,
 						   check_cb,
 						   foreign_dev_check_cb,
-- 
2.25.1

