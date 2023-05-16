Return-Path: <netdev+bounces-2838-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A690C7043C2
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 04:58:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9920C1C20D1D
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 02:58:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA06848B;
	Tue, 16 May 2023 02:55:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B25B846D
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:55:59 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84231E58
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:55:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTBe64Fe0r1z8mSVF/YZynAlZUJXXsf2hJMoX2jm/4BPzadhyMZkbizrK6wzKM6+JUhXX9D/Zz3o+8Y2ILB9K23mbO6FJ8/B2OSHeo8uLA3eGx93gFrMeb9m8hOKweefE/9uW7vp2aRHDnCKjpuFpYfaPBCukFMw1ehjvRQdRPRtg7DKpk00M71yEBj30FsPRtS2QEPVOCPMA4OIi/u9Y5JN+6PWH/5s+nFXI10a1p4Ej7LRKpD6//oRDO7/OF1rV7nKc+el6Bx343bmShpyDeyvl4ItoV0jF8nzY+IK5gnt1Juev2tbc2eG1zvvKc2ISmPsh6mn+fGtMa4GupnWsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zsVHtYdpRY56ZAHq2N4ViJencrC0UF5RGRXE90WK/6o=;
 b=jMpgkyuu534mxf9MH4s36lMKHrjC9hsPnt09jmU3stiGSSYudG7Dy8ndrCDIeNPmaxpq0a6StguU18RuueVV4oarA5T3zGmf3aK43hpIhF9RM4P/qTL74tJ72BGbLCoZYQaXx1iTZzos4Xn4aOaCqE8+liuFBG1Xxxd9Zzf/OefjzQmMDWl/6HlVvf228nWKFpk32f9kHHwYPY+Xbf7PwnREroufXdYlbaoer8ZhEJcmgyXL1AjLbKrVMRV0O8te+VtWSpiAOKMCz4gB/48Rg3HqLZM5qESUumUO+kacCumSFUbYUW5XbksMB6HaoJIP75cozLQTkjBJyJI3kGcXSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsVHtYdpRY56ZAHq2N4ViJencrC0UF5RGRXE90WK/6o=;
 b=X6iD7HpdIPYgpyCZiEtOybxN5az9K09lK+k/zKG5A2yD/jUEb2IT9/tidaLmw59vsQRDsMAH9sJ3vXJLCk1VjUEy4jqxio776R03/NL7r5nHh6vTa5bXfz68WdRIzjSTg71BgLoZsqNsAcPL5Eejw2eM0YNNqnxb44rzC4a3C+4=
Received: from SJ0PR03CA0015.namprd03.prod.outlook.com (2603:10b6:a03:33a::20)
 by CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.32; Tue, 16 May
 2023 02:55:52 +0000
Received: from DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:33a:cafe::69) by SJ0PR03CA0015.outlook.office365.com
 (2603:10b6:a03:33a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30 via Frontend
 Transport; Tue, 16 May 2023 02:55:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT096.mail.protection.outlook.com (10.13.173.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.15 via Frontend Transport; Tue, 16 May 2023 02:55:51 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 15 May
 2023 21:55:50 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v6 virtio 09/11] pds_vdpa: add support for vdpa and vdpamgmt interfaces
Date: Mon, 15 May 2023 19:55:19 -0700
Message-ID: <20230516025521.43352-10-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT096:EE_|CY5PR12MB6179:EE_
X-MS-Office365-Filtering-Correlation-Id: 33a2a449-78a7-4cb0-b70e-08db55b90f3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Gm8cBnMZp2vNpgFRaA1ysvG88lAvmUJ1eGJ9aRtRJMjoEuXjQ4KB5EdKfhsqQkAYQrjtRMoSmFvmm/g/IV2ztAKVQ25N130brIKyw7b/pVzWH3kqFg1aojbrYfzMtLb97/Ms5zvGf79jMmnEOWuDEx/kAaGxC32biHnXnNt8tsskbqsL0pSRdiF4FY0pAVuBpQOoMhbddRdorcXMcYJH3x2GYiMh7tPeto2lhRkzvB/gFp7oxQiZpEvZRw5D85zr0Nta5r7BEAOXx2O5/cCxyYh9shMQ4asgLeaTl1KUppIdrxn5462ISQg2u7fWTS1SGLB8UcNL1PSTG5HDCLIhl4j9Q0hM4vRVfx2ApAqSkJzjf/zawd0jgerzD8rhlaomR90KJEmRL0OHwGdYSHfdKQIl3hz0rjK5N20GNArpRqCvJjcgrj8buGvzPy/ZQgZpvMPi+QYpi+e6Z461SKVMRDzGXgXmlwWgB+VPxpI7Sy7wonBQeC9TgskNJWNPX/D75CBtaRVDulryZ/yTwKbr3sXKLZS6Or1Hd33Nwt16vtC92twgTIyDfyLMX0Y3MhHq2dlfP2kZXjuB73MUu1CVKQeK62yt055aSyX9MCa7ZgV7BaGsa3J+f2TIv+tV6BHhCTPoTC3YTnVJSkpno5vaDH9yh4QZoX59d+6lVWSdZVRxkQf13mQDDncd4XwiMXoO8ho4+N5ucoeOiOEgXydLoeBTAmNt6We0/kMnyOlHIfscWiLrk/nQXxHdOdiUrCzf37fVmICeb7AFp00Fw3JcEg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199021)(40470700004)(46966006)(36840700001)(6666004)(478600001)(83380400001)(2616005)(47076005)(36860700001)(336012)(426003)(1076003)(40480700001)(26005)(16526019)(36756003)(356005)(81166007)(82310400005)(186003)(86362001)(82740400003)(40460700003)(70206006)(70586007)(4326008)(316002)(5660300002)(2906002)(30864003)(8676002)(8936002)(41300700001)(54906003)(110136005)(44832011)(66899021)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 02:55:51.5042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a2a449-78a7-4cb0-b70e-08db55b90f3e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6179
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is the vDPA device support, where we advertise that we can
support the virtio queues and deal with the configuration work
through the pds_core's adminq.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/pds/aux_drv.c  |  15 +
 drivers/vdpa/pds/aux_drv.h  |   1 +
 drivers/vdpa/pds/debugfs.c  | 263 ++++++++++++++++
 drivers/vdpa/pds/debugfs.h  |   5 +
 drivers/vdpa/pds/vdpa_dev.c | 605 +++++++++++++++++++++++++++++++++++-
 drivers/vdpa/pds/vdpa_dev.h |   4 +-
 6 files changed, 891 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
