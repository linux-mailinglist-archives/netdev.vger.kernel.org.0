Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6379110979
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfEAOpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:45:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49340 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfEAOpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:45:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eu3m/3TpUj0vTk+RgjTeN64mICvWZpIKujR4Fo+gYmU=; b=ibUB2onajGCpDbbxCPJabcSYG
        7e5SX8+nOMGjL2+5vN9YwcePHUupGc8y8frtw+Dkdm8DUMbJVa+h/BzbHHl9byc0LhuuRb9PeJe+s
        0x6TcBzG5yXFuxAtzxLrjzUwwjyO6CWqPs15MC2DaOeo334WQe/z3khR2UkrO/sSx5VQHweUo1ZCC
        r6s0arJrKKCshZxSEE9qoLcJ+fJnvGSM0/ma1hpbJbQJvXMMdKStgg0xjbv16fDezHlw+rfyxd7K4
        +JMFOEygFnQJSed222scvcDJ1Jq0p52K6ljXG7tC8sbiTOuDeU0fJeAEfd4PS2g8RMnvDsZx5ZXgV
        H1QfMaPfw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLqTk-00025z-B4; Wed, 01 May 2019 14:45:00 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v2 6/7] net: Rename skb_frag_t size to bv_len
Date:   Wed,  1 May 2019 07:44:56 -0700
Message-Id: <20190501144457.7942-7-willy@infradead.org>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501144457.7942-1-willy@infradead.org>
References: <20190501144457.7942-1-willy@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Improved compatibility with bvec

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/skbuff.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a75e85226bea..df07b3144c77 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -316,7 +316,7 @@ typedef struct skb_frag_struct skb_frag_t;
 
 struct skb_frag_struct {
 	struct page *bv_page;
-	__u32 size;
+	unsigned int bv_len;
 	__u32 page_offset;
 };
 
@@ -326,7 +326,7 @@ struct skb_frag_struct {
  */
 static inline unsigned int skb_frag_size(const skb_frag_t *frag)
 {
-	return frag->size;
+	return frag->bv_len;
 }
 
 /**
@@ -336,7 +336,7 @@ static inline unsigned int skb_frag_size(const skb_frag_t *frag)
  */
 static inline void skb_frag_size_set(skb_frag_t *frag, unsigned int size)
 {
-	frag->size = size;
+	frag->bv_len = size;
 }
 
 /**
@@ -346,7 +346,7 @@ static inline void skb_frag_size_set(skb_frag_t *frag, unsigned int size)
  */
 static inline void skb_frag_size_add(skb_frag_t *frag, int delta)
 {
-	frag->size += delta;
+	frag->bv_len += delta;
 }
 
 /**
@@ -356,7 +356,7 @@ static inline void skb_frag_size_add(skb_frag_t *frag, int delta)
  */
 static inline void skb_frag_size_sub(skb_frag_t *frag, int delta)
 {
-	frag->size -= delta;
+	frag->bv_len -= delta;
 }
 
 /**
-- 
2.20.1

