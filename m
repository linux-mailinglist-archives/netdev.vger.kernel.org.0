Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C9E6E55EE
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjDRAdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjDRAda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:33:30 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6AF55BF
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 17:33:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7McZ5zwrVSFjknxjeDckoDgRciGJfoRK7Maa/NwU4jq7QMW9cmrD17CKgKtq16VejNaWMqjxD212/YXk2/JiEizsEHqxQ9PFDQ/XPp5pel99AV/vfPOTPxN+dLE2sswiIie4C8L4nM6Ar7N+E5NaUs0mp/p/sI360VHidfFjS/4nMnq74s1i4sJW7gO/jxprYnSHyfnXcWhmPM27deb2A4cSQ/oxqokRFGmrRg2dDpQ3f6zQkFgqaRBieSwLtFs/wtoKAdAq0O8/+C3IYJrJY9QA/uUANFM250MsFMnyK9O3JfXU3mpkkVseUBwO2db3sbOLrMnXWxj98bYVIO5yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ht7+72sEhm4At5sv19DZf+v+Gine7+1/7nmH42VqwiE=;
 b=YSuoIVDcMOPDHbWa517Aq0H/765EN55P1I54+ssZetS2W3SPzuUF7B1fSw/Vm3Ezgz/txlLrzWfoJXy54ea2I9BtcQ4xzFDFEMd0uQIY9jTWYBqd03jC3/iGDBYi4h0RYsIiwU7ynvU8TsYEvjKzTilfYyokD8b/SzI1lLNoJFjWHxWub5rdLG9lDdbSgPxvP+DKz55jtgq7/sZIeuhAY+zRizpT7puze8Gj+9Gn/Mg2Ay043EDc5GMvtLnHZsQPUYy9+QZ9EVmJF+0wuaGduJY/wKTLNAbA6XjazxdmSBavksY0MPhU5jjagIO+PuEqrfWADmk77aHZ/o35di/asg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ht7+72sEhm4At5sv19DZf+v+Gine7+1/7nmH42VqwiE=;
 b=BL+1ZjsiLNVgpMxd+myRjBiMH0oLnLrKGC7mgQjVGtLTWWqGEDiFlBiw4YGyguVvjNzStk59PPYu6x/0W9gQDq8H5NwJeqKYPUAGXFcCllW+3UVOTO40kfpqOqoFRh8qD7R//tp5JGdUgF09TxirI3MR+5LrfhKTocw5nQQKpf4=
