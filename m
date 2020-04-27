Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7221BAFD4
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgD0U47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726688AbgD0U45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:56:57 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C133EC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:56:57 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t4so7424843plq.12
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VTo0mbDiyFAFo1iFl6vXKIDRGFSnI/Bd16dM1Y0Hnro=;
        b=eYeewDPHbMSaqX6+tK1cG+zomhic4JJ3lpOkUunPYCNhYnQ3s5AA97igPZ2H/JOBG7
         XDj3/yHwi1KYAu1Mmk1KtnEOnxt/tcxU8nXH20yjrRapYeJZA3WV3oH1GdNQFK9oYoEN
         TG1yyCQSy6T8KM7CogmK4s7DCrHrbsX7zBe9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VTo0mbDiyFAFo1iFl6vXKIDRGFSnI/Bd16dM1Y0Hnro=;
        b=KSoBBLeVja8MKx8Vj2ayZyz1gEftWfTN+oYWYW9pMPlgBokvtZbgsCsLLTHWeaZXUy
         U7BjfOutITQnQuIgkDsKvtPNFcLh1cMzc6DwNyoQ34R9QdScxAeHTOIpQYtBuTG6pPD5
         s2UA+sYXONAuGtNdoyKCf65lzTnDf85TcJRHcvFTUUobCipmxcKpV+U6EfL3vVIJR9fJ
         eL/1XM3D592YFCMpz9A+VJ2jyYiV1EQaSv+3/FQltOKJp++ous+HKambLeAfvG45UL6H
         BJGnwFXsCalptFq3kdreog0GzDpO6lv+f63CXj+Mx7v91a/ortkAOPtfyCbNhyHf/rAB
         aC3w==
X-Gm-Message-State: AGi0PuYvRnM2opJ73n2NeM/aZ7BWVles29XjYAalMPsuY+R7kj3w7c8w
        pmk+jfA5t/0/a9hA+DDPt+YSLeJSmVwtzA==
X-Google-Smtp-Source: APiQypLT1n4kLRsLwVeHqu4zXFMlCFz6V4xVX+8iHo7+jHwb9kScjF+/4AbZrIFKIoJj0dRDWBhAIg==
X-Received: by 2002:a17:90a:648d:: with SMTP id h13mr745141pjj.12.1588021017245;
        Mon, 27 Apr 2020 13:56:57 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id fh18sm443830pjb.0.2020.04.27.13.56.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 13:56:56 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, rdunlap@infradead.org,
        nikolay@cumulusnetworks.com, bpoirier@cumulusnetworks.com
Subject: [PATCH net-next v4 3/3] selftests: net: add new testcases for nexthop API compat mode sysctl
Date:   Mon, 27 Apr 2020 13:56:47 -0700
Message-Id: <1588021007-16914-4-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1588021007-16914-1-git-send-email-roopa@cumulusnetworks.com>
References: <1588021007-16914-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

New tests to check route dump and notifications with
net.ipv4.nexthop_compat_mode on and off.

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 198 +++++++++++++++++++++++++++-
 1 file changed, 196 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 796670e..5762d98 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -19,8 +19,8 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime"
-IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime"
+IPV4_TESTS="ipv4_fcnal ipv4_grp_fcnal ipv4_withv6_fcnal ipv4_fcnal_runtime ipv4_compat_mode"
+IPV6_TESTS="ipv6_fcnal ipv6_grp_fcnal ipv6_fcnal_runtime ipv6_compat_mode"
 
 ALL_TESTS="basic ${IPV4_TESTS} ${IPV6_TESTS}"
 TESTS="${ALL_TESTS}"
@@ -253,6 +253,33 @@ check_route6()
 	check_output "${out}" "${expected}"
 }
 
