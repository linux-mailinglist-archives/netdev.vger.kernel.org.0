Return-Path: <netdev+bounces-7183-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4924671F069
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB2F21C20A20
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94E1242539;
	Thu,  1 Jun 2023 17:14:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8456340795
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:14:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9F218D
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685639686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7UAbNml4oAWGP++9AqxwAaw9U/MQwWhNaY462tBqx4=;
	b=igR2KjXgb3/16k3aIHz3+9LB/T4aTtlMbYh/s124YsfjrfakAP0mbmpXaPidbNuhIjlQic
	D0krDZJWtcWpx5Yj7HLJe+Qg5t+CssTJD+Omk5XzfE8BP+9gKlml1v5dlDcNYzojl9P+qN
	9bzMpul5TOVhhJiCnt/2PBn+rT/NsZQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-Dzf09lmbM7i9aB3uYBIKvQ-1; Thu, 01 Jun 2023 13:14:44 -0400
X-MC-Unique: Dzf09lmbM7i9aB3uYBIKvQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6338385A5A8;
	Thu,  1 Jun 2023 17:14:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3AD31C154D7;
	Thu,  1 Jun 2023 17:14:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHk-=wji_2UwFMkUYkygsYRek05NwaQkH-vA=yKQtQS9Js+urQ@mail.gmail.com>
References: <CAHk-=wji_2UwFMkUYkygsYRek05NwaQkH-vA=yKQtQS9Js+urQ@mail.gmail.com> <20230524153311.3625329-1-dhowells@redhat.com> <20230524153311.3625329-10-dhowells@redhat.com> <20230526180844.73745d78@kernel.org> <499791.1685485603@warthog.procyon.org.uk> <CAHk-=wgeixW3cc=Ys8eL0_+22FUhqeEru=nzRrSXy1U4YQdE-w@mail.gmail.com> <CAHk-=wghhHghtvU_SzXxAzfaX35BkNs-x91-Vj6+6tnVEhPrZg@mail.gmail.com> <832277.1685630048@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Jakub Kicinski <kuba@kernel.org>,
    netdev@vger.kernel.org, "David S.
 Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
    Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
    David Ahern <dsahern@kernel.org>,
    Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    linux-mm@kvack.org, linux-kernel@vger.kernel.org,
    Chuck Lever <chuck.lever@oracle.com>,
    Boris Pismenny <borisp@nvidia.com>,
    John Fastabend <john.fastabend@gmail.com>,
    Christoph Hellwig <hch@infradead.org>
Subject: Re: Bug in short splice to socket?
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <909594.1685639680.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Jun 2023 18:14:40 +0100
Message-ID: <909595.1685639680@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > However, this might well cause a malfunction in UDP, for example.
> > MSG_MORE corks the current packet, so if I ask sendfile() say shove 32=
K
> > into a packet, if, say, 16K is read from the source and entirely
> > transcribed into the packet,
> =

> If you use splice() for UDP, I don't think you would normally expect
> to get all that well-defined packet boundaries.

Actually, it will.  Attempting to overfill a UDP packet with splice will g=
et
you -EMSGSIZE.  It won't turn a splice into more than one UDP packet.

I wonder if the right solution actually is to declare that the problem is
userspace's.  If you ask it to splice Z amount of data and it can't manage
that because the source dries up prematurely, then make it so that you ass=
ume
it always passed MSG_MORE and returns a short splice to userspace.  Usersp=
ace
can retry the splice/sendfile or do an empty sendmsg() to cap the message =
(or
cancel it).  Perhaps flushing a short message is actually a *bad* idea.

The answer then might be to make TLS handle a zero-length send() and fix t=
he
test cases.  Would the attached changes then work for you?

David
---
diff --git a/fs/splice.c b/fs/splice.c
index 3e06611d19ae..237688b0700b 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -956,13 +956,17 @@ ssize_t splice_direct_to_actor(struct file *in, stru=
ct splice_desc *sd,
 	 */
 	bytes =3D 0;
 	len =3D sd->total_len;
+
+	/* Don't block on output, we have to drain the direct pipe. */
 	flags =3D sd->flags;
+	sd->flags &=3D ~SPLICE_F_NONBLOCK;
 =

 	/*
-	 * Don't block on output, we have to drain the direct pipe.
+	 * We signal MORE until we've read sufficient data to fulfill the
+	 * request and we keep signalling it if the caller set it.
 	 */
-	sd->flags &=3D ~SPLICE_F_NONBLOCK;
 	more =3D sd->flags & SPLICE_F_MORE;
+	sd->flags |=3D SPLICE_F_MORE;
 =

 	WARN_ON_ONCE(!pipe_empty(pipe->head, pipe->tail));
 =

@@ -978,14 +982,12 @@ ssize_t splice_direct_to_actor(struct file *in, stru=
ct splice_desc *sd,
 		sd->total_len =3D read_len;
 =

 		/*
-		 * If more data is pending, set SPLICE_F_MORE
-		 * If this is the last data and SPLICE_F_MORE was not set
-		 * initially, clears it.
+		 * If we now have sufficient data to fulfill the request then
+		 * we clear SPLICE_F_MORE if it was not set initially.
 		 */
-		if (read_len < len)
-			sd->flags |=3D SPLICE_F_MORE;
-		else if (!more)
+		if (read_len >=3D len && !more)
 			sd->flags &=3D ~SPLICE_F_MORE;
+
 		/*
 		 * NOTE: nonblocking mode only applies to the input. We
 		 * must not do the output in nonblocking mode as then we
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index f63e4405cf34..5d48391da16c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -995,6 +995,9 @@ static int tls_sw_sendmsg_locked(struct sock *sk, stru=
ct msghdr *msg,
 		}
 	}
 =

+	if (!msg_data_left(msg) && eor)
+		goto copied;
+
 	while (msg_data_left(msg)) {
 		if (sk->sk_err) {
 			ret =3D -sk->sk_err;
diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/n=
et/tls.c
index e699548d4247..7df31583f2a4 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -377,7 +377,7 @@ static void chunked_sendfile(struct __test_metadata *_=
metadata,
 	char buf[TLS_PAYLOAD_MAX_LEN];
 	uint16_t test_payload_size;
 	int size =3D 0;
-	int ret;
+	int ret =3D 0;
 	char filename[] =3D "/tmp/mytemp.XXXXXX";
 	int fd =3D mkstemp(filename);
 	off_t offset =3D 0;
@@ -398,6 +398,9 @@ static void chunked_sendfile(struct __test_metadata *_=
metadata,
 		size -=3D ret;
 	}
 =

+	if (ret < chunk_size)
+		EXPECT_EQ(send(self->fd, "", 0, 0), 0);
+
 	EXPECT_EQ(recv(self->cfd, buf, test_payload_size, MSG_WAITALL),
 		  test_payload_size);
 =



