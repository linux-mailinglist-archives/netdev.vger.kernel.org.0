Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24045F9CBB
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 12:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiJJKZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 06:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbiJJKZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 06:25:41 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA9B1C921
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 03:25:39 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id i12so6875309qvs.2
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 03:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u+N89mxsc/JUe7eiDPiKwGOnwUdVybdhvrZNerGwSDc=;
        b=F5bHAqDu8AO1e9Gam/y8eip+0cMkACwvvgY91cUz55UgFU/En6nabJu1ob7oM8MVQ/
         pU8AITBkk3kUpEXOG2AAF0NDwDPdAG1ZQF643v2SbxZcrO5C+pB7D2j34W0kyjIlW4Mg
         /yR4GzYgTHlp5OI6vX+Y4sBSa01lryWu1ygcZwbDJSc0qme5K09ilQnS3hf11RilTiFT
         Af3Lz2eRL9DhxZLJwGWPj8QQ8Z/hdtDY5bDBUnPFdf/A4+P9e41ZgDtgfhHywttpCo5U
         PPz8aPIEaCvuwt/JTk3ZGSX+AGNBghMJoymGqjRxSYeQ6jRxv7ybWWktZnswcM1uKtmT
         oc7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u+N89mxsc/JUe7eiDPiKwGOnwUdVybdhvrZNerGwSDc=;
        b=XrxlUtpKQFOeE4CP8ih6v+bBrIgiFyd4fsM4MB8gF4Ws+VOhRlOXCYnOoV8WDrVTNr
         BvmmxKApqwG3Y597OGqPTI8qjh92SzDmLJgS76sQ0dwhmRxDnlDarTI1QcnwcI4fm+rJ
         JK/tGPpXQ9tnRWXftHg5UyGGdKxG18/Yw8WS3gd2zH0ouIX5+/J5qAtF/9wnWfb6pOjw
         /eLA9Jmw0EiaqVTWofa8KIJPbFn0ojGlXW3P2yxBMJvdKn3Gq9r6+45WOJCFGSrmjNrH
         AW1z6fCXQLQ1jHw6WnFGILFswK+NL7t+486jWe/6tlnbX0w4/1E0SauBRSSfT/p6FwD5
         uDVQ==
X-Gm-Message-State: ACrzQf2IsF01g+D8ng+6r1RzRhqy2/r2ryU7fcL7hUxmpy0fb1qYHhyk
        tYW6M/9roBCpKi7jEr/Qy+aq6w==
X-Google-Smtp-Source: AMsMyM7Yb4bMOj+1yulbBq8AnnFL9mpP/q0hxk8Hua95tYc6z1m3kVEEoaWoktdQ5Wui1BGFbrGVpQ==
X-Received: by 2002:a05:6214:20e3:b0:4b1:d5d5:8e85 with SMTP id 3-20020a05621420e300b004b1d5d58e85mr14681441qvk.69.1665397537999;
        Mon, 10 Oct 2022 03:25:37 -0700 (PDT)
Received: from [192.168.1.57] (cpe-72-225-192-120.nyc.res.rr.com. [72.225.192.120])
        by smtp.gmail.com with ESMTPSA id q30-20020a05620a2a5e00b006ecb3694163sm2924536qkp.95.2022.10.10.03.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 03:25:37 -0700 (PDT)
Message-ID: <551ca020-d4bb-94bf-7091-755506d76f58@linaro.org>
Date:   Mon, 10 Oct 2022 06:23:24 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jerry Ray <jerry.ray@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221008225628.pslsnwilrpvg3xdf@skbuf>
 <e49eb069-c66b-532c-0e8e-43575304187b@linaro.org>
 <20221009222257.f3fcl7mw3hdtp4p2@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221009222257.f3fcl7mw3hdtp4p2@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/10/2022 18:22, Vladimir Oltean wrote:
> On Sun, Oct 09, 2022 at 05:20:03PM +0200, Krzysztof Kozlowski wrote:
>> On 09/10/2022 00:56, Vladimir Oltean wrote:
>>>>  
>>>> +MICROCHIP LAN9303/LAN9354 ETHERNET SWITCH DRIVER
>>>> +M:	Jerry Ray <jerry.ray@microchip.com>
>>>> +M:	UNGLinuxDriver@microchip.com
>>>> +L:	netdev@vger.kernel.org
>>>> +S:	Maintained
>>>> +F:	Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml
>>>> +F:	drivers/net/dsa/lan9303*
>>>> +
>>>
>>> Separate patch please? Changes to the MAINTAINERS file get applied to
>>> the "net" tree.
>>
>> This will also go via net tree, so there is no real need to split it.
> 
> I meant exactly what I wrote, "net" tree as in the networking tree where
> fixes to the current master branch are sent:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git, or in
> other words, not net-next.git where new features are sent:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git

Ah, but how it can go to fixes? It has invalid path (in the context of
net-fixes) and it is not related to anything in the current cycle.

Best regards,
Krzysztof

