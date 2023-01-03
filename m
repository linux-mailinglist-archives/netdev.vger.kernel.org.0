Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C789065C69F
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 19:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbjACSpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 13:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238374AbjACSow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 13:44:52 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBD617067
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 10:43:08 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id bk16so17342500wrb.11
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 10:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Q77snMsSA0RHjgcdnmWVPKGZuaieErtKpldxtmJJME=;
        b=dvBV21axKPcLoMyw1pGtEzYZsngO7g9WU5N4VAH1JYq1HIpghFY3iv8RFCgMdyc76y
         5HNPlMYHZiGl56bQTsEA7o41nSUVH5px7OytGAVClmsU9vHhuLLIRogdnMYhGZu2v/dK
         3er8vsGzR34/gWzjG6s2FcDAtpyz7KCSLlNus5/3ESC5xMOFxw/Iez3aiVNYrmEy88Bl
         phWnf6j/hh6CVFa1I0qxkNRc5xm42TGleNlc924sK2e7HZ4P0vwxkoWmMEC/rIdVDCR8
         25yIMLhwnRPJ8eB1EXToQzXgi8bVs1VyI0AWBjLiG1XJJNSYBxud9HcLlTQnU2GFXD9f
         0Lsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Q77snMsSA0RHjgcdnmWVPKGZuaieErtKpldxtmJJME=;
        b=NiAXFsiUCWtmXpVxsxLGHgKgAnFuV1Z8N3U/wepgSL4ctkoE2adK2G3zB99GQ5o8Gb
         6QkoDYiIvLuIlMJYFcnPMjPTl2LEHHqIKDs9NLeDTVMvSg7rBgEKm93F/mLJBa1ALKSl
         rFGr2XPSZrdANLUsNQqbLgRNUq9MWFv1PQL6hqzKYxJxsF7OXBbVW8c92PF2Ok1WSC7Z
         KZe85HAtF5yoct+NKoXQoFeoVWjq38+AeY17X3ck8JHybossNYXsQXlg8BzGhnXaBEG1
         OZ2zlBaKfqrbS1wshEuED7frUiXSrjmVa4Ctufzwzc8Q1APdUKutPbr+Ss72FsHS9UJu
         Kekg==
X-Gm-Message-State: AFqh2krWPfKMJOp1WR3R1pJZKcOfVOymzN4iL0wrqtXZsbNYhdtJiZ5z
        9onrDpbF5PSjoit/V0uwPuuWkw==
X-Google-Smtp-Source: AMrXdXv7NBse0h6eN97Y2c+XcC1/MykwtmTEZXJg2ITlSd0XQmlYvpKnc1nBAbdU5DIDydeIr+6nvw==
X-Received: by 2002:a5d:4911:0:b0:238:8896:788b with SMTP id x17-20020a5d4911000000b002388896788bmr28961788wrq.26.1672771387192;
        Tue, 03 Jan 2023 10:43:07 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id i18-20020a5d5232000000b0028e55b44a99sm13811578wra.17.2023.01.03.10.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 10:43:06 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v2 2/5] crypto/pool: Add crypto_pool_reserve_scratch()
Date:   Tue,  3 Jan 2023 18:42:54 +0000
Message-Id: <20230103184257.118069-3-dima@arista.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103184257.118069-1-dima@arista.com>
References: <20230103184257.118069-1-dima@arista.com>
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

Instead of having build-time hardcoded constant, reallocate scratch
area, if needed by user. Different algos, different users may need
different size of temp per-CPU buffer. Only up-sizing supported for
simplicity.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 crypto/Kconfig        |  6 ++++
 crypto/crypto_pool.c  | 77 ++++++++++++++++++++++++++++++++++---------
 include/crypto/pool.h |  3 +-
 3 files changed, 69 insertions(+), 17 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ba8d4a1f10f9..0614c2acfffa 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1394,6 +1394,12 @@ config CRYPTO_POOL
 	help
 	  Per-CPU pool of crypto requests ready for usage in atomic contexts.
 
+config CRYPTO_POOL_DEFAULT_SCRATCH_SIZE
+	hex "Per-CPU default scratch area size"
+	depends on CRYPTO_POOL
+	default 0x100
+	range 0x100 0x10000
+
 if !KMSAN # avoid false positives from assembly
 if ARM
 source "arch/arm/crypto/Kconfig"
diff --git a/crypto/crypto_pool.c b/crypto/crypto_pool.c
index 37131952c5a7..0cd9eade7b73 100644
--- a/crypto/crypto_pool.c
+++ b/crypto/crypto_pool.c
@@ -1,13 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
 #include <crypto/pool.h>
+#include <linux/cpu.h>
 #include <linux/kref.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/percpu.h>
 #include <linux/workqueue.h>
 
