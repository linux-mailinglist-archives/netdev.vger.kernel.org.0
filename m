Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3081D8D85
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 04:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgESCOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 22:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgESCOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 22:14:46 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1A1C05BD09
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 19:14:46 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id cx22so668795pjb.1
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 19:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1UBWqoBQsWkCUkGYHt/Fvb8wbeW8mCCOVHmcOqio4gw=;
        b=d+XyM7y2IaN9hGGFOXA4w8G1ORDjG70Lhsd0kEPV0jopAnQWyMweNCGlPvus0c2mkc
         3XlymAO4+bXGcljnl45kqpECPLEMwqW3b55vtvYaTRUWX7ALgUpNnjYZVYNBsWfZsjls
         U/fajuy9m1OnK5kMej2FlYcT/6n2LH2v9FTFE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1UBWqoBQsWkCUkGYHt/Fvb8wbeW8mCCOVHmcOqio4gw=;
        b=BEmUQrNIMx5Yvx4kb/e67+5knqJ9aIk5eTpRwWSrRolUaq0oA6zRC4/Lz0iV7Gqiln
         TumS437jg5E5hQ66wBZEG4T+sB3+F1fxZLBIs5+RuOrxVwwZrUdV+AOwyQL4KC3aUevw
         mkGBJOciCIxU+Tafohu9hnT/wd1+Jvd6OSw/iML3l3FVP2Qpx8HkM/i9qIgIOQA6FiKR
         t4FobG4aMMofDPbNuEAG/BrDSAt+FS77rTrvaQlBPvYyKOQARWdrUk+zgw9kM9YHoCAw
         nQCsBQNtAYePTcIfZZuFmKiYTT3NvH8kapgeaQc7zSUObMRlJlgtoJm5aXZLHYClm5St
         JbKw==
X-Gm-Message-State: AOAM5320PPKZHZS/4pjO3qwgzQDQctg6IlOoXh/9cg61cFUk9V/JUMb8
        0+ll89xLVNefzELZBvwa+ziAtQ==
X-Google-Smtp-Source: ABdhPJzQd95yDHDEn1cRMw109uKl3mbQIDeOCPpDYtohgsJxopO6UoLu/Zib1Z59TAaqAhhVG8Bn5w==
X-Received: by 2002:a17:90a:8b81:: with SMTP id z1mr2679520pjn.172.1589854486258;
        Mon, 18 May 2020 19:14:46 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id 5sm664753pjf.19.2020.05.18.19.14.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 19:14:45 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next 6/6] selftests: net: add fdb nexthop tests
Date:   Mon, 18 May 2020 19:14:34 -0700
Message-Id: <1589854474-26854-7-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
References: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This commit adds ipv4 and ipv6 fdb api tests to fib_nexthops.sh.

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 140 +++++++++++++++++++++++++++-
 1 file changed, 138 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 50d822f..eb4c270 100755
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
@@ -280,6 +281,141 @@ stop_ip_monitor()
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

