Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E0C6B18C8
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 02:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCIBbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 20:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjCIBbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 20:31:38 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2072.outbound.protection.outlook.com [40.107.100.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605029CFD7
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 17:31:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOXcO+AhVaZ/foa9vd//LiHd2QjyVQULsU/UTlaqT/CpELIKxiLOt7NxAqMFNRknl9E62YuuVwCNPHuXmgUQbzIi/XTh/Q3BzD5atBljiAzPyz1gQi0D/v8JlBECb1sqTpkAG4Re2yDPq4yKcvO/XIrknibj6E388BHx4rk0YNWVRAgbvEpj2sQbR+ugPrcMAHfg+/e0X8WduoTDmkdJFHCoLY5Zd4LiVZwMgLwHnZj58xM0rjqFtYkzCHPOq8nQNvtDgpqPGCxNhXt3+3d+fEJFabBY1enwZjGOhZCtnK28IqFzc43WPaDrRXYiURMmVmHoXJQKow6sttu/dP3rJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+xJJlltgY70GEkqfIJxcI5+yImfrN8Fgrv5ulsNgNmg=;
 b=gzwr/rjCjF/AdLxIMGlOhtE1vMYngMLLZqPLqlGZN1C1JJoO0DXtxonbRqXbY4IViawfoifZYlE65oH83c4dmelEI4RIMqRre1Igez/1ljt6hmyLk/MZtUwFbhIGuTdaJtVx3Qo/cCqU6eFes10nx+2VYC8XtF4E1AAmZ4nOwDZZubhZahBcpLowv6UErZvao5XhokkgtEKdawrQyRl5mpCj6Sh0sDTt7zp8Ez+uhq8ypWohqo8X7d6mgFsxkBKezpztv18mF60kkO0XYyZeEa4Xp/T7mopZmr9wPxi5h/irvOVvqARmKaCoP7euZW1HRQdOtN8PE+D+uRCUvz2Crw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xJJlltgY70GEkqfIJxcI5+yImfrN8Fgrv5ulsNgNmg=;
 b=jtnC/padZYrUQp4ZSGFYb4sFmGYS1es1/zVMgPE5wrZpUlOVC5s0+vk+f4obo7fyq9wQJ2rvDzNoi0rPflQG0R/1CWh4MS78HBAxUeT5XarUbwtRzSEpd+1LE25O4DCPDG/VhF4bp9fFNzUD6RzqqCUHC982ZhaksKt1hzyrr5A=
Received: from BN9PR03CA0332.namprd03.prod.outlook.com (2603:10b6:408:f6::7)
 by PH0PR12MB5452.namprd12.prod.outlook.com (2603:10b6:510:d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 01:31:31 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::d0) by BN9PR03CA0332.outlook.office365.com
 (2603:10b6:408:f6::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Thu, 9 Mar 2023 01:31:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Thu, 9 Mar 2023 01:31:31 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Mar
 2023 19:31:28 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH RFC v2 virtio 6/7] pds_vdpa: subscribe to the pds_core events
Date:   Wed, 8 Mar 2023 17:30:45 -0800
Message-ID: <20230309013046.23523-7-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT047:EE_|PH0PR12MB5452:EE_
X-MS-Office365-Filtering-Correlation-Id: 54444e58-4092-4fcc-44a0-08db203e0312
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T8wAy5cgC1g4SkkDcPYXi1lqL8C0E6SigS6GIXOpPrwgaBlKqdZLd3BhaEjF8rgNPUVjwsQPPVVV+cEA4jhK8I9DJkkdH9V6Bf49iA5w7u6dUsEtFpH2D+E6bEpZn7cHGMnY0Xk6R3cPDqqL4MW6z1wvnrg4SN7oNHx+HFnvd0VDYt/JqO63RfffLWnCssXrZRLtR25Mz51QbHgrHZHx0o0Cr2CHZ84tbAEY2dQRiEQRadvpCDFsSy9UGo+oYMXqoT/vNRUX5BGKqkywhwEIJJwoJSO80F1GsDAm+hSrzPZmH+C+TXZfSe9UgnQ2LV9w701qkpMAoFWgs97HQ88CNQWTRGg7uPLK6g8EL1paxUGqpl5Z4b100x8DfqlIkpoiJ0HeJHH/F0/CVPst05DIGQozw5tEPdbslWtvqKydmhoc4FVQLwZiMvbZmuhKm+bHqRZUp1+HiysoRwwTaX6na4KmwQqK8MwlNqTb8U4JCkSsDrgQGEQXa9RU1NG0GJ/JQzLBxodLOUohIy/rdmGBFrM69066W9RsxPL7b7Q3//nF4ueOJ7wCFh+y6C6nUhGq9QXcahmnfnvlWhjTQ0l5MOlTWQ+5V8MW9mzeEYgbDqbjGUY3WwZGH0E7ri2jqJo8sNLjcPF+lu62srLkRN2JgfNdQ9eds00qKs/eHWaBBiAE9VhugwQM6pn3VaJDE7ISJaB/T1h43cmagi6krn+DtYcncqjfpNcK3sAI08FRGEQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199018)(40470700004)(36840700001)(46966006)(8936002)(6666004)(5660300002)(36860700001)(82310400005)(40480700001)(8676002)(70206006)(4326008)(70586007)(86362001)(40460700003)(83380400001)(36756003)(478600001)(426003)(316002)(110136005)(47076005)(41300700001)(336012)(82740400003)(356005)(186003)(2906002)(16526019)(81166007)(1076003)(44832011)(26005)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 01:31:31.4178
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54444e58-4092-4fcc-44a0-08db203e0312
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5452
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register for the pds_core's notification events, primarily to
find out when the FW has been reset so we can pass this on
back up the chain.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vdpa/pds/vdpa_dev.c | 68 ++++++++++++++++++++++++++++++++++++-
 drivers/vdpa/pds/vdpa_dev.h |  1 +
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
index 2e0a5078d379..d99adb4f9fb1 100644
--- a/drivers/vdpa/pds/vdpa_dev.c
+++ b/drivers/vdpa/pds/vdpa_dev.c
@@ -22,6 +22,61 @@ static struct pds_vdpa_device *vdpa_to_pdsv(struct vdpa_device *vdpa_dev)
 	return container_of(vdpa_dev, struct pds_vdpa_device, vdpa_dev);
 }
 
