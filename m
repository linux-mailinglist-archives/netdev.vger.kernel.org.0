Return-Path: <netdev+bounces-9985-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E1C072B95E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:57:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52B4D281099
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B93DDB0;
	Mon, 12 Jun 2023 07:57:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848C0C8D8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:57:47 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B28210E
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:57:22 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f7f6341bf9so40216245e9.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686556634; x=1689148634;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ntRYvz0tRb6HbKymHFNjRh0d14+I2NVOI7EThtiN4Yc=;
        b=hYCX6PlERwfVWhQnpZIDQMkHG5m70BpXcb9Si+EgU/TSHXpqpOm/2DQ4bj4py6H4s+
         xRB/2qXBCQDpuikUQRAag5EMMJJ9jv5RkudNegt3foV5f2LHqtJd6S1cWCEaJDdY+YRa
         x84HbCG3snT+Nuln4+j3MUm3GWofMRWZHtDD7CKdQ/8Mqnz572+WY07DylJZqYzgFyBW
         3jtYyVOgT7RXifB72Saxh9I+gA/+IKSC0/obH/E8TZU5i2/ynuzxxk5ICfUPCyNUa8qA
         sjbHF90OmqSbRKnATd4B02cZDP23xDULnXqMR3zd4JAmSf0R1zaFWmJ/mB8FDbXvOcET
         Z0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686556634; x=1689148634;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ntRYvz0tRb6HbKymHFNjRh0d14+I2NVOI7EThtiN4Yc=;
        b=Af2FNFh+wotkxJL8Lq1rW+hMlsYw3KhDnkx8NNbOn4WwL5mGNIs7Jvx1O6WHlOYV0o
         3X9a3O2jKWIWxN02nAj09dB9p4gn3/cPKyC2/kPBHsg0dD+rhUnXf0iuPPagSy887iUt
         GzUqoHl1MkyeD4itw2C/9XwXj2RzIvBQkwOfNc2Yuo6c0pxZ+rJra5rTxlb1w63E3B5/
         C5i9cTJe2UHi9376W+WJWvoQyoQYD0akiBr3naVG4EUp1prUinVcQonlJ5SwwdcbfDzB
         jZQPQbukW7ocbEfYLE3oQL3doN209+nKGwG/hUBfpEGFxRm7XGWlPasX4AjuIoxrU6au
         u2zA==
X-Gm-Message-State: AC+VfDwsgWZT2OjuQR7KSwoSckhwB4UXsA9T4ZlCYn1Ftf7+QlWpnIRQ
	8VqqKBaI+sKCx7IX7ybA1zyCNeK4+95fOk/kSO0=
X-Google-Smtp-Source: ACHHUZ7CNdlZ+cV8ahgX1g2P375Kp+4cIx9AN8l9KjZ490gLm+dmUsMvU9DvqOjd5o4cQC6f4IH9Dw==
X-Received: by 2002:a17:907:728d:b0:96f:afe9:25c4 with SMTP id dt13-20020a170907728d00b0096fafe925c4mr7636877ejc.50.1686554146850;
        Mon, 12 Jun 2023 00:15:46 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id x10-20020a1709060eea00b009745edfb7cbsm4772634eji.45.2023.06.12.00.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 00:15:46 -0700 (PDT)
Message-ID: <416a90ee-7501-1014-051d-e6a3eb03a0ff@linaro.org>
Date: Mon, 12 Jun 2023 09:15:45 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH RFC net 1/2] nfc: nxp-nci: Fix i2c read on ThinkPad
 hardware
To: Marco Giorgi <giorgi.marco.96@disroot.org>
Cc: netdev@vger.kernel.org, u.kleine-koenig@pengutronix.de,
 davem@davemloft.net, michael@walle.cc, kuba@kernel.org,
 linux-kernel@vger.kernel.org
References: <20230607170009.9458-1-giorgi.marco.96@disroot.org>
 <20230607170009.9458-2-giorgi.marco.96@disroot.org>
 <07b33c1e-895e-d7d7-a108-0ee5f2812ffa@linaro.org>
 <20230611181707.1227de20@T590-Marco>
Content-Language: en-US
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230611181707.1227de20@T590-Marco>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 11/06/2023 18:25, Marco Giorgi wrote:
> Hi Krzysztof,
> 
> On Wed, 7 Jun 2023 19:45:25 +0200
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:
> 
>> On 07/06/2023 19:00, Marco Giorgi wrote:
>>> Add the IRQ GPIO configuration.  
>>
>> Why? Please include reasons in commit msg. What you are doing is quite
>> easy to see.
> 
> This is my fault, I only put the patch reason in patch [0/2].
> 
> Basically, I found out that the mainline driver is not working on my
> machine (Lenovo ThinkPad T590).
> 
> I suspect that the I2C read IRQ is somehow misconfigured, and it
> triggers even when the NFC chip is not ready to be read, resulting in
> an error.

Isn't this then a problem of your I2C controller?

> 
> In this patch [1/2], I'm adding the "IRQ" GPIO to the driver so its
> value can be directly read from the IRQ thread.

What is IRQ GPIO? If this is interrupt line, you are not handling it
correctly. This is quite surprising code.

> 
> In patch [2/2], I'm safely returning from the IRQ thread when the IRQ
> GPIO is not active.
> 


Best regards,
Krzysztof


