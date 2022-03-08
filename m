Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD154D18D2
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346249AbiCHNM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbiCHNMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:12:21 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C7948E41;
        Tue,  8 Mar 2022 05:11:18 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id a5so5710929pfv.2;
        Tue, 08 Mar 2022 05:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BdKzZoxcCHUk05nIKgEhaGedb/vHkDzRSP6HrqUzWkw=;
        b=mVG368BLiMOTpvYHAUUF4Hl0SvELdZmvTum03FPpeGhXzLHWktVasfzvvXjRTjOz8v
         OeRQAhrdpy137X55NmR+Q/Kuzq9xiVfXNfSvJp32pazR2MPbIlJ8Vzb0Bd7V7G/na2UQ
         /kfik/XTfzvUUpTBTd1qB8DMG2kpuKdtEfRyYh14NVfqPCAXvfHKDJ+64jnLsvC2UHCd
         Q3sUYvjb4wA56QqTFnZWhIKlsDgOcCCK5NzY5cMPJAHGwN6RbCmGB1z9nZM4JR4/0Zny
         plLD1LQTq3acxLCjuPV6GmozEA9rAtVuiBPQKKhaxmdk4ZZHaK0851qNleWCQ6+8DyHd
         neGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BdKzZoxcCHUk05nIKgEhaGedb/vHkDzRSP6HrqUzWkw=;
        b=T+tv+erLOYUodKRwrQo799/Hy2Bm0asGnoCfttiq/1f/epUXuMud0exijiAeqiEUJU
         JwRSdzdN2PuMjDoXew68KQ5nWgBxhO8DMqcNu0vlOoB80whLHuNIRRZRJOgyITxJbBoX
         9bezDaoXJIsED/lqaIPKwuDSIQLHdyYtudBbFZ6R/lJbqdYV5QRShuKtaoqebuNa6fXU
         loNRWiRvSfbnYtwsBWIKpEu0tQD9LM/Bn08uwA5TH8qQcE6e0ukocZenul7SwrQcwkJd
         sMVeHzx3QHmhVLfZgYebpmLryrHlpAGV31aXlcGXjeV2Mi/GtbXHnihvEiTGb2QPGaRc
         EClw==
X-Gm-Message-State: AOAM532JsQ8lhZQy/V3p/kDDMT+msbEyHYK1XRVrhSeHVQqgKhp+8lgU
        F/TwurWx3op8jXm683GOmq1I6gtz/VSjhHsGw6o=
X-Google-Smtp-Source: ABdhPJxi1T75LgLTxomuRmkgtIa5sVE1omWzFmGT1bjc4dtbt/cmnHAw3/PxWVByPMfUm079lFsD0Q==
X-Received: by 2002:a63:61d3:0:b0:37f:f9c5:bbb8 with SMTP id v202-20020a6361d3000000b0037ff9c5bbb8mr13005281pgb.332.1646745077687;
        Tue, 08 Mar 2022 05:11:17 -0800 (PST)
Received: from vultr.guest ([149.248.19.67])
        by smtp.gmail.com with ESMTPSA id s20-20020a056a00179400b004f709998d13sm7378598pfg.10.2022.03.08.05.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:11:17 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        guro@fb.com
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH RFC 3/9] mm: add methord to charge kmalloc-ed address
Date:   Tue,  8 Mar 2022 13:10:50 +0000
Message-Id: <20220308131056.6732-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220308131056.6732-1-laoar.shao@gmail.com>
References: <20220308131056.6732-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements a methord to charge or uncharge related pages
or objects from a given kmalloc-ed address. It is similar to kfree,
except that it doesn't touch the pages or objects while does account
only.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/slab.h |  1 +
 mm/slab.c            |  6 ++++++
 mm/slob.c            |  6 ++++++
 mm/slub.c            | 32 ++++++++++++++++++++++++++++++++
 4 files changed, 45 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 5b6193f..ae82e23 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -182,6 +182,7 @@ struct kmem_cache *kmem_cache_create_usercopy(const char *name,
 void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __alloc_size(2);
 void kfree(const void *objp);
 void kfree_sensitive(const void *objp);
+void kcharge(const void *objp, bool charge);
 size_t __ksize(const void *objp);
 size_t ksize(const void *objp);
 #ifdef CONFIG_PRINTK
diff --git a/mm/slab.c b/mm/slab.c
index ddf5737..fbff613 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3796,6 +3796,12 @@ void kfree(const void *objp)
 }
 EXPORT_SYMBOL(kfree);
 
+void kcharge(const void *objp, bool charge)
+{
+	/* Not implemented yet */
+}
+EXPORT_SYMBOL(kfree);
+
 /*
  * This initializes kmem_cache_node or resizes various caches for all nodes.
  */
diff --git a/mm/slob.c b/mm/slob.c
index 60c5842..d3a789f 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -569,6 +569,12 @@ void kfree(const void *block)
 }
 EXPORT_SYMBOL(kfree);
 
+void kcharge(const void *block, bool charge)
+{
+	/* not implemented yet. */
+}
+EXPORT_SYMBOL(kcharge);
+
 /* can't use ksize for kmem_cache_alloc memory, only kmalloc */
 size_t __ksize(const void *block)
 {
diff --git a/mm/slub.c b/mm/slub.c
index 2614740..e933d45 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4563,6 +4563,38 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
+void kcharge(const void *x, bool charge)
+{
+	void *object = (void *)x;
+	struct folio *folio;
+	struct slab *slab;
+
+	WARN_ON(!in_task());
+
+	if (unlikely(ZERO_OR_NULL_PTR(x)))
+		return;
+
+	folio = virt_to_folio(x);
+	if (unlikely(!folio_test_slab(folio))) {
+		unsigned int order = folio_order(folio);
+		int sign = charge ? 1 : -1;
+
+		mod_lruvec_page_state(folio_page(folio, 0), NR_SLAB_UNRECLAIMABLE_B,
+			sign * (PAGE_SIZE << order));
+
+		return;
+	}
+
+	slab = folio_slab(folio);
+	if (charge)
+		memcg_slab_post_alloc_hook(slab->slab_cache,
+			get_obj_cgroup_from_current(), GFP_KERNEL, 1, &object);
+	else
+		memcg_slab_free_hook(slab->slab_cache, &object, 1);
+
+}
+EXPORT_SYMBOL(kcharge);
+
 #define SHRINK_PROMOTE_MAX 32
 
 /*
-- 
1.8.3.1

