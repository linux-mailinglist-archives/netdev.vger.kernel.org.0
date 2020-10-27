Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD84B29C81C
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829234AbgJ0TBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:01:35 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41585 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371397AbgJ0TA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id s9so3113833wro.8
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KUwIDVuHZxC8CM1QJ43pGK3dXQdVN5CV0sqGlBsC+08=;
        b=B3t+dQ/ZMMRClgJdoY14DL/k5UGsWQP38sZjmzFQd7RLR7qkuQk1EBXLiJTRJiNrw1
         92oddnXE7M1avb9oEjN7p0/QVObZam7DxopYI2EMEgwOqD/lF4/4XlUzN1uVP3VKwtAK
         A1nsyIgF8xK/rugo4ODblyeV5Ssif8cVlEX3P+QMmD7bB66QKv29bWbBF1cD7qDg3wxA
         hyVxOj3YE165ebEvHl/uVkq741DDXaVuyn2rJ7kadooQ676fORbYxOrJbiw5Y1BdsWaH
         0B8S4plE5OurnFsB+DlwItxmK9ERr6G1gcHsPL8o+RVQnEc3LmC9aCR78P627mD7ZnYz
         kH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KUwIDVuHZxC8CM1QJ43pGK3dXQdVN5CV0sqGlBsC+08=;
        b=eTM4LjNEwQwfE+BI5cSVj9MPuW4JHGUl4xHwiMvp7sE0P6rVPorpdVI9y7mZM0p2c3
         pOu62vY1fwvOppyQIdVuMZKqyR9RzyMzETPfScsV8SlJuYbXzMPsaBnhYo2WwRUNU4TG
         k/eVoV9ofg1x1aHTzzh+UX0OtZ7tv8x/ptGUvDw9y332EakMGTn3rFu7M8Mo01CiwC+i
         KebKJailTMWURK/R7cIXFzIKXtgan6o/MKRUTJWWOEo8VJOqJUJX4dLyJ87ViYsIcDh2
         OBKVZ8ph6Zi6yQOJeBLJavSZ8WQ6+1fMPU/6HZ/l4j8bzt6AEXQjjRk34U5SGM4ggAuN
         OXfw==
X-Gm-Message-State: AOAM530bVhoqtSQgq4s7AOMqpYTT1r/d1HyjXj4afhktagegw4TV5BXg
        pP1pvwVTvGMfcijbp3wmwMyT8QYnK1PvIaib
X-Google-Smtp-Source: ABdhPJzvT/ZlEfqgxAcgH92K0h8DlZLP1JqONyLOH87tppbgYxW9DPuab304ZhyFExvldGBnhee+oA==
X-Received: by 2002:adf:80c8:: with SMTP id 66mr4566237wrl.415.1603825223987;
        Tue, 27 Oct 2020 12:00:23 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:23 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 15/16] selftests: net: bridge: add test for igmpv3 exclude timeout
Date:   Tue, 27 Oct 2020 20:59:33 +0200
Message-Id: <20201027185934.227040-16-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201027185934.227040-1-razor@blackwall.org>
References: <20201027185934.227040-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Test that when a group in exclude mode expires it changes mode to
include and the blocked entries are deleted.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_igmp.sh   | 49 ++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 45c5619666d8..db0a03e30868 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -3,7 +3,8 @@
 
 ALL_TESTS="v2reportleave_test v3include_test v3inc_allow_test v3inc_is_include_test \
 	   v3inc_is_exclude_test v3inc_to_exclude_test v3exc_allow_test v3exc_is_include_test \
-	   v3exc_is_exclude_test v3exc_to_exclude_test v3inc_block_test v3exc_block_test"
+	   v3exc_is_exclude_test v3exc_to_exclude_test v3inc_block_test v3exc_block_test \
+	   v3exc_timeout_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -574,6 +575,52 @@ v3exc_block_test()
 	v3cleanup $swp1 $TEST_GROUP
 }
 
+v3exc_timeout_test()
+{
+	RET=0
+	local X=("192.0.2.20" "192.0.2.30")
+
+	# GMI should be 3 seconds
+	ip link set dev br0 type bridge mcast_query_interval 100 mcast_query_response_interval 100
+
+	v3exclude_prepare $h1 $ALL_MAC $ALL_GROUP
+	ip link set dev br0 type bridge mcast_query_interval 500 mcast_query_response_interval 500
+	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_ALLOW2" -q
+	sleep 3
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and \
+				.source_list != null and .filter_mode == \"include\")" &>/dev/null
+	check_err $? "Wrong *,G entry filter mode"
+
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and \
+				.source_list != null and
+				.source_list[].address == \"192.0.2.1\")" &>/dev/null
+	check_fail $? "Wrong *,G entry source list, 192.0.2.1 entry still exists"
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and \
+				.source_list != null and
+				.source_list[].address == \"192.0.2.2\")" &>/dev/null
+	check_fail $? "Wrong *,G entry source list, 192.0.2.2 entry still exists"
+
+	check_sg_entries "allow" "${X[@]}"
+
+	check_sg_state 0 "${X[@]}"
+
+	check_sg_fwding 1 "${X[@]}"
+	check_sg_fwding 0 192.0.2.100
+
+	log_test "IGMPv3 group $TEST_GROUP exclude timeout"
+
+	ip link set dev br0 type bridge mcast_query_interval 12500 \
+					mcast_query_response_interval 1000
+
+	v3cleanup $swp1 $TEST_GROUP
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

