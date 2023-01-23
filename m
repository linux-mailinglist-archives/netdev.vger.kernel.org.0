Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D33677790
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 10:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbjAWJm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 04:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbjAWJmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 04:42:25 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE331CA01
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 01:42:22 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id f25-20020a1c6a19000000b003da221fbf48so8059776wmc.1
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 01:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bb3ehCbsmnDNOeIeuOp9X6FACVdZxwB9flFsEny7tkU=;
        b=dV+vmkhPJupVDkDKPKw/2uJe9dhCfz2931ZZfmSlTiTucpZhV2Dz+B6f9Fv3oiI5Qg
         xdALFShfLxjvVlVQ2K1bLQ5/4uPa6Q7gCQlFkO7bDQBoW/r8L1iBLX9dM/ZknvefkDGC
         6iJRk6CRvJJo7qipP+9FC4RrGHDwX//qae/qj8wJurKg8c+1OHYsm56cHw4p7MWRyk1K
         nfquz3KQcfaO9EzCTs/SUKrcWz3tEvEos7SFv6WhgRiugJpJ3DnoGoOyT8+BCgVZIzQS
         gVFXE4RIK7gcAlT4NdXcPy1iZVBPSkMbc+B1+QYLkW51SQ6p0ODeYa+m2ek55Zj8+RQZ
         DWEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bb3ehCbsmnDNOeIeuOp9X6FACVdZxwB9flFsEny7tkU=;
        b=2TB4Vzd5mPJwC8XOHrcoPmD7qKDzr0vjDrVr6cJr09Z3u6pR9I04v3tG+ZFKQjTq6d
         GPGHvNpPuTy0iR0Kq1wpUBfUtOeOPQFdE3y7F/sU01t+dAe4r2yOG2X/TaxwTaw00Dxc
         4hfJaz1y7UZluvJtsQ5tLNcFEc0pJQPq1uWPRJ26f15NfVMmTCITJylwujQ8RWrZeKO2
         CdzBRIQMfDo8+gduxv4xcYNp7apAi4ehCsRJFNfmcoGdAg8GcmqZOvlVHbLukC7DFXTs
         DURinXNZRxsb3dmGMEJaqc5CZmdcCIr4jQ6phkYVnT1u+EcV6NKivZZyK/BKBQ5gVgpn
         O6Qg==
X-Gm-Message-State: AFqh2kpDJwZeZMPntZdNZw0dzrDyQPdUG3djGaEswRHGfImNQ8E8MftL
        z9s1Bwxjs2XpnarLqxVrEiN3Uw==
X-Google-Smtp-Source: AMrXdXsm6TcBoxPPxS02VMNxznfImdfA7EnRpT/eJPmFB8AVCLXvlWQuATnvGBXA13pmaGAeWzaHKQ==
X-Received: by 2002:a05:600c:1d12:b0:3db:53f:baea with SMTP id l18-20020a05600c1d1200b003db053fbaeamr23030706wms.6.1674466941329;
        Mon, 23 Jan 2023 01:42:21 -0800 (PST)
Received: from [192.168.7.111] (679773502.box.freepro.com. [212.114.21.58])
        by smtp.gmail.com with ESMTPSA id t13-20020a1c770d000000b003db1ca20170sm9963482wmi.37.2023.01.23.01.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 01:42:20 -0800 (PST)
Message-ID: <d8f78a24-398c-8bb0-8964-778d8a0e8998@linaro.org>
Date:   Mon, 23 Jan 2023 10:42:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v2 04/11] dt-bindings: watchdog: convert meson-wdt.txt to
 dt-schema
Content-Language: en-US
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
References: <20221117-b4-amlogic-bindings-convert-v2-0-36ad050bb625@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v2-4-36ad050bb625@linaro.org>
 <CAFBinCDd1MJEmSHR1XPsfBoRasBq+cV1F+66sCBXALtCCmoyUA@mail.gmail.com>
Organization: Linaro Developer Services
In-Reply-To: <CAFBinCDd1MJEmSHR1XPsfBoRasBq+cV1F+66sCBXALtCCmoyUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01/2023 22:48, Martin Blumenstingl wrote:
> Hi Neil,
> 
> On Mon, Jan 9, 2023 at 1:53 PM Neil Armstrong <neil.armstrong@linaro.org> wrote:
> [...]
>> +  compatible:
>> +    oneOf:
>> +      - enum:
>> +          - amlogic,meson6-wdt
>> +          - amlogic,meson8-wdt
> Technically this is not an identical representation of what we had
> before which was:
> -       "amlogic,meson8-wdt" and "amlogic,meson6-wdt" on Meson8 SoCs
> 
> We're not using the "amlogic,meson8-wdt" compatible anywhere at the moment.
> In the meson_wdt driver it's defined with the same per-SoC data as
> "amlogic,meson6-wdt".
> 
> Long story short: In my opinion there's no need to change what you
> have right now.
> If you have to re-spin this then maybe you can add a note to the patch
> description.
> Please add my:
> Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Sorry I was distracted, I'll add a node on the commit message.

Thanks,
Neil

> 
> 
> Best regards,
> Martin

