Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304DD632477
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiKUN4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbiKUN4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:36 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2085.outbound.protection.outlook.com [40.107.249.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBC0C494B
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RG+clJi/WM0Pp/2ELpIoVaf9WzZ9Wn/m9pvo8l09u2eC46abpO0X5L/KS4ePTpfblf4onklWphFv6k5hgT/qqYZe1YSu9SMhLxhBdWuHy3VCc57PxJ88VxYTcYnmLNJzEwrQ2jopUOOnnRqoGJXkWRGtN2aY2g2pbb+yoZ6u/oYN3URxmpEE0sYH+PtqqMxbR8PYhOP6a0yPDJC0p/u16tsnb5VNWFbpc/WwJ4rbQ5Ei5MdsiYAYLRgDif7sT6/NJZ0/gMn+WgQnie5d7OMNmqBwk5Ko5ELTAOdyIM+qrkZACo/uI7sxINVKb5pV50UCfcWX5Mn3XCK7HdB2Jt4TfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Xn2l12qwzWcdnpkZv2VH49WkadwkP5lJnFK51hURIo=;
 b=KjKkTljncP3hoIOzNuKXFGXx7pjmoYj2B9gwTmJBZyHmVKlE/uooKD5QWbg5bSIBub5Ed7gP9HbeC4jYTeShWD7UdD42FCSgaPDFPqJY396i6kmf/EFl5N0df98uK/gxlS/JgjCd3hTKBl7RHemq6kZMCs2JMlewLwUk2iNsXfOOz3Mvk2x2MZbkXF6gHPuu+aXScGP8XTiuaqVY4JJPxcGL192Emt9vyTpuYBOCjnlEGRtq7vi5rhgB24ya05ys5yPVvYmnISkch1fQFyWt43w1f875sGXDCw43acn0D/s3pIeDhOsrEdCC7vjRyeENJjEohR4qYIfzyCcUtETCMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Xn2l12qwzWcdnpkZv2VH49WkadwkP5lJnFK51hURIo=;
 b=PyRDpXOdLZxqGigabCcul8GU5UBKhgIDjbD3hVpMUXcwmg/Glbn3r8svxJTt3+lSBZ4X3ME2oikTLe2sNmf5kKI5HqqYjyLcroaNubBx7du3Ckg+eX2McPicwzTdciT5H+DeZtRXs3qMX4lDLEdjjW2bVyJB4ojHHDrxcDPDdh8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6829.eurprd04.prod.outlook.com (2603:10a6:803:13b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 13/17] net: dsa: merge dsa.c into dsa2.c
Date:   Mon, 21 Nov 2022 15:55:51 +0200
Message-Id: <20221121135555.1227271-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0015.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB6829:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ae86a56-4667-480b-4683-08dacbc82ba7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dzU2YhoeEiMBntmRNHK9OqTpHu/Xon4aSb2KdmFNg8RQL4+u2UpKYvsQwd/wXFi4mAUD5VZO6ghgYlA+ntoWgpgUwcLGxLq/XNNaGCJIaO5Q2+9gK8jvWUacx0vM6PVsjW/66Xqp6h1Gkz1K/20Nas4az/5p5AUZ0Fi7bzXQVvNqOiKABf4jWmvPP/3GhHzTGzGGnfPNy61Iwau8qz3K+y3OvNpVvlVL3pKD/QymkjUj20WBnUalBBWLjmFF7vFLdP8gknxcu02A4oqEZejse1NiNxqZOEi4ecsFWpGqvCgXS7TYQvSyDgSdNuRBDuN76GICHUxBfW0yxTLa85tfAmwikgI/hxE0S3ZP9VcK2rDoCsFMpIDDH8shdoRC3dTs0543GrA1WfDzMLi3n6wDAb/STtQE/rVQHWQ1qDaHxFSs4dzQxeMdSev2eWib/ZdaXryt3fhEaocd2jNDTavvPZAoP/Sk5rtP0Ys8KyafIhOov160VOMixXZvJGfu0tY1alXXqD1j9JwO61FO+3dars2ISuouuhC264Y7gB36DbP4X8+c+egiFo/wumA7T+8apa33ZRUBvFYVoFnCJVnzJ63luj72TyGuwpK2QGdh67yjVZ5qOXmkFZpXIJ29OamlO6362DZI8jmm6F3cO/iFkVUL1gyEiSpbdwkramqNHxyJsIbV7hkqxMTN/heXNa8L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199015)(6486002)(26005)(2906002)(86362001)(36756003)(6506007)(6666004)(478600001)(83380400001)(38350700002)(6512007)(38100700002)(52116002)(1076003)(2616005)(186003)(30864003)(44832011)(8936002)(41300700001)(66556008)(4326008)(66476007)(8676002)(5660300002)(66946007)(6916009)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UgCkrU1q21zryt62IfGFkcllskVcpoqJduPs+MPUddmS+TZafU5ZMiEIHKPA?=
 =?us-ascii?Q?lr+aLGYt7pXxWxogwnL6GJM4UMMzbrWDcYvI/4Wy1/YxVG5aWWlzzqhUJvfn?=
 =?us-ascii?Q?KarVlLfSxdRDVEgF68+Du0k0j0ccaY2lgQtWhpoSges+YbGqDoU98FSw+oHW?=
 =?us-ascii?Q?pte7lqb6oTwxzOGPCGB/LNo1S7s9FO/XG6QlORXSALEY9O6gfHmG9VY1ojf8?=
 =?us-ascii?Q?+E1Mrxnv9f4JxueXPTTsOnwEvyIbpfiz0X7o7CO7yx/JOMA6A4BhuXTIO8lm?=
 =?us-ascii?Q?jdUBX+brBOtWu3F6mi2/ZR81nNqsel0fXEN7nexa1LTtmzVe45pjgn4P4AqE?=
 =?us-ascii?Q?okm/7VoPjtUqZ6JNZBCpn8tukHvu9qVBFnUf68YrBhkaWjj6K8FFuuDotog+?=
 =?us-ascii?Q?uu5f2GpHkaYGAdjDMkxrnpRonaECcLM10Ic6d0WSCK0lPW3lf3zXo6zIHUcG?=
 =?us-ascii?Q?8pu1X5Euh5qDUTFBX327jQ9cCoGpBcxJle5esOQdnIX0aJ+GqlGKLBUCX+Yh?=
 =?us-ascii?Q?f14Oa6amUHzRTuY8/EpCYUcjskRIi6sUbkKQ9nB71zutkkpJ6d70VLf5uQPF?=
 =?us-ascii?Q?MNpzbPVciWAvRgnLM2MQt2BQknDaHupIWZuj318/sL2EmR4ytVJsIJL+dS1J?=
 =?us-ascii?Q?wvvx1gK1phSQ9E0MnA1fdRC0bXF8WglutAQltpiQTA+rBfDgoxjR4cfMQDEi?=
 =?us-ascii?Q?98t/HdHg+hXV0u2yvuPym3GGIp33F5mF4IJFM/j2SQRpEHmoq8bOOon74ydg?=
 =?us-ascii?Q?6KqnJOe9XIaeLaczKkZ8uLBl5Sq0X1u3Nbni9ruQJo22PdEQeKkSl10ufahT?=
 =?us-ascii?Q?zLV/i/EYzUfTTkY8zVGoAGmYvm7QENFBT7nkqSntBU1q8qpy1JPSDVvUNNaY?=
 =?us-ascii?Q?I/09FyXFW8taegNBH+AlqIwOunlo7Q+R+8zZShjYE+fMfIeabS06ejP+z0km?=
 =?us-ascii?Q?OW6OzHgi06X3bEyjr1dsMSd86L7sS3nhlH7KC1D7YGpXbRqEFOLRIcdtJufU?=
 =?us-ascii?Q?HxVscNxrOSpmPP510eUIR9SzjqwRVH1fPTNKnh/cCXtW94pZXRcjff/9kIQq?=
 =?us-ascii?Q?78SRcBwog2cxtVp5K5gLTKnnstcUk4wKaDBNnZRyg/XZBEJGlDSMYC9Y+kz+?=
 =?us-ascii?Q?CiWM+EZap6+udoMQkQyFk49495dV1lJyYHyiTxYLZqRBXuSIOqvFJoDIDebh?=
 =?us-ascii?Q?z99C7LljCdP87UlqFfKz5ZdvqSXFnx0oMD1E8tXZcqJ/Jr/D0N6ETalglFuU?=
 =?us-ascii?Q?2Ul9zIXuY8cW8UXitd9vU24OTiKk1gMaxeR7k2s4WsqgDfY86l77/Yop004E?=
 =?us-ascii?Q?9NCfi2prX/2TZpBEVBCSWQWBvK1KtKbbvoNWXUNFTIpFC9k4Jlv/Bm+lHBt9?=
 =?us-ascii?Q?ZJyXRqJC63S6SmVsmz9Yww+QADzL9lKsU52WzKEDlI1BDx2oc6GRlJd2tgpA?=
 =?us-ascii?Q?6BUKTolqBw0pWyJ1/W9kSVCOMUjP4srn2SthxkG4pv8yRjdO6A4VVMDg4DNG?=
 =?us-ascii?Q?uaNcixKLPtGuYByl3wiJcE9aSJWp7cVmmEpwNnA6RnFGvwoletbF/WAFg7sF?=
 =?us-ascii?Q?oxXlas322Bt/yy/+USb1swOhtI+RJ1aZU55pz6QyedrXvbqltHAzBnnuW/1g?=
 =?us-ascii?Q?ww=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae86a56-4667-480b-4683-08dacbc82ba7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:21.4501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +i3MGnqoP18WN5aOUELHEz+Bjb2TFcF/HrRAAWcuEoBh8TsdkUts6bXqBJ74hXY5p400W0FD9msSUPCo7/nQ8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6829
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no longer a meaningful distinction between what goes into
dsa2.c and what goes into dsa.c. Merge the 2 into a single file.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/Makefile   |   1 -
 net/dsa/dsa.c      | 234 ---------------------------------------------
 net/dsa/dsa2.c     | 222 +++++++++++++++++++++++++++++++++++++++++-
 net/dsa/dsa_priv.h |   2 -
 4 files changed, 221 insertions(+), 238 deletions(-)
 delete mode 100644 net/dsa/dsa.c

diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 93f5d5f1e495..f38d0f4bf76c 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -3,7 +3,6 @@
 obj-$(CONFIG_NET_DSA) += dsa_core.o
 dsa_core-y += \
 	devlink.o \
-	dsa.o \
 	dsa2.o \
 	master.o \
 	netlink.o \
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
deleted file mode 100644
index 6f87dd1ee6bf..000000000000
--- a/net/dsa/dsa.c
+++ /dev/null
@@ -1,234 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * net/dsa/dsa.c - Hardware switch handling
- * Copyright (c) 2008-2009 Marvell Semiconductor
- * Copyright (c) 2013 Florian Fainelli <florian@openwrt.org>
- */
-
-#include <linux/device.h>
-#include <linux/list.h>
-#include <linux/module.h>
-#include <linux/netdevice.h>
-#include <linux/sysfs.h>
-
-#include "dsa_priv.h"
-#include "slave.h"
-#include "tag.h"
-
-static int dev_is_class(struct device *dev, void *class)
-{
-	if (dev->class != NULL && !strcmp(dev->class->name, class))
-		return 1;
-
-	return 0;
-}
-
-static struct device *dev_find_class(struct device *parent, char *class)
-{
-	if (dev_is_class(parent, class)) {
-		get_device(parent);
-		return parent;
-	}
-
-	return device_find_child(parent, class, dev_is_class);
-}
-
-struct net_device *dsa_dev_to_net_device(struct device *dev)
-{
-	struct device *d;
-
-	d = dev_find_class(dev, "net");
-	if (d != NULL) {
-		struct net_device *nd;
-
-		nd = to_net_dev(d);
-		dev_hold(nd);
-		put_device(d);
-
-		return nd;
-	}
-
-	return NULL;
-}
-
-#ifdef CONFIG_PM_SLEEP
-static bool dsa_port_is_initialized(const struct dsa_port *dp)
-{
-	return dp->type == DSA_PORT_TYPE_USER && dp->slave;
-}
-
-int dsa_switch_suspend(struct dsa_switch *ds)
-{
-	struct dsa_port *dp;
-	int ret = 0;
-
-	/* Suspend slave network devices */
-	dsa_switch_for_each_port(dp, ds) {
-		if (!dsa_port_is_initialized(dp))
-			continue;
-
-		ret = dsa_slave_suspend(dp->slave);
-		if (ret)
-			return ret;
-	}
-
-	if (ds->ops->suspend)
-		ret = ds->ops->suspend(ds);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(dsa_switch_suspend);
-
-int dsa_switch_resume(struct dsa_switch *ds)
-{
-	struct dsa_port *dp;
-	int ret = 0;
-
-	if (ds->ops->resume)
-		ret = ds->ops->resume(ds);
-
-	if (ret)
-		return ret;
-
-	/* Resume slave network devices */
-	dsa_switch_for_each_port(dp, ds) {
-		if (!dsa_port_is_initialized(dp))
-			continue;
-
-		ret = dsa_slave_resume(dp->slave);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(dsa_switch_resume);
-#endif
-
-static struct workqueue_struct *dsa_owq;
-
-bool dsa_schedule_work(struct work_struct *work)
-{
-	return queue_work(dsa_owq, work);
-}
-
-void dsa_flush_workqueue(void)
-{
-	flush_workqueue(dsa_owq);
-}
-EXPORT_SYMBOL_GPL(dsa_flush_workqueue);
-
-struct dsa_port *dsa_port_from_netdev(struct net_device *netdev)
-{
-	if (!netdev || !dsa_slave_dev_check(netdev))
-		return ERR_PTR(-ENODEV);
-
-	return dsa_slave_to_port(netdev);
-}
-EXPORT_SYMBOL_GPL(dsa_port_from_netdev);
-
-bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b)
-{
-	if (a->type != b->type)
-		return false;
-
-	switch (a->type) {
-	case DSA_DB_PORT:
-		return a->dp == b->dp;
-	case DSA_DB_LAG:
-		return a->lag.dev == b->lag.dev;
-	case DSA_DB_BRIDGE:
-		return a->bridge.num == b->bridge.num;
-	default:
-		WARN_ON(1);
-		return false;
-	}
-}
-
-bool dsa_fdb_present_in_other_db(struct dsa_switch *ds, int port,
-				 const unsigned char *addr, u16 vid,
-				 struct dsa_db db)
-{
-	struct dsa_port *dp = dsa_to_port(ds, port);
-	struct dsa_mac_addr *a;
-
-	lockdep_assert_held(&dp->addr_lists_lock);
-
-	list_for_each_entry(a, &dp->fdbs, list) {
-		if (!ether_addr_equal(a->addr, addr) || a->vid != vid)
-			continue;
-
-		if (a->db.type == db.type && !dsa_db_equal(&a->db, &db))
-			return true;
-	}
-
-	return false;
-}
-EXPORT_SYMBOL_GPL(dsa_fdb_present_in_other_db);
-
-bool dsa_mdb_present_in_other_db(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_mdb *mdb,
-				 struct dsa_db db)
-{
-	struct dsa_port *dp = dsa_to_port(ds, port);
-	struct dsa_mac_addr *a;
-
-	lockdep_assert_held(&dp->addr_lists_lock);
-
-	list_for_each_entry(a, &dp->mdbs, list) {
-		if (!ether_addr_equal(a->addr, mdb->addr) || a->vid != mdb->vid)
-			continue;
-
-		if (a->db.type == db.type && !dsa_db_equal(&a->db, &db))
-			return true;
-	}
-
-	return false;
-}
-EXPORT_SYMBOL_GPL(dsa_mdb_present_in_other_db);
-
-static int __init dsa_init_module(void)
-{
-	int rc;
-
-	dsa_owq = alloc_ordered_workqueue("dsa_ordered",
-					  WQ_MEM_RECLAIM);
-	if (!dsa_owq)
-		return -ENOMEM;
-
-	rc = dsa_slave_register_notifier();
-	if (rc)
-		goto register_notifier_fail;
-
-	dev_add_pack(&dsa_pack_type);
-
-	rc = rtnl_link_register(&dsa_link_ops);
-	if (rc)
-		goto netlink_register_fail;
-
-	return 0;
-
-netlink_register_fail:
-	dsa_slave_unregister_notifier();
-	dev_remove_pack(&dsa_pack_type);
-register_notifier_fail:
-	destroy_workqueue(dsa_owq);
-
-	return rc;
-}
-module_init(dsa_init_module);
-
-static void __exit dsa_cleanup_module(void)
-{
-	rtnl_link_unregister(&dsa_link_ops);
-
-	dsa_slave_unregister_notifier();
-	dev_remove_pack(&dsa_pack_type);
-	destroy_workqueue(dsa_owq);
-}
-module_exit(dsa_cleanup_module);
-
-MODULE_AUTHOR("Lennert Buytenhek <buytenh@wantstofly.org>");
-MODULE_DESCRIPTION("Driver for Distributed Switch Architecture switch chips");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:dsa");
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 7a314c8b3aaa..7a75b0767dd1 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * net/dsa/dsa2.c - Hardware switch handling, binding version 2
+ * DSA topology and switch handling
+ *
  * Copyright (c) 2008-2009 Marvell Semiconductor
  * Copyright (c) 2013 Florian Fainelli <florian@openwrt.org>
  * Copyright (c) 2016 Andrew Lunn <andrew@lunn.ch>
@@ -9,6 +10,7 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/list.h>
+#include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/slab.h>
 #include <linux/rtnetlink.h>
@@ -28,9 +30,22 @@
 static DEFINE_MUTEX(dsa2_mutex);
 LIST_HEAD(dsa_tree_list);
 
+static struct workqueue_struct *dsa_owq;
+
 /* Track the bridges with forwarding offload enabled */
 static unsigned long dsa_fwd_offloading_bridges;
 
+bool dsa_schedule_work(struct work_struct *work)
+{
+	return queue_work(dsa_owq, work);
+}
+
+void dsa_flush_workqueue(void)
+{
+	flush_workqueue(dsa_owq);
+}
+EXPORT_SYMBOL_GPL(dsa_flush_workqueue);
+
 /**
  * dsa_lag_map() - Map LAG structure to a linear LAG array
  * @dst: Tree in which to record the mapping.
@@ -1331,6 +1346,42 @@ static int dsa_switch_parse_of(struct dsa_switch *ds, struct device_node *dn)
 	return dsa_switch_parse_ports_of(ds, dn);
 }
 
+static int dev_is_class(struct device *dev, void *class)
+{
+	if (dev->class != NULL && !strcmp(dev->class->name, class))
+		return 1;
+
+	return 0;
+}
+
+static struct device *dev_find_class(struct device *parent, char *class)
+{
+	if (dev_is_class(parent, class)) {
+		get_device(parent);
+		return parent;
+	}
+
+	return device_find_child(parent, class, dev_is_class);
+}
+
+static struct net_device *dsa_dev_to_net_device(struct device *dev)
+{
+	struct device *d;
+
+	d = dev_find_class(dev, "net");
+	if (d != NULL) {
+		struct net_device *nd;
+
+		nd = to_net_dev(d);
+		dev_hold(nd);
+		put_device(d);
+
+		return nd;
+	}
+
+	return NULL;
+}
+
 static int dsa_port_parse(struct dsa_port *dp, const char *name,
 			  struct device *dev)
 {
@@ -1524,3 +1575,172 @@ void dsa_switch_shutdown(struct dsa_switch *ds)
 	mutex_unlock(&dsa2_mutex);
 }
 EXPORT_SYMBOL_GPL(dsa_switch_shutdown);
+
+#ifdef CONFIG_PM_SLEEP
+static bool dsa_port_is_initialized(const struct dsa_port *dp)
+{
+	return dp->type == DSA_PORT_TYPE_USER && dp->slave;
+}
+
+int dsa_switch_suspend(struct dsa_switch *ds)
+{
+	struct dsa_port *dp;
+	int ret = 0;
+
+	/* Suspend slave network devices */
+	dsa_switch_for_each_port(dp, ds) {
+		if (!dsa_port_is_initialized(dp))
+			continue;
+
+		ret = dsa_slave_suspend(dp->slave);
+		if (ret)
+			return ret;
+	}
+
+	if (ds->ops->suspend)
+		ret = ds->ops->suspend(ds);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dsa_switch_suspend);
+
+int dsa_switch_resume(struct dsa_switch *ds)
+{
+	struct dsa_port *dp;
+	int ret = 0;
+
+	if (ds->ops->resume)
+		ret = ds->ops->resume(ds);
+
+	if (ret)
+		return ret;
+
+	/* Resume slave network devices */
+	dsa_switch_for_each_port(dp, ds) {
+		if (!dsa_port_is_initialized(dp))
+			continue;
+
+		ret = dsa_slave_resume(dp->slave);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dsa_switch_resume);
+#endif
+
+struct dsa_port *dsa_port_from_netdev(struct net_device *netdev)
+{
+	if (!netdev || !dsa_slave_dev_check(netdev))
+		return ERR_PTR(-ENODEV);
+
+	return dsa_slave_to_port(netdev);
+}
+EXPORT_SYMBOL_GPL(dsa_port_from_netdev);
+
+bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b)
+{
+	if (a->type != b->type)
+		return false;
+
+	switch (a->type) {
+	case DSA_DB_PORT:
+		return a->dp == b->dp;
+	case DSA_DB_LAG:
+		return a->lag.dev == b->lag.dev;
+	case DSA_DB_BRIDGE:
+		return a->bridge.num == b->bridge.num;
+	default:
+		WARN_ON(1);
+		return false;
+	}
+}
+
+bool dsa_fdb_present_in_other_db(struct dsa_switch *ds, int port,
+				 const unsigned char *addr, u16 vid,
+				 struct dsa_db db)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_mac_addr *a;
+
+	lockdep_assert_held(&dp->addr_lists_lock);
+
+	list_for_each_entry(a, &dp->fdbs, list) {
+		if (!ether_addr_equal(a->addr, addr) || a->vid != vid)
+			continue;
+
+		if (a->db.type == db.type && !dsa_db_equal(&a->db, &db))
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(dsa_fdb_present_in_other_db);
+
+bool dsa_mdb_present_in_other_db(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_mdb *mdb,
+				 struct dsa_db db)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_mac_addr *a;
+
+	lockdep_assert_held(&dp->addr_lists_lock);
+
+	list_for_each_entry(a, &dp->mdbs, list) {
+		if (!ether_addr_equal(a->addr, mdb->addr) || a->vid != mdb->vid)
+			continue;
+
+		if (a->db.type == db.type && !dsa_db_equal(&a->db, &db))
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(dsa_mdb_present_in_other_db);
+
+static int __init dsa_init_module(void)
+{
+	int rc;
+
+	dsa_owq = alloc_ordered_workqueue("dsa_ordered",
+					  WQ_MEM_RECLAIM);
+	if (!dsa_owq)
+		return -ENOMEM;
+
+	rc = dsa_slave_register_notifier();
+	if (rc)
+		goto register_notifier_fail;
+
+	dev_add_pack(&dsa_pack_type);
+
+	rc = rtnl_link_register(&dsa_link_ops);
+	if (rc)
+		goto netlink_register_fail;
+
+	return 0;
+
+netlink_register_fail:
+	dsa_slave_unregister_notifier();
+	dev_remove_pack(&dsa_pack_type);
+register_notifier_fail:
+	destroy_workqueue(dsa_owq);
+
+	return rc;
+}
+module_init(dsa_init_module);
+
+static void __exit dsa_cleanup_module(void)
+{
+	rtnl_link_unregister(&dsa_link_ops);
+
+	dsa_slave_unregister_notifier();
+	dev_remove_pack(&dsa_pack_type);
+	destroy_workqueue(dsa_owq);
+}
+module_exit(dsa_cleanup_module);
+
+MODULE_AUTHOR("Lennert Buytenhek <buytenh@wantstofly.org>");
+MODULE_DESCRIPTION("Driver for Distributed Switch Architecture switch chips");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:dsa");
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index e5d421cdaa8f..3f6f84150592 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -44,8 +44,6 @@ struct dsa_standalone_event_work {
 };
 
 /* dsa.c */
-struct net_device *dsa_dev_to_net_device(struct device *dev);
-
 bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b);
 
 bool dsa_schedule_work(struct work_struct *work);
-- 
2.34.1

