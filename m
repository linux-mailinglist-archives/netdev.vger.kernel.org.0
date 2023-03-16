Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEF26BCE56
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 12:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjCPLgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 07:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjCPLgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 07:36:09 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C65DC6433
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 04:35:48 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id eg48so6182886edb.13
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 04:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678966546;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1rJrmS0fAGcKERGUg+zMb/pgvpZMkI4IZdMSp2WXIOY=;
        b=L2lPCgZh08p5G/m9Ds1die1D8hmsjqruS+G8lxFQH3R6ekNdBgt+zVHUldZM0+YBla
         2qf+eTErQ7YEi6uwwhxA344ZoOshJtLWfbGbZIUSyjgjVARxWsH95qIz0dTlMWw7U8tX
         W+xZZYH2OWR0eTn2MHlvJHX1BxROForMNLS70M6aVTiAJAPfErg/fRBdOXN5Tud9o53M
         qN7XtUK/v0AxcRcP9NINLXMSAjzO/92NzJkuXHmvXumXTwRgjYkq9ry7xGtuJpQZwyf0
         mS3k0KHd25506W8x9IvYn52vVDR4T5Jfp9qckFFlaihNfFPFDlldQf1s4N61j/33QZdE
         eZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678966546;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1rJrmS0fAGcKERGUg+zMb/pgvpZMkI4IZdMSp2WXIOY=;
        b=Mrbt5psf/XzOehNPfUvCVLpM/oNZ1oZY3ET+Hs30MXBnBN+bI3gmGYwjPdI46gbp39
         FgXKEG2F535aYllR8gyIAOL07h3skmN2Ii5SMwNgisYgcEw7runVEKDDUXS/8ahX/QES
         yc3UJWc3XRPjkyEe7TUUwFaLfoUUcjT6gHdLZVg952dVwMCsIxPuzAWiebEL6C962PS0
         eQ6gUsSgnweSCp5H+TVtMekIER2KGQtmPpoE7r1O17h5MRttZpA5kLznILhBzdwtYzEt
         64CJp4wPlXJ8ZOOOKI9ieCllIe5sBUnC56sEzpo6xOwyG48g/cD0stbpptgoNHOoUZxu
         +3yQ==
X-Gm-Message-State: AO0yUKU5+OomiA3msc6N/rw2KWGGJKmaDlWfyY53vCz4i0Y+VYvlzbwa
        gRB+7/jypMCJGEnj9dy72dtp6JI/bZktCE3ZHpA=
X-Google-Smtp-Source: AK7set+L96y4SUPx/KRqRAwTHybgvhAlOOMGD/TPuy6dnDpvs7HyqzfePsld4tlxWGomtSMEDPiuVg==
X-Received: by 2002:a17:907:7ba6:b0:8af:ef00:b853 with SMTP id ne38-20020a1709077ba600b008afef00b853mr11405773ejc.73.1678966546515;
        Thu, 16 Mar 2023 04:35:46 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id vs6-20020a170907a58600b0092bef8ad0basm3687886ejc.183.2023.03.16.04.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 04:35:46 -0700 (PDT)
Message-ID: <d6b4a24b-1624-a500-2675-c74c6a8b243e@linaro.org>
Date:   Thu, 16 Mar 2023 12:35:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next V3] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Content-Language: en-US
To:     "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Cc:     "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
        "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
References: <20230308054408.1353992-1-sarath.babu.naidu.gaddam@amd.com>
 <20230308054408.1353992-2-sarath.babu.naidu.gaddam@amd.com>
 <c2773010-2367-ba20-e0fa-2e060cb95128@linaro.org>
 <MW5PR12MB55988A6BACF98A29391CF64D87BC9@MW5PR12MB5598.namprd12.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <MW5PR12MB55988A6BACF98A29391CF64D87BC9@MW5PR12MB5598.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2023 11:53, Gaddam, Sarath Babu Naidu wrote:
> 
> 
>> -----Original Message-----
>> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> Sent: Tuesday, March 14, 2023 9:16 PM
>> To: Gaddam, Sarath Babu Naidu
>> <sarath.babu.naidu.gaddam@amd.com>; davem@davemloft.net;
>> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>> robh+dt@kernel.org; richardcochran@gmail.com
>> Cc: krzysztof.kozlowski+dt@linaro.org; netdev@vger.kernel.org;
>> devicetree@vger.kernel.org; linux-kernel@vger.kernel.org;
>> yangbo.lu@nxp.com; Pandey, Radhey Shyam
>> <radhey.shyam.pandey@amd.com>; Sarangi, Anirudha
>> <anirudha.sarangi@amd.com>; Katakam, Harini
>> <harini.katakam@amd.com>; git (AMD-Xilinx) <git@amd.com>
>> Subject: Re: [PATCH net-next V3] dt-bindings: net: ethernet-controller:
>> Add ptp-hardware-clock
>>
>> On 08/03/2023 06:44, Sarath Babu Naidu Gaddam wrote:
>>> There is currently no standard property to pass PTP device index
>>> information to ethernet driver when they are independent.
>>>
>>> ptp-hardware-clock property will contain phandle to PTP clock node.
>>>
>>> Its a generic (optional) property name to link to PTP phandle to
>>> Ethernet node. Any future or current ethernet drivers that need a
>>> reference to the PHC used on their system can simply use this generic
>>> property name instead of using custom property implementation in
>> their
>>> device tree nodes."
>>>
>>> Signed-off-by: Sarath Babu Naidu Gaddam
>>> <sarath.babu.naidu.gaddam@amd.com>
>>> Acked-by: Richard Cochran <richardcochran@gmail.com>
>>> ---
>>>
>>> Freescale driver currently has this implementation but it will be good
>>> to agree on a generic (optional) property name to link to PTP phandle
>>> to Ethernet node. In future or any current ethernet driver wants to
>>> use this method of reading the PHC index,they can simply use this
>>> generic name and point their own PTP clock node, instead of creating
>>> separate property names in each ethernet driver DT node.
>>
>> Again, I would like to see an user of this. I asked about this last time and
>> nothing was provided.
>>
>> So basically you send the same thing hoping this time will be accepted...
> 
> Apologies for miscommunication. As of now, we see only freescale driver
> has this type of implementation but with different binding name. we do 

Then the freescale binding (and driver) should be adjusted to use new
property. Deprecate then the old one.



Best regards,
Krzysztof

