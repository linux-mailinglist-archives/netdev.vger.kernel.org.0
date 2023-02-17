Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C0369B5C9
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjBQW5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjBQW5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:57:41 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CCC68561
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:56:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKDoWB1u0cTkFl4u+vvS5KBpRFqxxv1SqafUBzXkbjvQwjfvX/4XirJTYyav3Pihr+txVe0B82izUyo+xU26rHOyZ7V8s/mttuWfccNsfdsKt/LLKYM+6wE4hanuqRkrOCsUdGV+GZ5snJtj2YOzhRzOQVncpEWWWeXbonQhWEI7eWNH3KEvd7ahCfDFYV6cu770f/8nji18E7jB3igxesrVbIbNv1apcwcz+mIjJOI03CaFxQuPZk7CisXzUxVrLzrMUH9WdDa9J83mDnX40vrpII/YhpvDoXz4uyaZTODGfimwL6m3rg23WZifjBnd2jw/vubMP7C2P6Rd+/jxJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ck1v/nx63i69TZSXtzMxCuPosxkc39hyknjbdmHF3h8=;
 b=e4P8HKxIBXUWj1r1SBnZYCrNRS43g5ZWjRD9J2TcxEYNPp6GRuyxCjIIPtK4A91fXyzs8fQFJ2O9MX7jRh+XnkMLqP0xowIqtMLYziffE+V3ld9mxI6YIYaS3WXVIJNZjyTY0DrYb9iqPZvP4MndSb5S5mNvubNxZkrYDw9B8euZAt16iKIgfknWJ0SO8VrOfDPB4r6dZ0YNwSugxgymN5S3BgYfcac8ob1aph1oCZ5Z8nYT3daCTsGlWI7vj6HASsD6Sidf5mITogILF8a4WUfP8JIvU65fM/oJcIPlleWxjOI9VFbOvTVoTrhX0Eq7JS0qv7fPFnBXJiPVTtE/Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ck1v/nx63i69TZSXtzMxCuPosxkc39hyknjbdmHF3h8=;
 b=Z8oyWRhKBtGO4akh46HjiZxrjauPT4fbY+11/mbhnziOC/M7k+tgjjQAcLQfF8OJcQYORw/K9zPDXkwKZM+ns3oqpUwQkR6ZcqtRcu4+xSxuPRnBuKsP6fNaxOqefRqxYCHDmgSJEYRBI2BpEuN4FXhv08Kk2gbS0gnRJn3jduk=
Received: from DS7PR05CA0018.namprd05.prod.outlook.com (2603:10b6:5:3b9::23)
 by BL1PR12MB5047.namprd12.prod.outlook.com (2603:10b6:208:31a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 22:56:48 +0000
Received: from CO1PEPF00001A63.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::f1) by DS7PR05CA0018.outlook.office365.com
 (2603:10b6:5:3b9::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.13 via Frontend
 Transport; Fri, 17 Feb 2023 22:56:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A63.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 22:56:48 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 16:56:46 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <brett.creeley@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 12/14] pds_core: add the aux client API
Date:   Fri, 17 Feb 2023 14:55:56 -0800
Message-ID: <20230217225558.19837-13-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230217225558.19837-1-shannon.nelson@amd.com>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A63:EE_|BL1PR12MB5047:EE_
X-MS-Office365-Filtering-Correlation-Id: 471fa376-7eb6-48d2-aa62-08db113a4005
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: txo+bipu3QYt8pxorVXjMcFHY5z6WeM0k1GAs1J/kNmfUEiCkNAt7Rs4t82+SuUV4GoVMlLIHhq7EH9syZZFbLt+ASMcmYW9/HjE1I6AWsXaBRf4obWqdyiQvTq2TyZUmWhyAHVhfHdw27UfEtueIgDpHEagzAPXzvZHx26uI+wWd8NxeH6li/2D1d7Z4LFwl5YyZfDqyXHsw1jAe8PzMFBgx1bGTMn0eAy68IGEEPn167lL1ICWb7Rv7WYdCzO3Zwr459PgW1wFGxWN5wAm4u1r1nToiq4hKcwzshM3a7TvyoZ/M5TwWRjqF5RnfWlhtWC5bAq2lu3xj3EmB8UkA4j/UI0QddZyuXsupDfK74aKU8MonbnI7RsKPXR8hoXPpXfNdsOPwqCI5inFYVkcq/JlZ7EVWMLxkvUpdJPI5j4B8Lv8WKxniSDwhXd1dlb1GxuRQ3Le4i2kJ32cKOzVMEG6HTpIPXg/G/MUGX7cE+pv8ZPkC2I0Gfw7udJHQYeLNathiocgN9hWRLJ50eApBTdNaYuYdnqElUFiLNDWUqOwBVXerVgd3tHc5kl0H0qjwKQb4wmOaMvpy82FfuHm3tuPRWENuICytKxfwmVoYCABmaGlgn0+/oRByzDDOr7xY14evXx0Fl4RzyZOnQBCyakoERsWOEAHLqb6k97RkRryZ/O6LVYVdOglFlmJUuYqk/RixPecajzE2cBRmS5nq0N7tlJRMY/szg/fBCU05jI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(41300700001)(36756003)(4326008)(2906002)(8936002)(40480700001)(8676002)(70586007)(70206006)(44832011)(356005)(86362001)(82740400003)(36860700001)(81166007)(6666004)(478600001)(1076003)(110136005)(54906003)(316002)(5660300002)(82310400005)(47076005)(83380400001)(336012)(426003)(2616005)(26005)(186003)(40460700003)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:56:48.1383
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 471fa376-7eb6-48d2-aa62-08db113a4005
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A63.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5047
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the client API operations for registering, unregistering,
and running adminq commands.  We expect to add additional
operations for other clients, including requesting additional
private adminqs and IRQs, but don't have the need yet,

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/auxbus.c | 144 ++++++++++++++++++++-
 include/linux/pds/pds_auxbus.h             |  50 +++++++
 2 files changed, 192 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index dc36fc98de52..6d5e7e1d176c 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -11,6 +11,144 @@
 #include <linux/pds/pds_adminq.h>
 #include <linux/pds/pds_auxbus.h>
 
