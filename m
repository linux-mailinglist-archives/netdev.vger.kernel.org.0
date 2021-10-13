Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD9C42BC01
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239088AbhJMJu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:50:57 -0400
Received: from mail-bn8nam11on2040.outbound.protection.outlook.com ([40.107.236.40]:22625
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238054AbhJMJuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 05:50:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HlWVxy9vArmiSzag5pQPEU6sACLAiid9Kiyopapik48SdSA2eWI/yDeg4yGaC3BPvJ3F2ophMoxEribtjF7MiSoGmwN1NcAKoD7p+vZ2VLY95RXvO3tKG08O4XtIms1xxz2ZL54mQRhXcuVhn2TZe1FRhrlsc5KvAOJnXESSLaUzrnyB3y83kT7ACaYe7gL/WspN235zryFzkFg5amvCDIe2AUoOOqtAIutKHj9jbYVulu22XhSXQYMr+pdwcc/NFxBu+/aUXQhit1JYOGyhA4BAGUWFH17fji7tCDiVyfhpyiUHtuISQH8v4IdB59UAhG4EzDqWcrWSzQm6mg32Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7NbaxVIHev3mJq8019+LcbPy1A6au682iKmTvV+19xA=;
 b=MGuE8H3e/q0D5ifxgjrMNNvxnQYTiTyotO4bFoFAwM4N6yhjuljLQExNaRYJ/NhtEIeKxj8xd8jUWk8x8BRvPg6JZvxP7IJQMyBlXJAxvTDjoLCNMMDQAyxdGMcH9gZfEG/P80KiaznR5dm8aOvex9luZCiPCXYjsjx5++YhvkSiOTm88XB+XJ8LW0QhXJ0KltpX5RTefBDP0/Ueae9VYl/RYLQpUS4PumouJYmLO4X08qWO2Mj4A8AhgZzFI7Yt7UNB6hdnfOT1TYs4P12FRSdve1+IOd5vbY3DE7Z7WkjkagJCh3DQ+LjEBkTLFvdsx+eAMTi1svJ43V7meA0JrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7NbaxVIHev3mJq8019+LcbPy1A6au682iKmTvV+19xA=;
 b=lfP0tK7BD+uKtG/QilruHKmNHJKxy3yQ3Es3wB4fw+5JCCShn5RoJbVjJAif+NgxFBGmNIbZ2d/sNgdt0uXSagZWpyVQkq+BsZehnuDGuf5XDSrcID+L6Icv3vn/BLeDgKDzKqsG7JdI3eLOqMVJQyW8JS5CElhgsl8pAUQSflzsF0gcO6nfDULM10B9NnXYgetr8FV9Ppbej1Z5R/9R0g6ssLGGBR7dagXDy+jx5FMfcuPiKfMVzXpJ+M76bRhjh9zpLyy4ODQ+XVjbMOG/7A59DJeye0DWRoroA9+T+ik1ezPjn2OU65hcM6X8UoUjR8d6cyYbi8jfEkBQQ6FDfw==
Received: from MW4PR03CA0226.namprd03.prod.outlook.com (2603:10b6:303:b9::21)
 by BN9PR12MB5177.namprd12.prod.outlook.com (2603:10b6:408:11a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Wed, 13 Oct
 2021 09:48:47 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::c3) by MW4PR03CA0226.outlook.office365.com
 (2603:10b6:303:b9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 09:48:47 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 09:48:46 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:43 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 mlx5-next 07/13] vfio: Add 'invalid' state definitions
Date:   Wed, 13 Oct 2021 12:47:01 +0300
Message-ID: <20211013094707.163054-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211013094707.163054-1-yishaih@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d31da9e-ed47-4c70-9427-08d98e2ea70b
X-MS-TrafficTypeDiagnostic: BN9PR12MB5177:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5177887828418DAF57CEB3C9C3B79@BN9PR12MB5177.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lk/jgtiFQ9i8VQnvYzoHW46gHuTUixLYK6aJcrUs1YYcFb/59xvAhA97JWB+sM29nehuNq5PeSsPaEvaS0cpjcuTmc+wVwyqxfxdKnktvn2E7acjGfA5kUJsIhhhZ21YxqhUJfKOfNgy6XAgC7dQTpYMrTb0vLzy9JIG8rcpwMokz87Zy2/W6mJBfX4ZS0r3PmfNAyizZfIyTNkwhBS3YG9gPHmHs4JO88Sx5VaFJZiJ3rf0gy5JOF9dr2akXZigkw09/c7Wvr/rSyO1af+m5YqAoGLTzoyhDdLv8H+1/LO6/ynADnGIVvrUZPw2c89n9IkKJsIfIJR34jL5X9p5Ykz6jEIaoaUs+ojwQR1yDLIt6LQZR3rxUFnBpduEuPiTgtY5IJWtpfHTy73gIfDQL9ZzAEWro1ciR5HTDPlNsFDHyZpRXNXbTpu47YKmBtxYjUyRjEbCJDvZ1tgygxql9os4L5T+DN3VxSdCS0H1rMenP39+1jP1IRjQvEwP3sR4TfHnSiS512xQR2FPTKnY48mlSEMf60K4yURJtWGTf5dIWMj9uiFzRTaEDbQXguczAEQ+0QcV0+wRrBBcTUzRWJ+dRUNZv9Ok/0cbDQCUfPBFMxZCulykVfc+ehluBCrR8ndZihCqWRBwJ17zgK7uoQjLWAPyJqNGQIBpd9OekFMgCDTIssqRBeFOOayopWqGmM8mAXpbqcFwgg2btow5Kg==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(4326008)(356005)(7696005)(70586007)(2906002)(2616005)(36756003)(26005)(6636002)(70206006)(47076005)(54906003)(8936002)(1076003)(36860700001)(82310400003)(316002)(110136005)(107886003)(186003)(83380400001)(508600001)(86362001)(426003)(336012)(8676002)(5660300002)(7636003)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:48:47.0730
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d31da9e-ed47-4c70-9427-08d98e2ea70b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5177
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 'invalid' state definition to be used by drivers to set/check
invalid state.

In addition dropped the non complied macro VFIO_DEVICE_STATE_SET_ERROR
(i.e SATE instead of STATE) which seems unusable.

Fixes: a8a24f3f6e38 ("vfio: UAPI for migration interface for device state")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/vfio.h      | 5 +++++
 include/uapi/linux/vfio.h | 4 +---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b53a9557884a..6a8cf6637333 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -252,4 +252,9 @@ extern int vfio_virqfd_enable(void *opaque,
 			      void *data, struct virqfd **pvirqfd, int fd);
 extern void vfio_virqfd_disable(struct virqfd **pvirqfd);
 
+static inline bool vfio_is_state_invalid(u32 state)
+{
+	return state >= VFIO_DEVICE_STATE_INVALID;
+}
+
 #endif /* VFIO_H */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ef33ea002b0b..7f8fdada5eb3 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -609,6 +609,7 @@ struct vfio_device_migration_info {
 #define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
 #define VFIO_DEVICE_STATE_SAVING    (1 << 1)
 #define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
+#define VFIO_DEVICE_STATE_INVALID   (VFIO_DEVICE_STATE_RESUMING + 1)
 #define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
 				     VFIO_DEVICE_STATE_SAVING |  \
 				     VFIO_DEVICE_STATE_RESUMING)
@@ -621,9 +622,6 @@ struct vfio_device_migration_info {
 	((state & VFIO_DEVICE_STATE_MASK) == (VFIO_DEVICE_STATE_SAVING | \
 					      VFIO_DEVICE_STATE_RESUMING))
 
-#define VFIO_DEVICE_STATE_SET_ERROR(state) \
-	((state & ~VFIO_DEVICE_STATE_MASK) | VFIO_DEVICE_SATE_SAVING | \
-					     VFIO_DEVICE_STATE_RESUMING)
 
 	__u32 reserved;
 	__u64 pending_bytes;
-- 
2.18.1

