Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1223430B0D5
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbhBATwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:52:46 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:51599 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232840AbhBATwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:52:02 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5C271580518;
        Mon,  1 Feb 2021 14:49:02 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 01 Feb 2021 14:49:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=4ns3nr/ZKGSjpfRNiHT1j2e5Yq7+hcHMqH9HTf52zRs=; b=WDf21+hE
        ZHC3rcYGi3iReWUxPrmiOii7w4oI9lv2L3Si8X8SJeaaTRGNP0zcSVMohrMiq2PG
        2yzQU/pwmZkp6DHfISoYdrBif0BEvLig50g64RxRjy68bOPMpwQrfQVEMBu5iSTb
        a7mPmCvS0X6Z8sV1NwzeWf/S929pLEfrN6yFdmaDIQ7Nc2x26WcyS2KCmmMWktzj
        qi5/C54GwwiN2B/Juv9FKNq7jmKepeRoG+hRWBhi+2bdhSnvMmy4mNRil8UnmKTi
        Q9s2nOeeM1hy8/wgh0w1z/DKgQkdqFEvnc5Io0BQIEcU9M5Nc3diqr6YeeC6CuyM
        m5NJ73wdi22Zzw==
X-ME-Sender: <xms:LlsYYEWcB1Ifhv2GKQcBUdemcS3rScoqA9JGIJZq9Z5D7wDZZJ7a4w>
    <xme:LlsYYImjNfFCTT4CaBvEgOEdSTxTQrRTz17wZVnZI8cu3Bi7fLDRcZUSWZLrS7qhX
    QD0O2fOUZ6kyh0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:LlsYYIYPcGzosb3rz-LqnSYv86lxMNuImqG9V75LO8s6_ZswV4Zrlg>
    <xmx:LlsYYDVsFKIFec2EvoT9DkyqLhU1UVPB8ftZmjEKhJzxp3DyKm5L2A>
    <xmx:LlsYYOl0CU9dH7vySZUgEnDu_FtNNZMzi8DhSeyq4-7QdHpI5OKa3g>
    <xmx:LlsYYI7l-egMjqZhlzLdQ3IRbxBtfElPMIYu8u3td1D5WP2ZCPAb3g>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0742B24005B;
        Mon,  1 Feb 2021 14:48:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, jiri@nvidia.com, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 09/10] selftests: Extend fib tests to run with and without flags notifications
Date:   Mon,  1 Feb 2021 21:47:56 +0200
Message-Id: <20210201194757.3463461-10-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201194757.3463461-1-idosch@idosch.org>
References: <20210201194757.3463461-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Run the test cases with both `fib_notify_on_flag_change` sysctls set to
'1', and then with both sysctls set to '0' to verify there are no
regressions in the test when notifications are added.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/fib.sh   | 14 ++++++++++++++
 .../testing/selftests/drivers/net/netdevsim/fib.sh | 14 ++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/fib.sh b/tools/testing/selftests/drivers/net/mlxsw/fib.sh
index eab79b9e58cd..dcbf32b99bb6 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/fib.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/fib.sh
@@ -225,6 +225,16 @@ ipv6_local_replace()
 	ip -n $ns link del dev dummy1
 }
 
+fib_notify_on_flag_change_set()
+{
+	local notify=$1; shift
+
+	ip netns exec testns1 sysctl -qw net.ipv4.fib_notify_on_flag_change=$notify
+	ip netns exec testns1 sysctl -qw net.ipv6.fib_notify_on_flag_change=$notify
+
+	log_info "Set fib_notify_on_flag_change to $notify"
+}
+
 setup_prepare()
 {
 	ip netns add testns1
@@ -251,6 +261,10 @@ trap cleanup EXIT
 
 setup_prepare
 
+fib_notify_on_flag_change_set 1
+tests_run
+
+fib_notify_on_flag_change_set 0
 tests_run
 
 exit $EXIT_STATUS
diff --git a/tools/testing/selftests/drivers/net/netdevsim/fib.sh b/tools/testing/selftests/drivers/net/netdevsim/fib.sh
index 2f87c3be76a9..251f228ce63e 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/fib.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/fib.sh
@@ -302,6 +302,16 @@ ipv6_error_path()
 	ipv6_error_path_replay
 }
 
+fib_notify_on_flag_change_set()
+{
+	local notify=$1; shift
+
+	ip netns exec testns1 sysctl -qw net.ipv4.fib_notify_on_flag_change=$notify
+	ip netns exec testns1 sysctl -qw net.ipv6.fib_notify_on_flag_change=$notify
+
+	log_info "Set fib_notify_on_flag_change to $notify"
+}
+
 setup_prepare()
 {
 	local netdev
@@ -336,6 +346,10 @@ trap cleanup EXIT
 
 setup_prepare
 
+fib_notify_on_flag_change_set 1
+tests_run
+
+fib_notify_on_flag_change_set 0
 tests_run
 
 exit $EXIT_STATUS
-- 
2.29.2

