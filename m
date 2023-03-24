Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5F96C8588
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjCXTD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjCXTD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:03:26 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7D41B563
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:03:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2N1Gf7SYSE45NwyBVOpJ3BS+rxnxFuenE+xrR7Yb1J5y8KnQobrVncyRxDJGkM//JBALTAPPWBNEL5o627Of4GIv9CVt4lB0qFzjYer6drJxwX5gfg5JwWi+0DOMfArlzdh8tjXFA3afHKIgWmCK2BAomp2IsoWhiN+IkEM4xi+4hNzafweJlNixL7ZlPceOIAPpMyz3qb0mGGu8MrFPfddAQX2h6n0nw459cVtQkxjD1YJUK5E+K/jjw3vwKcntlvISDXHovVH5aJRr3vqCMy0aNXTZjvst71WQoHYDX6YItgF96X69SiY4M2Dk4fnRHKKI88EfPMXwxFPjVFN7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p1WldjbPuxUCrf+0oriBcxdplJsyKWQ4PelOp1drGz8=;
 b=MG72p5RzcVrLzL5DAXW20TBUKM9oBFXas4CkKMqLv5w6DqUiezV2B7hiA3H+cn7ThbsErJdWhdBN7swI1+NaBkoYFGo1EraTToslQb5HA94JGn8mCN5wvAU1n6+ctXCXFaNG8CL8sOvQvfT/QC+yg3qxbMLP6Uqdj6kTGRJ1KjEqfWAqjHVlTqj1cdzPlvwH7PQGUwVT7Kg8205S/pF9DletuANeeOvXTo+ahRaaqDWfvBn1gH+oCEmMngkX5XpEhnW6jmcdavZ5kSLWkwOulRBedOhncEoT4++A7Sr83XV3BKJ5HzLmzg9kCOrY6lRUbIoTkhp6KuQoZRyf2/C45g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p1WldjbPuxUCrf+0oriBcxdplJsyKWQ4PelOp1drGz8=;
 b=SrY5TXqkRjJA1NlTR22cz+onck80wz96vpO8dMygbzZTia2G4Jb7hTVgaqfuZcDEafjyb1RwU4aPnLAeCPyxrQ+pJKVrdEfwEUL5cWE0xYkweEqtGj8weqVHX4tjc9AIIpPjtLsyANuJ3GZuvujpChqarpF0ozFCCcOtZLbHqgs=
Received: from DM6PR17CA0014.namprd17.prod.outlook.com (2603:10b6:5:1b3::27)
 by SA0PR12MB4350.namprd12.prod.outlook.com (2603:10b6:806:92::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 19:03:17 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3::4) by DM6PR17CA0014.outlook.office365.com
 (2603:10b6:5:1b3::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Fri, 24 Mar 2023 19:03:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.9 via Frontend Transport; Fri, 24 Mar 2023 19:03:16 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 24 Mar
 2023 14:03:15 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v6 net-next 12/14] pds_core: add the aux client API
Date:   Fri, 24 Mar 2023 12:02:41 -0700
Message-ID: <20230324190243.27722-13-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230324190243.27722-1-shannon.nelson@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT035:EE_|SA0PR12MB4350:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b63cbb6-2599-4e82-2a2d-08db2c9a6d02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xrXXW0gd9QV2MS1eDHVcWuyQ3R0RBW7JMyZIhTOLjPfZaOlmoIilXOgxp6r+wYe8s6qfHT6PzGJJj3YLgNhczzkQnTt9z5SuPsr0ROmKmXqDTJ0af/A1WAw+4Vvf00ZLt6NZZUugs85t5Z+0kUOMHy8+1fP/jacyfhFN1Sudluih/p2tx0LiPlT0WREtPqJ+zibXbirhKH96zByxqMylqAg00sH/DEwrG+j/lFjY64XXn5boLA/9zth/oCNipVS5soPq155xknz/d4MQmnlZs2FFLicXlwJsPHXB/3MAnT8MtKOz0vb8Fj9/leDeBreVQdpMJQ9raxkyF1Lusz+Zj52i/OO6mK+QkA/DL1w0W+uWnOAL3oF5zMDXxEZRykkIQXGi891wEjFKDmC/dvefXqqtfa4+G+seijUaw5iVX0P9wbkhlsQKA1Q+XRROQVliqNbMcq0MbY6Zys/9OX/+bAfUlP++BdzJsUiCHY5AUBUE+ke4sWEpei5tDpY3oojQCuuHrLy6oDxETBROJZQV7iIX20Ih/3kmFUW+QUctKLd18CjdwyE72m8J8RmhLIkK76soEq3/ny4VJI0z+4EHZvHPXwN2qvqBau9ak2i57qX+KKV7BbZr8m12BIF0LJbBKdxmBbtoB39bnll4IbM6fHMiCVPb6qSjVTImsmqOZxfoI3FzvcXd4sg2+YsZmgrTzU9QYQ4g5Weqo+/zCB21Amv1AuWWUW3/0t6T2svRKcg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199021)(46966006)(40470700004)(36840700001)(2906002)(356005)(40480700001)(4326008)(426003)(70586007)(83380400001)(54906003)(41300700001)(5660300002)(36860700001)(6666004)(81166007)(82740400003)(70206006)(110136005)(8936002)(1076003)(26005)(16526019)(44832011)(47076005)(478600001)(40460700003)(82310400005)(36756003)(8676002)(86362001)(316002)(2616005)(336012)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 19:03:16.7720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b63cbb6-2599-4e82-2a2d-08db2c9a6d02
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4350
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
the need yet,

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

