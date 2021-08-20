Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C253F2BA1
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 13:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbhHTL6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 07:58:54 -0400
Received: from mail-db8eur05on2049.outbound.protection.outlook.com ([40.107.20.49]:31328
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239997AbhHTL6u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 07:58:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2xUM3OK0LztiwoIjoSds3VYnxaEBKmrr0dRqGtKlI2NK6Ayot37hYhVRPY0w/dDBjBr/1I6oiSWPKNzJwx2wyT+nc/s8mUgBDk+G3it7P6GaPYRL38tqDUY4t3Rl5sb+5RU6KAqdgbEWhbVGP09b4NiuKkIggLj943jDcmAUdCw8YNQL3P1NKYwc25dvSzaBE8o6XDYiFpBQr0k7YQUCZvny7BM8Jy77+Lc4WSYxEqq+N0ZByAOjEwtnhuE2+karMCrTStXWK8qaCJqRkD+Ubj/tnKecyoewsCqLDh5dP5fdivEolKziJLBJ+Ogmf6/Xma+0lx3HBPnov5GpBq/aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXkiAOwqt4AUK/lRlHaBAiN+1fYb8ux9rZPb/qOGpuM=;
 b=Sgy27IfObNxQaTLba2bCNsulYkPj0uqZgrNsOQubnr570n4qRlyF+zV3S/VjmU4vO5k7AvIDcVHbkYPSQnog7Au37i/V23HWCUreoZ6ERJYNvbb6PEbFHtutufcrQtxAMz7lePY7fdv72iT0ngmrWhUyyOo0aY/R2Ri35H6UuLp0Px0yUJjo0Y75W3hjWbZBM7ysknP+rUtF7VBZChM8jRYtaRgyUp8njyakQnq7WEx1CaCMR3P9EY6M0RxfYBH+Qhk7bjCnlN8gO+/gjfkjPpoUk54cY9Ya4OtU71pPpkfTbSYqy5epGUntEjuL6CtXyZK3OH8OX5O2IiCFQCRVzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXkiAOwqt4AUK/lRlHaBAiN+1fYb8ux9rZPb/qOGpuM=;
 b=pSzOqkFoD982yvHn5XhJRZnLhmDeR9W9falxwU3yvaklq7xL5d+ywQxE9049KkgzUJ0gFlnzCmOzaIJ45TYKxA+FpjMpH1vX5+e7sdoTralQUHB20uY8R/eQoo8YL2hS+AWsd45NIAOcZFpApgr2Yv/HLo8LfUzT5vx/xF+Ayek=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 11:58:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 11:58:09 +0000
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
Subject: [PATCH v3 net-next 3/7] net: switchdev: move SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE to the blocking notifier chain
Date:   Fri, 20 Aug 2021 14:57:42 +0300
Message-Id: <20210820115746.3701811-4-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by AM0PR04CA0010.eurprd04.prod.outlook.com (2603:10a6:208:122::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 11:58:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb461de4-d4e8-4093-9f74-08d963d1c72f
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839AC6A61C0DF6214617ED0E0C19@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6AQFKKUUmNKYLKf8QIhTRm1+lAqogCISY/z7bjQvL2d0aRc2BjCudid+NW9aJvRHDYDIEmQ7pwkiGOgy49TjMy3+FvUorIp+9pDltpketHH1g/3r8a0ma2H+8FiqGen/rlds1cJZrlrCc73WgFYNOsd5wh3um7tcOom+o2i2VGVpxmkrVZJKuYaKjImpUK5Oq8RtvHkl7ZABpWx7dV/Lh/tkkxxGUC6uW1tTdjoAmC8hQtMoaD5TRJk/mVf0lIC5G5FWeZvHfTde0/nGWj//HYZntRANKIkiR0Yr81MIO92B9zexy4MfW8dsr64v8h9PFl8a2ZNI6q16OIbaJp5qXG0QxYHsUDHGLon6CaavzoyCLYfoQYFm7Ji3ztqEWAe/IIJyFoMHBmAPr1oJGyxNw6BSlPeecuUEoupE0EBqLg4ZOTFNX5oAYCORCQyPbDKSJxsAVAL62fY5lVgIDxL/AH4FY1/Ya5ppUT7PaJi16jFhTJ2Gp1gB2uMuJBfW2id4hh1mzV1hHlPxrvEKJQi0klXjR2VYrxbyXgCagauv/mjQL48XIcVRl6FNEteG0ZZvq7atuBl0ywhhpSEW02lBxlPWGHoqVlf63zvgzygswF5Q4BYfFkTPzQtlhW4JHVBKlDeWeKxGvT+uNdi2He5TrYPk9+Nsa9BLmy7wFvtB5MVWj9Pk0l2hDEj798EKd4hHeeACTVO3dNHwA8J/etunAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(8936002)(8676002)(26005)(6506007)(6486002)(30864003)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(83380400001)(1076003)(6512007)(66946007)(52116002)(7416002)(7406005)(186003)(110136005)(36756003)(54906003)(478600001)(316002)(956004)(2616005)(44832011)(6666004)(2906002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3vdm+EtSuXv3C/NiTKdsl1lA0fXFyAgcu+XW4AKW4e2dJX0M5PqusblmMZLt?=
 =?us-ascii?Q?mHHo57bjrVxxrVXP2h8YpM9tWTXEk5Cu5ep99i2GGiNDDD8OBcUz1iCALVOZ?=
 =?us-ascii?Q?9/6EeFcsNffXmxjOYj1FiV6+XCi3LA4j0cHtUqptcLg8WUA/wwKW6WZOOz2p?=
 =?us-ascii?Q?NsZ9yz/PwwjA4Rc4WgYZFsA5d9ziuvtIoCKnRA4Aqo2sLrd01blSces7AXg8?=
 =?us-ascii?Q?UwYh8MeSxe9mqFprQX7i1NDhAXIEvAOIehzwmhmzhLJEV+tphm6+v3vOB5gH?=
 =?us-ascii?Q?g9tXsvjkMrpR84ad3yLWzc7o/+RnbqDMhRZweP1bnnJeyxTdBFoDoPxB032R?=
 =?us-ascii?Q?WE+4ICplp+tOKd3fhOCdsYethZIvya7TltLQ4lNT/JP57hCN0g1ybI6zOrYh?=
 =?us-ascii?Q?FWcr31VmmejLJXouDzhxQ8yj2GO+hoRMG0q0slWx7I5n/m7lUZjD3W6J4sXX?=
 =?us-ascii?Q?gGlX5j6Ay/PsQ0kElOWZxuDFLi6nZhu4twcEOd+i88DSYwHg0IQG4jQaWr88?=
 =?us-ascii?Q?TJioD3aXsQWh1H1GOFJdm8uHmzITyatgdSKRk+8fbQcLZgE1ZUCjEnV1/jdm?=
 =?us-ascii?Q?7wWeT1Dj0NKhTTTmTG7CXtWhOUlwnznbYQaXE5/d7lk/ITTPWu5vkf2FpDin?=
 =?us-ascii?Q?EWCOg55HD7iYW47Suyd8uRvHKICxCMJGQHsI6pmsEea2utC2HZSrEc2U2VG7?=
 =?us-ascii?Q?TX7JeDvVgn85bkLo60np/9BbENE7IUX7NgY9f8Pa+ca+4GeXiUNVUiPrhICf?=
 =?us-ascii?Q?b1B7ae/Lnj2CcM8nf8gB1lDhNbmsx7TeuG6wmj/0r6xjpr8j4RmlUty/Rgq5?=
 =?us-ascii?Q?dsnl4+QwMjTbhPOkEIJkRtyETXnCDWVo+OMIeWYM8xd3+dyCwNLFLkJz81O/?=
 =?us-ascii?Q?3Wm+2sv6MIuS+rMlxld1qJEz+LD6eVvISUkztsZx+seEo9GDYRYvyOcSV/fb?=
 =?us-ascii?Q?nJhygh+AsN6JcUlX4DkwgvDdVredS3q4rOm9j3+lIALLkGb6t0Jsa4XV/cqS?=
 =?us-ascii?Q?yNXtQXGw4ZHpmnlbKccHNPg0XBaMwBQvmVMY49F58EX5b/Kxh/o0UkDNV6Cv?=
 =?us-ascii?Q?iTIASFihtnDMDzbl92WCfsXlfqsYIYwWRHxuA1oZmz+H8yEK3XxLlyne9SKz?=
 =?us-ascii?Q?9VADTN/SNeiYggfwstgzsSvTNQlN185Bd5bHX4oXlFuFXZHVMaE8X5FPb5lb?=
 =?us-ascii?Q?ptvk0EGYK5u732KcJp+zN2ZyVDqNUBeRwa3zQzITVp/S62+bodrIn0T3H37R?=
 =?us-ascii?Q?VNKl2d8fNQ0Zk0DvRP01qUtlQ96ix+WBA356CHiaXvljUgOCPJUeeBx1p7Su?=
 =?us-ascii?Q?q6IZDP8gcJT22YiC5f/TGI2m?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb461de4-d4e8-4093-9f74-08d963d1c72f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 11:58:09.3605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: avNkssdxBhkX/lpVo+XhZ14+NaY1yqZj9VSyjhhf3nQpB52IMSmUeg7bcBlj3GsoXBGuHdINZeAXGmqmfyIPBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
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
rcu_read_lock() and rcu_read_unlock(). The RCU protection can be dropped
from the other drivers when they are reworked to stop scheduling.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- make sure that a shallow memcpy is enough to not have dangling bridge
  memory inside struct switchdev_notifier_fdb_info.
- removed a bogus mlx5_esw_bridge_is_local (suggested by Vlad Buslov)
- actually compile-tested the S/390 qeth driver

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 61 +++++++-------
 .../marvell/prestera/prestera_switchdev.c     | 82 ++++++++++---------
 .../mellanox/mlx5/core/en/rep/bridge.c        | 55 ++++++++++++-
 .../mellanox/mlxsw/spectrum_switchdev.c       | 47 ++++++++++-
 .../microchip/sparx5/sparx5_switchdev.c       | 58 +++++++------
 drivers/net/ethernet/rocker/rocker_main.c     | 56 +++++++------
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c | 42 +++++-----
 drivers/net/ethernet/ti/cpsw_switchdev.c      | 45 +++++-----
 drivers/s390/net/qeth_l2_main.c               | 15 +++-
 include/net/switchdev.h                       | 25 +++++-
 net/bridge/br_switchdev.c                     | 12 +--
 net/dsa/slave.c                               | 32 ++++----
 net/switchdev/switchdev.c                     | 47 +++++++++++
 13 files changed, 385 insertions(+), 192 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index dd0096cc3221..d0d63da7f01f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2253,40 +2253,10 @@ static int dpaa2_switch_port_event(struct notifier_block *nb,
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
-		memcpy(&switchdev_work->fdb_info, fdb_info,
-		       sizeof(switchdev_work->fdb_info));
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
 }
 
@@ -2312,6 +2282,34 @@ static int dpaa2_switch_port_obj_event(unsigned long event,
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
+	memcpy(&switchdev_work->fdb_info, fdb_info, sizeof(*fdb_info));
+
+	/* Take a reference on the device to avoid being freed. */
+	dev_hold(dev);
+
+	queue_work(ethsw->workqueue, &switchdev_work->work);
+
+	return NOTIFY_DONE;
+}
+
 static int dpaa2_switch_port_blocking_event(struct notifier_block *nb,
 					    unsigned long event, void *ptr)
 {
@@ -2323,6 +2321,9 @@ static int dpaa2_switch_port_blocking_event(struct notifier_block *nb,
 		return dpaa2_switch_port_obj_event(event, dev, ptr);
 	case SWITCHDEV_PORT_ATTR_SET:
 		return dpaa2_switch_port_attr_set_event(dev, ptr);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		return dpaa2_switch_fdb_event(event, dev, ptr);
 	}
 
 	return NOTIFY_DONE;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 236b07c42df0..a89cda394685 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -844,10 +844,6 @@ static int prestera_switchdev_event(struct notifier_block *unused,
 				    unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
-	struct switchdev_notifier_fdb_info *fdb_info;
-	struct switchdev_notifier_info *info = ptr;
-	struct prestera_fdb_event_work *swdev_work;
-	struct net_device *upper;
 	int err;
 
 	if (event == SWITCHDEV_PORT_ATTR_SET) {
@@ -857,42 +853,6 @@ static int prestera_switchdev_event(struct notifier_block *unused,
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
-		memcpy(&swdev_work->fdb_info, fdb_info,
-		       sizeof(swdev_work->fdb_info));
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
 }
 
@@ -1089,6 +1049,42 @@ static int prestera_port_obj_del(struct net_device *dev, const void *ctx,
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
+	memcpy(&swdev_work->fdb_info, fdb_info, sizeof(*fdb_info));
+	dev_hold(dev);
+
+	queue_work(swdev_wq, &swdev_work->work);
+	return 0;
+}
+
 static int prestera_switchdev_blk_event(struct notifier_block *unused,
 					unsigned long event, void *ptr)
 {
@@ -1111,6 +1107,12 @@ static int prestera_switchdev_blk_event(struct notifier_block *unused,
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
index 3e11420d8057..06bb8bb8e39e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -276,6 +276,51 @@ mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
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
@@ -295,6 +340,12 @@ static int mlx5_esw_bridge_event_blocking(struct notifier_block *nb,
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
@@ -405,9 +456,7 @@ static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
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
index 78e5059beafa..fbaed9de3929 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -3246,8 +3246,6 @@ static int mlxsw_sp_switchdev_event(struct notifier_block *unused,
 	switchdev_work->event = event;
 
 	switch (event) {
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
 	case SWITCHDEV_FDB_DEL_TO_BRIDGE:
 		fdb_info = container_of(info,
@@ -3506,6 +3504,45 @@ mlxsw_sp_switchdev_handle_vxlan_obj_del(struct net_device *vxlan_dev,
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
+	memcpy(&switchdev_work->fdb_info, fdb_info, sizeof(*fdb_info));
+	/* Take a reference on the device. This can be either
+	 * upper device containig mlxsw_sp_port or just a
+	 * mlxsw_sp_port
+	 */
+	dev_hold(dev);
+
+	mlxsw_core_schedule_work(&switchdev_work->work);
+
+	return 0;
+}
+
 static int mlxsw_sp_switchdev_blocking_event(struct notifier_block *unused,
 					     unsigned long event, void *ptr)
 {
@@ -3534,6 +3571,12 @@ static int mlxsw_sp_switchdev_blocking_event(struct notifier_block *unused,
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
index 5c5eb557a19c..0d19f2be0895 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
@@ -267,9 +267,6 @@ static int sparx5_switchdev_event(struct notifier_block *unused,
 				  unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
-	struct sparx5_switchdev_event_work *switchdev_work;
-	struct switchdev_notifier_fdb_info *fdb_info;
-	struct switchdev_notifier_info *info = ptr;
 	int err;
 
 	switch (event) {
@@ -278,27 +275,6 @@ static int sparx5_switchdev_event(struct notifier_block *unused,
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
-		memcpy(&switchdev_work->fdb_info, fdb_info,
-		       sizeof(switchdev_work->fdb_info));
-		dev_hold(dev);
-
-		sparx5_schedule_work(&switchdev_work->work);
-		break;
 	}
 
 	return NOTIFY_DONE;
@@ -449,6 +425,36 @@ static int sparx5_handle_port_obj_del(struct net_device *dev,
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
+	memcpy(&switchdev_work->fdb_info, fdb_info, sizeof(*fdb_info));
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
@@ -468,6 +474,10 @@ static int sparx5_switchdev_blocking_event(struct notifier_block *nb,
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
index d490d006cc98..f6facbf4dc2c 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2766,9 +2766,6 @@ static int rocker_switchdev_event(struct notifier_block *unused,
 				  unsigned long event, void *ptr)
 {
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
-	struct rocker_switchdev_event_work *switchdev_work;
-	struct switchdev_notifier_fdb_info *fdb_info = ptr;
-	struct rocker_port *rocker_port;
 
 	if (!rocker_port_dev_check(dev))
 		return NOTIFY_DONE;
@@ -2776,30 +2773,6 @@ static int rocker_switchdev_event(struct notifier_block *unused,
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
-		memcpy(&switchdev_work->fdb_info, fdb_info,
-		       sizeof(switchdev_work->fdb_info));
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
 
@@ -2822,6 +2795,32 @@ rocker_switchdev_port_obj_event(unsigned long event, struct net_device *netdev,
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
+	memcpy(&switchdev_work->fdb_info, fdb_info, sizeof(*fdb_info));
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
@@ -2836,6 +2835,9 @@ static int rocker_switchdev_blocking_event(struct notifier_block *unused,
 		return rocker_switchdev_port_obj_event(event, dev, ptr);
 	case SWITCHDEV_PORT_ATTR_SET:
 		return rocker_switchdev_port_attr_set_event(dev, ptr);
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		return rocker_switchdev_fdb_event(event, dev, ptr);
 	}
 
 	return NOTIFY_DONE;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
index 860214e1a8ca..5087d529c93e 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
@@ -423,9 +423,6 @@ static int am65_cpsw_switchdev_event(struct notifier_block *unused,
 				     unsigned long event, void *ptr)
 {
 	struct net_device *ndev = switchdev_notifier_info_to_dev(ptr);
-	struct am65_cpsw_switchdev_event_work *switchdev_work;
-	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
-	struct switchdev_notifier_fdb_info *fdb_info = ptr;
 	int err;
 
 	if (event == SWITCHDEV_PORT_ATTR_SET) {
@@ -435,38 +432,39 @@ static int am65_cpsw_switchdev_event(struct notifier_block *unused,
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
-		memcpy(&switchdev_work->fdb_info, fdb_info,
-		       sizeof(switchdev_work->fdb_info));
-		dev_hold(ndev);
-		break;
-	default:
-		kfree(switchdev_work);
-		return NOTIFY_DONE;
-	}
+	memcpy(&switchdev_work->fdb_info, fdb_info, sizeof(*fdb_info));
+	dev_hold(ndev);
 
 	queue_work(system_long_wq, &switchdev_work->work);
 
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block cpsw_switchdev_notifier = {
-	.notifier_call = am65_cpsw_switchdev_event,
-};
-
 static int am65_cpsw_switchdev_blocking_event(struct notifier_block *unused,
 					      unsigned long event, void *ptr)
 {
@@ -489,6 +487,10 @@ static int am65_cpsw_switchdev_blocking_event(struct notifier_block *unused,
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
index 786bb848ddeb..8d463d1283f9 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -433,9 +433,6 @@ static int cpsw_switchdev_event(struct notifier_block *unused,
 				unsigned long event, void *ptr)
 {
 	struct net_device *ndev = switchdev_notifier_info_to_dev(ptr);
-	struct switchdev_notifier_fdb_info *fdb_info = ptr;
-	struct cpsw_switchdev_event_work *switchdev_work;
-	struct cpsw_priv *priv = netdev_priv(ndev);
 	int err;
 
 	if (event == SWITCHDEV_PORT_ATTR_SET) {
@@ -445,38 +442,40 @@ static int cpsw_switchdev_event(struct notifier_block *unused,
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
-		memcpy(&switchdev_work->fdb_info, fdb_info,
-		       sizeof(switchdev_work->fdb_info));
-		dev_hold(ndev);
-		break;
-	default:
-		kfree(switchdev_work);
-		return NOTIFY_DONE;
-	}
+	memcpy(&switchdev_work->fdb_info, fdb_info, sizeof(*fdb_info));
+	dev_hold(dev);
 
 	queue_work(system_long_wq, &switchdev_work->work);
 
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block cpsw_switchdev_notifier = {
-	.notifier_call = cpsw_switchdev_event,
-};
-
 static int cpsw_switchdev_blocking_event(struct notifier_block *unused,
 					 unsigned long event, void *ptr)
 {
@@ -499,6 +498,10 @@ static int cpsw_switchdev_blocking_event(struct notifier_block *unused,
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
index de98f79c11ab..98678dc9d054 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -863,10 +863,15 @@ static int qeth_l2_switchdev_event(struct notifier_block *unused,
 	      event == SWITCHDEV_FDB_DEL_TO_DEVICE))
 		return NOTIFY_DONE;
 
+	rcu_read_lock();
+
 	dstdev = switchdev_notifier_info_to_dev(info);
 	brdev = netdev_master_upper_dev_get_rcu(dstdev);
-	if (!brdev || !netif_is_bridge_master(brdev))
+	if (!brdev || !netif_is_bridge_master(brdev)) {
+		rcu_read_unlock();
 		return NOTIFY_DONE;
+	}
+
 	fdb_info = container_of(info,
 				struct switchdev_notifier_fdb_info,
 				info);
@@ -881,11 +886,15 @@ static int qeth_l2_switchdev_event(struct notifier_block *unused,
 						       fdb_info->addr);
 			if (rc) {
 				QETH_CARD_TEXT(card, 2, "b2dqwerr");
+				rcu_read_unlock();
 				return NOTIFY_BAD;
 			}
 		}
 		lowerdev = netdev_next_lower_dev_rcu(brdev, &iter);
 	}
+
+	rcu_read_unlock();
+
 	return NOTIFY_DONE;
 }
 
@@ -901,7 +910,7 @@ static void qeth_l2_br2dev_get(void)
 	int rc;
 
 	if (!refcount_inc_not_zero(&qeth_l2_switchdev_notify_refcnt)) {
-		rc = register_switchdev_notifier(&qeth_l2_sw_notifier);
+		rc = register_switchdev_blocking_notifier(&qeth_l2_sw_notifier);
 		if (rc) {
 			QETH_DBF_MESSAGE(2,
 					 "failed to register qeth_l2_sw_notifier: %d\n",
@@ -921,7 +930,7 @@ static void qeth_l2_br2dev_put(void)
 	int rc;
 
 	if (refcount_dec_and_test(&qeth_l2_switchdev_notify_refcnt)) {
-		rc = unregister_switchdev_notifier(&qeth_l2_sw_notifier);
+		rc = unregister_switchdev_blocking_notifier(&qeth_l2_sw_notifier);
 		if (rc) {
 			QETH_DBF_MESSAGE(2,
 					 "failed to unregister qeth_l2_sw_notifier: %d\n",
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 6764fb7692e2..e27da5bd665f 100644
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
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 7e62904089c8..c7c8e23c2147 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -140,12 +140,10 @@ br_switchdev_fdb_notify(struct net_bridge *br,
 
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
@@ -303,6 +301,8 @@ static int br_fdb_replay(const struct net_device *br_dev, const void *ctx,
 	if (!nb)
 		return 0;
 
+	ASSERT_RTNL();
+
 	if (!netif_is_bridge_master(br_dev))
 		return -EINVAL;
 
@@ -343,7 +343,7 @@ static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
-	err = br_fdb_replay(br_dev, ctx, true, atomic_nb);
+	err = br_fdb_replay(br_dev, ctx, true, blocking_nb);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -362,7 +362,7 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
 
 	br_mdb_replay(br_dev, dev, ctx, false, blocking_nb, NULL);
 
-	br_fdb_replay(br_dev, ctx, false, atomic_nb);
+	br_fdb_replay(br_dev, ctx, false, blocking_nb);
 }
 
 /* Let the bridge know that this port is offloaded, so that it can assign a
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 7bc88767db9d..6601224f6a5a 100644
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

