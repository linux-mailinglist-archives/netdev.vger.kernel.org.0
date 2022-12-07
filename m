Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDC3645D1B
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiLGO7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiLGO71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:59:27 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA80663D4B;
        Wed,  7 Dec 2022 06:58:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cywa3rnC72bqiIKk6I7eNN63JGtVp1Tqhd3H3Xkvsu9zN7fzrfbILhUAxOJoZJn8xBGPZLyFyhZOy+1KMTFCLc5+aRq07xNh9bqH/KfCz5Ay3+EbWoUtkRYrblpYgPKDYV0WtS1hddhlI5IAgFyk746x9SWfpYs6OlXp0kSXfNNJm3aVAvzNOx8sDswMvJQm0I25GYKL7N/Z/97LBhQEgWtQmTNPXEY5VqI19rL9Xt0YGIC4Dy26RQwT51M2H0faJT1Z2jUPfUtPVF3pYZIyVompixDKoVYlt4Uu/LRPMyahElr77a/1ESJijfK0js4VvK8C8uhJ8SURr93D4y2OSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzCuX+xn1dKb3qq+JB4DsNggC/4+ve8vrZcXeVlMIf0=;
 b=ninqB8RAlSKPvOIKdMf5/Ok8u94kuJQOygLLqnHV9Ox/yRqvG8Io6wqB/7g4Sim0CnAzdip7+kM0pEG1SVCfBjGSlMiTs/4Y0kf+4XHNSi45yiVVChafcS9Yej9ghVQVopCkRaJ/L0SS2HGcaWfPwT0myBxlg7fH3yN4CAb8ve1fuqA+3wPGcbs/As1LmOH1/SH3XFhyIkFr15lOYhO6YYLTHQxDQV906WNhGwJZx/RP2KBAMZS8iAGZVMBwIEXKTUMhnNi0Cr1ENhPiyV0F4bV44ZXgowuYK4/B5djUq5ZxfW7ty6k4fS4LoRRk+Jj2JVuBGxdlnn7y5Xtoet9iRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzCuX+xn1dKb3qq+JB4DsNggC/4+ve8vrZcXeVlMIf0=;
 b=Qk5Fa+TpbjKSlRYqX/FB3LCe9CbzUs2fFt67GW4vRRANT2umLm76fcJI4ehPdOSPPJktg84VpvuhZk45ddnX/aGCTESt98m00VlddweUnVj8zzKASYrZkuHbn2Xmnck3AQmfmrF1hApJhWDCc60SO76mWd9D5xj/6vJeWm6dJPI=
Received: from DS7PR05CA0025.namprd05.prod.outlook.com (2603:10b6:5:3b9::30)
 by SJ1PR12MB6172.namprd12.prod.outlook.com (2603:10b6:a03:459::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 14:58:09 +0000
Received: from DS1PEPF0000E633.namprd02.prod.outlook.com
 (2603:10b6:5:3b9:cafe::e5) by DS7PR05CA0025.outlook.office365.com
 (2603:10b6:5:3b9::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8 via Frontend
 Transport; Wed, 7 Dec 2022 14:58:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E633.mail.protection.outlook.com (10.167.17.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Wed, 7 Dec 2022 14:58:08 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:57:37 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 06:57:37 -0800
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Wed, 7 Dec 2022 08:57:33 -0600
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <netdev@vger.kernel.org>,
        <jasowang@redhat.com>, <eperezma@redhat.com>
CC:     <tanuj.kamde@amd.com>, <Koushik.Dutta@amd.com>,
        <harpreet.anand@amd.com>, Gautam Dawar <gautam.dawar@amd.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 11/11] sfc: register the vDPA device
Date:   Wed, 7 Dec 2022 20:24:27 +0530
Message-ID: <20221207145428.31544-12-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20221207145428.31544-1-gautam.dawar@amd.com>
References: <20221207145428.31544-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E633:EE_|SJ1PR12MB6172:EE_
X-MS-Office365-Filtering-Correlation-Id: b0190eef-2b85-4897-210b-08dad8637446
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZJTS/XoVEsFtXqh13KYgs0nMSoDLlCHPbD7Gr9jKw6q3H1Dr1c8OvgdDRG9x2h25LD2+PqPPnBmV4Z+uRw4QAuHFZM7bOaaCvhf2psW3jpHoW0EhUcmNMG7ei+V4YrNY75sROR36LSSw0DMFrDU4OIzCNVM3FK9+ZAVdzBEVwG1/nue4f+QKh6pnmyPkqQQMGBozAwPa08OgflX4SKGSTW/1Lj2ghf7pqJm29hevBejMi7KY2DscseFPGAyexy6WsUxd/Oh9RrmkJXZFnZgXQ9U7juJG6K1/vydU+N4eUTJkmu+Fleli2h3Ii9zjnbojdWkAP1aCjNesmJBiS0wyG3+kE5k/OjVpLtOOr+3dgDGz8feZGLV8iOcdFoX64qcUdCbUJFEuJbQZD4C5d1XrJMBYRnen9x288n/QNQBef6ov61PYJHsxNGwq/8IDHDtBDvb4bR6JTuJmFm0DdFCEecZh+Qw6zkLW5WwBajpwvjf04B6G2qigYHmyLiUCmhItqbrUzfpdcqGNldHqslaEdhkLg+GzylLV/wca7wOQMBuWsqL0O0tVXnu5Vc/inb9o0RLTqTQiAiXxytFyGIpKS53SosAfePKcb0b5yoGgB9cIJyphVkxgJ3zMq0avXOCJf3bBNonfZ0EvCv0skhy178h7Spxk00QWPHpuP/Ksifeie2FEvhM8xt/23jOPor4vw4CZnrzVUTAl9WkqB9B2XUyXE8+8CL7tXgMAZ1JdLo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(47076005)(426003)(478600001)(40460700003)(82740400003)(81166007)(36756003)(40480700001)(86362001)(83380400001)(36860700001)(336012)(26005)(2616005)(1076003)(356005)(186003)(41300700001)(7416002)(8936002)(82310400005)(44832011)(6666004)(5660300002)(316002)(70206006)(8676002)(54906003)(70586007)(4326008)(110136005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 14:58:08.9680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0190eef-2b85-4897-210b-08dad8637446
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E633.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6172
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register the vDPA device which results in adding the device
to the vDPA bus which will be probed by either of the vDPA
bus drivers: virtio_vdpa or vhost_vdpa.

Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
---
 drivers/net/ethernet/sfc/ef100_vdpa.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index 16681d164fd1..ed59974c9633 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -231,9 +231,7 @@ static void ef100_vdpa_delete(struct efx_nic *efx)
 	if (efx->vdpa_nic) {
 		vdpa_dev = &efx->vdpa_nic->vdpa_dev;
 		ef100_vdpa_reset(vdpa_dev);
-
-		/* replace with _vdpa_unregister_device later */
-		put_device(&vdpa_dev->dev);
+		_vdpa_unregister_device(&efx->vdpa_nic->vdpa_dev);
 		efx->vdpa_nic = NULL;
 	}
 	efx_mcdi_free_vis(efx);
@@ -535,7 +533,14 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 	if (rc)
 		goto err_put_device;
 
-	/* _vdpa_register_device when its ready */
+	rc = _vdpa_register_device(&vdpa_nic->vdpa_dev,
+				   (allocated_vis - 1) * 2);
+	if (rc) {
+		pci_err(efx->pci_dev,
+			"vDPA device registration failed, vf: %u, rc: %d\n",
+			nic_data->vf_index, rc);
+		goto err_put_device;
+	}
 
 	return vdpa_nic;
 
-- 
2.30.1

