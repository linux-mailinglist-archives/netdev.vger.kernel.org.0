Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8451C2A4CC9
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgKCRY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgKCRYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:23 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E87C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:24:22 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id v5so107249wmh.1
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d4X+MzHPwavfeH5vks+WjS48DbZu9bbXsSeUnpDGMKQ=;
        b=FjUllosqkdGlWR4KVAlsTkE2uYTCktcrQdzP4gNWgWavgYG9TEwxOn6eDl8udqwaXs
         U47Y4QJz/MAkocHfT2qs7akapff+NyVsuVRt4g5Kz5dmz3bpAcYxhNyRuUC9GrZJ77jv
         Rx4a+Km3fr5vyy55b35jtNm5jDtKFmdl3+KkwVYPuHFsooLc/3XtsDBrmR9B5LKeNpVZ
         FoKf2Rbl5/UEOtQy2qrvKVSsnRhZege2DhSP/hXpKhuqw+8gmbOG37IUxofcJIhypj9v
         Fb8nFyoYcl34rfKvWOXfrcnKU5HBgfnbmLPwGQuh8+pq/cWMxZtGsk1LPOWVgyI1Iwe+
         Q1rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d4X+MzHPwavfeH5vks+WjS48DbZu9bbXsSeUnpDGMKQ=;
        b=KVv36QnliEZQmZFj7DQgm3antplROjATxOaocY55AWMec6tLUI/VWgXMC/cLxHtBwx
         AiHkLUKExUCd1NHHJS5R5jvdO5K/sXx49QAltAVwSU452u/a9zvuEJpaLOAzoLxO/GOZ
         ecTglaOV5o6ZyR5GDyNhhhTkDj6HJA3twbWUZX1BQfKa9qi30MbJ7NH9VBW6nE7T3BcF
         MPJIMsQlNct8s34qhkOIujK2I8wsMa+hgjod3Ez5Kb6gwUvD4XfsVwNp/uZNneZli/QH
         nEGoQstus+YinC89ELNazO21d1YOaczpnICHOYxQOWn7CHY3/vguxUw8rXf7o+Wzp4Y9
         3jxg==
X-Gm-Message-State: AOAM530O4bANRNygLZzB83vfjYoS1tjYUSqYVmGLVVLK4TVqCTmhBSt4
        tlt0TDxFg8gKqTz+MmEvOzx82gfSPEe8DKyh
X-Google-Smtp-Source: ABdhPJwkGwPgfKhA7iokMUYPfVknlU1XqKX40mLt+0+gPLBCU2x8u/H2li//CaVOP24Phr+f7JeOJQ==
X-Received: by 2002:a1c:4888:: with SMTP id v130mr218579wma.84.1604424260462;
        Tue, 03 Nov 2020 09:24:20 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a128sm2650795wmf.5.2020.11.03.09.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:24:19 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 03/16] selftests: net: bridge: factor out and rename sg state functions
Date:   Tue,  3 Nov 2020 19:23:59 +0200
Message-Id: <20201103172412.1044840-4-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103172412.1044840-1-razor@blackwall.org>
References: <20201103172412.1044840-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Factor out S,G entry state checking functions for existence, forwarding,
blocking and timer to lib.sh so they can be later used by MLDv2 tests.
Add brmcast_ suffix to their name to make the relation to the bridge
explicit.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_igmp.sh   | 179 ++++++------------
 tools/testing/selftests/net/forwarding/lib.sh |  67 +++++++
 2 files changed, 123 insertions(+), 123 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 50a48ce16ba1..675eff45b037 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -137,73 +137,6 @@ v2reportleave_test()
 	log_test "IGMPv2 leave $TEST_GROUP"
 }
 
