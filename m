Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B1847DF98
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239103AbhLWHaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:30:25 -0500
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:14049
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231566AbhLWHaY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 02:30:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Euno6OwkSqnlBl18/CLULPT7iOrYYr2lzt3jNyhRovZdfpgsxXArIc5Uy9+Rv2yAMdMpfsrkrOfc7Cut0vn7vz44uxBoUfntjfiVK18y5ikouaJ7tGpZ9pj3oQXkuliq8iETtVjeA0bWOiz6ss5Lv+yfRH7qawq2+aCUsY4yXF8DvQpJESiZBrIQ7/zuYlDY+V39AZJlRmE0/jWuPQYvcSIj2BPjQGD2Ty1oVRYVPNVsL0xJIMYFInpHPaejE2vHTTLeKeYhHdZ8JBKurhRnXHItxsPrp4tMJfFbfYRjrJJ0vQSMTMrdq3hswR5et/8/htmpOVS8SyMImJ8Z+/hU1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sUrV9rBkCL+TcElDnYSjeEn3POzX4NwhIxflWIW8tgk=;
 b=UkxkUfpLRSTvPAN6vydYtyVQC3fVNLRtPOCSU3di3xHlEfq5lE37jFKuzAH7H71VKZrw4aSf912s+bbhlSgHS3IUP/EJLAzHilEMKI9Oce5fHBpvW714U8mVMQgUlQI7IeP+HI3uDZ6BNl2WhWz8PIwt3GdVMxFmQ2v1bRd66BF+C8Dbcl09BPwFg4qACoqEKaFX7lwaewrWF8DJkxc01ltuywCXyYn35aU7bBl83/ZCShpA2zNN9o8MUdMzCVNE9sV+8d9ZzOeJh4YHC4qsNIodSn6elcuPUjcfpPkReeCtifZnYvFGHRW/36Fl7PkhIZpK4ClOvFZpNyXqOPZffA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUrV9rBkCL+TcElDnYSjeEn3POzX4NwhIxflWIW8tgk=;
 b=J4xd3+aCMxoeOAJxUrtnVrPnBsO7mrFtsAEGF0RJr5j+z1njk5+GKAo4vtGFlEeX+FjyfFoD0GbqmGB8MKq8Yqc5t5Tk2+RpO4PflI3EA0T346gHFARwaahiTGdTfmhTJeUMAwqwFqwj0AAQE0Pq3ROpNwQrD/kMahmCHtQAj4/yG4CgBbTI0B+m+D5FTtL1nDeFS3J9IYalx7eu6FM7BiRZw6ah2UKjLqGJPPw5jRRwVlSmSXnWqxSCZv6zaOBxUM4yxjZH2FKdXdPL2Nxuxxe0LDzGIUuw/XvqhaiBE0cYE1kuCe9sa2qUce6tTHidfU3miE27+9mMnxReaEv9lA==
Received: from MWHPR20CA0035.namprd20.prod.outlook.com (2603:10b6:300:ed::21)
 by MN2PR12MB3008.namprd12.prod.outlook.com (2603:10b6:208:c8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Thu, 23 Dec
 2021 07:30:21 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ed:cafe::b3) by MWHPR20CA0035.outlook.office365.com
 (2603:10b6:300:ed::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18 via Frontend
 Transport; Thu, 23 Dec 2021 07:30:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Thu, 23 Dec 2021 07:30:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 07:30:20 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 22 Dec 2021 23:30:17 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 1/8] selftests: mlxsw: vxlan: Make the test more flexible for future use
