Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D956C8C4B
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 08:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjCYHpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 03:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbjCYHpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 03:45:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2609E1515D
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 00:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679730265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c1fqtu9LBWrWaCQxQTVjr0cxRai+bTqOnRnWXMB8NKA=;
        b=C4Se7jDCNpm4VB+6K7RzgEFTEBJ3OeClIJNvGO5AwVFpDa+JnaIFb3t432FRJwH6szuTA7
        ySOkTfua59+utZIRWi9VUpEmd1ORar5EgIEHuVYnOc5LGZyct2InV0CLTw8XVaBdvuPfHU
        brEe9mMOoCkFGHF3zRWYdJ2dUlOW3c8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-H1kqNBBlOki1ozjiPf4r0w-1; Sat, 25 Mar 2023 03:44:18 -0400
X-MC-Unique: H1kqNBBlOki1ozjiPf4r0w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 698D385C06B;
        Sat, 25 Mar 2023 07:44:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55749175AD;
        Sat, 25 Mar 2023 07:44:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <ZB6N/H27oeWqouyb@gondor.apana.org.au>
References: <ZB6N/H27oeWqouyb@gondor.apana.org.au> <ZBPTC9WPYQGhFI30@gondor.apana.org.au> <3763055.1679676470@warthog.procyon.org.uk>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     dhowells@redhat.com, willy@infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        viro@zeniv.linux.org.uk, hch@infradead.org, axboe@kernel.dk,
        jlayton@kernel.org, brauner@kernel.org,
        torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH 23/28] algif: Remove hash_sendpage*()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3792016.1679730254.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Sat, 25 Mar 2023 07:44:14 +0000
Message-ID: <3792017.1679730254@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > I must be missing something, I think.  What's particularly optimal abo=
ut the
> > code in hash_sendpage() but not hash_sendmsg()?  Is it that the former=
 uses
> > finup/digest, but the latter ony does update+final?
> =

> A lot of hardware hashes can't perform partial updates, so they
> will always fall back to software unless you use finup/digest.

Okay.  Btw, how much of a hard limit is ALG_MAX_PAGES?  Multipage folios c=
an
exceed the current limit (16 pages, 64K) in size.  Is it just to prevent t=
oo
much memory being pinned at once?

David

