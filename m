Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC79922E919
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgG0JgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:36:21 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:43200 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgG0JgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 05:36:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 45F9A20536;
        Mon, 27 Jul 2020 11:36:19 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id juo5DPe4FfMI; Mon, 27 Jul 2020 11:36:18 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D25CA201E4;
        Mon, 27 Jul 2020 11:36:18 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 27 Jul 2020 11:36:18 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 27 Jul
 2020 11:36:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id F1C693184651;
 Mon, 27 Jul 2020 11:36:17 +0200 (CEST)
Date:   Mon, 27 Jul 2020 11:36:17 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     B K Karthik <bkkarthik@pesu.pes.edu>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: xfrm: xfrm_policy.c: remove some unnecessary cases
 in decode_session6
Message-ID: <20200727093617.GZ20687@gauss3.secunet.de>
References: <20200725134949.z53thk4jubabiubd@pesu.pes.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200725134949.z53thk4jubabiubd@pesu.pes.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 07:19:49PM +0530, B K Karthik wrote:
> remove some unnecessary cases in decode_session6
> 
> Signed-off-by: B K Karthik <bkkarthik@pesu.pes.edu>
> ---
>  net/xfrm/xfrm_policy.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index 19c5e0fa3f44..e1c988a89382 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -3449,10 +3449,6 @@ decode_session6(struct sk_buff *skb, struct flowi *fl, bool reverse)
>  			fl6->flowi6_proto = nexthdr;
>  			return;
>  #endif
> -		/* XXX Why are there these headers? */
> -		case IPPROTO_AH:
> -		case IPPROTO_ESP:
> -		case IPPROTO_COMP:
>  		default:
>  			fl6->fl6_ipsec_spi = 0;
>  			fl6->flowi6_proto = nexthdr;

IPv4 implements spi parsing for these protocols, IPv6
does not do it. Before you just remove something, you
should think about which is the correct behaviour and
then do it for both, IPv4 and IPv6.
