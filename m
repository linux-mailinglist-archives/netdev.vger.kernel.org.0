Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84BF6B9A2B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjCNPpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjCNPpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:45:38 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9412B19F26
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:45:09 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id fd5so29913198edb.7
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678808708;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9SCxm8iOPdeAsY0TXKkmz+2L6YqtA1AyHrADOlfOy2M=;
        b=MMo1OJO3T9Nigf+1XIH5iFNEn34rcy5D7wJEjCFOHC0ELhrtCGc1gCr5H0WcvRV2SV
         4VIFJIorbtD+zIdzgVpvL2gxAIsYEpFrObnIPjET/KGvx8opBDVvaze248ARPx8WXynr
         HjL/KAjUHXMop4VvxUAK08t0piegvCbRoQ//nwYHz4sXv9f2nxffibebOYMmU+yIwO5u
         occqSWuo6Pks4aJ6YD+exboTAcqFw/BUnMe/nQwPMR3ka3GuA0kJYJf08aSNquzbPw7x
         WNpbyfEFxUHpQXKQynNQJSHn6OHMsGPRHsrQ6AbXkx5iFA12MZAKm4HkbpdJXRrtSxVQ
         cF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678808708;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9SCxm8iOPdeAsY0TXKkmz+2L6YqtA1AyHrADOlfOy2M=;
        b=e3pSY06Ov8noKhRvJSeukuWsmNjy1BzTbV4TuhHBUokVxUwA+fbmATei6KMndn6I99
         3YCUIx30A9H5CILs9GSh421LZhaVvVeC+auZMdxK6MmEBwG0aJxVzgzmFvs5df1YiZQh
         3V8URXyP1CtEaBX6Bq2M9SUIvIHqTXGIHPgtO21+CeA05wwv9UicMyaJ0ZX7ngBOOc0W
         /RTCuPVN6eSeHrqmwG7c2dbdYsTs0xjs44ld0ancc0fbkMZlgsiwYP+TB1+iJ60qcJrN
         Kf5frnzd6pQbOdaoI8q83OWuIm9nYnidwsvATqLfgMldc6QfFtT2ufOHy66F/3KBYeBJ
         Oplg==
X-Gm-Message-State: AO0yUKX+hUGQmdoJLatZXwq5N0LD6HClxyT8xmkRMtGIVM6H3Xnz24UY
        8LjJNH3YxyAqvnicHdhXxo2/5Q==
X-Google-Smtp-Source: AK7set8h0VXGHjuQQFT+Mle8JiJQKMLwlt57Og4xS6JoJpZR63ktbj9TcT7GX03JVYWtZRtR9FLqag==
X-Received: by 2002:a17:907:1608:b0:92b:a511:c19e with SMTP id hb8-20020a170907160800b0092ba511c19emr3656998ejc.34.1678808707877;
        Tue, 14 Mar 2023 08:45:07 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:59be:4b3f:994b:e78c? ([2a02:810d:15c0:828:59be:4b3f:994b:e78c])
        by smtp.gmail.com with ESMTPSA id w23-20020a50d797000000b004fadc041e13sm1221690edi.42.2023.03.14.08.45.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 08:45:07 -0700 (PDT)
Message-ID: <1ee7386b-f42d-a182-f42d-c1f628fb4dda@linaro.org>
Date:   Tue, 14 Mar 2023 16:45:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next V3] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, radhey.shyam.pandey@amd.com,
        anirudha.sarangi@amd.com, harini.katakam@amd.com, git@amd.com
References: <20230308054408.1353992-1-sarath.babu.naidu.gaddam@amd.com>
 <20230308054408.1353992-2-sarath.babu.naidu.gaddam@amd.com>
 <20230313153532.2ed45ddf@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230313153532.2ed45ddf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 23:35, Jakub Kicinski wrote:
> On Wed, 8 Mar 2023 11:14:08 +0530 Sarath Babu Naidu Gaddam wrote:
>> There is currently no standard property to pass PTP device index
>> information to ethernet driver when they are independent.
>>
>> ptp-hardware-clock property will contain phandle to PTP clock node.
>>
>> Its a generic (optional) property name to link to PTP phandle to
>> Ethernet node. Any future or current ethernet drivers that need
>> a reference to the PHC used on their system can simply use this
>> generic property name instead of using custom property
>> implementation in their device tree nodes."
>>
>> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
>> Acked-by: Richard Cochran <richardcochran@gmail.com>
> 
> Rob, Krzysztof, any thoughts on this one?
> Looks like the v2 discussion was a bit inconclusive.

Anyway this did not implement changes I requested, so NAK.

Best regards,
Krzysztof

