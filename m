Return-Path: <netdev+bounces-9825-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 920D572AD1E
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 18:16:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEFD41C20A4A
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 16:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EE2D22D5A;
	Sat, 10 Jun 2023 16:12:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D81822602
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 16:12:05 +0000 (UTC)
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCD83C17
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:11:59 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-30e53cacc10so1733034f8f.0
        for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 09:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686413517; x=1689005517;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i3/m544Y4xi+8Ieyn4wQPmbPoOCvfuEI4stKUoC1R/Q=;
        b=euSvPvs22UmbIdLd4JejAfNty0GhFTDwuYFv7uvFAeO84CAAESiPT8FCajMJohN21z
         abPfHXNl0JwcaKnjlVfQHyhxb4mL+b1tuDKrkjnwAWjnkv6qguFsoVc2NCDbq2q5bHGo
         5tjPa3/ndsf8Rqb8VSsW0K+PbcQDP/gUYzZ3h38UAIPzrdeJMsdvGecvnPd7uV+g3UjH
         PbUHDPTzDfOH+xLPToXQC/Yg0cCTQWpr24223W2j5gyyYjOiCS7HbjcjR9YsRVqs4Kv8
         euKHTK7tUsN6ugMVrtkGzlR66ZslU2WPkINa1ZaktV+zhvjGRSz+6r/0q8MDaGCqGs83
         56XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686413517; x=1689005517;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i3/m544Y4xi+8Ieyn4wQPmbPoOCvfuEI4stKUoC1R/Q=;
        b=Cxmp4dNIBsJlhERgux88yzlcCBcjBWHCjxqKUoJt0TAnvCS5zk2PRXg6SBgWBwFWof
         02Et/B9bm7z7q6rArJLnKT20WVcvbROf9X+RV9yWCLW4AMFWvx5I0qDNOFqSTQAI1cyV
         T3Lro+G0B9P7+VmyURfjRU57GYVlxfFeYYmCxUeryN0PxFJz+u0blPhgzG/qHSXm87QZ
         ps95o74yoEV1GlCWp8OICdgRoyW/uSXq7OgVUwiJH+bymp1vQwmkg+Dq7949+vnHJ9xS
         vyDemX/rJzdYR/nNuKwbswi7AaIc736+eO6AfzF6vYpFG+XrtkI3kW4vP02mD0+EctGg
         bBZA==
X-Gm-Message-State: AC+VfDxfhQScwAcy89s58ZUzJCp3LOpm/Oy1lNUBFxUJhXhRIhTme7CA
	+1pFsC9i+vKjqv47aWmGquVEqA==
X-Google-Smtp-Source: ACHHUZ7e9PZtYH7kYiTKhLhk2sNy1v/RyJ5un0+yT9tYD1jzH9b9fD8lcu6pCGfxkAEVfcfRt9GlWQ==
X-Received: by 2002:a5d:6408:0:b0:30f:a938:6d5d with SMTP id z8-20020a5d6408000000b0030fa9386d5dmr819304wru.56.1686413517555;
        Sat, 10 Jun 2023 09:11:57 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id u9-20020a5d4349000000b003079c402762sm7431145wrr.19.2023.06.10.09.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 09:11:57 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Sat, 10 Jun 2023 18:11:44 +0200
Subject: [PATCH net 09/17] selftests: mptcp: join: skip implicit tests if
 not supported
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230609-upstream-net-20230610-mptcp-selftests-support-old-kernels-part-3-v1-9-2896fe2ee8a3@tessares.net>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2477;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=+TIYpqWqK0BPHdPmxcxR0Aqav5mF26MQtIHtBH1up88=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkhKC+NeKQrExRMscIswVqfvf84Omivjqk5VyW/
 r9EfiPsA6CJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZISgvgAKCRD2t4JPQmmg
 c8iXEACwL6K7BICJORbLHqj6QlVS6gnzSo7ks9iay1wjMUX+Ql5VSOXZtHUzbMF7HdX6WmLsxxL
 ISZJfj7kf1SKQd7tyn50gFDQm4M2q5rvLx4+PhygYYgxQl55S3u7DdLmcnwxo3XR0MyHZse15C9
 91GyhgENsFdUuhQbxbBaiFfabYcY8i1x9TTqBJCCMHCS4HfWddTWE6aZhXK4Ax/s3Tj9RdIsTE/
 60JDZyZ98wXntOSplKSUYG0HkSGNQn9hFELHV8cIPglvT7ph2oz11T6ggDmVX3EQMT4T4J4x5bu
 AtmwuE+W5BWXYLM5SECwRVCLgKvjZKuQIQeBmXmA9pWrhlUbifYH6EFQf+MT3dH5wymOqddsQSN
 AX6tMUWwMHLSN2uSPJm0PfDIqdjcL1l+HqI/OurryBNdaXJqk7QSUFCqN+IGw8taWBzNBJEkJpM
 3O90S5ndkn+M2074+7mb7QSvW3YjSIBY1XiukFrBlGsSLUiKsBiyfjWIFjXjVfGtyfc9YG63Cii
 4wQE8Uf/1AX70dYdLQtzOKkV7wfXHGfzik09dh0nS8vHrK6Qmr5h1TWwK14z7SL723bZtK6j/qL
 jVUEHK3nY8ECnps7dC3R/OtQSV9UKvnvLotmIb6ypglICowcWOLjxFBx7fmWB+mFfVDE2g/04Zi
 y463qYdjxFb5wVQ==
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

One of them is the support of the implicit endpoints introduced by
commit d045b9eb95a9 ("mptcp: introduce implicit endpoints").

It is possible to look for "mptcp_subflow_send_ack" in kallsyms because
it was needed to introduce the mentioned feature. So we can know in
advance if the feature is supported instead of trying and accepting any
results.

Note that here and in the following commits, we re-do the same check for
each sub-test of the same function for a few reasons. The main one is
not to break the ID assign to each test in order to be able to easily
compare results between different kernel versions. Also, we can still
run a specific test even if it is skipped. Another reason is that it
makes it clear during the review that a specific subtest will be skipped
or not under certain conditions. At the end, it looks OK to call the
exact same helper multiple times: it is not a critical path and it is
the same code that is executed, not really more cases to maintain.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 69c6ce7b6eca ("selftests: mptcp: add implicit endpoint test case")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 3d4f22fe8f8c..7f860a93527f 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3272,8 +3272,10 @@ userspace_tests()
 
 endpoint_tests()
 {
+	# subflow_rebuild_header is needed to support the implicit flag
 	# userspace pm type prevents add_addr
-	if reset "implicit EP"; then
+	if reset "implicit EP" &&
+	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
@@ -3293,7 +3295,8 @@ endpoint_tests()
 		kill_tests_wait
 	fi
 
-	if reset "delete and re-add"; then
+	if reset "delete and re-add" &&
+	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow

-- 
2.40.1


