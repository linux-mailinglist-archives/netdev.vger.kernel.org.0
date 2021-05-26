Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCA53916EB
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbhEZMCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:02:53 -0400
Received: from mail-dm6nam10on2045.outbound.protection.outlook.com ([40.107.93.45]:24989
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232324AbhEZMCv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:02:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTCIpjK9mqPrcSEH/+E0fADfLw0cntcwWkF86O2fkNU7FntntXPrKMQy6CkHrAY77Wo5hPWO/L6T8YpPB0eRV5SdOq+tDQKVBkH/2Mhr3/QM/z8OX4VD0CEUBo1qJcqdC6GOtM1Yn77oTf/pkP7Z+S9I2ZvD/LZ5wZppArgodG/uOdOD79yETtERHFJJa4F3m8Le2ZifNiW/67efd5a2FwSNZc8L+SmpZDGIE4hhGT4LndWR5PlHCty+3f4wxxQikH3sjqDeVeX3hBRi7FXW2JhLVpCjWfMdKufUZHy2mj8XZcX1Dz6AxgFJi9Pw8xbqo/ftmG58YKBdupODjsOvAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aRatcyb+T68JfTMK/PdWtvpE7/Rx5TbRBzSP5cSb6g=;
 b=hhiTQgemRwpQT9b4GLY/kM1s7fhciLXke3/FrqINHY45ROCFccd9EN633Vm9idJlkpKInmIbJE5VeqkzY458uJ7ElaQRRZiXLyExoJVFTHIVsoyos80cEZe5ZkUNAYYrMzfVq2xw7PSNaKpXsm9LNnAS2vTXZadUlADySzbHk/QYTSr64Sx2e586KSlANEJULUJ2mRT2XvfDEeENJw0k7v8NkAU2ydKN+3B91pQ2942Lj/3rQmidFW4BLhrWrQ3yhICxS/dP317W7yl8KYdozwLOg04r1ybjpk2ZKdb43+Umfae7Fx9MyELK6EuTkIOU818x54eCtqNi2hmZm42b4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aRatcyb+T68JfTMK/PdWtvpE7/Rx5TbRBzSP5cSb6g=;
 b=rdMcfr3HjyGTp44s6JXQWLL85mL7Jzc40M4/H55AzxnI+QtVmp+ZvtlrnMwWN7MffNL/ZTzp236B2UPvGR9a5laFQhLhwuw1TatUmjCcKS+G7Gu/GWP3znA6ZUoB6hNi4tjrwUzSDyUI7QDSnsoFqHb6wypIEZHnZ7BqX7xNEhfWR/JpSI8oldgslO8JJvTrmShqbbTkYe0t6wiXgYRMJf75BuChtlX6hWoM4qit5Dbdaha18lY3doQEFibaoKzTbKSlK/yevt6yZt/NgP5xfVpa6DByQFaBPrH6QlhtnP8SLOTgmJ7F5XYnOwr6017YP3GRZeW1yASoir1YrMdoUQ==
Received: from BN6PR2001CA0003.namprd20.prod.outlook.com
 (2603:10b6:404:b4::13) by MWHPR1201MB0126.namprd12.prod.outlook.com
 (2603:10b6:301:57::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Wed, 26 May
 2021 12:01:19 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::9b) by BN6PR2001CA0003.outlook.office365.com
 (2603:10b6:404:b4::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 12:01:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:01:18 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:01:17 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:14 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Yuval Avnery <yuvalav@nvidia.com>
Subject: [PATCH RFC net-next v3 01/18] netdevsim: Add max_vfs to bus_dev
Date:   Wed, 26 May 2021 15:00:53 +0300
Message-ID: <1622030470-21434-2-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dc238ba-6e17-4dc5-1589-08d9203df8cb
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0126:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0126CFEC8E53B4E0B4E0597FCB249@MWHPR1201MB0126.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kMBd67ORwBRaEnrjp+XojRXz53Iyh9u44oAXxPEeQNqAxqreM/5NLbWT3TBNBI5AWpBP3Jrha5bQY+S7I+5+lbHX6GfJEg6zyha1J8BpF06fvP7Shlk6jZD3XqtViQeRr7OrzeXQBkV+JjHx4tcbYoc0Il6wV8OXHz+grhZISNrC9yUlrwRog+VqKnjv2iIP5W4amITtwxQLqXNHWyOz2Wy4zqA33TYyiQc0wO/oOoj2faquS1yRpmO3DXRNa0lxLz3LuiVvGAJyaBNGVLyajm4ICUBDj57XHvXM+Sfks0+7Y7vPCaxgb5Jh1/huI+6/F50Kc2kFQqzn9c4YbUdwGyKfKu45M5XQZzbWCJJCqXEKgzmX7LzJ9elNt9jfAfaNpEjH4iUpvfaQZ9uMt+GKrcjTQawBjMJEVM/Lp4Qv2sL0tGc7DXFaICv8x4nqwVrD4UNUJ16lcPvrzfDMiuA4KlfiyQ9SmiLLJweCRtbyVCHNuG3buhwZwS+IdYKGggtkwb+wyuA1NUEB4aFOBKa5CSaED3gYT7Zoe8uSVZnonN53bEHL6rQka1j594/jO/I6MMKClH3els7g14nlMhYm5O23cl98DVnrO2s/IjpABN0azYyzzQyTEZjzXLdVBODzF0RdOWPS5DQf9P093Gi9Hg==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39850400004)(136003)(396003)(346002)(36840700001)(46966006)(47076005)(83380400001)(7696005)(336012)(7636003)(8676002)(36756003)(478600001)(82310400003)(2616005)(82740400003)(70586007)(36860700001)(70206006)(186003)(356005)(8936002)(6916009)(26005)(4326008)(5660300002)(36906005)(426003)(2906002)(2876002)(6666004)(54906003)(316002)(86362001)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:01:18.6789
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc238ba-6e17-4dc5-1589-08d9203df8cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Currently there is no limit to the number of VFs netdevsim can enable.
In a real systems this value exist and used by the driver.
Fore example, some features might need to consider this value when
allocating memory.

Expose max_vfs variable to debugfs as configurable resource. If are VFs
configured (num_vfs != 0) then changing of max_vfs not allowed.

Co-developed-by: Yuval Avnery <yuvalav@nvidia.com>
Signed-off-by: Yuval Avnery <yuvalav@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/bus.c       | 99 +++++++++++++++++++++++++++++++++++----
 drivers/net/netdevsim/dev.c       | 13 +++++
 drivers/net/netdevsim/netdevsim.h | 10 ++++
 3 files changed, 113 insertions(+), 9 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 0e95116..4bd7ef3c 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -27,9 +27,9 @@ static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
 static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
 				   unsigned int num_vfs)
 {
-	nsim_bus_dev->vfconfigs = kcalloc(num_vfs,
-					  sizeof(struct nsim_vf_config),
-					  GFP_KERNEL | __GFP_NOWARN);
+	if (nsim_bus_dev->max_vfs < num_vfs)
+		return -ENOMEM;
+
 	if (!nsim_bus_dev->vfconfigs)
 		return -ENOMEM;
 	nsim_bus_dev->num_vfs = num_vfs;
@@ -39,8 +39,6 @@ static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
 
 static void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev)
 {
-	kfree(nsim_bus_dev->vfconfigs);
-	nsim_bus_dev->vfconfigs = NULL;
 	nsim_bus_dev->num_vfs = 0;
 }
 
