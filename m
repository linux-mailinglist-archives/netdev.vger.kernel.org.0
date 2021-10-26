Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE4243AEA0
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234516AbhJZJKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:10:04 -0400
Received: from mail-mw2nam10on2071.outbound.protection.outlook.com ([40.107.94.71]:15520
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234576AbhJZJJ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:09:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGg7yvxk54d65In7soF7Brzu5fsoJIsDh+HdvED6GqG9qp19ck1GoOs4M51W6iYwARQduiqOLWgpikg/JhxOnCdBUicc61vbitIcM8zs7cllRsVM8OyzKgEyzWBRsOcbV3pUmrUfyOZyIHXzyqMLqd1OJDpPLvjiPv3l9h7fdaKR8EU6WbQT+jEXFWqwKjRyY5tUbSYNtBHQayPn4MHxbaQZEpdME1ykTfssqjZI6lJS51t1zDaD8za6/YtVvJgowwJSYJ0mACl7SVzZ3PLwXaAwWI7jKNmfbF/iQAzdbKlPv7a54umqqwFD7bY9S4M4FY1MuYRZ4IuanbQrcZsgbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A6cqDSd3/TvsRnCwVTJ73QVeAyquuhOTjwxlfWJx72Y=;
 b=iVL2D2WXeSTjgtK6hRO7M5nJWR+XM8CycBbtPdTtGcx/JE37bnIgUtWiB2ari7JCu9HLrP9u46P9g1vMcqG8qR7iimaXfDSDyt8vv/rsnP02Bl8zIGsWb1+Obh1yVgDRAeF791wgSvhUipwTzFAwog03Cb0EOsM3vANJ25P93U7AbNvE2ppieDqAqgZLgyzPs9Sajt/39NH09d4K3nJZfnLSdfcFnor+XuOblpQVQUrNFKAw9DZq7maYofD65shi+WGZCQwMXMXjH+GZfCMpQ3tlHTX2NSOU+2VYoxxDaFx6FW3vRabCKh7Qp9SArBVSxuhNzGppfjRMKEUkiPdiJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A6cqDSd3/TvsRnCwVTJ73QVeAyquuhOTjwxlfWJx72Y=;
 b=HLewS17D12eEVSstX6d8fSzBC8fgKNsapBThgHsaVUq5Ka2YGCkOMI6t32Kts2kLi4ANHPoP2j4jirEiYqBc1nYRECEQtZCUaEBu79vr9JPX80qKA0g3YtsUUbCW+zEEC6S5PVdM1Qhn7RI+yGEMogfrJ7OO+mhFp214MeMSb9Km4Y6v15gdyUCKrdPHaaMX10voUUmtWpJcyudn70yHHYW44ys6ijI8LdsPfkgtguQCwcwquldHjqaWh3+YEA1DOV0TnJYJG1pShLCtS9ozntTeomgAGZ9o9bPIHb682gCMHKlCqUj2ojHcG1CYwsrkragK1TcR5jVr7WPdLUOXuA==
Received: from DS7PR03CA0002.namprd03.prod.outlook.com (2603:10b6:5:3b8::7) by
 CH0PR12MB5091.namprd12.prod.outlook.com (2603:10b6:610:be::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Tue, 26 Oct 2021 09:07:33 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::31) by DS7PR03CA0002.outlook.office365.com
 (2603:10b6:5:3b8::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:07:33 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 02:07:32 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:29 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 mlx5-next 07/13] vfio: Add a macro for VFIO_DEVICE_STATE_ERROR
Date:   Tue, 26 Oct 2021 12:05:59 +0300
Message-ID: <20211026090605.91646-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211026090605.91646-1-yishaih@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8ed5e55-17f7-4789-8c5e-08d998600c2b
X-MS-TrafficTypeDiagnostic: CH0PR12MB5091:
X-Microsoft-Antispam-PRVS: <CH0PR12MB50912AF6987B1B40784A4F31C3849@CH0PR12MB5091.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SiJeP5vtYLGMqYF/LgXGfItl5vw/dEIKXKkL8ojQFcYACDriZx3+ajE90F3Lbum0Euw9GBYWpCnGI+yGalTiwQ2FEvmF4JhCp4JXfd0+kMzIsIZWyhFeQhu5Npk3toxjiLj8zFNmkm8NufGzEBlw68AjjpFjgFp+wtbmBoUyMWgo/NmQjo1dlkx1Mx6J3YoL2MyOYazTviz5Fz1SeZ6MvaOpPzzz8By4qPkSx6hKbuoyfKuM5Hpy3iibAKMgJuAag5hF+xKW5jWiA7KottCIqwEe0wmDZWn7Hv/AMg23K/fbZZAu4HEcABOVKZw18ZTrdWz+N2xJ5fn+GR64Dz1fbPh0Rsd+dlfWm7RddKFvb7KUzILRkblTGEH1YRLTi5g5B48SEBMhb7mgby65u+ge5vSAzrS4doBquwF9ekdYUU9hSGdo70TeQTrqjkruJj+t7yCinXLrzKD20WtTtD67sZNC56lgBMsn3soOj1GeyEHlR5KJM8QRgcPnoWPd7LpD/Z0/0ZvG/Vn4LYzRRC8PfDEhc2Q8BMVxSBOhpdajSqKxyDOUi1GpB1mLvl5hxIqbr757+FDOWPcFlARRhoLPPM2CtBy+jWB4R6ckEPtBP4jOTnwb4QMVQf2qkYqnrqeJfmu4qRj3cOGe0QXmrIY72w6uwoa6sbia9Y7dsh/qo8umUcZwswIjstnXjjO1OeaexFUwf08qCpp9XMjOsTCXJw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36860700001)(54906003)(7636003)(356005)(1076003)(83380400001)(110136005)(86362001)(6636002)(2616005)(426003)(7696005)(316002)(5660300002)(6666004)(186003)(4326008)(26005)(70206006)(107886003)(508600001)(8676002)(47076005)(8936002)(70586007)(2906002)(36756003)(336012)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:07:33.6389
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ed5e55-17f7-4789-8c5e-08d998600c2b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5091
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

