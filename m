Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933423916F6
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbhEZMDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:03:34 -0400
Received: from mail-mw2nam12on2050.outbound.protection.outlook.com ([40.107.244.50]:56736
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233197AbhEZMDT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5RP3AJUjvsLgZsIUyyZtlPnLv3dNMAQPuZmqnnDAh6onFTJAYNNdtVqfnwaHvMYgFQ+eEuA+dp55xaKzJKllFmIKDMCvOgpYk02FzqAf0w+pZepRjxyMZaOXkUAhbEG++1T6jd82kgsoz09ONddK5h5Gi9qBgD1+oH0QHAvJGYLgAlXhzf84il+e/Pg6SaZ0azoFIidO+nnrVhm/tuwI6u9llf6gVOG8+aYzJWycB+r81CFi4JhIa0dHTmS31hhdkmN0YlN+rCkU8+VvzjG8g6yjoXyPDCuOY2sHkwhgb3iKipdisiT5gO6zSLrXxpjQTIPPorQKOawavvUpeM8Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JZM9C8cvD2UVV84x0mxd9HVJHTmhdrJcwzwdvwuD8w=;
 b=HM7sPLpW1amMZ4PHEdjXbpeDw5ViKTyRbMFfjc1YZRIBPTv6tDngLL+hW2+DOByWN7Xj4YbRGUM+X5ZjscdFvWhbBbErmTseOMaHTkfcDldaRWAB3Tk8x2pbeT5m0eNvydb0oK9nODoLTNNJ/pt7dpjDBIRNonS91HubI64YoIkxsHsyVTwKlAGGpH8jabA+7mosN2lKg0x8ZAw69yuirbwUMSR11gvOnP8GZB7ln4/ikCN4lhXiJWS8v10hf3H4fol5Yqp7HePNfFV4Xx7VRZ88mj6MKb4za5mYCgIPF3MIJDyCWy1nJLVmVtEF3jq0Bmq0o4Q9KYFAx0TyJR9jaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JZM9C8cvD2UVV84x0mxd9HVJHTmhdrJcwzwdvwuD8w=;
 b=k5HMGfDcHAD7H0fxxyqqT92pPY0O7u9cJG2dHL/yiFgrzC+McJb/N3Xrv4LlaNlIM8bUyWiHJZAT86QEBFde0FiXUb4o+GWo1fWzKWOLitZgy4h/TVlNcCyYec2KTDVFSkeI5TqguMrcm+yad/xDFlvswoqp0Qt1tjH+IFD3BwPMZuxMa3EwTqYmgs+FFr6nKclFO2hDWms/0eAEUoHNkK32q/DtN7jgKM/NbiqYhKpUkr+pV8dVjerTcnrtuz/WMP4G8ICnWAaG8OpTWHfshBl6Ykrgpejs8dnVMv/ceRi5/KqgvoUsEdOr7BgcqhyvzR+o1Dni6IExB0j4hF0cUg==
Received: from DM6PR14CA0040.namprd14.prod.outlook.com (2603:10b6:5:18f::17)
 by CH0PR12MB5090.namprd12.prod.outlook.com (2603:10b6:610:bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 12:01:47 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::3b) by DM6PR14CA0040.outlook.office365.com
 (2603:10b6:5:18f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 12:01:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:01:46 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:01:46 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:01:46 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:43 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 11/18] selftest: netdevsim: Add devlink port shared/max tx rate test
Date:   Wed, 26 May 2021 15:01:03 +0300
Message-ID: <1622030470-21434-12-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9261c706-f60d-449e-61fe-08d9203e099f
X-MS-TrafficTypeDiagnostic: CH0PR12MB5090:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5090E4782DB572411603CB78CB249@CH0PR12MB5090.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gydCabVlLCv7NYB1jmzbHD3nL0Agwx/8vdxV64TFbVxAgmBe/IMOTr/k3goDp3goZ19RwyQOHFDrYq0+/1vpOovnGfcs84rlz+QmoxB9Jvq8IHzrXMGYbkFj37l2k9IzueYpPeMeR0okaITsG5091jtM2ayO29KOP+63ekJXD65b2IpwJapg+IBRK3tbBjLFPSZn7R5dteO92up/JgS37rMgvYDGO1u0YipV4JqqeQFufO1M4pJCTifEIn9y0Cpu2YhWjm3MdCo1m3TJYpRrQd230mEOK+uNk1r6hLPali1k/YrkT+j+MLYHkkFQ5F+pUF6VyDSe4cjdS8LQQ7XbdnfuDnIDg8FuQewpYSDabBXhKtJRo3mCvYPTS6HyjimhWFie9soIRArtvjeCELs40XSAW8R9GR4Rqh2ReKUEI0WfpTcJ9we8KqUaZejcG3+Wu4Dc/YeeYBPFpLT3eBJK8MfTWYApzwhjQSiXSwKsLjFChAkWARHlB7QkuuO7wmFRMfYQiom98tX6b2Ca8RddpTCNuFRNOS7kamkms3XYuf81xWsYbI85BnEKJcKtMDWtGTzdW11/HAqJwO5v97QbJs1mwF8+KY0YyAwWuXd1WpE/oY9n8PuXF9qZ5EiX7wDaU6WXCHTPSGB7qO1KK6N1JQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(46966006)(36840700001)(478600001)(2616005)(316002)(4326008)(7696005)(70586007)(8936002)(107886003)(6666004)(70206006)(5660300002)(426003)(336012)(26005)(186003)(54906003)(86362001)(36906005)(2876002)(82740400003)(356005)(7636003)(47076005)(6916009)(8676002)(2906002)(36756003)(82310400003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:01:46.9368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9261c706-f60d-449e-61fe-08d9203e099f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5090
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

