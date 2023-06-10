Return-Path: <netdev+bounces-9821-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 651AC72AD10
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 18:14:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 993721C20A5D
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 16:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA382098F;
	Sat, 10 Jun 2023 16:11:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A93920988
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 16:11:57 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928CE3A97
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:11:53 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f732d37d7cso28090715e9.2
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686413512; x=1689005512;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ebzCN2e3LmW/09+X000OqYT8+BgOfE8XFgbNZ00sNHo=;
        b=qZyygywpDh1p68o5FlXbw/1HYBnyeEWRQsQeQRdaA5WNu7f/gvtgJsPRrutFm83c8n
         Qu0SJquCECm4zL2Qwq2dJ1ywUZiWgeeuYM15fnjeEEagRvejvwv4D4+OAIaUgDH8naiv
         0QyMzr5jUFllEynf0CapLOeg212lSar2OY4K6/9L+PaxPYSJJGgLPLlk7weSRt3hlOMP
         bfx4d7hmbpaPAbZHcfFP355nJXv1VouwMEsFtX0+CTOHz5QnVcQtDFP3Q9X7TdX2glPV
         0Ghun2EPN4xKxauK+LRskL4FHyb08c1vOb6T3R9BUnjmyWbIAIqlzmAkuyTyDMoqgWjZ
         wgLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686413512; x=1689005512;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ebzCN2e3LmW/09+X000OqYT8+BgOfE8XFgbNZ00sNHo=;
        b=VkzyfwYEki/RQbe5dkRxu86jLQuvzvnqEWlg9o6EKnBlSTTa6apYYKFWm0pXcJnQKo
         cBU+r7KBYp+qbXdSi1665QtE+PEiVTsIMeJ/oGwW6fnH0zv3j8O9DnOMS1YIhZogjx1h
         1RK/6ktoNIcIMsGJ/94BsWyIWu5StSaPQb+ZkbhQJktN27SYdhmQbdB0os3XgHiBgS/g
         67czOy4/t3B4YBs5NlmBTLZTc00LSR8KjSJ7ad9WLIaMM4jECQcXoTXWWcYGi4Oku0Pk
         mleeofNfVtDyXuYKDKv01WrwPQF8pew6PNQXo6aUcf1wrYpQion0KZF0EXGwUMLUjngJ
         5TVA==
X-Gm-Message-State: AC+VfDxspHSTkXXdvkUzN390QtU2JBnoOy/vXH/wP/CuKYw8GZoTEJsz
	I8Mk9fMvsopJMumlDAXdBu6Z7g==
X-Google-Smtp-Source: ACHHUZ6aNDJcAyobwudyIAgSSJoe5zC4Yqtw7UlolFIVhdC1SVypMKGzowUsftoeUe2JQ5D7Mwsoyg==
X-Received: by 2002:adf:ec4b:0:b0:309:1532:87e with SMTP id w11-20020adfec4b000000b003091532087emr1744525wrn.31.1686413511996;
        Sat, 10 Jun 2023 09:11:51 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id u9-20020a5d4349000000b003079c402762sm7431145wrr.19.2023.06.10.09.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 09:11:51 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sat, 10 Jun 2023 18:11:40 +0200
