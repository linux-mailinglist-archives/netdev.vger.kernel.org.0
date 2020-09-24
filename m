Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812A727658B
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgIXBBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgIXBBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:01:32 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B4AC0613CE;
        Wed, 23 Sep 2020 18:01:32 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id x22so777102pfo.12;
        Wed, 23 Sep 2020 18:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=oZPkJS2+leQsW9xRtSE0zAO9xlb/IRjPMYUZOW6oH+s=;
        b=pgBgJ09+m44ICXVlIgT0CVm0TjP5oFws/u5wkXXLHXtW8Nb92K6s/pu4Nw4o0+mIOT
         3p1c9MTAUGws8rnSLOylEJUusmikIpdV0XDwubUjkuAsNbrZLub5u7jdq/e/FcO0neT3
         Z/OLK0uCOdGrp2In8yiHGauNPCTMR/lLWtyhLlu7dDN3cKJKXBb5osNP3TtokKYcC+cp
         ssa7UpBl8Qyzs9IMnPcqnaD5eJZz9cVX2hv7ydIGISLY/9HrVTTgz6MRfhkVa+G0LFZH
         nWVJooP+W8jIIyFJ4jrr1hLKYChtlkAo/Uw+l35WA9Zm61G0HvMsG5m44gDJiuDTLoD4
         cUQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=oZPkJS2+leQsW9xRtSE0zAO9xlb/IRjPMYUZOW6oH+s=;
        b=dLKKS9OjkGEmGi2lWzG08F/Hadlo1KsurbVevef4eSPrw9PNDoNkv1wy9cYlSphInw
         sIn8wpnJ1R0JHey7L2N48IwQWBLZrh6MSH79vxHZn0wPi9E9ZCrvjEktclE1pntTSN00
         ZYwuOcso1HaLQNqpG1nbzlqTvY+PF9atwL6s98dhNFION5AzgDC9pTZNPCuwuPRiICGl
         eVJLGQtB26TpOGbaQDkKjBrk7cgsTIxN/z5xVIHb43MHmD/U6XKSbuzzC0Hro9Sj/Isb
         pjFhITAwsZGIZBBtBMw+Ps9LoEQOrdyhaGNcRgPE35O4uaDcWeDk2QmhydiZxQe3PacV
         8RBA==
X-Gm-Message-State: AOAM5332YCJNEC5auqKu1dxcxhNSmGkWr+jhmHv7GoaYTBpHoEdsJF6r
        pvYxX1DnetTmi+pEqdIWb8k=
X-Google-Smtp-Source: ABdhPJybXhpq7Z2EtpNKQyj2w+sbEKt6ATyAYAvGNQF3tcpaLwM+ne4vhHS21Yzs0KfdKI/Q2mROsg==
X-Received: by 2002:a05:6a00:22d2:b029:142:2501:3966 with SMTP id f18-20020a056a0022d2b029014225013966mr2277631pfj.43.1600909291454;
        Wed, 23 Sep 2020 18:01:31 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id z7sm889240pgc.35.2020.09.23.18.01.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 18:01:30 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 13/16] selftests: mptcp: add remove addr and subflow test cases
Date:   Thu, 24 Sep 2020 08:29:59 +0800
Message-Id: <e0f074f2764382c6aa1e901f3003455261a33da3.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <aa4ffb8cb7f8c135e5704eb11cfce7cb0bf7ecd4.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com>
 <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com>
 <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com>
 <f9b7f06f71698c2e78366da929a7fef173d01856.1600853093.git.geliangtang@gmail.com>
 <430dd4f9c241ae990a5cfa6809276b36993ce91b.1600853093.git.geliangtang@gmail.com>
 <7b0898eff793dde434464b5fac2629739d9546fd.1600853093.git.geliangtang@gmail.com>
 <98bcc56283c482c294bd6ae9ce1476821ddc6837.1600853093.git.geliangtang@gmail.com>
 <37f2befac450fb46367f62446a4bb2c9d0a5986a.1600853093.git.geliangtang@gmail.com>
 <5018fd495529e058ea866e8d8edbe0bb98ec733a.1600853093.git.geliangtang@gmail.com>
 <644420f22ba6f0b9f9f3509c081d8d639ff4bbf3.1600853093.git.geliangtang@gmail.com>
 <fcebccadfa3127e0f55103cc7ee4cd00841e2ea0.1600853093.git.geliangtang@gmail.com>
 <aa4ffb8cb7f8c135e5704eb11cfce7cb0bf7ecd4.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added the remove addr and subflow test cases and two new
