Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4B53EBF7D
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 03:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbhHNB7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 21:59:09 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:19539 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbhHNB7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 21:59:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1628906322; x=1660442322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3g13B8GNHyKioHzxOHCYyAa0G1gbzKYmrkHQz7bfc3k=;
  b=wFkn+2WrWU/4BCFdkHYHINgCtdhWrjbgZ1jnPsqbQzEe1VYMhrhsI6gw
   k+GWztyzJ2XfYQyNoqIftOqHNehATMskeECXXzd9SaX/eGLLSNzBkmOtD
   Uq+tDEv1T/NdJC8rPjdtoePtoTD08aSjHT+tgAfnD5UuA/TVDdiXuWd58
   g=;
X-IronPort-AV: E=Sophos;i="5.84,320,1620691200"; 
   d="scan'208";a="19223575"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 14 Aug 2021 01:58:41 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 58E86A2329;
        Sat, 14 Aug 2021 01:58:39 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 14 Aug 2021 01:58:38 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.69) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Sat, 14 Aug 2021 01:58:34 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v6 bpf-next 4/4] selftest/bpf: Extend the bpf_snprintf() test for "%c".
Date:   Sat, 14 Aug 2021 10:57:18 +0900
Message-ID: <20210814015718.42704-5-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210814015718.42704-1-kuniyu@amazon.co.jp>
References: <20210814015718.42704-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.69]
X-ClientProxiedBy: EX13D13UWB003.ant.amazon.com (10.43.161.233) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds various "positive" patterns for "%c" and two "negative"
patterns for wide character.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 tools/testing/selftests/bpf/prog_tests/snprintf.c | 4 +++-
 tools/testing/selftests/bpf/progs/test_snprintf.c | 6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/snprintf.c b/tools/testing/selftests/bpf/prog_tests/snprintf.c
index dffbcaa1ec98..8fd1b4b29a0e 100644
--- a/tools/testing/selftests/bpf/prog_tests/snprintf.c
+++ b/tools/testing/selftests/bpf/prog_tests/snprintf.c
@@ -19,7 +19,7 @@
 #define EXP_ADDR_OUT "0000000000000000 ffff00000add4e55 "
 #define EXP_ADDR_RET sizeof(EXP_ADDR_OUT "unknownhashedptr")
 
-#define EXP_STR_OUT  "str1 longstr"
+#define EXP_STR_OUT  "str1         a  b c      d e longstr"
 #define EXP_STR_RET  sizeof(EXP_STR_OUT)
 
 #define EXP_OVER_OUT "%over"
@@ -114,6 +114,8 @@ void test_snprintf_negative(void)
 	ASSERT_ERR(load_single_snprintf("%"), "invalid specifier 3");
 	ASSERT_ERR(load_single_snprintf("%12345678"), "invalid specifier 4");
 	ASSERT_ERR(load_single_snprintf("%--------"), "invalid specifier 5");
+	ASSERT_ERR(load_single_snprintf("%lc"), "invalid specifier 6");
+	ASSERT_ERR(load_single_snprintf("%llc"), "invalid specifier 7");
 	ASSERT_ERR(load_single_snprintf("\x80"), "non ascii character");
 	ASSERT_ERR(load_single_snprintf("\x1"), "non printable character");
 }
diff --git a/tools/testing/selftests/bpf/progs/test_snprintf.c b/tools/testing/selftests/bpf/progs/test_snprintf.c
index e2ad26150f9b..8fda07544023 100644
--- a/tools/testing/selftests/bpf/progs/test_snprintf.c
+++ b/tools/testing/selftests/bpf/progs/test_snprintf.c
@@ -59,9 +59,9 @@ int handler(const void *ctx)
 	/* Kernel pointers */
 	addr_ret = BPF_SNPRINTF(addr_out, sizeof(addr_out), "%pK %px %p",
 				0, 0xFFFF00000ADD4E55, 0xFFFF00000ADD4E55);
-	/* Strings embedding */
-	str_ret  = BPF_SNPRINTF(str_out, sizeof(str_out), "%s %+05s",
-				str1, longstr);
+	/* Strings and single-byte character embedding */
+	str_ret  = BPF_SNPRINTF(str_out, sizeof(str_out), "%s % 9c %+2c %-3c %04c %0c %+05s",
+				str1, 'a', 'b', 'c', 'd', 'e', longstr);
 	/* Overflow */
 	over_ret = BPF_SNPRINTF(over_out, sizeof(over_out), "%%overflow");
 	/* Padding of fixed width numbers */
-- 
2.30.2

