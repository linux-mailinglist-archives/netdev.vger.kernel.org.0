Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64411433424
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbhJSLCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:02:08 -0400
Received: from mail-bn8nam11on2063.outbound.protection.outlook.com ([40.107.236.63]:26817
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235376AbhJSLBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:01:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVVL3YHpW4F7ZXP+fjpC+HMv4xM6A95F7g8RjBG6Qg/rLIQNyed7fCeZOo9DXAd+cAgNC8Ig6oFFa9CiL4J3kgwcXK5rYIVGUeGRl0JIEcq/6mFIQy2wjW8EoQFPTnQV+3/ADngeLO3/oliy+UmE970ZswLBNVFLPGJ5S798Yr0OUrZ/Xun6eOf8p+UoPqP++DBZMyBEEbk6oHWg6S4C2O80nltdRhNC5Q6tNQcOOdcrFEDKzTkBlqA12BKFhfUiRigMoxlqhpqIEejM2g7PaxY7M8WZ+LWOwwier3iNFb3l7drOo0Joh8GCybO07go/rccMsf7fYjAoVmvAk5e9kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JQIq0W3l53X1SP4Yfz2n4wvIoj4KiKObvdNUB8PnJI=;
 b=ck3Rs3zUsdF/vfocjFxG9dy39zBv4SYwM7Jp54FmCpYJzFSqy7pPkQI490BAQ/iIPeHdgpIZtTV4kwCxZ/9JhGdCMQLQ++YsT5s02VCFrK+yxzJWGn3FCdxSrhqA8nMNBzIG3laXsZ3OZcITlU1jPJnG99J3oeuDDeB8YTOMh2cf5LKoW3StMOyChK1CVGkAnBQVaNcMFLBL8feQBL+gwY4SgrbKvl5hYuTuKYYrU20aJh0fSacHHSYMQYG3ZHrolO3TcMFru39kzUNn7ZYpxpDc/4VkKz97iXerNgKDmkfeQiGQaNJUxmZwYOdUQ8br+DFQMBPZUlTyh28mb9qRxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JQIq0W3l53X1SP4Yfz2n4wvIoj4KiKObvdNUB8PnJI=;
 b=azXqeXBcmA8wF7QsxpNFRq8/ZFDqAWomLJPHNKyh7tn1pYmpDMTrKhFQhQoT35N9+z/KvfcfK4CnslSsE5WeAWXE5KbfYfTW7nqJvAvbvWGGrZXvGDie5anc3jhTOo+gNEvomFb1FVXLNK66dUEBMaXK7r8fOMGHGTWFnURHdxOO95ZU7rzS1vUrT9GdNW2tctP2rkXoASgFFCWKN8WhEZLE9gW7KHi/guldMRFl4fUWnLziWFFloFZWtD4sSkm2YNiZlrLPWn408y8QOYaKSHuasBc2SItKAytCIf/1GphVugdLIqbp/7ondb00FPPTcWLDCu9iM7d+dbR58gJJGA==
Received: from BN8PR04CA0015.namprd04.prod.outlook.com (2603:10b6:408:70::28)
 by MWHPR1201MB0141.namprd12.prod.outlook.com (2603:10b6:301:56::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 10:59:40 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::ec) by BN8PR04CA0015.outlook.office365.com
 (2603:10b6:408:70::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:59:39 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 10:59:33 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:30 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 mlx5-next 07/14] vfio: Fix VFIO_DEVICE_STATE_SET_ERROR macro
Date:   Tue, 19 Oct 2021 13:58:31 +0300
Message-ID: <20211019105838.227569-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211019105838.227569-1-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aab02568-1df5-40b5-49f5-08d992ef8c28
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0141:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0141F0AF7A1462FCF8D3EE30C3BD9@MWHPR1201MB0141.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N70uHExVQweb4ol61fQWXUM4HB14bfc4zvAdi4qNPebGco79QA4obZu2y9/rtJudqTDxrYKkisD91tf56t/JBakMVwlJc30YpzabNbRuzUA9EjNoXzg7lkUJ3UTlCJUnoRXAXc0nf2NpGqrjo0ht8kg5Pk9NSclWD763fhqaLHVzA6588L1EtRTx1BV+spRBZsq/7ru/WoCIRl3f+OUzf9aB5cxf6T3RgUGmn75/0X1gRcbG0bHbLOfqWULr5DH9p/Ag1b0Fpxlo9DKm3K6A5m0sMoiGzYuEN+cVI6Fnso4AfuLGzXKqeRMBKYgUT9P4w4RURaQgAefQ3wTjLeyYyJfog3rDumcYqIuz2CUfpj9IQBSxn7BWSpnoPM8ZyS0x7btQtJPKlhDKnZPlmgC1UA0h6tJ+ji6YIENgiXa+9RXqhRhbGuM+EVfTBvXZsUqB1SbMOziT86kxA0RHjEfpNFO0DP9boY7qmh5X1jJ6K6o0tYNjQrRmBxCfEijs14n+2glLe575BhZ8I04MOEU4U3XLuvD1akfEDCyji/F4IGnVImVP2p8WK8rPLBosGx/7H5OQLVoErCis4enshs9iK0O8QZz8UAp/FDacyouHOSM2eaJgdC9BfyI19nzyeKevdm11V6Ap8e3VhwMeR5gR5hVE5H4DRT8IAb11mevq5kF3Si0yudcaf0KD0n/+B0sHnNmOsQ59D/lJRI9KzVMfpA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(110136005)(82310400003)(54906003)(6636002)(5660300002)(7636003)(70206006)(36860700001)(2616005)(4744005)(1076003)(8936002)(107886003)(4326008)(86362001)(70586007)(336012)(426003)(316002)(47076005)(8676002)(2906002)(26005)(7696005)(508600001)(36756003)(186003)(356005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:59:39.1338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aab02568-1df5-40b5-49f5-08d992ef8c28
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0141
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

