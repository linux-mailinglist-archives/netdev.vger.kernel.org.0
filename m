Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23CC664CAA
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 20:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbjAJTj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 14:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232043AbjAJTjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 14:39:20 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B8759D08;
        Tue, 10 Jan 2023 11:39:19 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id c85so6392108pfc.8;
        Tue, 10 Jan 2023 11:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ytahM6TFxHypZxetqkfCVkmffXauXXQEJdKgL56HxD8=;
        b=cLQVTlSTOs39qtQ0dnDnsMGOF2nWqvYy0tBAWrDodUfcO2hYGHXR6Rls1NWfsiWiaJ
         xWBx2Pen6pk7Eyi1dmP1oPexDEe3bC5TvwmE60+XlzJp1FZBgTRmkxtfWI0vVBNS9bZr
         5czwEFxIzO2N96iCcd65u7Nakz+jyX3vBVAXZSFX0zh3Q+c3dk55R8YZJm7QDwp3gv98
         HFzvbWpC2xC2+is963zwUaHaxcVIKB6gze0MT8Xzs0QVcLRPTUdI/Buvukyr25nsZZ71
         qnnwnH8D6xb6rp4eyI/0uUaqi3YEh6QHXrq1DjOmyEBD8JyHcApnVXWaDXl0+lT9LjBU
         1AQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ytahM6TFxHypZxetqkfCVkmffXauXXQEJdKgL56HxD8=;
        b=Fv5Yu2FOO0/7QhhAYmJIxAi9RkTfX4fH5hst8tXOABjVX025Jd6tesaBmYwkr+MRa1
         6ujNiSRUwsRsaGRd6NGcorW82e15LSWk4PyLxcFrnQxpwLB5Uas7PwOAMcK6uxWACw8F
         5Y1bBhCxDPR5WzUk05vRWhX5AYX8ggv8RZ342CXaKWxhDNsXZuc3bJ5iZBNl8SLzrTHB
         3kQZPwOpI+td6xhf8GHG/m+GfFpmryZC5RaWQKH5wEHT8g3VGMKFp37qSJ5VskpiC4QV
         9QMZdTnOgF0dJcSIaxfKtJXHR+icnWl34+JLw1k8dDg1vo0NrXjSi1hyIozOafuofETP
         Zhng==
X-Gm-Message-State: AFqh2koa3qpJDFluu2gLfjwIH//rf60L03NsQ99jSAKmbA/e61qGBtYs
        /E9rN9/C9usXbxMrSHyDcJg=
X-Google-Smtp-Source: AMrXdXt1oOoeLlqdvX3/g8ylTfFh+uA1SzU8WaZTxdBuoR5ZfNp6simBasPTzyxGkApbzqHk9W3CpQ==
X-Received: by 2002:aa7:9683:0:b0:581:a8dc:8f94 with SMTP id f3-20020aa79683000000b00581a8dc8f94mr46012963pfk.27.1673379559143;
        Tue, 10 Jan 2023 11:39:19 -0800 (PST)
Received: from [192.168.0.128] ([98.97.37.136])
        by smtp.googlemail.com with ESMTPSA id u5-20020a626005000000b005815017d348sm1757469pfb.179.2023.01.10.11.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 11:39:18 -0800 (PST)
Message-ID: <ece5f6a7fad9eb55d0fbf97c6227571e887c2c33.camel@gmail.com>
Subject: Re: [PATCH] rndis_wlan: Prevent buffer overflow in rndis_query_oid
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>, kvalo@kernel.org,
        jussi.kivilinna@iki.fi, davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Jan 2023 11:39:17 -0800
In-Reply-To: <20230110173007.57110-1-szymon.heidrich@gmail.com>
References: <20230110173007.57110-1-szymon.heidrich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-01-10 at 18:30 +0100, Szymon Heidrich wrote:
> Since resplen and respoffs are signed integers sufficiently
> large values of unsigned int len and offset members of RNDIS
> response will result in negative values of prior variables.
> This may be utilized to bypass implemented security checks
> to either extract memory contents by manipulating offset or
> overflow the data buffer via memcpy by manipulating both
> offset and len.
>=20
> Additionally assure that sum of resplen and respoffs does not
> overflow so buffer boundaries are kept.
>=20
> Fixes: 80f8c5b434f9 ("rndis_wlan: copy only useful data from rndis_comman=
d respond")
> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
> ---
>  drivers/net/wireless/rndis_wlan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rnd=
is_wlan.c
> index 82a7458e0..d7fc05328 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -697,7 +697,7 @@ static int rndis_query_oid(struct usbnet *dev, u32 oi=
d, void *data, int *len)
>  		struct rndis_query_c	*get_c;
>  	} u;
>  	int ret, buflen;
> -	int resplen, respoffs, copylen;
> +	u32 resplen, respoffs, copylen;

Rather than a u32 why not just make it an size_t? The advantage is that
is the native type for all the memory allocation and copying that takes
place in the function so it would avoid having to cast between u32 and
size_t.

Also why not move buflen over to the unsigned integer category with the
other values you stated were at risk of overflow?

> =20
>  	buflen =3D *len + sizeof(*u.get);
>  	if (buflen < CONTROL_BUFFER_SIZE)

For example, this line here is comparing buflen to a fixed constant. If
we are concerned about overflows this could be triggering an integer
overflow resulting in truncation assuming *len is close to the roll-
over threshold.

By converting to a size_t we would most likely end up blowing up on the
kmalloc and instead returning an -ENOMEM.

> @@ -740,7 +740,7 @@ static int rndis_query_oid(struct usbnet *dev, u32 oi=
d, void *data, int *len)

Also with any type change such as this I believe you would also need to
update the netdev_dbg statement that displays respoffs and the like to
account for the fact that you are now using an unsigned value.
Otherwise I believe %d will display the value as a signed integer
value.

>  			goto exit_unlock;
>  		}
> =20
> -		if ((resplen + respoffs) > buflen) {
> +		if (resplen > (buflen - respoffs)) {
>  			/* Device would have returned more data if buffer would
>  			 * have been big enough. Copy just the bits that we got.
>  			 */

Actually you should be able to simplfy this further. Assuming resplen,
buflen and respoffs all the same type this entire if statement could be
broken down into:
		copylen =3D min(resplen, buflen - respoffs);


