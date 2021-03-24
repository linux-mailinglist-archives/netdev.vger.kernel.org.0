Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBDE3482B7
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238197AbhCXUPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:15:41 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54213 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238132AbhCXUPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:15:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 08D115C015A;
        Wed, 24 Mar 2021 16:15:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 24 Mar 2021 16:15:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=gjwOCmwj8Ly39QjTpaKd53dkXglYdjb8Q1nEP7Wo9xc=; b=oW/NXP2P
        LfLMk8CwrYL5Ckpr4t5A8mJToREFOGIU5AHEM9PQiQp5XnyhMPs8qh8mo6N7DNGO
        JduE/AyE0eAMkTUMMIA4o6YQhhlfv2l9+oQMRu/+5h6C7k1rJGxiXBW3twqZCvBJ
        e3TcCmdwd9eOk4eTGF0ID403NJOF5W2H2E+cfW89of7Bs37QrTMMSkoUmywTCCKY
        cm/I+tisoKZaelnxPbN1pQXo5jhwYBYunEjgDqpvsVMjGBGfw9PDrteMMkEt5HdW
        toRs+SXgPJDrhBfj0VgyPQZBrEuURs3BvDxAicBTCoYYz/YXdYto/NI8yu4pVG5I
        G2YNH7bZiHn5ug==
X-ME-Sender: <xms:yp1bYK5d5RFDtsc-s_3TYShhLP3ePUhYQElBruSnNKwEyaKdL92ttg>
    <xme:yp1bYD5TMTmLcRl5-luvfrCAVImxCdp02RQ3Rfhlli7ioAELRAPXgjGoLXuJczm4M
    EW0LHnWYhCqbbI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegkedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:yp1bYJd9UiMSMITLC6jn4YDDM9k_BSQAgvFyZTboOURNXBLCjhwtbQ>
    <xmx:yp1bYHKPDCUWSeAEw-fx1NxBWjMPyN93zd2UgHpM4nFrpxfzx42OsQ>
    <xmx:yp1bYOJDlWS8d-WtjqjayCtKEDft7jyBda7umA3_EYyFQfMK5pUi5w>
    <xmx:y51bYDEp3yF6fQeQt6V4VtQXehhRvHKVr6PQbWesz35plJxSMG2WBw>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id F33D0240430;
        Wed, 24 Mar 2021 16:15:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/10] selftests: mlxsw: Add resilient nexthop groups configuration tests
Date:   Wed, 24 Mar 2021 22:14:24 +0200
Message-Id: <20210324201424.157387-11-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324201424.157387-1-idosch@idosch.org>
References: <20210324201424.157387-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that unsupported resilient nexthop group configurations are
rejected and that offload / trap indication is correctly set on nexthop
buckets in a resilient group.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  | 82 +++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  5 ++
 2 files changed, 87 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
index ed346da5d3cb..a217f9f6775b 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
@@ -33,6 +33,7 @@ ALL_TESTS="
 	nexthop_obj_invalid_test
 	nexthop_obj_offload_test
 	nexthop_obj_group_offload_test
+	nexthop_obj_bucket_offload_test
 	nexthop_obj_blackhole_offload_test
 	nexthop_obj_route_offload_test
 	devlink_reload_test
@@ -739,11 +740,28 @@ nexthop_obj_invalid_test()
 
 	ip nexthop add id 1 dev $swp1
 	ip nexthop add id 2 dev $swp1
+	ip nexthop add id 3 via 192.0.2.3 dev $swp1
 	ip nexthop add id 10 group 1/2
 	check_fail $? "managed to configure a nexthop group with device-only nexthops when should not"
 
+	ip nexthop add id 10 group 3 type resilient buckets 7
+	check_fail $? "managed to configure a too small resilient nexthop group when should not"
+
+	ip nexthop add id 10 group 3 type resilient buckets 129
+	check_fail $? "managed to configure a resilient nexthop group with invalid number of buckets when should not"
+
+	ip nexthop add id 10 group 1/2 type resilient buckets 32
+	check_fail $? "managed to configure a resilient nexthop group with device-only nexthops when should not"
+
+	ip nexthop add id 10 group 3 type resilient buckets 32
+	check_err $? "failed to configure a valid resilient nexthop group"
+	ip nexthop replace id 3 dev $swp1
+	check_fail $? "managed to populate a nexthop bucket with a device-only nexthop when should not"
+
 	log_test "nexthop objects - invalid configurations"
 
