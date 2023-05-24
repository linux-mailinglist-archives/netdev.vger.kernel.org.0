Return-Path: <netdev+bounces-4941-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C128470F4B9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60C97280F9A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B202C8FB;
	Wed, 24 May 2023 11:04:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB20C8F3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:04:09 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9029418D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:04:06 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-309550263e0so642032f8f.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1684926244; x=1687518244;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cmF5KNf0N738Nbepu212yMN+Y0u3tgnIrnQW73JkJ8M=;
        b=GtAi+nziUnYfaM5Z0ECUL9dG8SpxY9alIFvtUteKuQrLzEqPX8QnBx135qgesEG6O9
         z9C4BcGNsCf/vm7vY5kTysixJxU/HqMgvDJVcrqlYeRR7ygeIM/DFOYkbaAYdazy3TWC
         WNVDr92nhfnf4JUxAYkeTDLtc5oaJaUA9RWSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684926244; x=1687518244;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cmF5KNf0N738Nbepu212yMN+Y0u3tgnIrnQW73JkJ8M=;
        b=DFk5C46SJ3H/6qU0MLEMS3J7LBoeo+3xI2gTStXhRgequSnuCAHVZuzeVrWGNUKLj5
         AfsLW6TdYdkqPeSf2DRNL53mJhg/eXplWv6tE5bfFDTQQWRENwOkc0alizCBB2nPfUGc
         33A2N9n1o/Q+YjgmurejNSMkT7DBCIHBQdO+zLnbqocQjVISzHQINF92OWJRTjMd3Fa8
         jvCEi/CirlOg4N7a7TWWPtr/aGzMfbB2R/Ih9DCnp9MWOBQeQN2oNYM3hHdGN8VSeeMp
         D7khq2FQZtQNV9Enzd27/ZbCA5lqw0S2RQGo9oYtAsnXpZN6xNGmfIhD7qK6k/AVhycQ
         O2NQ==
X-Gm-Message-State: AC+VfDzWeI2R56XQKgSSny8fqnFis5dvV0BpR89igLVf2JyoKkYTRd2o
	fdzGaFeUW87NGLxba21A29zDxlEOyZfHvSvzjaOpcA==
X-Google-Smtp-Source: ACHHUZ4TGuJJA6yd80V0+uqsU2zyy1IezTDwuzE2EN8/+wrcLSUogpitMCIR3ZPTncR90ZbGIIYtlQ==
X-Received: by 2002:a05:6000:118b:b0:307:8d6a:a48f with SMTP id g11-20020a056000118b00b003078d6aa48fmr13019301wrx.57.1684926244614;
        Wed, 24 May 2023 04:04:04 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.amarulasolutions.com ([37.159.126.57])
        by smtp.gmail.com with ESMTPSA id a2-20020a5d53c2000000b002ffbf2213d4sm14262297wrw.75.2023.05.24.04.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 04:04:04 -0700 (PDT)
From: Dario Binacchi <dario.binacchi@amarulasolutions.com>
To: netdev@vger.kernel.org
Cc: Michal Kubecek <mkubecek@suse.cz>,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>
Subject: [PATCH ethtool v2] Require a compiler with support for C11 features
Date: Wed, 24 May 2023 13:03:49 +0200
Message-Id: <20230524110349.2983588-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Just like the kernel, which has been using -std=gnu11 for about a year,
we also require a C11 compiler for ethtool.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
---
Changes in v2:
-  Enable support to C11 compiler instead of C++11
---
 configure.ac | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/configure.ac b/configure.ac
index c1e001247138..5735e24927e2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -13,6 +13,15 @@ AC_PROG_GCC_TRADITIONAL
 AM_PROG_CC_C_O
 PKG_PROG_PKG_CONFIG
 
+AC_DEFUN([AX_CHECK_STDC],
+	 [AX_CHECK_COMPILE_FLAG([-std=gnu11],
+		[AX_APPEND_FLAG([-std=gnu11])],
+		[AX_CHECK_COMPILE_FLAG([-std=c11],
+			[AX_APPEND_FLAG([-std=c11])],
+			[AC_MSG_ERROR([$PACKAGE requires a C11 compiler])])
+		])
+	])
+
 dnl Checks for libraries.
 
 dnl Checks for header files.
-- 
2.32.0


