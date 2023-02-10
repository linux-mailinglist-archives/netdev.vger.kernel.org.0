Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F786915D5
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 01:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjBJAoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 19:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjBJAoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 19:44:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8B736FFE;
        Thu,  9 Feb 2023 16:44:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AC4E61C18;
        Fri, 10 Feb 2023 00:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1B0C433EF;
        Fri, 10 Feb 2023 00:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675989839;
        bh=OgRaYJQZzWCY1SgdJk5Sgzocozw80CN9P2C2cbIWu9w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KSfs5+RrLDask/PWdjry22G1xf9G0melT7uJJsciiCxEi2ryRaUby+aMyiYRcEYuh
         9oBAQ5DnkKGpl6Xl2nwM8sgE3r8cQyyne+ysIJ8GU3T3UBwDD44rIRWbaGgl5ALCLd
         CTQUUD6aZ2kPcu89hVDsHW7qKQ0bM1X/WZ8vaLuyNC0krApnGCSebQKWmlMh/miax9
         ubY3QkehFnms13TYrf1Zd4alYFAk6+VaiWtTbk7slMn4tCz/L/LD7kWSg0bAKnm2Ah
         w0Mwt9hX5FMlExTlQDigYVPPjpL1KGzeyZQ5rG5w84KAqKX6MlZk7iIdyJWcWZxEVv
         nUfp5qj4K858A==
Date:   Fri, 10 Feb 2023 02:43:55 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tyler Hicks <code@tyhicks.com>, ecryptfs@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Subject: Re: [PATCH 2/17] net: macsec: Add scaffolding to change completion
 function signature
Message-ID: <Y+WTS5w9nbsoyZyr@kernel.org>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <E1pOydb-007zgc-0p@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pOydb-007zgc-0p@formenos.hmeau.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:22:15PM +0800, Herbert Xu wrote:
> This patch adds temporary scaffolding so that the Crypto API

nit: "Add ..."

> completion function can take a void * instead of crypto_async_request.
> Once affected users have been converted this can be removed.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  drivers/net/macsec.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index bf8ac7a3ded7..b7d9d487ccd2 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -528,9 +528,9 @@ static void count_tx(struct net_device *dev, int ret, int len)
>  	}
>  }
>  
> -static void macsec_encrypt_done(struct crypto_async_request *base, int err)
> +static void macsec_encrypt_done(crypto_completion_data_t *data, int err)
>  {
> -	struct sk_buff *skb = base->data;
> +	struct sk_buff *skb = crypto_get_completion_data(data);
>  	struct net_device *dev = skb->dev;
>  	struct macsec_dev *macsec = macsec_priv(dev);
>  	struct macsec_tx_sa *sa = macsec_skb_cb(skb)->tx_sa;
> @@ -835,9 +835,9 @@ static void count_rx(struct net_device *dev, int len)
>  	u64_stats_update_end(&stats->syncp);
>  }
>  
> -static void macsec_decrypt_done(struct crypto_async_request *base, int err)
> +static void macsec_decrypt_done(crypto_completion_data_t *data, int err)
>  {
> -	struct sk_buff *skb = base->data;
> +	struct sk_buff *skb = crypto_get_completion_data(data);
>  	struct net_device *dev = skb->dev;
>  	struct macsec_dev *macsec = macsec_priv(dev);
>  	struct macsec_rx_sa *rx_sa = macsec_skb_cb(skb)->rx_sa;

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
