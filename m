Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C22D63D7C6
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiK3OJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiK3OHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:07:44 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9498BD22
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:07:14 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id z20so24175166edc.13
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xHXcuy6oLE+Bgau9uGaJ5XFA1fmV6aif/DsLUjpATIk=;
        b=6pAl5L0VLYVXTiFnKW5E0skgWr5aO+z+xDFrjrFCoygUB9HiXC6ugck9ATxUopyWti
         H8wqG8ibFuGqDbf4IxVAeG+MNjsB02sYm/XJbeaxKF+IZSNU1+5NIlmQlMshCEMMrDx3
         LEJ9Fb9y+F9bLOtrqPFQ07p4zXiLA1tFbD4mnU+5cHobdfroCt9rehpFbgt1DeVNtU+G
         cyXZM79AcPgsgUPEed9ODLeH0n14OrTVbrJUzxNPSz+thEi1umaCxayYXmLyegjTfds7
         w1k4hD/aBdMHN4e4zelHwEEEqCnfdJnHIoAdgIlbQsP0O5tJ9n5Qjt/ssncXzjqO26aU
         p+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xHXcuy6oLE+Bgau9uGaJ5XFA1fmV6aif/DsLUjpATIk=;
        b=4ljbSPc/CDuQgXhR0s8oUE4XI802Nx35az07TyqiLcqC6ZQxPyGuiq/SSnGJimWuS7
         u5B9azw3H36s3If//ed0PTsj9YNNo+Zjix9kylpqIXEaKO64XrZo8GuERA7m49OUvIre
         PX8Sm/jkopU245v69qZuzxJHvAIMyBz5OhNgfT+XK8GFbNN29J4MccAEF8StjqbuZbzr
         /W9pn9CpkrDnQQc5m/DyP1xibJCFZ4bFrVvD0q0yW05BNsv9w6tp1qOP4NC2ZGknUCgh
         EbCAiV8DuxlfwDi0EXQuTB8E5p53dzWxYI/wYpwDFsk9z8Vp71E3m2S3w2NBZkjaOajM
         aNcg==
X-Gm-Message-State: ANoB5pnh3QSOhAdleT+Q5zpmyBoA/VjnI0caGQs5bVUc6WZcZWYGbnLB
        wg7zrsdWaMKjGMfbpK6pySisjQ==
X-Google-Smtp-Source: AA0mqf6ewQ3Wcmzfrxx1kg91XYTrJwaHBigrcJyyV4Am60DQzR9SUx1Bh1B7j8tYPPI+bjGnpvw8TA==
X-Received: by 2002:a05:6402:2074:b0:46a:bb9e:40d1 with SMTP id bd20-20020a056402207400b0046abb9e40d1mr23210839edb.242.1669817232990;
        Wed, 30 Nov 2022 06:07:12 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id mh1-20020a170906eb8100b0073d83f80b05sm692454ejb.94.2022.11.30.06.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 06:07:12 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 11/11] selftests: mptcp: listener test for in-kernel PM
Date:   Wed, 30 Nov 2022 15:06:33 +0100
Message-Id: <20221130140637.409926-12-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221130140637.409926-1-matthieu.baerts@tessares.net>
References: <20221130140637.409926-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3645; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=GYVgZ0ERRFhrNn6nnoF5lHfo9sSALlgzV4tXPFj4Gfk=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjh2NpDQZZlZIAutRRRraikXlvQ/bHo9/MRdBkQPGS
 nPdMgDOJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4djaQAKCRD2t4JPQmmgcyohD/
 91r32UYsZ+REfGf2SMW49ZwRShsLHwi5nPmiCAvVMANuAb2Y3i5PhjtnNnJCQLYLvgWRTQsH4YTNUg
 GQFlLgIUEygrccr5MOayeQePm0fDejaZHUjk5CW39jGzXwvgOqRvS712fn6ozELABLwvGHbSJRJV5y
 9D9u0mscDRn8umN+CLnKKDdAtgrOXXLUwqYlZ73AqhRy+TVWvzc0fNyXNpfhoHxyzFgM504MzfJlUH
 yS/qOmPKSFW7q20nRSRvkM4h1Uy/7McV7bSLsBXa4zMOruaYE0nYHOiFkOx3Bxk/3ZFvBe1DQlit6g
 MR8ml8BpXoh0BYUKpP0NWZrD4bahTKRaxMjQRl3ozG4brL1ox1RP0Bt69iT56TGf7kV2sNMB3mMr19
 q8UrJTPtBd4B7m1GeDmrGOUtaqjxyjRJXVSQvObhNfIO/V2RV1i9eIbziAgXUvQKslgRdFQz7F5qCB
 8hVWKG+47EqvJ/FSMdgNjCy9nM1+x3CJXO25g/G6VL3qub3xE1ztOATl1vYR09TpSq1907TsZX5Fp8
 J98/rJGjupG6Q5k1qrnCVYSzZsD4ARUpH9Rm3kigqIyf9vGVnUwC6dVWMQde0yTYmnLNbCxZLHn1uU
 kUCTllIMXHZv7MTbvuurpLPDWpao7kRurC+kTPJg2jRU6+/mXJrna2SOKsrQ==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch adds test coverage for listening sockets created by the
