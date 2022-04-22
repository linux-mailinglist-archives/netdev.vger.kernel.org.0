Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7AA50B107
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444634AbiDVHFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 03:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444426AbiDVHFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 03:05:04 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77768255B8;
        Fri, 22 Apr 2022 00:02:12 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t4so6662800pgc.1;
        Fri, 22 Apr 2022 00:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cE//00fhKyhkv8zXzb0JNZA/ch37kTGzwrab8yh2zXs=;
        b=dffSvKf9Bj3Z40NmPRAcK536nBtfkysHMIPSAilGdkxKHJoxSm891joCuWO3eHsXOf
         ke7xnG1cbjwANIZppjNN/6KhIOt7fbXLMnBGKEi1u+3eX4vI/XdWmRivA/IWewBfCt7c
         lZN7LOQjfxM2tlRZNW9Ggr1kagr5O3Wo/QZaQNSFyiRUzZYp+EP7v6MEEmmGC3vdeo5r
         b3O/2/qSeej9D1ZbuQTvJceISd1FbdNjeParfwTjPcLW7FXDdvv7lRTFLBi8XToI7RRm
         EO8gUJaGnhmtzinHmeoK1gqJtlJfwvnHPTCwRvNXDI7eOEqaATipnNqI+4Dw9rgk6RpU
         yJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cE//00fhKyhkv8zXzb0JNZA/ch37kTGzwrab8yh2zXs=;
        b=ygBIF/byN0142bWbt9J9wMGy9Pm4F6TG/7itDyVbq6SXULOQQZLy0EYrusfgTkkt/B
         s8tRkokc+XTQK9yZtJRGl6idZ4XF6o7YZ5tfV1pU4GpcFAp7hpmVKuWGHALRzhI+btmU
         oQ8tPHgzhdNflYW2GlL+egvuBiKCaTHnE31ZgljbZuhkvdBBfRYLlK/GWAazjcg7sgZA
         ULg9VRmOYLjOK5+02cZp3ximxBzu/WtrUPcCWXURpVSfFxK3Co5j794v/t1+i/tY24q1
         Jh87EfNVD5RCfW/Nq6p1VcBZEhjLdANHdA9YwHiCbKxZWoj7OdDfh3yJuzP52IO7ZZNZ
         eXZw==
X-Gm-Message-State: AOAM53113wGkbsxfy03NfHhvrtSg5a/HXXIirNt3U2Meex0EEy5EV2v4
        OZPOsQbSghJvkAw8SEz+eFCzcQtt3pMoww==
X-Google-Smtp-Source: ABdhPJwdWW2CvZ7R9SNKW7GyJYbRfgyz+K5TLOutaoNWp+V1hWfKMb/ll60CoEFpRGtAI5TOblxnvg==
X-Received: by 2002:a05:6a00:1a01:b0:505:b3e5:b5fc with SMTP id g1-20020a056a001a0100b00505b3e5b5fcmr3558569pfv.53.1650610931570;
        Fri, 22 Apr 2022 00:02:11 -0700 (PDT)
Received: from localhost.localdomain ([111.204.182.100])
        by smtp.gmail.com with ESMTPSA id 10-20020a17090a1a0a00b001cd630f301fsm4873467pjk.36.2022.04.22.00.02.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Apr 2022 00:02:11 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
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
Subject: [net-next v4 3/3] selftests/sysctl: add sysctl macro test
Date:   Fri, 22 Apr 2022 15:01:41 +0800
Message-Id: <20220422070141.39397-4-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220422070141.39397-1-xiangxia.m.yue@gmail.com>
References: <20220422070141.39397-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
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
 lib/test_sysctl.c                        | 21 ++++++++++++
 tools/testing/selftests/sysctl/sysctl.sh | 43 ++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/lib/test_sysctl.c b/lib/test_sysctl.c
