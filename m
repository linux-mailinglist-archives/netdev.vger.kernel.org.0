Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D153393EA
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhCLQvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:51:51 -0500
Received: from mail-mw2nam12on2068.outbound.protection.outlook.com ([40.107.244.68]:53697
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232043AbhCLQva (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 11:51:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZX43JjLf3VASpinMahOmIcwDl6BcwcpTHdTJ6brJDm07HyeT7NTh7JwCtqJjk6dDBQnfG+I1Aib+IX+50JfacOgj5NErmLijL/QWu5QCmtrNh2Z2UdTV56AWOgSJo3uQm4rM41r3//YDVQnkGCHaAjNm5cjTGzXYFTDo+wWt0xwE/99Dq1QuoGur+1jZFx0Hrp2JoOWz6ZxrogCjlc1nYgJL3ACFurFxxTTaY/fIuEc1qytT0hEDy2RbAGGQySsYqbt8BMnJ4acqRhkrBK9fKMg7L46QGfRAXTpGMae6zXFBDU//Z3ikjeOKqeeGort0Xq0qyAEpppvO3J97jflNxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UbPq1/a2TOW5rydhQjBevqeDfZYtThAlMU7cW/m1VR0=;
 b=UoxaY3VhC/WCLsfgQnvJjACYf7nBWTwLg7JFEFbJQbJyreqJftAmxHHEBsV/PRtJsRjN9u3TvSEIcSFAQRywjAD3L7v7DvxEU7PA0tf79ppfzzXsn7fLP9Y/k22nHpc7XnI+yOuMcusGxAwFl/1LY0XngVkqdd7vKJSn6kqx+a+VbGnSWEwZdkTDb0XypIgbhXYAp/PzUuYXj+fHAamHrttbLv5XAaD9S+z/5q1XImvUkqZdtNhsb7UPUqu6Wa4wOHKdLKgW2qRROsVzeHrfWEyx1iKtQ2P3Xt71AqAr9DwPRmNreUfSFK5FjQFmAvge9S/fZpw+wCOVj8kV4iTlaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UbPq1/a2TOW5rydhQjBevqeDfZYtThAlMU7cW/m1VR0=;
 b=t7GhMIx7eeaSh3QSHdQTDVa2GSrV2SqoGTp0fu7imUBQb7u52gyKd8SRH7gXmR4j7zDdb48PqfQ9i7+KP3e/+orC1jiSmkN2escypnfxsQRhYxDpnxOAXj5mvgzGlYFgKNLfLL3XMdwRJJarU0Oexos1QgynTIIknWHEfCEiw/ltgM1H7Rc/hYsVq82z+22O2YEWtgAR+48HVH+rXfiSTzK4T96B6+E5Wqcyv7WBbYCtnQgEOfgqYsm887JZLpwsjQaCrIVv018TIpw0bgSyQCqHG0KIhvQQ/i8LhyBIDBEeIRjbIDGxrI01rDvW4H0ojAwahWV9ERcaR25QdOt31w==
Received: from DM5PR04CA0027.namprd04.prod.outlook.com (2603:10b6:3:12b::13)
 by SA0PR12MB4477.namprd12.prod.outlook.com (2603:10b6:806:92::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 16:51:28 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:12b:cafe::f8) by DM5PR04CA0027.outlook.office365.com
 (2603:10b6:3:12b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Fri, 12 Mar 2021 16:51:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 16:51:28 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 16:51:24 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 04/10] netdevsim: Allow reporting activity on nexthop buckets
Date:   Fri, 12 Mar 2021 17:50:20 +0100
Message-ID: <69ce8e4dd4c372062e80c59979aef58cd84e58c7.1615563035.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615563035.git.petrm@nvidia.com>
References: <cover.1615563035.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86450f3d-e2f4-4919-b187-08d8e57714c4
X-MS-TrafficTypeDiagnostic: SA0PR12MB4477:
X-Microsoft-Antispam-PRVS: <SA0PR12MB44778BFADA4FDCA02B5BF2E9D66F9@SA0PR12MB4477.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r6bYYEQmgr7vV93HPT1rEIloGaCEMONieEgsylDg+SUMzE7uDv8mlzc98BTwf+nZUWNx9u25fX1pC9P0Vz9WZgGNGJw0g8QCYwge7tZL6CPEBVqQBQqFnUpTV5FXe4enzLLfp04cBefQUm5PEIv43oBn5HkKi7pjTYCgcHjEayPO5qnq6osciBTSUv+MFi9Xs4QKGg6HiKY0xT5X6dEu0XaqPD63KK5zOSottKNrDYXqQ5LbwhzqDeraHiVwHYeuq5kw0KIHCC/MBoMhJwGwBJ3kSr4vygoi77sLEL21SexokDjFMHKmeT0PwFPIQxHs2Q8MeifgzdQhJKjdcG9zQULUgJj4yvNg0Adg7LtjG88HKVkAagZpbpdYTRSHd+dqVAE2i4uUuA8EG7tUg3BnIOSYtEpLj6CUvZgiASKlZeN0uYXUZ+EJqniJuzWIfG+Kaf5zoyMJJ4wcW8no/lbe4HmOVEoAqOZvduedGIgWgja4GYWYY7HE0F7XIqIj+5xJgBrl7qordScUUwyaiu0Gc2HYIi545pZEJ1YVCx9Twl9KGZdaFEAh+FoO8HVrXjfmG8QgGL/Dv32hqOlHnnUhcuQ8lwu0+am9XEHTe+PKARNW5tdgX3g++zXQwyr0s7EtaDOATXlTWUV+a/xiV3HhLG6IEbfO7JhoWNRI9zqxur7MqScSqcLh4QArTWWzcx/F
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(396003)(46966006)(36840700001)(47076005)(83380400001)(36860700001)(34020700004)(82740400003)(82310400003)(86362001)(356005)(54906003)(336012)(26005)(316002)(6916009)(6666004)(2906002)(107886003)(478600001)(70206006)(70586007)(8676002)(36906005)(186003)(426003)(2616005)(7636003)(36756003)(8936002)(16526019)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 16:51:28.3380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86450f3d-e2f4-4919-b187-08d8e57714c4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4477
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

A key component of the resilient hashing algorithm is the hash buckets'
activity. If a bucket is active, it will not be populated with a new
nexthop in order not to break existing flows. Therefore, in order to
easily and thoroughly test the algorithm, we need to be in full control
over the reported activity.

Add a debugfs interface that allows user space to have netdevsim report
a nexthop bucket within a resilient nexthop group as active. For
example:

 # echo 10 23 > /sys/kernel/debug/netdevsim/netdevsim10/fib/nexthop_bucket_activity

Will mark bucket 23 in nexthop group 10 as active.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/netdevsim/fib.c | 61 +++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index e41f3b98295c..fda6f37e7055 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -14,6 +14,7 @@
  * THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
  */
 
+#include <linux/bitmap.h>
 #include <linux/in6.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -1345,6 +1346,63 @@ static void nsim_nexthop_free(void *ptr, void *arg)
 	nsim_nexthop_destroy(nexthop);
 }
 
+static ssize_t nsim_nexthop_bucket_activity_write(struct file *file,
+						  const char __user *user_buf,
+						  size_t size, loff_t *ppos)
+{
+	struct nsim_fib_data *data = file->private_data;
+	struct net *net = devlink_net(data->devlink);
+	struct nsim_nexthop *nexthop;
+	unsigned long *activity;
+	loff_t pos = *ppos;
+	u16 bucket_index;
+	char buf[128];
+	int err = 0;
+	u32 nhid;
+
+	if (pos != 0)
+		return -EINVAL;
+	if (size > sizeof(buf))
+		return -EINVAL;
+	if (copy_from_user(buf, user_buf, size))
+		return -EFAULT;
+	if (sscanf(buf, "%u %hu", &nhid, &bucket_index) != 2)
+		return -EINVAL;
+
+	rtnl_lock();
+
+	nexthop = rhashtable_lookup_fast(&data->nexthop_ht, &nhid,
+					 nsim_nexthop_ht_params);
+	if (!nexthop || !nexthop->is_resilient ||
+	    bucket_index >= nexthop->occ) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	activity = bitmap_zalloc(nexthop->occ, GFP_KERNEL);
+	if (!activity) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	bitmap_set(activity, bucket_index, 1);
+	nexthop_res_grp_activity_update(net, nhid, nexthop->occ, activity);
+	bitmap_free(activity);
+
+out:
+	rtnl_unlock();
+
+	*ppos = size;
+	return err ?: size;
+}
+
+static const struct file_operations nsim_nexthop_bucket_activity_fops = {
+	.open = simple_open,
+	.write = nsim_nexthop_bucket_activity_write,
+	.llseek = no_llseek,
+	.owner = THIS_MODULE,
+};
+
 static u64 nsim_fib_ipv4_resource_occ_get(void *priv)
 {
 	struct nsim_fib_data *data = priv;
@@ -1442,6 +1500,9 @@ nsim_fib_debugfs_init(struct nsim_fib_data *data, struct nsim_dev *nsim_dev)
 	data->fail_nexthop_bucket_replace = false;
 	debugfs_create_bool("fail_nexthop_bucket_replace", 0600, data->ddir,
 			    &data->fail_nexthop_bucket_replace);
+
+	debugfs_create_file("nexthop_bucket_activity", 0200, data->ddir,
+			    data, &nsim_nexthop_bucket_activity_fops);
 	return 0;
 }
 
-- 
2.26.2

