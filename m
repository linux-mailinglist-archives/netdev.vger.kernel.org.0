Return-Path: <netdev+bounces-9828-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC68172AD29
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 18:18:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA6131C20B2D
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 16:18:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F5923429;
	Sat, 10 Jun 2023 16:12:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15191DDD6
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 16:12:11 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C3D4200
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:12:03 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-30c4775d05bso1909704f8f.2
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686413521; x=1689005521;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LT4CEksVX0ymRiy2sQSk5Caolss+Jhuhlb8MjY6vjCo=;
        b=f+9y/pES9bX6Db5eTabVKSCGpWSvNa6CK6ofO8bw41JGGQL443hKkNgxbe8rrn2ttA
         6BEkARwLMXhwCTJZpqTVrhA7AEqbI0JVLx2Y0K491E0f+RM3QXQJ7RIEXTjdEqXYTOo/
         40t4E3BV7rDvuQtRpphck24gvaG1zgfgizHM/ghLbZVdnnUf+oLyNUrNDqKw3I+VQw8H
         4BTKSORIWe6CFFzwRr9FjFQeUl/No/BIG20/w73CPBx2XQ6p96EmKWvgWY7G/f6aimN1
         +uLLpcy5eIY6gli89HyCl+YZdm7haKkJZbPuAPN/v4SDap+EC2cKDD9mEVmrObz5vTNJ
         6VAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686413521; x=1689005521;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LT4CEksVX0ymRiy2sQSk5Caolss+Jhuhlb8MjY6vjCo=;
        b=Q3L1Laj7cbhDJUsUfJedUwIrxPmmui201k7IMtkvtVQD4hzjcL+b7irFVFeeFfMbvC
         VhBigANMIbBZiD2kGRRIplafhim6ynjtvXyvDI598E65RcAFXcdiWPGrXpRlUmTnpGon
         1cjU6AP/mBeoIXqX+/eFqdCkBwM01kJ8tNwcaodnQF+sPdazbPIAYUebpi8HqhYY/ofe
         ewPiUEuDuwo4qSsQ+wEX6eh8HFQC0KEX6N72MyfNto4YuZuytNHBqVIfbQ6FXs2rPcxn
         ElLN90mkYaPKJ5JMEnSsQhdgcZfaCsrCFf4iReHBOqgaQnTtQdHq6apGafESOpE8aORU
         QSfw==
X-Gm-Message-State: AC+VfDz4LeUp+pGG+khhu6889Ttx9htdAA4UXK6I1NWhFopz3vUBCxe6
	WPzhf0NP8w8BRjjoHJ00lY5KrQ==
X-Google-Smtp-Source: ACHHUZ4RkHNVJ4VrnbbHxeG4vTHIjYybF2SB9VZ5bIUNaAizAPNEl/O8/13ZfpWiSFpQKJS64Krqgg==
X-Received: by 2002:adf:f983:0:b0:307:8c47:a266 with SMTP id f3-20020adff983000000b003078c47a266mr1383202wrr.61.1686413521539;
        Sat, 10 Jun 2023 09:12:01 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id u9-20020a5d4349000000b003079c402762sm7431145wrr.19.2023.06.10.09.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 09:12:01 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sat, 10 Jun 2023 18:11:47 +0200
Subject: [PATCH net 12/17] selftests: mptcp: join: skip userspace PM tests
 if not supported
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-12-2896fe2ee8a3@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4465;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=pRdAKvQ/dI3pvOmEdmSh0TIcHcjun8gR5paBtNjXj6g=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkhKC+mfHCv2z2GumyoDLhhYl2np1YL27gjsD8r
 G2p4sYOKnWJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZISgvgAKCRD2t4JPQmmg
 c3MAEACzkX1XW63KkwRzIywwdh72ZbgMaUFu6fyrjoup03vy5yZHr8Y4/Cy7UDrDjMV9d8tBC3z
 +z2XJhPwEUqJtetwvWrArwZT2BpXlFrnl9MqnBZQctLEwcWXr/HFNBst3l7jpn0ilWf3EhKTegl
 8aK1Vtnrq7A7VtjKVvDnOZe5lvvp55C6pIQMh2VreTsh4geRlRGRe4S3Rkhf8j9Oa1aDCda1dOy
 DPCHpvI+A5QwJHivyUj6D7q/C+fHRCdTz3tijBtJmsKjEyMJuUbVrHPMdYqJgytcYMkMmeuMFBV
 6HDVsP7viQ5+P8TnJ/uz9/fvteJtdz6rkcRh6y4gnCFE6bstgjX667kAi6WVl7CTa5z7xSfKaRL
 Zodw7/S1GhPiGC/gd9SUbnKCyblz+eFCdVqJ66Sni2ED37wRU8lh8osbbKQZUGeP8sRgClgCluK
 4NODSxB46dwexuF4T9ZjwqG/Pfs5BaGtXzPj4McvP2RtcMvCG86cqkv6pVGNYsGxwYbWD3Ef9ZW
 MWDHyNq2QhcLsb5re93PjxHhY23VAD2E6oPgjxRdWg+vy1ke5woIJOOmx3GpCvNfuunVtHUx8u2
 EQz1baBJXjm2ygYSRlK9iMPMjE3OygFnkZWVptXCqLldwnNfF1eF5yMVWqUrHsf0BzCQrDD8kvt
 HwULest9RIbZgbQ==
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

