Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57311DA949
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 06:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgETEdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 00:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbgETEdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 00:33:47 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A94DC061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 21:33:47 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id b190so960115pfg.6
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 21:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CL53QmAMffJz24+NJGL8ymmwvvxOU2Skqv3Ocebapyw=;
        b=FqcOnZw8Jd8iCwifeN21e1eEEBvwbor2yWhJb6bwLhM/hvrntrTqVEl28dBf465EE5
         ZaGFGJ6BJbzQ9sMIuQtHwXbxn0zhNs++5Sdsflwa6CaJGoI2tdkvoTSWiYjiEZiSZ5oH
         wkOggsm/mg4aWWXNzSw511rxJ4WVhknhB5zqI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CL53QmAMffJz24+NJGL8ymmwvvxOU2Skqv3Ocebapyw=;
        b=TKbpu25vFYXeki/l6AiiPVUAfvW8jWGmTCTf3hPymqyB94FrgoxobFvvnOmACgZ476
         QreUaj4XClbgBXKp5Ck4wHf8p9Wt8LZHIGkwMJUjWunN/4xWMTSdEA6BZeOZZ0aEkLIJ
         5PuLLtPecAxNs6+wX7FoLUrNJRKODOiEqqCe6hB8V82lCT1fo7PK0L2gtT4DRnOw97Rc
         +496bSBUEP/J+1mBfqgiuh0GJrPJrWoFZ9B8uRGWZhc5vXl/FYpZnWfg9VbeQkn1bScE
         SFaukObeTQpcWzO5+GO0iGodY5WztjXgOFdTHVBtHNXskOqxfVRL3M9S92l9UIhOTp0f
         pYBg==
X-Gm-Message-State: AOAM531YwQBErJ8LyUPPMtkcwHRPtKYBdmOCG+X1bf+PmTQN5GP7C6lK
        XIywdU2GFH0CPK9tbkEG9GZfuw==
X-Google-Smtp-Source: ABdhPJyF8tQX7CBQanqU+/T5DkgxnIz+KAbeGfAChBhWGA+mV8nQDbn/o9BgLcckW0HS9wDm48t02g==
X-Received: by 2002:aa7:8ad6:: with SMTP id b22mr2331230pfd.251.1589949226615;
        Tue, 19 May 2020 21:33:46 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id g17sm753250pgg.43.2020.05.19.21.33.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 May 2020 21:33:46 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next v2 5/5] selftests: net: add fdb nexthop tests
Date:   Tue, 19 May 2020 21:33:34 -0700
Message-Id: <1589949214-14711-6-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1589949214-14711-1-git-send-email-roopa@cumulusnetworks.com>
References: <1589949214-14711-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This commit adds ipv4 and ipv6 fdb api tests to fib_nexthops.sh.

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 160 +++++++++++++++++++++++++++-
 1 file changed, 158 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 50d822f..62a040a 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -19,8 +19,8 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_compat_mode"
-IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_compat_mode"
+IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_compat_mode ipv4_fdb_grp_fcnal"
+IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_compat_mode ipv6_fdb_grp_fcnal"
 
 ALL_TESTS="basic ${IPV4_TESTS} ${IPV6_TESTS}"
 TESTS="${ALL_TESTS}"
@@ -146,6 +146,7 @@ setup()
 	create_ns remote
 
 	IP="ip -netns me"
+	BRIDGE="bridge -netns me"
 	set -e
 	$IP li add veth1 type veth peer name veth2
 	$IP li set veth1 up
@@ -280,6 +281,161 @@ stop_ip_monitor()
 	return $rc
 }
 