-static unsigned long scratch_size = DEFAULT_CRYPTO_POOL_SCRATCH_SZ;
+static unsigned long scratch_size = CONFIG_CRYPTO_POOL_DEFAULT_SCRATCH_SIZE;
 static DEFINE_PER_CPU(void *, crypto_pool_scratch);
 
 struct crypto_pool_entry {
@@ -22,26 +23,69 @@ static struct crypto_pool_entry cpool[CPOOL_SIZE];
 static unsigned int cpool_populated;
 static DEFINE_MUTEX(cpool_mutex);
 
-static int crypto_pool_scratch_alloc(void)
+/* Slow-path */
+/**
+ * crypto_pool_reserve_scratch - re-allocates scratch buffer, slow-path
+ * @size: request size for the scratch/temp buffer
+ */
+int crypto_pool_reserve_scratch(unsigned long size)
 {
-	int cpu;
-
-	lockdep_assert_held(&cpool_mutex);
+#define FREE_BATCH_SIZE		64
+	void *free_batch[FREE_BATCH_SIZE];
+	int cpu, err = 0;
+	unsigned int i = 0;
 
+	mutex_lock(&cpool_mutex);
+	if (size == scratch_size) {
+		for_each_possible_cpu(cpu) {
+			if (per_cpu(crypto_pool_scratch, cpu))
+				continue;
+			goto allocate_scratch;
+		}
+		mutex_unlock(&cpool_mutex);
+		return 0;
+	}
+allocate_scratch:
+	size = max(size, scratch_size);
+	cpus_read_lock();
 	for_each_possible_cpu(cpu) {
-		void *scratch = per_cpu(crypto_pool_scratch, cpu);
+		void *scratch, *old_scratch;
 
-		if (scratch)
+		scratch = kmalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
+		if (!scratch) {
+			err = -ENOMEM;
+			break;
+		}
+
+		old_scratch = per_cpu(crypto_pool_scratch, cpu);
+		/* Pairs with crypto_pool_get() */
+		WRITE_ONCE(*per_cpu_ptr(&crypto_pool_scratch, cpu), scratch);
+		if (!cpu_online(cpu)) {
+			kfree(old_scratch);
 			continue;
+		}
+		free_batch[i++] = old_scratch;
+		if (i == FREE_BATCH_SIZE) {
+			cpus_read_unlock();
+			synchronize_rcu();
+			while (i > 0)
+				kfree(free_batch[--i]);
+			cpus_read_lock();
+		}
+	}
+	cpus_read_unlock();
+	if (!err)
+		scratch_size = size;
+	mutex_unlock(&cpool_mutex);
 
-		scratch = kmalloc_node(scratch_size, GFP_KERNEL,
-				       cpu_to_node(cpu));
-		if (!scratch)
-			return -ENOMEM;
-		per_cpu(crypto_pool_scratch, cpu) = scratch;
+	if (i > 0) {
+		synchronize_rcu();
+		while (i > 0)
+			kfree(free_batch[--i]);
 	}
-	return 0;
+	return err;
 }
+EXPORT_SYMBOL_GPL(crypto_pool_reserve_scratch);
 
 static void crypto_pool_scratch_free(void)
 {
@@ -138,7 +182,6 @@ int crypto_pool_alloc_ahash(const char *alg)
 
 	/* slow-path */
 	mutex_lock(&cpool_mutex);
-
 	for (i = 0; i < cpool_populated; i++) {
 		if (cpool[i].alg && !strcmp(cpool[i].alg, alg)) {
 			if (kref_read(&cpool[i].kref) > 0) {
@@ -263,7 +306,11 @@ int crypto_pool_get(unsigned int id, struct crypto_pool *c)
 		return -EINVAL;
 	}
 	ret->req = *this_cpu_ptr(cpool[id].req);
-	ret->base.scratch = this_cpu_read(crypto_pool_scratch);
+	/*
+	 * Pairs with crypto_pool_reserve_scratch(), scartch area is
+	 * valid (allocated) until crypto_pool_put().
+	 */
+	ret->base.scratch = READ_ONCE(*this_cpu_ptr(&crypto_pool_scratch));
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_pool_get);
diff --git a/include/crypto/pool.h b/include/crypto/pool.h
index 2c61aa45faff..c7d817860cc3 100644
--- a/include/crypto/pool.h
+++ b/include/crypto/pool.h
@@ -4,8 +4,6 @@
 
 #include <crypto/hash.h>
 
-#define DEFAULT_CRYPTO_POOL_SCRATCH_SZ	128
-
 struct crypto_pool {
 	void *scratch;
 };
@@ -20,6 +18,7 @@ struct crypto_pool_ahash {
 	struct ahash_request *req;
 };
 
+int crypto_pool_reserve_scratch(unsigned long size);
 int crypto_pool_alloc_ahash(const char *alg);
 void crypto_pool_add(unsigned int id);
 void crypto_pool_release(unsigned int id);
-- 
2.39.0

