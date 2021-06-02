Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D255398937
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFBMT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:19:29 -0400
Received: from mail-bn8nam12on2049.outbound.protection.outlook.com ([40.107.237.49]:40928
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229809AbhFBMT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:19:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEk8FHNKr/UCbGYpSGWv8ocaHDHgXm+DtqclTjLKX31Q0wrRbtAkfpAqJyycyc/P8eTeFUTIAvM1XhybiKUlU9NTL7YzMqTBVN1GCTY6FKrpAXDnNrDb9R04K/O09EnXRd8mlBFrj394Wrb/4OYT/uGUhHerJEdx4iP6/gDomgix2Ggo5DTpjdoTboABShsTmPRPh8hwtSsoG9BG12qnlzGj4z6mrAPZ6XhFXA+QAyk4pHLwOcx8z5PbgJltze+oUuhCOSjhjk6tHyusHcpuG5fqkCBWfqXZpLwbuzbcJdDHgUZb4EPjzzi7Bayj7qlal697o1aPd88NJHx7i6fkUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRR3KKHr4sWyA9SIvxQ0UvsB1Ur5N2+g2WqlGIxyohI=;
 b=l+YHQtwm62nm0+U7K87P8LoMaxh8cziRFNBOEDSwKxdJ9momNf0F0B8SZeg3HavOyFzfxUISv5m3oq3pnMXS5wYBYqk7YJbVPIs52lEvfQ5O7cr2HCu49p7SZcsBZPh2elLW8QOQfQ+djNOfGAufMJwPoiqMeemgjpqrPTMIEXlvuC/fnlzB8Yq6BsVAPk5OparimVADSb0s484l/WFuDaC4aKcgWepoqlF2Dkg1roUyhAn/4q/s6Z4lVaYD3Pq1zFSVQz3JDFrmYI5jfny4ym+5+Gn/9nZ8qDVVUO9fikupAr+jBwmBubwcn6zX4JjCrjcBvEpYvMDd1jR8EfYGFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRR3KKHr4sWyA9SIvxQ0UvsB1Ur5N2+g2WqlGIxyohI=;
 b=Zg4MkReeKliXTdiyizgccWGvN7TG9fviuu/7Y4F0lqt2HVQnA/EgHELAK2g/8LWdewdzYqNmvFmkmzwYvyLTuXSL7d2jTwMxF2Rtj2bhwrO3kdbmjeVQWSp7/yTXNbEsCNW7DcYQQPVZ8+vts/noESl9EvT++Y3FBLK9g5bwMM3AHQXnJvreO2CghrA/baL/h79gxAsNk9/lTMOZKeOmp4qFHhdoR24lJqSwx0lvEbR1pzXE+yg++oV4S0vw0vtxCntPLK9lEbmiSwVL31rdni1jT61/4d84B45SzfSzOBZQbT4lvtGVFvJazEsdeRHYN2VBhR3ZSYl1owFMJnEKVA==
Received: from MW4PR04CA0010.namprd04.prod.outlook.com (2603:10b6:303:69::15)
 by CY4PR12MB1286.namprd12.prod.outlook.com (2603:10b6:903:44::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 12:17:42 +0000
Received: from CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:69:cafe::aa) by MW4PR04CA0010.outlook.office365.com
 (2603:10b6:303:69::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 2 Jun 2021 12:17:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT024.mail.protection.outlook.com (10.13.174.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:17:41 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:17:41 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:17:38 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 02/18] netdevsim: Disable VFs on nsim_dev_reload_destroy() call
Date:   Wed, 2 Jun 2021 15:17:15 +0300
Message-ID: <1622636251-29892-3-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6a52aa4-2181-4f85-3d73-08d925c06b97
X-MS-TrafficTypeDiagnostic: CY4PR12MB1286:
X-Microsoft-Antispam-PRVS: <CY4PR12MB12866FFE0FC1D7F39C2BB319CB3D9@CY4PR12MB1286.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:469;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pn/jRP4E5ls8cAAIBpmvYoQeefPhrS3S2xvTqVmwti7i1X49AYLuKZd9WJrBWXplr7zk9hmu2NYXPFKqwNG38YdkxuKPgcPahaZbE2ADC/3oWmH/gw3UVn58qifAmW7Eikmhs+9r6sW0WBZTO76teN2gqZoQKtbZBjwT2W2JpfrLTowX7pypORkWIxbbHrSBiiMsruoF3XxkQHSAcPrQ7sP64MmXFb/5qzsxwr5+WzWEy7v00x05Vx7Ff54E5Z0MNeSoGnOmKarRUnaK6mJA8eSXZNraxXIFQ1crDrCgGci2YMqyWiJ13f2Pi+/QzraE+h7Ppd68YJcLkTpqesC6VxedtxNtHjXOIYVvFNcTANTYKZWHvfVU9GOPS7HDsWA3rdWvh6B71csnWThK921LLg4NoFipnBC9yNT9JjQRbuEo3hzVjGkVSsmHg4C2ZBgPyH/IDkxR3/pm3/HUHuSk9mwJmSCtmrRVORGYungqq24ZrlpuVdRR1Q8u+fHxy0+UtY3DHv2jzH1ono+lol5V2dFLIHnNKSE4I1Korom2BHoyT7Aw4r3MkcoCWmyWGygy3tGzFeITWg5cu60y4ORfP6Qqrt27AQw5fj4A8z/xU89xulhMU1AT6uuuBFDPrFp77tvKwQh/982jLvqf9u0yI8ABYoLnXTfIKuL7HnhQakM=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(46966006)(36840700001)(8936002)(36860700001)(8676002)(426003)(82740400003)(82310400003)(186003)(336012)(6666004)(47076005)(316002)(478600001)(54906003)(6916009)(5660300002)(86362001)(26005)(2616005)(107886003)(70586007)(2876002)(36756003)(7636003)(356005)(7696005)(2906002)(4326008)(70206006)(36906005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:17:41.6319
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6a52aa4-2181-4f85-3d73-08d925c06b97
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1286
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Move VFs disabling from device release() to nsim_dev_reload_destroy() to
make VFs disabling and ports removal simultaneous.
This is a requirement for VFs ports implemented in next patches.

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/bus.c       | 5 +----
 drivers/net/netdevsim/dev.c       | 6 ++++++
 drivers/net/netdevsim/netdevsim.h | 1 +
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 4bd7ef3c..d5c547c 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -37,7 +37,7 @@ static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
 	return 0;
 }
 
-static void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev)
+void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev)
 {
 	nsim_bus_dev->num_vfs = 0;
 }