+start_ip_monitor()
+{
+	local mtype=$1
+
+	# start the monitor in the background
+	tmpfile=`mktemp /var/run/nexthoptestXXX`
+	mpid=`($IP monitor $mtype > $tmpfile & echo $!) 2>/dev/null`
+	sleep 0.2
+	echo "$mpid $tmpfile"
+}
+
+stop_ip_monitor()
+{
+	local mpid=$1
+	local tmpfile=$2
+	local el=$3
+
+	# check the monitor results
+	kill $mpid
+	lines=`wc -l $tmpfile | cut "-d " -f1`
+	test $lines -eq $el
+	rc=$?
+	rm -rf $tmpfile
+
+	return $rc
+}
+
 ################################################################################
 # basic operations (add, delete, replace) on nexthops and nexthop groups
 #
@@ -857,6 +884,173 @@ ipv4_fcnal_runtime()
 	log_test $? 0 "IPv4 route with MPLS encap, v6 gw - check"
 }
 
+sysctl_nexthop_compat_mode_check()
+{
+	local sysctlname="net.ipv4.nexthop_compat_mode"
+	local lprefix=$1
+
+	IPE="ip netns exec me"
+
+	$IPE sysctl -q $sysctlname 2>&1 >/dev/null
+	if [ $? -ne 0 ]; then
+		echo "SKIP: kernel lacks nexthop compat mode sysctl control"
+		return $ksft_skip
+	fi
+
+	out=$($IPE sysctl $sysctlname 2>/dev/null)
+	log_test $? 0 "$lprefix default nexthop compat mode check"
+	check_output "${out}" "$sysctlname = 1"
+}
+
+sysctl_nexthop_compat_mode_set()
+{
+	local sysctlname="net.ipv4.nexthop_compat_mode"
+	local mode=$1
+	local lprefix=$2
+
+	IPE="ip netns exec me"
+
+	out=$($IPE sysctl -w $sysctlname=$mode)
+	log_test $? 0 "$lprefix set compat mode - $mode"
+	check_output "${out}" "net.ipv4.nexthop_compat_mode = $mode"
+}
+
+ipv6_compat_mode()
+{
+	local rc
+
+	echo
+	echo "IPv6 nexthop api compat mode test"
+	echo "--------------------------------"
+
+	sysctl_nexthop_compat_mode_check "IPv6"
+	if [ $? -eq $ksft_skip ]; then
+		return $ksft_skip
+	fi
+
+	run_cmd "$IP nexthop add id 62 via 2001:db8:91::2 dev veth1"
+	run_cmd "$IP nexthop add id 63 via 2001:db8:91::3 dev veth1"
+	run_cmd "$IP nexthop add id 122 group 62/63"
+	ipmout=$(start_ip_monitor route)
+
+	run_cmd "$IP -6 ro add 2001:db8:101::1/128 nhid 122"
+	# route add notification should contain expanded nexthops
+	stop_ip_monitor $ipmout 3
+	log_test $? 0 "IPv6 compat mode on - route add notification"
+
+	# route dump should contain expanded nexthops
+	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 122 metric 1024 pref medium nexthop via 2001:db8:91::2 dev veth1 weight 1 nexthop via 2001:db8:91::3 dev veth1 weight 1"
+	log_test $? 0 "IPv6 compat mode on - route dump"
+
+	# change in nexthop group should generate route notification
+	run_cmd "$IP nexthop add id 64 via 2001:db8:91::4 dev veth1"
+	ipmout=$(start_ip_monitor route)
+	run_cmd "$IP nexthop replace id 122 group 62/64"
+	stop_ip_monitor $ipmout 3
+
+	log_test $? 0 "IPv6 compat mode on - nexthop change"
+
+	# set compat mode off
+	sysctl_nexthop_compat_mode_set 0 "IPv6"
+
+	run_cmd "$IP -6 ro del 2001:db8:101::1/128 nhid 122"
+
+	run_cmd "$IP nexthop add id 62 via 2001:db8:91::2 dev veth1"
+	run_cmd "$IP nexthop add id 63 via 2001:db8:91::3 dev veth1"
+	run_cmd "$IP nexthop add id 122 group 62/63"
+	ipmout=$(start_ip_monitor route)
+
+	run_cmd "$IP -6 ro add 2001:db8:101::1/128 nhid 122"
+	# route add notification should not contain expanded nexthops
+	stop_ip_monitor $ipmout 1
+	log_test $? 0 "IPv6 compat mode off - route add notification"
+
+	# route dump should not contain expanded nexthops
+	check_route6 "2001:db8:101::1" "2001:db8:101::1 nhid 122 metric 1024 pref medium"
+	log_test $? 0 "IPv6 compat mode off - route dump"
+
+	# change in nexthop group should not generate route notification
+	run_cmd "$IP nexthop add id 64 via 2001:db8:91::4 dev veth1"
+	ipmout=$(start_ip_monitor route)
+	run_cmd "$IP nexthop replace id 122 group 62/64"
+	stop_ip_monitor $ipmout 0
+	log_test $? 0 "IPv6 compat mode off - nexthop change"
+
+	# nexthop delete should not generate route notification
+	ipmout=$(start_ip_monitor route)
+	run_cmd "$IP nexthop del id 122"
+	stop_ip_monitor $ipmout 0
+	log_test $? 0 "IPv6 compat mode off - nexthop delete"
+
+	# set compat mode back on
+	sysctl_nexthop_compat_mode_set 1 "IPv6"
+}
+
+ipv4_compat_mode()
+{
+	local rc
+
+	echo
+	echo "IPv4 nexthop api compat mode"
+	echo "----------------------------"
+
+	sysctl_nexthop_compat_mode_check "IPv4"
+	if [ $? -eq $ksft_skip ]; then
+		return $ksft_skip
+	fi
+
+	run_cmd "$IP nexthop add id 21 via 172.16.1.2 dev veth1"
+	run_cmd "$IP nexthop add id 22 via 172.16.1.2 dev veth1"
+	run_cmd "$IP nexthop add id 122 group 21/22"
+	ipmout=$(start_ip_monitor route)
+
+	run_cmd "$IP ro add 172.16.101.1/32 nhid 122"
+	stop_ip_monitor $ipmout 3
+
+	# route add notification should contain expanded nexthops
+	log_test $? 0 "IPv4 compat mode on - route add notification"
+
+	# route dump should contain expanded nexthops
+	check_route "172.16.101.1" "172.16.101.1 nhid 122 nexthop via 172.16.1.2 dev veth1 weight 1 nexthop via 172.16.1.2 dev veth1 weight 1"
+	log_test $? 0 "IPv4 compat mode on - route dump"
+
+	# change in nexthop group should generate route notification
+	run_cmd "$IP nexthop add id 23 via 172.16.1.3 dev veth1"
+	ipmout=$(start_ip_monitor route)
+	run_cmd "$IP nexthop replace id 122 group 21/23"
+	stop_ip_monitor $ipmout 3
+	log_test $? 0 "IPv4 compat mode on - nexthop change"
+
+	sysctl_nexthop_compat_mode_set 0 "IPv4"
+
+	# cleanup
+	run_cmd "$IP ro del 172.16.101.1/32 nhid 122"
+
+	ipmout=$(start_ip_monitor route)
+	run_cmd "$IP ro add 172.16.101.1/32 nhid 122"
+	stop_ip_monitor $ipmout 1
+	# route add notification should not contain expanded nexthops
+	log_test $? 0 "IPv4 compat mode off - route add notification"
+
+	# route dump should not contain expanded nexthops
+	check_route "172.16.101.1" "172.16.101.1 nhid 122"
+	log_test $? 0 "IPv4 compat mode off - route dump"
+
+	# change in nexthop group should not generate route notification
+	ipmout=$(start_ip_monitor route)
+	run_cmd "$IP nexthop replace id 122 group 21/22"
+	stop_ip_monitor $ipmout 0
+	log_test $? 0 "IPv4 compat mode off - nexthop change"
+
+	# nexthop delete should not generate route notification
+	ipmout=$(start_ip_monitor route)
+	run_cmd "$IP nexthop del id 122"
+	stop_ip_monitor $ipmout 0
+	log_test $? 0 "IPv4 compat mode off - nexthop delete"
+
+	sysctl_nexthop_compat_mode_set 1 "IPv4"
+}
+
 basic()
 {
 	echo
-- 
2.1.4

