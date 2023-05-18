Return-Path: <netdev+bounces-3546-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09725707D4D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 11:53:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE85F1C21070
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 09:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 964C711CA6;
	Thu, 18 May 2023 09:53:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827D811CA5
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 09:53:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FBDE4E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 02:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684403618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7yINWos61yS1/Ae1KTt8I7rV0PBzJ6/BJSLEhV5ATss=;
	b=NnRD0GTJpEyfEOu+emSUbhT1sQ4+Na2WaV4+DstUJ3q8MA1keR2eXv496nfubJvgmOPvEl
	kDJNsTCoiJaBsES1Ye5tay677XcUw08duaVY+Agtwo2uy8c3evqrahstMl9ehlipcY20Ac
	BSuWKY2mSaGUw7CGGUe59g5COYrXrQk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-Gbff7KXbNvW9CLicHQ5d5Q-1; Thu, 18 May 2023 05:53:33 -0400
X-MC-Unique: Gbff7KXbNvW9CLicHQ5d5Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E423A3813F37;
	Thu, 18 May 2023 09:53:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.221])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C1CAA492C13;
	Thu, 18 May 2023 09:53:29 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <93aba6cc363e94a6efe433b3c77ec1b6b54f2919.camel@redhat.com>
References: <93aba6cc363e94a6efe433b3c77ec1b6b54f2919.camel@redhat.com> <20230515093345.396978-1-dhowells@redhat.com> <20230515093345.396978-4-dhowells@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    "David S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
    David Ahern <dsahern@kernel.org>,
    Matthew Wilcox <willy@infradead.org>,
    Al Viro <viro@zeniv.linux.org.uk>,
    Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    Jeff Layton <jlayton@kernel.org>,
    Christian Brauner <brauner@kernel.org>,
    Chuck Lever III <chuck.lever@oracle.com>,
    Linus Torvalds <torvalds@linux-foundation.org>,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    linux-mm@kvack.org
Subject: Re: [PATCH net-next v7 03/16] net: Add a function to splice pages into an skbuff for MSG_SPLICE_PAGES
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1347186.1684403608.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 18 May 2023 10:53:28 +0100
Message-ID: <1347187.1684403608@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Paolo Abeni <pabeni@redhat.com> wrote:

> Minor nit: please respect the reverse x-mas tree order (there are a few
> other occurrences around)

I hadn't come across that.  Normally I only apply that to the types so tha=
t
the names aren't all over the place.  But whatever.

> > +		if (space =3D=3D 0 &&
> > +		    !skb_can_coalesce(skb, skb_shinfo(skb)->nr_frags,
> > +				      pages[0], off)) {
> > +			iov_iter_revert(iter, len);
> > +			break;
> > +		}
> =

> It looks like the above condition/checks duplicate what the later
> skb_append_pagefrags() will perform below. I guess the above chunk
> could be removed?

Good point.  There used to be an allocation between in the case sendpage_o=
k()
failed and we wanted to copy the data.  I've removed that for the moment.

> > +			ret =3D -EIO;
> > +			if (!sendpage_ok(page))
> > +				goto out;
> =

> My (limited) understanding is that the current sendpage code assumes
> that the caller provides/uses pages suitable for such use. The existing
> sendpage_ok() check is in place as way to try to catch possible code
> bug - via the WARN_ONCE().
>
> I think the same could be done here?

Yeah.

Okay, I made the attached changes to this patch.

David
---
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 56d629ea2f3d..f4a5b51aed22 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6923,10 +6923,10 @@ static void skb_splice_csum_page(struct sk_buff *s=
kb, struct page *page,
 ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
 			     ssize_t maxsize, gfp_t gfp)
 {
+	size_t frag_limit =3D READ_ONCE(sysctl_max_skb_frags);
 	struct page *pages[8], **ppages =3D pages;
-	unsigned int i;
 	ssize_t spliced =3D 0, ret =3D 0;
-	size_t frag_limit =3D READ_ONCE(sysctl_max_skb_frags);
+	unsigned int i;
 =

 	while (iter->count > 0) {
 		ssize_t space, nr;
@@ -6946,20 +6946,13 @@ ssize_t skb_splice_from_iter(struct sk_buff *skb, =
struct iov_iter *iter,
 			break;
 		}
 =

-		if (space =3D=3D 0 &&
-		    !skb_can_coalesce(skb, skb_shinfo(skb)->nr_frags,
-				      pages[0], off)) {
-			iov_iter_revert(iter, len);
-			break;
-		}
-
 		i =3D 0;
 		do {
 			struct page *page =3D pages[i++];
 			size_t part =3D min_t(size_t, PAGE_SIZE - off, len);
 =

 			ret =3D -EIO;
-			if (!sendpage_ok(page))
+			if (WARN_ON_ONCE(!sendpage_ok(page)))
 				goto out;
 =

 			ret =3D skb_append_pagefrags(skb, page, off, part,


