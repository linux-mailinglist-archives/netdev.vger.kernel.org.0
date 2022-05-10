Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71B75225F5
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 22:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbiEJU5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 16:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiEJU5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 16:57:36 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E626B4C7B7
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 13:57:33 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id iq10so346828pjb.0
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 13:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qEwSLaBnufvf0B/G9DnjVyMhvQQtp6PRHTVxLgDlPK8=;
        b=JZZc8nkB/4Su4yIh1M5akAXPXMXUy7OMtkUi17Z4U6q8imKFEnTV2ldgRsbBiWHbOc
         OXkC8mulfoTXZNJgg7dy8ejG6nYNpAntJzw/UJ+ZREiXKr9wDqUzvSrnqoqdQxyFobaM
         R+HM0meqwbmtR1sWL0MDTYxA0VK0lzS8IXVh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qEwSLaBnufvf0B/G9DnjVyMhvQQtp6PRHTVxLgDlPK8=;
        b=lXXIX9AzKT313Q30oQFxkG6CY7iRViIo34l8Xloh84l3NxwxC374QlBJdKpxRf8zJo
         yTpBDZLTcMfItG0CBIyKTY6v2IzYjiuGLWUpIK/0SetKXFrvrATaz4PWr7OVB6l7L1BN
         kadgWzmYsgarxha8Z+B9yx0cLfdE006pwfL43ZWvlNPF6uICwG6ANX/WSB6NEtpicq/J
         jdLcouAgS1imeTHMU9/XhQyiYriwtdsufo8vSGpdA43r20b6xjnXL6DyBDcSIprNvYIt
         VBSiJ9JWL/tQyCe/D33mMXBlaYzOqXhxCfbf/FKR4WkqbRRof7hwu8c6Dbk4vvmRRyd1
         55UQ==
X-Gm-Message-State: AOAM5332YS81VFDWa8LaLauXmXubBPyYdd2I8X92t73O37XPIimLGXNf
        FW1mXrObWk8ULjZSVdBg6W6C8w==
X-Google-Smtp-Source: ABdhPJzq6QFou00wiYYBUDT4UWIfcPJViSah6uRx1sl8Xa88lUVgHIvT844SOrOHnYuyyCgBDE0x7w==
X-Received: by 2002:a17:902:a583:b0:15d:197b:9259 with SMTP id az3-20020a170902a58300b0015d197b9259mr22529041plb.51.1652216253338;
        Tue, 10 May 2022 13:57:33 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u3-20020a170903108300b0015ee9bb2a38sm72477pld.72.2022.05.10.13.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 13:57:33 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Christoph Hellwig <hch@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Du Cheng <ducheng2@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vlastimil Babka <vbabka@suse.cz>,
        William Kucharski <william.kucharski@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] niu: Silence randstruct warnings
Date:   Tue, 10 May 2022 13:57:29 -0700
Message-Id: <20220510205729.3574400-1-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6424; h=from:subject; bh=qjuk20AT1lvrR1lDg81FqCODCnq2+tj+/Y7wwEnRQa8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBietG4dsJ9H5fxphZwsMR3iDSJzvX3mPa4VHlCGvUH hideMGiJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnrRuAAKCRCJcvTf3G3AJtleD/ 9zyb+fsiOw5Yfe5VTpCrrjyUdaIkIJl/vUPO3MSulEMU1Unng7KrEqQmJgAJM5WTUcAh7cTjNpY1q7 8+KeeGAO0KfG+t8kYQEEZRsOTCpFxnS4/oaFATHvLKVmZr83K0Yev/T2Ks6sActMbiWmsoo1mWhbJP ZMxlvaAFuKNEW9EjhNwKggoufIHyZcrx55WZFm5FF5HWQpa8sHQswEfZEQdK9raFdLCfMrBUfEEYbu UvlGalUlLC0Eg3kxD8/3HoqiKYvY9oQLdo8jnYGX7iqtwpQdXs9Y45aRQXDg7N55W9cOSut7I2kIMZ luOU+ygvT7MzXWj4Lo2ixe8ZwX7v+Hff8CLqdCpozXqoYiUYH6RzrJbX2ltMwpR4NNhsUsi7YznAT9 2Q0DKZZAjkGQq6c13DiqXaBQjRDAXhpPiUY0jNRi6l6FzxS3jqz9Zxrx2W7QYHGga4BpIc1LVgb5aT Kd04io55f66UaqZWMPDUw6dt02EdrN21KLLjlJUYMBus1KJR5LomjDBIhtphXZSh6+fD5cmFPZO8ZM k8JpuL3zTs+wcdSc4JdrsoELDqoR1K2PmCqX5eiS5GGfDobMFeJkx0lD8QY13R9yGukQrPhbcIcSG8 m7ViudNhHRmgfEdMjUJn0Ws8ouESfaGkchCFruYPxZ8TwyMWXHnsMqOb/7dw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang randstruct gets upset when it sees struct addresspace (which is
randomized) being assigned to a struct page (which is not randomized):

drivers/net/ethernet/sun/niu.c:3385:12: error: casting from randomized structure pointer type 'struct address_space *' to 'struct page *'
                        *link = (struct page *) page->mapping;
                                ^

It looks like niu.c is looking for an in-line place to chain its allocated
pages together and is overloading the "mapping" member, as it is unused.
This is very non-standard, and is expected to be cleaned up in the
future[1], but there is no "correct" way to handle it today.

No meaningful machine code changes result after this change, and source
readability is improved.

Drop the randstruct exception now that there is no "confusing" cross-type
assignment.

