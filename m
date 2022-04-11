Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728804FBD69
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346612AbiDKNlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346592AbiDKNlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:41:13 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EA922530
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:38:59 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id o16so14261838ljp.3
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=7+9AQPsj4qe+ej9vd9ZSEydjVfvWzHGKKHrVDnEiVdU=;
        b=QCrNRd94foqMNxVskGlMwCCfRXRjQeQ+pp6t1LBGrm9LEuIGq4N4GXTvyNQx4uEUBh
         ++f6ASOqDQLBns5t1I9IMVfxzR6IlWEZIBxk2DBCYDNGcHdL8vyzwCZz4q4YfpIoyC4T
         VZQKvlUgbx+I8b9kNSG2LhpqWaUYBRyHkWKvbeh1lltsD0OniLu8Ay/4e/2S/wAIJH52
         CHAaf8fTEqBgk8G76MuGXEHS/WUiYcZ0SKLtEAqXdZmov79e5faGdOsziIPbICPZ5zfi
         9T71AKcCSUNE8Dcg7JSOKdCjUQV8IStq7GGOVkNQ2z4KX+WjiWa2kQF1PNysKiFnVtvR
         B/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=7+9AQPsj4qe+ej9vd9ZSEydjVfvWzHGKKHrVDnEiVdU=;
        b=Eg7AZj3TDxp0wXXePqkU/IWfrw7+pNWUd1DTf3BmFUsq3MrJnhF7dY1CpdupoyAsIN
         5Shmt27vU+52e7msO+fUHKIeIrq+Qu6QiyH/lZvT67rIJfHxXh+s7cxEymLuuWtiFwdQ
         QnnPSWL47JKirn7MCSl2wmjSLEHB5N0X2AAznxLXsn3JeQLf4Lj6A4zr8orvCMTUkWl4
         XSdilFlCFtQb49bJhblMrZ62C6c5q8NTTeLu8GltLOHscC6KvfgQiJZb1AzL0sofhPig
         0bxqqn8aEnRcNRalJI/RCv+HVD/M8Dg3PX1AXVTU43Arg6lFwsene4I4kJkxyOSBONGu
         bqpQ==
X-Gm-Message-State: AOAM530T5mncpS4oTt7gUujqpbZRhr6Ov80H7DruW0qenH0JUcRzBn5K
        xNDnfgPAHnIsgXP0qKzZomY=
X-Google-Smtp-Source: ABdhPJxvN7ailgrYMIamCFTGsgBi/osE36m/CuR7LqQ7S1vJdTd54IN4IAHq3rUPQql+D5A36XfYYw==
X-Received: by 2002:a05:651c:555:b0:24b:15b7:74ad with SMTP id q21-20020a05651c055500b0024b15b774admr20055797ljp.239.1649684337910;
        Mon, 11 Apr 2022 06:38:57 -0700 (PDT)
Received: from wbg.labs.westermo.se (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id p12-20020a056512138c00b0044833f1cd85sm3336847lfa.62.2022.04.11.06.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:38:57 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joachim Wiberg <troglobit@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC net-next 06/13] selftests: forwarding: multiple instances in tcpdump helper
Date:   Mon, 11 Apr 2022 15:38:30 +0200
Message-Id: <20220411133837.318876-7-troglobit@gmail.com>
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

Extend tcpdump_start() & C:o to handle multiple instances.  Useful when
observing bridge operation, e.g., unicast learning/flooding, and any
case of multicast distribution (to these ports but not that one ...).

This means the interface argument is now a mandatory argument to all
tcpdump_*() functions, hence the changes to the ocelot flower test.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 .../drivers/net/ocelot/tc_flower_chains.sh    | 24 +++++++++---------
 tools/testing/selftests/net/forwarding/lib.sh | 25 +++++++++++++------
 2 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index eaf8a04a7ca5..7e684e27a682 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -215,15 +215,15 @@ test_vlan_pop()
 
 	sleep 1
 
