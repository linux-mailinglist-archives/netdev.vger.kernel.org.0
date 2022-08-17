Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014CA596904
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 07:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238640AbiHQFus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 01:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238793AbiHQFuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 01:50:32 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1EA7C53A
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 22:50:31 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id e15so17769947lfs.0
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 22:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=7axt1sg0+BERbIoi6l8zBsfKL7pIMpF85l/HPXUT3Qs=;
        b=kzcwKcUMsWLN2TJs6vbxvZWrP0W+d+JD66BJ/Wcl7J++ISXPqdXHnVn2N+c7aMl3J9
         CCIcMLDn/AalOgnPc2+kexOQqTYWhoK6TXgoKnT281NhIVagd9EDRbikW+Bte9b6x58a
         SE3z3cnpCRHa5/ibnBD0MbJKfbfkcjVo1TeKWtkLwAu9RUP2KIxEaatTJX/z4znDsPKN
         MRLzvW2GDxRtUxomKlr3YqPqZGnsKoW0ELG19Bq8n693cHdFarae4vvWJzKu0Eq3OiFq
         imr5zj5ILO8rn0px+ybpZ34TmFhvybZdxFew0nncNm5MSgNh4HYfaA95LJdqaCg9FY5o
         nN7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=7axt1sg0+BERbIoi6l8zBsfKL7pIMpF85l/HPXUT3Qs=;
        b=JUiYsZkwd3VrbS0BxsUBNpJ6G7ulkOd3kspYFvJT2V3ttrMshU8octcx2Q7Z2ZFwNK
         dV1OgcJquDnlmfO6RtpH9/oK7C6LVdXL0XDF/PFd0xi/kc+g30FBLEltNqzjtB/YugP0
         /54UVVPuA1eTkdZWgIHHnQN9AZ8raI4z8ytovWnJCWu5u7JOSZIwEON1HLrmSa3p5+9f
         dMyoFMyvhIGNpU6Y/T72blZ1gycyW2gxX0PTz1J7pHo3lyyIHchIr5FvQ7a4n26kgYs2
         PjZqPwfiLw1F1q8Sdfy0Iy8WRN8mddOLzHs/GftRW5S20es3DYOz9K5lBh0dGRIm3pmC
         sKWA==
X-Gm-Message-State: ACgBeo0U97aEUXGqWPwxPEG14WskHL5iDVGIZeSM6J/b02DPBYtVSGfO
        pNOG7+6LqQLOXzPiKIqvDqGzBw==
X-Google-Smtp-Source: AA6agR7Ilk9IEC0d+v6/FsaxUTEgsVYB2Nsu2MwH+4y520DbtFacfApXYjQTDQJsBT/KZb/3MhemIg==
X-Received: by 2002:a05:6512:3f14:b0:47d:e011:f19b with SMTP id y20-20020a0565123f1400b0047de011f19bmr7765361lfa.427.1660715429296;
        Tue, 16 Aug 2022 22:50:29 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ae:539c:1b1c:14b7:109b:ed76? (d15l54h48cw7vbh-qr4-4.rev.dnainternet.fi. [2001:14bb:ae:539c:1b1c:14b7:109b:ed76])
        by smtp.gmail.com with ESMTPSA id w14-20020ac2598e000000b0048b037fb5d6sm1577168lfn.85.2022.08.16.22.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 22:50:28 -0700 (PDT)
Message-ID: <9c331cdc-e34a-1146-fb83-84c2107b2e2a@linaro.org>
Date:   Wed, 17 Aug 2022 08:50:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v4 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J7200 CPSW5G
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>,
        krzysztof.kozlowski+dt@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org, linux@armlinux.org.uk,
        vladimir.oltean@nxp.com, grygorii.strashko@ti.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com
References: <20220816060139.111934-1-s-vadapalli@ti.com>
 <20220816060139.111934-2-s-vadapalli@ti.com>
 <79e58157-f8f2-6ca8-1aa6-b5cf6c83d9e6@linaro.org>
 <31c3a5b0-17cc-ad7b-6561-5834cac62d3e@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <31c3a5b0-17cc-ad7b-6561-5834cac62d3e@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/08/2022 08:14, Siddharth Vadapalli wrote:

>>> -      port@[1-2]:
>>> +      "^port@[1-4]$":
>>>          type: object
>>>          description: CPSWxG NUSS external ports
>>>  
>>> @@ -119,7 +120,7 @@ properties:
>>>          properties:
>>>            reg:
>>>              minimum: 1
>>> -            maximum: 2
>>> +            maximum: 4
>>>              description: CPSW port number
>>>  
>>>            phys:
>>> @@ -151,6 +152,18 @@ properties:
>>>  
>>>      additionalProperties: false
>>>  
>>> +if:
>>
>> This goes under allOf just before unevaluated/additionalProperties:false
> 
> allOf was added by me in v3 series patch and it is not present in the
> file. I removed it in v4 after Rob Herring's suggestion. Please let me
> know if simply moving the if-then statements to the line above
> additionalProperties:false would be fine.

I think Rob's comment was focusing not on using or not-using allOf, but
on format of your entire if-then-else. Your v3 was huge and included
allOf in wrong place).

Now you add if-then in proper place, but it is still advisable to put it
with allOf, so if ever you grow the if-then by new entry, you do not
have to change the indentation.

Anyway the location is not correct. Regardless if this is if-then or
allOf-if-then, put it just like example schema is suggesting.

Best regards,
Krzysztof
