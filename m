Return-Path: <netdev+bounces-2839-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C25797043C3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 04:59:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 318CC280C15
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 02:59:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C57F846D;
	Tue, 16 May 2023 02:56:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8678830
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:56:01 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25CD40D0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:55:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0otGPJ4/uKUXgJ3g4WM0t8sWgCrbanK1Eiwhe2ZlaX+uGBKRuZeq5z8518slthmZ9OBiYXrKllrx7X897mTgVkTsKy4ngP3Q3pj0BTARFWUFtRA8d0qZzb0o118J7udcHovcMpezc0XgRyQ9T5ppUsvVbaK6ccZQxh3wFEXSauL3AJFyGMDSfpGAu4n+lAgM/M/w0+LQFBJZExcLYvQurVX0/5Oy1dXIsUZjsyDRRRCJTspSxuApFXOKRxUFqCFgFV0kPRdDCMaePqlFix4J9ewwVpPgEe8Nx600S4npKznwZmWvzYaQr0wIm98YXc6DIYnc6DhHiFX7ZEb/5S9cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJLAmJMpBaqhUGOWtNzwNu+mPZmC2vq4ac/CQjEBuyM=;
 b=k1BkacBJ8jw3UBc/gMveUuFkq3iOCBMm6G5ig539HCdWAOn/wbCxEeB2gKtQBBwog/XPprAKF+Q0zK29fKPsBQ0jf1gdQo7R2XH/qhXarxeeA4z8+pMTGF4TN/hZHvupfMTu7R5YBjWCBpdNtE9dQ+Ynq8hr773Qlzlw8CKopMt77azrtdPKh6EHy+M4hDuzDXBjWUpGh82CVl0BcMx6D0O8pugTPaqf0kSM32RWHVuRTewXKV823MqH8E+aKqolPDGfIUAHzL0ijxMf3aJlgAtFk1CzM7xd7inzJWwWV/Zyni1kiRKMSmr/N0N2GsHFg12HXfQfDNy8b9BXE1uf3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJLAmJMpBaqhUGOWtNzwNu+mPZmC2vq4ac/CQjEBuyM=;
 b=lRZFOoBfuJ1tLBIn1uqHq7nu7qg4YJFjzHyE9nh8cauwqHOez+PawIetzp241Po57s7BwYj75BO9nu1o0AZKkYcYAZtaBUzAc8a3pvlAFL3OTpj6i6jikez73aS82pux4AyS1OeW9MvnjBW+YevsZmLD6HZNTsck40meTVd0kbM=
Received: from SJ0PR03CA0024.namprd03.prod.outlook.com (2603:10b6:a03:33a::29)
 by SJ2PR12MB9244.namprd12.prod.outlook.com (2603:10b6:a03:574::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 02:55:52 +0000
Received: from DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:33a:cafe::15) by SJ0PR03CA0024.outlook.office365.com
 (2603:10b6:a03:33a::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30 via Frontend
 Transport; Tue, 16 May 2023 02:55:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT096.mail.protection.outlook.com (10.13.173.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.15 via Frontend Transport; Tue, 16 May 2023 02:55:52 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 15 May
 2023 21:55:51 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v6 virtio 10/11] pds_vdpa: subscribe to the pds_core events
Date: Mon, 15 May 2023 19:55:20 -0700
Message-ID: <20230516025521.43352-11-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT096:EE_|SJ2PR12MB9244:EE_
X-MS-Office365-Filtering-Correlation-Id: acd7fd45-ff34-42e5-73d1-08db55b90fbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2Ma7uHkln4dcMiZyUtgjhSKWNgmzmB2zpK+E4E1/3ne/5I/ehXvgoWq9Y/H1QcxNg0qabG4504e4eQ0xdBVncd7FYsrIEqFDjMPY6BOcmP+UxGSTzoaQUwM3qesjOUq6xBHc4D8ASZ/aq79igmeJNEG+feRjjon8WsQhrD+2ZgltVhuQxCIiEp3Qs4u7WKVqwJtJ7JK6JI8zipyn/zziid/FT+5H9/8RHiHmk+rK7lao2zfMjZ9T2+omUdpFdsRFgyMxQTCwZDEChEJL9lh8xB+n+NRiAXL8XgVYrucIoUncXoedswTDCWbMahfN8pAVl422bXO6V3XcPmUsCqlLdDVlbEcWTXL8icK/2rskIVQROVMvSJxV1gUQMfQecsqx95DhK2426d2MRPaOi6HIXkxOD+Fag2Og1Nz/+Wd+Ln17qM3PvdahRUl5lAoTpKTKIhrsA0Stf2k+remzr1q7kcHtayX/ZJsliBwY3o6PT8EarTNtoSwD6LMZWnRB5Ml5wRE9WaRJym8r/riKq0+3zKnY7JslttCpSh5Rjieatj+zKUQtoMP8gLCTFTTDkOJ9Z3YnQDO7GOpYwqSOfhtyFlRgqTjcDAI26n6dV2Lo4Nmtk9nXRIaA2Ymtbf6oGSSdrvl8erM3a6yfJVn6lGkgwo3Zd6FbCNayd75phwQhhxsFzBrzrPhJi/QyKA27VmEhlHV6g3LxdU1ckyKAthX+sIiFe7S5tc8wpQbOpAkkuUWAj3bw7t3qJizE1oRkZwqp1W5uxSgkMis1eOa3yzrm3A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199021)(46966006)(40470700004)(36840700001)(83380400001)(82310400005)(44832011)(5660300002)(8936002)(8676002)(356005)(36860700001)(81166007)(316002)(86362001)(2906002)(47076005)(426003)(336012)(54906003)(2616005)(16526019)(186003)(110136005)(1076003)(40460700003)(478600001)(26005)(70206006)(70586007)(41300700001)(36756003)(82740400003)(6666004)(4326008)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 02:55:52.3791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acd7fd45-ff34-42e5-73d1-08db55b90fbf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9244
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
---
 drivers/vdpa/pds/vdpa_dev.c | 59 ++++++++++++++++++++++++++++++++++++-
 drivers/vdpa/pds/vdpa_dev.h |  1 +
 2 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
index 07b98dff5701..9afa803c4f21 100644
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
@@ -594,6 +640,12 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 
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
@@ -602,13 +654,15 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
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
@@ -618,8 +672,11 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
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


