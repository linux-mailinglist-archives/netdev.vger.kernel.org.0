Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574D36B18C7
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 02:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCIBbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 20:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjCIBbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 20:31:38 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2049.outbound.protection.outlook.com [40.107.101.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BAF94A7B
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 17:31:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9H8axbFmyxEvwdIXOL3L3hpzWuYMRSJ7bvV/vDKEhVXiY+O35BBXaQFdhOnmy+X3PtKqHwE3VPQU8iJsGWPkAkW801K92obyGk6idnhK9rt8a0Rufcr6kuUPBN0PmCHe47sl8QxbiTyt9t80r2z7mwkVIvREkFEtbtAKez/yv6z+DNmAgkUvcQ37w8c6JiS12IUz6JTLUf0BwomYql3dKNeaYGfLe+xG8LcTTsxIlSKbo9L4tgStPz9F/gaKlELCAzcFoVbe0OwqjBkQYy6o+dmCi4GhIMvCjrKGVuW9Qw+pljCZ3dpUMfeqPUIfQnby1W2f071bElDoGRBNgHtGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZJLil3DfWJT/1W8l+CFNlOxTDPrTNS208idm/hnQ4g=;
 b=NbNDVq0IhLXyXtBrdvS7XWIPK7x425Y26XHhxUSiy9NDb4Q2soSIx2m/thUQLiB60GeWWtrxcHJ0yiiTHIdjVaV2qZuzYSfmEHGeSlh6Rv3c8hIC8X4DtMBDepkxKWgE64Exgu9Y6mETs4u3LtEDkLZLL2Xl9VTKaXTLWwTo3kUKzaMXhG33k+6Iytz4LYVRyED8Kgzy3HxujT21gDCHpc6T5HmCUVdES8vlvh53axsAsx+SAbIvdA01j5qnlZHZUNPfCquX+3UJz0pULJER/nXvEGJTpK/Od+Uns46ICSZNINm6Q2vpgnpvuqM0x/MtfIRWIKsT8l5oTJHGqJYFJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZJLil3DfWJT/1W8l+CFNlOxTDPrTNS208idm/hnQ4g=;
 b=UL9g6h8RXeUznMSZxx+MZ2w2qRnU1iQrai4+OYAjEe9ZCLk2Pv9oHQ59Ps0DvCGBIpnRrdR0TzrUVybNxxOj3VyBO4xxhYTg/8hoeYp8pwIO6Kb+GYZyFEnPpKU28lzUeOs5xCWF7SlONTK4ZgXAhI71W3pO+lY97uHM3z70kXg=
Received: from BN9PR03CA0335.namprd03.prod.outlook.com (2603:10b6:408:f6::10)
 by CH0PR12MB8531.namprd12.prod.outlook.com (2603:10b6:610:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Thu, 9 Mar
 2023 01:31:30 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::80) by BN9PR03CA0335.outlook.office365.com
 (2603:10b6:408:f6::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Thu, 9 Mar 2023 01:31:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Thu, 9 Mar 2023 01:31:30 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Mar
 2023 19:31:27 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH RFC v2 virtio 5/7] pds_vdpa: add support for vdpa and vdpamgmt interfaces
Date:   Wed, 8 Mar 2023 17:30:44 -0800
Message-ID: <20230309013046.23523-6-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230309013046.23523-1-shannon.nelson@amd.com>
References: <20230309013046.23523-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT047:EE_|CH0PR12MB8531:EE_
X-MS-Office365-Filtering-Correlation-Id: 62880e12-da09-4cd1-5f34-08db203e02a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U8WmKBqZj5iVv/zGa1Sftn4tq1gqUntXO+ZJUu5CbMqyIK+AHTVVs20TConhNFsldjNJFkHvvc3WEiL1Etz2kOcP0P8cOFwH6aEaCP+Wi9OoOLP6MZIpdR3wnQS3iAUJ2qnoMV6o0my7YKqDnFF4zGIOEMJUfUSxC8eiSIpD0M4ktPrZEZcrRHKWeggcZj2UP5QaRxvvbuunscm0Dd2gkiqTILtK/keQZOu2U/amTWuSbCNWhrc0jn/rqY4oRPZW/94w5yvZ5ORW34L5VQQI5nYy2GdzqoNuFqixQ1XCLfwLfdE0X3RnXBFgbCBwKE303F9gU3V0RADOtuC7ZzriadAMcggqWGsj3VIujiYzRo718cUmyMkkSDfjV6MnDWdRgQgGTEDLxqfOgGUnBm9o0CaZcyzM7dZR6rfyrEkFioPAhwNvRlJiyakyhDO1gjjQZzMv9Rw6Nmv6ZPDGvZHLNX9kwFQMTlmT/J7K7VTIO5F0PMc+DSCsdN3GgyPJ11fJEYw8wScQJb/L7qaxCnyMxd+9nIuNDYXD1nwVNQ0kQEaZQyF4cUnp8UfRAgJFnM0Y8pACn9faLql8ldL14HZXyDjb1GDmQZlFNuF45UyjBPIwFCAIqCzEhZoMsYk0ebeGMVDBDQ8wf8sQF8E7GMcgHmHdnZK9TFdU5A5SIqYaCrERo/wTIxoO0LhRDvcWFnH5rdagDYPCQDvXUgMjf8OoMhi4v+iz4hdVYPitVUxvgJs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199018)(36840700001)(40470700004)(46966006)(8936002)(30864003)(5660300002)(44832011)(70206006)(70586007)(4326008)(8676002)(316002)(66899018)(478600001)(110136005)(2906002)(36756003)(6666004)(426003)(47076005)(1076003)(36860700001)(356005)(82740400003)(41300700001)(2616005)(81166007)(86362001)(40480700001)(83380400001)(82310400005)(40460700003)(26005)(186003)(16526019)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 01:31:30.7304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62880e12-da09-4cd1-5f34-08db203e02a9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8531
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the vDPA device support, where we advertise that we can
support the virtio queues and deal with the configuration work
through the pds_core's adminq.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vdpa/pds/aux_drv.c  |  15 +
 drivers/vdpa/pds/aux_drv.h  |   1 +
 drivers/vdpa/pds/debugfs.c  | 172 ++++++++++++
 drivers/vdpa/pds/debugfs.h  |   8 +
 drivers/vdpa/pds/vdpa_dev.c | 545 +++++++++++++++++++++++++++++++++++-
 5 files changed, 740 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
