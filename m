Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF033EF096
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhHQRGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:06:03 -0400
Received: from mail-co1nam11on2083.outbound.protection.outlook.com ([40.107.220.83]:43835
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229723AbhHQRGC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 13:06:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lfd8T1SswVn3QGxS5MjDyIaJPRts5x8+JHcwVEj6vcks10u8Kti6RcQo5MiVGzL/tqH/OkZ63CpO27AxnX2zlUApQYW80vnwLFEW+17b54f8R/Ou5Jffj8M1kb10oWK98IIN9nJNEpXynIX8nsybHf+jeuCfs8vsg35pa8mrUnH4cDdkEM3LHbbl4T+CaQiMykf3YihUqga/oF8J3QnpK+f5uSVc9VPxbIK0qDxFTkz+HYCiTTX5ghFl6FOgHTNnZV1OPWri1fFBDs6DumCaCs6MiZgWaLgX4Dstjtpasi+BhzhCO8I/sQUKTa9ZC8Ne/Fldqw+CbZEzaWLXkGgBfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=52oneabHlPm6S92t8xhNuz27khF1eVFLyU9tmmwFjXE=;
 b=HRS7RVwSGVZO9YUKCw8hCPLqR9BaCB8bw3y6ThHMOwxlyGy8/MJqWwncwd5m/fBeCycOWjWizeXhKKkSK8UQXhfEDSdH5l2FCkcaD0aXmc+Uy++5/HQRjsyz8aZyvGvxPab+bF24l8uFE2aBM0KvJ5TRGhamMhc3tsS9vfMisF76o671mLTCxGhslHZZtGRxQ7SNvvvfrybzvjl3SPGn9zoaXPNhEKWNJqJS2fFd7aJnfQzOtRQqFhS/ZBSws63CXmKFADt3qM75ioshX7zuZ17QOIWqeYUCOLfDUkY73DIDsDJbTnLR+E22gChW5Oet8s5KTNhHTqRHUlIQLVM4aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=52oneabHlPm6S92t8xhNuz27khF1eVFLyU9tmmwFjXE=;
 b=sWRVO72B3LMZJxajSPoXm1zuix+M70sk0dTUsoyY6X6k3jcxR1ZtdbvDsZ+0DB0YVRlLsc73+/wL0/vobEejbjHdCu0gFzxQXTlQvt3gGT9UQ6dWuebsX8MgERXeR1FV2eMLLCHzRf6vj0X7RAaVM7EYQfDozR/0fWR/I+spCgqnEAj5jrlDWcMa6XYhvrsMBviXEk77XxzUY0PSGwWNRtFLnYuJCGTJYY1TCqgbjMzSNIGWUWrYyT295p1KQME7GmKwXULACCqMbj3ZRFocHyv7AUHfIa+e3pj0jdBTkSi7EHZA+yx8uHTPzuzdgPTUQyzZBNmOrTUFVYsyAAJ/kg==
Received: from DM5PR05CA0024.namprd05.prod.outlook.com (2603:10b6:3:d4::34) by
 BN8PR12MB3492.namprd12.prod.outlook.com (2603:10b6:408:67::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.14; Tue, 17 Aug 2021 17:05:27 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::8a) by DM5PR05CA0024.outlook.office365.com
 (2603:10b6:3:d4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend
 Transport; Tue, 17 Aug 2021 17:05:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 17:05:27 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Aug
 2021 17:05:27 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Aug 2021 10:05:25 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <elic@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCHv2 net-next 1/2] net/core: Remove unused field from struct flow_indr_dev
Date:   Tue, 17 Aug 2021 20:05:17 +0300
Message-ID: <20210817170518.378686-2-elic@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817170518.378686-1-elic@nvidia.com>
References: <20210817170518.378686-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4ed0204-4bfc-4fcb-d890-08d961a13607
X-MS-TrafficTypeDiagnostic: BN8PR12MB3492:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3492B8613135C3B6F6916908ABFE9@BN8PR12MB3492.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:291;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xr2GHaZ7czOry+1LEXvB9s37IBbys4sap9ghcnGVTbtKMGkD1j1YlPDMyTYJhlK4nO74gHkiWiaq9zpSpObIn006hw1swv03D1b26K27ZFOdKxQ1IlDuijliEqtWYzlG9zUmOt7R2+RxZXgnGsbKmS3j2rt2REcOhuzp0Ar48RJs3uo20Uko8gCHL9FfCXOKZJPb4dURcJKytQVPAatTup4kGgMN8sl8cw1Y2fiC7e01jTRSX0AfnGcPpo9GRPzbCiwnpnVNn2IntHsKfudZWAJzOm1rDLVMkNe0pgme1/EpVuX+1CWHVhkyVSpo2l3Ws53ieOevrCvpxt/SQm4f1kRph1QUiTdsCGKIBRMKKS7blz8q4p+th+kDhGEn7bGiS4GE45AAx3PJI/HoqXOSqRjYp8D7KmUDtkEE1Xme/nGCqQCudy4aymOzkEkO6Ywam/pAS4+Q7pXissT9vJI8fQbmKapZNLz+7ADGQWp+bXct671382R0d+j5zeXS7nQbdaTP6yucHfRJKd601l3ZR4SHDHmflM4RsUAgCZmow5vk0grOhKw1DiZclB8DwfvP4M+sxJox35/1Mww5OYlR6Egf6Lg6QDFYps/7S6J+flyxbQM3b5EcXQiNagUqxUZbvmyjp7Y1XBAQdmT/PyTaTeU/sP4unFB52JCMNqlKztpF1UpMnzaOcdk/IGH4EWSa9NdUFpjwTEGRLUoijj+8w==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(36840700001)(46966006)(47076005)(4744005)(5660300002)(36906005)(316002)(2616005)(7636003)(36756003)(4326008)(107886003)(1076003)(6666004)(8936002)(478600001)(8676002)(70206006)(110136005)(54906003)(86362001)(36860700001)(356005)(82310400003)(336012)(7696005)(426003)(82740400003)(70586007)(26005)(186003)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 17:05:27.2679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4ed0204-4bfc-4fcb-d890-08d961a13607
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3492
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rcu field is not used. Remove it.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 net/core/flow_offload.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 715b67f6c62f..1da83997e86a 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -327,7 +327,6 @@ struct flow_indr_dev {
 	flow_indr_block_bind_cb_t	*cb;
 	void				*cb_priv;
 	refcount_t			refcnt;
-	struct rcu_head			rcu;
 };
 
 static struct flow_indr_dev *flow_indr_dev_alloc(flow_indr_block_bind_cb_t *cb,
-- 
2.32.0

