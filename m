Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7F25F1F89
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 22:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJAUvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 16:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiJAUvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 16:51:08 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645EE5924D
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 13:51:07 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gf8so4418253pjb.5
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 13:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=lvoYBwdyN+zV8Zt3OjnrnXSmchk9Wqzb6BScZlzl89Y=;
        b=p8XWvClaZPLjovSoL1AxzUXZ65XXqPjJUQnoN/tTixS9AhwCBJ24ZYHs1ef84rDUgR
         kuqbG8oK/ndHsKGt4b8khWnH8ijD2AlTRK2UGs6i2FJi24W4pIk+EB97O52r587FHHEM
         L0450sMKqYMZnLgz8RfZpiQlLFUwt46HvfWLOf98Du1ANVFKATuqy3r5afPJGctzyXrr
         JCCtgUqwP8/2pi2SXZY9lFPIadYxvzfEz6x508dRLDhI9/9WhcZe5iE31lX4BtQ+z3LY
         r+o6thHr+ELm1eXPx3IUOC2b0zetMr5uYC+T7yeqFRQi/9LcGr7H9VcLfYjOdyaJiw/H
         uc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=lvoYBwdyN+zV8Zt3OjnrnXSmchk9Wqzb6BScZlzl89Y=;
        b=LxMBgZeYdxb/lWvL1NYZyO937rAZxgOd+chkSA3MYbZbY4Q1L2VCJp/hN8SNFJ3EiT
         a0wzDRNOin9mBuytzHUYjTl9phB5IHLWx+nRiJu/UfphB0TzUd6n1yQqZ0V39Fvbdq8/
         K5OaRltd9zqZJFCvTOXoxlkYdeYRmSGCehUeLnIrq94PLMAI0xL31hF+R6QBqvKtsDGM
         xxcM0YVa6HDX+TMqAxtHzUSP0SLc/npqOdKsYRPCsOs9uWx6wXUjuiP/1VtrpZsJIPhA
         K+bBiV3e7VHA9IZspbTkXEkhHUW1Vse5lAXj4/FIpsxDfMHz8E79XJkp8NFXZkrz6k0/
         3BGg==
X-Gm-Message-State: ACrzQf22awGsuwxsREmpTlyjeE9+XDdzVgVJjkVeuf0FNq0Pr1KXhZr5
        2XuPGarDY9F/riD7XM5laXo=
X-Google-Smtp-Source: AMsMyM4sjCxzkl3ZHohbJ9/lrRe6Z9dDTFeAfvt8LEn4f6JRRhHpP9iyuJhER7ZLTV2FUWgWgoV07A==
X-Received: by 2002:a17:902:cf03:b0:179:b7fe:dc90 with SMTP id i3-20020a170902cf0300b00179b7fedc90mr15754570plg.112.1664657466669;
        Sat, 01 Oct 2022 13:51:06 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:73b5:9ed8:32d2:8e2f])
        by smtp.gmail.com with ESMTPSA id bd12-20020a170902830c00b0017bbd845c17sm4282534plb.158.2022.10.01.13.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 13:51:06 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Willy Tarreau <w@1wt.eu>
Subject: [PATCH net-next] once: add DO_ONCE_SLOW() for sleepable contexts
Date:   Sat,  1 Oct 2022 13:51:02 -0700
Message-Id: <20221001205102.2319658-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Christophe Leroy reported a ~80ms latency spike
happening at first TCP connect() time.

This is because __inet_hash_connect() uses get_random_once()
to populate a perturbation table which became quite big
after commit 4c2c8f03a5ab ("tcp: increase source port perturb table to 2^16")

get_random_once() uses DO_ONCE(), which block hard irqs for the duration
of the operation.

This patch adds DO_ONCE_SLOW() which uses a mutex instead of a spinlock
for operations where we prefer to stay in process context.

Then __inet_hash_connect() can use get_random_slow_once()
to populate its perturbation table.

