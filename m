Return-Path: <netdev+bounces-8424-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13627723FF5
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:45:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C580D2812C9
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2403A12B9F;
	Tue,  6 Jun 2023 10:45:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19676468F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:45:33 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DC61994
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:45:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 483DE207B9;
	Tue,  6 Jun 2023 12:45:30 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7n3uHJggFaOq; Tue,  6 Jun 2023 12:45:29 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id CFB64207A4;
	Tue,  6 Jun 2023 12:45:29 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id CA6BC80004E;
	Tue,  6 Jun 2023 12:45:29 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 12:45:29 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 6 Jun
 2023 12:45:29 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id 398183182D2E; Tue,  6 Jun 2023 12:45:29 +0200 (CEST)
Date: Tue, 6 Jun 2023 12:45:29 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <netdev@vger.kernel.org>, David George <David.George@sophos.com>, "Markus
 Trapp" <markus.trapp@secunet.com>
Subject: Re: [PATCH] xfrm: Remove inner/outer modes from input path
Message-ID: <ZH8OSd1ElPIKCFa+@gauss3.secunet.de>
References: <ZAr3rc+QvKs50xkm@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZAr3rc+QvKs50xkm@gondor.apana.org.au>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Herbert,

On Fri, Mar 10, 2023 at 05:26:05PM +0800, Herbert Xu wrote:
...
> @@ -369,17 +366,12 @@ static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
>  		return -EAFNOSUPPORT;
>  	}
>  
> -	if (x->sel.family == AF_UNSPEC) {
> -		inner_mode = xfrm_ip2inner_mode(x, XFRM_MODE_SKB_CB(skb)->protocol);
> -		if (!inner_mode)
> -			return -EAFNOSUPPORT;
> -	}
> -
> -	switch (inner_mode->family) {
> -	case AF_INET:
> +	switch (XFRM_MODE_SKB_CB(skb)->protocol) {
> +	case IPPROTO_IPIP:
> +	case IPPROTO_BEETPH:

the assumption that the L4 protocol on BEET mode can be
just IPIP or BEETPH seems not to be correct. One of
our testcaces hit the second WARN_ON_ONCE() in
xfrm_prepare_input. In that case the L4 protocol
is UDP. Looks like we need some other way to
dertermine the inner protocol family.


