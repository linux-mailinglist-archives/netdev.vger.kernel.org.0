Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66CD4FBD67
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346618AbiDKNlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346626AbiDKNlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:41:21 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4548F42
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:39:06 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z17so2183547lfj.11
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=50MJkKhlS1J2AvfKZSt0Jb7+m5hEUpZE6Hebck0fg/A=;
        b=JXCw9oiD2WnF+/dOWbCKR30QwHOFYeeIGFnoSQa3rk8zCXJGF9WjRf21JEaJS7JlFW
         oJYl9mRBvdtaftLg5HYDs6a1KOlfipXmEgYHv64nyqOgOdKBy5dw93enKmSLyOTC8vDJ
         W/UW3b6tEh2yZBB1eEDy309N1pFBTEJEpmWVM2F45VroybbBgx/7sQzUz5QgrIDKfitW
         cMnHAf+Q4TDrbb1nkoIJQXMsvEtII4Ikv0y/qk+3qrMBfUp2W8kEQjfFaQdohb1DjTE1
         sqAvuH9qb9id5HA7h3y0VaR/F/YMRqh2KrrJV6qs859EreZyHh+T2yEXN41++YTzd4wl
         zeKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=50MJkKhlS1J2AvfKZSt0Jb7+m5hEUpZE6Hebck0fg/A=;
        b=JQ5q88RYGj1gVixPegxJ22O7wCCUnv/bF7IrJgbBlKhSj2S61yTtNLvIiyX2Ouym3B
         JXmq3Q/WeKX9VXLWi3alKZQmP+BgOHQov9kSTmRjZ1ozQfqguG00IVRQVisvFFxv9NQY
         74Xw65zlqmOSc7VY+KHQ9GiA6pjHNmxOh4Nc3dEbgqO0rzrs8//+29KnaBn5QKrTp+4a
         cLiM+HQoORjVPfzcZkkj7hjhgpYYKMj6LLGlfGynMWFm8/Xe/GQWANNvotCWRgPC8/O1
         /4RNVxLao9YTNVUJbL/HK5NoeZhoN8Z607vM8/0lTti30e+QzK3DeZ0aCFrI7WiFx0kN
         xerQ==
X-Gm-Message-State: AOAM531y2HTUnx+EN6SwClMyvWlMXuewYV/pGcs8Jg03e7THw2bAEbz1
        ECfXhU7/SnSEe+zVYX01PJM=
X-Google-Smtp-Source: ABdhPJygk8gDfsKgwEqOQRFbO6IgRWDrD1xWTXDdJhj6rrgjNMQxB602CKesPbTFsnNmR3wr9M9wzQ==
X-Received: by 2002:ac2:5119:0:b0:450:d4e7:99ca with SMTP id q25-20020ac25119000000b00450d4e799camr21456161lfb.95.1649684344648;
        Mon, 11 Apr 2022 06:39:04 -0700 (PDT)
Received: from wbg.labs.westermo.se (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id p12-20020a056512138c00b0044833f1cd85sm3336847lfa.62.2022.04.11.06.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:39:04 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joachim Wiberg <troglobit@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC net-next 13/13] selftests: forwarding: verify flood of known mc on mcast_router port
Date:   Mon, 11 Apr 2022 15:38:37 +0200
Message-Id: <20220411133837.318876-14-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411133837.318876-1-troglobit@gmail.com>
References: <20220411133837.318876-1-troglobit@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test verifies that both known (in mdb) and unknown IP multicast is
forwarded to a mcast_router port.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 .../selftests/net/forwarding/bridge_mdb.sh    | 54 ++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
index 137bc79fd677..3fd7d68bca09 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -10,13 +10,16 @@
 # Verify selective multicast forwarding (strict mdb), when bridge port
 # mcast_flood is disabled, of known MAC, IPv4, IPv6 traffic.
 #
+# Verify flooding towards mcast_router ports of known IP multicast.
+#
 # Note: this test completely disables IPv6 auto-configuration to avoid
 #       any type of dynamic behavior outside of MLD and IGMP protocols.
 #       Static IPv6 addresses are used to ensure consistent behavior,
 #       even in the startup phase when multicast snooping is enabled.
 #
 
-ALL_TESTS="mdb_add_del_test mdb_compat_fwd_test mdb_mac_fwd_test mdb_ip4_fwd_test mdb_ip6_fwd_test"
+ALL_TESTS="mdb_add_del_test mdb_compat_fwd_test mdb_rport_fwd_test \
+	   mdb_mac_fwd_test mdb_ip4_fwd_test mdb_ip6_fwd_test"
 NUM_NETIFS=6
 
 SRC_PORT="1234"
@@ -246,6 +249,55 @@ mdb_compat_fwd_test()
 	do_compat_fwd "br0"
 }
 
+#
+# Verify fwd of IP multicast to router ports.  A detected multicast
+# router should always receive both known and unknown multicast.
+#
+mdb_rport_fwd_test()
+{
+	pass_grp=$PASS_GRP_IP4
+	fail_grp=$FAIL_GRP_IP4
+	pass_pkt=$PASS_PKT_IP4
+	fail_pkt=$FAIL_PKT_IP4
+	decoy="br0"
+	port=$h1
+	type="IPv4"
+
+	# Disable flooding of unknown multicast, strict MDB forwarding
+	bridge link set dev "$swp1" mcast_flood off
+	bridge link set dev "$swp2" mcast_flood off
+	bridge link set dev "br0"   mcast_flood off self
+
+	# Let h2 act as a multicast router
+	ip link set dev "$swp1" type bridge_slave mcast_router 2
+
+	# Static filter only to this decoy port
+	bridge mdb add dev br0 port $decoy grp "$pass_grp"
+	check_err $? "Failed adding multicast group $pass_grp to bridge port $decoy"
+
+	tcpdump_start "$port"
+
+	# Real data we're expecting
+	$MZ -q "$h2" "$pass_pkt"
+	# This should not pass
+	$MZ -q "$h2" "$fail_pkt"
+
+	sleep 1
+	tcpdump_stop "$port"
+
+	tcpdump_show "$port" |grep -q "$src$spt > $pass_grp$dpt"
+	check_err $? "Failed forwarding $type multicast $pass_grp from $h2 to port $port"
+
+	tcpdump_show "$port" |grep -q "$src$spt > $fail_grp$dpt"
+	check_err $? "Failed forwarding $type multicast $fail_grp from $h2 to port $port"
+
+	bridge mdb del dev br0 port br0 grp "$pass_grp"
+	ip link set dev "$swp1" type bridge_slave mcast_router 1
+
+	log_test "MDB forward all $type multicast to multicast router on $port"
+	tcpdump_cleanup "$port"
+}
+
 do_mdb_fwd()
 {
 	type=$1
-- 
2.25.1

