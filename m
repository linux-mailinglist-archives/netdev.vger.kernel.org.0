Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CEE658E32
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 16:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiL2PAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 10:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiL2PAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 10:00:45 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4657EB9C
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 07:00:44 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id 1so27825985lfz.4
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 07:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y8T3Cnhk+uutaNaK4ajOfaW3pnDHfKYJwhA+wD1OiWw=;
        b=TdoiO2RoNC2zxTU3D8pbHWFty1hKb8ldMAdoqf9YSFJSBcpXkjpgakhaCLJ35cp2VX
         g4p3TpdVJpObDruBJ75yhshf0YC6GyM22GfPfUgYmlNTw76qx9uNfQGi/WvzrwppeNJx
         CKXenA7g06ulD9DxyggRgdPrWz4FYbA7+gh2U+JPVY96ADH7j98e+vy4zkiGcCiZKDGT
         3RfrobGtTY/Z64MRZEvCSj51+ed56nfFhOJbRWW4w/xybvAYFczplb2mh6nxNsSdWZJe
         OGLDvfHEteWCa+cx1ASU+lWZ0LvvmX3a/IeA+OPGaHHkOPsbL2f4hIsV4IvMrouYFnZS
         7SHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y8T3Cnhk+uutaNaK4ajOfaW3pnDHfKYJwhA+wD1OiWw=;
        b=RG55qDx5i13kArMyp1urj4mCpgaqNFxM57DIhRIJ8Bw/Cgbh16Juj4zxI4Kbpr1FyS
         g7UauhTvsjqiSw+r+5dcPHGg9cRMYALoLhceKI3YB1GV51SmZUg6eYkKgKbYU3boExt2
         sQWKRamVoiET0PMi7UiXt1K/mmrmzrVNkfzPLkDYslhYCshShHuHZKobsMOFtJFrK1cO
         eL4GAwsQsAIjLMYuLxLDPEUp3eBv4OGZi+BbaOqtqM7MWpXCt1IEtHSmVvLfngPgvs7p
         7xWAFEiCeu7AyiHsuITCUux10Rwy5u0qPLk8oRHJ38CcyNXBE4ZGVXgx70QmkA4XYm98
         mQKg==
X-Gm-Message-State: AFqh2kqBQ1JCm7bFeZrsn0yPv/zr5eez5RlIDO9Qpp+aDxyUr0ZrPrcE
        NkOklmVYWRVv8mhyRMd/2zWHHg==
X-Google-Smtp-Source: AMrXdXtB+1vKWx3NpqukhYH3EN1EzdtM4nON7C728CEN/RHUhzUQyJz5672v4lVrWFePXhZTwv+6Zg==
X-Received: by 2002:a05:6512:2030:b0:4bc:df73:4459 with SMTP id s16-20020a056512203000b004bcdf734459mr7514900lfs.29.1672326042504;
        Thu, 29 Dec 2022 07:00:42 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id b8-20020a056512070800b004cb00bf6724sm2230270lfs.143.2022.12.29.07.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 07:00:41 -0800 (PST)
Message-ID: <330942f7-6f53-cc7b-2b91-71b8bec6fe4e@linaro.org>
Date:   Thu, 29 Dec 2022 16:00:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3] dt-bindings: net: marvell,orion-mdio: Fix examples
Content-Language: en-US
To:     =?UTF-8?Q?Micha=c5=82_Grzelak?= <mig@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        andrew@lunn.ch, chris.packham@alliedtelesis.co.nz,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        upstream@semihalf.com, mw@semihalf.com, mchl.grzlk@gmail.com
References: <20221229142219.93427-1-mig@semihalf.com>
 <8e4ec6b0-63cf-c086-c00e-5b4e8a2b2d25@linaro.org>
 <CADcojVOt+pWSZkVdOSE15HmdfFSZWNDUkEA1hNvn62vGAYjFsg@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CADcojVOt+pWSZkVdOSE15HmdfFSZWNDUkEA1hNvn62vGAYjFsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/12/2022 15:51, Michał Grzelak wrote:
> Hi Krzysztof,
> 
> On Thu, Dec 29, 2022 at 3:30 PM Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org> wrote:
>>
>> On 29/12/2022 15:22, Michał Grzelak wrote:
>>> As stated in marvell-orion-mdio.txt deleted in commit 0781434af811f
>>> ("dt-bindings: net: orion-mdio: Convert to JSON schema") if
>>> 'interrupts' property is present, width of 'reg' should be 0x84.
>>> Otherwise, width of 'reg' should be 0x4. Fix 'examples:' and add
>>> constraints checking whether 'interrupts' property is present
>>> and validate it against fixed values in reg.
>>>
>>> Signed-off-by: Michał Grzelak <mig@semihalf.com>
>>
>> This is a friendly reminder during the review process.
>>
>> It looks like you received a tag and forgot to add it.
>>
>> If you do not know the process, here is a short explanation:
>> Please add Acked-by/Reviewed-by/Tested-by tags when posting new
>> versions. However, there's no need to repost patches *only* to add the
>> tags. The upstream maintainer will do that for acks received on the
>> version they apply.
>>
>> https://elixir.bootlin.com/linux/v5.17/source/Documentation/process/submitting-patches.rst#L540
>>
>> If a tag was not added on purpose, please state why and what changed.
> 
> Deletion of tag wasn't on purpose, it was done by accident. Would you
> like me to resend the patch with it being added, or leave it as is?

No need, I added it here, so will be picked-up by maintainers.

Best regards,
Krzysztof

