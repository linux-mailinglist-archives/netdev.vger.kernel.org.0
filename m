Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF470366F84
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244113AbhDUPyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:54:52 -0400
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:45856
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244120AbhDUPxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:53:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9sd8vrOxagCb5jzmrVyRVbWPNBkg0s3HtP5kcwywZ+H0BXbLteMbbJohuH5Gb5RLwzn4bojvqMsQ+UPXxOJpj0V24Mx8fJQdSjm8D4/dzfaAu5hf6syMNXWryreohh7v52WwluVdZuidaOtAmUwflcuf68/HoVCh7K9evbMAJ0iLR3nX+RKt/QvcW8rb3Kr1whhOcDKl7udHGZeY5ER/kydgNtfB3Bwp1Hn0xy5bkSRcw/X+/VV2RZSnRrNwRfedEwEDVaQRwzYRiDlO/rGMMrj6QMPlIwSlfRReitswJv8OSZDdhF0S0eqJ7+n+emvKiitaYhRDgDu5Dqipe5Viw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gl+52mnQcZq3/J+bkNVDr5hRXD9Y1kPYC2Z/Z0abwI0=;
 b=dHKBMBAD156xHCXiarGvg9rfRtYIEAtQat2WQu2zAUCfetLld8UJjecxWjr7qXKtRO5dYs3RFnc5zdiEfXxZ8WleJTXlkuwVVEcH8d6rg8Yq21qlRs03r6CqyJYlv/GUV3Dl3vWmAORiZhJdzJlmHjqJZWqX1/aYJQTopMMg0b08FX4030+khdEU78VsjaIZT3vtX1HK5xPV3EPOEPLgZrzUR4hcklxAi5f2oWr3bHFMv7Tz2ku4UG0zudm04TYt/UYQ4PWd2F3sAWpA1GHHmWXN6lD1HcQvEeSuwXR0CNhtnvO9i+PLd7p7ac964Baxu5zyLfm6KAz4QKyMyfHYlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gl+52mnQcZq3/J+bkNVDr5hRXD9Y1kPYC2Z/Z0abwI0=;
 b=pSSBuuGCqGCzPooRgm95dtLhqAXU/G+pozm8UTPER5+haagVBS1EkbcLpm4WbLd/HXNMPvhyfDkhUSV3rdrJ9mSOpr2qphcSPIKz4+UaTM7DY7u5yVi7gWNokHG+osjPp0vrPv3/9HvI6xC6M6NTQpJyLIo9+c36CQPf3bDCRcvl6ITzEquF1UP0wGNBmhP0DK+2Mq1Ln6RExxiQGtaGdmp8mXWx27xHTzFgPvPai8nkoN9iXfbJs5tDpp2niO44HCMJ9gYgDxvm2plkLFfTjvQDR9PdI1WYW0n2ZbY54pWdUh89D8tAsqY95r9IZD6fQKt4rorvMy8nVBfKUkZr2Q==
Received: from MWHPR17CA0089.namprd17.prod.outlook.com (2603:10b6:300:c2::27)
 by DM6PR12MB4987.namprd12.prod.outlook.com (2603:10b6:5:163::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Wed, 21 Apr
 2021 15:53:17 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c2:cafe::14) by MWHPR17CA0089.outlook.office365.com
 (2603:10b6:300:c2::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:17 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 08:53:15 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:13 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 03/18] netdevsim: Implement port types and indexing
Date:   Wed, 21 Apr 2021 18:52:50 +0300
Message-ID: <1619020385-20220-4-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e4255c4-bdbc-49b3-124e-08d904dd946b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4987:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4987724A71427B3296301778CB479@DM6PR12MB4987.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nGwRbwFeL9mCBa34B174Jz96jRPp4fIwuPAukcEC7VpGGpXDQAHiD6pOfVmPiys/9czISLgPuSxefR0XTK29adD+c9dNHmjWYHyLBE7Yxe01Vn857ZXuFtztFTzRedhE+z/6TbOqwVn8H6a4k+bApEB/d0CvtDEpf7gewHuw/XVRupYcR5sNg51soTLQY77V8UTCjK/foUVHH/QA7dkI0OrMcV77UMdMsD5buec5OkNAvHhpkjq5g+mV3lT6uzpOMu7HZjBA9Wmw/8nMMXBJz5/gUytVhnmfs1+pLGLaoDt70kXA7EBnIErlxngcdLaIgOgdPzUg4/PijJjRy7NLJlD5nXJoS87DdkHyuE4dxS/BIIbM5+dyVI8iA/Hpon/W2uAEEYPvrFRe4wbih9pgXmW1QiS8u6RSZHKc7AQ9fiC/c2NHvRJj9DbxrC35giOdjMzGyWOYEBVjSXaQ6+T9hrm1YuAdCxgfZXPCamo//IaPaqGhYW/C+CM+yJolWu1EoP1/5qBptHJMCuxNTfCQUXSnPUVJbmzVSYjUCn5SDxGsNMDTx1mrB3s4kbLDHQ1xQN0S1yzg43RuAkUcmr5bJucD23yEneA++ujaavqi4JNUMgBli4TTKAZfwTI9T9OHS12bVySL6uTayI1mnxaPCw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(46966006)(36840700001)(7636003)(6916009)(6666004)(70206006)(186003)(2616005)(478600001)(316002)(36860700001)(4326008)(54906003)(36756003)(82740400003)(70586007)(2906002)(356005)(26005)(107886003)(336012)(8936002)(47076005)(426003)(5660300002)(8676002)(7696005)(2876002)(82310400003)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:17.2155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e4255c4-bdbc-49b3-124e-08d904dd946b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4987
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

