Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EECE176F8E
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 07:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbgCCGh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 01:37:59 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35133 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgCCGh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 01:37:58 -0500
Received: by mail-qk1-f194.google.com with SMTP id 145so2384964qkl.2
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 22:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AhGUuzasSvXgJ3k0I3+oiSz35HAN3drLhBLKPIsrv7U=;
        b=iuEODtXDcHUqGiyUm4lq36WmAzzlp/Ap22btVIyzHC58nmixBB+zGdA1NW+YbG4xyw
         CY9zvqhm1GZAXWm6bQrlTgLR7UltIWrQyUa050OAHXVxkJleLaKEVS1e+z7ZC/r2Bc99
         rL+TfMNQqzjeQj0Lx4KPh4Nx8CbDumPdaV/cKZg5IaUK18egduTtkQIelVSpUS5QJkQI
         lRwIBhR9oOaLhAHN4JVw8K0Xz+QQ4Aw9MBbQ074dDeNf6OuPqE/sS4q2j1VUR7Dz6qM1
         0e9E9byAxxvo8tuf7LQoJ2uGf/VO5aAK4ZkNEjAx2GgT/EJoE41uZsRZ0f4BgoTGhVOC
         IVOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AhGUuzasSvXgJ3k0I3+oiSz35HAN3drLhBLKPIsrv7U=;
        b=gTVy+MKLdfpnoKdjXtygZOd9P4ZnYL8DUnalKnpnvRB+f58pP1vwY0OvF0JIW6ToVz
         SQo4piDukiXBt2gqjXyXDKnHYugfQbgGR2madda/zk5DMPccBTmAd/WqUNbD1FLI4lOI
         frP/EXKOsrxymCPGdGWfHA1FyUdK1y3FM6wBIQaF+GWgsSCTUzfwVVgOhyaIhC5QbUlY
         IFAGqo8Z2PghauCJPQWSaZyHiCeYl0NkzpU/g/AHrsMpmo3yAiJS2eNh33OHuDqzLtcZ
         26xd57mrlrZPm3+knuemsdHmAv7x6OjmxUqsWztdPZ/eduHhc8tP7XCkpz5cTthwkQQl
         eCxA==
X-Gm-Message-State: ANhLgQ2DB1AY3AxnPxJ+3ZkEU4EJpZ1zxhijRrc9dkhebEpwOj9tSuql
        WkO+rRqM8PwTyHYdzksAz2O2MhMjU1o=
X-Google-Smtp-Source: ADFU+vt9qsui9AJIChraId9TM7NQtPwf5uhPU1FIIJl95cS745I9xtrqb1L/x+HxCL8ruEN3eFbFdA==
X-Received: by 2002:a05:620a:12a3:: with SMTP id x3mr2840914qki.254.1583217477373;
        Mon, 02 Mar 2020 22:37:57 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x4sm3599929qto.56.2020.03.02.22.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 22:37:57 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 3/3] selftests/net/fib_tests: update addr_metric_test for peer route testing
Date:   Tue,  3 Mar 2020 14:37:36 +0800
Message-Id: <20200303063736.4904-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200303063736.4904-1-liuhangbin@gmail.com>
References: <20200303063736.4904-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch update {ipv4, ipv6}_addr_metric_test with
1. Set metric of address with peer route and see if the route added
correctly.
2. Modify metric and peer address for peer route and see if the route
changed correctly.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/fib_tests.sh | 34 +++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 60273f1bc7d9..b7616704b55e 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1041,6 +1041,27 @@ ipv6_addr_metric_test()
 	fi
 	log_test $rc 0 "Prefix route with metric on link up"
 
+	# verify peer metric added correctly
+	set -e
+	run_cmd "$IP -6 addr flush dev dummy2"
+	run_cmd "$IP -6 addr add dev dummy2 2001:db8:104::1 peer 2001:db8:104::2 metric 260"
+	set +e
+
+	check_route6 "2001:db8:104::1 dev dummy2 proto kernel metric 260"
+	log_test $? 0 "Set metric with peer route on local side"
+	log_test $? 0 "User specified metric on local address"
+	check_route6 "2001:db8:104::2 dev dummy2 proto kernel metric 260"
+	log_test $? 0 "Set metric with peer route on peer side"
+
+	set -e
+	run_cmd "$IP -6 addr change dev dummy2 2001:db8:104::1 peer 2001:db8:104::3 metric 261"
+	set +e
+
+	check_route6 "2001:db8:104::1 dev dummy2 proto kernel metric 261"
+	log_test $? 0 "Modify metric and peer address on local side"
+	check_route6 "2001:db8:104::3 dev dummy2 proto kernel metric 261"
+	log_test $? 0 "Modify metric and peer address on peer side"
+
 	$IP li del dummy1
 	$IP li del dummy2
 	cleanup
@@ -1457,13 +1478,20 @@ ipv4_addr_metric_test()
 
 	run_cmd "$IP addr flush dev dummy2"
 	run_cmd "$IP addr add dev dummy2 172.16.104.1/32 peer 172.16.104.2 metric 260"
-	run_cmd "$IP addr change dev dummy2 172.16.104.1/32 peer 172.16.104.2 metric 261"
 	rc=$?
 	if [ $rc -eq 0 ]; then
-		check_route "172.16.104.2 dev dummy2 proto kernel scope link src 172.16.104.1 metric 261"
+		check_route "172.16.104.2 dev dummy2 proto kernel scope link src 172.16.104.1 metric 260"
+		rc=$?
+	fi
+	log_test $rc 0 "Set metric of address with peer route"
+
+	run_cmd "$IP addr change dev dummy2 172.16.104.1/32 peer 172.16.104.3 metric 261"
+	rc=$?
+	if [ $rc -eq 0 ]; then
+		check_route "172.16.104.3 dev dummy2 proto kernel scope link src 172.16.104.1 metric 261"
 		rc=$?
 	fi
-	log_test $rc 0 "Modify metric of address with peer route"
+	log_test $rc 0 "Modify metric and peer address for peer route"
 
 	$IP li del dummy1
 	$IP li del dummy2
-- 
2.19.2

