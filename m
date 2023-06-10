Return-Path: <netdev+bounces-9819-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17A8472AD07
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 18:13:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 636431C20AC9
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 16:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EBED20690;
	Sat, 10 Jun 2023 16:11:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D07A20688
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 16:11:54 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79DD3A94
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:11:50 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f6e4554453so20616465e9.3
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686413509; x=1689005509;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vbCMcIUx++P6SdtXKp4v0Xqp9nJ5C2WK+DmOSVFkYWI=;
        b=OkrifqmXX55yO4FkuGabclI2bqoO6y31QHS0r9xw/jLI+lO52u5kYKZduErpx/V/bD
         ARYC6z4PZnqkEvQzfajdeZ+NhlkixaBJD2GNH4lo27KNXUOsUmiAfDnHV8XEHAn33TwR
         tWi16rZHVucUexDXiLob8dosG/aKk7E5YMz0LkG6cKcPZiodzry0lFjHghVVk8VhMFMi
         5TtPRAvgOyEp44yhwA6z9xgeW9Xx7sCTodA3dXa05YjcNxjqTSNm255l/Av94O+qyuS8
         n2L57Ke2b+0X6KksWQ9QTlIDO/Bns4x7mJ8Fqmc1cCMrTjVLnHWZrpUIjCexXJZI65Df
         3fDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686413509; x=1689005509;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vbCMcIUx++P6SdtXKp4v0Xqp9nJ5C2WK+DmOSVFkYWI=;
        b=R+9koUlW3AtneJPshbW7SvFYEYyzz8ymTHZCZICQTbV6/jR4i6soDITOFnixIc0XAA
         85lm+GePsW5qrJNcCJ7H3CpvePuIY/mlm1lFmdWYl+7CiEnafpsSojs0QL7nijMKa0+B
         Emp0Wsv+NwqEEvK7E+smVu5AAdLVnC1VvL7SWCLTea8FnDvjvxwF297I1KEP/FJCwmjM
         Ar7e+GKD4HutOHd4EMJ66QiKeE0ARodfnRfnvP1EexJvzhGI5B7/VwSTbeJUuXjkOQT2
         BPG4BehXPxQIFNHSquqdBKBS5PlU3c561O9XS+o6Nt7vpt0E4aMzV7p4JA7h9/U0LXzx
         ZYZw==
X-Gm-Message-State: AC+VfDwLpP6Wb8V8jMTlDkwr4Xvq9ikxb4Zatqe0tJ95hLRq021s5yX5
	6t475/NmS3ys/B0fBsZmo+HWUg==
X-Google-Smtp-Source: ACHHUZ5wlz6A6rIrbQvMeFaiq5asxJYrpA4MR7RzkZ2k6tR9yrG+PNtzsvJBrkaLVHeDVziVC9ETJQ==
X-Received: by 2002:a05:600c:3785:b0:3f4:2328:b5c2 with SMTP id o5-20020a05600c378500b003f42328b5c2mr2977964wmr.35.1686413509234;
        Sat, 10 Jun 2023 09:11:49 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id u9-20020a5d4349000000b003079c402762sm7431145wrr.19.2023.06.10.09.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 09:11:48 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sat, 10 Jun 2023 18:11:38 +0200
Subject: [PATCH net 03/17] selftests: mptcp: join: helpers to skip tests
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-3-2896fe2ee8a3@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1874;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=Lz+CG90Q/jYCqW9q9yYPKVP+ZrLRJq5EixGj4YlvfsI=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkhKC9J8WtCudLHdu3pw2KRPMvFMZqLF+DxvfkK
 FVZhqBJlNOJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZISgvQAKCRD2t4JPQmmg
 c6HxD/9O/MNGyJjazN49T9UQv63fgVXYnatJP7GDD9kQX0OYx61bP3EnSR66Kh7fiTFvnz4/tKZ
 Q+oKGIiBYx1moIqeIXkFpenYehlPHAHXx4c5/39x2nJkWmyOoY8/9RUhIErdpmAk/0FvVHOBaIF
 93CYxPcWShett7MrQnXx0xZtudzxhrLMesJqAcW71bWeJElSNnyCB7jB7wkuEpNyMYFb5rlsWWM
 Hph1em3uYE2n7rrnKTsQLNxbobiiyeGaR3jx7wsvN/yw9Aw9+Ymr8fkx1gedHT8J4v+YfuenKnd
 7Zp0FY94LBDeTqXXPuPW0Df+6n9/amNQdT1oPpvin5gzxgdG9YlLZOPykVmA2dSMQPqsOGdKzNs
 8EyUFBLDkL7RQx6Kn26snCvnBxzWv76VnT+JIF/uFCoPrX4Mf8NmoaG5Bo/DlT7Wi0gF5DKXMOZ
 qjAa7WSFeXTuajNDhEFWT8aFZaYUm+yPBO6Yaed8bxptsUHdYjqBf9td9Fz1w/FWM1b8423zDJj
 CnwzDE34Qxh3WRstPo2A6sh+Widdt9+hG1YrmunwEYsSFkqlhflVPJJU82YaIAiF9I3PdB7C5VO
 pQ7lrIEZ/tUifWUE7JrJsg8WDsevx0WFJAgYEOW3ds0D1gNPuToO/exvZULEiOCLjWh6HZrDq1w
 d0DBsdLnDgS+7wQ==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

Here are some helpers that will be used to mark subtests as skipped if a
feature is not supported. Marking as a fix for the commit introducing
this selftest to help with the backports.

While at it, also check if kallsyms feature is available as it will also
be used in the following commits to check if MPTCP features are
available before starting a test.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: b08fbf241064 ("selftests: add test-cases for MPTCP MP_JOIN")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 27 +++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 74cc8a74a9d6..a63aed145393 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -142,6 +142,7 @@ cleanup_partial()
 check_tools()
 {
 	mptcp_lib_check_mptcp
+	mptcp_lib_check_kallsyms
 
 	if ! ip -Version &> /dev/null; then
 		echo "SKIP: Could not run test without ip tool"
@@ -191,6 +192,32 @@ cleanup()
 	cleanup_partial
 }
 
+# $1: msg
+print_title()
+{
+	printf "%03u %-36s %s" "${TEST_COUNT}" "${TEST_NAME}" "${1}"
+}
+
+# [ $1: fail msg ]
+mark_as_skipped()
+{
+	local msg="${1:-"Feature not supported"}"
+
+	mptcp_lib_fail_if_expected_feature "${msg}"
+
+	print_title "[ skip ] ${msg}"
+	printf "\n"
+}
+
+# $@: condition
+continue_if()
+{
+	if ! "${@}"; then
+		mark_as_skipped
+		return 1
+	fi
+}
+
 skip_test()
 {
 	if [ "${#only_tests_ids[@]}" -eq 0 ] && [ "${#only_tests_names[@]}" -eq 0 ]; then

-- 
2.40.1


