Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC6B6C5494
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjCVTLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjCVTLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:11:08 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02ABE5C9D3
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:11:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3MjgOR2uWQaMxnoWsGpc3RvSetEKjPeJgvIPwB1TecxS1dK2Yh/U/JOkA5Azv1Sic0NbTmYQUMlWpix0FwQsQf6AD43+DgRQpieMAIaVLCaV776n8YKrH1/rIlpiR50nfxSuvWoM+uXH+6k5E8Fcd2OOs0smT5Y/NtBsF5MrTG7NT7gvO7PGRw2cMnEk0mT+0cXOs+xzDVDV8+TRodUOYaDfVoQGsGpa5p7lTtdy5BBhESiRXEtykB6xLGzRAvG1sqgm5Y3cIZyawfBH88cEvUpTuFN9jT6ekccPk4/a5cDZn7ZWQIjF06qG4LOvCgiT5qjGu4Cvn5viMQh2n7UKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NpiPLJ22zI1qFLJpTd74/sRpfDQGAiwUkhCAjFuOBo=;
 b=YyeUwhA0ESNkx9r7+RdbrBm5JWP4jgp8tozdckG90dfz9XQNIsOu41W/rdv7x0OS/jZSmYtk4BhfB5r5HtnuvLpmiAX/t62kihO5KG+mwuE393A2ym+Fv/HPzHUvFnfBC7J/gIEWDIZ6OD7Ie5CSSSJtPz5cIY3suctt/UY8h0KMh1WIRlTcW5W2FNIzLu0HcYGETjOHCsuKobFmvKPJNhw1aZhdY2ex+f3cORgXtHEA+b3FgRVAXHMtoeR15ONfdVRjSjnTs0SChI+wA/MGwIk1aZJ9kdsLpYrWsP75M3hKOoaEgCI3GBv9GK2DnnRgVORFEWVl+C1UXXYWtvR2Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NpiPLJ22zI1qFLJpTd74/sRpfDQGAiwUkhCAjFuOBo=;
 b=qeiiEeNCUNnQk0mF3Df/ynM8oiAe2g6i1OdBNBmEWHmHeIjAmvha0U94kY2TQzNfs2/jRWNo+rvSFAmgRqRfAT2qmvfFRI+oecFi6U/k43ndOXZdRkTf3QR/G8tqjw0PuSDN/IxRmw/zwNSoMocNlJJLdI8civ8YToPo70ttETo=
Received: from DS7PR03CA0287.namprd03.prod.outlook.com (2603:10b6:5:3ad::22)
 by PH0PR12MB8051.namprd12.prod.outlook.com (2603:10b6:510:26d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 19:11:03 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::de) by DS7PR03CA0287.outlook.office365.com
 (2603:10b6:5:3ad::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 19:11:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 19:11:02 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 14:11:00 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH v3 virtio 7/8] pds_vdpa: subscribe to the pds_core events
Date:   Wed, 22 Mar 2023 12:10:37 -0700
Message-ID: <20230322191038.44037-8-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230322191038.44037-1-shannon.nelson@amd.com>
References: <20230322191038.44037-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|PH0PR12MB8051:EE_
X-MS-Office365-Filtering-Correlation-Id: 8347e3bf-cb77-43f9-1daa-08db2b092dec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j1AaN8k0aGivlhu/TIRq0ddpyh2CSbCDt8t0mxpxwb/m1IPsQu5ninUwUvUXc4ZOeUc2z6qQFYuSxRm9w1BshyBkm1M3+Dgtsl2GAFsFJFgGTmL6k/eVk36J6ISrodEaKYfydTmswAedI9a8HBf+/D3Fuj6vTsFCVFxqfkpSVx5Tz++hKxGDFKeulWKn5Awwo9bgtFr9x/ag3LZdNFKl3EZD4dQ1kn/NtIqVOS28SpTII5VCgRaAMyXX1vpkAksZIndaFmHFYz7skw56PvKEwINW/FC9DyUOo8tdt7Vm88VswOeyXU6HtFTjYuK9yGPnmGDjsFvBNX5IwiWE8Zr+4MUbCGyWd4BlkAHj0hhOq09LpsPZCy0FmowZNNF9DfIXpGmgf+8bRAAGhot+qg/2VqbJtwJfftav1TONC3YkEnlngB2i5GceQO+UKJFObov0oO6eqAkAavetrueLS598pHbCLxoZVvGHqw/DkV3zz54TsLDl4T8WAFMmoOL/DUISIUOdS8Q9c9AfEYPV46So7rl0PriO99s4Ou3NPVrMbGALNL+4V8A39WLH5j45PRVGJ7S/IHzy4hNFzZPpC4hRWwf84TODOC4/DlSsin0g7/hvXMwuOSmPOhCov6IXI6kn7Q3la6U3aNOVCDT2lLVKHEirjopk0+HeUOSkvsifNKgk/ptaQ8I9oiEygfQM47JJlTrP0CoB8+2zA/rQz/ZLEPMaRHLGsE+2VCUYQCNtqQc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199018)(46966006)(40470700004)(36840700001)(16526019)(2616005)(47076005)(26005)(83380400001)(426003)(336012)(6666004)(186003)(4326008)(316002)(1076003)(110136005)(8676002)(70206006)(478600001)(70586007)(36860700001)(44832011)(5660300002)(41300700001)(81166007)(82740400003)(8936002)(2906002)(356005)(40460700003)(86362001)(82310400005)(40480700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 19:11:02.6331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8347e3bf-cb77-43f9-1daa-08db2b092dec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8051
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register for the pds_core's notification events, primarily to
find out when the FW has been reset so we can pass this on
back up the chain.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vdpa/pds/vdpa_dev.c | 68 ++++++++++++++++++++++++++++++++++++-
 drivers/vdpa/pds/vdpa_dev.h |  1 +
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
index 6b6675ac4219..c0cd000bac06 100644
--- a/drivers/vdpa/pds/vdpa_dev.c
+++ b/drivers/vdpa/pds/vdpa_dev.c
@@ -22,6 +22,61 @@ static struct pds_vdpa_device *vdpa_to_pdsv(struct vdpa_device *vdpa_dev)
 	return container_of(vdpa_dev, struct pds_vdpa_device, vdpa_dev);
 }
 
