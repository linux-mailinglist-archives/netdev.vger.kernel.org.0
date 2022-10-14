Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB9F5FEEBB
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 15:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJNNg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 09:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiJNNg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 09:36:57 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0C719C22B;
        Fri, 14 Oct 2022 06:36:56 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id o22so2417378qkl.8;
        Fri, 14 Oct 2022 06:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HXD89n+g/IHfNLxiFjO0ku2zV39n7Ij4/f7iwolHvDA=;
        b=XedoNpp0fM2LS9h3qwYg/QbLyZUeKGuriQZkE5AsCgog55mCg5l//DbGx9NU37OLac
         ojv/VMZw8L9W1rW8Fat8i3oN9VG97bmXN39v5a8EW8QsFMTijuudZvFPfRsBUj5tC6d3
         2SRMwzUv+ExrORBwrNQbBlcbY9E8ZjllsGlpLdq1QN6djjliWROKTdpMYloqCYAn/twP
         9J4qfeICQWuNsnq7zNj9fZ8inoQBOIibXUY56OgEN2hH/dfYBc4sLSbMihNjhgOn+5eq
         mU6um6hYnGV1P5wWTohrqVtPHn7syy5r1mMEjpkGlBXOaFqo560n19d0UDlaxVMMJ3Dv
         Xk9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HXD89n+g/IHfNLxiFjO0ku2zV39n7Ij4/f7iwolHvDA=;
        b=uqoQXsBab7BfLB4SIHqzwSP4gWPDtZp3oaCeotGSWFzzDKbjsCz0NtIMyIO2tSyIu9
         UqrUf6Mvaz1uOiEi+2YJXoh44vmZRSEiyBpon4ozT87/59Y/ZMXIiUr4M/nB4svClyRj
         YQScjy7EDYxNvDiG7JacdsWnWVioZtTiFjcwCkJpUTKSmUEVIX1NKIIkm2ffl6Lqn+c6
         3p4L33P2/EndqYyW2rkAtxyl4WcAozsA8s21JtqU3nhInNOllxzERZNrNIeC3yhr9cE0
         VhjiKK7wkQ6fnAV5WqPet7ss2+zGoEcVWMxrSHrW79nFxswVtbokngor3BxVP2wrDsqZ
         Q2Nw==
X-Gm-Message-State: ACrzQf0dtu4YLloQsa8tdOM+GQSXHtkoA3CyRXG6QEGvQRbtkZGox+36
        uSt35EmzwsECV3D1ptRcIwgiNEUjaiA=
X-Google-Smtp-Source: AMsMyM6GNZuQdkoS6Dw52LPxv4g7vcgJQSJQi131zAY5ZiRXq0Daa30zSKKXsvGOcEAZ/GhEPBGz2A==
X-Received: by 2002:a05:620a:4248:b0:6d2:7f09:50a1 with SMTP id w8-20020a05620a424800b006d27f0950a1mr3692923qko.746.1665754615618;
        Fri, 14 Oct 2022 06:36:55 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id l5-20020ac80785000000b003996aa171b9sm1972323qth.97.2022.10.14.06.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 06:36:55 -0700 (PDT)
Message-ID: <69402e24-99a2-9957-693d-645b98f01cda@gmail.com>
Date:   Fri, 14 Oct 2022 09:36:54 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] sunhme: Uninitialized variable in happy_meal_init()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <Y0kuLdMUdLCHF+fe@kili>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <Y0kuLdMUdLCHF+fe@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/22 05:38, Dan Carpenter wrote:
> The "burst" string is only initialized for CONFIG_SPARC.
> 
> Fixes: 24cddbc3ef11 ("sunhme: Combine continued messages")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/net/ethernet/sun/sunhme.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index 62deed210a95..efaa6a8eadec 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -1328,7 +1328,7 @@ static int happy_meal_init(struct happy_meal *hp)
>   	void __iomem *erxregs      = hp->erxregs;
>   	void __iomem *bregs        = hp->bigmacregs;
>   	void __iomem *tregs        = hp->tcvregs;
> -	const char *bursts;
> +	const char *bursts = "";
>   	u32 regtmp, rxcfg;
>   
>   	/* If auto-negotiation timer is running, kill it. */

This should be "64" to match the value used by PCI.

--Sean