+check_nexthop_fdb_support()
+{
+	$IP nexthop help 2>&1 | grep -q fdb
+	if [ $? -ne 0 ]; then
+		echo "SKIP: iproute2 too old, missing fdb nexthop support"
+		return $ksft_skip
+	fi
+}
+
+ipv6_fdb_grp_fcnal()
+{
+	local rc
+
+	echo
+	echo "IPv6 fdb groups functional"
+	echo "--------------------------"
+
+	check_nexthop_fdb_support
+	if [ $? -eq $ksft_skip ]; then
+		return $ksft_skip
+	fi
+
+	# create group with multiple nexthops
+	run_cmd "$IP nexthop add id 61 via 2001:db8:91::2 fdb"
+	run_cmd "$IP nexthop add id 62 via 2001:db8:91::3 fdb"
+	run_cmd "$IP nexthop add id 102 group 61/62 fdb"
+	check_nexthop "id 102" "id 102 group 61/62 fdb"
+	log_test $? 0 "Fdb Nexthop group with multiple nexthops"
+
+	## get nexthop group
+	run_cmd "$IP nexthop get id 102"
+	check_nexthop "id 102" "id 102 group 61/62 fdb"
+	log_test $? 0 "Get Fdb nexthop group by id"
+
+	# fdb nexthop group can only contain fdb nexthops
+	run_cmd "$IP nexthop add id 63 via 2001:db8:91::4"
+	run_cmd "$IP nexthop add id 64 via 2001:db8:91::5"
+	run_cmd "$IP nexthop add id 103 group 63/64 fdb"
+	log_test $? 2 "Fdb Nexthop group with non-fdb nexthops"
+
+	# Non fdb nexthop group can not contain fdb nexthops
+	run_cmd "$IP nexthop add id 65 via 2001:db8:91::5 fdb"
+	run_cmd "$IP nexthop add id 66 via 2001:db8:91::6 fdb"
+	run_cmd "$IP nexthop add id 104 group 65/66"
+	log_test $? 2 "Non-Fdb Nexthop group with non nexthops"
+
+	# fdb nexthop cannot have blackhole
+	run_cmd "$IP nexthop add id 67 blackhole fdb"
+	log_test $? 2 "Fdb Nexthop with blackhole"
+
+	# fdb nexthop with oif
+	run_cmd "$IP nexthop add id 68 via 2001:db8:91::7 dev veth1 fdb"
+	log_test $? 2 "Fdb Nexthop with oif"
+
+	# fdb nexthop with onlink
+	run_cmd "$IP nexthop add id 68 via 2001:db8:91::7 onlink fdb"
+	log_test $? 2 "Fdb Nexthop with onlink"
+
+	# fdb nexthop with encap
+	run_cmd "$IP nexthop add id 69 encap mpls 101 via 2001:db8:91::8 dev veth1 fdb"
+	log_test $? 2 "Fdb Nexthop with encap"
+
+	run_cmd "$IP link add name vx10 type vxlan id 1010 local 2001:db8:91::9 remote 2001:db8:91::10 dstport 4789 nolearning noudpcsum tos inherit ttl 100"
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:13 dev vx10 nhid 102 self"
+	log_test $? 0 "Fdb mac add with nexthop group"
+
+	## fdb nexthops can only reference nexthop groups and not nexthops
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:14 dev vx10 nhid 61 self"
+	log_test $? 255 "Fdb mac add with nexthop"
+
+	run_cmd "$IP -6 ro add 2001:db8:101::1/128 nhid 66"
+	log_test $? 2 "Route add with fdb nexthop"
+
+	run_cmd "$IP -6 ro add 2001:db8:101::1/128 nhid 103"
+	log_test $? 2 "Route add with fdb nexthop group"
+
+	run_cmd "$IP nexthop del id 102"
+	log_test $? 0 "Fdb nexthop delete"
+
+	$IP link del dev vx10
+}
+
+ipv4_fdb_grp_fcnal()
+{
+	local rc
+
+	echo
+	echo "IPv4 fdb groups functional"
+	echo "--------------------------"
+
+	check_nexthop_fdb_support
+	if [ $? -eq $ksft_skip ]; then
+		return $ksft_skip
+	fi
+
+	# create group with multiple nexthops
+	run_cmd "$IP nexthop add id 12 via 172.16.1.2 fdb"
+	run_cmd "$IP nexthop add id 13 via 172.16.1.3 fdb"
+	run_cmd "$IP nexthop add id 102 group 12/13 fdb"
+	check_nexthop "id 102" "id 102 group 12/13 fdb"
+	log_test $? 0 "Fdb Nexthop group with multiple nexthops"
+
+	# get nexthop group
+	run_cmd "$IP nexthop get id 102"
+	check_nexthop "id 102" "id 102 group 12/13 fdb"
+	log_test $? 0 "Get Fdb nexthop group by id"
+
+	# fdb nexthop group can only contain fdb nexthops
+	run_cmd "$IP nexthop add id 14 via 172.16.1.2"
+	run_cmd "$IP nexthop add id 15 via 172.16.1.3"
+	run_cmd "$IP nexthop add id 103 group 14/15 fdb"
+	log_test $? 2 "Fdb Nexthop group with non-fdb nexthops"
+
+	# Non fdb nexthop group can not contain fdb nexthops
+	run_cmd "$IP nexthop add id 16 via 172.16.1.2 fdb"
+	run_cmd "$IP nexthop add id 17 via 172.16.1.3 fdb"
+	run_cmd "$IP nexthop add id 104 group 14/15"
+	log_test $? 2 "Non-Fdb Nexthop group with non nexthops"
+
+	# fdb nexthop cannot have blackhole
+	run_cmd "$IP nexthop add id 18 blackhole fdb"
+	log_test $? 2 "Fdb Nexthop with blackhole"
+
+	# fdb nexthop with oif
+	run_cmd "$IP nexthop add id 16 via 172.16.1.2 dev veth1 fdb"
+	log_test $? 2 "Fdb Nexthop with oif"
+
+	# fdb nexthop with onlink
+	run_cmd "$IP nexthop add id 16 via 172.16.1.2 onlink fdb"
+	log_test $? 2 "Fdb Nexthop with onlink"
+
+	# fdb nexthop with encap
+	run_cmd "$IP nexthop add id 17 encap mpls 101 via 172.16.1.2 dev veth1 fdb"
+	log_test $? 2 "Fdb Nexthop with encap"
+
+	run_cmd "$IP link add name vx10 type vxlan id 1010 local 10.0.0.1 remote 10.0.0.2 dstport 4789 nolearning noudpcsum tos inherit ttl 100"
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:13 dev vx10 nhid 102 self"
+	log_test $? 0 "Fdb mac add with nexthop group"
+
+	# fdb nexthops can only reference nexthop groups and not nexthops
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:14 dev vx10 nhid 12 self"
+	log_test $? 255 "Fdb mac add with nexthop"
+
+	run_cmd "$IP ro add 172.16.0.0/22 nhid 15"
+	log_test $? 2 "Route add with fdb nexthop"
+
+	run_cmd "$IP ro add 172.16.0.0/22 nhid 103"
+	log_test $? 2 "Route add with fdb nexthop group"
+
+	run_cmd "$IP nexthop del id 102"
+	log_test $? 0 "Fdb nexthop delete"
+
+	$IP link del dev vx10
+}
+
 ################################################################################
 # basic operations (add, delete, replace) on nexthops and nexthop groups
 #
-- 
2.1.4