Date:   Thu, 23 Dec 2021 09:29:55 +0200
Message-ID: <20211223073002.3733510-2-amcohen@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 79fe94ee-5d42-483b-c426-08d9c5e6138a
X-MS-TrafficTypeDiagnostic: MN2PR12MB3008:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3008EEB09E1FADA446D95268CB7E9@MN2PR12MB3008.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KJFtqu8DUI9j7hmMQq+8NBB13C/y2k7ZMjDqoN5n0i0ocuDzxGiSqeEEfe1ttxXrAo84+4YHxaQTG+D6na/q0loOtA2GVZg/gygl5BszWvDEOmenjDv+gsyj43ojK3xG3mbabNyvfL5ExzSG5mNK7NYUHL2KLhIWceXleS/571IItEwnzqv3iW3Kr9wVQD8ywHV/CUX+O+Lhpj4OPKogir7rjzip1HNL7oPVF6J4ZAztvEmnQOrt8aw4VT16SEtu8FP6RjKBCIM0zhJlsWHXSP9+yfHqpa4lsmI/Vp6iKLd/9Z33xAqFhhQJ4HyTgj3ALYqcHwU/3G3p0mmQrctu71tGyrWTk6DzVTBmw82zwT+gew5muMqd3zAIIdjL131uqGFn/3GYesUe1GuLlo1LlcOXTdS5Gmps+pKKKE16L2NhkTuOTsqCjYOUS5KimFKfkfOFd/+nHSeGyXmrlfSa6Vp8NyCxOXBYA7T3Esbxl0LZtOVpRQOFAxAmZNK5GNnadp8vtQcJT7GmgpKwsjL08unsojpWN73R8elmHNMW26qluecscSMaqplqmulIbIjFSnZjpLWjSNWC1PTjkayeklc78bemm3fW2TB9NVNtWSME/gTm7SNPFi77LHqBpFWvHGop1LuavXKhj0i/w+1de5NyZ5UignvkupIy9kMgp/m2AJAhV+njFA3/GT3NHaQH6u1HLyuTRxBZUvwtQLdxEh1jSQ77VQQ8jdRVvMIO1ssKU7m2pOrJNJhaRoHT272W3bc384aOjuzwJAWJEfFfSmYDPrGWlaxuMC+RVKe9+xg=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(40460700001)(508600001)(316002)(47076005)(36756003)(54906003)(6666004)(30864003)(81166007)(356005)(83380400001)(8676002)(2906002)(5660300002)(107886003)(16526019)(86362001)(36860700001)(1076003)(2616005)(6916009)(82310400004)(4326008)(8936002)(70586007)(426003)(336012)(186003)(26005)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 07:30:20.9553
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79fe94ee-5d42-483b-c426-08d9c5e6138a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3008
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vxlan.sh cases are dedicated to test VxLAN with IPv4 underlay.
The main changes to test IPv6 underlay are IP addresses and some flags.

Add variables to define all the values which supposed to be different
for IPv6 testing, set them to use the existing values by default.

The next patch will define the new added variables in a separated file,
so the same tests can be used for IPv6 also.

Rename some functions to include "ipv4", so the next patch will add
equivalent functions for IPv6.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/vxlan.sh      | 224 ++++++++++--------
 1 file changed, 125 insertions(+), 99 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
index 3639b89c81ba..99a332b712f0 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
@@ -4,10 +4,35 @@
 # Test various aspects of VxLAN offloading which are specific to mlxsw, such
 # as sanitization of invalid configurations and offload indication.
 
-lib_dir=$(dirname $0)/../../../net/forwarding
+: ${ADDR_FAMILY:=ipv4}
+export ADDR_FAMILY
+
+: ${LOCAL_IP_1:=198.51.100.1}
+export LOCAL_IP_1
+
+: ${LOCAL_IP_2:=198.51.100.2}
+export LOCAL_IP_2
+
+: ${PREFIX_LEN:=32}
+export PREFIX_LEN
+
+: ${UDPCSUM_FLAFS:=noudpcsum}
+export UDPCSUM_FLAFS
 
-ALL_TESTS="sanitization_test offload_indication_test \
-	sanitization_vlan_aware_test offload_indication_vlan_aware_test"
+: ${MC_IP:=239.0.0.1}
+export MC_IP
+
+: ${IP_FLAG:=""}
+export IP_FLAG
+
+: ${ALL_TESTS:="
+	sanitization_test
+	offload_indication_test
+	sanitization_vlan_aware_test
+	offload_indication_vlan_aware_test
+"}
+
+lib_dir=$(dirname $0)/../../../net/forwarding
 NUM_NETIFS=2
 : ${TIMEOUT:=20000} # ms
 source $lib_dir/lib.sh
@@ -63,8 +88,8 @@ sanitization_single_dev_valid_test()
 
 	ip link add dev br0 type bridge mcast_snooping 0
 
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	sanitization_single_dev_test_pass
 
@@ -80,8 +105,8 @@ sanitization_single_dev_vlan_aware_test()
 
 	ip link add dev br0 type bridge mcast_snooping 0 vlan_filtering 1
 
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	sanitization_single_dev_test_pass
 
@@ -97,8 +122,8 @@ sanitization_single_dev_mcast_enabled_test()
 
 	ip link add dev br0 type bridge
 
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	sanitization_single_dev_test_fail
 
@@ -115,9 +140,9 @@ sanitization_single_dev_mcast_group_test()
 	ip link add dev br0 type bridge mcast_snooping 0
 	ip link add name dummy1 up type dummy
 
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789 \
-		dev dummy1 group 239.0.0.1
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789 \
+		dev dummy1 group $MC_IP
 
 	sanitization_single_dev_test_fail
 
@@ -134,7 +159,7 @@ sanitization_single_dev_no_local_ip_test()
 
 	ip link add dev br0 type bridge mcast_snooping 0
 
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
 		ttl 20 tos inherit dstport 4789
 
 	sanitization_single_dev_test_fail
@@ -145,14 +170,14 @@ sanitization_single_dev_no_local_ip_test()
 	log_test "vxlan device with no local ip"
 }
 
-sanitization_single_dev_learning_enabled_test()
+sanitization_single_dev_learning_enabled_ipv4_test()
 {
 	RET=0
 
 	ip link add dev br0 type bridge mcast_snooping 0
 
-	ip link add name vxlan0 up type vxlan id 10 learning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 learning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	sanitization_single_dev_test_pass
 
@@ -169,8 +194,8 @@ sanitization_single_dev_local_interface_test()
 	ip link add dev br0 type bridge mcast_snooping 0
 	ip link add name dummy1 up type dummy
 
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789 dev dummy1
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789 dev dummy1
 
 	sanitization_single_dev_test_fail
 
@@ -187,8 +212,8 @@ sanitization_single_dev_port_range_test()
 
 	ip link add dev br0 type bridge mcast_snooping 0
 
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789 \
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789 \
 		srcport 4000 5000
 
 	sanitization_single_dev_test_fail
@@ -205,8 +230,8 @@ sanitization_single_dev_tos_static_test()
 
 	ip link add dev br0 type bridge mcast_snooping 0
 
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos 20 local 198.51.100.1 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos 20 local $LOCAL_IP_1 dstport 4789
 
 	sanitization_single_dev_test_fail
 
@@ -222,8 +247,8 @@ sanitization_single_dev_ttl_inherit_test()
 
 	ip link add dev br0 type bridge mcast_snooping 0
 
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl inherit tos inherit local 198.51.100.1 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl inherit tos inherit local $LOCAL_IP_1 dstport 4789
 
 	sanitization_single_dev_test_fail
 
@@ -233,14 +258,14 @@ sanitization_single_dev_ttl_inherit_test()
 	log_test "vxlan device with inherit ttl"
 }
 
-sanitization_single_dev_udp_checksum_test()
+sanitization_single_dev_udp_checksum_ipv4_test()
 {
 	RET=0
 
 	ip link add dev br0 type bridge mcast_snooping 0
 
 	ip link add name vxlan0 up type vxlan id 10 nolearning udpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	sanitization_single_dev_test_fail
 
@@ -259,12 +284,12 @@ sanitization_single_dev_test()
 	sanitization_single_dev_mcast_enabled_test
 	sanitization_single_dev_mcast_group_test
 	sanitization_single_dev_no_local_ip_test
-	sanitization_single_dev_learning_enabled_test
+	sanitization_single_dev_learning_enabled_"$ADDR_FAMILY"_test
 	sanitization_single_dev_local_interface_test
 	sanitization_single_dev_port_range_test
 	sanitization_single_dev_tos_static_test
 	sanitization_single_dev_ttl_inherit_test
-	sanitization_single_dev_udp_checksum_test
+	sanitization_single_dev_udp_checksum_"$ADDR_FAMILY"_test
 }
 
 sanitization_multi_devs_test_pass()
@@ -316,10 +341,10 @@ sanitization_multi_devs_valid_test()
 	ip link add dev br0 type bridge mcast_snooping 0
 	ip link add dev br1 type bridge mcast_snooping 0
 
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
-	ip link add name vxlan1 up type vxlan id 20 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
+	ip link add name vxlan1 up type vxlan id 20 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	sanitization_multi_devs_test_pass
 
@@ -338,10 +363,10 @@ sanitization_multi_devs_ttl_test()
 	ip link add dev br0 type bridge mcast_snooping 0
 	ip link add dev br1 type bridge mcast_snooping 0
 
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
-	ip link add name vxlan1 up type vxlan id 20 nolearning noudpcsum \
-		ttl 40 tos inherit local 198.51.100.1 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
+	ip link add name vxlan1 up type vxlan id 20 nolearning $UDPCSUM_FLAFS \
+		ttl 40 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	sanitization_multi_devs_test_fail
 
@@ -360,10 +385,10 @@ sanitization_multi_devs_udp_dstport_test()
 	ip link add dev br0 type bridge mcast_snooping 0
 	ip link add dev br1 type bridge mcast_snooping 0
 
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
-	ip link add name vxlan1 up type vxlan id 20 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 5789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
+	ip link add name vxlan1 up type vxlan id 20 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 5789
 
 	sanitization_multi_devs_test_fail
 
@@ -382,10 +407,10 @@ sanitization_multi_devs_local_ip_test()
 	ip link add dev br0 type bridge mcast_snooping 0
 	ip link add dev br1 type bridge mcast_snooping 0
 
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
-	ip link add name vxlan1 up type vxlan id 20 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.2 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
+	ip link add name vxlan1 up type vxlan id 20 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_2 dstport 4789
 
 	sanitization_multi_devs_test_fail
 
@@ -425,12 +450,12 @@ offload_indication_setup_create()
 	ip link set dev $swp1 master br0
 	ip link set dev $swp2 master br1
 
-	ip address add 198.51.100.1/32 dev lo
+	ip address add $LOCAL_IP_1/$PREFIX_LEN dev lo
 
 	ip link add name vxlan0 up master br0 type vxlan id 10 nolearning \
-		noudpcsum ttl 20 tos inherit local 198.51.100.1 dstport 4789
+		$UDPCSUM_FLAFS ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 	ip link add name vxlan1 up master br1 type vxlan id 20 nolearning \
-		noudpcsum ttl 20 tos inherit local 198.51.100.1 dstport 4789
+		$UDPCSUM_FLAFS ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 }
 
 offload_indication_setup_destroy()
@@ -438,7 +463,7 @@ offload_indication_setup_destroy()
 	ip link del dev vxlan1
 	ip link del dev vxlan0
 
-	ip address del 198.51.100.1/32 dev lo
+	ip address del $LOCAL_IP_1/$PREFIX_LEN dev lo
 
 	ip link set dev $swp2 nomaster
 	ip link set dev $swp1 nomaster
@@ -451,7 +476,7 @@ offload_indication_fdb_flood_test()
 {
 	RET=0
 
-	bridge fdb append 00:00:00:00:00:00 dev vxlan0 self dst 198.51.100.2
+	bridge fdb append 00:00:00:00:00:00 dev vxlan0 self dst $LOCAL_IP_2
 
 	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb 00:00:00:00:00:00 \
 		bridge fdb show brport vxlan0
@@ -467,7 +492,7 @@ offload_indication_fdb_bridge_test()
 	RET=0
 
 	bridge fdb add de:ad:be:ef:13:37 dev vxlan0 self master static \
-		dst 198.51.100.2
+		dst $LOCAL_IP_2
 
 	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
 		de:ad:be:ef:13:37 self bridge fdb show brport vxlan0
@@ -518,7 +543,7 @@ offload_indication_fdb_bridge_test()
 	# marked as offloaded in both drivers
 	RET=0
 
-	bridge fdb add de:ad:be:ef:13:37 dev vxlan0 self dst 198.51.100.2
+	bridge fdb add de:ad:be:ef:13:37 dev vxlan0 self dst $LOCAL_IP_2
 	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
 		de:ad:be:ef:13:37 self bridge fdb show brport vxlan0
 	check_err $?
@@ -542,17 +567,17 @@ offload_indication_decap_route_test()
 	RET=0
 
 	busywait "$TIMEOUT" wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	ip link set dev vxlan0 down
 	busywait "$TIMEOUT" wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	ip link set dev vxlan1 down
 	busywait "$TIMEOUT" not wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	log_test "vxlan decap route - vxlan device down"
@@ -561,26 +586,26 @@ offload_indication_decap_route_test()
 
 	ip link set dev vxlan1 up
 	busywait "$TIMEOUT" wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	ip link set dev vxlan0 up
 	busywait "$TIMEOUT" wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	log_test "vxlan decap route - vxlan device up"
 
 	RET=0
 
-	ip address delete 198.51.100.1/32 dev lo
+	ip address delete $LOCAL_IP_1/$PREFIX_LEN dev lo
 	busywait "$TIMEOUT" not wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
-	ip address add 198.51.100.1/32 dev lo
+	ip address add $LOCAL_IP_1/$PREFIX_LEN dev lo
 	busywait "$TIMEOUT" wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	log_test "vxlan decap route - add local route"
@@ -589,18 +614,18 @@ offload_indication_decap_route_test()
 
 	ip link set dev $swp1 nomaster
 	busywait "$TIMEOUT" wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	ip link set dev $swp2 nomaster
 	busywait "$TIMEOUT" not wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	ip link set dev $swp1 master br0
 	ip link set dev $swp2 master br1
 	busywait "$TIMEOUT" wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	log_test "vxlan decap route - local ports enslavement"
@@ -609,12 +634,12 @@ offload_indication_decap_route_test()
 
 	ip link del dev br0
 	busywait "$TIMEOUT" wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	ip link del dev br1
 	busywait "$TIMEOUT" not wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	log_test "vxlan decap route - bridge device deletion"
@@ -628,25 +653,25 @@ offload_indication_decap_route_test()
 	ip link set dev vxlan0 master br0
 	ip link set dev vxlan1 master br1
 	busywait "$TIMEOUT" wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	ip link del dev vxlan0
 	busywait "$TIMEOUT" wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	ip link del dev vxlan1
 	busywait "$TIMEOUT" not wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	log_test "vxlan decap route - vxlan device deletion"
 
 	ip link add name vxlan0 up master br0 type vxlan id 10 nolearning \
-		noudpcsum ttl 20 tos inherit local 198.51.100.1 dstport 4789
+		$UDPCSUM_FLAFS ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 	ip link add name vxlan1 up master br1 type vxlan id 20 nolearning \
-		noudpcsum ttl 20 tos inherit local 198.51.100.1 dstport 4789
+		$UDPCSUM_FLAFS ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 }
 
 check_fdb_offloaded()
@@ -703,10 +728,10 @@ __offload_indication_join_vxlan_first()
 	local mac=00:11:22:33:44:55
 	local zmac=00:00:00:00:00:00
 
-	bridge fdb append $zmac dev vxlan0 self dst 198.51.100.2
+	bridge fdb append $zmac dev vxlan0 self dst $LOCAL_IP_2
 
 	ip link set dev vxlan0 master br0
-	bridge fdb add dev vxlan0 $mac self master static dst 198.51.100.2
+	bridge fdb add dev vxlan0 $mac self master static dst $LOCAL_IP_2
 
 	RET=0
 	check_vxlan_fdb_not_offloaded
@@ -756,8 +781,8 @@ __offload_indication_join_vxlan_first()
 offload_indication_join_vxlan_first()
 {
 	ip link add dev br0 up type bridge mcast_snooping 0
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	__offload_indication_join_vxlan_first
 
@@ -771,7 +796,7 @@ __offload_indication_join_vxlan_last()
 
 	RET=0
 
-	bridge fdb append $zmac dev vxlan0 self dst 198.51.100.2
+	bridge fdb append $zmac dev vxlan0 self dst $LOCAL_IP_2
 
 	ip link set dev $swp1 master br0
 
@@ -791,8 +816,8 @@ __offload_indication_join_vxlan_last()
 offload_indication_join_vxlan_last()
 {
 	ip link add dev br0 up type bridge mcast_snooping 0
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	__offload_indication_join_vxlan_last
 
@@ -819,10 +844,10 @@ sanitization_vlan_aware_test()
 	ip link add dev br0 type bridge mcast_snooping 0 vlan_filtering 1
 
 	ip link add name vxlan10 up master br0 type vxlan id 10 nolearning \
-		noudpcsum ttl 20 tos inherit local 198.51.100.1 dstport 4789
+		$UDPCSUM_FLAFS ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	ip link add name vxlan20 up master br0 type vxlan id 20 nolearning \
-		noudpcsum ttl 20 tos inherit local 198.51.100.1 dstport 4789
+		$UDPCSUM_FLAFS ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	# Test that when each VNI is mapped to a different VLAN we can enslave
 	# a port to the bridge
@@ -866,20 +891,20 @@ sanitization_vlan_aware_test()
 
 	# Use the offload indication of the local route to ensure the VXLAN
 	# configuration was correctly rollbacked.
-	ip address add 198.51.100.1/32 dev lo
+	ip address add $LOCAL_IP_1/$PREFIX_LEN dev lo
 
 	ip link set dev vxlan10 type vxlan ttl 10
 	ip link set dev $swp1 master br0 &> /dev/null
 	check_fail $?
 
 	busywait "$TIMEOUT" not wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	log_test "vlan-aware - failed enslavement to bridge due to conflict"
 
 	ip link set dev vxlan10 type vxlan ttl 20
-	ip address del 198.51.100.1/32 dev lo
+	ip address del $LOCAL_IP_1/$PREFIX_LEN dev lo
 
 	ip link del dev vxlan20
 	ip link del dev vxlan10
@@ -898,12 +923,12 @@ offload_indication_vlan_aware_setup_create()
 	bridge vlan add vid 10 dev $swp1
 	bridge vlan add vid 20 dev $swp1
 
-	ip address add 198.51.100.1/32 dev lo
+	ip address add $LOCAL_IP_1/$PREFIX_LEN dev lo
 
 	ip link add name vxlan10 up master br0 type vxlan id 10 nolearning \
-		noudpcsum ttl 20 tos inherit local 198.51.100.1 dstport 4789
+		$UDPCSUM_FLAFS ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 	ip link add name vxlan20 up master br0 type vxlan id 20 nolearning \
-		noudpcsum ttl 20 tos inherit local 198.51.100.1 dstport 4789
+		$UDPCSUM_FLAFS ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	bridge vlan add vid 10 dev vxlan10 pvid untagged
 	bridge vlan add vid 20 dev vxlan20 pvid untagged
@@ -917,7 +942,7 @@ offload_indication_vlan_aware_setup_destroy()
 	ip link del dev vxlan20
 	ip link del dev vxlan10
 
-	ip address del 198.51.100.1/32 dev lo
+	ip address del $LOCAL_IP_1/$PREFIX_LEN dev lo
 
 	bridge vlan del vid 20 dev $swp1
 	bridge vlan del vid 10 dev $swp1
@@ -934,7 +959,7 @@ offload_indication_vlan_aware_fdb_test()
 	log_info "vxlan entry offload indication - vlan-aware"
 
 	bridge fdb add de:ad:be:ef:13:37 dev vxlan10 self master static \
-		dst 198.51.100.2 vlan 10
+		dst $LOCAL_IP_2 vlan 10
 
 	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
 		de:ad:be:ef:13:37 self bridge fdb show brport vxlan10
@@ -985,7 +1010,7 @@ offload_indication_vlan_aware_fdb_test()
 	# marked as offloaded in both drivers
 	RET=0
 
-	bridge fdb add de:ad:be:ef:13:37 dev vxlan10 self dst 198.51.100.2
+	bridge fdb add de:ad:be:ef:13:37 dev vxlan10 self dst $LOCAL_IP_2
 	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
 		de:ad:be:ef:13:37 self bridge fdb show brport vxlan10
 	check_err $?
@@ -1003,7 +1028,7 @@ offload_indication_vlan_aware_decap_route_test()
 	RET=0
 
 	busywait "$TIMEOUT" wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	# Toggle PVID flag on one VxLAN device and make sure route is still
@@ -1011,7 +1036,7 @@ offload_indication_vlan_aware_decap_route_test()
 	bridge vlan add vid 10 dev vxlan10 untagged
 
 	busywait "$TIMEOUT" wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	# Toggle PVID flag on second VxLAN device and make sure route is no
@@ -1019,14 +1044,15 @@ offload_indication_vlan_aware_decap_route_test()
 	bridge vlan add vid 20 dev vxlan20 untagged
 
 	busywait "$TIMEOUT" not wait_for_offload \
-		ip route show table local 198.51.100.1
+		ip $IP_FLAG route show table local $LOCAL_IP_1
 	check_err $?
 
 	# Toggle PVID flag back and make sure route is marked as offloaded
 	bridge vlan add vid 10 dev vxlan10 pvid untagged
 	bridge vlan add vid 20 dev vxlan20 pvid untagged
 
-	busywait "$TIMEOUT" wait_for_offload ip route show table local 198.51.100.1
+	busywait "$TIMEOUT" wait_for_offload ip $IP_FLAG route show table local \
+		$LOCAL_IP_1
 	check_err $?
 
 	log_test "vxlan decap route - vni map/unmap"
@@ -1036,8 +1062,8 @@ offload_indication_vlan_aware_join_vxlan_first()
 {
 	ip link add dev br0 up type bridge mcast_snooping 0 \
 		vlan_filtering 1 vlan_default_pvid 1
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	__offload_indication_join_vxlan_first 1
 
@@ -1049,8 +1075,8 @@ offload_indication_vlan_aware_join_vxlan_last()
 {
 	ip link add dev br0 up type bridge mcast_snooping 0 \
 		vlan_filtering 1 vlan_default_pvid 1
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	__offload_indication_join_vxlan_last
 
@@ -1067,14 +1093,14 @@ offload_indication_vlan_aware_l3vni_test()
 	sysctl_set net.ipv6.conf.default.disable_ipv6 1
 	ip link add dev br0 up type bridge mcast_snooping 0 \
 		vlan_filtering 1 vlan_default_pvid 0
-	ip link add name vxlan0 up type vxlan id 10 nolearning noudpcsum \
-		ttl 20 tos inherit local 198.51.100.1 dstport 4789
+	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
 	ip link set dev $swp1 master br0
 
 	# The test will use the offload indication on the FDB entry to
 	# understand if the tunnel is offloaded or not
-	bridge fdb append $zmac dev vxlan0 self dst 192.0.2.1
+	bridge fdb append $zmac dev vxlan0 self dst $LOCAL_IP_2
 
 	ip link set dev vxlan0 master br0
 	bridge vlan add dev vxlan0 vid 10 pvid untagged
-- 
2.31.1

