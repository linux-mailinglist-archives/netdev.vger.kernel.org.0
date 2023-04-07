Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906C16DA9E9
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240247AbjDGIOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240050AbjDGIOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:14:22 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76A8A5CD;
        Fri,  7 Apr 2023 01:13:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJR25/YVE8z9EB2Tm/vQjaaRcgver9FiWtMPRWyd2py0LxJHmEZm6lMzh8iX6SZKZQGWoJdOGN+Z+kVQ4L/XLiIWgwGU/Bgakul/jqsZeWuHCo+WB3fsqjSmgT6VfDJ6QTYmYupFi/To9Vs8bZ4uK5bmXQRmeZROZeY5K6i7I+mQz6ajDuuz0aczCNez1P3Mh1iQ0KPdEzx314N/VVtSsY6JKcFBoyCRTl9Kay6vJI15HMnpgwLUJ50ZVQ1zTSWE8Ei8TBhJ3yGTlURAMqvODoNRvqPMNnzlEpgxg1X6DMu2LF+vHMZEp5UZw7wVKvd4Az5xJR6SSuylv9vLrhcx5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNpFllR/nXDSPgqnMrrZHAa4qA9wkNXDSuhF5CZb8KY=;
 b=LX2tX1Yu9iKyMtKqbBM+z15APXrkklw3tFA80bmiWaWIfh5IbHqnRcUMYMRCtrK3HkHNcGMp9UxDatR8wvNF68jsCrKcmSISsIRA9+OGqN7LYlyODU7tAoJ03UxNYqefs7qiC4BKBtmN+uW+FM0DvOITlcP2/UJR7lLWL6gEt5NMydUD/DtVb3ZX+s6FFVECEHbtCVDNoYidxeDUm1JphujYayL+YeRfhVwvPtT5/opAAfmzXO6Dp5KEWD0caLYEaPE4EhKE0lPF4gw14xpiL5fVTJxerPFgboh7uT39s5eL9O7GDYEH3Qt+U21l2VeevJJUfZXbH2oRyYZiO2tUOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNpFllR/nXDSPgqnMrrZHAa4qA9wkNXDSuhF5CZb8KY=;
 b=ZcsdkOPP3wLRnRn/5mGGYE/geP1NDB9l36j4Z8aNS2gPjnt7nngJL0FUnCq5wmoGOuDRHVMqV67P0CEdHOGd9MbeXo0RWOalAQbTSgwfr2gzisrP3xssFiEods6MtAA82kREqci1z0KyI2ONmwWgotTSXBrKcZfwwM9om/sx9VU=
Received: from BN9P222CA0004.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::9)
 by PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Fri, 7 Apr
 2023 08:13:07 +0000
Received: from BN8NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::28) by BN9P222CA0004.outlook.office365.com
 (2603:10b6:408:10c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34 via Frontend
 Transport; Fri, 7 Apr 2023 08:13:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT069.mail.protection.outlook.com (10.13.176.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.20 via Frontend Transport; Fri, 7 Apr 2023 08:13:07 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:13:06 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:13:06 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Fri, 7 Apr 2023 03:13:02 -0500
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
Subject: [PATCH net-next v4 14/14] sfc: register the vDPA device
Date:   Fri, 7 Apr 2023 13:40:15 +0530
Message-ID: <20230407081021.30952-15-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230407081021.30952-1-gautam.dawar@amd.com>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT069:EE_|PH0PR12MB7982:EE_
X-MS-Office365-Filtering-Correlation-Id: ffb76f15-bb2b-4129-7840-08db373feb2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j9tQ1AtP3iS28XqZkT1+FA9QBVbEK7MjgsxPklDt5D8swf9N36f7WTpSFyMwsF/vH9b7WOguEmcSdTrmOxvDoobBGcMZc1b/H+z/TjV6ICgWmIhmwRtLn6lNXJqoejcgKyM9iLgl0EMUU+xl4ISS3P2PQ8G/S9DvWiOppLcW82d7lDIOSrAP6GMMJ+ZK9JJ9MZV/5Bc+z54+8jWMU9jPTNsc9Va3ERgz66S2EvH1E1U1zFoRNqkXQ7mnTbh5xNMzv7pt9G7qih/sHhrUnAhDn5sUC8vXd6Xhb35kb/Hn7IIduib5kbl+Gf9F0QuDzaMQbvotPYJJX75EXJoqvPoOnIf6Aw5h/+ff8zxeABqdz0pqR5kkxiL1EoChDp9teqC1JRuY2N46sFDHWhvjERfUgKyjK8GQsmo2tOwxV2U4TImNEB+Bx3TSmYivgkhJphxy4lJtknsW594sew8HGkuKoP4vh2qplkbzURhDNP9b+GZwBSi65s1r7CLvJitlqUOd7tPLs0Ds+cXqAtmPocNbRRKh1dSK3u2gjQyerJveOqQubznYPtAm2xFze3cQO/kcsKe5c9Qs7G3r85hNzwId9NRQyUUhvtrGb0Lt3qj/+GcE6nkeNDtqn3zvxyiVbwlSpWH6uZCrGZ/V4iFMvWwc+qjjTUJKiCFJRFrbJ9R0+DOVXQ7ZXnTARlmR1jRF1+rnELeEHD5I5KcaWrCOlr1h5wrJbuCDe3cFX3yOIMP3s3lj7O6LJPr7m6509448Z7rP
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199021)(40470700004)(46966006)(36840700001)(2906002)(1076003)(26005)(2616005)(6666004)(86362001)(40480700001)(40460700003)(81166007)(41300700001)(356005)(8676002)(478600001)(4326008)(82740400003)(54906003)(921005)(316002)(110136005)(82310400005)(83380400001)(36860700001)(36756003)(70586007)(70206006)(186003)(7416002)(426003)(47076005)(336012)(8936002)(44832011)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 08:13:07.0746
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ffb76f15-bb2b-4129-7840-08db373feb2e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7982
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
index 1aa7dec6c8b3..be3f5cddfb60 100644
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

