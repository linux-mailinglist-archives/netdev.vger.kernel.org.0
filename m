Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC55645099
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiLGAqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiLGAp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:45:27 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7999D4EC01
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 16:45:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pr/jUWEtSaU8HMzzacsp9Ma2b+Jy1JJlQaxczL0zR1cffOw7/SHfuMD0ITHB3wPLKhtRMez8q/48n1lihE2nbS94s0/83mv5H3Xv0rTgvGoEIWQpr7YOlWsGdrgMlSDXD/y8yHxfIiYJ7RwC5tqnVaRupJa4+QEImUIhXGz6uP139uKwOAhv2+pglnHeK5r7SEhfFvee4RjzKpdqsoIHXHuZeGmqRADjDtKY1smHFKX49dTE9oQnfo5mCYmcyuFzoE8TsV2ZRYOUqbko5t8pv/gl03na+qaRTlt8kuw/duPGjNfrAKinnhbkXqr2Nmq7luI5EamM1NwsNpPj8Jozhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FkrLBOaHfUn8fFpGADArRA0+DoOAA8xiSN0FgzMn/fs=;
 b=XBaPpD63rsglTlt2u992H6xEQ3R4NjZ96wA8R6Pr7zr9NIKtzMhSplgTZnOwE+khmnzzhgD45RujISF/rcw5/C6E0E+qP/X3YtYOhiycl/P7gAh0xwjDlpNff24D6TlxZrezmC3ad1cxJ/8SlwP1WIagzEdBCGdNJvWEmc2myn7B7XGW21brFK5e0OdiuBpg3WnBOyT8HHUuZVGDHO/G9rDEv7H2iabUrUf8kgd/c+nUEFqqs703YB9NnaC1rWUDdFKdhVbkE6qCAUYljW/Pn99rsebbziLHm9JRtTKa+6MpOK6LeNQsBv16kvW4AenPlD6qjK+1l5SfA+F/HBxtdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkrLBOaHfUn8fFpGADArRA0+DoOAA8xiSN0FgzMn/fs=;
 b=h5ZrHT6OSXyROPVfWKkg+jM9VWyKeqnwlL72rnLUYGmY+PsvCr1Fp3veMr+o5dlD/7AvZU/+I80zblGiuiilDY5axg+SU8N3OmNuUGlLufR0pRCB1fujjSvuk4GVNZnMW7b32CP+1uxLpQLByAtrF32kOxk6Lj7LO5BbZKIO9mQ=
Received: from BN9PR03CA0132.namprd03.prod.outlook.com (2603:10b6:408:fe::17)
 by SN7PR12MB6957.namprd12.prod.outlook.com (2603:10b6:806:263::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Wed, 7 Dec
 2022 00:45:16 +0000
Received: from BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::c4) by BN9PR03CA0132.outlook.office365.com
 (2603:10b6:408:fe::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 00:45:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT073.mail.protection.outlook.com (10.13.177.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 00:45:15 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 18:45:13 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 14/16] pds_core: add the aux client API
Date:   Tue, 6 Dec 2022 16:44:41 -0800
Message-ID: <20221207004443.33779-15-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207004443.33779-1-shannon.nelson@amd.com>
References: <20221207004443.33779-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT073:EE_|SN7PR12MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: 88a809f7-b350-4af8-491e-08dad7ec4eb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 44UW5iN5mz+BIR0bKAxsLhwQJAthXoXQh/WLTTAw1CIxG/Ar7eThS68xeQFtie+ksxJfCiRbZ+fJj/C9uPjHTpURUr+9MyQJ7Y/rrwgCZE5rqOJfICDK/FX0ve6liFtBCW32mSvArSRBsK37kTj+VUe6yn4m8J1aSWAg7L/WNi738islQii91i+aQaILSNtu4eE/bJKNRaa9ABiHddISuuRRPMb6DlTuQa6RG93+icVoe0PJJ8RfgG33UA0zi3tTnDvwTYkjDf7mhnUeB98+P6zU/bVLHD3GCzflySoX9CUB0NAtfwq1Hzrgvsudmy5NCZzmvuGW4cfnlF+sN7/EKLeBA6q/gY+Et0rLEwkyLLswg+B3srWzNwvECx43PzPFKiH6kZx4yRf3UdoUgcGf3BAi8eMC4WcwiGDlffau+WXCuaWmL9ZBMpaCcl4T2OmBmsYSYuIStWax5D6cIuorLAYuDC33J9c3wva6RcwD/Blkm5NJJNxRZBEPNTCfDLbAZUbEJOe6KIH4mw0Ie2QTGkgUnIF9C59YDrq8utdp1UMUN31uDVKH6e9WqoyuPFVvPN4M7fomWqP/3H36wpJOwu3MQxmydhOrxy0l5ELHfd1jKgEymjjUi+nQm9j5YfTWb8TT69crxtnv2Mx6/LaMK4K0vHR+TYYymPkzkziE2rmtDg3xCxolrCKkW2wene4p2Sdx4jIsh18fwYff42v+kH2RzBL3+lbdWwJXOpVZx6o=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(36840700001)(40470700004)(46966006)(36860700001)(2906002)(83380400001)(36756003)(336012)(40480700001)(16526019)(186003)(1076003)(41300700001)(70586007)(70206006)(86362001)(40460700003)(26005)(82740400003)(356005)(81166007)(110136005)(82310400005)(426003)(8676002)(2616005)(316002)(4326008)(44832011)(8936002)(6666004)(54906003)(5660300002)(478600001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 00:45:15.8766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a809f7-b350-4af8-491e-08dad7ec4eb7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6957
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 .../net/ethernet/pensando/pds_core/auxbus.c   | 144 +++++++++++++++++-
 include/linux/pds/pds_auxbus.h                |  51 +++++++
 2 files changed, 193 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/pds_core/auxbus.c b/drivers/net/ethernet/pensando/pds_core/auxbus.c
index 331944a4d1a0..e82f4e2ef458 100644
--- a/drivers/net/ethernet/pensando/pds_core/auxbus.c
+++ b/drivers/net/ethernet/pensando/pds_core/auxbus.c
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
index 7ad66d726b01..ac121b44c71a 100644
--- a/include/linux/pds/pds_auxbus.h
+++ b/include/linux/pds/pds_auxbus.h
@@ -27,6 +27,7 @@ struct pds_auxiliary_drv {
 
 struct pds_auxiliary_dev {
 	struct auxiliary_device aux_dev;
+	struct pds_core_ops *ops;
 	struct pci_dev *pcidev;
 	u32 id;
 	u16 client_id;
@@ -34,4 +35,54 @@ struct pds_auxiliary_dev {
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
+
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

