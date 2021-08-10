Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABC43E5B67
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241408AbhHJNZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:25:12 -0400
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:12129
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241352AbhHJNZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:25:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REnZPelCuqpl6LqxCPGCJOQT4vUxRdQMXBl3gkYXPpLfV7M53EKQb8VEex9P4vz9Zt7zohbuq1Ltn6iixOh00lcHDfYMlI1pFs1ZzAt7VEAeGhoFAkRMY53H6t04rnynxCKAbTYwUNA2Zb0d1Lveqop6QXtpLneoxR/jcGiKCMl9cj96IOMuW/Adr3VPuyPfRJeyjCGYxMUALjiC4hbGKjJ6eg0rGcoo5JYkVXfZWR5omga+a+PCtRsrM6TJ8K0VYwU3u173JFoXWmLQZIJ6sNB2Ekg4AM5jVKetEm9+GkgQ1ZYvO801Nwg7HpTmzKojtfj5yJjLFV4zP3XGFYD4jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMMYImPDjzX3tlIYCUsUxidRBJpfw8dwpK6xM3+B8nQ=;
 b=MPMqMKkwoC4+TqyKoynS50qEWWe4xPE625dImkskNmYlGMZWRkpD6t+WDiyQhg6fZ/ORN5iwbueKIcSpyo9w6g919fDS2W2gEV6DWk7makr1tubASc89SzDVZZHME4XnJQcrkuYd8DwvljZj2tWo0Ck66xYpUAMA5MHtQO//Ft59NqXOGcRvrAIL4cjPUZCCk28qsCmYV/85mMnBK5GymNmmiWXwgzridxhC26Di5fcWF8DKJG0u/LfVLNB7+O8P4VsWF9lU3v+irSxFFog98Avc2cAbQiTDAJ3aQ3jhqFIr0HSxD+/qqTz84V0L4Z2BxxoFs0HrvwWut6fDEg4t/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMMYImPDjzX3tlIYCUsUxidRBJpfw8dwpK6xM3+B8nQ=;
 b=gXGDLBI2Sv3t+48JzYmyUruhO/Vn7AYmBO2WznBvpj/k1ld8pJFzyMVv/7477L39QZTvzbjmUpOQ7PuuyfW09RwB/QfOBUgd75rq8g38JVE8brnzNZrOaIhv2ir3lLkflJGudP9cS2d3/9S8/PI9hSNeMNDmOmp3lUzFdW2i5ZnKzsQD3e7uQ3y60bUYYpV3c890skq2tZwMnyuPHAs7WfwH0g3DFYcZnlXfNl7uvrChX5ns1YEnes7ExTzFRjbiPbfyOO9ir6iXvyoU/FX04n1KmNpwoh/RuGNwA1yG0X5rAHyw0qStVUBGdmGu30H0g2dbCtWLM73owLeDXnPaiQ==
Received: from MW4PR03CA0028.namprd03.prod.outlook.com (2603:10b6:303:8f::33)
 by DM6PR12MB3738.namprd12.prod.outlook.com (2603:10b6:5:1c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Tue, 10 Aug
 2021 13:24:42 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::56) by MW4PR03CA0028.outlook.office365.com
 (2603:10b6:303:8f::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend
 Transport; Tue, 10 Aug 2021 13:24:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 13:24:41 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 13:24:40 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-rdma@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Leon Romanovsky" <leonro@nvidia.com>
Subject: [PATCH RESEND net-next 04/10] devlink: Create a helper function for one parameter registration
Date:   Tue, 10 Aug 2021 16:24:18 +0300
Message-ID: <20210810132424.9129-5-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210810132424.9129-1-parav@nvidia.com>
References: <20210810132424.9129-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea05471f-88e9-4b64-0d5c-08d95c023651
X-MS-TrafficTypeDiagnostic: DM6PR12MB3738:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3738AED47E382E02A3E0B4CCDCF79@DM6PR12MB3738.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:597;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ABp869X4oxi+hpwgEeNYw8FFrIb14PR/7tOZYyQMR3XIShi+goYyP/SL3pEsqGuzxurjWpOor2GqT1gO9dgZIcr/cPKUb55EyYZObvMQfqQDjPfAQgvgjNC3McE5lO5pRcKX+rcZVODO4HfCC6XsmqlJp3LjuuqawPQD2Fx3KFeRI47W4PJBPuIXRGbyIxFmj5Pl9PAOuojBoART/aDvgYh9AXsfXvz1deqp2py0fdI7+UCvU+a0hpA4v2+kjhegJpiYFc116Zd48dtTUUq9CNNAhvIynBd/3Pj0HB6NDbvczn4nMG1emT54P3qnbFHC2QlwUpEcBhG2ot6s59bvaRNrNtQ1cYUT238mxT1mfB1S+ubqPQ2RU+t7O9La5oScHZMPTOgtov6Ocq7wPUcH+UKXeJrqfbzVcVPWlqpHTNiWQM8IxJX2xID0sk3fizWWgW7mf6E+lxBrMageEUms4oRr17/Jl4KeMxawdv8boBdD8+hUgBZp8hFin00sZi4M9d25Z16TuhTUOD2NhgdLR44zdvCbpxzD63b3XNNchrdUETgIYln6jqqVQponIDh9RSJ3gbtQ5Kjhq/7KX525gcsXXSW5Ks9N1mqtTyKmjovXXsM2tR8iP4J2pWzpbGlRfmomLMg4kkshZtI1zFJMmtARz9st/7k/NoAEIxSO5bSpHMMQg0PAllG4E/S2gxuBa+9xpEt4su+CrGsp4gEx6Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(46966006)(36840700001)(7636003)(70586007)(1076003)(16526019)(54906003)(426003)(70206006)(478600001)(8936002)(186003)(36860700001)(82310400003)(107886003)(2906002)(82740400003)(36906005)(47076005)(8676002)(316002)(36756003)(86362001)(336012)(110136005)(26005)(83380400001)(4326008)(356005)(6666004)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 13:24:41.9487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea05471f-88e9-4b64-0d5c-08d95c023651
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3738
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create and use a helper function for one parameter registration.
Subsequent patch also will reuse this for driver facing routine to
register a single parameter.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 867ae7e39788..050dd7271a45 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9800,6 +9800,22 @@ static int devlink_param_verify(const struct devlink_param *param)
 		return devlink_param_driver_verify(param);
 }
 
+static int __devlink_param_register_one(struct devlink *devlink,
+					unsigned int port_index,
+					struct list_head *param_list,
+					const struct devlink_param *param,
+					enum devlink_command reg_cmd)
+{
+	int err;
+
+	err = devlink_param_verify(param);
+	if (err)
+		return err;
+
+	return devlink_param_register_one(devlink, port_index,
+					  param_list, param, reg_cmd);
+}
+
 static int __devlink_params_register(struct devlink *devlink,
 				     unsigned int port_index,
 				     struct list_head *param_list,
@@ -9814,12 +9830,8 @@ static int __devlink_params_register(struct devlink *devlink,
 
 	mutex_lock(&devlink->lock);
 	for (i = 0; i < params_count; i++, param++) {
-		err = devlink_param_verify(param);
-		if (err)
-			goto rollback;
-
-		err = devlink_param_register_one(devlink, port_index,
-						 param_list, param, reg_cmd);
+		err = __devlink_param_register_one(devlink, port_index,
+						   param_list, param, reg_cmd);
 		if (err)
 			goto rollback;
 	}
-- 
2.26.2