index 0c4a135b1484..186e9ee22eb1 100644
--- a/drivers/vdpa/pds/aux_drv.c
+++ b/drivers/vdpa/pds/aux_drv.c
@@ -63,8 +63,21 @@ static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
 		goto err_free_mgmt_info;
 	}
 
+	/* Let vdpa know that we can provide devices */
+	err = vdpa_mgmtdev_register(&vdpa_aux->vdpa_mdev);
+	if (err) {
+		dev_err(dev, "%s: Failed to initialize vdpa_mgmt interface: %pe\n",
+			__func__, ERR_PTR(err));
+		goto err_free_virtio;
+	}
+
+	pds_vdpa_debugfs_add_pcidev(vdpa_aux);
+	pds_vdpa_debugfs_add_ident(vdpa_aux);
+
 	return 0;
 
+err_free_virtio:
+	vp_modern_remove(&vdpa_aux->vd_mdev);
 err_free_mgmt_info:
 	pci_free_irq_vectors(padev->vf_pdev);
 err_free_mem:
@@ -79,9 +92,11 @@ static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
 	struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
 	struct device *dev = &aux_dev->dev;
 
+	vdpa_mgmtdev_unregister(&vdpa_aux->vdpa_mdev);
 	vp_modern_remove(&vdpa_aux->vd_mdev);
 	pci_free_irq_vectors(vdpa_aux->padev->vf_pdev);
 
+	pds_vdpa_debugfs_del_vdpadev(vdpa_aux);
 	kfree(vdpa_aux);
 	auxiliary_set_drvdata(aux_dev, NULL);
 
diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
index 99e0ff340bfa..26b75344156e 100644
--- a/drivers/vdpa/pds/aux_drv.h
+++ b/drivers/vdpa/pds/aux_drv.h
@@ -13,6 +13,7 @@ struct pds_vdpa_aux {
 	struct pds_auxiliary_dev *padev;
 
 	struct vdpa_mgmt_dev vdpa_mdev;
+	struct pds_vdpa_device *pdsv;
 
 	struct pds_vdpa_ident ident;
 
diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
index d91dceb07380..21a0dc0cb607 100644
--- a/drivers/vdpa/pds/debugfs.c
+++ b/drivers/vdpa/pds/debugfs.c
@@ -10,6 +10,7 @@
 #include <linux/pds/pds_auxbus.h>
 
 #include "aux_drv.h"
+#include "vdpa_dev.h"
 #include "debugfs.h"
 
 static struct dentry *dbfs_dir;
@@ -24,3 +25,265 @@ void pds_vdpa_debugfs_destroy(void)
 	debugfs_remove_recursive(dbfs_dir);
 	dbfs_dir = NULL;
 }
