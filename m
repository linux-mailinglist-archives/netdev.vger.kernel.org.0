Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAF66D1397
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 01:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjC3Xrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 19:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjC3XrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 19:47:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82D711677
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 16:46:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlqWkbxQQVU8okDcCgIiZpJbvZhjHCaJNkwj4wNpabLj+G2zw58FU0YFcGsAF7ULkvQLR8wG+PGhiCjZkKuS0Qy9WPgbZkJQTH575J5ZwqfVnsGmgcm0Qm0XrCKPRaeVhVq8laEbTY3SUR04hGMuyP0LCQdiZIl0RK+4YVDRKyjtsa2jkHb0jhP1gic8C/+fqp2bQAWFnnudUX58LyvIslxdCj0lU3joNF8fHpmGlVBq2e/6lOKBIHk77442R+kTw7h78Jt1YDZUzVMmQ5F7tKYg2EUfe3W5Akyn6XP7fGhC2byZA1/SIvDm3UBRJKgdknmFI4Z+gG3bbcWuC2pnwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fYqYaSAQfgAsyYYwJBr1zCXTq+klqYJ7t4pyJ4TFbWQ=;
 b=M3bAqlyNgaG8FVPKKwD3J71sR9VpatjWlIx3lo8jVPfcmuuxYdv9x0Cc2Zz0cJf8slXwsCuCpUvjNE5cu4pObSr45m4u3lkzy9Z7PUBDmAaoj5H8BcOJRW5POy3fdBTbdnYSvkJyDfliS2cEGcrFoJM5OHUcZsEgk64qWjsrkfPfEQbMQe5W4R9i8Ur/TpJxxtGEIRfawVm02PLZKIUhK0r/xhyqQ0JYfVFRgyc/al7holzG71bEqLorzWiVn+NZj3Zfb87ekPV+s9kiSXYOfjAYNIGtvwKIsYRS6IBFuolEBGkh8sG2JkekE/gngbYYngoRPJfNt1SsbKHZ0O/ryQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fYqYaSAQfgAsyYYwJBr1zCXTq+klqYJ7t4pyJ4TFbWQ=;
 b=yiIPtPpdB9ldhzJ4OMzDMvofrlVKZwrloO0MKZtNpCn4FAMuRSQKQYs5wXXg2TMNDS0lx4Gg3Sl3talp4fmg0Rlh8++1GMzwkSzy22qldh839mRTqVm+HUceg7Y0/PWo4fBSUD/Wfh+Sf5iMwUsbdjY7fw0nfFLQHch/RIb0ciM=
Received: from MN2PR15CA0033.namprd15.prod.outlook.com (2603:10b6:208:1b4::46)
 by SA1PR12MB6972.namprd12.prod.outlook.com (2603:10b6:806:24f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 23:46:56 +0000
Received: from BL02EPF000100D2.namprd05.prod.outlook.com
 (2603:10b6:208:1b4:cafe::94) by MN2PR15CA0033.outlook.office365.com
 (2603:10b6:208:1b4::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 23:46:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000100D2.mail.protection.outlook.com (10.167.241.206) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Thu, 30 Mar 2023 23:46:55 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 18:46:54 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v8 net-next 12/14] pds_core: add the aux client API
Date:   Thu, 30 Mar 2023 16:46:26 -0700
Message-ID: <20230330234628.14627-13-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330234628.14627-1-shannon.nelson@amd.com>
References: <20230330234628.14627-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000100D2:EE_|SA1PR12MB6972:EE_
X-MS-Office365-Filtering-Correlation-Id: 80dacb3e-5661-471d-3250-08db31790bb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zPRJiZBuRRY3xFGm3czGArw0gF6BXl5aSH55X7XnJryk+TgrkpqsJXL0E0JnuUpgzda23JWKqQJCv0LXn0UMFwMbPhWXsFIB1Do3gbNFFjihkygr8zea4rCAL8odoE7SjTniOSGDSMQExpkYa0vSsxvq2MEc+6Yi2DTb+qYcr8evmLDtK5mgU6Uy/H/JQfcX+RvTGM7pp2wbv28xbRzibn2snx2I4d0zei1qpJEhpvi2+m99QjR63+9gt2/3UXjz15AOTGx4foEhjbYDTaT5W83wakI6oTCoGmdHKLT4m4Qs1eAhVb6du/QMckw33X+Dskotl6QiThzuzx6Vj3Yy9siiA4FGYb4ud9/LLlPLhsYmNgQkqwyUvYqudSkdKmpcHBx3vZExy7lsyQO0KT+piQ/sTDmHdHdl8dMLjGDPl6qj+g6HBLpYJzSP93RMsQfV2l0ibP0jOCo8VkIcPGxK5AcJOsIvXqIHBt0xAASxceVcmfz2ejv66UfL1ISETmmpgPtUEmSLKVbKqIzt4tBKlTodZZQsj+w0vEaQe3igjVd+/Crr4bfMkJkUjBU/Qrpe9QC0/V+9RepxRRT1s+0JraRnihWqriYaP2Mzpffoh+YTUwz1UP8k7CH6GZhbPiQpoyzemuqtCCPhtrUh/u/UI5jJHl2m1WMOe1lO3oeXwDlUywtFp2szq44LPRixBCm3Q8cZ+EJZdyaUThQUVFA1mIPBpmFjBp6g1jaEIIrYjXs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199021)(36840700001)(40470700004)(46966006)(40460700003)(82740400003)(8676002)(70206006)(356005)(41300700001)(70586007)(81166007)(2906002)(36860700001)(36756003)(4326008)(5660300002)(86362001)(478600001)(44832011)(82310400005)(8936002)(40480700001)(110136005)(1076003)(26005)(6666004)(16526019)(54906003)(186003)(316002)(83380400001)(2616005)(47076005)(336012)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:46:55.9816
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80dacb3e-5661-471d-3250-08db31790bb5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000100D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6972
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
---
 drivers/net/ethernet/amd/pds_core/auxbus.c | 135 ++++++++++++++++++++-
 include/linux/pds/pds_auxbus.h             |  28 +++++
 2 files changed, 160 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index 7c6a84009558..fbf60a03fcb6 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -6,6 +6,115 @@
 #include "core.h"
 #include <linux/pds/pds_auxbus.h>
 
