Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2020026A45A
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 13:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgIOLqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 07:46:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42391 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726137AbgIOLnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 07:43:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E2B645C004B;
        Tue, 15 Sep 2020 07:41:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 07:41:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=R1y9Mma9sU9srpiUHUc7yNIiodSmxT9kKrmlRNaMRRc=; b=OJvSM9bM
        tnnrc2jh6L6AR67no8MwUSGngeZYC9yBzpZpcDhyGAyIYUkTkfQpHbjeYHDRrUp2
        IUF6dME7jvKNwLO7KmXQ530Hhwbpuu4Q96TmhmQcsVk7BCoKnKMAwgQhfjMyBZs4
        IcdYlssqzaiei//GgdCHzmaYInzMnbFvHrgKn4YaPouneptEJIgpIGJ9MtRY89MH
        ttel9epmkoR1TCJ60UeKcYMlvrkiwJqZvgGec4SefNy9ZEMVrEiryLw/ywUKFuXA
        +a7VrfmDVDMce2zFzBGsa822E3A6+Wn+DNAm4WJHDhByXQ7nK6eLCXJygF3aHAet
        CtnCk6w0zUcXgQ==
X-ME-Sender: <xms:hqhgX891sCR1D8esEGcuorCdGCEz5tqai-QKmO36OOkDAOfyRymJow>
    <xme:hqhgX0s_xI2NFkeug-WjFFPdeysj7wsQQA9qNC2zqjSj88jKFoIl1wAELEt5E3TfS
    ANHdSUIm9vw3ao>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddtgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefiedrkedvnecu
    vehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:hqhgXyCt8AfT0S3vjK1bjnmXHGCGGTUr4ZMe6TqHLBVy2sDWFdROow>
    <xmx:hqhgX8fiZzu0auNF9WuVIwFSM5d1XhjYXxrYM_whxlb0JvPRUS0qxg>
    <xmx:hqhgXxMdsn5iFeIRzm0nokExccpCVjduvab2GFKiIdVa3ugzQV6p3g>
    <xmx:hqhgX6aZjrJaD_WrLlrd7x7DIeI7GNlDcrfKGLsEppmQ8by9Um8Ewg>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 163543064682;
        Tue, 15 Sep 2020 07:41:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/5] selftests: fib_nexthops: Test cleanup of FDB entries following nexthop deletion
Date:   Tue, 15 Sep 2020 14:41:03 +0300
Message-Id: <20200915114103.88883-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915114103.88883-1-idosch@idosch.org>
References: <20200915114103.88883-1-idosch@idosch.org>
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
Reviewed-by: David Ahern <dsahern@gmail.com>
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

