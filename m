Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6B33C5F07
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235457AbhGLPZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:06 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:46304
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232203AbhGLPZD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hS2CrvE6L4d8H3TSpuPVLOmH51y5s2MgJ2hz3F3mHyrS3aJPjaZyu8oOgAIv+J9EZwqK9a8LGlpMZ4LlpOyByIfULG3FmHPFMdocNncNuMAfjVwsovUUlVdsyLdA5/LzQjYNtDOm17rB6eP287nv+TQhpBxcOwAoI2QdeeYY3eWk4EMZEpxBShtWls9MH2zryHZaiL2VPJXODo8OF57NQ/iMlP8DL76hJCiMm2jpPlk8Fi0DcKjWrJ4FqioQ7CUhfAFl0ZRmh3YRPgPredEoIj+rDaTGII8u9vVQLIJ0MipB5JMbnleuHImrn7GYDu+bZ3E3CcUZQR2Ilrx789zGTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQGZqA4YLYAdJOm/W3LrzcL1Llu3tBJ7wawN8JJFNl0=;
 b=h0xaMTEfgl7M/mRRLhdbY9B+L/8/hha1b30q2u56Z4b1ucI1ffp9i800+lwfcJ8mFrANlI/gh5e4l5J7FDAZzuadvs5oB5U2sW7iIUsVQczqm42f0TH/XKuz7/O+m7IDiavGKZ6q7rJ3ztVM+BgMVJhOEJfwcFDHhlA51Mm9WZ8m42gHbXSxBNydXrg38sN0on238dvVYjX/Y+JsSTKIMnx69+EZGv2+1oduDJtMoiU8K7XF/OTZm3VpjU3mBf+TjXYtl9hJEYrogXWV3gbSO+/CGPOTFiAOP9YXagGLtpyBdXoA/IYnwv6V7VyHoLDe+dsz9nLDneHy/0QG6Yarug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQGZqA4YLYAdJOm/W3LrzcL1Llu3tBJ7wawN8JJFNl0=;
 b=mOGXrMWfOZ51fpM8UYk0FlhfkAuSpJVolRUGgvBmUo44XMtWAD7Rx2fPtktrAqZ57tSQzgbEWniB2cVjMS4sT6dx8xWzxn3Ph2jtQBFdjSDXBB7Xl7AyOXdD6XDQ5PIx3432SsjGhTyj5yU8wgRCasjIjS5CXxxvB04AcQay34c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:12 +0000
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
Subject: [RFC PATCH v3 net-next 04/24] net: ocelot: fix switchdev objects synced for wrong netdev with LAG offload
Date:   Mon, 12 Jul 2021 18:21:22 +0300
Message-Id: <20210712152142.800651-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a59790fe-9293-4d8b-f53d-08d94548d272
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6271BBAF78FD1FE64E81C4A4E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dHf7I5VGvQQYwyBBkKlf+J3BSkRtLDRGkyCALTrgw1gCHh10nC9XPHCEVC8rQJ0DceEtUzrc+pfNOzhpUiXGmflo865ywWySd39bZ3GZ+jlIdos+l01jOKAZ7ftHS/Z7UMeXbuqY5Ij/s5z4RDB/BnYaUl/4XWtNFlwOzzOLMknFYu03aFcCDmomt5tNscQEUh4q6s6uT0//DK4sGC/iwtrIJ6BTqwSgGGEULYoQE6cpDWoxDGWGmVCG5GyqkkzBZJ4f0qx4yxiKLDD5dySU9RXZKd9bUICNzDVhqjj8pNz6wSge8E9FYE1nhDH2L0pXDRk3wL6vBVLaMgy+qCfZ8v75SXp61oyjfmqu9azEeDEdWRa/fBn+YJ+hHWpBKVkBN5zhShQd+TlLGPw9s9ixlyodvwZI0+2LxT3M7aMMGDHe/3r7zQ+XUdRW9Yr9Xj1L+dl7KxceylA8F6/ELnBu5iowZqI4Ik+qzkY9meztBa6VTuKEgZ0v1GCQ1ksjjuLiDQfS/sZpiHNxED+TeiEI+lZwTQDb4x4QkjqUsf7TSPBAC3cTnBsa/dO3lpbWzKf+EqoAcslopo77Iv9Pa9MYHG9MtHAPdRVi8GmiZ5fu8kv4QwQIJhnL/fYdEWJ5+TMYewes4lCbnykh5rnHUDzSY18TkwwZwTGCXQzsqj2pLu2SAAC9Ikz86PzyTpkM1XRbZ4z0CNTQAVtPBF6Q8zP5uQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(6666004)(83380400001)(66556008)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3QDNmSwpkO9JwKnxlRsjTpPoRS3tp4BInrjgmC9DSsxQZlH2ne8ecsZlh+aG?=
 =?us-ascii?Q?tQ5nsrf6cVkhnZOFf7E/8yB8W1DXrxJMHikD94Ein+Zl4hhhj3M2LFqC+XH8?=
 =?us-ascii?Q?SrMHhjoenA5klt4J4L+Wz1YjRK70F8E68L2WBmMGgvdrlpxVBcMs6etEMzGy?=
 =?us-ascii?Q?/kqwiFBLPxq6wyG+cxudPaMZW1wqcb0Xm4bJ1xuMLYvnfEGVRu9ph0HGE8Xw?=
 =?us-ascii?Q?+m9KkWOQ+lejfo6Ayi+/WwO+PdtJgU2sg4Qw0jws7PKQjEoLgnZ4sF8qxdTr?=
 =?us-ascii?Q?zCCckP+W2EF85B2BgO6Dl1yaVNXhqGup0nSpgVTPjMrJqGkHQpD+fy3/CUbf?=
 =?us-ascii?Q?P032VjqQsN2CzF0Jm30paA+k6963DPoVwTwqzoLzcsRjLp+V4opB+q9j2CFB?=
 =?us-ascii?Q?j7QcZwPYgcsgmLQg/2rdakM5C9Sac8XJUVTNIZ+r0WTfh2hDodBxDKJWOwtC?=
 =?us-ascii?Q?Lr87T1eCS3MGC2OKU55rmzCZf1WdEjULZXK/ecD7HOEMdsCRF3W9U5b/1jhT?=
 =?us-ascii?Q?jzYjy0SwOAziSF0rPyuI6dr48CMWvLJjFnWDkCurZrsTZDcIv7pMBSM5jZWq?=
 =?us-ascii?Q?vOIGIRiJvP0ib8CQxPyVgGY0iTx6o35wRUEILV5T8Sq6GNNvzJOsu8zPqzcU?=
 =?us-ascii?Q?Wj1d1A4Cy20imqY7UzdlnlXByYPkQ46M98AdV1a8KnAEodzU3WC8w3p+J9Nw?=
 =?us-ascii?Q?7hw4r4WIByPYjRHjRYuuaWw2VxiTvSpIgoa5yN8vFSxNE6e+fipMYjrc/Q8n?=
 =?us-ascii?Q?/ge0ptv7Lg1gs29KRkwWOMop3K03m2tqgo5b6CZ87wuZDrDXrfbHv9gVydk6?=
 =?us-ascii?Q?6ZRIVmjr02JgeuHk9UszuCOFPVdGEoMiyvdlqLwqMx9vQX/GlSIVW73AzDFv?=
 =?us-ascii?Q?FJHMgjMP423HPebt+ricpPeZ7rXc4E04xbN6D4IJh9YxhSumwm6+PaqyIuwe?=
 =?us-ascii?Q?acIGM9uGpVIm2Rvx0NfnOXIScDKZgUKvxhxvsodDi9sWocPYAGIvExmRpEQO?=
 =?us-ascii?Q?WhsLBhQCEKgN2xezdJK4gnye3q1DTg1/KHU/DEbirmjGkM3Ec/pifkpyFRwZ?=
 =?us-ascii?Q?4h4EXDAwDSWaXU5HxIK/CTHcP9WJNj08Rs7pqlbsp4RBeih1UXuH4jXwG3fF?=
 =?us-ascii?Q?5/hbPLH/XCSwZYw9aSqGqueNxXG3k7SS/hx6HzLMbtlcxuXVbgRISAREm0hM?=
 =?us-ascii?Q?7hbvt5sFx3p7dUUHovdaHrbMmucLo2XREC9ySyYoEPRB1N65bwR7YCq37cuE?=
 =?us-ascii?Q?l6saR04HFOw9SHsuaxJIyj8RrtUB0pnhI3VG7iVOQXOQuv36H4jtJJGxaMVo?=
 =?us-ascii?Q?u2Q0RMeoJ7PDui5xSCN7xzRu?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a59790fe-9293-4d8b-f53d-08d94548d272
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:12.1876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 23Skls0cf9MazAKJdKfeuxRiX3C+vpqkeGIpsVyW2V9IvPL5JXU68th+E1hX+pTUXDyrDY0QghQj1qmLvdN/Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The point with a *dev and a *brport_dev is that when we have a LAG net
device that is a bridge port, *dev is an ocelot net device and
*brport_dev is the bonding/team net device. The ocelot net device
beneath the LAG does not exist from the bridge's perspective, so we need
to sync the switchdev objects belonging to the brport_dev and not to the
dev.

