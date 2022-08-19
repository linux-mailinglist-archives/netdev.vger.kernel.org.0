Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCD5599B3A
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 13:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348439AbiHSLho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 07:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348411AbiHSLhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 07:37:42 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF35EF997C
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 04:37:40 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id b38so3149757lfv.4
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 04:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=lHgy8XrEK9EH8gMtXevMZ8OhZpXuFAeH18nZ4CtlnC0=;
        b=JsXFK+7tESqFY4cci/SkxtZOAcPIBWE3n4jatcpJefKHiKqYECX12eyujyt4Y2mK8Q
         kNid1iKfa8yy6jx5UpG1yFsBQ06r9bXlP1JxaSahMSMSHi08qaHrMULxTP3SkxnHMeLQ
         KLe6BnLE1nKX8B+AQoQjlddQic+DzaHDTWMTSm3r4Vpv9G7M6E9aLzLyTg/JKg7huXDt
         8dEF5lKGv4uddEWErzzzDyaAFk3ekHA7mo4QYtryGdfULSQlPzfcaxKkNH9KBLQixNPZ
         2+3F4nJ+lq+xRtYJLiJS8Yqq3uChIlB5Ju/XpqdLE8t5t2NSSdURgPIqDHH9JzQNULFk
         zDLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=lHgy8XrEK9EH8gMtXevMZ8OhZpXuFAeH18nZ4CtlnC0=;
        b=yNVmkLpAAVJGvjhBP+UfJ4wjvPBKfbixpPU626NKuwOMqxv3Ok/VVjAMZCm/6Lw/D5
         RXQZ9R2RhYzSmJ/RHtnMunI+RalwrizhfVHaGGVou1fsUuyP+qQPUFoFJ1NRQnvPq1WM
         7JKjMnNRk/HETA/aLXITFuvWnNPtCqOqKHsIUYMEF2cxvp6qOKxKnhL9QMCOHrDSVPpg
         FqfEjNsDniW5elai0+/49BpBNFIgdpJYe/RJ/BBdMG5SPPkuLv3nZ6SLzdettM4SxpXS
         Lhj9DPwqARs4adJLLkDRgO1Qk0HDnfy+NdEoSHtqCZLLVIUe5+Wayyqgkshk1GvpFukH
         XDeQ==
X-Gm-Message-State: ACgBeo2VzrRHTebtZKuXohDGT1hN0fC8goyMdomL2GWytrgbRl5Rfwhk
        5c1vVhR182UpA4Yx0H4ST99aYw==
X-Google-Smtp-Source: AA6agR5Te7ahz2V+cHlZ9H+U9DJXNEpjlMP2ULm4k3InUeRNY/fBPFAy8b7dcgKzGTVBiqC/s74I2w==
X-Received: by 2002:a05:6512:2589:b0:48a:f56d:2912 with SMTP id bf9-20020a056512258900b0048af56d2912mr2573221lfb.370.1660909059296;
        Fri, 19 Aug 2022 04:37:39 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ac:e5a8:ef73:73ed:75b3:8ed5? (d1xw6v77xrs23np8r6z-4.rev.dnainternet.fi. [2001:14bb:ac:e5a8:ef73:73ed:75b3:8ed5])
        by smtp.gmail.com with ESMTPSA id v15-20020ac2560f000000b0048af4dc964asm610445lfd.73.2022.08.19.04.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 04:37:38 -0700 (PDT)
Message-ID: <9ec575ba-784d-74f7-8861-da2f62fe0773@linaro.org>
Date:   Fri, 19 Aug 2022 14:37:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: tja11xx: add nxp,refclk_in
 property
Content-Language: en-US
To:     Wei Fang <wei.fang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220819074729.1496088-1-wei.fang@nxp.com>
 <20220819074729.1496088-2-wei.fang@nxp.com>
 <f0f6e8af-4006-e0e8-544b-f2f892d79a1f@linaro.org>
 <DB9PR04MB81064199835C0E44B997DE06886C9@DB9PR04MB8106.eurprd04.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <DB9PR04MB81064199835C0E44B997DE06886C9@DB9PR04MB8106.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 12:37, Wei Fang wrote:
>>
>>> +          in RMII mode. This clock signal is provided by the PHY and is
>>> +          typically derived from an external 25MHz crystal. Alternatively,
>>> +          a 50MHz clock signal generated by an external oscillator can be
>>> +          connected to pin REF_CLK. A third option is to connect a 25MHz
>>> +          clock to pin CLK_IN_OUT. So, the REF_CLK should be configured
>>> +          as input or output according to the actual circuit connection.
>>> +          If present, indicates that the REF_CLK will be configured as
>>> +          interface reference clock input when RMII mode enabled.
>>> +          If not present, the REF_CLK will be configured as interface
>>> +          reference clock output when RMII mode enabled.
>>> +          Only supported on TJA1100 and TJA1101.
>>
>> Then disallow it on other variants.
>>
>> Shouldn't this be just "clocks" property?
>>
>>
> This property is to configure the pin REF_CLK of PHY as a input pin through phy register,
> indicates that the REF_CLK signal is provided by an external oscillator. so I don't think it's a
> "clock" property.

clocks, not clock.

You just repeated pieces of description as an counter-argument, so this
does not explain anything.

If it is external oscillator shouldn't it be represented in DTS and then
obtained by driver (clk_get + clk_prepare_enable)? Otherwise how are you
sure that clock is actually enabled? And the lack of presence of the
external clock means it is derived from PHY?

Best regards,
Krzysztof
