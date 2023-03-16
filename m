Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FD56BD3B4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjCPP3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjCPP26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:28:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07640D5A43
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678980429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fl0FVU0Ldf/kGpij9uVxFzVxVMUJY5FbZMiRTa3smnM=;
        b=iu/8ZsrhDtpBJBKaRDg9BUter6euLufRWq8HuauCPYwySBmCfe/OXygQ2h/zB4TOJbzP/e
        DPvZyc7ZWdhiZpoBnZU8BS7eBOFi/AymLS79UGXRG4QLJtGRsTFTSem8/tRdLyEe5mXCAX
        P6OelZEXYW0qMUMeJ3SJDiJcNDC88K8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-khorhuokMxiDfSWLdIPQyg-1; Thu, 16 Mar 2023 11:27:00 -0400
X-MC-Unique: khorhuokMxiDfSWLdIPQyg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6213F96DC83;
        Thu, 16 Mar 2023 15:26:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64DEF35453;
        Thu, 16 Mar 2023 15:26:55 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: [RFC PATCH 13/28] crypto: af_alg: Indent the loop in af_alg_sendmsg()
Date:   Thu, 16 Mar 2023 15:26:03 +0000
Message-Id: <20230316152618.711970-14-dhowells@redhat.com>
In-Reply-To: <20230316152618.711970-1-dhowells@redhat.com>
References: <20230316152618.711970-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Put the loop in af_alg_sendmsg() into an if-statement to indent it to make
the next patch easier to review as that will add another branch to handle
MSG_SPLICE_PAGES to the if-statement.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: linux-crypto@vger.kernel.org
cc: netdev@vger.kernel.org
---
 crypto/af_alg.c | 50 +++++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 5f7252a5b7b4..feb989b32606 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1060,35 +1060,37 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		if (sgl->cur)
 			sg_unmark_end(sg + sgl->cur - 1);
 
-		do {
-			struct page *pg;
-			unsigned int i = sgl->cur;
+		if (1 /* TODO check MSG_SPLICE_PAGES */) {
+			do {
+				struct page *pg;
+				unsigned int i = sgl->cur;
 
-			plen = min_t(size_t, len, PAGE_SIZE);
+				plen = min_t(size_t, len, PAGE_SIZE);
 
-			pg = alloc_page(GFP_KERNEL);
-			if (!pg) {
-				err = -ENOMEM;
-				goto unlock;
-			}
+				pg = alloc_page(GFP_KERNEL);
+				if (!pg) {
+					err = -ENOMEM;
+					goto unlock;
+				}
 
-			sg_assign_page(sg + i, pg);
+				sg_assign_page(sg + i, pg);
 
-			err = memcpy_from_msg(page_address(sg_page(sg + i)),
-					      msg, plen);
-			if (err) {
-				__free_page(sg_page(sg + i));
-				sg_assign_page(sg + i, NULL);
-				goto unlock;
-			}
+				err = memcpy_from_msg(page_address(sg_page(sg + i)),
+						      msg, plen);
+				if (err) {
+					__free_page(sg_page(sg + i));
+					sg_assign_page(sg + i, NULL);
+					goto unlock;
+				}
 
-			sg[i].length = plen;
-			len -= plen;
-			ctx->used += plen;
-			copied += plen;
-			size -= plen;
-			sgl->cur++;
-		} while (len && sgl->cur < MAX_SGL_ENTS);
+				sg[i].length = plen;
+				len -= plen;
+				ctx->used += plen;
+				copied += plen;
+				size -= plen;
+				sgl->cur++;
+			} while (len && sgl->cur < MAX_SGL_ENTS);
+		}
 
 		if (!size)
 			sg_mark_end(sg + sgl->cur - 1);

