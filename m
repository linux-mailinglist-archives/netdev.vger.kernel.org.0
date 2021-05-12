Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78A137C0A0
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhELOuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:50:19 -0400
Received: from mail-mw2nam10on2041.outbound.protection.outlook.com ([40.107.94.41]:54752
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231355AbhELOuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJEbSc6yqtJHEBp4mxkZ7IV7pQhb+e9939GcraicE2/aSHDyG/9DJMfF3SE+Drr7xb4bEOsf8oTUpd7n8lIWNr67XlDoCbwG2muZiRYO6ZJ5QQrJVn+S8kLhDZKB4yqdeVu6/MUeOOI0JISg21gw2NP88J2C0jA2U1x6DFJ12eVeTn5KmRR2/40VPN5rFzyOcD9yggua8fDwbqO8HJ0fRPz/m+8Z3syTzxnzKk35u8vV/Qqa29u7KIgFKA0FrASgoaS1nL4QIUNSFjjUZ3LIGLLTaBxBW2tJkq3i3mixbojr9qpCSsF2SFDpST/L71EErWAnwHX7rEjxVFyQhaRclw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRR3KKHr4sWyA9SIvxQ0UvsB1Ur5N2+g2WqlGIxyohI=;
 b=jcLPoamspkUPuq56Vxa1ElItMWxnrmRDr0ZzwthFC9bbs2Yyta9UhHDyx07dhsFQ7D1VxHqcxIi3uIxLfP0xoJ9p9PQ8Pt5jGqMDrdGuWt8KN34GjvtoYSoIPRMflhUvmh5e/yhGnFLtnCKDkE16E9sizgO+hdpIIFNVn6aCnjVqxAA/BAkIImyu2MM2KPm5l8PD00T3y+o+gDTZCoczLPbbTyRpxDEBhqAO5geajmWOm0258QjlJbUy9Z3h9qxB6vpedOxh0Eivm51xxLNsS17e6pKYtHFLdoxCGJFZeYxKUfnhcCFKAiyo4QUDs12zUFRpQpket2X6hgbzN0q+HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRR3KKHr4sWyA9SIvxQ0UvsB1Ur5N2+g2WqlGIxyohI=;
 b=hnTu19uurGv6nruCM4dhTis/dmTwMDPMrQ83fO12JX5jetfQA3gpl0JM9k18zS5JLtV+UsLyEkuzFBIJTz1pEPc8lkp7QNgxL+swNwWjLsWizArtCwO0LARUMaIQP2N5ZVi8VFJ+BfUulpO83Irm5ecSe9HG6FVfZbWUlFBFe4X2u1nbrox5jWNsVx+MfHJDb7fGB+mQnbCyzYdlIA3BVas9eVNw3lu5Rv+x5M8mwsVSiuEsieFQeVNBQQy460Rn2+H+kIAt1oMPVKilZbfJzm0GgnW3vKQLXfg3aVfRtAsapfow7J0mtH3f08niK3facniEttOOLq9PV5QkpCfY+w==
Received: from DM5PR08CA0031.namprd08.prod.outlook.com (2603:10b6:4:60::20) by
 BY5PR12MB4818.namprd12.prod.outlook.com (2603:10b6:a03:1b4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.31; Wed, 12 May
 2021 14:48:58 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::b8) by DM5PR08CA0031.outlook.office365.com
 (2603:10b6:4:60::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Wed, 12 May 2021 14:48:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:48:58 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:48:57 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:48:54 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 02/18] netdevsim: Disable VFs on nsim_dev_reload_destroy() call
Date:   Wed, 12 May 2021 17:48:31 +0300
Message-ID: <1620830927-11828-3-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 129db858-05d4-48b9-6d35-08d915551309
X-MS-TrafficTypeDiagnostic: BY5PR12MB4818:
X-Microsoft-Antispam-PRVS: <BY5PR12MB48182C6C698C4364D78B3BACCB529@BY5PR12MB4818.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:469;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0DcXSNiLM9NDX6bEb0MMakDaVt2Ab5pbMSN5idmkmi3zJdNzXB0iLXvpoRZNEAdUqUji+OfASIbsKS5CXy8RIPD9Mv97+gGBtGg8azv/CUnikDuyO6h3WlchZczgx7+1gLC2XYJLfCeSTrU55xKwFSr7Bm3+qORjGprlBWDG1WOtigCdPlY4sxszZoYnlr6cFBW57+xejAdEYZVwDyvKNCLbFdp61uejM3Lt9mBs7Tg7wv3hX0B9GvE2VWKf8px5UbL/9+gFjeaR702/B9yP0IuEeSjChJCvEfl5WmKyAXxpno1yhdF9j5vQ+LcYn423FCk2Lv5lDfsu7vISsW3nwxuJx6LjmjF15NCQ8kwM/0B6VZ/p0VvOJGVCNqp+a0Qpd5hgGdrNL/TSKN3KSw/w7IoH6g1FhutugL/sKHz5tkr9qkRtx3xpDbdn8lOqv90kttrHx0Ql2B8Kx1MGpube0zCf3jl1zzlTsisOigBADgxXSYuJoQdg26ePV7s4fdSXNwbNW5nQ0k5vE55+SvBzjT70snI7ESrazuddYfoQCK8v+vBU91XtpQKcI/XSMObyeVvZvXzoVasSEFs2LU0U8lj/m0/QKrIQc99etCTA+jZxiC5Ivmj/TBPHTNYQaLNZuzPzt4qhISTOQ9O0Xd2TkhWkuut/Elf91Z5VSajV+t8=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(36840700001)(46966006)(6916009)(82740400003)(7696005)(2906002)(2876002)(70586007)(70206006)(356005)(4326008)(336012)(478600001)(186003)(6666004)(2616005)(426003)(26005)(83380400001)(7636003)(54906003)(107886003)(8936002)(8676002)(47076005)(36756003)(82310400003)(86362001)(316002)(36906005)(36860700001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:48:58.4344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 129db858-05d4-48b9-6d35-08d915551309
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4818
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

