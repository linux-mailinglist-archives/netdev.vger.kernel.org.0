Return-Path: <netdev+bounces-3236-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C73957062AC
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:23:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74233280F9C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0EDA154A6;
	Wed, 17 May 2023 08:23:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9519A15492
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:23:54 +0000 (UTC)
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA2C3AAD
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:23:52 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-510a59ead3fso707214a12.2
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684311831; x=1686903831;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LKUIs50mnG/Knu4CLF/A96KY4SWKyjHZGjCyjw2baO4=;
        b=xDvL5sQ+DjWEIr5GoQyOeWMPcVUdgea2iobHJW1TnN8/cjb3uYuoxBRO5ONKv0BZAT
         8981ycPq0MWXiUIx/ecTG4EynrbkzKAzVyGJ4AfOdNF3Qm0veuDInBrds2quBika/Xmv
         s4/4KgK0NTl+h2wEbi7ACJc1JIEISD0N3hjtuCKVgzyINzPK5TQv9aSKLyiM5delIPH3
         vDb5vngLmWMvttRB8+2vsHUrjl/9yqscY1ROOfTpcuWk+RxvDXpsrJ7BKmzw3eD0ElCA
         CASgBv2+/2qRJfVTw6CMUr3knbtLadmBmjcLPgKMJSoCOGL1jPCkcbwX76zooIaE6DpB
         Beog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684311831; x=1686903831;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LKUIs50mnG/Knu4CLF/A96KY4SWKyjHZGjCyjw2baO4=;
        b=VKmJhKtSB1abc58Y6m0w90S5qpyVQZ7z4slcTkmcxuCC3KqJNe+AE11Mc7K+A/BjQi
         Dv6BJ56ewCeN5ULfnV9KNGsOd2np8DJZvHjdSdamebTWgCGXfA/R/n95EPI3IikxiJaB
         BrITmT4btNBWGj88ayPzRVgavX6C81v99wRzqwvonSiWENrs7yEWrprTEJQnNhNRJTCX
         8Xs8UifucNEP88CzVbIGHgzlYbMaF522vg8vJN3HZPQfyRhMltKU235wU9TgzhjHL1f2
         /WKa0sM0f/esfQ1IRFK5YgK/jZq/ro/KExZx669qajoJ6Ae2AzpiNouVHEnzcffofnx4
         LUjQ==
X-Gm-Message-State: AC+VfDzhT+YX8SHkA88514Krp7E7q/fDBTGcWPgzMFaWlBeYjgW/QAOK
	UKmu5Klmutv+PF2AA/+Ee51glQ==
X-Google-Smtp-Source: ACHHUZ6JAU9IyvwDF7lt/LO8E3EuXYi5lw61lPs7XcWdpC28r6MFpbSeQVAKg2TYT4dhri6K8nNUhA==
X-Received: by 2002:a17:907:a46:b0:94f:2b80:f3b4 with SMTP id be6-20020a1709070a4600b0094f2b80f3b4mr32901870ejc.69.1684311830969;
        Wed, 17 May 2023 01:23:50 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:c9ff:4c84:dd21:568d? ([2a02:810d:15c0:828:c9ff:4c84:dd21:568d])
        by smtp.gmail.com with ESMTPSA id mm30-20020a170906cc5e00b0096595cc87cesm11997266ejb.132.2023.05.17.01.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 01:23:50 -0700 (PDT)
Message-ID: <c585ef60-1482-ad53-3b7b-44163754c0fa@linaro.org>
Date: Wed, 17 May 2023 10:23:49 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Content-Language: en-US
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 Conor Dooley <conor.dooley@microchip.com>
References: <20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
 <20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
 <20230515105035.kzmygf2ru2jhusek@skbuf> <20230516201000.49216ca0@kernel.org>
 <124a5697-9bcf-38ec-ca0e-5fbcae069646@linaro.org>
 <20230517070437.ixgvnru4a2wjgele@skbuf>
 <20230517070826.ywncgnuyoi67zttg@skbuf>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230517070826.ywncgnuyoi67zttg@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 17/05/2023 09:08, Vladimir Oltean wrote:
> On Wed, May 17, 2023 at 10:04:37AM +0300, Vladimir Oltean wrote:
>> On Wed, May 17, 2023 at 09:01:38AM +0200, Krzysztof Kozlowski wrote:
>>> Yes, apologies, I usually forget the net-next tag.
>>>
>>> Shall I resend?
>>
>> Probably not.
> 
> Although patchwork marked it as "not a local patch", so no tests ran on
> it. Let's see what Jakub says.
> https://patchwork.kernel.org/project/netdevbpf/patch/20230515074525.53592-1-krzysztof.kozlowski@linaro.org/

I will just resend in such case.

Best regards,
Krzysztof


