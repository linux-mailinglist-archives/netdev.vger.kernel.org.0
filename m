Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CB6470753
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244490AbhLJRhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244520AbhLJRhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:37:16 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574B2C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:33:38 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso10335142ota.5
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z8DvdE8cQs/ahPWAnUud5n5yToq2pjtImEbhrWCSKj4=;
        b=A2U4egVLtJIpoFQ30tstUVGzUGtOmsoHZ0xs8fseV5579Sz4E00j5WbNj12yVBrh10
         gBjWd+OSjLozqsC67VnD+TKT5lsMslmI9Dan2YNX0NvXY97ryAY1BHSC/uJesx1iBcpC
         Pd1bwFa6CQTZ3aeMIGkPxRo3I016VxH2gMgzU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z8DvdE8cQs/ahPWAnUud5n5yToq2pjtImEbhrWCSKj4=;
        b=7wQSxg+LjMES+Q4MfoGjJEHdV1N+otnAlMMMkDW2V2X7aKbGBxHZR9hnhxwnJrWP2R
         M+Er+IOEpoUo0JYpA1RA5PpaQLZ1ZhRdMDFD1y51/g5qIVyqZdQGVtWkOYtfEVuUBu3j
         +Xa/luhMutUorKoP41yJ8c/YgSj50qbVYsWSraazctTRdru3foRgOvVZDFp7j+CkTGf4
         7pG6GJgGKvGVOsf+MjYylTPYyM00tMHIvspOzfdQqx5ffHXA3WKigfgAltNXR1XBosAJ
         R80r1zXwStYHMgrk5kq/2DWdlM6R4fJ6pWX6X0H0wwlLV+dIFIMC2q83cD1hYvs7/i1U
         Kp3g==
X-Gm-Message-State: AOAM533Eyv+QDq0koZc+M/wJUkt4BH539GQcihVjRiU8AVm27v2aov3c
        XyxQhkeZeI1Y4lMGAAVVF5W2sg==
X-Google-Smtp-Source: ABdhPJw/EV9rFIsA/Y2l9EL9YhWZjVYVklXozZh2QN5jLKH28l9K6PLS2YIbrdvs6ptrFP99TR5idg==
X-Received: by 2002:a05:6830:1216:: with SMTP id r22mr12680706otp.10.1639157617637;
        Fri, 10 Dec 2021 09:33:37 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x4sm892224oiv.35.2021.12.10.09.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 09:33:37 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
        keescook@chromium.org, mic@digikod.net, davem@davemloft.net,
        kuba@kernel.org, peterz@infradead.org, paulmck@kernel.org,
        boqun.feng@gmail.com, akpm@linux-foundation.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 12/12] selftests/vm: remove ARRAY_SIZE define from individual tests
Date:   Fri, 10 Dec 2021 10:33:22 -0700
Message-Id: <18321f68b399cd2c2709131d6d6eb1d0f58e8b4f.1639156389.git.skhan@linuxfoundation.org>
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

Remove ARRAY_SIZE from vm tests and pickup the one defined in
kselftest.h.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/vm/mremap_test.c    | 1 -
 tools/testing/selftests/vm/pkey-helpers.h   | 3 ++-
 tools/testing/selftests/vm/va_128TBswitch.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vm/mremap_test.c b/tools/testing/selftests/vm/mremap_test.c
index 0624d1bd71b5..7c0b0617b9f8 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -20,7 +20,6 @@
 #define VALIDATION_DEFAULT_THRESHOLD 4	/* 4MB */
 #define VALIDATION_NO_THRESHOLD 0	/* Verify the entire region */
 
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 #define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
 
 struct config {
diff --git a/tools/testing/selftests/vm/pkey-helpers.h b/tools/testing/selftests/vm/pkey-helpers.h
index 622a85848f61..92f3be3dd8e5 100644
--- a/tools/testing/selftests/vm/pkey-helpers.h
+++ b/tools/testing/selftests/vm/pkey-helpers.h
@@ -13,6 +13,8 @@
 #include <ucontext.h>
 #include <sys/mman.h>
 
+#include "../kselftest.h"
+
 /* Define some kernel-like types */
 #define  u8 __u8
 #define u16 __u16
@@ -175,7 +177,6 @@ static inline void __pkey_write_allow(int pkey, int do_allow_write)
 	dprintf4("pkey_reg now: %016llx\n", read_pkey_reg());
 }
 
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
 #define ALIGN_UP(x, align_to)	(((x) + ((align_to)-1)) & ~((align_to)-1))
 #define ALIGN_DOWN(x, align_to) ((x) & ~((align_to)-1))
 #define ALIGN_PTR_UP(p, ptr_align_to)	\
diff --git a/tools/testing/selftests/vm/va_128TBswitch.c b/tools/testing/selftests/vm/va_128TBswitch.c
index 83acdff26a13..da6ec3b53ea8 100644
--- a/tools/testing/selftests/vm/va_128TBswitch.c
+++ b/tools/testing/selftests/vm/va_128TBswitch.c
@@ -9,7 +9,7 @@
 #include <sys/mman.h>
 #include <string.h>
 
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+#include "../kselftest.h"
 
 #ifdef __powerpc64__
 #define PAGE_SIZE	(64 << 10)
-- 
2.32.0

