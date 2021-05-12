Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE3337C0A9
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhELOvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:51:35 -0400
Received: from mail-bn7nam10on2072.outbound.protection.outlook.com ([40.107.92.72]:58753
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231330AbhELOug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EUOgHPVgTWdRGtkkJcYBJaeva/GUXp1KCvbOJ8flOZbnyDQ2+FNofBi1K7JA9uEc6fZrTgl6DzB6OPTePHiKb8WsKAjQoSw3x8ZEhJx/zAgJCU06aQFVAxFv5iAL9ediomA6CJ615g/eo3uPFpU9ah4eI34jAShfKIH1yOXQe+LV7HS4pyDMOpEKkc1oiZHI8EDrXw2Y2mIXYq9iuDUcsXH1V3B4Sh2wprxdVqw1jNPewQCu+JKT/+uFtpMRO1C1i0thhfjhNDRkQKiIbAGBEUmPnepNqwu8/LnsSd1T/7lVfr/1R4+yNlZH07ngTnvVaV0bjP8S2EvQCTbq17Vkpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JZM9C8cvD2UVV84x0mxd9HVJHTmhdrJcwzwdvwuD8w=;
 b=VqVmEadjXq4rbXwzzJ1/qJ47kWntrxN9M9QLIXO8NLlnDTLPNB8zv19B7wBZTRe7DrCoMWAhhC844gRBQzIXGJaRnniKv0Lr/kyJZ1AgXBkJD8/k/+OdbMf+JefFCqvsRYmB6A+uLpiYgxxBNcxGBslypktHLibQgVus2dJNz/iHEcDBapJ3zxgdIAHEjuW6KjzUsPGwaKj4rhA1xeg75kkAIoDt3UJyv3WHgM8XWEZwq7Wg+dj0ToBizkDuAu77Ft3SL6KGyxH2jyvt4Cnf8ZScMrdREC/UWCSgxtACfFAWp5cVUeOCifFvj/C4TqGEWJyKUTrgYJQmDkhmE55eaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JZM9C8cvD2UVV84x0mxd9HVJHTmhdrJcwzwdvwuD8w=;
 b=oWXIR4I/+KkTHBfeZ3STavKlQL3SdGfOXAk+yj/SVS/Hg5ygu7xF8nlq8GdI3Vprp94gsaYM9nKfDBrNGFwWILEEf7/90AAddkIjOyRtw/xuh6L60XfenEvjrP6ogcbxaLLSKwOuF0C72MW+kEcRkph+GhxJ2YdoN5vmMJgKCQOnsnqeN3K7zT/CYTJT1Pl8PeLJ3izIB/3PQcrlMXGzTPScLd/PtSVhJ5ACzsvrbXBW4a2sw4bxUmn11cOoHthnRFRFUYcSrvze6yTETlEEpAeuL2IHFle1IlyuUjYbwMWgBVykxUL/Gn4FiowE1LaR0f+2h1DW7fmp4nmgovxd/g==
Received: from BN0PR04CA0075.namprd04.prod.outlook.com (2603:10b6:408:ea::20)
 by DM6PR12MB4057.namprd12.prod.outlook.com (2603:10b6:5:213::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 14:49:26 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::7) by BN0PR04CA0075.outlook.office365.com
 (2603:10b6:408:ea::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 14:49:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:24 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:49:23 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:49:20 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 11/18] selftest: netdevsim: Add devlink port shared/max tx rate test
Date:   Wed, 12 May 2021 17:48:40 +0300
Message-ID: <1620830927-11828-12-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8700068f-40b4-4c45-7eff-08d91555225b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4057:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4057B89DCBD2FAA5F979493CCB529@DM6PR12MB4057.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FxaBBotPWg6TVzbowOXsNm9iKvhU9uw7rX8Gy3NgD1oCSu+UZZrKuUnhJQ3srNKXx1v5xdWtbsYQ+ir9jrc/qpYQKtKpZiMg99oInbrXpDBy43vzBoGvTw4wuIKsId6NgrrQrX8S8uMtT4mLR2FiFM6VtWPSIYwp8QLc/WJMPRcYHhyGv7lVLVXh//0bqxj7rL4VaKM1yO3fYH/yXqASVMol403Mt+8udiqjB1ThgbZ1/X3N6XHpnMBxK12/tbmW1ExUZTY/Deq7jxwrF4soF6pnqPd67wtbflpTYR6XPOzOp+QbBVTr1fvkgbIuKTRYZsc1jgsAEWYimyCkMScD6qmmuZHZaZ8KLa4smNqW8U2FIyp9h3qeS5HVgKZaWZWRplBZGEJM1xyMw5yi17mzPucqH1veLtNFP+6Hvfh/XeI0Q50QXCGIbUni7FeO8PnppOBxdh654xlwBjP4EDQsEB1lALXAXSOFJktuJdUWFPMdqhDTq++t4zDIyIt4xxzhrKJy+wUKoYgy2hoerVIadM9tiT2CdwzDklItScETq/uF/paAjGhGZNLgwEqie4Jy8b5cUoyEfIakgotJkHZTL244r5mzN+eh0ABagVhbV/G/YZCdQBIBuusxEtsFKDdtG9qZ50RR6ot1wQZKh9Smrg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(36840700001)(46966006)(6916009)(356005)(6666004)(478600001)(107886003)(4326008)(2906002)(7636003)(8936002)(8676002)(2876002)(336012)(82310400003)(36860700001)(26005)(2616005)(82740400003)(36756003)(54906003)(70206006)(86362001)(5660300002)(426003)(186003)(47076005)(316002)(70586007)(36906005)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:24.0631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8700068f-40b4-4c45-7eff-08d91555225b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4057
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

Notes:
    v1->v2:
    - s/func/function/ in devlink commands

 .../selftests/drivers/net/netdevsim/devlink.sh     | 55 ++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index c654be0..05dcefc 100755
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
+	devlink port function rate set $handle $name $value$units
+}
+
+rate_attr_get()
+{
+	local handle=$1
+	local name=$2
+
+	cmd_jq "devlink port function rate show $handle -j" '.[][].'$name
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