@@ -233,9 +233,6 @@ ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 
 static void nsim_bus_dev_release(struct device *dev)
 {
-	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
-
-	nsim_bus_dev_vfs_disable(nsim_bus_dev);
 }
 
 static struct device_type nsim_bus_dev_type = {
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 12df93a..cd50c05 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1182,6 +1182,12 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 	if (devlink_is_reload_failed(devlink))
 		return;
 	debugfs_remove(nsim_dev->take_snapshot);
+
+	mutex_lock(&nsim_dev->nsim_bus_dev->vfs_lock);
+	if (nsim_dev->nsim_bus_dev->num_vfs)
+		nsim_bus_dev_vfs_disable(nsim_dev->nsim_bus_dev);
+	mutex_unlock(&nsim_dev->nsim_bus_dev->vfs_lock);
+
 	nsim_dev_port_del_all(nsim_dev);
 	nsim_dev_psample_exit(nsim_dev);
 	nsim_dev_health_exit(nsim_dev);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 12f56f2..a1b49c8 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -276,6 +276,7 @@ ssize_t nsim_bus_dev_max_vfs_read(struct file *file,
 ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
 				   const char __user *data,
 				   size_t count, loff_t *ppos);
+void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev);
 
 #if IS_ENABLED(CONFIG_XFRM_OFFLOAD)
 void nsim_ipsec_init(struct netdevsim *ns);
-- 
1.8.3.1

