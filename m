Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760D6398991
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhFBMdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:33:02 -0400
Received: from mail-bn8nam12on2079.outbound.protection.outlook.com ([40.107.237.79]:33089
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229828AbhFBMc6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:32:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSW3P9kRtpOclwTuaPXWvZqPBu1LNvKh2E0CirGtoHGrFYkH9793vTXIt6banyR7IsOni8ZRTpgmqGjLDj6mg+yacP5+1S9yzYGJsZg7j2QD4EcK+cfKJ1TCPF5ep9PthtP9a6Pntyerxq0wGVPJU4qb83eulSLKUK0l+amLCTk3mNmB61yO7/OYrCR8cvw+MjKsgKYkZ7X1sc97X96sep1VzCITOpgZN6Zxvi2IXQ7Rib863DGlGrAFWXu7JWudJd0BMXTmM9Nv9hLTeMNmJJNG4mZaNe9u3RUtTFCEypNDoXNqtJrwxJemAm93SgPJpAA0mO0rpiX+AT9xj8tBAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NE5B3qxn8XNStV8xoUvUEnaZxCtUjYEkqXMVWBfNNt8=;
 b=jCpupYG+a8O8Z7P4FtNFSFuesQQiv9Dg4re33fy5UYc8X8Cx7gDQU48zVmyygHsex+2+S4RuZO+525gsUBvEO7fbGDKnn/kwv3YsmgwGLxDvS4Z8Zc2U1eNba/SsgisPUR4bytLtcbkrPO3O8s/vxq5pZZXeROqfGbwq0LipAMfkPeyzWZOOtWyelVtQiULMAGTS9/XU4hXwRRQJnx+SMMVS0O8JiFoHtKkKxP/LTVg9ES9jqaxcPigZ08xNdaUfG1EV23n3Wm03V/KLNmHDJmyZDScVr/hHHEglV16gj/3uAFhH3JfCTO3tKk9MISVIZBlqeHIy2zrpKszbCkxKKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NE5B3qxn8XNStV8xoUvUEnaZxCtUjYEkqXMVWBfNNt8=;
 b=CGDv0cVf7YBSMnxmjIHgIZ3mjFyQI9Ki3hI0mSk9AMPFx/NYht2/Eye62lvMo1TdqMLQTSbnQyX513Fgk7z6OznTe+f7+QCiHAhuKocscklXOaqCa0SEVNb1NLm2tGg5KEEUw6ud6+QgLCBttjZr8T18LHp2CJ8Pc8+ThYc4RJ+0pc+EEjjuF78FaDva44pBPzxJWUyAWtZd+Dak6EUifXITe6Q8yByxrymj9mrtuBBI+gBblfk2Jums2VTOPCv5bo8+IDh31dRc/Y0hF4kPt3RQ2vtDR+1XdrR6gAVL5QoCM5G6bCQHIYD8u/3fOYKbW5ygo1L2VH7B/ph6OnwNcw==
Received: from BN9PR03CA0577.namprd03.prod.outlook.com (2603:10b6:408:10d::12)
 by DM6PR12MB3084.namprd12.prod.outlook.com (2603:10b6:5:117::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.27; Wed, 2 Jun
 2021 12:31:14 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::ac) by BN9PR03CA0577.outlook.office365.com
 (2603:10b6:408:10d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Wed, 2 Jun 2021 12:31:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:31:13 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 05:31:12 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:31:12 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 12:31:09 +0000
From:   Dmytro Linkin <dlinkin@nvidia.com>
To:     <dlinkin@nvidia.com>
CC:     <davem@davemloft.net>, <dsahern@gmail.com>, <huyn@nvidia.com>,
        <jiri@nvidia.com>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <parav@nvidia.com>, <stephen@networkplumber.org>,
        <vladbu@nvidia.com>
Subject: [PATCH RESEND iproute2 net-next 1/4] uapi: update devlink kernel header
Date:   Wed, 2 Jun 2021 15:31:02 +0300
Message-ID: <1622637065-30803-2-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622637065-30803-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
 <1622637065-30803-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a24e73f-9be0-4f36-257a-08d925c24f5b
X-MS-TrafficTypeDiagnostic: DM6PR12MB3084:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3084047CC99BC974B210567FCB3D9@DM6PR12MB3084.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HiR5kcSw9bMFQ06fOjMY1/rvYXblr01dKUMmCQ60XRR0apOCMbBOwOcPECZF0znRXyB9UE9CmhHlLxf3YkM0Jn1Rlya8ng7Rj+xJBVexOgCsEG6O9Ct9lRxpBVMTQ1+g0pX3xufNBQTeXp7lIy9hr9H98EY+L+02j+0EfgqLEGZo0VOP3/OxTcgza1n2Ov4m2jFWCiYgGLFF+tNB8F3E4rZEAOZRlS754ARWIYDRdNGDRdpAaod5bC1OOl7nW7seDPmscDKAnuTv65BGmUqHKcjQICfOYsmER9Rdsj+S6SsDGuqPLF/2vA+i2rIz9LVb7tiiLeyAL1Go00Uz7r4D4OLwMffFj0QbUt6T8ko3sFeFFEwC/+e9wLOmbltUm/FnSTTEKGnWI4KcT0z2+g86KdxsB4AW5xTFy1nkIE/EUeQqLEBf42/UWsW/2IrCn2QVLYJiZosZqS4AvnmhIJ4y3S2y+fkEzHpty4UOfjSZ7lVjpoKBCmQK1PEXSQDy8iZp/DnJrEXdXy8cAZcCi2Ahe2KVaGqmDYKgR7K7zI8l9fyn4IqPNEQqTZYrA5rITdmQQiZpR2ot+1SsSpofGtRu6pWgcYcSVabgz40QWNdVxxOgPqNvwgTLbozHVd3uW+7SdD6ob+dcy765+eMzzxv21Onj4Wa6/rhuBh6wqMFuRmE=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(46966006)(36840700001)(7696005)(2616005)(107886003)(8936002)(478600001)(316002)(82310400003)(6666004)(356005)(37006003)(5660300002)(54906003)(86362001)(15650500001)(82740400003)(70206006)(186003)(47076005)(36860700001)(6200100001)(70586007)(26005)(2906002)(7636003)(336012)(6862004)(83380400001)(426003)(8676002)(7049001)(4326008)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:31:13.3073
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a24e73f-9be0-4f36-257a-08d925c24f5b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3084
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

