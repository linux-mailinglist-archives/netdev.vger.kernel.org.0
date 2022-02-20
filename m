Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157834BCDC0
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243624AbiBTKAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 05:00:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiBTKAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 05:00:08 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC0E54688;
        Sun, 20 Feb 2022 01:59:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abkh/YDqbBwV76hHpKjm/c7p4lR4AXEsIxqGmtwMqZxOyzEssouBjUx6mTjwoZABg7VPKPN1JuXE9DtDhEfyT2YV2avkemFBrR24XjPu8N2GoF91RttbQ2ZtujNPOB4FGerAf2YfP4O24/HcjIKHGj8XJRW/eoSJtLDht/ZoPhrk4qFxyDrFlfCxkuaPObJhAN2ZNQg5g0R2KIFc5jVx53CxN7UdSxin8H4nzK4YtNB3rZmmNsi5BkFIke9xcjqEjA4ea8vx2qBt3DFFYOuUsPaiEqgyxyYzPkbpWvu38HpsLOole5GYAsIuTfM46prZFHvBvz0zdw9FLzq8dgQumQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNQgaDTdj4EZWXUCoFLRq6+GwlBZaCf9ViHrWbjQUmk=;
 b=H83TYxMw6OWEU3YyWBVEQTTwBahis6NZC5D6kEY5A67aZxCjkZhdmCz6K0GbJp6wGref61s973LDZBi70JVL5Plp2IcVwgmcFXDRHp/jg/py2GyNrf4WtyQRqTUgcUdvH8bXJ/0x94XO+bBq7A/I2jWFiEjHA94H13tsx+7iIhAFCnaLM0NW68XKngtsEmQSnDtqoasCeIFlP4fNVuGizJnXz5xgSTf7BNx+F0lBjvYERPKFI8feIBDlpyXJsYCVDlnOC7T/Oa8sLnwjbpV1Zggr9Q6LAfUY60f8fCvzn+oVr5pNK1zTkiam/1ddBt2xhJZaTXSr8eAyOzJ4ki5xOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNQgaDTdj4EZWXUCoFLRq6+GwlBZaCf9ViHrWbjQUmk=;
 b=Rg4k1knrSE3q5MCDy2a32cx1BzCR29+j3nF5VS4+cj9CnaLcRRT9kOEj7EFFfS7MCufK7F54e/9ShY8qOs1UfRBDkP4L6T8EE4JMSgVDIXvI4uHBzALJ1ZIBr7ipXigHYBfWbcVx0TN8jwVzx8gW6aiNHtLl8jRaHobGMysTXAK9RvKK8IRqnb6MddQyAPP8w+bgNv87uk4T+sQi3WV9pY6upnom0J1xXYrl6Vd2OROC60JzO0zbPM6Al2jM6dnIoEvN7PNWhQ4ITUh4Nc4RX8C6q8OeZLsc0apN7wkfJunfOZf+49Rj0rGTGUB5qK9LowEc3vx+hjyNzCRKUOdPfA==
Received: from MW4PR04CA0099.namprd04.prod.outlook.com (2603:10b6:303:83::14)
 by DM6PR12MB3385.namprd12.prod.outlook.com (2603:10b6:5:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Sun, 20 Feb
 2022 09:59:34 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::cf) by MW4PR04CA0099.outlook.office365.com
 (2603:10b6:303:83::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Sun, 20 Feb 2022 09:59:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 09:59:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 09:59:26 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 01:59:26 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 20 Feb
 2022 01:59:21 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V8 mlx5-next 14/15] vfio/pci: Expose vfio_pci_core_aer_err_detected()
Date:   Sun, 20 Feb 2022 11:57:15 +0200
Message-ID: <20220220095716.153757-15-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220220095716.153757-1-yishaih@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1534ffd1-f486-4518-098a-08d9f457b233
X-MS-TrafficTypeDiagnostic: DM6PR12MB3385:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3385E88340930C586E9C4D2AC3399@DM6PR12MB3385.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AKz6jJqFRdFWl1Y0UBuZ2ki2St1M/GFMjuiRuDtGQ+gISmD9lVfVmPrHpiviPTOHtdb4k9HiPjfbH37kq+C4zUlK3nxUrbwTOB4BPkY9sZHQpVdEQaMOoOwDR1lgC9+BiF6TUQIvl9Bv2kLmbAKDICXhWYQvwzg84YC8OTFLO4c6jvfShVx0SmiwoKuwOIS8UPY+IMN4wgHQfO9Il5RbtkooVG1ClcYV0wPgo1cUl38eFb4+vhocYyO+A84HJfyzaqYdmviGlie7qFRH6wZrcE8OfkKS21KQXc1iJTe0tsckqMFCEaZWdwzO4KEZ+EJp97vP74lW0Vai0YV84E/Yp63VrGQuIGOJxbSlFbyFt32wqnSzpsIGpLiFTANGnwMTzoWaTssNRh4/woMFRDiGbsYHhaaEvFqc9h7WmFtzJhIdeHzZWkYLHyUdtnI8tet3+ZswJQddKkp83DsrVVBDy1oNA2+oJUskxF0ypmq89Fzhg0N6Hif6d2424AeDwp7xN1ZXujMAZj3Vbkv7JOZRb5N1RFGKa84OBKJg8oxqRq7YWgUiF7lBv547JeAoD7meX2KwZREK0fSBD8fIWNJkJjCMgrmgKU/vgvR3U03VM3GBlIP1sGRy8FzXwoUu4ur4vLGUjxnA3v+SjJRx/gvZC5uiqCnWXkKPmnq/TQDw8KNA6k+g68uG4Ib4lKjau6nA0pcKTbvrUOnehV0XNY+epw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(7416002)(5660300002)(8936002)(7696005)(82310400004)(6666004)(86362001)(2906002)(83380400001)(356005)(81166007)(110136005)(54906003)(6636002)(316002)(47076005)(40460700003)(26005)(186003)(508600001)(2616005)(1076003)(36756003)(426003)(336012)(70586007)(70206006)(4326008)(8676002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 09:59:33.7563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1534ffd1-f486-4518-098a-08d9f457b233
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3385
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

