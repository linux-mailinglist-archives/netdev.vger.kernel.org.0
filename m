Return-Path: <netdev+bounces-2044-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A1E07000E8
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:54:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF5881C20FCD
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9067563B8;
	Fri, 12 May 2023 06:54:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2CE1119
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:54:42 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B596ADC66
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:54:39 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-965d2749e2eso1401478866b.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683874478; x=1686466478;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FjXUkXzHmLJkLJqGLPZFXqBqkIkhEgvZocnaDYnUcUg=;
        b=NNUd1P4piw1vL7STEfyXPEakse7eOF1CEYsj3zx6+aoQfc81g50Hb+o7tN9yPC/xZC
         7SFeVpqQjfnzWv8Q4l8DQz3L6yj8SeEi7QZKDAkcDBL3qL4dP1CC7bEEGXbabW6IYcEW
         GaYkg9UsrmgR81loqen4dwEByQQd0eJFgAgPRZWXGRSdFiqcy1N+CLa+HYSMQ4/Lck3f
         uhDLT3aZBK09/iBP9STeIhdx3PYHvG5aWvOVjyxo1UAhWxDE0LYtHVdqyDLDaUCZFY01
         dsKJydZeU9Wl35NAPsig8FlcQxT0j/bvfWmulbF7sNEm4RJJS7Ajt/YeQdEXtghwwRR9
         pFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683874478; x=1686466478;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FjXUkXzHmLJkLJqGLPZFXqBqkIkhEgvZocnaDYnUcUg=;
        b=Yj5PwOBrd76EwJRvlDDI6MVuqrO3ZM2SeNM5sZgpYmc8AUO3I9nEiv+HobBWOmJWCA
         0cfAIoeuJsY0FalqxDCUTE0n5pBG+DGtxnFVXq/KtqoCteqlv52apmLI4vxAyprM3QEX
         Gl1e49wj+AfyGXMQF+HsfMKOQmj9XHZZOOJsnfFFhtvr3K58ww7wfuYCq8dDzThdLb0W
         nm5F1p+XduO0266UUvi41ymXRj5oysiydbJdDOQUby+m5p57DzQML8DtHw+bYc5lYjd6
         OXZEHoMugCWfP+Ywkz6KmOj/qygslRApYsy0EEasL8vTS/HUgK/xoir6td25XN4ej6QR
         0kVg==
X-Gm-Message-State: AC+VfDxD1UTOFR1k1uPeC2waAt9WkFSMaY4xYcS5gemXTuCbnw9sfQah
	j5qEo6BaV8y/FQW3SMWAeqoFLw==
X-Google-Smtp-Source: ACHHUZ4yy5HgsrY8PHBO7NaE2kkMJm6oRaQhNMbX4qWxwK89SLe2e4ju+bwDOzRDTJUx/bMnGgBdrg==
X-Received: by 2002:a17:907:3f0a:b0:967:21:5887 with SMTP id hq10-20020a1709073f0a00b0096700215887mr16008252ejc.40.1683874478238;
        Thu, 11 May 2023 23:54:38 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:7ede:fc7b:2328:3883? ([2a02:810d:15c0:828:7ede:fc7b:2328:3883])
        by smtp.gmail.com with ESMTPSA id k10-20020a1709067aca00b0096a1ba4e0d1sm3386641ejo.32.2023.05.11.23.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 23:54:37 -0700 (PDT)
Message-ID: <7e8d0945-dfa9-7f61-b075-679e8a89ded9@linaro.org>
Date: Fri, 12 May 2023 08:54:36 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v4 1/2] dt-bindings: arm: mediatek: add
 mediatek,boottrap binding
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, Daniel Golle <daniel@makrotopia.org>
Cc: devicetree@vger.kernel.org, netdev@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <linux@armlinux.org.uk>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Qingfang Deng <dqfext@gmail.com>, SkyLake Huang
 <SkyLake.Huang@mediatek.com>, Simon Horman <simon.horman@corigine.com>
References: <cover.1683813687.git.daniel@makrotopia.org>
 <f2d447d8b836cf9584762465a784185e8fcf651f.1683813687.git.daniel@makrotopia.org>
 <55f8ac31-d81d-43de-8877-6a7fac2d37b4@lunn.ch>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <55f8ac31-d81d-43de-8877-6a7fac2d37b4@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 11/05/2023 17:53, Andrew Lunn wrote:
> On Thu, May 11, 2023 at 04:10:20PM +0200, Daniel Golle wrote:
>> The boottrap is used to read implementation details from the SoC, such
>> as the polarity of LED pins. Add bindings for it as we are going to use
>> it for the LEDs connected to MediaTek built-in 1GE PHYs.
> 
> What exactly is it? Fuses? Is it memory mapped, or does it need a
> driver to access it? How is it shared between its different users?

Yes, looks like some efuse/OTP/nvmem, so it should probably use nvmem
bindings and do not look different than other in such class.

Best regards,
Krzysztof


