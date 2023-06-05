Return-Path: <netdev+bounces-7915-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24BCB72211B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:35:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D07D0281017
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC492107;
	Mon,  5 Jun 2023 08:35:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD8C196
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781E8C433D2;
	Mon,  5 Jun 2023 08:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685954100;
	bh=KNrV//Bo+zqQ1/Kkalh+mrM4XTLA5+jJqev5pBZLUd8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LoE0sjosGTqW9cpUYTFrXSXU2Y//b81Q7w+fBEBUjWPqJk/yYpf0Ac5Near0cSmXh
	 2fuXyvsOuo7+H8eAah/2wRHtUQMQDaMQCYpyMscDBLzbcJ19Xmaun0JVWmyaXF8Suf
	 CBYRxaTVfd9xfUThlwZqxbLyyWmLOk/H7csIXpVif88N528TLuMfMVTVX1Z2TDzaRw
	 ODQXvbOgJU5SahnJncSIN14bI9bvMIbMVg4zrIfoLdPXCbae9B2QWeWoTGzCelT6XH
	 4BpAOkeCJ1UEH7HMANMAl2FEe3rtno47z/vj6Wc21qOlI+dnQwHc/lzwhRlysMngfL
	 tDhD+He3ikgkw==
Date: Mon, 5 Jun 2023 11:34:56 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH ipsec-next] xfrm: delete not-needed clear to zero of
 encap_oa
Message-ID: <20230605083456.GA22489@unreal>
References: <1ed3e00428a0036bdea14eb4f5a45706a89f11eb.1685952635.git.leon@kernel.org>
 <ZH2dNy+PrhPuNsy9@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH2dNy+PrhPuNsy9@gondor.apana.org.au>

On Mon, Jun 05, 2023 at 04:30:47PM +0800, Herbert Xu wrote:
> On Mon, Jun 05, 2023 at 11:11:51AM +0300, Leon Romanovsky wrote:
> >
> > diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
> > index c34a2a06ca94..ec713db148f3 100644
> > --- a/net/xfrm/xfrm_user.c
> > +++ b/net/xfrm/xfrm_user.c
> > @@ -1077,7 +1077,6 @@ static int copy_to_user_encap(struct xfrm_encap_tmpl *ep, struct sk_buff *skb)
> >  	uep->encap_type = ep->encap_type;
> >  	uep->encap_sport = ep->encap_sport;
> >  	uep->encap_dport = ep->encap_dport;
> > -	uep->encap_oa = ep->encap_oa;
> 
> Where is the justification for this?

The line "memset(&natt->encap_oa, 0, sizeof(natt->encap_oa));" deleted
in this patch was the last reference to encap_oa.

Thanks

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

