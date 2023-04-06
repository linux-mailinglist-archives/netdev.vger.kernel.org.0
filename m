Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACD36D9020
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbjDFHGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235372AbjDFHF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:05:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5152AD3A;
        Thu,  6 Apr 2023 00:04:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FD/n/qsYz2UFWRyX9l/gBfovMSviYYO8cF+vDaoNO4z9cKC66UVSBBg3oNRm2QNTmPnfRBA+nE0s4K3J/mu360df5UJljG9xZqVwLbPejjkwN7JfgPnXWLZ+bnfV60F6J8ph+4Q0s8RcS+SNvOYlRUE2ktNzesUMobrdvnBhdCczIw6v2xsRZi5UaeKFm4lPrvIpjdR0yysFpXrCxbmdpQHsiAZ6nKfK30cObAzRoBfNPEuM/9ofTom7HDES9cN788tXNcUlKBDiPvLvaeJOSHC69OdKrKdwSVRpvd5C3Ce8R+Wtizb2CPT73nl02NZbSPGzm3sRqOeLWngr9PhjQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Z3swE6Inzynh+zHyET/RxE3vG+3RlpVAs5vL5wjwPo=;
 b=dd/78zdQQemf/zGNqJu9FBnHci8spQS6DYOhysT510WLsszzARqoQbmP6BEs6IFMNISVHi2PckUQJw8Z7us+lDiBbDphHRJqrSbxF6m4iGDINeU0+B9qEKGZ/wLU+klnaHu0DNuqbEbxDLGng3uzAwmcAyVLwHBm9FpHe+SWjHUEk/dGi9OUAtNJ04lXaVE27iQG9vmWbSSzp0BI+zCVNzVczM7v43CgS3kXFrszpsSGVb1h6CiO0Zn78WmQVVMMcdChaMK7OWdEIkRu3qGvTuPhnK/tb+eu8ZY5q01ua5QdB25JVLcACztHEAJUpeaTeaQu/MWpUHxZ4qlfNdQ0WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Z3swE6Inzynh+zHyET/RxE3vG+3RlpVAs5vL5wjwPo=;
 b=elRtOI2EzCRycfvEfRikCuDUPqQ8HCTYhnd0IRHPGwR+VUlKlVaW3uuTMEqMIc+e+1VjWcyNx7o++hgxpyT/pepxckFXCRn/qY3cp/oM1ZlkYLNrU0YHTA5BiFChFsadVA1+GRPTxt4si8+7vNcvHlr8IwSVVds5rI+hk9P2qyU=
Received: from MW4PR03CA0291.namprd03.prod.outlook.com (2603:10b6:303:b5::26)
 by PH7PR12MB6394.namprd12.prod.outlook.com (2603:10b6:510:1fe::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 07:03:17 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::c9) by MW4PR03CA0291.outlook.office365.com
 (2603:10b6:303:b5::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.37 via Frontend
 Transport; Thu, 6 Apr 2023 07:03:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.30 via Frontend Transport; Thu, 6 Apr 2023 07:03:17 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:03:05 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 02:03:04 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Thu, 6 Apr 2023 02:03:00 -0500
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
Subject: [PATCH net-next v3 14/14] sfc: register the vDPA device
Date:   Thu, 6 Apr 2023 12:27:00 +0530
Message-ID: <20230406065706.59664-16-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230406065706.59664-1-gautam.dawar@amd.com>
References: <20230406065706.59664-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT043:EE_|PH7PR12MB6394:EE_
X-MS-Office365-Filtering-Correlation-Id: e95b6f1c-b1eb-48cd-012c-08db366cff62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yD4HfRhSIZ3/WIMGk0rC/daaIJEF3PBZ5kLIWDb4f3g4Znm3lMLVoOs74nlIi7P7ETHf1To9eofgcwJfAC1p6X62o1wqDKWtiVAFZYRi3ZRwv4T1xoc6AYRgkKVHeOo9AvujiAgdgRcNp3Vvt/9wDCmpB2gxEg+a7I8A9aRDXkc9yuK1kIarAgdhs14uyJs2yIsTvzbdHNdFQaFzcJcHOzyxgLidrYI2wVcB2V/p5CUVZDPrEGpkcP0UgUAc7lB/Ahhu6LZapRliAyyLsdxDUZqHKsGHYnfo3Z2xCPdCWZVoRixNs0ja/XWsEBqzJ+RfMECsXjKslWskTQ0721FMGeG4Ft4Y2uMW3a7dQ6GlDREahMbQkqFFNpm4KDOSQzfCDEe+IAaz2DBxadyInBE2cXamGEHuVrUjRZosv5KeJaLrkXwguWypz1fHWKGopcd0hyrhkgXyAunxEKcHQ/vw4xqbAy24pD2uMIDGWkHy14svMq5eUecCzeAz9EGG7eyGCsrhqff6w0IQ2QVTpeH+yVMbF6lYYqg6yGvL6e5Z+hPHJ+PY9fKj6dE2HobPl9JNeqbNLn30YJ+71TC2TytZGXxXp1AsJ0FFbsPPnGa5FybbjUE52qh003iCwa+vk2rnM8+md/Jk7Xdxttk/8oqkx1Js09Z9JugSmnFDJbjmyIe2t6OlwPDgwwsRBNsH50H5IJi8DERyfOjaY14yOaTxrtOX6U1eutOxsttZZ2uhHw0Z/cK2fXRGpNeK+5LvSWZT
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(40480700001)(82310400005)(26005)(186003)(2906002)(5660300002)(7416002)(86362001)(8936002)(36860700001)(44832011)(47076005)(83380400001)(70586007)(4326008)(336012)(41300700001)(478600001)(1076003)(2616005)(426003)(82740400003)(54906003)(81166007)(70206006)(36756003)(921005)(316002)(40460700003)(110136005)(356005)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 07:03:17.0319
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e95b6f1c-b1eb-48cd-012c-08db366cff62
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6394
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
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
 drivers/net/ethernet/sfc/ef100_vdpa.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
index a04bcae89b7b..472a85c81701 100644
--- a/drivers/net/ethernet/sfc/ef100_vdpa.c
+++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
@@ -242,8 +242,7 @@ static void ef100_vdpa_delete(struct efx_nic *efx)
 			}
 		}
 
-		/* replace with _vdpa_unregister_device later */
-		put_device(&vdpa_dev->dev);
+		_vdpa_unregister_device(&efx->vdpa_nic->vdpa_dev);
 	}
 	efx_mcdi_free_vis(efx);
 }
@@ -393,7 +392,14 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
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

