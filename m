Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A94237C0A1
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhELOuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:50:24 -0400
Received: from mail-co1nam11on2056.outbound.protection.outlook.com ([40.107.220.56]:59617
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231396AbhELOuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgvPSzwTdAwPcDQgQwOs2uYJV/ywBLOuna+GhptH/kzTGj8k+XOz/GnwiyIVmUtehKxGKW+YTqUlp7FVXi9tDehlpWthhNRCBTZOZvmb6iWwofpoygtZFWLiIowpAiSGjdxJke/h01E50VMpyKLpon5o8kFHD35a3KXPCPFzNXeXGriOfEj9G4o3Hm2QDD4AkABcG0pVG/l1TusxzafzIvsxxUSlO/ZqmPlfjm14negdAXGIIKUqLUtHabyMq+ZA8ga6r7KHn3aVwA68VgZjk2xE3Hz1Zr24V7KiQWPA5XuRsWUUtxv/KRT7TU5MoBdQhUVnngA8t2mGCad3+LbQAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gl+52mnQcZq3/J+bkNVDr5hRXD9Y1kPYC2Z/Z0abwI0=;
 b=AF+mD60gRl5i1YE4jD9Edh6AWEEkY44boDA2llCOe8yZuK2T+jdUX4ZcgU6PFFgaX9V7N6jMdghOCa+pyWFcjgdrdqkWw4+4yZ0gx1WeYyniNox/gX2QqnkuQDDmt5X0nIEELmmy9f/1ZShTeFY15bSZlsUgbYaN8iwckwznQEp9EtvoB6gwA8PUMQirh3v2w2MJCyXiv+9tcfhLp1bxE2gFfADkZu5m7F48GFsGkRsvF9nLOtUNuYx2MDubpcCXTy2L3qFE3YZWO+cNfnxuEETlRvF5N0CnN9W+tQwp2xiHd2XqhHLAhlFEdjLQtOAhLMzMJI7H/wzJEYuiBr68+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gl+52mnQcZq3/J+bkNVDr5hRXD9Y1kPYC2Z/Z0abwI0=;
 b=XmTZK4/SbOxGDvWstSjyJUY23jGHnXZnQ1jd8YDVJoirdJY3IO22OUlAii9fIl4dIYxk5M4+OQHhJzUbrLAztFno4bz0lmxMKX5DxCGzDzZ1P7YmUlHuQG/rJvqix4BIlf70RMU//YEVaJU7UfjysWVPe91PqqgvgNMS8yzNxLkG3U3+fMwMvO9VAqXmDQYOHzkNv27C6+eRbxbAXbVlCx+aKLl2NY6neUYuTFziFNCO9pnpQehdgWOI5S5x3z8QUn4AxT9WOvtYkCUhLKVuwZGlxhSm/jv2a7gaTSZhSonEtHpWT8YUoEGzw/wwx+3HXkkv9yFqApSUM5+GQrQGpA==
Received: from DM3PR03CA0022.namprd03.prod.outlook.com (2603:10b6:0:50::32) by
 DM6PR12MB3674.namprd12.prod.outlook.com (2603:10b6:5:1c4::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.26; Wed, 12 May 2021 14:49:01 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:50:cafe::cd) by DM3PR03CA0022.outlook.office365.com
 (2603:10b6:0:50::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend
 Transport; Wed, 12 May 2021 14:49:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:00 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:49:00 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:48:57 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 03/18] netdevsim: Implement port types and indexing
Date:   Wed, 12 May 2021 17:48:32 +0300
Message-ID: <1620830927-11828-4-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03b074a3-1c4e-4706-da99-08d915551472
X-MS-TrafficTypeDiagnostic: DM6PR12MB3674:
X-Microsoft-Antispam-PRVS: <DM6PR12MB367439B7057717FC86A71646CB529@DM6PR12MB3674.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BycMaDgxH8z0hjgmjqqMR33SJ1uguSU94YvANjAN8mafRBH4Eyq5iKbtK44NHc4SYMJqPsQuVdI+SspzOj90UDF6jg1TVbucn6qWV5KNwfJvEoZIjaTVTPa1IkslzdfD/huNsPgzU2PaOnI3rjB4QiuU+dFp98hDMoe7MnLjskEo7QgeeHC9hFBlQ68rcQi230G11K2kJRYxqAVqjvtVuemt9isyHJ1mp7a8fdaSZomkBo0q50eM5ROuKRkzYn/YufpgtAkDfXzkxjt0+VKJTPuwHbzzRTWuEicu1lSi8B5SFDpFjCYO9hFYlrhRL7IoBSDpr3xWcbiJYDpjC+x8lSfH37cbyKiZjmR6+O7kaWv8xu+emhlET1Ds6DUmsf+jO4dSp9XIvY9Ll4lVkliSyiLpudXmGwnGldL8B3n6UMbv4XqPsPIFae+nWNXlR6b0FXUF9GIs/IMcbS6PAF7PVj67cEiuYOdmkyaXDcQypNsPLYJlFrhLvYKtLRSFdG7cnT28XvRpDc8hYQtorFgiw2rwu2ChlgJwRv+oPAR6//Ka+josxSficYxJDC8pX5IdTpW8XBALLLD3o1SMFElmG9UYb7qtinXIAWsfiZzF5MiK1H9vSCAiqREeL/qhaWK1BJ18aNzMue4puS2QrRhE8A==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(46966006)(36840700001)(82740400003)(186003)(2616005)(36860700001)(426003)(107886003)(336012)(7636003)(7696005)(47076005)(6666004)(86362001)(4326008)(26005)(36906005)(356005)(2906002)(54906003)(8676002)(83380400001)(36756003)(2876002)(316002)(478600001)(70206006)(70586007)(8936002)(6916009)(82310400003)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:00.8011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03b074a3-1c4e-4706-da99-08d915551472
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Define type of ports, which netdevsim driver currently operates with as
PF. Define new port type - VF, which will be implemented in following
patches. Add helper functions to distinguish them. Add helper function
to get VF index from port index.

Add port indexing logic where PFs' indexes starts from 0, VFs' - from
NSIM_DEV_VF_PORT_INDEX_BASE.
All ports uses same index pool, which means that PF port may be created
with index from VFs' indexes range.
Maximum number of VFs, which the driver can allocate, is limited by
UINT_MAX - BASE.

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/bus.c       | 10 ++++++++--
 drivers/net/netdevsim/dev.c       | 42 +++++++++++++++++++++++++++++----------
 drivers/net/netdevsim/netdevsim.h | 20 +++++++++++++++++++
 3 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index d5c547c..e29146d 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -141,6 +141,12 @@ ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 		goto unlock;
 	}
 
