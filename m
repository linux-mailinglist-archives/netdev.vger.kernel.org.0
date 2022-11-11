Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEED62637D
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 22:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiKKVXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 16:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbiKKVXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 16:23:32 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A829FF6
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:23:30 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id j15so7980418wrq.3
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 13:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/wqu7ka025DHmiQHo96XTmKANEmftj8UjKkUsPUJ5+A=;
        b=fxVJwfPadmX2Uf5lD3RgJFfhZGXHqr6rP7D8M4ssAK4uU5IWGA4BJkQKPdVttgZO+v
         uXmVGi6Qgm563iisXM1+ajmiPXYAsXb99/we41xRtyFyhDvvDRZC8JPD9I/7OpCUqjVj
         lUTPyvEtnEF6q4PNqyi0LwMAh7Ssg8QqgqdkV9Bx/xXvspGSWleBm83YkbIx7nY3+C+E
         ffQkoIU0G6sAtFXGMlkKE5hog0L+8Yj5cXwmrwtBijDE4XmlKDip1EhBxi1441SQ6taO
         2fN94oJE07p69DqUZPt7ICKiGdM2wTBzV9ok2L80GKrDG8/3wzotNFYnYwAejO3PXXMk
         6Lkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/wqu7ka025DHmiQHo96XTmKANEmftj8UjKkUsPUJ5+A=;
        b=sLYa1sWPCZipq0d8J3HJBVv2wW7mKcpiF5xTe8ojQYOQjYxXFmk3k5+lCcRq9fsbpk
         HZ7bDhdSvWkRqqshKbW0UvJEEYoue3wcAdILpalAVAVAK/oXL3wPrlRbREr9HcGkIPdB
         ONoPmtLMujZ13zZFd7bdin213dz7GwZIw7rA0f43LJXeGXj3HQYiFZeWhJhzk5S+FNLI
         3A/GPlLxxjitIUkGgNHj+gn05BM1+WfxDPF7zF3p4FK1izK0l+ZLumNtnIsfbEebPNSO
         OfMYba++h+0yhv0uGajqkytSKsNe/va+wssX7IkYWVDozsbA/B+m2/4FNELa2tRppvpn
         r4VQ==
X-Gm-Message-State: ANoB5pkt+3ghXlhiTXbfap9/R7a256mWyTneb9Pevzh1WyWNXo2TRkgz
        h4fL3LHmStK2AGJtTqwhrUKJsQ==
X-Google-Smtp-Source: AA0mqf5qyVUOYbiavINF4aCT+lEdbutL4RcNHVO5ns2hb4bESLOXBnavZU1Tx0DyY7qe1LjOnH85mg==
X-Received: by 2002:adf:f882:0:b0:236:8dd7:1919 with SMTP id u2-20020adff882000000b002368dd71919mr2114766wrp.242.1668201809379;
        Fri, 11 Nov 2022 13:23:29 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n18-20020a7bcbd2000000b003cf9bf5208esm9423281wmi.19.2022.11.11.13.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 13:23:28 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v3 1/3] jump_label: Prevent key->enabled int overflow
Date:   Fri, 11 Nov 2022 21:23:18 +0000
Message-Id: <20221111212320.1386566-2-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111212320.1386566-1-dima@arista.com>
References: <20221111212320.1386566-1-dima@arista.com>
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

While at here, provide static_key_fast_inc() helper that does ref
counter increment in atomic fashion (without grabbing cpus_read_lock()
on CONFIG_JUMP_LABEL=y). This is needed to add a new user for
a static_key when the caller controls the lifetime of another user.
The exact detail where it will be used: if a listen socket with TCP-MD5
key receives SYN packet that passes the verification and in result
creates a request socket - it's all done from RX softirq. At that moment
userspace can't lock the listen socket and remove that TCP-MD5 key, so
the tcp_md5_needed static branch can't get disabled. But the refcounter
of the static key needs to be adjusted to account for a new user
(the request socket).

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/jump_label.h | 21 ++++++++++++---
 kernel/jump_label.c        | 54 ++++++++++++++++++++++++++++----------
 2 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 570831ca9951..ced5b49d24b4 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -224,9 +224,10 @@ extern bool arch_jump_label_transform_queue(struct jump_entry *entry,
 					    enum jump_label_type type);
 extern void arch_jump_label_transform_apply(void);
 extern int jump_label_text_reserved(void *start, void *end);
