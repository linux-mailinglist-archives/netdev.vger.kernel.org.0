Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34395607997
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiJUO3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiJUO3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:29:38 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A54D2D6
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 07:29:30 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id ml12so900123qvb.0
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 07:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zYhXx3JshQE/tuoCTDyLMashoUzdUo4pZcMqABkRo/M=;
        b=srn3zByRrvEg+Yl6vV3ME0TTHd3gSfIVYc5ZsM/gQ0sujv8ybmnhpgntT0M6CLvr4P
         m/RzgyED/1GoDGFqUlL3LFyZgVLHf2kd4IOVgVaSQg2DCWp2il/4PLd7C2F3kVEEX79N
         nYke2DF0zLQX9jgzJm6HL3QMEw9CewFh3MPpKG5pu1vWUhzC7NEtPzbnnicUmuCSq8SS
         x7GbK2dbutqxSpzqpV5t9smW102A9VVnGQ2MOuDQ8sAKz4MTKPex7eTSjWRJ0M6m/J2R
         7qnWcwXvMysRYCIvyFb4tfcjoGcLX1dAAikcq1J3fnjo2oP1dyuMLUL09n97fmm9WWbv
         kU3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zYhXx3JshQE/tuoCTDyLMashoUzdUo4pZcMqABkRo/M=;
        b=C3q2n7ayqfogFXFNRdu1CzvgvCLPJmIyALq8ERW/N8wxcaib3MSegTUIQlQtl9XILk
         V5Nm/CPy3mgjmt7F+bqZbXGs+0hDI1iIsazvOg1jbwc0nb4nAhHMyuTA87ZGlsgjXBxR
         O9c7tD8egz5lB50MHdEmnz2jzWi+sevH4fTRmbmzFfheYrY7RkrW9EwDrWiM4i4GX9Rs
         ab0jKFUCtG6Y889t1D1AsqAIzCRs4BCIq3s3sUtZGRuZqVfZCJw6lP+7taR9ilu1DXpl
         7MP0OpEwgguV5/nPZa5ynnOzg7nr57eJPXjGfMAjcXp68zDIyG9CHfSA55t8lMygEGF/
         Qfpw==
X-Gm-Message-State: ACrzQf15JKSxO3HvgrRaJx5Bns5PETi/WBrtGrHlCriQM2kCVL0mEqTu
        igvS0kX9RCke48d8JEOtGiQ5Dw==
X-Google-Smtp-Source: AMsMyM5rkcPzQyOOQTpTuNGSU0Y+0j9z9JKh5icS5aTFsqI2snnDhTn3uBhW8R+XpbEZuMtOlufWhw==
X-Received: by 2002:a0c:e449:0:b0:4b9:cfc3:b31a with SMTP id d9-20020a0ce449000000b004b9cfc3b31amr5680781qvm.35.1666362568431;
        Fri, 21 Oct 2022 07:29:28 -0700 (PDT)
Received: from [192.168.10.124] (pool-72-83-177-149.washdc.east.verizon.net. [72.83.177.149])
        by smtp.gmail.com with ESMTPSA id x6-20020ac86b46000000b0035ba48c032asm7936410qts.25.2022.10.21.07.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 07:29:27 -0700 (PDT)
Message-ID: <fecd3c0d-33bb-d30c-3104-00e3bb36b2a8@linaro.org>
Date:   Fri, 21 Oct 2022 10:29:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next v5 5/5] ARM: dts: qcom: ipq4019: Add description
 for the IPQESS Ethernet controller
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
References: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
 <20221021124556.100445-1-maxime.chevallier@bootlin.com>
 <20221021124556.100445-6-maxime.chevallier@bootlin.com>
 <20221021124556.100445-6-maxime.chevallier@bootlin.com>
 <20221021142057.zbc3xfny4hfdshei@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221021142057.zbc3xfny4hfdshei@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/10/2022 10:20, Vladimir Oltean wrote:
> On Fri, Oct 21, 2022 at 02:45:56PM +0200, Maxime Chevallier wrote:
>> @@ -591,6 +592,51 @@ wifi1: wifi@a800000 {
>>  			status = "disabled";
>>  		};
>>  
>> +		gmac: ethernet@c080000 {
> 
> Pretty random ordering in this dts, you'd expect nodes are sorted by
> address...

Good point.

> 
>> +			compatible = "qcom,ipq4019-ess-edma";
>> +			reg = <0xc080000 0x8000>;
>> +			resets = <&gcc ESS_RESET>;
>> +			reset-names = "ess";
>> +			clocks = <&gcc GCC_ESS_CLK>;
>> +			clock-names = "ess";
>> +			interrupts = <GIC_SPI  65 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  66 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  67 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  68 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  69 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  70 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  71 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  72 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  73 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  74 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  75 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  76 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  77 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  78 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  79 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI  80 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 240 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 241 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 242 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 243 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 244 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 245 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 246 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 247 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 248 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 249 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 250 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 251 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 252 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 253 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 254 IRQ_TYPE_EDGE_RISING>,
>> +				     <GIC_SPI 255 IRQ_TYPE_EDGE_RISING>;
> 
> 32 interrupts, and no interrupt-names? :)

There is no requirement for names, because entries must be ordered. Also
Linux driver simply does not use them as it is slower to map, then just
by index. For few other Qualcomm drivers we dropped the names as well.

> 
>> +
>> +			status = "disabled";
>> +
> 
> Could you drop these 2 blank lines? They aren't generally added between
> properties.
> 

... and put status at the end.

Best regards,
Krzysztof

