Return-Path: <netdev+bounces-7631-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10141720E2B
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:38:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAB4A281B89
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 242AB8828;
	Sat,  3 Jun 2023 06:38:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD6FEA0
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C172C433EF;
	Sat,  3 Jun 2023 06:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685774328;
	bh=Ww3/vKUJQBHff7cB+X/RbuQRVkrsQ3I889K7iIKiGtc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=L15nmu+93564FFy5+uxruKubBk9dQaOHm/98Rgy8ruUPaZ+0OOOuxL+uXmbevFJGS
	 Lipb6mlFr+Zs4L0bgLsfYv8iBYDf9HK8ugxT1doVDzdaJHWJQt2g3Ub2oBwWuCIzpn
	 yEUw9JcaIbXRuwVPtFYlY2G/lXEI5GYgfleyY+ypQYKJoGrrn9sGm+0VgkeuCXiJfg
	 u8Ew+w4azeFMPb9OCU0Kbgj4rOSHya050OJt133/6+/tn3ZFKRZdsyohc/yHYMsE9W
	 8OjNnkGBnMFRxa9V3Tx+knQXAZ5v6mTPjKqIlaE8Tk50AGCh5OKvbDlDLffb+itTfP
	 o3+3vS6BlL5Kw==
Date: Fri, 2 Jun 2023 23:38:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
 Chuck Lever <chuck.lever@oracle.com>, Boris Pismenny <borisp@nvidia.com>,
 John Fastabend <john.fastabend@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH net-next v3 11/11] net: Add samples for network I/O and
 splicing
Message-ID: <20230602233847.06c01102@kernel.org>
In-Reply-To: <20230602150752.1306532-12-dhowells@redhat.com>
References: <20230602150752.1306532-1-dhowells@redhat.com>
	<20230602150752.1306532-12-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  2 Jun 2023 16:07:52 +0100 David Howells wrote:
> Examples include:
> 
> 	./splice-out -w0x400 /foo/16K 4K | ./alg-encrypt -s -
> 	./splice-out -w0x400 /foo/1M | ./unix-send -s - /tmp/foo
> 	./splice-out -w0x400 /foo/16K 16K -w1 | ./tls-send -s6 -n16K - servbox
> 	./tcp-send /bin/ls 192.168.6.1
> 	./udp-send -4 -p5555 /foo/4K localhost

Can it be made into a selftests? Move the code and wrap the above in a
bash script?