+	ip nexthop del id 10
+	ip nexthop del id 3
 	ip nexthop del id 2
 	ip nexthop del id 1
 
@@ -858,6 +876,70 @@ nexthop_obj_group_offload_test()
 	simple_if_fini $swp1 192.0.2.1/24 2001:db8:1::1/64
 }
 
+nexthop_obj_bucket_offload_test()
+{
+	# Test offload indication of nexthop buckets
+	RET=0
+
+	simple_if_init $swp1 192.0.2.1/24 2001:db8:1::1/64
+	simple_if_init $swp2
+	setup_wait
+
+	ip nexthop add id 1 via 192.0.2.2 dev $swp1
+	ip nexthop add id 2 via 2001:db8:1::2 dev $swp1
+	ip nexthop add id 10 group 1/2 type resilient buckets 32 idle_timer 0
+	ip neigh replace 192.0.2.2 lladdr 00:11:22:33:44:55 nud reachable \
+		dev $swp1
+	ip neigh replace 192.0.2.3 lladdr 00:11:22:33:44:55 nud reachable \
+		dev $swp1
+	ip neigh replace 2001:db8:1::2 lladdr 00:11:22:33:44:55 nud reachable \
+		dev $swp1
+
+	busywait "$TIMEOUT" wait_for_offload \
+		ip nexthop bucket show nhid 1
+	check_err $? "IPv4 nexthop buckets not marked as offloaded when should"
+	busywait "$TIMEOUT" wait_for_offload \
+		ip nexthop bucket show nhid 2
+	check_err $? "IPv6 nexthop buckets not marked as offloaded when should"
+
+	# Invalidate nexthop id 1
+	ip neigh replace 192.0.2.2 nud failed dev $swp1
+	busywait "$TIMEOUT" wait_for_trap \
+		ip nexthop bucket show nhid 1
+	check_err $? "IPv4 nexthop buckets not marked with trap when should"
+
+	# Invalidate nexthop id 2
+	ip neigh replace 2001:db8:1::2 nud failed dev $swp1
+	busywait "$TIMEOUT" wait_for_trap \
+		ip nexthop bucket show nhid 2
+	check_err $? "IPv6 nexthop buckets not marked with trap when should"
+
+	# Revalidate nexthop id 1 by changing its configuration
+	ip nexthop replace id 1 via 192.0.2.3 dev $swp1
+	busywait "$TIMEOUT" wait_for_offload \
+		ip nexthop bucket show nhid 1
+	check_err $? "nexthop bucket not marked as offloaded after revalidating nexthop"
+
+	# Revalidate nexthop id 2 by changing its neighbour
+	ip neigh replace 2001:db8:1::2 lladdr 00:11:22:33:44:55 nud reachable \
+		dev $swp1
+	busywait "$TIMEOUT" wait_for_offload \
+		ip nexthop bucket show nhid 2
+	check_err $? "nexthop bucket not marked as offloaded after revalidating neighbour"
+
+	log_test "nexthop bucket offload indication"
+
+	ip neigh del 2001:db8:1::2 dev $swp1
+	ip neigh del 192.0.2.3 dev $swp1
+	ip neigh del 192.0.2.2 dev $swp1
+	ip nexthop del id 10
+	ip nexthop del id 2
+	ip nexthop del id 1
+
+	simple_if_fini $swp2
+	simple_if_fini $swp1 192.0.2.1/24 2001:db8:1::1/64
+}
+
 nexthop_obj_blackhole_offload_test()
 {
 	# Test offload indication of blackhole nexthop objects
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index be71012b8fc5..05c05e02bade 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -353,6 +353,11 @@ wait_for_offload()
 	"$@" | grep -q offload
 }
 
+wait_for_trap()
+{
+	"$@" | grep -q trap
+}
+
 until_counter_is()
 {
 	local expr=$1; shift
-- 
2.30.2

