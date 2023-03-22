Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F3B6C5467
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbjCVS72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjCVS6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:58:10 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3130E67727
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:57:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XF9Fovfm5ISwFe+cPQsImvIKiPykR2jZ1aT9M3GJryHCPNReGA64GWvLFe3MDYBpiDjY4kO8CVqtG4ppS9yPmHQmIJPsthljol1H+galrDTWM3c72FoDKewlzdaVhMahDK7npxuSp8HCXcXX6Jt7MnLUI1udmRLuSNe7LNs/NijoZZAOUFZPAWQB+9ov3tJmcxtzU6/0XjIKw4jzee2a19pcvIrCQ4ov6SRJfXdNJXSYsfkT+9I7Kti2PwYY/vBBXP2h/VX4ilvg4QFvu9DsYbWN9mPxax1vhl9mPPP6USl8U7DLfek4nxeL5NtMT4hsLhojirIFxowbgs+86+oITQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WhdLweeRxTjH1vUTSmjNiDs9tnUlbJO7cl9/8v3Tl+Q=;
 b=P2sJtOZUX2z177YNSGzWRq7usa9dyutHE4pa1awXRY8j9PXQNJRUBE+DTFq7fIKgeYDUc7/HKC29VktKXLdDAYR1RvpXRTMnaSvGkHIK2HqiUTTsPVcnpoJ0OphBNfOyvZ1l0dQ4DKGZ+KZ/Xwm+5eeKcEjKoj9C/C+QCV2MxqRMYUflYxlHKnn+oeIGommAQwI1d7WO82E60JypWuhvjTT5fcy9bu5P4Nzm3Ma9pbOlm5FagNr9lrc9Hsi2tuRUNfF1Admy/5V4IcS3alku6IzSW5q5i+U3Ydl6zJNDUA/UYaMbc6cCggbiUklosJwH3euJhQTtJuGdq+pDYGOS5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhdLweeRxTjH1vUTSmjNiDs9tnUlbJO7cl9/8v3Tl+Q=;
 b=cHZe8fHHft4eEiSsV2J68SJhPKch9kcgkeTBcLb7vobkJwWim37BovP51c36dDbJMpBvtU2n+12uiZsD0YM5hhIysFxDceVfFttNlf872QShfQ+LK02xxvvT3y7cCfUFvPrB1wfLmeHTCCqF5ULriFDFfzY5iXtUw48GRmGEvZ0=
Received: from BN0PR10CA0025.namprd10.prod.outlook.com (2603:10b6:408:143::22)
 by CH2PR12MB4070.namprd12.prod.outlook.com (2603:10b6:610:ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 18:57:00 +0000
Received: from BN8NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:143:cafe::86) by BN0PR10CA0025.outlook.office365.com
 (2603:10b6:408:143::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 18:57:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT111.mail.protection.outlook.com (10.13.177.54) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 18:56:59 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 13:56:54 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v5 net-next 12/14] pds_core: add the aux client API