functions.

The first function run_remove_tests calls do_transfer with two new
arguments, rm_nr_ns1 and rm_nr_ns2, for the numbers of addresses should be
removed during the transfer process in namespace 1 and namespace 2.

If both these two arguments are 0, we do the join test cases with
"mptcp_connect -j" command. Otherwise, do the remove test cases with
"mptcp_connect -r" command.

The second function chk_rm_nr checks the RM_ADDR related mibs's counters.

The output of the test cases looks like this:

11 remove single subflow           syn[ ok ] - synack[ ok ] - ack[ ok ]
                                   rm [ ok ] - sf    [ ok ]
12 remove multiple subflows        syn[ ok ] - synack[ ok ] - ack[ ok ]
                                   rm [ ok ] - sf    [ ok ]
13 remove single address           syn[ ok ] - synack[ ok ] - ack[ ok ]
                                   add[ ok ] - echo  [ ok ]
                                   rm [ ok ] - sf    [ ok ]
14 remove subflow and signal       syn[ ok ] - synack[ ok ] - ack[ ok ]
                                   add[ ok ] - echo  [ ok ]
                                   rm [ ok ] - sf    [ ok ]
15 remove subflows and signal      syn[ ok ] - synack[ ok ] - ack[ ok ]
                                   add[ ok ] - echo  [ ok ]
                                   rm [ ok ] - sf    [ ok ]

Suggested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Suggested-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 145 +++++++++++++++++-
 1 file changed, 142 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 9d64abdde146..08f53d86dedc 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -8,6 +8,7 @@ cin=""
 cout=""
 ksft_skip=4
 timeout=30
+mptcp_connect=""
 capture=0
 
 TEST_COUNT=0
@@ -132,6 +133,8 @@ do_transfer()
 	cl_proto="$3"
 	srv_proto="$4"
 	connect_addr="$5"
+	rm_nr_ns1="$6"
+	rm_nr_ns2="$7"
 
 	port=$((10000+$TEST_COUNT))
 	TEST_COUNT=$((TEST_COUNT+1))
@@ -156,14 +159,44 @@ do_transfer()
 		sleep 1
 	fi
 
-	ip netns exec ${listener_ns} ./mptcp_connect -j -t $timeout -l -p $port -s ${srv_proto} 0.0.0.0 < "$sin" > "$sout" &
+	if [[ $rm_nr_ns1 -eq 0 && $rm_nr_ns2 -eq 0 ]]; then
+		mptcp_connect="./mptcp_connect -j"
+	else
+		mptcp_connect="./mptcp_connect -r"
+	fi
+
+	ip netns exec ${listener_ns} $mptcp_connect -t $timeout -l -p $port -s ${srv_proto} 0.0.0.0 < "$sin" > "$sout" &
 	spid=$!
 
 	sleep 1
 
-	ip netns exec ${connector_ns} ./mptcp_connect -j -t $timeout -p $port -s ${cl_proto} $connect_addr < "$cin" > "$cout" &
+	ip netns exec ${connector_ns} $mptcp_connect -t $timeout -p $port -s ${cl_proto} $connect_addr < "$cin" > "$cout" &
 	cpid=$!
 
