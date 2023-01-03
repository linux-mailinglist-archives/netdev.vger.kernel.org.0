Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8053965C69A
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 19:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238275AbjACSpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 13:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238199AbjACSos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 13:44:48 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540D815F2B
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 10:43:07 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id bs20so28452906wrb.3
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 10:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JbgIiDs9XOqs3x5JE++9owDgkz4yX2MsWocTUbw0/sU=;
        b=L3JVkBFECQ6Vd0S2/1jwhsAPPOkYOF3EDGIhQsoRZYDOmmRl3QreTQbB90Of9F0XqZ
         fGkgd28Ta8jP/UVMHRh9ZtR0E/+TspmLok7bnbjYK1pazHya3HutxhO/FTFRqo/mChhC
         6Zxu89mnhUVHAB89wreQmEmuPrMTwY7M0sZJUm6vCG9DYGp9s1U440WLSNemiPrZFejf
         QQ65A4xqCI9DqoDVuxi/3Hel+RWg+bHO8bXWr51YD6TLO1qxqofQ3Anwcf8r1h53qJuk
         FymYBCfSdtv2/RWJjeUQmNI8tuSpM28qoSl1BEdEmxRhDjtUVKfqQq5RkK9qm9M+Bk1b
         u0Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JbgIiDs9XOqs3x5JE++9owDgkz4yX2MsWocTUbw0/sU=;
        b=y2SauEExTjkuWENP2JzRE9+voabTJsND/PcnJjw1ZiYnLtD8x8Tw3MPOBFaLTac69T
         xZ0GuHS9HGchDQHYJz4PiUonoVMWtGo+sbz9vU9Z1k9TzEC4wjEx1picq0rp44MJ31T+
         feT3r+D2eSfuYF35HcxENQYxxyxd8Y1d4/763tD0/ICUdzuS1sm2YXGtblcMWokUR3Gc
         l1Ie1tSCfmxWqZLxyUJOV968kO6KDtqGQ6PKwWbaC2BE3cL84Mz1jLf65Hl6WNj0byry
         pF94v2fP2CuWELqF/RKZH5EK4ti4KTarQEvytnCZYPPMTDczi7a3utoCndtlLcKf4O6i
         2OHg==
X-Gm-Message-State: AFqh2kqYnIotaZ/p+dY4Zou7pM6i/n7Lnl4LHteDkDEqCeOgKbecRp+r
        35pXaI2tpIcKsW0VXds+vYPrxA==
X-Google-Smtp-Source: AMrXdXvQqdXqcMuLZKJa29c6040pa67s2LWo65W5oOrKnrxtCKAnzLA5RaY/XvMdl0Pq++MPh/ZTlA==
X-Received: by 2002:adf:f305:0:b0:277:2e27:61fa with SMTP id i5-20020adff305000000b002772e2761famr22173728wro.9.1672771385796;
        Tue, 03 Jan 2023 10:43:05 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id i18-20020a5d5232000000b0028e55b44a99sm13811578wra.17.2023.01.03.10.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 10:43:05 -0800 (PST)
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
Subject: [PATCH v2 1/5] crypto: Introduce crypto_pool
Date:   Tue,  3 Jan 2023 18:42:53 +0000
Message-Id: <20230103184257.118069-2-dima@arista.com>
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

Introduce a per-CPU pool of async crypto requests that can be used
in bh-disabled contexts (designed with net RX/TX softirqs as users in
mind). Allocation can sleep and is a slow-path.
Initial implementation has only ahash as a backend and a fix-sized array
of possible algorithms used in parallel.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 crypto/Kconfig        |   6 +
 crypto/Makefile       |   1 +
 crypto/crypto_pool.c  | 291 ++++++++++++++++++++++++++++++++++++++++++
 include/crypto/pool.h |  34 +++++
 4 files changed, 332 insertions(+)
 create mode 100644 crypto/crypto_pool.c
 create mode 100644 include/crypto/pool.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9c86f7045157..ba8d4a1f10f9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1388,6 +1388,12 @@ endmenu
 config CRYPTO_HASH_INFO
 	bool
 
+config CRYPTO_POOL
+	tristate "Per-CPU crypto pool"
+	default n
+	help
+	  Per-CPU pool of crypto requests ready for usage in atomic contexts.
+
 if !KMSAN # avoid false positives from assembly
 if ARM
 source "arch/arm/crypto/Kconfig"
diff --git a/crypto/Makefile b/crypto/Makefile
index d0126c915834..eed8f61bc93b 100644
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
index 000000000000..37131952c5a7
--- /dev/null
+++ b/crypto/crypto_pool.c
@@ -0,0 +1,291 @@
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
+static unsigned int cpool_populated;
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
+	int i, ret;
+
+	/* slow-path */
+	mutex_lock(&cpool_mutex);
+
+	for (i = 0; i < cpool_populated; i++) {
+		if (cpool[i].alg && !strcmp(cpool[i].alg, alg)) {
+			if (kref_read(&cpool[i].kref) > 0) {
+				kref_get(&cpool[i].kref);
+				ret = i;
+				goto out;
+			} else {
+				break;
+			}
+		}
+	}
+
+	for (i = 0; i < cpool_populated; i++) {
+		if (!cpool[i].alg)
+			break;
+	}
+	if (i >= CPOOL_SIZE) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	ret = __cpool_alloc_ahash(&cpool[i], alg);
+	if (!ret) {
+		ret = i;
+		if (i == cpool_populated)
+			cpool_populated++;
+	}
+out:
+	mutex_unlock(&cpool_mutex);
+	return ret;
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
+	for (i = 0; i < cpool_populated; i++) {
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
+	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg))
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
+	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg))
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
+	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg)) {
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
2.39.0

