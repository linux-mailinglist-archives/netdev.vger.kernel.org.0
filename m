Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0607E47DF9A
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhLWHa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:30:28 -0500
Received: from mail-bn7nam10on2071.outbound.protection.outlook.com ([40.107.92.71]:64523
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242556AbhLWHa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 02:30:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dilr5Z4GPbll2SnnR3ZUKyIyGz5WOBK/4KA01p2hCnFnxaxYuZGJyXMn9n9251PhCUvpdShsT6ZK/CXCvIvW2MGZyvRuH8kodaz+WVBzC30jeFyQgwuixaAGPJeTfrEZL9iICKeJJzt+kBASsRb8Tsv0/MSY7UXT+R3HCq9HZeb2vfEGBVDprZAQnIy4rh2G0Pq3YhnYTQk/Blfry0oh04XB4POq1+TW3+yjGnwMdAcCoO5B6jsIj9hBOKnl2o41UUhrrQ/mSUESBAY7Hlr4X/HsYJPZREGDGLBMdxRiUZjxQZGIT+LQEo4u1jW+DA1T539LzxBCJOGYj8IZfp0dzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SJi/oVPQ1CpAcTekbCo+0XIK4AYVBdb3NynorF1gw7g=;
 b=KV9JpZVhFsrAPgvFMeMgW0Om0sfLyYWYt2un14IVVT4sxg1wItgr3jRzShWSM/6xkGVffz6jb0GvBbdA8yJQinqlImFKFhtT/sdXNPSfdSqGFxHxgdYYA5wlWQC430tvh7wLIvr33ep5uDdPOiyzFGSbUdZVxLdnlb4lH7yZjqaMm+/4pgu+Vq4zugrTMHyW0vRq2ITDNHEOs4iILzeRWR37uP3G0irKbkKcijkzD3GrRJpCQgpF6qiEoJDHHlCPRWajeJDmYbbE6odUbZpAvLjYZruqudLL6fYf7lGyn1FwhcBWrIGOjewxomSSfjxnXnVrti2ccl0w1JHOZ7EeVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJi/oVPQ1CpAcTekbCo+0XIK4AYVBdb3NynorF1gw7g=;
 b=isNMkFzVNQKKQ01qRG94/5ZFJql7j28FepEGb/cXJY0GLT43Ps0d1FCWftT+VbBc+xdsR/zGxPfMClI7YOs/V7ez8Y42uNBOmcpNsRFwmf/3BY5XsdfaWRztgDmkrEMCIjB86rNJz81H1kgxVgPk/LkiNdKH5QLPVv+M+u5qcXnItqxMLBeaALbS+ZlwyOtcgZb5V0qvzEXLVXSmpyu6ewCN9e4Y9XtwcGSZnWTamcBl+ErpR7q6tS0HRncJiHQU4yNJt3PAkwYGRIB4+vDE9j9y0aNudAnbM14sGQ0TWRuHWDvpbJM4PSgPAEkWG+kzFUl6BJD11lKeOnvjtoi2ZQ==
Received: from MWHPR13CA0024.namprd13.prod.outlook.com (2603:10b6:300:16::34)
 by MN2PR12MB3582.namprd12.prod.outlook.com (2603:10b6:208:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Thu, 23 Dec
 2021 07:30:25 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:16:cafe::d0) by MWHPR13CA0024.outlook.office365.com
 (2603:10b6:300:16::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.6 via Frontend
 Transport; Thu, 23 Dec 2021 07:30:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Thu, 23 Dec 2021 07:30:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 07:30:24 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 22 Dec 2021 23:30:22 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 3/8] selftests: mlxsw: vxlan_fdb_veto: Make the test more flexible for future use
Date:   Thu, 23 Dec 2021 09:29:57 +0200
Message-ID: <20211223073002.3733510-4-amcohen@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211223073002.3733510-1-amcohen@nvidia.com>
References: <20211223073002.3733510-1-amcohen@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dad1dad7-e95b-4f41-6d50-08d9c5e61635
X-MS-TrafficTypeDiagnostic: MN2PR12MB3582:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3582FD739EC49C77A469FA6FCB7E9@MN2PR12MB3582.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+Ncm8reG8H1K5+fJiZR5FUFlxVS48+5E2f0M6ZHU+uasOPck2Ny3ilsiWnitt+0cZSggS+2ahzg0bkUU8WaoSgz5V6kEcvrfkV8k5jZsjV6PHcIhpkFU9JirOasfOmYc+H2XzUdu478HYmdntN3mFP9+XGFDPbs/492Ha8FUKo9qjSe3F0c/chMKOm+h3zBZhAXAmmDqxRIqZNrBgHQI3PTZ6E60r9uUUeFDua4iWm2mkt/H39ah+DT6OqGp2VSghaVoBoLfIXzSYvqAdMA2kf+F2VOqDwZxumpMqeqosVyi3TgJi5/KDusvoRb5XMtT2VKxL9jcur2KGkgjqEj98XtaPKCnLbFFNkIAiCcgzElZhvxQ+F/ONSPronY6zAGuHNFRlDyS3WiUG+oRg6nWPneB6fFYQRPWa/uWS738x1xNqICJuklvh8p5uPKRhshnD/N1Q94VKtcrAldCJaE5Vx5dfEbrTHKOyg29Ksl7EkNM0/joHpeBIOlB/kVUlDxT4ajSNECq+g91o7Eb7FZErWPUa4wquLXPCIMKIMsq8NKxGvLRyKqVQJlplJ/7vRAVKEuGpJl8TITQZrcHtYblPq8Irt9QuRV+hVbXmWhJmrV3tfdk/7H932W4JpAcGaaR9YeAyXE44UrTnqYG9kgaVvzVlHGkUsEtzMA7WOvWv6r7BdltffoQFNRDNetwuEBDNr3FyNnHW8aX/iU4tNxIG3wmYE+37/CVOQd3vv/xwrMX5MsoYF/3RObSUmBpdWoRo2CEjJuDnaEVWxldVwoib2XcSIFi6Ra7RU7+EXIAGs=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700002)(36860700001)(70586007)(8936002)(508600001)(26005)(70206006)(2616005)(40460700001)(107886003)(2906002)(1076003)(4326008)(36756003)(47076005)(6916009)(356005)(54906003)(8676002)(336012)(86362001)(6666004)(83380400001)(16526019)(5660300002)(316002)(426003)(186003)(81166007)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 07:30:25.4136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dad1dad7-e95b-4f41-6d50-08d9c5e61635
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3582
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vxlan_fdb_veto.sh cases are dedicated to test VxLAN with IPv4 underlay.
The main changes to test IPv6 underlay are IP addresses and some flags.

