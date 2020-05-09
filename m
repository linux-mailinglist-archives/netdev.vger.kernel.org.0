Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770A11CC462
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 22:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgEIUGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 16:06:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33211 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728718AbgEIUGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 16:06:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 660385C00B6;
        Sat,  9 May 2020 16:06:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 09 May 2020 16:06:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=wD6C9uofuT4suP5kxS3E91eENLXtqcXXEKgO7itcUqU=; b=3LUNEQMi
        j5RJBljbFy3ovbWImkLD5Y+qncsTqMMN6LQ+5tGmS6UiHX3QXj2Ayk2J8dh6LPrE
        95xvyy/aHBvM0/SxFwTQmOMuvN11CPrOzOh5FauqjjnvG+W/ui4HKesH6qJmHia4
        JPCDAmeHrUxmRSSOy26jSJ4Kma6uq6tlBGBrLbfl59TSXhZKTnG2FWt6wVuMQxLu
        F+hYw9dAs3ayr1PxQYqMIAJqwpoiPTf6gN4Y4PfJ3svlbky71ik7FOc0pN+0ywGa
        5keWr00rcuZKkSxvmog0zyU4V/sFg2KaMbs15EAYoxsGjyd6AcJV2W0H47WltxGc
        ku3XjyyOi+0hLQ==
X-ME-Sender: <xms:WA23Xs34p2aA3r_L8lwVZbPIznuoN7NgoJEV6_SgOJDmoFAVTUTX3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:WA23XioVqVbCmbrXTPxGGZ5Io_ophKZySK7xGGYM8ZANID_uXm0lZQ>
    <xmx:WA23XlwdAOStMtLTDYXo9c7rnk_xXHjmZfJqUF60_b_TpE_fF25qIw>
    <xmx:WA23XovcZZom7wI65H2ks0h0WvacTQ6exvZ_km1f4ab5evVoepYBIw>
    <xmx:WA23XmkeiUanyxKtOjqbJveoBNYIEDtu7ZY45Lx_TdWJcLFAuufMfw>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D2B2306622F;
        Sat,  9 May 2020 16:06:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 8/9] selftests: mlxsw: tc_restrictions: add test to check sample action restrictions
Date:   Sat,  9 May 2020 23:06:09 +0300
Message-Id: <20200509200610.375719-9-idosch@idosch.org>
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

Check that matchall rules with sample actions are not possible to be
inserted to egress.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/tc_restrictions.sh      | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
index 68c80d0ec1ec..a67e80315e47 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
@@ -7,6 +7,7 @@ ALL_TESTS="
 	shared_block_drop_test
 	egress_redirect_test
 	multi_mirror_test
+	matchall_sample_egress_test
 "
 NUM_NETIFS=2
 
@@ -155,6 +156,30 @@ multi_mirror_test()
 	log_test "multi mirror"
 }
 
+matchall_sample_egress_test()
+{
+	RET=0
+
+	# It is forbidden in mlxsw driver to have matchall with sample action
+	# bound on egress
+
+	tc qdisc add dev $swp1 clsact
+
+	tc filter add dev $swp1 ingress protocol all pref 1 handle 101 \
+		matchall skip_sw action sample rate 100 group 1
+	check_err $? "Failed to add rule with sample action on ingress"
+
+	tc filter del dev $swp1 ingress protocol all pref 1 handle 101 matchall
+
+	tc filter add dev $swp1 egress protocol all pref 1 handle 101 \
+		matchall skip_sw action sample rate 100 group 1
+	check_fail $? "Incorrect success to add rule with sample action on egress"
+
+	tc qdisc del dev $swp1 clsact
+
+	log_test "matchall sample egress"
+}
+
 setup_prepare()
 {
 	swp1=${NETIFS[p1]}
-- 
2.26.2

