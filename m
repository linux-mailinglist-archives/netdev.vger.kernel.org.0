Return-Path: <netdev+bounces-8964-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3CE672669B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D85B281234
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8DC9370CC;
	Wed,  7 Jun 2023 16:57:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B884E63B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83317C433A0;
	Wed,  7 Jun 2023 16:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686157063;
	bh=lmG/iO4yCH/y6BZzMgEzghnezPPBrnzSLbgdr+z6b0Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tNgxGoQ0gPVV6m9sXjcItYlUSPzWY69mHwmYp2o9RLQ/1mqxCliU+wlW2xMneoWzC
	 eUVJ+njWX0VKJLEdtS+raXSkIh/Lyz/cqrGHv4a0bJMrPI5LzBvWG3F6F/3DZADS8u
	 MLkx72637FQN/GCcz30xpzaz1TLR0Aq8hXzoYjSCw/mCRa7Y4vg/oRkXQ0Rql9F6L5
	 NrhQBSSd9ktD2Ijy2WawHszVdVHtwjqs65PKO46Aw0autkh7HPSPutb4ZljhyfDjGQ
	 bIloblYGEHqhDpUz98zVWqvlsl9xnVOBx+m+QYiDbBz9TY8R65a/6bIur/FL7xdlzm
	 kpMbNUvYAniQg==
Date: Wed, 7 Jun 2023 09:57:41 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
 Chuck Lever <chuck.lever@oracle.com>, Boris Pismenny <borisp@nvidia.com>,
 John Fastabend <john.fastabend@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 05/14] tls/sw: Use splice_eof() to flush
Message-ID: <20230607095741.223689c1@kernel.org>
In-Reply-To: <20230607140559.2263470-6-dhowells@redhat.com>
References: <20230607140559.2263470-1-dhowells@redhat.com>
	<20230607140559.2263470-6-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Jun 2023 15:05:50 +0100 David Howells wrote:
> Allow splice to end a TLS record after prematurely ending a splice/sendfile
> due to getting an EOF condition (->splice_read() returned 0) after splice
> had called TLS with a sendmsg() with MSG_MORE set when the user didn't set
> MSG_MORE.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Link: https://lore.kernel.org/r/CAHk-=wh=V579PDYvkpnTobCLGczbgxpMgGmmhqiTyE34Cpi5Gg@mail.gmail.com/
> Signed-off-by: David Howells <dhowells@redhat.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

