Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B07C4AC74F
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358195AbiBGR1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347972AbiBGRYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:24:05 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C276C0401D5;
        Mon,  7 Feb 2022 09:24:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NH12exB71fMFBMdCSDSVLWEq+imrVuLbIX6H+KSP3S11zIC95ac62783j38rO1vHqaRfqxYU5bzMMlLAiif9p9j8BWQzthPLz0gTkiqcHI2o4SbY8pGJ360HFRsWGnuJ9vik4PFkoEY+mJJ6RfhpSyNc7l+B6Ju65sPtfBMPitB6k+VhAEHSPyQ3xWhYzzFNqpD4cgKIyzMhjXxgvr3XJb8QgOW2o46HmGL7SS6KWoVFXtl1jle82q12ktvEXv9pWMOd0Hnw+MCLkDyprMd9aoKMXlUK/Uu1i5GAqJmHIvd157Kwka8Z5ffVXKysGoTmP4jz+3Ooz8xaAMqv+T9TFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNQgaDTdj4EZWXUCoFLRq6+GwlBZaCf9ViHrWbjQUmk=;
 b=l9IuSZfocQvEuMA8vEL6zHNv3+cwQL1kepTudJYR1xwuAd36WLXWA5rxLzEEH3OwkzOKeh+L+6toIVj/PIPTIJtUYhGFQMr3ae6oQWT1NWDFzxeKd+KZchhzXSdOvwH3/aNmlR3Ijm5h/yT4zaxhnMu1XdUllmaRFB/6O1G01pSBVJBTX2Eq7GLA1xtmvSsDQQdcvkb3jaNj+IIPsVUykeP6ERW7dTtQgqgwMsuF+wDBs854mRS7ANd3YalONjWFAbE+8hcWeje5r0ZPzQIwpOu0dvCHJMF0/qhBOor07/H3/9IzM27hplBhCimbPFvBzv7AfkMcQnNjzsg9FWccKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNQgaDTdj4EZWXUCoFLRq6+GwlBZaCf9ViHrWbjQUmk=;
 b=MGnpLsxPK+5M4vj4mJm9stxEOdtqJrAQU6Y+FPY+2N7uvp6xTLcQHQ37CNAAaB2sMEwBS4i3dGRnZEljhIKSE1tuPLl+ON4fe4RicFFoSPDZYbd/6hdjBPoJ/E3bjO50YLfhhnOdQoLeLqB8Jm5pEIWVqWgg6tbOVCQqkXI5mzkNLbomPuPIMuY2mjJztXSjHWrxgQgBz/EN9XcKtjW6nebLIADWL97Nd+TsMSU6J2wY40m4LiqAbL2HaD2uP+T/9YvmHZIKX7gE0LzFlYaEB0VbXL6qha3781XpTOPa0VeRh1NCbwoA2IFhtRpdMOlvY4fPNBO6pP+bZAcQ3CcvOw==
Received: from BN8PR04CA0018.namprd04.prod.outlook.com (2603:10b6:408:70::31)
 by BY5PR12MB4901.namprd12.prod.outlook.com (2603:10b6:a03:1c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Mon, 7 Feb
 2022 17:24:03 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::8d) by BN8PR04CA0018.outlook.office365.com
 (2603:10b6:408:70::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11 via Frontend
 Transport; Mon, 7 Feb 2022 17:24:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 17:24:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 17:24:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 09:24:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 09:23:58 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <ashok.raj@intel.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V7 mlx5-next 13/15] vfio/pci: Expose vfio_pci_core_aer_err_detected()
Date:   Mon, 7 Feb 2022 19:22:14 +0200
Message-ID: <20220207172216.206415-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220207172216.206415-1-yishaih@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2abc6e83-7122-4bb7-25da-08d9ea5ea30d
X-MS-TrafficTypeDiagnostic: BY5PR12MB4901:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4901EA277C064B578E7E75DFC32C9@BY5PR12MB4901.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MYmZXRZramBDXkFjujI9oDt55VlJICEf2Jqx2ZsDkLxFmS+ZUFQJMVxOS/39Okrh7AiiGD5/QxPHFv0OveLtakOA094BISgzF5MMRu5RWHJlx8U18oqa0WMtMxYZjwpvYkn5XYX1MFxWvbpbYn9Seyh9iobOyJmpoASFUhztjFcuMqR4Q4iy8io9OperoYbyYwcJ/rDrp33RoviLlU/dfy4+/9zk4fC9VmM3oaA+WgbyWcWeBzQPRVVKJjvEt7hOAFhKVMjShWQ/BSv9DhkCH6yLWJH1a9Htf0TT8250rGfUWuVt6n3TY+6C5H/KlE9GlTnqX8dccQ37kH++ztE5+wHLspabFee1QaQQzJKfWKog/e8hv/PrGTn2YsH6GFegJ8qkm/KBd2tLI8UyShc9iwajkOdZOELdlNsfX4qutcinvMJ6TJlB3R1KBTmIMVTMhqtroWlaqUV9CBg/vXOYmVLctRvLaT1vPbWIuP6hgkjLql8Gy0c7Idx38FCMhBoyEeQVG4irQo1qhsYPZcBS3b9hiQMsg1n5P+ZjQXiLvA1oTDcWbHzs9z85jmYQoAkc4mCypW9Vb1Gy197P2D62Ehit/ZQdiVqw1Q4XBlxMV6A7LgbMv0wo9MPaP4ok0+KDpkvJSrCxNYn1LLD7uY9eQywTWIArYdlipmBWciyyZBFqIKpVaUEVYoO5vKJPE9cZolQDle/KuElLXYwuJ+ZlcA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(8936002)(1076003)(86362001)(82310400004)(70586007)(70206006)(2616005)(5660300002)(426003)(336012)(186003)(54906003)(110136005)(47076005)(26005)(6636002)(316002)(8676002)(4326008)(2906002)(6666004)(7696005)(83380400001)(81166007)(508600001)(40460700003)(356005)(36860700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:24:03.1290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2abc6e83-7122-4bb7-25da-08d9ea5ea30d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4901
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose vfio_pci_core_aer_err_detected() to be used by drivers as part of
their pci_error_handlers structure.

Next patch for mlx5 driver will use it.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 7 ++++---
 include/linux/vfio_pci_core.h    | 2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 106e1970d653..e301092e94ef 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1871,8 +1871,8 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
 
-static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
-						  pci_channel_state_t state)
+pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
+						pci_channel_state_t state)
 {
 	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
@@ -1894,6 +1894,7 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_aer_err_detected);
 
 int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
@@ -1916,7 +1917,7 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
 const struct pci_error_handlers vfio_pci_core_err_handlers = {
-	.error_detected = vfio_pci_aer_err_detected,
+	.error_detected = vfio_pci_core_aer_err_detected,
 };
 EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index beba0b2ed87d..9f1bf8e49d43 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -232,6 +232,8 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
+pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
+						pci_channel_state_t state);
 
 static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 {
-- 
2.18.1

