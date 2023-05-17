Return-Path: <netdev+bounces-3244-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB834706302
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:36:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E49B28165D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CEB3D62;
	Wed, 17 May 2023 08:36:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3556764C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:36:49 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE2C1BFB
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:36:45 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-96b4ed40d97so69863666b.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684312604; x=1686904604;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g7ruM67WgRDIXbVKb/F6e9gFEQIj+XoUWJErkIr/uRg=;
        b=ItSaBxJTJ1tBihpooE/eT24WtPMlJ5sdTHYC9l471aIHQkuvYcRgVDLGm7zaeDx0Bc
         a36OA5ogxSHq9sO1144MHXOcUG5Y3QLpR0e9Nik2MR31WkUIXZCe22sI2gI5wNCKz9kr
         VZFFD4gmzMImzYaEayluE6x8Bj/dRjpcOwJJ0I2IaJyRb5IQlBbalaf975PvfR5UQzvO
         QDftdV7RP/vABR+XhsI+BRLDSXSbgoK7J8NZfoBdlxRZV25GHkcooq7gvv7SUuZgHDrF
         rGnC1nOr+QXN37dAKP6xpSljkn9O6VjZGEA2ymJpMtcTFUyxMhZkBFxEmJGsuFMnqlNx
         P3cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684312604; x=1686904604;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g7ruM67WgRDIXbVKb/F6e9gFEQIj+XoUWJErkIr/uRg=;
        b=hlB5biz88xLamgFcscfdctKE+yjubXd5meRN5vo3flqzm+rRFr3ajypM8ixkGduSHw
         CkmFazE+bZKTHogkZbThwMh6ckkUPdZAZ5+QXlL/oihuo2sdgIcD/5Oin/pHZPcKEAoB
         QsfYBFmWVdSkS1h/VSkcchoI1zCaXvWUWUskCsl3msnVUR6tvD2ptKWQBTS/H+MryRy2
         4H30sTTODNam5MBy+y2CVITyAlbqSXmMYR9tzip0uAmn4Vcqe8k3TJpYVpnXhqgSH0kf
         TNDXbyeiXC5xGzkLvFpxNeKatJmL5xfK8L/QDGKKcGSD+tPkyHLw3InqqyL7M25qYBxs
         j9Ig==
X-Gm-Message-State: AC+VfDxy9A67yZcsovuHGQLFms3gRGOIWV3MvjmcVkYKZbZrt+uOxJ9+
	lRAVe9ES37o5EO2nmWCRxzwKwg==
X-Google-Smtp-Source: ACHHUZ7mi58zcftzLkvCYSEZqALyJYLyJJAqnIEVZEYRSCl/2H4HV/w7hE9ZWWBQ9pRBw86G0ihu6Q==
X-Received: by 2002:a17:907:8a14:b0:94f:6218:191f with SMTP id sc20-20020a1709078a1400b0094f6218191fmr39457018ejc.52.1684312603985;
        Wed, 17 May 2023 01:36:43 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:c9ff:4c84:dd21:568d? ([2a02:810d:15c0:828:c9ff:4c84:dd21:568d])
        by smtp.gmail.com with ESMTPSA id ta26-20020a1709078c1a00b009663b1addb0sm11911626ejc.224.2023.05.17.01.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 01:36:43 -0700 (PDT)
Message-ID: <38ae4ceb-da21-d73e-9625-1918b4ab4e16@linaro.org>
Date: Wed, 17 May 2023 10:36:42 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 3/5] dt-bindings: net: add mac-address-increment option
Content-Language: en-US
To: Ivan Mikhaylov <fr0st61te@gmail.com>,
 Samuel Mendoza-Jonas <sam@mendozajonas.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org,
 Paul Fertser <fercerpav@gmail.com>
References: <20230509143504.30382-1-fr0st61te@gmail.com>
 <20230509143504.30382-4-fr0st61te@gmail.com>
 <6b5be71e-141e-c02a-8cba-a528264b26c2@linaro.org>
 <fc3dae42f2dfdf046664d964bae560ff6bb32f69.camel@gmail.com>
 <8de01e81-43dc-71af-f56f-4fba957b0b0b@linaro.org>
 <be85bef7e144ebe08f422bf53bb81b59a130cb29.camel@gmail.com>
 <5b826dc7-2d02-d4ed-3b6a-63737abe732b@linaro.org>
 <e6247cb39cc16a9328d9432e0595745b67c0aed5.camel@gmail.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <e6247cb39cc16a9328d9432e0595745b67c0aed5.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16/05/2023 13:47, Ivan Mikhaylov wrote:
hy this is property of the hardware. I
>>>> understand
>>>> that this is something you want Linux to do, but DT is not for
>>>> that
>>>> purpose. Do not encode system policies into DT and what above
>>>> commit
>>>> says is a policy.
>>>>
>>>
>>> Krzysztof, okay then to which DT subsystem it should belong? To
>>> ftgmac100 after conversion?
>>
>> To my understanding, decision to add some numbers to MAC address does
>> not look like DT property at all. Otherwise please help me to
>> understand
>> - why different boards with same device should have different
>> offset/value?
>>
>> Anyway, commit msg also lacks any justification for this.
>>
>> Best regards,
>> Krzysztof
>>
> 
> Krzysztof, essentially some PCIe network cards have like an additional
> *MII interface which connects directly to a BMC (separate SoC for
> managing a motherboard) and by sending special ethernet type frames
> over that connection (called NC-SI) the BMC can obtain MAC, get link
> parameters etc. So it's natural for a vendor to allocate two MACs per
> such a board with PCIe card intergrated, with one MAC "flashed into"
> the network card, under the assumption that the BMC should

Who makes the assumption that next MAC should differ by 1 or 2?

> automatically use the next MAC. So it's the property of the hardware as
> the vendor designs it, not a matter of usage policy.
> 
> Also at the nvmem binding tree is "nvmem-cell-cells" which is literally
> the same as what was proposed but on different level.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/Documentation/devicetree/bindings/nvmem?id=7e2805c203a6c8dc85c1cfda205161ed39ae82d5

How is this similar? This points the location of mac address on some NV
storage. You add fixed value which should be added to the Ethernet.

I might be missing the context but there is no DTS example nor user of
this property, so how can I get such?

Best regards,
Krzysztof


