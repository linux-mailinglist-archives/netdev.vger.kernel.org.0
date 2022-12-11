Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C5E64951A
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 17:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiLKQeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 11:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiLKQeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 11:34:21 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC0A647C;
        Sun, 11 Dec 2022 08:34:20 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id vv4so22497227ejc.2;
        Sun, 11 Dec 2022 08:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ll6kCX33+8s5cf4iHgOPaW3i8Vl4DHq71YOPP4oWCdQ=;
        b=RZ1RbDsik47vSTcGLGdHgmvZ8u1feKoyfhGemL8bPzoLg/g0Ex7Y/cYi7oqtU4vyje
         bwNF35X2pvFByb7Fyd6+QYYRi2ycOQUI65VMF7ZVpdBynonHPfLtLv988vml5Sr9DAcc
         5buFZC4d6vU+QQql4jddEb2CrqFgUe/cZpcAvNlyUEZvw1tjxcljTVtyicdSIkfvluj1
         +2DqeEsZI1ZVGIJnOoFXeb6uDmmz+CmGYCd551xZ5dpgNgziTYbPsZNlU0FQIFmENINp
         XptTlH8c3Be0qKtMJzIJEWAlNbz/N1h9+6S0VhKbac4SU2HuFdg7Fc6rpDqx3S8sSbi/
         dGzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ll6kCX33+8s5cf4iHgOPaW3i8Vl4DHq71YOPP4oWCdQ=;
        b=1yHszkH1ZOjD9gQxcp0G/9Ab34znW6mRaMlUDxK4ql1S7t6esZ8qhizvaEDgAbHEDQ
         RfmZDGBH/lMdbHKvgPtVvxNDzWWY6OTqEPVSzSqkR774V3ENCO4nKmP3RkG5hR2mSawB
         gxDkBLvudnS3SW0zC9s/1neQTD3r+E44R3YDGMkRrVB7PGSkFBUVy73d7wwEN2KgzEkU
         IJHJWXjGt/hrtEHEg3Ceh30JjaLqxloeZ+NEwDe5psXfaQ5y4UL5SYphXFLhzBTc6ecc
         7BJbzgWDG1oxPoCy6ePNOJVvALrDJOtQ6AFRPdwJArwwJVqk6S8iN670L4dC4tYJWe45
         RkqQ==
X-Gm-Message-State: ANoB5pkBF0tH2w06pH17AO+GvO93zwxJOiP4PpQPaE/4RcSFGFCoQe5h
        T0cVs1Qf3BZlsUt+ghgXYek=
X-Google-Smtp-Source: AA0mqf4NXMwfkOs1mNO8pfQyBM2Z6bwdZcilrDNTObHD8PCILQSAy9nh4q09wCuWFweuwStpxFvaow==
X-Received: by 2002:a17:906:5213:b0:7c1:3125:9564 with SMTP id g19-20020a170906521300b007c131259564mr10131461ejm.8.1670776459101;
        Sun, 11 Dec 2022 08:34:19 -0800 (PST)
Received: from ?IPV6:2a01:c23:b8e1:2200:1956:d6ee:60e0:6ee2? (dynamic-2a01-0c23-b8e1-2200-1956-d6ee-60e0-6ee2.c23.pool.telefonica.de. [2a01:c23:b8e1:2200:1956:d6ee:60e0:6ee2])
        by smtp.googlemail.com with ESMTPSA id r1-20020a1709061ba100b007bb32e2d6f5sm2180719ejg.207.2022.12.11.08.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Dec 2022 08:34:18 -0800 (PST)
Message-ID: <f04435d8-9af3-1fde-c2bf-fadd045b10a1@gmail.com>
Date:   Sun, 11 Dec 2022 17:34:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] net: ipa: Remove redundant dev_err()
To:     Kang Minchul <tegongkang@gmail.com>, Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221211144722.754398-1-tegongkang@gmail.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20221211144722.754398-1-tegongkang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.12.2022 15:47, Kang Minchul wrote:
> Function dev_err() is redundant because platform_get_irq_byname()
> already prints an error.
> 
> Signed-off-by: Kang Minchul <tegongkang@gmail.com>
> ---
>  drivers/net/ipa/gsi.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index 55226b264e3c..585cfd3f9ec0 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -1967,11 +1967,8 @@ int gsi_init(struct gsi *gsi, struct platform_device *pdev, bool prefetch,
>  
>  	/* Get the GSI IRQ and request for it to wake the system */
>  	ret = platform_get_irq_byname(pdev, "gsi");
> -	if (ret <= 0) {
> -		dev_err(gsi->dev,
> -			"DT error %d getting \"gsi\" IRQ property\n", ret);
> +	if (ret <= 0)

According to the function description it can't return 0.
You can further simplify the code.
And you patch should be annotated net-next.

>  		return ret ? : -EINVAL;
> -	}
>  	irq = ret;
>  
>  	ret = request_irq(irq, gsi_isr, 0, "gsi", gsi);