+static int pds_vdpa_notify_handler(struct notifier_block *nb,
+				   unsigned long ecode,
+				   void *data)
+{
+	struct pds_vdpa_device *pdsv = container_of(nb, struct pds_vdpa_device, nb);
+	struct device *dev = &pdsv->vdpa_aux->padev->aux_dev.dev;
+
+	dev_dbg(dev, "%s: event code %lu\n", __func__, ecode);
+
+	/* Give the upper layers a hint that something interesting
+	 * may have happened.  It seems that the only thing this
+	 * triggers in the virtio-net drivers above us is a check
+	 * of link status.
+	 *
+	 * We don't set the NEEDS_RESET flag for EVENT_RESET
+	 * because we're likely going through a recovery or
+	 * fw_update and will be back up and running soon.
+	 */
+	if (ecode == PDS_EVENT_RESET || ecode == PDS_EVENT_LINK_CHANGE) {
+		if (pdsv->config_cb.callback)
+			pdsv->config_cb.callback(pdsv->config_cb.private);
+	}
+
+	return 0;
+}
+
+static int pds_vdpa_register_event_handler(struct pds_vdpa_device *pdsv)
+{
+	struct device *dev = &pdsv->vdpa_aux->padev->aux_dev.dev;
+	struct notifier_block *nb = &pdsv->nb;
+	int err;
+
+	if (!nb->notifier_call) {
+		nb->notifier_call = pds_vdpa_notify_handler;
+		err = pdsc_register_notify(nb);
+		if (err) {
+			nb->notifier_call = NULL;
+			dev_err(dev, "failed to register pds event handler: %ps\n",
+				ERR_PTR(err));
+			return -EINVAL;
+		}
+		dev_dbg(dev, "pds event handler registered\n");
+	}
+
+	return 0;
+}
+
+static void pds_vdpa_unregister_event_handler(struct pds_vdpa_device *pdsv)
+{
+	if (pdsv->nb.notifier_call) {
+		pdsc_unregister_notify(&pdsv->nb);
+		pdsv->nb.notifier_call = NULL;
+	}
+}
+
 static int pds_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
 				   u64 desc_addr, u64 driver_addr, u64 device_addr)
 {
@@ -551,6 +606,12 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 
 	pdsv->vdpa_dev.mdev = &vdpa_aux->vdpa_mdev;
 
+	err = pds_vdpa_register_event_handler(pdsv);
+	if (err) {
+		dev_err(dev, "Failed to register for PDS events: %pe\n", ERR_PTR(err));
+		goto err_unmap;
+	}
+
 	/* We use the _vdpa_register_device() call rather than the
 	 * vdpa_register_device() to avoid a deadlock because our
 	 * dev_add() is called with the vdpa_dev_lock already set
@@ -559,13 +620,15 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	err = _vdpa_register_device(&pdsv->vdpa_dev, pdsv->num_vqs);
 	if (err) {
 		dev_err(dev, "Failed to register to vDPA bus: %pe\n", ERR_PTR(err));
-		goto err_unmap;
+		goto err_unevent;
 	}
 
 	pds_vdpa_debugfs_add_vdpadev(vdpa_aux);
 
 	return 0;
 
+err_unevent:
+	pds_vdpa_unregister_event_handler(pdsv);
 err_unmap:
 	put_device(&pdsv->vdpa_dev.dev);
 	vdpa_aux->pdsv = NULL;
@@ -575,8 +638,11 @@ static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 static void pds_vdpa_dev_del(struct vdpa_mgmt_dev *mdev,
 			     struct vdpa_device *vdpa_dev)
 {
+	struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
 	struct pds_vdpa_aux *vdpa_aux;
 
+	pds_vdpa_unregister_event_handler(pdsv);
+
 	vdpa_aux = container_of(mdev, struct pds_vdpa_aux, vdpa_mdev);
 	_vdpa_unregister_device(vdpa_dev);
 
diff --git a/drivers/vdpa/pds/vdpa_dev.h b/drivers/vdpa/pds/vdpa_dev.h
index a21596f438c1..1650a2b08845 100644
--- a/drivers/vdpa/pds/vdpa_dev.h
+++ b/drivers/vdpa/pds/vdpa_dev.h
@@ -40,6 +40,7 @@ struct pds_vdpa_device {
 	u8 vdpa_index;			/* rsvd for future subdevice use */
 	u8 num_vqs;			/* num vqs in use */
 	struct vdpa_callback config_cb;
+	struct notifier_block nb;
 };
 
 int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux);
-- 
2.17.1

