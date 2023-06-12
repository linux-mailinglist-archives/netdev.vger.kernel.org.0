Return-Path: <netdev+bounces-9979-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D09F72B8AA
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90AFE1C20AF3
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752C5D2F5;
	Mon, 12 Jun 2023 07:34:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68670D50E
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:34:47 +0000 (UTC)
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482F710D9
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:29:46 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4f640e48bc3so4513243e87.2
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686554684; x=1689146684;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ntRYvz0tRb6HbKymHFNjRh0d14+I2NVOI7EThtiN4Yc=;
        b=exC6JDgIZcs71JZTfbGe8FbVFtVvq+ND8hCHRMIVYZdCzwmzcdmv9z8tSVKQBLoskl
         jJfToWX3LrORQdtFQKHrdsGR0blZOzuUROlSvBmDzWBmXfKuBnbb51KyeUmcUhcAW3Rn
         TibUQhkxDc8W5tNInES9Ih3RCKN4WQJVvQvstUUk5lpflSi9bqakPE7esueqN9UssGwH
         Xf2MOH5shcSeu1ajU5LjyggWJyAA10Pka9/g2k4jXi2H7kAyuclLpxxGwNMW44YY/+HH
         MUgHZ5jbpm6kMBLO+hXRPtgAzfU+Pjy4JXso0tZcHZNg85pWCP54uzJ4PH6vORzA1fDy
         BwUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686554684; x=1689146684;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ntRYvz0tRb6HbKymHFNjRh0d14+I2NVOI7EThtiN4Yc=;
        b=KM4ihc6U6HSzhtFzA0bEIwnxnRyasO+RNSNqQwsp/d8bx6nkoXxjyEBcjAbVmlS9bf
         X3X0j4DYOgid7xIoSZgLeisse5vwME8ZXE8U2GFSpd1qCdVR2VX6k2DjnuRyfLH7QND6
         lV0mB0I9yVQUPxx6HIT8SAdPSvDA9CtKxDKpx11NfE5lXiUJ/sHVe+gZymg7Nw2+vtAC
         fMaEJmqpvuy3NtbMAmNT+R1Lk802MPN4mPZqLyzOAKTJ/eqI/h6DP6880qlEyRZS7zs3
         3xKtEVGzR8nYCxY2cJPOg646SIQPldgjvMiEETemyZDmw5CK4It2AuhemSt2TaEDJ8iH
         taeg==
X-Gm-Message-State: AC+VfDy6uK5T0b5ZMoTJjkxe56VS2oxeKqVoFK1I/cOLwLx1e2IZpVbd
	n4l6Su1FO3mmhulNzwAhxtpU6W6oVgkMPxI4uuk=
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


