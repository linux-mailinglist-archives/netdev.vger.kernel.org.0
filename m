Return-Path: <netdev+bounces-8752-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F30E6725864
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:47:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A32292812EE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 075368BE2;
	Wed,  7 Jun 2023 08:47:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F119F6AB9
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:47:50 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82D01725
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:47:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 05A9E207E4;
	Wed,  7 Jun 2023 10:47:47 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z9rM6rTgXygx; Wed,  7 Jun 2023 10:47:46 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 086A2207D1;
	Wed,  7 Jun 2023 10:47:46 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id 0170780004A;
	Wed,  7 Jun 2023 10:47:46 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 10:47:45 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 7 Jun
 2023 10:47:45 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id 1F7FD31844F3; Wed,  7 Jun 2023 10:47:45 +0200 (CEST)
Date: Wed, 7 Jun 2023 10:47:45 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <netdev@vger.kernel.org>, David George <David.George@sophos.com>, "Markus
 Trapp" <markus.trapp@secunet.com>
Subject: Re: [PATCH] xfrm: Use xfrm_state selector for BEET input
Message-ID: <ZIBEMe8SXYMIuOqK@gauss3.secunet.de>
References: <ZAr3rc+QvKs50xkm@gondor.apana.org.au>
 <ZH8OSd1ElPIKCFa+@gauss3.secunet.de>
 <ZIBCFyszqwJlZd/V@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZIBCFyszqwJlZd/V@gondor.apana.org.au>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 04:38:47PM +0800, Herbert Xu wrote:
> On Tue, Jun 06, 2023 at 12:45:29PM +0200, Steffen Klassert wrote:
> >
> > the assumption that the L4 protocol on BEET mode can be
> > just IPIP or BEETPH seems not to be correct. One of
> > our testcaces hit the second WARN_ON_ONCE() in
> > xfrm_prepare_input. In that case the L4 protocol
> > is UDP. Looks like we need some other way to
> > dertermine the inner protocol family.
> 
> Oops, that was a thinko on my part:
> 
> ---8<---
> For BEET the inner address and therefore family is stored in the
> xfrm_state selector.  Use that when decapsulating an input packet
> instead of incorrectly relying on a non-existent tunnel protocol.
> 
> Fixes: 5f24f41e8ea6 ("xfrm: Remove inner/outer modes from input path")
> Reported-by: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> index 39fb91ff23d9..bdaed1d1ff97 100644
> --- a/net/xfrm/xfrm_input.c
> +++ b/net/xfrm/xfrm_input.c
> @@ -330,11 +330,10 @@ xfrm_inner_mode_encap_remove(struct xfrm_state *x,
>  {
>  	switch (x->props.mode) {
>  	case XFRM_MODE_BEET:
> -		switch (XFRM_MODE_SKB_CB(skb)->protocol) {
> -		case IPPROTO_IPIP:
> -		case IPPROTO_BEETPH:
> +		switch (x->sel.family) {

Hm, I thought about that one too. But x->sel.family can
also be AF_UNSPEC, in which case we used the address
family of the inner mode before your change.

> +		case AF_INET:
>  			return xfrm4_remove_beet_encap(x, skb);
> -		case IPPROTO_IPV6:
> +		case AF_INET6:
>  			return xfrm6_remove_beet_encap(x, skb);
>  		}
>  		break;
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

