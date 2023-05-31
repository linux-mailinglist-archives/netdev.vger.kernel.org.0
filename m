Return-Path: <netdev+bounces-6703-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 716497177A2
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:17:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8DC3281315
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:17:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5BB7A928;
	Wed, 31 May 2023 07:17:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73B7A922
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:17:17 +0000 (UTC)
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D31186
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:17:15 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f3bb61f860so6405027e87.3
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685517433; x=1688109433;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z6zuba+42QikFw+SZhZKKWqLdO5h+vgWV6OvnqfYZ4E=;
        b=MAROC3Itu8Rb30ZZq0XzoSrnOZCbUR3QtLFVln7CeB855WWkhgCy9BhAR4RLpy2Lq/
         2+ibMjW4MLMxKKr8a33dUE7NDughOA8CjTRxdxmau3Zmkrj19HIozkgZpp2Ug7vEMgNn
         lKqjxI6yqa3PyLgk4zU2QlxsZ15kWCoPZBWLFtufhowUPRmVb7Mq/4KJkiBaETp95fvH
         PzKRqnKeXbgtACIgh4vQ2gI8PPXDrO13RsErzSw0QSanRKGEqQ9Z14kNBWC+jpl8PO+q
         YyUO4Yf2uJy4/3sbKmhKr+pIWILuF5UGcnmGru6RvH9PHDDJflCJKuAsHnBXq8qbmRJQ
         a0pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685517433; x=1688109433;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z6zuba+42QikFw+SZhZKKWqLdO5h+vgWV6OvnqfYZ4E=;
        b=MlOoe7mGuTYN6lZungjrfjc/GglQmls0RE/uZGnEl5jgfX8Sav7IYiLjsefrlIEhAc
         9ArJq2jEMr3NzG3tdqOF8rIGT2edQkeI8VlwWJXAPZXVxeGr33GFWkSiJqtQKT6cyCge
         m7COhiz21QK5vc7/ZYmCLtTm3EfrplElIxCzrDsugKYPCQAjkeEM0UZLUNk8Bdy+IBhL
         wbd33B5lveE76Hgxnm4kOnUq7+W2D4s94FN6mKWFlYy6UMOU7JdsgHGInivz89rv6xSV
         Qzz/WCYX8MnwUmodPnz9lLJeHAmuqEQR9ABqrwm2niPUE/ljxNHdE4TyeR3sVIO6K6qI
         0MNA==
X-Gm-Message-State: AC+VfDzaMrOunIO17uSkHS46vKNEKfP5sevVWwWbDmOrHmKgOT9qPcMm
	jASeznhmrE9RF+KV4DeFfMfI3g==
X-Google-Smtp-Source: ACHHUZ618Kgo2wyP+qgnENoAmPPhleQ4byUvQhP0EDUGQg+dHaFEYOdVpCRWxkcAHMC0kg7h4pS2Zw==
X-Received: by 2002:a19:f608:0:b0:4dd:9f86:859d with SMTP id x8-20020a19f608000000b004dd9f86859dmr2152530lfe.13.1685517433467;
        Wed, 31 May 2023 00:17:13 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.199.204])
        by smtp.gmail.com with ESMTPSA id y1-20020aa7c241000000b0050bfeb15049sm5231685edo.60.2023.05.31.00.17.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 00:17:13 -0700 (PDT)
Message-ID: <38c9dfb3-e1c6-8a2d-993f-b6930bd0d8fa@linaro.org>
Date: Wed, 31 May 2023 09:17:11 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v3 1/2] dt-bindings: net: cdns,macb: Add
 rx-watermark property
Content-Language: en-US
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Pranavi Somisetty <pranavi.somisetty@amd.com>
Cc: pabeni@redhat.com, netdev@vger.kernel.org, edumazet@google.com,
 davem@davemloft.net, kuba@kernel.org, nicolas.ferre@microchip.com,
 michal.simek@amd.com, harini.katakam@amd.com, robh+dt@kernel.org,
 devicetree@vger.kernel.org, claudiu.beznea@microchip.com,
 radhey.shyam.pandey@amd.com, linux-kernel@vger.kernel.org,
 krzysztof.kozlowski+dt@linaro.org, git@amd.com
References: <20230530095138.1302-1-pranavi.somisetty@amd.com>
 <20230530095138.1302-2-pranavi.somisetty@amd.com>
 <20230530122559.o2nvvtkf2gddvjkz@krzk-bin>
In-Reply-To: <20230530122559.o2nvvtkf2gddvjkz@krzk-bin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 30/05/2023 14:25, Krzysztof Kozlowski wrote:
> On Tue, 30 May 2023 03:51:37 -0600, Pranavi Somisetty wrote:
>> watermark value is the minimum amount of packet data
>> required to activate the forwarding process. The watermark
>> implementation and maximum size is dependent on the device
>> where Cadence MACB/GEM is used.
>>
>> Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>
>> ---
>> Changes v2:
>> None (patch added in v2)
>>
>> Changes v3:
>> 1. Fixed DT schema error: "scalar properties shouldn't have array keywords".
>> 2. Modified description of rx-watermark to include units of the watermark value.
>> 3. Modified the DT property name corresponding to rx_watermark in
>> pbuf_rxcutthru to "cdns,rx-watermark".
>> 4. Modified commit description to remove references to Xilinx platforms,
>> since the changes aren't platform specific.
>> ---
>>  Documentation/devicetree/bindings/net/cdns,macb.yaml | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
> 
> Running 'make dtbs_check' with the schema in this patch gives the
> following warnings. Consider if they are expected or the schema is
> incorrect. These may not be new warnings.
> 
> Note that it is not yet a requirement to have 0 warnings for dtbs_check.
> This will change in the future.
> 
> Full log is available here: https://patchwork.ozlabs.org/patch/1787378
> 
> 
> ethernet@e000b000: ethernet-phy@0: Unevaluated properties are not allowed ('device_type', 'marvell,reg-init' were unexpected)
> 	arch/arm/boot/dts/zynq-parallella.dtb
> 

Unrelated warnings, can be ignored.

Best regards,
Krzysztof


