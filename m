Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB7A636762
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239137AbiKWRjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239069AbiKWRjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:39:11 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB718FB29
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:39:09 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id v1so30457525wrt.11
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r5XPjM3RgE/cH2+A7+UFbzbdCk3mTFWCKPug1l8jbA0=;
        b=GiH4RbqJTKN/mly4lBU/H75GpRlBlxb0RYHmBN8b2PiA+WFBtoiaTYIY3iGo9JAh+N
         3yPIiTFK5IwgKSZQvTymUaj9+FkwBORkQwhT9t2dWn/CoBR/wVQZUVeA797cKjK7x0gU
         APJXLW4Lc3ZVJMaaNWFbkrANbfIW43Gt5aCsbvCXV46a35pg9J7gudgfVxlW91qZB7kO
         2ZY9eiMCD4F6073w+qH1/q3oLh/EaAXBbtHencOPgM/JpCQHx5wNDTIEZGycGbEASSLq
         z83KNrqZhUtMFdMdpr7hCitWRjEyuNU2Q35T06OSebu9NMWezsQ5zA8ou/FjGvYE7w91
         G8jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r5XPjM3RgE/cH2+A7+UFbzbdCk3mTFWCKPug1l8jbA0=;
        b=0KDth4ygnRUCFSg6G/ivB8hazoCOiJQZ8PADxDXrlyfbshzSxXfXNxVDL8W44sSPRn
         btl0JY9msezYQWOX6Oxf4YBpuT5P4JlXT3HM/WKYYo1S8xTzAEaZ+32RISabeP7GDB71
         DUNIndO5HaWQf1tXDhHi7OVR5rC3sbaB16JNxkQxkG4Nq75V87iSEjNvIQ67YcLBK1qx
         y6OKwmOtbxZqN+PopcWE34EWF8K6PGyu52h1d//Ev0lgxNTll+rnpfzd9HTGoQRrTkA2
         5tqjbTaCjz1r/lOZOK6cLl1WDrgX0k75BAjUsbHkC9q0jnoBcFU1ZOMSW6F5dzWG49jw
         hxnw==
X-Gm-Message-State: ANoB5pkYWGOet56VekeDi8LwloS0OVvquGWe7UdPBuuvwKopabmPD6/Z
        TFrsIMJz3Uh/OzC+3cc55G2tTA==
X-Google-Smtp-Source: AA0mqf4WB//HRR7o8qsoYAXb9nei3HeIprtyCEwvLNr2Ci0zo6e2hcRvR3VFc7MtiiWtYdN31IomYw==
X-Received: by 2002:adf:edd1:0:b0:241:7d0a:65ef with SMTP id v17-20020adfedd1000000b002417d0a65efmr10818977wro.491.1669225148331;
        Wed, 23 Nov 2022 09:39:08 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id v10-20020adfe28a000000b0023647841c5bsm17464636wri.60.2022.11.23.09.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 09:39:07 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Dmitry Safonov <dima@arista.com>, Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Subject: [PATCH v6 1/5] jump_label: Prevent key->enabled int overflow
Date:   Wed, 23 Nov 2022 17:38:55 +0000
Message-Id: <20221123173859.473629-2-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123173859.473629-1-dima@arista.com>
References: <20221123173859.473629-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. With CONFIG_JUMP_LABEL=n static_key_slow_inc() doesn't have any
   protection against key->enabled refcounter overflow.
2. With CONFIG_JUMP_LABEL=y static_key_slow_inc_cpuslocked()
   still may turn the refcounter negative as (v + 1) may overflow.

key->enabled is indeed a ref-counter as it's documented in multiple
places: top comment in jump_label.h, Documentation/staging/static-keys.rst,
etc.

As -1 is reserved for static key that's in process of being enabled,
functions would break with negative key->enabled refcount:
- for CONFIG_JUMP_LABEL=n negative return of static_key_count()
  breaks static_key_false(), static_key_true()
- the ref counter may become 0 from negative side by too many
  static_key_slow_inc() calls and lead to use-after-free issues.

These flaws result in that some users have to introduce an additional
mutex and prevent the reference counter from overflowing themselves,
see bpf_enable_runtime_stats() checking the counter against INT_MAX / 2.

Prevent the reference counter overflow by checking if (v + 1) > 0.
Change functions API to return whether the increment was successful.

Signed-off-by: Dmitry Safonov <dima@arista.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/jump_label.h | 21 +++++++++++---
 kernel/jump_label.c        | 56 ++++++++++++++++++++++++++++++--------
 2 files changed, 61 insertions(+), 16 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 570831ca9951..4e968ebadce6 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -224,9 +224,10 @@ extern bool arch_jump_label_transform_queue(struct jump_entry *entry,
 					    enum jump_label_type type);
 extern void arch_jump_label_transform_apply(void);
 extern int jump_label_text_reserved(void *start, void *end);
