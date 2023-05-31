Return-Path: <netdev+bounces-6730-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FE98717AB9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79164281146
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 774ACBE6B;
	Wed, 31 May 2023 08:52:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4A01879
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:52:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC59C194
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 01:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685523119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WGo4qtRQ4pkJVWaEUVypZ+1I1vSFSgJTj8gN/jNbr24=;
	b=I2KF44bSn0L3SoygoNBC9h0gV8ali7yenRSqjYXC0dWpr5dxQzqvD4U+lgUG18a2VZmVPA
	xDqL0Uza/Ez+PYdYdpuqBAdfFVzjgqZk/Z9hLzLkmEHV4Dv/ffZSxWBE2MJU0i2jbTirK9
	2AUOkHJnfyyZi71OVifr3iGdCKvxN5Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-6A7MVqTQNyGeS8sO5Uaxog-1; Wed, 31 May 2023 04:51:57 -0400
X-MC-Unique: 6A7MVqTQNyGeS8sO5Uaxog-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD993280BC41;
	Wed, 31 May 2023 08:51:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9FE4B40E6A43;
	Wed, 31 May 2023 08:51:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20230526201202.1cd35fe9@kernel.org>
References: <20230526201202.1cd35fe9@kernel.org> <20230524144923.3623536-1-dhowells@redhat.com> <20230524144923.3623536-4-dhowells@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
    Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
    David Ahern <dsahern@kernel.org>,
    Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    linux-mm@kvack.org, linux-kernel@vger.kernel.org,
    Tom Herbert <tom@herbertland.com>, Tom Herbert <tom@quantonium.net>
Subject: Re: [PATCH net-next 3/4] kcm: Support MSG_SPLICE_PAGES
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <574369.1685523113.1@warthog.procyon.org.uk>
Date: Wed, 31 May 2023 09:51:53 +0100
Message-ID: <574370.1685523113@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Jakub Kicinski <kuba@kernel.org> wrote:

> On Wed, 24 May 2023 15:49:22 +0100 David Howells wrote:
> > +			err = skb_splice_from_iter(skb, &msg->msg_iter, copy,
> > +						   sk->sk_allocation);
> > +			if (err < 0) {
> > +				if (err == -EMSGSIZE)
> > +					goto wait_for_memory;
> > +				goto out_error;
> > +			}
> >  
> 
> should there be a:
> 
> 		copy = err;
> or:
> 		copy -= msg_data_left(msg);
> 
> or some such here? Can we safely assume that skb_splice_from_iter() will
> copy all or nothing? 

Yeah.  Good point.  I didn't add one because the normal operation code doesn't
do that - but I guess that's all-or-nothing.

David


