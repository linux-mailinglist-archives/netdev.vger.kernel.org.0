Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E816477E3
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 22:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiLHVWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 16:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiLHVWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 16:22:19 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D21B72845
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 13:22:18 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id p8so3962834lfu.11
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 13:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=abZKbKUJfOxCSq1MPfvZXV7QCvgG9o8fBXW4C3oMuuI=;
        b=V+OOnCcFNysG2pLGicgTlbVl+LUJe54qHq5jnSwM7K2q8GJ2fYaDrkaH+bzLcWwxZK
         WQn++2QsiBh+c9n2FnCTm1sggPfsPeqpmQYeOu+3umFug+H+uYmAUkPkIJwZQ2/OEK4D
         dDa1ic+0ND/GUBShWRmzztzRNiAqtE01a28vMe4iceNpDfzzz0CfrkZGD6xJFPWC6+F4
         qaz0aoYDNrCt1qa/tEFAkEg00AAq9gSN0JZw/QNH9Ylx+x4wVDINWw7TvLzbg12c2ZYK
         3rmxDk+z80cxDIekpgpovY/1d+SoegDfQeqXwIhHLAUfULv2oYnjpUmxcdrGqL+A9hPo
         x4Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=abZKbKUJfOxCSq1MPfvZXV7QCvgG9o8fBXW4C3oMuuI=;
        b=REaQoqgj09j2ks79iHs1WfDV8VdhociZWNkshLq+gfHlIT99PVCIqwi/RZeZnkFFuA
         k3B0nrZQwlfjUVkICmadjXDS1uTu+N0ojsjmY26XDodqtkmNzgBUTNltjpDlMHwAAI2i
         ghCuQZO91/eNDQGSBoM2CQS4UnhoKJOR/Wlct1NGlzOjX8ua88Fx88raeb74PX5wORi7
         GasaHOHIwRgjL32+2B6BVTrb0Ix7XhNxu9bMBg6D7EwEs5g8dr7y7iAX+2I9qcucJw6d
         dizH144/SKhX4wOdiTOJVxeaFgJiuy+jmqHE2p1gKyvZDzoQBfBvfug4nBbHo77uMIzc
         ouaQ==
X-Gm-Message-State: ANoB5pkAHA6rXq1pZ5Cez2ZWE6byI5lF1cdR5pmfgyRi13u7VA5Uy3y7
        rvzu6KtMXNfMkAxRS2dHbjPP1g==
X-Google-Smtp-Source: AA0mqf57IDQUvyPzGFYIG1ByCLs5HahO5hw2LWOrgdpshJUChB20nKmieK/du4yTeDGn5f5XlsXN0w==
X-Received: by 2002:a05:6512:22c5:b0:4b5:5880:8359 with SMTP id g5-20020a05651222c500b004b558808359mr7702628lfu.425.1670534536643;
        Thu, 08 Dec 2022 13:22:16 -0800 (PST)
Received: from [192.168.1.101] (95.49.125.53.neoplus.adsl.tpnet.pl. [95.49.125.53])
        by smtp.gmail.com with ESMTPSA id v3-20020a05651203a300b004a4754c5db5sm3480550lfp.244.2022.12.08.13.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 13:22:16 -0800 (PST)
Message-ID: <47b2fb29-1c2e-db6e-b14f-6dfe90341825@linaro.org>
Date:   Thu, 8 Dec 2022 22:22:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 2/2] net: ipa: add IPA v4.7 support
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     andersson@kernel.org, agross@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luca Weiss <luca.weiss@fairphone.com>
References: <20221208211529.757669-1-elder@linaro.org>
 <20221208211529.757669-3-elder@linaro.org>
Content-Language: en-US
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20221208211529.757669-3-elder@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8.12.2022 22:15, Alex Elder wrote:
> Add the necessary register and data definitions needed for IPA v4.7,
> which is found on the SM6350 SoC.
> 
> Co-developed-by: Luca Weiss <luca.weiss@fairphone.com>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
[...]
> +
> +/* Memory configuration data for an SoC having IPA v4.7 */
> +static const struct ipa_mem_data ipa_mem_data = {
> +	.local_count	= ARRAY_SIZE(ipa_mem_local_data),
> +	.local		= ipa_mem_local_data,
> +	.imem_addr	= 0x146a9000,
> +	.imem_size	= 0x00002000,
Should probably be

0x146a8000
0x00003000

with an appropriate change in dt to reserve that region.

Qualcomm does:
ipa@... { qcom,additional-mapping = <0x146a8000 0x146a8000 0x2000>; };

which covers 0x146a8000-0x146a9fff

plus

imem@.. { reg = <0x146aa000 0x1000>; };

which in total gives us 0x146a8000-0x146aafff


That would also mean all of your writes are kind of skewed, unless
you already applied some offsets to them.

(IMEM on 6350 starts at 0x14680000 and is 0x2e000 long, as per
the bootloader memory map)

Konrad
