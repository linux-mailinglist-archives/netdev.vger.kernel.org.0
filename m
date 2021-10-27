Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF7243CD68
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbhJ0PWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:22:51 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51063 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238299AbhJ0PWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 11:22:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9EF7C5C00F7;
        Wed, 27 Oct 2021 11:20:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 27 Oct 2021 11:20:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=oTghbd6J1FALMUG8fJbNQTCqLV4UwF4zp7k3ExlXynE=; b=WxBLCydZ
        AUJ4edBl9w/kuRQ5deq7wBavAbfsyTszbDseZ/JRA0/ogkdhiALz7q12sacnxyRr
        fi86U78kNaylK2gZJxpfjPBeADgY8ur3U23nFeGuAxbGMbmNyJbIk7e4tjvmvDgA
        t9WMJcjNPDNzPKeFPVo4AXXmdAuMaYlTDEA21Tv99A8UP5a6kqgx/KhmIOKOStTj
        +gii5+/0Gef3uh8vrx1Hh3u2ZuwJrDPO13FzQl3Xb6RyBlddd7c16ZUgoGHrgxFz
        DHakf149+JNW0cepURMHtZjA3am1MBKBMpd03cGyX/LrptntjVhz1jjQKbBI6mKE
        k6ERijo7jjFnxA==
X-ME-Sender: <xms:N255YWr1hhLIwk8pSDMosxvSo8del1cUDlLdlGhRdO6bScALFlJ1NA>
    <xme:N255YUrWoZU8GfZ5JqqMbD8xucV9mBdlkfJohqHEGLTk1N3pRcXtYW0kh37zyF09o
    AltqdBZiXjAjBs>
X-ME-Received: <xmr:N255YbMRB8ymQX20Eu1XCYArygU06BCgMPDGdWKhwyjHLm7-6fLbmE2rEncToqWrsPD4UxfRstcL0jjH6gNJcKwp3SZNoAvkdp0hKbfcTW_k7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:N255YV7H0AhIfzhxtI4wbIPU0pTaVR5klNVL6-h1uM2vYMyK5x1BCA>
    <xmx:N255YV4b794LFYK8L5gS-Tao0t766cFD9BVnuQVEHeg3w9OaTXq_ig>
    <xmx:N255YVi38_1VJB00wBrLnE2kGHjnfj8fwPNyE81hA8bMg0aVAtL3dw>
    <xmx:N255YY1C5qoL8fpehcUpEGSSpDeGsMrnffyYemPzucN7IJwEEcGtGA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 11:20:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/3] selftests: mlxsw: Test offloadability of root TBF
Date:   Wed, 27 Oct 2021 18:20:00 +0300
Message-Id: <20211027152001.1320496-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027152001.1320496-1-idosch@idosch.org>
References: <20211027152001.1320496-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

TBF can be used as a root qdisc, with the usual ETS/RED/TBF hierarchy below
it. This use should now be offloaded. Add a test that verifies that it is.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/sch_offload.sh     | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_offload.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_offload.sh
index ade79ef08de3..071a33d10c20 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_offload.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_offload.sh
@@ -6,7 +6,9 @@
 
 ALL_TESTS="
 	test_root
+	test_port_tbf
 	test_etsprio
+	test_etsprio_port_tbf
 "
 NUM_NETIFS=1
 lib_dir=$(dirname $0)/../../../net/forwarding
@@ -221,6 +223,12 @@ test_root()
 	do_test_combinations 1 0
 }
 
+test_port_tbf()
+{
+	with_tbf 1: root \
+		do_test_combinations 8 1
+}
+
 do_test_etsprio()
 {
 	local parent=$1; shift
@@ -264,6 +272,12 @@ test_etsprio()
 	do_test_etsprio root ""
 }
 
+test_etsprio_port_tbf()
+{
+	with_tbf 1: root \
+		do_test_etsprio "parent 1:1" "-TBF"
+}
+
 cleanup()
 {
 	tc qdisc del dev $h1 root &>/dev/null
-- 
2.31.1

