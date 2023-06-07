Return-Path: <netdev+bounces-8754-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58F83725875
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:48:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B86AE1C20D18
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630728BE7;
	Wed,  7 Jun 2023 08:48:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595AD882D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:48:56 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6E318F;
	Wed,  7 Jun 2023 01:48:53 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1q6oq8-0007Kf-9L; Wed, 07 Jun 2023 16:48:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 Jun 2023 16:48:24 +0800
Date: Wed, 7 Jun 2023 16:48:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-crypto@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 10/10] crypto: af_alg/hash: Support
 MSG_SPLICE_PAGES
Message-ID: <ZIBEWBPDdkCtx8XM@gondor.apana.org.au>
References: <20230606130856.1970660-1-dhowells@redhat.com>
 <20230606130856.1970660-11-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606130856.1970660-11-dhowells@redhat.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 02:08:56PM +0100, David Howells wrote:
> Make AF_ALG sendmsg() support MSG_SPLICE_PAGES in the hashing code.  This
> causes pages to be spliced from the source iterator if possible.
> 
> This allows ->sendpage() to be replaced by something that can handle
> multiple multipage folios in a single transaction.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: linux-crypto@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
> 
> Notes:
>     ver #2)
>      - Fixed some checkpatch warnings.
> 
>  crypto/af_alg.c     |  11 +++--
>  crypto/algif_hash.c | 100 +++++++++++++++++++++++++++-----------------
>  2 files changed, 70 insertions(+), 41 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