Date:   Wed, 22 Mar 2023 11:56:24 -0700
Message-ID: <20230322185626.38758-13-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230322185626.38758-1-shannon.nelson@amd.com>
References: <20230322185626.38758-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT111:EE_|CH2PR12MB4070:EE_
X-MS-Office365-Filtering-Correlation-Id: 85dff597-e734-41f8-daa0-08db2b07374f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OZPTI353Wm8Rwv1NVjZOHgW+aNbarkhQcqjaeDy3iaLYg8mipXnc/u1Z0KdnBArH9DSeYrFAvxy5xgITawoaKHDffChrpCno0GdRi/z0HPzYx0N+KNbCQL6q6S0/3NJfpVV+ELDGmwvNdA80aKJxdbVOwdkrXVdSISzdFp3BvY1ryKeITFAwK8zrIbXGUmQiILcDmW9gnBPB5tPNm0imRLhb8c4KxFIn5iuBJqvcnmxk83oT+4Mu1FjDQ+u+DcVRdLdlU2lsAoRu+hdlDbvOb5hkuVe2kk+zeXgwdGE01XbLe9sA0HKopY0/YvZqfXBS9mBBNd8YqS1or9H3ZpN72ibqmzmm6Hi9UZ9yCufNll0vYcP+lcAV0lcsdL/YuKpxa518RrwV80Lc2CzMaqO6smq+hn74NGUlt9Df9X1KFNAFMG7VA8rSe5O0MMqatUoAGZrpw+sEVz8Gk3MSx9A02xkkB8rq9c8z9Pj8erM8rnmUDNKB9hp52GykhWW0sBPVXrinnDR8q9ZyNYU6njIwUBqsalCwESPS9qAX/soLlPLuikVcVepbNyk13HyU6Tx7fUz3okeARvnV+n8wdQHPjgWYxY9wfqfHy0SXfPFHBdqAP3ZRlZWmrHDOSsGVdPJEVEJSUt+iAu+Ht7bcs1DNuqssrzYIao1krM+QuaklZA4GOAxgk6RdMfhmsejY4kRozOkgyq1gqzoWyb1hGqK+XNJ1AonTaPXJCfPAJZEn/Ls=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199018)(40470700004)(46966006)(36840700001)(2616005)(47076005)(83380400001)(426003)(478600001)(82310400005)(186003)(82740400003)(316002)(110136005)(1076003)(16526019)(54906003)(6666004)(4326008)(26005)(40480700001)(336012)(40460700003)(86362001)(8936002)(5660300002)(41300700001)(44832011)(36860700001)(70206006)(356005)(81166007)(2906002)(70586007)(8676002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 18:56:59.3459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85dff597-e734-41f8-daa0-08db2b07374f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4070
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
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
the need yet,

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/auxbus.c | 133 ++++++++++++++++++++-
 include/linux/pds/pds_auxbus.h             |  28 +++++
 2 files changed, 159 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index cb5bc65ca3c2..7dd6d1540260 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -6,6 +6,112 @@
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
+		dev_err(pf->dev, "%s: device returned null client_id\n", __func__);
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
+	err = pdsc_adminq_post(pf, &cmd, resp, !!(flags & PDS_AQ_FLAG_FASTPOLL));
+	if (err && err != -EAGAIN)
+		dev_info(pf->dev, "client admin cmd failed: %pe\n", ERR_PTR(err));
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
@@ -16,7 +122,9 @@ static void pdsc_auxbus_dev_release(struct device *dev)
 
 static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *vf,
 							  struct pdsc *pf,
-							  char *name)
+							  u16 client_id,
+							  char *name,
+							  struct pds_core_ops *ops)
 {
 	struct auxiliary_device *aux_dev;
 	struct pds_auxiliary_dev *padev;
@@ -28,6 +136,8 @@ static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *vf,
 
 	padev->vf_pdev = vf->pdev;
 	padev->pf_pdev = pf->pdev;
+	padev->ops = ops;
+	padev->client_id = client_id;
 
 	aux_dev = &padev->aux_dev;
 	aux_dev->name = name;
@@ -77,6 +187,8 @@ int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf)
 
 	padev = pf->vfs[vf->vf_id].padev;
 	if (padev) {
+		pds_client_unregister(pf, padev->client_id);
+		padev->client_id = 0;
 		auxiliary_device_delete(&padev->aux_dev);
 		auxiliary_device_uninit(&padev->aux_dev);
 	}
@@ -91,6 +203,7 @@ int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf)
 {
 	struct pds_auxiliary_dev *padev;
 	enum pds_core_vif_types vt;
+	int client_id;
 	int err = 0;
 
 	mutex_lock(&pf->config_lock);
@@ -124,7 +237,23 @@ int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf)
 		      pf->viftype_status[vt].enabled))
 			continue;
 
-		padev = pdsc_auxbus_dev_register(vf, pf, pf->viftype_status[vt].name);
+		/* need to register with FW and get the client_id before
+		 * creating the aux device so that the aux client can run
+		 * adminq commands as part its probe
+		 */
+		client_id = pds_client_register(vf, pf, pf->viftype_status[vt].name);
+		if (client_id < 0) {
+			err = client_id;
+			goto out_unlock;
+		}
+
+		padev = pdsc_auxbus_dev_register(vf, pf, client_id,
+						 pf->viftype_status[vt].name,
+						 &pds_core_ops);
+		if (!padev) {
+			pds_client_unregister(pf, client_id);
+			goto out_unlock;
+		}
 		pf->vfs[vf->vf_id].padev = padev;
 
 		/* We only support a single type per VF, so jump out here */
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

