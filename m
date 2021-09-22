Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C19D414528
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhIVJcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:32:52 -0400
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com ([40.107.237.72]:49952
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234107AbhIVJcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 05:32:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rpe6qfwrB30nbWSO2mO1/aFIFmrGB4vNJR7bcRd2Vf/ssBUdTnkiL2L2IyfjjcmQED71/YUcdVHQFQsCZASe4b5Fr0b/W0X1dodtx7xUEqrLhs4viH6+0BdzBPypBQxHjMMACuAGwNNVqKOLSrC5zp9y4ZqMOrfZz6BbGq4PhiUItbDW4KPpbLzoyZ5rMFa01oPZrrPMsqv92PobD+Ixmt4HS1vmI76TNj0kOH6D91+PnD9m84umfh97Fc9TAyijKNrRic5m4CH2DOR5ebsvUQncXwSKUiujG4dEpRPbl/ZlL8+sPlQzg+XxER8RFrsfnCrp8HrznHQ3Kv7D8QsxKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TyH6dVba1CT3KazWgMyIHtm/na+nMwaAiIte1JFHKXA=;
 b=glW6kIrmR4VTHekuHZT7luJMZcLtguXIInvkkvLucHORruCFKSRHtHhoJLr9IRMvc8ZIKPoaTewmCh2wGqcyJyiETLEQIIk0u4/UIl0CTVX2Z+zARf/6+nr6lbhfRBTIjR/moSZkSfnEJeh/Cby1erT0X9Q7WWlcXZ68Je7Axlo5CvvxD8o49upayvXCIMeppZCJCNHYKC9dN06xXktB364bKZuibeTFceZZp3Tkr1fudm3F6CSPrzuRiNNj10Qdz3fc+rUEqAT2hz4LzcPFMZlfJPN+DWaSgBhgsP2zl2R/1P0P0/jjl0IMcOv/pwq4kBBsQaG5XkPILGX3wOYW8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TyH6dVba1CT3KazWgMyIHtm/na+nMwaAiIte1JFHKXA=;
 b=Gky45yvxH0u7T08Vm5aSw7bPXt/q31WdBAMNG7/aoyGI6JrJzEXyD6WO3CMpvQXRGR/UB7N53qAJ3xwY2vAfifirYV7vJ2JDeIi2AVGYgx+C5NIkdPWg5HultXlfcQysne2sH85wPCzRJb5IipykV8cDP1JRkFt2kpOGtiKzgKniKSOYz02cgm5h9xPNtu7pVy8wzKq8bd4AIi/xduuU0xpfXAAXMVoKS6EsLDG8i1EG8iCJR9bTckbUYfsR0UDpaxJHTntv3hx2/ndNvrcKKmbD+efUmWDh2HN6OQc5UCTTPqcq0S7cznz5ktRIPBYbKUPWy+7hUVj43uCBs0QQ2Q==
Received: from DM5PR13CA0026.namprd13.prod.outlook.com (2603:10b6:3:7b::12) by
 CO6PR12MB5475.namprd12.prod.outlook.com (2603:10b6:5:354::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4523.14; Wed, 22 Sep 2021 09:31:11 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::4f) by DM5PR13CA0026.outlook.office365.com
 (2603:10b6:3:7b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.6 via Frontend
 Transport; Wed, 22 Sep 2021 09:31:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 09:31:11 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 02:31:10 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 09:31:10 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 22 Sep 2021 09:31:07 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <dsahern@gmail.com>, <jgg@nvidia.com>, <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH RESEND iproute2-next 1/3] rdma: Update uapi headers
Date:   Wed, 22 Sep 2021 12:30:36 +0300
Message-ID: <20210922093038.141905-2-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20210922093038.141905-1-markzhang@nvidia.com>
References: <20210922093038.141905-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99b45c60-2a97-4ea7-6013-08d97dabb708
X-MS-TrafficTypeDiagnostic: CO6PR12MB5475:
X-Microsoft-Antispam-PRVS: <CO6PR12MB5475C0B85538F01FC32C1A80C7A29@CO6PR12MB5475.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:110;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHqzxNuTDwbxvsBA6T8adALxaeNrz84iBcLjooYRm6YZ1hBRCrQiYF4zFi77awDuK5cVA03VnkdidieGSmroIHW/yEyvJSiktkeW47Z+NlH/XOQ4PQg8XBVjdiSH3zmrdssUGD5YG1T+NCiFcYPdme+1duPGsotN47XZQHw1wTYat5urO2R600CTkx17ocbPZv8WeEpnNb+z3TZh79CrEjVSn+tTVF0VgyQaGs31csfvzCbWF5p0gcGPdNPzFICdHYUglsWjlbOHjF+6vT2N5v4xSSzd4Mr5FZTMT9dQCoHu+bprIID5EmR0SwzjV6eJZiZEExlBq+GFbiIvV5wnQbYq0mFoMpDLsd8nqTufCB2rWvly+XNirMPXSMY1+/rvgkBSSp72RhhXWcaCn/TzNlwFkgrmf6qQl6TFQbAjZAeMd4lJE+mt91Z2uDdq+o0YvWGaKrtPMFjJb9OLALfxZ7iMWu786i/ZWiImH6n0jmstWgkGNBFNSCoyuZLzPKvWEcvsgVvPlW1W2p7ioP3mjbdSDY54TqQJRITfDmllklGhaC4KmsuBKuqPk99UX9/EinX4INCFFvnI8FFb65ZLzNIpUibkvC7masCRrwozx1w4AF32e4WOEHNW0+EVmVK/cT0UU3BW2OpSOR3eYs+LTQFN/VMjPxOqSILjTEqbWeA/Qx9sIbNMbKL7IAwBn4sHkHNa98m/yZDWtgxUxEHeSw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(2906002)(4744005)(7696005)(82310400003)(110136005)(7636003)(70206006)(426003)(316002)(8936002)(5660300002)(336012)(70586007)(36756003)(2616005)(356005)(15650500001)(54906003)(6666004)(186003)(36860700001)(8676002)(107886003)(47076005)(83380400001)(4326008)(508600001)(26005)(86362001)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 09:31:11.2135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b45c60-2a97-4ea7-6013-08d97dabb708
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5475
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neta Ostrovsky <netao@nvidia.com>

Update rdma_netlink.h file upto kernel commit

Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 37f583ee..fd347bc7 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -549,6 +549,9 @@ enum rdma_nldev_attr {
 
 	RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK,	/* u8 */
 
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_INDEX,	/* u32 */
+	RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC, /* u8 0 - disabled, 1 - enabled */
+
 	/*
 	 * Always the end
 	 */
-- 
2.26.2

