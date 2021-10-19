Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC12433427
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbhJSLCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:02:09 -0400
Received: from mail-dm6nam12on2051.outbound.protection.outlook.com ([40.107.243.51]:45888
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235381AbhJSLBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:01:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+TCeiheYJ5rWLLT0etm9qRvJio3ZwmjKYfrrMRdgwOi+mVuXGEwEOOSg4oYBy8OViWitNcyLakrSpEpezJPDf+/2lzIYvWdK2JoPcuPR2flXZb6NqqiPV0Kt39IJw/NuzcHzMlbmbkha9362QwWDn8AVbSgVJrOw7nfU3F9wnR9QkeFR6czD/s3Hwk7Eed3BZWwHAzDDhtztMA84rye9YeEePxcTpr7raKqV/ne57gM7Es5Mc9Q6p1Qs6MJm+alUyjZ6Es1kR7Wb0ZHz/r7UqyyyVU9OvGCqHGZ3frda6xZQpFYsKo1X4FntZd4Q7tpCQNNxYgTzrigBtowJ84v4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8goAoxyjUAsHv6c1ws9+V6erIF3GK7IY7fbncebHEMs=;
 b=Ullfd+d+UxxEGN6XnK8j19BK6ychqw2X6GfMx9NCyGP1DU5Y3qgJsgSGszFYHLEBe/naX3OQecj3J3FxJmqlBBRAfuSuyTtJkK2hmyvpj77s9QK3JGEo+d4bOHP2h0321VUjRxeCVSa0qlv4ToU9lDEvinTTtaO5FCaAAmU/60IwEAdSrPP+2cs2luvVHXbM+ybw4TcEBSZYzCXjD6TH9d9nOpbjfwg45kgWuZ0Wpwz0Avhni2oLz6UWfkGFQqFnsqwUV1bWSV7yzgdJGG1ir/dxBZiHjyC2xJSH+WzS0E4ftXKJU6EThM/3YNXjTTivCJxegsECr4EPWQV0POD4XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8goAoxyjUAsHv6c1ws9+V6erIF3GK7IY7fbncebHEMs=;
 b=uIPkgSFibttehPVWAx+CCiZ7AxxvJCydrmafg8vu2moarF/SBE1PWqhT7mbIHxlDIVeUUsXrSPaaRvztONGuxd/D191wlvELp0Kj590jNn6QLRm4XJtElHdIKZMFAp/NQTpm6Hxekatl5ACv33cXkzXWd9TiXJoEXtVAI8YEL9uB3IE1ISlSqI+/Ey5OHG2Tq2H9WurEdSdiOMOTu/Ae4k/tW62sMIUkOib5Ia/w0kn65+jND4Afry3xXSVgr4qDkF4UOgjgHiGwfNk/Ki+Wgrh4p8rVBHpEXXmWH+U0ciKt1OeYcIoxkPFAGChfMueC063A5wEaCaKdF5DOXqC4zg==
Received: from BN8PR04CA0014.namprd04.prod.outlook.com (2603:10b6:408:70::27)
 by DM4PR12MB5293.namprd12.prod.outlook.com (2603:10b6:5:39d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 10:59:41 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::21) by BN8PR04CA0014.outlook.office365.com
 (2603:10b6:408:70::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:59:40 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 10:59:37 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:34 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 mlx5-next 08/14] vfio: Add a macro for VFIO_DEVICE_STATE_ERROR
Date:   Tue, 19 Oct 2021 13:58:32 +0300
Message-ID: <20211019105838.227569-9-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211019105838.227569-1-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d54cdcf-763c-48b7-97f3-08d992ef8d1c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5293:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5293C8C3AFB754CA38BF2EB0C3BD9@DM4PR12MB5293.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: okj9jkAQ2Svbb95/pb8cAQzm+poaMhUARTMyk5xjBrmb8CKfHcz/CtA41SYkwvUWz42KY1XXlI5XGAOxwCEgAPLzmaOxiUhAAxRqxeHOueuQvqkmdSDMgWD97EyRVDoTfsmG3xZQzwS8GDRNNLon3NXEVDtbrItHhTDPZK+bT10nj+Y91wwRFDxVHpNqdzMNpdSBDlGxGouKwotKcxFYEl5J9ZpGlCD4ZE4cgnk3Y67nncXR1ZPP/GzWmo9LqXMWJw6MZY+nGSVbm00Tw9KGQCYkXsAdppYRuafzyfKl9mydJmO83M25Mrx7Ldp0AbG9IOWmoeNhM00x7lqF4YfuvCd6I8XF/9emQLom5IxUcwIGW+y67ckXUcNIdDukURBuwBorl7ax5cQzIKh0Ku06p8lhC+i7DaXpRUgKA/uyQ5oV/IW1lkTdWiyFn/AiHWb/pxBvEFMydyAVB2sgLQXuA+dYfYgO8nJBeP3ik2/i5dwdGHrC6NnSVhcmuKiardLztkEb3MnwO8xkPhO5FPPhLHy3GIUUteRys54lftOuZeBxJ5hZEnoXpWb7/hW79nlhnADXv4c4IucZBe78DkuWBK0HyLmkUx+EVhE4b4/Pia8vcrEotus9AI8vzSc1fD5aW/yqRiIVhZ8d08TpvZXG3OR2AqAIhXlGqXjTCsU34Wls8QmB8mzhpooVPytReLnoNzPU76QtQUCkhcfQRb8I6w==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(1076003)(6636002)(36860700001)(26005)(8676002)(107886003)(70206006)(4326008)(8936002)(508600001)(4744005)(7696005)(2906002)(47076005)(5660300002)(7636003)(82310400003)(86362001)(356005)(186003)(336012)(36756003)(2616005)(54906003)(316002)(70586007)(426003)(83380400001)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:59:40.6619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d54cdcf-763c-48b7-97f3-08d992ef8d1c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5293
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a macro for VFIO_DEVICE_STATE_ERROR to be used to set/check an error
state.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/vfio.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 114ffcefe437..6d41a0f011db 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -631,6 +631,8 @@ struct vfio_device_migration_info {
 	__u64 data_size;
 };
 
+#define VFIO_DEVICE_STATE_ERROR (VFIO_DEVICE_STATE_SAVING | \
+				 VFIO_DEVICE_STATE_RESUMING)
 /*
  * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
  * which allows direct access to non-MSIX registers which happened to be within
-- 
2.18.1

