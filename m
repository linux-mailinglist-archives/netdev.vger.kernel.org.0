Return-Path: <netdev+bounces-11964-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CE0E735755
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:52:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9E1B1C209E1
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:52:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E183D307;
	Mon, 19 Jun 2023 12:52:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689BEC8DC
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 12:52:03 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2722EE7F
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 05:51:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJRdvLtqgZgLyJf8KSdlPgTBAraK6ngch6dcDnbr3tGvwQLD/fbS9qOPj/JnARfc9FUq9pTEsdBG3uN+Zjic3YpXWdxTEC03xtoQI43tNKv0GtJq3i7QChuL0fb5UwZADiYNwDdppkRMu6jhVzUGcwq3lUsoY9HXCa3v7M9nOGvhavbhVkF3yhuqO5G15WuWHk4vtOCTQ0ZlsXh72g0uoF/0CCcrp8dUf8bWeQwwUbMVDn9hJrromOKzRXrMBYYmzjtuocZ4doPnotsit0ISOJYUrhZjjythj2BG3mcBllujjdPWIh0JPs67Nz2/6dNqQKH3U0R7dj2uLhFjzZOtMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vOU32seMfkBjGQQP71JeUHRFWNlHECOYcMG4k9cAfJs=;
 b=dLlRlqhZakrKfH+ijibLoVbL7g+/YtxRdoX7u4VFz1w2b4Hciw3j4boQ1lQC3aYTItzbjX9dWZjbaDrRN2GEPfvRbp3tamGj3NyAZsjRgiVTuAZHYLmZVS8N4jxZ8qbQ1+YfgrW6POS4dLTm4sJcLIzfdW7jbBu7yDHiIrLlUcYt2/NpHH64zLNs8Nm/KR0adAgCViSilZOFeoMb6zBY56zwX/h82g0KczzHoyCf4lXWCx0L8E3EKdUQ1Seh+2HtZA3/JMliTdN+cOr2WkFgyWWvnsc0841IO9XL/nTcgoZMsbdVX6g7QEusoUXho5SiKzIfdJwo50H1bDvq7asv2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOU32seMfkBjGQQP71JeUHRFWNlHECOYcMG4k9cAfJs=;
 b=lr+zvBstVbxCgl/MCLpgBQVv7zxNREKzo6MSJq5vf4ewPQpXtw8C0KSa6iZ240F6591TcfqS8gyjT/Nj97PjvK0lJPbyC55GSNYLXDF2MMzmPTizN9I7o1ahdHuOpw+IwY4ClC9cF1x24WqquLhz1Dmgm+7S5P/VMo54ZI7iQCJfUwrUScsKoEZukE4k+4ZDM7sWRyZjpfzdNJnp/xaYHBbxFPmQ8DTVdbcdUTIuv8lKa1fTc5ebxlPKoPmn0nJEvKSyxRomrD6/xaGU+WWSHzkamYYHgOMLNnD8fLWz8Bl1uuPHIlM+yh5PXaKdzt0Wck+0aFNbyLd8EjfT5U/yxA==
Received: from DM6PR05CA0055.namprd05.prod.outlook.com (2603:10b6:5:335::24)
 by SJ2PR12MB8692.namprd12.prod.outlook.com (2603:10b6:a03:543::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Mon, 19 Jun
 2023 12:50:59 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::c5) by DM6PR05CA0055.outlook.office365.com
 (2603:10b6:5:335::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Mon, 19 Jun 2023 12:50:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Mon, 19 Jun 2023 12:50:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 19 Jun 2023
 05:50:46 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 19 Jun 2023 05:50:43 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <jiri@resnulli.us>, <petrm@nvidia.com>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [RFC PATCH net-next 2/2] devlink: Acquire device lock during reload
Date: Mon, 19 Jun 2023 15:50:15 +0300
Message-ID: <20230619125015.1541143-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230619125015.1541143-1-idosch@nvidia.com>
References: <20230619125015.1541143-1-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT020:EE_|SJ2PR12MB8692:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fbb0deb-3615-4013-880f-08db70c3d50a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	V9lu1YVGoBRbNqv0GmTBApcu+HH3SvQXepa7mp4TgMdPKoWvVye+anA56I7vf1nfFJtk/nLKXh31i6f9g8Begga8zMdHz4vs7uxJuK6eTX5A2/zMYC0ZdfhOUXnMLVdWKvAYMZcLxLpFEnwVMRdOU9JhBCFKn42UDnvXIGLOjnjlzXCPNWQDSTrvPwB0M4RlqvUg5KKB74ZfqI6QYa5gBTZGYJ6gITtWcMtTbNMjMpUAhIztdZ1D3rnYY7y4l9Q6fuEs2KTXTofXMaxsdMcsBnaTJE+olO2lLcJFMVjfRtrZgUmKwVSVVK6Th36ggXo+XdRC9JWqtAghKXbbY9yTxTT+/1rKVPl8cUd1WYP38/O1U/lXnmJcaQIdqd8p+CABfeCtPx0QSeBXZXVjSpB2J+dRhc5L/qcVDOAFHzoonJksA7dr4KCtgkMcD00J51541BjioUgtpP/BuVB6U4mfICnNEPQuv9D+i7+W9Vku7kK1WkTqHen/C4Ja+FksxUG6KnsqJgqQ6hj8y0WVpk2Qg1tODPKhPr7iFnM2Ke0i9pAKJxM0PbIDfngpLSuPGwLwakePVsebwGD6EcOqLNrRFnk1r/Jnbu7pHWPWJgIBZRbfrH0CoRghU9fjTM+pwJeZcCic2bmH7jgdse1vIQ884FYSUdrmUjQBWrbqrlothGrWFC7J2g6m0PGeELqCoClHy/1v1rczXm6eJAPJCXztGST2Wbmz50xvHWCqpa1PZb2JzZ60x+ftRKtgAymlTz9n
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199021)(40470700004)(46966006)(36840700001)(82310400005)(478600001)(4326008)(6916009)(70206006)(70586007)(36756003)(6666004)(356005)(54906003)(316002)(40460700003)(86362001)(1076003)(36860700001)(186003)(16526019)(2616005)(7636003)(336012)(82740400003)(5660300002)(41300700001)(8936002)(8676002)(2906002)(26005)(107886003)(426003)(83380400001)(47076005)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 12:50:59.6665
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fbb0deb-3615-4013-880f-08db70c3d50a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8692
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Device drivers register with devlink from their probe routines (under
the device lock) by acquiring the devlink instance lock and calling
devl_register().

