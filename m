Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8B43D8037
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhG0VAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbhG0U7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:59:47 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664A4C0619D4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:13 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a4-20020a17090aa504b0290176a0d2b67aso6632916pjq.2
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VM7uWZbkUfYnHDd5ZNIAVnDbZvywZy43PN6h2gF7C7c=;
        b=oBkhd6x8PpRaO8QoO+UEqARpklYQ85EbQwaaqZSpUTzsIkrs1pGiuH526VcUurLUkS
         +gkvSbxFz3vGB1BF1YQeauyWi9ev8hnzhng3t5uiTcBEZberDOU2lSJPBM+aa6yDkfTe
         HmjxMNfk6GT/foIn5FNaX7+ENNmF5UhcQ22mM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VM7uWZbkUfYnHDd5ZNIAVnDbZvywZy43PN6h2gF7C7c=;
        b=guzmmP048PPjonkKTT+tRAjmGMYWSKGlJ2pwWPm/XV3NI9KQIA8BslMDXCs9tFLK/e
         1uhrZCML5+T2dn8VQSRwBnDBMkFh7YebqyaT5glJp7tCjvaQsnflXYwJ0gPcoGafGjVM
         zIADRtAwXlyEyhK148fHn3HaToHCYZdkpRPo6LxauKuwDma7DLQfJR/GXvi0Q8oXS4LY
         qQVwjXCaL+zD/A4+bYNZHw5TnkLOFVRxWc3g3XdqVWQNkC3B6+fxNikQFkHj+yfsdRyF
         CxiRxyiNRsznfs/RBJp9c1e3P6SUjkpGJ5xZDZiL9e3Xdtx+OfzxLHDBShcD2EcTIbzU
         8DqQ==
X-Gm-Message-State: AOAM532+TrwB5vvKyzRcQ3JHv4O81/tgyPxpACHoURQRySQeVeOi5157
        NoN90Ck9p+Qm5gTBRMZRDuJSfg==
X-Google-Smtp-Source: ABdhPJzvwIujwX2h82eYkbdvoMbJ+ZJVnzoCXczVsCM4H67j0yiuDjVnUU+OKLLA11yr/7OVmcSq6g==
X-Received: by 2002:a63:b4d:: with SMTP id a13mr22272005pgl.404.1627419552873;
        Tue, 27 Jul 2021 13:59:12 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e23sm3796816pjt.8.2021.07.27.13.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:09 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 28/64] compiler_types.h: Remove __compiletime_object_size()
Date:   Tue, 27 Jul 2021 13:58:19 -0700
Message-Id: <20210727205855.411487-29-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2278; h=from:subject; bh=26+UkQF9u4QR73rE2ugmnkAtGgRJVqdRH0gVQ+miGJI=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOGx79zwuZNTkBGJbxUTLtc6LvVjffViSXdghqh ZCh8w1mJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzhgAKCRCJcvTf3G3AJoOuD/ 9QhIBj8Ac1dYCQqsKDnl8+GV1Fmwz5NE+vrrmgysyx4iAIh5Hi9gSJVcciJHuWfxsYbsfjbgYy0kX1 fb3zQvUIkMQIB2igKikLexaw/u/aMZvCk9Z5omDCckYav5xDMDxop57SAnRwDmI5ma37g307rYAPXK 3MKhIW4uQWUEg9VD//gprsbS2OpIiwxkghySrauZU6lUWDXOFDxi3e7AnfeRnLBMm5P9R7uYb1c63i CCLVixc36sEWt5n1A3nVhugbXoR7XhzcCKsn6dHqVUwhOr0WC1NiDHg09PcpuJ/iyIKZftDHqUPqg6 5qiwdJ4fNBuagx0+hD1UYhVyC4D8uCcU5JbpSaMhqA5ruisKG07SgLC2mW64QD5KC1l5vxwssi27Ef 7z6+Z9XE9eAIUfHNMPoPePEDUngERmhsvmWGVOt9xejvTsuIr7a0dLku55mNRDgPOr3kKzwatg+19w b9l9CzMUNItXijvnyBQc/Vqy1SAb0lYpmUGz8MBzs95DcaaAGbaZmpWiUWaHQ5s823F8qG3r/1SSM/ zjI2/ycPgCzFufboCXRAyrLfLL7g8dxi7bDg8lAiPKcigIIGX0UbyaLeH8fulCViw1XPIwojOh5Gqh 6Oqz9uM0LoNmL8ecwuaSepH7hTO/bHW05UdooSY1mofMkUQTUBDoMmiCWncw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since all compilers support __builtin_object_size(), and there is only
one user of __compiletime_object_size, remove it to avoid the needless
indirection. This lets Clang reason about check_copy_size() correctly.

Link: https://github.com/ClangBuiltLinux/linux/issues/1179
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/compiler-gcc.h   | 2 --
 include/linux/compiler_types.h | 4 ----
 include/linux/thread_info.h    | 2 +-
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index cb9217fc60af..01985821944b 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -41,8 +41,6 @@
 
 #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
 
-#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
-
 #define __compiletime_warning(message) __attribute__((__warning__(message)))
 #define __compiletime_error(message) __attribute__((__error__(message)))
 
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index e4ea86fc584d..c43308b0a9a9 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -290,10 +290,6 @@ struct ftrace_likely_data {
 	(sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || \
 	 sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
 
-/* Compile time object size, -1 for unknown */
-#ifndef __compiletime_object_size
-# define __compiletime_object_size(obj) -1
-#endif
 #ifndef __compiletime_warning
 # define __compiletime_warning(message)
 #endif
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 0999f6317978..ad0c4e041030 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -203,7 +203,7 @@ static inline void copy_overflow(int size, unsigned long count)
 static __always_inline __must_check bool
 check_copy_size(const void *addr, size_t bytes, bool is_source)
 {
-	int sz = __compiletime_object_size(addr);
+	int sz = __builtin_object_size(addr, 0);
 	if (unlikely(sz >= 0 && sz < bytes)) {
 		if (!__builtin_constant_p(bytes))
 			copy_overflow(sz, bytes);
-- 
2.30.2

