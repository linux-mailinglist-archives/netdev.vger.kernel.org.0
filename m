Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D9C63440C
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbiKVSzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbiKVSzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:55:46 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA16A7ECBB
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:55:44 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id b12so12312641wrn.2
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HvKmf8QkEDqM5bOgMSE5Lyq5esRkdcJRdtODvTTixyM=;
        b=hBw/+9L4EZL/aiqvkrB5TAyD3y/O0/0QjkftTfqA4937+/nNf4uEMM5ZMz5YIsAF56
         qvojkyFz9LFmOpSU3VK16EcO7Azp14KafzU3tmkch0zgMgkEm+CcYrrSO15/mwxjwvYX
         kXJRqYkglrr2udytY7dEl92qDUMHYjvtjeA+m9x2ncnkPpxHlc3vG5JnD3eqn9F52cLp
         6xMtNgk7VcVcjHh1BaJq+AhZKBH3CytGaLvsZA6ygdmc3PEkK/uFAtLWXEM8vawVI18V
         sxJ7N6/Y/3/vASRsiTnWtWSXzGOC+W/G7D7g6IP1KIpAcCEot6u2nn2KsCe9kxa7Xfgc
         hGHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HvKmf8QkEDqM5bOgMSE5Lyq5esRkdcJRdtODvTTixyM=;
        b=DtsEDmuchaKfJIdQzz0vSBc+HsRESJV81s0Ob2UWhTmblz+kps9cy99NI7cSTtfdAz
         62v/PUyetlOlg/yb1SjP410PA1xabcuzrsUzpduM4rRPc5/pJ/54soz06UplZGbLedfz
         pgxT3tmxkVf4cL+dyugNIuy/2spe95IE+iUy30QqrCKsqxMUkI2uOVpuy32gx2xlJsWH
         j5zJiPPMuriEiW1AUEXBj4zM21OLJfFM614VnTkwbhRzABCfREWBz1oCMyHjt6uIPRry
         kG/7bItW59kw0kf6VChBVBacolHENvuVCEAyRt+aPzksAFhx6TYjl4DMmDr0wVDApDaV
         PWPQ==
X-Gm-Message-State: ANoB5pmIA83O+6wGzVpyZpbUvOq+/GdS30Fm135urX7mfIn4sR6yZT5u
        7hdLKCe/w+VqehyTz9uzyKzF4w==
X-Google-Smtp-Source: AA0mqf6K2SIKd/zviOqdwHxX5J/DPo4yItO3nGC82en2kcy0xyfUOZytD5E9UtkcqKARGu9/thW4JA==
X-Received: by 2002:a5d:698c:0:b0:236:4930:2465 with SMTP id g12-20020a5d698c000000b0023649302465mr15170230wru.235.1669143343288;
        Tue, 22 Nov 2022 10:55:43 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb12000000b002365730eae8sm14478044wrr.55.2022.11.22.10.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 10:55:42 -0800 (PST)
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
Subject: [PATCH v5 1/5] jump_label: Prevent key->enabled int overflow
Date:   Tue, 22 Nov 2022 18:55:30 +0000
Message-Id: <20221122185534.308643-2-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122185534.308643-1-dima@arista.com>
References: <20221122185534.308643-1-dima@arista.com>
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

