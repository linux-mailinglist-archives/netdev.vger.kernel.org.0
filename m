Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B6A3F1D77
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbhHSQIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:08:43 -0400
Received: from mail-am6eur05on2045.outbound.protection.outlook.com ([40.107.22.45]:64993
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233785AbhHSQIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 12:08:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iYqS9aMs+Y7rRC8VzbCCV1D19c/neATKDb7UnAne8JOI0nEpr4Y+khTeOVr5Vw7ARAaDyFC1jKFnoxNSzUzdAcMnC0eWC/cNLckKQNatRI09+dx73AhMsxYBoJK2xrY1E7ddDG3uZCiyG8CUDRf9GDQIS58GedEEmiQu/R4vpAH/xyR2+8hSicxuQl8wwVD5r2/dePUEAqTafvkou1NOIdym4S24P/yabOUPQOjlw1aZKPN7K8oIJ+4p/o0j7ihhJhw9GiUoZD0QQvM9CLWuIY9L9R2LDuRRUz2TZLvi5QhhNrJRoODgkUiqR0MWhugfO1gB2vtXkEahK0HmpCaULw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vfb+FcZ3Yp7jafJtQn3tzPAK7pmCYHjTtxOx6skGsik=;
 b=Uc7o71lABcvhlLSBnYXNZZaVb2pTceLVrrcsx6/e+LBF/RRT3DxRrVSKnxCKszktB/8lYz0VAX00gWMu2DlOy9IElxQ73x3YfDnBCtc1h2kzoO2DjvBc/YXXtHdAr8rLswcACh/zKnGLKLGxv06Yup2hwUAlJcFTVtXtXNEcBjr0flSAj5A6qkIO3q/dDutGuooVYxWnBEA46w3Lk6PZZY+k5+SBcF2lwuJRuXeKhao0wVvFZ41JwC7xgod+8SnoWLK/pQ2K6UNxUDA9mMXZkLNCz2Veg6S9vM/j8OrR8n7zxjzgh4kgqfTJ7IM85v7UHBS2mW4OylBQ2kZGn2n9Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vfb+FcZ3Yp7jafJtQn3tzPAK7pmCYHjTtxOx6skGsik=;
 b=RpKPAu8euEKIkdbZSQJEcQK5fFInpJRff61QXNTroq3+FuUCIoH64bEbs5nLen9jlUVbgwQ+HkiU8ukbjRwblyYBT9IXpujfVFQxBy9vykk8RAtws7rbzl3ePVUsMiupTRO/AaLncHRggrQYm1Zamxv0plr9y2GhU0YHj0bgfUs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6269.eurprd04.prod.outlook.com (2603:10a6:803:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 16:07:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 16:07:52 +0000
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
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH v2 net-next 1/5] net: switchdev: move SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE to the blocking notifier chain
Date:   Thu, 19 Aug 2021 19:07:19 +0300
Message-Id: <20210819160723.2186424-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0004.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM8P189CA0004.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 16:07:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21b24734-a4f4-4e01-92f0-08d9632b7f2e
X-MS-TrafficTypeDiagnostic: VI1PR04MB6269:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6269BF91B5706F18096656CCE0C09@VI1PR04MB6269.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c+/7hCW1V2sGR9SLxd0w1bUTd6O63HyU80GyjD6qb87a9hc4zsHENndnuE/k88uxZ0ShiXorrIUL2hyayRCgoTHzNdizLUCeADjnYVWVETVBbT2M25+Rhel0ooaGiwmKE4EzQDuC+FYfNxagisO5nNLqaZEnKpI8infU+XujwT9HZ59VWYzV9t/dYOr645qKf237ASsmGb/fM52XaA5XbRG/Sys4oDw6vAfIrOQyGFi+1jdHuvc/YMO93S0vO5aBCaXK2Jlt6Sgz6LfPcCjRi+VBj2f6gZhe/YcyhJ8pqIVq9XwHGCgtZc0dV3RdbaT6ixZY6czSYMzuVbvpu/YMypPst1nvjvVbhg4MeAbtuk5ICaNf7xQ46TkvhbmdOLlNmKgPK4RAvizz0Jkccwu012JbXSs07fATIEvTKp69s6gTuMsRYlb+uSFSWXQTU99aJxDO5eVZOWsYrTAOru2tGj7t41YLnEdMWvLpH3R7NyZqFv5Fyif7hBnD4O/LyQX0v34WBlgClRBrVrt1hN0d8XCtrGc44Ly8SduBcQfmEMFdIJMjm3YByd+9wZ71EkgFwJn7C4hta9JwPVtdB7fJmwKQTL5iJaiQXr7NVZXi5yfG9faH0uqKeYRIpwBFJc4wmksJ1Nkn86BUtKT4FPMjOibzjrdsv4dYVwHUU9n+/W3tfgz93ZrDSfZ7rWuL6u4c00TT6LF+R5JED39UrX/DLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(7406005)(2616005)(26005)(6486002)(38350700002)(5660300002)(38100700002)(7416002)(4326008)(8676002)(316002)(54906003)(110136005)(6512007)(6506007)(6666004)(478600001)(44832011)(186003)(1076003)(8936002)(956004)(66476007)(30864003)(52116002)(2906002)(83380400001)(36756003)(86362001)(66946007)(66556008)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HRybHgPgMdrnC3iNeupAmBWT6q+7mJvklOSTzuitvySgxnNWpD7WBdKXQlZj?=
 =?us-ascii?Q?gwDoAqYKaz6w+1gSm8yiEgOZX0T7xvvtqbo1wuMmXJW1sNBu9x+x7v0jPY3V?=
 =?us-ascii?Q?WRXUphJLW/TlJj2TovnWrwXE9fAtafm1ms/lXmE4Fh0Mj8y9+kJC6z4abmHU?=
 =?us-ascii?Q?yqzqxXdwBaN19hE8BE97D2XjRQ4QOfYsQ32x1gicBtn6QBbPMUbICpMxNBmT?=
 =?us-ascii?Q?orjJC5BfAmGyq+V0LBS50yUpNt7urFbupqO1fIVPPPH/4tayU9hBdIKonzKO?=
 =?us-ascii?Q?F+Sq7pdMP9Os2f9f+0jnOJTWZDG8muTkdelslb3H1lCLDnPX2341MYyg5KJ3?=
 =?us-ascii?Q?O2m3fVvaNeF7vdFMDfTp9CaNSHHfq+RvFvJYS7PuNvaKxLanaSYnKKyRCeD1?=
 =?us-ascii?Q?4dPsvrWf4LvZssPAkQ9L7EYsdRVdx4LH4VOCtHUsbUaquU8G+q5Eq1icoTqd?=
 =?us-ascii?Q?lPwfHNrh93AFaGSvb51PTQq9i+BfuLxqpTPcY5pBob1Mh0Y22kxsSu2/QY8e?=
 =?us-ascii?Q?67m6NyeLHsq4jI1x1/+prOEaty6tJOQJZKGqhurPz+D6OB289fKpZxGzCNqC?=
 =?us-ascii?Q?i5oUaj1ZuajammGsGBFCLepVkIxNMhoCd83PyN9A69j+KUhhKRVRk8Yu6EJ4?=
 =?us-ascii?Q?1VJedwyi0E4crh8pHWMh5mMqt67yzmzkQRhKpcRILkbLq2ihEErmlH1wpx3x?=
 =?us-ascii?Q?giYoRgPuF9Pwcz3IsiDKykO+90hAwu+wqPSgXRJeonvO5DSUipZnQeMC17da?=
 =?us-ascii?Q?CxBd5t1lV1CxTdhOCw3C+i5Oaq0zgjju3RVCIz06V8nWmYLAQRVnBFFZw94/?=
 =?us-ascii?Q?jPYk1/t58I6noezkcvXNwLWQfPr24LhdOL28ki4gfA5/VIgiZvvy1a9LeNnC?=
 =?us-ascii?Q?UT+uh8S0EJyn6kIGtbydmRXRD1CBuQwfWj60XIyvqDA6lqnzGFdga2np5SrB?=
 =?us-ascii?Q?XWaLBpgLzLnlt5niRwCN+1KWoPHOoJ6tTi4yRpjkQdwzwC4XUXVnnJ3alfPR?=
 =?us-ascii?Q?G2Q8swPyk3cy6KFRumowQziE5p4tjWhJqfizJLMz6eLpDBdVX8GeZwnsG/vs?=
 =?us-ascii?Q?Gsp66/F3G3xPIb4lYqdA8oKucgzCEWorwJy5QwBWVJWdbXsKRrd/gF5kNFjJ?=
 =?us-ascii?Q?BPzg1loeURKN3asrJxWD2V3NfLSh2scP8ZupJZnLBKTvWKuueUkV72x3JDjF?=
 =?us-ascii?Q?vLOIvWN1R6GT7yqoNwscp6UgFy9tjxB+IfBDnbjjbtS/pCtt+iaRnhOqopFD?=
 =?us-ascii?Q?PMIxPRTb+ESD+aX8ukCkCPS1QhNqEYKomONRiBRihUbcpdXucZKWFhZyW1q8?=
 =?us-ascii?Q?tOa+Wv/qBssINNbOkeS2Mm79?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b24734-a4f4-4e01-92f0-08d9632b7f2e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 16:07:52.4644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HLiYcAAl4s5mwdsZpmrFBspy6AQeblC1Frfqk2EABduRrVcXp9dh2GQZyxUWcEmpAE0g+X97y5O1lz4fLULV0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, br_switchdev_fdb_notify() uses call_switchdev_notifiers (and
br_fdb_replay() open-codes the same thing). This means that drivers
handle the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE events on the atomic
switchdev notifier block.

Most existing switchdev drivers either talk to firmware, or to a device
over a bus where the I/O is sleepable (SPI, I2C, MDIO etc). So there
exists an (anti)pattern where drivers make a sleepable context for
offloading the given FDB entry by registering an ordered workqueue and
scheduling work items on it, and doing all the work from there.

The problem is the inherent limitation that this design imposes upon
what a switchdev driver can do with those FDB entries.

For example, a switchdev driver might want to perform FDB isolation,
i.e. associate each FDB entry with the bridge it belongs to. Maybe the
driver associates each bridge with a number, allocating that number when
the first port of the driver joins that bridge, and freeing it when the
last port leaves it.

And this is where the problem is. When user space deletes a bridge and
all the ports leave, the bridge will notify us of the deletion of all
FDB entries in atomic context, and switchdev drivers will schedule their
private work items on their private workqueue.

The FDB entry deletion notifications will succeed, the bridge will then
finish deleting itself, but the switchdev work items have not run yet.
When they will eventually get scheduled, the aforementioned association
between the bridge_dev and a number will have already been broken by the
switchdev driver. All ports are standalone now, the bridge is a foreign
interface!

One might say "why don't you cache all your associations while you're
still in the atomic context and they're still valid, pass them by value
through your switchdev_work and work with the cached values as opposed
to the current ones?"

This option smells of poor design, because instead of fixing a central
problem, we add tens of lateral workarounds to avoid it. It should be
easier to use switchdev, not harder, and we should look at the common
patterns which lead to code duplication and eliminate them.

In this case, we must notice that
(a) switchdev already has the concept of notifiers emitted from the fast
    path that are still processed by drivers from blocking context. This
    is accomplished through the SWITCHDEV_F_DEFER flag which is used by
    e.g. SWITCHDEV_OBJ_ID_HOST_MDB.
(b) the bridge del_nbp() function already calls switchdev_deferred_process().
    So if we could hook into that, we could have a chance that the
    bridge simply waits for our FDB entry offloading procedure to finish
    before it calls netdev_upper_dev_unlink() - which is almost
    immediately afterwards, and also when switchdev drivers typically
    break their stateful associations between the bridge upper and
    private data.

So it is in fact possible to use switchdev's generic
switchdev_deferred_enqueue mechanism to get a sleepable callback, and
from there we can call_switchdev_blocking_notifiers().

In the case of br_fdb_replay(), the only code path is from
switchdev_bridge_port_offload(), which is already in blocking context.
So we don't need to go through switchdev_deferred_enqueue, and we can
just call the blocking notifier block directly.

To preserve the same behavior as before, all drivers need to have their
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handlers moved from their switchdev
atomic notifier blocks to the blocking ones. This patch attempts to make
that trivial movement. Note that now they might schedule a work item for
nothing (since they are now called from a work item themselves), but I
don't have the energy or hardware to test all of them, so this will have
to do.

Note that previously, we were under rcu_read_lock() but now we're not.
I have eyeballed the drivers that make any sort of RCU assumption and
for the most part, enclosed them between a private pair of
rcu_read_lock() and rcu_read_unlock(). The exception is
qeth_l2_switchdev_event, for which adding the rcu_read_lock and properly
calling rcu_read_unlock from all places that return would result in more
churn than what I am about to do. This function had an apparently bogus
comment "Called under rtnl_lock", but to me this is not quite possible,
since this is the handler function from register_switchdev_notifier
which is on an atomic chain. But anyway, after the rework we _are_ under
rtnl_mutex, so just drop the _rcu from the functions used by the qeth
driver.

The RCU protection can be dropped from the other drivers when they are
reworked to stop scheduling.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  84 +++++++-------
 .../marvell/prestera/prestera_switchdev.c     | 104 +++++++++---------
 .../mellanox/mlx5/core/en/rep/bridge.c        |  59 +++++++++-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  57 +++++++++-
 .../microchip/sparx5/sparx5_switchdev.c       |  74 +++++++------
 drivers/net/ethernet/rocker/rocker_main.c     |  73 ++++++------
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  57 +++++-----
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  60 +++++-----
 drivers/s390/net/qeth_l2_main.c               |  10 +-
 include/net/switchdev.h                       |  25 ++++-
 net/bridge/br_fdb.c                           |   2 +
 net/bridge/br_switchdev.c                     |  10 +-
 net/dsa/slave.c                               |  32 +++---
 net/switchdev/switchdev.c                     |  47 ++++++++
 14 files changed, 447 insertions(+), 247 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index d260993ab2dc..5de475927958 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2254,52 +2254,11 @@ static int dpaa2_switch_port_event(struct notifier_block *nb,
 				   unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
-	struct ethsw_port_priv *port_priv = netdev_priv(dev);
-	struct ethsw_switchdev_event_work *switchdev_work;
-	struct switchdev_notifier_fdb_info *fdb_info = ptr;
-	struct ethsw_core *ethsw = port_priv->ethsw_data;
 
 	if (event == SWITCHDEV_PORT_ATTR_SET)
 		return dpaa2_switch_port_attr_set_event(dev, ptr);
 
-	if (!dpaa2_switch_port_dev_check(dev))
-		return NOTIFY_DONE;
-
-	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
-	if (!switchdev_work)
-		return NOTIFY_BAD;
-
-	INIT_WORK(&switchdev_work->work, dpaa2_switch_event_work);
-	switchdev_work->dev = dev;
-	switchdev_work->event = event;
-
-	switch (event) {
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		memcpy(&switchdev_work->fdb_info, ptr,
-		       sizeof(switchdev_work->fdb_info));
-		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-		if (!switchdev_work->fdb_info.addr)
-			goto err_addr_alloc;
-
-		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
-				fdb_info->addr);
-
-		/* Take a reference on the device to avoid being freed. */
-		dev_hold(dev);
-		break;
-	default:
-		kfree(switchdev_work);
-		return NOTIFY_DONE;
-	}
-
-	queue_work(ethsw->workqueue, &switchdev_work->work);
-
 	return NOTIFY_DONE;
-
-err_addr_alloc:
-	kfree(switchdev_work);
-	return NOTIFY_BAD;
 }
 
 static int dpaa2_switch_port_obj_event(unsigned long event,
@@ -2324,6 +2283,46 @@ static int dpaa2_switch_port_obj_event(unsigned long event,
 	return notifier_from_errno(err);
 }
 
+static int dpaa2_switch_fdb_event(unsigned long event,
+				  struct net_device *dev,
+				  struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct ethsw_port_priv *port_priv = netdev_priv(dev);
+	struct ethsw_switchdev_event_work *switchdev_work;
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+
+	if (!dpaa2_switch_port_dev_check(dev))
+		return NOTIFY_DONE;
+
+	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+	if (!switchdev_work)
+		return NOTIFY_BAD;
+
+	INIT_WORK(&switchdev_work->work, dpaa2_switch_event_work);
+	switchdev_work->dev = dev;
+	switchdev_work->event = event;
+
+	memcpy(&switchdev_work->fdb_info, fdb_info,
+	       sizeof(switchdev_work->fdb_info));
+	switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+	if (!switchdev_work->fdb_info.addr)
+		goto err_addr_alloc;
+
+	ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
+			fdb_info->addr);
+
+	/* Take a reference on the device to avoid being freed. */
+	dev_hold(dev);
+
+	queue_work(ethsw->workqueue, &switchdev_work->work);
+
+	return NOTIFY_DONE;
+
+err_addr_alloc:
+	kfree(switchdev_work);
+	return NOTIFY_BAD;
+}
+
 static int dpaa2_switch_port_blocking_event(struct notifier_block *nb,
 					    unsigned long event, void *ptr)
 {
@@ -2335,6 +2334,9 @@ static int dpaa2_switch_port_blocking_event(struct notifier_block *nb,
 		return dpaa2_switch_port_obj_event(event, dev, ptr);
 	case SWITCHDEV_PORT_ATTR_SET:
 		return dpaa2_switch_port_attr_set_event(dev, ptr);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		return dpaa2_switch_fdb_event(event, dev, ptr);
 	}
 
 	return NOTIFY_DONE;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 3ce6ccd0f539..9b8847aa3b92 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -845,10 +845,6 @@ static int prestera_switchdev_event(struct notifier_block *unused,
 				    unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
-	struct switchdev_notifier_fdb_info *fdb_info;
-	struct switchdev_notifier_info *info = ptr;
-	struct prestera_fdb_event_work *swdev_work;
-	struct net_device *upper;
 	int err;
 
 	if (event == SWITCHDEV_PORT_ATTR_SET) {
@@ -858,54 +854,7 @@ static int prestera_switchdev_event(struct notifier_block *unused,
 		return notifier_from_errno(err);
 	}
 
-	if (!prestera_netdev_check(dev))
-		return NOTIFY_DONE;
-
-	upper = netdev_master_upper_dev_get_rcu(dev);
-	if (!upper)
-		return NOTIFY_DONE;
-
-	if (!netif_is_bridge_master(upper))
-		return NOTIFY_DONE;
-
-	swdev_work = kzalloc(sizeof(*swdev_work), GFP_ATOMIC);
-	if (!swdev_work)
-		return NOTIFY_BAD;
-
-	swdev_work->event = event;
-	swdev_work->dev = dev;
-
-	switch (event) {
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		fdb_info = container_of(info,
-					struct switchdev_notifier_fdb_info,
-					info);
-
-		INIT_WORK(&swdev_work->work, prestera_fdb_event_work);
-		memcpy(&swdev_work->fdb_info, ptr,
-		       sizeof(swdev_work->fdb_info));
-
-		swdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-		if (!swdev_work->fdb_info.addr)
-			goto out_bad;
-
-		ether_addr_copy((u8 *)swdev_work->fdb_info.addr,
-				fdb_info->addr);
-		dev_hold(dev);
-		break;
-
-	default:
-		kfree(swdev_work);
-		return NOTIFY_DONE;
-	}
-
-	queue_work(swdev_wq, &swdev_work->work);
 	return NOTIFY_DONE;
-
-out_bad:
-	kfree(swdev_work);
-	return NOTIFY_BAD;
 }
 
 static int
@@ -1101,6 +1050,53 @@ static int prestera_port_obj_del(struct net_device *dev, const void *ctx,
 	}
 }
 
+static int prestera_switchdev_fdb_event(struct net_device *dev,
+					unsigned long event,
+					struct switchdev_notifier_info *info)
+{
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct prestera_fdb_event_work *swdev_work;
+	struct net_device *upper;
+
+	if (!prestera_netdev_check(dev))
+		return 0;
+
+	upper = netdev_master_upper_dev_get_rcu(dev);
+	if (!upper)
+		return 0;
+
+	if (!netif_is_bridge_master(upper))
+		return 0;
+
+	swdev_work = kzalloc(sizeof(*swdev_work), GFP_ATOMIC);
+	if (!swdev_work)
+		return -ENOMEM;
+
+	swdev_work->event = event;
+	swdev_work->dev = dev;
+
+	fdb_info = container_of(info, struct switchdev_notifier_fdb_info,
+				info);
+
+	INIT_WORK(&swdev_work->work, prestera_fdb_event_work);
+	memcpy(&swdev_work->fdb_info, fdb_info, sizeof(swdev_work->fdb_info));
+
+	swdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+	if (!swdev_work->fdb_info.addr)
+		goto out_bad;
+
+	ether_addr_copy((u8 *)swdev_work->fdb_info.addr,
+			fdb_info->addr);
+	dev_hold(dev);
+
+	queue_work(swdev_wq, &swdev_work->work);
+	return 0;
+
+out_bad:
+	kfree(swdev_work);
+	return -ENOMEM;
+}
+
 static int prestera_switchdev_blk_event(struct notifier_block *unused,
 					unsigned long event, void *ptr)
 {
@@ -1123,6 +1119,12 @@ static int prestera_switchdev_blk_event(struct notifier_block *unused,
 						     prestera_netdev_check,
 						     prestera_port_obj_attr_set);
 		break;
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		rcu_read_lock();
+		err = prestera_switchdev_fdb_event(dev, event, ptr);
+		rcu_read_unlock();
+		break;
 	default:
 		err = -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 0c38c2e319be..ea7c3f07f6fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -276,6 +276,55 @@ mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
 	return err;
 }
 
+static struct mlx5_bridge_switchdev_fdb_work *
+mlx5_esw_bridge_init_switchdev_fdb_work(struct net_device *dev, bool add,
+					struct switchdev_notifier_fdb_info *fdb_info,
+					struct mlx5_esw_bridge_offloads *br_offloads);
+
+static int
+mlx5_esw_bridge_fdb_event(struct net_device *dev, unsigned long event,
+			  struct switchdev_notifier_info *info,
+			  struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct mlx5_bridge_switchdev_fdb_work *work;
+	struct mlx5_eswitch *esw = br_offloads->esw;
+	u16 vport_num, esw_owner_vhca_id;
+	struct net_device *upper, *rep;
+
+	upper = netdev_master_upper_dev_get_rcu(dev);
+	if (!upper)
+		return 0;
+	if (!netif_is_bridge_master(upper))
+		return 0;
+
+	rep = mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, esw,
+							&vport_num,
+							&esw_owner_vhca_id);
+	if (!rep)
+		return 0;
+
+	/* only handle the event on peers */
+	if (mlx5_esw_bridge_is_local(dev, rep, esw))
+		return 0;
+
+	fdb_info = container_of(info, struct switchdev_notifier_fdb_info, info);
+
+	work = mlx5_esw_bridge_init_switchdev_fdb_work(dev,
+						       event == SWITCHDEV_FDB_ADD_TO_DEVICE,
+						       fdb_info,
+						       br_offloads);
+	if (IS_ERR(work)) {
+		WARN_ONCE(1, "Failed to init switchdev work, err=%ld",
+			  PTR_ERR(work));
+		return PTR_ERR(work);
+	}
+
+	queue_work(br_offloads->wq, &work->work);
+
+	return 0;
+}
+
 static int mlx5_esw_bridge_event_blocking(struct notifier_block *nb,
 					  unsigned long event, void *ptr)
 {
@@ -295,6 +344,12 @@ static int mlx5_esw_bridge_event_blocking(struct notifier_block *nb,
 	case SWITCHDEV_PORT_ATTR_SET:
 		err = mlx5_esw_bridge_port_obj_attr_set(dev, ptr, br_offloads);
 		break;
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		rcu_read_lock();
+		err = mlx5_esw_bridge_fdb_event(dev, event, ptr, br_offloads);
+		rcu_read_unlock();
+		break;
 	default:
 		err = 0;
 	}
@@ -415,9 +470,7 @@ static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
 		/* only handle the event on peers */
 		if (mlx5_esw_bridge_is_local(dev, rep, esw))
 			break;
-		fallthrough;
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+
 		fdb_info = container_of(info,
 					struct switchdev_notifier_fdb_info,
 					info);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 22fede5cb32c..791a165fe3aa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -3247,8 +3247,6 @@ static int mlxsw_sp_switchdev_event(struct notifier_block *unused,
 	switchdev_work->event = event;
 
 	switch (event) {
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
 	case SWITCHDEV_FDB_DEL_TO_BRIDGE:
 		fdb_info = container_of(info,
@@ -3513,6 +3511,55 @@ mlxsw_sp_switchdev_handle_vxlan_obj_del(struct net_device *vxlan_dev,
 	}
 }
 
+static int mlxsw_sp_switchdev_fdb_event(struct net_device *dev, unsigned long event,
+					struct switchdev_notifier_info *info)
+{
+	struct mlxsw_sp_switchdev_event_work *switchdev_work;
+	struct switchdev_notifier_fdb_info *fdb_info;
+	struct net_device *br_dev;
+
+	/* Tunnel devices are not our uppers, so check their master instead */
+	br_dev = netdev_master_upper_dev_get_rcu(dev);
+	if (!br_dev)
+		return 0;
+	if (!netif_is_bridge_master(br_dev))
+		return 0;
+	if (!mlxsw_sp_port_dev_lower_find_rcu(br_dev))
+		return 0;
+
+	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+	if (!switchdev_work)
+		return -ENOMEM;
+
+	switchdev_work->dev = dev;
+	switchdev_work->event = event;
+
+	fdb_info = container_of(info, struct switchdev_notifier_fdb_info,
+				info);
+	INIT_WORK(&switchdev_work->work,
+		  mlxsw_sp_switchdev_bridge_fdb_event_work);
+	memcpy(&switchdev_work->fdb_info, fdb_info,
+	       sizeof(switchdev_work->fdb_info));
+	switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+	if (!switchdev_work->fdb_info.addr)
+		goto err_addr_alloc;
+	ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
+			fdb_info->addr);
+	/* Take a reference on the device. This can be either
+	 * upper device containig mlxsw_sp_port or just a
+	 * mlxsw_sp_port
+	 */
+	dev_hold(dev);
+
+	mlxsw_core_schedule_work(&switchdev_work->work);
+
+	return 0;
+
+err_addr_alloc:
+	kfree(switchdev_work);
+	return NOTIFY_BAD;
+}
+
 static int mlxsw_sp_switchdev_blocking_event(struct notifier_block *unused,
 					     unsigned long event, void *ptr)
 {
@@ -3541,6 +3588,12 @@ static int mlxsw_sp_switchdev_blocking_event(struct notifier_block *unused,
 						     mlxsw_sp_port_dev_check,
 						     mlxsw_sp_port_attr_set);
 		return notifier_from_errno(err);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		rcu_read_lock();
+		err = mlxsw_sp_switchdev_fdb_event(dev, event, ptr);
+		rcu_read_unlock();
+		return notifier_from_errno(err);
 	}
 
 	return NOTIFY_DONE;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
index 649ca609884a..7fb9f59d43e0 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -268,9 +268,6 @@ static int sparx5_switchdev_event(struct notifier_block *unused,
 				  unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
-	struct sparx5_switchdev_event_work *switchdev_work;
-	struct switchdev_notifier_fdb_info *fdb_info;
-	struct switchdev_notifier_info *info = ptr;
 	int err;
 
 	switch (event) {
@@ -279,39 +276,9 @@ static int sparx5_switchdev_event(struct notifier_block *unused,
 						     sparx5_netdevice_check,
 						     sparx5_port_attr_set);
 		return notifier_from_errno(err);
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		fallthrough;
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
-		if (!switchdev_work)
-			return NOTIFY_BAD;
-
-		switchdev_work->dev = dev;
-		switchdev_work->event = event;
-
-		fdb_info = container_of(info,
-					struct switchdev_notifier_fdb_info,
-					info);
-		INIT_WORK(&switchdev_work->work,
-			  sparx5_switchdev_bridge_fdb_event_work);
-		memcpy(&switchdev_work->fdb_info, ptr,
-		       sizeof(switchdev_work->fdb_info));
-		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-		if (!switchdev_work->fdb_info.addr)
-			goto err_addr_alloc;
-
-		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
-				fdb_info->addr);
-		dev_hold(dev);
-
-		sparx5_schedule_work(&switchdev_work->work);
-		break;
 	}
 
 	return NOTIFY_DONE;
-err_addr_alloc:
-	kfree(switchdev_work);
-	return NOTIFY_BAD;
 }
 
 static void sparx5_sync_port_dev_addr(struct sparx5 *sparx5,
@@ -459,6 +426,43 @@ static int sparx5_handle_port_obj_del(struct net_device *dev,
 	return err;
 }
 
+static int sparx5_switchdev_fdb_event(struct net_device *dev, unsigned long event,
+				      struct switchdev_notifier_info *info)
+{
+	struct sparx5_switchdev_event_work *switchdev_work;
+	struct switchdev_notifier_fdb_info *fdb_info;
+
+	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+	if (!switchdev_work)
+		return -ENOMEM;
+
+	switchdev_work->dev = dev;
+	switchdev_work->event = event;
+
+	fdb_info = container_of(info,
+				struct switchdev_notifier_fdb_info,
+				info);
+	INIT_WORK(&switchdev_work->work,
+		  sparx5_switchdev_bridge_fdb_event_work);
+	memcpy(&switchdev_work->fdb_info, fdb_info,
+	       sizeof(switchdev_work->fdb_info));
+	switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+	if (!switchdev_work->fdb_info.addr)
+		goto err_addr_alloc;
+
+	ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
+			fdb_info->addr);
+	dev_hold(dev);
+
+	sparx5_schedule_work(&switchdev_work->work);
+
+	return 0;
+
+err_addr_alloc:
+	kfree(switchdev_work);
+	return -ENOMEM;
+}
+
 static int sparx5_switchdev_blocking_event(struct notifier_block *nb,
 					   unsigned long event,
 					   void *ptr)
@@ -478,6 +482,10 @@ static int sparx5_switchdev_blocking_event(struct notifier_block *nb,
 						     sparx5_netdevice_check,
 						     sparx5_port_attr_set);
 		return notifier_from_errno(err);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		err = sparx5_switchdev_fdb_event(dev, event, ptr);
+		return notifier_from_errno(err);
 	}
 
 	return NOTIFY_DONE;
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 3364b6a56bd1..0d998b28bb90 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2767,9 +2767,6 @@ static int rocker_switchdev_event(struct notifier_block *unused,
 				  unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
-	struct rocker_switchdev_event_work *switchdev_work;
-	struct switchdev_notifier_fdb_info *fdb_info = ptr;
-	struct rocker_port *rocker_port;
 
 	if (!rocker_port_dev_check(dev))
 		return NOTIFY_DONE;
@@ -2777,38 +2774,6 @@ static int rocker_switchdev_event(struct notifier_block *unused,
 	if (event == SWITCHDEV_PORT_ATTR_SET)
 		return rocker_switchdev_port_attr_set_event(dev, ptr);
 
-	rocker_port = netdev_priv(dev);
-	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
-	if (WARN_ON(!switchdev_work))
-		return NOTIFY_BAD;
-
-	INIT_WORK(&switchdev_work->work, rocker_switchdev_event_work);
-	switchdev_work->rocker_port = rocker_port;
-	switchdev_work->event = event;
-
-	switch (event) {
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		memcpy(&switchdev_work->fdb_info, ptr,
-		       sizeof(switchdev_work->fdb_info));
-		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-		if (unlikely(!switchdev_work->fdb_info.addr)) {
-			kfree(switchdev_work);
-			return NOTIFY_BAD;
-		}
-
-		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
-				fdb_info->addr);
-		/* Take a reference on the rocker device */
-		dev_hold(dev);
-		break;
-	default:
-		kfree(switchdev_work);
-		return NOTIFY_DONE;
-	}
-
-	queue_work(rocker_port->rocker->rocker_owq,
-		   &switchdev_work->work);
 	return NOTIFY_DONE;
 }
 
