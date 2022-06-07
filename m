Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38827542040
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384666AbiFHAUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449430AbiFGXJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:09:48 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD2D1F5C5B;
        Tue,  7 Jun 2022 13:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1654634754;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=5EXmhbBINWAX1iJ92pS7nRFv8qfOOWqr79b/Dpdp51E=;
    b=RqreEK8DAmvUJvJ+ZocucZMHU5ApuzIv6BBlLrDYNCq2tol28Ufq+0FCXsxOi8hROq
    u2P9DJcs5VvkzDl484gXs708gmuPH9TOKrNAktktNEGSe4YMoBeFUetV3Uwh6cSpbkgS
    W6qOxhaiGU59jA7TaPCbzHolCR9YwrCjWR0CAo2SLEQjkk2FCvXD4+YC/SnvfafiR9NJ
    IBgxLOnC+giORLI2KzB9xqpyJCEhk52LUuMnfJKYI5lb9zkwv1uhpBaAv3isxjBmCBvl
    Bu7q171l+S59nA6AhvsoKSazrV1dsPrMD0R11wGZAKNDsilF/oFl282SDgevJogt3dBC
    sZxQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1q3DbdV+Ofo7wY7W6Qxgy"
X-RZG-CLASS-ID: mo00
Received: from [172.20.10.8]
    by smtp.strato.de (RZmta 47.45.0 DYNA|AUTH)
    with ESMTPSA id R0691fy57Kjq8cw
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 7 Jun 2022 22:45:52 +0200 (CEST)
Subject: Re: [RFC PATCH 05/13] can: slcan: simplify the device de-allocation
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-6-dario.binacchi@amarulasolutions.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <f03bf100-c53e-75e4-55f6-47db7c5a37c2@hartkopp.net>
Date:   Tue, 7 Jun 2022 22:45:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220607094752.1029295-6-dario.binacchi@amarulasolutions.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.06.22 11:47, Dario Binacchi wrote:
> Since slcan_devs array contains the addresses of the created devices, I
> think it is more natural to use its address to remove it from the list.
> It is not necessary to store the index of the array that points to the
> device in the driver's private data.

IMO this patch should not be part of the slcan enhancement series.

I can see the "miss-use" of dev->base_addr but when we change this code 
we should also take care of a similar handling in drivers/net/slip/slip.c

Therefore a change like this should be done in slcan.c and slip.c 
simultaneously with a single patch.

Best regards,
Oliver

> 
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> ---
> 
>   drivers/net/can/slcan.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index 956b47bd40a7..4df0455e11a2 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -428,11 +428,17 @@ static int slc_open(struct net_device *dev)
>   
>   static void slc_dealloc(struct slcan *sl)
>   {
> -	int i = sl->dev->base_addr;
> +	unsigned int i;
>   
> -	free_candev(sl->dev);
> -	if (slcan_devs)
> -		slcan_devs[i] = NULL;
> +	for (i = 0; i < maxdev; i++) {
> +		if (sl->dev == slcan_devs[i]) {
> +			free_candev(sl->dev);
> +			slcan_devs[i] = NULL;
> +			return;
> +		}
> +	}
> +
> +	pr_err("slcan: can't free %s resources\n",  sl->dev->name);
>   }
>   
>   static int slcan_change_mtu(struct net_device *dev, int new_mtu)
> @@ -529,7 +535,6 @@ static struct slcan *slc_alloc(void)
>   
>   	snprintf(dev->name, sizeof(dev->name), "slcan%d", i);
>   	dev->netdev_ops = &slc_netdev_ops;
> -	dev->base_addr  = i;
>   	sl = netdev_priv(dev);
>   
>   	/* Initialize channel control data */
> 
