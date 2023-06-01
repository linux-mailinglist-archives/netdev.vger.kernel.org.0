Return-Path: <netdev+bounces-7109-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBD1E71A025
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:34:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7687C2811DF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 14:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7F0FFC1D;
	Thu,  1 Jun 2023 14:34:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9795823439
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 14:34:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CB21A8
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 07:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685630061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5cWnXN2OJgEdtvyQPWdKWzOTqRw1rxRQiL55xfvSEwM=;
	b=O/UOkcypUmjV4f91JnZOlEF3w3tymL6PM5gyQ4O9/VuUfOVx7HiBz65N+xSDKPsGaCP8LB
	s6/t/HYyjie4BXTwRTYBduUIH8JTvs30pU0SnX0R0loLmXNoPx455IPdMqHFkwpXqtOeIU
	qVIIMg89c5xfCxV3jwNjRfVWFlgxAfU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-B2F83YmsP2aeqexs1ttJDQ-1; Thu, 01 Jun 2023 10:34:18 -0400
X-MC-Unique: B2F83YmsP2aeqexs1ttJDQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B28721C01719;
	Thu,  1 Jun 2023 14:34:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A3ABE48205E;
	Thu,  1 Jun 2023 14:34:14 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHk-=wghhHghtvU_SzXxAzfaX35BkNs-x91-Vj6+6tnVEhPrZg@mail.gmail.com>
References: <CAHk-=wghhHghtvU_SzXxAzfaX35BkNs-x91-Vj6+6tnVEhPrZg@mail.gmail.com> <20230524153311.3625329-1-dhowells@redhat.com> <20230524153311.3625329-10-dhowells@redhat.com> <20230526180844.73745d78@kernel.org> <499791.1685485603@warthog.procyon.org.uk> <CAHk-=wgeixW3cc=Ys8eL0_+22FUhqeEru=nzRrSXy1U4YQdE-w@mail.gmail.com>
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
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Jun 2023 15:34:08 +0100
Message-ID: <832277.1685630048@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jun 1, 2023 at 9:09=E2=80=AFAM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > The reason the old code is garbage is that it sets SPLICE_F_MORE
> > entirely in the wrong place. It sets it *after* it has done the
> > splice(). That's just crazy.
>=20
> Clarification, because there are two splice's (from and to): by "after
> the splice" I mean after the splice source, of course. It's still set
> before the splice _to_ the network.
>=20
> (But it is still true that I hope the networking code itself then sets
> MSG_MORE even if SPLICE_F_MORE wasn't set, if it gets a buffer that is
> bigger than what it can handle right now - so there are two
> *different* reasons for "more data" - either the source knows it has
> more to give, or the destination knows it didn't use everything it
> got).

I'm in the process of changing things so that ->sendpage() is removed and
replaced with sendmsg() with MSG_SPLICE_PAGES.  The aim is to end up with a
splice_to_socket() function (see attached) that transcribes a chunk of the
pipe into a BVEC iterator and does a single sendmsg() that pushes a whole
chunk of data to the socket in one go.

In the network protocol, the loop inside sendmsg splices those pages into
socket buffers, sleeping as necessary to gain sufficient memory to transcri=
be
all of them.  It can return partly done and the fully consumed pages will be
consumed and then it'll return to gain more data.

At the moment, it transcribes 16 pages at a time.  I could make it set
MSG_MORE only if (a) SPLICE_F_MORE was passed into the splice() syscall or =
(b)
there's yet more data in the buffer.

However, this might well cause a malfunction in UDP, for example.  MSG_MORE
corks the current packet, so if I ask sendfile() say shove 32K into a packe=
t,
if, say, 16K is read from the source and entirely transcribed into the pack=
et,
if I understand what you're proposing, MSG_MORE wouldn't get set and the
packet would be transmitted early.  A similar issue might exist for AF_TLS,
where the lack of MSG_MORE triggers an end-of-record.

The problem isn't that the buffer supplied is bigger than the protocol could
handle in one go, it's that what we read was less than the amount that the
user requested - but we don't know if there will be more data.

One solution might be to pass MSG_MORE regardless, and then follow up with a
null sendmsg() if we then hit a zero-length read (ie. EOF) or -ENODATA (ie.=
 a
hole).

> The point is that the splice *source* knows whether there is more data
> to be had, and that's where the "there is more" should be set.