+static int pds_vdpa_notify_handler(struct notifier_block *nb,
+				   unsigned long ecode,
+				   void *data)
+{
+	struct pds_vdpa_device *pdsv = container_of(nb, struct pds_vdpa_device, nb);
+	struct device *dev = pdsv->vdpa_aux->padev->vf->dev;
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
+	struct device *dev = pdsv->vdpa_aux->padev->vf->dev;
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
@@ -538,6 +593,12 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 
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
@@ -546,13 +607,15 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
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
@@ -562,8 +625,11 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 static void pds_vdpa_dev_del(struct vdpa_mgmt_dev *mdev,
 			     struct vdpa_device *vdpa_dev)
 {
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
 	struct pds_vdpa_aux *vdpa_aux;
 
+	pds_vdpa_unregister_event_handler(pdsv);
+
 	vdpa_aux = container_of(mdev, struct pds_vdpa_aux, vdpa_mdev);
 	_vdpa_unregister_device(vdpa_dev);
 	pds_vdpa_debugfs_del_vdpadev(vdpa_aux);
diff --git a/drivers/vdpa/pds/vdpa_dev.h b/drivers/vdpa/pds/vdpa_dev.h
index 33284ebe538c..4e7a1b04a12a 100644
--- a/drivers/vdpa/pds/vdpa_dev.h
+++ b/drivers/vdpa/pds/vdpa_dev.h
@@ -43,6 +43,7 @@ struct pds_vdpa_device {
 	u8 vdpa_index;			/* rsvd for future subdevice use */
 	u8 num_vqs;			/* num vqs in use */
 	struct vdpa_callback config_cb;
+	struct notifier_block nb;
 };
 
 int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux);
-- 
2.17.1

