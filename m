Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4346C548E
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjCVTLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCVTK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:10:58 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401C8570B2
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:10:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WRgz+m2RtR1Rf1POuvx2QwQa+dHMucY/mDnCZC5VHxOfZpEaITCEWdqSxEMVD0LVzfIelaYgEUCXp5ZNeoMF+6v4UHzQ/xgrF8d9klubObde54bZma8Bguw6KECmq5zuvMeWD6KaqnL2Omt5fOQSZjN72daRnqmEqboq3uqsoBV+TdiNgFaZXNKMm0dvPtEe6SEBXxUrRv0RE1plZWmTxRyUlEsZFrTUxFprZ0096jGlEPKI46tZ+r7yYE8dyDYj8bvnSgqSpgtOVF2B456p9n3K3dNUWag2Xp3v2Yj6i+UaQLJSaIvWVHRspGMY2lnk8HgE8FAZd1fv6jiZIrEPsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q944AGSbLZa1GpsklG+Def0XmFjiS60a7VYRxzTuOT8=;
 b=KLqvPSh0q9Ayex7jrZEsqTwrW+Fsayfo7cGJ0brM8T6Y9SNcln9aU8UyIVhiEnsKWo8MItthLkpVP5rif0C2QImAV5bmv+h1kejcvzVVEtq5LHa4Drguz2EoYqjCE4Zh+verLDXELsIjE0KljT3kcevuqRk9r4GDz4WYrsvgl72HOvs4EpiZEqC8Eh8yrOHPP0CaZHFvN/prYZO5Nmb2bRZaoEiPrPZonvbTRT7Xvb83Efm34s7wTYBpxUxG2blOH5BQuhXXaWJN8wLM/FmrzwY4Wl+aXLN4qzUTy9q4V5yG6Meuriin04JzLVCb75Y7vrjDYP3zbO31+bS5eJDaaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q944AGSbLZa1GpsklG+Def0XmFjiS60a7VYRxzTuOT8=;
 b=u6DQeGMn+MeCslBzadGuuiHcN4YvOKaT6dUj5GH0aNhZsxiAH+fia83y1hAupK4mjZ0FSYbFFjpkjkTxR8qV3SATJ3va+MdNXUdAkpKmvUop0zmSqpZ/xF01GEwv0800zWoVxwoxakwDIt6eHVD6lhBjVFIBsSRpR9s7lz1X73Y=
Received: from DS7PR03CA0292.namprd03.prod.outlook.com (2603:10b6:5:3ad::27)
 by DM6PR12MB4417.namprd12.prod.outlook.com (2603:10b6:5:2a4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 19:10:55 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::35) by DS7PR03CA0292.outlook.office365.com
 (2603:10b6:5:3ad::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 19:10:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 19:10:54 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 14:10:53 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH v3 virtio 1/8] virtio: allow caller to override device id and DMA mask
