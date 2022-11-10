Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0356242A0
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 13:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiKJMzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 07:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiKJMzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 07:55:00 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899B5D2EB
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 04:54:58 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id c25so1091289ljr.8
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 04:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4rl7jbCW2Iyj8yUM0jRXj0eHKryCRu10YTQuW097Gr8=;
        b=whwogG/M7Q/aGeiR8QbGlSJ9JxjAtIf9fE8Jb+btzCVlfgjoH66EEA0EQbo+Zwr8dr
         wvauFcCp1Z29sNzHCzqa508TADHQYP4HPOnHPJ1ka6yJEZPXnxzHuU8g2gz7PXlCEuuY
         jlWu+VSMvLTnSH3EBYmu/IQTOsCchEYKjHkJanYaUBPmtlgPHNXaSH4VyWnJUjFsUolW
         Y8Yhfkjo2dc0xFBJNU2ICW+GaHd6r9V9Yf7+YOiI4LUFQlsrHo9WRXubMcYZU0XONo0d
         RrCnYOqHhMylSvVnxabKVw2Ews7lgk7fXfAvxg+9ueo6FQN3kezOtc5eycpUhmyg3LMs
         k7rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4rl7jbCW2Iyj8yUM0jRXj0eHKryCRu10YTQuW097Gr8=;
        b=NIzLyMzjulyjWyia4o3wG3UWMAVFdsgxgbusMYYP7ec+MweLrVPI0ouOh7sVl3BKdJ
         GwuMDZYmJlFiGcgSd6cnSsdzaq9G/EOPjNnwD4dG3h42S3ZHcKBCXtgAtRljwPk0nxKy
         Tvw/81KaBNJCwxqzH1ymHKjqynAUJtsSZ/f8ZKV47QVqMlNtZaccDQzjL77bs0eo2Xug
         52UqnoWvfvTCsEWFsNC+pcbu5AEgRJlLfjAueqEo/gWbroZZYXUGN/W2Vn3aPP+3DU8P
         yD+5r4UfEpvOlHxxVu6Ot1y4NyW98xGR+XL7jxi4Zn4b5VgHxSuMbUuXI25LNEz/TzM1
         F21w==
X-Gm-Message-State: ACrzQf2JB3TExeVWai2tBehdS3dYh5D6IVIrBbw/IvydrhcYdjAWoauK
        86jj3bTSoAU5IcixTKNxya4fXw==
X-Google-Smtp-Source: AMsMyM7PksszzPCzsZ7TQYRjS50hCw4oU0MMSh3auqYjyGoudQLh6bxP/LVj8dD1a7HI8a+95D3bpw==
X-Received: by 2002:a2e:9f42:0:b0:277:1295:31ca with SMTP id v2-20020a2e9f42000000b00277129531camr8664043ljk.280.1668084896752;
        Thu, 10 Nov 2022 04:54:56 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id o11-20020a05651205cb00b00492dfcc0e58sm2742221lfo.53.2022.11.10.04.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 04:54:56 -0800 (PST)
Message-ID: <b43a03b2-ca53-fbdd-b4d0-03e424638468@linaro.org>
Date:   Thu, 10 Nov 2022 13:54:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 3/6] arm64: dts: fsd: add sysreg device node
Content-Language: en-US
To:     Sam Protsenko <semen.protsenko@linaro.org>,
        Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, krzysztof.kozlowski+dt@linaro.org,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        alim.akhtar@samsung.com, linux-fsd@tesla.com, robh+dt@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com
References: <CGME20221109100254epcas5p48c574876756f899875df8ac71464ce11@epcas5p4.samsung.com>
 <20221109100928.109478-1-vivek.2311@samsung.com>
 <20221109100928.109478-4-vivek.2311@samsung.com>
 <CAPLW+4nH=QQj+eWVrxeeOmgZ9UTGeL4__uttkNsji4XsGjOv3w@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAPLW+4nH=QQj+eWVrxeeOmgZ9UTGeL4__uttkNsji4XsGjOv3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11/2022 12:17, Sam Protsenko wrote:
> Hi Vivek,
> 
> On Wed, 9 Nov 2022 at 11:54, Vivek Yadav <vivek.2311@samsung.com> wrote:
>>
>> From: Sriranjani P <sriranjani.p@samsung.com>
>>
>> Add SYSREG controller device node, which is available in PERIC and FSYS0
>> block of FSD SoC.
>>
>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
>> Signed-off-by: Pankaj Kumar Dubey <pankaj.dubey@samsung.com>
>> Cc: devicetree@vger.kernel.org
>> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
>> ---
>>  arch/arm64/boot/dts/tesla/fsd.dtsi | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/tesla/fsd.dtsi b/arch/arm64/boot/dts/tesla/fsd.dtsi
>> index f35bc5a288c2..3d8ebbfc27f4 100644
>> --- a/arch/arm64/boot/dts/tesla/fsd.dtsi
>> +++ b/arch/arm64/boot/dts/tesla/fsd.dtsi
>> @@ -518,6 +518,16 @@
>>                                 "dout_cmu_fsys1_shared0div4";
>>                 };
>>
>> +               sysreg_peric: system-controller@14030000 {
>> +                       compatible = "tesla,sysreg_peric", "syscon";
>> +                       reg = <0x0 0x14030000 0x0 0x1000>;
> 
> Probably not related to this particular patch, but does the "reg"
> really have to have those extra 0x0s? Why it can't be just:
> 
>     reg = <0x14030000 0x1000>;
> 
> That comment applies to the whole dts/dtsi. Looks like #address-cells
> or #size-cells are bigger than they should be, or I missing something?

Yes, it looks like intention was to support some 64-bit addresses (maybe
as convention for arm64?) but none of upstreamed are above 32 bit range.
I don't have the manual/datasheet to judge whether any other
(non-upstreamed) nodes need 64bit addresses.

Best regards,
Krzysztof

