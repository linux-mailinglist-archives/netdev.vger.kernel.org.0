Return-Path: <netdev+bounces-10112-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 422A572C4FE
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:51:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AF7F1C202F2
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA8018AF1;
	Mon, 12 Jun 2023 12:51:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FAF6FBF
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 12:51:24 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521DBE6E
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:51:21 -0700 (PDT)
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id DCC933F378
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 12:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686574279;
	bh=O8zmxTSCOaKjtgaTpZ2khZE2ysWZBc/b8cBiaSfw2F8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=OnHG5EPhtvp6AWT/42tcVXq/8NUx8aTAaG/IvrgbiFbX6gzvMHvk3EAfUgjORN0mY
	 KSedK74mBWSIRWTlNeI020dalw19PGRGpaMouAVq8pNUqriTUtNhg8Jbb+3ZT+K5xA
	 O07TQBFLpZFXiLk3WlTJ52BaCJkw12imM6zSOUCuckGFJieNSSOnyI0gj7glJbwPsa
	 bv+WlXj6nZuKWaWetO0u65/Mo/2+yk+ZjZteRGUJdQOdjS+IZqMuZwITQDpazAoTs0
	 1Dw0p1jnaRGVo+QIfIGzVywzFLrJnsz3itc1FDE9ce9dH+I2nc0eVuehsWgZrN55tV
	 KsNySALjExlew==
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-39c8140b31fso1912881b6e.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:51:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686574278; x=1689166278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O8zmxTSCOaKjtgaTpZ2khZE2ysWZBc/b8cBiaSfw2F8=;
        b=LTt1m8gNfl7ADequeFV0B6NSdb7dOyhb5VedsiHSgV8ZsYr3EtmIjSyYvt4XbUr7WB
         POYmzrLm4LD7Z9WCExfxXdpITPBd1fPpwk1mH+mlhXeaiuuNCltiZU2XNgOEObIp157E
         gyKOuI4TuktfF7kwYzBW6L5ucnumsUI/NKkCSkjDyy8u0gjkUti78BJl28hNmk8hqcdd
         FgxAG/UvRVTlFwbirKMqeU03GhH1q+Kf/G23iBCydWyrKfnY+cMgcg4MM2Sn0b7pCP40
         1eToIVpznZXisuNYSOKILjyzk7uQvhXRVEYCIQz2o+i5nygXWwrt8F6i2ulJT1ee8VqL
         YpYw==
X-Gm-Message-State: AC+VfDyMKnCiWD59nFhFxj0doNgcbNva0FTKEEUXFiXL8p0T5igw38H/
	Fyk0MIUDQr5hkE9r2d5I2snPJguI1C5w6vAyFT8IEaw/XBnOSwFAF/R81gumfmHSr/t7O7sZ9/z
	nhhcUUCZ79XgsgSmcPN5pxiExxgJ7xaVLm+M5R3SHEw==
X-Received: by 2002:a05:6808:180a:b0:38d:e632:8302 with SMTP id bh10-20020a056808180a00b0038de6328302mr4438186oib.14.1686574278443;
        Mon, 12 Jun 2023 05:51:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4bXJz8c6+3Q90Xf645kavYrySdHcaMtT3/DVP52hnwOajDgXzOYVKMWIdlFPQRcNX1ME/Y3g==
X-Received: by 2002:a05:6808:180a:b0:38d:e632:8302 with SMTP id bh10-20020a056808180a00b0038de6328302mr4438174oib.14.1686574278223;
        Mon, 12 Jun 2023 05:51:18 -0700 (PDT)
Received: from magali.. ([2804:14c:bbe3:4606:d612:b95d:6bdc:8f6d])
        by smtp.gmail.com with ESMTPSA id j22-20020a4ad196000000b00529cc3986c8sm3157193oor.40.2023.06.12.05.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 05:51:17 -0700 (PDT)
From: Magali Lemes <magali.lemes@canonical.com>
To: keescook@chromium.org,
	shuah@kernel.org
Cc: andrei.gherzan@canonical.com,
	netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] selftests/harness: allow tests to be skipped during setup
Date: Mon, 12 Jun 2023 09:51:04 -0300
Message-Id: <20230612125107.73795-2-magali.lemes@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230612125107.73795-1-magali.lemes@canonical.com>
References: <20230612125107.73795-1-magali.lemes@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Before executing each test from a fixture, FIXTURE_SETUP is run once.
When SKIP is used in FIXTURE_SETUP, the setup function returns early
but the test still proceeds to run, unless another SKIP macro is used
within the test definition, leading to some code repetition. Therefore,
allow tests to be skipped directly from the setup function.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
---
Changes in v3:
 - Add this patch.

 tools/testing/selftests/kselftest_harness.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index d8bff2005dfc..5fd49ad0c696 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -249,7 +249,7 @@
 
 /**
  * FIXTURE_SETUP() - Prepares the setup function for the fixture.
- * *_metadata* is included so that EXPECT_* and ASSERT_* work correctly.
+ * *_metadata* is included so that EXPECT_*, ASSERT_* etc. work correctly.
  *
  * @fixture_name: fixture name
  *
@@ -275,7 +275,7 @@
 
 /**
  * FIXTURE_TEARDOWN()
- * *_metadata* is included so that EXPECT_* and ASSERT_* work correctly.
+ * *_metadata* is included so that EXPECT_*, ASSERT_* etc. work correctly.
  *
  * @fixture_name: fixture name
  *
@@ -388,7 +388,7 @@
 		if (setjmp(_metadata->env) == 0) { \
 			fixture_name##_setup(_metadata, &self, variant->data); \
 			/* Let setup failure terminate early. */ \
-			if (!_metadata->passed) \
+                       if (!_metadata->passed || _metadata->skip) \
 				return; \
 			_metadata->setup_completed = true; \
 			fixture_name##_##test_name(_metadata, &self, variant->data); \
-- 
2.34.1


