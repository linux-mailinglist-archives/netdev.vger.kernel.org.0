Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CF243CD69
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242727AbhJ0PWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:22:52 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33613 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238301AbhJ0PWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 11:22:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 290565C0061;
        Wed, 27 Oct 2021 11:20:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 27 Oct 2021 11:20:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=vD+VUktvH8nThBn1xXiSfDhqCo5l8bGMsG4p5hCr5rc=; b=EJSPwC8D
        YcsHTmFILV7YAyOJ2LW7xCgXj/Urv4WYgiCtJK/GO9bXnV9RGz7rnU8rcVtJUCM+
        PKJzjyLGgiQTud+AXG7RECLVT6FxieGXkuAeUtqRTcT7mKdPOor4j+GwrxBSqbGN
        xq9z4/cDi3MRzH/DfZaDKcYnkyn7M4nTqROC9t5H9rH7gbLSEe32/aearv+6uCPJ
        a5uMX9SL9bhxS/fvRRsV14Z6iL/CzpVwxTBnuC5pRTTZAq86Cl899PF++Q7tuaj/
        mzEQDUWgozQ7+YP2fTNRdCjox8P4o3TJiMPOAoke4/HdDvGt8in4r2OzsX+xJk/e
        ZS5rjeAmhdI7aw==
X-ME-Sender: <xms:OW55Yb7AcLJigoD520thXcs79DAtF3m2YB_F04gqURSM3Ux7gjzmHQ>
    <xme:OW55YQ7hSgL_kcCK25xQ3zuUBzSGFHfaNY_iYabOaykopvx_abWdLwQfd8xXS9rXo
    p0h-7rZE7f5Oa8>
X-ME-Received: <xmr:OW55YSe_XNQbANaa-CimqUnchqdeZ5_o3K0PWkuJgLAeHzZCe60NRRgxSPESh11qLf2oF-kHr_ArCTp6s83IwoQY72I3kqJuTQ5beZXiM9F-2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:OW55YcLZEQ7G2IpW9Nni1OQmuav2MsmtVez_Js6Y7U0wmgpn8fZWGw>
    <xmx:OW55YfLHWT5_9GyxhgR0ns_0H8a9wpt6tlAw0ThSxCWQOFstABxOPQ>
    <xmx:OW55YVwq3OX39_LFevUN0egO6TRFQv6qNpCpmyPEet5KXQTQvmvsKg>
    <xmx:Om55YcG1mjFpaRplXr3HgwOWA6Lr5rGCwD7NsXb8fdOxJMhYj69KQQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 11:20:23 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/3] selftests: mlxsw: Test port shaper
Date:   Wed, 27 Oct 2021 18:20:01 +0300
Message-Id: <20211027152001.1320496-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027152001.1320496-1-idosch@idosch.org>
References: <20211027152001.1320496-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

TBF can be used as a root qdisc, in which case it is supposed to configure
port shaper. Add a test that verifies that this is so by installing a root
TBF with a ETS or PRIO below it, and then expecting individual bands to all
be shaped according to the root TBF configuration.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/forwarding/sch_tbf_etsprio.sh         | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh b/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh
index 8bd85da1905a..75a37c189ef3 100644
--- a/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh
+++ b/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh
@@ -4,9 +4,12 @@
 ALL_TESTS="
 	ping_ipv4
 	tbf_test
+	tbf_root_test
 "
 source $lib_dir/sch_tbf_core.sh
 
+QDISC_TYPE=${QDISC% *}
+
 tbf_test_one()
 {
 	local bs=$1; shift
@@ -22,6 +25,8 @@ tbf_test_one()
 
 tbf_test()
 {
+	log_info "Testing root-$QDISC_TYPE-tbf"
+
 	# This test is used for both ETS and PRIO. Even though we only need two
 	# bands, PRIO demands a minimum of three.
 	tc qdisc add dev $swp2 root handle 10: $QDISC 3 priomap 2 1 0
@@ -29,6 +34,29 @@ tbf_test()
 	tc qdisc del dev $swp2 root
 }
 
+tbf_root_test()
+{
+	local bs=128K
+
+	log_info "Testing root-tbf-$QDISC_TYPE"
+
+	tc qdisc replace dev $swp2 root handle 1: \
+		tbf rate 400Mbit burst $bs limit 1M
+	tc qdisc replace dev $swp2 parent 1:1 handle 10: \
+		$QDISC 3 priomap 2 1 0
+	tc qdisc replace dev $swp2 parent 10:3 handle 103: \
+		bfifo limit 1M
+	tc qdisc replace dev $swp2 parent 10:2 handle 102: \
+		bfifo limit 1M
+	tc qdisc replace dev $swp2 parent 10:1 handle 101: \
+		bfifo limit 1M
+
+	do_tbf_test 10 400 $bs
+	do_tbf_test 11 400 $bs
+
+	tc qdisc del dev $swp2 root
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.31.1

