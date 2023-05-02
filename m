Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE7C6F4192
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 12:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbjEBK20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 06:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbjEBK1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 06:27:40 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14014EFA
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 03:26:17 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-94f0dd117dcso609141766b.3
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 03:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683023176; x=1685615176;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y+VcOBuPZ9Z6a80tOn//2hFrGUX4xkAkZldzuFsuPH8=;
        b=qr3J9ipcosMHDXmRvIvE5R9kCb45BRSvttmk05Vu3qiiyuL/xmn4oMezVu65IeVt6J
         g/rcpXX0b6ge20z1gQf+ht4R1mdAh+ED5/Xx0zIzM/jLGJLOsqMN0VahZV5elWK7vTIc
         cNcfHIthwFsgZePnnlEW2ASPZhmO03givYSvF1LUOq0FRyQpVhSKgmSe0q+AeEkXw+/X
         YplF35ms1Pn7Ue0A7PHpGMAn9znYPq1frA28NzVljMKNCTs23L+2aLEuiiIArPyMAb+w
         wIiYpw/satrJpNjLI2Nb2O3gd8qriOy1ZLtknvPI/qUVEh9acJrrydWFeOPG9yPCzXcn
         BTww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683023176; x=1685615176;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+VcOBuPZ9Z6a80tOn//2hFrGUX4xkAkZldzuFsuPH8=;
        b=Frb/O0GjQJnrLFukY0K+drRraolkH0rN4d2U0lgLeGhVHwdbZAneXcN4bYukMZnDbL
         rR8VdPKNdvZjSOUeVcNVYedYIFgf842a6YQgwhY2bqsN3DFCqf/i1RQQOrPNve4eAZmK
         7+w5zoK6u5VLRczMGqb8xuYUpe7fYCN6tMdOr2aHlx93a8eliopsCnz5kvvT4Gp6+8cd
         v3oLaEBje96t9F4GgK7Pqv3XXHEKuKzyZqZB5XXjLCwpL9DJEXnPxsTQeMy1iKbEGqjL
         A2qFBNHCKjRIGL93B5QSVVJxIog72tr9tj3/pmu856+d+221PO4RsYSuLUPVaYvg9/Og
         CBoA==
X-Gm-Message-State: AC+VfDxbLGJohnGpNYaROXHukDL7J+4e9fZ4p1QSFgPXA1ojtBPP8iUj
        RCuzc5+2eP79xwLbES1qj4DKQQ==
X-Google-Smtp-Source: ACHHUZ73eZoSNWO8O/kr6zY6yMMGXUMAmeVST3CQP9jC3dSuRhCXNIN06aw+TR22xaH76y2JRiEVuw==
X-Received: by 2002:a17:907:988:b0:94a:171:83b1 with SMTP id bf8-20020a170907098800b0094a017183b1mr13689748ejc.2.1683023176109;
        Tue, 02 May 2023 03:26:16 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:bafd:1283:b136:5f6a? ([2a02:810d:15c0:828:bafd:1283:b136:5f6a])
        by smtp.gmail.com with ESMTPSA id a13-20020a1709066d4d00b0094a9b9c4979sm15788738ejt.88.2023.05.02.03.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 03:26:15 -0700 (PDT)
Message-ID: <a5e18c4f-b906-5c9d-ec93-836401dcd3ea@linaro.org>
Date:   Tue, 2 May 2023 12:26:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Content-Language: en-US
To:     "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>
Cc:     "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
References: <20230308061223.1358637-1-sarath.babu.naidu.gaddam@amd.com>
 <5d074e6b-7fe1-ab7f-8690-cfb1bead6927@linaro.org>
 <MW5PR12MB559880B0E220BDBD64E06D2487889@MW5PR12MB5598.namprd12.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <MW5PR12MB559880B0E220BDBD64E06D2487889@MW5PR12MB5598.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/03/2023 14:52, Gaddam, Sarath Babu Naidu wrote:
> 
> 
>> -----Original Message-----
>> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> Sent: Tuesday, March 14, 2023 9:22 PM
>> To: Gaddam, Sarath Babu Naidu
>> <sarath.babu.naidu.gaddam@amd.com>; davem@davemloft.net;
>> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org
>> Cc: michal.simek@xilinx.com; radhey.shyam.pandey@xilinx.com;
>> netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-arm-
>> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Sarangi,
>> Anirudha <anirudha.sarangi@amd.com>; Katakam, Harini
>> <harini.katakam@amd.com>; git (AMD-Xilinx) <git@amd.com>
>> Subject: Re: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet:
>> convert bindings document to yaml
>>
>> On 08/03/2023 07:12, Sarath Babu Naidu Gaddam wrote:
>>> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>>>
>>> Convert the bindings document for Xilinx AXI Ethernet Subsystem from
>>> txt to yaml. No changes to existing binding description.
>>>
>>
>> (...)
>>
>>> +properties:
>>> +  compatible:
>>> +    enum:
>>> +      - xlnx,axi-ethernet-1.00.a
>>> +      - xlnx,axi-ethernet-1.01.a
>>> +      - xlnx,axi-ethernet-2.01.a
>>> +
>>> +  reg:
>>> +    description:
>>> +      Address and length of the IO space, as well as the address
>>> +      and length of the AXI DMA controller IO space, unless
>>> +      axistream-connected is specified, in which case the reg
>>> +      attribute of the node referenced by it is used.
>>
>> Did you test it with axistream-connected? The schema and description
>> feel contradictory and tests would point the issue.
> 
> Thanks for review comments. We tested with axistream-connected and
> did not observe any errors. Do you anticipate any issues/errors ?

Yes, I anticipate errors. What you wrote here looks incorrect based on
the schema.

Also, See also my further comments (or you ignored them?).

You can come many months after my review to ask about details, to be
sure I will forget the topic.


Best regards,
Krzysztof

