Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC46369201
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242576AbhDWMXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:23:36 -0400
Received: from mail-eopbgr760081.outbound.protection.outlook.com ([40.107.76.81]:1286
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242249AbhDWMXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:23:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Es9Mc6TRoCF2169WnELbhMZ8+kPQMWt+LgBc0G7tdQGJvI2YTJ1iQkwhgPQXjgHHlc8+QKzGPQPAm3mRF791biIxuI2YKo9vg9gp1wxDz7v2FK4yR3BqxybIvRKx2S4bhcRPLnut8yF6nkU088dx1qGdnAWPICpC/ncTRav4iDVhaXKKqqDZu/gYUyvLAwvvRupZ7anfjeYCiJFmW9F8rGsZVCvEFpKnzq9RcYms8uTveieHly8lcRtzUrKzPmy2Tx/jXImDr1c8UdRWK30iDjav93vDTg2Hv8OpjU7SRzcW9hd83rte5rrOxpwFlY7IQN768MXqZsT8CAgkFh3f+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ATL7DX+2WF3s+ZAPewK+Km8IwTLApZ1iDYOULRTGuE=;
 b=FYCJNVwPoIzo6jR/UCdlOaGAhfuHb0NB/MIcai3U+GD6EmBd8YV/tn8DoXRZK4xiYD6IKbb9oIEPrUKxJnrgOR+p24J2CgAi8yCeINb9tZ3JkNRWzRrdNvk1OXq5bOOJWtNlAMG58Dfoay9WnNb2DCPG6CK6ZLZ7rspf4iXcJCLEbjpkNrY8lQI8XlDaVAbdF27s+/pHmfhkU3qsBOqAl6xWgVfwvCPwGWTR3+BToFIfsikxF+rrdY5+ulqCpWkV39VmEZgXjJJkaA4OIWuSiKNlJgaQZ/RL3BKBy4oJt4B8vE7q40VYZHMvWzPDwWV3K4vhN04TFmnnT1VyPnPeEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ATL7DX+2WF3s+ZAPewK+Km8IwTLApZ1iDYOULRTGuE=;
 b=Z97Vz1Mr5pxsb7RwShqVbSp0LQ8t3gqjP5BrqYUABjuleMFPPzBuVfHBAX6jqlSfoo9weH2JAb0Qu24ZtSuRA4Hb1YhW8Ska7JKCC2NRlVzhuLAVEiiLsQfSJR5ihmaCOWfsks6DH7F9hNmlS8hmsAz4RPIlsrBzFH04MX4HcMrMQ6jzdR3fH3T1stDKBGPrUUaM7IhzSh22F9Pv4/PX+G3dUT6GuWQjcacxjOUbz7zQxQZP6C4ydE3GhtFJ9TIoRZCmHauiIPPFWAF9jxiE0KoGArHPcaAv2UmCwIfOIgNGuduao2gDXneQ07+5boRss2wtEJkaldNzFLyFqB5DRQ==
Received: from BN8PR12CA0006.namprd12.prod.outlook.com (2603:10b6:408:60::19)
 by DM5PR12MB1532.namprd12.prod.outlook.com (2603:10b6:4:6::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.22; Fri, 23 Apr 2021 12:22:56 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::60) by BN8PR12CA0006.outlook.office365.com
 (2603:10b6:408:60::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Fri, 23 Apr 2021 12:22:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 12:22:55 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 12:22:53 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 6/6] selftests: mlxsw: Fix mausezahn invocation in ERSPAN scale test
Date:   Fri, 23 Apr 2021 14:19:48 +0200
Message-ID: <6990c097a89494eaf6527682b29eabc9f8dc7824.1619179926.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1619179926.git.petrm@nvidia.com>
References: <cover.1619179926.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4049e05b-ba0d-4cc5-1bf2-08d906528670
X-MS-TrafficTypeDiagnostic: DM5PR12MB1532:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1532F608226F4654D3286832D6459@DM5PR12MB1532.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yk2JWkxmHmMO1fB5hyc4+zkQJKYfcqNRa1pIzTJpx0VyaHukmsLESuuurr67JI1gu7uenwdKfqjT9CdS1CZaA7P8IXA81AIft3t/8VNmk3+OOWN1/xxSP/JjA0UO4RXlBaGpMbDXXdLduSANkq3PaZ/1QTS+Q+3HxyEJw6OrcR7jpgead1GwJpeCnIe+4IJMVc5u5Bd8Mscqaga5Fl6Q9aNcRsA6NzDicB/uFqd+YqgO1gWsYAX27CutY55ocFQuGeidi1ob0xB/9k8rUdxGOSiQooypRN6DEy5H/Z2Zl4ZA94QRvxlL0Mv4J3hrBdozZxk3AUYD8xFhgBDFZi6X5qe7NSg8XHN8d1u1UnVoNCjB6EQFToYqKE00KR94YPPaHPch5cXltq+bWXR9z0PWOW8yoYWzy8Ue87JDYt/Y/5SEtr5mL/usSiXBGqYgEDn4noO9gFGuxkxb1bq6rYLeSy59dSB3zWgwLj9jyab44Xog7ohazHw8QHkGb+QKw6l7DWZGUiCssbQdawSTwNUp2WIh3PbeONXH9cLSmpqNfc2CRIQaZTRiA9wm4kKErks7gPhh/wg+UDwVIsyFm5eqr1FOFbDWumkSPFCSuX5QY8DQ1pyRRlpVHoZimx+7j46uNqJ5FCExDIRAY0vbXgm0xKj8kjx7nWpRV9go19M07kM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(39850400004)(376002)(396003)(36840700001)(46966006)(36906005)(316002)(86362001)(6916009)(82740400003)(2906002)(54906003)(82310400003)(47076005)(2616005)(186003)(426003)(8936002)(107886003)(36756003)(6666004)(336012)(83380400001)(478600001)(70206006)(356005)(36860700001)(70586007)(7636003)(26005)(16526019)(8676002)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 12:22:55.9666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4049e05b-ba0d-4cc5-1bf2-08d906528670
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1532
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mirror_gre_scale test creates as many ERSPAN sessions as the underlying
chip supports, and tests that they all work. In order to determine that it
issues a stream of ICMP packets and checks if they are mirrored as
expected.

However, the mausezahn invocation missed the -6 flag to identify the use of
IPv6 protocol, and was sending ICMP messages over IPv6, as opposed to
ICMP6. It also didn't pass an explicit source IP address, which apparently
worked at some point in the past, but does not anymore.

To fix these issues, extend the function mirror_test() in mirror_lib by
detecting the IPv6 protocol addresses, and using a different ICMP scheme.
Fix __mirror_gre_test() in the selftest itself to pass a source IP address.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/mlxsw/mirror_gre_scale.sh     |  3 ++-
 .../selftests/net/forwarding/mirror_lib.sh    | 19 +++++++++++++++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh
index 6f3a70df63bc..e00435753008 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh
@@ -120,12 +120,13 @@ __mirror_gre_test()
 	sleep 5
 
 	for ((i = 0; i < count; ++i)); do
+		local sip=$(mirror_gre_ipv6_addr 1 $i)::1
 		local dip=$(mirror_gre_ipv6_addr 1 $i)::2
 		local htun=h3-gt6-$i
 		local message
 
 		icmp6_capture_install $htun
-		mirror_test v$h1 "" $dip $htun 100 10
+		mirror_test v$h1 $sip $dip $htun 100 10
 		icmp6_capture_uninstall $htun
 	done
 }
