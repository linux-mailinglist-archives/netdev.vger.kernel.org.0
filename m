Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75FA547C04
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 22:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbiFLUpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 16:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiFLUpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 16:45:10 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A0F36E0C;
        Sun, 12 Jun 2022 13:45:06 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-fe15832ce5so6117439fac.8;
        Sun, 12 Jun 2022 13:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KiHh3mNR9SjXvyYJ+6mDjY+crvy6Eb0sGDaczJHHzBY=;
        b=a7ebsPScQ1p7OfSZ7u/kJMe7FIMASIksYh7WQLGaAf00s6NDFIs1SuUPq0OoT/4KXd
         hSYPDhVg+zIWGPA1YoqrcduMy9LdUorOlp6Cxucoq2yF3e5ug4gMeGgOPpv9Kxn5XKV6
         Q9w/CabZXCp/3glyKYvRCOiEkqZ+F+CHlUJaMobeXIxF32MZWBncV6E72Kobjs01ghve
         3ZQem4WFV5MoAWHXUCahpwV2AAr8BnM+M+pP3r9FLlJnhFwFi0mrUHzuA6UZHnbsPqWW
         fm73hbH7Qow+NG57JieVc+4yaJ8kvQsJNZTlQKRsUFHcTc4SuZ6vo8vdzVQvOih1p5xG
         dPSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KiHh3mNR9SjXvyYJ+6mDjY+crvy6Eb0sGDaczJHHzBY=;
        b=SOX4dqaQB0vhKx3V7P6TN7/d6BWlG6pW5AUIWvNdUFolBVG9oRap8kN3ePFBuGElRI
         AUbuKXrQnIxKNGlRGx2gwJl9FR0i3HkgBGSvRwqHN8/Izkw3lJk48XPE1YkIu3mS/Gh7
         qmE3BzLZwsHweMZOj8PXrApOlf2IEs30QJhjQAc3sQbPgew7+yCEDL8ZxOO6WdwBbCf+
         W9ZnT4QiGbq8pIzqm7mQu3UOqVmC3U4DzJhm3bA7Fk+L9P+kWPcwiSHuCNGcNbj+icP3
         vaiFyYg1D6UxoyR/LnEtukK9udluu/gaqsd8gsNhD/Plmav1yzTi51w1ZQ2x03pTNeaO
         rrJQ==
X-Gm-Message-State: AOAM530lJ9KpkG/894ug2EEnmDunKF9q0X4spu2AJmx82Mn9Hgvm9mtD
        Mu0QZtSLPs4EczPcad33UU0=
X-Google-Smtp-Source: ABdhPJymWnsda3CStPG0OThx0198+W1zvun1kQUjmySM156hLtUKWA87KUhtU47aGKZE3zOrhXILpw==
X-Received: by 2002:a05:6870:5621:b0:f5:d454:d7c7 with SMTP id m33-20020a056870562100b000f5d454d7c7mr5749188oao.236.1655066704678;
        Sun, 12 Jun 2022 13:45:04 -0700 (PDT)
Received: from ?IPV6:2603:8090:2005:39b3::1042? (2603-8090-2005-39b3-0000-0000-0000-1042.res6.spectrum.com. [2603:8090:2005:39b3::1042])
        by smtp.gmail.com with ESMTPSA id pu16-20020a0568709e9000b000f5e256494csm2925539oab.34.2022.06.12.13.45.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jun 2022 13:45:03 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <892df159-e73f-be1c-a9c8-bf861fe45d83@lwfinger.net>
Date:   Sun, 12 Jun 2022 15:45:01 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] p54: Fix an error handling path in p54spi_probe()
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christian Lamparter <chunkeey@web.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <41d88dff4805800691bf4909b14c6122755f7e28.1655063685.git.christophe.jaillet@wanadoo.fr>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <41d88dff4805800691bf4909b14c6122755f7e28.1655063685.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/12/22 14:54, Christophe JAILLET wrote:
> If an error occurs after a successful call to p54spi_request_firmware(), it
> must be undone by a corresponding release_firmware() as already done in
> the error handling path of p54spi_request_firmware() and in the .remove()
> function.
> 
> Add the missing call in the error handling path and update some goto
> label accordingly.
> 
> Fixes: cd8d3d321285 ("p54spi: p54spi driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/net/wireless/intersil/p54/p54spi.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/p54spi.c b/drivers/net/wireless/intersil/p54/p54spi.c
> index f99b7ba69fc3..679ac164c994 100644
> --- a/drivers/net/wireless/intersil/p54/p54spi.c
> +++ b/drivers/net/wireless/intersil/p54/p54spi.c
> @@ -650,14 +650,16 @@ static int p54spi_probe(struct spi_device *spi)
>   
>   	ret = p54spi_request_eeprom(hw);
>   	if (ret)
> -		goto err_free_common;
> +		goto err_release_firmaware;
>   
>   	ret = p54_register_common(hw, &priv->spi->dev);
>   	if (ret)
> -		goto err_free_common;
> +		goto err_release_firmaware;
>   
>   	return 0;
>   
> +err_release_firmaware:
> +	release_firmware(priv->firmware);
>   err_free_common:
>   	free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
>   err_free_gpio_irq:

Why "err_release_firmaware" rather than "err_release_firmware"? Otherwise the 
patch looks good.

Larry