@@ -56,7 +54,7 @@ static void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev)
 	if (ret)
 		return ret;
 
-	rtnl_lock();
+	mutex_lock(&nsim_bus_dev->vfs_lock);
 	if (nsim_bus_dev->num_vfs == num_vfs)
 		goto exit_good;
 	if (nsim_bus_dev->num_vfs && num_vfs) {
@@ -74,7 +72,7 @@ static void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev)
 exit_good:
 	ret = count;
 exit_unlock:
-	rtnl_unlock();
+	mutex_unlock(&nsim_bus_dev->vfs_lock);
 
 	return ret;
 }
@@ -92,6 +90,73 @@ static void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev)
 	__ATTR(sriov_numvfs, 0664, nsim_bus_dev_numvfs_show,
 	       nsim_bus_dev_numvfs_store);
 
+ssize_t nsim_bus_dev_max_vfs_read(struct file *file,
+				  char __user *data,
+				  size_t count, loff_t *ppos)
+{
+	struct nsim_bus_dev *nsim_bus_dev = file->private_data;
+	char buf[11];
+	size_t len;
+
+	len = snprintf(buf, sizeof(buf), "%u\n", nsim_bus_dev->max_vfs);
+	if (len < 0)
+		return len;
+
+	return simple_read_from_buffer(data, count, ppos, buf, len);
+}
+
+ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
+				   const char __user *data,
+				   size_t count, loff_t *ppos)
+{
+	struct nsim_bus_dev *nsim_bus_dev = file->private_data;
+	struct nsim_vf_config *vfconfigs;
+	ssize_t ret;
+	char buf[10];
+	u32 val;
+
+	if (*ppos != 0)
+		return 0;
+
+	if (count >= sizeof(buf))
+		return -ENOSPC;
+
+	mutex_lock(&nsim_bus_dev->vfs_lock);
+	/* Reject if VFs are configured */
+	if (nsim_bus_dev->num_vfs) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = copy_from_user(buf, data, count);
+	if (ret) {
+		ret = -EFAULT;
+		goto unlock;
+	}
+
+	buf[count] = '\0';
+	ret = kstrtouint(buf, 10, &val);
+	if (ret) {
+		ret = -EIO;
+		goto unlock;
+	}
+
+	vfconfigs = kcalloc(val, sizeof(struct nsim_vf_config), GFP_KERNEL | __GFP_NOWARN);
+	if (!vfconfigs) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	kfree(nsim_bus_dev->vfconfigs);
+	nsim_bus_dev->vfconfigs = vfconfigs;
+	nsim_bus_dev->max_vfs = val;
+	*ppos += count;
+	ret = count;
+unlock:
+	mutex_unlock(&nsim_bus_dev->vfs_lock);
+	return ret;
+}
+
 static ssize_t
 new_port_store(struct device *dev, struct device_attribute *attr,
 	       const char *buf, size_t count)