index 28158d0d98a5..d706f06f7400 100644
--- a/drivers/vdpa/pds/aux_drv.c
+++ b/drivers/vdpa/pds/aux_drv.c
@@ -60,8 +60,21 @@ static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
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
+	pds_vdpa_remove_virtio(&vdpa_aux->vd_mdev);
 err_free_mgmt_info:
 	pci_free_irq_vectors(padev->vf->pdev);
 err_aux_unreg:
@@ -78,11 +91,13 @@ static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
 	struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
 	struct device *dev = &aux_dev->dev;
 
+	vdpa_mgmtdev_unregister(&vdpa_aux->vdpa_mdev);
 	pds_vdpa_remove_virtio(&vdpa_aux->vd_mdev);
 	pci_free_irq_vectors(vdpa_aux->padev->vf->pdev);
 
 	vdpa_aux->padev->ops->unregister_client(vdpa_aux->padev);
 
+	pds_vdpa_debugfs_del_vdpadev(vdpa_aux);
 	kfree(vdpa_aux);
 	auxiliary_set_drvdata(aux_dev, NULL);
 
diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
index 87ac3c01c476..1ab1ce64da7c 100644
--- a/drivers/vdpa/pds/aux_drv.h
+++ b/drivers/vdpa/pds/aux_drv.h
@@ -11,6 +11,7 @@ struct pds_vdpa_aux {
 	struct pds_auxiliary_dev *padev;
 
 	struct vdpa_mgmt_dev vdpa_mdev;
+	struct pds_vdpa_device *pdsv;
 
 	struct pds_vdpa_ident ident;
 
diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
index aa5e9677fe74..b3ee4f42f3b6 100644
--- a/drivers/vdpa/pds/debugfs.c
+++ b/drivers/vdpa/pds/debugfs.c
@@ -9,6 +9,7 @@
 #include <linux/pds/pds_auxbus.h>
 
 #include "aux_drv.h"
+#include "vdpa_dev.h"
 #include "debugfs.h"
 
 #ifdef CONFIG_DEBUG_FS
@@ -26,4 +27,175 @@ void pds_vdpa_debugfs_destroy(void)
 	dbfs_dir = NULL;
 }
 
