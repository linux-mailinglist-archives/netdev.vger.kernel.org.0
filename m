Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8886D255C
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbjCaQVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbjCaQVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:21:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167AD2CAFE
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=taClZ7tV+6NGiC2MYzyqiyjdYhpNZJPUqY1OQ7XAIPM=;
        b=S9VWId0Sx71MRizrT8+qEophmBaHCpVhdxdhRN+syys4bA0APlYdUKvpeFPALAVAMvsjai
        TNYeAKZ+E3E+ytL4X5XtQNETDXZQlO7ZskObHVxO1ZkBREOB8Lfei8/Q0ct0kq3FHNtakp
        XA9Ybr2uF1vFzxyeTdyRIqotLUewKmQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-c9EO5cpKMmGD23YMrtD9Yg-1; Fri, 31 Mar 2023 12:11:23 -0400
X-MC-Unique: c9EO5cpKMmGD23YMrtD9Yg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73F4B811E7C;
        Fri, 31 Mar 2023 16:11:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 628494020C82;
        Fri, 31 Mar 2023 16:11:20 +0000 (UTC)
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
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 44/55] algif: Remove hash_sendpage*()
Date:   Fri, 31 Mar 2023 17:09:03 +0100
Message-Id: <20230331160914.1608208-45-dhowells@redhat.com>
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove hash_sendpage*()..

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
 crypto/algif_hash.c | 66 ---------------------------------------------
 1 file changed, 66 deletions(-)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index b89c2c50cecc..dc6c45637b2d 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -162,58 +162,6 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 	goto unlock;
 }
 
-static ssize_t hash_sendpage(struct socket *sock, struct page *page,
-			     int offset, size_t size, int flags)
-{
-	struct sock *sk = sock->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct hash_ctx *ctx = ask->private;
-	int err;
-
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
-
-	lock_sock(sk);
-	sg_init_table(ctx->sgl.sgl, 1);
-	sg_set_page(ctx->sgl.sgl, page, size, offset);
-
-	if (!(flags & MSG_MORE)) {
-		err = hash_alloc_result(sk, ctx);
-		if (err)
-			goto unlock;
-	} else if (!ctx->more)
-		hash_free_result(sk, ctx);
-
-	ahash_request_set_crypt(&ctx->req, ctx->sgl.sgl, ctx->result, size);
-
-	if (!(flags & MSG_MORE)) {
-		if (ctx->more)
-			err = crypto_ahash_finup(&ctx->req);
-		else
-			err = crypto_ahash_digest(&ctx->req);
-	} else {
-		if (!ctx->more) {
-			err = crypto_ahash_init(&ctx->req);
-			err = crypto_wait_req(err, &ctx->wait);
-			if (err)
-				goto unlock;
-		}
-
-		err = crypto_ahash_update(&ctx->req);
-	}
-
-	err = crypto_wait_req(err, &ctx->wait);
-	if (err)
-		goto unlock;
-
-	ctx->more = flags & MSG_MORE;
-
-unlock:
-	release_sock(sk);
-
-	return err ?: size;
-}
-
 static int hash_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			int flags)
 {
@@ -318,7 +266,6 @@ static struct proto_ops algif_hash_ops = {
 
 	.release	=	af_alg_release,
 	.sendmsg	=	hash_sendmsg,
-	.sendpage	=	hash_sendpage,
 	.recvmsg	=	hash_recvmsg,
 	.accept		=	hash_accept,
 };
@@ -370,18 +317,6 @@ static int hash_sendmsg_nokey(struct socket *sock, struct msghdr *msg,
 	return hash_sendmsg(sock, msg, size);
 }
 
-static ssize_t hash_sendpage_nokey(struct socket *sock, struct page *page,
-				   int offset, size_t size, int flags)
-{
-	int err;
-
-	err = hash_check_key(sock);
-	if (err)
-		return err;
-
-	return hash_sendpage(sock, page, offset, size, flags);
-}
-
 static int hash_recvmsg_nokey(struct socket *sock, struct msghdr *msg,
 			      size_t ignored, int flags)
 {
@@ -420,7 +355,6 @@ static struct proto_ops algif_hash_ops_nokey = {
 
 	.release	=	af_alg_release,
 	.sendmsg	=	hash_sendmsg_nokey,
-	.sendpage	=	hash_sendpage_nokey,
 	.recvmsg	=	hash_recvmsg_nokey,
 	.accept		=	hash_accept_nokey,
 };

