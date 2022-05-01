Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB785516153
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 05:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239675AbiEAD7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 23:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239646AbiEAD7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 23:59:52 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13064EDC8;
        Sat, 30 Apr 2022 20:56:25 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id w17-20020a17090a529100b001db302efed6so8842852pjh.4;
        Sat, 30 Apr 2022 20:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nFKK9tbwZ4J1LvHBYQyFT4vsHGk5LucafrRS/Gv18zA=;
        b=ktOboK1mXTskj8qTSetILJdzrAt3fBKxSpOym4txyAZilYWxeX0LRHga+1QpY/BIFM
         7KXljDm4rPD8PUu0T6RVX2m8LdRYC1SypNNx0+mAPOekj9u7DqNuGxqJHYHLqa8fKbGg
         +497gEpFYRo1UorbDUWq7FFYgl2pckvvmu5o59Gu3bmynM8Fa7C4LYjbLj02t6r3uFFN
         nPGj+8LcaA74IAxdAb1b1Tg59tqoxZMc31uYdZ7wk81OktKKcAggGKSt8MNt0K7hq3Wt
         hPcDxNneUr1nZtg+2l4gh2oNxyJ8iSdLVk59uC6smn1oXEbZIK7VMhD5+Ejf9bn1X6Wn
         mjCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nFKK9tbwZ4J1LvHBYQyFT4vsHGk5LucafrRS/Gv18zA=;
        b=mwktS2TBoXsIHehGoM9L7JBXaOa7GJ/Hyw3APLQyv411zgmpQ8Gaetd+OmzP2Rp8h0
         sBwzxkd0Yv4c7EcGf7qWFqT7xhO3D4I9fEzQM4Z9AzUI1ylFdBIt9GqL3b3RSrRiieQ4
         vtYAH7FzizbdLY8U5GIaNUoE/HhSjfrzh+XHYkQ7GdlaiiuuW72PQrxm0N/VS7nfOkj0
         mxQJvMd5FeVKodQh0pUidta6mxgE3SJr+EGLEI1ZnLTBChYc17Tn2Fg5jqBHSjIoAdB0
         k8U2QnUaLE5t3s3MWNsnKksx7m/Um7GxZ+pPA2KI15OZGRMJzc42Ie/9y/zafOmkgkZW
         PLrg==
X-Gm-Message-State: AOAM531qymp0ET1B/iFDP19gA4sMRM2ggXXNcPnCPiaX1F2heFw4lQhB
        +SCJJLyqUKlNG9ifQOo/0KF3giPyaRiQzA==
X-Google-Smtp-Source: ABdhPJwHYKQ/ZlsEGXA6r5p6xTcoS10xAS/6qA8qeCPePdAImnjtQ9Sv5DA2y4zc51ufizRS4D1gbQ==
X-Received: by 2002:a17:90a:730c:b0:1d9:3f5:9a00 with SMTP id m12-20020a17090a730c00b001d903f59a00mr6829993pjk.109.1651377384932;
        Sat, 30 Apr 2022 20:56:24 -0700 (PDT)
Received: from bogon.xiaojukeji.com ([111.201.149.168])
        by smtp.gmail.com with ESMTPSA id q9-20020a654949000000b003c1d946af6csm1767863pgs.32.2022.04.30.20.56.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 30 Apr 2022 20:56:24 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: [PATCH v5 3/3] selftests/sysctl: add sysctl macro test
Date:   Sun,  1 May 2022 11:55:24 +0800
Message-Id: <20220501035524.91205-4-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220501035524.91205-1-xiangxia.m.yue@gmail.com>
References: <20220501035524.91205-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: Akhmat Karakotov <hmukos@yandex-team.ru>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 lib/test_sysctl.c                        | 32 ++++++++++++++++++++++++
 tools/testing/selftests/sysctl/sysctl.sh | 23 +++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/lib/test_sysctl.c b/lib/test_sysctl.c
index a5a3d6c27e1f..9a564971f539 100644
--- a/lib/test_sysctl.c
+++ b/lib/test_sysctl.c
@@ -38,6 +38,7 @@
 
 static int i_zero;
 static int i_one_hundred = 100;