Received: from BN9PR03CA0137.namprd03.prod.outlook.com (2603:10b6:408:fe::22)
 by SJ2PR12MB8183.namprd12.prod.outlook.com (2603:10b6:a03:4f4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 00:33:07 +0000
Received: from BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::5f) by BN9PR03CA0137.outlook.office365.com
 (2603:10b6:408:fe::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Tue, 18 Apr 2023 00:33:07 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT075.mail.protection.outlook.com (10.13.176.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 00:33:07 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 17 Apr
 2023 19:33:04 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v10 net-next 12/14] pds_core: add the aux client API
Date:   Mon, 17 Apr 2023 17:32:26 -0700
Message-ID: <20230418003228.28234-13-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230418003228.28234-1-shannon.nelson@amd.com>
References: <20230418003228.28234-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT075:EE_|SJ2PR12MB8183:EE_
X-MS-Office365-Filtering-Correlation-Id: 40439558-6868-4194-12bc-08db3fa47b35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ujS8SSg7efmvHqwP/zvpfOKHhjZXetOwGQWE/TQqYM/0RWV83UCj8Mke9RytHkJTnvojiFKtM+zpypOGgR74Sp5BvYtqlW5FYaIHBbRFdhoZSxSLCH5UpJec8LBx5rlp84WzuZLTqz84LeEGtxqb3l/OY6KxcDZTouPMQtPGbjwCYKPKPDWdCq0jhPrSr5zSN8KTkeTfwQqx8e3Nmkv+Se/S92YFZBzgwrX5y7XiWyGssh3sHy4LgbGBrWC8Hg5qwYbNittBxq8j0UKc50fmKLdb7Ujins15Eon8+DdUgK+kM8WjR6QyiSPvFrKhvDTQfoSgjH0Xz2qJy8XZLHoK/HwBLgcr4iO6I4Hfpx0Z7vYM4Obam4FtmZhZyY+gj0hw44ISAv08ksB2K1Xxi1B8Z9qZm1eAjrBGo9kS1xBPwubx/ZHWm9EToTK+EIKED+gsYqZmcJTMDr0g3BNZ5AShvdgAsjVtvYdftWtrM9nP6tbrY+2FtXB1Vu4tEvlm89/i83AFP1VtIuo0HT7sWNwy62G6JQaSGEEv3ZegEmA7rnYViwgYEljH+2//H+H/iCUaq94ZMc28BpDaZaXnwP7MFIItdhi1wqlYvLmdGPHZM7NdD4RT4pzbN5euTlkC3l7E6LVFrWhO5GmaIaizdiMWZPHIbS11lK9BGCCjrZ3E2iS5+ahjdYz7DH6KgPTTaX+zKjCxULVLtjq5XzxY4VcXfXSDrYZGDmjhYlCv/PTydvM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199021)(46966006)(36840700001)(40470700004)(478600001)(6666004)(8936002)(8676002)(316002)(41300700001)(82740400003)(4326008)(70586007)(70206006)(40480700001)(81166007)(54906003)(110136005)(356005)(40460700003)(16526019)(186003)(2906002)(1076003)(336012)(426003)(26005)(86362001)(83380400001)(36756003)(47076005)(63350400001)(82310400005)(63370400001)(2616005)(36860700001)(5660300002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 00:33:07.7006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40439558-6868-4194-12bc-08db3fa47b35
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8183
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the client API operations for running adminq commands.
The core registers the client with the FW, then the client
has a context for requesting adminq services.  We expect
to add additional operations for other clients, including
requesting additional private adminqs and IRQs, but don't have
the need yet.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/auxbus.c | 151 ++++++++++++++++++++-
 include/linux/pds/pds_auxbus.h             |   6 +
 include/linux/pds/pds_common.h             |   2 +
 3 files changed, 158 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index adee516b3f0c..0cf77a7eb94b 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -6,6 +6,136 @@
 #include "core.h"
 #include <linux/pds/pds_auxbus.h>
 
+/**
+ * pds_client_register - Link the client to the firmware
+ * @pf_pdev:	ptr to the PF driver struct
+ * @devname:	name that includes service into, e.g. pds_core.vDPA
+ *
+ * Return: 0 on success, or
+ *         negative for error
+ */
+int pds_client_register(struct pci_dev *pf_pdev, char *devname)
+{
+	union pds_core_adminq_comp comp = {};
+	union pds_core_adminq_cmd cmd = {};
+	struct pdsc *pf;
+	int err;
+	u16 ci;
+
+	pf = pci_get_drvdata(pf_pdev);
+	if (pf->state)
+		return -ENXIO;
+
+	cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
+	strncpy(cmd.client_reg.devname, devname,
+		sizeof(cmd.client_reg.devname));
+
+	err = pdsc_adminq_post(pf, &cmd, &comp, false);
+	if (err) {
+		dev_info(pf->dev, "register dev_name %s with DSC failed, status %d: %pe\n",
+			 devname, comp.status, ERR_PTR(err));
+		return err;
+	}
+
+	ci = le16_to_cpu(comp.client_reg.client_id);
+	if (!ci) {
+		dev_err(pf->dev, "%s: device returned null client_id\n",
+			__func__);
+		return -EIO;
+	}
+
+	dev_dbg(pf->dev, "%s: device returned client_id %d for %s\n",
+		__func__, ci, devname);
+
+	return ci;
+}
+EXPORT_SYMBOL_GPL(pds_client_register);
+
+/**
+ * pds_client_unregister - Unlink the client from the firmware
+ * @pf_pdev:	ptr to the PF driver struct
+ * @client_id:	id returned from pds_client_register()
+ *
+ * Return: 0 on success, or
+ *         negative for error
+ */
+int pds_client_unregister(struct pci_dev *pf_pdev, u16 client_id)
+{
+	union pds_core_adminq_comp comp = {};
+	union pds_core_adminq_cmd cmd = {};
+	struct pdsc *pf;
+	int err;
+
+	pf = pci_get_drvdata(pf_pdev);
+	if (pf->state)
+		return -ENXIO;
+
+	cmd.client_unreg.opcode = PDS_AQ_CMD_CLIENT_UNREG;
+	cmd.client_unreg.client_id = cpu_to_le16(client_id);
+
+	err = pdsc_adminq_post(pf, &cmd, &comp, false);
+	if (err)
+		dev_info(pf->dev, "unregister client_id %d failed, status %d: %pe\n",
+			 client_id, comp.status, ERR_PTR(err));
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(pds_client_unregister);
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
+int pds_client_adminq_cmd(struct pds_auxiliary_dev *padev,
+			  union pds_core_adminq_cmd *req,
+			  size_t req_len,
+			  union pds_core_adminq_comp *resp,
+			  u64 flags)
+{
+	union pds_core_adminq_cmd cmd = {};
+	struct pci_dev *pf_pdev;
+	struct pdsc *pf;
+	size_t cp_len;
+	int err;
+
+	pf_pdev = pci_physfn(padev->vf_pdev);
+	pf = pci_get_drvdata(pf_pdev);
+
+	dev_dbg(pf->dev, "%s: %s opcode %d\n",
+		__func__, dev_name(&padev->aux_dev.dev), req->opcode);
+
+	if (pf->state)
+		return -ENXIO;
+
+	/* Wrap the client's request */
+	cmd.client_request.opcode = PDS_AQ_CMD_CLIENT_CMD;
+	cmd.client_request.client_id = cpu_to_le16(padev->client_id);
+	cp_len = min_t(size_t, req_len, sizeof(cmd.client_request.client_cmd));
+	memcpy(cmd.client_request.client_cmd, req, cp_len);
+
+	err = pdsc_adminq_post(pf, &cmd, resp,
+			       !!(flags & PDS_AQ_FLAG_FASTPOLL));
+	if (err && err != -EAGAIN)
+		dev_info(pf->dev, "client admin cmd failed: %pe\n",
+			 ERR_PTR(err));
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(pds_client_adminq_cmd);
+
 static void pdsc_auxbus_dev_release(struct device *dev)
 {
 	struct pds_auxiliary_dev *padev =
@@ -16,6 +146,7 @@ static void pdsc_auxbus_dev_release(struct device *dev)
 
 static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *cf,
 							  struct pdsc *pf,
+							  u16 client_id,
 							  char *name)
 {
 	struct auxiliary_device *aux_dev;
@@ -27,6 +158,7 @@ static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *cf,
 		return ERR_PTR(-ENOMEM);
 
 	padev->vf_pdev = cf->pdev;
+	padev->client_id = client_id;
 
 	aux_dev = &padev->aux_dev;
 	aux_dev->name = name;
@@ -66,8 +198,10 @@ int pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf)
 
 	padev = pf->vfs[cf->vf_id].padev;
 	if (padev) {
+		pds_client_unregister(pf->pdev, padev->client_id);
 		auxiliary_device_delete(&padev->aux_dev);
 		auxiliary_device_uninit(&padev->aux_dev);
+		padev->client_id = 0;
 	}
 	pf->vfs[cf->vf_id].padev = NULL;
 
@@ -79,7 +213,9 @@ int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf)
 {
 	struct pds_auxiliary_dev *padev;
 	enum pds_core_vif_types vt;
+	char devname[PDS_DEVNAME_LEN];
 	u16 vt_support;
+	int client_id;
 	int err = 0;
 
 	mutex_lock(&pf->config_lock);
@@ -101,9 +237,22 @@ int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf)
 	      pf->viftype_status[vt].enabled))
 		goto out_unlock;
 
