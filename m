Return-Path: <netdev+bounces-907-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC24C6FB526
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:34:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E50701C20A36
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6361C210D;
	Mon,  8 May 2023 16:34:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557A117E3
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 16:34:11 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDE95FE2
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 09:34:09 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-94a34a14a54so950056866b.1
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 09:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683563648; x=1686155648;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zNrcNKI3kICArS7t8GClBlVXIXiQxlkex2o1RaeVkAM=;
        b=ifgS1KzRjg+dYaia/i2Ma75A3+9IOa6M0ANa5UCEgJZ3yW4zFHspD6zYfcremJT6TW
         GEgBTn9LLcDRu2nsBP6jEY5zvEN1AFMPgbXM53mdCKB9Qbiy0HG2JPSjJbW231RrlLd2
         gOXK7eltK3L0VeY6ViODOnOEB7CLnVioyw6rGuZbNRX9GIeVLXeIjXFf/mplQnockM3Q
         aRkDCqv7tqzEacSTstt/T95A10AdmFDqWzyVBJuYqfJrfbmWzZ65e2z91vM+B6YYMkoI
         oFeUa1BdvdbpITj9zIE6XOMfBbgpt14jKqjiWtbttsFA0DRm1iG6pr8OLt8QQ5JYMQlS
         8r5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683563648; x=1686155648;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zNrcNKI3kICArS7t8GClBlVXIXiQxlkex2o1RaeVkAM=;
        b=WnqcbcMv6dTijtRrFtXsCbA8kutLJiyxEKyg/W3ysku0G+5WprcnfgpjcF1WXBqqUk
         NaOuIn6LVfNRzWtQ4MMGmzfVgHNoOUU06Op28ZYmaO79VUEAEgug3PIwJW0Cfz40uksS
         1SLOfZYEat4tvXmN783aF//LqvzUFDimWeso6IYKC6fa4EFMfNVgJMz0j+dlNKZY6klt
         bIInWWj20EI1pD8/FLwh0xVLRUEB/vNZDrL2dlGh+TDFAPnjmjvR05OxtnDb6x1LC0Md
         qUAwdStX8FxsLuVfwQsUeb4UjK3pe2RcGuix3mrLvohUM5vYVEjI6ei5BE4eDSYWFUKR
         DeOQ==
X-Gm-Message-State: AC+VfDyKVcgp2bl+KNFlwfHAJgYDFm6qM6vw92B6pBFtanUnozADAKsi
	lUPqqZY/9EqyDZpIKdzs1My1sA==
X-Google-Smtp-Source: ACHHUZ4CdoPU10LEgoyuRPnokuJ9LTkNvbjtjTNSFZc3CjQpZHZZxhybyE1BPFPskERmKA9wItcwug==
X-Received: by 2002:a17:907:9308:b0:965:b2c3:9575 with SMTP id bu8-20020a170907930800b00965b2c39575mr8598586ejc.57.1683563647903;
        Mon, 08 May 2023 09:34:07 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:50e0:ebdf:b755:b300? ([2a02:810d:15c0:828:50e0:ebdf:b755:b300])
        by smtp.gmail.com with ESMTPSA id ka11-20020a170907990b00b0096602a5ab25sm169419ejc.92.2023.05.08.09.34.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 09:34:07 -0700 (PDT)
Message-ID: <e25760bd-1de0-5ac1-868b-50299e83d70b@linaro.org>
Date: Mon, 8 May 2023 18:34:06 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 1/2] dt-bindings: net: realtek-bluetooth: Fix RTL8821CS
 binding
Content-Language: en-US
To: Chris Morgan <macroalpha82@gmail.com>, devicetree@vger.kernel.org
Cc: linux-rockchip@lists.infradead.org, netdev@vger.kernel.org,
 anarsoul@gmail.com, alistair@alistair23.me, heiko@sntech.de,
 conor+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
 pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
 davem@davemloft.net, Chris Morgan <macromorgan@hotmail.com>
References: <20230508160811.3568213-1-macroalpha82@gmail.com>
 <20230508160811.3568213-2-macroalpha82@gmail.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230508160811.3568213-2-macroalpha82@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 08/05/2023 18:08, Chris Morgan wrote:
> From: Chris Morgan <macromorgan@hotmail.com>
> 
> Update the fallback string for the RTL8821CS from realtek,rtl8822cs-bt
> to realtek,rtl8723bs-bt. The difference between these two strings is
> that the 8822cs enables power saving features that the 8723bs does not,
> and in testing the 8821cs seems to have issues with these power saving
> modes enabled.
> 
> Fixes: 95ee3a93239e ("dt-bindings: net: realtek-bluetooth: Add RTL8821CS")
> Signed-off-by: Chris Morgan <macromorgan@hotmail.com>

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof


