Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C5067D7EE
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 22:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbjAZVvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 16:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjAZVvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 16:51:40 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82EFFF25
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 13:51:38 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id mg12so8842695ejc.5
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 13:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MqXh2+E8iJs7wo/kixnLmyAo4vCoE9jx2NshAMdQdhk=;
        b=bKaK/ctjLrTftCgy6iuhFHsvkcxrlzWwRUDo+YNkZlibgyNBd2PKwG6zJkf3v1F6Ee
         KbqJ/numtWHVrfY38qrB76My9TGXMDGXD5OrC1Yi5JreUJSsCyV+9vjM1bF/ylYRLdGO
         sm0psMEJl+tp5dp6TM9jdaTvVeyAS5+U2ZxI3qIkJflUNAkittA7cRR0u7VfvsNMn8ct
         Vk6HBlOQC7jJTSY7LTvt/nt+ZJXIzuHUY5rdEBN3VswOrrzS7zfjnRwfAYUGV1keT3It
         kb5BDwZgphSlRvIVFzF5EmIU2vZoVIwHvG/e/ZimszkAkVBTLQU/va0sFO1UehBIy8Ol
         gy8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MqXh2+E8iJs7wo/kixnLmyAo4vCoE9jx2NshAMdQdhk=;
        b=KQ/fxCMVIEI1NBG3BmZwLfmfh7yXJem1JwB7ajZlx0m3I27OP3zVm8Ls8pms1bBsgh
         j3UZyo70B0jhyrEct1xokkeJAdfqTxrtsU9Gynhjg+k6GlNVyUe0iwmEh9o7lT5VEph3
         8EPAw3ZEoCIPMhDV4S/V2MuyqAMGc5ioAAbfseWNtC0YWkdWsmIxzT8iVApErw6nrc2C
         gHqjw70cKM+wqI1rdm916HU2lWSpIbmAUv/x4xpRgi4xdNgowRbQJ8Z3QAV5Fm/wf3fE
         wWYOSRuAV/X/ibQqJgrjD9TPaaQMw/fwc8tumdekxTN0/YbkeP7zBWFDHuL/qBj45P87
         nVEg==
X-Gm-Message-State: AFqh2kpFQunclsSO9m5d4N0TTAff4Eoa4/X3Yi4CDE9E53E00a5Nw6J4
        UTPZtOIrkOQyMyKp30spmO2YNA==
X-Google-Smtp-Source: AMrXdXs+sAI5Gz3WB8RUn1xMA8MppwykyLLgQIlCxXNtxLmH0SYOO77LdlAY9aiwg7Khf80nqTd4gg==
X-Received: by 2002:a17:907:75e7:b0:871:3919:cbea with SMTP id jz7-20020a17090775e700b008713919cbeamr38276063ejc.54.1674769897548;
        Thu, 26 Jan 2023 13:51:37 -0800 (PST)
Received: from [192.168.118.20] ([87.116.162.186])
        by smtp.gmail.com with ESMTPSA id ck17-20020a170906c45100b0082000f8d871sm1135489ejb.152.2023.01.26.13.51.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 13:51:37 -0800 (PST)
Message-ID: <2d0f82c8-231b-7ad2-0366-a1a25f71da8f@linaro.org>
Date:   Fri, 27 Jan 2023 00:51:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 0/2] net: stmmac: add DT parameter to keep RX_CLK running
 in LPI state
To:     Rob Herring <robh@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        alexandre.torgue@foss.st.com, peppe.cavallaro@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230123133747.18896-1-andrey.konovalov@linaro.org>
 <Y88uleBK5zROcpgc@lunn.ch> <f8b6aca2-c0d2-3aaf-4231-f7a9b13d864d@linaro.org>
 <Y8/mrhWDa6DuauZY@lunn.ch> <20230125191453.GA2704119-robh@kernel.org>
Content-Language: en-US
From:   Andrey Konovalov <andrey.konovalov@linaro.org>
In-Reply-To: <20230125191453.GA2704119-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.01.2023 22:14, Rob Herring wrote:
> On Tue, Jan 24, 2023 at 03:09:50PM +0100, Andrew Lunn wrote:
>>>> Could
>>>> dwmac-qcom-ethqos.c just do this unconditionally?
>>>
>>> Never stopping RX_CLK in Rx LPI state would always work, but the power
>>> consumption would somewhat increase (in Rx LPI state). Some people do care
>>> about it.
>>>
>>>> Is the interrupt
>>>> controller part of the licensed IP, or is it from QCOM? If it is part
>>>> of the licensed IP, it is probably broken for other devices as well,
>>>> so maybe it should be a quirk for all devices of a particular version
>>>> of the IP?
>>>
>>> Most probably this is the part of the ethernet MAC IP. And this is quite
>>> possible that the issue is specific for particular versions of the IP.
>>> Unfortunately I don't have the documentation related to this particular
>>> issue.
>>
>> Please could you ask around.

I am on it, but it will take time.

>> Do you have contacts in Qualcomm?
>> Contacts at Synopsys?

In Qualcomm only I am afraid.

>> Ideally it would be nice to fix it for everybody, not just one SoC.
> 
> Yes, but to fix for just 1 SoC use the SoC specific compatible to imply
> the need for this. Then only a kernel update is needed to fix, not a
> kernel and dtb update.

That's good point! Thanks!

I've just posted such 1 SoC only version:
https://lore.kernel.org/lkml/20230126213539.166298-1-andrey.konovalov@linaro.org/T/#t
In case this is a more proper way to go.

> Rob

Thanks,
Andrey
