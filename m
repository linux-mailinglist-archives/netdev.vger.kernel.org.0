Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D264D18D1
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347061AbiCHNM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbiCHNMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:12:21 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A2B488A0;
        Tue,  8 Mar 2022 05:11:19 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id p8so17287237pfh.8;
        Tue, 08 Mar 2022 05:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z98OQ6AdalG5oMDKVv5aA3FO3T1l3cK2nxdIAVKfKFQ=;
        b=YdbOfZYq1mOC7LrS/ckJnfEBQ+MAblMP+dx7AWe6RKa98jAA9r1n44yEApW3RKGMd5
         zRC97/VTsM7EsdnHMDO7hE6yzmYjY+E4jfZQL8n8DTe/cfFkXDN5zun4HeZTuag2VUiI
         1uVbJRLZgyBFHI3LI09GiKz5UK1PMeMrNKAI4k6YNc4E1md3TxXvNZpzuFtYIbfkIFOJ
         i797KhWbBX2INTNoR3rd6zalgu7CvEkKZbVypUJ8AUSn5KpA5CEVOMo06zFbjaj2nm8t
         BELs1qacF+x+Y92yqHN5epNG5LlOKvH5ZD7MfFAEnqr8Z3Ff6F3wXJTKxppyuwulT8mY
         r62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z98OQ6AdalG5oMDKVv5aA3FO3T1l3cK2nxdIAVKfKFQ=;
        b=5OS99iRwHy9HfFc0WKwaUfIkhwaA1cCcwGFrCwHfPfcbQnzYgpjO/fYOiOpl/vIpWK
         pOkVQdPSDJ94VIAFu59NN8UPWvxC4xXwWV3j5E1+O6q0HC79S5ia0Jb/WkLTzgsyDS7u
         JBh0l8N5boa6q/dav6PFOTJN9NpEzRS45394UKX7AZGlLcMVTK6zFA7Cr2M1c+cFH+5Q
         54EF7BZiJg2L1hhHj04VCAcSq9NhAhdmS7A6RAdU9nstAif0e7JzKNwtH81sJ5fpoOdT
         wGO3PqNgn6gJRXEO69tG1DbHmmGjR1Aq4/K+Zh0WL/+XA/r4peAir+I7EBi2xzHKysXT
         UbZQ==
X-Gm-Message-State: AOAM533C+pzsWm+kTgsWz/G7KZwv0G+5YE2ehPw8kUtc1OPGhSEmLOEn
        jqdGAwwn8lyAGiq9uEPwApY=
X-Google-Smtp-Source: ABdhPJxrM0tl1/gYxlXQIsaOe+AjwvJr57dfg0zKANngu7XWWfwFpew1AJotBmNiE7RcN7WhSYaheA==
X-Received: by 2002:a63:b30d:0:b0:378:c5ee:afda with SMTP id i13-20020a63b30d000000b00378c5eeafdamr14297243pgf.385.1646745079189;
        Tue, 08 Mar 2022 05:11:19 -0800 (PST)
Received: from vultr.guest ([149.248.19.67])
        by smtp.gmail.com with ESMTPSA id s20-20020a056a00179400b004f709998d13sm7378598pfg.10.2022.03.08.05.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:11:18 -0800 (PST)
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
Subject: [PATCH RFC 4/9] mm: add methord to charge vmalloc-ed address
Date:   Tue,  8 Mar 2022 13:10:51 +0000
Message-Id: <20220308131056.6732-5-laoar.shao@gmail.com>
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

This patch adds a methord to charge or uncharge a given vmalloc-ed
address. It is similar to vfree, except that it doesn't touch the
related pages while does account only.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/slab.h    |  1 +
 include/linux/vmalloc.h |  1 +
 mm/util.c               |  9 +++++++++
 mm/vmalloc.c            | 29 +++++++++++++++++++++++++++++
 4 files changed, 40 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index ae82e23..7173354 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -759,6 +759,7 @@ extern void *kvrealloc(const void *p, size_t oldsize, size_t newsize, gfp_t flag
 		      __alloc_size(3);
 extern void kvfree(const void *addr);
 extern void kvfree_sensitive(const void *addr, size_t len);
+void kvcharge(const void *addr, bool charge);
 
 unsigned int kmem_cache_size(struct kmem_cache *s);
 void __init kmem_cache_init_late(void);
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 880227b..b48d941 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -161,6 +161,7 @@ void *__vmalloc_node(unsigned long size, unsigned long align, gfp_t gfp_mask,
 
 extern void vfree(const void *addr);
 extern void vfree_atomic(const void *addr);
+void vcharge(const void *addr, bool charge);
 
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
diff --git a/mm/util.c b/mm/util.c
index 7e433690..f5f5e05 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -614,6 +614,15 @@ void kvfree(const void *addr)
 }
 EXPORT_SYMBOL(kvfree);
 
+void kvcharge(const void *addr, bool charge)
+{
+	if (is_vmalloc_addr(addr))
+		vcharge(addr, charge);
+	else
+		kcharge(addr, charge);
+}
+EXPORT_SYMBOL(kvcharge);
+
 /**
  * kvfree_sensitive - Free a data object containing sensitive information.
  * @addr: address of the data object to be freed.
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 4165304..6fc2295 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2715,6 +2715,35 @@ void vfree(const void *addr)
 }
 EXPORT_SYMBOL(vfree);
 
+void vcharge(const void *addr, bool charge)
+{
+	unsigned int page_order;
+	struct vm_struct *area;
+	int i;
+
+	WARN_ON(!in_task());
+
+	if (!addr)
+		return;
+
+	area = find_vm_area(addr);
+	if (unlikely(!area))
+		return;
+
+	page_order = vm_area_page_order(area);
+	for (i = 0; i < area->nr_pages; i += 1U << page_order) {
+		struct page *page = area->pages[i];
+
+		WARN_ON(!page);
+		if (charge)
+			memcg_kmem_charge_page(page, GFP_KERNEL, page_order);
+		else
+			memcg_kmem_uncharge_page(page, page_order);
+		cond_resched();
+	}
+}
+EXPORT_SYMBOL(vcharge);
+
 /**
  * vunmap - release virtual mapping obtained by vmap()
  * @addr:   memory base address
-- 
1.8.3.1

