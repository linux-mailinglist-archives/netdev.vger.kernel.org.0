Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722AF438C64
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 00:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhJXWhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 18:37:34 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50299 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231786AbhJXWha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 18:37:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8553F5C0771;
        Sun, 24 Oct 2021 03:19:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 Oct 2021 03:19:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=tH0odi6+dOJB/ftCaHwWrWWRwsYj4EliDFdp51KoBGQ=; b=RihaIJGk
        nfUqpXQQk9Oc8efPlhNnvpPwKb3GKDDXNypWiUgY+F+ZeBPir7PyT6BFctyZZo5s
        xaXVnwpZ9RQpQeiYwijnlAu0YMEJueir0YuaN4chy12nm1sc1u01VWzlWMfrckn8
        9z4jMSya/KBsUu9WZh6I4cDqK5IEcDkd/7OedF+nB9F6zO2+Iw26Vf7XXGLmFoXE
        sEasmuxd/cQenCxH08Hp64TmsBk5EO/GgLz2eWU79s9oB/aLxZNnNWUI0wblLixg
        mN8yet9Ed9Drhwvv6syFNQa/qCWOXN1cEwbu5GxA9f+98+2dH213w7aeQGagrSUj
        fQ3VpjrLptf2Qw==
X-ME-Sender: <xms:DQl1YYEgHKG_IajU6saGMJIOS5dYOV7s9JUaaqKt2S3LEPREs7N6Gw>
    <xme:DQl1YRXZD_sDjqe976xvyxLdWKdMZe7p_Tl83eB5Ds-BFt0XmYYm_fxk09rsk_1mB
    1OSdOdwvgTCU9Y>
X-ME-Received: <xmr:DQl1YSKkhG8l2q6Q6ccJgd2Rcu3lYWAPHEavlQ-1DaBiPDA_DNDmG18gy1xWP-Q98UrcoqoRaTHlO_DA3MBO70v-lQ3B_cg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefvddgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:DQl1YaHaK7dgtTiGI4N8zWglYfJRzW66_alwIpkpnWTQynA0Dgs6_A>
    <xmx:DQl1YeWAyMovApKnMsDLzy5mrUK-q5Fb72pxEDpInDGQHj9Pv5Sn9w>
    <xmx:DQl1YdM7L2V3tV1TN_AxTT3SAgfEkw1UxuHqyjDLNoNnKyG1tbmO9A>
    <xmx:Dgl1Ycx5MU0fEsJwmCabOhwwzMGXfEzEK8j0f66-cgOekGILD6ykQw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 24 Oct 2021 03:19:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/3] selftests: mlxsw: Reduce test run time
Date:   Sun, 24 Oct 2021 10:19:11 +0300
Message-Id: <20211024071911.1064322-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211024071911.1064322-1-idosch@idosch.org>
References: <20211024071911.1064322-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Instead of iterating over all the available trap policers, only perform
the tests with three policers: The first, the last and the one in the
middle of the range. On a Spectrum-3 system, this reduces the run time
from almost an hour to a few minutes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/mlxsw/devlink_trap_policer.sh | 32 ++++++++++++-------
 .../selftests/net/forwarding/devlink_lib.sh   |  6 ----
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh
index 508a702f0021..0bd5ffc218ac 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_policer.sh
@@ -272,13 +272,17 @@ __rate_test()
 
 rate_test()
 {
-	local id
+	local last_policer=$(devlink -j -p trap policer show |
+			     jq '[.[]["'$DEVLINK_DEV'"][].policer] | max')
 
-	for id in $(devlink_trap_policer_ids_get); do
-		echo
-		log_info "Running rate test for policer $id"
-		__rate_test $id
-	done
+	log_info "Running rate test for policer 1"
+	__rate_test 1
+
+	log_info "Running rate test for policer $((last_policer / 2))"
+	__rate_test $((last_policer / 2))
+
+	log_info "Running rate test for policer $last_policer"
+	__rate_test $last_policer
 }
 
 __burst_test()
@@ -342,13 +346,17 @@ __burst_test()
 
 burst_test()
 {
-	local id
+	local last_policer=$(devlink -j -p trap policer show |
+			     jq '[.[]["'$DEVLINK_DEV'"][].policer] | max')
+
+	log_info "Running burst test for policer 1"
+	__burst_test 1
+
+	log_info "Running burst test for policer $((last_policer / 2))"
+	__burst_test $((last_policer / 2))
 
-	for id in $(devlink_trap_policer_ids_get); do
-		echo
-		log_info "Running burst size test for policer $id"
-		__burst_test $id
-	done
+	log_info "Running burst test for policer $last_policer"
+	__burst_test $last_policer
 }
 
 trap cleanup EXIT
diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 2c14a86adaaa..de9944d42027 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -563,12 +563,6 @@ devlink_trap_group_policer_get()
 		| jq '.[][][]["policer"]'
 }
 
-devlink_trap_policer_ids_get()
-{
-	devlink -j -p trap policer show \
-		| jq '.[]["'$DEVLINK_DEV'"][]["policer"]'
-}
-
 devlink_port_by_netdev()
 {
 	local if_name=$1
-- 
2.31.1

