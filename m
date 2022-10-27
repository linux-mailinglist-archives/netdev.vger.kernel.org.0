Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21286102EB
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbiJ0UoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236615AbiJ0UoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:44:00 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA677173C
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:43:59 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id a14so4172738wru.5
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RxfT3udHjY/1MFp4/+Y9TLXrCrikupuEdzT2r1qucRk=;
        b=WObTEuSpCZ6kMlzBm/Y1HjE9FvJSeykn2DUTcsVTC2eDycf2ZDGPUcrb6r7L/423El
         ZuPxAEamLFG8SeagtCXwBy5pSPP+SPHLPCAZ69QkfrsuhUAbe8J3usllgZj0Wb0pak7D
         NvVxE45Ve5j4+4at2dVO+/HKBYzr1h1+M4dDQtm3VDf0fEnOOhBaQRI4rBw80CwPGew8
         5GnuzdG1g15c5nYNOEiTVTrMlgrL4s9YKXC0J6XyJKcYiXhBSzPr/nY7HlQVFjw+fvvx
         aMFfDbEp+su/jwS7NkHAVa08sXoo//f0GGNa0Zbsa6mccpRHxksq0jQcP4biMrmUBdgj
         uUuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RxfT3udHjY/1MFp4/+Y9TLXrCrikupuEdzT2r1qucRk=;
        b=1Xpc+ZOmCdP4ZJqVcK5DncGUKRjCcxngrT8MnNsvqVYn5e6Ob2p4KS0oqQUPnwJoNu
         jc3PietiJgebfGLCK6wjQ8g7yE7rVqX+v6/tKJz22b2dLhj1q7mdsYVulgaBe9lMjPLt
         bbi+XJnhK4S9CIe94Xp/leEeh3ie6NOAmI2PkyNqE0Zaqc1rInt8XqaKzp3IIeSBYBfv
         PtsTCIY2S2Lcj8XNtsCMf/1cF96EwfQT52wUdY2RHf9yw+XiEesyT/jd/1grvA6iW6Cd
         3ADt6ZQD19ihcDlXeJxBG/Q9x/0Ni2fyYjZ1bZj7B7Z6AB5tkugvkhjcZT1ltkjf//5V
         csjQ==
X-Gm-Message-State: ACrzQf2jcjU7dFb17/FNTkN7KlnnksiJ3SWF24CylSxDzLyrR7PLwS1G
        hMouzshd0vxMcwEOjtCZ6Rea0w==
X-Google-Smtp-Source: AMsMyM5uB1RtXoPm8/baWtcX8vcSmcCs4lg1PeNXA3NJ9eLfk5R01WukaeXAdIrN4jxeBP3JtYByLQ==
X-Received: by 2002:a05:6000:811:b0:236:622d:a7d6 with SMTP id bt17-20020a056000081100b00236622da7d6mr19178175wrb.258.1666903438049;
        Thu, 27 Oct 2022 13:43:58 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:43:57 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 02/36] crypto_pool: Add crypto_pool_reserve_scratch()
Date:   Thu, 27 Oct 2022 21:43:13 +0100
Message-Id: <20221027204347.529913-3-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 768d331e626b..e002cd321e79 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1397,6 +1397,12 @@ config CRYPTO_POOL
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
index 37131952c5a7..2f1deb3f5218 100644
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
+#define FREE_BATCH_SIZE		64
+int crypto_pool_reserve_scratch(unsigned long size)
 {
-	int cpu;
-
-	lockdep_assert_held(&cpool_mutex);
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
2.38.1