-check_sg_entries()
-{
-	local report=$1; shift
-	local slist=("$@")
-	local sarg=""
-
-	for src in "${slist[@]}"; do
-		sarg="${sarg} and .source_list[].address == \"$src\""
-	done
-	bridge -j -d -s mdb show dev br0 \
-		| jq -e ".[].mdb[] | \
-			 select(.grp == \"$TEST_GROUP\" and .source_list != null $sarg)" &>/dev/null
-	check_err $? "Wrong *,G entry source list after $report report"
-
-	for sgent in "${slist[@]}"; do
-		bridge -j -d -s mdb show dev br0 \
-			| jq -e ".[].mdb[] | \
-				 select(.grp == \"$TEST_GROUP\" and .src == \"$sgent\")" &>/dev/null
-		check_err $? "Missing S,G entry ($sgent, $TEST_GROUP)"
-	done
-}
-
-check_sg_fwding()
-{
-	local should_fwd=$1; shift
-	local sources=("$@")
-
-	for src in "${sources[@]}"; do
-		local retval=0
-
-		mcast_packet_test $TEST_GROUP_MAC $src $TEST_GROUP $h2 $h1
-		retval=$?
-		if [ $should_fwd -eq 1 ]; then
-			check_fail $retval "Didn't forward traffic from S,G ($src, $TEST_GROUP)"
-		else
-			check_err $retval "Forwarded traffic for blocked S,G ($src, $TEST_GROUP)"
-		fi
-	done
-}
-
-check_sg_state()
-{
-	local is_blocked=$1; shift
-	local sources=("$@")
-	local should_fail=1
-
-	if [ $is_blocked -eq 1 ]; then
-		should_fail=0
-	fi
-
-	for src in "${sources[@]}"; do
-		bridge -j -d -s mdb show dev br0 \
-			| jq -e ".[].mdb[] | \
-				 select(.grp == \"$TEST_GROUP\" and .source_list != null) |
-				 .source_list[] |
-				 select(.address == \"$src\") |
-				 select(.timer == \"0.00\")" &>/dev/null
-		check_err_fail $should_fail $? "Entry $src has zero timer"
-
-		bridge -j -d -s mdb show dev br0 \
-			| jq -e ".[].mdb[] | \
-				 select(.grp == \"$TEST_GROUP\" and .src == \"$src\" and \
-				 .flags[] == \"blocked\")" &>/dev/null
-		check_err_fail $should_fail $? "Entry $src has blocked flag"
-	done
-}
-
 v3include_prepare()
 {
 	local host1_if=$1
@@ -225,7 +158,7 @@ v3include_prepare()
 			 select(.grp == \"$TEST_GROUP\" and \
 				.source_list != null and .filter_mode == \"include\")" &>/dev/null
 	check_err $? "Wrong *,G entry filter mode"
-	check_sg_entries "is_include" "${X[@]}"
+	brmcast_check_sg_entries "is_include" "${X[@]}"
 }
 
 v3exclude_prepare()
@@ -247,10 +180,10 @@ v3exclude_prepare()
 				.source_list != null and .filter_mode == \"exclude\")" &>/dev/null
 	check_err $? "Wrong *,G entry filter mode"
 
-	check_sg_entries "is_exclude" "${X[@]}" "${Y[@]}"
+	brmcast_check_sg_entries "is_exclude" "${X[@]}" "${Y[@]}"
 
-	check_sg_state 0 "${X[@]}"
-	check_sg_state 1 "${Y[@]}"
+	brmcast_check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 1 "${Y[@]}"
 
 	bridge -j -d -s mdb show dev br0 \
 		| jq -e ".[].mdb[] | \
@@ -276,10 +209,10 @@ v3include_test()
 
 	v3include_prepare $h1 $ALL_MAC $ALL_GROUP
 
-	check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 0 "${X[@]}"
 
-	check_sg_fwding 1 "${X[@]}"
-	check_sg_fwding 0 "192.0.2.100"
+	brmcast_check_sg_fwding 1 "${X[@]}"
+	brmcast_check_sg_fwding 0 "192.0.2.100"
 
 	log_test "IGMPv3 report $TEST_GROUP is_include"
 
@@ -295,12 +228,12 @@ v3inc_allow_test()
 
 	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_ALLOW" -q
 	sleep 1
-	check_sg_entries "allow" "${X[@]}"
+	brmcast_check_sg_entries "allow" "${X[@]}"
 
-	check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 0 "${X[@]}"
 
-	check_sg_fwding 1 "${X[@]}"
-	check_sg_fwding 0 "192.0.2.100"
+	brmcast_check_sg_fwding 1 "${X[@]}"
+	brmcast_check_sg_fwding 0 "192.0.2.100"
 
 	log_test "IGMPv3 report $TEST_GROUP include -> allow"
 
@@ -316,12 +249,12 @@ v3inc_is_include_test()
 
 	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_IS_INC2" -q
 	sleep 1
-	check_sg_entries "is_include" "${X[@]}"
+	brmcast_check_sg_entries "is_include" "${X[@]}"
 
-	check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 0 "${X[@]}"
 
-	check_sg_fwding 1 "${X[@]}"
-	check_sg_fwding 0 "192.0.2.100"
+	brmcast_check_sg_fwding 1 "${X[@]}"
+	brmcast_check_sg_fwding 0 "192.0.2.100"
 
 	log_test "IGMPv3 report $TEST_GROUP include -> is_include"
 
@@ -334,8 +267,8 @@ v3inc_is_exclude_test()
 
 	v3exclude_prepare $h1 $ALL_MAC $ALL_GROUP
 
-	check_sg_fwding 1 "${X[@]}" 192.0.2.100
-	check_sg_fwding 0 "${Y[@]}"
+	brmcast_check_sg_fwding 1 "${X[@]}" 192.0.2.100
+	brmcast_check_sg_fwding 0 "${Y[@]}"
 
 	log_test "IGMPv3 report $TEST_GROUP include -> is_exclude"
 
@@ -361,10 +294,10 @@ v3inc_to_exclude_test()
 				.source_list != null and .filter_mode == \"exclude\")" &>/dev/null
 	check_err $? "Wrong *,G entry filter mode"
 
-	check_sg_entries "to_exclude" "${X[@]}" "${Y[@]}"
+	brmcast_check_sg_entries "to_exclude" "${X[@]}" "${Y[@]}"
 
-	check_sg_state 0 "${X[@]}"
-	check_sg_state 1 "${Y[@]}"
+	brmcast_check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 1 "${Y[@]}"
 
 	bridge -j -d -s mdb show dev br0 \
 		| jq -e ".[].mdb[] | \
@@ -379,8 +312,8 @@ v3inc_to_exclude_test()
 				.source_list[].address == \"192.0.2.21\")" &>/dev/null
 	check_fail $? "Wrong *,G entry source list, 192.0.2.21 entry still exists"
 
-	check_sg_fwding 1 "${X[@]}" 192.0.2.100
-	check_sg_fwding 0 "${Y[@]}"
+	brmcast_check_sg_fwding 1 "${X[@]}" 192.0.2.100
+	brmcast_check_sg_fwding 0 "${Y[@]}"
 
 	log_test "IGMPv3 report $TEST_GROUP include -> to_exclude"
 
@@ -399,13 +332,13 @@ v3exc_allow_test()
 
 	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_ALLOW2" -q
 	sleep 1
-	check_sg_entries "allow" "${X[@]}" "${Y[@]}"
+	brmcast_check_sg_entries "allow" "${X[@]}" "${Y[@]}"
 
-	check_sg_state 0 "${X[@]}"
-	check_sg_state 1 "${Y[@]}"
+	brmcast_check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 1 "${Y[@]}"
 
-	check_sg_fwding 1 "${X[@]}" 192.0.2.100
-	check_sg_fwding 0 "${Y[@]}"
+	brmcast_check_sg_fwding 1 "${X[@]}" 192.0.2.100
+	brmcast_check_sg_fwding 0 "${Y[@]}"
 
 	log_test "IGMPv3 report $TEST_GROUP exclude -> allow"
 
@@ -422,13 +355,13 @@ v3exc_is_include_test()
 
 	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_IS_INC3" -q
 	sleep 1
-	check_sg_entries "is_include" "${X[@]}" "${Y[@]}"
+	brmcast_check_sg_entries "is_include" "${X[@]}" "${Y[@]}"
 
-	check_sg_state 0 "${X[@]}"
-	check_sg_state 1 "${Y[@]}"
+	brmcast_check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 1 "${Y[@]}"
 
-	check_sg_fwding 1 "${X[@]}" 192.0.2.100
-	check_sg_fwding 0 "${Y[@]}"
+	brmcast_check_sg_fwding 1 "${X[@]}" 192.0.2.100
+	brmcast_check_sg_fwding 0 "${Y[@]}"
 
 	log_test "IGMPv3 report $TEST_GROUP exclude -> is_include"
 
@@ -445,13 +378,13 @@ v3exc_is_exclude_test()
 
 	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_IS_EXC2" -q
 	sleep 1
-	check_sg_entries "is_exclude" "${X[@]}" "${Y[@]}"
+	brmcast_check_sg_entries "is_exclude" "${X[@]}" "${Y[@]}"
 
-	check_sg_state 0 "${X[@]}"
-	check_sg_state 1 "${Y[@]}"
+	brmcast_check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 1 "${Y[@]}"
 
-	check_sg_fwding 1 "${X[@]}" 192.0.2.100
-	check_sg_fwding 0 "${Y[@]}"
+	brmcast_check_sg_fwding 1 "${X[@]}" 192.0.2.100
+	brmcast_check_sg_fwding 0 "${Y[@]}"
 
 	log_test "IGMPv3 report $TEST_GROUP exclude -> is_exclude"
 
@@ -471,13 +404,13 @@ v3exc_to_exclude_test()
 
 	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_TO_EXC" -q
 	sleep 1
-	check_sg_entries "to_exclude" "${X[@]}" "${Y[@]}"
+	brmcast_check_sg_entries "to_exclude" "${X[@]}" "${Y[@]}"
 
-	check_sg_state 0 "${X[@]}"
-	check_sg_state 1 "${Y[@]}"
+	brmcast_check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 1 "${Y[@]}"
 
-	check_sg_fwding 1 "${X[@]}" 192.0.2.100
-	check_sg_fwding 0 "${Y[@]}"
+	brmcast_check_sg_fwding 1 "${X[@]}" 192.0.2.100
+	brmcast_check_sg_fwding 0 "${Y[@]}"
 
 	log_test "IGMPv3 report $TEST_GROUP exclude -> to_exclude"
 
@@ -496,9 +429,9 @@ v3inc_block_test()
 	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_BLOCK" -q
 	# make sure the lowered timers have expired (by default 2 seconds)
 	sleep 3
-	check_sg_entries "block" "${X[@]}"
+	brmcast_check_sg_entries "block" "${X[@]}"
 
-	check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 0 "${X[@]}"
 
 	bridge -j -d -s mdb show dev br0 \
 		| jq -e ".[].mdb[] | \
@@ -507,8 +440,8 @@ v3inc_block_test()
 				.source_list[].address == \"192.0.2.1\")" &>/dev/null
 	check_fail $? "Wrong *,G entry source list, 192.0.2.1 entry still exists"
 
-	check_sg_fwding 1 "${X[@]}"
-	check_sg_fwding 0 "192.0.2.100"
+	brmcast_check_sg_fwding 1 "${X[@]}"
+	brmcast_check_sg_fwding 0 "192.0.2.100"
 
 	log_test "IGMPv3 report $TEST_GROUP include -> block"
 
@@ -528,13 +461,13 @@ v3exc_block_test()
 
 	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_BLOCK" -q
 	sleep 1
-	check_sg_entries "block" "${X[@]}" "${Y[@]}"
+	brmcast_check_sg_entries "block" "${X[@]}" "${Y[@]}"
 
-	check_sg_state 0 "${X[@]}"
-	check_sg_state 1 "${Y[@]}"
+	brmcast_check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 1 "${Y[@]}"
 
-	check_sg_fwding 1 "${X[@]}" 192.0.2.100
-	check_sg_fwding 0 "${Y[@]}"
+	brmcast_check_sg_fwding 1 "${X[@]}" 192.0.2.100
+	brmcast_check_sg_fwding 0 "${Y[@]}"
 
 	log_test "IGMPv3 report $TEST_GROUP exclude -> block"
 
@@ -574,12 +507,12 @@ v3exc_timeout_test()
 				.source_list[].address == \"192.0.2.2\")" &>/dev/null
 	check_fail $? "Wrong *,G entry source list, 192.0.2.2 entry still exists"
 
-	check_sg_entries "allow" "${X[@]}"
+	brmcast_check_sg_entries "allow" "${X[@]}"
 
-	check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 0 "${X[@]}"
 
-	check_sg_fwding 1 "${X[@]}"
-	check_sg_fwding 0 192.0.2.100
+	brmcast_check_sg_fwding 1 "${X[@]}"
+	brmcast_check_sg_fwding 0 192.0.2.100
 
 	log_test "IGMPv3 group $TEST_GROUP exclude timeout"
 
@@ -610,7 +543,7 @@ v3star_ex_auto_add_test()
 				.flags[] == \"added_by_star_ex\")" &>/dev/null
 	check_err $? "Auto-added S,G entry doesn't have added_by_star_ex flag"
 
-	check_sg_fwding 1 192.0.2.3
+	brmcast_check_sg_fwding 1 192.0.2.3
 
 	log_test "IGMPv3 S,G port entry automatic add to a *,G port"
 
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 0a427b8a039d..98ea37d26c44 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1310,3 +1310,70 @@ mcast_packet_test()
 
 	return $seen
 }
+
+brmcast_check_sg_entries()
+{
+	local report=$1; shift
+	local slist=("$@")
+	local sarg=""
+
+	for src in "${slist[@]}"; do
+		sarg="${sarg} and .source_list[].address == \"$src\""
+	done
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and .source_list != null $sarg)" &>/dev/null
+	check_err $? "Wrong *,G entry source list after $report report"
+
+	for sgent in "${slist[@]}"; do
+		bridge -j -d -s mdb show dev br0 \
+			| jq -e ".[].mdb[] | \
+				 select(.grp == \"$TEST_GROUP\" and .src == \"$sgent\")" &>/dev/null
+		check_err $? "Missing S,G entry ($sgent, $TEST_GROUP)"
+	done
+}
+
+brmcast_check_sg_fwding()
+{
+	local should_fwd=$1; shift
+	local sources=("$@")
+
+	for src in "${sources[@]}"; do
+		local retval=0
+
+		mcast_packet_test $TEST_GROUP_MAC $src $TEST_GROUP $h2 $h1
+		retval=$?
+		if [ $should_fwd -eq 1 ]; then
+			check_fail $retval "Didn't forward traffic from S,G ($src, $TEST_GROUP)"
+		else
+			check_err $retval "Forwarded traffic for blocked S,G ($src, $TEST_GROUP)"
+		fi
+	done
+}
+
+brmcast_check_sg_state()
+{
+	local is_blocked=$1; shift
+	local sources=("$@")
+	local should_fail=1
+
+	if [ $is_blocked -eq 1 ]; then
+		should_fail=0
+	fi
+
+	for src in "${sources[@]}"; do
+		bridge -j -d -s mdb show dev br0 \
+			| jq -e ".[].mdb[] | \
+				 select(.grp == \"$TEST_GROUP\" and .source_list != null) |
+				 .source_list[] |
+				 select(.address == \"$src\") |
+				 select(.timer == \"0.00\")" &>/dev/null
+		check_err_fail $should_fail $? "Entry $src has zero timer"
+
+		bridge -j -d -s mdb show dev br0 \
+			| jq -e ".[].mdb[] | \
+				 select(.grp == \"$TEST_GROUP\" and .src == \"$src\" and \
+				 .flags[] == \"blocked\")" &>/dev/null
+		check_err_fail $should_fail $? "Entry $src has blocked flag"
+	done
+}
-- 
2.25.4

