Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD856E8019
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbjDSRFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbjDSRFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:05:37 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2042.outbound.protection.outlook.com [40.107.95.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940EB7D82
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:05:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNFbtZT8TCXS7dblkuczCMggC9tmxpKXReZOUgw9hKcHC2de5QsmgtkWScLWU2QFDI3aqKd75mY0VaN+WXsG8GZiKd3DHuhYiSwB5nNIKvxx2Y52+s/EfbPhyeuV5hwVDee8VCSynPHBhMFQ7Qg8WaVjhWZlEr5WT9J8GfX5dZmiyODjpoZgEmxbRMJJZL8ns+hIumucUhI3fmDPKcNSbpuvEx4rvpxNQk2uYXIvUsCAy8v9JDZUCGzr2qCfM82PDSVsU+PBKYr1m7jSgjG80TBssc4R76xby70T2zRBVLw3nD43VDIIChAcuOzj7R1cr0zoUpG5xyGY+1MMyp8Llg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3aPVrDOgi9ydNlsQYcKDPYyaWBaPZfA4esTN4KHwVzs=;
 b=Mf97e2YArrI8gYy9YUGh2pubcbsHsO9HGHkq6bVyX1Z/VWM5FoQvnWKnlf5NIUsLBkNuQDs1KWzCK9NBvtLc1y5I3bq+WtmiMsBToL4saGHl/lKSMRXWZE0SpX4caoWWmY/bKJtofkRBye76elxP5vzAqFWoLQWDBiTJMugF2r7DSclZSRNQlN9Sj7bVsQFtqwKDkexLquj7lj7B4UPsO95I3z2ccHYhP6wwkjKgheA54XjQSQ0gmguP5qCGaOsB9Q1vooy/+A4b2KVIiUqBvkPZ5vNjbVS33UPg2zD1VUHG1oufqgEvWWjbPPkH+frig5NEP9BIfdjCHokZMSiwIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3aPVrDOgi9ydNlsQYcKDPYyaWBaPZfA4esTN4KHwVzs=;
 b=Z2Mks2mZ7UxtIl8xJx/9LCjr4DwDj1D4vaprlCZsoA/OH0q++zsSUKAoI+9wWFIqswQXLLlV1BpJxPGc4MunGwdq8aSrubVMEAz5AOh+4TTjCApWrDqHrM1J+mBCOorCCw/3AIQjiN4JwRCSIwVzqjHpGJKcbv8OHJmLtgr95F8=
Received: from MW4PR03CA0089.namprd03.prod.outlook.com (2603:10b6:303:b6::34)
 by SN7PR12MB6910.namprd12.prod.outlook.com (2603:10b6:806:262::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.21; Wed, 19 Apr
 2023 17:05:33 +0000
Received: from CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::7d) by MW4PR03CA0089.outlook.office365.com
 (2603:10b6:303:b6::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22 via Frontend
 Transport; Wed, 19 Apr 2023 17:05:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT064.mail.protection.outlook.com (10.13.175.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.23 via Frontend Transport; Wed, 19 Apr 2023 17:05:32 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 19 Apr
 2023 12:05:23 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v11 net-next 12/14] pds_core: add the aux client API
Date:   Wed, 19 Apr 2023 10:04:25 -0700
Message-ID: <20230419170427.1108-13-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230419170427.1108-1-shannon.nelson@amd.com>
References: <20230419170427.1108-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT064:EE_|SN7PR12MB6910:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f067853-28f7-4f13-2624-08db40f84909
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q5lXnLda4v1eIgchYPUSqnn+CxOsWGhYzgm7odQPJa8/1YJ8XxsGn/N3d7Hnl5fFxIvXfZulKSJLU/RS1xYcEpnnfrKrE+wkbA8kL9XJRXyqvkufDxE/SLcjY/sXiTznAGVQv9ZPM8ISfwGpHiQRuV08P8mno//0cLk2Pfz9XNXplto8eJLpFRZPyyZ9vnVrSEvETbI21DQKBtFusRPlWS6KGyL84VOxc4UBmJ19hxd6DpzDVqn1qN7l7hUjr+UP/pSmj/0n5zG89Ht+TclCRZP5F8Uo8mJch3qUEjhvrJDEVtFNFKZ97whNY2Jf0zNBeuIyij5eDJqySeaupnwOzYrRTBpipIwJB/Qd9RTSIgum8mZwoTT8Xw5p0j/O8wQ1jRRms0kIHXVDjsLQ/TCKVp1vB1bvDNT6fDxNf+mUZ/QlnzPBiLF5EX20NG5EWidi9F4aaN68yQkfQARUTNZ6xS0B3FOs3Evfx64T3kppdEoQQC0jN0vg+du1XgenDsxxysKOi6WdxsjHL+k6C4zrlfuVb2R4RxqA0I1GDO4ExIplFIK3/7vg0z0o+C4uClK6YvQDpPWuIhWDnXpWOXuzlmoSh9vs/yp2vL1C6x9IrEj89uY3PAGiRQ6NZ+KLxO7eN7pZ/FScOALo1raDPx29JR32J7YY4Y35IkUeJVFoaRmN/eWFonx4gzFHx/1zOjfAr1UtSzfbArB2DqFf62ibWBnGgX7eSRD8oID9sMsFWpQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199021)(36840700001)(46966006)(40470700004)(1076003)(186003)(26005)(16526019)(81166007)(356005)(41300700001)(426003)(336012)(47076005)(36860700001)(2616005)(83380400001)(478600001)(40460700003)(40480700001)(4326008)(82310400005)(44832011)(70586007)(70206006)(316002)(82740400003)(5660300002)(54906003)(110136005)(36756003)(86362001)(2906002)(8676002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 17:05:32.2898
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f067853-28f7-4f13-2624-08db40f84909
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6910
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
index adee516b3f0c..561af8e5b3ea 100644
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
+	strscpy(cmd.client_reg.devname, devname,
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