diff --git a/tools/testing/selftests/net/forwarding/mirror_lib.sh b/tools/testing/selftests/net/forwarding/mirror_lib.sh
index 13db1cb50e57..6406cd76a19d 100644
--- a/tools/testing/selftests/net/forwarding/mirror_lib.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_lib.sh
@@ -20,6 +20,13 @@ mirror_uninstall()
 	tc filter del dev $swp1 $direction pref 1000
 }
 
+is_ipv6()
+{
+	local addr=$1; shift
+
+	[[ -z ${addr//[0-9a-fA-F:]/} ]]
+}
+
 mirror_test()
 {
 	local vrf_name=$1; shift
@@ -29,9 +36,17 @@ mirror_test()
 	local pref=$1; shift
 	local expect=$1; shift
 
+	if is_ipv6 $dip; then
+		local proto=-6
+		local type="icmp6 type=128" # Echo request.
+	else
+		local proto=
+		local type="icmp echoreq"
+	fi
+
 	local t0=$(tc_rule_stats_get $dev $pref)
-	$MZ $vrf_name ${sip:+-A $sip} -B $dip -a own -b bc -q \
-	    -c 10 -d 100msec -t icmp type=8
+	$MZ $proto $vrf_name ${sip:+-A $sip} -B $dip -a own -b bc -q \
+	    -c 10 -d 100msec -t $type
 	sleep 0.5
 	local t1=$(tc_rule_stats_get $dev $pref)
 	local delta=$((t1 - t0))
-- 
2.26.2

