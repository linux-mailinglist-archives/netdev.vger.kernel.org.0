Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7354E581ADF
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 22:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239839AbiGZUQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 16:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239869AbiGZUQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 16:16:22 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD8032DAF
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:16:16 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h9so21649934wrm.0
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=awxy/BDZoT0mM/P9mIhPTjV07MQDeBS6ciLhmG/Wd6U=;
        b=Mas144nsu2lGiSPU7SoK2Dkvt5JZVg0bt5YZ5uyveNMSh2MeomG6b8c0PR8essfZ1Q
         OxyDDVWcaSYFog89+hcdJRrm9vRWNeQS2kulnHwpYs9bfwmBrZpQbiLlAzfg/r6kKxjn
         deh0mXYPSOEVWcT0Rv5X+0xnkkdE6DQud2sIVROP4iJtFKe2oscy989H6b8PQ0EQ87nc
         YedkvrWDJ9z1gCK4IoW2WjiPOJzIM2oBFEg3BsEAOvNLbZAoXufMAO2z/G6ge0mlrL+T
         eF6i+lgGk7MQNJYBklV8qUguOilc/LdaowwM2bRfxirx7W624ROvjBwwlsRDt3PR8Tm5
         HQnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=awxy/BDZoT0mM/P9mIhPTjV07MQDeBS6ciLhmG/Wd6U=;
        b=gOW+mL5PYsgmYaPJPgX/+l5Gd3Ni1DDElQdJq9HhwX8Wx1cbjhswaD/Zs62W5glr07
         ++O3cJr+GXcePr6j/yp3Q3wkDN9toZiqMou4I7fOg9/mxkmTXeZfsR8jJgxvuat37EyB
         5NxnAsDPm2zzZYNNX1eCXs8voMSXAdxk5Ustzfh1ZcEnIvoRDKLWOmpWSPLvCoQEuTPR
         bh4yP945xtS82xOhfg4wuIxo3irKucrMuaa2F1MxbkqFMwCo/yA16uwGsE6EwO4Pw3x9
         2+zY+wOkhrLXvlMHuvx74aJyF/PDhyuwl37j74YnSF2CNmicRydCMYSEH3LhybMChdlP
         Rksw==
X-Gm-Message-State: AJIora90rntB8nNw5lFVMqrGCXntnraFzUiLkBGG/fYJGPtjHp6N3RPf
        PgKsYlpAFo+ugr4HG55azVmb3g==
X-Google-Smtp-Source: AGRyM1suvy8hibTSugbZ0RLGIbu6B2puqQ/WjE13KKElm59HY9bzOPt2Uu/G6z8SjtU3/DaBfjhoYg==
X-Received: by 2002:a05:6000:168e:b0:21d:ae03:49d9 with SMTP id y14-20020a056000168e00b0021dae0349d9mr12073735wrd.457.1658866575021;
        Tue, 26 Jul 2022 13:16:15 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c3b0600b003a320e6f011sm28073wms.1.2022.07.26.13.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 13:16:14 -0700 (PDT)
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
Subject: [PATCH 6/6] net/ipv6: sr: Switch to using crypto_pool
Date:   Tue, 26 Jul 2022 21:16:00 +0100
Message-Id: <20220726201600.1715505-7-dima@arista.com>
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
 include/net/seg6_hmac.h |   7 --
 net/ipv6/Kconfig        |   2 +-
 net/ipv6/seg6.c         |   3 -
 net/ipv6/seg6_hmac.c    | 204 ++++++++++++++++------------------------
 4 files changed, 80 insertions(+), 136 deletions(-)

diff --git a/include/net/seg6_hmac.h b/include/net/seg6_hmac.h
index 2b5d2ee5613e..d6b7820ecda2 100644
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
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 658bfed1df8b..5be1dab0f178 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -304,7 +304,7 @@ config IPV6_SEG6_LWTUNNEL
 config IPV6_SEG6_HMAC
 	bool "IPv6: Segment Routing HMAC support"
 	depends on IPV6
-	select CRYPTO
+	select CRYPTO_POOL
 	select CRYPTO_HMAC
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 73aaabf0e966..96b80e1d04c1 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -552,9 +552,6 @@ int __init seg6_init(void)
 
 void seg6_exit(void)
 {
-#ifdef CONFIG_IPV6_SEG6_HMAC
-	seg6_hmac_exit();
-#endif
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
 	seg6_iptunnel_exit();
 #endif
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index d43c50a7310d..3732dd993925 100644
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
+	err = crypto_pool_get(algo->crypto_pool_id, (struct crypto_pool *)&hp);
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
+		goto err_put_pool;
+	}
+
+	err = crypto_ahash_setkey(tfm, hinfo->secret, hinfo->slen);
+	if (err) {
+		pr_debug("crypto_ahash_setkey failed: err %d\n", err);
+		goto err_put_pool;
+	}
+
+	err = crypto_ahash_init(hp.req);
+	if (err)
+		goto err_put_pool;
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
+		goto err_put_pool;
 
-	if (dgsize < 0)
-		return dgsize;
+	err = crypto_ahash_final(hp.req);
+	if (err)
+		goto err_put_pool;
 
 	wrsize = SEG6_HMAC_FIELD_LEN;
 	if (wrsize > dgsize)
 		wrsize = dgsize;
 
 	memset(output, 0, SEG6_HMAC_FIELD_LEN);
-	memcpy(output, tmp_out, wrsize);
+	memcpy(output, hp.base.scratch, wrsize);
 
-	return 0;
+err_put_pool:
+	crypto_pool_put();
+
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
 
-	err = rhashtable_lookup_insert_fast(&sdata->hmac_infos, &hinfo->node,
+	algo = __hmac_get_algo(hinfo->alg_id);
+	if (!algo)
+		return -ENOENT;
+
+	ret = crypto_pool_alloc_ahash(algo->name);
+	if (ret < 0)
+		return ret;
+	algo->crypto_pool_id = ret;
+
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
@@ -348,56 +372,9 @@ int seg6_push_hmac(struct net *net, struct in6_addr *saddr,
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
 int __init seg6_hmac_init(void)
 {
-	return seg6_hmac_init_algo();
+	return crypto_pool_reserve_scratch(SEG6_HMAC_MAX_DIGESTSIZE);
 }
 
 int __net_init seg6_hmac_net_init(struct net *net)
@@ -407,29 +384,6 @@ int __net_init seg6_hmac_net_init(struct net *net)
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
2.36.1

