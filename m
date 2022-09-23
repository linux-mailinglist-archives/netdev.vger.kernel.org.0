Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722E95E8312
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiIWUNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiIWUNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:13:34 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607B11231D5
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:31 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id x18so1555656wrm.7
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=23/CF7tfLkvh+nww9EnlgmTsumKJWYoWUnec63NKi1A=;
        b=gV+UxtY0g3SlZ6hGfED5aEL/inzqrRA1e4THqvQHPjE2AdW/D+4jgRiTmpGKZ2QqMT
         LtfUMz69xutCsGO2UKesIC2LZlXHkw8Y2dwVvqP74PcsHtSTMYbqVf4xVAGa7KRwBVo2
         IcX3I8KX6Mog4RlYe6IJ9NPEKjyhuwxiF4eg1Lx9RoG3DRj6UpGmG3Ij5lJXKkSG9IPX
         DAeqzrJ1fwVgyAxGkdp2N6XVFUE8ie0Vz9RsFJ7SYRAtKi/9ZF0HWBYm1zcOut8czPdO
         9eL0B02akLrXYpX1xzJrxKKwEtHx9wPxsSNC1WjO/qSxE0W+3+cGnw42grk9udSoLvDm
         FVKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=23/CF7tfLkvh+nww9EnlgmTsumKJWYoWUnec63NKi1A=;
        b=D5RKK9MXyI2jziwqs+vVW4HAJTukm6GO8F/OMm7AUCwKhsABgnJEHFrZ/luI3wxlgy
         VUK/IfomNouLZqFNeVn6FAQ/WN5HpNe2ETFA8AvU9S4Y/GC/xEEBw8mQp1YEaiTa2FXU
         1hG1AndhuS5VW8/lU5wqzN7QyY7dVMRuU0FbwRLslnYhOZHybvegiWMuiLbZYhm08pWk
         BAfnvxO1Al1tenquxj7qUgfDr9cCu06HB8IsGyniy3YEReJ8kOvhXgZR+qLAHPPUHHwO
         rT4dTcn8tsPhEaV5KEMB3bFbIxMxbTKxvmC5BBl9F8hM/tzNeOVEx+T2EpLXqzXhnDMK
         pd7w==
X-Gm-Message-State: ACrzQf1e1KhiZkUDtAY1pdiNbBMZNwNzcBg8UxhmRBq7DKzFZDUmnT+E
        jCgPSZn2P9kKwo+zFjGZXBISgQ==
X-Google-Smtp-Source: AMsMyM5EXomzqDs/qpu1iRm5KQDCbfOcAkYsGQRSh6u82J4RGOI9uudHf6vEYaDBlN9jF6lciDbH4Q==
X-Received: by 2002:a5d:654d:0:b0:22a:ff55:e9c9 with SMTP id z13-20020a5d654d000000b0022aff55e9c9mr6068725wrv.14.1663964009896;
        Fri, 23 Sep 2022 13:13:29 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:13:29 -0700 (PDT)
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
Subject: [PATCH v2 02/35] crypto_pool: Add crypto_pool_reserve_scratch()
Date:   Fri, 23 Sep 2022 21:12:46 +0100
Message-Id: <20220923201319.493208-3-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
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
 crypto/Kconfig        |  6 +++++
 crypto/crypto_pool.c  | 63 +++++++++++++++++++++++++++++++++----------
 include/crypto/pool.h |  3 +--
 3 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index aeddaa3dcc77..e5865be483be 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -2134,6 +2134,12 @@ config CRYPTO_POOL
 	help
 	  Per-CPU pool of crypto requests ready for usage in atomic contexts.
 
+config CRYPTO_POOL_DEFAULT_SCRATCH_SIZE
+	hex "Per-CPU default scratch area size"
+	depends on CRYPTO_POOL
+	default 0x100
+	range 0x100 0x10000
+
 source "drivers/crypto/Kconfig"
 source "crypto/asymmetric_keys/Kconfig"
 source "certs/Kconfig"
diff --git a/crypto/crypto_pool.c b/crypto/crypto_pool.c
index 37131952c5a7..a1ad35c24f09 100644
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
@@ -22,26 +23,61 @@ static struct crypto_pool_entry cpool[CPOOL_SIZE];
 static unsigned int cpool_populated;
 static DEFINE_MUTEX(cpool_mutex);
 
-static int crypto_pool_scratch_alloc(void)
+static void __set_scratch(void *scratch)
 {
-	int cpu;
+	kfree(this_cpu_read(crypto_pool_scratch));
+	this_cpu_write(crypto_pool_scratch, scratch);
+}
 
-	lockdep_assert_held(&cpool_mutex);
+/* Slow-path */
+/**
+ * crypto_pool_reserve_scratch - re-allocates scratch buffer, slow-path
+ * @size: request size for the scratch/temp buffer
+ */
+int crypto_pool_reserve_scratch(unsigned long size)
+{
+	int cpu, err = 0;
 
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
+		void *scratch;
 
-		if (scratch)
-			continue;
+		scratch = kmalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
+		if (!scratch) {
+			err = -ENOMEM;
+			break;
+		}
 
-		scratch = kmalloc_node(scratch_size, GFP_KERNEL,
-				       cpu_to_node(cpu));
-		if (!scratch)
-			return -ENOMEM;
-		per_cpu(crypto_pool_scratch, cpu) = scratch;
+		if (!cpu_online(cpu)) {
+			kfree(per_cpu(crypto_pool_scratch, cpu));
+			per_cpu(crypto_pool_scratch, cpu) = scratch;
+			continue;
+		}
+		err = smp_call_function_single(cpu, __set_scratch, scratch, 1);
+		if (err) {
+			kfree(scratch);
+			break;
+		}
 	}
-	return 0;
+
+	cpus_read_unlock();
+	scratch_size = size;
+	mutex_unlock(&cpool_mutex);
+	return err;
 }
+EXPORT_SYMBOL_GPL(crypto_pool_reserve_scratch);
 
 static void crypto_pool_scratch_free(void)
 {
@@ -138,7 +174,6 @@ int crypto_pool_alloc_ahash(const char *alg)
 
 	/* slow-path */
 	mutex_lock(&cpool_mutex);
-
 	for (i = 0; i < cpool_populated; i++) {
 		if (cpool[i].alg && !strcmp(cpool[i].alg, alg)) {
 			if (kref_read(&cpool[i].kref) > 0) {
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
2.37.2

