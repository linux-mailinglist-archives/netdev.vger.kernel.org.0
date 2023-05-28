Return-Path: <netdev+bounces-5946-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84BA67138BB
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 10:34:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A6A01C208C8
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 08:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F073364;
	Sun, 28 May 2023 08:34:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24373360
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 08:34:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F29CBE
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 01:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685262847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kwxNaHisEq+hSYVrnROXXvszOL5x+627ymiwxF2+pCM=;
	b=QLUkMAGrBhf52VLpeLsrRdCDBZubtOux35b8i6Q5ayNFRcTyZCXv3zvNPC6hBnLA02shA0
	Xa0jaVG5GLhXEdW4pY/hkZVYhDqtsTkfOeng/th5A1OP7nbNdWA49NA+r7BO1e1B/F2Jqp
	/4YxbvjqFqEVGDWuh4vmoQu1WLMO1eo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-6Ul53yeCPrWlx62V8qraXA-1; Sun, 28 May 2023 04:34:01 -0400
X-MC-Unique: 6Ul53yeCPrWlx62V8qraXA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2BC9101A52C;
	Sun, 28 May 2023 08:34:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.39.192.68])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D3DE740CFD45;
	Sun, 28 May 2023 08:33:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <ZHH1nqZWOGzxlidT@corigine.com>
References: <ZHH1nqZWOGzxlidT@corigine.com> <20230526143104.882842-1-dhowells@redhat.com> <20230526143104.882842-2-dhowells@redhat.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    Herbert Xu <herbert@gondor.apana.org.au>,
    "David
 S. Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
    Paolo Abeni <pabeni@redhat.com>,
    Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
    David Ahern <dsahern@kernel.org>,
    Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    linux-crypto@vger.kernel.org, linux-mm@kvack.org,
    linux-kernel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
    Steve French <sfrench@samba.org>,
    Shyam Prasad N <nspmangalore@gmail.com>,
    Rohith Surabattula <rohiths.msft@gmail.com>,
    linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
    linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH net-next 1/8] Move netfs_extract_iter_to_sg() to lib/scatterlist.c
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <992933.1685262837.1@warthog.procyon.org.uk>
Date: Sun, 28 May 2023 09:33:57 +0100
Message-ID: <992934.1685262837@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If it comes to a respin, I'll stick in an extra patch to fix the spellings -
and if not, I'll submit the patch separately.  It shouldn't be changed in with
the movement of code to give git analysis a better chance of tracking the
movement.

David


