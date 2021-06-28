Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396733B5D59
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 13:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhF1LwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 07:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbhF1LwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 07:52:14 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6548BC061574;
        Mon, 28 Jun 2021 04:49:48 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id c7-20020a17090ad907b029016faeeab0ccso12662121pjv.4;
        Mon, 28 Jun 2021 04:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bPPAtY/9mAL1oVXyJbWdPc+4zxS5qQL9D261KGv0kyU=;
        b=CuHN1L6iSTzqgLqjBaDNPr6LR4qzO878CqutJZl5gT2a42vWAisNa6SIt8DBJ12hsH
         T2abGf+8iLhfIZOP4pFTx6qSr3a8iiVVb8twUV4HwUGQsb1ZxZCj9HikyYzHSGd0I0Ca
         /Htenh/3Dr2I8mHwxEb0hKFJhT/rGgr2gn+9Eif/XrtM22I1jjjYpkx7JwKUy8hDNoqI
         Zplxw+HKdph6bxHVprtwdwAaTqI2hvsKtjZQMa0BU7mPI2CmVNSv5q0kz9OiyGYfKXHX
         GT16XhwGRkqlyOX3cOIxbamnO3EzA5+CFgUuZisRofU6+vBCyFWQ/mk3IHpPRX/hBSnJ
         CaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bPPAtY/9mAL1oVXyJbWdPc+4zxS5qQL9D261KGv0kyU=;
        b=ikZugQKwjQtZxIhU4lcdvnyFyanGDhBe4hG/ifb98u6Ob+15Gf77qO3G1/8HsCr4Rt
         4ROT3EDDHuHa+0ZB0dd0k+4STzcNzOAh5CjSpuHfKVaVi5mD0fq04wwlWCx7Ubeb+64G
         zQXkbCbYsXdoMI3EebuiD9J+NdmWKLmRuhWD2N4aEWuoBwcWpWoQDj2msydv6luUuShe
         HQk2Wx3IEjwN8HWRwXGGKGKlReZPxnqk0nwYcickyjnze1y7dxC9raz0VjZcL4lXpXUY
         ZkqEczO8qvmcEvX/V8+BDjhrHeIIlbJYWpCOPEiReLO3OXw9LbZ1LzgSkp0H320nZJrR
         pChw==
X-Gm-Message-State: AOAM532KYlhuAlRRP7txNAG5j0PrvtuvjwvFVANxLu8PBGMtu/YYoKpi
        MUi73xDXWlkuRvIITIVgjMY52/viZu4=
X-Google-Smtp-Source: ABdhPJwdIEbUFakx4heNIIqNmklcHwaISV0eUCWWrGa7ZLLfXGmLaTtQXcfkJxzvLp5ZN0H1TJJQ3w==
X-Received: by 2002:a17:903:31d1:b029:120:2863:cba2 with SMTP id v17-20020a17090331d1b02901202863cba2mr22744993ple.28.1624880987854;
        Mon, 28 Jun 2021 04:49:47 -0700 (PDT)
Received: from localhost ([2402:3a80:11da:c590:f80e:952e:84ac:ba3d])
        by smtp.gmail.com with ESMTPSA id o12sm15289543pgq.83.2021.06.28.04.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 04:49:47 -0700 (PDT)
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
Subject: [PATCH net-next v4 2/5] bitops: add non-atomic bitops for pointers
Date:   Mon, 28 Jun 2021 17:17:43 +0530
Message-Id: <20210628114746.129669-3-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210628114746.129669-1-memxor@gmail.com>
References: <20210628114746.129669-1-memxor@gmail.com>
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