+	/* max_vfs limited by the maximum number of provided port indexes */
+	if (val > NSIM_DEV_VF_PORT_INDEX_MAX - NSIM_DEV_VF_PORT_INDEX_BASE) {
+		ret = -ERANGE;
+		goto unlock;
+	}
+
 	vfconfigs = kcalloc(val, sizeof(struct nsim_vf_config), GFP_KERNEL | __GFP_NOWARN);
 	if (!vfconfigs) {
 		ret = -ENOMEM;
@@ -178,7 +184,7 @@ ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 
 	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
 	devlink_reload_disable(devlink);
-	ret = nsim_dev_port_add(nsim_bus_dev, port_index);
+	ret = nsim_dev_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
 	devlink_reload_enable(devlink);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
@@ -207,7 +213,7 @@ ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 
 	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
 	devlink_reload_disable(devlink);
-	ret = nsim_dev_port_del(nsim_bus_dev, port_index);
+	ret = nsim_dev_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
 	devlink_reload_enable(devlink);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index cd50c05..93d6f3d 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -35,6 +35,25 @@
 
 #include "netdevsim.h"
 
+static unsigned int
+nsim_dev_port_index(enum nsim_dev_port_type type, unsigned int port_index)
+{
+	switch (type) {
+	case NSIM_DEV_PORT_TYPE_VF:
+		port_index = NSIM_DEV_VF_PORT_INDEX_BASE + port_index;
+		break;
+	case NSIM_DEV_PORT_TYPE_PF:
+		break;
+	}
+
+	return port_index;
+}
+
+static inline unsigned int nsim_dev_port_index_to_vf_index(unsigned int port_index)
+{
+	return port_index - NSIM_DEV_VF_PORT_INDEX_BASE;
+}
+
 static struct dentry *nsim_dev_ddir;
 
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
@@ -923,7 +942,7 @@ static int nsim_dev_devlink_trap_init(struct devlink *devlink,
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
 #define NSIM_DEV_TEST1_DEFAULT true
 
-static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
+static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_type type,
 			       unsigned int port_index)
 {
 	struct devlink_port_attrs attrs = {};
@@ -934,7 +953,8 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 	nsim_dev_port = kzalloc(sizeof(*nsim_dev_port), GFP_KERNEL);
 	if (!nsim_dev_port)
 		return -ENOMEM;
-	nsim_dev_port->port_index = port_index;
+	nsim_dev_port->port_index = nsim_dev_port_index(type, port_index);
+	nsim_dev_port->port_type = type;
 
 	devlink_port = &nsim_dev_port->devlink_port;
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
@@ -943,7 +963,7 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 	attrs.switch_id.id_len = nsim_dev->switch_id.id_len;
 	devlink_port_attrs_set(devlink_port, &attrs);
 	err = devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
-				    port_index);
+				    nsim_dev_port->port_index);
 	if (err)
 		goto err_port_free;
 
