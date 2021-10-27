Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6748043C70E
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241337AbhJ0KBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:01:10 -0400
Received: from mail-co1nam11on2080.outbound.protection.outlook.com ([40.107.220.80]:5761
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241334AbhJ0KAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 06:00:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DyjPtaSvy50J4k5/bhNugk1zhqTcfZLzTKpq6vVjkGokipJNkKuPLBP+vF1FjBtSp8qm3ahQaw4+q4VxHAvM4HmGUY5nL0z0Wlhmfi80iLuLk+FuuxeqwxKSKanOH6wSC93Q2yaOvEGaBxUC6FmyoHlRuK2JLHu8UAakxrcEJTRxIFkUzghf8t0St75DUbSd+ZNKL8OUjDi1UB/lMLV36tMd93aVGK4qoxXZmOjH/5kopzXaIxIJg3tXGIMbA8zxG0K2T5us7PKLlsUEGSMYImTiQDbpzN1wzknbPYaLlVF6VPVpJvRIqT3Ql5wv/JR3DMxW43himSGR9Qz54qmY6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EWUSC24NCfT14SxQlq2ReyGeyhziaCkugOmClyCiu7E=;
 b=G8Hyt96A+BZr3MQx40zRsp5ylmEPzi+pz2XjDj2PUhmyz1D26jJflGJy+sb20JhS5B0zPp9cCBvxokoqh+tgC4sdaaJ+dO/2Uc08cJA/u8QfWZEHNGbuuOfQeoaA3i1jTJZBZ1Uw0u+i5qhAmLzVyED4DPJT8h/mdKdlLxNaVrayE1O2ta29WsuK3HUOY4B0i7x+7qtuGJ521QNqPgtTKJMfcL9T3KGMweXb5/tQjot/a40RXa5q/IKZcfUqtaiLRj+N/19lPfETUo0zDaELLnBziy6VpBAfFUh5uVB8XDqwsTeMuEYf9JWrcUlwtIFK9D5RVTFlckKVtk8a/AnlJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EWUSC24NCfT14SxQlq2ReyGeyhziaCkugOmClyCiu7E=;
 b=L+hVfuYXF/B/vLKFFxnGTaLflh+xzr24gUOn1tdUGZOX0zkQmAP61TjpgG3lMg4d1rJrF4UlPebLaiAPt4Bo5EN9+frEe54B1KiOVGiil/4pxNFyXWHX7GHssLFfu8Gm8paVGrIMyHKIzEEcSw567SnkOil/igmU93o34PHKi1XAQZ7Djx7ytfnQUuMvZB0VkVVBOqWy/Bf+BEQWDe+Jd0m8KJM+E+z6pGqyA9xKe8XHPa6FJYVcW9HuxXqZcXtVxo7lY5NZ1hzlzm8o+CXZdnJ3nx1l5GO9oulDcuCwMVSI0KHlz5MluvVEVJeurU8NGSuX2Co8Nj9TxpTV+ZbYQg==
Received: from DS7PR03CA0077.namprd03.prod.outlook.com (2603:10b6:5:3bb::22)
 by BN8PR12MB2849.namprd12.prod.outlook.com (2603:10b6:408:6e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 09:58:15 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3bb:cafe::76) by DS7PR03CA0077.outlook.office365.com
 (2603:10b6:5:3bb::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 09:58:15 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 09:58:14 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:11 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH V5 mlx5-next 07/13] vfio: Add a macro for VFIO_DEVICE_STATE_ERROR
Date:   Wed, 27 Oct 2021 12:56:52 +0300
Message-ID: <20211027095658.144468-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211027095658.144468-1-yishaih@nvidia.com>
References: <20211027095658.144468-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d949af63-23c7-4c71-317a-08d999304b92
X-MS-TrafficTypeDiagnostic: BN8PR12MB2849:
X-Microsoft-Antispam-PRVS: <BN8PR12MB28490DE732220F5D8D08FB3FC3859@BN8PR12MB2849.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZHNoWywPdowcoUCW0+Vfum1A9A2jxPgrQdGlOq/QNIhP3j3ouNFHa7R5gfwmBe6OOXKo23YbhSzHdpVc5sklPPXTNg4qiT7tQowGhWRRYIsOQ+W+nhIOYvhj9F9gNP43b//NuozOuWlwlsSUzUofXmcmUwVZpWwuRrFzwrVBL06gn/p5jS3GchZ3EnJxTHhvCw/2Rpeqoz36wf+yFaPzXMyLA5unO/Z3lAlZtaldEJD8ObXiEbZ25jZYhzpXaU4RmyP+Djro5x029XhqmjszSTfj/iMMka8QtB8rRL9j3v1+9beyvT7VqopWMB0fM38lWrLpFV4PYbtrLDl1sAdJ+4BsXouNOrVoA0uHUag4XHKyItbU2yh3+YTaZZbabpvdoB587RvUM0j4T5Nat5QEQbwWXj9zmAZCFY0ZSvRgRZxXKei/ucQuG2kkVt1XymNDIGv949QGshNx5wxRUx5jLnLdFy+EkEKDwmwVX1dVl7ZRB6Yl/kYGVHUsxWNFCaFfzLNmf4P0JCu1qEtxi+rJAJsjZlxQtAd/o66fxthitwcjckLZ6AvTPNsKwEb6O20QA2EDtk8ZdSHvmX07F+OMFlQ1bb07TYBmw/ZzO329A4Ul0r0xvAbCuWbTCNV8xBYzbPYFe9hq28p2O/zToGzymUnZpKCRebXcJKSZwWfNe5qh2qJEvXMiWjO0ngzmfAOIwRcSW0zWk1tCWvRc3Joreg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(83380400001)(110136005)(36906005)(7636003)(6636002)(70206006)(7696005)(508600001)(86362001)(1076003)(47076005)(336012)(8936002)(356005)(316002)(8676002)(4326008)(36860700001)(186003)(2906002)(426003)(5660300002)(82310400003)(36756003)(54906003)(6666004)(70586007)(2616005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 09:58:15.3968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d949af63-23c7-4c71-317a-08d999304b92
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2849
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a macro for VFIO_DEVICE_STATE_ERROR to be used to set/check an error
state.

In addition, update existing macros that include _SAVING | _RESUMING to
use it.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/vfio.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 114ffcefe437..63ab0b9abd94 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -609,6 +609,8 @@ struct vfio_device_migration_info {
 #define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
 #define VFIO_DEVICE_STATE_SAVING    (1 << 1)
 #define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
+#define VFIO_DEVICE_STATE_ERROR (VFIO_DEVICE_STATE_SAVING | \
+				 VFIO_DEVICE_STATE_RESUMING)
 #define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
 				     VFIO_DEVICE_STATE_SAVING |  \
 				     VFIO_DEVICE_STATE_RESUMING)
@@ -618,12 +620,10 @@ struct vfio_device_migration_info {
 	(state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_RESUMING : 1)
 
 #define VFIO_DEVICE_STATE_IS_ERROR(state) \
-	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_SAVING | \
-					      VFIO_DEVICE_STATE_RESUMING))
+	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_ERROR))
 
 #define VFIO_DEVICE_STATE_SET_ERROR(state) \
-	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_SAVING | \
-					     VFIO_DEVICE_STATE_RESUMING)
+	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_STATE_ERROR)
 
 	__u32 reserved;
 	__u64 pending_bytes;
-- 
2.18.1

