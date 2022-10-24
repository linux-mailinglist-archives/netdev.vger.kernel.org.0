Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4918360BBB9
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 23:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiJXVLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 17:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbiJXVK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 17:10:56 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F20F019A
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 12:17:26 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id g11so6224247qts.1
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 12:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Uz1LChqXvtTQgQ4UX3FdXnaqMoy3szlw7sN3/aSmaU=;
        b=tO1Rtjv/pG5rdUtCJjc6Wqt0VphLY9rbHOBvebxi2pLOg9CMzvOwLqxl5td/ZiJbDR
         CxBLEnpssf2Hcj65gyijNBp3wfyR70YsaslP59G/9ILBxHNJQxhiqF3EjYB1nQhNgdsr
         dLHQdqbl6kuFOFs8yG0s/B8+REWHQiazIrfKs8e4a21x44MIoVUed3ja3QA71XicAYUU
         Az7fiBMGYXyIu3QWSBtDzqvE6UqvcctEthUw4epcTeSiZV+iko/F0e9LChCnGPT1WSIv
         cKjUDn63w8MyUYYjmjTswQn8mmtsL0pO74ZN2j0dnGQCOMkriBgfBmNUg+Z5MerPWMrP
         xGeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Uz1LChqXvtTQgQ4UX3FdXnaqMoy3szlw7sN3/aSmaU=;
        b=jHY4MtmwvRHevXJj1i6HtrX+oKGjVJX/fMGxiGdMtT8V0Dhzz6FbKPtyioUdlyH4/R
         fMnWAdXTAapVxu25tVBWRD3kXtF2+qDEMpU8GHtylkPXjVSevN0K3DVxWkI9LUq06EbA
         XeghYOYGZ9xr417eH2EP+lYj5njqI9nNWAKgoYyHWETckQvNoBi6eu49kQg9Jjj3lM4O
         LaikE1TeAj07ucy6H+nUYCxOdpBy8CcxLxBmSlJwqKHVD3mv/is4CTWKDV2mCPOsJjGD
         Dm8aJjWs4QVuIBiA4AOx02XVR7byhuqLwzsh/zjueeOI3LvYLzGPGOpPMgaNmrrkoU7I
         yQMw==
X-Gm-Message-State: ACrzQf2oPKPfU80qA8o6RxeyxRRZiAYbF504x6szVakv70ZH+rEXonoo
        OAB5iSG5Af/hrXjhAa/cdJ3LeA==
X-Google-Smtp-Source: AMsMyM4tuMOGYErwIW725XTlNxvY5jz9YlLp4nfLliYmjmdkBBtut5knzrkgWET62BwZrVWyS086hQ==
X-Received: by 2002:a05:622a:3ca:b0:39c:c860:fc2f with SMTP id k10-20020a05622a03ca00b0039cc860fc2fmr28860824qtx.489.1666638949713;
        Mon, 24 Oct 2022 12:15:49 -0700 (PDT)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id v8-20020a05620a440800b006ec59941acasm546994qkp.11.2022.10.24.12.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 12:15:48 -0700 (PDT)
Message-ID: <bf67b30f-074b-22b5-8d23-b1531ad30d74@linaro.org>
Date:   Mon, 24 Oct 2022 14:15:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] net: ipa: fix some resource limit max values
Content-Language: en-US
To:     Caleb Connolly <caleb.connolly@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alex Elder <elder@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        devicetree@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
References: <20221024165636.3979249-1-caleb.connolly@linaro.org>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20221024165636.3979249-1-caleb.connolly@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 10/24/22 11:56 AM, Caleb Connolly wrote:
> Some resource limits on IPA v3.1 and v3.5.1 have their max values set to
> 255, this causes a few splats in ipa_reg_encode and prevents it from booting.
> The limits are all 6 bits wide so adjust the max values to 63.

Thank you for sending this Caleb.

On IPA v3.5.1 (SDM845) I confirm that these resource limit fields are
6 bits wide, while the values we assign are in some cases 255, which
cannot be represented in 6 bits.  Your fix in this case is proper,
changing the maximum limit from 255 to be 63.  (Just in case, I've
sent a note to Qualcomm to ask them to confirm this, but I think this
is fine.)

I re-checked the definitions of the MIN_LIMIT and MAX_LIMIT fields
for IPA v3.1, and it turns out in that case the *register field*
definitions were wrong.  They should, in fact, be 8 bits wide rather
than just 6.  So in that case, 255 would be a reasonable limit value.

