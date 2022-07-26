Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F59A581ADC
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 22:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239871AbiGZUQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 16:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239839AbiGZUQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 16:16:16 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8B722292
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:16:10 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id ay11-20020a05600c1e0b00b003a3013da120so6551wmb.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pXanxk9kkSH5IzZhG+IrzCgXJT5SaMoTxGMdgKi88Ao=;
        b=aOTdaJR7DRCHTIhcRrNUKxttpjYsSYzUN56FfDWDFzWSCG98auk7DNhiske4HaC3zG
         cS6h+UesI+/EQl/sHZpkP7AsceKUhdlWOjCCO3rXGmOU7O6FegMwB4L8sFyYH9uL0KLU
         UKsGcQMbRLxqcQ+tphoCYKCx6EqnRaRP9idnG+bIn08ahovsjwxGm6YMATBHXTlbjgiS
         fWk6KsehukN3u1IN5gy6zWnI59fMaGzddwvFRpExwBo5b4rlTSqWtz8XwLEYXUS0WeZ/
         kE0+yP1n5ukWYeqlSd0NDKImOFfrKY9RToA5QaWiBhAsjw6KRTL8ApD3o9t+OickTtBz
         ysBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pXanxk9kkSH5IzZhG+IrzCgXJT5SaMoTxGMdgKi88Ao=;
        b=l27N5cWQG9GT+AgYkSdREGvszR1vEdmDu9IlqkNTTbvjMwAgpEl2bXnXe1KuqGW10W
         IYRW3o+n73n5TKleYFREMMRddtRzKnZ0u516yMwVewO3Ik7vKLMjUELDRn6VRw2Cvn7y
         PbCTZahLvl6e5leffuw2LhUgkywhqYXtCpycm8g4sCji0/srnb79VkofaekJ1uK/5lA0
         2X1LSo9nQmHme6p5hQ4qZTnVd7ooBAJV3+is6rNOYzywubRVdqVRBKr4OX5RgTBp2Pew
         M2mtQBDlDOUqRbYP5xeojL65xcQBdh+ZH0GJuDbbZXrKTWcFTrLHPW/KaziXOH3VXjMg
         Ufaw==
X-Gm-Message-State: AJIora9lgq41HE//a85I0bxg3RAe1KcmV9tno92Qa52qE8N3yKmlNtLg
        mbq8iZW3OSVOMWMNHL3RVVPLgw==
X-Google-Smtp-Source: AGRyM1vN2dLizczxw8G9+ojw1TT85gS1AkDW1LlK5/c4Vuq3soc//mjpjF9+MdBOjk0uYiaWbIipjg==
X-Received: by 2002:a05:600c:2212:b0:3a3:328:5bd2 with SMTP id z18-20020a05600c221200b003a303285bd2mr568174wml.146.1658866568443;
        Tue, 26 Jul 2022 13:16:08 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c3b0600b003a320e6f011sm28073wms.1.2022.07.26.13.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 13:16:08 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 1/6] crypto: Introduce crypto_pool
Date:   Tue, 26 Jul 2022 21:15:55 +0100
Message-Id: <20220726201600.1715505-2-dima@arista.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220726201600.1715505-1-dima@arista.com>
References: <20220726201600.1715505-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a per-CPU pool of async crypto requests that can be used
in bh-disabled contexts (designed with net RX/TX softirqs as users in
mind). Allocation can sleep and is a slow-path.
Initial implementation has only ahash as a backend and a fix-sized array
of possible algorithms used in parallel.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 crypto/Kconfig        |   6 +
 crypto/Makefile       |   1 +
 crypto/crypto_pool.c  | 287 ++++++++++++++++++++++++++++++++++++++++++
 include/crypto/pool.h |  34 +++++
 4 files changed, 328 insertions(+)
 create mode 100644 crypto/crypto_pool.c
 create mode 100644 include/crypto/pool.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index bb427a835e44..aeddaa3dcc77 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -2128,6 +2128,12 @@ config CRYPTO_STATS
 config CRYPTO_HASH_INFO
 	bool
 
