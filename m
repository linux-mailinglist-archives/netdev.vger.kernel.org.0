Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72FC39893D
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhFBMTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:19:51 -0400
Received: from mail-dm6nam10on2042.outbound.protection.outlook.com ([40.107.93.42]:51072
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229962AbhFBMTm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:19:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaqjatNr79Yo8Lu6RN4WTqDTan5t/WHW/haMsC0N46sD/QGCD7JhUluIIRggqo5pFqz1eII40bWa/mQrBKH0f/Z3cUucrZFQ6Ao8Kf8fMI0Yitg4fPWGE1loB2PfIDH6CsRBwk+wMLYTzqlj4ANurZ3fS6EdV5wJiZIWlcpVpjQp0rQ/lZ7fvQ//6P71xn+Do3tpgqS6BrfhylTr0WVXGAKT9VlH95Fubn8TZufW0Ml1X3HbUZSjQlXZzm3vD0g+zAnWUrx4f0PldYX6nN/1j+xM6Qe/WiNd9Un3bE5yb0kl4PFnawE4chixKce1IFP1Nz54JGDjZSaV6C5TVbFz8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+WSe9UwMbwu8YqblmRLM0HskzdUFtBQWHklUr2ts/Q=;
 b=Ifc3OxQjo4OzXdw4JDuPPisDog8luHvHddQI6i7jdo9Uf9moj4bH7Ucsn6gGgfkK+d2TpytF7ojsfr86dEY2RW22bzmdNjaOSh5mfLlxt4ZdJincln1HNFzYcN2/tibWhEp1cjeGzB5bm+H//hsB99CspWaaZZIOYdYHJt6UiyC4oPVEc2XCW0Hz7LiKenZ+7cC4N8mDL7PHhhOAJOkIGF7dxU8xu1Hj+1Au88T3XsEs/vcqn8phSeUhcn9Bc7/mhJqWlEiiJZrvC81a5EkuEGjZYouXk2UCIUp/l44XDCkPz2e+VkRYTMzxfQUm/eT/aS/+GKBOxHWs2I8xYBPhhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+WSe9UwMbwu8YqblmRLM0HskzdUFtBQWHklUr2ts/Q=;
 b=G93hYVvfVj3Rk387bUvKvvZLFjMvGUL+rL6x4+Cr9XjDQiAKEMYOR8TsKh6bLaRYGU/LgYOiiYbJu2df+c4RRbE7d/pJwwa8d287+/tmL/qTo4qtodVFB4FZcWyRFuuImds8BNIaIUzh0lnC2Gl3Eysd81FsNyNLPqhizMni8KD9Ua+al54QsrjcLnjeICzdDWE66feHcJE6zWZkyz1IxX2LUQuB29CtNG6e3fD4n9kJJ8UPUyWXRkuKz/1bo+rU7LN6dNR24AXk2TM1KZ/SwiZphbhYyzQ+A80y9bq/4CMx8iB6XFTG0jdoLQ7HihzA/mOli6XlY+RZamt8IL9OcA==
Received: from BN9PR03CA0107.namprd03.prod.outlook.com (2603:10b6:408:fd::22)
 by MN2PR12MB4335.namprd12.prod.outlook.com (2603:10b6:208:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 12:17:58 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::a7) by BN9PR03CA0107.outlook.office365.com
 (2603:10b6:408:fd::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Wed, 2 Jun 2021 12:17:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:17:58 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 05:17:58 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:17:55 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 08/18] selftest: netdevsim: Add devlink rate test
Date:   Wed, 2 Jun 2021 15:17:21 +0300
Message-ID: <1622636251-29892-9-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3593a8d1-6f67-4b61-6405-08d925c075a5
X-MS-TrafficTypeDiagnostic: MN2PR12MB4335:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4335338E4605928BB545F901CB3D9@MN2PR12MB4335.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 927RovtcTnopw6MylvuNDM3ZyF4JTeXDO1Y1LRY59AQ0KkX9EOv68t8XDCw0G4et5Z2+1OktZCfwaeE2y3GPqbXLh+mCTopSRuheozliYss7jOpv5AKkXSXZEk87iIyEmaWjS/VGuIRa+ecbh9QD/DJqE72IBJSKFL3vEVXCHFQee/nXp6pR8dwHdeczOs+seJBMOO6DWavw+RuMqlbEO2ZdN6+AUCnmoxjSf03xznSbV9H9iH2whiGYKucUb3MgZoTjCLxSrf/ZzREOr9AOuMAa+sLmzUpPIK1LnR4bV+f5wbTtzTb9+UNlVTJzNx6fzpTyp0+8nYTzbCOOfDSbau7EbN7PZN0N3TbUU/K/7i5Hzb/v1BA1GusNNDN8pSSCVu4+Ten7qzH6CeEKvzk+yGQFDk78ru9Llrb46KKGmhrx1UDpPSZ9CRtM/a4tj/3Dvq1Wjm8okakA/kQH7gOxGTgvnBbj+cb5XdJeesVUcvvAqY/zWdUMCl4RPEfEk33q7ZzEy0n9b8QPEo3Jc5tptGkkgnIRUu8rGlJIgmzJmMDTEcD+mJ8CT0kOzOf5YYw/lRX5wjdyjVG5dlfXLqSUY9yUond4gkf0/TqeSmrEdN4WGJFcPfX9zm5juraP0sVzf5NCSgEP/dqscz0rCP3Zbg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(46966006)(36840700001)(7696005)(186003)(70206006)(356005)(7636003)(2616005)(83380400001)(426003)(6916009)(107886003)(36756003)(316002)(82310400003)(26005)(6666004)(36860700001)(2906002)(86362001)(82740400003)(54906003)(4326008)(5660300002)(478600001)(8936002)(70586007)(336012)(47076005)(2876002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:17:58.5508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3593a8d1-6f67-4b61-6405-08d925c075a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4335
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Test verifies that all netdevsim VF ports have rate leaf object created
by default.

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---

Notes:
    v1->v2:
    - s/func/function in devlink command

 .../selftests/drivers/net/netdevsim/devlink.sh     | 25 +++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 40909c2..c654be0 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -5,12 +5,13 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 
 ALL_TESTS="fw_flash_test params_test regions_test reload_test \
 	   netns_reload_test resource_test dev_info_test \
-	   empty_reporter_test dummy_reporter_test"
+	   empty_reporter_test dummy_reporter_test rate_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
 BUS_ADDR=10
 PORT_COUNT=4
+VF_COUNT=4
 DEV_NAME=netdevsim$BUS_ADDR
 SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV_NAME/net/
 DEBUGFS_DIR=/sys/kernel/debug/netdevsim/$DEV_NAME/
@@ -507,6 +508,28 @@ dummy_reporter_test()
 	log_test "dummy reporter test"
 }
 
+rate_leafs_get()
+{
+	local handle=$1
+
+	cmd_jq "devlink port function rate show -j" \
+	       '.[] | to_entries | .[] | select(.value.type == "leaf") | .key | select(contains("'$handle'"))'
+}
+
+rate_test()
+{
+	RET=0
+
+	echo $VF_COUNT > /sys/bus/netdevsim/devices/$DEV_NAME/sriov_numvfs
+	devlink dev eswitch set $DL_HANDLE mode switchdev
+	local leafs=`rate_leafs_get $DL_HANDLE`
+	local num_leafs=`echo $leafs | wc -w`
+	[ "$num_leafs" == "$VF_COUNT" ]
+	check_err $? "Expected $VF_COUNT rate leafs but got $num_leafs"
+
+	log_test "rate test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-- 
1.8.3.1