-extern void static_key_slow_inc(struct static_key *key);
+extern bool static_key_slow_inc(struct static_key *key);
+extern bool static_key_fast_inc_not_disabled(struct static_key *key);
 extern void static_key_slow_dec(struct static_key *key);
-extern void static_key_slow_inc_cpuslocked(struct static_key *key);
+extern bool static_key_slow_inc_cpuslocked(struct static_key *key);
 extern void static_key_slow_dec_cpuslocked(struct static_key *key);
 extern int static_key_count(struct static_key *key);
 extern void static_key_enable(struct static_key *key);
@@ -278,11 +279,23 @@ static __always_inline bool static_key_true(struct static_key *key)
 	return false;
 }
 
-static inline void static_key_slow_inc(struct static_key *key)
+static inline bool static_key_fast_inc_not_disabled(struct static_key *key)
 {
+	int v;
+
 	STATIC_KEY_CHECK_USE(key);
-	atomic_inc(&key->enabled);
+	/*
+	 * Prevent key->enabled getting negative to follow the same semantics
+	 * as for CONFIG_JUMP_LABEL=y, see kernel/jump_label.c comment.
+	 */
+	v = atomic_read(&key->enabled);
+	do {
+		if (v < 0 || (v + 1) < 0)
+			return false;
+	} while (!likely(atomic_try_cmpxchg(&key->enabled, &v, v + 1)));
+	return true;
 }
+#define static_key_slow_inc(key)	static_key_fast_inc_not_disabled(key)
 
 static inline void static_key_slow_dec(struct static_key *key)
 {
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 4d6c6f5f60db..d9c822bbffb8 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -113,9 +113,40 @@ int static_key_count(struct static_key *key)
 }
 EXPORT_SYMBOL_GPL(static_key_count);
 
-void static_key_slow_inc_cpuslocked(struct static_key *key)
+/*
+ * static_key_fast_inc_not_disabled - adds a user for a static key
+ * @key: static key that must be already enabled
+ *
+ * The caller must make sure that the static key can't get disabled while
+ * in this function. It doesn't patch jump labels, only adds a user to
+ * an already enabled static key.
+ *
+ * Returns true if the increment was done. Unlike refcount_t the ref counter
+ * is not saturated, but will fail to increment on overflow.
+ */
+bool static_key_fast_inc_not_disabled(struct static_key *key)
 {
+	int v;
+
 	STATIC_KEY_CHECK_USE(key);
+	/*
+	 * Negative key->enabled has a special meaning: it sends
+	 * static_key_slow_inc() down the slow path, and it is non-zero
+	 * so it counts as "enabled" in jump_label_update().  Note that
+	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
+	 */
+	v = atomic_read(&key->enabled);
+	do {
+		if (v <= 0 || (v + 1) < 0)
+			return false;
+	} while (!likely(atomic_try_cmpxchg(&key->enabled, &v, v + 1)));
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(static_key_fast_inc_not_disabled);
+
+bool static_key_slow_inc_cpuslocked(struct static_key *key)
+{
 	lockdep_assert_cpus_held();
 
 	/*
@@ -124,15 +155,9 @@ void static_key_slow_inc_cpuslocked(struct static_key *key)
 	 * jump_label_update() process.  At the same time, however,
 	 * the jump_label_update() call below wants to see
 	 * static_key_enabled(&key) for jumps to be updated properly.
-	 *
-	 * So give a special meaning to negative key->enabled: it sends
-	 * static_key_slow_inc() down the slow path, and it is non-zero
-	 * so it counts as "enabled" in jump_label_update().  Note that
-	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
 	 */
-	for (int v = atomic_read(&key->enabled); v > 0; )
-		if (likely(atomic_try_cmpxchg(&key->enabled, &v, v + 1)))
-			return;
+	if (static_key_fast_inc_not_disabled(key))
+		return true;
 
 	jump_label_lock();
 	if (atomic_read(&key->enabled) == 0) {
@@ -144,16 +169,23 @@ void static_key_slow_inc_cpuslocked(struct static_key *key)
 		 */
 		atomic_set_release(&key->enabled, 1);
 	} else {
-		atomic_inc(&key->enabled);
+		if (WARN_ON_ONCE(!static_key_fast_inc_not_disabled(key))) {
+			jump_label_unlock();
+			return false;
+		}
 	}
 	jump_label_unlock();
+	return true;
 }
 
-void static_key_slow_inc(struct static_key *key)
+bool static_key_slow_inc(struct static_key *key)
 {
+	bool ret;
+
 	cpus_read_lock();
-	static_key_slow_inc_cpuslocked(key);
+	ret = static_key_slow_inc_cpuslocked(key);
 	cpus_read_unlock();
+	return ret;
 }
 EXPORT_SYMBOL_GPL(static_key_slow_inc);
 
-- 
2.38.1

