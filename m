Return-Path: <netdev+bounces-196-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A2056F5DAA
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 20:13:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78D4F1C20F9E
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D13A52772C;
	Wed,  3 May 2023 18:13:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5D627729
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 18:13:02 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312E4E57
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:13:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgzkGb7MCu/q7USsL/Wy9qRVpn9W+AofVBFgWaXBCD7bTFOsAKR6nJH6ag7ixYuvgMAYt/6/X4AnBXscH56qFoO1gwBdW24em/UPnZpjXyJ0iI9KTtUn5AaaRwjuTBbM1Oo90MhVRjTD2h383N14WT2nV7SlzPKmZgoN4L1FK9AyIiUI30p3jPepZPQG+vIuNu91knkvpzCfKsRzX8oRuKlSQEXMI2n43m0HgpAsknOOlIaB4FgPg6sIaUOpdkHtWdPihYf7X296kSJeu0SmUQwvPHipA8Aax77J5McGN4qER02BId7coWMaaUrK4V15g6oLJL4O68Gksjl9/JXjFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imWsguDCR2KuaQ9IxBgvR7Q5aiQ/IK+oKoakVFuejuU=;
 b=EXZ1prTYe3Zp+h4wdAuIryI1BItJ5qRwgKOPvJS5oDuYCqMmIvtQ3sZ/GE/kwAohIzI5i418RGUHmCsHEyFbFnDA3wTnNgSCwh9QTVozzqxwptwp5pakrmsGUcsQASee74Tw8/EU2JUuMxpH+to2gzj9X3b1sxE+wb0baw5YHIDbj5q7pOJq7gT+kfklBIt8UCiDi+Fes1mH7t39FudXqpvMK79Nf5tMPPr1u7i/LgWQWaAGXpuI0m1auSdxN2r9/yuYx+vFwWuoqeojz/p7p6AQhJIvQTbze0mYnEcaMqrIXndMqpVFm2b4Yl1hegkQob4W+7C58epFrEZ0eQ+DTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imWsguDCR2KuaQ9IxBgvR7Q5aiQ/IK+oKoakVFuejuU=;
 b=GhO6eHsufeXFyPh9inioIE8LvDa7WJ/6keLbvinfTeibeHMXsNGHfse3aW2tebuXm/fKtAfigITce7LGk8FAm5HlSuBTDlYfZxaXXCEHajSptPGkfwEvM4IPLb1Omg5YrPF6lOgwbh3jC7XUk9SS0L/PPliZdTmVnMJnb6XXrLA=
Received: from DM6PR03CA0054.namprd03.prod.outlook.com (2603:10b6:5:100::31)
 by MW4PR12MB7382.namprd12.prod.outlook.com (2603:10b6:303:22b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Wed, 3 May
 2023 18:12:58 +0000
Received: from DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::12) by DM6PR03CA0054.outlook.office365.com
 (2603:10b6:5:100::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22 via Frontend
 Transport; Wed, 3 May 2023 18:12:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT109.mail.protection.outlook.com (10.13.173.178) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.22 via Frontend Transport; Wed, 3 May 2023 18:12:58 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 3 May
 2023 13:12:57 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v5 virtio 01/11] virtio: allow caller to override device id in vp_modern
Date: Wed, 3 May 2023 11:12:30 -0700
Message-ID: <20230503181240.14009-2-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230503181240.14009-1-shannon.nelson@amd.com>
References: <20230503181240.14009-1-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT109:EE_|MW4PR12MB7382:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f3384ed-1ea1-4850-0e8a-08db4c020679
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	M7LsrSBvXvHjgdy6oBzzfp9JoFYc008NM6L2+IJU7VbdaFJDjc9OcO0NprFbF8kOtujNh5k1E91qYa4iaojRkPzEWFTzLLMkQ/0FNJ4raia1aDdn+lDs1H7ZXoef+kwAyhVkpG3IWlyNrj8vfhioGHACIklIwj/okv+PJcIPCONjVaSR85mnZvfhC6y8dlcwznp3gmzKmfxXPoEhAX3Ml4aqD59csX/+zMsDMa81pIvWJjIAgZkYJ+N4zIXfxO4sIPzd2yXuTfowgYAg2GzETTmABOmB3wrUZzVuHyOdFAyydQWzij+qJFleNNE5WaI0uoWbZjdrDWv18YW7svJrscV4uELXYFu6kXQV380s6bPgQ9XchJYRnkCR4WY0QIuzwvKlZOVAuWT2aDUTuk+rKNv2nmo6X0t72YZcDxnHAp7U70KQJf326669ZEJClh6wn1SnFWtVdnwABPdOU4v/y0i7oVVv27+MAC+ZD408bZCPqhMVPCHm19T0TPb8BMBdeRTt9GhjiFQIvIX7oCb0rP0FU36XgCPtsWl4QFv2ENvp2A3rUJF4V0r4MshSrktsmKzUdCVTovZnDRruqEJmMCegT+JaZiKl2JdZOjBsVEtYPYDJ6LOlPJfPSCf5talZdAAbzQprUSePcm6oJYR7z0Z3kDHMm2ZL5IU4PRNWWelXbGjfBkqxRRN8+bNkMiHUdldG044HM9WK+JkW5LrERQIQxgzeP6ZZeKNXspW1czY=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199021)(46966006)(36840700001)(40470700004)(478600001)(36860700001)(36756003)(316002)(5660300002)(2906002)(40460700003)(8936002)(86362001)(70206006)(40480700001)(4326008)(8676002)(82310400005)(81166007)(70586007)(336012)(356005)(44832011)(41300700001)(83380400001)(82740400003)(426003)(47076005)(54906003)(1076003)(2616005)(186003)(6666004)(110136005)(26005)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 18:12:58.4674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f3384ed-1ea1-4850-0e8a-08db4c020679
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7382
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

To add a bit of vendor flexibility with various virtio based devices,
allow the caller to check for a different device id.  This adds a function
pointer field to struct virtio_pci_modern_device to specify an override
device id check.  If defined by the driver, this function will be called
to check that the PCI device is the vendor's expected device, and will
return the found device id to be stored in mdev->id.device.  This allows
vendors with alternative vendor device ids to use this library on their
own device BAR.

Note: A lot of the diff in this is simply indenting the existing code
into an else block.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/virtio/virtio_pci_modern_dev.c | 30 ++++++++++++++++----------
 include/linux/virtio_pci_modern.h      |  3 +++
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index 869cb46bef96..9b2d6614de67 100644
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
 
diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
index c4eeb79b0139..e7b1db1dd0bb 100644
--- a/include/linux/virtio_pci_modern.h
+++ b/include/linux/virtio_pci_modern.h
@@ -38,6 +38,9 @@ struct virtio_pci_modern_device {
 	int modern_bars;
 
 	struct virtio_device_id id;
+
+	/* optional check for vendor virtio device, returns dev_id or -ERRNO */
+	int (*device_id_check)(struct pci_dev *pdev);
 };
 
 /*
-- 
2.17.1


