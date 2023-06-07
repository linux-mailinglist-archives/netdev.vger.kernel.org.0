Return-Path: <netdev+bounces-8965-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BD3B7266A1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:58:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 051321C20E08
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:58:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4BAF370F8;
	Wed,  7 Jun 2023 16:58:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9C463B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DE5C433EF;
	Wed,  7 Jun 2023 16:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686157122;
	bh=exiwNMtro5HZ3RTiNqye9ih4jHEqnpnzeZJ2eAQPXh4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=H1vZGGGrAefzYt3YUbVr2VTjdG3ZuzagxJr9pFbQvwg3+wG+vM9fhrQwLYiySKC8J
	 bPEJw2Ig/z8qobZwKfHHz8w+67d/aPU84K9tm9SyyMkFvc8x0nwoOJm4OObzCoNUbm
	 UtBcvVtwj0LxVFadTBDx6BxNhN55TzSH5jUVM4esHYUPeBWW0q0VBn2OXJJQXdmUuW
	 ULNc2zCWHq81EKoBdF6k7DEovs8RvE+CuZd8JMVLjvjUvNCz+6lNvER+J8gELA60H7
	 Hs86QMzwg/6UWxAZguASPAHCUeqTtKXErsuqeXOI+l4X2ZD3Uy7SNsheG1fel1ZlL+
	 oV2Qp40oZMvDg==
Date: Wed, 7 Jun 2023 09:58:41 -0700
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
Subject: Re: [PATCH net-next v5 06/14] tls/device: Use splice_eof() to flush
Message-ID: <20230607095841.6e0edf7e@kernel.org>
In-Reply-To: <20230607140559.2263470-7-dhowells@redhat.com>
References: <20230607140559.2263470-1-dhowells@redhat.com>
	<20230607140559.2263470-7-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Jun 2023 15:05:51 +0100 David Howells wrote:
> Allow splice to end a TLS record after prematurely ending a splice/sendfile
> due to getting an EOF condition (->splice_read() returned 0) after splice
> had called TLS with a sendmsg() with MSG_MORE set when the user didn't set
> MSG_MORE.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

