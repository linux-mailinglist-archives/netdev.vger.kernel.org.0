Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783E139F707
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhFHMqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:46:45 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34267 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232704AbhFHMql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 08:46:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 496405C00AE;
        Tue,  8 Jun 2021 08:44:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Jun 2021 08:44:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=K4kDhtbEB+P0gDPeh80v9Bpjxrxmvtfn4m/YHa1XzKs=; b=JD366IYl
        fM9Hi0WWKhatybqFkmfwef9Co06tUetPDib+fVLjEESuQwmXzGA1V85U2VtKxxTY
        GUvju0jHDmG0GX7HA8adB7ZQL93jh2Rqwb2YrnhLZKRPpUTAjpb7DS2UtxSfVhPJ
        0kpekMkl5Lgr851dVY+MEDbIT1LQHBp4nKriIIg7HRoHH/3ZalT2oTfFKDIkD8qk
        lRRap1z4SPbvdA2iGU3b4G61rufdGDXz4rTeKGw8oXocYOvrBxrJ7wp/JRShwzMz
        CAS8KA5misN8/6HlxE8gu1Ujyo0xv4uZA55t6Hp8ljxSOJAf1lu3LWMTzP3+m2A+
        SNTcOgEdZB10NA==
X-ME-Sender: <xms:P2a_YNJ29uS-xmGSDIsdCHFn4YYPA_RTX81JYqDCWpbhOQdqyqIyUw>
    <xme:P2a_YJJfP9nFTc5bLJbBaUdU0rjp7NSvHe-ftasq6sYq7TSBJXN1TvwPSeoDEChtk
    YaBot1DXoNOIik>
X-ME-Received: <xmr:P2a_YFs10R3rq1Cajtvp9K7pkpjYZpIfnI0qbdigvG6htKnEODnelqB3skyoM-w0MS6xQgoMDdnDkKstqHccmfipC0fB2LltpomtQpmqBtQL8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:P2a_YOblygbQ1xOixvUYRwfueSoRTnwJb3onFAz0dDIahzpEMsd-YQ>
    <xmx:P2a_YEZLPM9UDqn7SbRUIHDkvm8zHqHoV78KRc5C90JG8RC4Ivm_yQ>
    <xmx:P2a_YCCNuwGGcfW8AkMrw69v9XoCKLLot_SbH7J5fA23xjQh2Knb_w>
    <xmx:P2a_YE7yZ6jvlhfz7I2UclxpYe07MrDVOPHE56ouPgsCU2zYcCah_Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:44:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, vadimp@nvidia.com,
        c_mykolak@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/8] selftests: Clean forgotten resources as part of cleanup()
Date:   Tue,  8 Jun 2021 15:44:09 +0300
Message-Id: <20210608124414.1664294-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608124414.1664294-1-idosch@idosch.org>
References: <20210608124414.1664294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Several tests do not set some ports down as part of their cleanup(),
resulting in IPv6 link-local addresses and associated routes not being
deleted.

These leaks were found using a BPF tool that monitors ASIC resources.

Solve this by setting the ports down at the end of the tests.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh       | 3 +++
 .../selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh  | 3 +++
 tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh   | 2 ++
 tools/testing/selftests/net/forwarding/pedit_dsfield.sh        | 2 ++
 tools/testing/selftests/net/forwarding/pedit_l4port.sh         | 2 ++
 tools/testing/selftests/net/forwarding/skbedit_priority.sh     | 2 ++
 6 files changed, 14 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
index 4029833f7e27..160891dcb4bc 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_drops.sh
@@ -109,6 +109,9 @@ router_destroy()
 	__addr_add_del $rp1 del 192.0.2.2/24 2001:db8:1::2/64
 
 	tc qdisc del dev $rp2 clsact
+
+	ip link set dev $rp2 down
+	ip link set dev $rp1 down
 }
 
 setup_prepare()
diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
index 42d44e27802c..190c1b6b5365 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_l3_exceptions.sh
@@ -111,6 +111,9 @@ router_destroy()
 	__addr_add_del $rp1 del 192.0.2.2/24 2001:db8:1::2/64
 
 	tc qdisc del dev $rp2 clsact
+
+	ip link set dev $rp2 down
+	ip link set dev $rp1 down
 }
 
 setup_prepare()
diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
index 5cbff8038f84..28a570006d4d 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
@@ -93,7 +93,9 @@ switch_destroy()
 	lldptool -T -i $swp1 -V APP -d $(dscp_map 10) >/dev/null
 	lldpad_app_wait_del
 
+	ip link set dev $swp2 down
 	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 down
 	ip link set dev $swp1 nomaster
 	ip link del dev br1
 }
diff --git a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
index 55eeacf59241..64fbd211d907 100755
--- a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
+++ b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
@@ -75,7 +75,9 @@ switch_destroy()
 	tc qdisc del dev $swp2 clsact
 	tc qdisc del dev $swp1 clsact
 
+	ip link set dev $swp2 down
 	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 down
 	ip link set dev $swp1 nomaster
 	ip link del dev br1
 }
diff --git a/tools/testing/selftests/net/forwarding/pedit_l4port.sh b/tools/testing/selftests/net/forwarding/pedit_l4port.sh
index 5f20d289ee43..10e594c55117 100755
--- a/tools/testing/selftests/net/forwarding/pedit_l4port.sh
+++ b/tools/testing/selftests/net/forwarding/pedit_l4port.sh
@@ -71,7 +71,9 @@ switch_destroy()
 	tc qdisc del dev $swp2 clsact
 	tc qdisc del dev $swp1 clsact
 
+	ip link set dev $swp2 down
 	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 down
 	ip link set dev $swp1 nomaster
 	ip link del dev br1
 }
diff --git a/tools/testing/selftests/net/forwarding/skbedit_priority.sh b/tools/testing/selftests/net/forwarding/skbedit_priority.sh
index e3bd8a6bb8b4..bde11dc27873 100755
--- a/tools/testing/selftests/net/forwarding/skbedit_priority.sh
+++ b/tools/testing/selftests/net/forwarding/skbedit_priority.sh
@@ -72,7 +72,9 @@ switch_destroy()
 	tc qdisc del dev $swp2 clsact
 	tc qdisc del dev $swp1 clsact
 
+	ip link set dev $swp2 down
 	ip link set dev $swp2 nomaster
+	ip link set dev $swp1 down
 	ip link set dev $swp1 nomaster
 	ip link del dev br1
 }
-- 
2.31.1

