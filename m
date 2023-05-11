Return-Path: <netdev+bounces-1697-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF4E26FEDF0
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:40:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 110EC28157D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 08:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25FE7804;
	Thu, 11 May 2023 08:39:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C79377
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:39:57 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A4249D6
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:39:55 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so76954406a12.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683794393; x=1686386393;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rI3gU8oVkKaiPnV7pBa9aBcGI6toVfCrnfG0G6zDqkE=;
        b=k9uJI6+dURy+3pVvbdWprfOltfy6eFPUDt02aa7bNrcwEc5PzuqUlY5AqVsp9fsRtk
         AH7cFd/PuD3O+fdhdkqXbL8BTbIv65E3cDK3glj4RgCcbASfAgKTYKuuJLr2PcNeArkv
         ItMl4RFqKb8o41NMx/qX8vLosaKFydSYezOFMl6YqaH4LbelO2gWC8TCAieGswxIIUZ9
         lUYyA5T19geES8NWNUWWBqHq47AsqJn8X83owShEEcZcvHmMvYLsNZF97gQS9MmllikK
         kta2swY3q91SJNlpGiYRl+StRu9GNby3zq+1BKeC26+uhfzemAQJroBgnADANRJh8vhi
         mSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683794393; x=1686386393;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rI3gU8oVkKaiPnV7pBa9aBcGI6toVfCrnfG0G6zDqkE=;
        b=LBMVA+jhGK99I/HhOeL8iG9IYoASupiIl4coRzwbb7iUXcsos/N7ZeKNS94no5ThCW
         EMonTyHYibr/EB32F8yZv8dh1iNmuUPxaEYvRou/GsP5nQE4eX5bw7FQ+BYdL/34Wz2k
         elUJpxUuXR23tfCeBGyDldnIuzckCjA/FPxA+r7y3KKC8j90z+/FPSSbQl27xaRqHxR6
         CMNQAwbAbcqnXkaaBhZfdgNa/bNF5bWEh6ztOWpeqn021AK6rVgX4/cuehb8BcZOOiFT
         ToGuJh66b8T7tIQCaovFPQRwxXYK3G/y7rLLw1Yg4kBAaC5GFHo26x2Qy5yyFQvyLRq0
         p+lw==
X-Gm-Message-State: AC+VfDyYwG+GqBlvHtPwD8UMSduPmTE08IZcuV0I2I5qjrPZmUhguKYd
	XH2OoLFl8vHjoSk8PFbEsqFUCA==
X-Google-Smtp-Source: ACHHUZ52XVRxdDG3kW7XH9RjlpXoCnQHyjMTsLfBw/b+G7AB7t1Mb+4T+7eafMV1YO3zBfQHVCLR0g==
X-Received: by 2002:a17:907:a41f:b0:94f:1d54:95d2 with SMTP id sg31-20020a170907a41f00b0094f1d5495d2mr19367749ejc.15.1683794393437;
        Thu, 11 May 2023 01:39:53 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:7e61:f14a:c3a4:809e? ([2a02:810d:15c0:828:7e61:f14a:c3a4:809e])
        by smtp.gmail.com with ESMTPSA id n17-20020a170906725100b0096a6bf89259sm374828ejk.167.2023.05.11.01.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 01:39:52 -0700 (PDT)
Message-ID: <26d223dc-ed79-5523-923e-8fe413cddf1d@linaro.org>
Date: Thu, 11 May 2023 10:39:51 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 5/5] dt-bindings: net: ftgmac100: convert to yaml
 version from txt
To: Ivan Mikhaylov <fr0st61te@gmail.com>,
 Samuel Mendoza-Jonas <sam@mendozajonas.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
References: <20230509143504.30382-1-fr0st61te@gmail.com>
 <20230509143504.30382-6-fr0st61te@gmail.com>
 <ec0a3553-2c11-301e-d838-f0bc70353b17@linaro.org>
 <c16f87f8182bdb0a0fe89014e56a32758248baeb.camel@gmail.com>
Content-Language: en-US
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <c16f87f8182bdb0a0fe89014e56a32758248baeb.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 11/05/2023 02:15, Ivan Mikhaylov wrote:
>>> +  phy-mode:
>>> +    enum:
>>> +      - rgmii
>>> +      - rmii
>>> +
>>> +  phy-handle: true
>>> +
>>> +  use-ncsi:
>>> +    description: |
>>
>> Do not need '|' unless you need to preserve formatting.
>>
>> I will stop review, because it depends whether this is true
>> conversion
>> or new binding.
>>
> 
> I've tried to convert it from ftgmac100.txt, everything is same in it
> except mac-address-increment option with explanation for which purpose
> it there, need I divide conversion from that option or is it fine in
> one?

As I wrote at beginning, I don't see conversion here, so difficult to judge.

Best regards,
Krzysztof


