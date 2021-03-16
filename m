Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B715633D66F
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbhCPPE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:04:59 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51897 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237700AbhCPPEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:04:22 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BBA585C012C;
        Tue, 16 Mar 2021 11:04:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 16 Mar 2021 11:04:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=93rwysau0Jpm/Yrv8v03kZQdKrKZGfsFaNuHvB8HB6I=; b=H5Xnw1qd
        RHtgA3NsOpPeMSqqNRNY15sj4kWcX4ttgR30+UvklEdA18Jd8/wNm9CMLmOK38Fx
        7EIa6jjbkPW8MJi4+TBpSa1sEvIPNMtXUqTMJtVFIOM3Xg2M0OLqp4aLsIkE2mdv
        VSudmwERdZBSb2QnC0X/QjgifOVCMVk2XADvckg7gw1tBr9O7AEVvn+Q5GMZ+37L
        6N0+s0StyaGPDSIswv6TiRTQhIHwk58V+MNnS4yuHPyC7YfRk2/XuP1PTNejRUIi
        cFWobFS39XaFFVnJo3671o90m89/Dkwwkz3BpBZCxykcH7ZYEo0qYU41R6G/Li2n
        C+AU/BBg+y9y/Q==
X-ME-Sender: <xms:9chQYGazKmNhtMT0QpbJgkWhRwvbhy4olt6dEt7IdgOrOxAkfuk7ZA>
    <xme:9chQYJYiWrSl7FlWJKFXNrU5yIafyDs6F5WYmKQ4sZcxUhMkB4-4o7H2U_gLEKV-1
    qNlr1lRzen1bJo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:9chQYA_WG7NHeUmb0ZlPBELpJHrZAXFdisxTYP7S3bFad5XLtEpRtg>
    <xmx:9chQYIoK4-G79ZKvq6sCvBnr8y5vWKpAGZeD0bbVjaimoer9fUKjew>
    <xmx:9chQYBo9n8isR1RWzQXZ6ceQ13JwtItbCbzKspTl7Plc2OkYS2O50Q>
    <xmx:9chQYKCVzCxgaonbZ28CKoWOBJtSEBSTBk1Y3Sf3w_2AuBOpSBnoew>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5C0E91080057;
        Tue, 16 Mar 2021 11:04:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/10] selftests: mlxsw: Add tc sample tests for new triggers
Date:   Tue, 16 Mar 2021 17:03:02 +0200
Message-Id: <20210316150303.2868588-10-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316150303.2868588-1-idosch@idosch.org>
References: <20210316150303.2868588-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that packets are sampled when tc-sample is used with matchall
egress binding and flower classifier. Verify that when performing
sampling on egress the end-to-end latency is reported as metadata.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/tc_sample.sh  | 135 ++++++++++++++++++
 1 file changed, 135 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh
index 75d00104f291..57b05f042787 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh
@@ -41,6 +41,10 @@ ALL_TESTS="
 	tc_sample_md_lag_oif_test
 	tc_sample_md_out_tc_test
 	tc_sample_md_out_tc_occ_test
+	tc_sample_md_latency_test
+	tc_sample_acl_group_conflict_test
+	tc_sample_acl_rate_test
+	tc_sample_acl_max_rate_test
 "
 NUM_NETIFS=8
 CAPTURE_FILE=$(mktemp)
@@ -482,6 +486,137 @@ tc_sample_md_out_tc_occ_test()
 	tc filter del dev $rp1 ingress protocol all pref 1 handle 101 matchall
 }
 
