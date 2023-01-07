Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC30E660DB2
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 11:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjAGKUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 05:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjAGKUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 05:20:39 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD39782F64
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 02:20:36 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id bu8so5498501lfb.4
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 02:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j5DrSJVhwW7xN52teNHHpubxjnBjClsyPzyDg7+uVys=;
        b=D2GBHDxJ2YBplJR9VAolgv/WYjkCdwjwR7ZCzbCVvitxD8DdU2EZv5Tj5HZbQqv6qG
         VtCUQgnF8GJnR+jTPoCFCO/Cjh0G/bcsgF6UAdXQi7NmfZtf99gAVGNLOAIXlZXK8xua
         tlYPvo0eWe2jh1VQdfLEuBuX2bzpv/QJpjIrqTQr+pos3qkXiAf3m9728CANMS+jH0wv
         ygzs0K52pR2NswH8n/jNgLGOlVGfIhxgYbKFIO7AQ6K828YpiZ6anIue7i8HOMUTpwAS
         KKX/zSVKcALvwOSmQrJ2UXOS4F93Wand4l1ZZdk+RCOINgqiwhq8o3cIOXeVqILy75f7
         +MBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j5DrSJVhwW7xN52teNHHpubxjnBjClsyPzyDg7+uVys=;
        b=khZAoja39oTZCMhcZodlHIDUJRGsp1gn7RW9MVDm4dULnpPQi/rljC2uVKwu9raC0X
         eUQmpfRY6p+J2YnRXuapqh1heaZCUqhQegBZG7UojHm3dMlo7G4LnKdOqKC1IbQ+LSUD
         PoytaPk/dJ7l5Ju8POS2xk7OZ/5Gwg25TIAO1SO+aHf93ab0iBTGLOi6TdlEJ5Us2yyb
         MafPsFHpg0N/QCJcAn4DB0gvjt2Xb+O1l8Xxw3TrDKS1i+cHiPBVhoB9/KlkrOk8dY2e
         HLrmqEqGf/1h+b8kcWIZYxyMYNZZ9fxEJNOjtapXsHCtnTA5pjLL8LVTpYIZLcE/zaUZ
         oX4g==
X-Gm-Message-State: AFqh2komOxF3qhpEjHmDLZlvvH5dDj9bMVZ9jNrxEAmXh4kFmlSdeJzF
        /CEf6POlxbQ+sgeGKqbcC/s5BA==
X-Google-Smtp-Source: AMrXdXv+dxf/DElvVyTAVMFntR1ULobGPsDCOzmMEVbwpWA1cLwfTCEUb3Lal3vhxH2lv+0WCWxF3w==
X-Received: by 2002:a05:6512:4013:b0:4a4:8044:9b8 with SMTP id br19-20020a056512401300b004a4804409b8mr17695688lfb.9.1673086834887;
        Sat, 07 Jan 2023 02:20:34 -0800 (PST)
Received: from [192.168.1.101] (abxi45.neoplus.adsl.tpnet.pl. [83.9.2.45])
        by smtp.gmail.com with ESMTPSA id 12-20020ac25f0c000000b004cb3aced3f9sm525041lfq.226.2023.01.07.02.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Jan 2023 02:20:34 -0800 (PST)
Message-ID: <ce0e8a89-8765-e986-6128-2b12287826df@linaro.org>
Date:   Sat, 7 Jan 2023 11:20:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net v2] net: ipa: correct IPA v4.7 IMEM offset
Content-Language: en-US
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     luca.weiss@fairphone.com, caleb.connolly@linaro.org,
        mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230106132502.3307220-1-elder@linaro.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230106132502.3307220-1-elder@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6.01.2023 14:25, Alex Elder wrote:
> Commit b310de784bacd ("net: ipa: add IPA v4.7 support") was merged
> despite an unresolved comment made by Konrad Dybcio.  Konrad
> observed that the IMEM region specified for IPA v4.7 did not match
> that used downstream for the SM7225 SoC.  In "lagoon.dtsi" present
> in a Sony Xperia source tree, a ipa_smmu_ap node was defined with a
> "qcom,additional-mapping" property that defined the IPA IMEM area
> starting at offset 0x146a8000 (not 0x146a9000 that was committed).
> 
> The IPA v4.7 target system used for testing uses the SM7225 SoC, so
> we'll adhere what the downstream code specifies is the address of
> the IMEM region used for IPA.
> 
> Link: https://lore.kernel.org/linux-arm-msm/20221208211529.757669-1-elder@linaro.org
> Fixes: b310de784bac ("net: ipa: add IPA v4.7 support")
> Tested-by: Luca Weiss <luca.weiss@fairphone.com>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
> v2: Based on net/master this time...
> 
>  drivers/net/ipa/data/ipa_data-v4.7.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/data/ipa_data-v4.7.c b/drivers/net/ipa/data/ipa_data-v4.7.c
> index 7552c400961eb..b83390c486158 100644
> --- a/drivers/net/ipa/data/ipa_data-v4.7.c
> +++ b/drivers/net/ipa/data/ipa_data-v4.7.c
> @@ -357,7 +357,7 @@ static const struct ipa_mem ipa_mem_local_data[] = {
>  static const struct ipa_mem_data ipa_mem_data = {
>  	.local_count	= ARRAY_SIZE(ipa_mem_local_data),
>  	.local		= ipa_mem_local_data,
> -	.imem_addr	= 0x146a9000,
> +	.imem_addr	= 0x146a8000,
>  	.imem_size	= 0x00002000,
>  	.smem_id	= 497,
>  	.smem_size	= 0x00009000,
