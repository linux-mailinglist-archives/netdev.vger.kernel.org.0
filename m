Return-Path: <netdev+bounces-4018-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F5A070A23B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 23:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00BB0281BD2
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9000118012;
	Fri, 19 May 2023 21:56:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E2B18006
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 21:56:56 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20624.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::624])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D02B10F
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:56:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPO2AZq8r+W8jtzTkUfDfrKftk1bzrc85ePdGIKfDVMiVEMbDnmuEDMgo5SXbCjGBYDs08Ee6mEcDp/8TRMEz+sFr2fOsn7vuxhUo3u4k3AXYpr3Ni4XMkKqLJsDKjBF+VWeJ/lNfM/UKUOTRgxSeOPo5lqz6NS/gqyoxY9dsKDBexs0zEgboz5D+bM5ULiR7nwSPQI2m26IKH3nK+9W8JCsZvGfETiyOKeeg4kVX5QgKF2+TsVoMc9D12QxELPR9FclQBTC5/lf87rlPytVqPOtIY8FCYP6deHs0N/T+YKh9o3La/whYehIOLC4z9h+sZRvOGK3Aa7daZQSwtmbwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7M0ZM7UHOdU4Esi2UwbRjhF2g4heOLasFC79+b2hs4=;
 b=Yi7UvfM0Z++tIt12hQm9VVWbBFeVpbWv1Peho0lBv9qaK8WKBggL5e/1ccnmjtGZaiAex+Ruqg/BkJz7scXI5nKUP5hufhZcE4OZsdfz68WYDn31C2lIJAtAs+X7vECm2S18VC43XwAMCTRC6vz9UN0p8pKMGfgaxg6i7cRF+nynxBkE1LUcjxom18clziK8cQNhNtEkdyS5H/kIOvZsZcaU9eFTr1XZWHcyT5aL9nI9/YkZEvCCp7evg88muj5gH5sqTYMeUV1xhuaVUd5ZIn1LLpS8hrWGJf3UEUr6BReLHto7mAMKh5PkXPKzzLCrHlK92fpHiaqfQEp5oPvlbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7M0ZM7UHOdU4Esi2UwbRjhF2g4heOLasFC79+b2hs4=;
 b=ZXkaW4YSrQNhGbi6lPs2CIlWbWp/OGJ4/dbo5DNX10JLEAL9U/oFOWHCaxdZ2l7pen5h5rGdm+I9cfvZwiE0HpCSFSplujg2chAtNEfy0NoT/raYPco38Pa0TH0OA8zie249x+UaGJP3nI5yWt+e+B7dIeHOqgx832UuECMjhIs=
Received: from BN8PR07CA0022.namprd07.prod.outlook.com (2603:10b6:408:ac::35)
 by PH8PR12MB7025.namprd12.prod.outlook.com (2603:10b6:510:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 21:56:51 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::38) by BN8PR07CA0022.outlook.office365.com
 (2603:10b6:408:ac::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21 via Frontend
 Transport; Fri, 19 May 2023 21:56:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.21 via Frontend Transport; Fri, 19 May 2023 21:56:51 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 19 May
 2023 16:56:50 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v7 virtio 02/11] virtio: allow caller to override device DMA mask in vp_modern
Date: Fri, 19 May 2023 14:56:23 -0700
Message-ID: <20230519215632.12343-3-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230519215632.12343-1-shannon.nelson@amd.com>
References: <20230519215632.12343-1-shannon.nelson@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|PH8PR12MB7025:EE_
X-MS-Office365-Filtering-Correlation-Id: ee8d47da-da6b-497b-5059-08db58b3f3d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	u+kWeP2y8h4OAtGG+uLcsywgGCIABR8eQIAdHoO07ApY9qHRcA8h4wtjRfHtwUZdWeWVDwJBh0yOvYpbs1zU6q8lwOprfjwus3yM0v5ru3U/WEA5UZHz2aphzGWZ4OCEG677K6DlFeVy5xh2wTIhJId6SGdU73dQcd+oxJjINXBwlJ2nL2bhlnL79mK5Dj8GB32InadoflWId81WWosttk1K/Xy0/ZS8dAvvWM2w7/yTQI5nf6WmuGk3xiEXI7hVQnXhdM39QnCZjw1rrUVgrN8+jTKl9UlY3MBcylFJwq8GIDmCi32N6MaDTvGYQYdvXuNjJN4vs9mxix24BOhfvGg1FDcqTwtxcp518KrP753g+p7srZ0jyNu/Raf8khl3qDkypW1H+mHP8eJV+mrzI4SwMqBFiEcXnY+cQr4JvAp6hKIyp8u46wGuJxBsaW4Qz2N03YqHL2IP21kvZpaQ98NNrQvbkOPOlu8FFv9j0wi6iesFm0yqfmPH05dNkPvzr1S00k0Bpt3wHDDIFBmFmocCbvtNk3OZejQXJDgMo21ZgQk/33i8Jrp+lwwc+fmOL2J2e9Uw3dhSM2QGO2bf+8zMAgLpJzuEHSUs3vnVNw5bFWrh7jjOWPwcvecXwgUTDwWZmPi5aIJfwStZd0ywYBs/HsfAHbbuATV3g/4dSufp36YUndwdOIlBbRdhbJ9uE2SrNlJE3I9A/wyoActNa7Q27cmx3obgy2vA01gWbdBULEkT1JAgOvmkdoIZ/9Q1RCBR2oNU6BhdOop8QakHLw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199021)(36840700001)(40470700004)(46966006)(86362001)(36756003)(110136005)(316002)(54906003)(70586007)(478600001)(4326008)(70206006)(6666004)(82310400005)(8936002)(8676002)(5660300002)(41300700001)(2906002)(44832011)(40480700001)(81166007)(82740400003)(356005)(426003)(336012)(186003)(16526019)(26005)(1076003)(36860700001)(2616005)(47076005)(83380400001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 21:56:51.5559
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee8d47da-da6b-497b-5059-08db58b3f3d1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7025
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
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


