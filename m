Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9BE43878B
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhJXIeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:34:25 -0400
Received: from mail-dm6nam08on2084.outbound.protection.outlook.com ([40.107.102.84]:30337
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231708AbhJXIeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 04:34:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B90N/aIlizrjj1zUB6nzK5Iw1Sxy1RmHs2FZiE8scQiFhCJG7hAh8fEhkWH4bbcuraQ/staD5idW07RfLQD7TkEPrhbfBhPJtK0Oy5VMNBIt5hmFE+GRgSQWUShbZ8c+KonQdbObla5z+X1rZx/A1uaYsSB8d+5najsOYwiEpaff1Htx8tougdi9nKXrR5OKlf4AyF/YbwnvOm4+q6qOQR9OtsAwyUl5hUw5GncO9rfoxwIc/gwOoOF1YsDklJXQQdVDgR3cNvPWkR3cV6oeoUDg58osGx/aBKOvPAVx4tGYZymKd6Lu/QvBS0w6nJjS0J0ttV1K5LMfhxZ3ChHv8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JQIq0W3l53X1SP4Yfz2n4wvIoj4KiKObvdNUB8PnJI=;
 b=hjy+wjL6C54kDBUG6+MR2zZ8Y5gFBtZL/B6/ey9LWi0bA5qsBMqk2/O0NCQfskYYNYsD7KHfunzpVRElvqrfEh5+aMpJBPuf8WtqA3OHp6FuKRVwAQVNdZhUywN/caD1pM5K7Q/VyqiRp5VwO4r2EFMiE+xIIhm1gaR/ElVMnMtIjvI2lFtt99o9gJGp1PKimrdFFm6fsY8HTbQTfpaYPlC9/06CGOtj74qgeI70Dxrnr1VsPsY61qMEpxlcOL2RBQ2i3meIqmeOI9Ng7FlGCTqOXgQn/YbcYoSt0/N0WuyuEJh17kmvwazk0hp/fhLofXYYrfAoGbg7JqElJuyQYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JQIq0W3l53X1SP4Yfz2n4wvIoj4KiKObvdNUB8PnJI=;
 b=YvVD8TGHHgv5xPbaSXNkKMCxHkJEq5hAfEjt9OsB9TLfDOkv8WDgb3QP6ndfSMRsyg+h0An6YYnMf1+mgTuKWjBBSjSa74ud3AVVxA2dq5GAescMYGM0mVdumP6sLM18leDfmjbqHFevTRZuJabA95OIFXPmq+toAZvNo82LkpDbKrjpls+8oz5e7wQPUkpoiIyKRXpr/2NqOVn1wKcV68O+aWOvJy4cNXS9ljgdvQr5FHEJfhJdyz3o132a+K7USFFPN1k7uUzBq/tAr+Y4leJjki5ef/eJi5ArrC7bbWg1CIOB3s2ubCi35M4skdOIJnZgV+ct++LHR0IpTDj0GA==
Received: from BN6PR1101CA0007.namprd11.prod.outlook.com
 (2603:10b6:405:4a::17) by MWHPR1201MB2479.namprd12.prod.outlook.com
 (2603:10b6:300:df::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 08:31:54 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4a:cafe::41) by BN6PR1101CA0007.outlook.office365.com
 (2603:10b6:405:4a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Sun, 24 Oct 2021 08:31:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 08:31:54 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 08:31:53 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Oct 2021 01:31:50 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 mlx5-next 06/13] vfio: Fix VFIO_DEVICE_STATE_SET_ERROR macro
Date:   Sun, 24 Oct 2021 11:30:12 +0300
Message-ID: <20211024083019.232813-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211024083019.232813-1-yishaih@nvidia.com>
References: <20211024083019.232813-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1004236-4214-499b-fc1c-08d996c8bc1a
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2479:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB2479CF796C5A52177A1EE712C3829@MWHPR1201MB2479.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EEdPjkFrd2y/79Dwsm7Kwykqva/TxKDuaw02z0MvaaRHyF/TqbzLrxML2UxYg0vw0DyiCrsn7f1O4+aoVD9K5cvW19FBxvuKwb7TCmnaBKgctLENstV0B75Y4+cpjaatQwkrBER5olkBsXjEcY3O0rd94aBPS6wPfEnH25pZ/D7WrX01QUmub23IOxJq+bKKBXnY5QNiB6ky+KfFrpIplNJKh9p2YMuUzQtt12l4uCDVN3hLJ/+gJT8fRpZEwIqVa8IflRkFs4My2hG9Ahx/VWvZSwLVld5BOLx4llxyYkfnNQdEPPKiUCkIZz049kZSfDSIa3QXu12b97lE2ZLBVZCZtYnV4So/Jg4UrHQVXWW9cXAZu4KkphB+ur7MszU17OKWZdOE2wdW9wYpv/65q/ruOrRQT2ouT/5av5+REAPjgyHsTOv+ZIAMjysmSLReMs4/tdLYhGkxL/xOcgfX5vuuwBjusFDVMBcnlx2UDTC9fiwMiXcNv2TtWCc6qAjP6QydJeLfHBiLlPw2lf9TRyalsaB0szh0uP7rzdcjK7hO3uB6Gzx8MNYM+kCFVPOjFMpEVQwNnf33Hfk3AWRTOFks6GS+SK6Sxr/HjdDmDo6leiSsxWbLUzplewCDWKwzbdsRdDAAxwAG+UkPydbdjWaMHNOJ5HUWL0q9lzkynO/MmieMX0Kc2Uji5Cxe6r2EjT0wWN9DIhggtotfz0vwCg==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2906002)(508600001)(110136005)(83380400001)(4744005)(2616005)(4326008)(47076005)(7636003)(1076003)(6636002)(26005)(86362001)(186003)(316002)(107886003)(426003)(70586007)(336012)(82310400003)(6666004)(356005)(36756003)(70206006)(5660300002)(8936002)(54906003)(36860700001)(7696005)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 08:31:54.1407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1004236-4214-499b-fc1c-08d996c8bc1a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2479
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed the non-compiled macro VFIO_DEVICE_STATE_SET_ERROR (i.e. SATE
instead of STATE).

Fixes: a8a24f3f6e38 ("vfio: UAPI for migration interface for device state")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/uapi/linux/vfio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ef33ea002b0b..114ffcefe437 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -622,7 +622,7 @@ struct vfio_device_migration_info {
 					      VFIO_DEVICE_STATE_RESUMING))
 
 #define VFIO_DEVICE_STATE_SET_ERROR(state) \
-	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
+	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_SAVING | \
 					     VFIO_DEVICE_STATE_RESUMING)
 
 	__u32 reserved;
-- 
2.18.1

