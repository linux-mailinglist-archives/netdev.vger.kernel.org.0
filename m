Return-Path: <netdev+bounces-4025-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55D2470A248
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 23:59:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EDD51C208E3
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC4D18AF5;
	Fri, 19 May 2023 21:57:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ACD18AF4
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 21:57:05 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDE4B1
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:57:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ddhyeCR+VM+eoHb28KzHAv/LJKwk2u2Z1xoo/69ubv0R95tO9vIJYvFSV54SjZb4KL9mLwGf3DeMOfaUhe9shTY/YX82QUkDauA0b2dDHR2AwpAOQoCX+ZeCGwxVVKjrFpClAaY6Xz0W/GUdnrkpPVHt3LI27cHESW7ADTIWDZdG4KdEGHzNE39u0P/oqX9DljhzpWs6wKwYylvgsY0GrI5iUw2K9KB2WQsRcjZ/0KVvoQh/rDSrQUcfXAGHALE6Rvkl6QuqyoAmLT64YIiZ99Bx0GGbkWjyZ/jWQcq6jZbbNwiqTvUMrg5atlpy5RyVrXoc/QWU9Wg8NFMSW2rrtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WueP5MkSfpKKR7H4N/FDcTIi8eX12sx3ZV2Rdgya2XU=;
 b=cacrI2JAiQ5S8cl8q+r9dELVbiOR1hFxDUVwdflaeLhYOKNq32vk5ADM9D5wuj6WqGky5VeooewcEQpmXcZIplk1DnYhhROo/j595ExCkUosdG/eel6wUBnx+oNpe1/UspQGXuzeVjnJqnkFTluq5/Vfd7qmSWZUANl021iK7VNEhkl/CTbecxio3A0/MnG8w4FUG7Kc/u7ck9pLK4dCiLDTPHQwlhjPlmxpBOxA+HcraxS2F2atj3jCVauzohMjuaw7ls66lcM42RmAydFna5TfkGh9pBwJMEMkEYLZli8zyRi61ayx2vWqQ7Q+h5PUPnQbdDI+9AhjEPu51NVbUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WueP5MkSfpKKR7H4N/FDcTIi8eX12sx3ZV2Rdgya2XU=;
 b=4e2qU7xhyEUPxSjtiX10rODH2FP6k0eVg5Cl9XV6R0mxZP0KNiy02CzsXxUluK8fknTnp/BQAyBsJ4sTIRcfdMKcYuFteIMbJ8/9uvqf2T+sJf2lq46LpkBwzovCoSxorYXhnYYbI7E8je2IyWaN6R5H2zIrncPKp2LEWnSws+4=
Received: from BN9PR03CA0990.namprd03.prod.outlook.com (2603:10b6:408:109::35)
 by PH7PR12MB9256.namprd12.prod.outlook.com (2603:10b6:510:2fe::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 21:57:01 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::22) by BN9PR03CA0990.outlook.office365.com
 (2603:10b6:408:109::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19 via Frontend
 Transport; Fri, 19 May 2023 21:57:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.21 via Frontend Transport; Fri, 19 May 2023 21:57:00 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 19 May
 2023 16:56:58 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v7 virtio 10/11] pds_vdpa: subscribe to the pds_core events
Date: Fri, 19 May 2023 14:56:31 -0700
Message-ID: <20230519215632.12343-11-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT009:EE_|PH7PR12MB9256:EE_
X-MS-Office365-Filtering-Correlation-Id: 189e9f67-12c2-4a27-a70e-08db58b3f93c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IPN9ihZrvJSkIVU8vSRodK/4ZB7Ul52ARIFxiZMNntDCYyCpUhIiDNqUVnI6Yzbalqc73aanU31cAblu1on/ldD/e5rdMpJf7p8s6OnE2ps2QUyYw0FGjDfctztHcyM5J5hQmFRqoG4un9gaAIdzCLZkvBUAYkfk5IwNKntUMe7+ibq1p1MDcklATcnJBsi4w+bChtUXE0DwtZX2eoseAGhANulFZ5eaKLyvv0cff9yK/BWZsjGNhoTC7HWK0gES0GNvYQvXLmq1lb2axLwG7Giu0MvyApwKLM6qc6BHAEBs/Gee+kIZ8uzxTW0lcKtZNpB+LZKbT9cK7PmJjTXUlLl8Dp1jQV1Vu4QAj869beqSy5oYh0SDaPlL2ANJeb9FUPQTiz8F0JkoeyWJxlgidbCzV77y7wxlJUfpSZFh/T+R97i+WsHD5yDsvDI0j/vtROz7i31UZqIgnGdCKyvzbiQ0L6e0q4fyE6FwnkLucr6Q8pqr6HeqaRhsnagL7SfGgY3saFI7NDmB0teoGHmyrxchVrfiz1cUWi12MXJ3PRWEcl15hRGSZIIgUZOdG8xuj3UD7WxI0k++Wo+BsABiwcapqZ22+Yjx3ZQ6sT3Q+d2ygiEpyjJBJGr97dby60Gdg2suGUNc1atFnu2Ygtt0nZk2KPDXbCWaD2APahaBzeH+T4jBb1NaDf0DyElJkA63nQfTxGRZqArhJOseIIAJn0rDD/uIJdz65b99KLZMC9t3vnmkD2CP46T4++X7jnuNH9pQQIDuM2zSqbHm3//OBw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199021)(40470700004)(46966006)(36840700001)(40460700003)(26005)(1076003)(426003)(36756003)(36860700001)(83380400001)(47076005)(40480700001)(86362001)(336012)(2616005)(82310400005)(81166007)(16526019)(82740400003)(186003)(356005)(54906003)(110136005)(44832011)(5660300002)(2906002)(316002)(8676002)(4326008)(8936002)(41300700001)(478600001)(70206006)(70586007)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 21:57:00.6480
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 189e9f67-12c2-4a27-a70e-08db58b3f93c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9256
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Register for the pds_core's notification events, primarily to
find out when the FW has been reset so we can pass this on
back up the chain.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/pds/vdpa_dev.c | 59 ++++++++++++++++++++++++++++++++++++-
 drivers/vdpa/pds/vdpa_dev.h |  1 +
 2 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
