Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F218E44B105
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 17:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhKIQUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 11:20:52 -0500
Received: from mail-bn8nam11on2058.outbound.protection.outlook.com ([40.107.236.58]:46944
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236759AbhKIQUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 11:20:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPs8bgdMMl1sWrGjANcmxeDMa/Qp0XOhNRML2+R8hUmc/VawpEFWLRPOs5xT0eRnbdK65jQeGj9rm/79R4TOqZM97WltAuaKCH7dgKANxbP+qfeklf0LDOSjyg0eNZgdPGydHJ5KYq8X7401Vz/fTPH1EDVxmPaOiHQPYl1slRWBsz3suNrM/uVqiWG/1YUz/NX3bx8CuOprhwC+kgX4QARC/DohhrjEzw34+VL6Naebc/INLbQn6JALg5UIQXJpH3/xvYROMyi5Agkt9553L+A1VjcJgYiI9wp1Umyj4nnbThg7p2J/cxk4zyxwBC9DglcFaHAfYINXiGXgVjbgfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aEZrUr12HcLIe98OwQuVi2K1efBIjbO+R3zEmj4PZ6U=;
 b=B0AD4TbsH4F6nGXU6udySIEIBS0jMvqwrPGC2eYcF3eHX2HjVIBW2YMCpDu46Ln7KUQGKH6jnJIpHBa3rDiND5zaSflV0PpUJeCD8q9f3UemMWAFQwfqKIqvWAacV7pU2jrTiHoFttVQ7YuRDGaPcMxGslxxMrMxKclKxfuoypzEu9DUQMgEAcwbnKT6JP58G/cQIbxQcf/zL5tRm0eKAmeYwef0NxSBjCF9dJ/UCGqgCUaFg6qY/XOWYlzdPEXCyxkJpvk8GoexXUrNqDWFNVQzoaCOap5G9EAaHiUscwzAcWcY1Sj1r1cjXy+yWKPd5TePy4nWvTRWdMeaeCAzFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aEZrUr12HcLIe98OwQuVi2K1efBIjbO+R3zEmj4PZ6U=;
 b=J1P6yZKW7jHStmeFWZYYU9LbafYaUcm/UBNj2i5r2IrsSIZG5gGdC28kusjA0wd0zeQ6+3E9CS+eFzN+p5QMtehK76HrVC7q3RNkgU43wAyrnFZq1aaFC3QD3tx4I+GUDKSU9yjXOrGL2K+0kXrM62v29/wKvyvif6Ujv0BQCPBn50faHGuqr97TPMMKgczIiEmJWDgmYlBX01rS0iNiIPZPW9QH0sUgM5XG1sgEAPaL7Rjz1AzE5qzLVl9v2mb39unXqtoO0Q+0f3p1bk7tbkF1delzXcRF07wr7+YT+8fEngHV5mVUVc3qKd/h07pb/xNwjBPGCk8YgfPaAV/1GA==
Received: from MWHPR11CA0031.namprd11.prod.outlook.com (2603:10b6:300:115::17)
 by DM6PR12MB2956.namprd12.prod.outlook.com (2603:10b6:5:182::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Tue, 9 Nov
 2021 16:18:02 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:115:cafe::7) by MWHPR11CA0031.outlook.office365.com
 (2603:10b6:300:115::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend
 Transport; Tue, 9 Nov 2021 16:18:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4669.10 via Frontend Transport; Tue, 9 Nov 2021 16:18:01 +0000
Received: from yaviefel.vdiclient.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Tue, 9 Nov 2021 16:17:57 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>
Subject: [PATCH net] selftests: forwarding: Fix packet matching in mirroring selftests
Date:   Tue, 9 Nov 2021 17:17:34 +0100
Message-ID: <401162bba655a1f925b929f6a7f19f6429fc044e.1636474515.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd65e28a-3762-4a2c-faf0-08d9a39c80c9
X-MS-TrafficTypeDiagnostic: DM6PR12MB2956:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2956B515190A21CE4F1E5758D6929@DM6PR12MB2956.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AbzbBZYxiQF1NqN+D/tzzQ7tLKeQP0WKWAaFt3mp5hy8cB4WWhYm6mm+Znk9/4Z9i0ZPf/1RI0IpAXtUpcCch/JJdGYac+o5hIHlEa7VYwHuApwp6xVHtGxfkhOJoYNmXHomo/3sOfoSKEAevYWzwmKCpEKbFKfOu+WT0H+I4V9EURMqSImIwpWCK5yYQP86HDT6ZUSMUa6lUdDzzwSNSPik6CZb3r2EIkK+tOt4j6Q5ekGDK4ko98ZRnpjDkld3QDZriPQhm+l0EIOKMhrko0BRJ7WyuI5qu1j85Y3P8SNG8XHTDF4MXDJ0jMkLfJAHZgoIV4lRFIHI4PK+1y6kAA2mTuwH5jU+CcC8NYdbX40nMqrZvXLz8+68TsMr2PlKjWHzv4VIldvyh4Glbq/xPwR/dNEa5XFJw0TT6P463P+Na7lbJqdEwT/A691cOHJflyJqTNm84MWZGwo4cOCZO1s8Cxl8uty/tknNOGGlO6pjiTvdz6sRUakG7JoosPa/7Zebo/GbmGiCzHD63cGhJtSirTaU3CWzn5Hbzef9ILj/p5rTAOEnU2UTQ5qxwTrrMygd19MaSunPcmd9G14VO2az8a8yirOpyawlMJrSvIK5ymGe/HacHfvxorxUz2OgnkjsQRrx4lBxqGR4OaZl6uqYVEGWPHMKEyCoGlV4HmfiT7GIbdfKZhZbtuQCLA46QyUNbdlNjloHPz7t3qpnwg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7636003)(336012)(47076005)(356005)(36860700001)(8936002)(82310400003)(2616005)(70206006)(8676002)(6916009)(83380400001)(36906005)(316002)(426003)(6666004)(4326008)(508600001)(186003)(70586007)(7696005)(16526019)(26005)(107886003)(5660300002)(36756003)(2906002)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 16:18:01.9602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd65e28a-3762-4a2c-faf0-08d9a39c80c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2956
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 6de6e46d27ef ("cls_flower: Fix inability to match GRE/IPIP
packets"), cls_flower was fixed to match an outer packet of a tunneled
packet as would be expected, rather than dissecting to the inner packet and
matching on that.

This fix uncovered several issues in packet matching in mirroring
selftests:

- in mirror_gre_bridge_1d_vlan.sh and mirror_gre_vlan_bridge_1q.sh, the
  vlan_ethtype match is copied around as "ip", even as some of the tests
  are running over ip6gretap. This is fixed by using an "ipv6" for
  vlan_ethtype in the ip6gretap tests.

- in mirror_gre_changes.sh, a filter to count GRE packets is set up to
  match TTL of 50. This used to trigger in the offloaded datapath, where
  the envelope TTL was matched, but not in the software datapath, which
  considered TTL of the inner packet. Now that both match consistently, all
  the packets were double-counted. This is fixed by marking the filter as
  skip_hw, leaving only the SW datapath component active.

Fixes: 6de6e46d27ef ("cls_flower: Fix inability to match GRE/IPIP packets")
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../net/forwarding/mirror_gre_bridge_1d_vlan.sh     |  2 +-
 .../selftests/net/forwarding/mirror_gre_changes.sh  |  2 +-
 .../net/forwarding/mirror_gre_vlan_bridge_1q.sh     | 13 +++++++------
 .../testing/selftests/net/forwarding/mirror_lib.sh  |  3 ++-
 .../testing/selftests/net/forwarding/mirror_vlan.sh |  4 ++--
 5 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh
index f8cda822c1ce..1b27f2b0f196 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh
@@ -80,7 +80,7 @@ test_gretap()
 
 test_ip6gretap()
 {
-	test_vlan_match gt6 'skip_hw vlan_id 555 vlan_ethtype ip' \
+	test_vlan_match gt6 'skip_hw vlan_id 555 vlan_ethtype ipv6' \
 			"mirror to ip6gretap"
 }
 
diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_changes.sh b/tools/testing/selftests/net/forwarding/mirror_gre_changes.sh
index 472bd023e2a5..aff88f78e339 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_changes.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_changes.sh
@@ -74,7 +74,7 @@ test_span_gre_ttl()
 
 	mirror_install $swp1 ingress $tundev "matchall $tcflags"
 	tc filter add dev $h3 ingress pref 77 prot $prot \
-		flower ip_ttl 50 action pass
+		flower skip_hw ip_ttl 50 action pass
 
 	mirror_test v$h1 192.0.2.1 192.0.2.2 $h3 77 0
 
diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh b/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
index 880e3ab9d088..c8a9b5bd841f 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
@@ -141,7 +141,7 @@ test_gretap()
 
 test_ip6gretap()
 {
-	test_vlan_match gt6 'skip_hw vlan_id 555 vlan_ethtype ip' \
+	test_vlan_match gt6 'skip_hw vlan_id 555 vlan_ethtype ipv6' \
 			"mirror to ip6gretap"
 }
 
@@ -218,6 +218,7 @@ test_ip6gretap_forbidden_egress()
 test_span_gre_untagged_egress()
 {
 	local tundev=$1; shift
+	local ul_proto=$1; shift
 	local what=$1; shift
 
 	RET=0
@@ -225,7 +226,7 @@ test_span_gre_untagged_egress()
 	mirror_install $swp1 ingress $tundev "matchall $tcflags"
 
 	quick_test_span_gre_dir $tundev ingress
-	quick_test_span_vlan_dir $h3 555 ingress
+	quick_test_span_vlan_dir $h3 555 ingress "$ul_proto"
 
 	h3_addr_add_del del $h3.555
 	bridge vlan add dev $swp3 vid 555 pvid untagged
@@ -233,7 +234,7 @@ test_span_gre_untagged_egress()
 	sleep 5
 
 	quick_test_span_gre_dir $tundev ingress
-	fail_test_span_vlan_dir $h3 555 ingress
+	fail_test_span_vlan_dir $h3 555 ingress "$ul_proto"
 
 	h3_addr_add_del del $h3
 	bridge vlan add dev $swp3 vid 555
@@ -241,7 +242,7 @@ test_span_gre_untagged_egress()
 	sleep 5
 
 	quick_test_span_gre_dir $tundev ingress
-	quick_test_span_vlan_dir $h3 555 ingress
+	quick_test_span_vlan_dir $h3 555 ingress "$ul_proto"
 
 	mirror_uninstall $swp1 ingress
 
@@ -250,12 +251,12 @@ test_span_gre_untagged_egress()
 
 test_gretap_untagged_egress()
 {
-	test_span_gre_untagged_egress gt4 "mirror to gretap"
+	test_span_gre_untagged_egress gt4 ip "mirror to gretap"
 }
 
 test_ip6gretap_untagged_egress()
 {
-	test_span_gre_untagged_egress gt6 "mirror to ip6gretap"
+	test_span_gre_untagged_egress gt6 ipv6 "mirror to ip6gretap"
 }
 
 test_span_gre_fdb_roaming()
diff --git a/tools/testing/selftests/net/forwarding/mirror_lib.sh b/tools/testing/selftests/net/forwarding/mirror_lib.sh
index 6406cd76a19d..3e8ebeff3019 100644
--- a/tools/testing/selftests/net/forwarding/mirror_lib.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_lib.sh
@@ -115,13 +115,14 @@ do_test_span_vlan_dir_ips()
 	local dev=$1; shift
 	local vid=$1; shift
 	local direction=$1; shift
+	local ul_proto=$1; shift
 	local ip1=$1; shift
 	local ip2=$1; shift
 
 	# Install the capture as skip_hw to avoid double-counting of packets.
 	# The traffic is meant for local box anyway, so will be trapped to
 	# kernel.
-	vlan_capture_install $dev "skip_hw vlan_id $vid vlan_ethtype ip"
+	vlan_capture_install $dev "skip_hw vlan_id $vid vlan_ethtype $ul_proto"
 	mirror_test v$h1 $ip1 $ip2 $dev 100 $expect
 	mirror_test v$h2 $ip2 $ip1 $dev 100 $expect
 	vlan_capture_uninstall $dev
diff --git a/tools/testing/selftests/net/forwarding/mirror_vlan.sh b/tools/testing/selftests/net/forwarding/mirror_vlan.sh
index 9ab2ce77b332..0b44e148235e 100755
--- a/tools/testing/selftests/net/forwarding/mirror_vlan.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_vlan.sh
@@ -85,9 +85,9 @@ test_tagged_vlan_dir()
 	RET=0
 
 	mirror_install $swp1 $direction $swp3.555 "matchall $tcflags"
-	do_test_span_vlan_dir_ips 10 "$h3.555" 111 "$direction" \
+	do_test_span_vlan_dir_ips 10 "$h3.555" 111 "$direction" ip \
 				  192.0.2.17 192.0.2.18
-	do_test_span_vlan_dir_ips  0 "$h3.555" 555 "$direction" \
+	do_test_span_vlan_dir_ips  0 "$h3.555" 555 "$direction" ip \
 				  192.0.2.17 192.0.2.18
 	mirror_uninstall $swp1 $direction
 
-- 
2.31.1

