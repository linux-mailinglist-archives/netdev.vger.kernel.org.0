Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCE13B0EC4
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 22:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhFVUdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 16:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhFVUdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 16:33:17 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4EAC061574;
        Tue, 22 Jun 2021 13:31:00 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u18so462348pfk.11;
        Tue, 22 Jun 2021 13:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jivxYGcJYbE7eSkXipGR1sWBMuZY0V3FzEQSe7d96iA=;
        b=AhxZBywa1Rb8izZOPZJBN6vS7pvo0FqkGRFYp2BU+TV8HwB7NB2hvHsu5WyA2Pz9tP
         s2Ugk0d2ooebU0aMpYbDUbrV/V9INpAY5qtQgQ0wzvNwwNpiRepkx/8Lqpq8dgt3Yoch
         999FNohKjOTyVyap/83nrCLhqtDuoewbTOl9UzLz8YhaJ+KgKYAbBp1djp7kazjgBJGm
         6xb/zl2ZaFLyq7+IKmIrZ3ou6zXW8zfiYp0O6J0FDAyN2F2qKfNlwySA0z9PurnzaHoD
         OcUEFUiK6dQ1cH77EzLMZaRESzJyMt36XZ0WqSANmzty8xZiooHI2F7a9Fefy4jxQHUQ
         D6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jivxYGcJYbE7eSkXipGR1sWBMuZY0V3FzEQSe7d96iA=;
        b=rRPKk+ACSqmGb4+A7YHTj9CDr9akheDHtoqogrJLP2v88fi4ibJBb/ZsCORv9PLwMv
         kYt4TPxDhZCUFpJqBVes4OMvtga3+BUGfP7J8MjKabhJ4jFuQG2xe2Q0LJNuRtXy9sDz
         iaeHejhBo9mD1z0HmOCaeERUdrsju84GT7H6ZFZCd5KlJ3D6zIXzp+Lto2VFThd6m+8Q
         bMO0WAifDaRfiqEQuzrWqDUXJbB3rH/mGsH5tfTdQmLVWoAff7vunXEq/om6mWM7rF0j
         EGOnv+fZW87+Lyqw8G622de9EK3eWrgjSXhGGBNfVTmBN4w7LdMZ/tZ4lrw9FXFBfLEC
         xE1A==
X-Gm-Message-State: AOAM533cBeU3aEYpILfcCjxmDwbj+QKFnwkaevo+Jmz7C95LdteuFUs1
        TItcC3O5ijkDq8SRGkzJEw6wEKql6hM=
X-Google-Smtp-Source: ABdhPJwmFFhzJrl5upL+F5lt+MzsNok+YMDyQai0YHQPJj9eTlqcmmZaXaY4wQluwcGezhf/ObeXjw==
X-Received: by 2002:a65:6243:: with SMTP id q3mr414908pgv.297.1624393859999;
        Tue, 22 Jun 2021 13:30:59 -0700 (PDT)
Received: from localhost ([2402:3a80:11bb:33b3:7f0c:3646:8bde:417e])
        by smtp.gmail.com with ESMTPSA id e13sm188164pfd.8.2021.06.22.13.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 13:30:59 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v3 2/5] bitops: add non-atomic bitops for pointers
Date:   Wed, 23 Jun 2021 01:58:32 +0530
Message-Id: <20210622202835.1151230-3-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622202835.1151230-1-memxor@gmail.com>
References: <20210622202835.1151230-1-memxor@gmail.com>
MIME-Version: 1.0
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

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bitops.h    | 19 +++++++++++++++++++
 include/linux/typecheck.h | 10 ++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 26bf15e6cd35..a9e336b9fa4d 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -4,6 +4,7 @@
 
 #include <asm/types.h>
 #include <linux/bits.h>
+#include <linux/typecheck.h>
 
 #include <uapi/linux/kernel.h>
 
@@ -253,6 +254,24 @@ static __always_inline void __assign_bit(long nr, volatile unsigned long *addr,
 		__clear_bit(nr, addr);
 }
 
+#define __ptr_set_bit(nr, addr)                         \
+	({                                              \
+		typecheck_pointer(*(addr));             \
+		__set_bit(nr, (unsigned long *)(addr)); \
+	})
+
+#define __ptr_clear_bit(nr, addr)                         \
+	({                                                \
+		typecheck_pointer(*(addr));               \
+		__clear_bit(nr, (unsigned long *)(addr)); \
+	})
+
+#define __ptr_test_bit(nr, addr)                       \
+	({                                             \
+		typecheck_pointer(*(addr));            \
+		test_bit(nr, (unsigned long *)(addr)); \
+	})
+
 #ifdef __KERNEL__
 
 #ifndef set_mask_bits
diff --git a/include/linux/typecheck.h b/include/linux/typecheck.h
index 20d310331eb5..33c78f27147a 100644
--- a/include/linux/typecheck.h
+++ b/include/linux/typecheck.h
@@ -22,4 +22,14 @@
 	(void)__tmp; \
 })
 
+/*
+ * Check at compile that something is a pointer type.
+ * Always evaluates to 1 so you may use it easily in comparisons.
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

