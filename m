Return-Path: <netdev+bounces-7337-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D94F071FBC9
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:23:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99841281662
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 08:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5771C8FE;
	Fri,  2 Jun 2023 08:23:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95029846C
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:23:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86246F2
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 01:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685694230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oD+X2kcKX6bzS0/GnmGAAZI7Di/1DIZrV3VWBtc6qTI=;
	b=DETbqjQyCqJ9NClCal0S7Fn3mr5+n4khSSET4W8ZJQb7XXuE8jSghFGiq2o/CZyrGRx+AX
	J2yZD8olxBSGCRcFR6nkHVAG2pyEbaRz6HZQjQbIs5oWFQB18Gg1qeozwuu09dNDsA+bVi
	pVyujfZcmOyjAWiEJhzUok+8/nJGUTc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-2PmVrOJmMwqg0KXeqP6pYw-1; Fri, 02 Jun 2023 04:23:45 -0400
X-MC-Unique: 2PmVrOJmMwqg0KXeqP6pYw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C388185A78F;
	Fri,  2 Jun 2023 08:23:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 02FB520296C6;
	Fri,  2 Jun 2023 08:23:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20230601212043.720f85c2@kernel.org>
References: <20230601212043.720f85c2@kernel.org> <CAHk-=wji_2UwFMkUYkygsYRek05NwaQkH-vA=yKQtQS9Js+urQ@mail.gmail.com> <20230524153311.3625329-1-dhowells@redhat.com> <20230524153311.3625329-10-dhowells@redhat.com> <20230526180844.73745d78@kernel.org> <499791.1685485603@warthog.procyon.org.uk> <CAHk-=wgeixW3cc=Ys8eL0_+22FUhqeEru=nzRrSXy1U4YQdE-w@mail.gmail.com> <CAHk-=wghhHghtvU_SzXxAzfaX35BkNs-x91-Vj6+6tnVEhPrZg@mail.gmail.com> <832277.1685630048@warthog.procyon.org.uk> <909595.1685639680@warthog.procyon.org.uk>
To: Jakub Kicinski <kuba@kernel.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
    netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
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
Content-ID: <952876.1685694220.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Jun 2023 09:23:40 +0100
Message-ID: <952877.1685694220@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 01 Jun 2023 18:14:40 +0100 David Howells wrote:
> > The answer then might be to make TLS handle a zero-length send()
> =

> IDK. Eric added MSG_SENDPAGE_NOTLAST 11 years ago, to work around =

> this exact problem. Your refactoring happens to break it and what
> you're saying sounds to me more or less like "MSG_SENDPAGE_NOTLAST =

> is unnecessary, it's user's fault".
> =

> A bit unconvincing. Maybe Eric would chime in, I'm not too familiar
> with the deadly mess of the unchecked sendmsg()/sendpage() flags.

Not so much the "user's fault" as we couldn't fulfill what the user asked =
- so
should we leave it to the user to work out how to clean it up rather than
automatically allowing the socket to flush (if cancellation might be an op=
tion
instead)?

The problem I have with NOTLAST is that it won't be asserted if the short =
read
only occupies a single pipe_buf.  We don't know that we won't get some mor=
e
data on the next pass.

An alternative way to maintain the current behaviour might be to have
splice_direct_to_actor() call the actor with sd->total_len =3D=3D 0 if
do_splice_to() returned 0 and SPLICE_F_MORE wasn't set by the caller
(ie. !more).  Attached is a change to do that.  It becomes simpler if/once=
 my
splice_to_socket() patches are applied - but I don't really want to push t=
hat
until all the protocols that support sendpage() support sendmsg() +
MSG_SPLICE_PAGES as well[*].

[*] Though if you're okay having a small window where TLS copies data rath=
er
    than splicing, I could push the splice_to_socket() patches *first*.  T=
CP
    and AF_UNIX splice already support MSG_SPLICE_PAGES so that would bump
    their efficiency.

David
---
diff --git a/fs/splice.c b/fs/splice.c
index 3e06611d19ae..84e9ca06db47 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -643,6 +643,22 @@ static void splice_from_pipe_end(struct pipe_inode_in=
fo *pipe, struct splice_des
 		wakeup_pipe_writers(pipe);
 }
 =

+/*
+ * Pass a zero-length record to the splice-write actor with SPLICE_F_MORE
+ * turned off to allow the network to see MSG_MORE deasserted.
+ */
+static ssize_t splice_from_pipe_zero(struct pipe_inode_info *pipe,
+				     struct splice_desc *sd,
+				     splice_actor *actor)
+{
+	struct pipe_buffer buf =3D {
+		.page	=3D ZERO_PAGE(0),
+		.ops	=3D &nosteal_pipe_buf_ops,
+	};
+
+	return actor(pipe, &buf, sd);
+}
+
 /**
  * __splice_from_pipe - splice data from a pipe to given actor
  * @pipe:	pipe to splice from
@@ -662,6 +678,9 @@ ssize_t __splice_from_pipe(struct pipe_inode_info *pip=
e, struct splice_desc *sd,
 	int ret;
 =

 	splice_from_pipe_begin(sd);
+	if (!sd->total_len)
+		return splice_from_pipe_zero(pipe, sd, actor);
+
 	do {
 		cond_resched();
 		ret =3D splice_from_pipe_next(pipe, sd);
@@ -956,13 +975,17 @@ ssize_t splice_direct_to_actor(struct file *in, stru=
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

@@ -971,21 +994,19 @@ ssize_t splice_direct_to_actor(struct file *in, stru=
ct splice_desc *sd,
 		loff_t pos =3D sd->pos, prev_pos =3D pos;
 =

 		ret =3D do_splice_to(in, &pos, pipe, len, flags);
-		if (unlikely(ret <=3D 0))
+		if (unlikely(ret < 0))
 			goto out_release;
 =

 		read_len =3D ret;
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
+		if ((read_len =3D=3D 0 || read_len >=3D len) && !more)
 			sd->flags &=3D ~SPLICE_F_MORE;
+
 		/*
 		 * NOTE: nonblocking mode only applies to the input. We
 		 * must not do the output in nonblocking mode as then we
@@ -1005,6 +1026,8 @@ ssize_t splice_direct_to_actor(struct file *in, stru=
ct splice_desc *sd,
 			sd->pos =3D prev_pos + ret;
 			goto out_release;
 		}
+		if (read_len < 0)
+			goto out_release;
 	}
 =

 done:
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


