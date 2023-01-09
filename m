Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE773662DE6
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbjAISBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237286AbjAISAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:00:40 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68893B90C
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 09:59:26 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id x37so9715174ljq.1
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 09:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E+qveqb1lIXcnGTFvIEjJsK5V3NNFl28mMyS0BdM5eM=;
        b=tP1uPGEjt19pL3v7Xe1yBbBEPpYe9mfqcLJNIvwMjzuGWiNfvMLd63Ji90WEgfF9FK
         M3soHz01A+iMxPlHGi+T6/7E2Oj8FDlcwJsXy9CfrIcuQnDKSrpE6MXQvqUiGFtRwVB7
         sYd4nZ1ctJwFeqVuex5ZfFNThvxd7VP+aTpfLQzSjbjewLouY00CApU5iy76XlFqo4ps
         X8ErjYKBSVvhOTam9quX64OEs0XvFWLTIclWFllfcQYtYa8YhvjKQplbjAOUdlrT+bSJ
         hl67TrCOehNrjjJFmHVtrUi7h26b1ZXRYtgrw2AtM4Dkd3E46tbhpSXl5qgmIRYVszFy
         icTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E+qveqb1lIXcnGTFvIEjJsK5V3NNFl28mMyS0BdM5eM=;
        b=6r+gWJDcDVY6k8XdjGLD2kfL2KI19ZC589tc1yTDuafZ+ZBCwEK1xkn6E2xx72GxSR
         n2HP+LG4ZX9fHJj9NFN1r8IApgCNi+pqPLJUvycfqkIamsfsfELBde2bgHNW8v/GmwEY
         b0MV/0iXlUmyVo7mpgd/AkSDnBhLwJmVn9EZrTXawjyUjHKImmsQXQtyIUTtWIJn1ief
         XYj8fTxM5YVa5YSdnOZsY9cjYOsQBA/iDTZK9yDUir06XUXFMd+EdOVoD2H+i6t4NrI/
         GDVarwSKmYf5S0wDUe3B1+7jDNLBgyzYVjPehPL2UT1cWIgo5ku7H5TQkcGtOcdW14z3
         i2AA==
X-Gm-Message-State: AFqh2kpT2VbIK3bK8Hxorq5h+MhQPzs2lSlbQX1tkyMpHEPCdTAStr5E
        Cawi1gvh13Podku4Ts/FmU4gxw==
X-Google-Smtp-Source: AMrXdXuZNCexu4b3MipAqyEIlM3q5wufS7OLP2Gp8Y5QdkOr98qbiY/UXca24lcoWCb+KMRv/GHTGQ==
X-Received: by 2002:a2e:bf1e:0:b0:27b:65e3:3e93 with SMTP id c30-20020a2ebf1e000000b0027b65e33e93mr20988977ljr.45.1673287165211;
        Mon, 09 Jan 2023 09:59:25 -0800 (PST)
Received: from [192.168.1.101] (abxi45.neoplus.adsl.tpnet.pl. [83.9.2.45])
        by smtp.gmail.com with ESMTPSA id w19-20020a2e1613000000b00284448243e0sm596907ljd.87.2023.01.09.09.59.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 09:59:24 -0800 (PST)
Message-ID: <016d11c4-4d1e-cc70-bd4b-71a778e0cc1d@linaro.org>
Date:   Mon, 9 Jan 2023 18:59:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 03/18] arm64: defconfig: enable the clock driver for
 Qualcomm SA8775P platforms
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
 <20230109174511.1740856-4-brgl@bgdev.pl>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230109174511.1740856-4-brgl@bgdev.pl>
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



On 9.01.2023 18:44, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Enable the GCC clock driver on SA8775P platforms. It needs to be built-in
> for console to work.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
>  arch/arm64/configs/defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
> index 851e8f9be06d..1cb586125c46 100644
> --- a/arch/arm64/configs/defconfig
> +++ b/arch/arm64/configs/defconfig
> @@ -1098,6 +1098,7 @@ CONFIG_MSM_GCC_8994=y
>  CONFIG_MSM_MMCC_8996=y
>  CONFIG_MSM_GCC_8998=y
>  CONFIG_QCS_GCC_404=y
> +CONFIG_SA_GCC_8775P=y
>  CONFIG_SC_GCC_7180=y
>  CONFIG_SC_GCC_7280=y
>  CONFIG_SC_GCC_8180X=y