+
+#define PRINT_SBIT_NAME(__seq, __f, __name)                     \
+	do {                                                    \
+		if ((__f) & (__name))                               \
+			seq_printf(__seq, " %s", &#__name[16]); \
+	} while (0)
+
+static void print_status_bits(struct seq_file *seq, u8 status)
+{
+	seq_puts(seq, "status:");
+	PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_ACKNOWLEDGE);
+	PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_DRIVER);
+	PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_DRIVER_OK);
+	PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_FEATURES_OK);
+	PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_NEEDS_RESET);
+	PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_FAILED);
+	seq_puts(seq, "\n");
+}
+
+static void print_feature_bits_all(struct seq_file *seq, u64 features)
+{
+	int i;
+
+	seq_puts(seq, "features:");
+
+	for (i = 0; i < (sizeof(u64) * 8); i++) {
+		u64 mask = BIT_ULL(i);
+
+		switch (features & mask) {
+		case BIT_ULL(VIRTIO_NET_F_CSUM):
+			seq_puts(seq, " VIRTIO_NET_F_CSUM");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_GUEST_CSUM):
+			seq_puts(seq, " VIRTIO_NET_F_GUEST_CSUM");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_CTRL_GUEST_OFFLOADS):
+			seq_puts(seq, " VIRTIO_NET_F_CTRL_GUEST_OFFLOADS");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_MTU):
+			seq_puts(seq, " VIRTIO_NET_F_MTU");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_MAC):
+			seq_puts(seq, " VIRTIO_NET_F_MAC");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_GUEST_TSO4):
+			seq_puts(seq, " VIRTIO_NET_F_GUEST_TSO4");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_GUEST_TSO6):
+			seq_puts(seq, " VIRTIO_NET_F_GUEST_TSO6");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_GUEST_ECN):
+			seq_puts(seq, " VIRTIO_NET_F_GUEST_ECN");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_GUEST_UFO):
+			seq_puts(seq, " VIRTIO_NET_F_GUEST_UFO");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_HOST_TSO4):
+			seq_puts(seq, " VIRTIO_NET_F_HOST_TSO4");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_HOST_TSO6):
+			seq_puts(seq, " VIRTIO_NET_F_HOST_TSO6");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_HOST_ECN):
+			seq_puts(seq, " VIRTIO_NET_F_HOST_ECN");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_HOST_UFO):
+			seq_puts(seq, " VIRTIO_NET_F_HOST_UFO");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_MRG_RXBUF):
+			seq_puts(seq, " VIRTIO_NET_F_MRG_RXBUF");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_STATUS):
+			seq_puts(seq, " VIRTIO_NET_F_STATUS");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_CTRL_VQ):
+			seq_puts(seq, " VIRTIO_NET_F_CTRL_VQ");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_CTRL_RX):
+			seq_puts(seq, " VIRTIO_NET_F_CTRL_RX");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_CTRL_VLAN):
+			seq_puts(seq, " VIRTIO_NET_F_CTRL_VLAN");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_CTRL_RX_EXTRA):
+			seq_puts(seq, " VIRTIO_NET_F_CTRL_RX_EXTRA");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_GUEST_ANNOUNCE):
+			seq_puts(seq, " VIRTIO_NET_F_GUEST_ANNOUNCE");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_MQ):
+			seq_puts(seq, " VIRTIO_NET_F_MQ");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_CTRL_MAC_ADDR):
+			seq_puts(seq, " VIRTIO_NET_F_CTRL_MAC_ADDR");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_HASH_REPORT):
+			seq_puts(seq, " VIRTIO_NET_F_HASH_REPORT");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_RSS):
+			seq_puts(seq, " VIRTIO_NET_F_RSS");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_RSC_EXT):
+			seq_puts(seq, " VIRTIO_NET_F_RSC_EXT");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_STANDBY):
+			seq_puts(seq, " VIRTIO_NET_F_STANDBY");
+			break;
+		case BIT_ULL(VIRTIO_NET_F_SPEED_DUPLEX):
+			seq_puts(seq, " VIRTIO_NET_F_SPEED_DUPLEX");
+			break;
+		case BIT_ULL(VIRTIO_F_NOTIFY_ON_EMPTY):
+			seq_puts(seq, " VIRTIO_F_NOTIFY_ON_EMPTY");
+			break;
+		case BIT_ULL(VIRTIO_F_ANY_LAYOUT):
+			seq_puts(seq, " VIRTIO_F_ANY_LAYOUT");
+			break;
+		case BIT_ULL(VIRTIO_F_VERSION_1):
+			seq_puts(seq, " VIRTIO_F_VERSION_1");
+			break;
+		case BIT_ULL(VIRTIO_F_ACCESS_PLATFORM):
+			seq_puts(seq, " VIRTIO_F_ACCESS_PLATFORM");
+			break;
+		case BIT_ULL(VIRTIO_F_RING_PACKED):
+			seq_puts(seq, " VIRTIO_F_RING_PACKED");
+			break;
+		case BIT_ULL(VIRTIO_F_ORDER_PLATFORM):
+			seq_puts(seq, " VIRTIO_F_ORDER_PLATFORM");
+			break;
+		case BIT_ULL(VIRTIO_F_SR_IOV):
+			seq_puts(seq, " VIRTIO_F_SR_IOV");
+			break;
+		case 0:
+			break;
+		default:
+			seq_printf(seq, " bit_%d", i);
+			break;
+		}
+	}
+
+	seq_puts(seq, "\n");
+}
+
+void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_aux *vdpa_aux)
+{
+	vdpa_aux->dentry = debugfs_create_dir(pci_name(vdpa_aux->padev->vf_pdev), dbfs_dir);
+}
+
+static int identity_show(struct seq_file *seq, void *v)
+{
+	struct pds_vdpa_aux *vdpa_aux = seq->private;
+	struct vdpa_mgmt_dev *mgmt;
+
+	seq_printf(seq, "aux_dev:            %s\n",
+		   dev_name(&vdpa_aux->padev->aux_dev.dev));
+
+	mgmt = &vdpa_aux->vdpa_mdev;
+	seq_printf(seq, "max_vqs:            %d\n", mgmt->max_supported_vqs);
+	seq_printf(seq, "config_attr_mask:   %#llx\n", mgmt->config_attr_mask);
+	seq_printf(seq, "supported_features: %#llx\n", mgmt->supported_features);
+	print_feature_bits_all(seq, mgmt->supported_features);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(identity);
+
+void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux)
+{
+	debugfs_create_file("identity", 0400, vdpa_aux->dentry,
+			    vdpa_aux, &identity_fops);
+}
+
+static int config_show(struct seq_file *seq, void *v)
+{
+	struct pds_vdpa_device *pdsv = seq->private;
+	struct virtio_net_config vc;
+	u64 driver_features;
+	u8 status;
+
+	memcpy_fromio(&vc, pdsv->vdpa_aux->vd_mdev.device,
+		      sizeof(struct virtio_net_config));
+
+	seq_printf(seq, "mac:                  %pM\n", vc.mac);
+	seq_printf(seq, "max_virtqueue_pairs:  %d\n",
+		   __virtio16_to_cpu(true, vc.max_virtqueue_pairs));
+	seq_printf(seq, "mtu:                  %d\n", __virtio16_to_cpu(true, vc.mtu));
+	seq_printf(seq, "speed:                %d\n", le32_to_cpu(vc.speed));
+	seq_printf(seq, "duplex:               %d\n", vc.duplex);
+	seq_printf(seq, "rss_max_key_size:     %d\n", vc.rss_max_key_size);
+	seq_printf(seq, "rss_max_indirection_table_length: %d\n",
+		   le16_to_cpu(vc.rss_max_indirection_table_length));
+	seq_printf(seq, "supported_hash_types: %#x\n",
+		   le32_to_cpu(vc.supported_hash_types));
+	seq_printf(seq, "vn_status:            %#x\n",
+		   __virtio16_to_cpu(true, vc.status));
+
+	status = vp_modern_get_status(&pdsv->vdpa_aux->vd_mdev);
+	seq_printf(seq, "dev_status:           %#x\n", status);
+	print_status_bits(seq, status);
+
+	seq_printf(seq, "req_features:         %#llx\n", pdsv->req_features);
+	print_feature_bits_all(seq, pdsv->req_features);
+	driver_features = vp_modern_get_driver_features(&pdsv->vdpa_aux->vd_mdev);
+	seq_printf(seq, "driver_features:      %#llx\n", driver_features);
+	print_feature_bits_all(seq, driver_features);
+	seq_printf(seq, "vdpa_index:           %d\n", pdsv->vdpa_index);
+	seq_printf(seq, "num_vqs:              %d\n", pdsv->num_vqs);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(config);
+
+static int vq_show(struct seq_file *seq, void *v)
+{
+	struct pds_vdpa_vq_info *vq = seq->private;
+
+	seq_printf(seq, "ready:      %d\n", vq->ready);
+	seq_printf(seq, "desc_addr:  %#llx\n", vq->desc_addr);
+	seq_printf(seq, "avail_addr: %#llx\n", vq->avail_addr);
+	seq_printf(seq, "used_addr:  %#llx\n", vq->used_addr);
+	seq_printf(seq, "q_len:      %d\n", vq->q_len);
+	seq_printf(seq, "qid:        %d\n", vq->qid);
+
+	seq_printf(seq, "doorbell:   %#llx\n", vq->doorbell);
+	seq_printf(seq, "avail_idx:  %d\n", vq->avail_idx);
+	seq_printf(seq, "used_idx:   %d\n", vq->used_idx);
+	seq_printf(seq, "irq:        %d\n", vq->irq);
+	seq_printf(seq, "irq-name:   %s\n", vq->irq_name);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(vq);
+
+void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_aux *vdpa_aux)
+{
+	int i;
+
+	debugfs_create_file("config", 0400, vdpa_aux->dentry, vdpa_aux->pdsv, &config_fops);
+
+	for (i = 0; i < vdpa_aux->pdsv->num_vqs; i++) {
+		char name[8];
+
+		snprintf(name, sizeof(name), "vq%02d", i);
+		debugfs_create_file(name, 0400, vdpa_aux->dentry,
+				    &vdpa_aux->pdsv->vqs[i], &vq_fops);
+	}
+}
+
+void pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_aux *vdpa_aux)
+{
+	debugfs_remove_recursive(vdpa_aux->dentry);
+	vdpa_aux->dentry = NULL;
+}
+
+void pds_vdpa_debugfs_reset_vdpadev(struct pds_vdpa_aux *vdpa_aux)
+{
+	/* we don't keep track of the entries, so remove it all
+	 * then rebuild the basics
+	 */
+	pds_vdpa_debugfs_del_vdpadev(vdpa_aux);
+	pds_vdpa_debugfs_add_pcidev(vdpa_aux);
+	pds_vdpa_debugfs_add_ident(vdpa_aux);
+}
diff --git a/drivers/vdpa/pds/debugfs.h b/drivers/vdpa/pds/debugfs.h
index 658849591a99..c088a4e8f1e9 100644
--- a/drivers/vdpa/pds/debugfs.h
+++ b/drivers/vdpa/pds/debugfs.h
@@ -8,5 +8,10 @@
 
 void pds_vdpa_debugfs_create(void);
 void pds_vdpa_debugfs_destroy(void);
