Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165331B8A67
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 02:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgDZAs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 20:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726088AbgDZAs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 20:48:58 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCC4C061A0C
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 17:48:58 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o185so6737657pgo.3
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 17:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v4JvgC0mifYszhEPcVIRnhoWtkQlu0pTcGfZrAxa8I8=;
        b=XdnhQLEGLelnuLd0COr8b9NF7W0515wqUmbIc/lHT5pt4cAUTC2D+pTsmmO3zYL4b5
         rkgNDlJtPDmmyikSdAlW4kERdRW+B1Xd8VqY96OFuhiuHFSZcMNVhwJzvewr6xVdL92l
         Lm+UbpBrihPYiPcifI9hDYxDd1e6LpRtx+fjA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=v4JvgC0mifYszhEPcVIRnhoWtkQlu0pTcGfZrAxa8I8=;
        b=njhC6sb3qySJ1+VFn93bmY4V5xnrmTXJ6IFmCogCuxUL2WYCkp2PpE8PdUmY0hEjld
         y8dRFaW52wiC07CwO5XwvH6kTebyC9362bPB3ioXp7rLLAXKlcSQ0I+jsuNUtMbnDyZK
         0VFsy6rtLUnp0y079/rDjN9pKOOLrQOFQYIfcDRpV9Zvc7HXcSvnBjKMupoUcxlfY2va
         A+lFmVh7Wb4+FpbENp4INSOpw0vanT43t264ql4kUqorTwS/qQGqvpC6EaYFxcYaG1bV
         GK5Jw7M/YjjxWllflWbG4j7tklwFeK1e4Co0vPgWvnBkqrt0kj5ePqUVnFHPBRQ/Qwqx
         DRtw==
X-Gm-Message-State: AGi0PuacQrePs1SXmeZ+7JzZBrMwRpUCUkblQhsIANGC5nOIyBaB5XT+
        y5ZUh5pOITnY2iBT45HrX5Kifw5e80c=
X-Google-Smtp-Source: APiQypLS+q0mQodVrTOPA3lePTNlGpDDn/2GOrVMixwKc/MTT9WSuyjwnV8djoicinnw++0C7mqpCQ==
X-Received: by 2002:a62:7cc1:: with SMTP id x184mr14521307pfc.282.1587862137923;
        Sat, 25 Apr 2020 17:48:57 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id c59sm8242514pje.10.2020.04.25.17.48.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 Apr 2020 17:48:57 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        bpoirier@cumulusnetworks.com
Subject: [PATCH net-next v2 3/3] selftests: net: add new testcases for nexthop API compat mode sysctl
Date:   Sat, 25 Apr 2020 17:48:48 -0700
Message-Id: <1587862128-24319-4-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1587862128-24319-1-git-send-email-roopa@cumulusnetworks.com>
References: <1587862128-24319-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

New tests to check route dump and notifications with
net.ipv4.nexthop_compat_mode on and off.

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 198 +++++++++++++++++++++++++++-
 1 file changed, 196 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 796670e..41dad16 100755
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
+	mpid=`($IP monitor $1 > $tmpfile & echo $!) 2>/dev/null`
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

