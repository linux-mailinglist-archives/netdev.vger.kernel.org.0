Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40EA654A020
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 22:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245294AbiFMUs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 16:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351238AbiFMUrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 16:47:16 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE9F2A940;
        Mon, 13 Jun 2022 13:03:12 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v25so8694588eda.6;
        Mon, 13 Jun 2022 13:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O2td3YP3JdUJuU07d3g8dndjMkX/4E+coAFBXOpD16E=;
        b=JMkGk63f6veModCTgkLMWMKyGEaydw5MgeRkLBOCjl+edkC8l6swYd6lK5XvGB1uDI
         C6j2NjFSj1Y+VNJoX+K3fXxfv4BCldHpQP1G4DF6WAPjgMWTtwk2A+iD5j8/2f70X4Zl
         PL6VeYes3d1ImWkIkEL8JK081lUKcpvfIOlyonY2g8oorwEKgKoh/f3RpfcT4Y86wZkh
         AR5rzkq41X9KEy5t18yxRzj9Q9jr29jMJGCILcWUk3tLjS7apGXFwRqDJ2fxiQdlLdff
         RcnJn3/nQogPSbr6nF03vZ2dB4WyJYeznggeZ1FX92Laz/D1R2959Up9yIBOrNysZH5p
         Hoew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O2td3YP3JdUJuU07d3g8dndjMkX/4E+coAFBXOpD16E=;
        b=kTXLS/DzElqRoIzpjzxwqA8X0ZBGGvgQsmrpjjjVzkgdiTQnUFmvSrbGAOKjEhk6WC
         D2YWKwT3yLuhjx9SiA6yvIGyEWZ1k9Bvfpn6StXGa2SMpazwFZmDwEyjI8tHfknIOM99
         vmzTnSVU1FFIfrnmsYK2oOYa87kOHVv88Ef0y1eVInzUST5JZhOUAf5VFpcVWmxok2HO
         b3OPDjY56UClgcUiuzW1fJxzikk8q8cp5nueU2iUbMORgmaHLbGDjLTqMiRGXoFn0wpS
         Nvn3bTelscIgniZNelSUehtpOLHXuCKvJSmK5BBpm8PAT+tux4yJAgklWXc/p2/+ivvq
         iuxQ==
X-Gm-Message-State: AOAM533L2VHfrx9OLBtQ+7FC+WO4+43/5FAmPOfnke6HzE90Dg/KR7Zw
        D9x8Ay0i8pi7nn6tonJ6nWlRjBfDt3zKzM7BN64NmhFD+l8=
X-Google-Smtp-Source: ABdhPJw2yRloQpbm6sxa+GrLKvGbTyCPyWW+lcJOlNOcBAd9ZPR5hEzRjfBokj5OwA6RXjIWWGTL3Pfzc7umGHPa950=
X-Received: by 2002:a05:6402:3546:b0:42e:2f58:2c90 with SMTP id
 f6-20020a056402354600b0042e2f582c90mr1710971edd.84.1655150590514; Mon, 13 Jun
 2022 13:03:10 -0700 (PDT)
MIME-Version: 1.0
References: <297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr>
From:   Christian Lamparter <chunkeey@gmail.com>
Date:   Mon, 13 Jun 2022 22:02:58 +0200
Message-ID: <CAAd0S9DgctqyRx+ppfT6dNntUR-cpySnsYaL=unboQ+qTK2wGQ@mail.gmail.com>
Subject: Re: [PATCH v2] p54: Fix an error handling path in p54spi_probe()
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

On Sun, Jun 12, 2022 at 11:12 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> If an error occurs after a successful call to p54spi_request_firmware(), it
> must be undone by a corresponding release_firmware() as already done in
> the error handling path of p54spi_request_firmware() and in the .remove()
> function.
>
> Add the missing call in the error handling path and remove it from
> p54spi_request_firmware() now that it is the responsibility of the caller
> to release the firmawre

that last word hast a typo:  firmware. (maybe Kalle can fix this in post).

> Fixes: cd8d3d321285 ("p54spi: p54spi driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
(Though, v1 was fine too.)
> ---
> v2: reduce diffstat and take advantage on the fact that release_firmware()
> checks for NULL

Heh, ok ;) . Now that I see it,  the "ret = p54_parse_firmware(...); ... "
could have been replaced with "return p54_parse_firmware(dev, priv->firmware);"
so the p54spi.c could shrink another 5-6 lines.

I think leaving p54spi_request_firmware() callee to deal with
releasing the firmware
in the error case as well is nicer because it gets rid of a "but in
this case" complexity.

(I still have hope for the devres-firmware to hit some day).

Cheers
Christian

> ---
>  drivers/net/wireless/intersil/p54/p54spi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/intersil/p54/p54spi.c b/drivers/net/wireless/intersil/p54/p54spi.c
> index f99b7ba69fc3..19152fd449ba 100644
> --- a/drivers/net/wireless/intersil/p54/p54spi.c
> +++ b/drivers/net/wireless/intersil/p54/p54spi.c
> @@ -164,7 +164,7 @@ static int p54spi_request_firmware(struct ieee80211_hw *dev)
>
>         ret = p54_parse_firmware(dev, priv->firmware);
>         if (ret) {
> -               release_firmware(priv->firmware);
> +               /* the firmware is released by the caller */
>                 return ret;
>         }
>
> @@ -659,6 +659,7 @@ static int p54spi_probe(struct spi_device *spi)
>         return 0;
>
>  err_free_common:
> +       release_firmware(priv->firmware);
>         free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
>  err_free_gpio_irq:
>         gpio_free(p54spi_gpio_irq);
> --
> 2.34.1
>
