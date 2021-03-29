Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5671534CDB3
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 12:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhC2KKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 06:10:53 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59675 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231687AbhC2KKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 06:10:34 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0FCCB5C0078;
        Mon, 29 Mar 2021 06:10:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 06:10:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=V8GiiPRto8cFaPsD/oWwdpe/afofgMZJeftVo1w4l8c=; b=wkOwKPNd
        prOWg63x3C5S4KtB2WY2/zXbTPNqlyZAlq5UyQY1vY031Wd9XoU7rl+jcMnfRFc0
        aPEpiHvdUYnSQd8bzZA8Xe6qae74H95E/guMeWdUDteRxVqJmvkdtvWt/AbJdJax
        phh6GsGQFvZonUM62tOL+OaAlK8NExXYPr9UxWM01nnwdF54/JKh2GaWL+HFzRJD
        0ZwYwe+x3D0DTUheDoeVdRT8VeLK1VAjUNr5Fopnt3oEG7C/9DR7zCkEsbZgm2i0
        IPXthzMxawdZ8XGs3xk4A4nz+vhP+zxiG4O0oHEZxQrR2GVLnZ0KQQci8Q48Z0m9
        DCx++a4vOSKM1w==
X-ME-Sender: <xms:madhYOt78rUdtEiRXntHR6eVQ17wBRTQfwu0w6gvvj7ZkAPkp7NIlg>
    <xme:madhYDcBLqJd5oHka-jMSkCbDzCmkzybLW6JE5B1V8mdDOgTcw0rZQHMnxAmeQ5Bm
    Xu4RvdmbDhrVMk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:madhYJxGwiqVsJ6V6bCJFn6zy2nJErG5wbSJGCcLcpcTZsc_KwHHVg>
    <xmx:madhYJOk22Ro_3xSriFlvhz28ngSnsgbxpz6yvJE8zQ3ubh5Y8Ijwg>
    <xmx:madhYO_oKLU9votet-E0n9AfrMPKBEpUZOPNnqMJuiVIIJBGDsSBFw>
    <xmx:mqdhYAKFSJuEzFKdZaoKrMFlY6hIB4Ql_Fb3X03FMIOqIDtaRh8tXw>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4B17B240054;
        Mon, 29 Mar 2021 06:10:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/6] selftests: mlxsw: Test vetoing of double sampling
Date:   Mon, 29 Mar 2021 13:09:48 +0300
Message-Id: <20210329100948.355486-7-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329100948.355486-1-idosch@idosch.org>
References: <20210329100948.355486-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that two sampling rules cannot be configured on the same port with
the same trigger.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/tc_sample.sh  | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh
index 57b05f042787..093bed088ad0 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh
@@ -34,6 +34,7 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 ALL_TESTS="
 	tc_sample_rate_test
 	tc_sample_max_rate_test
+	tc_sample_conflict_test
 	tc_sample_group_conflict_test
 	tc_sample_md_iif_test
 	tc_sample_md_lag_iif_test
@@ -272,6 +273,35 @@ tc_sample_max_rate_test()
 	log_test "tc sample maximum rate"
 }
 
+tc_sample_conflict_test()
+{
+	RET=0
+
+	# Test that two sampling rules cannot be configured on the same port,
+	# even when they share the same parameters.
+
+	tc filter add dev $rp1 ingress protocol all pref 1 handle 101 matchall \
+		skip_sw action sample rate 1024 group 1
+	check_err $? "Failed to configure sampling rule"
+
+	tc filter add dev $rp1 ingress protocol all pref 2 handle 102 matchall \
+		skip_sw action sample rate 1024 group 1 &> /dev/null
+	check_fail $? "Managed to configure second sampling rule"
+
+	# Delete the first rule and make sure the second rule can now be
+	# configured.
+
+	tc filter del dev $rp1 ingress protocol all pref 1 handle 101 matchall
+
+	tc filter add dev $rp1 ingress protocol all pref 2 handle 102 matchall \
+		skip_sw action sample rate 1024 group 1
+	check_err $? "Failed to configure sampling rule after deletion"
+
+	log_test "tc sample conflict test"
+
+	tc filter del dev $rp1 ingress protocol all pref 2 handle 102 matchall
+}
+
 tc_sample_group_conflict_test()
 {
 	RET=0
-- 
2.30.2