Subject: [PATCH net 05/17] selftests: mptcp: join: skip test if iptables/tc
 cmds fail
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-5-2896fe2ee8a3@tessares.net>
References: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-0-2896fe2ee8a3@tessares.net>
In-Reply-To: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-0-2896fe2ee8a3@tessares.net>
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>, 
 Davide Caratti <dcaratti@redhat.com>, Christoph Paasch <cpaasch@apple.com>, 
 Geliang Tang <geliangtang@gmail.com>, Geliang Tang <geliang.tang@suse.com>
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 Matthieu Baerts <matthieu.baerts@tessares.net>, stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5942;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=ikkDavS1p6kc/V5BA9I5ZZiKDslgeSsXhbwNygCFAjw=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkhKC+49ffDzzJivGJbPD00PzWgfLoS/qsQ040z
 fDv9sepS5WJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZISgvgAKCRD2t4JPQmmg
 c71/D/4+XvdHcSoQODxaQYHwmJPtDwA3VDu4wzTJCAuJ6EGvhzmRjzcyfonr/93wVkI84G++f/v
 c2ow8e25QjKV34fUbo2MSsUlTpaPXIW4blTt1jJ8L4wWMU9178mlTwyB5KOXYHO4N7TEwEE600R
 kpp0K6wuf0jcQARpw9j+0fimzQdnSEbENozHAGiY7TiAnrVCC3kcEd+T3nUdxcEsSR/pUTNf11k
 AIUHIOiagftB7n8ZuU0jz2QDB70oltxuBmZLU4s/s+xjWA/+Af1g040SC0yi4JSACmB/1yGaLt8
 VAM661e2gd5B7hCtXKSYXia0Vp5usd5V7+JA9VAwJRgFj523jC2nyp1zekmkS1Am5fBjh8LoZpU
 ZirgQDXp4SFCdmMgs7IaVIqwraz/XMP4yf5cYb9ndAIE3sM3ImhOiFsj1afW8QVhGCkrdnBMMAA
 SJ+7j/6Ny6ZutOhmBdMJomTYZzoDVbiUUqB9tdsslgGMLFHPG6S1O8aQS/hwuDd3x5k+XCXZcew
 BglKQmttPDBugCvxAzY6nHkUuaFnbGJ81FF62KSgE7JfMr+2Y0DqwQQhVd/ITDZEmZ5uq8T8+D7
 3vmp57mi1q5r2P1uQlVnhcZSvPFioM4xiDbm34WI0gXYRxkwcOqgElHHh2U+xuMtRicGKpgnaaR
 SWa3uajbHYY6Cog==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

Some tests are using IPTables and/or TC commands to force some
behaviours. If one of these commands fails -- likely because some
features are not available due to missing kernel config -- we should
intercept the error and skip the tests requiring these features.

Note that if we expect to have these features available and if
SELFTESTS_MPTCP_LIB_EXPECT_ALL_FEATURES env var is set to 1, the tests
will be marked as failed instead of skipped.

This patch also replaces the 'exit 1' by 'return 1' not to stop the
selftest in the middle without the conclusion if there is an issue with
NF or TC.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 8d014eaa9254 ("selftests: mptcp: add ADD_ADDR timeout test case")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 88 ++++++++++++++++---------
 1 file changed, 57 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 276396cbe60c..c471934ad5e0 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -286,11 +286,15 @@ reset_with_add_addr_timeout()
 	fi
 
 	ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
-	ip netns exec $ns2 $tables -A OUTPUT -p tcp \
-		-m tcp --tcp-option 30 \
-		-m bpf --bytecode \
-		"$CBPF_MPTCP_SUBOPTION_ADD_ADDR" \
-		-j DROP
+
+	if ! ip netns exec $ns2 $tables -A OUTPUT -p tcp \
+			-m tcp --tcp-option 30 \
+			-m bpf --bytecode \
+			"$CBPF_MPTCP_SUBOPTION_ADD_ADDR" \
+			-j DROP; then
+		mark_as_skipped "unable to set the 'add addr' rule"
+		return 1
+	fi
 }
 
 # $1: test name
@@ -334,17 +338,12 @@ reset_with_allow_join_id0()
 #     tc action pedit offset 162 out of bounds
 #
 # Netfilter is used to mark packets with enough data.
