Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B20C398940
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhFBMUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:20:04 -0400
Received: from mail-mw2nam10on2087.outbound.protection.outlook.com ([40.107.94.87]:41985
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229989AbhFBMTx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:19:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmkUUL1C2bZp6ypUXcQK1Qkw8YE7TC32AuFS+jIXwdlRyexKyQNGHM8Eci1g9LzF8tMWA3xYXyvAUtEJsm6Z9t6U2OTzCv9U7MxzwLX1OX5UOGBTuVU+zcLav2mOLEI4olyk5ucEN2chqd5psf1B5OCFpFO8igTBuj+Qa/QExSFxmdvOWJAIhVRh2R3vKMHJ98FK/JZuG13RL3shLG3/jO71p76EcSO0MWvg1MnQeTUrjWMRbjHYoC8waAA+X09kDqN0IzAiesOZus7g8xN8UGbIy4CwvFSg/IM79Ts1PLWTFu6usPxifYTplbx82YAnY9N3XgT1njcX2I0zEyZ03A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JZM9C8cvD2UVV84x0mxd9HVJHTmhdrJcwzwdvwuD8w=;
 b=CYcViaRI20UTO3d37pbKlqcTr5uoJxrxWpcYjsPjfHmt0CEh20KPLNkzmC/8UzyB3lOfNjTEz+BV8K3bTrAZajzWzhBZWpO/jX6EPQhugjx7luN/S7QsiIZooxTvUz4J3vARrcoNslohRMH5dZ6dmK+oNUo20WzvZazZtkK0ZbPgAGY3j3LmSX0IGHe3OYAFlK2BA57QwtwlewS7s8m7DMmin2gdoqwgr244gEkWxHBjkZQHvzC/puQOu8GqGGgBj3Z8pUlAsPVHIDTgiXg3dWG4N3Gcpqt5gDgsRn8LRnz4l/dUFOoD2F0SvSAQeUw1zHWCNnEX9GgtQVXBJdgHvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JZM9C8cvD2UVV84x0mxd9HVJHTmhdrJcwzwdvwuD8w=;
 b=oHPEuwS+Nt2B77oitWj2N7IHtwuG9jG3eYIdnJtKBkmPzgc/E/M+u6uQF1dNOHaFgngyA5gdwwJuDsaWdfYHjtKlSxT3sGB7iFLnikYAQPn20qKZFS5LPkz1tRmFIkN+z8qaTI9/jyKd7lzq6kQI2xwPDVWiu7EonjUFHZV7mtw6CfNm/9BDRCEhdy1LYhfwXEwub6mikhNxqkfQUav6V/tFT0OE8aIMx8dKItmkLcf5if4halXj8TR4WqX0Z1oa+uk46RkdEy+xPoqPEHGcorYvxHCB0RWeCctKhw/L2PeXoYjWy03mocs8OhhagIoN/WYyWbILufa0IlNM6jNFrA==
Received: from MW4PR03CA0351.namprd03.prod.outlook.com (2603:10b6:303:dc::26)
 by MN2PR12MB3229.namprd12.prod.outlook.com (2603:10b6:208:102::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 12:18:07 +0000
Received: from CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::ea) by MW4PR03CA0351.outlook.office365.com
 (2603:10b6:303:dc::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22 via Frontend
 Transport; Wed, 2 Jun 2021 12:18:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT033.mail.protection.outlook.com (10.13.174.247) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:18:07 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 12:18:06 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:18:04 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 11/18] selftest: netdevsim: Add devlink port shared/max tx rate test
Date:   Wed, 2 Jun 2021 15:17:24 +0300
Message-ID: <1622636251-29892-12-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c849726b-5df9-46ad-26ce-08d925c07b01
X-MS-TrafficTypeDiagnostic: MN2PR12MB3229:
X-Microsoft-Antispam-PRVS: <MN2PR12MB32293E639971BD741910D696CB3D9@MN2PR12MB3229.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zvg0vH58v58xXtse/0gjik8UvmoMrjvEdelPAQKRgJdufZ3YHc2+g+ztV1OYc+KkQJmEvlmRIDr2+DN1srexMMjYKVcqweysHsYSBkqbiu7R+3uyxHN4mHv+C0xXI10xKt0b1aS2Ug8fnzCoTLPNggSSmyiTJflx3A7BkVRt8bfvaNX8Mh/4ykHI8vjjMkz+Jp64eT0QSgKwhtj98ftTHjBx11zrlIBNSqZ5jwGsBGjjToN5nITPK6xYRy+PR40dnA5VuaDaa8dl2gehplP7R4/a2DHSYWKYKQ6suZgDufL2IxxF8KwqHRBFD+exlJUrRbjP6IlFPcxSAstUIDiZ7A0sa69/NLizOrs8D1hUUlt63TxZWBddb52PyE226sOhcr83yGVmH4z/L8haIuK2RzpoxEO9stF48/R7IZQ3i2RCLOu1KPDEmld7cRjT4fObsgvlAJJPjO7bKAtpUvRewDXvC9klItbaHJ3pg3/8Nn8GyEBrBgOLj76qEsNcOOdciVBDFdMimrYKIieS0jykL96/VYrXbk/Uh3EGU94bvHsxnhW1oAO0GFUD0kXmbwQId8eaqYlg6cpiv3ZCjASNt0jwADzAErBO/tBVUrE8tREK1nIbYvnVLR2+JZW4QcYC/zlREu8GjiJWNyFUfwVscQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(46966006)(36840700001)(316002)(36906005)(5660300002)(54906003)(2906002)(478600001)(2876002)(2616005)(7696005)(36860700001)(4326008)(426003)(26005)(47076005)(8936002)(82310400003)(107886003)(356005)(7636003)(6916009)(6666004)(8676002)(82740400003)(70586007)(336012)(36756003)(70206006)(86362001)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:18:07.6257
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c849726b-5df9-46ad-26ce-08d925c07b01
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3229
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

