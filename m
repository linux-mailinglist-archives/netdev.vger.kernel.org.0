Return-Path: <netdev+bounces-8976-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C94072673D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:26:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACC072813CE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED9E337355;
	Wed,  7 Jun 2023 17:26:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40E61641B
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05812C433D2;
	Wed,  7 Jun 2023 17:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686158761;
	bh=0MBhuEUX2bktmVFKRPGnv8oU9W5tm0XrwIeAW9OBqu4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NYJztc6K5jZaEpT5qmYChibBOYzwSAkpmz4luHH2EERw0PJbUy4NdUK7sOHmMohEv
	 L4Y7jZiccYhyhFR5ioEP01GXWEyxpDJ73Gab/BxVRJhCWxnFAvzE29QxtsB3IuT1xn
	 qTcuRgtm/jMMrfC+i53EtgpTUIBBrnLMh+sI0NfGT4IFKTnbOOgHyY6BB+ny035F9E
	 av80Tcccr/PaZaKHCB3HTiybgCAWkD4ePOn5L4H0tXwCaTFgXNFkqzK4UldjZtsxwy
	 rbwwSEegzCShGku9llVhj8mpPI6xq3GpFvw8RP/8sQpd1zt7NT2VqVpvzleaooJKow
	 euaKcvwu3sxTw==
Date: Wed, 7 Jun 2023 10:26:00 -0700
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
Subject: Re: [PATCH net-next v5 14/14] tls/device: Convert
 tls_device_sendpage() to use MSG_SPLICE_PAGES
Message-ID: <20230607102600.07d16cf0@kernel.org>
In-Reply-To: <20230607140559.2263470-15-dhowells@redhat.com>
References: <20230607140559.2263470-1-dhowells@redhat.com>
	<20230607140559.2263470-15-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Jun 2023 15:05:59 +0100 David Howells wrote:
> Convert tls_device_sendpage() to use sendmsg() with MSG_SPLICE_PAGES rather
> than directly splicing in the pages itself.  With that, the tls_iter_offset
> union is no longer necessary and can be replaced with an iov_iter pointer
> and the zc_page argument to tls_push_data() can also be removed.
> 
> This allows ->sendpage() to be replaced by something that can handle
> multiple multipage folios in a single transaction.

Acked-by: Jakub Kicinski <kuba@kernel.org>