@@ -311,6 +376,8 @@ static int nsim_num_vf(struct device *dev)
 	.num_vf		= nsim_num_vf,
 };
 
+#define NSIM_BUS_DEV_MAX_VFS 4
+
 static struct nsim_bus_dev *
 nsim_bus_dev_new(unsigned int id, unsigned int port_count)
 {
@@ -329,15 +396,28 @@ static int nsim_num_vf(struct device *dev)
 	nsim_bus_dev->dev.type = &nsim_bus_dev_type;
 	nsim_bus_dev->port_count = port_count;
 	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
+	nsim_bus_dev->max_vfs = NSIM_BUS_DEV_MAX_VFS;
 	mutex_init(&nsim_bus_dev->nsim_bus_reload_lock);
+	mutex_init(&nsim_bus_dev->vfs_lock);
 	/* Disallow using nsim_bus_dev */
 	smp_store_release(&nsim_bus_dev->init, false);
 
-	err = device_register(&nsim_bus_dev->dev);
-	if (err)
+	nsim_bus_dev->vfconfigs = kcalloc(nsim_bus_dev->max_vfs,
+					  sizeof(struct nsim_vf_config),
+					  GFP_KERNEL | __GFP_NOWARN);
+	if (!nsim_bus_dev->vfconfigs) {
+		err = -ENOMEM;
 		goto err_nsim_bus_dev_id_free;
+	}
+
+	err = device_register(&nsim_bus_dev->dev);
+	if (err)
+		goto err_nsim_vfs_free;
+
 	return nsim_bus_dev;
 
+err_nsim_vfs_free:
+	kfree(nsim_bus_dev->vfconfigs);
 err_nsim_bus_dev_id_free:
 	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
 err_nsim_bus_dev_free:
@@ -351,6 +431,7 @@ static void nsim_bus_dev_del(struct nsim_bus_dev *nsim_bus_dev)
 	smp_store_release(&nsim_bus_dev->init, false);
 	device_unregister(&nsim_bus_dev->dev);
 	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
+	kfree(nsim_bus_dev->vfconfigs);
 	kfree(nsim_bus_dev);
 }
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 6189a4c..12df93a 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -192,6 +192,14 @@ static ssize_t nsim_dev_trap_fa_cookie_write(struct file *file,
 	.owner = THIS_MODULE,
 };
 
+static const struct file_operations nsim_dev_max_vfs_fops = {
+	.open = simple_open,
+	.read = nsim_bus_dev_max_vfs_read,
+	.write = nsim_bus_dev_max_vfs_write,
+	.llseek = generic_file_llseek,
+	.owner = THIS_MODULE,
+};
+
 static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 {
 	char dev_ddir_name[sizeof(DRV_NAME) + 10];
@@ -231,6 +239,11 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	debugfs_create_bool("fail_trap_policer_counter_get", 0600,
 			    nsim_dev->ddir,
 			    &nsim_dev->fail_trap_policer_counter_get);
+	nsim_dev->max_vfs = debugfs_create_file("max_vfs",
+						0600,
+						nsim_dev->ddir,
+						nsim_dev->nsim_bus_dev,
+						&nsim_dev_max_vfs_fops);
 	nsim_udp_tunnels_debugfs_create(nsim_dev);
 	return 0;
 }
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 7ff24e0..12f56f2 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -212,6 +212,7 @@ struct nsim_dev {
 	struct dentry *ddir;
 	struct dentry *ports_ddir;
 	struct dentry *take_snapshot;
+	struct dentry *max_vfs;
 	struct bpf_offload_dev *bpf_dev;
 	bool bpf_bind_accept;
 	bool bpf_bind_verifier_accept;
@@ -269,6 +270,13 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
 		     enum nsim_resource_id res_id, bool max);
 
+ssize_t nsim_bus_dev_max_vfs_read(struct file *file,
+				  char __user *data,
+				  size_t count, loff_t *ppos);
+ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
+				   const char __user *data,
+				   size_t count, loff_t *ppos);
+
 #if IS_ENABLED(CONFIG_XFRM_OFFLOAD)
 void nsim_ipsec_init(struct netdevsim *ns);
 void nsim_ipsec_teardown(struct netdevsim *ns);
@@ -308,7 +316,9 @@ struct nsim_bus_dev {
 	struct net *initial_net; /* Purpose of this is to carry net pointer
 				  * during the probe time only.
 				  */
+	unsigned int max_vfs;
 	unsigned int num_vfs;
+	struct mutex vfs_lock;  /* Protects vfconfigs */
 	struct nsim_vf_config *vfconfigs;
 	/* Lock for devlink->reload_enabled in netdevsim module */
 	struct mutex nsim_bus_reload_lock;
-- 
1.8.3.1