Actually, that's not necessarily true.  If the source is a pipe or a socket,
there may not be more, but we don't know that until the far end is closed -
but for a file it probably is (we could be racing with a writer).  And then
there's seqfile-based things like the trace buffer or procfiles which are
really a class of their own.

> Basically my argument is that the whole "there is more data" should be
> set by "->splice_read()" not by some hack in some generic
> splice_direct_to_actor() function that is absolutely not supposed to
> know about the internals of the source or the destination.
>=20
> Do we have a good interface for that? No. I get the feeling that to
> actually fix this, we'd have to pass in the 'struct splice_desc"
> pointer to ->splice_read().

That might become more feasible, actually.  In Jens's tree are the patches =
to
clean up splice_read a lot and get rid of ITER_PIPE.  Most of the
->splice_reads are going to be direct calls to copy_splice_read() and
filemap_splice_read() or wrappers around filemap_splice_read().  The latter,
at least, might be in a good position to note EOF, perhaps by marking a pipe
buffer as "no more".

copy_splice_read() is more problematic because ->read_iter() doesn't indica=
te
if it hit EOF (or hit a hole).

David
---
ssize_t splice_to_socket(struct pipe_inode_info *pipe, struct file *out,
			 loff_t *ppos, size_t len, unsigned int flags)
{
	struct socket *sock =3D sock_from_file(out);
	struct bio_vec bvec[16];
	struct msghdr msg =3D {};
	ssize_t ret;
	size_t spliced =3D 0;
	bool need_wakeup =3D false;

	pipe_lock(pipe);

	while (len > 0) {
		unsigned int head, tail, mask, bc =3D 0;
		size_t remain =3D len;

		/*
		 * Check for signal early to make process killable when there
		 * are always buffers available
		 */
		ret =3D -ERESTARTSYS;
		if (signal_pending(current))
			break;

		while (pipe_empty(pipe->head, pipe->tail)) {
			ret =3D 0;
			if (!pipe->writers)
				goto out;

			if (spliced)
				goto out;

			ret =3D -EAGAIN;
			if (flags & SPLICE_F_NONBLOCK)
				goto out;

			ret =3D -ERESTARTSYS;
			if (signal_pending(current))
				goto out;

			if (need_wakeup) {
				wakeup_pipe_writers(pipe);
				need_wakeup =3D false;
			}

			pipe_wait_readable(pipe);
		}

		head =3D pipe->head;
		tail =3D pipe->tail;
		mask =3D pipe->ring_size - 1;

		while (!pipe_empty(head, tail)) {
			struct pipe_buffer *buf =3D &pipe->bufs[tail & mask];
			size_t seg;

			if (!buf->len) {
				tail++;
				continue;
			}

			seg =3D min_t(size_t, remain, buf->len);
			seg =3D min_t(size_t, seg, PAGE_SIZE);

			ret =3D pipe_buf_confirm(pipe, buf);
			if (unlikely(ret)) {
				if (ret =3D=3D -ENODATA)
					ret =3D 0;
				break;
			}

			bvec_set_page(&bvec[bc++], buf->page, seg, buf->offset);
			remain -=3D seg;
			if (seg >=3D buf->len)
				tail++;
			if (bc >=3D ARRAY_SIZE(bvec))
				break;
		}

		if (!bc)
			break;

		msg.msg_flags =3D 0;
		if (flags & SPLICE_F_MORE)
			msg.msg_flags =3D MSG_MORE;
		if (remain && pipe_occupancy(pipe->head, tail) > 0)
			msg.msg_flags =3D MSG_MORE;
		msg.msg_flags |=3D MSG_SPLICE_PAGES;

		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, bvec, bc, len - remain);
		ret =3D sock_sendmsg(sock, &msg);
		if (ret <=3D 0)
			break;

		spliced +=3D ret;
		len -=3D ret;
		tail =3D pipe->tail;
		while (ret > 0) {
			struct pipe_buffer *buf =3D &pipe->bufs[tail & mask];
			size_t seg =3D min_t(size_t, ret, buf->len);

			buf->offset +=3D seg;
			buf->len -=3D seg;
			ret -=3D seg;

			if (!buf->len) {
				pipe_buf_release(pipe, buf);
				tail++;
			}
		}

		if (tail !=3D pipe->tail) {
			pipe->tail =3D tail;
			if (pipe->files)
				need_wakeup =3D true;
		}
	}

out:
	pipe_unlock(pipe);
	if (need_wakeup)
		wakeup_pipe_writers(pipe);
	return spliced ?: ret;
}


