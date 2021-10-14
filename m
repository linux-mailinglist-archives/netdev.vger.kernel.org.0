Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A71042D431
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 09:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhJNH4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 03:56:52 -0400
Received: from mail-bn8nam12on2062.outbound.protection.outlook.com ([40.107.237.62]:41825
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229967AbhJNH4s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 03:56:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VP54HI9vP5GA9jLcQNEtUdhrfDjWPX10K3sYv0+/BozRAbaMxe37i7khT1e/fjPYSlRBEV+9XqqKf9rxNxrAoIUkocxn/BnpmaR54QPAGd6thblWO3/vdSA+5e0nbuVkPt9QrKqLTbf3fjAcuDyeJvyCDvR5zBNxnU0xBYVbqXhI6huxtOlp3TnDEAzmd1MYZVEi+R/luZc7CTd+Kz6Nbyaj+gsLAtJLv10Wp790slO3XQvTtJH3f76qm4sEoPfikKCVpObK5dAxVrTseyCxoX58EOExO2s5w5Cvwrr8hfQfV3s7I1D5PNYJwUpsS35IE/3f3yfFOHggqMr6kR9mVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+JKneylYb9dNQ+ZRcLFYMBjh719XN10k7+DDnOqeNc=;
 b=dAG3k57TA9cy4DE/8XMevX/D0TeIf4rw4TmQlO3ZxzLZXPfVAL+jzG+wJAGoZe8Lg1tC5Mlc86nglNJrovYHvvaMdTc3letAxrZBx6Iawp9AixpCPaT0Ra9FSjG5nMo4cI2XZE7fPIB6A9st8q8emwUVCFreWmlFaifPEtVaqDQlR7EEL0EzUORUXuCnMoTsQVCGAmP8dOEB7I7F/vJszFRSgFKMx4nmv2cb2o9vcW4NumlttLlYoXkTiC+WPTyz6QeFgkG/RkLKrsoXdbguvWf7rdcYMdwD0o4hx9+5wkPxgE088gOm9ndm+6+3rm3UCXG2qouynMThVNHmqrdPmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+JKneylYb9dNQ+ZRcLFYMBjh719XN10k7+DDnOqeNc=;
 b=EbKgfiOsFYKwM1Azq6GvtdCsqXybC5KxnMJp5fAkMwlGB/mw4xJ42tq891acgQxAS7gdaItFEbm2mINWS8sLlPjgv+vAyq+oZyarp6RdDcLiu1JgeFeDj5/Ipu+ICuB/AUBPCBwuxw0lrNYseEYgixqyboHbrjR7CbRWOCMN+TZGmTia0C5wqmEy83+yPBkZU21v3Kc4QX3h7Wx9vUeDYdm7D3DKbE02u+2Ichu2RnFo2pW7t1X7nfN4aBd4WQSwaYtz08OxsHmOVOL3ToxQlp8KN06Ehav5ovmY9J+/2H4uMA2JGzSfAtTsc8cw+iJC/n2xoZ4gb5/ucR0gQoIC3g==
Received: from CO2PR05CA0078.namprd05.prod.outlook.com (2603:10b6:102:2::46)
 by BN6PR12MB1795.namprd12.prod.outlook.com (2603:10b6:404:107::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Thu, 14 Oct
 2021 07:54:43 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:2:cafe::66) by CO2PR05CA0078.outlook.office365.com
 (2603:10b6:102:2::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.5 via Frontend
 Transport; Thu, 14 Oct 2021 07:54:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 07:54:42 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 14 Oct
 2021 00:54:41 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 14 Oct 2021 00:54:39 -0700
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <dsahern@gmail.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH iproute2-next v1 1/3] rdma: Update uapi headers
Date:   Thu, 14 Oct 2021 10:53:56 +0300
Message-ID: <20211014075358.239708-2-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211014075358.239708-1-markzhang@nvidia.com>
References: <20211014075358.239708-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8718f27d-0bfb-4949-d156-08d98ee7e1ac
X-MS-TrafficTypeDiagnostic: BN6PR12MB1795:
X-Microsoft-Antispam-PRVS: <BN6PR12MB17955A215BA9E57177451ED7C7B89@BN6PR12MB1795.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:93;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SeZb7uw84AJ/HurFGJXMzaMD6AODLViHOtO9efca8bA3MuzmWsq3fyTFrqzdXrWtYxZAU6dNyM8SXE3c9RA9j4sYaiS13GdTP4gBHxleq7NMC+VvaoymKkEH8i8D1CkH6HmKvAKJ5ZvVUyAdd4ZFHhqzEwdq8BBB02LQa1U8+PknpO2mgV/wl9pdbZJPqypImI4hzOLvwQSM8/zYzZS8E3oHa1ReTyMvR1AnHeoSLq+UXvnijr1oHQ1eV9TkygC5prvr+TDZtlo7ejyuyQf4ou5ez8Q5fTX4v+G1ys1KiVduIyAzC92qx75Pa1ND79r2ZlD9cLGmqX0JmIg0/OEAEO425htyIL9TT0mWi1qlmfL3aHZKd4w24IW13+O3wnbupaI9p9OaH2VkoYPRXV4hWnyc2gu9A6/Uxl73153SjhzJqRRRTK1G+GCxVc89TDijgM/Bkavqo1CswJIrdODBRJEwiSPLDCY70lo/5Q/shIZCsCGWJhzJtu/sVi4qnYX3jlaqnuHu5W7cOav4DOaka82ibMRVVoYIvPtuJmaO+3WGGC4s4nPzyH6CMDFwKHt+AO0WYZhRsY2zn9od4FyM4cfiihlYbX1RdH7Ou1yZ/uJ8GEjZD9AUdgARsSFgAU8LKzMlu/bK1u9SQyYB277gcpcn56lGW77QhQggho1gOz3/WuW1ZDrhzgeSwKhj7gH7wg6HgNI8naVIpc868vezGscY3p/P1RrifJrMBvqS4qg=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(1076003)(107886003)(4326008)(186003)(26005)(2906002)(15650500001)(70586007)(36756003)(7636003)(6666004)(8936002)(2616005)(336012)(8676002)(70206006)(426003)(508600001)(5660300002)(110136005)(316002)(4744005)(54906003)(36860700001)(83380400001)(356005)(7696005)(82310400003)(47076005)(86362001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 07:54:42.3395
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8718f27d-0bfb-4949-d156-08d98ee7e1ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1795
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neta Ostrovsky <netao@nvidia.com>

Update rdma_netlink.h file upto kernel commit 7301d0a9834c
("RDMA/nldev: Add support to get status of all counters")

Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 37f583ee..92c528a0 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -297,6 +297,8 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_RES_SRQ_GET, /* can dump */
 
+	RDMA_NLDEV_CMD_STAT_GET_STATUS,
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -549,6 +551,9 @@ enum rdma_nldev_attr {
 
 	RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK,	/* u8 */
 
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_INDEX,	/* u32 */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC, /* u8 */
+
 	/*
 	 * Always the end
 	 */
-- 
2.26.2

