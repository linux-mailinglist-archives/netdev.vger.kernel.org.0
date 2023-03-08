Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749B06AFE27
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjCHFOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjCHFNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:13:48 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B91887A04
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:13:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mufDH/1qEHOUVjXTSeLJNBDCccRgjLiJCO9tYmiCtsQnrymNBEkmeKMOJMS/GecBHiVQQNHG1Rlm0I4tchdhRqhQaRL5DfKQ5iogKgINPJF4gYBQQaSqHF1dgMiBMLo2sZGTpvaoDNlHLa5b/ZQi/613ec4wv6CNImMI6WCzEsfxxmLDFyixfMsLHFif3qx80TwejOEMODe6jeTnz5sfY7Jhb36FBJKdLudiUUU5BY6oWcgl8zfME9Cj61+/sel8TPcsHBppOmu4moc5D/ql3nQmY5/w2bo1iV79+Sz/6S89uHIa1Gneo74jGe4OvrmMgzDNK+xn9p6H6f4DGTLp8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQR0eoABuFSsu7J8oJKmqwnIhZaECo//pqLjawx8OX4=;
 b=mX+ihgLaLev4u8oR+wh2JgAQPupYuucVgLHC9ZbZ/pT0SnJj1be790nE4/bfjbDOGuLo/dhdJgaSl3G8ZTyoAvDpRk2QPrAx7nIc5XNo+132OlU+oa1btwv2Sioqjn20dct/0cJtgxWhYkAeE45885wGqQsdkfeVfNnmTPevuZ05v104AEQfyHOdHsYNjbdBsaJmd6meBIiPMMrdLGHOTPYt1yoSOlVeqZ+ktHgjKFpu+EscFsWJSmTyqS3z7Lk5YUq2Fnec88lWhOBa9PjNtYxUWKd8UJlh3HDtDBA8V/y5XRl+Si/weGtd6N1Du7189dEdyOeGrFOM8eldMdx8og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQR0eoABuFSsu7J8oJKmqwnIhZaECo//pqLjawx8OX4=;
 b=mSFJMZK+0f7JSC1iXILLmQgShzEtFOhjpinSwdalszItwj4Ub5MKh0VJWE9Bka6xwEVN6BX7HYy8ZXnBdCFCRd8pbv2S4LdW0VhbbbJU0cnCo7okkLJY4MjhPWknwRCr8rqHgEJETtDCAeFAFX/m6d5xMwkV6FQyjgibV0jr07c=
