Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871824FBD72
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346607AbiDKNli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346611AbiDKNlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:41:20 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A43610A9
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:39:05 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id q189so3563910ljb.13
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=q+s8pq7+mxXhYAN0HYAAMlwmmRXM/+hxH/iXox3zYsM=;
        b=gdo0pS8M3mZcu6zMtF4X72sjJJqTcx5UQwbKFqReNhLgiXxnh2ISjb2yBJVIMrlQIa
         DSQmq4HxJNFezf/5uWJTQpnjWBRLOoZryE1tpiydETCDQFoDwZTh1Dq4cchaP9qYnbvd
         /GM7Y2vcPZ2pQggoBLHKuImTqcscnNPRjHYTawbAe9ndgi5nnl2oMnZh2nto5LqbJPAN
         46Gq00yyVLTLl1EehcDBJfV0zyQ0I8gIx1Ci9zNw8WMay9Mp25jHUF6ClIzRZodbCQ+G
         NuW19d2pkOyNDN3niO9heQrfNeTX54+tGnrtxEp7bruLXtvEEzaoEVqCTrjabKnpN3eY
         2Kug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=q+s8pq7+mxXhYAN0HYAAMlwmmRXM/+hxH/iXox3zYsM=;
        b=UxmYyROTpvImPHb5L2ZvI+/I/Vy18um7H9/bt9HZmTy490I5/3mZULKSIFCrWRxD5J
         UtEfp5uvwgJhu+hHSSn1iNtC5hjzUMdnDZcz/PmDhJYMENsik3kUlsC28CL5Vipf0sje
         21dj9uzlEi+zfxApPU1DEaW1SWm1+GitiSenR+9PqKgDSSqBblaEsAnz7/Ln0ZALPjy+
         NJrLKZYSpvsaFMKS+ATgCdRxZ2DWs6u997Adse1I4nin2F8Y7QMzqt9MuCvza67wV4Oq
         s2XD/vA2u9Lbj/Q9tdHDgigulAh0UkdLuz5Pq58p9oMEe98EDVgImDzaukb2UkxJwmIi
         84ZA==
X-Gm-Message-State: AOAM533J2LxDcnDb45kKEtitAHvmaJ1vhJP0zlZPxgaVktncutyoDVtl
        riZGY13Li86wlWsKp6dbcrHs75QgrxQolhE5
X-Google-Smtp-Source: ABdhPJxoeeE+BEZplY/9jIvtkpxorjrLWXx31/h0HfvOx/segsFUmb12dz3EoHK1iaXU71IyDMURMQ==
X-Received: by 2002:a05:651c:54f:b0:24b:6b48:cce5 with SMTP id q15-20020a05651c054f00b0024b6b48cce5mr335435ljp.506.1649684343437;
        Mon, 11 Apr 2022 06:39:03 -0700 (PDT)
Received: from wbg.labs.westermo.se (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id p12-20020a056512138c00b0044833f1cd85sm3336847lfa.62.2022.04.11.06.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:39:03 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joachim Wiberg <troglobit@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC net-next 12/13] selftests: forwarding: verify strict filtering doesn't leak
Date:   Mon, 11 Apr 2022 15:38:36 +0200
Message-Id: <20220411133837.318876-13-troglobit@gmail.com>
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

Add a another veth pair to get a dedicated canary port.  This to help us
verify that multicast is received by only a subset of the ports in the
MDB filter.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 .../selftests/net/forwarding/bridge_mdb.sh    | 32 ++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
index 4e3bb950263f..137bc79fd677 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -17,7 +17,7 @@
 #
 
 ALL_TESTS="mdb_add_del_test mdb_compat_fwd_test mdb_mac_fwd_test mdb_ip4_fwd_test mdb_ip6_fwd_test"
-NUM_NETIFS=4
+NUM_NETIFS=6
 
 SRC_PORT="1234"
 DST_PORT="4321"
