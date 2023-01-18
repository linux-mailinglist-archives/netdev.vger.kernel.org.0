Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F63672AB8
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbjARVlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjARVlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:41:25 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5DE16AC4
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:41:24 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d2so15213277wrp.8
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3HZPKYb2PIVdmeKOK5m1pvrqCNkMbBHNc0IpoK2AHjU=;
        b=VKHWS9hxSMvklXJwfn/LnCRZqfrdx5Eo5olrqvSKObW/WSn3uMMG04tdASYTVH5k+C
         NBWdW0KR9AjLXGWFrVq0h7/KV5H4aLXcx6AqAZqBSnzlqmUeJiUS60zM0VSgJNmZaeg7
         GJhndnVcMFGhJA5RD6ewKcE5XPSE7Y/LV69iv2yHm3vvcbyBVymRfSNtumnaGonO2qWn
         1lYIVQZYzanD6f1xNbx86Lzxsu2MHh6VD5TIZ7zmyiyGOkUjNNSjdSe0XXekYWKXaCrP
         aXC928rjrNgb+FGnlQDFrLbQ0XRT11BRGv3nvaA+zBai2v7yxFAvJSgp4UvXFSGcABu4
         /SNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3HZPKYb2PIVdmeKOK5m1pvrqCNkMbBHNc0IpoK2AHjU=;
        b=VK94q/vxK7SmVCktO2HkWhyBP+dKNavZVjsciOTn/XGxUntQqlFxUTsagZqBH8qQi6
         Un16ZEhEVz7negsE8UHlObv6IVnAcSRYYerPFH1bq+vEdZxRHNy5aOKWkP3NXHgpqjY5
         pQ/hkXPBkrjRfRu+uC5aNoNf9mUl4srH2WIZz9eWjM1C6QRrq+IAO07cMts2cDLLnadN
         dmZTudEom+Ex5VUe6WE6yMTM/cN3odeb0lSD+4C2aEt3vHEn4gxkhHqJqk/PO8MF9KZV
         lZQY4xX8RIwl44/eMAJBd7yRomp0XITkC3HtS4/CQMpsmnv3S/VjKAWVbnORLmQjj1qn
         KBKg==
X-Gm-Message-State: AFqh2koZShex+tbmsdobwLpvIMOxFLbDKAy+jnFNBSO/bAsZxBn/5k3C
        Bbp6Swsqz/obd/Kux5ARQcMjAg==
X-Google-Smtp-Source: AMrXdXvy00IeeTk40sNMiKgiI1Qet+2cRvTnJgWKC3ywU8iPspN+nu/pIfzgcTvOGM+7v4FG5wlOXw==
X-Received: by 2002:a5d:5227:0:b0:275:618c:83ea with SMTP id i7-20020a5d5227000000b00275618c83eamr7288209wra.29.1674078083019;
        Wed, 18 Jan 2023 13:41:23 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m5-20020a056000024500b00267bcb1bbe5sm33186349wrz.56.2023.01.18.13.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 13:41:22 -0800 (PST)
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
Subject: [PATCH v4 3/4] crypto/net/ipv6: sr: Switch to using crypto_pool
Date:   Wed, 18 Jan 2023 21:41:10 +0000
Message-Id: <20230118214111.394416-4-dima@arista.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118214111.394416-1-dima@arista.com>
References: <20230118214111.394416-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The conversion to use crypto_pool has the following upsides:
- now SR uses asynchronous API which may potentially free CPU cycles and
  improve performance for of CPU crypto algorithm providers;
- hash descriptors now don't have to be allocated on boot, but only at
  the moment SR starts using HMAC and until the last HMAC secret is
  deleted;
- potentially reuse ahash_request(s) for different users
- allocate only one per-CPU scratch buffer rather than a new one for
  each user
- have a common API for net/ users that need ahash on RX/TX fast path

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/seg6_hmac.h |   9 --
 net/ipv6/Kconfig        |   1 +
 net/ipv6/seg6.c         |  14 +--
 net/ipv6/seg6_hmac.c    | 207 +++++++++++++++-------------------------
 4 files changed, 81 insertions(+), 150 deletions(-)

diff --git a/include/net/seg6_hmac.h b/include/net/seg6_hmac.h
index 2b5d2ee5613e..8aba24036143 100644
--- a/include/net/seg6_hmac.h
+++ b/include/net/seg6_hmac.h
@@ -32,13 +32,6 @@ struct seg6_hmac_info {
 	u8 alg_id;
 };
 
