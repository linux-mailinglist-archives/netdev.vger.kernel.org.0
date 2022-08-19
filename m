Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9F559955E
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 08:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345915AbiHSGbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 02:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243435AbiHSGbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 02:31:43 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210BCCE4BA
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 23:31:41 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id i19so4893691lfr.10
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 23:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Bb2RpT6vGLRj2vz+IAdNpAgpAbLXOPpk7ezwAEBFYwY=;
        b=PjTOEJ7UVo3OwfPxwoHxo3jrcfA8/pAuI7GZMYNsQ+EbNFOYCAglWqmIJYqSiNARNz
         a5s/LIpaVS257AsfezDM2rPaUqul4ZwVuNg22IFg+BCsN1hveBQDHXyivh3aDSW6LhPH
         zTzQaKgPb8rjbJqMJchNdvT5WxjjOIOD/8l4TreRzhKQ+/ED+jmk0Mzzsx5VH3HJoE7I
         lOdfextLrw03dVjS82jVmm6b7XQ4elNURm4LchOwnSB1Ki4v5Tn9GFYs6nGKqwqefnUn
         2w5T7LNZQmUUqF0vHnnSaeObZScPx1PnEVl+/FyAm3UaGRQEEflik9EyXQrzy3scRcPi
         o2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Bb2RpT6vGLRj2vz+IAdNpAgpAbLXOPpk7ezwAEBFYwY=;
        b=dTt5NnnI84KHbgwdjkwTsSdE2GEzBLC03fpzQHEppAvmSlQdPV4R/Mb758VNxE+2GQ
         M47el5M5Fcz9HbSHSax/XceaO2VZ3hA7Ryqg8z5GTn9zfPr0lZKWd8XVGXHvWdlaQyLz
         nreZF8X1a0aYwBCFFwIDP2en+oFkGhL1P/fkHJ7rS7LCuIBkaCCY/Pfc2ieR51dpGZ66
         Cg24IFzJCKj3NXO/0hkbnD/lEChML16xsDheQOEjZslyJU5aS2imAWeDxqR5IVu6EKVP
         gadrbeoqtPyW6RTG08Wvw8iwr5ajdDv4W9PgCBj1UJkZ4bPwWrAtUnJBtOGBAQ0931vk
         WrGQ==
X-Gm-Message-State: ACgBeo0q660KXFutPDsQ9y6VPOwujKvIZemNegIn06orBXD1+WyEGSMl
        o4qLkBumXj7sjqQiQmGxFZYJHA==
X-Google-Smtp-Source: AA6agR796NtSOJs4gp+P2t8uFT91TfNBuALgjbqCoOF2Y/Xgcdz0QTYg21T57msGMFfNMZB5FapbDg==
X-Received: by 2002:a05:6512:3409:b0:48a:ef20:dda with SMTP id i9-20020a056512340900b0048aef200ddamr2183723lfr.649.1660890700214;
        Thu, 18 Aug 2022 23:31:40 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ac:e5a8:ef73:73ed:75b3:8ed5? (d1xw6v77xrs23np8r6z-4.rev.dnainternet.fi. [2001:14bb:ac:e5a8:ef73:73ed:75b3:8ed5])
        by smtp.gmail.com with ESMTPSA id s20-20020a056512215400b00492b313d37csm514106lfr.134.2022.08.18.23.31.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 23:31:39 -0700 (PDT)
Message-ID: <31dd0110-4c7f-61f8-7261-2476766c9360@linaro.org>
Date:   Fri, 19 Aug 2022 09:31:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible item
Content-Language: en-US
To:     Peng Fan <peng.fan@nxp.com>, Wei Fang <wei.fang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>, Jacky Bai <ping.bai@nxp.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Aisheng Dong <aisheng.dong@nxp.com>
References: <20220704101056.24821-1-wei.fang@nxp.com>
 <20220704101056.24821-2-wei.fang@nxp.com>
 <ef7e501a-b351-77f9-c4f7-74ab10283ed6@linaro.org>
 <20220818013344.GE149610@dragon>
 <fd41a409-d0e0-0026-4644-9058d1177c45@linaro.org>
 <20220818092257.GF149610@dragon>
 <a08b230c-d655-75ee-0f0c-8281b13b477b@linaro.org>
 <20220818135727.GG149610@dragon>
 <00614b8f-0fdd-3d7e-0153-3846be5bb645@linaro.org>
 <DB9PR04MB8106BB72857149F5DD10ACEA886C9@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <PA4PR04MB9416C0E26B13D4060C2F50A9886C9@PA4PR04MB9416.eurprd04.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <PA4PR04MB9416C0E26B13D4060C2F50A9886C9@PA4PR04MB9416.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 06:13, Peng Fan wrote:
>>>
>> Sorry, I did not explain clearly last time, I just mentioned that imx8ulp fec
>> was totally reused from imx6ul and was a little different from imx6q.
>> So what should I do next? Should I fix the binding doc ?
> 
> Just my understanding, saying i.MX6Q supports feature A,
> i.MX6UL support feature A + B, Then i.MX6UL is compatible with i.MX6Q.

Or if i.MX8ULP can bind with any previous compatible and still work
(with limited subset of features).

> 
> If upper is true from hardware level, then i.MX8ULP FEC node
> should contain 8ulp, 6ul, 6q.
> 
> But the list may expand too long if more and more devices are supported
> and hardware backward compatible

True. I guess three items is the limit and anything newer should restart
the sequence.

Best regards,
Krzysztof