+config CRYPTO_POOL
+	tristate "Per-CPU crypto pool"
+	default n
+	help
+	  Per-CPU pool of crypto requests ready for usage in atomic contexts.
+
 source "drivers/crypto/Kconfig"
 source "crypto/asymmetric_keys/Kconfig"
 source "certs/Kconfig"
diff --git a/crypto/Makefile b/crypto/Makefile
index 167c004dbf4f..6d1d9801b76b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_CRYPTO_ACOMP2) += crypto_acompress.o
 cryptomgr-y := algboss.o testmgr.o
 
 obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
+obj-$(CONFIG_CRYPTO_POOL) += crypto_pool.o
 obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
 crypto_user-y := crypto_user_base.o
 crypto_user-$(CONFIG_CRYPTO_STATS) += crypto_user_stat.o
diff --git a/crypto/crypto_pool.c b/crypto/crypto_pool.c
new file mode 100644
index 000000000000..c668c02499b7
--- /dev/null
+++ b/crypto/crypto_pool.c
@@ -0,0 +1,287 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <crypto/pool.h>
+#include <linux/kref.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
+
+static unsigned long scratch_size = DEFAULT_CRYPTO_POOL_SCRATCH_SZ;
+static DEFINE_PER_CPU(void *, crypto_pool_scratch);
+
+struct crypto_pool_entry {
+	struct ahash_request * __percpu *req;
+	const char			*alg;
+	struct kref			kref;
+	bool				needs_key;
+};
+
+#define CPOOL_SIZE (PAGE_SIZE/sizeof(struct crypto_pool_entry))
+static struct crypto_pool_entry cpool[CPOOL_SIZE];
+static int last_allocated;
+static DEFINE_MUTEX(cpool_mutex);
+
+static int crypto_pool_scratch_alloc(void)
+{
+	int cpu;
+
+	lockdep_assert_held(&cpool_mutex);
+
+	for_each_possible_cpu(cpu) {
+		void *scratch = per_cpu(crypto_pool_scratch, cpu);
+
+		if (scratch)
+			continue;
+
+		scratch = kmalloc_node(scratch_size, GFP_KERNEL,
+				       cpu_to_node(cpu));
+		if (!scratch)
+			return -ENOMEM;
+		per_cpu(crypto_pool_scratch, cpu) = scratch;
+	}
+	return 0;
+}
+
+static void crypto_pool_scratch_free(void)
+{
+	int cpu;
+
+	lockdep_assert_held(&cpool_mutex);
+
+	for_each_possible_cpu(cpu) {
+		void *scratch = per_cpu(crypto_pool_scratch, cpu);
+
+		if (!scratch)
+			continue;
+		per_cpu(crypto_pool_scratch, cpu) = NULL;
+		kfree(scratch);
+	}
+}
+
+static int __cpool_alloc_ahash(struct crypto_pool_entry *e, const char *alg)
+{
+	struct crypto_ahash *hash;
+	int cpu, ret = -ENOMEM;
+
+	e->alg = kstrdup(alg, GFP_KERNEL);
+	if (!e->alg)
+		return -ENOMEM;
+
+	e->req = alloc_percpu(struct ahash_request *);
+	if (!e->req)
+		goto out_free_alg;
+
+	hash = crypto_alloc_ahash(alg, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(hash)) {
+		ret = PTR_ERR(hash);
+		goto out_free_req;
+	}
+
+	/* If hash has .setkey(), allocate ahash per-cpu, not only request */
+	e->needs_key = crypto_ahash_get_flags(hash) & CRYPTO_TFM_NEED_KEY;
+
+	for_each_possible_cpu(cpu) {
+		struct ahash_request *req;
+
+		if (!hash)
+			hash = crypto_alloc_ahash(alg, 0, CRYPTO_ALG_ASYNC);
+		if (IS_ERR(hash))
+			goto out_free;
+
+		req = ahash_request_alloc(hash, GFP_KERNEL);
+		if (!req)
+			goto out_free;
+
+		ahash_request_set_callback(req, 0, NULL, NULL);
+
+		*per_cpu_ptr(e->req, cpu) = req;
+
+		if (e->needs_key)
+			hash = NULL;
+	}
+	kref_init(&e->kref);
+	return 0;
+
+out_free:
+	if (!IS_ERR_OR_NULL(hash) && e->needs_key)
+		crypto_free_ahash(hash);
+
+	for_each_possible_cpu(cpu) {
+		if (*per_cpu_ptr(e->req, cpu) == NULL)
+			break;
+		hash = crypto_ahash_reqtfm(*per_cpu_ptr(e->req, cpu));
+		ahash_request_free(*per_cpu_ptr(e->req, cpu));
+		if (e->needs_key) {
+			crypto_free_ahash(hash);
+			hash = NULL;
+		}
+	}
+
+	if (hash)
+		crypto_free_ahash(hash);
+out_free_req:
+	free_percpu(e->req);
+out_free_alg:
+	kfree(e->alg);
+	e->alg = NULL;
+	return ret;
+}
+
+/**
+ * crypto_pool_alloc_ahash - allocates pool for ahash requests
+ * @alg: name of async hash algorithm
+ */
+int crypto_pool_alloc_ahash(const char *alg)
+{
+	unsigned int i;
+	int err;
+
+	/* slow-path */
+	mutex_lock(&cpool_mutex);
+	err = crypto_pool_scratch_alloc();
+	if (err)
+		goto out;
+
+	for (i = 0; i < last_allocated; i++) {
+		if (cpool[i].alg && !strcmp(cpool[i].alg, alg)) {
+			kref_get(&cpool[i].kref);
+			goto out;
+		}
+	}
+
+	for (i = 0; i < last_allocated; i++) {
+		if (!cpool[i].alg)
+			break;
+	}
+	if (i >= CPOOL_SIZE) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	err = __cpool_alloc_ahash(&cpool[i], alg);
+	if (!err && last_allocated <= i)
+		last_allocated++;
+out:
+	mutex_unlock(&cpool_mutex);
+	return err ?: (int)i;
+}
+EXPORT_SYMBOL_GPL(crypto_pool_alloc_ahash);
+
+static void __cpool_free_entry(struct crypto_pool_entry *e)
+{
+	struct crypto_ahash *hash = NULL;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		if (*per_cpu_ptr(e->req, cpu) == NULL)
+			continue;
+
+		hash = crypto_ahash_reqtfm(*per_cpu_ptr(e->req, cpu));
+		ahash_request_free(*per_cpu_ptr(e->req, cpu));
+		if (e->needs_key) {
+			crypto_free_ahash(hash);
+			hash = NULL;
+		}
+	}
+	if (hash)
+		crypto_free_ahash(hash);
+	free_percpu(e->req);
+	kfree(e->alg);
+	memset(e, 0, sizeof(*e));
+}
+
+static void cpool_cleanup_work_cb(struct work_struct *work)
+{
+	unsigned int i;
+	bool free_scratch = true;
+
+	mutex_lock(&cpool_mutex);
+	for (i = 0; i < last_allocated; i++) {
+		if (kref_read(&cpool[i].kref) > 0) {
+			free_scratch = false;
+			continue;
+		}
+		if (!cpool[i].alg)
+			continue;
+		__cpool_free_entry(&cpool[i]);
+	}
+	if (free_scratch)
+		crypto_pool_scratch_free();
+	mutex_unlock(&cpool_mutex);
+}
+
+static DECLARE_WORK(cpool_cleanup_work, cpool_cleanup_work_cb);
+static void cpool_schedule_cleanup(struct kref *kref)
+{
+	schedule_work(&cpool_cleanup_work);
+}
+
+/**
+ * crypto_pool_release - decreases number of users for a pool. If it was
+ * the last user of the pool, releases any memory that was consumed.
+ * @id: crypto_pool that was previously allocated by crypto_pool_alloc_ahash()
+ */
+void crypto_pool_release(unsigned int id)
+{
+	if (WARN_ON_ONCE(id > last_allocated || !cpool[id].alg))
+		return;
+
+	/* slow-path */
+	kref_put(&cpool[id].kref, cpool_schedule_cleanup);
+}
+EXPORT_SYMBOL_GPL(crypto_pool_release);
+
+/**
+ * crypto_pool_add - increases number of users (refcounter) for a pool
+ * @id: crypto_pool that was previously allocated by crypto_pool_alloc_ahash()
+ */
+void crypto_pool_add(unsigned int id)
+{
+	if (WARN_ON_ONCE(id > last_allocated || !cpool[id].alg))
+		return;
+	kref_get(&cpool[id].kref);
+}
+EXPORT_SYMBOL_GPL(crypto_pool_add);
+
+/**
+ * crypto_pool_get - disable bh and start using crypto_pool
+ * @id: crypto_pool that was previously allocated by crypto_pool_alloc_ahash()
+ * @c: returned crypto_pool for usage (uninitialized on failure)
+ */
+int crypto_pool_get(unsigned int id, struct crypto_pool *c)
+{
+	struct crypto_pool_ahash *ret = (struct crypto_pool_ahash *)c;
+
+	local_bh_disable();
+	if (WARN_ON_ONCE(id > last_allocated || !cpool[id].alg)) {
+		local_bh_enable();
+		return -EINVAL;
+	}
+	ret->req = *this_cpu_ptr(cpool[id].req);
+	ret->base.scratch = this_cpu_read(crypto_pool_scratch);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_pool_get);
+
+/**
+ * crypto_pool_algo - return algorithm of crypto_pool
+ * @id: crypto_pool that was previously allocated by crypto_pool_alloc_ahash()
+ * @buf: buffer to return name of algorithm
+ * @buf_len: size of @buf
+ */
+size_t crypto_pool_algo(unsigned int id, char *buf, size_t buf_len)
+{
+	size_t ret = 0;
+
+	/* slow-path */
+	mutex_lock(&cpool_mutex);
+	if (cpool[id].alg)
+		ret = strscpy(buf, cpool[id].alg, buf_len);
+	mutex_unlock(&cpool_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_pool_algo);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Per-CPU pool of crypto requests");
diff --git a/include/crypto/pool.h b/include/crypto/pool.h
new file mode 100644
index 000000000000..2c61aa45faff
--- /dev/null
+++ b/include/crypto/pool.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _CRYPTO_POOL_H
+#define _CRYPTO_POOL_H
+
+#include <crypto/hash.h>
+
+#define DEFAULT_CRYPTO_POOL_SCRATCH_SZ	128
+
+struct crypto_pool {
+	void *scratch;
+};
+
+/*
+ * struct crypto_pool_ahash - per-CPU pool of ahash_requests
+ * @base: common members that can be used by any async crypto ops
+ * @req: pre-allocated ahash request
+ */
+struct crypto_pool_ahash {
+	struct crypto_pool base;
+	struct ahash_request *req;
+};
+
+int crypto_pool_alloc_ahash(const char *alg);
+void crypto_pool_add(unsigned int id);
+void crypto_pool_release(unsigned int id);
+
+int crypto_pool_get(unsigned int id, struct crypto_pool *c);
+static inline void crypto_pool_put(void)
+{
+	local_bh_enable();
+}
+size_t crypto_pool_algo(unsigned int id, char *buf, size_t buf_len);
+
+#endif /* _CRYPTO_POOL_H */
-- 
2.36.1

