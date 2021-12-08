Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A00C46CDFA
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244366AbhLHHEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:04:09 -0500
Received: from mail-dm6nam08on2081.outbound.protection.outlook.com ([40.107.102.81]:19553
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244367AbhLHHEE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 02:04:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6a0OCzFRwL4k38/7d+VaNcKTLH3oypa3FbwBjp1GTlOwPL71GODDxDHIzvok9HmrcrosTtd35x2HgzTLf66pxz5ua5S+6+F4mkkHMdYJE4hXX076spA/Ed3UEhU6iH3Y6D/nCp/00P4IZy5dD2/+E0AoicNMsIgy1NMRMl5zDFqzZ+3R0ztvv48FTL2PzMCsS0ZuPyiQL/+zpXw6GyoqfeQWh/nWeDWADrlT/Na1M6SFKsyZOWQIQ9RVjy7hUDYWJv2RytvdqJPrvSLWBmFeMHR1elOWwgOHe+CBCq1pin/vFcLU/h8FE4aQIiQ2IRA5XQXGrAm17C4f766xV+gBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2jtDw9rFt2BN8ZZw3K8mKy5FqnzF66bVj4IpnDkcjhE=;
 b=VxpmOudMmZ4NoHB17SWwEAivsJrt4tEzjq8MxXbQlNmdvpND/0tqMFV4awvVXMdg1/80pBeXeCeRYDdQVu4WWCViGwGQrFVyj6m7mmabYnolugRXsYFz0dUa2sgilDduGc+Zmmt1cduWTfluRxMAvvKps2N8VbPil/28O/JfsIwNUL1fHUfPKeqbiEY4VUSsiiCB9Y0OXHzIFPEh2Q7yoRtVayurfo7nvsOeGdEDKqMaaeyeBSJ7D+W7iq+hmc21biV4eL7ehuJEK6zb0jR3QX71NIXM0R0XZkGN8xwsoeex8fBE56dWB5nmkmH+co6kylW30qWE40O2QD4/Xks2xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.12) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jtDw9rFt2BN8ZZw3K8mKy5FqnzF66bVj4IpnDkcjhE=;
 b=jEzg6kDzGbPjlNkMj3ZsjwLeUM+iw/he85Qtqr73bCOM2JadUKug7LjKoyTIYKfW+noDgDIMRjFZDIAD9UdBgb5syOEtdgF322phjpDUqpA4NM0G+LaKw4QbvR1UkwnFPvLx3mXjqdZPf1Og0B0qdh8Lo4EedBjjQeR9XSu0+oy1GAVYQDXby0n4PUo8cR4wC/1rkx3tu5lzuKtsC0k2CFdDffzPibfpjzUnb7NKEmlEfK4hict4lAA9K0my9zqcy9MO4mr0lUjnwvCnlyQnK+8pQkSkTY91tHHUoahfm8JoGHPblC37V/MWUQfUR1l9qqXqc/qYoH0WygbP1+2i1Q==
Received: from DM5PR11CA0012.namprd11.prod.outlook.com (2603:10b6:3:115::22)
 by BN6PR12MB1186.namprd12.prod.outlook.com (2603:10b6:404:1c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Wed, 8 Dec
 2021 07:00:31 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::6c) by DM5PR11CA0012.outlook.office365.com
 (2603:10b6:3:115::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Wed, 8 Dec 2021 07:00:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.12)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.12; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.12) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 8 Dec 2021 07:00:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 07:00:28 +0000
Received: from nps-server-23.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 7 Dec 2021 23:00:24 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@nvidia.com>, <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 3/6] devlink: Add new "event_eq_size" generic device param
Date:   Wed, 8 Dec 2021 09:00:03 +0200
Message-ID: <20211208070006.13100-4-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211208070006.13100-1-shayd@nvidia.com>
References: <20211208070006.13100-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69ab7de1-6a43-4cde-2616-08d9ba186c64
X-MS-TrafficTypeDiagnostic: BN6PR12MB1186:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1186CDDD2AC760D4C4401617CF6F9@BN6PR12MB1186.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2zMNuD8ChsLumqjRQOHvM1EHy6jtkwDc9sPJvzymCmNhZ+1imLR/3wYMDu5LBhNafukPMDpnBSumvBxLqCA1zr455IP/qoc9nTIGpmXRycLj+cT9SeKnosC2BmrNNKx9ldhZQ8VBj2InLkRCpfC4+XHQSMhD1r0ZxrqQBWO5qYuvmBLq0UYiQxI3soD6ywgxF22lgAbWkdaKJqBOqI6j2NpwsUq3Ol5Z9meqK7l2XiLbMdjZUr9lCuPfKN+n9Kf+Mcpx0EAXaDpO76ZUHx0iTe7GYAn99pYTej+EIRzYg+/JTIet7p1gW+gWYpVDBoTAEhX+HJ7bg2kYp+62A5jWC2uJU/ZXN3G7a98eVXCXvs8PwYFNhp1jPwsbjWzyrNQV/wc84ktwzJ5CZGn9/CgtDwRZO5qZkk8PkI3qa0Y2W76oCUiz+Ngk6sZgEdjTHPxbPl4wuXQU8Vezu6xek7DzN4krNBQ7y/Ie4Bmbizt44x+MyI1B5FY1b1AciUtTDbaUdPk5g1cfV7ml+lENkr4AP5nmu+ea/1nw9JtYjAeIpm/6EzD17GJr13N4hIAmt7DpY9yuKbwfqbj6ZLtPGNUOfzuQRMTTlSbG/klZPBKavBuqxn0tvMBclZ+mdRDypo/q5qRbtoDOUPSZAh7Yf86kpTXr40Comuf71k/fO8oTHm2CfPA1eoLteM3pkf6zE20k9hbOBGjG7tNoJJF36gkIs+R2wFgFK5Uj2wWddUI2652tmKGqEJ1Zx3IMICkpfZKdtQgGfJNP1b/sXubxKaJ10mqeZ9Qecgd+OtS1H3ij+2VpYdRvkTAtTtvIPMdMqu7pWSldngmUBCClSBmOgpatEQ==
X-Forefront-Antispam-Report: CIP:203.18.50.12;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(36756003)(70586007)(83380400001)(508600001)(186003)(6666004)(70206006)(82310400004)(8676002)(107886003)(2906002)(1076003)(40460700001)(7636003)(4326008)(2616005)(16526019)(426003)(5660300002)(54906003)(110136005)(356005)(34070700002)(47076005)(26005)(36860700001)(86362001)(336012)(8936002)(316002)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 07:00:30.5589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ab7de1-6a43-4cde-2616-08d9ba186c64
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.12];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1186
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new device generic parameter to determine the size of the
asynchronous control events EQ.

For example, to reduce event EQ size to 64, execute:
$ devlink dev param set pci/0000:06:00.0 \
              name event_eq_size value 64 cmode driverinit
$ devlink dev reload pci/0000:06:00.0

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 3 +++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index cd9342305a13..0eddee6e66f3 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -132,3 +132,6 @@ own name.
    * - ``io_eq_size``
      - u16
      - Control the size of I/O completion EQs.
+   * - ``event_eq_size``
+     - u16
+     - Control the size of asynchronous control events EQ.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 61efa45b8786..99b06740a918 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -460,6 +460,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -515,6 +516,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME "io_eq_size"
 #define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U16
 
+#define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME "event_eq_size"
+#define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U16
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0d4e63d11585..d9f3c994e704 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4471,6 +4471,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME,
 		.type = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+		.name = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME,
+		.type = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.21.3

