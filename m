Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6E443878D
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhJXIe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:34:27 -0400
Received: from mail-mw2nam10on2051.outbound.protection.outlook.com ([40.107.94.51]:46081
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231822AbhJXIeT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 04:34:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRWJ/G1lKPEungoe9IuTpRvnc5xn04QEob+bT0vezV08q8qUxhXNqxDRcUTIZg4WtH634hXAeiIhC3NorvPJk2jSLNJK5nrv1iaUnOOQxULq9M8LiZI/2JQE6HmXtShuZOzyt1vn/IJFUcZJtDylVycMdNMZ8adrwvPuSiHUiEubEcEQvCsN+4OZekSbAKeYm9I6ryhVzuTNn9c/Hg55OlEz+7hWrhd84AOckMl5ko7njgbIjj8a9hK666o8YOZLzxjrhc1b5ST3MdJsPotyFBwP511ykHQOuJxEviwoA9DIKcGXaCC4fpIDgTJRtUJQ/wEj2MGcHZhUHaEvgQvQQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A6cqDSd3/TvsRnCwVTJ73QVeAyquuhOTjwxlfWJx72Y=;
 b=lPx0xuc6P15uUIungHGjezCT0Y8zxpmEQ5n/k5vEWcFf3iwNjEvGkQeYWrMg5bXYnOG2kgbOWLA+iDH8kzNE1fCLU6qq9INpGSftuHyFLd6zWSUKmU6OsvsAT+2N3xBRRRZM1AO7MDKGsNe7/GR8SDm+nJsK8/r4BrXG87X9AYZKcIM6d6fvPwn8BHIPzOJlTjpsuvgHJXaxFaUqBMVQCe/AbrUxVNQl+xWk6bwCC3cM3KbCbm8wkgrPglY8a3PL+7NXFv1ScOYPPK1ryeVV9PsTPH8oYBqi8wGiqUlKHIfCDpz+h/9X1uF325dctLEJHkobsTCUqz8pq3myBVhLwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A6cqDSd3/TvsRnCwVTJ73QVeAyquuhOTjwxlfWJx72Y=;
 b=OBv7pIeamJ1NRo95/vKBefTPurN/+OqMCEtEfhlogp7f8Y0D4kiH7Tez4BQQXDxaHJHt4mpckuJ+SYdqgDXtx7d+wS2EhctkNnSrHoj8Y6koElncT+A5QfMUPtVo43kbV1hW4yMYHh/lz0U6OUxrUBhTEwCI3WAaI70JFZfcV7/a3ifBl8aKOKT50zqjBhT7EAGB4ONyO+zEPkBvg45JlP5fSQTNhQgpr+CTpb7RAu1+mFILRmfC253l2ga/RozxxK8elahq+RlXkdXy2Gw9RmmRALwIwLoidxC8Kfdw04ou0HT/447r/0bu1prEwFBWTFWJsirJfoAMlipbd48W1A==
Received: from BN6PR13CA0069.namprd13.prod.outlook.com (2603:10b6:404:11::31)
 by MN2PR12MB4335.namprd12.prod.outlook.com (2603:10b6:208:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 08:31:57 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::4a) by BN6PR13CA0069.outlook.office365.com
 (2603:10b6:404:11::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11 via Frontend
 Transport; Sun, 24 Oct 2021 08:31:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 08:31:57 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 08:31:57 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Oct 2021 01:31:54 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 mlx5-next 07/13] vfio: Add a macro for VFIO_DEVICE_STATE_ERROR
Date:   Sun, 24 Oct 2021 11:30:13 +0300
Message-ID: <20211024083019.232813-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211024083019.232813-1-yishaih@nvidia.com>
References: <20211024083019.232813-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4462a0d3-6a70-4642-170a-08d996c8be29
X-MS-TrafficTypeDiagnostic: MN2PR12MB4335:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4335BDEE5ED72C13D2B2D9A3C3829@MN2PR12MB4335.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sz6ePiissbXHTme8xHdrme7uL7lChNUbZdoIaxCeAaC/9z/DuLJRhDr/K0zOoq+zJNtqGKJHgkg8OccvMwHoWDR1M7b9at8vh15IKqc11oRgcaqQhKmPyZHXfgdF3Wy0rduuNOetJWsEccKf0QE0YGibYqd17LVaDt9gAdk7FYrMFXicVAdEKVfZBDpNXdbbQ0FgqYRrNB0rqYaSJrhFTNqH/UnDKXNBm8xgwOt2T1ve1Ymy3CRMCKHO++tl/4KBRsQR61NLvfXKDZCyH6H9rUXgnv+db+/5TXPOUC7KK0tg5oGmv1zZ95t0eXMedemT7Z7LDUyIZrk0pq9CS8hZ5rs4Nj3wmoLkFv08FaHkAa+CHRMiYbg+hMx6g0MWM1QM/jGmR0ZKOodalOuMB7npbCBW/Pv/cHE0XHxWthaefa2xIu533WlFIOzFdufYskn7wOxdKcn7v7EydO6NobSmktU3UTb5CXeecGX07bpVVgnIKHTpcdGNQzo3PJh6spV9KCb7jgVoaTw72RuBcmU1oAX3jMOxp4MoFedvmL/GDNpt10XzvCnBli7dFia7jT9y0xt+7JD+XJ0Evf+aCiBEvIZfZR++TmscCJe0o8mExrXOdFvyCXh7BH8fXeEMW6xdL+x8nCCm89Meb9XIQyG25uRqEgck8ukZLxJIyjI5qi6Gi8FGWR9wYJZDJ+AtUzOZmVrTNgualzaevyH6PGP8Dw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(336012)(426003)(7696005)(36756003)(26005)(2616005)(186003)(47076005)(54906003)(83380400001)(6666004)(316002)(8936002)(8676002)(4326008)(110136005)(82310400003)(1076003)(36906005)(5660300002)(6636002)(70206006)(70586007)(2906002)(36860700001)(107886003)(7636003)(86362001)(508600001)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 08:31:57.5826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4462a0d3-6a70-4642-170a-08d996c8be29
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4335
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a macro for VFIO_DEVICE_STATE_ERROR to be used to set/check an error
state.

In addition, update existing macros that include _SAVING | _RESUMING to
use it.

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

