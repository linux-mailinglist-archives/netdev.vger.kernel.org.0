Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECDC470742
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241390AbhLJRhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244759AbhLJRhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:37:05 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A705C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:33:30 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso10345037otr.2
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NDgcHDpgiGWK9Ew3NHUhEO9yqNh1ILLLayqUXO2p75w=;
        b=RBvRuhdbY7g+jhhycOa6s6AnQRPB9u+jMTQAdWAGcbZry4Gs71DzkZXrtyFNlzrjYb
         t6cYRkjUJNJA0VqVa9VD5NUujJb9jkn5OXNmdw0ZBi1zYANnBFWUCoJvVfZtk5h4sJn1
         eqbzyIxoNgJ2evkyeFqyx5i3WODR+TVyV1f2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NDgcHDpgiGWK9Ew3NHUhEO9yqNh1ILLLayqUXO2p75w=;
        b=w0RGwci8qn75eXOaxUL6A273yNF0PQIMP4BuCZwN+pIBo8C6+NAZgtO+VELt/ZeQRO
         RL2l+rCFwu37z/LQilAfSFsci0cfF9/zTuNGNAdlfvFXjvum+GY7v+yH6x8qwSJ2UU5P
         i205J5nuGb1jGnoObm2jn1DVtHhqk752bRCCsxQdYld5S7mGya9mgmtQM2LegztbVBAo
         zNYDy6BOGdGgQgBtGVDjQz8VNHagF/aAeUDehLDu3JGPTxx+/J9/AYntpnvUlYp1D7v8
         UDBYSd1t4kiemaOo/ji0lizCNiYR1m3vI7+u3uqHGHwCuV1YQdMSdlms065Cij+IUTJj
         /qfw==
X-Gm-Message-State: AOAM531/Omxeur6ef5v774IJEax2YyTCC71qT6lod+4tEsYniknYrEBQ
        v6EJed4ul0LgyPCIxWA12oRqew==
X-Google-Smtp-Source: ABdhPJyA4yaTBTIyZO1xnTM+/bAUFXSJizFV+09oAtmwLgPNp33uTLG6kCjRdELfrCYBpviWIZftqA==
X-Received: by 2002:a05:6830:118a:: with SMTP id u10mr11939448otq.194.1639157609588;
        Fri, 10 Dec 2021 09:33:29 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x4sm892224oiv.35.2021.12.10.09.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 09:33:29 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
        keescook@chromium.org, mic@digikod.net, davem@davemloft.net,
        kuba@kernel.org, peterz@infradead.org, paulmck@kernel.org,
        boqun.feng@gmail.com, akpm@linux-foundation.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 04/12] selftests/core: remove ARRAY_SIZE define from close_range_test.c
Date:   Fri, 10 Dec 2021 10:33:14 -0700
Message-Id: <0b20692e28c83822bb6b56518791371120582d0e.1639156389.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1639156389.git.skhan@linuxfoundation.org>
References: <cover.1639156389.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ARRAY_SIZE is defined in several selftests. Remove definitions from
individual test files and include header file for the define instead.
ARRAY_SIZE define is added in a separate patch to prepare for this
change.

Remove ARRAY_SIZE from close_range_test.c and pickup the one defined
in kselftest.h.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/core/close_range_test.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/testing/selftests/core/close_range_test.c b/tools/testing/selftests/core/close_range_test.c
index aa7d13d91963..749239930ca8 100644
--- a/tools/testing/selftests/core/close_range_test.c
+++ b/tools/testing/selftests/core/close_range_test.c
@@ -50,10 +50,6 @@ static inline int sys_close_range(unsigned int fd, unsigned int max_fd,
 	return syscall(__NR_close_range, fd, max_fd, flags);
 }
 
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-#endif
-
 TEST(core_close_range)
 {
 	int i, ret;
-- 
2.32.0

