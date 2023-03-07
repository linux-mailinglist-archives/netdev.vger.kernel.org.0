Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B466ADDC4
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 12:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjCGLnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 06:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjCGLmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 06:42:31 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2067.outbound.protection.outlook.com [40.107.100.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7317BA18;
        Tue,  7 Mar 2023 03:39:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DjlxfMwlriBvk2pHts/yLdtsnYf9EB+G1nNw57TYNAD/qULVr9OYGGxoU7mhSHCIGEHpj0VCRDaIgkRPIJU5bkv81+61CmQ7JdKmYYAPGUanTCW+qsjDfenKh9lecJ+r1cIHnxtdOQKmOWDj5CW7Knh1Se5wwSGcrgrY5gnL037fB966RUimMdarMeQ8PWOKS9j1sVxAvT/cPaC+6fcuYrdIUaNh9KXqnngAo1+LfTcfJk2OD7KpBc7CmoaVvtQnRSRwUgr+TzJIsxsrAeEMRYhhAn18RAVdgbVgqG5SxMX3DW+ozbhVHKNJ9FMRZ4rGyHoxspn6oojbPX/sulVjkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DgYhD1JmnVL70wpTruKP4DJucBlwgDt5ayQ4GqVgqyA=;
 b=KuYjAb6dtk5GgdtswcmMCSS1StjZ6adHt3A10kMf6Q9sn26slrkPkC1GvsPjLkxx9Ew7NhSkZ5RvPAapqj/Ia11auo6nBsnVffdDWUAgRl31cRlkOV0qPiA+Ud4OjCrGm84qHtAQwucW4yBGxw6OphIrhG411666S6ku4DOnVdKYDjzLl4EBrJ378nkBaovC13Q1q3IjFRmmjJSR5rhT0t9z/Okm+YP6n9h86IAV9VulTTJ3JEUt1b07FM7t9cvcYQlZ3Quvk1BtH6Aov2hrzmJpRIUFoJe0wFeHrMHzpXp0GFySXaythUJ0aJzUj8EIQ42+yn3kkLpCphqEaa7ZqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgYhD1JmnVL70wpTruKP4DJucBlwgDt5ayQ4GqVgqyA=;
 b=lV5/nqOWbujHL017VpKq8/FSIpfMHy6ugVV3JtIj7ntzBwND8fazShIRXHtDianMwOV/S9OkfoC0HfKV0lLV0nlugO2uvmiynki4/ClmHWicilCfiTR3jKe8+L/uW0zctPCu+UuisA+4xJaGyT9eu0m+mRKVkYEvfzcNTaNEass=
Received: from BN9PR03CA0887.namprd03.prod.outlook.com (2603:10b6:408:13c::22)
 by MW4PR12MB7016.namprd12.prod.outlook.com (2603:10b6:303:218::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 11:38:39 +0000
Received: from BN8NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::e9) by BN9PR03CA0887.outlook.office365.com
 (2603:10b6:408:13c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Tue, 7 Mar 2023 11:38:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT114.mail.protection.outlook.com (10.13.177.46) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.16 via Frontend Transport; Tue, 7 Mar 2023 11:38:38 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 05:38:37 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Tue, 7 Mar 2023 05:38:33 -0600
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <jasowang@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <eperezma@redhat.com>, <harpreet.anand@amd.com>,
        <tanuj.kamde@amd.com>, <koushik.dutta@amd.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Subject: [PATCH net-next v2 14/14] sfc: register the vDPA device
Date:   Tue, 7 Mar 2023 17:06:16 +0530
Message-ID: <20230307113621.64153-15-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230307113621.64153-1-gautam.dawar@amd.com>
References: <20230307113621.64153-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT114:EE_|MW4PR12MB7016:EE_
X-MS-Office365-Filtering-Correlation-Id: 76acc331-35b6-4916-3fce-08db1f007e86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MZqnDkcUlIaxapruM9vF/sWaeX71xiLq6wkFE0O7LiBm2EoaMrlF1xslW1uVnJnLTXqXEIaRkm4ZCnKwXgzSyW7+vYmAnD/PTS2TbNZqJ4g0e3WtqyR+oJmkWqyi3/hTAyPHK1H9STOLorD7P6gEHo+7n3KXdKM+X66odtBnoxYXgizQ8+y3VfvY7W2mKxlvsAIyRlfSD6HV7u+1K+par4A4QNY6yV87YysrrhZn5ORSE/EQJXKqxSAGSjKdtkEFcRL46uJvS/mu+QatS1deTkw9hEP1P+iKuQGYHZqOSB1eAymKAkF4eDiuQjHsd0qT7y0gcISJfzkMK2yokcPXCEf6iYwyL7ZhqM4BP9jYAbNR8Jk8EJB6kgG1B/pUBBJ1fy6meMeQSAMDyNO3gVSZ0enURlIalouiHyIM5nIt2VPual8kB25aYoMP4u6idb4czc5qbP9eZ7aIfpsrM6ugU6rWW8tD1cHv/kCf/MMq2xvm87fAZyiyGns8d9EnS/81+EZMEnjR4fXDrIFoma237vTxrgK84bTFoYIBMnNX4OLVaAouXAmVCLm2PebTcmqW53n1KmSOrTgKOBEsMQ4p/AqaBON9EXbyFpy1CbuawCPsb/lUpkuEdiVJCCVbSJDWTqKhpSvKninrcVx1dUmi4R25PGOH4HxbEYoBQYSykbBS+DbkwBKH/jNLOWIJTiDsxJXehqUUHsIDTkmdWO3+0dIckadqBc8fdl1UhysPWZ9bfALgP9WvatS4sv8aJ7QP
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199018)(36840700001)(40470700004)(46966006)(82310400005)(426003)(478600001)(336012)(54906003)(47076005)(81166007)(110136005)(316002)(83380400001)(36756003)(82740400003)(4326008)(40480700001)(8676002)(36860700001)(70206006)(70586007)(1076003)(186003)(6666004)(40460700003)(26005)(2616005)(2906002)(7416002)(44832011)(8936002)(86362001)(41300700001)(356005)(5660300002)(921005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 11:38:38.5776
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76acc331-35b6-4916-3fce-08db1f007e86
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7016
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/sfc/ef100_vdpa.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index 32182a01f6a5..a07dd5e8bfb0 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -237,8 +237,7 @@ static void ef100_vdpa_delete(struct efx_nic *efx)
 			}
 		}
 
-		/* replace with _vdpa_unregister_device later */
-		put_device(&vdpa_dev->dev);
+		_vdpa_unregister_device(&efx->vdpa_nic->vdpa_dev);
 	}
 	efx_mcdi_free_vis(efx);
 }
@@ -388,7 +387,14 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
 		vdpa_nic->mac_configured = true;
 	}
 
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

