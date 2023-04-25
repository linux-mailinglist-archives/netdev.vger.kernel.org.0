Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E358A6EE993
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbjDYV0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236379AbjDYV0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:26:22 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA4817A23
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:26:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9jq93cmP/K4cV91hhJbHZEl9tcsTUrGw4p7GqgsA1Br4VrqdXQx1+yO+YgQbmABsDZSNsfyqQoq2hIPCuzb8CAbdcQhO8o7dHE3G7pNNA2D4MRb71AX4Hh7GXgHElgn+mUWlpL5+P6AmUEaxL7zfELZvTRCooVDrZDFLna4rHQ5M2quK4OO61vpJHXEGvZilv3PkoFJX8gH1vnNU3qMaOKffZNlLmK9d6JIoHQpqcrNPUgZBWpAPu9mIUb1Vm1eoGiHwVhONJq4iOnOp30oYpTL42hfCOCMbG7CNluFRDn+yb1CJ+d7fdVFAD0bKcB/GPkPbw8tryl2OSPwzRDQsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfGJq7prAa0eCCR/WyECcFzOEew8XjNIURXQcwLKpN8=;
 b=UNrvHI1Jb/WuGyhuwHIo/TqTVr5/rA9hIfyP2oMMM5gUEJaXPU6H8BsI/bcribfpmKgSKob/i7cCb4LhpH5TklonxLXqFmdfsupQiVlA2IASNjgjUNkockaSv8OPEj9vypgeVEKrIgfqtGI1iVxx18fAz7FaY8LmqdT2W99DZgW6APE2GGc+cCdyTX7a7USlsiUKrKZ8z8pO79EVwbnJtU7B9D5jK6H380SKWT8ALRen6d7FlNDZSTg7BTnBo3V4LwzaWrkg21auJwtaVok5NT0IVTfz8/YlQPO6NgcZ4+fy9tgUa3HIT5hVWfctNv2dkyxABYUMUWfx1QXxA4dsgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfGJq7prAa0eCCR/WyECcFzOEew8XjNIURXQcwLKpN8=;
 b=dMR7D2cJxrPNhC8HJuVYS2siZWGHrpxNMkWd6AOTq666MpqK6DW+Ejuo4KcLbycm24vmOxhtO/rE+uaCBdaR/QwAJO7/v5H4NyaGpeOKwWg69HIHl4lg4ypIGET9Ru5I37fJwAlA8XH+N3TWQUSogDbtL7animL4qOEFC4aE0lc=
