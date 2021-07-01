Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998C73B8B48
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 02:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbhGAAce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 20:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238132AbhGAAcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 20:32:33 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCFFC061756;
        Wed, 30 Jun 2021 17:30:03 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m26so4413034pgb.8;
        Wed, 30 Jun 2021 17:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xl2XQWEJG8begT6rZuY2RmzXT/AoqbtgvUhn3YaKP7M=;
        b=tSee+xMkrX2NUt3ddxNLUclWxPk59Tcck5SDe+FxXdhg/iOwIPxHHSfIYDjN4osP1o
         Simf3pFkkl/dpKWgrrklUkvAFZB6bmi66Lp+HA9r9SNqDJGPAG86A4RztOzez4CHn7Ni
         J5tXHlyDuFuAlH06zrQgE9wELzZ+a0SjdIkkUTrS0yht5e4w55l+taGR4ml5WGls83F4
         BOZXiIrCa+WJt5XniSvp9ME2SC0qPpI/S9VWLNjjcIt2cz0mWjqXoxeahxtJU2CzN5Wt
         KGMlqgJMGaQHXiqJc8FzhALepPhISk/u66qmC9hKJvk89UEY4XLeRe5txSBYUP+0r4F0
         TQSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xl2XQWEJG8begT6rZuY2RmzXT/AoqbtgvUhn3YaKP7M=;
        b=PFxirul5rmKpHRTU0LJamV7IrnddFcAz6VMNPre+vdaV8BdnA4aANiM9QouqNFmh61
         Gmz8qkI2KliVxeyQfpGHm+uBRPRiuD3BJw/Xx3zrbJq04TKOlYieQfZO4vC//k73rKjN
         FjulgnmKi5rLs5kRfk2wgrUdbgy+C0/Wg2/f3y1UIzV626JACicE67EOMeH20uCPXLjc
         EqvXfz6CZu9Sj79io51MIjktS8BZDU7E77NQXl0xA9KdokI1PQpkvp5RJ7RGlwPv58yE
         o6wp4hzhpsEYYic8boOCcwUCZVFSRWUlqEJJxD4XCztKLIXKZcnfjEnKFAU1PAP9EHWX
         XHIw==
X-Gm-Message-State: AOAM53136329mJKpm7Q3Ae2JMstzkvMYLWypPvjxdbxAW5q/Li2P0Wta
        AQBBCzQSjHmIv/aEgFlZ1SH9nBMXG+g=
X-Google-Smtp-Source: ABdhPJySSxKosOvXkh5kMgVHhl5e5dghTSrFVcDO3nSRbPBb8W6Qe2d5J6GsjEy0hquA/3BIzCr3oA==
X-Received: by 2002:a63:4719:: with SMTP id u25mr37126833pga.193.1625099403322;
        Wed, 30 Jun 2021 17:30:03 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:6f6:e6a8:37a6:1da7:fbc7])
        by smtp.gmail.com with ESMTPSA id u24sm23741144pfm.200.2021.06.30.17.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 17:30:03 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v5 2/5] bitops: add non-atomic bitops for pointers
Date:   Thu,  1 Jul 2021 05:57:56 +0530
Message-Id: <20210701002759.381983-3-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210701002759.381983-1-memxor@gmail.com>
References: <20210701002759.381983-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cpumap needs to set, clear, and test the lowest bit in skb pointer in
various places. To make these checks less noisy, add pointer friendly
bitop macros that also do some typechecking to sanitize the argument.

These wrap the non-atomic bitops __set_bit, __clear_bit, and test_bit
but for pointer arguments. Pointer's address has to be passed in and it
is treated as an unsigned long *, since width and representation of
pointer and unsigned long match on targets Linux supports. They are
prefixed with double underscore to indicate lack of atomicity.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bitops.h    | 50 +++++++++++++++++++++++++++++++++++++++
 include/linux/typecheck.h |  9 +++++++
 2 files changed, 59 insertions(+)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 26bf15e6cd35..5e62e2383b7f 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -4,6 +4,7 @@
 
 #include <asm/types.h>
 #include <linux/bits.h>
+#include <linux/typecheck.h>
 
 #include <uapi/linux/kernel.h>
 
@@ -253,6 +254,55 @@ static __always_inline void __assign_bit(long nr, volatile unsigned long *addr,
 		__clear_bit(nr, addr);
 }
 
+/**
+ * __ptr_set_bit - Set bit in a pointer's value
+ * @nr: the bit to set
+ * @addr: the address of the pointer variable
+ *
+ * Example:
+ *	void *p = foo();
+ *	__ptr_set_bit(bit, &p);
+ */
+#define __ptr_set_bit(nr, addr)                         \
+	({                                              \
+		typecheck_pointer(*(addr));             \
+		__set_bit(nr, (unsigned long *)(addr)); \
+	})
+
+/**
+ * __ptr_clear_bit - Clear bit in a pointer's value
+ * @nr: the bit to clear
+ * @addr: the address of the pointer variable
+ *
+ * Example:
+ *	void *p = foo();
+ *	__ptr_clear_bit(bit, &p);
+ */
+#define __ptr_clear_bit(nr, addr)                         \
+	({                                                \
+		typecheck_pointer(*(addr));               \
+		__clear_bit(nr, (unsigned long *)(addr)); \
+	})
+
+/**
+ * __ptr_test_bit - Test bit in a pointer's value
+ * @nr: the bit to test
+ * @addr: the address of the pointer variable
+ *
+ * Example:
+ *	void *p = foo();
+ *	if (__ptr_test_bit(bit, &p)) {
+ *	        ...
+ *	} else {
+ *		...
+ *	}
+ */
+#define __ptr_test_bit(nr, addr)                       \
+	({                                             \
+		typecheck_pointer(*(addr));            \
+		test_bit(nr, (unsigned long *)(addr)); \
+	})
+
 #ifdef __KERNEL__
 
 #ifndef set_mask_bits
diff --git a/include/linux/typecheck.h b/include/linux/typecheck.h
index 20d310331eb5..46b15e2aaefb 100644
--- a/include/linux/typecheck.h
+++ b/include/linux/typecheck.h
@@ -22,4 +22,13 @@
 	(void)__tmp; \
 })
 
+/*
+ * Check at compile time that something is a pointer type.
+ */
+#define typecheck_pointer(x) \
+({	typeof(x) __dummy; \
+	(void)sizeof(*__dummy); \
+	1; \
+})
+
 #endif		/* TYPECHECK_H_INCLUDED */
-- 
2.31.1