Did you observe these splats when doing actual testing on an msm8998
(which has IPA v3.1)?  Or did you just double-check the code?  I
looked at the other currently-supported platforms and didn't see
this sort of problem elsewhere (IPA v4.2, 4.5, 4.9, 4.11).


Could you please send a new version of your patch, which fixes the
register definition in "ipa_reg-v3.1.c" instead?

It might be best to fix the two issues in separate patches, since
they will parts pf the code with different development histories.

Thanks!

					-Alex

> Fixes: 1c418c4a929c ("net: ipa: define resource group/type IPA register fields")
> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>
> ---
>   drivers/net/ipa/data/ipa_data-v3.1.c   | 62 +++++++++++++-------------
>   drivers/net/ipa/data/ipa_data-v3.5.1.c |  4 +-
>   2 files changed, 33 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/net/ipa/data/ipa_data-v3.1.c b/drivers/net/ipa/data/ipa_data-v3.1.c
> index e0d71f609272..7ff093f982ad 100644
> --- a/drivers/net/ipa/data/ipa_data-v3.1.c
> +++ b/drivers/net/ipa/data/ipa_data-v3.1.c
> @@ -187,53 +187,53 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
>   static const struct ipa_resource ipa_resource_src[] = {
>   	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
>   		.limits[IPA_RSRC_GROUP_SRC_UL] = {
> -			.min = 3,	.max = 255,
> +			.min = 3,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DL] = {
> -			.min = 3,	.max = 255,
> +			.min = 3,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DIAG] = {
> -			.min = 1,	.max = 255,
> +			.min = 1,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
> -			.min = 1,	.max = 255,
> +			.min = 1,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
> -			.min = 2,	.max = 255,
> +			.min = 2,	.max = 63,
>   		},
>   	},
>   	[IPA_RESOURCE_TYPE_SRC_HDR_SECTORS] = {
>   		.limits[IPA_RSRC_GROUP_SRC_UL] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DL] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DIAG] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   	},
>   	[IPA_RESOURCE_TYPE_SRC_HDRI1_BUFFER] = {
>   		.limits[IPA_RSRC_GROUP_SRC_UL] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DL] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DIAG] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   	},
>   	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS] = {
> @@ -272,36 +272,36 @@ static const struct ipa_resource ipa_resource_src[] = {
>   	},
>   	[IPA_RESOURCE_TYPE_SRC_HDRI2_BUFFERS] = {
>   		.limits[IPA_RSRC_GROUP_SRC_UL] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DL] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DIAG] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   	},
>   	[IPA_RESOURCE_TYPE_SRC_HPS_DMARS] = {
>   		.limits[IPA_RSRC_GROUP_SRC_UL] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DL] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DIAG] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_DMA] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   	},
>   	[IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES] = {
> @@ -345,22 +345,22 @@ static const struct ipa_resource ipa_resource_dst[] = {
>   	},
>   	[IPA_RESOURCE_TYPE_DST_DATA_SECTOR_LISTS] = {
>   		.limits[IPA_RSRC_GROUP_DST_UL] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_DST_DL] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_DST_DIAG_DPL] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_DST_DMA] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_DST_Q6ZIP_GENERAL] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_DST_Q6ZIP_ENGINE] = {
> -			.min = 0,	.max = 255,
> +			.min = 0,	.max = 63,
>   		},
>   	},
>   	[IPA_RESOURCE_TYPE_DST_DPS_DMARS] = {
> diff --git a/drivers/net/ipa/data/ipa_data-v3.5.1.c b/drivers/net/ipa/data/ipa_data-v3.5.1.c
> index 383ef1890065..42f2c88a92d4 100644
> --- a/drivers/net/ipa/data/ipa_data-v3.5.1.c
> +++ b/drivers/net/ipa/data/ipa_data-v3.5.1.c
> @@ -179,10 +179,10 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
>   static const struct ipa_resource ipa_resource_src[] = {
>   	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
>   		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
> -			.min = 1,	.max = 255,
> +			.min = 1,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
> -			.min = 1,	.max = 255,
> +			.min = 1,	.max = 63,
>   		},
>   		.limits[IPA_RSRC_GROUP_SRC_UC_RX_Q] = {
>   			.min = 1,	.max = 63,