index 5690ee676ad9..5071a4d58f8d 100644
--- a/drivers/vdpa/pds/vdpa_dev.c
+++ b/drivers/vdpa/pds/vdpa_dev.c
@@ -23,6 +23,52 @@ static struct pds_vdpa_device *vdpa_to_pdsv(struct vdpa_device *vdpa_dev)
 	return container_of(vdpa_dev, struct pds_vdpa_device, vdpa_dev);
 }
 
+static int pds_vdpa_notify_handler(struct notifier_block *nb,
+				   unsigned long ecode,
+				   void *data)
+{
+	struct pds_vdpa_device *pdsv = container_of(nb, struct pds_vdpa_device, nb);
+	struct device *dev = &pdsv->vdpa_aux->padev->aux_dev.dev;
+
+	dev_dbg(dev, "%s: event code %lu\n", __func__, ecode);
+
+	if (ecode == PDS_EVENT_RESET || ecode == PDS_EVENT_LINK_CHANGE) {
+		if (pdsv->config_cb.callback)
+			pdsv->config_cb.callback(pdsv->config_cb.private);
+	}
+
+	return 0;
+}
+
+static int pds_vdpa_register_event_handler(struct pds_vdpa_device *pdsv)
+{
+	struct device *dev = &pdsv->vdpa_aux->padev->aux_dev.dev;
+	struct notifier_block *nb = &pdsv->nb;
+	int err;
+
+	if (!nb->notifier_call) {
+		nb->notifier_call = pds_vdpa_notify_handler;
+		err = pdsc_register_notify(nb);
+		if (err) {
+			nb->notifier_call = NULL;
+			dev_err(dev, "failed to register pds event handler: %ps\n",
+				ERR_PTR(err));
+			return -EINVAL;
+		}
+		dev_dbg(dev, "pds event handler registered\n");
+	}
+
+	return 0;
+}
+
+static void pds_vdpa_unregister_event_handler(struct pds_vdpa_device *pdsv)
+{
+	if (pdsv->nb.notifier_call) {
+		pdsc_unregister_notify(&pdsv->nb);
+		pdsv->nb.notifier_call = NULL;
+	}
+}
+
 static int pds_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
 				   u64 desc_addr, u64 driver_addr, u64 device_addr)
 {
@@ -595,6 +641,12 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 
 	pdsv->vdpa_dev.mdev = &vdpa_aux->vdpa_mdev;
 
+	err = pds_vdpa_register_event_handler(pdsv);
+	if (err) {
+		dev_err(dev, "Failed to register for PDS events: %pe\n", ERR_PTR(err));
+		goto err_unmap;
+	}
+
 	/* We use the _vdpa_register_device() call rather than the
 	 * vdpa_register_device() to avoid a deadlock because our
 	 * dev_add() is called with the vdpa_dev_lock already set
@@ -603,13 +655,15 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	err = _vdpa_register_device(&pdsv->vdpa_dev, pdsv->num_vqs);
 	if (err) {
 		dev_err(dev, "Failed to register to vDPA bus: %pe\n", ERR_PTR(err));
-		goto err_unmap;
+		goto err_unevent;
 	}
 
 	pds_vdpa_debugfs_add_vdpadev(vdpa_aux);
 
 	return 0;
 
+err_unevent:
+	pds_vdpa_unregister_event_handler(pdsv);
 err_unmap:
 	put_device(&pdsv->vdpa_dev.dev);
 	vdpa_aux->pdsv = NULL;
@@ -619,8 +673,11 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 static void pds_vdpa_dev_del(struct vdpa_mgmt_dev *mdev,
 			     struct vdpa_device *vdpa_dev)
 {
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
 	struct pds_vdpa_aux *vdpa_aux;
 
+	pds_vdpa_unregister_event_handler(pdsv);
+
 	vdpa_aux = container_of(mdev, struct pds_vdpa_aux, vdpa_mdev);
 	_vdpa_unregister_device(vdpa_dev);
 
diff --git a/drivers/vdpa/pds/vdpa_dev.h b/drivers/vdpa/pds/vdpa_dev.h
index 25c1d192f0ef..a1bc37de9537 100644
--- a/drivers/vdpa/pds/vdpa_dev.h
+++ b/drivers/vdpa/pds/vdpa_dev.h
@@ -40,6 +40,7 @@ struct pds_vdpa_device {
 	u8 vdpa_index;			/* rsvd for future subdevice use */
 	u8 num_vqs;			/* num vqs in use */
 	struct vdpa_callback config_cb;
+	struct notifier_block nb;
 };
 
 #define PDS_VDPA_PACKED_INVERT_IDX	0x8000
-- 
2.17.1


