Return-Path: <netdev+bounces-202-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F0AB6F5DB5
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 20:15:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6530C1C20FC4
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94C81BE76;
	Wed,  3 May 2023 18:13:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806A4BE45
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 18:13:13 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733CE19BE
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:13:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOhH4Ngd/C+U/XoausJQ+tdQ/Il4M60GwhpYAOP74cVBjWvbK6NbmwsxwSx7UMToVgjoNJBeNF6LPdZwqoLFKlcr0V5F6va+qIeqFomiiKkneRT8/J6hTma/bFI0iTSALmbQj9R7nOKer0HR7Hchy2TGC11elmk+oJ+K3IAfTpVzL8yekyC60vhR3pdoqRQVIUCqfIq6Go1D0XyjrtKZ9QzFAJev1IRiNdHIfJ1IB7A2s7EzV0uFlHg++TOVp5AX9/rrepbFLaqu+1WEHg0Ric/3YKkfyMBswyNRkB5zHWvl8+4SY0lnc/YQRBLjJ5KCbUomv6YLkD8J/02hnfwFow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1gIveVpiQV5ZSSgZln6UEHlyprFWoCfTQPmmOKNSLk=;
 b=az9b3yxQIPaIKQR5yr0MLiKQt+fn1HgviOymSNAKUDInBjpf1rIsuDdUk98IqLKumM1B1VrPsvpvdFsiUngILL8wObLDYEyTpFTRurNQMV8TRGFWFUlt08aKobgi67mi4a6Khpzi2N8bkIs9acU3F5cuhxwy0hego2/zxqYNU/EFXUATM1FxOPXlB15uQXIzOXCThchlrkFLcZD3qIXshdCZZmivsyto1dCOEd8Cojn/GbP84YU+HMgSY6zaSChUab25p6X5y+jZzKIw7k4bFKTWyN87/RQzmlUU7sOK+nASg3Rw4sleGFQLbpi5HSgeSULMdNVPc6Fxx87T/m5wxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1gIveVpiQV5ZSSgZln6UEHlyprFWoCfTQPmmOKNSLk=;
 b=MgBvVO0ewvCvsuZcFUva5+9aA8i+5XPNDDRZUwYnjj3ui3IyYOTtXySW1h20ZpQDXHbEhpSaTfO/pYBfmsob9m/jEjMuCpMA2wD3X7kZFQeqYlRQ2cgJy6VamepmdJgFutcfhmVCw/91X0OONAssRswVL7vC5erTfC2xeT2B6sw=
Received: from DS7PR03CA0131.namprd03.prod.outlook.com (2603:10b6:5:3b4::16)
 by DM6PR12MB4188.namprd12.prod.outlook.com (2603:10b6:5:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Wed, 3 May
 2023 18:13:08 +0000
Received: from DM6NAM11FT107.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::a) by DS7PR03CA0131.outlook.office365.com
 (2603:10b6:5:3b4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22 via Frontend
 Transport; Wed, 3 May 2023 18:13:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT107.mail.protection.outlook.com (10.13.172.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.22 via Frontend Transport; Wed, 3 May 2023 18:13:08 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 3 May
 2023 13:13:07 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v5 virtio 10/11] pds_vdpa: subscribe to the pds_core events
Date: Wed, 3 May 2023 11:12:39 -0700
Message-ID: <20230503181240.14009-11-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT107:EE_|DM6PR12MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: e2fe56de-a335-4e7b-9d41-08db4c020c9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vdLKHlkwvZz1cSN8mXlfO1kSXLPTHT4FR2yn7puYiuhov5jp+71HVXDlAnWoL2eVb231sP7NGgxCjiogxW2gNj+9gmdQIX3EXi7BpfI4avPmvTzMGKZBm54eHppzACtxZgwxBREC44Jnsa8HtjvT5SkDfye+FMIGlVg83DhH1Q1Dbxu9ai3RaJBjFY/qwOvCKhsWIR7oKIWFpOfZxDkHRLT62nefT9w+/E85+BhA5lgaYKiHaN2NjlvbFXT5syx8CP0L2REI7Ch/wntujYu6wGTF8K5BLhGIrcu8Iu+IxRO1jKt5yu0ZxrFV7cW1PNDxmJSg3ltiZUrohN8LzreS0dTPKazkl7P5JWsMWZhwy69svk3g1uGor9/y1YwL3RKJwIJ6DLEw4xij0YaEUt9Ulf/OYWezmeZqB6oEHAnx++gjvvdKXFJAlGqOdZqsPAiT7z1OKqaIbLrM8PYeU4VFAJBRCkKnvZcDYuymQ9QLWPtpX5sFTIPd8gVASWaRbbPh1IUYmpEyE9DqNuPIAu7nhprxtH6lfostrMdaDaIPATCnspB08MEWVk5V/+A77L3QW3xd3Zr29oShvT0ySQs3z71Rdj8J12rvyGWUu3MboAnAkEM5lbhAgbh2NJkExZ3Ihle5xPjr5nEoa+Ac759SLip7DDHOjv59uRw1MCOy8aJPE2R4gQpLJc5LF6zKR7xx/ALlhGeNlUDxR5wcluBoJqoomqQKyLCQX+EY3iEEQtw=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199021)(46966006)(40470700004)(36840700001)(44832011)(2616005)(36756003)(41300700001)(6666004)(86362001)(40480700001)(316002)(47076005)(4326008)(83380400001)(426003)(36860700001)(70586007)(70206006)(336012)(82310400005)(40460700003)(478600001)(16526019)(2906002)(5660300002)(356005)(81166007)(110136005)(54906003)(82740400003)(186003)(8676002)(8936002)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 18:13:08.7380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2fe56de-a335-4e7b-9d41-08db4c020c9a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT107.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4188
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
 drivers/vdpa/pds/vdpa_dev.c | 68 ++++++++++++++++++++++++++++++++++++-
 drivers/vdpa/pds/vdpa_dev.h |  1 +
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
index 9970657cdb3d..377eefc2fa1e 100644
--- a/drivers/vdpa/pds/vdpa_dev.c
+++ b/drivers/vdpa/pds/vdpa_dev.c
@@ -21,6 +21,61 @@ static struct pds_vdpa_device *vdpa_to_pdsv(struct vdpa_device *vdpa_dev)
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
+	/* Give the upper layers a hint that something interesting
+	 * may have happened.  It seems that the only thing this
+	 * triggers in the virtio-net drivers above us is a check
+	 * of link status.
+	 *
+	 * We don't set the NEEDS_RESET flag for EVENT_RESET
+	 * because we're likely going through a recovery or
+	 * fw_update and will be back up and running soon.
+	 */
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
@@ -522,6 +577,12 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 
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
@@ -530,13 +591,15 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
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
@@ -546,8 +609,11 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
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
index a21596f438c1..1650a2b08845 100644
--- a/drivers/vdpa/pds/vdpa_dev.h
+++ b/drivers/vdpa/pds/vdpa_dev.h
@@ -40,6 +40,7 @@ struct pds_vdpa_device {
 	u8 vdpa_index;			/* rsvd for future subdevice use */
 	u8 num_vqs;			/* num vqs in use */
 	struct vdpa_callback config_cb;
+	struct notifier_block nb;
 };
 
 int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux);
-- 
2.17.1


