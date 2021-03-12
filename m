Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB433393EC
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbhCLQvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:51:52 -0500
Received: from mail-eopbgr750043.outbound.protection.outlook.com ([40.107.75.43]:40394
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232248AbhCLQvg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 11:51:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FO8KsLtpefa2xQm78LhZ8awKpQizl8tC6zQ2RK2JcTlgQndk+7hYk6ew+rGM7hk0AWAEr44kscffjHgfPEG9rVPH0qpLG3nK/SQG4nn0Y1x/+kUOp3i6YQ5sGLimioaZQKXOp3RBC58kzoIU8LUMbBch0VnHST2KfT/GVat08EO+fZrlasFSkloSk1Y/j7+V/CeImEe4iXZjs8i0wQzspsu20JlJ7pJbkX1mZ/zi+bgsv0ODFfvxNu7YelQM7nididD+pilnFrjPifuPBeG80YPgeQoikHhf3PtedxaFOAbb5h6F5xNr8HYZoVDBifcAm9wddOsT/9LH7K3z0EQhlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e80hNM88nVkYWOuBoubg8UIvi5fU03TVoJJ3zQG6jmU=;
 b=azxtmaLxUv+62CSo3cTl/Ql2RRSv5M1kyTRX8YXbXFKGNiOS6GPO8GNRdeFzWYyxXNuBoy0tBzSGbG0KVlP3kl1BZMRR/9SMFgt7kMDrCUsHu4brxaAzX5SM6HtKU9QvpkenLoTMyuVJTrp9Jd1uN0d2TKo/cosOFgBH+RiUhBhXyxKsl6b/1MMPrdZvGCQ7lmOaamlHpoZTUuU6NRHR4XQkCUtutEldJpHRerRe0LzKwccVdL6PU+JDHB6WRef+7W6nPqKX9HHXfAcyUYFYa6Za4nwuvpQdQBoi8BFAArEVlUKRhej9v5nf+rntv6AZ4MyIEUQdZ9klqMG+GXP3jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e80hNM88nVkYWOuBoubg8UIvi5fU03TVoJJ3zQG6jmU=;
 b=ck/dWtmSI1MAPLletZQ8C1rP1DeD3VD158h46mEprCPzj00ArU6Cb10c3ysrz/8ufRYSuesrqhocRqLghqGAr0x3SSSFS1sxkuYkesR2lZfhk0r0g2FlT7jniQEdb94G9WyKjUMlSSLWzTmp2N2JEP8lvNhVMXZ59fLg5GHUZ+NZLl7gbyqDX+rh8Co4QQGSygqBF05jJ0d+75hg0aty9QgUY/RGkSl/owy3/OyK+KF6zfmLbRmX/ISbtwxi4El+27ylNagV99hmlQr/ICfUVkhHeq4YvxSw4+fnyrlWGDI4Et+OaFkBkary3mij+8KmKnnaarEU9WKkao4wUfe3AA==
Received: from DM3PR12CA0054.namprd12.prod.outlook.com (2603:10b6:0:56::22) by
 DM6PR12MB3337.namprd12.prod.outlook.com (2603:10b6:5:118::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Fri, 12 Mar 2021 16:51:33 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:56:cafe::92) by DM3PR12CA0054.outlook.office365.com
 (2603:10b6:0:56::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend
 Transport; Fri, 12 Mar 2021 16:51:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 16:51:33 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 16:51:30 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 06/10] selftests: fib_nexthops: List each test case in a different line
Date:   Fri, 12 Mar 2021 17:50:22 +0100
Message-ID: <14c08ef572c7ee338e5014842c7e66dbc9416045.1615563035.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615563035.git.petrm@nvidia.com>
References: <cover.1615563035.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dec3656-cfd4-44f2-66e7-08d8e57717c7
X-MS-TrafficTypeDiagnostic: DM6PR12MB3337:
X-Microsoft-Antispam-PRVS: <DM6PR12MB333770677E102EBAE0812F9CD66F9@DM6PR12MB3337.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FHNTc5Fnn8v30v5+A4WqlpCSLy7hKT9hmjuoMknBfhQIxHDbgTfj4nb7UndYPHLKB4d3GGOrlE6F7Xe+9uN0t+CxY/F3l4LuWmdGou1HVd53+bD+VZZpz2Kxzo5uuD9INh13ZUeIsiIZtLQuWmRZn3o6d3uJs/0xLeYqzbElu2L6IefeqQTZw6efKdzFzEsj29p1dG5p/0zQSSD0R6mdiDnyPiUH0L4TTEZQr8Ty6OXIucy3LgTz8l2Z7UBOk56NaqvMw63U8AU7L6Rnm3PyBefmrBMzSqlA4b6sdCEzoVYqjcrD8Skn1wUUbS9nfX5D55wG3zdj1UvjIL4ZViZ2TwCKSaMiLfMWssy26IImJCSawmZ2il2HFWCQAY2kGlkKmFOD8eS2u9lWK1Fm/sSzaqYK1mMeSvP68BPF9iGhyts5AwgDIj9u0e+pL5hyNd8rr4jKMN2naRe4ANS91ezTQWfEFRCIGOAt3RY8F75EQnAXgOJJB5koovuGLoogwoFrYw3cKlpAQ8xoVUKpXhUnAL4ClBk9zsR+Yr+QwKny0c1+jiSIPuNUWoKSZM15jeTJt8tOUuiqq3g6l1bsKjC7BdRRoXFIsUMgBAOwJQiJKrF0pVeAPjF16reeGPyRxplfuDAT9E5SeXqkzSZfixjdaSXeNXUg/gSCzI8C1OVBB+JrQTXO0Yh75BQ367DJhq8A
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(46966006)(36840700001)(26005)(186003)(2906002)(16526019)(36756003)(4326008)(2616005)(426003)(336012)(8676002)(8936002)(6916009)(107886003)(86362001)(316002)(36906005)(478600001)(54906003)(36860700001)(82740400003)(70206006)(70586007)(83380400001)(7636003)(356005)(47076005)(6666004)(5660300002)(34020700004)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 16:51:33.0881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dec3656-cfd4-44f2-66e7-08d8e57717c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3337
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The lines with the IPv4 and IPv6 test cases are already very long and
more test cases will be added in subsequent patches.

List each test case in a different line to make it easier to extend the
test with more test cases.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 30 ++++++++++++++++++---
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 91226ac50112..c840aa88ff18 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -19,10 +19,32 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_large_grp ipv4_compat_mode ipv4_fdb_grp_fcnal ipv4_torture"
-IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_large_grp ipv6_compat_mode ipv6_fdb_grp_fcnal ipv6_torture"
-
-ALL_TESTS="basic ${IPV4_TESTS} ${IPV6_TESTS}"
+IPV4_TESTS="
+	ipv4_fcnal
+	ipv4_grp_fcnal
+	ipv4_withv6_fcnal
+	ipv4_fcnal_runtime
+	ipv4_large_grp
+	ipv4_compat_mode
+	ipv4_fdb_grp_fcnal
+	ipv4_torture
+"
+
+IPV6_TESTS="
+	ipv6_fcnal
+	ipv6_grp_fcnal
+	ipv6_fcnal_runtime
+	ipv6_large_grp
+	ipv6_compat_mode
+	ipv6_fdb_grp_fcnal
+	ipv6_torture
+"
+
+ALL_TESTS="
+	basic
+	${IPV4_TESTS}
+	${IPV6_TESTS}
+"
 TESTS="${ALL_TESTS}"
 VERBOSE=0
 PAUSE_ON_FAIL=no
-- 
2.26.2