[1] https://lore.kernel.org/lkml/YnqgjVoMDu5v9PNG@casper.infradead.org/

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Du Cheng <ducheng2@gmail.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
earlier version: https://lore.kernel.org/lkml/20220509222334.3544344-1-keescook@chromium.org/
---
 drivers/net/ethernet/sun/niu.c                | 41 ++++++++++++++-----
 scripts/gcc-plugins/randomize_layout_plugin.c |  2 -
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 42460c0885fc..df70df29deea 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -35,6 +35,25 @@
 
 #include "niu.h"
 
+/* This driver wants to store a link to a "next page" within the
+ * page struct itself by overloading the content of the "mapping"
+ * member. This is not expected by the page API, but does currently
+ * work. However, the randstruct plugin gets very bothered by this
+ * case because "mapping" (struct address_space) is randomized, so
+ * casts to/from it trigger warnings. Hide this by way of a union,
+ * to create a typed alias of "mapping", since that's how it is
+ * actually being used here.
+ */
+union niu_page {
+	struct page page;
+	struct {
+		unsigned long __flags;	/* unused alias of "flags" */
+		struct list_head __lru;	/* unused alias of "lru" */
+		struct page *next;	/* alias of "mapping" */
+	};
+};
+#define niu_next_page(p)	container_of(p, union niu_page, page)->next
+
 #define DRV_MODULE_NAME		"niu"
 #define DRV_MODULE_VERSION	"1.1"
 #define DRV_MODULE_RELDATE	"Apr 22, 2010"
@@ -3283,7 +3302,7 @@ static struct page *niu_find_rxpage(struct rx_ring_info *rp, u64 addr,
 
 	addr &= PAGE_MASK;
 	pp = &rp->rxhash[h];
-	for (; (p = *pp) != NULL; pp = (struct page **) &p->mapping) {
+	for (; (p = *pp) != NULL; pp = &niu_next_page(p)) {
 		if (p->index == addr) {
 			*link = pp;
 			goto found;
@@ -3300,7 +3319,7 @@ static void niu_hash_page(struct rx_ring_info *rp, struct page *page, u64 base)
 	unsigned int h = niu_hash_rxaddr(rp, base);
 
 	page->index = base;
-	page->mapping = (struct address_space *) rp->rxhash[h];
+	niu_next_page(page) = rp->rxhash[h];
 	rp->rxhash[h] = page;
 }
 
@@ -3382,11 +3401,11 @@ static int niu_rx_pkt_ignore(struct niu *np, struct rx_ring_info *rp)
 		rcr_size = rp->rbr_sizes[(val & RCR_ENTRY_PKTBUFSZ) >>
 					 RCR_ENTRY_PKTBUFSZ_SHIFT];
 		if ((page->index + PAGE_SIZE) - rcr_size == addr) {
-			*link = (struct page *) page->mapping;
+			*link = niu_next_page(page);
 			np->ops->unmap_page(np->device, page->index,
 					    PAGE_SIZE, DMA_FROM_DEVICE);
 			page->index = 0;
-			page->mapping = NULL;
+			niu_next_page(page) = NULL;
 			__free_page(page);
 			rp->rbr_refill_pending++;
 		}
@@ -3451,11 +3470,11 @@ static int niu_process_rx_pkt(struct napi_struct *napi, struct niu *np,
 
 		niu_rx_skb_append(skb, page, off, append_size, rcr_size);
 		if ((page->index + rp->rbr_block_size) - rcr_size == addr) {
-			*link = (struct page *) page->mapping;
+			*link = niu_next_page(page);
 			np->ops->unmap_page(np->device, page->index,
 					    PAGE_SIZE, DMA_FROM_DEVICE);
 			page->index = 0;
-			page->mapping = NULL;
+			niu_next_page(page) = NULL;
 			rp->rbr_refill_pending++;
 		} else
 			get_page(page);
@@ -3518,13 +3537,13 @@ static void niu_rbr_free(struct niu *np, struct rx_ring_info *rp)
 
 		page = rp->rxhash[i];
 		while (page) {
-			struct page *next = (struct page *) page->mapping;
+			struct page *next = niu_next_page(page);
 			u64 base = page->index;
 
 			np->ops->unmap_page(np->device, base, PAGE_SIZE,
 					    DMA_FROM_DEVICE);
 			page->index = 0;
-			page->mapping = NULL;
+			niu_next_page(page) = NULL;
 
 			__free_page(page);
 
@@ -6440,8 +6459,7 @@ static void niu_reset_buffers(struct niu *np)
 
 				page = rp->rxhash[j];
 				while (page) {
-					struct page *next =
-						(struct page *) page->mapping;
+					struct page *next = niu_next_page(page);
 					u64 base = page->index;
 					base = base >> RBR_DESCR_ADDR_SHIFT;
 					rp->rbr[k++] = cpu_to_le32(base);
@@ -10176,6 +10194,9 @@ static int __init niu_init(void)
 
 	BUILD_BUG_ON(PAGE_SIZE < 4 * 1024);
 
+	BUILD_BUG_ON(offsetof(struct page, mapping) !=
+		     offsetof(union niu_page, next));
+
 	niu_debug = netif_msg_init(debug, NIU_MSG_DEFAULT);
 
 #ifdef CONFIG_SPARC64
diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index 727512eebb3b..38a8cf90f611 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -46,8 +46,6 @@ struct whitelist_entry {
 };
 
 static const struct whitelist_entry whitelist[] = {
-	/* NIU overloads mapping with page struct */
-	{ "drivers/net/ethernet/sun/niu.c", "page", "address_space" },
 	/* unix_skb_parms via UNIXCB() buffer */
 	{ "net/unix/af_unix.c", "unix_skb_parms", "char" },
 	{ }
-- 
2.32.0

