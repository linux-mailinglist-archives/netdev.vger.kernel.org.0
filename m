Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFD0146ED4
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 17:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgAWQ7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 11:59:49 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33625 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729792AbgAWQ7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 11:59:46 -0500
Received: by mail-wr1-f65.google.com with SMTP id b6so3956045wrq.0
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 08:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rb1rNawttqyIkUsUxmbdc0uUxGiYj0dD/f72ioJC76k=;
        b=yLHzEv+AA8o4f/7cdOhZQV9l/CveX4Eviz1ROxUOGNJOdZWLcO87ssprX/3wmIjbDT
         TbhDAlrWrjcsK7Dt3y3V6ndEobcs4+OSePOc9/42fr8PvzJXcGnCyU+jetwxkNVnV/2K
         xyK5BE3E246zlrUr2HyFhrEi9TGkza4umntkE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rb1rNawttqyIkUsUxmbdc0uUxGiYj0dD/f72ioJC76k=;
        b=JGq3rN1J1wi2yARb1ywYRgFQr568T/WVSfp0b5nDEQTN4KOIQgsFA9ObjUFfvBwg+x
         Qr13RAqfetDNBJgWiGqx5lzvxy60B319OKlGr+hqEF4kWiR48vIAP/SMTNa8j2iTRs+0
         BSmNsflCEHFX3zhq0qDijUA/BdZpwg/2fVzna5OePrlHYstop1GUHcHkuK26qujsj51G
         kYZ48EL2d+7zOdFbZTaM+j9mxpJR4A7NEQd5K3xgOD10dnc7GuFFbmAsYnx3VoL8es13
         Cw+Nn8DL3YgKSIhs128zl42/M3sqYqcEsjkfSWO4/J8h3yb2XZ83WSaIb4geuXMXVkSF
         pwBw==
X-Gm-Message-State: APjAAAWz8Ug/tKqDjt2Z1n5v/BQDuvvG24Z3xGqeOYozCf7XBV8dD0ML
        m2a6G69RlmgrmcH4msPF54AV0Q==
X-Google-Smtp-Source: APXvYqw5qClXvS6LvBmbFphDEZ37bZMMug7AGHXZjJYQNS1WAbdkaa7R9cQ+mSce0KsrQyAnYJTSYQ==
X-Received: by 2002:adf:81c2:: with SMTP id 60mr18243517wra.8.1579798785202;
        Thu, 23 Jan 2020 08:59:45 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:d0a9:6cca:1210:a574])
        by smtp.gmail.com with ESMTPSA id u1sm3217698wmc.5.2020.01.23.08.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 08:59:44 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf 3/4] selftests: bpf: make reuseport test output more legible
Date:   Thu, 23 Jan 2020 16:59:32 +0000
Message-Id: <20200123165934.9584-4-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123165934.9584-1-lmb@cloudflare.com>
References: <20200123165934.9584-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include the name of the mismatching result in human readable format
when reporting an error. The new output looks like the following:

  unexpected result
   result: [1, 0, 0, 0, 0, 0]
  expected: [0, 0, 0, 0, 0, 0]
  mismatch on DROP_ERR_INNER_MAP (bpf_prog_linum:153)
  check_results:FAIL:382

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 .../bpf/prog_tests/select_reuseport.c         | 30 ++++++++++++++++---
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
index 2c37ae7dc214..09a536af139a 100644
--- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
@@ -316,6 +316,28 @@ static void check_data(int type, sa_family_t family, const struct cmd *cmd,
 		       expected.len, result.len, get_linum());
 }
 
+static const char *result_to_str(enum result res)
+{
+	switch (res) {
+	case DROP_ERR_INNER_MAP:
+		return "DROP_ERR_INNER_MAP";
+	case DROP_ERR_SKB_DATA:
+		return "DROP_ERR_SKB_DATA";
+	case DROP_ERR_SK_SELECT_REUSEPORT:
+		return "DROP_ERR_SK_SELECT_REUSEPORT";
+	case DROP_MISC:
+		return "DROP_MISC";
+	case PASS:
+		return "PASS";
+	case PASS_ERR_SK_SELECT_REUSEPORT:
+		return "PASS_ERR_SK_SELECT_REUSEPORT";
+	case NR_RESULTS:
+		return "NR_RESULTS";
+	default:
+		return "UNKNOWN";
+	}
+}
+
 static void check_results(void)
 {
 	__u32 results[NR_RESULTS];
@@ -351,10 +373,10 @@ static void check_results(void)
 		printf(", %u", expected_results[i]);
 	printf("]\n");
 
-	RET_IF(expected_results[broken] != results[broken],
-	       "unexpected result",
-	       "expected_results[%u] != results[%u] bpf_prog_linum:%ld\n",
-	       broken, broken, get_linum());
+	printf("mismatch on %s (bpf_prog_linum:%ld)\n", result_to_str(broken),
+	       get_linum());
+
+	CHECK_FAIL(true);
 }
 
 static int send_data(int type, sa_family_t family, void *data, size_t len,
-- 
2.20.1

