Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDC643AE9B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhJZJKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:10:01 -0400
Received: from mail-bn8nam12on2081.outbound.protection.outlook.com ([40.107.237.81]:52832
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234007AbhJZJJ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:09:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2Boj9YYsqUtoGyP5EfRle2unEL24EvsrLoSYi3BhnNwOvYV3F4cdc9diu6vPmHcVnasnyU2+UlOd8eC6+RGSyc2c2tJuF5P0J/eRuTGyDn8SjRx7cfEntZTfUo3gktrbQXy8hPNpxOygTbdKbdWj+y2cC/z+uaHM6QtiYBCBAN5cdM2AvKgq2YD1aGdwBHTO0ZAZ5PDe3TByMtJFMHLdyrAP+vuRkdOU2asuUr3Mz8vKC8f1FNb5O3tvpf9zPz/AedGHxOJSPxRC8qGo4Bnx+Tur6RTb2v7QNno+iHLFcSZHjRdZnNEIIxi0xi6lUi1z0WeeGQrJ3wyR9IzY6ELtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JQIq0W3l53X1SP4Yfz2n4wvIoj4KiKObvdNUB8PnJI=;
 b=KMnDgxWnqe9mJy9aLy7Euk2/NMIzPtT1c1OfxO7f1CANr/3ytLHS0onsJmdIqmkPkhad7BN7rIYdsp2rW+TLNsm9KfJepjBEaS5E6GkYjbjzvgxbnQxbCmCxIgk6A3BDKPu6wolt5/fKPiqo2XiMjp7BAFCEGud4HCP+0j0Vc598zLdiv9YIpCy+gIbgCl1ixYZsO9AyYjUMJbUUkRclhhGeJ8SNObK0xTLDep/lMuRTv0GCJwH2Yc28xsRdq4rVD2Wt1DWrHavC4nfLGh32am0YW6RFlGAuHaZwtze6VuzKIosaKaa04JlSq7b5a3OsEJGGpAk373rFX38zcsKFww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JQIq0W3l53X1SP4Yfz2n4wvIoj4KiKObvdNUB8PnJI=;
 b=LSVewblUdv8uTNPvTX6DDuFbmVbXLH0xDwM4v4leca5I16tIfDbcz49DnVsxWQczDbY6XsgIYogqHQkJ6mGgyLr/A4PFC0v9IJLPUBy1CwF8uhKNKRh7T5Xq4rk7O49sv+jXZmHlMty8qGPBiipEzeu1vxcqstdMzF8FZN18TJmEMDNCsUDY+YdgaQnuvi6FQ2UKJ6uf05BbUq93/cS59dpPauVikXO7+TFg0ps9wUtq+G7fs3jab0jms5OFqXBeqRyxxegXNfrQh1JFYgv1cvu2cdb1Zql7WZvRxb/2dpre+eFjgt6oT7Yic22bV/CzjQaTlM2GQOHkofjPphahag==
Received: from DS7PR03CA0022.namprd03.prod.outlook.com (2603:10b6:5:3b8::27)
 by SN6PR12MB4718.namprd12.prod.outlook.com (2603:10b6:805:ee::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Tue, 26 Oct
 2021 09:07:30 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::17) by DS7PR03CA0022.outlook.office365.com
 (2603:10b6:5:3b8::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:07:30 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:07:29 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:07:29 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:26 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 mlx5-next 06/13] vfio: Fix VFIO_DEVICE_STATE_SET_ERROR macro
Date:   Tue, 26 Oct 2021 12:05:58 +0300
Message-ID: <20211026090605.91646-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211026090605.91646-1-yishaih@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 101831a1-2c31-4cf3-43d6-08d998600a51
X-MS-TrafficTypeDiagnostic: SN6PR12MB4718:
X-Microsoft-Antispam-PRVS: <SN6PR12MB4718F2B34DC3E06FC31F0D36C3849@SN6PR12MB4718.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O1g5NgiPmEwcoOluYSeLPeTrHG7jbZ/1CrZJIky/WaLdd5PnjOgj5rmVc4hQ9lR//dkgZuLkYGUAW1khFQXqYyHK6Bum76rk9yQWiR88udOfJD6Eug1jY10tfHMRAgIJVe8AHAisDtedj6GCj4wFJ7IVRFh0bESKhUHSFRxdaz+ZT0DuAKoiQfIZJukwZrMdOc0WOWf2/LxfhT1lJHEiJH3BBgRhGXuXtzwUJGvePY1j1OYUEDppQTRw24ZkxDiSXgMMdMPBTBjkM7cNTK+XZ6mjS7z8aXXxNAJ8nQ8/QRbC311M81VlUZfQHldlSuTGHc/PryfJV5GYku6vtHkZ6cisqrDMUlfKk4ltH+88ipWYDZte5IcGtI73hlMOYy+QOUHuFwK56gzPMX7NP/nIBam0T2iIzBfrWAC5KOkYvP+BX7Zq8hBs5Kjc2wK2Zfa6zj3dNefHbyo/5NYp3OdQ5n5cwyEuBwXYJ9JrP3khPD1NeGvqYriyxCTJBQi7K0E0BgjE4/wI3ejGNha0tOX2LNN+wIK6ANJpFnX7bQaj3Av4b6w9/xoAzAQp+AyzlIuXlQaYmkpaQUtg79qhzVn7qMY5lafJtFQbOIpHsC2IX6hIjla7bKJo++Hik1+Fb/61ZljAu4otAFBLfSsD/3TQAPP79RQXEWtYGhw5YOCwGBf9yN+LyQL9fD9OtuZPS8WgxPWBG7PT+kRiJlTlIeJBvQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(356005)(186003)(508600001)(83380400001)(36756003)(316002)(70206006)(70586007)(7696005)(6636002)(36906005)(5660300002)(8676002)(2616005)(1076003)(54906003)(7636003)(82310400003)(336012)(426003)(86362001)(26005)(8936002)(36860700001)(6666004)(107886003)(2906002)(110136005)(4744005)(47076005)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:07:30.5277
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 101831a1-2c31-4cf3-43d6-08d998600a51
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4718
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

