Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E2162A3E1
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbiKOVT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiKOVTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:19:50 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1836621E27
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 13:19:46 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id g12so26360084wrs.10
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 13:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G6ZrelBNbx4bHqPFCl+9tJGrR84oe90P9c4JQMnU//c=;
        b=JEiTnfyG7jVn1GJy603cURHFeY1WtTxd95lLwGzpaA8HBNnXKesxowihb3ga39IPKr
         dS5gw1ezZx4dCaWPIAoHblLuwwFa6ESLDtWGU0E0Ok22CK32mdOJtxTg78+U4HkxGv8q
         y5Pn2DaPOFVFX/NDzqa+wg9sbjgYg1BDrSBkL0RGFRFGcUGOelgL132hPXG0Fny9hhGI
         tvgtu1d6G2g0fgsL/ThFkBdPrNOzJ9XQIJMtO1gIZ7b15+v0bRb5bQ4shpCXKN6bEmJz
         TbF8pwAK2SxsONFHVj/j2l1iXpbz8BLy2ORo0gkpaTyy0WLlzkiOOj6/nbupYYZderOi
         lCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G6ZrelBNbx4bHqPFCl+9tJGrR84oe90P9c4JQMnU//c=;
        b=SOR8/Uza78ll68PhMumfh1lHybRbYSuGa8pEsjiG2NbD3sjm713mn9Frd4PpoDs0eP
         +7vB/hG9j6untv2G01yeQw1QGOv2a7zBi+5V+zzulQXb7ys0k+YNacHOgx1z2Z1FlgO2
         oKO9kJhrTN/g0fzctHS+Y1MUazqWGlf+5Nv1Pfvob8fGV2NkxuIAOc+PCWXAyJIj/75i
         1IfVlAwoDaUsTPVwLO7exqfMMlaclK/zzKYzrXloNcTsiGGo27PaGruu2rABsnL8y5fX
         Id1UMCZqq8GD4CJ2CiBmqMnw6F/FJSC7NOPj6jqKRC6K9xb88Q98wJvcKUy0SoudWeSp
         NVvA==
X-Gm-Message-State: ANoB5pnb0MXEkTl0hkYBbafh6kIOWcM3LRRiM0jTjxOtD6ZwbX12pV9j
        9ii+FbyRgdT1aBIkoiLUvIz+cg==
X-Google-Smtp-Source: AA0mqf6ot1+pW00qvrkf/vvbjKqUy0/Nsglu2a7sKnGP3DS2KJSGUcA4Re4Z5gF68zjEj6eMwE5YFA==
X-Received: by 2002:a05:6000:61a:b0:241:6e0a:bfe6 with SMTP id bn26-20020a056000061a00b002416e0abfe6mr12006959wrb.34.1668547154291;
        Tue, 15 Nov 2022 13:19:14 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n41-20020a05600c502900b003c65c9a36dfsm17201487wmr.48.2022.11.15.13.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 13:19:13 -0800 (PST)
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
Subject: [PATCH v4 1/5] jump_label: Prevent key->enabled int overflow
Date:   Tue, 15 Nov 2022 21:19:01 +0000
Message-Id: <20221115211905.1685426-2-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221115211905.1685426-1-dima@arista.com>
References: <20221115211905.1685426-1-dima@arista.com>
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
---
 include/linux/jump_label.h | 19 +++++++++++---
 kernel/jump_label.c        | 54 +++++++++++++++++++++++++++++---------
 2 files changed, 57 insertions(+), 16 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 570831ca9951..c0a02d4c2ea2 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -224,9 +224,9 @@ extern bool arch_jump_label_transform_queue(struct jump_entry *entry,
 					    enum jump_label_type type);
 extern void arch_jump_label_transform_apply(void);
 extern int jump_label_text_reserved(void *start, void *end);
-extern void static_key_slow_inc(struct static_key *key);
+extern bool static_key_slow_inc(struct static_key *key);
 extern void static_key_slow_dec(struct static_key *key);
-extern void static_key_slow_inc_cpuslocked(struct static_key *key);
+extern bool static_key_slow_inc_cpuslocked(struct static_key *key);
 extern void static_key_slow_dec_cpuslocked(struct static_key *key);
 extern int static_key_count(struct static_key *key);
 extern void static_key_enable(struct static_key *key);
@@ -278,10 +278,21 @@ static __always_inline bool static_key_true(struct static_key *key)
 	return false;
 }
 
-static inline void static_key_slow_inc(struct static_key *key)
+static inline bool static_key_slow_inc(struct static_key *key)
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
 
 static inline void static_key_slow_dec(struct static_key *key)
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 4d6c6f5f60db..677a6674c130 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -113,9 +113,38 @@ int static_key_count(struct static_key *key)
 }
 EXPORT_SYMBOL_GPL(static_key_count);
 
-void static_key_slow_inc_cpuslocked(struct static_key *key)
+/***
+ * static_key_fast_inc_not_negative - adds a user for a static key
+ * @key: static key that must be already enabled
+ *
+ * The caller must make sure that the static key can't get disabled while
+ * in this function. It doesn't patch jump labels, only adds a user to
+ * an already enabled static key.
+ *
+ * Returns true if the increment was done.
+ */
+static bool static_key_fast_inc_not_negative(struct static_key *key)
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
+
+bool static_key_slow_inc_cpuslocked(struct static_key *key)
+{
 	lockdep_assert_cpus_held();
 
 	/*
@@ -124,15 +153,9 @@ void static_key_slow_inc_cpuslocked(struct static_key *key)
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
+	if (static_key_fast_inc_not_negative(key))
+		return true;
 
 	jump_label_lock();
 	if (atomic_read(&key->enabled) == 0) {
@@ -144,16 +167,23 @@ void static_key_slow_inc_cpuslocked(struct static_key *key)
 		 */
 		atomic_set_release(&key->enabled, 1);
 	} else {
-		atomic_inc(&key->enabled);
+		if (WARN_ON_ONCE(!static_key_fast_inc_not_negative(key))) {
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