+static int match_int_ok = 1;
 
 struct test_sysctl_data {
 	int int_0001;
@@ -95,6 +96,13 @@ static struct ctl_table test_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "match_int",
+		.data		= &match_int_ok,
+		.maxlen		= sizeof(match_int_ok),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		.procname	= "boot_int",
 		.data		= &test_data.boot_int,
@@ -132,6 +140,30 @@ static struct ctl_table_header *test_sysctl_header;
 
 static int __init test_sysctl_init(void)
 {
+	int i;
+
+	struct {
+		int defined;
+		int wanted;
+	} match_int[] = {
+		{.defined = *(int *)SYSCTL_ZERO,	.wanted = 0},
+		{.defined = *(int *)SYSCTL_ONE,		.wanted = 1},
+		{.defined = *(int *)SYSCTL_TWO,		.wanted = 2},
+		{.defined = *(int *)SYSCTL_THREE,	.wanted = 3},
+		{.defined = *(int *)SYSCTL_FOUR,	.wanted = 4},
+		{.defined = *(int *)SYSCTL_ONE_HUNDRED, .wanted = 100},
+		{.defined = *(int *)SYSCTL_TWO_HUNDRED,	.wanted = 200},
+		{.defined = *(int *)SYSCTL_ONE_THOUSAND, .wanted = 1000},
+		{.defined = *(int *)SYSCTL_THREE_THOUSAND, .wanted = 3000},
+		{.defined = *(int *)SYSCTL_INT_MAX,	.wanted = INT_MAX},
+		{.defined = *(int *)SYSCTL_MAXOLDUID,	.wanted = 65535},
+		{.defined = *(int *)SYSCTL_NEG_ONE,	.wanted = -1},
+	};
+
+	for (i = 0; i < ARRAY_SIZE(match_int); i++)
+		if (match_int[i].defined != match_int[i].wanted)
+			match_int_ok = 0;
+
 	test_data.bitmap_0001 = kzalloc(SYSCTL_TEST_BITMAP_SIZE/8, GFP_KERNEL);
 	if (!test_data.bitmap_0001)
 		return -ENOMEM;
diff --git a/tools/testing/selftests/sysctl/sysctl.sh b/tools/testing/selftests/sysctl/sysctl.sh
index 19515dcb7d04..f50778a3d744 100755
--- a/tools/testing/selftests/sysctl/sysctl.sh
+++ b/tools/testing/selftests/sysctl/sysctl.sh
@@ -40,6 +40,7 @@ ALL_TESTS="$ALL_TESTS 0004:1:1:uint_0001"
 ALL_TESTS="$ALL_TESTS 0005:3:1:int_0003"
 ALL_TESTS="$ALL_TESTS 0006:50:1:bitmap_0001"
 ALL_TESTS="$ALL_TESTS 0007:1:1:boot_int"
+ALL_TESTS="$ALL_TESTS 0008:1:1:match_int"
 
 function allow_user_defaults()
 {
@@ -785,6 +786,27 @@ sysctl_test_0007()
 	return $ksft_skip
 }
 
+sysctl_test_0008()
+{
+	TARGET="${SYSCTL}/match_int"
+	if [ ! -f $TARGET ]; then
+		echo "Skipping test for $TARGET as it is not present ..."
+		return $ksft_skip
+	fi
+
+	echo -n "Testing if $TARGET is matched in kernel"
+	ORIG_VALUE=$(cat "${TARGET}")
+
+	if [ $ORIG_VALUE -ne 1 ]; then
+		echo "TEST FAILED"
+		rc=1
+		test_rc
+	fi
+
+	echo "ok"
+	return 0
+}
+
 list_tests()
 {
 	echo "Test ID list:"
@@ -800,6 +822,7 @@ list_tests()
 	echo "0005 x $(get_test_count 0005) - tests proc_douintvec() array"
 	echo "0006 x $(get_test_count 0006) - tests proc_do_large_bitmap()"
 	echo "0007 x $(get_test_count 0007) - tests setting sysctl from kernel boot param"
+	echo "0008 x $(get_test_count 0008) - tests sysctl macro values match"
 }
 
 usage()
-- 
2.27.0