in-kernel path manager in mptcp_join.sh.

It adds the listener event checking in the existing "remove single
address with port" test. The output looks like this:

 003 remove single address with port syn[ ok ] - synack[ ok ] - ack[ ok ]
                                     add[ ok ] - echo  [ ok ] - pt [ ok ]
                                     syn[ ok ] - synack[ ok ] - ack[ ok ]
                                     syn[ ok ] - ack   [ ok ]
                                     rm [ ok ] - rmsf  [ ok ]   invert
                                     CREATE_LISTENER 10.0.2.1:10100[ ok ]
                                     CLOSE_LISTENER 10.0.2.1:10100 [ ok ]

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 58 ++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 32a3694c57fb..d11d3d566608 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2513,6 +2513,57 @@ backup_tests()
 	fi
 }
 
+LISTENER_CREATED=15 #MPTCP_EVENT_LISTENER_CREATED
+LISTENER_CLOSED=16  #MPTCP_EVENT_LISTENER_CLOSED
+
+AF_INET=2
+AF_INET6=10
+
+verify_listener_events()
+{
+	local evt=$1
+	local e_type=$2
+	local e_family=$3
+	local e_saddr=$4
+	local e_sport=$5
+	local type
+	local family
+	local saddr
+	local sport
+
+	if [ $e_type = $LISTENER_CREATED ]; then
+		stdbuf -o0 -e0 printf "\t\t\t\t\t CREATE_LISTENER %s:%s"\
+			$e_saddr $e_sport
+	elif [ $e_type = $LISTENER_CLOSED ]; then
+		stdbuf -o0 -e0 printf "\t\t\t\t\t CLOSE_LISTENER %s:%s "\
+			$e_saddr $e_sport
+	fi
+
+	type=$(grep "type:$e_type," $evt |
+	       sed --unbuffered -n 's/.*\(type:\)\([[:digit:]]*\).*$/\2/p;q')
+	family=$(grep "type:$e_type," $evt |
+		 sed --unbuffered -n 's/.*\(family:\)\([[:digit:]]*\).*$/\2/p;q')
+	sport=$(grep "type:$e_type," $evt |
+		sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q')
+	if [ $family ] && [ $family = $AF_INET6 ]; then
+		saddr=$(grep "type:$e_type," $evt |
+			sed --unbuffered -n 's/.*\(saddr6:\)\([0-9a-f:.]*\).*$/\2/p;q')
+	else
+		saddr=$(grep "type:$e_type," $evt |
+			sed --unbuffered -n 's/.*\(saddr4:\)\([0-9.]*\).*$/\2/p;q')
+	fi
+
+	if [ $type ] && [ $type = $e_type ] &&
+	   [ $family ] && [ $family = $e_family ] &&
+	   [ $saddr ] && [ $saddr = $e_saddr ] &&
+	   [ $sport ] && [ $sport = $e_sport ]; then
+		stdbuf -o0 -e0 printf "[ ok ]\n"
+		return 0
+	fi
+	fail_test
+	stdbuf -o0 -e0 printf "[fail]\n"
+}
+
 add_addr_ports_tests()
 {
 	# signal address with port
@@ -2537,7 +2588,8 @@ add_addr_ports_tests()
 	fi
 
 	# single address with port, remove
-	if reset "remove single address with port"; then
+	# pm listener events
+	if reset_with_events "remove single address with port"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
 		pm_nl_set_limits $ns2 1 1
@@ -2545,6 +2597,10 @@ add_addr_ports_tests()
 		chk_join_nr 1 1 1
 		chk_add_nr 1 1 1
 		chk_rm_nr 1 1 invert
+
+		verify_listener_events $evts_ns1 $LISTENER_CREATED $AF_INET 10.0.2.1 10100
+		verify_listener_events $evts_ns1 $LISTENER_CLOSED $AF_INET 10.0.2.1 10100
+		kill_events_pids
 	fi
 
 	# subflow and signal with port, remove
-- 
2.37.2

