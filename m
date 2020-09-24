Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3BB27655B
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgIXApt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXApt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:45:49 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6F4C0613CE;
        Wed, 23 Sep 2020 17:45:49 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id fa1so700617pjb.0;
        Wed, 23 Sep 2020 17:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Y06geVnFRAlUGD0zw0ngZdWLQoShuSNreoopx4iDaRc=;
        b=PfXmuC13aPVXNA1iRVre4IrM0VOK2SiZBQIeb8pFGwyeqMTZahbw3gim2Qjea+sb3I
         8pYhYONXbCowuJSryWXxxcJ4Tg37bdlh839BagkAxOIET+EGdq88DWdAc/dF1vb5Hr7P
         +645rfdwNDE964whh+cFd/kLrdRetavp+oiSEwkUDLU9miO2y+VDBFs1GutktntPhO40
         OW21SGcarxfnrMo9gtZHeeNtZJRA6VCY65Or+vGCzmadIwdi42kJ9QYrRZB5BsvmZSfq
         wk1CKMVMkSTsrAsxcZlW78ebcDSjXvh0pJHZzWlAL8ZvAFM7DgAqiUG166Z6GupzTRl6
         VKFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Y06geVnFRAlUGD0zw0ngZdWLQoShuSNreoopx4iDaRc=;
        b=oMySjse313qKcSQjSoxHfXAfiwwawa2jmzc72scXpiC3MYyNwzqfG+p3JhOpELvvTI
         /sTEv42KYbJI9JeDbS7P66wo93Y9rgOKQB/fPQQKRacSIo7ECYyiNXpt48V64ljFW58r
         uQgHNYD1uNouMBsIa2ofRKqcdrxTmkwmWSv+/ThjOKcFCVk6BjAu8HjMi7fL6nC+7JIO
         UwnqnSj1uX/1xYM7DVxrs1TYd+YB7yKyISNSlwB9CkqQbTgb9YVSQs14yWtjN8mLtReY
         OcDhu/nG9LO6PR8bbuVhmjEE3CboNLucKsP5+yT9KvM6eKwFAa9xa1w5sl82yM0/LlCp
         HypA==
X-Gm-Message-State: AOAM531G12tNM3OwiMHuREAvcScXFFIYtbbz2RGtUi19wvLX8IF8UhH/
        HEBHroMl1Vas1ZXsw8SLIKw=
X-Google-Smtp-Source: ABdhPJwVkW6xQEQD3QLU8Emj495pJ636kOj3j0Wia4vysl72iRbz/mBst+4HL5AFtGH8yftc+aPghA==
X-Received: by 2002:a17:902:8e86:b029:d2:4276:1abf with SMTP id bg6-20020a1709028e86b02900d242761abfmr2069028plb.64.1600908348819;
        Wed, 23 Sep 2020 17:45:48 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id c7sm752732pfj.100.2020.09.23.17.45.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Sep 2020 17:45:48 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 06/16] selftests: mptcp: add ADD_ADDR mibs check function
Date:   Thu, 24 Sep 2020 08:29:52 +0800
Message-Id: <7b0898eff793dde434464b5fac2629739d9546fd.1600853093.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com>
In-Reply-To: <430dd4f9c241ae990a5cfa6809276b36993ce91b.1600853093.git.geliangtang@gmail.com>
References: <cover.1600853093.git.geliangtang@gmail.com> <bfecdd638bb74a02de1c3f1c84239911e304fcc3.1600853093.git.geliangtang@gmail.com> <e3c9ab612d773465ddf78cef0482208c73a0ca07.1600853093.git.geliangtang@gmail.com> <bf7aca2bee20de148728e30343734628aee6d779.1600853093.git.geliangtang@gmail.com> <f9b7f06f71698c2e78366da929a7fef173d01856.1600853093.git.geliangtang@gmail.com> <430dd4f9c241ae990a5cfa6809276b36993ce91b.1600853093.git.geliangtang@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added the ADD_ADDR related mibs counter check function
chk_add_nr(). This function check both ADD_ADDR and ADD_ADDR with
echo flag.

