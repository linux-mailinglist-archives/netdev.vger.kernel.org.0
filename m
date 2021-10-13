Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E38542B4D8
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 07:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbhJMFXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 01:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237600AbhJMFXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 01:23:40 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9440C061570;
        Tue, 12 Oct 2021 22:21:36 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id r18so4865856edv.12;
        Tue, 12 Oct 2021 22:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O0bpNeV5H2tlTKXse90QMUfiIV8csT1Ar0RjDFkM7MQ=;
        b=bHtADcOHkeHQOEJQ1DFKGZXoEe2uR67R4MGx+Xt53CiQdjgqW6piJV4beISkN7L9bf
         5X4DrXk4/GfkKHDaVWmulp8diX6xqXZeVbqpttUR389XmHXP9cppPbcuO8r/w8fOQDnU
         OpBQyyPVtVK0wwq+ZX4iwXZMA2p3FmvqOkJr/2CEIK5zD93vWMmwqrfICD8+Bq+mjNNr
         HScRHcVpXt/0T4+m9fUVvPGtWS+OMJsHDUre/ddB2wxJQxxrvDKptbqx1Cs+E3glqi37
         U1NIt9vR6pvQskNa6AFdBi7qJvWW4u5WCckhycVb1Lw+HkuPYny/rxZmpB9nW5Qu5W0s
         +xdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O0bpNeV5H2tlTKXse90QMUfiIV8csT1Ar0RjDFkM7MQ=;
        b=NXAym8+EnADfxHGlJhsASyESAlSAhT7D9MtSyK5BThHjdu0jst13rKtLfQr+g166V5
         vNXhp6O1V/U1G6DMkztm53b1fs2wxTVQUFwg4bIqbWPnwuZzaRebStXWNFXoaeJ73CS/
         sR02G62NZFeH7xbMMZnC1InpmJ/Eb1A1Nu0xVk3wHOw0aCJEC9qsskF0W87ZB/F9uDLU
         a1iDlHyGgizrR2oudRRNWOZoo8iYGfx9v8xDchvRRhfFBc2QYmX8Q2qU+pzAGyM9Ioy8
         +UX2h1TNbdCFfWkN9oME1EeEuX4c4eCZPBTELZpRCftCAvig8HrGR45DBDwtsZM25xDe
         s5CQ==
X-Gm-Message-State: AOAM530Dt6ZUrtaSwNJnVPCGTCtK8PKRedfOEB+fXvsC2gsxQxlsKEq5
        zXo++wxRn2+RIyp/YDgNSElVvf8qHWvQlWMYrjZx7FzVDKHXAtfwJvI=
X-Google-Smtp-Source: ABdhPJycgoRsBj6dI+FOHWjkdXIyhPmcwUwXpL4QMgQODvoGZJExgG7CIgbT9UWGiYlQufM4N3L8Eec0wMeqHjsqjQI=
X-Received: by 2002:a17:906:f6cd:: with SMTP id jo13mr37508004ejb.563.1634102495447;
 Tue, 12 Oct 2021 22:21:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211013040349.2858773-1-mudongliangabcd@gmail.com>
In-Reply-To: <20211013040349.2858773-1-mudongliangabcd@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 13 Oct 2021 13:21:09 +0800
Message-ID: <CAD-N9QWTP8DLtAN70Xxap+WhNUfh9ixfeDMuNaB2NnpFhuAN8A@mail.gmail.com>
Subject: Re: [PATCH] driver: net: can: delete napi if register_candev fails
To:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc:     linux-can@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 12:04 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> If register_candev fails, xcan_probe does not clean the napi
> created by netif_napi_add.
>

It seems the netif_napi_del operation is done in the free_candev
(free_netdev precisely).

list_for_each_entry_safe(p, n, &dev->napi_list, dev_list)
          netif_napi_del(p);

And list_add_rcu(&napi->dev_list, &dev->napi_list) is done in the
netif_napi_add.

Therefore, I suggest removing "netif_napi_del" operation in the
xcan_remove to match probe and remove function.

> Fix this by adding error handling code to clean napi when
> register_candev fails.
>
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/can/xilinx_can.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
> index 3b883e607d8b..6ee0b5a8cdfc 100644
> --- a/drivers/net/can/xilinx_can.c
> +++ b/drivers/net/can/xilinx_can.c
> @@ -1807,7 +1807,7 @@ static int xcan_probe(struct platform_device *pdev)
>         ret = register_candev(ndev);
>         if (ret) {
>                 dev_err(&pdev->dev, "fail to register failed (err=%d)\n", ret);
> -               goto err_disableclks;
> +               goto err_del_napi;
>         }
>
>         devm_can_led_init(ndev);
> @@ -1825,6 +1825,8 @@ static int xcan_probe(struct platform_device *pdev)
>
>         return 0;
>
> +err_del_napi:
> +       netif_napi_del(&priv->napi);
>  err_disableclks:
>         pm_runtime_put(priv->dev);
>         pm_runtime_disable(&pdev->dev);
> --
> 2.25.1
>
