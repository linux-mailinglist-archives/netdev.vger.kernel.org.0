Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA664C2E32
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiBXOWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235526AbiBXOWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:22:41 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BDA1029E5;
        Thu, 24 Feb 2022 06:21:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EV4gjwUSobuila/7LcbQBgD536z+WG7dm4ihaam2IDWMCzu/IDv54TaV9fT5ODRRFvD9eqUp2lixG5X+3w8UTRKUO3WUMx4PJw0ZIdRaF12QPBeMDxgorN5NT6CiTwq1lWBo8yENWCO7IDhFnIvrs7x30qj+CA9uRYNwQ8Wqjwrm++70brImxU7Fe9GBzrB3acd6EZiqpt88vvahAxtMnp3KNG9lwgyDKWFQP9lRBfVoQfch0LsFNUIWKJsuu2m5qVjZXL9eyCGY8JQk7GLDiKsQ0Y3aC0SskCATzx2EJh74F19PWp/9FC+hQPcO3QXizJrIesUbgoqYZ21a/JXvfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNQgaDTdj4EZWXUCoFLRq6+GwlBZaCf9ViHrWbjQUmk=;
 b=avztDS1OO7MwanVxZFQgJCbyvv+ZJpnBbCHdyrHk2zRAdQdj5jMUZ2E5dfHG0eX6bnP+EVi9faTWNc3jM0uckjIXfIaGqlqIRvic/BdoiRxl5xvcEJHnD7QEpa78TG06HQfUUnkLs5YAt0NTlMMAdmpgd9uJMGay90LUosEY/cNX47byUvl0786zbxVLSCRqXl9TY6nyaIriU4QpsZpnI7ieFo7QOsaSi5Rp8gHyWoUa0+eIA8ahvR8UJaLbMtpD6GCQ5kqRz1Iql1Ms+BnECrmjefhm0PRK6FzJR5akrPd8FglJ3Qeb45+KuTinghoJNByyZnD8KFJS/BcYxXk+rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNQgaDTdj4EZWXUCoFLRq6+GwlBZaCf9ViHrWbjQUmk=;
 b=KjXkz1xJl8oBPiUDrT3en0/2tVxR8QgWNdjqaUVM4czX6iyp3ui16xBjsB9h1er4KCK3cRxKblJrq/QpgMUHeZkxiMgFyheDg7YtHtz56r+x98cjLdgJnPS6H+emwkv+i8ZnXj9t0tJRtN5Pr9fMBGeO6X7Gpr2MDa7U0dai+ZkrLNaned5T8/28zx+JuumVsmprBskfda0PrwIwY8+0/PWvGHZNdX5e6UeWvKkF4PGvB7EjVA12jHY4hSSxBunh6R7W+x6AYf6MUdFGl9x+RJ8lFVZcffAeEs9uSE4sWngtVzXdJk26GtnQjU6rn8uPKcReGFe3EIA3W1g5Yvl37g==
Received: from MWHPR11CA0035.namprd11.prod.outlook.com (2603:10b6:300:115::21)
 by BN6PR1201MB0163.namprd12.prod.outlook.com (2603:10b6:405:56::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Thu, 24 Feb
 2022 14:21:56 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:115:cafe::49) by MWHPR11CA0035.outlook.office365.com
 (2603:10b6:300:115::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Thu, 24 Feb 2022 14:21:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 14:21:56 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 14:21:55 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 06:21:54 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 06:21:50 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V9 mlx5-next 14/15] vfio/pci: Expose vfio_pci_core_aer_err_detected()
Date:   Thu, 24 Feb 2022 16:20:23 +0200
Message-ID: <20220224142024.147653-15-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220224142024.147653-1-yishaih@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f45433e-c3d6-4899-28d0-08d9f7a1032e
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0163:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB01634865A18BF0CC15ABCE2AC33D9@BN6PR1201MB0163.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e+QACybnD8x5z/htXUkw0/wFY6t0sGFSP/9qKHJ2D8Y7sss6sFxRF4YYrtb+scpm7M9Lt/KBprfzFZpBk2AMR+2F9d3lW62zAR2DvsZKAXeu7RTpSSmgigMQa5+yH/AL91S4vXKt+LzJfbJng/D4Z1Wiv0goDllRzGnWuUWJ9TzY7HIiAL3jU6/IZRujV4TADkRc16z//7LwxrClsKSyEXhrmkqYOW579t/AjeHcXkucjTGVRfoh3VbhcWT8zy+H8dnDvToN0Gd5F1h9TudXRxPiFo11zOA0p7q2k9tTopG89JcQBOo0ZBuIiuWeI/1vduvLNSLcGde5BmJhgmNPefBW7ruBWkDsGRlYkLeOsWMW6+u3OV9cQH1U9wLgBSzWYl1J+nrRFxQsHPMZjNpKHiKKZP14yl7R3BGpkbU5YKQvXPbRlsJzDDFgwi0B+qBiLK5cYEbycuBS5qSzCWecwFjK36okuEIoRhVpQUdMF1ejN9MViuOeHaOiWBtIP/1UOw1bTBfIX6CVUh7i8zR1aS0eK/iDyL/Ee+4eYg3AfEow7pZtywshjNtSzf/86+XRpCdtI+dRXVKJwf7HLe2WVeAKkzxxnW6dFP31cjF3XPF3uwTzheaPX2klejMRd31tlWugJzgpJJDIRVn0EvhOqsAZmOPzvQa4w99VqeOTMN1sQsPhMsuld/ilt6yJzeoJEp5Dens+U3dZW3AkiA16Aw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(26005)(70586007)(6666004)(6636002)(5660300002)(4326008)(316002)(47076005)(36756003)(186003)(110136005)(1076003)(83380400001)(508600001)(7416002)(7696005)(70206006)(2616005)(8676002)(426003)(8936002)(336012)(40460700003)(2906002)(81166007)(356005)(36860700001)(86362001)(82310400004)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:21:56.3694
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f45433e-c3d6-4899-28d0-08d9f7a1032e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0163
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