-	tcpdump_stop
+	tcpdump_stop $eth2
 
-	if tcpdump_show | grep -q "$eth3_mac > $eth2_mac, ethertype IPv4"; then
+	if tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, ethertype IPv4"; then
 		echo "OK"
 	else
 		echo "FAIL"
 	fi
 
-	tcpdump_cleanup
+	tcpdump_cleanup $eth2
 }
 
 test_vlan_push()
@@ -236,15 +236,15 @@ test_vlan_push()
 
 	sleep 1
 
-	tcpdump_stop
+	tcpdump_stop $eth3.100
 
-	if tcpdump_show | grep -q "$eth2_mac > $eth3_mac"; then
+	if tcpdump_show $eth3.100 | grep -q "$eth2_mac > $eth3_mac"; then
 		echo "OK"
 	else
 		echo "FAIL"
 	fi
 
-	tcpdump_cleanup
+	tcpdump_cleanup $eth3.100
 }
 
 test_vlan_ingress_modify()
@@ -267,15 +267,15 @@ test_vlan_ingress_modify()
 
 	sleep 1
 
-	tcpdump_stop
+	tcpdump_stop $eth2
 
-	if tcpdump_show | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"; then
+	if tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"; then
 		echo "OK"
 	else
 		echo "FAIL"
 	fi
 
-	tcpdump_cleanup
+	tcpdump_cleanup $eth2
 
 	tc filter del dev $eth0 ingress chain $(IS1 2) pref 3
 
@@ -305,15 +305,15 @@ test_vlan_egress_modify()
 
 	sleep 1
 
-	tcpdump_stop
+	tcpdump_stop $eth2
 
-	if tcpdump_show | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"; then
+	if tcpdump_show $eth2 | grep -q "$eth3_mac > $eth2_mac, .* vlan 300"; then
 		echo "OK"
 	else
 		echo "FAIL"
 	fi
 
-	tcpdump_cleanup
+	tcpdump_cleanup $eth2
 
 	tc filter del dev $eth1 egress chain $(ES0) pref 3
 	tc qdisc del dev $eth1 clsact
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 00cdcab7accf..20a6d6b2f389 100755
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1349,13 +1349,17 @@ stop_traffic()
 	{ kill %% && wait %%; } 2>/dev/null
 }
 
+declare -A cappid
+declare -A capfile
+declare -A capout
+
 tcpdump_start()
 {
 	local if_name=$1; shift
 	local ns=$1; shift
 
-	capfile=$(mktemp)
-	capout=$(mktemp)
+	capfile[$if_name]=$(mktemp)
+	capout[$if_name]=$(mktemp)
 
 	if [ -z $ns ]; then
 		ns_cmd=""
@@ -1376,26 +1380,33 @@ tcpdump_start()
 	fi
 
 	$ns_cmd tcpdump $extra_flags -e -n -Q in -i $if_name \
-		-s 65535 -B 32768 $capuser -w $capfile > "$capout" 2>&1 &
-	cappid=$!
+		-s 65535 -B 32768 $capuser -w ${capfile[$if_name]} > "${capout[$if_name]}" 2>&1 &
+	cappid[$if_name]=$!
 
 	sleep 1
 }
 
 tcpdump_stop()
 {
-	$ns_cmd kill $cappid
+	local if_name=$1
+	local pid=${cappid[$if_name]}
+
+	$ns_cmd kill "$pid" && wait "$pid"
 	sleep 1
 }
 
 tcpdump_cleanup()
 {
-	rm $capfile $capout
+	local if_name=$1
+
+	rm ${capfile[$if_name]} ${capout[$if_name]}
 }
 
 tcpdump_show()
 {
-	tcpdump -e -n -r $capfile 2>&1
+	local if_name=$1
+
+	tcpdump -e -n -r ${capfile[$if_name]} 2>&1
 }
 
 # return 0 if the packet wasn't seen on host2_if or 1 if it was
-- 
2.25.1