-struct seg6_hmac_algo {
-	u8 alg_id;
-	char name[64];
-	struct crypto_shash * __percpu *tfms;
-	struct shash_desc * __percpu *shashs;
-};
-
 extern int seg6_hmac_compute(struct seg6_hmac_info *hinfo,
 			     struct ipv6_sr_hdr *hdr, struct in6_addr *saddr,
 			     u8 *output);
@@ -49,8 +42,6 @@ extern int seg6_hmac_info_del(struct net *net, u32 key);
 extern int seg6_push_hmac(struct net *net, struct in6_addr *saddr,
 			  struct ipv6_sr_hdr *srh);
 extern bool seg6_hmac_validate_skb(struct sk_buff *skb);
-extern int seg6_hmac_init(void);
-extern void seg6_hmac_exit(void);
 extern int seg6_hmac_net_init(struct net *net);
 extern void seg6_hmac_net_exit(struct net *net);
 
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 658bfed1df8b..e9aa99180f85 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -305,6 +305,7 @@ config IPV6_SEG6_HMAC
 	bool "IPv6: Segment Routing HMAC support"
 	depends on IPV6
 	select CRYPTO
+	select CRYPTO_POOL
 	select CRYPTO_HMAC
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 29346a6eec9f..a1e4f3079c49 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -526,12 +526,6 @@ int __init seg6_init(void)
 		goto out_unregister_pernet;
 
 	err = seg6_local_init();
-	if (err)
-		goto out_unregister_pernet;
-#endif
-
-#ifdef CONFIG_IPV6_SEG6_HMAC
-	err = seg6_hmac_init();
 	if (err)
 		goto out_unregister_iptun;
 #endif
@@ -540,13 +534,12 @@ int __init seg6_init(void)
 
 out:
 	return err;
-#ifdef CONFIG_IPV6_SEG6_HMAC
-out_unregister_iptun:
+
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
 	seg6_local_exit();
+out_unregister_iptun:
 	seg6_iptunnel_exit();
 #endif
-#endif
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
 out_unregister_pernet:
 	unregister_pernet_subsys(&ip6_segments_ops);
