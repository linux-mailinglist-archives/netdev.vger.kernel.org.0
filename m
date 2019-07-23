Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1B670F8F
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 05:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387911AbfGWDIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 23:08:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36414 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387875AbfGWDIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 23:08:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2wZyzvwDZegSCVDrIR3rrGx2i2TBHBQBrDtpZIXYsQg=; b=gLzNw3+vJ18tlc2Z1lQ2LVW7ZZ
        Jk1eVVD9LBQSisfHKC1dvuru2M2E8nPNIvabYI/UXdGXNUAi+sc5M+IRJBq1t8KfoA+NLKIq/WiWO
        elBwk7izY3vmAdySPt0JRkwCtfhcYXAVVw0lDUGPryKZems9xeDMQ1v117CL/io4zf6NSvi+c4c9/
        KHo2TseHzrt9XTbLfoasfCgCgnJKWB3ONTiZyrSYRRexIFtE//oNDR3fCuEqrTp/EqsSCaEUB4CyK
        pgHCUkrIyCDfr4/VOB6ICSPLQOlbZz09b5GOpoTq63Lkv/prUslRoew97S9Ggr/pkehxL071j01Ox
        IXZ0vUNw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hplAJ-00036w-Jb; Tue, 23 Jul 2019 03:08:35 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v3 6/7] net: Rename skb_frag_t size to bv_len
Date:   Mon, 22 Jul 2019 20:08:30 -0700
Message-Id: <20190723030831.11879-7-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723030831.11879-1-willy@infradead.org>
References: <20190723030831.11879-1-willy@infradead.org>
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

