Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CA26DA638
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 01:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjDFXm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 19:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238738AbjDFXmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 19:42:32 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2084.outbound.protection.outlook.com [40.107.96.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C226CA271
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 16:42:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HbhInPR8jH5Fq+7f+eNdA2oP3nU2NLoMf7YVSJPcZ/q9qQ5KZRb6wE6jMjBF/wfHObcWFT1CrOUurzJ1ME6Ia2XxUWy1p+5q9mHAclqGfm5b9msvhPI3f0QUR9gj75UOY/6m9JlxQ2+dIJNxDgG34PbM3FXgJD7GkmM+ESYdCvRYDJUD2FqVzuP0i6dQR4fcG0FJwe0szABi/iT/TtW94XccRCLZ1oQu2iJBvENcf6DAcXFrxpTNZSWYp1FZ7nxlmm8JSlFUjA72ZAqviJ3/Dh+vQ/O8hkqVfnfAJynlVfI8ZjLAYMQVjOM1wTbiSLPI5vlBRAyqq9VDuwt/NEt0zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=861hfToN/R/vjXq6tiUD0B15PItQJrizxBEPWYhqLK8=;
 b=mmUiH5WjaAWGHOjbxpWnpebdJLzTTzGTQgES2hsBlbhlLg76J+LzQUP8LSBMTmzv3vimxUVgUN+E9ojCkrCOewthVCPu6noKs4lbVPcxZwIJNZk85MD7e2XvF/MdXe39zMA4o/vU+YMbnNkk99KMThRlQfmOAs6wpDkkO8LK236X0uHQLSUzuP5KZvC17roDtxhi4jjtnF7L84Mgf97gcrrWD9fMnrZT8BzeX8hLZ4VqjCmeMzpdEkH9+iKc6bVkBTosF61jd0ovVfJAyLvGejG/EbCG4EmMoyxrR9ufyl5zkumxphMME3blVXCDzk3LxR4JghbVcZw0h6wB0T5ukw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=861hfToN/R/vjXq6tiUD0B15PItQJrizxBEPWYhqLK8=;
 b=JDgFGe62QSR/GD9tXLUXtBN4g/BzeVGS94t7yb9OQQKEU39Uv6vcAVfFHmHEuy5YTPBxRaNau+Wh69eCiAOZIVq0BMIZLU1OC8LCj6sH1DdqXRf8ixdWqfll7g9e4tK0qP0IvQtb8rUULf9ZkG9QsNKkee9bXF2ayyGda+jjc0A=
Received: from DM5PR07CA0091.namprd07.prod.outlook.com (2603:10b6:4:ae::20) by
 PH0PR12MB7080.namprd12.prod.outlook.com (2603:10b6:510:21d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Thu, 6 Apr
 2023 23:42:28 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::ee) by DM5PR07CA0091.outlook.office365.com
 (2603:10b6:4:ae::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Thu, 6 Apr 2023 23:42:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.19 via Frontend Transport; Thu, 6 Apr 2023 23:42:27 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 18:42:26 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v9 net-next 12/14] pds_core: add the aux client API
Date:   Thu, 6 Apr 2023 16:41:41 -0700
Message-ID: <20230406234143.11318-13-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230406234143.11318-1-shannon.nelson@amd.com>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT067:EE_|PH0PR12MB7080:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bee5535-3402-44a7-aa9b-08db36f894b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U+1DMUm0ic3YoyK5vW+CApGDhoc98K4Fan1E7fl9lviqvWqSIqXYHp9MCeMB2BEjL+GGlaIxmLWkabi7ZokM4IevHfY0g/HXIvkL3FxPWNH4dWXq9X71lzXt56CGsTXUqZLrTGICLY+oYlgTDWi4xxbWrI+gj3ORYUI4D5umAUdHCa/DVGMqEtA7xa5I3gh+pAm3sDLKfY9e/jDPzIeeza1clKOJQuOLwr5Tubc89JvofcZ2bjOcbO48nWRzzhc0DAzCNvOZ9RfzuKM2z8qlPWpdE83s6DA18IJAIrR3x2pUg9npFx5Rviaxpt5zYMVltYvLWqjt8/qACK7GCSS2+qVhDr3tH1SF4gd7QB8AR7zfG4BPHqfLISNEBKDXnLVRHoUHBc9ydBQAUI9G7kclJuFvU9alPeIQmdamLlSi39NJPQeumIZ613KwxtJqUg1wKIBfGUhFBLb9hgxe5dvwwXaDyajvBHZw71zlYatz9ftOoPc/wWRfU4mhe2wovNx3O/FhZMXiIO5xrGOeHeoy3wh19HeIYQeWqmPiqW7yJEey9vkAUtVlWVo6GHlHpwznT0Jo8PnvDF/zZ6z+H3S8Ou8LLvPpq0d4PjH0CPx9xTJHgiSEOvj2ojZsscfDZFG8UXd4xC2rh2oJKIStT4tRCkH5oiPzurZcQ/jZmfgYJ6VstZP8aehpmGix/PuNCojudB6/DzGzJNF8ty4+ixNNICIW5+ALqOazJOfCSdtemf4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199021)(46966006)(40470700004)(36840700001)(83380400001)(82310400005)(47076005)(6666004)(4326008)(70206006)(70586007)(1076003)(86362001)(8676002)(2906002)(186003)(36860700001)(16526019)(26005)(316002)(478600001)(110136005)(82740400003)(356005)(426003)(336012)(81166007)(41300700001)(40460700003)(54906003)(8936002)(36756003)(44832011)(5660300002)(40480700001)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 23:42:27.6867
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bee5535-3402-44a7-aa9b-08db36f894b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7080
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
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
index 6757a5174eb7..c8c5cc5c9ca6 100644
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
+		 "%s.%s.%d", PDS_CORE_DRV_NAME, name, vf->uid);
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
@@ -67,8 +180,10 @@ int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf)
 
 	padev = pf->vfs[vf->vf_id].padev;
 	if (padev) {
+		pds_client_unregister(pf, padev->client_id);
 		auxiliary_device_delete(&padev->aux_dev);
 		auxiliary_device_uninit(&padev->aux_dev);
+		padev->client_id = 0;
 	}
 	pf->vfs[vf->vf_id].padev = NULL;
 
@@ -80,6 +195,7 @@ int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf)
 {
 	struct pds_auxiliary_dev *padev;
 	enum pds_core_vif_types vt;
+	int client_id;
 	int err = 0;
 
 	mutex_lock(&pf->config_lock);
@@ -94,9 +210,22 @@ int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf)
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

