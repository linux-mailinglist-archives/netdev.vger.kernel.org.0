Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050E26B98BD
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbjCNPOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbjCNPOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:14:16 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2726AAF6AF
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:13:42 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y15so10950335lfa.7
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678806801;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aWquE/66XhiUdKcAjOZcdT8JwAjOV0jdF3ZReJh+jhU=;
        b=A70OxIRflPWeFRqLRBN8qDh9Nnpwl6mYudE01YgkwWijNkevncaAafkm4hhBFkYlPY
         B+r3GEwqp0NgXcsOp5XuGK9r6rRnB/Obx5FjFgTAiep+FKTJN4Wf8YdFdeEt+FGeianQ
         HKZRv9Gxy6ZXY22rJYBwB5fqIrxLopllTUZDbEXoT8/sDmpetnaCfVfzZjKfHbsVw5Ma
         sKRrOmFpYtj4/IWOdsY6LEdG6eur/ataMRIvXZhgMnc/+DueCevIubHxa7SwxkyI+bBL
         soT9s0BQKP1rOM59EGlR7NRgMnjXylMelTjMehReRdJPPj/aP3dV4uNWBeArjdPde47F
         bsqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678806801;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aWquE/66XhiUdKcAjOZcdT8JwAjOV0jdF3ZReJh+jhU=;
        b=mBZD8fPespGW4p/6Z3RccBFovbwrUtuR74Sdjh01yoOk8zqHJHNle2TdFJJLHtMWgo
         To6gMGEWvkX2K7TIVWeuNvqL9r9ikYieFBuB461G2nin7ucM4PqNk5XbigUIMAOSh2uj
         7l3WLKzGDfs9KrrJ0TczH0ifS2kVpexapIzIczT1L6OFwdZykQ5gT2SvMU4+Z6LU0Nog
         KpapAByl7sqHuajVo8i/Gox7jywYUngtbh91tpksYm7pAJCBB4MidyjLOJ1GBd+0JKEv
         p1w4AsMMLLzzKVJOX1f0EsV2UiKs0Q/z9qT3b2yfthq/TdgJe7lUOFtoHarWhUflmM3K
         4HBg==
X-Gm-Message-State: AO0yUKVQwJw16vkQsnxCXT+Wo1acJWbFoJAiWEjLMCqa/0+zS7MvukcE
        6LVlMaP/2oi0e2H4zhxR+BItTA==
X-Google-Smtp-Source: AK7set+0FwZrp2Kqmgi11czNIWqOTIdgsRQEqlYZ+eN8f1lZ8ifft3X4RqJNjukpilWNLQkafq+Kxg==
X-Received: by 2002:ac2:43ad:0:b0:4dc:4bda:c26f with SMTP id t13-20020ac243ad000000b004dc4bdac26fmr973810lfl.23.1678806801649;
        Tue, 14 Mar 2023 08:13:21 -0700 (PDT)
Received: from [192.168.1.101] (abyj16.neoplus.adsl.tpnet.pl. [83.9.29.16])
        by smtp.gmail.com with ESMTPSA id l7-20020ac24a87000000b004d23763fe96sm431973lfp.72.2023.03.14.08.13.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 08:13:20 -0700 (PDT)
Message-ID: <3f37eede-6d62-fb92-9cff-b308de333ebd@linaro.org>
Date:   Tue, 14 Mar 2023 16:13:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 05/11] clk: qcom: gcc-sc8280xp: Add EMAC GDSCs
Content-Language: en-US
To:     Andrew Halaney <ahalaney@redhat.com>, linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        vkoul@kernel.org, bhupesh.sharma@linaro.org,
        mturquette@baylibre.com, sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com
References: <20230313165620.128463-1-ahalaney@redhat.com>
 <20230313165620.128463-6-ahalaney@redhat.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230313165620.128463-6-ahalaney@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_HTTP,RCVD_IN_SORBS_SOCKS,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13.03.2023 17:56, Andrew Halaney wrote:
> Add the EMAC GDSCs to allow the EMAC hardware to be enabled.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
> ---
Was it tested to not cause issues on access on "normal" 8280xp?
AFAICS if there would be any, they would happen at registration
time, as gdsc_init already accesses its registers

Konrad
>  drivers/clk/qcom/gcc-sc8280xp.c               | 18 ++++++++++++++++++
>  include/dt-bindings/clock/qcom,gcc-sc8280xp.h |  2 ++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/clk/qcom/gcc-sc8280xp.c b/drivers/clk/qcom/gcc-sc8280xp.c
> index b3198784e1c3..04a99dbaa57e 100644
> --- a/drivers/clk/qcom/gcc-sc8280xp.c
> +++ b/drivers/clk/qcom/gcc-sc8280xp.c
> @@ -6873,6 +6873,22 @@ static struct gdsc usb30_sec_gdsc = {
>  	.pwrsts = PWRSTS_RET_ON,
>  };
>  
> +static struct gdsc emac_0_gdsc = {
> +	.gdscr = 0xaa004,
> +	.pd = {
> +		.name = "emac_0_gdsc",
> +	},
> +	.pwrsts = PWRSTS_OFF_ON,
> +};
> +
> +static struct gdsc emac_1_gdsc = {
> +	.gdscr = 0xba004,
> +	.pd = {
> +		.name = "emac_1_gdsc",
> +	},
> +	.pwrsts = PWRSTS_OFF_ON,
> +};
> +
>  static struct clk_regmap *gcc_sc8280xp_clocks[] = {
>  	[GCC_AGGRE_NOC_PCIE0_TUNNEL_AXI_CLK] = &gcc_aggre_noc_pcie0_tunnel_axi_clk.clkr,
>  	[GCC_AGGRE_NOC_PCIE1_TUNNEL_AXI_CLK] = &gcc_aggre_noc_pcie1_tunnel_axi_clk.clkr,
> @@ -7351,6 +7367,8 @@ static struct gdsc *gcc_sc8280xp_gdscs[] = {
>  	[USB30_MP_GDSC] = &usb30_mp_gdsc,
>  	[USB30_PRIM_GDSC] = &usb30_prim_gdsc,
>  	[USB30_SEC_GDSC] = &usb30_sec_gdsc,
> +	[EMAC_0_GDSC] = &emac_0_gdsc,
> +	[EMAC_1_GDSC] = &emac_1_gdsc,
>  };
>  
>  static const struct clk_rcg_dfs_data gcc_dfs_clocks[] = {
> diff --git a/include/dt-bindings/clock/qcom,gcc-sc8280xp.h b/include/dt-bindings/clock/qcom,gcc-sc8280xp.h
> index cb2fb638825c..721105ea4fad 100644
> --- a/include/dt-bindings/clock/qcom,gcc-sc8280xp.h
> +++ b/include/dt-bindings/clock/qcom,gcc-sc8280xp.h
> @@ -492,5 +492,7 @@
>  #define USB30_MP_GDSC					9
>  #define USB30_PRIM_GDSC					10
>  #define USB30_SEC_GDSC					11
> +#define EMAC_0_GDSC					12
> +#define EMAC_1_GDSC					13
>  
>  #endif