-	padev = pdsc_auxbus_dev_register(cf, pf,
+	/* Need to register with FW and get the client_id before
+	 * creating the aux device so that the aux client can run
+	 * adminq commands as part its probe
+	 */
+	snprintf(devname, sizeof(devname), "%s.%s.%d",
+		 PDS_CORE_DRV_NAME, pf->viftype_status[vt].name, cf->uid);
+	client_id = pds_client_register(pf->pdev, devname);
+	if (client_id < 0) {
+		err = client_id;
+		goto out_unlock;
+	}
+
+	padev = pdsc_auxbus_dev_register(cf, pf, client_id,
 					 pf->viftype_status[vt].name);
 	if (IS_ERR(padev)) {
+		pds_client_unregister(pf->pdev, client_id);
 		err = PTR_ERR(padev);
 		goto out_unlock;
 	}
diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
index 493f75b1995e..214ef12302d0 100644
--- a/include/linux/pds/pds_auxbus.h
+++ b/include/linux/pds/pds_auxbus.h
@@ -11,4 +11,10 @@ struct pds_auxiliary_dev {
 	struct pci_dev *vf_pdev;
 	u16 client_id;
 };
+
+int pds_client_adminq_cmd(struct pds_auxiliary_dev *padev,
+			  union pds_core_adminq_cmd *req,
+			  size_t req_len,
+			  union pds_core_adminq_comp *resp,
+			  u64 flags);
 #endif /* _PDSC_AUXBUS_H_ */
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 961b3d02c69f..4b37675fde3e 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -61,4 +61,6 @@ enum pds_core_logical_qtype {
 };
 
 void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
+int pds_client_register(struct pci_dev *pf_pdev, char *devname);
+int pds_client_unregister(struct pci_dev *pf_pdev, u16 client_id);
 #endif /* _PDS_COMMON_H_ */
-- 
2.17.1

