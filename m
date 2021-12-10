Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6909047074B
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241476AbhLJRhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244460AbhLJRhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:37:15 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F91C061D7E
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:33:35 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso10280660otf.12
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ol2LYejDODLNDCE9czeVtY6ZXvOj8cq9Dfk6NPWHsZY=;
        b=HBUNCaPvhfUaNQMquE8OUfIRrgmyX82ibPWw02Ng8pu7UyIZi6ZN6ze3wHpalVRLq8
         CruwY2I6pMfj2zKyYebS6zyfpAu0zAI0d0VcLZdnKAbaQdFIPrJT+/hLE+aMawAK6euu
         TsIJst1MmQSizYM3Y4pSmGaUHMkpUbyfEJ0k0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ol2LYejDODLNDCE9czeVtY6ZXvOj8cq9Dfk6NPWHsZY=;
        b=GGvEDOeHtouxombCZrpRSSDg9gySMoN/EfXZcbB+RbkwUPK7nqlOS5BU3WayoksaNt
         yh6HbjCQX0kviYp4iGIQ/BcZzXEBIaI1jSqtN5X7DUyFDpN5PzC3mq80ijpPcD/kfMxR
         bMKvRP92aAZkejE9gHlMY15U36kBRl0UmOCghDITKrJJ96b83Ol1roCqySLQIbxP0atm
         Q0bNMk6IMwdKFizftxgM6Mr0WAUpk1J7izJCz75qpJdyxuFegB4DIv1oRxbqVKBuI5wy
         N/c9X+BSrqunkthZrFjAFXS73vfv05qTmVnvKGILGqg+VR6x5p52OmA+2fJkOxqYpvi4
         SssQ==
X-Gm-Message-State: AOAM532A3OVG+tht27uz5LYoXu1xY3Cu4cGHyOAdwhOnshtQvqgC5Ngt
        tMHFBns5tRz9OPhUcoiQodVwEw==
X-Google-Smtp-Source: ABdhPJwC08jHpPh4Q3noN8ttIxOYmu22m0CTuK9V/wHlRnKrp4RkdnmVkknN/jUdmXkq6G6Ycz5roA==
X-Received: by 2002:a05:6830:3094:: with SMTP id f20mr12233166ots.201.1639157614456;
        Fri, 10 Dec 2021 09:33:34 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x4sm892224oiv.35.2021.12.10.09.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 09:33:34 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
        keescook@chromium.org, mic@digikod.net, davem@davemloft.net,
        kuba@kernel.org, peterz@infradead.org, paulmck@kernel.org,
        boqun.feng@gmail.com, akpm@linux-foundation.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 09/12] selftests/seccomp: remove ARRAY_SIZE define from seccomp_benchmark
Date:   Fri, 10 Dec 2021 10:33:19 -0700
Message-Id: <80fa7078e0645649b6e31be4844a3cffbe67a79b.1639156389.git.skhan@linuxfoundation.org>
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

Remove ARRAY_SIZE from seccomp_benchmark and pickup the one defined in
kselftest.h.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/seccomp/seccomp_benchmark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_benchmark.c b/tools/testing/selftests/seccomp/seccomp_benchmark.c
index 6e5102a7d7c9..5b5c9d558dee 100644
--- a/tools/testing/selftests/seccomp/seccomp_benchmark.c
+++ b/tools/testing/selftests/seccomp/seccomp_benchmark.c
@@ -18,7 +18,7 @@
 #include <sys/syscall.h>
 #include <sys/types.h>
 
-#define ARRAY_SIZE(a)    (sizeof(a) / sizeof(a[0]))
+#include "../kselftest.h"
 
 unsigned long long timing(clockid_t clk_id, unsigned long long samples)
 {
-- 
2.32.0