@@ -1000,7 +1020,7 @@ static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
 	int i, err;
 
 	for (i = 0; i < port_count; i++) {
-		err = __nsim_dev_port_add(nsim_dev, i);
+		err = __nsim_dev_port_add(nsim_dev, NSIM_DEV_PORT_TYPE_PF, i);
 		if (err)
 			goto err_port_del_all;
 	}
@@ -1216,32 +1236,34 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 }
 
 static struct nsim_dev_port *
-__nsim_dev_port_lookup(struct nsim_dev *nsim_dev, unsigned int port_index)
+__nsim_dev_port_lookup(struct nsim_dev *nsim_dev, enum nsim_dev_port_type type,
+		       unsigned int port_index)
 {
 	struct nsim_dev_port *nsim_dev_port;
 
+	port_index = nsim_dev_port_index(type, port_index);
 	list_for_each_entry(nsim_dev_port, &nsim_dev->port_list, list)
 		if (nsim_dev_port->port_index == port_index)
 			return nsim_dev_port;
 	return NULL;
 }
 
-int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev,
+int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type type,
 		      unsigned int port_index)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	int err;
 
 	mutex_lock(&nsim_dev->port_list_lock);
-	if (__nsim_dev_port_lookup(nsim_dev, port_index))
+	if (__nsim_dev_port_lookup(nsim_dev, type, port_index))
 		err = -EEXIST;
 	else
-		err = __nsim_dev_port_add(nsim_dev, port_index);
+		err = __nsim_dev_port_add(nsim_dev, type, port_index);
 	mutex_unlock(&nsim_dev->port_list_lock);
 	return err;
 }
 
-int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
+int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type type,
 		      unsigned int port_index)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
@@ -1249,7 +1271,7 @@ int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
 	int err = 0;
 
 	mutex_lock(&nsim_dev->port_list_lock);
-	nsim_dev_port = __nsim_dev_port_lookup(nsim_dev, port_index);
+	nsim_dev_port = __nsim_dev_port_lookup(nsim_dev, type, port_index);
 	if (!nsim_dev_port)
 		err = -ENOENT;
 	else
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index a1b49c8..e025c1b 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -197,10 +197,19 @@ static inline void nsim_dev_psample_exit(struct nsim_dev *nsim_dev)
 }
 #endif
 
+enum nsim_dev_port_type {
+	NSIM_DEV_PORT_TYPE_PF,
+	NSIM_DEV_PORT_TYPE_VF,
+};
+
+#define NSIM_DEV_VF_PORT_INDEX_BASE 128
+#define NSIM_DEV_VF_PORT_INDEX_MAX UINT_MAX
+
 struct nsim_dev_port {
 	struct list_head list;
 	struct devlink_port devlink_port;
 	unsigned int port_index;
+	enum nsim_dev_port_type port_type;
 	struct dentry *ddir;
 	struct netdevsim *ns;
 };
@@ -260,8 +269,10 @@ static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
 int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev);
 void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev);
 int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev,
+		      enum nsim_dev_port_type type,
 		      unsigned int port_index);
 int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
+		      enum nsim_dev_port_type type,
 		      unsigned int port_index);
 
 struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
@@ -278,6 +289,15 @@ ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 				   size_t count, loff_t *ppos);
 void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev);
 
+static inline bool nsim_dev_port_is_pf(struct nsim_dev_port *nsim_dev_port)
+{
+	return nsim_dev_port->port_type == NSIM_DEV_PORT_TYPE_PF;
+}
+
+static inline bool nsim_dev_port_is_vf(struct nsim_dev_port *nsim_dev_port)
+{
+	return nsim_dev_port->port_type == NSIM_DEV_PORT_TYPE_VF;
+}
 #if IS_ENABLED(CONFIG_XFRM_OFFLOAD)
 void nsim_ipsec_init(struct netdevsim *ns);
 void nsim_ipsec_teardown(struct netdevsim *ns);
-- 
1.8.3.1

