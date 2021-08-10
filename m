Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336583E5959
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240273AbhHJLrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:47:15 -0400
Received: from mail-dm6nam11on2061.outbound.protection.outlook.com ([40.107.223.61]:48096
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233318AbhHJLrF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:47:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ib1RVgCopUJHCHkqfQRpyw8DIFP08doEhHny9AmHT7cwcAglI8cnmnkHS8q+oOwYJW8upyxICnvl780B372N6goUlAMaM4cJvason1b996iMGQjGtbEvDrz7+NWa3KmE++TDgJo08JZeSsMCb4lilwRgpCL232u2ALxa/ZadKvuqZM1bH7vnhOKgTP0cUt6mF7c8BcPGLTiduJaHdfdjYMhey6YJjqCZxd7GHw2TZZk/9kxcoJESvGoEaSl8Uqbqqui7CfsUoUVGpD3tk9edtgTB4gYTFAAY+3dEpJdpD0gYlnmQYY3sSJUVzfw3cqpwaL9LRiNnTyenOwP6XO0WlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=drnAII7q7Sg0ir7JPDzE3fON+Ec+o1taOtnrCCLk71w=;
 b=X6he/hR1EUOF6JzvrozUVjmzc6kNLSQI1PJ7d7bzUmICEIsffJG4jWiTGJYWEKVeuNJPplNybK3UNZpc2nyh9PXJOHTsilEwPA61u9hKz2M2llOWYaJafLyulM4XjITg1yr8FsHmqNxLiv6qsWH5GwqVZf/03yB6pdyBxdjwrvLGWEayseC3WYj9/zLTp3o+MoZZsE1SzV7YjWuIYfZTIpzWQ4+d3hmpKiyeCDXFhr287wb2MDFHKbvBvhi++TZzoEy5a4g18VnkyhlBqhuMHZM+7hzzegw/T4fAGtGZSHkSiWdgYq3gCJ34Un8SRkYZJfzhpJe8LhAddDqxqxtVZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=drnAII7q7Sg0ir7JPDzE3fON+Ec+o1taOtnrCCLk71w=;
 b=IX2sJ+G8sQHXmQ4Zed+89G/EfFjl/46QSfc2q1oXM/M61R9FHmXjskbB+mtEgJL0PJvFgKp+u2KnR8mvU3JoULHKSEH3IZlXtA9ZFN/IrfJ5eFCMfyzZ85JdStCELfP+tRH6TrHpSZzZJbIeSIEBN6M8G90Vu3DQ2cWxic+vsGmt5e27MBVTduiD+eObXxIS6kq/lZx/ABlnM7lnLEDrWIMWojoPmbESbQmer1L5oa2AKV9xYT3d4G9OXEqj2UhhvU/Eq8kP0ItioezpT02eSHApCv68lPcFpBRDJhnYM0PL/ttveoxgl+HV8+PmQUqlJEr1RBkGUgqFo79eCV6CaA==
Received: from BN9P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::17)
 by BYAPR12MB2599.namprd12.prod.outlook.com (2603:10b6:a03:6b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Tue, 10 Aug
 2021 11:46:42 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::52) by BN9P222CA0012.outlook.office365.com
 (2603:10b6:408:10c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend
 Transport; Tue, 10 Aug 2021 11:46:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 11:46:42 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 11:46:40 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Leon Romanovsky" <leonro@nvidia.com>
Subject: [PATCH net-next 05/10] devlink: Add API to register and unregister single parameter
Date:   Tue, 10 Aug 2021 14:46:15 +0300
Message-ID: <20210810114620.8397-6-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210810114620.8397-1-parav@nvidia.com>
References: <20210810114620.8397-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de0dcb91-0bac-4705-4133-08d95bf485c8
X-MS-TrafficTypeDiagnostic: BYAPR12MB2599:
X-Microsoft-Antispam-PRVS: <BYAPR12MB259977866811368B1B304130DCF79@BYAPR12MB2599.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xdGz1qTyUydGsc/1uk1kHPzcxx7pPSbJClee1kqJUAZHQqg+vUQ6J7lr76/1asyaph3UiesFRhS1rGXRQ5vWWiHNUDUvleptmkTdM6RcNubn/7oSo2FD8nLQjAASBw/TmZmFthv183G3iwe2+G4/EbX8JeZAF9ZuUCNuuj0o5Lk569QifKY6QA8nJts34pOWI8jl7F/kOP54jKU6cvtaAX2YDnLQCZqWOdOt4rt4RoMOtIbw7Z1H8H54YJRcRLtsIDccgFHW/rgelILmgq6OQRBui7XilNuARi6MUh++iGkauziRsWKpECOxn3XIobPYyVCU0GRcv08CXVXpp6oGu+DvrmySRH4z3qYSZsQI/JGkKtD6BESGW1FytgJIksrriqj2eYBH7fSvfjvi7Bqo9IQE/Co7K1VqdUCBhZHhZUdY4Mwul2yQz2sYfLTCIdzrj4vLFNmYM23sizoA1xLIDpvSE8g5e3f5RZTooEUAOXeQotYV9hyROcH8RzazDKDNWS7saz5ntyWNB31tvh7Lr8bbTG2YclpN+nY5Pg+dCwY2b491Rt0JqhYgVanPWOcnAZdc3SnmYUnO+cPCNDK1HtdIeK0UfUCaNi1N3sajB38tLL8o3M8SaS/2ByLM0FpEFt9QbATL2hwybPe2g1APMTR0VWNcoFUBY22Y7EDuD4Ke1p8+wjEWhkMueZw0ZN4A
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(396003)(346002)(46966006)(36840700001)(70586007)(70206006)(8936002)(8676002)(82310400003)(47076005)(336012)(36906005)(356005)(83380400001)(6666004)(16526019)(36756003)(478600001)(26005)(86362001)(186003)(5660300002)(36860700001)(2616005)(2906002)(54906003)(110136005)(7636003)(1076003)(426003)(316002)(107886003)(4326008)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:46:42.2118
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de0dcb91-0bac-4705-4133-08d95bf485c8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2599
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently device configuration parameters can be registered as an array.
Due to this a constant array must be registered. A single driver
supporting multiple devices each with different device capabilities end
up registering all parameters even if it doesn't support it.

One possible workaround a driver can do is, it registers multiple single
entry arrays to overcome such limitation.

Better is to provide a API that enables driver to register/unregister a
single parameter. This also further helps in two ways.
(1) to reduce the memory of devlink_param_entry by avoiding in registering
parameters which are not supported by the device.
(2) avoid generating multiple parameter add, delete, publish, unpublish,
init value notifications for such unsupported parameters

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/devlink.h |  4 ++++
 net/core/devlink.c    | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 0a0becbcdc49..f6459ee77114 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1645,6 +1645,10 @@ int devlink_params_register(struct devlink *devlink,
 void devlink_params_unregister(struct devlink *devlink,
 			       const struct devlink_param *params,
 			       size_t params_count);
+int devlink_param_register(struct devlink *devlink,
+			   const struct devlink_param *param);
+void devlink_param_unregister(struct devlink *devlink,
+			      const struct devlink_param *param);
 void devlink_params_publish(struct devlink *devlink);
 void devlink_params_unpublish(struct devlink *devlink);
 int devlink_port_params_register(struct devlink_port *devlink_port,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 050dd7271a45..629291175af3 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9903,6 +9903,43 @@ void devlink_params_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_params_unregister);
 
+/**
+ * devlink_param_register - register one configuration parameter
+ *
+ * @devlink: devlink
+ * @param: one configuration parameter
+ *
+ * Register the configuration parameter supported by the driver.
+ * Return: returns 0 on successful registration or error code otherwise.
+ */
+int devlink_param_register(struct devlink *devlink,
+			   const struct devlink_param *param)
+{
+	int err;
+
+	mutex_lock(&devlink->lock);
+	err = __devlink_param_register_one(devlink, 0, &devlink->param_list,
+					   param, DEVLINK_CMD_PARAM_NEW);
+	mutex_unlock(&devlink->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(devlink_param_register);
+
+/**
+ * devlink_param_unregister - unregister one configuration parameter
+ * @devlink: devlink
+ * @param: configuration parameter to unregister
+ */
+void devlink_param_unregister(struct devlink *devlink,
+			      const struct devlink_param *param)
+{
+	mutex_lock(&devlink->lock);
+	devlink_param_unregister_one(devlink, 0, &devlink->param_list, param,
+				     DEVLINK_CMD_PARAM_DEL);
+	mutex_unlock(&devlink->lock);
+}
+EXPORT_SYMBOL_GPL(devlink_param_unregister);
+
 /**
  *	devlink_params_publish - publish configuration parameters
  *
-- 
2.26.2

