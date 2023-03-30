Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AE36D0EB0
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 21:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbjC3TYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 15:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjC3TXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 15:23:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F544DBDB
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:23:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQGtNZzz/VSimAO9+BGX1U31eifVzpjFCFc5pYpWU/6TwFuOhNbOPabNrSzcxkckQpqUxy/8NyKuWnAXwfRCfIHb1fr2lP2brjvSHxkjgUeN/UhX++3I/WWeyQNyC7pE6gVuOH/PohWfDEbrWwLZbIWIjoZCq2T9Ccy8/2/MflOgW46k8aEw9uoKJgihcnKk+KmWPaDuhRPnLBEwpbeg2ETDVbaxGym9Kd6Q9URe7BJDXf+JUeG/pKV583aw5aF72NdIXGLV5V/ZaZ7rM5Y9PL7u03SFethTWyH22b1wrGr12roEL7/WbGQMtZZtGyBhH8P4eIzuvcisQIImP8hVtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D5Lu+5YFSSsFfL1IP5km8oLg+qOL24uSg02BiNFjkjw=;
 b=T4vnZaaWzRKlzJ3837/GgBZRk+mM+h9i+wfqAOoQQ2m2twkwo73FMz7jvjn9Gdj9N1Idq+sbXcsCWIx7+3w+y+EQm/87JY9q/CsSzsrOPKt6xEWnyBWvVhlDQRcxnWKbIp06pP4gdAdegNNnrKFPoWpKj/dHB4grtonrXXJucZP8GwSHnmaNQISIbJv8VToCON/QlfJsX2g5zxgyhIucOGm9FRWPG+hsaWtsDvAVpTb+XIAkxFoZcwQOqd/3p89dDfxE6jMfrkfcOGXNBUrfURg/QYHJ2JCDsZhWBr8o/eJe3bT5H5bI6hI/hscIHTc1fk7JVsjDUT/dPsrhzSXfIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D5Lu+5YFSSsFfL1IP5km8oLg+qOL24uSg02BiNFjkjw=;
 b=BU4NPHptZZT+YBbZAfXyh95f3TywhQsfT8Glu6GOTn0fEGBUbZHt+aqZ/gwbmNmiv/NDYdvWEtJQ26MdVXj8ITwNEagiAMm6M1r3wxlueM/tUU5zrBY3/yNg7ln0Julne8fzN+5ueSp/nT8hPM0bDVp10sPfX1pkQIezGhOTwJA=
Received: from MW4PR03CA0041.namprd03.prod.outlook.com (2603:10b6:303:8e::16)
 by PH7PR12MB7353.namprd12.prod.outlook.com (2603:10b6:510:20c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 19:23:42 +0000
Received: from CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::c2) by MW4PR03CA0041.outlook.office365.com
 (2603:10b6:303:8e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 19:23:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT114.mail.protection.outlook.com (10.13.174.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.22 via Frontend Transport; Thu, 30 Mar 2023 19:23:41 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 14:23:39 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v7 net-next 12/14] pds_core: add the aux client API
Date:   Thu, 30 Mar 2023 12:23:10 -0700
Message-ID: <20230330192313.62018-13-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330192313.62018-1-shannon.nelson@amd.com>
References: <20230330192313.62018-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT114:EE_|PH7PR12MB7353:EE_
X-MS-Office365-Filtering-Correlation-Id: 61c483e9-3af6-4837-c265-08db31544599
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TMmG04Bt6ZEcu7vdaAdobO01oPUY7tStsRopT6eqP6nmN+mQvCKoUpVjuf3qTLQ897FwzFjg4RDn1Hyi36tCuHb+4iOjxlP4J+cadROKz7ZCDnz6uoaUTKUP0fXlNt7P7CPOGWYcS7CugWnGqynXKX/XVMdD+vvaPEIVP/rssdfPMBQMMaOX5TsdKl1oz3R6LbJshhe9H7imkeKzFd6rp2Sv/I2H3zRTfE6XALF1JNwUc5j97BORUOyXiOV806tUYw1qF16bdsib2wWn6ycWmKkS2Qc68EZX/cu0+qX3IpvUIvSbWarzx7frBMFXKcNfn390gxduBTDls7yUUxIgguWwjfQZTeSp3/VVoLsuwUC+1J8Ws37OAl1GY+Ovhen1XORuxJDlh85A9VN++QrbC7Kms/3045PRwoy3c69+S+49hsq+p2hEdE9/NpVxMNXgfzAqeJYLl/JuxeBVyxYcpoiO16pT4EWOb+aUD6eU/lT6YklanV9x7WXX6xX5znaSskS/usbrDe0LTfWejCJzUAykExGHsdJzPhHDc/d964HAIlhatEDoWTSJ9XYH0yqTgPvs+HDO5eHnwNpEDR2CZfHhNJ1jPA4nkrRmxGSMWzjczNyTNmVp8VGpFUktOpXEUqklUvuwkIHSkqOP1y9nGAq0zXXGbfjKNFE9cUPWyR3WEVpXHLFTvsnfWbh9dXnrrN3dsy7aCv0+W1uBpxQYvrOHONbJQw8bY3uEjZ1/gTs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199021)(40470700004)(36840700001)(46966006)(47076005)(8936002)(40460700003)(356005)(36756003)(81166007)(44832011)(5660300002)(4326008)(86362001)(70206006)(70586007)(41300700001)(82740400003)(82310400005)(40480700001)(8676002)(83380400001)(36860700001)(336012)(2616005)(54906003)(1076003)(426003)(6666004)(2906002)(26005)(186003)(478600001)(16526019)(110136005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 19:23:41.5900
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c483e9-3af6-4837-c265-08db31544599
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7353
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
index 7c6a84009558..2443339f73de 100644
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
@@ -77,6 +190,8 @@ int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf)
 
 	padev = pf->vfs[vf->vf_id].padev;
 	if (padev) {
+		pds_client_unregister(pf, padev->client_id);
+		padev->client_id = 0;
 		auxiliary_device_delete(&padev->aux_dev);
 		auxiliary_device_uninit(&padev->aux_dev);
 	}
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