One of them is the support of the userspace PM introduced by commit
4638de5aefe5 ("mptcp: handle local addrs announced by userspace PMs")
and the following ones.

It is possible to look for the MPTCP pm_type's sysctl knob to know in
advance if the userspace PM is available.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 5ac1d2d63451 ("selftests: mptcp: Add tests for userspace PM type")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 26 ++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index f8e58ebcdd54..f9161ed69b86 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -84,7 +84,7 @@ init_partial()
 		ip netns add $netns || exit $ksft_skip
 		ip -net $netns link set lo up
 		ip netns exec $netns sysctl -q net.mptcp.enabled=1
-		ip netns exec $netns sysctl -q net.mptcp.pm_type=0
+		ip netns exec $netns sysctl -q net.mptcp.pm_type=0 2>/dev/null || true
 		ip netns exec $netns sysctl -q net.ipv4.conf.all.rp_filter=0
 		ip netns exec $netns sysctl -q net.ipv4.conf.default.rp_filter=0
 		if [ $checksum -eq 1 ]; then
@@ -3191,7 +3191,8 @@ fail_tests()
 userspace_tests()
 {
 	# userspace pm type prevents add_addr
-	if reset "userspace pm type prevents add_addr"; then
+	if reset "userspace pm type prevents add_addr" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns1
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
@@ -3202,7 +3203,8 @@ userspace_tests()
 	fi
 
 	# userspace pm type does not echo add_addr without daemon
-	if reset "userspace pm no echo w/o daemon"; then
+	if reset "userspace pm no echo w/o daemon" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns2
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
@@ -3213,7 +3215,8 @@ userspace_tests()
 	fi
 
 	# userspace pm type rejects join
-	if reset "userspace pm type rejects join"; then
+	if reset "userspace pm type rejects join" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns1
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
@@ -3223,7 +3226,8 @@ userspace_tests()
 	fi
 
 	# userspace pm type does not send join
-	if reset "userspace pm type does not send join"; then
+	if reset "userspace pm type does not send join" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns2
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
@@ -3233,7 +3237,8 @@ userspace_tests()
 	fi
 
 	# userspace pm type prevents mp_prio
-	if reset "userspace pm type prevents mp_prio"; then
+	if reset "userspace pm type prevents mp_prio" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns1
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
@@ -3244,7 +3249,8 @@ userspace_tests()
 	fi
 
 	# userspace pm type prevents rm_addr
-	if reset "userspace pm type prevents rm_addr"; then
+	if reset "userspace pm type prevents rm_addr" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns1
 		set_userspace_pm $ns2
 		pm_nl_set_limits $ns1 0 1
@@ -3256,7 +3262,8 @@ userspace_tests()
 	fi
 
 	# userspace pm add & remove address
-	if reset_with_events "userspace pm add & remove address"; then
+	if reset_with_events "userspace pm add & remove address" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns1
 		pm_nl_set_limits $ns2 1 1
 		run_tests $ns1 $ns2 10.0.1.1 0 userspace_1 0 slow
@@ -3267,7 +3274,8 @@ userspace_tests()
 	fi
 
 	# userspace pm create destroy subflow
-	if reset_with_events "userspace pm create destroy subflow"; then
+	if reset_with_events "userspace pm create destroy subflow" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns2
 		pm_nl_set_limits $ns1 0 1
 		run_tests $ns1 $ns2 10.0.1.1 0 0 userspace_1 slow

-- 
2.40.1