+#define PRINT_SBIT_NAME(__seq, __f, __name)                     \
+	do {                                                    \
+		if ((__f) & (__name))                               \
+			seq_printf(__seq, " %s", &#__name[16]); \
+	} while (0)
+
+static void print_status_bits(struct seq_file *seq, u16 status)
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
+#define PRINT_FBIT_NAME(__seq, __f, __name)                \
+	do {                                               \
+		if ((__f) & BIT_ULL(__name))                 \
+			seq_printf(__seq, " %s", #__name); \
+	} while (0)
+
+static void print_feature_bits(struct seq_file *seq, u64 features)
+{
+	seq_puts(seq, "features:");
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CSUM);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_CSUM);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MTU);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MAC);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_TSO4);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_TSO6);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_ECN);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_UFO);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_TSO4);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_TSO6);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_ECN);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_UFO);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MRG_RXBUF);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_STATUS);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_VQ);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_RX);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_VLAN);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_RX_EXTRA);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_ANNOUNCE);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MQ);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_MAC_ADDR);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HASH_REPORT);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_RSS);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_RSC_EXT);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_STANDBY);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_SPEED_DUPLEX);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_F_NOTIFY_ON_EMPTY);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_F_ANY_LAYOUT);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_F_VERSION_1);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_F_ACCESS_PLATFORM);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_F_RING_PACKED);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_F_ORDER_PLATFORM);
+	PRINT_FBIT_NAME(seq, features, VIRTIO_F_SR_IOV);
+	seq_puts(seq, "\n");
+}
+
+void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_aux *vdpa_aux)
+{
+	vdpa_aux->dentry = debugfs_create_dir(pci_name(vdpa_aux->padev->vf->pdev), dbfs_dir);
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
+	print_feature_bits(seq, mgmt->supported_features);
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
+	print_status_bits(seq, __virtio16_to_cpu(true, vc.status));
+
+	seq_printf(seq, "req_features:         %#llx\n", pdsv->req_features);
+	print_feature_bits(seq, pdsv->req_features);
+	seq_printf(seq, "actual_features:      %#llx\n", pdsv->actual_features);
+	print_feature_bits(seq, pdsv->actual_features);
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
+	seq_printf(seq, "hw_qtype:   %d\n", vq->hw_qtype);
+	seq_printf(seq, "hw_qindex:  %d\n", vq->hw_qindex);
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
 #endif /* CONFIG_DEBUG_FS */
diff --git a/drivers/vdpa/pds/debugfs.h b/drivers/vdpa/pds/debugfs.h
index fff078a869e5..23e8345add0d 100644
--- a/drivers/vdpa/pds/debugfs.h
+++ b/drivers/vdpa/pds/debugfs.h
@@ -10,9 +10,17 @@
 
 void pds_vdpa_debugfs_create(void);
 void pds_vdpa_debugfs_destroy(void);
+void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_aux *vdpa_aux);
+void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux);
+void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_aux *vdpa_aux);
+void pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_aux *vdpa_aux);
 #else
 static inline void pds_vdpa_debugfs_create(void) { }
 static inline void pds_vdpa_debugfs_destroy(void) { }
+static inline void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_aux *vdpa_aux) { }
+static inline void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux) { }
+static inline void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_aux *vdpa_aux) { }
+static inline void pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_aux *vdpa_aux) { }
 #endif
 
 #endif /* _PDS_VDPA_DEBUGFS_H_ */
diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
index 15d623297203..2e0a5078d379 100644
--- a/drivers/vdpa/pds/vdpa_dev.c
+++ b/drivers/vdpa/pds/vdpa_dev.c
@@ -5,6 +5,7 @@
 #include <linux/vdpa.h>
 #include <uapi/linux/vdpa.h>
 #include <linux/virtio_pci_modern.h>
+#include <uapi/linux/virtio_pci.h>
 
 #include <linux/pds/pds_core.h>
 #include <linux/pds/pds_adminq.h>
@@ -13,7 +14,426 @@
 
 #include "vdpa_dev.h"
 #include "aux_drv.h"
