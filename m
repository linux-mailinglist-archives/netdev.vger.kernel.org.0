Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB23366F7C
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244159AbhDUPye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:54:34 -0400
Received: from mail-eopbgr750049.outbound.protection.outlook.com ([40.107.75.49]:33661
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244169AbhDUPyO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:54:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NAOxrky/S9LAdyK9p0FdMBkjq7uDcJhR0E1VFCct7tJn0fZtxOnfJG9TBtKKPAWHP40KMTzZklJSEpd49OBrMDfdTapCiPQoCSVVDQ8RiUkKthMl2lo58jhLcbTyBHHrnsj8ZXdWT/i+Yxux2W4fsYxt7/X19j/CewjkOmTH2GVpO4ZjcNjcogkwIK6u2/YwJKamIaJ9uKoiY1PvXYhtJho+mqAquEEJzp1gl+nuMuOYdb785yEwK/j/NkXtgisewUqftqkl20zKmjug3PC91tTQOeZ9zcmsjLfAc/7OG+3sHPdy+4fZ0XEvzMGUBzVT4Wyw9sFkoHwhhj1PTQ+YlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YDIJRr9/oRAxDtMDHFTD40odxPuUACu4zSDwFKfqOI=;
 b=afnsGjnAYhxTW09g/iaODZBlPwfXnqEfpSYZAC2G2J32Rw1O7Bejp8trdlDXRc0jfUS8nryWyOG1aZaFBQXe7DKfX6N+AdPF7QLkFebmu0qyiZZAO24VYXiVbOu/IPg0zVqW5NOo66FalvoAhO6q+hSM/2pYL//1wrPijACWecAuTNDxO6l+91Kal2N9DPo1s/FRdYIVn8cfyha1iHNpambWuop75WQ6Sk/nJJm6cFxStnkvdoAwK1zomYEY44L2beEIAaNOjA7bovqQqPhnYP45fEqoj0rBurr7qh4GGV59F+8gdkmfvUGfSsCz1uE8/2Let9fmFWR/vs8zmk5JNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YDIJRr9/oRAxDtMDHFTD40odxPuUACu4zSDwFKfqOI=;
 b=FgW1U8UiXzJdBsEN34OpfsFRS+wgvbsa0eWxCmpSJ9sUhK4mZBpDhL8bMA08IfddNzI6cXzW2GfJIGcwGzaKOJmo2Ydg5PccBaR1ASpN3ZfATmS3fGAZVgOCipPZMoO/r73ibumWeMy8a27vGundnB/54Mi72IBH2BnJX26tR7jT1bhxoFpu11cG1QfkcD3Dq4x4Yj0TU6rIjQLIsE71BA+Xwnn3pTKPTkEr1n6EbOp408ftbaQWTYvV61e2iimLKuANxf25p+eDpDlU1A+YLwVzePPOsg8SC/2urZXAoSlW97hh/SYEB+pYY6D5SceXuqdNoBeObHV6AOgDy+Vx0A==
Received: from BN6PR20CA0051.namprd20.prod.outlook.com (2603:10b6:404:151::13)
 by CY4PR12MB1719.namprd12.prod.outlook.com (2603:10b6:903:125::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Wed, 21 Apr
 2021 15:53:39 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::be) by BN6PR20CA0051.outlook.office365.com
 (2603:10b6:404:151::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:36 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:53:35 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:33 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 11/18] selftest: netdevsim: Add devlink port shared/max tx rate test
Date:   Wed, 21 Apr 2021 18:52:58 +0300
Message-ID: <1619020385-20220-12-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d09d457-71dc-4974-0979-08d904dd9fe8
X-MS-TrafficTypeDiagnostic: CY4PR12MB1719:
X-Microsoft-Antispam-PRVS: <CY4PR12MB17199984E8A0985F84EA256ECB479@CY4PR12MB1719.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: erQFgyaycgyVGZs1SKyUnqgBzy0Wtbpl9h0qfWRkDMgB8tCS4GVwpq5ZyVaKtYHMdvxwyR02gOnzzphHEGjRedawW4LSlhAKEcwA58K9QeB8Bo21aUXKutRVATuEtY3+hl54cSUOVLuEKmmIqPis32E0nmLdFYMbSkGhFNgxMJi0rDEvaFWun/40WccSFc/dw1GDqVhdyODXYykP25kj2N/o/iDg4e0DiWbgU2jvFxdaIp2vxt6pjCQafugre58bxALFJ9YURVwxmPhez1o+DLggxRYiVetky21musjkXHPqlYyBvqC4MUUuaeq3Jdf2v7QEqzdepm8/we0ScHn7O4/k5zTg7q5v2zPNChulO4l/tOtG5mRRSmWCTdnS8qYXs1i2WqWiGoujVw/o/FW3t0XG/u/By+PfTspzXjYgw1wfKt2LR2y75pSXjKDKI7NQzlQsrP+061ps4odBJn4t7SSShs6ZOuWqC57FycKJSVuqRWZb7jDIWsW4r80A3QVLHzGprpNOxPZaz6U13L+WHT66F80d+EAhOG12WBY41UPqMPadA2pdL4Y7V+0eeNk4WHvplE1lGjT2JpPj73g3dpbJyGU7rUnpXP1l6Fif6cuD8DluQZrqtoWcvVQhATPy8bP72LWW0rXyoTVUxcEmiA==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(46966006)(36840700001)(70586007)(356005)(6916009)(36906005)(86362001)(2876002)(82740400003)(2906002)(426003)(70206006)(36756003)(2616005)(8936002)(82310400003)(107886003)(5660300002)(54906003)(36860700001)(6666004)(47076005)(336012)(8676002)(186003)(26005)(4326008)(316002)(7696005)(478600001)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:36.4884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d09d457-71dc-4974-0979-08d904dd9fe8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1719
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Test verifies that netdevsim VFs can set and retrieve shared/max tx
rate through new devlink API.

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../selftests/drivers/net/netdevsim/devlink.sh     | 55 ++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index b8b0990..c4be343 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -516,6 +516,45 @@ rate_leafs_get()
 	       '.[] | to_entries | .[] | select(.value.type == "leaf") | .key | select(contains("'$handle'"))'
 }
 
