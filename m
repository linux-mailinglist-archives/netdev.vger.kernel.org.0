Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2131679371
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 09:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbjAXItM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 03:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbjAXItL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 03:49:11 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B93E05B
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 00:49:09 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y19so17495090edc.2
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 00:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DrMcycYJnXH0bsh3LC+gskNxVs1P28hKpETgVTZ5jVo=;
        b=MGr/zFi+TPhHoA5VQQDuoDgxl/X5xPuW/hrAouqW7ysj5MMyBMTQx9QBLuDofU8cCy
         PFmhEvKdBRXe5vJRTfTi1n3VgUY3OaNMugbhACR2ZOfMg1qvlG6WLh/Tt91CJ2W5IAJL
         2B4btlK8YgoTxyhJkhf2J+7/wZUIdffyWaXCUAuV4uU3opzCWsMTWW7QpKKfwwIfbFu9
         gB4IQiXVW81emySkvGeb1P+8BsTe2YsIMSk9xEDmd/Ox6686yTcAPd5VEYYM9SFkdhXX
         dvKgasRvGlpyfsh6v1vVhAGRDizS8DXfk3gxXQ8IfmbMfyoxWenr21N5hqQXd1NoWr0R
         KC9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DrMcycYJnXH0bsh3LC+gskNxVs1P28hKpETgVTZ5jVo=;
        b=uS3wE5qqNMJqk2oKjFE5xIvEOFdd0VR3DA2T1QVrIFVJTxmcSOXa8d8+KS4XnFdlXZ
         3s7ItF83ShU7SCNRUt2FVcXY0HX5I2x3UJpWzuqT8hPGOCOZrCiOGIEpzq3xgWeZALNg
         wcdmT6Km6UHU7Nv12rZH6MiMqJkgs5RuseYqwL1XdNIVsfLeGugY8I+ILvPkzXJnPRDs
         WVc6dda04u5viyQT6jM16B71r9NGP7FtODUJqShjqoJ/Sp2LHvezmlh6lZLFs73J6k8f
         tnBndogp5tg1MOviUqgyDDs1mzn6WhRmroyLhOztTlHsQYwjCJ4U0JbO3PPLx5Ur7qwq
         9ybw==
X-Gm-Message-State: AFqh2kpyktZZYvIVTRj5LxGmx0occ8C3wob+OtQNzlzjqQ1OU9EP5V4Q
        iteVnrRe1owMU6MQTSrS8fMK+A==
X-Google-Smtp-Source: AMrXdXsJYdNutXhS4r2NEeYCt6Ilqyx1Nb4Zl2WetY6CGWNeP4EJJUEF5jooKuyIvR6hXe25g1bBCA==
X-Received: by 2002:a05:6402:25cb:b0:49e:6bf1:5399 with SMTP id x11-20020a05640225cb00b0049e6bf15399mr22086723edb.8.1674550148197;
        Tue, 24 Jan 2023 00:49:08 -0800 (PST)
Received: from [192.168.118.20] ([87.116.164.245])
        by smtp.gmail.com with ESMTPSA id p7-20020aa7cc87000000b0049e08f781e3sm775045edt.3.2023.01.24.00.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 00:49:07 -0800 (PST)
Message-ID: <f8b6aca2-c0d2-3aaf-4231-f7a9b13d864d@linaro.org>
Date:   Tue, 24 Jan 2023 11:49:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 0/2] net: stmmac: add DT parameter to keep RX_CLK running
 in LPI state
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20230123133747.18896-1-andrey.konovalov@linaro.org>
 <Y88uleBK5zROcpgc@lunn.ch>
Content-Language: en-US
From:   Andrey Konovalov <andrey.konovalov@linaro.org>
In-Reply-To: <Y88uleBK5zROcpgc@lunn.ch>
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

Hi Andrew,

On 24.01.2023 04:04, Andrew Lunn wrote:
> On Mon, Jan 23, 2023 at 04:37:45PM +0300, Andrey Konovalov wrote:
>> On my qcs404 based board the ethernet MAC has issues with handling
>> Rx LPI exit / Rx LPI entry interrupts.
>>
>> When in LPI mode the "refresh transmission" is received, the driver may
>> see both "Rx LPI exit", and "Rx LPI entry" bits set in the single read from
>> GMAC4_LPI_CTRL_STATUS register (vs "Rx LPI exit" first, and "Rx LPI entry"
>> then). In this case an interrupt storm happens: the LPI interrupt is
>> triggered every few microseconds - with all the status bits in the
>> GMAC4_LPI_CTRL_STATUS register being read as zeros. This interrupt storm
>> continues until a normal non-zero status is read from GMAC4_LPI_CTRL_STATUS
>> register (single "Rx LPI exit", or "Tx LPI exit").
>>
>> The reason seems to be in the hardware not being able to properly clear
>> the "Rx LPI exit" interrupt if GMAC4_LPI_CTRL_STATUS register is read
>> after Rx LPI mode is entered again.
>>
>> The current driver unconditionally sets the "Clock-stop enable" bit
>> (bit 10 in PHY's PCS Control 1 register) when calling phy_init_eee().
>> Not setting this bit - so that the PHY continues to provide RX_CLK
>> to the ethernet controller during Rx LPI state - prevents the LPI
>> interrupt storm.
>>
>> This patch set adds a new parameter to the stmmac DT:
>> snps,rx-clk-runs-in-lpi.
>> If this parameter is present in the device tree, the driver configures
>> the PHY not to stop RX_CLK after entering Rx LPI state.
> 
> Do we really need yet another device tree parameter?

Indeed, there are quite a lot of them already (as this is complex and 
highly configurable device).

> Could
> dwmac-qcom-ethqos.c just do this unconditionally?

Never stopping RX_CLK in Rx LPI state would always work, but the power 
consumption would somewhat increase (in Rx LPI state). Some people do 
care about it.

> Is the interrupt
> controller part of the licensed IP, or is it from QCOM? If it is part
> of the licensed IP, it is probably broken for other devices as well,
> so maybe it should be a quirk for all devices of a particular version
> of the IP?

Most probably this is the part of the ethernet MAC IP. And this is quite 
possible that the issue is specific for particular versions of the IP.
Unfortunately I don't have the documentation related to this particular 
issue. And don't have the test results for different IP versions. It 
looks like testing Energy Efficient Ethernet (EEE) support isn't very 
common (yes, it is enabled by default in the stmmac driver, but if the 
ethernet switch the device is connected to doesn't support EEE then the 
issue wouldn't reveal).

Thanks,
Andrey

>     Andrew