Drivers that support a devlink reload usually implement the
reload_{down, up}() operations in a similar fashion to their remove and
probe routines, respectively.

However, while the remove and probe routines are invoked with the device
lock held, the reload operations are only invoked with the devlink
instance lock held. It is therefore impossible for drivers to acquire
the device lock from their reload operations, as this would result in
lock inversion.

The motivating use case for invoking the reload operations with the
device lock held is in mlxsw which needs to trigger a PCI reset as part
of the reload. The driver cannot call pci_reset_function() as this
function acquires the device lock. Instead, it needs to call
__pci_reset_function_locked which expects the device lock to be held.

To that end, adjust devlink to always acquire the device lock before the
devlink instance lock when performing a reload. Do that both when reload
is triggered explicitly by user space and when it is triggered as part
of netns dismantle.

Tested the following flows with netdevsim and mlxsw while lockdep is
enabled:

netdevsim:

 # echo "10 1" > /sys/bus/netdevsim/new_device
 # devlink dev reload netdevsim/netdevsim10
 # ip netns add bla
 # devlink dev reload netdevsim/netdevsim10 netns bla
 # ip netns del bla
 # echo 10 > /sys/bus/netdevsim/del_device

mlxsw:

 # devlink dev reload pci/0000:01:00.0
 # ip netns add bla
 # devlink dev reload pci/0000:01:00.0 netns bla
 # ip netns del bla
 # echo 1 > /sys/bus/pci/devices/0000\:01\:00.0/remove
 # echo 1 > /sys/bus/pci/rescan

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/devlink/core.c          |  4 ++--
 net/devlink/dev.c           |  8 ++++++++
 net/devlink/devl_internal.h | 19 ++++++++++++++++++-
 net/devlink/health.c        |  3 ++-
 net/devlink/leftover.c      |  4 +++-
 net/devlink/netlink.c       | 18 ++++++++++++------
 6 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index b191112f57af..a4b6d548e50c 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -279,14 +279,14 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 	 * all devlink instances from this namespace into init_net.
 	 */
 	devlinks_xa_for_each_registered_get(net, index, devlink) {
-		devl_lock(devlink);
+		devl_dev_lock(devlink, true);
 		err = 0;
 		if (devl_is_registered(devlink))
 			err = devlink_reload(devlink, &init_net,
 					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
 					     DEVLINK_RELOAD_LIMIT_UNSPEC,
 					     &actions_performed, NULL);
-		devl_unlock(devlink);
+		devl_dev_unlock(devlink, true);
 		devlink_put(devlink);
 		if (err && err != -EOPNOTSUPP)
 			pr_warn("Failed to reload devlink instance into init_net\n");
diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index bf1d6f1bcfc7..daee2039fb58 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2016 Jiri Pirko <jiri@mellanox.com>
  */
 
+#include <linux/device.h>
 #include <net/genetlink.h>
 #include <net/sock.h>
 #include "devl_internal.h"
@@ -356,6 +357,13 @@ int devlink_reload(struct devlink *devlink, struct net *dest_net,
 	struct net *curr_net;
 	int err;
 
+	/* Make sure the reload operations are invoked with the device lock
+	 * held to allow drivers to trigger functionality that expects it
+	 * (e.g., PCI reset) and to close possible races between these
+	 * operations and probe/remove.
+	 */
+	device_lock_assert(devlink->dev);
+
 	memcpy(remote_reload_stats, devlink->stats.remote_reload_stats,
 	       sizeof(remote_reload_stats));
 
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 62921b2eb0d3..99c3efbae718 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -3,6 +3,7 @@
  * Copyright (c) 2016 Jiri Pirko <jiri@mellanox.com>
  */
 
+#include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
 #include <linux/notifier.h>
@@ -87,12 +88,27 @@ static inline bool devl_is_registered(struct devlink *devlink)
 	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 }
 
+static inline void devl_dev_lock(struct devlink *devlink, bool dev_lock)
+{
+	if (dev_lock)
+		device_lock(devlink->dev);
+	devl_lock(devlink);
+}
+
+static inline void devl_dev_unlock(struct devlink *devlink, bool dev_lock)
+{
+	devl_unlock(devlink);
+	if (dev_lock)
+		device_unlock(devlink->dev);
+}
+
 /* Netlink */
 #define DEVLINK_NL_FLAG_NEED_PORT		BIT(0)
 #define DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT	BIT(1)
 #define DEVLINK_NL_FLAG_NEED_RATE		BIT(2)
 #define DEVLINK_NL_FLAG_NEED_RATE_NODE		BIT(3)
 #define DEVLINK_NL_FLAG_NEED_LINECARD		BIT(4)
+#define DEVLINK_NL_FLAG_NEED_DEV_LOCK		BIT(5)
 
 enum devlink_multicast_groups {
 	DEVLINK_MCGRP_CONFIG,
@@ -122,7 +138,8 @@ struct devlink_cmd {
 extern const struct genl_small_ops devlink_nl_ops[56];
 
 struct devlink *
-devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs);
+devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs,
+			    bool dev_lock);
 
 void devlink_notify_unregister(struct devlink *devlink);
 void devlink_notify_register(struct devlink *devlink);
diff --git a/net/devlink/health.c b/net/devlink/health.c
index 194340a8bb86..fa8ccdcffb7a 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -1253,7 +1253,8 @@ devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 	struct nlattr **attrs = info->attrs;
 	struct devlink *devlink;
 
-	devlink = devlink_get_from_attrs_lock(sock_net(cb->skb->sk), attrs);
+	devlink = devlink_get_from_attrs_lock(sock_net(cb->skb->sk), attrs,
+					      false);
 	if (IS_ERR(devlink))
 		return NULL;
 	devl_unlock(devlink);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 1f00f874471f..f4e6030e3b56 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -5185,7 +5185,8 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	start_offset = state->start_offset;
 
-	devlink = devlink_get_from_attrs_lock(sock_net(cb->skb->sk), attrs);
+	devlink = devlink_get_from_attrs_lock(sock_net(cb->skb->sk), attrs,
+					      false);
 	if (IS_ERR(devlink))
 		return PTR_ERR(devlink);
 
@@ -6478,6 +6479,7 @@ const struct genl_small_ops devlink_nl_ops[56] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_reload,
 		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEV_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_PARAM_GET,
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index 7a332eb70f70..95fd8e3befea 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -83,7 +83,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 };
 
 struct devlink *
-devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs)
+devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs,
+			    bool dev_lock)
 {
 	struct devlink *devlink;
 	unsigned long index;
@@ -97,12 +98,12 @@ devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs)
 	devname = nla_data(attrs[DEVLINK_ATTR_DEV_NAME]);
 
 	devlinks_xa_for_each_registered_get(net, index, devlink) {
-		devl_lock(devlink);
+		devl_dev_lock(devlink, dev_lock);
 		if (devl_is_registered(devlink) &&
 		    strcmp(devlink->dev->bus->name, busname) == 0 &&
 		    strcmp(dev_name(devlink->dev), devname) == 0)
 			return devlink;
-		devl_unlock(devlink);
+		devl_dev_unlock(devlink, dev_lock);
 		devlink_put(devlink);
 	}
 
@@ -115,9 +116,12 @@ static int devlink_nl_pre_doit(const struct genl_split_ops *ops,
 	struct devlink_linecard *linecard;
 	struct devlink_port *devlink_port;
 	struct devlink *devlink;
+	bool dev_lock;
 	int err;
 
-	devlink = devlink_get_from_attrs_lock(genl_info_net(info), info->attrs);
+	dev_lock = !!(ops->internal_flags & DEVLINK_NL_FLAG_NEED_DEV_LOCK);
+	devlink = devlink_get_from_attrs_lock(genl_info_net(info), info->attrs,
+					      dev_lock);
 	if (IS_ERR(devlink))
 		return PTR_ERR(devlink);
 
@@ -162,7 +166,7 @@ static int devlink_nl_pre_doit(const struct genl_split_ops *ops,
 	return 0;
 
 unlock:
-	devl_unlock(devlink);
+	devl_dev_unlock(devlink, dev_lock);
 	devlink_put(devlink);
 	return err;
 }
@@ -171,9 +175,11 @@ static void devlink_nl_post_doit(const struct genl_split_ops *ops,
 				 struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink *devlink;
+	bool dev_lock;
 
+	dev_lock = !!(ops->internal_flags & DEVLINK_NL_FLAG_NEED_DEV_LOCK);
 	devlink = info->user_ptr[0];
-	devl_unlock(devlink);
+	devl_dev_unlock(devlink, dev_lock);
 	devlink_put(devlink);
 }
 
-- 
2.40.1


