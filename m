Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B835FC766
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 16:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiJLOce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 10:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJLOcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 10:32:33 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7AECA8A9
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:32:31 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id x13so8004374qkg.11
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SH4UGOuYFZRjMjpUe6JiCqBFCXy39ifK+ZqrTxN5hbc=;
        b=h2tWoloLCif8btRNVAv/Kb99Ys0nSBWAsdEQBv245LFnhCgk3+HaPx5b6/4u30qaqc
         3oAtZ6i0r8pAwA6mGhMULAttwwqiEz6jBQtizIuuziZjGvoZS4RdauEHZqmqBizGuvPB
         FI+hp1RU8rPQRamMz24NeXBCIGqonYlFLzaYaRuYQGv7CDp5clNblWwTN5wg1mGX2CeC
         /FfFsnjm0Vh4kcQWjmEH5rwe6YfmYUkmjq0hB08kmbs0WuGjLZPm45nKNLd4leXDbYt4
         W4wL0UBPGSP7zC03yOpTfEGgEAHsPCesRgSH44F3E5SZxiorLTkr9vqu9mHiZRZPzWeC
         1Bzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SH4UGOuYFZRjMjpUe6JiCqBFCXy39ifK+ZqrTxN5hbc=;
        b=MoWilNay4hf8FtHhgmQMgJGM+KLcUv/oQNqx8qaQCWkq96FRD+n3xuTd7GyWW9V1AH
         oT+Db6dgqqrCxgLb8eHGW8MhZ7aIXFTN6mYxOPyUWAxafimKPf1EXuCnzwujxkDzwob9
         jP146L8RBumVmgY1YMTyiu5D3Gul8gYgCOp4ixh9Gu0yT+zBQwLv+hpFTUeYYKDYaOwn
         IHgWVglBuaeGdaXEuergxYauHTWVKhWNHYTyFbuP1WzwfU3Z9Cn7GKG5RJTOg7yV/7Xc
         +FOWCEf0I+yvEbYE6rGrX+NMrufSKyCzlI7wQz38TZbrCeJY161iSuNkja0fz5JCwQSK
         xlMA==
X-Gm-Message-State: ACrzQf3wmZ3mIUIH6enHkNBs+ExIcdV4idRX8Ydn5vRScfeaJfF0/Anv
        2dgMr8LI5gCEfpQXea1H0MnOZQ==
X-Google-Smtp-Source: AMsMyM561J8FH7HsWgP5RLTfNoeEdidaF/qKXJ1zmPKh6eF/XRTzCY/HasSxm6mPyaBCFY1GpNGHKQ==
X-Received: by 2002:a37:ad12:0:b0:6ee:8313:6199 with SMTP id f18-20020a37ad12000000b006ee83136199mr5398271qkm.570.1665585150355;
        Wed, 12 Oct 2022 07:32:30 -0700 (PDT)
Received: from [192.168.1.57] (cpe-72-225-192-120.nyc.res.rr.com. [72.225.192.120])
        by smtp.gmail.com with ESMTPSA id bq15-20020a05622a1c0f00b0039cb9b6c390sm2395117qtb.79.2022.10.12.07.32.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 07:32:29 -0700 (PDT)
Message-ID: <6f3088a8-284d-d71f-68d1-01a5412bfff2@linaro.org>
Date:   Wed, 12 Oct 2022 10:32:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH v3 1/3] dt-bindings: net: marvell,pp2: convert to
 json-schema
Content-Language: en-US
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     =?UTF-8?Q?Micha=c5=82_Grzelak?= <mig@semihalf.com>,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, upstream@semihalf.com
References: <20221011190613.13008-1-mig@semihalf.com>
 <20221011190613.13008-2-mig@semihalf.com>
 <ad015bc9-a6d2-491d-463a-42a6a0afbf75@linaro.org>
 <CAPv3WKcY=erFTBDLP1AhQa0+CP6C8KJinmKFEkR2xh4mHHv_aQ@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAPv3WKcY=erFTBDLP1AhQa0+CP6C8KJinmKFEkR2xh4mHHv_aQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/2022 16:34, Marcin Wojtas wrote:
>>
>> Keep the same order of items here as in list of properties
>>
>>> +
>>> +required:
>>> +  - compatible
>>> +  - reg
>>> +  - clocks
>>> +  - clock-names
>>> +
>>> +allOf:
>>> +  - $ref: ethernet-controller.yaml#
>>
>> Hmm, are you sure this applies to top-level properties, not to
>> ethernet-port subnodes? Your ports have phy-mode and phy - just like
>> ethernet-controller. If I understand correctly, your Armada Ethernet
>> Controller actually consists of multiple ethernet controllers?
>>
> 
> PP2 is a single controller with common HW blocks, such as queue/buffer
> management, parser/classifier, register space, and more. It controls
> up to 3 MAC's (ports) that can be connected to phys, sfp cages, etc.
> The latter cannot exist on their own and IMO the current hierarchy -
> the main controller with subnodes (ports) properly reflects the
> hardware.
> 
> Anyway, the ethernet-controller.yaml properties fit to the subnodes.
> Apart from the name. The below is IMO a good description:.

It also starts to look a bit like a switch (see bindings/net/dsa).

> 
>> If so, this should be moved to proper place inside patternProperties.
>> Maybe the subnodes should also be renamed from ports to just "ethernet"
>> (as ethernet-controller.yaml expects), but other schemas do not follow
>> this convention,
> 
> ethernet@
> {
>     ethernet-port@0
>     {
>      }
>      ethernet-port@1
>      {
>      }
> }
> 
> What do you recommend?

Yes, keep it like this and reference the ethernet-controller.yaml in
each port.

Best regards,
Krzysztof

