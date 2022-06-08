Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA2B5428E3
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 10:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiFHIGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 04:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbiFHIFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 04:05:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD0A1F1BF4
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 00:36:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 672F761503
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 07:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294CDC3411D;
        Wed,  8 Jun 2022 07:36:14 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="signature verification failed" (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ilSvVTcg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654673772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q4tqVlf1sRQigfRdRZ3K4aDGJHx76yXvCzVSiCHv7Ek=;
        b=ilSvVTcgnTjvl8oxT0teGAS2mnG8tW5ld1XQTivkkZEj0UEYFx7aF3Fs4KmU/GzTdqJ9L4
        VQxakjxZloOVtyTQQKfxPoyntrIDOfCXBNz5quRlawM0g4f4plGWimhtvoU+62UrTOXTmH
        vK+HzAlEFj2v83PnvA18heZk6Ni9juo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0115a1c7 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 8 Jun 2022 07:36:12 +0000 (UTC)
Date:   Wed, 8 Jun 2022 09:36:10 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 5/9] wireguard: use dev_sw_netstats_rx_add()
Message-ID: <YqBRan+zhcf9d4EU@zx2c4.com>
References: <20220607233614.1133902-1-eric.dumazet@gmail.com>
 <20220607233614.1133902-6-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220607233614.1133902-6-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Tue, Jun 07, 2022 at 04:36:10PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We have a convenient helper, let's use it.
> This will make the following patch easier to review and smaller.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>

The subject line should be:

    wireguard: receive: use dev_sw_netstats_rx_add()

Please don't commit it before changing that. With that addressed,

    Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

Regards,
Jason

>  drivers/net/wireguard/receive.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
> index 7b8df406c7737398f0270361afcb196af4b6a76e..7135d51d2d872edb66c856379ce2923b214289e9 100644
> --- a/drivers/net/wireguard/receive.c
> +++ b/drivers/net/wireguard/receive.c
> @@ -19,15 +19,8 @@
>  /* Must be called with bh disabled. */
>  static void update_rx_stats(struct wg_peer *peer, size_t len)
>  {
> -	struct pcpu_sw_netstats *tstats =
> -		get_cpu_ptr(peer->device->dev->tstats);
> -
> -	u64_stats_update_begin(&tstats->syncp);
> -	++tstats->rx_packets;
> -	tstats->rx_bytes += len;
> +	dev_sw_netstats_rx_add(peer->device->dev, len);
>  	peer->rx_bytes += len;
> -	u64_stats_update_end(&tstats->syncp);
> -	put_cpu_ptr(tstats);
>  }
>  
>  #define SKB_TYPE_LE32(skb) (((struct message_header *)(skb)->data)->type)
> -- 
> 2.36.1.255.ge46751e96f-goog
> 
