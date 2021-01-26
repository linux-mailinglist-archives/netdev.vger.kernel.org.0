Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25F230403D
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 15:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404062AbhAZO07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 09:26:59 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:59133 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391762AbhAZN00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:26:26 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id F37CF9D0;
        Tue, 26 Jan 2021 08:24:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 26 Jan 2021 08:24:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=4ns3nr/ZKGSjpfRNiHT1j2e5Yq7+hcHMqH9HTf52zRs=; b=i1gQ97dk
        7eKUauJ/j3tToXlsQ9QZiSRVx3u7mrajC38K7cy3lduTkRgAWKXYkwvZfeR3FAwJ
        TqpIebIN40UYOiAn8YJKQGjvcgrrnKjXT/5txKobFH1XfMOzhdtl+t2+SJoeJg6m
        V2kQoW8Us9OjyVtn7GYFTNCBFj9qxOP+/ScfocIPPuHVlE8XFwPw7HCkSpCTc1CM
        SinF5cY+jBoyLr/U4KL+2CFXijq0+oTcfzoGYw7HullEva5iTERDG5N6/PbKAebr
        MW9HAUq0eY6cIwH+kKYarE83yiPPUt2yrIXA6YM12bIj3l/qEcYQ+3MINqRQvZrL
        CB+q4IuiLtJmAA==
X-ME-Sender: <xms:ExgQYJB-IanbCLrIJTFyPn0v4tGmWNQeH74M1vqkRMim0GoRknDC2A>
    <xme:ExgQYHhfru-Jyis5LksPi8gnCo6U9No96E4XhV_x0LKAHqu8LRx0ZSoms8NxISic9
    FexRgEbKv_Ns2c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ExgQYEnOBMGAXm3Bk3q5enCtxmr7-iwbVhhQtN_A5yZ6EWQUP9Wtnw>
    <xmx:ExgQYDzXkD60K0r6qlrgEHMHXaw1l9N78E0S44xLB5lOa87biUxGfg>
    <xmx:ExgQYORQn3RZFP8I63l9o_lHdAyVkSXD_j80t-ix8-XKnAzZdiL4Wg>
    <xmx:ExgQYNGnKznjcQQODc7oNf37iTDXnECiPM-9tZszH2xtLNmAx9R85Q>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 68523108005F;
        Tue, 26 Jan 2021 08:24:33 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        amcohen@nvidia.com, roopa@nvidia.com, sharpd@nvidia.com,
        bpoirier@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/10] selftests: Extend fib tests to run with and without flags notifications
Date:   Tue, 26 Jan 2021 15:23:10 +0200
Message-Id: <20210126132311.3061388-10-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126132311.3061388-1-idosch@idosch.org>
References: <20210126132311.3061388-1-idosch@idosch.org>
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