+static int pds_client_register(struct pdsc *vf, struct pdsc *pf, char *name)
+{
+	union pds_core_adminq_comp comp = { 0 };
+	union pds_core_adminq_cmd cmd = { 0 };
+	int err;
+	u16 ci;
+
+	if (pf->state)
+		return -ENXIO;
+
+	cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
+	snprintf(cmd.client_reg.devname, sizeof(cmd.client_reg.devname),
+		 "%s.%s.%d", PDS_CORE_DRV_NAME, name, vf->id);
+
+	err = pdsc_adminq_post(pf, &cmd, &comp, false);
+	if (err) {
+		dev_info(pf->dev, "register dev_name %s with DSC failed, status %d: %pe\n",
+			 name, comp.status, ERR_PTR(err));
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
+		__func__, ci, cmd.client_reg.devname);
+
+	return ci;
+}
+
+static int pds_client_unregister(struct pdsc *pf, u16 client_id)
+{
+	union pds_core_adminq_comp comp = { 0 };
+	union pds_core_adminq_cmd cmd = { 0 };
+	int err;
+
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
+	struct pdsc *pf;
+	size_t cp_len;
+	int err;
+
+	pf = pci_get_drvdata(padev->pf_pdev);
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
+
+static struct pds_core_ops pds_core_ops = {
+	.adminq_cmd = pds_client_adminq_cmd,
+};
+
 static void pdsc_auxbus_dev_release(struct device *dev)
 {
 	struct pds_auxiliary_dev *padev =
@@ -16,7 +125,9 @@ static void pdsc_auxbus_dev_release(struct device *dev)
 
 static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *vf,
 							  struct pdsc *pf,
-							  char *name)
+							  u16 client_id,
+							  char *name,
+							  struct pds_core_ops *ops)
 {
 	struct auxiliary_device *aux_dev;
 	struct pds_auxiliary_dev *padev;
@@ -28,6 +139,8 @@ static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *vf,
 
 	padev->vf_pdev = vf->pdev;
 	padev->pf_pdev = pf->pdev;
+	padev->ops = ops;
+	padev->client_id = client_id;
 
 	aux_dev = &padev->aux_dev;
 	aux_dev->name = name;
@@ -77,8 +190,10 @@ int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf)
 
 	padev = pf->vfs[vf->vf_id].padev;
 	if (padev) {
+		pds_client_unregister(pf, padev->client_id);
 		auxiliary_device_delete(&padev->aux_dev);
 		auxiliary_device_uninit(&padev->aux_dev);
+		padev->client_id = 0;
 	}
 	pf->vfs[vf->vf_id].padev = NULL;
 
@@ -91,6 +206,7 @@ int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf)
 {
 	struct pds_auxiliary_dev *padev;
 	enum pds_core_vif_types vt;
+	int client_id;
 	int err = 0;
 
 	mutex_lock(&pf->config_lock);
@@ -124,9 +240,22 @@ int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf)
 		      pf->viftype_status[vt].enabled))
 			continue;
 
-		padev = pdsc_auxbus_dev_register(vf, pf,
-						 pf->viftype_status[vt].name);
+		/* need to register with FW and get the client_id before
+		 * creating the aux device so that the aux client can run
+		 * adminq commands as part its probe
+		 */
+		client_id = pds_client_register(vf, pf,
+						pf->viftype_status[vt].name);
+		if (client_id < 0) {
+			err = client_id;
+			goto out_unlock;
+		}
+
+		padev = pdsc_auxbus_dev_register(vf, pf, client_id,
+						 pf->viftype_status[vt].name,
+						 &pds_core_ops);
 		if (IS_ERR(padev)) {
+			pds_client_unregister(pf, client_id);
 			err = PTR_ERR(padev);
 			goto out_unlock;
 		}
diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
index aa0192af4a29..f98efd578e1c 100644
--- a/include/linux/pds/pds_auxbus.h
+++ b/include/linux/pds/pds_auxbus.h
@@ -10,7 +10,35 @@ struct pds_auxiliary_dev {
 	struct auxiliary_device aux_dev;
 	struct pci_dev *vf_pdev;
 	struct pci_dev *pf_pdev;
+	struct pds_core_ops *ops;
 	u16 client_id;
 	void *priv;
 };
+
+/*
+ *   ptrs to functions to be used by the client for core services
+ */
+struct pds_core_ops {
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

