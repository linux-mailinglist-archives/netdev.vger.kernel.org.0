Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471366D9027
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbjDFHIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235736AbjDFHIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:08:52 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410229EEE;
        Thu,  6 Apr 2023 00:08:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=laklsYMS74RXff9Z4P0d0agAGAuldqCP9p7kKhapjp2RvKzMXuKpt/G5TyJFmtphFhdTNBwILkEEVEImPkVzyfycyeRWaWw8HYo+GUwhqlyHTZ4N0a5C/nhkjxM96suwhMmFO1pGOqUDlFLSykMR4G6PUX7qW5zZO/94pCsBo9YAfaBPEln5O6bPSYzL37mE0aeMgUhGOSJn9turlOGtbrpeL8Ef3pjiMXNWigE3SUvrp6+koIs75ft6lEXL/x9q0Gp0nZBgdfcgV46P8Kly9jiZ+t7DCSvaPnyhtVsTcQqGFWIA9QWPl8GRSmGFP4cwlOofXgwjWb+rw4xijLZKmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9/Zfb2wrh8TtrDIET1smZbUjj1Hl72xvwltgft2b0M=;
 b=mSxBIm7xR9jp0zTJYRwjnctNjMWqkWHdPRnR5Us24RNmsxyIigAcu/TSzaPrZkAAQFWhafnav4DHv14jUvmaUWhesLEfOKCssQtyB/KzgwtSh81+Vog7az3drp5OGrzcWwNKfdrmvHP+D8ihccZiSvmzpvTh/wro0lDXobIIRRzzRutgspmUa5bnYvluBMjc2JZrZ0hVEkwyPrmc8lYb74zlmQWtBh++nm5SISr1qCnMpGfmJsYisb8moTKKoo8D/sF7kWqTQYY2rij+i0xHwGcMXrOxNfuRdxAimqD12XdQwe/5dp94cBRxkkfBEJdxT5AtDoWaCBBzvTJVqpiP0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9/Zfb2wrh8TtrDIET1smZbUjj1Hl72xvwltgft2b0M=;
 b=QPUAIuXh4jXugewdD7TQFNivPt+J9TRedB/v92bx/affFvt9sK3KLAbiXecf/qh6o5KVveemE10bpsLkzOUF9wlor1QkejWR/Ow9g455Ldr6mvi24rV6xaCwEDz8Izytwm3t1nk7rymIedOSFflXUq15OxqWX57lUuOR6Py48ak=
Received: from MW4PR04CA0215.namprd04.prod.outlook.com (2603:10b6:303:87::10)
 by MW3PR12MB4428.namprd12.prod.outlook.com (2603:10b6:303:57::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 07:02:49 +0000
Received: from CO1NAM11FT102.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::52) by MW4PR04CA0215.outlook.office365.com
 (2603:10b6:303:87::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Thu, 6 Apr 2023 07:02:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT102.mail.protection.outlook.com (10.13.175.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.31 via Frontend Transport; Thu, 6 Apr 2023 07:02:49 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:02:46 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 00:02:45 -0700
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Thu, 6 Apr 2023 02:02:41 -0500
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
Subject: [PATCH net-next v3 13/13] sfc: register the vDPA device
Date:   Thu, 6 Apr 2023 12:26:58 +0530
Message-ID: <20230406065706.59664-14-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230406065706.59664-1-gautam.dawar@amd.com>
References: <20230406065706.59664-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT102:EE_|MW3PR12MB4428:EE_
X-MS-Office365-Filtering-Correlation-Id: 9facdd32-1240-4db6-d88a-08db366cef0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3NexJTMY1RDlOvneNfy1iwlwHZ0J6t+aZRx076jtMBddy7482SNVw+cu61W0Ug/MktW8rnmlGe6mAY6NjpGoiURMZfZ/bqcMIK0STyXU8smFWcmba383CriicmVWL40UUDfwmlI3xUg5C/eYOAoIEua2FShDckfGi7teFw3O4vqapjz10MZrGnDFXboYlBn7drO/jhPM7huoGIue9yN4wfviO4XPJu6ej4JEEoIITLK8FvaDnRjlil44ziPOtPfMvBqAfJuo7dZBSg8Fdx1h1Z5rBXuR7t6osAp+gTuUCg7BEmiYFyFv6BP0v9FnpZ3aYWGx20e2oUqGZiqmlbuQ/tr86PPfPRqDW9vt8tWW36HFljYNOdAZx9Ttip3t7HkVnyIujGM6sWnzDijZpTr5NVO6MHvsp95omxdn2cJw9c8kc+xGc+IiA+QlfskE4t/x/Ih9/YDAFOr4eg/kydgE8fYfRCrYvL4xwii7cUrU3K8Cw/kADOmoVBoXUCrCRc1VY5tR/WuNDOysz0rCBovUsVuFvDiZkEJew7LOlvWg0oDB5w+5lm5CeiyBN5ZKvH9jZ18+x6JiU2sXTHvZOtbw2urxGfBo16KrG3TGI/PVWUhlUV4xN6DkhpnIvacmj027wXKzd+dZLx3LOgm0GB8/g+QXnfXfftT4Y5VMd+jglEEEUEPj043nNpCTG5YWisyeCawplM5V1SdDXIFgO9ZYSf2ePOcbjud+COJEb+oYLGrckwM5GHr7DkSF0KP5ogRV
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199021)(36840700001)(40470700004)(46966006)(356005)(81166007)(2616005)(921005)(41300700001)(1076003)(6666004)(26005)(54906003)(478600001)(40480700001)(86362001)(36756003)(110136005)(316002)(186003)(40460700003)(70206006)(70586007)(8676002)(4326008)(7416002)(5660300002)(47076005)(44832011)(8936002)(2906002)(36860700001)(83380400001)(82740400003)(82310400005)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 07:02:49.6393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9facdd32-1240-4db6-d88a-08db366cef0b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT102.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4428
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index 50c062b417aa..a6bf43d98939 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -239,8 +239,7 @@ static void ef100_vdpa_delete(struct efx_nic *efx)
 			}
 		}
 
-		/* replace with _vdpa_unregister_device later */
-		put_device(&vdpa_dev->dev);
+		_vdpa_unregister_device(&efx->vdpa_nic->vdpa_dev);
 	}
 	efx_mcdi_free_vis(efx);
 }
@@ -375,7 +374,14 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
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