+void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_aux *vdpa_aux);
+void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux);
+void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_aux *vdpa_aux);
+void pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_aux *vdpa_aux);
+void pds_vdpa_debugfs_reset_vdpadev(struct pds_vdpa_aux *vdpa_aux);
 
 #endif /* _PDS_VDPA_DEBUGFS_H_ */
diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
index 0f0f0ab8b811..07b98dff5701 100644
--- a/drivers/vdpa/pds/vdpa_dev.c
+++ b/drivers/vdpa/pds/vdpa_dev.c
@@ -4,6 +4,7 @@
 #include <linux/pci.h>
 #include <linux/vdpa.h>
 #include <uapi/linux/vdpa.h>
+#include <linux/virtio_pci_modern.h>
 
 #include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
@@ -12,7 +13,464 @@
 
 #include "vdpa_dev.h"
 #include "aux_drv.h"
+#include "cmds.h"
+#include "debugfs.h"
 
+static u64 pds_vdpa_get_driver_features(struct vdpa_device *vdpa_dev);
+
+static struct pds_vdpa_device *vdpa_to_pdsv(struct vdpa_device *vdpa_dev)
+{
+	return container_of(vdpa_dev, struct pds_vdpa_device, vdpa_dev);
+}
+
+static int pds_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
+				   u64 desc_addr, u64 driver_addr, u64 device_addr)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+
+	pdsv->vqs[qid].desc_addr = desc_addr;
+	pdsv->vqs[qid].avail_addr = driver_addr;
+	pdsv->vqs[qid].used_addr = device_addr;
+
+	return 0;
+}
+
+static void pds_vdpa_set_vq_num(struct vdpa_device *vdpa_dev, u16 qid, u32 num)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+
+	pdsv->vqs[qid].q_len = num;
+}
+
+static void pds_vdpa_kick_vq(struct vdpa_device *vdpa_dev, u16 qid)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+
+	iowrite16(qid, pdsv->vqs[qid].notify);
+}
+
+static void pds_vdpa_set_vq_cb(struct vdpa_device *vdpa_dev, u16 qid,
+			       struct vdpa_callback *cb)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+
+	pdsv->vqs[qid].event_cb = *cb;
+}
+
+static irqreturn_t pds_vdpa_isr(int irq, void *data)
+{
+	struct pds_vdpa_vq_info *vq;
+
+	vq = data;
+	if (vq->event_cb.callback)
+		vq->event_cb.callback(vq->event_cb.private);
+
+	return IRQ_HANDLED;
+}
+
+static void pds_vdpa_release_irq(struct pds_vdpa_device *pdsv, int qid)
+{
+	if (pdsv->vqs[qid].irq == VIRTIO_MSI_NO_VECTOR)
+		return;
+
+	free_irq(pdsv->vqs[qid].irq, &pdsv->vqs[qid]);
+	pdsv->vqs[qid].irq = VIRTIO_MSI_NO_VECTOR;
+}
+
+static void pds_vdpa_set_vq_ready(struct vdpa_device *vdpa_dev, u16 qid, bool ready)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+	struct pci_dev *pdev = pdsv->vdpa_aux->padev->vf_pdev;
+	struct device *dev = &pdsv->vdpa_dev.dev;
+	u64 driver_features;
+	u16 invert_idx = 0;
+	int irq;
+	int err;
+
+	dev_dbg(dev, "%s: qid %d ready %d => %d\n",
+		__func__, qid, pdsv->vqs[qid].ready, ready);
+	if (ready == pdsv->vqs[qid].ready)
+		return;
+
+	driver_features = pds_vdpa_get_driver_features(vdpa_dev);
+	if (driver_features & BIT_ULL(VIRTIO_F_RING_PACKED))
+		invert_idx = PDS_VDPA_PACKED_INVERT_IDX;
+
+	if (ready) {
+		irq = pci_irq_vector(pdev, qid);
+		snprintf(pdsv->vqs[qid].irq_name, sizeof(pdsv->vqs[qid].irq_name),
+			 "vdpa-%s-%d", dev_name(dev), qid);
+
+		err = request_irq(irq, pds_vdpa_isr, 0,
+				  pdsv->vqs[qid].irq_name, &pdsv->vqs[qid]);
+		if (err) {
+			dev_err(dev, "%s: no irq for qid %d: %pe\n",
+				__func__, qid, ERR_PTR(err));
+			return;
+		}
+		pdsv->vqs[qid].irq = irq;
+
+		/* Pass vq setup info to DSC using adminq to gather up and
+		 * send all info at once so FW can do its full set up in
+		 * one easy operation
+		 */
+		err = pds_vdpa_cmd_init_vq(pdsv, qid, invert_idx, &pdsv->vqs[qid]);
+		if (err) {
+			dev_err(dev, "Failed to init vq %d: %pe\n",
+				qid, ERR_PTR(err));
+			pds_vdpa_release_irq(pdsv, qid);
+			ready = false;
+		}
+	} else {
+		err = pds_vdpa_cmd_reset_vq(pdsv, qid, invert_idx, &pdsv->vqs[qid]);
+		if (err)
+			dev_err(dev, "%s: reset_vq failed qid %d: %pe\n",
+				__func__, qid, ERR_PTR(err));
+		pds_vdpa_release_irq(pdsv, qid);
+	}
+
+	pdsv->vqs[qid].ready = ready;
+}
+
+static bool pds_vdpa_get_vq_ready(struct vdpa_device *vdpa_dev, u16 qid)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+
+	return pdsv->vqs[qid].ready;
+}
+
+static int pds_vdpa_set_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
+				 const struct vdpa_vq_state *state)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	u64 driver_features;
+	u16 avail;
+	u16 used;
+
+	if (pdsv->vqs[qid].ready) {
+		dev_err(dev, "Setting device position is denied while vq is enabled\n");
+		return -EINVAL;
+	}
+
+	driver_features = pds_vdpa_get_driver_features(vdpa_dev);
+	if (driver_features & BIT_ULL(VIRTIO_F_RING_PACKED)) {
+		avail = state->packed.last_avail_idx |
+			(state->packed.last_avail_counter << 15);
+		used = state->packed.last_used_idx |
+		       (state->packed.last_used_counter << 15);
+
+		/* The avail and used index are stored with the packed wrap
+		 * counter bit inverted.  This way, in case set_vq_state is
+		 * not called, the initial value can be set to zero prior to
+		 * feature negotiation, and it is good for both packed and
+		 * split vq.
+		 */
+		avail ^= PDS_VDPA_PACKED_INVERT_IDX;
+		used ^= PDS_VDPA_PACKED_INVERT_IDX;
+	} else {
+		avail = state->split.avail_index;
+		/* state->split does not provide a used_index:
+		 * the vq will be set to "empty" here, and the vq will read
+		 * the current used index the next time the vq is kicked.
+		 */
+		used = avail;
+	}
+
+	if (used != avail) {
+		dev_dbg(dev, "Setting used equal to avail, for interoperability\n");
+		used = avail;
+	}
+
+	pdsv->vqs[qid].avail_idx = avail;
+	pdsv->vqs[qid].used_idx = used;
+
+	return 0;
+}
+
+static int pds_vdpa_get_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
+				 struct vdpa_vq_state *state)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	u64 driver_features;
+	u16 avail;
+	u16 used;
+
+	if (pdsv->vqs[qid].ready) {
+		dev_err(dev, "Getting device position is denied while vq is enabled\n");
+		return -EINVAL;
+	}
+
+	avail = pdsv->vqs[qid].avail_idx;
+	used = pdsv->vqs[qid].used_idx;
+
+	driver_features = pds_vdpa_get_driver_features(vdpa_dev);
+	if (driver_features & BIT_ULL(VIRTIO_F_RING_PACKED)) {
+		avail ^= PDS_VDPA_PACKED_INVERT_IDX;
+		used ^= PDS_VDPA_PACKED_INVERT_IDX;
+
+		state->packed.last_avail_idx = avail & 0x7fff;
+		state->packed.last_avail_counter = avail >> 15;
+		state->packed.last_used_idx = used & 0x7fff;
+		state->packed.last_used_counter = used >> 15;
+	} else {
+		state->split.avail_index = avail;
+		/* state->split does not provide a used_index. */
+	}
+
+	return 0;
+}
+
+static struct vdpa_notification_area
+pds_vdpa_get_vq_notification(struct vdpa_device *vdpa_dev, u16 qid)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+	struct virtio_pci_modern_device *vd_mdev;
+	struct vdpa_notification_area area;
+
+	area.addr = pdsv->vqs[qid].notify_pa;
+
+	vd_mdev = &pdsv->vdpa_aux->vd_mdev;
+	if (!vd_mdev->notify_offset_multiplier)
+		area.size = PDS_PAGE_SIZE;
+	else
+		area.size = vd_mdev->notify_offset_multiplier;
+
+	return area;
+}
+
+static int pds_vdpa_get_vq_irq(struct vdpa_device *vdpa_dev, u16 qid)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+
+	return pdsv->vqs[qid].irq;
+}
+
+static u32 pds_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
+{
+	return PDS_PAGE_SIZE;
+}
+
+static u32 pds_vdpa_get_vq_group(struct vdpa_device *vdpa_dev, u16 idx)
+{
+	return 0;
+}
+
+static u64 pds_vdpa_get_device_features(struct vdpa_device *vdpa_dev)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+
+	return pdsv->supported_features;
+}
+
+static int pds_vdpa_set_driver_features(struct vdpa_device *vdpa_dev, u64 features)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+	struct device *dev = &pdsv->vdpa_dev.dev;
+	u64 driver_features;
+	u64 nego_features;
+	u64 missing;
+
+	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)) && features) {
+		dev_err(dev, "VIRTIO_F_ACCESS_PLATFORM is not negotiated\n");
+		return -EOPNOTSUPP;
+	}
+
+	pdsv->req_features = features;
+
+	/* Check for valid feature bits */
+	nego_features = features & le64_to_cpu(pdsv->vdpa_aux->ident.hw_features);
+	missing = pdsv->req_features & ~nego_features;
+	if (missing) {
+		dev_err(dev, "Can't support all requested features in %#llx, missing %#llx features\n",
+			pdsv->req_features, missing);
+		return -EOPNOTSUPP;
+	}
+
+	driver_features = pds_vdpa_get_driver_features(vdpa_dev);
+	dev_dbg(dev, "%s: %#llx => %#llx\n",
+		__func__, driver_features, nego_features);
+
+	if (driver_features == nego_features)
+		return 0;
+
+	vp_modern_set_features(&pdsv->vdpa_aux->vd_mdev, nego_features);
+
+	return 0;
+}
+
+static u64 pds_vdpa_get_driver_features(struct vdpa_device *vdpa_dev)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+
+	return vp_modern_get_driver_features(&pdsv->vdpa_aux->vd_mdev);
+}
+
+static void pds_vdpa_set_config_cb(struct vdpa_device *vdpa_dev,
+				   struct vdpa_callback *cb)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+
+	pdsv->config_cb.callback = cb->callback;
+	pdsv->config_cb.private = cb->private;
+}
+
+static u16 pds_vdpa_get_vq_num_max(struct vdpa_device *vdpa_dev)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+
+	/* qemu has assert() that vq_num_max <= VIRTQUEUE_MAX_SIZE (1024) */
+	return min_t(u16, 1024, BIT(le16_to_cpu(pdsv->vdpa_aux->ident.max_qlen)));
+}
+
+static u32 pds_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
+{
+	return VIRTIO_ID_NET;
+}
+
+static u32 pds_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
+{
+	return PCI_VENDOR_ID_PENSANDO;
+}
+
+static u8 pds_vdpa_get_status(struct vdpa_device *vdpa_dev)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+
+	return vp_modern_get_status(&pdsv->vdpa_aux->vd_mdev);
+}
+
+static void pds_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+	struct device *dev = &pdsv->vdpa_dev.dev;
+	u8 old_status;
+	int i;
+
+	old_status = pds_vdpa_get_status(vdpa_dev);
+	dev_dbg(dev, "%s: old %#x new %#x\n", __func__, old_status, status);
+
+	pds_vdpa_cmd_set_status(pdsv, status);
+
+	/* Note: still working with FW on the need for this reset cmd */
+	if (status == 0) {
+		pds_vdpa_cmd_reset(pdsv);
+
+		for (i = 0; i < pdsv->num_vqs; i++) {
+			pdsv->vqs[i].avail_idx = 0;
+			pdsv->vqs[i].used_idx = 0;
+		}
+	}
+
+	if (status & ~old_status & VIRTIO_CONFIG_S_FEATURES_OK) {
+		for (i = 0; i < pdsv->num_vqs; i++) {
+			pdsv->vqs[i].notify =
+				vp_modern_map_vq_notify(&pdsv->vdpa_aux->vd_mdev,
+							i, &pdsv->vqs[i].notify_pa);
+		}
+	}
+}
+
+static int pds_vdpa_reset(struct vdpa_device *vdpa_dev)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+	struct device *dev;
+	int err = 0;
+	u8 status;
+	int i;
+
+	dev = &pdsv->vdpa_aux->padev->aux_dev.dev;
+	status = pds_vdpa_get_status(vdpa_dev);
+
+	if (status == 0)
+		return 0;
+
+	if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
+		/* Reset the vqs */
+		for (i = 0; i < pdsv->num_vqs && !err; i++) {
+			err = pds_vdpa_cmd_reset_vq(pdsv, i, 0, &pdsv->vqs[i]);
+			if (err)
+				dev_err(dev, "%s: reset_vq failed qid %d: %pe\n",
+					__func__, i, ERR_PTR(err));
+			pds_vdpa_release_irq(pdsv, i);
+			memset(&pdsv->vqs[i], 0, sizeof(pdsv->vqs[0]));
+			pdsv->vqs[i].ready = false;
+		}
+	}
+
+	pds_vdpa_set_status(vdpa_dev, 0);
+
+	return 0;
+}
+
+static size_t pds_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
+{
+	return sizeof(struct virtio_net_config);
+}
+
+static void pds_vdpa_get_config(struct vdpa_device *vdpa_dev,
+				unsigned int offset,
+				void *buf, unsigned int len)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+	void __iomem *device;
+
+	if (offset + len > sizeof(struct virtio_net_config)) {
+		WARN(true, "%s: bad read, offset %d len %d\n", __func__, offset, len);
+		return;
+	}
+
+	device = pdsv->vdpa_aux->vd_mdev.device;
+	memcpy_fromio(buf, device + offset, len);
+}
+
+static void pds_vdpa_set_config(struct vdpa_device *vdpa_dev,
+				unsigned int offset, const void *buf,
+				unsigned int len)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+	void __iomem *device;
+
+	if (offset + len > sizeof(struct virtio_net_config)) {
+		WARN(true, "%s: bad read, offset %d len %d\n", __func__, offset, len);
+		return;
+	}
+
+	device = pdsv->vdpa_aux->vd_mdev.device;
+	memcpy_toio(device + offset, buf, len);
+}
+
+static const struct vdpa_config_ops pds_vdpa_ops = {
+	.set_vq_address		= pds_vdpa_set_vq_address,
+	.set_vq_num		= pds_vdpa_set_vq_num,
+	.kick_vq		= pds_vdpa_kick_vq,
+	.set_vq_cb		= pds_vdpa_set_vq_cb,
+	.set_vq_ready		= pds_vdpa_set_vq_ready,
+	.get_vq_ready		= pds_vdpa_get_vq_ready,
+	.set_vq_state		= pds_vdpa_set_vq_state,
+	.get_vq_state		= pds_vdpa_get_vq_state,
+	.get_vq_notification	= pds_vdpa_get_vq_notification,
+	.get_vq_irq		= pds_vdpa_get_vq_irq,
+	.get_vq_align		= pds_vdpa_get_vq_align,
+	.get_vq_group		= pds_vdpa_get_vq_group,
+
+	.get_device_features	= pds_vdpa_get_device_features,
+	.set_driver_features	= pds_vdpa_set_driver_features,
+	.get_driver_features	= pds_vdpa_get_driver_features,
+	.set_config_cb		= pds_vdpa_set_config_cb,
+	.get_vq_num_max		= pds_vdpa_get_vq_num_max,
+	.get_device_id		= pds_vdpa_get_device_id,
+	.get_vendor_id		= pds_vdpa_get_vendor_id,
+	.get_status		= pds_vdpa_get_status,
+	.set_status		= pds_vdpa_set_status,
+	.reset			= pds_vdpa_reset,
+	.get_config_size	= pds_vdpa_get_config_size,
+	.get_config		= pds_vdpa_get_config,
+	.set_config		= pds_vdpa_set_config,
+};
 static struct virtio_device_id pds_vdpa_id_table[] = {
 	{VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID},
 	{0},
@@ -21,12 +479,156 @@ static struct virtio_device_id pds_vdpa_id_table[] = {
 static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 			    const struct vdpa_dev_set_config *add_config)
 {
-	return -EOPNOTSUPP;
+	struct pds_vdpa_aux *vdpa_aux;
+	struct pds_vdpa_device *pdsv;
+	struct vdpa_mgmt_dev *mgmt;
+	u16 fw_max_vqs, vq_pairs;
+	struct device *dma_dev;
+	struct pci_dev *pdev;
+	struct device *dev;
+	u8 mac[ETH_ALEN];
+	int err;
+	int i;
+
+	vdpa_aux = container_of(mdev, struct pds_vdpa_aux, vdpa_mdev);
+	dev = &vdpa_aux->padev->aux_dev.dev;
+	mgmt = &vdpa_aux->vdpa_mdev;
+
+	if (vdpa_aux->pdsv) {
+		dev_warn(dev, "Multiple vDPA devices on a VF is not supported.\n");
+		return -EOPNOTSUPP;
+	}
+
+	pdsv = vdpa_alloc_device(struct pds_vdpa_device, vdpa_dev,
+				 dev, &pds_vdpa_ops, 1, 1, name, false);
+	if (IS_ERR(pdsv)) {
+		dev_err(dev, "Failed to allocate vDPA structure: %pe\n", pdsv);
+		return PTR_ERR(pdsv);
+	}
+
+	vdpa_aux->pdsv = pdsv;
+	pdsv->vdpa_aux = vdpa_aux;
+
+	pdev = vdpa_aux->padev->vf_pdev;
+	dma_dev = &pdev->dev;
+	pdsv->vdpa_dev.dma_dev = dma_dev;
+
+	pdsv->supported_features = mgmt->supported_features;
+
+	if (add_config->mask & BIT_ULL(VDPA_ATTR_DEV_FEATURES)) {
+		u64 unsupp_features =
+			add_config->device_features & ~mgmt->supported_features;
+
+		if (unsupp_features) {
+			dev_err(dev, "Unsupported features: %#llx\n", unsupp_features);
+			goto err_unmap;
+		}
+
+		pdsv->supported_features = add_config->device_features;
+	}
+
+	err = pds_vdpa_cmd_reset(pdsv);
+	if (err) {
+		dev_err(dev, "Failed to reset hw: %pe\n", ERR_PTR(err));
+		goto err_unmap;
+	}
+
+	err = pds_vdpa_init_hw(pdsv);
+	if (err) {
+		dev_err(dev, "Failed to init hw: %pe\n", ERR_PTR(err));
+		goto err_unmap;
+	}
+
+	fw_max_vqs = le16_to_cpu(pdsv->vdpa_aux->ident.max_vqs);
+	vq_pairs = fw_max_vqs / 2;
+
+	/* Make sure we have the queues being requested */
+	if (add_config->mask & (1 << VDPA_ATTR_DEV_NET_CFG_MAX_VQP))
+		vq_pairs = add_config->net.max_vq_pairs;
+
+	pdsv->num_vqs = 2 * vq_pairs;
+	if (pdsv->supported_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
+		pdsv->num_vqs++;
+
+	if (pdsv->num_vqs > fw_max_vqs) {
+		dev_err(dev, "%s: queue count requested %u greater than max %u\n",
+			__func__, pdsv->num_vqs, fw_max_vqs);
+		err = -ENOSPC;
+		goto err_unmap;
+	}
+
+	if (pdsv->num_vqs != fw_max_vqs) {
+		err = pds_vdpa_cmd_set_max_vq_pairs(pdsv, vq_pairs);
+		if (err) {
+			dev_err(dev, "Failed to set max_vq_pairs: %pe\n",
+				ERR_PTR(err));
+			goto err_unmap;
+		}
+	}
+
+	/* Set a mac, either from the user config if provided
+	 * or set a random mac if default is 00:..:00
+	 */
+	if (add_config->mask & BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
+		ether_addr_copy(mac, add_config->net.mac);
+		pds_vdpa_cmd_set_mac(pdsv, mac);
+	} else {
+		struct virtio_net_config __iomem *vc;
+
+		vc = pdsv->vdpa_aux->vd_mdev.device;
+		memcpy_fromio(mac, vc->mac, sizeof(mac));
+		if (is_zero_ether_addr(mac)) {
+			eth_random_addr(mac);
+			dev_info(dev, "setting random mac %pM\n", mac);
+			pds_vdpa_cmd_set_mac(pdsv, mac);
+		}
+	}
+
+	for (i = 0; i < pdsv->num_vqs; i++) {
+		pdsv->vqs[i].qid = i;
+		pdsv->vqs[i].pdsv = pdsv;
+		pdsv->vqs[i].irq = VIRTIO_MSI_NO_VECTOR;
+		pdsv->vqs[i].notify = vp_modern_map_vq_notify(&pdsv->vdpa_aux->vd_mdev,
+							      i, &pdsv->vqs[i].notify_pa);
+	}
+
+	pdsv->vdpa_dev.mdev = &vdpa_aux->vdpa_mdev;
+
+	/* We use the _vdpa_register_device() call rather than the
+	 * vdpa_register_device() to avoid a deadlock because our
+	 * dev_add() is called with the vdpa_dev_lock already set
+	 * by vdpa_nl_cmd_dev_add_set_doit()
+	 */
+	err = _vdpa_register_device(&pdsv->vdpa_dev, pdsv->num_vqs);
+	if (err) {
+		dev_err(dev, "Failed to register to vDPA bus: %pe\n", ERR_PTR(err));
+		goto err_unmap;
+	}
+
+	pds_vdpa_debugfs_add_vdpadev(vdpa_aux);
+
+	return 0;
+
+err_unmap:
+	put_device(&pdsv->vdpa_dev.dev);
+	vdpa_aux->pdsv = NULL;
+	return err;
 }
 
 static void pds_vdpa_dev_del(struct vdpa_mgmt_dev *mdev,
 			     struct vdpa_device *vdpa_dev)
 {
+	struct pds_vdpa_aux *vdpa_aux;
+
+	vdpa_aux = container_of(mdev, struct pds_vdpa_aux, vdpa_mdev);
+	_vdpa_unregister_device(vdpa_dev);
+
+	pds_vdpa_cmd_reset(vdpa_aux->pdsv);
+	pds_vdpa_debugfs_reset_vdpadev(vdpa_aux);
+
+	vdpa_aux->pdsv = NULL;
+
+	dev_info(&vdpa_aux->padev->aux_dev.dev, "Removed vdpa device\n");
 }
 
 static const struct vdpa_mgmtdev_ops pds_vdpa_mgmt_dev_ops = {
@@ -94,6 +696,7 @@ int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux)
 	mgmt->supported_features = le64_to_cpu(vdpa_aux->ident.hw_features);
 	mgmt->config_attr_mask = BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR);
 	mgmt->config_attr_mask |= BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MAX_VQP);