+	if [ $rm_nr_ns1 -gt 0 ]; then
+		counter=1
+		sleep 1
+
+		while [ $counter -le $rm_nr_ns1 ]
+		do
+			ip netns exec ${listener_ns} ./pm_nl_ctl del $counter
+			sleep 1
+			let counter+=1
+		done
+	fi
+
+	if [ $rm_nr_ns2 -gt 0 ]; then
+		counter=1
+		sleep 1
+
+		while [ $counter -le $rm_nr_ns2 ]
+		do
+			ip netns exec ${connector_ns} ./pm_nl_ctl del $counter
+			sleep 1
+			let counter+=1
+		done
+	fi
+
 	wait $cpid
 	retc=$?
 	wait $spid
@@ -219,7 +252,24 @@ run_tests()
 	connect_addr="$3"
 	lret=0
 
-	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr}
+	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr} 0 0
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		ret=$lret
+		return
+	fi
+}
+
+run_remove_tests()
+{
+	listener_ns="$1"
+	connector_ns="$2"
+	connect_addr="$3"
+	rm_nr_ns1="$4"
+	rm_nr_ns2="$5"
+	lret=0
+
+	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr} ${rm_nr_ns1} ${rm_nr_ns2}
 	lret=$?
 	if [ $lret -ne 0 ]; then
 		ret=$lret
@@ -313,6 +363,43 @@ chk_add_nr()
 	fi
 }
 
+chk_rm_nr()
+{
+	local rm_addr_nr=$1
+	local rm_subflow_nr=$2
+	local count
+	local dump_stats
+
+	printf "%-39s %s" " " "rm "
+	count=`ip netns exec $ns1 nstat -as | grep MPTcpExtRmAddr | awk '{print $2}'`
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$rm_addr_nr" ]; then
+		echo "[fail] got $count RM_ADDR[s] expected $rm_addr_nr"
+		ret=1
+		dump_stats=1
+	else
+		echo -n "[ ok ]"
+	fi
+
+	echo -n " - sf    "
+	count=`ip netns exec $ns2 nstat -as | grep MPTcpExtRmSubflow | awk '{print $2}'`
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$rm_subflow_nr" ]; then
+		echo "[fail] got $count RM_SUBFLOW[s] expected $rm_subflow_nr"
+		ret=1
+		dump_stats=1
+	else
+		echo "[ ok ]"
+	fi
+
+	if [ "${dump_stats}" = 1 ]; then
+		echo Server ns stats
+		ip netns exec $ns1 nstat -as | grep MPTcp
+		echo Client ns stats
+		ip netns exec $ns2 nstat -as | grep MPTcp
+	fi
+}
+
 sin=$(mktemp)
 sout=$(mktemp)
 cin=$(mktemp)
@@ -404,6 +491,58 @@ run_tests $ns1 $ns2 10.0.1.1
 chk_join_nr "multiple subflows and signal" 3 3 3
 chk_add_nr 1 1
 
+# single subflow, remove
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+run_remove_tests $ns1 $ns2 10.0.1.1 0 1
+chk_join_nr "remove single subflow" 1 1 1
+chk_rm_nr 1 1
+
+# multiple subflows, remove
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+run_remove_tests $ns1 $ns2 10.0.1.1 0 2
+chk_join_nr "remove multiple subflows" 2 2 2
+chk_rm_nr 2 2
+
+# single address, remove
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+run_remove_tests $ns1 $ns2 10.0.1.1 1 0
+chk_join_nr "remove single address" 1 1 1
+chk_add_nr 1 1
+chk_rm_nr 0 0
+
+# subflow and signal, remove
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+run_remove_tests $ns1 $ns2 10.0.1.1 1 1
+chk_join_nr "remove subflow and signal" 2 2 2
+chk_add_nr 1 1
+chk_rm_nr 1 1
+
+# subflows and signal, remove
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 3
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+ip netns exec $ns2 ./pm_nl_ctl limits 1 3
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+run_remove_tests $ns1 $ns2 10.0.1.1 1 2
+chk_join_nr "remove subflows and signal" 3 3 3
+chk_add_nr 1 1
+chk_rm_nr 2 2
+
 # single subflow, syncookies
 reset_with_cookies
 ip netns exec $ns1 ./pm_nl_ctl limits 0 1
-- 
2.17.1