Add variables to define all the values which supposed to be different
for IPv6 testing, set them to use the existing values by default.

The next patch will define the new added variables in a separated file,
so the same tests can be used for IPv6 also.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/mlxsw/vxlan_fdb_veto.sh       | 39 +++++++++++++------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/vxlan_fdb_veto.sh b/tools/testing/selftests/drivers/net/mlxsw/vxlan_fdb_veto.sh
index 749ba3cfda1d..38148f51877a 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/vxlan_fdb_veto.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/vxlan_fdb_veto.sh
@@ -4,6 +4,21 @@
 # Test vetoing of FDB entries that mlxsw can not offload. This exercises several
 # different veto vectors to test various rollback scenarios in the vxlan driver.
 
+: ${LOCAL_IP:=198.51.100.1}
+export LOCAL_IP
+
+: ${REMOTE_IP_1:=198.51.100.2}
+export REMOTE_IP_1
+
+: ${REMOTE_IP_2:=198.51.100.3}
+export REMOTE_IP_2
+
+: ${UDPCSUM_FLAFS:=noudpcsum}
+export UDPCSUM_FLAFS
+
+: ${MC_IP:=224.0.0.1}
+export MC_IP
+
 lib_dir=$(dirname $0)/../../../net/forwarding
 
 ALL_TESTS="