-extern void static_key_slow_inc(struct static_key *key);
+extern bool static_key_slow_inc(struct static_key *key);
+extern bool static_key_fast_inc(struct static_key *key);
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
+static inline bool static_key_fast_inc(struct static_key *key)
 {
+	int v, v1;
+
 	STATIC_KEY_CHECK_USE(key);
-	atomic_inc(&key->enabled);
+	/*
+	 * Prevent key->enabled getting negative to follow the same semantics
+	 * as for CONFIG_JUMP_LABEL=y, see kernel/jump_label.c comment.
+	 */
+	for (v = atomic_read(&key->enabled); v >= 0 && (v + 1) > 0; v = v1) {
+		v1 = atomic_cmpxchg(&key->enabled, v, v + 1);
+		if (likely(v1 == v))
+			return true;
+	}
+	return false;
 }
+#define static_key_slow_inc(key)	static_key_fast_inc(key)
 
 static inline void static_key_slow_dec(struct static_key *key)
 {
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 714ac4c3b556..f2c1aa351d41 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -113,11 +113,38 @@ int static_key_count(struct static_key *key)
 }
 EXPORT_SYMBOL_GPL(static_key_count);
 
-void static_key_slow_inc_cpuslocked(struct static_key *key)
+/***
+ * static_key_fast_inc - adds a user for a static key
+ * @key: static key that must be already enabled
+ *
+ * The caller must make sure that the static key can't get disabled while
+ * in this function. It doesn't patch jump labels, only adds a user to
+ * an already enabled static key.
+ *
+ * Returns true if the increment was done.
+ */
+bool static_key_fast_inc(struct static_key *key)
 {
 	int v, v1;
 
 	STATIC_KEY_CHECK_USE(key);
+	/*
+	 * Negative key->enabled has a special meaning: it sends
+	 * static_key_slow_inc() down the slow path, and it is non-zero
+	 * so it counts as "enabled" in jump_label_update().  Note that
+	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
+	 */
+	for (v = atomic_read(&key->enabled); v > 0 && (v + 1) > 0; v = v1) {
+		v1 = atomic_cmpxchg(&key->enabled, v, v + 1);
+		if (likely(v1 == v))
+			return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(static_key_fast_inc);
+
+bool static_key_slow_inc_cpuslocked(struct static_key *key)
+{
 	lockdep_assert_cpus_held();
 
 	/*
@@ -126,17 +153,9 @@ void static_key_slow_inc_cpuslocked(struct static_key *key)
 	 * jump_label_update() process.  At the same time, however,
 	 * the jump_label_update() call below wants to see
 	 * static_key_enabled(&key) for jumps to be updated properly.
-	 *
-	 * So give a special meaning to negative key->enabled: it sends
-	 * static_key_slow_inc() down the slow path, and it is non-zero
-	 * so it counts as "enabled" in jump_label_update().  Note that
-	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
 	 */
-	for (v = atomic_read(&key->enabled); v > 0; v = v1) {
-		v1 = atomic_cmpxchg(&key->enabled, v, v + 1);
-		if (likely(v1 == v))
-			return;
-	}
+	if (static_key_fast_inc(key))
+		return true;
 
 	jump_label_lock();
 	if (atomic_read(&key->enabled) == 0) {
@@ -148,16 +167,23 @@ void static_key_slow_inc_cpuslocked(struct static_key *key)
 		 */
 		atomic_set_release(&key->enabled, 1);
 	} else {
-		atomic_inc(&key->enabled);
+		if (WARN_ON_ONCE(static_key_fast_inc(key))) {
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

