Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C4B37C09E
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhELOuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:50:07 -0400
Received: from mail-mw2nam10on2066.outbound.protection.outlook.com ([40.107.94.66]:10721
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231355AbhELOuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVh6bYKaYfrgRb3t7nz/8WlKttu7bjn19O3EX+CyldsFbP9/cforStPsQijkm5GerTkZ11sU9KDo995e8iWs4E0ex55QLre6B3l91feZJqnUDZ5rcgJMRMK31kzCZKKDPd6KR7HSXwHr/gOsIyxu2gknQMgo/0tSVqMU8R0GwB1o1uAKvqjF69MHWazyQwGnSWLfhiQq5PMRj6UIANog2XGYrESd3zdeKIquzdUTiOH5SiwwsyyYEsb5AzSnmrBOELqAIbzBiiQRIqugsiKidvS5G+T1FeLvM6J5IZkwFvnw6PzaVv75QNSe3fAdoX838eCTUnyzXzEZnVs52xX//Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aRatcyb+T68JfTMK/PdWtvpE7/Rx5TbRBzSP5cSb6g=;
 b=IIKO3q7kk4REIvPBeQfryVFO7yc8OaFLgO85zu5Wm6OgLvjXA+1hdrKguH6RPZik2d+P3Xp/BAulYcIap6E/ZFzdtZPAfZMvQhuI8NkVpXM5D2mfIfmCJPGQoKB9nyRS8+dl8Y+nvXNtXlEmAHMeJHiFOCUhv2q9e2iZgoQs0VcfaqOpqQTbyY2hzpE/vneZZh1q9prxboy8oJh1apID/zWA8FafAbei189xxGgnQpAzUQFbo8SmGkIGD/6T6RAKCmS6/1fHegp+T7ow8ceFRQIprFCzcTXegUIbxYcghNhdGzRKs909dledjEEshGtCWvKgw/4/AgtMKYdJBg/Zgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aRatcyb+T68JfTMK/PdWtvpE7/Rx5TbRBzSP5cSb6g=;
 b=hFGyropBZ0HXCO0pxMXatTJlR1/3KF2yvPUWFgCLBrEdzXOPdTmZJsuDqensrAS3O3B4Wndw1rXd50lm3sWnXEwYIBvzOOC+a5iiKrLiWddFNTZ00+cUTCWJg9WA71dVRpvl2Vw5lEMqOAIXKlafDv3IrejDHalTss94mH8dWmeMbkNfgTP5IGA3bwXhm3GQzuEGWcs0JImh+Fc2wxfu7joTrgC11STR1sLmmbQqawYq5LBYrxPlKn5IblaOu62m7T4wph65piKGnDdGwv3/EhMhXcTffpWV6jzawUHVARlVcKHzQ3c9kEWieXJxUOMIzzRmWK3wCOYnGwK35QCdpQ==
Received: from BN6PR17CA0041.namprd17.prod.outlook.com (2603:10b6:405:75::30)
 by DM5PR12MB1691.namprd12.prod.outlook.com (2603:10b6:4:8::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.25; Wed, 12 May 2021 14:48:55 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::5a) by BN6PR17CA0041.outlook.office365.com
 (2603:10b6:405:75::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 14:48:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:48:55 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:48:54 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:48:51 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Yuval Avnery <yuvalav@nvidia.com>
Subject: [PATCH RFC net-next v2 01/18] netdevsim: Add max_vfs to bus_dev
Date:   Wed, 12 May 2021 17:48:30 +0300
Message-ID: <1620830927-11828-2-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b63582e-3725-45fa-ac16-08d91555116e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1691:
X-Microsoft-Antispam-PRVS: <DM5PR12MB16913DD0AE7C257604674B93CB529@DM5PR12MB1691.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dKWiJjVfaCJlXGIFdheTJ2qeNOyURU5CXOKdPs0TrINREds5atSamQ64I2keHcIABhRn/JmzTRejjojz26ZHlaD71x5BOaXVhoAsc5prpVYNENe1kUBk/edRZwaAxJ27dgFWS+Jv4eeJZtVhr4xRcb7FRy/OVIrdsnMj5ih6zK1znIs1M0JbJwFuh1woNbViCbVgkD/d+aEPberECxH2jTkHX1Tfi1wAAHx5Pog16Y3tuilIHZXyORWlKZi0TLxuH7OkDH3eSHkJhFrfof6tg1bdUZKxtM1mWcx3wcQwIu8Tfp1vv/vuv4gCBY9bZ4wsYiEkBtCv4FHHAPAx87UaKG8FxyAcNI4FUwVAzsUn56LAyh1Ml9/Ungmks4ehEPBB9htVsSEeZMvr1TKUJkdf2rOy4RNVlNanS3/Q0lXOZw95D8uWcHDBbdB+idz4xNZ0DaNs3gauGbNoi7P0A0u1thRwqjbwEHTtnrh2+z7LuGVodHwWD88tdnV00cu37ZHiPBX+60E5KXjSnR8lAk4x/ln5f+mAu6ElK3lr1r/wzCuOrYOZJ4xSxinFBU91wQBjYRktQXbq9pqQWUud1C47kKSnrTuxkm7yii1r5s2tSBk5+3W2Zwr7HvPa+3kkF5Cr827m+3MSlvMK/5oYcvE/+Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(46966006)(36840700001)(36906005)(316002)(2616005)(82310400003)(5660300002)(7696005)(26005)(82740400003)(70586007)(6666004)(186003)(426003)(6916009)(7636003)(4326008)(70206006)(36860700001)(478600001)(36756003)(336012)(86362001)(2876002)(107886003)(2906002)(8676002)(47076005)(83380400001)(54906003)(8936002)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:48:55.6726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b63582e-3725-45fa-ac16-08d91555116e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1691
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

