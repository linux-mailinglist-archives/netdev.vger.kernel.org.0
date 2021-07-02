Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1983B9FB2
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 13:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhGBLXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 07:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbhGBLW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 07:22:59 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF270C061762;
        Fri,  2 Jul 2021 04:20:27 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id u14so9190091pga.11;
        Fri, 02 Jul 2021 04:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xl2XQWEJG8begT6rZuY2RmzXT/AoqbtgvUhn3YaKP7M=;
        b=qcTzLh92hj03rlhXIFhZnwtBGfTM/0T0YtunyglUMeoXMjshQFU5LccL5TrrhMMFzo
         /kCTZL+h5rA+hVNOLmA9qSitdHTogXq/dl60f0JssY9n7uUabMZLoNQK+2Uyr1ceqfH8
         b9ct5yAk+lF0C2io2kG3cWuhTkQ34nh3rvIwnoxnv4X5eNpcSgF1DRt+LEZBPnW8t0q/
         7IctqBL1PVVL8y5tsq5iuI6amdaXt+1VACKAyr5RLiVbUtEw2VAech/SFT530zv+21E0
         zuJggkDn/+GKIwotBtB/B+tsa2cbYsMRREJzv13BqQzkXRxFbknTw+HxtcRw/JKt8KG6
         tbQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xl2XQWEJG8begT6rZuY2RmzXT/AoqbtgvUhn3YaKP7M=;
        b=ikXxbIqYNa+gpmTOLqDTtkQ4IeDk1HLHlR+d9cv94Efo7ovcj0FMfkxAH/cY7AYQdz
         kEdbBhPRDJJ3BpgQ1K6icLWxV9Gx3U6GAZC2P2PTbHcVw56KbV6cv2Pq9/fosAP9/PHS
         MP7qZZh9vrMRZQaVzv6SVl92f+MtCyfs9e9szH5nwpD+UCoiDfyWGHFNNp5B3LQ26Aqv
         XDw7UJKSYgXeVkgm8GQpYJhg/y0nABHHO+5AFAy3nWYH5vCXF/gX5K3QLdz+QY0gh3uY
         Exrwyp+UhFkAaFZBtnxHbyPDyCI0Op9m03nsvwZTSrZ+QIAksnjILPClArgzG/8uppnf
         9tgw==
X-Gm-Message-State: AOAM532KTfr68xBFORtBkgUrkN9X6YFJh86Zmdkzfx4C7MgSe+VN34qr
        h3mz4e/1i0S0PT5crnPck7mxYIZE6FY=
X-Google-Smtp-Source: ABdhPJyu/4/S95BlUQEBZLpYPTvZ+JUCewwovtx90/NqzBrsM/4Y6Kj+jckh/VID5GZlVAY7ebe3VA==
X-Received: by 2002:a62:7e8a:0:b029:2f8:183:8aa2 with SMTP id z132-20020a627e8a0000b02902f801838aa2mr4774076pfc.58.1625224827414;
        Fri, 02 Jul 2021 04:20:27 -0700 (PDT)
Received: from localhost ([2409:4063:4d83:c0b5:70cd:e919:ab0c:33ce])
        by smtp.gmail.com with ESMTPSA id j24sm3076690pfe.58.2021.07.02.04.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 04:20:27 -0700 (PDT)
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
        Martin KaFai Lau <kafai@fb.com>,
        Eric Leblond <eric@regit.org>, bpf@vger.kernel.org
Subject: [PATCH net-next v6 2/5] bitops: add non-atomic bitops for pointers
Date:   Fri,  2 Jul 2021 16:48:22 +0530
Message-Id: <20210702111825.491065-3-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210702111825.491065-1-memxor@gmail.com>
References: <20210702111825.491065-1-memxor@gmail.com>
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

