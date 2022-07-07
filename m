Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B643C56A10E
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbiGGLd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiGGLd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:33:28 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68644DC2
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 04:33:27 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-31cb2c649f7so92392647b3.11
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 04:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ctNgL+QgBYKL2YB5e/3sk9WZdLgG3HMH4jYAFqa6ogg=;
        b=H9SLhiJunqZ46fGYPI8GVSIIurx+fts3UCCOzDqeN1Dez+ctwVUmiL/1tRSetWNz8C
         V+1wuZFxTAIVjyiJu4o2+Rb/hjIRlfOiznkjwI8VKjoa/TMEZkpF+UtdtmhTetQ/n1eB
         PNcHQVPJVZ47nTnR/jY+bZRdg+RRr3/mCQcSu3SkZx9NpUMNc31oIouzr7st48NTm19z
         nrjpVFUqoJItFVpsOOChEzBXU2rokBoy/l92OujWh1vgULVVon/fvB2vLMVIlmR84NnQ
         Id/XROcdIjV45F7XXWFzFZnxzcd3qjMBsppTjXgv7TXmGswMge4eT9rKok5pIIX3bK1C
         gSTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ctNgL+QgBYKL2YB5e/3sk9WZdLgG3HMH4jYAFqa6ogg=;
        b=TEEllkXXjOGUOBY/z4cdgvaix7sk/bwrHOYIkAU0lnozDDptGlMWXFQEZlY8US1CNg
         v4EZ/6VeoHoZhmJWD/KA1VCuUDkLIyk2V2WuTe1B2DtrT2ycEwzZcJGdJS3DdvFSwQFy
         0c1lj2AdPukD4KMCe9ZFLW+VYFlfz4uLnlvjhUUFVlKRk8Waf864uFdwSfXY3h77Qztx
         UTZiAAFxe7X5vg41j1RpQ4OOytAfQn6GsmUqgId0Xqxr7bKBcvioW7kPRKfUVpFib6fI
         quHslO8ldoZCnNVnzwj1sJpnWzir2roIy/QVKhh/sYQaQYiXoVy/Bd9DkGjJWpoXHGOC
         gVnQ==
X-Gm-Message-State: AJIora+cQMWhY6kXri2kHs+JsX+maMdejFsMCGUvZdjKe4MGUtVw99x7
        kmPu8ORJuOhJyoKlrHIsh+5JKxUcjqPJuTT9uk0=
X-Google-Smtp-Source: AGRyM1u78yMtZ8i8RsQnFddtDTECN9e3WbwsAJK2UgO9zKKe4EyQ3+DIyfuIPoHpqkv31PS7DOjdvBcytIbI0giALcA=
X-Received: by 2002:a81:6a42:0:b0:31c:d418:790 with SMTP id
 f63-20020a816a42000000b0031cd4180790mr14063243ywc.26.1657193606587; Thu, 07
 Jul 2022 04:33:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220707030020.1382722-1-kuba@kernel.org> <20220707030020.1382722-2-kuba@kernel.org>
In-Reply-To: <20220707030020.1382722-2-kuba@kernel.org>
From:   =?UTF-8?B?5ZGC6Iqz6aiw?= <wellslutw@gmail.com>
Date:   Thu, 7 Jul 2022 19:33:22 +0800
Message-ID: <CAFnkrsk+RkHxV17FrP=F5Tag5bLv6Ahq1JWQTmuDQWoxT0ckgQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] eth: sp7021: switch to netif_napi_add_tx()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> The Tx NAPI should use netif_napi_add_tx().
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: wellslutw@gmail.com
> ---
>  drivers/net/ethernet/sunplus/spl2sw_driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
> index 3773ce5e12cc..546206640492 100644
> --- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
> +++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
> @@ -494,7 +494,7 @@ static int spl2sw_probe(struct platform_device *pdev)
>         /* Add and enable napi. */
>         netif_napi_add(ndev, &comm->rx_napi, spl2sw_rx_poll, NAPI_POLL_WEIGHT);
>         napi_enable(&comm->rx_napi);
> -       netif_napi_add(ndev, &comm->tx_napi, spl2sw_tx_poll, NAPI_POLL_WEIGHT);
> +       netif_napi_add_tx(ndev, &comm->tx_napi, spl2sw_tx_poll);
>         napi_enable(&comm->tx_napi);
>         return 0;
>
> --
> 2.36.1
>
Thanks for fixing the bug.

I applied the patch and did some tests.
I did not find any problem with patch.

Acked-by: Wells Lu <wellslutw@gmail.com>
