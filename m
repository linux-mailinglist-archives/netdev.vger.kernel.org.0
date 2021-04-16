Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9683624B9
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 17:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbhDPP4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 11:56:54 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58119 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236168AbhDPP4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 11:56:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7FB4F5C00EC;
        Fri, 16 Apr 2021 11:56:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 16 Apr 2021 11:56:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=wGJvuhHZvNnmp+E1EpX9tgq6uEFUfYg1TGnCVzQ0bT0=; b=EdKmjBWm
        /adBw1o6HjJqj+ulaL74hqhF79xmMIUPfFFgvBDFe16cCwf+8e+ZkRbnWAGxquvR
        vcXfB/S6dmfZc+SSeeG+Hbp+syTRhOUCfBWBkNoOx/ExXqrWqgEbKWpY6Ht2Lhs7
        0/cGyBexnvmcpLALeq+iO51YWfuWR8dzrDWEn95KqrzyQdAlOuhGDqoVz44O1swD
        uClHgStePUn/BOmw1ugGBq4hDA5iEeTi44cmNdThhPp4+a+IINT9uz10DJXWvzCr
        RizbhpLJNR+ewj3484k4hmXcoxCeDXZeU7tEDOwuudQ+H05jlxwZvVEKm0WJf1xO
        gUWsKJVsQ6Ve3Q==
X-ME-Sender: <xms:q7N5YJE2J2y2p-5KBfZ1E4Hc88QFVfx-pSHydJ0kX4Ex2RiBCaPGtQ>
    <xme:q7N5YOWdWptfBdVhlwKrlnU5-tkbgXZfdItOkpJ_Ur539mCy7hP-7gVjyJKejQQ51
    _Blj6cmS5MugFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelhedgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrudek
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:q7N5YLJQ7asiz-UKhGgFiWMnhs2jVCDY4a31jQw9_jgz9HuH3rgA2Q>
    <xmx:q7N5YPGzhm858o-4qOUBGT_u8CEvi1Lu5DPvMC0FgJEOtlwUKYExhg>
    <xmx:q7N5YPXndJ6x-iUoIQ3cRyu4VOHX8tTFQ0h-bfZHjZNIZaQB4peyCw>
    <xmx:q7N5YKTUHvX1TCq0NFVxSQPTo0e4ouMimro0TRu2mZlFd1b7EIGqdg>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 872421080063;
        Fri, 16 Apr 2021 11:56:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/2] selftests: fib_nexthops: Test large scale nexthop flushing
Date:   Fri, 16 Apr 2021 18:55:35 +0300
Message-Id: <20210416155535.1694714-3-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416155535.1694714-1-idosch@idosch.org>
References: <20210416155535.1694714-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that all the nexthops are flushed when a multi-part nexthop dump is
required for the flushing.

Without previous patch:

 # ./fib_nexthops.sh
 TEST: Large scale nexthop flushing                                  [FAIL]

With previous patch:

 # ./fib_nexthops.sh
 TEST: Large scale nexthop flushing                                  [ OK ]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 56dd0c6f2e96..49774a8a7736 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -1933,6 +1933,21 @@ basic()
 	log_test $? 2 "Nexthop group and blackhole"
 
 	$IP nexthop flush >/dev/null 2>&1
+
+	# Test to ensure that flushing with a multi-part nexthop dump works as
+	# expected.
+	local batch_file=$(mktemp)
+
+	for i in $(seq 1 $((64 * 1024))); do
+		echo "nexthop add id $i blackhole" >> $batch_file
+	done
+
+	$IP -b $batch_file
+	$IP nexthop flush >/dev/null 2>&1
+	[[ $($IP nexthop | wc -l) -eq 0 ]]
+	log_test $? 0 "Large scale nexthop flushing"
+
+	rm $batch_file
 }
 
 check_nexthop_buckets_balance()
-- 
2.30.2

