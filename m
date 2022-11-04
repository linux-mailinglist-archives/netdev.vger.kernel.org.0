Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303FC619E03
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbiKDRAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiKDRAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:00:42 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA2A32B8A;
        Fri,  4 Nov 2022 10:00:36 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id i21so8485107edj.10;
        Fri, 04 Nov 2022 10:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4fCPgYoU3waghJpT2drBRUhqOVkGsUgsTwOK67tZmqg=;
        b=Ht82vcHMVwPq3LT34TKeasNFC8pTIDwoCLnJRlNCC98iJgHfCTNzEJeDxzk3A3ohug
         jLtoIymFu2Oswv0tOi810qrKr0w/l5BGT9MIPpRZyYMGjlw/phjcRUeWV2H4l5MW2aSQ
         jQr2KKUaMOPaCXTCjNP1csPQuoQyk8RP5QBjrgETkmBrD5cMbj3bIuAQotfR6tf8omf8
         ebGk3wFo1UVsyhVZTWXkxXUpjlX3ZadReH4FC33TsUqw2axUguK23Z8M+YBhFW/tPmmu
         UZCwoUnMhXSfxJtftrKxnKsvg6zip4kG54lK+DkaYXsglc3GizwiYaV+7PMpph0N5kCf
         3l6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4fCPgYoU3waghJpT2drBRUhqOVkGsUgsTwOK67tZmqg=;
        b=YQbat+RbNF/dxF17LdXI9UOdIwdGFGsaRnScsfWN2Aqi00qXEvEO5GaE6VuW4bDMYY
         KcoausmFnJGHt2wOZAO00ntbOtf88A60s2bSXOO3HeGfeSe42vaKV1AFuK2jeGp1dCnt
         tXUE/fXhiDvMFw2vsjjLVJV5/C6z2CBYy22nkIQJKLDrPbVDpHgwOCCHMErsCp8OpuRz
         lqhfm4As/bO6LychfP18abbnNV9IRyN0CgfWCI4YZ9ybJmGFJ1kjUBeB63WFDteL0AwK
         jTDU93yf7kpRwWlXpJ1lJqvqLKZOWbFSDu5x67g/84AbyiYuitsZGS4TM7V1MWUra0vk
         NAmQ==
X-Gm-Message-State: ACrzQf1kwyBIgYa4qFzoHfjpv6IzKqsDecI3M55dmK4WLsyIE/LUeofV
        uS743NKC1xgMDMGdUIvTEhw=
X-Google-Smtp-Source: AMsMyM6Q67g1IANmQQk15dltdaZClCbJ+Ghab1+AATzVI42UbkrjzVMioHiyXyHMHgMzu6lYDFC8pw==
X-Received: by 2002:a05:6402:3896:b0:45c:93c3:3569 with SMTP id fd22-20020a056402389600b0045c93c33569mr5949061edb.37.1667581235155;
        Fri, 04 Nov 2022 10:00:35 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id qp18-20020a170907207200b007ad86f86b4fsm2049454ejb.69.2022.11.04.10.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 10:00:34 -0700 (PDT)
Date:   Fri, 4 Nov 2022 19:00:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Message-ID: <20221104170031.zr76bv6u5yuxhsyq@skbuf>
References: <20221102185232.131168-1-krzysztof.kozlowski@linaro.org>
 <20221103233319.m2wq5o2w3ccvw5cu@skbuf>
 <698c3a72-f694-01ac-80ba-13bd40bb6534@linaro.org>
 <20221104020326.4l63prl7vxgi3od7@skbuf>
 <6056fe63-26f8-bbda-112a-5b7cf25570ad@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6056fe63-26f8-bbda-112a-5b7cf25570ad@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 09:09:02AM -0400, Krzysztof Kozlowski wrote:
> It is not valid to put spi-max-frequency = 1 GHz in
> spi-peripheral-props.yaml.
...
> IOW, CPHA/CPOL are not valid for most devices, so they cannot be in
> spi-peripheral-props.yaml.

Your understanding of SPI clock polarity/phase is probably not the same
as mine. "Not valid for most devices" is a gross misrepresentation.
There are 4 electrical modes of communication between a SPI controller
and a peripheral, formed by the 0/1 combination of the CPOL and CPHA bits.
Some peripherals support only a subset of these modes of operation, that
is completely true and I agree with it. But they're still SPI devices,
and all 4 modes of communication apply to them all. That's why I made
the comparison with the 1 GHz frequency. The spi-peripheral-props.yaml
schema only says what properties are valid for a peripheral, and both
CPOL and CPHA are valid for all SPI peripherals, even if some combos
don't work (when neither spi-cpol nor spi-cpha is present, they are 0
and 0, so the connection works in SPI mode 0).
