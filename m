Return-Path: <netdev+bounces-2830-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17C527043B5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 04:56:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17BC31C20D1C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 02:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D54621;
	Tue, 16 May 2023 02:55:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A01256C
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:55:50 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3844EE58
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:55:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U3ayax8wkWATmLtOb1whI04ZJjFlWe9pg9YMrdB8+e/y+VFdZsCYBihFqKTzbyJ4iBlj8bPQE1gwVAn9nhnxmiiwl3grQYHBhoLm300cgGiqsWS79CMaLuipVe2fHzeopTGsmAqSOQ6/cGy/Eow3nCi6roPAjC+cgYdJokcbXr0uzr6gJTgPbqrZp6t0MzabXUiEmnCrm8GFwO1u9+kbgDpvZS67fKIJn4+rHEW2WMdY65snroSlhukIW5+YOX6AJdiAYScRFkaB4S9pXJSgn0qV0A+ujmCHS+78Eds3Xedq7lZ7+LdkVk70blnryJd+W9wQAYvtmcFRM9SGEiIxaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7M0ZM7UHOdU4Esi2UwbRjhF2g4heOLasFC79+b2hs4=;
 b=k3yTsmgVPoPWo9qnXGOY/c+NS/qJad5jFpgcPVOg4MjnCd4JS1647whQBR1wMZoSA0ztqo/rtwJfOFHZvXQEbKpSb2nDUgE8FFSNU8vR005huA0bZMY6y1xa2RB+zRj8xeYP6+4IIkN3OTCtKJhTYP1oUKVhVujsBvjgnNGSulCT0qs2Mk9wPPb0/71CRrq5KSYEom2Dxc6Np0qnA4vugoBbxj4rt8dhDcUkFXUMCVEYDR+CQB37rmmF4NP0EaRq/QoznSa55TPahSS5KavIfJMQrWd9L6eRo1QMXh05rRPm6Tgyqnl1y+gtItpw/Ya0wGvJI3ieFa7Vy7uXZQnTnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7M0ZM7UHOdU4Esi2UwbRjhF2g4heOLasFC79+b2hs4=;
 b=tVKDMmoJCdSpl9+16GgNPyjMlz3y5ydfXW63fr/WoVQpabfT0Q1jjEKsfDdFMQuUsHJE+9AbegrMeKLLcuJSTHSqyXPqInh7kyRvVWtndfBeilswc7OTecIDL6RvpmrxviAImV83vhFIrauM4dEG1mQ99dtKs9hq+Qm74ljR2iQ=
Received: from SJ0PR03CA0015.namprd03.prod.outlook.com (2603:10b6:a03:33a::20)
 by IA1PR12MB6409.namprd12.prod.outlook.com (2603:10b6:208:38b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 02:55:46 +0000
Received: from DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:33a:cafe::d3) by SJ0PR03CA0015.outlook.office365.com
 (2603:10b6:a03:33a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30 via Frontend
 Transport; Tue, 16 May 2023 02:55:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT096.mail.protection.outlook.com (10.13.173.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.15 via Frontend Transport; Tue, 16 May 2023 02:55:45 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 15 May
 2023 21:55:43 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v6 virtio 02/11] virtio: allow caller to override device DMA mask in vp_modern
Date: Mon, 15 May 2023 19:55:12 -0700
Message-ID: <20230516025521.43352-3-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230516025521.43352-1-shannon.nelson@amd.com>
References: <20230516025521.43352-1-shannon.nelson@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT096:EE_|IA1PR12MB6409:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c462afa-738f-43b0-1541-08db55b90be2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UIoTKxs+uDMdlXSYFWeAHVQYXEbYeRLwg+z/eKDoJk38ZjOzcHmWFO5dewYCvZOldnLi/vjw0UAEwFn4N9vD5rVvtUfQBu01WMGnSmSIjjsnxv9ZLvuewecyfidV8oEyFZ52CRR/2InRLkLg35i0XIQc5RHdGqokKxpjA5nxvbOSNDRR3de0HvWRLjtzxLc7iUIQu6XEpvgV8j2i0w+koInJSKVyVj3uafEcU/mp9fgCLCdbKH3Q4Wl1Zr2OKWlZoHQhLJXT93dOiI2IijQTMWOwljqorKYt2v04HNnTRLwVmLKHBrgL8eB5SRXlrNcYIs1ZBJ4lUKOvUrgZ/806iqfN/z3Tkz5xTJ2qsdHvuIATLh7U2vXX0xnf8fgVFk0r6BnMBTX+dHMqvggM9cTDKSZo6vrkSwVxyS3zhooIIuLJUxMqRHY0GLGHFcskCLtiYWwhwG81tnZeduiHgutX8ROrJyNSNu1JdRyZstJuFeV5hfcbBE1K8bSurjdB+Wi3rZ6XA6U88mhjXexXHEIZR0Ij2fMvtFitQzifaB2A/f7pj+EHxPVj+rqBpK+3QFOh6WyRLPwl8c5UvD6vvFvuX1tfj1cxBrhePZ/8GBalFkiTHNSZbIFg6i+Mpw03zkKHHRbjHNV+tXirMij87v0YfSgK0sA/244XCItInL7vrYpGLwJEErdxi8QonnmTmCQT8NC0PhHnThrBkBSQTMxMEdeW9UoCO3OD2CQjo6EsWIDx0tdYpNyfi0R2B607oeNCAlKGgh5Rt/fm2liT19mbJg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199021)(40470700004)(36840700001)(46966006)(47076005)(36860700001)(186003)(16526019)(2616005)(41300700001)(6666004)(426003)(336012)(1076003)(83380400001)(26005)(478600001)(54906003)(110136005)(40460700003)(70586007)(4326008)(70206006)(82740400003)(40480700001)(81166007)(316002)(356005)(8676002)(5660300002)(36756003)(8936002)(44832011)(86362001)(82310400005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 02:55:45.8952
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c462afa-738f-43b0-1541-08db55b90be2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6409
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

To add a bit of vendor flexibility with various virtio based devices,
allow the caller to specify a different DMA mask.  This adds a dma_mask
field to struct virtio_pci_modern_device.  If defined by the driver,
this mask will be used in a call to dma_set_mask_and_coherent() instead
of the traditional DMA_BIT_MASK(64).  This allows limiting the DMA space
on vendor devices with address limitations.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_pci_modern_dev.c | 3 ++-
 include/linux/virtio_pci_modern.h      | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index 9b2d6614de67..aad7d9296e77 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -268,7 +268,8 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
 		return -EINVAL;
 	}
 
-	err = dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(64));
+	err = dma_set_mask_and_coherent(&pci_dev->dev,
+					mdev->dma_mask ? : DMA_BIT_MASK(64));
 	if (err)
 		err = dma_set_mask_and_coherent(&pci_dev->dev,
 						DMA_BIT_MASK(32));
diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
index e7b1db1dd0bb..067ac1d789bc 100644
--- a/include/linux/virtio_pci_modern.h
+++ b/include/linux/virtio_pci_modern.h
@@ -41,6 +41,9 @@ struct virtio_pci_modern_device {
 
 	/* optional check for vendor virtio device, returns dev_id or -ERRNO */
 	int (*device_id_check)(struct pci_dev *pdev);
+
+	/* optional mask for devices with limited DMA space */
+	u64 dma_mask;
 };
 
 /*
-- 
2.17.1


