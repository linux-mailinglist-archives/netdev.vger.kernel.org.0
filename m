Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5946705F
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfGLNnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:43:49 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50692 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbfGLNnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:43:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2wZyzvwDZegSCVDrIR3rrGx2i2TBHBQBrDtpZIXYsQg=; b=SxHAx3Ludx1GlTYck8xDtqh/JM
        mWWaW8mMN0/sidBKbkeeK7d2YYUUSOxo+GUwqV4sPNMe2obkMGUDirMlu92x5xElyu3aMuQbbAW8l
        TnXml0aavz0CjLFhQG4KoNtuDrvuZgRq4VCoXiOjrjWnNZpnSrQerWFB6aY2MUtXnPjh2yqMPz5NA
        PYpWIvFymKFDj2V7bPcnfulAKH85O0JN02wzLBT2eEE9L1OHACe+ZowuLz5MGUyOIwknKYIa/iGSn
        ggbwOEwN3g0234TUU3YUWuMF9UCvQyfVfV5DW0o8X5hrr4azPeeuzY9b7X0OyjecY6oCHn1wyioe8
        no8HS7Rg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hlvpz-0005A8-Ll; Fri, 12 Jul 2019 13:43:47 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v3 6/7] net: Rename skb_frag_t size to bv_len
Date:   Fri, 12 Jul 2019 06:43:44 -0700
Message-Id: <20190712134345.19767-7-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190712134345.19767-1-willy@infradead.org>
References: <20190712134345.19767-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 8076e2ba8349..e849e411d1f3 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -312,7 +312,7 @@ typedef struct skb_frag_struct skb_frag_t;
 
 struct skb_frag_struct {
 	struct page *bv_page;
-	__u32 size;
+	unsigned int bv_len;
 	__u32 page_offset;
 };
 
@@ -322,7 +322,7 @@ struct skb_frag_struct {
  */
 static inline unsigned int skb_frag_size(const skb_frag_t *frag)
 {
-	return frag->size;
+	return frag->bv_len;
 }
 
 /**
@@ -332,7 +332,7 @@ static inline unsigned int skb_frag_size(const skb_frag_t *frag)
  */
 static inline void skb_frag_size_set(skb_frag_t *frag, unsigned int size)
 {
-	frag->size = size;
+	frag->bv_len = size;
 }
 
 /**
@@ -342,7 +342,7 @@ static inline void skb_frag_size_set(skb_frag_t *frag, unsigned int size)
  */
 static inline void skb_frag_size_add(skb_frag_t *frag, int delta)
 {
-	frag->size += delta;
+	frag->bv_len += delta;
 }
 
 /**
@@ -352,7 +352,7 @@ static inline void skb_frag_size_add(skb_frag_t *frag, int delta)
  */
 static inline void skb_frag_size_sub(skb_frag_t *frag, int delta)
 {
-	frag->size -= delta;
+	frag->bv_len -= delta;
 }
 
 /**
-- 
2.20.1