Fixes: e4bd44e89dcf ("net: ocelot: replay switchdev events when joining bridge")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 3e89e34f86d5..e9d260d84bf3 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1298,6 +1298,7 @@ static int ocelot_netdevice_lag_leave(struct net_device *dev,
 }
 
 static int ocelot_netdevice_changeupper(struct net_device *dev,
+					struct net_device *brport_dev,
 					struct netdev_notifier_changeupper_info *info)
 {
 	struct netlink_ext_ack *extack;
@@ -1307,11 +1308,11 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 
 	if (netif_is_bridge_master(info->upper_dev)) {
 		if (info->linking)
-			err = ocelot_netdevice_bridge_join(dev, dev,
+			err = ocelot_netdevice_bridge_join(dev, brport_dev,
 							   info->upper_dev,
 							   extack);
 		else
-			err = ocelot_netdevice_bridge_leave(dev, dev,
+			err = ocelot_netdevice_bridge_leave(dev, brport_dev,
 							    info->upper_dev);
 	}
 	if (netif_is_lag_master(info->upper_dev)) {
@@ -1346,7 +1347,7 @@ ocelot_netdevice_lag_changeupper(struct net_device *dev,
 		if (ocelot_port->bond != dev)
 			return NOTIFY_OK;
 
-		err = ocelot_netdevice_changeupper(lower, info);
+		err = ocelot_netdevice_changeupper(lower, dev, info);
 		if (err)
 			return notifier_from_errno(err);
 	}
@@ -1385,7 +1386,7 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 		struct netdev_notifier_changeupper_info *info = ptr;
 
 		if (ocelot_netdevice_dev_check(dev))
-			return ocelot_netdevice_changeupper(dev, info);
+			return ocelot_netdevice_changeupper(dev, dev, info);
 
 		if (netif_is_lag_master(dev))
 			return ocelot_netdevice_lag_changeupper(dev, info);
-- 
2.25.1

