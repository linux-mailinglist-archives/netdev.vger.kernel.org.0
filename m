Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C9234CDB1
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 12:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbhC2KKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 06:10:51 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37993 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232592AbhC2KKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 06:10:30 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4942A5C00E4;
        Mon, 29 Mar 2021 06:10:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 06:10:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=jISKp6s8FivG4t1UYI6sBhKbNi9pzdQD5kHqKX5v60Y=; b=dthKIe1O
        JcDuz3HULD8J9f23EBtQ9WfM40MyrzuCKFA3DmDywQZpFSAaBo5/JAH2cU9Fgram
        BYqxoz7xKYRrGcQk2wIzgIXEbEQIhCyJWVZSL2HoloJ0DP9IpZQWV6vunI+gCb1O
        WJqiw8TEmAatBw7FKSJFyxaHuq9cmiQZeqvtkn3OHQegfN+XnugRlqwsEeQM3vOn
        iJmqQhHp9RBE6W2qfW/vJb2waOmV7wvGT7STfVTf3PmKqwY5fHPsCWmXfnae2UvN
        UYcRSUrQUoJzsYxi8dn66lGY7er6CEiwzLW5zEci04b8dR/EtIVZtk4U1+Y0ehKv
        eVjDwg8WkQ5Ntw==
X-ME-Sender: <xms:lqdhYNJ4I5hM3fAXGXGvOpHJWREZqKt2XvfsHnshNAvllhBXjq2wzw>
    <xme:lqdhYMYlvVevLZ5eI94pYCtfRM7GG0P2d_AOsUOcR77_gM90qmz-5btURWW8AE7mO
    _Egvp_ViI1f7wc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:lqdhYPJ8y7pl_-X20IPzrR4WNWx4kLYdDdi3p0Uc0Xu2v16LMxtNkQ>
    <xmx:lqdhYKAaX9B2Owqsh6ICGkertKfSTasNjKwliUOhvIFzWhohouVz0w>
    <xmx:lqdhYEqXe4ANvWKpbfPwsfxXTF5e7-l25a-difV1O1LoBi875dELJA>
    <xmx:lqdhYHCTjuDz5nydAmtKgicgJ9N8GL-T9ofojRyDJbshkDqSOYdbIw>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id B0C59240054;
        Mon, 29 Mar 2021 06:10:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/6] selftests: mlxsw: Test matchall failure with protocol match
Date:   Mon, 29 Mar 2021 13:09:46 +0300
Message-Id: <20210329100948.355486-5-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329100948.355486-1-idosch@idosch.org>
References: <20210329100948.355486-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The driver can only offload matchall rules that do not match on a
protocol. Test that matchall rules that match on a protocol are vetoed.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../drivers/net/mlxsw/tc_restrictions.sh        | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
index b4dbda706c4d..5ec3beb637c8 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
@@ -11,6 +11,7 @@ ALL_TESTS="
 	matchall_mirror_behind_flower_ingress_test
 	matchall_sample_behind_flower_ingress_test
 	matchall_mirror_behind_flower_egress_test
+	matchall_proto_match_test
 	police_limits_test
 	multi_police_test
 "
@@ -291,6 +292,22 @@ matchall_mirror_behind_flower_egress_test()
 	matchall_behind_flower_egress_test "mirror" "mirred egress mirror dev $swp2"
 }
 
+matchall_proto_match_test()
+{
+	RET=0
+
+	tc qdisc add dev $swp1 clsact
+
+	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
+		matchall skip_sw \
+		action sample group 1 rate 100
+	check_fail $? "Incorrect success to add matchall rule with protocol match"
+
+	tc qdisc del dev $swp1 clsact
+
+	log_test "matchall protocol match"
+}
+
 police_limits_test()
 {
 	RET=0
-- 
2.30.2