@@ -558,9 +551,6 @@ int __init seg6_init(void)
 
 void seg6_exit(void)
 {
-#ifdef CONFIG_IPV6_SEG6_HMAC
-	seg6_hmac_exit();
-#endif
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
 	seg6_iptunnel_exit();
 #endif
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index d43c50a7310d..2395d227018c 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -35,6 +35,7 @@
 #include <net/xfrm.h>
 
 #include <crypto/hash.h>
+#include <crypto/pool.h>
 #include <net/seg6.h>
 #include <net/genetlink.h>
 #include <net/seg6_hmac.h>
@@ -70,6 +71,12 @@ static const struct rhashtable_params rht_params = {
 	.obj_cmpfn		= seg6_hmac_cmpfn,
 };
 
+struct seg6_hmac_algo {
+	u8 alg_id;
+	char name[64];
+	int crypto_pool_id;
+};
+
 static struct seg6_hmac_algo hmac_algos[] = {
 	{
 		.alg_id = SEG6_HMAC_ALGO_SHA1,
@@ -115,55 +122,17 @@ static struct seg6_hmac_algo *__hmac_get_algo(u8 alg_id)
 	return NULL;
 }
 
-static int __do_hmac(struct seg6_hmac_info *hinfo, const char *text, u8 psize,
-		     u8 *output, int outlen)
-{
-	struct seg6_hmac_algo *algo;
-	struct crypto_shash *tfm;
-	struct shash_desc *shash;
-	int ret, dgsize;
-
-	algo = __hmac_get_algo(hinfo->alg_id);
-	if (!algo)
-		return -ENOENT;
-
-	tfm = *this_cpu_ptr(algo->tfms);
-
-	dgsize = crypto_shash_digestsize(tfm);
-	if (dgsize > outlen) {
-		pr_debug("sr-ipv6: __do_hmac: digest size too big (%d / %d)\n",
-			 dgsize, outlen);
-		return -ENOMEM;
-	}
-
-	ret = crypto_shash_setkey(tfm, hinfo->secret, hinfo->slen);
-	if (ret < 0) {
-		pr_debug("sr-ipv6: crypto_shash_setkey failed: err %d\n", ret);
-		goto failed;
-	}
-
-	shash = *this_cpu_ptr(algo->shashs);
-	shash->tfm = tfm;
-
-	ret = crypto_shash_digest(shash, text, psize, output);
-	if (ret < 0) {
-		pr_debug("sr-ipv6: crypto_shash_digest failed: err %d\n", ret);
-		goto failed;
-	}
-
-	return dgsize;
-
-failed:
-	return ret;
-}
-
 int seg6_hmac_compute(struct seg6_hmac_info *hinfo, struct ipv6_sr_hdr *hdr,
 		      struct in6_addr *saddr, u8 *output)
 {
 	__be32 hmackeyid = cpu_to_be32(hinfo->hmackeyid);
-	u8 tmp_out[SEG6_HMAC_MAX_DIGESTSIZE];
+	struct crypto_pool_ahash hp;
+	struct seg6_hmac_algo *algo;
 	int plen, i, dgsize, wrsize;
+	struct crypto_ahash *tfm;
+	struct scatterlist sg;
 	char *ring, *off;
+	int err;
 
 	/* a 160-byte buffer for digest output allows to store highest known
 	 * hash function (RadioGatun) with up to 1216 bits
@@ -176,6 +145,10 @@ int seg6_hmac_compute(struct seg6_hmac_info *hinfo, struct ipv6_sr_hdr *hdr,
 	if (plen >= SEG6_HMAC_RING_SIZE)
 		return -EMSGSIZE;
 
+	algo = __hmac_get_algo(hinfo->alg_id);
+	if (!algo)
+		return -ENOENT;
+
 	/* Let's build the HMAC text on the ring buffer. The text is composed
 	 * as follows, in order:
 	 *
@@ -186,8 +159,36 @@ int seg6_hmac_compute(struct seg6_hmac_info *hinfo, struct ipv6_sr_hdr *hdr,
 	 * 5. All segments in the segments list (n * 128 bits)
 	 */
 
-	local_bh_disable();
+	err = crypto_pool_start(algo->crypto_pool_id, &hp.base);
+	if (err)
+		return err;
+
 	ring = this_cpu_ptr(hmac_ring);
+
+	sg_init_one(&sg, ring, plen);
+
+	tfm = crypto_ahash_reqtfm(hp.req);
+	dgsize = crypto_ahash_digestsize(tfm);
+	if (dgsize > SEG6_HMAC_MAX_DIGESTSIZE) {
+		pr_debug("digest size too big (%d / %d)\n",
+			 dgsize, SEG6_HMAC_MAX_DIGESTSIZE);
+		err = -ENOMEM;
+		goto err_end_pool;
+	}
+
+	err = crypto_ahash_setkey(tfm, hinfo->secret, hinfo->slen);
+	if (err) {
+		pr_debug("crypto_ahash_setkey failed: err %d\n", err);
+		goto err_end_pool;
+	}
+
+	err = crypto_ahash_init(hp.req);
+	if (err)
+		goto err_end_pool;
+
+	ahash_request_set_crypt(hp.req, &sg,
+				hp.base.scratch, SEG6_HMAC_MAX_DIGESTSIZE);
+
 	off = ring;
 
 	/* source address */
@@ -210,21 +211,25 @@ int seg6_hmac_compute(struct seg6_hmac_info *hinfo, struct ipv6_sr_hdr *hdr,
 		off += 16;
 	}
 
-	dgsize = __do_hmac(hinfo, ring, plen, tmp_out,
-			   SEG6_HMAC_MAX_DIGESTSIZE);
-	local_bh_enable();
+	err = crypto_ahash_update(hp.req);
+	if (err)
+		goto err_end_pool;
 
-	if (dgsize < 0)
-		return dgsize;
+	err = crypto_ahash_final(hp.req);
+	if (err)
+		goto err_end_pool;
 
 	wrsize = SEG6_HMAC_FIELD_LEN;
 	if (wrsize > dgsize)
 		wrsize = dgsize;
 
 	memset(output, 0, SEG6_HMAC_FIELD_LEN);
-	memcpy(output, tmp_out, wrsize);
+	memcpy(output, hp.base.scratch, wrsize);
+
+err_end_pool:
+	crypto_pool_end();
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(seg6_hmac_compute);
 
@@ -291,12 +296,24 @@ EXPORT_SYMBOL(seg6_hmac_info_lookup);
 int seg6_hmac_info_add(struct net *net, u32 key, struct seg6_hmac_info *hinfo)
 {
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
-	int err;
+	struct seg6_hmac_algo *algo;
+	int ret;
+
+	algo = __hmac_get_algo(hinfo->alg_id);
+	if (!algo)
+		return -ENOENT;
+
+	ret = crypto_pool_alloc_ahash(algo->name, SEG6_HMAC_MAX_DIGESTSIZE);
+	if (ret < 0)
+		return ret;
+	algo->crypto_pool_id = ret;
 
-	err = rhashtable_lookup_insert_fast(&sdata->hmac_infos, &hinfo->node,
+	ret = rhashtable_lookup_insert_fast(&sdata->hmac_infos, &hinfo->node,
 					    rht_params);
+	if (ret)
+		crypto_pool_release(algo->crypto_pool_id);
 
-	return err;
+	return ret;
 }
 EXPORT_SYMBOL(seg6_hmac_info_add);
 
@@ -304,6 +321,7 @@ int seg6_hmac_info_del(struct net *net, u32 key)
 {
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
 	struct seg6_hmac_info *hinfo;
+	struct seg6_hmac_algo *algo;
 	int err = -ENOENT;
 
 	hinfo = rhashtable_lookup_fast(&sdata->hmac_infos, &key, rht_params);
@@ -315,6 +333,12 @@ int seg6_hmac_info_del(struct net *net, u32 key)
 	if (err)
 		goto out;
 
+	algo = __hmac_get_algo(hinfo->alg_id);
+	if (algo)
+		crypto_pool_release(algo->crypto_pool_id);
+	else
+		WARN_ON_ONCE(1);
+
 	seg6_hinfo_release(hinfo);
 
 out:
@@ -348,58 +372,6 @@ int seg6_push_hmac(struct net *net, struct in6_addr *saddr,
 }
 EXPORT_SYMBOL(seg6_push_hmac);
 
-static int seg6_hmac_init_algo(void)
-{
-	struct seg6_hmac_algo *algo;
-	struct crypto_shash *tfm;
-	struct shash_desc *shash;
-	int i, alg_count, cpu;
-
-	alg_count = ARRAY_SIZE(hmac_algos);
-
-	for (i = 0; i < alg_count; i++) {
-		struct crypto_shash **p_tfm;
-		int shsize;
-
-		algo = &hmac_algos[i];
-		algo->tfms = alloc_percpu(struct crypto_shash *);
-		if (!algo->tfms)
-			return -ENOMEM;
-
-		for_each_possible_cpu(cpu) {
-			tfm = crypto_alloc_shash(algo->name, 0, 0);
-			if (IS_ERR(tfm))
-				return PTR_ERR(tfm);
-			p_tfm = per_cpu_ptr(algo->tfms, cpu);
-			*p_tfm = tfm;
-		}
-
-		p_tfm = raw_cpu_ptr(algo->tfms);
-		tfm = *p_tfm;
-
-		shsize = sizeof(*shash) + crypto_shash_descsize(tfm);
-
-		algo->shashs = alloc_percpu(struct shash_desc *);
-		if (!algo->shashs)
-			return -ENOMEM;
-
-		for_each_possible_cpu(cpu) {
-			shash = kzalloc_node(shsize, GFP_KERNEL,
-					     cpu_to_node(cpu));
-			if (!shash)
-				return -ENOMEM;
-			*per_cpu_ptr(algo->shashs, cpu) = shash;
-		}
-	}
-
-	return 0;
-}
-
-int __init seg6_hmac_init(void)
-{
-	return seg6_hmac_init_algo();
-}
-
 int __net_init seg6_hmac_net_init(struct net *net)
 {
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
@@ -407,29 +379,6 @@ int __net_init seg6_hmac_net_init(struct net *net)
 	return rhashtable_init(&sdata->hmac_infos, &rht_params);
 }
 
-void seg6_hmac_exit(void)
-{
-	struct seg6_hmac_algo *algo = NULL;
-	int i, alg_count, cpu;
-
-	alg_count = ARRAY_SIZE(hmac_algos);
-	for (i = 0; i < alg_count; i++) {
-		algo = &hmac_algos[i];
-		for_each_possible_cpu(cpu) {
-			struct crypto_shash *tfm;
-			struct shash_desc *shash;
-
-			shash = *per_cpu_ptr(algo->shashs, cpu);
-			kfree(shash);
-			tfm = *per_cpu_ptr(algo->tfms, cpu);
-			crypto_free_shash(tfm);
-		}
-		free_percpu(algo->tfms);
-		free_percpu(algo->shashs);
-	}
-}
-EXPORT_SYMBOL(seg6_hmac_exit);
-
 void __net_exit seg6_hmac_net_exit(struct net *net)
 {
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
-- 
2.39.0

