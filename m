Return-Path: <netdev+bounces-12085-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79C48735F56
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 23:45:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D879280FDA
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 21:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 497A714AB2;
	Mon, 19 Jun 2023 21:45:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E2D522A
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 21:45:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510768F
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687211146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RVS2CDGv8MXaquA/9hvN5l2wqMBpBpyGhN0hUvKYgmY=;
	b=QIB9q3Io1VWg7UZtoNmzMVDC51Te+yqLnNniKe9KdZyZB4IISCooW673TbyrbHlZjauLL5
	sGRHbgbgxLTeppjW9Skt5eZCFBoGW/RWk7bhYIZXtyi61NkdQoh3ezGhzfg3WGyXdQjRDF
	NPXktAe6Xk6EmkH/FnWTjlqLfQ+RKs4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-IGuhDMxKPTu8sl9GWRJ7Lw-1; Mon, 19 Jun 2023 17:45:43 -0400
X-MC-Unique: IGuhDMxKPTu8sl9GWRJ7Lw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3FDE8002BF;
	Mon, 19 Jun 2023 21:45:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E81D540C20F5;
	Mon, 19 Jun 2023 21:45:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <000000000000c6527105fe7fdab8@google.com>
References: <000000000000c6527105fe7fdab8@google.com>
To: syzbot <syzbot+88f4b1e6cf88da11f5cd@syzkaller.appspotmail.com>
Cc: dhowells@redhat.com, davem@davemloft.net,
    herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
    pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] general protection fault in shash_ahash_update
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1167415.1687211141.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Jun 2023 22:45:41 +0100
Message-ID: <1167416.1687211141@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.g=
it main

commit c2996e733d4f2d93bdc0fed74022da082b2e6784
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jun 14 13:33:04 2023 +0100

    crypto: af_alg/hash: Fix recvmsg() after sendmsg(MSG_MORE)
    =

    If an AF_ALG socket bound to a hashing algorithm is sent a zero-length
    message with MSG_MORE set and then recvmsg() is called without first
    sending another message without MSG_MORE set to end the operation, an =
oops
    will occur because the crypto context and result doesn't now get set u=
p in
    advance because hash_sendmsg() now defers that as long as possible in =
the
    hope that it can use crypto_ahash_digest() - and then because the mess=
age
    is zero-length, it the data wrangling loop is skipped.
    =

    Fix this by handling zero-length sends at the top of the hash_sendmsg(=
)
    function.  If we're not continuing the previous sendmsg(), then just i=
gnore
    the send (hash_recvmsg() will invent something when called); if we are
    continuing, then we finalise the request at this point if MSG_MORE is =
not
    set to get any error here, otherwise the send is of no effect and can =
be
    ignored.
    =

    Whilst we're at it, remove the code to create a kvmalloc'd scatterlist=
 if
    we get more than ALG_MAX_PAGES - this shouldn't happen.
    =

    Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")
    Reported-by: syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com
    Link: https://lore.kernel.org/r/000000000000b928f705fdeb873a@google.co=
m/
    Reported-by: syzbot+14234ccf6d0ef629ec1a@syzkaller.appspotmail.com
    Link: https://lore.kernel.org/r/000000000000c047db05fdeb8790@google.co=
m/
    Reported-by: syzbot+4e2e47f32607d0f72d43@syzkaller.appspotmail.com
    Link: https://lore.kernel.org/r/000000000000bcca3205fdeb87fb@google.co=
m/
    Reported-by: syzbot+472626bb5e7c59fb768f@syzkaller.appspotmail.com
    Link: https://lore.kernel.org/r/000000000000b55d8805fdeb8385@google.co=
m/
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

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index dfb048cefb60..0ab43e149f0e 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -76,13 +76,30 @@ static int hash_sendmsg(struct socket *sock, struct ms=
ghdr *msg,
 =

 	lock_sock(sk);
 	if (!continuing) {
-		if ((msg->msg_flags & MSG_MORE))
-			hash_free_result(sk, ctx);
+		/* Discard a previous request that wasn't marked MSG_MORE. */
+		hash_free_result(sk, ctx);
+		if (!msg_data_left(msg))
+			goto done; /* Zero-length; don't start new req */
 		need_init =3D true;
+	} else if (!msg_data_left(msg)) {
+		/*
+		 * No data - finalise the prev req if MSG_MORE so any error
+		 * comes out here.
+		 */
+		if (!(msg->msg_flags & MSG_MORE)) {
+			err =3D hash_alloc_result(sk, ctx);
+			if (err)
+				goto unlock_free;
+			ahash_request_set_crypt(&ctx->req, NULL,
+						ctx->result, 0);
+			err =3D crypto_wait_req(crypto_ahash_final(&ctx->req),
+					      &ctx->wait);
+			if (err)
+				goto unlock_free;
+		}
+		goto done_more;
 	}
 =

-	ctx->more =3D false;
-
 	while (msg_data_left(msg)) {
 		ctx->sgl.sgt.sgl =3D ctx->sgl.sgl;
 		ctx->sgl.sgt.nents =3D 0;
@@ -93,15 +110,6 @@ static int hash_sendmsg(struct socket *sock, struct ms=
ghdr *msg,
 		if (npages =3D=3D 0)
 			goto unlock_free;
 =

-		if (npages > ARRAY_SIZE(ctx->sgl.sgl)) {
-			err =3D -ENOMEM;
-			ctx->sgl.sgt.sgl =3D
-				kvmalloc(array_size(npages,
-						    sizeof(*ctx->sgl.sgt.sgl)),
-					 GFP_KERNEL);
-			if (!ctx->sgl.sgt.sgl)
-				goto unlock_free;
-		}
 		sg_init_table(ctx->sgl.sgl, npages);
 =

 		ctx->sgl.need_unpin =3D iov_iter_extract_will_pin(&msg->msg_iter);
@@ -150,7 +158,9 @@ static int hash_sendmsg(struct socket *sock, struct ms=
ghdr *msg,
 		af_alg_free_sg(&ctx->sgl);
 	}
 =

+done_more:
 	ctx->more =3D msg->msg_flags & MSG_MORE;
+done:
 	err =3D 0;
 unlock:
 	release_sock(sk);
@@ -158,6 +168,8 @@ static int hash_sendmsg(struct socket *sock, struct ms=
ghdr *msg,
 =

 unlock_free:
 	af_alg_free_sg(&ctx->sgl);
+	hash_free_result(sk, ctx);
+	ctx->more =3D false;
 	goto unlock;
 }
 =