@@ -26,8 +41,8 @@ setup_prepare()
 	ip link set dev $swp1 master br0
 	ip link set dev $swp2 up
 
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP dstport 4789
 	ip link set dev vxlan0 master br0
 }
 
@@ -50,11 +65,11 @@ fdb_create_veto_test()
 	RET=0
 
 	bridge fdb add 01:02:03:04:05:06 dev vxlan0 self static \
-	       dst 198.51.100.2 2>/dev/null
+	       dst $REMOTE_IP_1 2>/dev/null
 	check_fail $? "multicast MAC not rejected"
 
 	bridge fdb add 01:02:03:04:05:06 dev vxlan0 self static \
-	       dst 198.51.100.2 2>&1 >/dev/null | grep -q mlxsw_spectrum
+	       dst $REMOTE_IP_1 2>&1 >/dev/null | grep -q mlxsw_spectrum
 	check_err $? "multicast MAC rejected without extack"
 
 	log_test "vxlan FDB veto - create"
@@ -65,15 +80,15 @@ fdb_replace_veto_test()
 	RET=0
 
 	bridge fdb add 00:01:02:03:04:05 dev vxlan0 self static \
-	       dst 198.51.100.2
+	       dst $REMOTE_IP_1
 	check_err $? "valid FDB rejected"
 
 	bridge fdb replace 00:01:02:03:04:05 dev vxlan0 self static \
-	       dst 198.51.100.2 port 1234 2>/dev/null
+	       dst $REMOTE_IP_1 port 1234 2>/dev/null
 	check_fail $? "FDB with an explicit port not rejected"
 
 	bridge fdb replace 00:01:02:03:04:05 dev vxlan0 self static \
-	       dst 198.51.100.2 port 1234 2>&1 >/dev/null \
+	       dst $REMOTE_IP_1 port 1234 2>&1 >/dev/null \
 	    | grep -q mlxsw_spectrum
 	check_err $? "FDB with an explicit port rejected without extack"
 
@@ -85,15 +100,15 @@ fdb_append_veto_test()
 	RET=0
 
 	bridge fdb add 00:00:00:00:00:00 dev vxlan0 self static \
-	       dst 198.51.100.2
+	       dst $REMOTE_IP_1
 	check_err $? "valid FDB rejected"
 
 	bridge fdb append 00:00:00:00:00:00 dev vxlan0 self static \
-	       dst 198.51.100.3 port 1234 2>/dev/null
+	       dst $REMOTE_IP_2 port 1234 2>/dev/null
 	check_fail $? "FDB with an explicit port not rejected"
 
 	bridge fdb append 00:00:00:00:00:00 dev vxlan0 self static \
-	       dst 198.51.100.3 port 1234 2>&1 >/dev/null \
+	       dst $REMOTE_IP_2 port 1234 2>&1 >/dev/null \
 	    | grep -q mlxsw_spectrum
 	check_err $? "FDB with an explicit port rejected without extack"
 
@@ -105,11 +120,11 @@ fdb_changelink_veto_test()
 	RET=0
 
 	ip link set dev vxlan0 type vxlan \
-	   group 224.0.0.1 dev lo 2>/dev/null
+	   group $MC_IP dev lo 2>/dev/null
 	check_fail $? "FDB with a multicast IP not rejected"
 
 	ip link set dev vxlan0 type vxlan \
-	   group 224.0.0.1 dev lo 2>&1 >/dev/null \
+	   group $MC_IP dev lo 2>&1 >/dev/null \
 	    | grep -q mlxsw_spectrum
 	check_err $? "FDB with a multicast IP rejected without extack"
 
-- 
2.31.1

