Return-Path: <netdev+bounces-11947-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74717735665
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:05:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A67681C209F6
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29EAB107B1;
	Mon, 19 Jun 2023 12:05:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B86CD539
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 12:05:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C241A8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 05:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687176343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=flv0m9IzvhIUpKnDIyrInh56vnSxXK9hbzXv0isFig8=;
	b=Wp9BlVqKIhS28sFgcvGrKzbCzwdaJ5qB2dONWvHT3uy5F+CwJ3kN30H6GyXwYIu0BJVVOU
	Eoq28K9Ma14BOGicewTVD2Q3aVyB6E+1Q4xaa19yt5PHk9MEPpzYBAHYAlQCgyDOk/vZUu
	pMfcWEe4h8JKafirYXiK0W4lOGn+EMw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-6kJ1RmfDPwCBOHGN8dJYCQ-1; Mon, 19 Jun 2023 08:05:40 -0400
X-MC-Unique: 6kJ1RmfDPwCBOHGN8dJYCQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FC9A1C06EC1;
	Mon, 19 Jun 2023 12:05:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 88C75C1603B;
	Mon, 19 Jun 2023 12:05:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <648f36d02fe6e_33cfbc2944f@willemb.c.googlers.com.notmuch>
References: <648f36d02fe6e_33cfbc2944f@willemb.c.googlers.com.notmuch> <20230617121146.716077-1-dhowells@redhat.com> <20230617121146.716077-18-dhowells@redhat.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    Alexander Duyck <alexander.duyck@gmail.com>,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>,
    Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    linux-mm@kvack.org, linux-kernel@vger.kernel.org,
    bpf@vger.kernel.org, dccp@vger.kernel.org,
    linux-afs@lists.infradead.org, linux-arm-msm@vger.kernel.org,
    linux-can@vger.kernel.org, linux-crypto@vger.kernel.org,
    linux-doc@vger.kernel.org, linux-hams@vger.kernel.org,
    linux-perf-users@vger.kernel.org, linux-rdma@vger.kernel.org,
    linux-sctp@vger.kernel.org, linux-wpan@vger.kernel.org,
    linux-x25@vger.kernel.org, mptcp@lists.linux.dev,
    rds-devel@oss.oracle.com, tipc-discussion@lists.sourceforge.net,
    virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 17/17] net: Kill MSG_SENDPAGE_NOTLAST
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <784657.1687176327.1@warthog.procyon.org.uk>
Date: Mon, 19 Jun 2023 13:05:27 +0100
Message-ID: <784658.1687176327@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> Is it intentional to add MSG_MORE here in this patch?
> 
> I do see that patch 3 removes this branch:

Yeah.  I think I may have tcp_bpf a bit wrong with regard to handling
MSG_MORE.

How about the attached version of tcp_bpf_push()?

I wonder if it's save to move the setting of MSG_SENDPAGE_NOPOLICY out of the
loop as I've done here.  The caller holds the socket lock.

Also, I'm not sure whether to take account of apply/apply_bytes when setting
MSG_MORE mid-message, or whether to just go on whether we've reached
sge->length yet.  (I'm not sure exactly how tcp_bpf works).

David
---

static int tcp_bpf_push(struct sock *sk, struct sk_msg *msg, u32 apply_bytes,
			int flags, bool uncharge)
{
	bool apply = apply_bytes;
	struct scatterlist *sge;
	struct page *page;
	int size, ret = 0;
	u32 off;

	flags |= MSG_SPLICE_PAGES;
	if (tls_sw_has_ctx_tx(sk))
		msghdr.msg_flags |= MSG_SENDPAGE_NOPOLICY;

	while (1) {
		struct msghdr msghdr = {};
		struct bio_vec bvec;

		sge = sk_msg_elem(msg, msg->sg.start);
		size = (apply && apply_bytes < sge->length) ?
			apply_bytes : sge->length;
		off  = sge->offset;
		page = sg_page(sge);

		tcp_rate_check_app_limited(sk);
retry:
		msghdr.msg_flags = flags;

		/* Determine if we need to set MSG_MORE. */
		if (!(msghdr.msg_flags & MSG_MORE)) {
			if (apply && size < apply_bytes)
				msghdr.msg_flags |= MSG_MORE;
			else if (!apply && size < sge->length &&
				 msg->sg.start != msg->sg.end)
				msghdr.msg_flags |= MSG_MORE;
		}

		bvec_set_page(&bvec, page, size, off);
		iov_iter_bvec(&msghdr.msg_iter, ITER_SOURCE, &bvec, 1, size);
		ret = tcp_sendmsg_locked(sk, &msghdr, size);
		if (ret <= 0)
			return ret;

		if (apply)
			apply_bytes -= ret;
		msg->sg.size -= ret;
		sge->offset += ret;
		sge->length -= ret;
		if (uncharge)
			sk_mem_uncharge(sk, ret);
		if (ret != size) {
			size -= ret;
			off  += ret;
			goto retry;
		}
		if (!sge->length) {
			put_page(page);
			sk_msg_iter_next(msg, start);
			sg_init_table(sge, 1);
			if (msg->sg.start == msg->sg.end)
				break;
		}
		if (apply && !apply_bytes)
			break;
	}

	return 0;
}