index a5a3d6c27e1f..43b8d502f4c7 100644
--- a/lib/test_sysctl.c
+++ b/lib/test_sysctl.c
@@ -43,6 +43,7 @@ struct test_sysctl_data {
 	int int_0001;
 	int int_0002;
 	int int_0003[4];
+	int match_int[12];
 
 	int boot_int;
 
@@ -95,6 +96,13 @@ static struct ctl_table test_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "match_int",
+		.data		= &test_data.match_int,
+		.maxlen		= sizeof(test_data.match_int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		.procname	= "boot_int",
 		.data		= &test_data.boot_int,
@@ -132,6 +140,19 @@ static struct ctl_table_header *test_sysctl_header;
 
 static int __init test_sysctl_init(void)
 {
+	test_data.match_int[0] = *(int *)SYSCTL_ZERO,
+	test_data.match_int[1] = *(int *)SYSCTL_ONE,
+	test_data.match_int[2] = *(int *)SYSCTL_TWO,
+	test_data.match_int[3] = *(int *)SYSCTL_THREE,
+	test_data.match_int[4] = *(int *)SYSCTL_FOUR,
+	test_data.match_int[5] = *(int *)SYSCTL_ONE_HUNDRED,
+	test_data.match_int[6] = *(int *)SYSCTL_TWO_HUNDRED,
+	test_data.match_int[7] = *(int *)SYSCTL_ONE_THOUSAND,
+	test_data.match_int[8] = *(int *)SYSCTL_THREE_THOUSAND,
+	test_data.match_int[9] = *(int *)SYSCTL_INT_MAX,
+	test_data.match_int[10] = *(int *)SYSCTL_MAXOLDUID,
+	test_data.match_int[11] = *(int *)SYSCTL_NEG_ONE,
+
 	test_data.bitmap_0001 = kzalloc(SYSCTL_TEST_BITMAP_SIZE/8, GFP_KERNEL);
 	if (!test_data.bitmap_0001)
 		return -ENOMEM;
diff --git a/tools/testing/selftests/sysctl/sysctl.sh b/tools/testing/selftests/sysctl/sysctl.sh
index 19515dcb7d04..cd74f4749748 100755
--- a/tools/testing/selftests/sysctl/sysctl.sh
+++ b/tools/testing/selftests/sysctl/sysctl.sh
@@ -40,6 +40,7 @@ ALL_TESTS="$ALL_TESTS 0004:1:1:uint_0001"
 ALL_TESTS="$ALL_TESTS 0005:3:1:int_0003"
 ALL_TESTS="$ALL_TESTS 0006:50:1:bitmap_0001"
 ALL_TESTS="$ALL_TESTS 0007:1:1:boot_int"
+ALL_TESTS="$ALL_TESTS 0008:1:1:match_int"
 
 function allow_user_defaults()
 {
@@ -785,6 +786,47 @@ sysctl_test_0007()
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
+	echo -n "Testing if $TARGET is matched with kernel ..."
+	ORIG_VALUES=$(cat "${TARGET}")
+
+	# SYSCTL_ZERO		0
+	# SYSCTL_ONE		1
+	# SYSCTL_TWO		2
+	# SYSCTL_THREE		3
+	# SYSCTL_FOUR		4
+	# SYSCTL_ONE_HUNDRED	100
+	# SYSCTL_TWO_HUNDRED	200
+	# SYSCTL_ONE_THOUSAND	1000
+	# SYSCTL_THREE_THOUSAND 3000
+	# SYSCTL_INT_MAX	INT_MAX
+	# SYSCTL_MAXOLDUID	65535
+	# SYSCTL_NEG_ONE	-1
+	local VALUES=(0 1 2 3 4 100 200 1000 3000 $INT_MAX 65535 -1)
+	idx=0
+
+	for ori in $ORIG_VALUES; do
+		val=${VALUES[$idx]}
+		if [ $ori -ne $val ]; then
+			echo "Expected $val, got $ori, TEST FAILED"
+			rc=1
+			test_rc
+		fi
+
+		let idx=$idx+1
+	done
+
+	echo "ok"
+	return 0
+}
+
 list_tests()
 {
 	echo "Test ID list:"
@@ -800,6 +842,7 @@ list_tests()
 	echo "0005 x $(get_test_count 0005) - tests proc_douintvec() array"
 	echo "0006 x $(get_test_count 0006) - tests proc_do_large_bitmap()"
 	echo "0007 x $(get_test_count 0007) - tests setting sysctl from kernel boot param"
+	echo "0008 x $(get_test_count 0008) - tests sysctl macro values match"
 }
 
 usage()
-- 
2.27.0

