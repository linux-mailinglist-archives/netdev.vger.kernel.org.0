Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36671657477
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 10:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbiL1JLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 04:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbiL1JLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 04:11:49 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F70B1D
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 01:11:48 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id g14so15977284ljh.10
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 01:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0iU0lEEi+NPvnevFz5v/nUd+nt+xlbi55hYpYeF8kv8=;
        b=ZlHAN2Qm4X+4bssNjlhgXwc8CTx1TnTGHd2REjIfdPyoL9XYLnoO+oTKZ/fYg1pl1z
         CvAkMwnXhkgNsRxLUHnxqCLoocXFQWx2oRKEKu+BfxTUhSZp9+k30JerybpCYMvryA3v
         yXSBC5GV9ZPP2pQKZVTkb6ERWgG69R2/C9hOItndq1BwS1E84D7Gm0Kd5Sa2xoGF/boQ
         98K6ZwvyeR+k5OZgL+E4SOSC+D5k8Ud0IUW7m042LRXXwONQ4b09Ec1MvyChTzf7HkNX
         QERdR8ekbUkw5pK3TLrJKviunp5SVGom7FGrukWB+F9T/aAKtw/Af/bNk+swft+on4fm
         KOEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0iU0lEEi+NPvnevFz5v/nUd+nt+xlbi55hYpYeF8kv8=;
        b=bDBppQk2hrGOYtf5mvzIDKB1Y/0o2R6E758MEQ1qYFiNu3fnngIJ2QnDi7AiNIuQdl
         xSqUO2nvANlbkY/mFBIc/GZo1rJ5Die3ZhNHDHSJInA/D4WGAat36k1mj7WdE2s5Qz5L
         Ga+EX7M/Emur3wsUnGKOtL7+zN3IwX0zI3ByqcFxXd3ISdjUwNf2i7B2c80T2A8eJOQA
         +acaxQVm2oTm+2nFjdoQGTAAW1eX9vfBbkT+rbP3tM7srYTFuCZLHfmOZXZfZ+KtPh5j
         2mJC6h7eP9aN901wSZVo0WTfxqZd9IMXIQzSArlv+N6U97RhUV40PipbKBQhID2yG/CP
         Gmbg==
X-Gm-Message-State: AFqh2kq1Uf8TMBwv2uJ3Ov7DHru/vnFF+4y5HodkEZvmAKjz/bf7tdi6
        /iLhIwBYOaktr2bd+kYCa5cYhg==
X-Google-Smtp-Source: AMrXdXsm9YuIsn0AG+RnQD6psOq8x79YYXxCot3n430np+AbdgZ3DeKWY9XoGdQCIRAveXW9tKysUA==
X-Received: by 2002:a05:651c:b0c:b0:27f:66ec:b57 with SMTP id b12-20020a05651c0b0c00b0027f66ec0b57mr12033879ljr.39.1672218706774;
        Wed, 28 Dec 2022 01:11:46 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id f2-20020a05651c02c200b0027fc4f018a8sm711703ljo.5.2022.12.28.01.11.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 01:11:46 -0800 (PST)
Message-ID: <9b098bf9-59d7-e58d-aba3-a8055af053c6@linaro.org>
Date:   Wed, 28 Dec 2022 10:11:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 5/9] dt-bindings: net: motorcomm: add support for
 Motorcomm YT8531
Content-Language: en-US
To:     yanhong wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
 <20221216070632.11444-6-yanhong.wang@starfivetech.com>
 <994718d8-f3ee-af5e-bda7-f913f66597ce@linaro.org>
 <134a2ead-e272-c32e-b14f-a9e98c8924ac@starfivetech.com>
 <c296cf6b-6c50-205d-d5f5-6095c0a6c523@linaro.org>
 <e03fb7bc-b196-bc8a-b396-fab8686d396b@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <e03fb7bc-b196-bc8a-b396-fab8686d396b@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/12/2022 04:23, yanhong wang wrote:
> 
> 
> On 2022/12/27 17:52, Krzysztof Kozlowski wrote:
>> On 27/12/2022 10:38, yanhong wang wrote:
>>>>
>>>> This must be false. After referencing ethernet-phy this should be
>>>> unevaluatedProperties: false.
>>>>
>>>>
>>>
>>> Thanks. Parts of this patch exist already, after discussion unanimity was achieved,
>>> i will remove the parts of YT8531 in the next version.
>>
>> I don't understand what does it mean. You sent duplicated patch? If so,
>> please do not... you waste reviewers time.
>>
>> Anyway this entire patch does not meet criteria for submission at all,
>> so please start over from example-schema.
>>
> 
> Sorry, maybe I didn't make it clear, which led to misunderstanding. Motorcomm Inc is also 
> carrying out the upstream of YT8531, and my patch will be duplicated and conflicted 
> with their submission. By communicating with the developers of Motorcomm Inc, the part 
> of YT8531 will be submitted by Motorcomm Inc, so my submission about YT8531 will be withdrawn.

Are they going to apply the feedback received for this series?

Best regards,
Krzysztof