+#include "cmds.h"
+#include "debugfs.h"
 
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
+	struct pci_dev *pdev = pdsv->vdpa_aux->padev->vf->pdev;
+	struct device *dev = &pdsv->vdpa_dev.dev;
+	int irq;
+	int err;
+
+	dev_dbg(dev, "%s: qid %d ready %d => %d\n",
+		__func__, qid, pdsv->vqs[qid].ready, ready);
+	if (ready == pdsv->vqs[qid].ready)
+		return;
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
+		/* Pass vq setup info to DSC */
+		err = pds_vdpa_cmd_init_vq(pdsv, qid, &pdsv->vqs[qid]);
+		if (err) {
+			pds_vdpa_release_irq(pdsv, qid);
+			ready = false;
+		}
+	} else {
+		err = pds_vdpa_cmd_reset_vq(pdsv, qid);
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
+	struct pds_vdpa_vq_set_state_cmd cmd = {
+		.opcode = PDS_VDPA_CMD_VQ_SET_STATE,
+		.vdpa_index = pdsv->vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+		.qid = cpu_to_le16(qid),
+	};
+	struct pds_vdpa_comp comp = {0};
+	int err;
+
+	dev_dbg(dev, "%s: qid %d avail %#x\n",
+		__func__, qid, state->packed.last_avail_idx);
+
+	if (pdsv->actual_features & VIRTIO_F_RING_PACKED) {
+		cmd.avail = cpu_to_le16(state->packed.last_avail_idx |
+					(state->packed.last_avail_counter << 15));
+		cmd.used = cpu_to_le16(state->packed.last_used_idx |
+				       (state->packed.last_used_counter << 15));
+	} else {
+		cmd.avail = cpu_to_le16(state->split.avail_index);
+		/* state->split does not provide a used_index:
+		 * the vq will be set to "empty" here, and the vq will read
+		 * the current used index the next time the vq is kicked.
+		 */
+		cmd.used = cpu_to_le16(state->split.avail_index);
+	}
+
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+	if (err)
+		dev_err(dev, "Failed to set vq state qid %u, status %d: %pe\n",
+			qid, comp.status, ERR_PTR(err));
+
+	return err;
+}
+
+static int pds_vdpa_get_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
+				 struct vdpa_vq_state *state)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_vq_get_state_cmd cmd = {
+		.opcode = PDS_VDPA_CMD_VQ_GET_STATE,
+		.vdpa_index = pdsv->vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+		.qid = cpu_to_le16(qid),
+	};
+	struct pds_vdpa_vq_get_state_comp comp = {0};
+	int err;
+
+	dev_dbg(dev, "%s: qid %d\n", __func__, qid);
+
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+	if (err) {
+		dev_err(dev, "Failed to get vq state qid %u, status %d: %pe\n",
+			qid, comp.status, ERR_PTR(err));
+		return err;
+	}
+
+	if (pdsv->actual_features & VIRTIO_F_RING_PACKED) {
+		state->packed.last_avail_idx = le16_to_cpu(comp.avail) & 0x7fff;
+		state->packed.last_avail_counter = le16_to_cpu(comp.avail) >> 15;
+	} else {
+		state->split.avail_index = le16_to_cpu(comp.avail);
+		/* state->split does not provide a used_index. */
+	}
+
+	return err;
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
+		area.size = PAGE_SIZE;
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
+	return PAGE_SIZE;
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
+	return le64_to_cpu(pdsv->vdpa_aux->ident.hw_features);
+}
+
+static int pds_vdpa_set_driver_features(struct vdpa_device *vdpa_dev, u64 features)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+	struct device *dev = &pdsv->vdpa_dev.dev;
+	u64 nego_features;
+	u64 missing;
+	int err;
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
+	dev_dbg(dev, "%s: %#llx => %#llx\n",
+		__func__, pdsv->actual_features, nego_features);
+
+	if (pdsv->actual_features == nego_features)
+		return 0;
+
+	err = pds_vdpa_cmd_set_features(pdsv, nego_features);
+	if (!err)
+		pdsv->actual_features = nego_features;
+
+	return err;
+}
+
+static u64 pds_vdpa_get_driver_features(struct vdpa_device *vdpa_dev)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+
+	return pdsv->actual_features;
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
+
+	vp_modern_set_status(&pdsv->vdpa_aux->vd_mdev, status);
+}
+
+static int pds_vdpa_reset(struct vdpa_device *vdpa_dev)
+{
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
+	struct device *dev = pdsv->vdpa_aux->padev->vf->dev;
+	int err = 0;
+	u8 status;
+	int i;
+
+	status = pds_vdpa_get_status(vdpa_dev);
+
+	if (status == 0)
+		return 0;
+
+	if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
+		/* Reset the vqs */
+		for (i = 0; i < pdsv->num_vqs && !err; i++) {
+			err = pds_vdpa_cmd_reset_vq(pdsv, i);
+			if (err)
+				dev_err(dev, "%s: reset_vq failed qid %d: %pe\n",
+					__func__, i, ERR_PTR(err));
+			pds_vdpa_release_irq(pdsv, i);
+			memset(&pdsv->vqs[i], 0, sizeof(pdsv->vqs[0]));
+			pdsv->vqs[i].ready = false;
+		}
+	}
+
+	if (err != -ETIMEDOUT && err != -ENXIO)
+		pds_vdpa_set_status(vdpa_dev, 0);
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
@@ -22,12 +442,135 @@ static struct virtio_device_id pds_vdpa_id_table[] = {
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
+	vdpa_aux->padev->priv = pdsv;
+	pdsv->vdpa_aux = vdpa_aux;
+
+	pdev = vdpa_aux->padev->vf->pdev;
+	dma_dev = &pdev->dev;
+	pdsv->vdpa_dev.dma_dev = dma_dev;
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
+	if (mgmt->supported_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
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
+	pds_vdpa_debugfs_del_vdpadev(vdpa_aux);
+
+	vdpa_aux->pdsv = NULL;
+
+	dev_info(vdpa_aux->padev->vf->dev, "Removed vdpa device\n");
 }
 
 static const struct vdpa_mgmtdev_ops pds_vdpa_mgmt_dev_ops = {
-- 
2.17.1

