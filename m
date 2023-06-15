Return-Path: <netdev+bounces-11229-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B68AE7320E3
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:24:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F5F82814A3
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 20:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4BF9125DF;
	Thu, 15 Jun 2023 20:24:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B5A156C0
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 20:24:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8092101
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686860692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MrpsuXVoVGE8iGkAh6o3j2l9HUCJ39oCK3xuHOwIHY0=;
	b=E/05qhEWq+TBrrXVHPO61F9tApmSWlbrSz9MhZCF3Ur7PhkJvmandUnrxj/HCFAah/N/jL
	1G05uCIGbReU9S+Iy0EsTdLNpPD185sVEPn+No7Q+GZ65irfAZCH1oou/I89d3qyHx2GD7
	vqPLBtpYQVuDBEVBNqGzQCsUhmRp/9Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-nAZj1wX0NOmifXfyQVRigA-1; Thu, 15 Jun 2023 16:24:48 -0400
X-MC-Unique: nAZj1wX0NOmifXfyQVRigA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B985805C10;
	Thu, 15 Jun 2023 20:24:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D9EBE2166B26;
	Thu, 15 Jun 2023 20:24:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1657853.1686757902@warthog.procyon.org.uk>
References: <1657853.1686757902@warthog.procyon.org.uk> <000000000000b2585a05fdeb8379@google.com>
Cc: dhowells@redhat.com,
    syzbot <syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com>,
    davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
    linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
    netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] KASAN: slab-out-of-bounds Read in extract_iter_to_sg
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <262281.1686860686.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Jun 2023 21:24:46 +0100
Message-ID: <262282.1686860686@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.g=
it main

    crypto: Fix af_alg_sendmsg(MSG_SPLICE_PAGES) sglist limit
    =

    When af_alg_sendmsg() calls extract_iter_to_sg(), it passes MAX_SGL_EN=
TS as
    the maximum number of elements that may be written to, but some of the
    elements may already have been used (as recorded in sgl->cur), so
    extract_iter_to_sg() may end up overrunning the scatterlist.
    =

    Fix this to limit the number of elements to "MAX_SGL_ENTS - sgl->cur".
    =

    Note: It probably makes sense in future to alter the behaviour of
    extract_iter_to_sg() to stop if "sgtable->nents >=3D sg_max" instead, =
but
    this is a smaller fix for now.
    =

    The bug causes errors looking something like:
    =

    BUG: KASAN: slab-out-of-bounds in sg_assign_page include/linux/scatter=
list.h:109 [inline]
    BUG: KASAN: slab-out-of-bounds in sg_set_page include/linux/scatterlis=
t.h:139 [inline]
    BUG: KASAN: slab-out-of-bounds in extract_bvec_to_sg lib/scatterlist.c=
:1183 [inline]
    BUG: KASAN: slab-out-of-bounds in extract_iter_to_sg lib/scatterlist.c=
:1352 [inline]
    BUG: KASAN: slab-out-of-bounds in extract_iter_to_sg+0x17a6/0x1960 lib=
/scatterlist.c:1339
    =

    Fixes: bf63e250c4b1 ("crypto: af_alg: Support MSG_SPLICE_PAGES")
    Reported-by: syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com
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

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 7d4b6016b83d..cdb1dcc5dd1a 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1043,7 +1043,7 @@ int af_alg_sendmsg(struct socket *sock, struct msghd=
r *msg, size_t size,
 			};
 =

 			plen =3D extract_iter_to_sg(&msg->msg_iter, len, &sgtable,
-						  MAX_SGL_ENTS, 0);
+						  MAX_SGL_ENTS - sgl->cur, 0);
 			if (plen < 0) {
 				err =3D plen;
 				goto unlock;


