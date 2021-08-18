Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A604F3EF897
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 05:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236744AbhHRDdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 23:33:02 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53318 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236585AbhHRDdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 23:33:01 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mGCJI-0005VM-Vt; Wed, 18 Aug 2021 11:32:13 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mGCJD-00054g-6O; Wed, 18 Aug 2021 11:32:07 +0800
Date:   Wed, 18 Aug 2021 11:32:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, dan.carpenter@oracle.com,
        syzbot+b9cfd1cc5d57ee0a09ab@syzkaller.appspotmail.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: xfrm: assign the per_cpu_ptr pointer before return
Message-ID: <20210818033207.GA19350@gondor.apana.org.au>
References: <20210818032554.283428-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818032554.283428-1-mudongliangabcd@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 11:25:53AM +0800, Dongliang Mu wrote:
>
> diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
> index cb40ff0ff28d..01dbec70dfba 100644
> --- a/net/xfrm/xfrm_ipcomp.c
> +++ b/net/xfrm/xfrm_ipcomp.c
> @@ -223,9 +223,9 @@ static void * __percpu *ipcomp_alloc_scratches(void)
>  		void *scratch;
>  
>  		scratch = vmalloc_node(IPCOMP_SCRATCH_SIZE, cpu_to_node(i));
> +		*per_cpu_ptr(scratches, i) = scratch;
>  		if (!scratch)
>  			return NULL;
> -		*per_cpu_ptr(scratches, i) = scratch;

scratches comes from alloc_percpu so it should already be zeroed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