Received: from DM6PR11CA0013.namprd11.prod.outlook.com (2603:10b6:5:190::26)
 by BY5PR12MB4855.namprd12.prod.outlook.com (2603:10b6:a03:1dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.29; Tue, 25 Apr
 2023 21:26:18 +0000
Received: from DM6NAM11FT115.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::5d) by DM6PR11CA0013.outlook.office365.com
 (2603:10b6:5:190::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.20 via Frontend
 Transport; Tue, 25 Apr 2023 21:26:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT115.mail.protection.outlook.com (10.13.173.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.21 via Frontend Transport; Tue, 25 Apr 2023 21:26:18 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 25 Apr
 2023 16:26:17 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <netdev@vger.kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH v4 virtio 01/10] virtio: allow caller to override device id and DMA mask
Date:   Tue, 25 Apr 2023 14:25:53 -0700
Message-ID: <20230425212602.1157-2-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230425212602.1157-1-shannon.nelson@amd.com>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT115:EE_|BY5PR12MB4855:EE_
X-MS-Office365-Filtering-Correlation-Id: b9aef1d5-3c54-46b1-5f5a-08db45d3b575
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FLJa+kvSTxrNQVoMcLvBtSpNrxGup8VCWUALNWiWLs0OiTO6I1idlzdaSwnTW21Si9fd4K0B1O9YywoUaSa9TJ2VkjVSMWQCJM4yIRg5ICmF6WYbKbpf3ADLPlGz4NzFOEZppkN/d2xEV35kW+Rv7HpnWNEuFKKxVfln0MgIMp9WPDWCB8U2IteMmoFR8P4/9QesSm1k3GBxRZOsyKJP3Y6tKxyECIZrXEiLlbNoXr5/zq9MBnoyNV/EZInk2kJdyjRMdKF6k0djW3yP2LVZ6D5NiILRRw7P0lnRIguznPL4BL4YeZkPDA5UfAiM2MIVENZzvGIIXupkW25kCfYlbOzIzHqpMR9Tdc+IQbv8phUAClXB9RxZcH04L5tgwlw4ZrgyvwVRqeZgGDVXT3aIUoHdp4/JzG/ikROxXhGbT3W11xphaFqGrxfAnAoLWakHPK3d8v8psFtxU2ZrXHLgYSyQ9U0lm5yX1m1S6vGGY+jBMgkihYow2eKc2RcEc3Stb+cCMV68wAVD6Ozmm26kuwyuGoI/O5JCP8bgE3UM3OHTQXvbxAcrO5HqWVD4V75BKxQ2/LKrH2rY28b+g2G2eOatMUjhmpM6dtKIsGTBn0UjSVTt0CTMHXTod05dNH9nAqngpDu9Zozr8NxmuoiOKoD8OXBYfNslmzLT8S+GTIlu4llCPFKtSF3SKx7q+hBHeN099/rKafXUBbNs4NknTDcefuWKkb40sSU6B+tbgxM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199021)(36840700001)(40470700004)(46966006)(110136005)(36756003)(4326008)(186003)(2906002)(44832011)(70586007)(70206006)(316002)(6666004)(16526019)(41300700001)(5660300002)(36860700001)(478600001)(40480700001)(81166007)(356005)(426003)(336012)(82740400003)(47076005)(8676002)(82310400005)(8936002)(86362001)(83380400001)(1076003)(26005)(2616005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 21:26:18.6903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9aef1d5-3c54-46b1-5f5a-08db45d3b575
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT115.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4855
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To add a bit of flexibility with various virtio based devices, allow
the caller to specify a different device id and DMA mask.  This adds
fields to struct virtio_pci_modern_device to specify an override device
id check and a DMA mask.

int (*device_id_check)(struct pci_dev *pdev);
	If defined by the driver, this function will be called to check
	that the PCI device is the vendor's expected device, and will
	return the found device id to be stored in mdev->id.device.
	This allows vendors with alternative vendor device ids to use
	this library on their own device BAR.

u64 dma_mask;
	If defined by the driver, this mask will be used in a call to
	dma_set_mask_and_coherent() instead of the traditional
	DMA_BIT_MASK(64).  This allows limiting the DMA space on
	vendor devices with address limitations.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/virtio/virtio_pci_modern_dev.c | 37 +++++++++++++++++---------
 include/linux/virtio_pci_modern.h      |  6 +++++
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index 869cb46bef96..1f2db76e8f91 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -218,21 +218,29 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
 	int err, common, isr, notify, device;
 	u32 notify_length;
 	u32 notify_offset;
+	int devid;
 
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
+	if (mdev->device_id_check) {
+		devid = mdev->device_id_check(pci_dev);
+		if (devid < 0)
+			return devid;
+		mdev->id.device = devid;
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
 
@@ -260,7 +268,12 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
 		return -EINVAL;
 	}
 
-	err = dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(64));
+	if (mdev->dma_mask)
+		err = dma_set_mask_and_coherent(&pci_dev->dev,
+						mdev->dma_mask);
+	else
+		err = dma_set_mask_and_coherent(&pci_dev->dev,
+						DMA_BIT_MASK(64));
 	if (err)
 		err = dma_set_mask_and_coherent(&pci_dev->dev,
 						DMA_BIT_MASK(32));
diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
index c4eeb79b0139..067ac1d789bc 100644
--- a/include/linux/virtio_pci_modern.h
+++ b/include/linux/virtio_pci_modern.h
@@ -38,6 +38,12 @@ struct virtio_pci_modern_device {
 	int modern_bars;
 
 	struct virtio_device_id id;
+
+	/* optional check for vendor virtio device, returns dev_id or -ERRNO */
+	int (*device_id_check)(struct pci_dev *pdev);
+
+	/* optional mask for devices with limited DMA space */
+	u64 dma_mask;
 };
 
 /*
-- 
2.17.1

