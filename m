Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4B359898E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345245AbiHRRA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345308AbiHRRAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:00:25 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023DECAC4D
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:17 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id bs25so2435311wrb.2
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=3fqnnsku3QxqTPl7elY558LSX4G3DY2EK2AyDbfNKys=;
        b=eVNM23MWi9DGYRreT1Nrk6LL+8eemUOGXLdX/+2z0h/XQMBbWnHaTv/s3uLL5/wJcP
         GUlYU+UcUZC2PQy6WafyHBC8ML7z7hwLxRbSlXYzrbKcETADFqh2Du3E9RFvuB0wfTtK
         SVnzsKUN01KygW3EDRX6b8h9VNL7U8b5+l4SDUYtvbrUCIPYWk9+kMJPQzPSKQhv6I+/
         HK7sMarLoHfei+H89sUEq8er1cUICUZj/BRVINBhTtDTG2kSUgr9EtBfFe0CzFk2Jbiw
         i+N78+98kjtGuUOY0akVjppp7Q2EobDsr/6+nKJeiEZH4T1DnVaCVcaGTsUefEP2JhKn
         8sfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=3fqnnsku3QxqTPl7elY558LSX4G3DY2EK2AyDbfNKys=;
        b=LANdbekBIlwq667ze+Oomh0m3X9CBAoAFQaVlZ8wFpyNCEZdnv6FIhF1f3Aac96JpI
         qDOihDOoidmpO/vCsT9wxR8cN4Igg1JbjfubV6ADmjgMXipLD5Blfb3HPnf2ZhDX1jJI
         N1GjTCN5medGr8TV3ePx7wElr22vPKyQYj80Sa7SgcTtlEjIzIpilW8z3jXyyMg+RoPQ
         H2ByTMNFSXIgPUtCGzTBpuXzTo3WFZlposaiRpvGB54cH4Kau70JSvolV4JG/mbgOeS3
         EPbYhOH+8iBXpLq12TA4aKykb2Ecdu7wqUYJMENxg3tNYqj/Zz41czi8zKofKTVIgozY
         LXgw==
X-Gm-Message-State: ACgBeo0SVOTFnFX9DuGO9TIf95rr5xMimzoXD9372JqV90fg4PzWE7DX
        BLmlUdRXpiLCaQDoPHTD/pyspg==
X-Google-Smtp-Source: AA6agR6pHX0KBrrBFjoZxk7gXB7J2ga3HP4VqeEj9R1te3T+j/h8xDu+EWr/NPk37fBxiW8/DgnAYg==
X-Received: by 2002:a05:6000:80b:b0:21e:d62e:b282 with SMTP id bt11-20020a056000080b00b0021ed62eb282mr2121768wrb.557.1660842016009;
        Thu, 18 Aug 2022 10:00:16 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:15 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
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
Subject: [PATCH 02/31] crypto_pool: Add crypto_pool_reserve_scratch()
Date:   Thu, 18 Aug 2022 17:59:36 +0100
Message-Id: <20220818170005.747015-3-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 crypto/crypto_pool.c  | 68 +++++++++++++++++++++++++++++++------------
 include/crypto/pool.h |  3 +-
 3 files changed, 57 insertions(+), 20 deletions(-)

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
index a5b6e6cf818a..9e2ac4eb1138 100644
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
@@ -19,29 +20,64 @@ struct crypto_pool_entry {
 
 #define CPOOL_SIZE (PAGE_SIZE/sizeof(struct crypto_pool_entry))
 static struct crypto_pool_entry cpool[CPOOL_SIZE];
-static int last_allocated;
+static unsigned int last_allocated;
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
@@ -139,10 +175,6 @@ int crypto_pool_alloc_ahash(const char *alg)
 
 	/* slow-path */
 	mutex_lock(&cpool_mutex);
-	err = crypto_pool_scratch_alloc();
-	if (err)
-		goto out;
-
 	for (i = 0; i < last_allocated; i++) {
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

