Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D6055AAAB
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 15:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiFYNzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 09:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbiFYNzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 09:55:13 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAE912ACB;
        Sat, 25 Jun 2022 06:55:12 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so8207440pjl.5;
        Sat, 25 Jun 2022 06:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rq85kfN+kIsKSpiVIlYRgY/oRH6pyH6elOkY0pr17X8=;
        b=hgfxS3V4J1iXv9Nrh0fcvKWIa/amBW6X3fvUiBLLphkpMJt9wcgDSWULqm7GP/0GaP
         6aSfy+jSCZ9j4WZexZhFObM3rwxX5lPJsFFZN076vmGQmL5F6VIzmzoUAY8rY6KRMSjv
         R6ZhugXIa6LdfrPlfK9JaOa2U5bXh812sAwaUmgup8SDolYUTYEo+70VZvtcrFnSuFxi
         04ypGDWM//+TRLLtFoEyutvFarER9RIv67xr7XYhJR1OgU+hLOJ0DxkN7EHu9Um5lj4r
         KISANjryYyHsprldO94mdBahgWp9ATn+ceH0x3vcFmnINanU50nMhQKDvWs4Phh9vN1z
         vACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rq85kfN+kIsKSpiVIlYRgY/oRH6pyH6elOkY0pr17X8=;
        b=c3BqLgFuxZZMw9oiFdXnxOq94AIpSgYY+Uq/0Q9+iyQu48R73HEQw0SdauQLRE2uPp
         l8t9xoBerbSeeFwWeAgtVYRxaUx/RPuTIwduZ/fcMIfSSiTNI7u4hDTTG3VBSkSsZv/t
         u3tVNNeo04X+wOcA3bEOCC36Oo37sCpsHhCm4NUOyY/MQoX+Kn9JonAa1+fzwVcq5E/b
         43pHqipRCzes0+ufSjx9m5G/UKvTtqdesGerN3vaOXaa/pknTTNY+xY4SD19MwZ5kD2i
         f31EAAuD8fBAVeEgc4/3IQ8CRFmSMqLApfV15c0MkCCbiOtUUDXauctbNaTcJUJQnbxF
         5GuQ==
X-Gm-Message-State: AJIora+pbcv8zYS//Ob9o9VRZFPxb2ZpETPkGAoJmMXmQ80q/w0v9w3M
        ffP4dUwDG8bUUVBILO0yVwM56TA2k2nj588P
X-Google-Smtp-Source: AGRyM1tHN1gbZ2yVQGHra6qT4FiOfTNe6GbslEsaiCOvnvsi/mWa+4LCop/8sCB+fYivYjFqNJC8HQ==
X-Received: by 2002:a17:90b:3a8f:b0:1ec:93d4:f955 with SMTP id om15-20020a17090b3a8f00b001ec93d4f955mr9909343pjb.23.1656165311419;
        Sat, 25 Jun 2022 06:55:11 -0700 (PDT)
Received: from fedora.. ([2409:4042:261d:8029:35f0:415b:b9b4:3fcb])
        by smtp.gmail.com with ESMTPSA id a4-20020a170902710400b00162037fbb68sm3708733pll.215.2022.06.25.06.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 06:55:10 -0700 (PDT)
From:   Gautam <gautammenghani201@gmail.com>
To:     shuah@kernel.org, brauner@kernel.org, keescook@chromium.org
Cc:     Gautam <gautammenghani201@gmail.com>, kafai@fb.com,
        songliubraving@fb.com, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH] kselftests: Enable the echo command to print newlines in Makefile
Date:   Sat, 25 Jun 2022 19:24:55 +0530
Message-Id: <20220625135455.167939-1-gautammenghani201@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the install section of the main Makefile of kselftests, the echo
command is used with -n flag, which disables the printing of new line
due to which the output contains "\n" chars as follows:

  Emit Tests for alsa\nSkipping non-existent dir: arm64
  Emit Tests for breakpoints\nEmit Tests for capabilities\n

This patch fixes the above bug by using the -e flag.

Signed-off-by: Gautam <gautammenghani201@gmail.com>
---
 tools/testing/selftests/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index de11992dc577..52e31437f1a3 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -253,7 +253,7 @@ ifdef INSTALL_PATH
 	for TARGET in $(TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
 		[ ! -d $(INSTALL_PATH)/$$TARGET ] && echo "Skipping non-existent dir: $$TARGET" && continue; \
-		echo -n "Emit Tests for $$TARGET\n"; \
+		echo -ne "Emit Tests for $$TARGET\n"; \
 		$(MAKE) -s --no-print-directory OUTPUT=$$BUILD_TARGET COLLECTION=$$TARGET \
 			-C $$TARGET emit_tests >> $(TEST_LIST); \
 	done;
-- 
2.36.1

