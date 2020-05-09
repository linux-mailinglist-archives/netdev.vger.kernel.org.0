Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A16B1CC464
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 22:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgEIUGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 16:06:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42073 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728681AbgEIUGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 16:06:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id CE10D5C00CE;
        Sat,  9 May 2020 16:06:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 09 May 2020 16:06:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=c0OhqFEfoWZ8yIfJiuRc2d/1tNfQD5ujnvKjBg1TiCc=; b=1UxNaASr
        P6gg+pVale/WziPxGlR15ZkA8ZacsrN6Xsit+RzsOxTlGB/xBCj+62UIJXik/+FP
        nAZxBSxUb5LZ6tEdb5c+qI6m2h/w+G2V9+9rilp4faZrkfRtkcWgHWzgHaX7jZI8
        yGTwKeMPVjU9zOWAhD2hC8EB4C0PdicHNh1T2eV5UvOax0Iv51naKnQLpXfbuT5v
        pGhjsYBPe4Pjng1NmsKklYLZ0FjlbNazJoPIaUiT+NXfTLoe4lEtpxyw+Nh9RTIv
        WpsWpysNohl23U8oIcbn4cjLGNYunzVXS6NvsJB/T0AwG1ii56ldVY/q9FsT0tiV
        YDF6sG7WkGkTsw==
X-ME-Sender: <xms:WQ23XqH4H949qKHg2TCq0p5jaZyO6bCHgT51lPOXs089rOZqFqQLGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:WQ23Xvl3jsCYYqepiab4Kn9HfgOo3elm_QMsrrzCLAAzflCzNboYWQ>
    <xmx:WQ23XvK3qUX0vQNYeBhK0w7OprcXndG7ezcjkk9VRFlWyaB5scfUUA>
    <xmx:WQ23XobHnaIQgtvagHxsCr7WT7aye6BDgTXXUhaWZXRpBOml6RxIbg>
    <xmx:WQ23XkXsHWNS3KduZbZZeGlCKiQJB2YPGpjKtctJ8EyoSS5gUSwAeQ>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7C7D3306612B;
        Sat,  9 May 2020 16:06:48 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 9/9] selftests: mlxsw: tc_restrictions: add couple of test for the correct matchall-flower ordering
Date:   Sat,  9 May 2020 23:06:10 +0300
Message-Id: <20200509200610.375719-10-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509200610.375719-1-idosch@idosch.org>
References: <20200509200610.375719-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Make sure that the drive restricts incorrect order of inserted matchall
vs. flower rules.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/tc_restrictions.sh      | 107 ++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
index a67e80315e47..9241250c5921 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
@@ -8,6 +8,9 @@ ALL_TESTS="
 	egress_redirect_test
 	multi_mirror_test
 	matchall_sample_egress_test
+	matchall_mirror_behind_flower_ingress_test
+	matchall_sample_behind_flower_ingress_test
+	matchall_mirror_behind_flower_egress_test
 "
 NUM_NETIFS=2
 
@@ -180,6 +183,110 @@ matchall_sample_egress_test()
 	log_test "matchall sample egress"
 }
 
+matchall_behind_flower_ingress_test()
+{
+	local action=$1
+	local action_args=$2
+
+	RET=0
+
+	# On ingress, all matchall-mirror and matchall-sample
+	# rules have to be in front of the flower rules
+
+	tc qdisc add dev $swp1 clsact
+
+	tc filter add dev $swp1 ingress protocol ip pref 10 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 action drop
+
+	tc filter add dev $swp1 ingress protocol all pref 9 handle 102 \
+		matchall skip_sw action $action_args
+	check_err $? "Failed to add matchall rule in front of a flower rule"
+
+	tc filter del dev $swp1 ingress protocol all pref 9 handle 102 matchall
+
+	tc filter add dev $swp1 ingress protocol all pref 11 handle 102 \
+		matchall skip_sw action $action_args
+	check_fail $? "Incorrect success to add matchall rule behind a flower rule"
+
+	tc filter del dev $swp1 ingress protocol ip pref 10 handle 101 flower
+
+	tc filter add dev $swp1 ingress protocol all pref 9 handle 102 \
+		matchall skip_sw action $action_args
+
+	tc filter add dev $swp1 ingress protocol ip pref 10 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 action drop
+	check_err $? "Failed to add flower rule behind a matchall rule"
+
+	tc filter del dev $swp1 ingress protocol ip pref 10 handle 101 flower
+
+	tc filter add dev $swp1 ingress protocol ip pref 8 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 action drop
+	check_fail $? "Incorrect success to add flower rule in front of a matchall rule"
+
+	tc qdisc del dev $swp1 clsact
+
+	log_test "matchall $action flower ingress"
+}
+
+matchall_mirror_behind_flower_ingress_test()
+{
+	matchall_behind_flower_ingress_test "mirror" "mirred egress mirror dev $swp2"
+}
+
+matchall_sample_behind_flower_ingress_test()
+{
+	matchall_behind_flower_ingress_test "sample" "sample rate 100 group 1"
+}
+
+matchall_behind_flower_egress_test()
+{
+	local action=$1
+	local action_args=$2
+
+	RET=0
+
+	# On egress, all matchall-mirror rules have to be behind the flower rules
+
+	tc qdisc add dev $swp1 clsact
+
+	tc filter add dev $swp1 egress protocol ip pref 10 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 action drop
+
+	tc filter add dev $swp1 egress protocol all pref 11 handle 102 \
+		matchall skip_sw action $action_args
+	check_err $? "Failed to add matchall rule in front of a flower rule"
+
+	tc filter del dev $swp1 egress protocol all pref 11 handle 102 matchall
+
+	tc filter add dev $swp1 egress protocol all pref 9 handle 102 \
+		matchall skip_sw action $action_args
+	check_fail $? "Incorrect success to add matchall rule behind a flower rule"
+
+	tc filter del dev $swp1 egress protocol ip pref 10 handle 101 flower
+
+	tc filter add dev $swp1 egress protocol all pref 11 handle 102 \
+		matchall skip_sw action $action_args
+
+	tc filter add dev $swp1 egress protocol ip pref 10 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 action drop
+	check_err $? "Failed to add flower rule behind a matchall rule"
+
+	tc filter del dev $swp1 egress protocol ip pref 10 handle 101 flower
+
+	tc filter add dev $swp1 egress protocol ip pref 12 handle 101 flower \
+		skip_sw dst_ip 192.0.2.2 action drop
+	check_fail $? "Incorrect success to add flower rule in front of a matchall rule"
+
+	tc qdisc del dev $swp1 clsact
+
+	log_test "matchall $action flower egress"
+}
+
+matchall_mirror_behind_flower_egress_test()
+{
+	matchall_behind_flower_egress_test "mirror" "mirred egress mirror dev $swp2"
+}
+
 setup_prepare()
 {
 	swp1=${NETIFS[p1]}
-- 
2.26.2