Fixes: 4c2c8f03a5ab ("tcp: increase source port perturb table to 2^16")
Fixes: 190cc82489f4 ("tcp: change source port randomizarion at connect() time")
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/netdev/CANn89iLAEYBaoYajy0Y9UmGFff5GPxDUoG-ErVB2jDdRNQ5Tug@mail.gmail.com/T/#t
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willy Tarreau <w@1wt.eu>
---
 include/linux/once.h       | 28 ++++++++++++++++++++++++++++
 lib/once.c                 | 30 ++++++++++++++++++++++++++++++
 net/ipv4/inet_hashtables.c |  4 ++--
 3 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/include/linux/once.h b/include/linux/once.h
index b14d8b309d52b198bb144689fe67d9ed235c2b3e..176ab75b42df740a738d04d8480821a0b3b65ba9 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -5,10 +5,18 @@
 #include <linux/types.h>
 #include <linux/jump_label.h>
 
+/* Helpers used from arbitrary contexts.
+ * Hard irqs are blocked, be cautious.
+ */
 bool __do_once_start(bool *done, unsigned long *flags);
 void __do_once_done(bool *done, struct static_key_true *once_key,
 		    unsigned long *flags, struct module *mod);
 
+/* Variant for process contexts only. */
+bool __do_once_slow_start(bool *done);
+void __do_once_slow_done(bool *done, struct static_key_true *once_key,
+			 struct module *mod);
+
 /* Call a function exactly once. The idea of DO_ONCE() is to perform
  * a function call such as initialization of random seeds, etc, only
  * once, where DO_ONCE() can live in the fast-path. After @func has
@@ -52,7 +60,27 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
 		___ret;							     \
 	})
 
+/* Variant of DO_ONCE() for process/sleepable contexts. */
+#define DO_ONCE_SLOW(func, ...)						     \
+	({								     \
+		bool ___ret = false;					     \
+		static bool __section(".data.once") ___done = false;	     \
+		static DEFINE_STATIC_KEY_TRUE(___once_key);		     \
+		if (static_branch_unlikely(&___once_key)) {		     \
+			___ret = __do_once_slow_start(&___done);	     \
+			if (unlikely(___ret)) {				     \
+				func(__VA_ARGS__);			     \
+				__do_once_slow_done(&___done, &___once_key,  \
+						    THIS_MODULE);	     \
+			}						     \
+		}							     \
+		___ret;							     \
+	})
+
 #define get_random_once(buf, nbytes)					     \
 	DO_ONCE(get_random_bytes, (buf), (nbytes))
 
+#define get_random_slow_once(buf, nbytes)				     \
+	DO_ONCE_SLOW(get_random_bytes, (buf), (nbytes))
+
 #endif /* _LINUX_ONCE_H */
diff --git a/lib/once.c b/lib/once.c
index 59149bf3bfb4a97e4fa7febee737155d700bae48..351f66aad310a47f17d0636da0ed5b2b4460522d 100644
--- a/lib/once.c
+++ b/lib/once.c
@@ -66,3 +66,33 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
 	once_disable_jump(once_key, mod);
 }
 EXPORT_SYMBOL(__do_once_done);
+
+static DEFINE_MUTEX(once_mutex);
+
+bool __do_once_slow_start(bool *done)
+	__acquires(once_mutex)
+{
+	mutex_lock(&once_mutex);
+	if (*done) {
+		mutex_unlock(&once_mutex);
+		/* Keep sparse happy by restoring an even lock count on
+		 * this mutex. In case we return here, we don't call into
+		 * __do_once_done but return early in the DO_ONCE_SLOW() macro.
+		 */
+		__acquire(once_mutex);
+		return false;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(__do_once_slow_start);
+
+void __do_once_slow_done(bool *done, struct static_key_true *once_key,
+			 struct module *mod)
+	__releases(once_mutex)
+{
+	*done = true;
+	mutex_unlock(&once_mutex);
+	once_disable_jump(once_key, mod);
+}
+EXPORT_SYMBOL(__do_once_slow_done);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 49db8c597eea83a27e91edc429c2c4779b0a5cd7..dc1c5629cd0d61716d6d99131c57b49717785709 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -958,8 +958,8 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	net_get_random_once(table_perturb,
-			    INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
+	get_random_slow_once(table_perturb,
+			     INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
 	index = port_offset & (INET_TABLE_PERTURB_SIZE - 1);
 
 	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

