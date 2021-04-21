Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C1D366F75
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244109AbhDUPx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:53:59 -0400
Received: from mail-bn8nam11on2044.outbound.protection.outlook.com ([40.107.236.44]:17855
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243606AbhDUPxs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:53:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CN2Kr0Clu/zYgVpUND5MFV6WrdpduRKXFzx8k82h9v0mZ7M9B4Rz/ik55S7baRBDDPdoC9swbAGRRYpHmCBBME9z+OoUQNCnL+Th7UPSpGYDx0b7RRjjSgILJW58fsg27A76IkieCD6sh45PKoP8HLEnWhkeRPReUEjaMF9D7Bf5u1saE4uLxetAHQjcaYExmQoLePe5jgzd3GzfVwyUhOd9dBqp6cSfAtjBLJ5datdFJw5naBLaEs2M4bEoujaWjqOlLtl0LO+C/K4dVBoAWTzF5OBs3aeR0pGhxcM15BLt/yN0I10Ew41TsxF5T7Fe/VRJUUh44b32JIF59fBj9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KstVsE3CzK5UTNd867f1Tdta5xiF1Qy2hI1UWAIBENw=;
 b=KpOiIe8NS8POKT9j6Y+lhEGVFK7rCUJL6QNghdhO1u67DLLEe0JdU8ZciRMaLSKEvgFB2uVyAkUWrzhkThoeMoIielwJp9kZiQ2CZYDLeD2ZygysL6ll4ZA49FcFTxt48rl59pBf+7+bYnxN0U/V+BTx5udWWqbWhRPvdo73AByqr3icgjhYrHHAYyouUCOQEvS+is2H52i392KQemZ3ataCmexVDkfboNFYji9zD14oa58+WwHYV1SjN56PdCsLbcvGT9Becx9KzTz/kD2V9MP0QBBpWyRzU5/vvb/heJpiRplbRYsXwGhJEieOPSXT+fmyAV/qT75ciYTssb9bRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KstVsE3CzK5UTNd867f1Tdta5xiF1Qy2hI1UWAIBENw=;
 b=HnoJMolqf1A8g1TB7gN8cWiMcCRamzg/Q6dSgKNKAu4NuO2wPX27OIlwPx5+J9liMjPnyOHdCRUgJYT8v3VLBlZLDIzF705krJCbZQy2LY3nT191bdWKXGW32mODY80oKbniOjIpTaLLViNfQUmW9N2x9JB89+yje5p535+TkbyfurS7lhb0aIQZHEEtP0n0H5ERbixAOhM6nQRmqkIIJACRHhI/TE71f5LshZYxMhMwpTdhvoFpzMNlKkr2HwWTGx7cbnQ2PLdwY4XzMerhazskDBwtcs85w/K1TLnDRrJpXV1b/g5j42x2UqWkSD3mlrP/5IZGNLgaN8CWgTGLDA==
Received: from BN9PR03CA0698.namprd03.prod.outlook.com (2603:10b6:408:ef::13)
 by BYAPR12MB3334.namprd12.prod.outlook.com (2603:10b6:a03:df::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.24; Wed, 21 Apr
 2021 15:53:13 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ef:cafe::cc) by BN9PR03CA0698.outlook.office365.com
 (2603:10b6:408:ef::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:11 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:53:11 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:08 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>,
        Yuval Avnery <yuvalav@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 01/18] netdevsim: Add max_vfs to bus_dev
Date:   Wed, 21 Apr 2021 18:52:48 +0300
Message-ID: <1619020385-20220-2-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b113fdc9-c12b-489e-cc80-08d904dd914b
X-MS-TrafficTypeDiagnostic: BYAPR12MB3334:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3334EE489C7AE3BDC5C21E48CB479@BYAPR12MB3334.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pfe47uGKIGQaARxaWnJ31mSEZ7RK3KuY2V88Zhlhzkg279zv9Xfbi4JRb7IOXDfWqbjzFRk06aPBhqPTIGn+6vJxMLOC9VoIqTra+2ti3wML7b5BJSIFwGB3cJPU0NZ1E1h2TKgiH2quLR7bphJQ43H0pffnVXXTJPMYUbaZGTh9q4EZWFCCDezCxU3m/b+Z1Z074XdbVIIkCK7wyhCy/WTBSXurlRLcQjTtZpvs+iETPMh0KUaa5yolok5JeAgm9S6H9Ipa54j6qhsou0EVoJbOR1vyjbD95xp0FZoHI59AyqRIdw46ZiETy2LwrGi4il7TV7ha0OekgUUXRLzT57kTqcLDvVq8vgx7YkNGZPJhqx+6DvM00oS7QnRj6TRar9P/DPhsjr0QCvF1MHvsGFJkAq5I7T6MbeFM3B0kBhnUYVmkxpv6S3/Q55Vhs64j1+4ZJQahAVFCBVxU/IzOy+DYXN+AF194w329+jbxbThbiPoI/DMfJ1L5JS2fsjZY15Au9a/Hj71IDPjj5fcTypDipnvtjlZXwMaE4GxT2GR2E8iuJlahhiMEZ+j2D+8VhuTRmmGb1s+9D7QbviKUSfbMTjQvExm5u+nVHHMBTGJVAUK2kOM0qawHiMpE+NSEYUde02Tg4G2b58uObkanHA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(36840700001)(46966006)(6916009)(36860700001)(5660300002)(2616005)(4326008)(426003)(8936002)(107886003)(26005)(7696005)(36906005)(336012)(186003)(2906002)(7636003)(47076005)(478600001)(316002)(83380400001)(54906003)(82310400003)(86362001)(82740400003)(6666004)(356005)(70586007)(70206006)(8676002)(36756003)(2876002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:11.9634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b113fdc9-c12b-489e-cc80-08d904dd914b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3334
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

Change-Id: I8f3180de8f770343b0f7d3c5377defcd4c635232
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