-reset_with_fail()
+setup_fail_rules()
 {
-	reset "${1}" || return 1
-
-	ip netns exec $ns1 sysctl -q net.mptcp.checksum_enabled=1
-	ip netns exec $ns2 sysctl -q net.mptcp.checksum_enabled=1
-
 	check_invert=1
 	validate_checksum=1
-	local i="$2"
-	local ip="${3:-4}"
+	local i="$1"
+	local ip="${2:-4}"
 	local tables
 
 	tables="${iptables}"
@@ -359,15 +358,32 @@ reset_with_fail()
 		-p tcp \
 		-m length --length 150:9999 \
 		-m statistic --mode nth --packet 1 --every 99999 \
-		-j MARK --set-mark 42 || exit 1
+		-j MARK --set-mark 42 || return ${ksft_skip}
 
-	tc -n $ns2 qdisc add dev ns2eth$i clsact || exit 1
+	tc -n $ns2 qdisc add dev ns2eth$i clsact || return ${ksft_skip}
 	tc -n $ns2 filter add dev ns2eth$i egress \
 		protocol ip prio 1000 \
 		handle 42 fw \
 		action pedit munge offset 148 u8 invert \
 		pipe csum tcp \
-		index 100 || exit 1
+		index 100 || return ${ksft_skip}
+}
+
+reset_with_fail()
+{
+	reset "${1}" || return 1
+	shift
+
+	ip netns exec $ns1 sysctl -q net.mptcp.checksum_enabled=1
+	ip netns exec $ns2 sysctl -q net.mptcp.checksum_enabled=1
+
+	local rc=0
+	setup_fail_rules "${@}" || rc=$?
+
+	if [ ${rc} -eq ${ksft_skip} ]; then
+		mark_as_skipped "unable to set the 'fail' rules"
+		return 1
+	fi
 }
 
 reset_with_events()
@@ -382,6 +398,25 @@ reset_with_events()
 	evts_ns2_pid=$!
 }
 
+reset_with_tcp_filter()
+{
+	reset "${1}" || return 1
+	shift
+
+	local ns="${!1}"
+	local src="${2}"
+	local target="${3}"
+
+	if ! ip netns exec "${ns}" ${iptables} \
+			-A INPUT \
+			-s "${src}" \
+			-p tcp \
+			-j "${target}"; then
+		mark_as_skipped "unable to set the filter rules"
+		return 1
+	fi
+}
+
 fail_test()
 {
 	ret=1
@@ -745,15 +780,6 @@ pm_nl_check_endpoint()
 	fi
 }
 
-filter_tcp_from()
-{
-	local ns="${1}"
-	local src="${2}"
-	local target="${3}"
-
-	ip netns exec "${ns}" ${iptables} -A INPUT -s "${src}" -p tcp -j "${target}"
-}
-
 do_transfer()
 {
 	local listener_ns="$1"
@@ -1975,23 +2001,23 @@ subflows_error_tests()
 	fi
 
 	# multiple subflows, with subflow creation error
-	if reset "multi subflows, with failing subflow"; then
+	if reset_with_tcp_filter "multi subflows, with failing subflow" ns1 10.0.3.2 REJECT &&
+	   continue_if mptcp_lib_kallsyms_has "mptcp_pm_subflow_check_next$"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
-		filter_tcp_from $ns1 10.0.3.2 REJECT
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
 		chk_join_nr 1 1 1
 	fi
 
 	# multiple subflows, with subflow timeout on MPJ
-	if reset "multi subflows, with subflow timeout"; then
+	if reset_with_tcp_filter "multi subflows, with subflow timeout" ns1 10.0.3.2 DROP &&
+	   continue_if mptcp_lib_kallsyms_has "mptcp_pm_subflow_check_next$"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
-		filter_tcp_from $ns1 10.0.3.2 DROP
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
 		chk_join_nr 1 1 1
 	fi
@@ -1999,11 +2025,11 @@ subflows_error_tests()
 	# multiple subflows, check that the endpoint corresponding to
 	# closed subflow (due to reset) is not reused if additional
 	# subflows are added later
-	if reset "multi subflows, fair usage on close"; then
+	if reset_with_tcp_filter "multi subflows, fair usage on close" ns1 10.0.3.2 REJECT &&
+	   continue_if mptcp_lib_kallsyms_has "mptcp_pm_subflow_check_next$"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-		filter_tcp_from $ns1 10.0.3.2 REJECT
 		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow &
 
 		# mpj subflow will be in TW after the reset

-- 
2.40.1


