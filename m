Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507586C3AAE
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 20:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjCUTeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 15:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjCUTeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 15:34:12 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAB9574C4
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 12:33:16 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id by8so15486394ljb.12
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 12:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679427190;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DOJedXqzU4VqWJK2Ajbw3X3+PFnOG//f2bTihr6Ow9s=;
        b=GLM3DYS2JL2It4G6BzoIJ2VGfllIZyUTyFizD2iw7R1nQ/2Nxw7s1eUA4S475UZ30E
         RRYPrXV+WtXKvvHWVQA+mkJeFTUzRQ7PiclfuUNDSZQrSITkCUvu5MS5yIcyeiSw2xpG
         TJylosF3L45XsVG1r+7VfG+NiDUacqoboZLj91Yr50Fcw5URjdl8g8ThnfqbP7+U7R/v
         eKUxRfwh1Y3706MWwpv8qmqpPXKUm3Yl2lPgxYBzzgiFBPvu5xtuzrhREfL1hlPzNA8r
         yJEsi1N22r00cg0uXwTzXYRvGaCrs9z0gGgysEzANaA3egBRhHbyyRjwy0Qcru8YSOLj
         AqtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679427190;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DOJedXqzU4VqWJK2Ajbw3X3+PFnOG//f2bTihr6Ow9s=;
        b=Q/R5Xx0Eri7zXu5zFXzHS5D6goVD+o5uAhgVXgnOPIoBE4G3nrwURMnXIroN/pMUiI
         MGUBtWVCT01wmctGZvhw8jz+29a01EfXfCzhvNsKsg/InIo8DtDRnZj0feA7JMz09Jii
         J5lPmt+YUOzU8ZMoz7lswqHSbwqDb7nNKdeQBN8F+YF9iSNpK/l9VJ+UjO4hZjben54B
         8HANvBJq1LC7cqy/02GcV9SV2ss6UPb215y5o2X2ugPWyqOjWj2aZvz4JSQgZSA2UuqX
         tKmmsjwigymkfjRWzM9EbRhZHAno1MQIZzmLJ5d256/iLjz6IUY5JP5aB9vrF4pJJpiZ
         iKqw==
X-Gm-Message-State: AO0yUKUOAwP6nuq9JO5iAL+PIGJNrcnEKQ8BXsPp0iY3VtpPBX9sW9xy
        YnAD6k99Go2I7pwLUi4O/FWh5g==
X-Google-Smtp-Source: AK7set/Ex+jNMGHlNPs7MD/8WHLmtZjVZAaZIPc3DR+BKF/CGbp/oAxGt7AI1rUvwWvA4YPWwZQhAw==
X-Received: by 2002:a2e:9e53:0:b0:29b:aee8:29b3 with SMTP id g19-20020a2e9e53000000b0029baee829b3mr1074275ljk.38.1679427189980;
        Tue, 21 Mar 2023 12:33:09 -0700 (PDT)
Received: from [192.168.1.101] (abym238.neoplus.adsl.tpnet.pl. [83.9.32.238])
        by smtp.gmail.com with ESMTPSA id y22-20020a2e9d56000000b002991baef49bsm2349020ljj.12.2023.03.21.12.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 12:33:09 -0700 (PDT)
Message-ID: <013babf9-713b-b0ee-c70b-d12ab5e2b3eb@linaro.org>
Date:   Tue, 21 Mar 2023 20:33:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v2 05/12] clk: qcom: gcc-sc8280xp: Add EMAC GDSCs
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
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
References: <20230320221617.236323-1-ahalaney@redhat.com>
 <20230320221617.236323-6-ahalaney@redhat.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230320221617.236323-6-ahalaney@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20.03.2023 23:16, Andrew Halaney wrote:
> Add the EMAC GDSCs to allow the EMAC hardware to be enabled.
> 
> Acked-by: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
> 
> I'm still unsure if Bjorn wants to take this patch or net-dev, and how I am
> supposed to indicate such other than commenting here (per Stephen's
> comment on v1): https://lore.kernel.org/netdev/e5cb46e8874b12dbe438be12ee0cf949.sboyd@kernel.org/#t
> 
> Changes since v1:
> 	* Add Stephen's Acked-by
> 	* Explicitly tested on x13s laptop with no noticeable side effect (Konrad)
> 
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