+/**
+ * pds_client_register - Register the client with the device
+ * @padev:  ptr to the client device info
+ * @padrv:  ptr to the client driver info
+ *
+ * Register the client with the core and with the DSC.  The core
+ * will fill in the client padev->client_id for use in calls
+ * to the DSC AdminQ
+ */
+static int pds_client_register(struct pds_auxiliary_dev *padev,
+			       struct pds_auxiliary_drv *padrv)
+{
+	union pds_core_adminq_comp comp = { 0 };
+	union pds_core_adminq_cmd cmd = { 0 };
+	struct device *dev;
+	struct pdsc *pdsc;
+	int err;
+	u16 ci;
+
+	pdsc = (struct pdsc *)dev_get_drvdata(padev->aux_dev.dev.parent);
+	dev = pdsc->dev;
+
+	if (pdsc->state)
+		return -ENXIO;
+
+	cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
+	strscpy(cmd.client_reg.devname, dev_name(&padev->aux_dev.dev),
+		sizeof(cmd.client_reg.devname));
+
+	err = pdsc_adminq_post(pdsc, &pdsc->adminqcq, &cmd, &comp, false);
+	if (err) {
+		dev_info(dev, "register dev_name %s with DSC failed, status %d: %pe\n",
+			 dev_name(&padev->aux_dev.dev), comp.status, ERR_PTR(err));
+		return err;
+	}
+
+	ci = le16_to_cpu(comp.client_reg.client_id);
+	if (!ci) {
+		dev_err(dev, "%s: device returned null client_id\n", __func__);
+		return -EIO;
+	}
+
+	padev->client_id = ci;
+	padev->event_handler = padrv->event_handler;
+
+	return 0;
+}
+
+/**
+ * pds_client_unregister - Disconnect the client from the device
+ * @padev:  ptr to the client device info
+ *
+ * Disconnect the client from the core and with the DSC.
+ */
+static int pds_client_unregister(struct pds_auxiliary_dev *padev)
+{
+	union pds_core_adminq_comp comp = { 0 };
+	union pds_core_adminq_cmd cmd = { 0 };
+	struct device *dev;
+	struct pdsc *pdsc;
+	int err;
+
+	pdsc = (struct pdsc *)dev_get_drvdata(padev->aux_dev.dev.parent);
+	dev = pdsc->dev;
+
+	if (pdsc->state)
+		return -ENXIO;
+
+	cmd.client_unreg.opcode = PDS_AQ_CMD_CLIENT_UNREG;
+	cmd.client_unreg.client_id = cpu_to_le16(padev->client_id);
+
+	err = pdsc_adminq_post(pdsc, &pdsc->adminqcq, &cmd, &comp, false);
+	if (err)
+		dev_info(dev, "unregister dev_name %s failed, status %d: %pe\n",
+			 dev_name(&padev->aux_dev.dev), comp.status, ERR_PTR(err));
+
+	padev->client_id = 0;
+
+	return err;
+}
+
+/**
+ * pds_client_adminq_cmd - Process an adminq request for the client
+ * @padev:   ptr to the client device
+ * @req:     ptr to buffer with request
+ * @req_len: length of actual struct used for request
+ * @resp:    ptr to buffer where answer is to be copied
+ * @flags:   optional flags from pds_core_adminq_flags
+ *
+ * Return: 0 on success, or
+ *         negative for error
+ *
+ * Client sends pointers to request and response buffers
+ * Core copies request data into pds_core_client_request_cmd
+ * Core sets other fields as needed
+ * Core posts to AdminQ
+ * Core copies completion data into response buffer
+ */
+static int pds_client_adminq_cmd(struct pds_auxiliary_dev *padev,
+				 union pds_core_adminq_cmd *req,
+				 size_t req_len,
+				 union pds_core_adminq_comp *resp,
+				 u64 flags)
+{
+	union pds_core_adminq_cmd cmd = { 0 };
+	struct device *dev;
+	struct pdsc *pdsc;
+	size_t cp_len;
+	int err;
+
+	pdsc = (struct pdsc *)dev_get_drvdata(padev->aux_dev.dev.parent);
+	dev = pdsc->dev;
+
+	dev_dbg(dev, "%s: %s opcode %d\n",
+		__func__, dev_name(&padev->aux_dev.dev), req->opcode);
+
+	if (pdsc->state)
+		return -ENXIO;
+
+	/* Wrap the client's request */
+	cmd.client_request.opcode = PDS_AQ_CMD_CLIENT_CMD;
+	cmd.client_request.client_id = cpu_to_le16(padev->client_id);
+	cp_len = min_t(size_t, req_len, sizeof(cmd.client_request.client_cmd));
+	memcpy(cmd.client_request.client_cmd, req, cp_len);
+
+	err = pdsc_adminq_post(pdsc, &pdsc->adminqcq, &cmd, resp, !!(flags & PDS_AQ_FLAG_FASTPOLL));
+	if (err && err != -EAGAIN)
+		dev_info(dev, "client admin cmd failed: %pe\n", ERR_PTR(err));
+
+	return err;
+}
+
+static struct pds_core_ops pds_core_ops = {
+	.register_client = pds_client_register,
+	.unregister_client = pds_client_unregister,
+	.adminq_cmd = pds_client_adminq_cmd,
+};
+
 static void pdsc_auxbus_dev_release(struct device *dev)
 {
 	struct pds_auxiliary_dev *padev =
@@ -21,7 +159,8 @@ static void pdsc_auxbus_dev_release(struct device *dev)
 
 static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *pdsc,
 							  char *name, u32 id,
-							  struct pci_dev *client_dev)
+							  struct pci_dev *client_dev,
+							  struct pds_core_ops *ops)
 {
 	struct auxiliary_device *aux_dev;
 	struct pds_auxiliary_dev *padev;
@@ -31,6 +170,7 @@ static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *pdsc,
 	if (!padev)
 		return NULL;
 
+	padev->ops = ops;
 	padev->pcidev = client_dev;
 
 	aux_dev = &padev->aux_dev;
@@ -96,7 +236,7 @@ int pdsc_auxbus_dev_add_vf(struct pdsc *pdsc, int vf_id)
 		id = PCI_DEVID(pdsc->pdev->bus->number,
 			       pci_iov_virtfn_devfn(pdsc->pdev, vf_id));
 		padev = pdsc_auxbus_dev_register(pdsc, pdsc->viftype_status[vt].name, id,
-						 pdsc->pdev);
+						 pdsc->pdev, &pds_core_ops);
 		pdsc->vfs[vf_id].padev = padev;
 
 		/* We only support a single type per VF, so jump out here */
diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
index 737fd4dbbf5a..9d71ef523c35 100644
--- a/include/linux/pds/pds_auxbus.h
+++ b/include/linux/pds/pds_auxbus.h
@@ -25,6 +25,7 @@ struct pds_auxiliary_drv {
 
 struct pds_auxiliary_dev {
 	struct auxiliary_device aux_dev;
+	struct pds_core_ops *ops;
 	struct pci_dev *pcidev;
 	u32 id;
 	u16 client_id;
@@ -32,4 +33,53 @@ struct pds_auxiliary_dev {
 			      union pds_core_notifyq_comp *event);
 	void *priv;
 };
+
+struct pds_fw_state {
+	unsigned long last_fw_time;
+	u32 fw_heartbeat;
+	u8  fw_status;
+};
+
+/*
+ *   ptrs to functions to be used by the client for core services
+ */
+struct pds_core_ops {
+	/* .register() - register the client with the device
+	 * padev:  ptr to the client device info
+	 * padrv:  ptr to the client driver info
+	 * Register the client with the core and with the DSC.  The core
+	 * will fill in the client padrv->client_id for use in calls
+	 * to the DSC AdminQ
+	 */
+	int (*register_client)(struct pds_auxiliary_dev *padev,
+			       struct pds_auxiliary_drv *padrv);
+
+	/* .unregister() - disconnect the client from the device
+	 * padev:  ptr to the client device info
+	 * Disconnect the client from the core and with the DSC.
+	 */
+	int (*unregister_client)(struct pds_auxiliary_dev *padev);
+
+	/* .adminq_cmd() - process an adminq request for the client
+	 * padev:  ptr to the client device
+	 * req:     ptr to buffer with request
+	 * req_len: length of actual struct used for request
+	 * resp:    ptr to buffer where answer is to be copied
+	 * flags:   optional flags defined by enum pds_core_adminq_flags
+	 *	    and used for more flexible adminq behvior
+	 *
+	 * returns 0 on success, or
+	 *         negative for error
+	 * Client sends pointers to request and response buffers
+	 * Core copies request data into pds_core_client_request_cmd
+	 * Core sets other fields as needed
+	 * Core posts to AdminQ
+	 * Core copies completion data into response buffer
+	 */
+	int (*adminq_cmd)(struct pds_auxiliary_dev *padev,
+			  union pds_core_adminq_cmd *req,
+			  size_t req_len,
+			  union pds_core_adminq_comp *resp,
+			  u64 flags);
+};
 #endif /* _PDSC_AUXBUS_H_ */
-- 
2.17.1

