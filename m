Return-Path: <netdev+bounces-10698-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDBF472FDD7
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:05:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9EB81C20CE7
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B57E8C1B;
	Wed, 14 Jun 2023 12:04:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECA58463
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:04:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F291FD2
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 05:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686744292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wOPn16B3XWpxkytpYHR3Z5EM60rOR3dmARKpzGwWozo=;
	b=CQuZSv48VoYlS5Gut2KEBMAWU/Hq8RE2m06eTbpxZS3PS6qn1bmnsFoCD8OKYhOVJ2DlQc
	yf0gvyjBWypLeqVf/CQRYGUpc7UUGs1iJVApAB02zLhp98wdnV2qh39QqvQMxoCr33TPiT
	f8oq32WEYnqvxeLRKW9rG0an+9oiX68=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-oSw5vEMcNhWtY8PAEacv1A-1; Wed, 14 Jun 2023 08:04:47 -0400
X-MC-Unique: oSw5vEMcNhWtY8PAEacv1A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 710041C0E3D4;
	Wed, 14 Jun 2023 12:04:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5B3BF492CA6;
	Wed, 14 Jun 2023 12:04:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <ZIhD53a/6Svmn1aS@gondor.apana.org.au>
References: <ZIhD53a/6Svmn1aS@gondor.apana.org.au> <0000000000000cb2c305fdeb8e30@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dhowells@redhat.com,
    syzbot <syzbot+e79818f5c12416aba9de@syzkaller.appspotmail.com>,
    davem@davemloft.net, linux-crypto@vger.kernel.org,
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
    pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] general protection fault in cryptd_hash_export
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1521346.1686744278.1@warthog.procyon.org.uk>
Date: Wed, 14 Jun 2023 13:04:38 +0100
Message-ID: <1521347.1686744278@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> David, the logic for calling hash_alloc_result looks quite different
> from that on whether you do the hash finalisation.  I'd suggest that
> you change them to use the same check, and also set use NULL instead
> of ctx->result if you didn't call hash_alloc_result.

I don't fully understand what the upstream hash_sendmsg() is doing.  Take this
bit for example:

	if (!ctx->more) {
		if ((msg->msg_flags & MSG_MORE))
			hash_free_result(sk, ctx);

Why is it freeing the old result only if MSG_MORE is now set, but wasn't set
on the last sendmsg()?

David