Received: from BN9P223CA0008.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::13)
 by DM4PR12MB5964.namprd12.prod.outlook.com (2603:10b6:8:6b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Wed, 8 Mar 2023 05:13:44 +0000
Received: from BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::ca) by BN9P223CA0008.outlook.office365.com
 (2603:10b6:408:10b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Wed, 8 Mar 2023 05:13:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT080.mail.protection.outlook.com (10.13.176.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Wed, 8 Mar 2023 05:13:44 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:13:42 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH RFC v4 net-next 11/13] pds_core: add the aux client API
Date:   Tue, 7 Mar 2023 21:13:08 -0800
Message-ID: <20230308051310.12544-12-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230308051310.12544-1-shannon.nelson@amd.com>
References: <20230308051310.12544-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT080:EE_|DM4PR12MB5964:EE_
X-MS-Office365-Filtering-Correlation-Id: cfa0bf80-da38-443a-ceec-08db1f93e393
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f9ZOUw5Lv5PTPYseHYmbxam/qB8KOROC7I0NYTkGJcXBP302V50xNSIF/UrB7JouMjquX6Z3Kp2FXQA/84Wppx3uvbvNWpQQyNsAVJSi+Iq9i5PGLixRP1qjk0w0L3pjvAq8MNpvo6QdMqQf/+4ydEsqAlOnYPi2t34ZwfqvUNZl+UW5/zhOg1Q42WWK0oTyoeMk/dT+SON0k2d+XA591ZTDJWnsWgazb0CKj+nDD5t+Tbbw/Zpip7gAeUdOtN/IQdZdPHA/ZGJ2cRKg8EnUPxUmQ7tL5fmgRPc3iBXixHSF0Cs5OBVGFX4RqaA7zWilIM2hW5bC6VS26yiXWzZ4rhfSEbHohY9B59nPx5ji3cqysjfJpGD2huovh0aLppTq/USZADDUK0v8YF5R+I/ZZPy0zXmGUXgKOemWdVXpawUnIDmcxf/wNDt3xGIfdHawxm4v9V6KqcQpaQqR9Wbntn1bfEpgI6s6Ad4tvv780uYVFjmzuBmb7gqCLYT0TUNueT9QB95P1VckbHCuPl8IJY4kTm6IxVmYXDQ0htvuHX2dUYyCF/mjLDDut/x2hpWc/SULqBBhGWuRCjtpsp+f5WJXuZ2qql4yxbnalSJpJphTrAhRuEHhwn7fOvz/E/u87rpBp6a4Pbfch2lHnaqxlH/ObDdcS8V7isBpMpSeiq5+oP8gxenyDN66irTdHTM/SwFjT57F1A80v+cRy0oImPMvMNmXAM0zEp4Vgcx1Bgk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(36756003)(70586007)(70206006)(41300700001)(4326008)(8676002)(8936002)(1076003)(5660300002)(2906002)(44832011)(86362001)(82740400003)(81166007)(36860700001)(356005)(40480700001)(54906003)(478600001)(6666004)(26005)(110136005)(316002)(47076005)(82310400005)(40460700003)(83380400001)(426003)(2616005)(16526019)(186003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:13:44.1356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfa0bf80-da38-443a-ceec-08db1f93e393
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5964
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/amd/pds_core/auxbus.c | 134 ++++++++++++++++++++-
 include/linux/pds/pds_auxbus.h             |  42 +++++++
 2 files changed, 174 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index 535fee627874..3f0e0bd13184 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -5,6 +5,132 @@
 #include <linux/pds/pds_adminq.h>
 #include <linux/pds/pds_auxbus.h>
 
+/**
+ * pds_client_register - Register the client with the device
+ * @padev:  ptr to the client device info
+ *
+ * Register the client with the core and with the DSC.  The core
+ * will fill in the client padev->client_id for use in calls
+ * to the DSC AdminQ
+ */
+static int pds_client_register(struct pds_auxiliary_dev *padev)
+{
+	union pds_core_adminq_comp comp = { 0 };
+	union pds_core_adminq_cmd cmd = { 0 };
+	struct device *dev = padev->pf->dev;
+	struct pdsc *pf = padev->pf;
+	int err;
+	u16 ci;
+
+	if (pf->state)
+		return -ENXIO;
+
+	cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
+	strscpy(cmd.client_reg.devname, dev_name(&padev->aux_dev.dev),
+		sizeof(cmd.client_reg.devname));
+
+	err = pdsc_adminq_post(pf, &pf->adminqcq, &cmd, &comp, false);
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
+	struct device *dev = padev->pf->dev;
+	struct pdsc *pf = padev->pf;
+	int err;
+
+	if (pf->state)
+		return -ENXIO;
+
+	cmd.client_unreg.opcode = PDS_AQ_CMD_CLIENT_UNREG;
+	cmd.client_unreg.client_id = cpu_to_le16(padev->client_id);
+
+	err = pdsc_adminq_post(pf, &pf->adminqcq, &cmd, &comp, false);
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
+	struct device *dev = padev->pf->dev;
+	struct pdsc *pf = padev->pf;
+	size_t cp_len;
+	int err;
+
+	dev_dbg(dev, "%s: %s opcode %d\n",
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
+	err = pdsc_adminq_post(pf, &pf->adminqcq, &cmd, resp, !!(flags & PDS_AQ_FLAG_FASTPOLL));
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
@@ -15,7 +141,8 @@ static void pdsc_auxbus_dev_release(struct device *dev)
 
 static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *vf,
 							  struct pdsc *pf,
-							  char *name)
+							  char *name,
+							  struct pds_core_ops *ops)
 {
 	struct auxiliary_device *aux_dev;
 	struct pds_auxiliary_dev *padev;
@@ -27,6 +154,7 @@ static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *vf,
 
 	padev->vf = vf;
 	padev->pf = pf;
+	padev->ops = ops;
 
 	aux_dev = &padev->aux_dev;
 	aux_dev->name = name;
@@ -94,7 +222,9 @@ int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf)
 		      pf->viftype_status[vt].enabled))
 			continue;
 
-		padev = pdsc_auxbus_dev_register(vf, pf, pf->viftype_status[vt].name);
+		padev = pdsc_auxbus_dev_register(vf, pf,
+						 pf->viftype_status[vt].name,
+						 &pds_core_ops);
 		pf->vfs[vf->vf_id].padev = padev;
 
 		/* We only support a single type per VF, so jump out here */
diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
index 30c643878a2b..e3e99fe58d0e 100644
--- a/include/linux/pds/pds_auxbus.h
+++ b/include/linux/pds/pds_auxbus.h
@@ -10,7 +10,49 @@ struct pds_auxiliary_dev {
 	struct auxiliary_device aux_dev;
 	struct pdsc *vf;
 	struct pdsc *pf;
+	struct pds_core_ops *ops;
 	u16 client_id;
 	void *priv;
 };
+
+/*
+ *   ptrs to functions to be used by the client for core services
+ */
+struct pds_core_ops {
+	/* .register() - register the client with the device
+	 * padev:  ptr to the client device info
+	 * Register the client with the core and with the DSC.  The core
+	 * will fill in the client padrv->client_id for use in calls
+	 * to the DSC AdminQ
+	 */
+	int (*register_client)(struct pds_auxiliary_dev *padev);
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

