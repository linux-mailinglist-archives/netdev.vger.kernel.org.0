Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFB8333704
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhCJIKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbhCJIJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 03:09:38 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F09C06174A;
        Wed, 10 Mar 2021 00:09:37 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id v2so18952611lft.9;
        Wed, 10 Mar 2021 00:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BE9RCcaNGpshX4iYJfUpPreL/M/EC4I0fqj7I0+J8sA=;
        b=MHNTloGfVJlEqOjkFM3mJUUJqWUYKTYgInWP6FoqqHdaDRuuQUIRT4W0zOYpaPFfV2
         a+GjQyoCjwijYLn5RJJXpOYcQG+YPV5vLc2wehWmzpQ4V2+EQVys2k84hg1JCCbZf+7s
         P/3j8ZtcowAZ+arlsEs6GbuATNz2KkUmvz7pW6SNUogvMKThHmVDfFzIvQnfvxax0Y2U
         sgdkhkALc3BSICzF/Ggtsm4yjwC5lL7u6qs+DiHV9h5m+0OlsGbiukYr9Uce5C46eTdW
         hrpnpJXPyY7Ik6LPGCEwGi6/4lkbxjRe5ymPp+4V3xYe+NgICf422qDGhIWMK5M3zDQL
         5v9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BE9RCcaNGpshX4iYJfUpPreL/M/EC4I0fqj7I0+J8sA=;
        b=I1qxxQHdnzbiU22DFpL3drWI+4bWRpN17H4MI8zDtewO6PxRQO4++rq8WzZlW4eSV9
         jcW8TJ11OFpZyzMn6tt3kAKWk2o9NevMVWKg85gLFrCC15vZVAdcfiRqzW3u6+nMz9G7
         wcgRS/yGl0DY+BlCN5RZalHyM28pp0MOdeGgRuUJ2NkKNpL5844is21g9BhBum6i74db
         Q8zwvFGaHmnxQZm0gS6KId9xBjIHJmKiS9sE9VHj7LsSCIVW/0OK40jUMHXkxPLuCM+O
         VthsjNoPc6bCKmasJ/WM3zOJ9Sp38R1iUNkkjS/Gqc3s1MaSGXVH6TPGcddyzfGaseqF
         xl5g==
X-Gm-Message-State: AOAM5310K93LytNOyfIr7YUB4ib9EJRzTNcYIBc0sFiEDhNysFK4hbY5
        NeWrGpU4rZbHpV8lqkvAWMpN9WN3sRxl9Q==
X-Google-Smtp-Source: ABdhPJzMIVpbe2ctzEfXuhNKjkrdkN/JoRxzNtFsP99pEd1VOrUkrBFPVvOOS0dZvAMbmROEC1c2dQ==
X-Received: by 2002:a05:6512:224f:: with SMTP id i15mr1367987lfu.545.1615363776359;
        Wed, 10 Mar 2021 00:09:36 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id x1sm2812130ljh.62.2021.03.10.00.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 00:09:35 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, andrii@kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, ciara.loftus@intel.com
Subject: [PATCH bpf-next 1/2] libbpf: xsk: remove linux/compiler.h header
Date:   Wed, 10 Mar 2021 09:09:28 +0100
Message-Id: <20210310080929.641212-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210310080929.641212-1-bjorn.topel@gmail.com>
References: <20210310080929.641212-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

In commit 291471dd1559 ("libbpf, xsk: Add libbpf_smp_store_release
libbpf_smp_load_acquire") linux/compiler.h was added as a dependency
to xsk.h, which is the user-facing API. This makes it harder for
userspace application to consume the library. Here the header
inclusion is removed, and instead {READ,WRITE}_ONCE() is added
explicitly.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/lib/bpf/libbpf_util.h | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/libbpf_util.h b/tools/lib/bpf/libbpf_util.h
index cfbcfc063c81..954da9b34a34 100644
--- a/tools/lib/bpf/libbpf_util.h
+++ b/tools/lib/bpf/libbpf_util.h
@@ -5,25 +5,30 @@
 #define __LIBBPF_LIBBPF_UTIL_H
 
 #include <stdbool.h>
-#include <linux/compiler.h>
 
 #ifdef __cplusplus
 extern "C" {
 #endif
 
-/* Use these barrier functions instead of smp_[rw]mb() when they are
- * used in a libbpf header file. That way they can be built into the
- * application that uses libbpf.
+/* Load-Acquire Store-Release barriers used by the XDP socket
+ * library. The following macros should *NOT* be considered part of
+ * the xsk.h API, and is subject to change anytime.
+ *
+ * LIBRARY INTERNAL
  */
+
+#define __XSK_READ_ONCE(x) (*(volatile typeof(x) *)&x)
+#define __XSK_WRITE_ONCE(x, v) (*(volatile typeof(x) *)&x) = (v)
+
 #if defined(__i386__) || defined(__x86_64__)
 # define libbpf_smp_store_release(p, v)					\
 	do {								\
 		asm volatile("" : : : "memory");			\
-		WRITE_ONCE(*p, v);					\
+		__XSK_WRITE_ONCE(*p, v);				\
 	} while (0)
 # define libbpf_smp_load_acquire(p)					\
 	({								\
-		typeof(*p) ___p1 = READ_ONCE(*p);			\
+		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
 		asm volatile("" : : : "memory");			\
 		___p1;							\
 	})
@@ -41,11 +46,11 @@ extern "C" {
 # define libbpf_smp_store_release(p, v)					\
 	do {								\
 		asm volatile ("fence rw,w" : : : "memory");		\
-		WRITE_ONCE(*p, v);					\
+		__XSK_WRITE_ONCE(*p, v);				\
 	} while (0)
 # define libbpf_smp_load_acquire(p)					\
 	({								\
-		typeof(*p) ___p1 = READ_ONCE(*p);			\
+		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
 		asm volatile ("fence r,rw" : : : "memory");		\
 		___p1;							\
 	})
@@ -55,19 +60,21 @@ extern "C" {
 #define libbpf_smp_store_release(p, v)					\
 	do {								\
 		__sync_synchronize();					\
-		WRITE_ONCE(*p, v);					\
+		__XSK_WRITE_ONCE(*p, v);				\
 	} while (0)
 #endif
 
 #ifndef libbpf_smp_load_acquire
 #define libbpf_smp_load_acquire(p)					\
 	({								\
-		typeof(*p) ___p1 = READ_ONCE(*p);			\
+		typeof(*p) ___p1 = __XSK_READ_ONCE(*p);			\
 		__sync_synchronize();					\
 		___p1;							\
 	})
 #endif
 
+/* LIBRARY INTERNAL -- END */
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
-- 
2.27.0