+rate_attr_set()
+{
+	local handle=$1
+	local name=$2
+	local value=$3
+	local units=$4
+
+	devlink port func rate set $handle $name $value$units
+}
+
+rate_attr_get()
+{
+	local handle=$1
+	local name=$2
+
+	cmd_jq "devlink port func rate show $handle -j" '.[][].'$name
+}
+
+rate_attr_tx_rate_check()
+{
+	local handle=$1
+	local name=$2
+	local rate=$3
+	local debug_file=$4
+
+	rate_attr_set $handle $name $rate mbit
+	check_err $? "Failed to set $name value"
+
+	local debug_value=$(cat $debug_file)
+	check_err $? "Failed to read $name value from debugfs"
+	[ "$debug_value" == "$rate" ]
+	check_err $? "Unexpected $name debug value $debug_value != $rate"
+
+	local api_value=$(( $(rate_attr_get $handle $name) * 8 / 1000000 ))
+	check_err $? "Failed to get $name attr value"
+	[ "$api_value" == "$rate" ]
+	check_err $? "Unexpected $name attr value $api_value != $rate"
+}
+
 rate_test()
 {
 	RET=0
@@ -527,6 +566,22 @@ rate_test()
 	[ "$num_leafs" == "$VF_COUNT" ]
 	check_err $? "Expected $VF_COUNT rate leafs but got $num_leafs"
 
+	rate=10
+	for r_obj in $leafs
+	do
+		rate_attr_tx_rate_check $r_obj tx_share $rate \
+			$DEBUGFS_DIR/ports/${r_obj##*/}/tx_share
+		rate=$(($rate+10))
+	done
+
+	rate=100
+	for r_obj in $leafs
+	do
+		rate_attr_tx_rate_check $r_obj tx_max $rate \
+			$DEBUGFS_DIR/ports/${r_obj##*/}/tx_max
+		rate=$(($rate+100))
+	done
+
 	log_test "rate test"
 }
 
-- 
1.8.3.1

