Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DE4547C09
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 22:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbiFLUpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 16:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbiFLUpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 16:45:34 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5363EBA0;
        Sun, 12 Jun 2022 13:45:33 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id x5so4844311edi.2;
        Sun, 12 Jun 2022 13:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Edd0Fo2D0WvSZIjYk40gz3y+yRWfqXBpq1Y7O0sOFY=;
        b=YxtfdEp9yyF9pGGKIxUY4D+xrFnRoOkL4qVbNj6GJXEWdOv4vyA9Nt+wUZmiN3Cw4m
         sXITJ9OpDejJxJHQ8V9TJY4Lk6YcW8lQ6LeST088bdIL8eBszQmUW+8wFQQPHOWjb8mo
         S+htV6BtSbyihOok0Z3T+K3FuQ6tds773c/nrQtYIUj9pGdBjkj8tHvqK6qFDN8oilHg
         UTYbYVcmXYRXI4JOtoa7BHw0rgKvAuluGiUBmG3SEylKl8awShHE4ttQ22HZnZZYKcbS
         svQob/+osAS0G35GaexiR2W9gbzK+TUF2rQsjw77rQT3OoxwF3hW8m2YmpNoJ1PmZwlu
         YJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Edd0Fo2D0WvSZIjYk40gz3y+yRWfqXBpq1Y7O0sOFY=;
        b=VTWs6krtv0JBq/RwEquJrhKaNpp6hHioEwZiqIvMkToxEhk12sUbM59dFFa60HEUKU
         KefRXEJ/Fq388tnrw7xmIbHgfouReasJvF54QK8rwL4PIKyhXUNewJ/PlTSvObkhasIU
         /DKZkJ8xG9AMxZwjutR1RcUyECjbDiKpiKRhyF8lepe9jtthPM9AoXtbWHAv7llTd3Rj
         jWKCqoenrVIn6syYC7IjpvCLmGEAfn86hVrdzbxn4oYkQPTs4krkoVRhouAb2WOp76bO
         TgbLyxD3GLj4UjDI/QzTHL5CWFaQuuXuwNd+ggnOCpC62iUw4DZx7dqbSArmeM2n/052
         3CnA==
X-Gm-Message-State: AOAM531gIP603z/e+SPNltOKgTyuP+ulGpCpnwtiEVetn/hYYi0A1L1V
        dPCG7S5yomNa3OacWS5KF8oqNJ2iQZXVTYKXcIM=
X-Google-Smtp-Source: ABdhPJxHfXE6UKB/kFzePKWrFvXgmDJzVqsmC6ouyI/l2fFtl0ZCqE2/y9PYkRF5Q83kXOotPOiSHgChLs3BI/1vv4Y=
X-Received: by 2002:a05:6402:11d2:b0:42d:e68a:eae0 with SMTP id
 j18-20020a05640211d200b0042de68aeae0mr61764300edw.111.1655066732236; Sun, 12
 Jun 2022 13:45:32 -0700 (PDT)
MIME-Version: 1.0
References: <41d88dff4805800691bf4909b14c6122755f7e28.1655063685.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <41d88dff4805800691bf4909b14c6122755f7e28.1655063685.git.christophe.jaillet@wanadoo.fr>
From:   Christian Lamparter <chunkeey@gmail.com>
Date:   Sun, 12 Jun 2022 22:45:20 +0200
Message-ID: <CAAd0S9CFQn33FsmaSMdVwHd__HW8NXM0MvDzJfNuxTUm6Hh4oQ@mail.gmail.com>
Subject: Re: [PATCH] p54: Fix an error handling path in p54spi_probe()
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Christian Lamparter <chunkeey@web.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
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

Hi,

On Sun, Jun 12, 2022 at 9:55 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> If an error occurs after a successful call to p54spi_request_firmware(), it
> must be undone by a corresponding release_firmware()

Yes, good catch. That makes sense.

> as already done in the error handling path of p54spi_request_firmware() and in
> the .remove() function.
>
> Add the missing call in the error handling path and update some goto
> label accordingly.

From what I know, "release_firmware(some *fw)" includes a check for
*fw != NULL already.

we could just add a single release_firmware(priv->firmware) to any of the error
paths labels (i.e.: err_free_common) and then we remove the extra
release_firmware(...) in p54spi_request_firmware so that we don't try to free
it twice.

(This also skips the need for having "err_release_firmaware" .. which
unfortunately has a small typo)

Regards,
Christian

> Fixes: cd8d3d321285 ("p54spi: p54spi driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/wireless/intersil/p54/p54spi.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/intersil/p54/p54spi.c b/drivers/net/wireless/intersil/p54/p54spi.c
> index f99b7ba69fc3..679ac164c994 100644
> --- a/drivers/net/wireless/intersil/p54/p54spi.c
> +++ b/drivers/net/wireless/intersil/p54/p54spi.c
> @@ -650,14 +650,16 @@ static int p54spi_probe(struct spi_device *spi)
>
>         ret = p54spi_request_eeprom(hw);
>         if (ret)
> -               goto err_free_common;
> +               goto err_release_firmaware;
>
>         ret = p54_register_common(hw, &priv->spi->dev);
>         if (ret)
> -               goto err_free_common;
> +               goto err_release_firmaware;
>
>         return 0;
>
> +err_release_firmaware:
> +       release_firmware(priv->firmware);
>  err_free_common:
>         free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
>  err_free_gpio_irq:
> --
> 2.34.1
>