+	mgmt->config_attr_mask |= BIT_ULL(VDPA_ATTR_DEV_FEATURES);
 
 	err = pci_alloc_irq_vectors(pdev, vdpa_aux->nintrs, vdpa_aux->nintrs,
 				    PCI_IRQ_MSIX);
diff --git a/drivers/vdpa/pds/vdpa_dev.h b/drivers/vdpa/pds/vdpa_dev.h
index a21596f438c1..25c1d192f0ef 100644
--- a/drivers/vdpa/pds/vdpa_dev.h
+++ b/drivers/vdpa/pds/vdpa_dev.h
@@ -35,12 +35,14 @@ struct pds_vdpa_device {
 	struct pds_vdpa_aux *vdpa_aux;
 
 	struct pds_vdpa_vq_info vqs[PDS_VDPA_MAX_QUEUES];
+	u64 supported_features;		/* specified device features */
 	u64 req_features;		/* features requested by vdpa */
-	u64 actual_features;		/* features negotiated and in use */
 	u8 vdpa_index;			/* rsvd for future subdevice use */
 	u8 num_vqs;			/* num vqs in use */
 	struct vdpa_callback config_cb;
 };
 
+#define PDS_VDPA_PACKED_INVERT_IDX	0x8000
+
 int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux);
 #endif /* _VDPA_DEV_H_ */
-- 
2.17.1


