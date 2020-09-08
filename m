Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F4F260E60
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgIHJME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:12:04 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:60235 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727995AbgIHJLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 06DA9E88;
        Tue,  8 Sep 2020 05:11:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=d1vM0GHv/cJlisJj9UdjIZ/fQ5+5v7JG1KmbBxF5EkQ=; b=siO3Ezjd
        6Te0o9VZJPIpZeuYtnG0Fm2pQjFzMktvCzuCgk+zwW3k6Qxngj0LSoK1meLNnGLj
        ebNzhiRZ4yxJqpmxp1qrhFueffUl2YIUzbaKGahckzf6dLzgKDCf0zGy/gscpJkK
        H2F5Sno1FnvT3UKgMDdnNkWSV+bkWFRUT8cAkaLTcKtSCSLRc1I/Yh4dNl3nrn8b
        F8iHy6x0n2CcF7fdyHVUXOC80d7OWncFVHUyizbqs4UepFzCwu/dtCuFtnx8j6M0
        BZLkZqDA6B6SAl0RhXjknUAM+DmSJJH2/kqFp/03vydMnlPpv7Wj6b1+UMnKnuzf
        HaZSsp/tvL7Q0A==
X-ME-Sender: <xms:w0pXXwbV0-IBALAOKGuqkdB7TFeTLdf6d-DfFZyK3tsX0YIzos1Vgw>
    <xme:w0pXX7YzE8MOApYfqktDtRjfcC4relVNxykrN1bKCpePdQ4ItvnGu9_U2z-IdvTdA
    YiCAsZ9xbjZ9Uo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:w0pXX6_gysYFLqUJm9SZ_Z1Dru5AS4Yk3p99OdGBEh9jyBPi88MOpA>
    <xmx:w0pXX6pQdhLtmFfvz1oDotfV_ZTjGcpvxIh1YFHy5i5meaca7cAO7Q>
    <xmx:w0pXX7rY1C0HKPbgm0vRRwBneSAO72SLOniBOddyquH4i1KPlzEkSQ>
    <xmx:w0pXX6VR5QbQ6wfP2teVSPs8u-fqxpQwVsWqBklfb28HCxvthEY5tg>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3B6A73064683;
        Tue,  8 Sep 2020 05:11:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 04/22] selftests: fib_nexthops: Test cleanup of FDB entries following nexthop deletion
Date:   Tue,  8 Sep 2020 12:10:19 +0300
Message-Id: <20200908091037.2709823-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908091037.2709823-1-idosch@idosch.org>
References: <20200908091037.2709823-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Commit c7cdbe2efc40 ("vxlan: support for nexthop notifiers") registered
a listener in the VXLAN driver to the nexthop notification chain. Its
purpose is to cleanup FDB entries that use a nexthop that is being
deleted.

Test that such FDB entries are removed when the nexthop group that they
use is deleted. Test that entries are not deleted when a single nexthop
in the group is deleted.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index b74884d52913..eb693a3b7b4a 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -411,9 +411,16 @@ ipv6_fdb_grp_fcnal()
 	run_cmd "$IP -6 ro add 2001:db8:101::1/128 nhid 103"
 	log_test $? 2 "Route add with fdb nexthop group"
 
+	run_cmd "$IP nexthop del id 61"
+	run_cmd "$BRIDGE fdb get to 02:02:00:00:00:13 dev vx10 self"
+	log_test $? 0 "Fdb entry after deleting a single nexthop"
+
 	run_cmd "$IP nexthop del id 102"
 	log_test $? 0 "Fdb nexthop delete"
 
+	run_cmd "$BRIDGE fdb get to 02:02:00:00:00:13 dev vx10 self"
+	log_test $? 254 "Fdb entry after deleting a nexthop group"
+
 	$IP link del dev vx10
 }
 
@@ -484,9 +491,16 @@ ipv4_fdb_grp_fcnal()
 	run_cmd "$IP ro add 172.16.0.0/22 nhid 103"
 	log_test $? 2 "Route add with fdb nexthop group"
 
+	run_cmd "$IP nexthop del id 12"
+	run_cmd "$BRIDGE fdb get to 02:02:00:00:00:13 dev vx10 self"
+	log_test $? 0 "Fdb entry after deleting a single nexthop"
+
 	run_cmd "$IP nexthop del id 102"
 	log_test $? 0 "Fdb nexthop delete"
 
+	run_cmd "$BRIDGE fdb get to 02:02:00:00:00:13 dev vx10 self"
+	log_test $? 254 "Fdb entry after deleting a nexthop group"
+
 	$IP link del dev vx10
 }
 
-- 
2.26.2