The output looks like this:

 07 unused signal address             syn[ ok ] - synack[ ok ] - ack[ ok ]
                                      add[ ok ] - echo  [ ok ]
 08 signal address                    syn[ ok ] - synack[ ok ] - ack[ ok ]
                                      add[ ok ] - echo  [ ok ]
 09 subflow and signal                syn[ ok ] - synack[ ok ] - ack[ ok ]
                                      add[ ok ] - echo  [ ok ]
 10 multiple subflows and signal      syn[ ok ] - synack[ ok ] - ack[ ok ]
                                      add[ ok ] - echo  [ ok ]
 11 remove subflow and signal         syn[ ok ] - synack[ ok ] - ack[ ok ]
                                      add[ ok ] - echo  [ ok ]

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 44 +++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index c2943e4dfcfe..9d64abdde146 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -276,6 +276,43 @@ chk_join_nr()
 	fi
 }
 
+chk_add_nr()
+{
+	local add_nr=$1
+	local echo_nr=$2
+	local count
+	local dump_stats
+
+	printf "%-39s %s" " " "add"
+	count=`ip netns exec $ns2 nstat -as | grep MPTcpExtAddAddr | awk '{print $2}'`
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$add_nr" ]; then
+		echo "[fail] got $count ADD_ADDR[s] expected $add_nr"
+		ret=1
+		dump_stats=1
+	else
+		echo -n "[ ok ]"
+	fi
+
+	echo -n " - echo  "
+	count=`ip netns exec $ns1 nstat -as | grep MPTcpExtEchoAdd | awk '{print $2}'`
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$echo_nr" ]; then
+		echo "[fail] got $count ADD_ADDR echo[s] expected $echo_nr"
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
@@ -332,6 +369,7 @@ reset
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
 run_tests $ns1 $ns2 10.0.1.1
 chk_join_nr "unused signal address" 0 0 0
+chk_add_nr 1 1
 
 # accept and use add_addr
 reset
@@ -340,6 +378,7 @@ ip netns exec $ns2 ./pm_nl_ctl limits 1 1
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
 run_tests $ns1 $ns2 10.0.1.1
 chk_join_nr "signal address" 1 1 1
+chk_add_nr 1 1
 
 # accept and use add_addr with an additional subflow
 # note: signal address in server ns and local addresses in client ns must
@@ -352,6 +391,7 @@ ip netns exec $ns2 ./pm_nl_ctl limits 1 2
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
 run_tests $ns1 $ns2 10.0.1.1
 chk_join_nr "subflow and signal" 2 2 2
+chk_add_nr 1 1
 
 # accept and use add_addr with additional subflows
 reset
@@ -362,6 +402,7 @@ ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
 run_tests $ns1 $ns2 10.0.1.1
 chk_join_nr "multiple subflows and signal" 3 3 3
+chk_add_nr 1 1
 
 # single subflow, syncookies
 reset_with_cookies
@@ -396,6 +437,7 @@ ip netns exec $ns2 ./pm_nl_ctl limits 1 1
 ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
 run_tests $ns1 $ns2 10.0.1.1
 chk_join_nr "signal address with syn cookies" 1 1 1
+chk_add_nr 1 1
 
 # test cookie with subflow and signal
 reset_with_cookies
@@ -405,6 +447,7 @@ ip netns exec $ns2 ./pm_nl_ctl limits 1 2
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
 run_tests $ns1 $ns2 10.0.1.1
 chk_join_nr "subflow and signal w cookies" 2 2 2
+chk_add_nr 1 1
 
 # accept and use add_addr with additional subflows
 reset_with_cookies
@@ -415,5 +458,6 @@ ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
 ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
 run_tests $ns1 $ns2 10.0.1.1
 chk_join_nr "subflows and signal w. cookies" 3 3 3
+chk_add_nr 1 1
 
 exit $ret
-- 
2.17.1