@@ -2831,6 +2796,41 @@ rocker_switchdev_port_obj_event(unsigned long event, struct net_device *netdev,
 	return notifier_from_errno(err);
 }
 
+static int
+rocker_switchdev_fdb_event(unsigned long event, struct net_device *dev,
+			   struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct rocker_switchdev_event_work *switchdev_work;
+	struct rocker_port *rocker_port;
+
+	rocker_port = netdev_priv(dev);
+	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+	if (WARN_ON(!switchdev_work))
+		return NOTIFY_BAD;
+
+	INIT_WORK(&switchdev_work->work, rocker_switchdev_event_work);
+	switchdev_work->rocker_port = rocker_port;
+	switchdev_work->event = event;
+
+	memcpy(&switchdev_work->fdb_info, fdb_info,
+	       sizeof(switchdev_work->fdb_info));
+	switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+	if (unlikely(!switchdev_work->fdb_info.addr)) {
+		kfree(switchdev_work);
+		return NOTIFY_BAD;
+	}
+
+	ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
+			fdb_info->addr);
+	/* Take a reference on the rocker device */
+	dev_hold(dev);
+
+	queue_work(rocker_port->rocker->rocker_owq,
+		   &switchdev_work->work);
+
+	return NOTIFY_DONE;
+}
+
 static int rocker_switchdev_blocking_event(struct notifier_block *unused,
 					   unsigned long event, void *ptr)
 {
@@ -2845,6 +2845,9 @@ static int rocker_switchdev_blocking_event(struct notifier_block *unused,
 		return rocker_switchdev_port_obj_event(event, dev, ptr);
 	case SWITCHDEV_PORT_ATTR_SET:
 		return rocker_switchdev_port_attr_set_event(dev, ptr);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		return rocker_switchdev_fdb_event(event, dev, ptr);
 	}
 
 	return NOTIFY_DONE;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
index 599708a3e81d..7282001c85e6 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
@@ -424,9 +424,6 @@ static int am65_cpsw_switchdev_event(struct notifier_block *unused,
 				     unsigned long event, void *ptr)
 {
 	struct net_device *ndev = switchdev_notifier_info_to_dev(ptr);
-	struct am65_cpsw_switchdev_event_work *switchdev_work;
-	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
-	struct switchdev_notifier_fdb_info *fdb_info = ptr;
 	int err;
 
 	if (event == SWITCHDEV_PORT_ATTR_SET) {
@@ -436,47 +433,49 @@ static int am65_cpsw_switchdev_event(struct notifier_block *unused,
 		return notifier_from_errno(err);
 	}
 
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block cpsw_switchdev_notifier = {
+	.notifier_call = am65_cpsw_switchdev_event,
+};
+
+static int am65_cpsw_switchdev_fdb_event(struct net_device *ndev,
+					 unsigned long event,
+					 struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct am65_cpsw_switchdev_event_work *switchdev_work;
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
+
 	if (!am65_cpsw_port_dev_check(ndev))
-		return NOTIFY_DONE;
+		return 0;
 
 	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 	if (WARN_ON(!switchdev_work))
-		return NOTIFY_BAD;
+		return -ENOMEM;
 
 	INIT_WORK(&switchdev_work->work, am65_cpsw_switchdev_event_work);
 	switchdev_work->port = port;
 	switchdev_work->event = event;
 
-	switch (event) {
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		memcpy(&switchdev_work->fdb_info, ptr,
-		       sizeof(switchdev_work->fdb_info));
-		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-		if (!switchdev_work->fdb_info.addr)
-			goto err_addr_alloc;
-		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
-				fdb_info->addr);
-		dev_hold(ndev);
-		break;
-	default:
-		kfree(switchdev_work);
-		return NOTIFY_DONE;
-	}
+	memcpy(&switchdev_work->fdb_info, fdb_info,
+	       sizeof(switchdev_work->fdb_info));
+	switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+	if (!switchdev_work->fdb_info.addr)
+		goto err_addr_alloc;
+	ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
+			fdb_info->addr);
+	dev_hold(ndev);
 
 	queue_work(system_long_wq, &switchdev_work->work);
 
-	return NOTIFY_DONE;
+	return 0;
 
 err_addr_alloc:
 	kfree(switchdev_work);
-	return NOTIFY_BAD;
+	return -ENOMEM;
 }
 
-static struct notifier_block cpsw_switchdev_notifier = {
-	.notifier_call = am65_cpsw_switchdev_event,
-};
-
 static int am65_cpsw_switchdev_blocking_event(struct notifier_block *unused,
 					      unsigned long event, void *ptr)
 {
@@ -499,6 +498,10 @@ static int am65_cpsw_switchdev_blocking_event(struct notifier_block *unused,
 						     am65_cpsw_port_dev_check,
 						     am65_cpsw_port_attr_set);
 		return notifier_from_errno(err);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		err = am65_cpsw_switchdev_fdb_event(dev, event, ptr);
+		return notifier_from_errno(err);
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index a7d97d429e06..bc3ddca2750d 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -434,9 +434,6 @@ static int cpsw_switchdev_event(struct notifier_block *unused,
 				unsigned long event, void *ptr)
 {
 	struct net_device *ndev = switchdev_notifier_info_to_dev(ptr);
-	struct switchdev_notifier_fdb_info *fdb_info = ptr;
-	struct cpsw_switchdev_event_work *switchdev_work;
-	struct cpsw_priv *priv = netdev_priv(ndev);
 	int err;
 
 	if (event == SWITCHDEV_PORT_ATTR_SET) {
@@ -446,47 +443,50 @@ static int cpsw_switchdev_event(struct notifier_block *unused,
 		return notifier_from_errno(err);
 	}
 
-	if (!cpsw_port_dev_check(ndev))
-		return NOTIFY_DONE;
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block cpsw_switchdev_notifier = {
+	.notifier_call = cpsw_switchdev_event,
+};
+
+static int cpsw_switchdev_fdb_event(struct net_device *dev, unsigned long event,
+				    struct switchdev_notifier_fdb_info *fdb_info)
+{
+	struct cpsw_switchdev_event_work *switchdev_work;
+	struct cpsw_priv *priv;
+
+	if (!cpsw_port_dev_check(dev))
+		return 0;
+
+	priv = netdev_priv(dev);
 
 	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 	if (WARN_ON(!switchdev_work))
-		return NOTIFY_BAD;
+		return -ENOMEM;
 
 	INIT_WORK(&switchdev_work->work, cpsw_switchdev_event_work);
 	switchdev_work->priv = priv;
 	switchdev_work->event = event;
 
-	switch (event) {
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		memcpy(&switchdev_work->fdb_info, ptr,
-		       sizeof(switchdev_work->fdb_info));
-		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
-		if (!switchdev_work->fdb_info.addr)
-			goto err_addr_alloc;
-		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
-				fdb_info->addr);
-		dev_hold(ndev);
-		break;
-	default:
-		kfree(switchdev_work);
-		return NOTIFY_DONE;
-	}
+	memcpy(&switchdev_work->fdb_info, fdb_info,
+	       sizeof(switchdev_work->fdb_info));
+	switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
+	if (!switchdev_work->fdb_info.addr)
+		goto err_addr_alloc;
+	ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
+			fdb_info->addr);
+	dev_hold(dev);
 
 	queue_work(system_long_wq, &switchdev_work->work);
 
-	return NOTIFY_DONE;
+	return 0;
 
 err_addr_alloc:
 	kfree(switchdev_work);
-	return NOTIFY_BAD;
+	return -ENOMEM;
 }
 
-static struct notifier_block cpsw_switchdev_notifier = {
-	.notifier_call = cpsw_switchdev_event,
-};
-
 static int cpsw_switchdev_blocking_event(struct notifier_block *unused,
 					 unsigned long event, void *ptr)
 {
@@ -509,6 +509,10 @@ static int cpsw_switchdev_blocking_event(struct notifier_block *unused,
 						     cpsw_port_dev_check,
 						     cpsw_port_attr_set);
 		return notifier_from_errno(err);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		err = cpsw_switchdev_fdb_event(dev, event, ptr);
+		return notifier_from_errno(err);
 	default:
 		break;
 	}
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 72e84ff9fea5..aa94f57e1d7c 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -867,14 +867,14 @@ static int qeth_l2_switchdev_event(struct notifier_block *unused,
 		return NOTIFY_DONE;
 
 	dstdev = switchdev_notifier_info_to_dev(info);
-	brdev = netdev_master_upper_dev_get_rcu(dstdev);
+	brdev = netdev_master_upper_dev_get(dstdev);
 	if (!brdev || !netif_is_bridge_master(brdev))
 		return NOTIFY_DONE;
 	fdb_info = container_of(info,
 				struct switchdev_notifier_fdb_info,
 				info);
 	iter = &brdev->adj_list.lower;
-	lowerdev = netdev_next_lower_dev_rcu(brdev, &iter);
+	lowerdev = netdev_next_lower_dev(brdev, &iter);
 	while (lowerdev) {
 		if (qeth_l2_must_learn(lowerdev, dstdev)) {
 			card = lowerdev->ml_priv;
@@ -887,7 +887,7 @@ static int qeth_l2_switchdev_event(struct notifier_block *unused,
 				return NOTIFY_BAD;
 			}
 		}
-		lowerdev = netdev_next_lower_dev_rcu(brdev, &iter);
+		lowerdev = netdev_next_lower_dev(brdev, &iter);
 	}
 	return NOTIFY_DONE;
 }
@@ -904,7 +904,7 @@ static void qeth_l2_br2dev_get(void)
 	int rc;
 
 	if (!refcount_inc_not_zero(&qeth_l2_switchdev_notify_refcnt)) {
-		rc = register_switchdev_notifier(&qeth_l2_sw_notifier);
+		rc = register_switchdev_blocking_notifier(&qeth_l2_sw_notifier);
 		if (rc) {
 			QETH_DBF_MESSAGE(2,
 					 "failed to register qeth_l2_sw_notifier: %d\n",
@@ -924,7 +924,7 @@ static void qeth_l2_br2dev_put(void)
 	int rc;
 
 	if (refcount_dec_and_test(&qeth_l2_switchdev_notify_refcnt)) {
-		rc = unregister_switchdev_notifier(&qeth_l2_sw_notifier);
+		rc = unregister_switchdev_blocking_notifier(&qeth_l2_sw_notifier);
 		if (rc) {
 			QETH_DBF_MESSAGE(2,
 					 "failed to unregister qeth_l2_sw_notifier: %d\n",
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 60d806b6a5ae..5d9ae1ec85b3 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -191,8 +191,8 @@ struct switchdev_brport {
 enum switchdev_notifier_type {
 	SWITCHDEV_FDB_ADD_TO_BRIDGE = 1,
 	SWITCHDEV_FDB_DEL_TO_BRIDGE,
-	SWITCHDEV_FDB_ADD_TO_DEVICE,
-	SWITCHDEV_FDB_DEL_TO_DEVICE,
+	SWITCHDEV_FDB_ADD_TO_DEVICE, /* Blocking. */
+	SWITCHDEV_FDB_DEL_TO_DEVICE, /* Blocking. */
 	SWITCHDEV_FDB_OFFLOADED,
 	SWITCHDEV_FDB_FLUSH_TO_BRIDGE,
 
@@ -283,6 +283,13 @@ int switchdev_port_obj_add(struct net_device *dev,
 int switchdev_port_obj_del(struct net_device *dev,
 			   const struct switchdev_obj *obj);
 
+int
+switchdev_fdb_add_to_device(struct net_device *dev,
+			    const struct switchdev_notifier_fdb_info *fdb_info);
+int
+switchdev_fdb_del_to_device(struct net_device *dev,
+			    const struct switchdev_notifier_fdb_info *fdb_info);
+
 int register_switchdev_notifier(struct notifier_block *nb);
 int unregister_switchdev_notifier(struct notifier_block *nb);
 int call_switchdev_notifiers(unsigned long val, struct net_device *dev,
@@ -386,6 +393,20 @@ static inline int switchdev_port_obj_del(struct net_device *dev,
 	return -EOPNOTSUPP;
 }
 
+static inline int
+switchdev_fdb_add_to_device(struct net_device *dev,
+			    const struct switchdev_notifier_fdb_info *fdb_info)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int
+switchdev_fdb_del_to_device(struct net_device *dev,
+			    const struct switchdev_notifier_fdb_info *fdb_info)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int register_switchdev_notifier(struct notifier_block *nb)
 {
 	return 0;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 46812b659710..0bdbcfc53914 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -763,6 +763,8 @@ int br_fdb_replay(const struct net_device *br_dev, const void *ctx, bool adding,
 	if (!nb)
 		return 0;
 
+	ASSERT_RTNL();
+
 	if (!netif_is_bridge_master(br_dev))
 		return -EINVAL;
 
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 6bf518d78f02..cd413b010567 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -138,12 +138,10 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 
 	switch (type) {
 	case RTM_DELNEIGH:
-		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
-					 dev, &info.info, NULL);
+		switchdev_fdb_del_to_device(dev, &info);
 		break;
 	case RTM_NEWNEIGH:
-		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
-					 dev, &info.info, NULL);
+		switchdev_fdb_add_to_device(dev, &info);
 		break;
 	}
 }
@@ -287,7 +285,7 @@ static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_fdb_replay(br_dev, ctx, true, atomic_nb);
+	err = br_fdb_replay(br_dev, ctx, true, blocking_nb);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -306,7 +304,7 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
 
 	br_mdb_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
 
-	br_fdb_replay(br_dev, ctx, false, atomic_nb);
+	br_fdb_replay(br_dev, ctx, false, blocking_nb);
 }
 
 /* Let the bridge know that this port is offloaded, so that it can assign a
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index eb9d9e53c536..249303ac3c3c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2454,20 +2454,6 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 						     dsa_slave_dev_check,
 						     dsa_slave_port_attr_set);
 		return notifier_from_errno(err);
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		err = switchdev_handle_fdb_add_to_device(dev, ptr,
-							 dsa_slave_dev_check,
-							 dsa_foreign_dev_check,
-							 dsa_slave_fdb_add_to_device,
-							 NULL);
-		return notifier_from_errno(err);
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		err = switchdev_handle_fdb_del_to_device(dev, ptr,
-							 dsa_slave_dev_check,
-							 dsa_foreign_dev_check,
-							 dsa_slave_fdb_del_to_device,
-							 NULL);
-		return notifier_from_errno(err);
 	default:
 		return NOTIFY_DONE;
 	}
@@ -2497,6 +2483,24 @@ static int dsa_slave_switchdev_blocking_event(struct notifier_block *unused,
 						     dsa_slave_dev_check,
 						     dsa_slave_port_attr_set);
 		return notifier_from_errno(err);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+		rcu_read_lock();
+		err = switchdev_handle_fdb_add_to_device(dev, ptr,
+							 dsa_slave_dev_check,
+							 dsa_foreign_dev_check,
+							 dsa_slave_fdb_add_to_device,
+							 NULL);
+		rcu_read_unlock();
+		return notifier_from_errno(err);
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		rcu_read_lock();
+		err = switchdev_handle_fdb_del_to_device(dev, ptr,
+							 dsa_slave_dev_check,
+							 dsa_foreign_dev_check,
+							 dsa_slave_fdb_del_to_device,
+							 NULL);
+		rcu_read_unlock();
+		return notifier_from_errno(err);
 	}
 
 	return NOTIFY_DONE;
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 0b2c18efc079..c34c6abceec6 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -378,6 +378,53 @@ int call_switchdev_blocking_notifiers(unsigned long val, struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(call_switchdev_blocking_notifiers);
 
+static void switchdev_fdb_add_deferred(struct net_device *dev, const void *data)
+{
+	const struct switchdev_notifier_fdb_info *fdb_info = data;
+	struct switchdev_notifier_fdb_info tmp = *fdb_info;
+	int err;
+
+	ASSERT_RTNL();
+	err = call_switchdev_blocking_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
+						dev, &tmp.info, NULL);
+	err = notifier_to_errno(err);
+	if (err && err != -EOPNOTSUPP)
+		netdev_err(dev, "failed to add FDB entry: %pe\n", ERR_PTR(err));
+}
+
+static void switchdev_fdb_del_deferred(struct net_device *dev, const void *data)
+{
+	const struct switchdev_notifier_fdb_info *fdb_info = data;
+	struct switchdev_notifier_fdb_info tmp = *fdb_info;
+	int err;
+
+	ASSERT_RTNL();
+	err = call_switchdev_blocking_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
+						dev, &tmp.info, NULL);
+	err = notifier_to_errno(err);
+	if (err && err != -EOPNOTSUPP)
+		netdev_err(dev, "failed to delete FDB entry: %pe\n",
+			   ERR_PTR(err));
+}
+
+int
+switchdev_fdb_add_to_device(struct net_device *dev,
+			    const struct switchdev_notifier_fdb_info *fdb_info)
+{
+	return switchdev_deferred_enqueue(dev, fdb_info, sizeof(*fdb_info),
+					  switchdev_fdb_add_deferred);
+}
+EXPORT_SYMBOL_GPL(switchdev_fdb_add_to_device);
+
+int
+switchdev_fdb_del_to_device(struct net_device *dev,
+			    const struct switchdev_notifier_fdb_info *fdb_info)
+{
+	return switchdev_deferred_enqueue(dev, fdb_info, sizeof(*fdb_info),
+					  switchdev_fdb_del_deferred);
+}
+EXPORT_SYMBOL_GPL(switchdev_fdb_del_to_device);
+
 struct switchdev_nested_priv {
 	bool (*check_cb)(const struct net_device *dev);
 	bool (*foreign_dev_check_cb)(const struct net_device *dev,
-- 
2.25.1