@@ -70,6 +70,16 @@ h2_destroy()
 	simple_if_fini $h2 192.0.2.2/24 2001:db8:1::2/64
 }
 
+h3_create()
+{
+	simple_if_init $h3 192.0.2.3/24 2001:db8:1::3/64
+}
+
+h3_destroy()
+{
+	simple_if_fini $h3 192.0.2.3/24 2001:db8:1::3/64
+}
+
 switch_create()
 {
 	# Enable multicast filtering w/ querier, reduce query response
@@ -88,10 +98,12 @@ switch_create()
 
 	ip link set dev $swp1 master br0
 	ip link set dev $swp2 master br0
+	ip link set dev $swp3 master br0
 
 	ip link set dev br0 up
 	ip link set dev $swp1 up
 	ip link set dev $swp2 up
+	ip link set dev $swp3 up
 
 	# Initial delay, when bridge floods all mcast, is set to 200
 	# above (2 sec.)  We wait 3 sec to handle the case when a single
@@ -102,6 +114,7 @@ switch_create()
 
 switch_destroy()
 {
+	ip link set dev $swp3 down
 	ip link set dev $swp2 down
 	ip link set dev $swp1 down
 
@@ -116,6 +129,9 @@ setup_prepare()
 	swp2=${NETIFS[p3]}
 	h2=${NETIFS[p4]}
 
+	swp3=${NETIFS[p5]}
+	h3=${NETIFS[p6]}
+
 	# Disable all IPv6 autoconfiguration during test, we want
 	# full control of when MLD queries start etc.
 	sysctl_set net.ipv6.conf.default.accept_ra 0
@@ -123,6 +139,7 @@ setup_prepare()
 
 	h1_create
 	h2_create
+	h3_create
 
 	switch_create
 }
@@ -133,6 +150,7 @@ cleanup()
 
 	switch_destroy
 
+	h3_destroy
 	h2_destroy
 	h1_destroy
 
@@ -249,11 +267,15 @@ do_mdb_fwd()
 	fi
 	if [ "$port" = "$h2" ]; then
 		swp=$swp2
+		nop="$h3"
+	else
+		nop="$h2"
 	fi
 
 	# Disable flooding of unknown multicast, strict MDB forwarding
 	bridge link set dev "$swp1" mcast_flood off
 	bridge link set dev "$swp2" mcast_flood off
+	bridge link set dev "$swp3" mcast_flood off
 	bridge link set dev "br0"   mcast_flood off self
 
 	# Static filter only to this port
@@ -261,6 +283,7 @@ do_mdb_fwd()
 	check_err $? "Failed adding $type multicast group $pass_grp to bridge port $swp"
 
 	tcpdump_start "$port"
+	tcpdump_start "$nop"
 
 	# Real data we're expecting
 	$MZ -q "$h1" "$pass_pkt"
@@ -268,6 +291,7 @@ do_mdb_fwd()
 	$MZ -q "$h1" "$fail_pkt"
 
 	sleep 1
+	tcpdump_stop "$nop"
 	tcpdump_stop "$port"
 
 	tcpdump_show "$port" |grep -q "$src$spt > $pass_grp$dpt"
@@ -276,6 +300,12 @@ do_mdb_fwd()
 	tcpdump_show "$port" |grep -q "$src$spt > $fail_grp$dpt"
 	check_err_fail 1 $? "Received $type multicast group $fail_grp from $h1 to port $port"
 
+	# Verify we don't get multicast to the canary port
+	tcpdump_show "$nop" |grep -q "$src$spt > $pass_grp$dpt"
+	check_err_fail 1 $? "Received $type multicast group $pass_grp from $h1 to port $nop"
+	tcpdump_show "$nop" |grep -q "$src$spt > $fail_grp$dpt"
+	check_err_fail 1 $? "Received $type multicast group $fail_grp from $h1 to port $nop"
+
 	bridge mdb del dev br0 port "$swp" grp "$pass_grp"
 
 	log_test "MDB forward $type multicast to bridge port $port"
-- 
2.25.1

