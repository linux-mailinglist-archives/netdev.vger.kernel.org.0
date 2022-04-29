Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47E45147E7
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 13:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358235AbiD2LUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 07:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358224AbiD2LUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 07:20:17 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2548684EF7;
        Fri, 29 Apr 2022 04:16:59 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id v4so10083802ljd.10;
        Fri, 29 Apr 2022 04:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hz0RNsEKTjmIo/p11tTiNf/OsbPRAe1Ze+MjYBl3gM4=;
        b=FZQ+KjW/5JEg3drJp9CadA8zjFDEiVIbyqwZQe3yIx8qIF3Uo2m/BFr1gKw7EyFLDR
         fTxiVISIAX5vMrNi0nJJCzstwqNGNoPmkaFqqqOcZqlrLO1MFkRUdYj3kew2F4d8fqv/
         OnnwogvnSafElrMVD4RfNmGd2fRGTwAytWyo+4vBicG9RzPL9uqSrQAKKiCbAXzidBI5
         rvdUQCev8SVTmEYmkvoqGdctmE1cnUKVJHezX3dfm9U98yNVZski+xcBgG2LA0VN9lP1
         KrfztUi/6YhsJT3pLwyF7xT5mHTIb9/AlGgQaHKeCGM+J3+LLzD24F/qBE8hdGUk9B4R
         F+7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hz0RNsEKTjmIo/p11tTiNf/OsbPRAe1Ze+MjYBl3gM4=;
        b=X1fCMPnhGVHsiOlgUhuc6XOnv6zSwDV1U7cIuyemP3PVcflc5S7tPovJC9TYjajbLU
         wp+ZxrbpKS0CqBhuc2PJ+tpppXVUOS6UJsVkNGPrR3jJuGWNWsy19wgt8vgu/G0kRV8T
         HMhw+mZD8FDXTt4XX0pAvDF4RULBwR/ARROxWwFocx0WBH2dtB0W39lfftytUsBR915G
         vlDu22AJ51VQNWNW9auRJtUubJdYNgJuu/NwJIDYs/Wg6C1F5EyXWgP1OndJgl1RUYJd
         q0ocgXIY8FASPKzncP0CV7xPlD9bTnF8bOUVRsSEkguUpljk1lSHnDptf5hyURm9U8m9
         s0vw==
X-Gm-Message-State: AOAM5304lV0nUpg/dgyKxEXD9ApALYOSR85rk5xt+j9gEuQRrylZ3i6P
        Gqp+LvzihFao5V7Dkp3mvNRmEZX46TJaBeaubO8=
X-Google-Smtp-Source: ABdhPJze0ExX3Xn5JBoNWskIr377b/kqzk6Orn04yfBcLyzUw+sKzIlmFLqgoOuZ6ug+nvQJn0d38dvvwtqf/KWQDig=
X-Received: by 2002:a05:651c:1603:b0:248:e00:aeba with SMTP id
 f3-20020a05651c160300b002480e00aebamr24953814ljq.456.1651231017381; Fri, 29
 Apr 2022 04:16:57 -0700 (PDT)
MIME-Version: 1.0
References: <CWLP265MB3217B3A355529E36F6468A43E0FC9@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
In-Reply-To: <CWLP265MB3217B3A355529E36F6468A43E0FC9@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Fri, 29 Apr 2022 21:16:45 +1000
Message-ID: <CAGRGNgXJfHc4UOvz5QGDPpUsCLau+0caAsCzFDBnc3EHHgf1xw@mail.gmail.com>
Subject: Re: [PATCH] Fix le16_to_cpu warning for beacon_interval
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Srinivasan,

On Fri, Apr 29, 2022 at 8:49 PM Srinivasan Raju <srini.raju@purelifi.com> wrote:
>
> Fixed the following warning
> drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: expected unsigned short [usertype] beacon_interval
> drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: got restricted __le16 [usertype]
>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>
> ---
>  drivers/net/wireless/purelifi/plfxlc/chip.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/purelifi/plfxlc/chip.c b/drivers/net/wireless/purelifi/plfxlc/chip.c
> index a5ec10b66ed5..5d952ca07195 100644
> --- a/drivers/net/wireless/purelifi/plfxlc/chip.c
> +++ b/drivers/net/wireless/purelifi/plfxlc/chip.c
> @@ -30,10 +30,10 @@ int plfxlc_set_beacon_interval(struct plfxlc_chip *chip, u16 interval,
>  {
>         if (!interval ||
>             (chip->beacon_set &&
> -            le16_to_cpu(chip->beacon_interval) == interval))
> +            chip->beacon_interval) == interval)

Shouldn't that first ")" go at the end of the line?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
