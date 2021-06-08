Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1390939F4D9
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 13:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhFHLYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 07:24:37 -0400
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:63968
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231866AbhFHLYg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 07:24:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPpXwVmxYphWq4QsJg98CHK2/o6N2GzmxX0gYR9bpTRh+WlSWb1B5g3CDfhhcYfih7A6lFG5vr58DvY8KzNTxGZQMwvAXB3aJ+mpQJBwExnTg2gAeW9j3qbyn+d8klo3TGt/uZ4CYwRtImrzkSVxuxMkx4fBPHB3wd4hnRYezbJ5rnZBuSRgGK2ViZIasz5ikJ/chBMHZFLm0Dvwi9yVC45+tJimV7oY4+/N86dlLDA5SaC2nfpfzTTxPLTQRfuq1WzQcyvrdsCPo7ZCcxQbGOdmSfEh8lU8LykQ6hmxcsjA2tVVDpsllxVksEc68Xpo9i69Jlh70q1FRs14egbXsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olVyyWd5jy/nH075ilXHUd2fS1DbS4/x3flsA+f/DKw=;
 b=OHujMkzpVsVltseOQmRL0zUXvtfza7RvCh5CzEIIdw0/8q80dj2xKCEbG9mCPSNSqqfq9QEwX66BwP6laBDV88IvVGGuQeuhte1TRQrVDv28qnsCoDDADofKYPsThb00DopqrxMFmS4iu3v1/FsDUYHTH5jTVxpVp+72A4aZ7HUWvwhZ0Dc8qqO25S+4K11ihw4VmORiRQOyTkRjyXs17uFC0rr3OExNkvO7V49KR7n6oVKkIhsn9r8JPhsbj3FQFeqQXGTtgNC9PvBTnBblLId3j+ndnTe3Iue3iwkO4K0bz1+X0gvOY6J/JtkSsyioiJGpbf0PNU5Y3EpWarjR5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olVyyWd5jy/nH075ilXHUd2fS1DbS4/x3flsA+f/DKw=;
 b=tOhkIGuacHC2HwIkJP4CX6BZmMmS6UOufR+XWpRrV7j3OJwPtKXX0g804FVVym4p81QYnYOEayYAHZuqc7bony2ilqnvlIZxrq0tjwL19wFm2EJCWHzSrrvEKH0VpndYOrREfn2mcslw3wspMthYq6mdjMWIyuXrhTWA7x1Bo1TPf/HTYpgZ1wVK/DGOl0zzAu5KzEgLkd94LnyzqXJqtQK/dKkgnLtl+USO62H9+bexZozMKoEmkTVZhDCVm1M66fY9Rypr+KXNrwPyE73K70w2jeATaEmsRfQ1TQigPcIwLdlfvaZFVPY7+Gg1Nq3uHXePmWaae9hGd7+rfzKKoA==
Received: from BN9PR03CA0518.namprd03.prod.outlook.com (2603:10b6:408:131::13)
 by BL0PR12MB2450.namprd12.prod.outlook.com (2603:10b6:207:4d::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 11:22:42 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:131:cafe::f1) by BN9PR03CA0518.outlook.office365.com
 (2603:10b6:408:131::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24 via Frontend
 Transport; Tue, 8 Jun 2021 11:22:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 11:22:42 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Jun
 2021 11:22:41 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Jun 2021 11:22:38 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        <dlinkin@nvidia.com>
Subject: [PATCH RESEND iproute2 net-next 1/4] uapi: update devlink kernel header
Date:   Tue, 8 Jun 2021 14:22:31 +0300
Message-ID: <1623151354-30930-2-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1623151354-30930-1-git-send-email-dlinkin@nvidia.com>
References: <1623151354-30930-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca23e6fb-8bf9-40d0-2327-08d92a6fbb81
X-MS-TrafficTypeDiagnostic: BL0PR12MB2450:
X-Microsoft-Antispam-PRVS: <BL0PR12MB24509DD06C71D27144CE344CCB379@BL0PR12MB2450.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fB2I8VNT5RLaqC6TCvfAetJQJfMVE4jVw0WAyhOOEFtyTeKi6ar/R23uarn75DOeBZbljIZS272T7ReJqghFAt+yMMVXARs4osf4/G5N62pOfgeeo+hrWlE8aGOuUJlB5gxm9f6tV6HSFOvlOBUDcx5i0n+deAE1FNaiIb+jTy02vIkesDCJ5AnMomAuxaBDouy9uPC1w/PpO22L6BIohGVnDWcrqaGxHpJXiu9+pLj20v8sBXU34CbNqjCOWqfz4iDpU34LCF/vFTYaqf/p8BRqgx9chJNf/SEVep9lcEwaJcTuA7dsIcZnPPLTTe1nidwyNQGJYh53m3vzNO4QOEqNqC7XOtkNjQ20l8lrSQZ0bQi8XN8Tr8N2g8m+X9ZPLRogHtls2xlaCi1s/r8dp1Cx9RKh2DbhqfDrxowUXknvzvVOIoMqHjavSl8LdYErdYekPQDit/CL20u28xAcXq4KQwR5/z7jj2dVOJGJXq7oA0N3zX+QACj993GXzUg3dRFKBUIWdCSQ5P+qkR3wVu98uC/iIKJsdIsJPR5Ws4IBMMZ9Srs5Cnwow5I90PLN60aklJwAIdvMrw7DvHSFl9ftdRoJOLSMyFwvw3sn/z/0i4SxzG2xsJCn09XWfteKYtonjcUenEnuii6w75je0a6lUiQldiXsozArw9YZjBU=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(36840700001)(46966006)(15650500001)(107886003)(8676002)(426003)(2616005)(336012)(36860700001)(4326008)(36906005)(8936002)(54906003)(316002)(7636003)(478600001)(186003)(26005)(2906002)(86362001)(70206006)(70586007)(36756003)(6916009)(6666004)(5660300002)(82740400003)(83380400001)(47076005)(356005)(2876002)(7696005)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 11:22:42.3425
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca23e6fb-8bf9-40d0-2327-08d92a6fbb81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2450
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
---
 include/uapi/linux/devlink.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index a430775..6408b40 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -126,6 +126,11 @@ enum devlink_command {
 
 	DEVLINK_CMD_HEALTH_REPORTER_TEST,
 
+	DEVLINK_CMD_RATE_GET,		/* can dump */
+	DEVLINK_CMD_RATE_SET,
+	DEVLINK_CMD_RATE_NEW,
+	DEVLINK_CMD_RATE_DEL,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -206,6 +211,11 @@ enum devlink_port_flavour {
 				      */
 };
 
+enum devlink_rate_type {
+	DEVLINK_RATE_TYPE_LEAF,
+	DEVLINK_RATE_TYPE_NODE,
+};
+
 enum devlink_param_cmode {
 	DEVLINK_PARAM_CMODE_RUNTIME,
 	DEVLINK_PARAM_CMODE_DRIVERINIT,
@@ -534,6 +544,13 @@ enum devlink_attr {
 	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
 
 	DEVLINK_ATTR_PORT_PCI_SF_NUMBER,	/* u32 */
+
+	DEVLINK_ATTR_RATE_TYPE,			/* u16 */
+	DEVLINK_ATTR_RATE_TX_SHARE,		/* u64 */
+	DEVLINK_ATTR_RATE_TX_MAX,		/* u64 */
+	DEVLINK_ATTR_RATE_NODE_NAME,		/* string */
+	DEVLINK_ATTR_RATE_PARENT_NODE_NAME,	/* string */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
1.8.3.1

