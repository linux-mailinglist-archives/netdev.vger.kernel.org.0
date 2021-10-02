Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF8941FA41
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 09:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhJBHXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 03:23:55 -0400
Received: from smtprelay0120.hostedemail.com ([216.40.44.120]:44244 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232457AbhJBHXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 03:23:54 -0400
Received: from omf09.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 55C80181AC9CB;
        Sat,  2 Oct 2021 07:22:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf09.hostedemail.com (Postfix) with ESMTPA id F057D1E04D5;
        Sat,  2 Oct 2021 07:22:05 +0000 (UTC)
Message-ID: <8d21e758966ca5581edd4babe0773a28e9938a78.camel@perches.com>
Subject: Re: [PATCH] net:dev: Change napi_gro_complete return type to void
From:   Joe Perches <joe@perches.com>
To:     Gyumin Hwang <hkm73560@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Date:   Sat, 02 Oct 2021 00:22:04 -0700
In-Reply-To: <20211002061102.1878-1-hkm73560@gmail.com>
References: <20211002061102.1878-1-hkm73560@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.37
X-Stat-Signature: fxrkypnqobwgax3kfh16izpd38zewms1
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: F057D1E04D5
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19Vjc8TV9EcImDG6C8pKm2b77RM+g9bq2k=
X-HE-Tag: 1633159325-371635
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-10-02 at 06:11 +0000, Gyumin Hwang wrote:
> napi_gro_complete always returned the same value, NET_RX_SUCCESS
> And the value was not used anywhere
[]
> diff --git a/net/core/dev.c b/net/core/dev.c
[]
> @@ -5868,12 +5868,12 @@ static int napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
>  	if (err) {
>  		WARN_ON(&ptype->list == head);
>  		kfree_skb(skb);
> -		return NET_RX_SUCCESS;
> +		return;
>  	}
>  
> 
>  out:
>  	gro_normal_one(napi, skb, NAPI_GRO_CB(skb)->count);
> -	return NET_RX_SUCCESS;
> +	return;

unnecessary return at function end

>  }