+tc_sample_md_latency_test()
+{
+	RET=0
+
+	# Egress sampling not supported on Spectrum-1.
+	[[ "$DEVLINK_VIDDID" == "15b3:cb84" ]] && return
+
+	tc filter add dev $rp2 egress protocol all pref 1 handle 101 matchall \
+		skip_sw action sample rate 5 group 1
+	check_err $? "Failed to configure sampling rule"
+
+	psample_capture_start
+
+	ip vrf exec v$h1 $MZ $h1 -c 3200 -d 1msec -p 64 -A 192.0.2.1 \
+		-B 198.51.100.1 -t udp dp=52768,sp=42768 -q
+
+	psample_capture_stop
+
+	grep -q -e "latency " $CAPTURE_FILE
+	check_err $? "Sampled packets do not have latency attribute"
+
+	log_test "tc sample latency"
+
+	tc filter del dev $rp2 egress protocol all pref 1 handle 101 matchall
+}
+
+tc_sample_acl_group_conflict_test()
+{
+	RET=0
+
+	# Test that two flower sampling rules cannot be configured on the same
+	# port with different groups.
+
+	# Policy-based sampling is not supported on Spectrum-1.
+	[[ "$DEVLINK_VIDDID" == "15b3:cb84" ]] && return
+
+	tc filter add dev $rp1 ingress protocol ip pref 1 handle 101 flower \
+		skip_sw action sample rate 1024 group 1
+	check_err $? "Failed to configure sampling rule"
+
+	tc filter add dev $rp1 ingress protocol ip pref 2 handle 102 flower \
+		skip_sw action sample rate 1024 group 1
+	check_err $? "Failed to configure sampling rule with same group"
+
+	tc filter add dev $rp1 ingress protocol ip pref 3 handle 103 flower \
+		skip_sw action sample rate 1024 group 2 &> /dev/null
+	check_fail $? "Managed to configure sampling rule with conflicting group"
+
+	log_test "tc sample (w/ flower) group conflict test"
+
+	tc filter del dev $rp1 ingress protocol ip pref 2 handle 102 flower
+	tc filter del dev $rp1 ingress protocol ip pref 1 handle 101 flower
+}
+
+__tc_sample_acl_rate_test()
+{
+	local bind=$1; shift
+	local port=$1; shift
+	local pkts pct
+
+	RET=0
+
+	# Policy-based sampling is not supported on Spectrum-1.
+	[[ "$DEVLINK_VIDDID" == "15b3:cb84" ]] && return
+
+	tc filter add dev $port $bind protocol ip pref 1 handle 101 flower \
+		skip_sw dst_ip 198.51.100.1 action sample rate 32 group 1
+	check_err $? "Failed to configure sampling rule"
+
+	psample_capture_start
+
+	ip vrf exec v$h1 $MZ $h1 -c 3200 -d 1msec -p 64 -A 192.0.2.1 \
+		-B 198.51.100.1 -t udp dp=52768,sp=42768 -q
+
+	psample_capture_stop
+
+	pkts=$(grep -e "group 1 " $CAPTURE_FILE | wc -l)
+	pct=$((100 * (pkts - 100) / 100))
+	(( -25 <= pct && pct <= 25))
+	check_err $? "Expected 100 packets, got $pkts packets, which is $pct% off. Required accuracy is +-25%"
+
+	# Setup a filter that should not match any packet and make sure packets
+	# are not sampled.
+	tc filter del dev $port $bind protocol ip pref 1 handle 101 flower
+
+	tc filter add dev $port $bind protocol ip pref 1 handle 101 flower \
+		skip_sw dst_ip 198.51.100.10 action sample rate 32 group 1
+	check_err $? "Failed to configure sampling rule"
+
+	psample_capture_start
+
+	ip vrf exec v$h1 $MZ $h1 -c 3200 -d 1msec -p 64 -A 192.0.2.1 \
+		-B 198.51.100.1 -t udp dp=52768,sp=42768 -q
+
+	psample_capture_stop
+
+	grep -q -e "group 1 " $CAPTURE_FILE
+	check_fail $? "Sampled packets when should not"
+
+	log_test "tc sample (w/ flower) rate ($bind)"
+
+	tc filter del dev $port $bind protocol ip pref 1 handle 101 flower
+}
+
+tc_sample_acl_rate_test()
+{
+	__tc_sample_acl_rate_test ingress $rp1
+	__tc_sample_acl_rate_test egress $rp2
+}
+
+tc_sample_acl_max_rate_test()
+{
+	RET=0
+
+	# Policy-based sampling is not supported on Spectrum-1.
+	[[ "$DEVLINK_VIDDID" == "15b3:cb84" ]] && return
+
+	tc filter add dev $rp1 ingress protocol ip pref 1 handle 101 flower \
+		skip_sw action sample rate $((2 ** 24 - 1)) group 1
+	check_err $? "Failed to configure sampling rule with max rate"
+
+	tc filter del dev $rp1 ingress protocol ip pref 1 handle 101 flower
+
+	tc filter add dev $rp1 ingress protocol ip pref 1 handle 101 flower \
+		skip_sw action sample rate $((2 ** 24)) \
+		group 1 &> /dev/null
+	check_fail $? "Managed to configure sampling rate above maximum"
+
+	log_test "tc sample (w/ flower) maximum rate"
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.29.2

