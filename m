Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBC0398935
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFBMT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:19:27 -0400
Received: from mail-co1nam11on2087.outbound.protection.outlook.com ([40.107.220.87]:32833
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229738AbhFBMTZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:19:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7Lf/Crp9JA2gN0DoOGBuo47+p2jIJMpqGNF9Yn3q+aVOd9MmxFp7g3gHmXtXuLJ2nkzjUMwKFizn6bUQGWFCdy0xOJdVXxkXmrf7KRI2zrC/Rw984vdAnKj8+s31PJkRBi/O3NxbXpaCO973iGfCqdxrQRTALiTgsha7/440C4qzeWKkGDMDQ1pxPTdBkiUcllQh9Npd8ov9zDzX0WiW+wntopwOuVQoTYyzSfDTLe1WdkyHSwIQNQnZzbuVctcoRy75m9ITTaU2dwkezk9xbP5YbOIRuOcDtJchcbik7k3QLpb6c/93Yksx3pesSXMNiUgYrasfCJNUmfx/jg/xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aRatcyb+T68JfTMK/PdWtvpE7/Rx5TbRBzSP5cSb6g=;
 b=JZ0WscNOxLUiBZNHdGDFAcHpvtK2r/A5y0o5+rPXBE4BS32gOyx2GcdawvmHvtFX4oJAlhXWonDE+fI4QMFkpYj/A4j5oq2uUxTJXo+qK/wnUNPZnE1ssDcgjWvsH5eq9zBT9vSSC62U+3gXDLR4kYLf7d4GwrZhu3p+9Br+wG4+LbbeV20gfYkRR3i1iO7OaG6M1xtuk/vosv94+zvBNdahzt/nzTt9iKLGK69U0ytQuemGqHHc2t98kG/L9L2xQQH8XEXX+JuXvFEQ0Onkd1nw2dOVjKF6s5UbA7OANdw82QMgih7CsiH3EtJ1u2cdqhTKUnHopSS07hFm/7Jb3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aRatcyb+T68JfTMK/PdWtvpE7/Rx5TbRBzSP5cSb6g=;
 b=E6NxSmMW9IIJJJhsUaGqbddFpbDhsKVmqzCyVi/Spa8w/JM4KMoWJSheyIKeo3cQG+f3CaDQv+hGKFXZJZkDXNYCYw4TEsJc82OHBPMNaw8HjnVEDM08H9c4HStMbHPQYikx1W9JryWsDvU0C1BnjHuYd5CFq7Dinouyi1IaZuFocCMtmGc81ie9xXWlM3J7VSGqXOAbtbin81+MdJRZakjszqK+cMSYrunIe5iNIlr5LUWU1QBKQ90BgdC0aajuHSqQGVQtU3z8X2mjgeew0ZRASDWsqsOxVNhqF4r8d08dNBnaN0Yx6a15k19o4nBqGvMPBYTub2oodrO4gAM/nQ==
Received: from MWHPR03CA0009.namprd03.prod.outlook.com (2603:10b6:300:117::19)
 by DM6PR12MB4449.namprd12.prod.outlook.com (2603:10b6:5:2a5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26; Wed, 2 Jun
 2021 12:17:39 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:117:cafe::27) by MWHPR03CA0009.outlook.office365.com
 (2603:10b6:300:117::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Wed, 2 Jun 2021 12:17:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:17:38 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:17:38 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:17:35 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Yuval Avnery <yuvalav@nvidia.com>
Subject: [PATCH RESEND net-next v3 01/18] netdevsim: Add max_vfs to bus_dev
Date:   Wed, 2 Jun 2021 15:17:14 +0300
Message-ID: <1622636251-29892-2-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4efd8b7e-b835-437c-2d5c-08d925c069c8
X-MS-TrafficTypeDiagnostic: DM6PR12MB4449:
X-Microsoft-Antispam-PRVS: <DM6PR12MB444977840569C2E13FC6BE92CB3D9@DM6PR12MB4449.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TEG+m+nnH35f8LEQ1aAjL8nMtGFcokQwUsAmyUl0YgC98Eg1i6RlVKsg/xp66sHFpNj81MmBv7IB9p2tozqLFOf3gXD2bqsVw9tHtIIXIqsCwYPWWsn1Ns25ObqcTWDfqP6b4IwyEmWBI5DN+yrwk0nc0XG5GCqAE36oH6SgiVpM4GOJsLVZP7A4PBqlClussEwmEkzACBMGmnIo3oRQCJLKjoUgRXFOMDy4QeJ963LR3UdxEINDjJYjM0fdAExlvusFBRRDGc9JeTRU5ApAGkXhYl8Q3Whi3d87QyBW2n2w2rIIokZ79zsKj8h8gpNrNZI8JMnJLe4R5tXfcNH3wEScZuExXbhJkB3HngJ8jaJPJehfBmTnNT/x+w3FVSbIUU2242f2e51tucbZec9J9xrBml+5cDQSArUFMvkkj3adVIqssw+meSroHZMPKAgGFFBFGWSAjlhZq9BrNf/Dvi8aiCI24gV/ZT08FIJQbi5RPPZ4PsqetNsmDJIE42UByFygqBHbOhtFmgKk6ThXGUUGH46l51ixyvjyX2XTFfyAfq0NXqqkefKXw7Yr3qfLBoRjq5XQe0BLDcYDQLpm9a14tJ8FgYfTLP0xhp82UAMU9T02ehHJ029hu50JxxIP7dy4lyhQnYx5OfzAF7vo3A==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(36840700001)(46966006)(7696005)(26005)(426003)(36906005)(6666004)(47076005)(82310400003)(54906003)(478600001)(316002)(70206006)(4326008)(36860700001)(356005)(2876002)(82740400003)(2616005)(36756003)(107886003)(2906002)(7636003)(8936002)(336012)(6916009)(186003)(5660300002)(8676002)(86362001)(70586007)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:17:38.7291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4efd8b7e-b835-437c-2d5c-08d925c069c8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4449
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