Date:   Wed, 22 Mar 2023 12:10:31 -0700
Message-ID: <20230322191038.44037-2-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230322191038.44037-1-shannon.nelson@amd.com>
References: <20230322191038.44037-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|DM6PR12MB4417:EE_
X-MS-Office365-Filtering-Correlation-Id: ebbf76f8-9577-4f71-c837-08db2b092954
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CEEgw1JG0bv0lmUHCOlEffg48VfNPBYna/QNB5WFvkPBJxnGH3SiCK8O7C1cgq0iaIWW8Qkw1Zfq/LbuU0MXxTvbifnXFDC0i0ZGI4dG637cvXcNkO/7S32P/yLS1KOlnAcRM9mitiXI9vuui483PtTto3Qr3RfSnVXdus9e6jaOpwHgSC8jFNZTwiEhOGd4Z/o7jWLU59PUOM+nxRw5oCmlZdf8FHuVuWZaSIf3wM/Lw4R8X//1UZKhiuKxoe81oSiwCAcHIcQHSfT8lcacVxN2OLXHna9FRlGQW4fyg1lRVaAjM/JS46UdDjXwvZoHT0lFupp8bBr41uSOQbQSp3SGogAua2sfYFt51T2SQr7F50G34gVzOFQLs+8xsROW63T8Kwkk+JzrKp513304Rhp21QPlclhoiuBZ9IP8349iizKOR9V8acOtcTIIGClmhwPDgLupIAIvDT3W9P3ez02+gg/iJAUoM0RIXcXDVg4Q29/0cgfrnjYTRB9vwmV1B99yrJvNAwGW4RoQ4unu7csIQrcG5xY5gwQWsrR76DmzVK2RpmKp0pzhSY2au+SGRPsG4nekmjR4QOsUw+eqZTOROSL8uk8DnT7/cHmsHIwkxm6a8/f+S1yGh1SLgDEt46NX4grjVuZcX7Pf/b9VLDOGWCFKogLqrIYY9EH+63s5xXqFpqgaFHHYpN7dPs5ORUTGBxHEVVFWf7s/ilH6HXG1cZhInqYzPGyRbEFLLUm2Dy+MlhVRpgvadNh6jL3/xsHVPApDdpxTwwKd/xJ4nA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199018)(40470700004)(46966006)(36840700001)(2616005)(16526019)(426003)(478600001)(47076005)(336012)(6666004)(83380400001)(70586007)(110136005)(316002)(70206006)(26005)(186003)(8676002)(4326008)(36860700001)(1076003)(8936002)(44832011)(5660300002)(41300700001)(82740400003)(40460700003)(2906002)(81166007)(36756003)(356005)(86362001)(40480700001)(82310400005)(21314003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 19:10:54.8679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebbf76f8-9577-4f71-c837-08db2b092954
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4417
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To allow a bit of flexibility with various virtio based devices, allow
the caller to specify a different device id and DMA mask.  This adds
fields to struct XXX to specify an override device id check and a DMA mask.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/virtio/virtio_pci_modern_dev.c | 36 +++++++++++++++++---------
 include/linux/virtio_pci_modern.h      |  6 +++++
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index 869cb46bef96..6ad1bb9ae8fa 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -221,18 +221,25 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
 
 	check_offsets();
 
-	/* We only own devices >= 0x1000 and <= 0x107f: leave the rest. */
-	if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
-		return -ENODEV;
-
-	if (pci_dev->device < 0x1040) {
-		/* Transitional devices: use the PCI subsystem device id as
-		 * virtio device id, same as legacy driver always did.
-		 */
-		mdev->id.device = pci_dev->subsystem_device;
+	if (mdev->device_id_check_override) {
+		err = mdev->device_id_check_override(pci_dev);
+		if (err)
+			return err;
+		mdev->id.device = pci_dev->device;
 	} else {
-		/* Modern devices: simply use PCI device id, but start from 0x1040. */
-		mdev->id.device = pci_dev->device - 0x1040;
+		/* We only own devices >= 0x1000 and <= 0x107f: leave the rest. */
+		if (pci_dev->device < 0x1000 || pci_dev->device > 0x107f)
+			return -ENODEV;
+
+		if (pci_dev->device < 0x1040) {
+			/* Transitional devices: use the PCI subsystem device id as
+			 * virtio device id, same as legacy driver always did.
+			 */
+			mdev->id.device = pci_dev->subsystem_device;
+		} else {
+			/* Modern devices: simply use PCI device id, but start from 0x1040. */
+			mdev->id.device = pci_dev->device - 0x1040;
+		}
 	}
 	mdev->id.vendor = pci_dev->subsystem_vendor;
 
@@ -260,7 +267,12 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
 		return -EINVAL;
 	}
 
-	err = dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(64));
+	if (mdev->dma_mask_override)
+		err = dma_set_mask_and_coherent(&pci_dev->dev,
+						mdev->dma_mask_override);
+	else
+		err = dma_set_mask_and_coherent(&pci_dev->dev,
+						DMA_BIT_MASK(64));
 	if (err)
 		err = dma_set_mask_and_coherent(&pci_dev->dev,
 						DMA_BIT_MASK(32));
diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
index c4eeb79b0139..84765bbd8dc5 100644
--- a/include/linux/virtio_pci_modern.h
+++ b/include/linux/virtio_pci_modern.h
@@ -38,6 +38,12 @@ struct virtio_pci_modern_device {
 	int modern_bars;
 
 	struct virtio_device_id id;
+
+	/* alt. check for vendor virtio device, return 0 or -ERRNO */
+	int (*device_id_check_override)(struct pci_dev *pdev);
+
+	/* alt. mask for devices with limited DMA space */
+	u64 dma_mask_override;
 };
 
 /*
-- 
2.17.1

