Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17AAE60BE63
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 01:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiJXXP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 19:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJXXPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 19:15:33 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939651BBED9
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:36:27 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id cr19so6481141qtb.0
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sYcC1Hf5uFhVZuAIt3B0smLjO6ifatn3SZB/4VvO5T4=;
        b=rRr+DJxMyoaYySbaY77FbZDsnehXzqPBB6g7fAUyCrFManLQsJi9dcUmksiCeyJm6v
         iR3ermaH4ABvzuQFr3me4Ybom2EC6anXTnuqaOgtMu2tK9H6654Wvrr5A3R1T+bNisNF
         2PW86qqOcN5uYVI0yAIILthWpmeabUshuRBl76feXkxrJYow/VGqs8R/NHT8KjIl4vz9
         AZyTmUrockNpyzs8LYIo4obPqfZb2C96U1NmFX0LLHzjmtnjxJTsOmWLzwrBWmPOBMJ6
         ktNZ2bsUHBalb6xhRI5uQwiw8+O+mDfcxVSQf7jajvkmIBlSNiS89z8uyCkPDYqKgFnU
         4NNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sYcC1Hf5uFhVZuAIt3B0smLjO6ifatn3SZB/4VvO5T4=;
        b=U/OHQr1nm6/GoCNu3DcdSK+AXinC8rwMEzRBAehLE8azMGFcYsaKNWKr8Hnf4xOoZt
         D/g+j7DnOgWFup4ZmCcWklCnTbk2iYQrl2K4ZYBuFgBBVmRuV9MOLWHh4elZWl8ldUcm
         M7QO3ztqc3T/4RjAIHcAUe1g3Tz86VhShzFdFzKxyJqxQ0kjWQX/yCtP1VD3sEVIvoG4
         1QpwA0KOJ0EtPle987XFidpWylIDYi/yGT7g/CeZkUhpvkTW72kvybe+iDZNy56IEaU9
         Fmdx03jqfcsxOgLC7ih1O35wCd3NCpJmKTZueXEFkIJ0mCK9WHTG6e2f66ChqInzaPSg
         da4Q==
X-Gm-Message-State: ACrzQf1VVKBQCz9kSIPkpXTIAUcWWU7yZxHW9GLA+WwzlJ4DZlOp2cSz
        cD/jhhRvMjq6WhgZCHka+sOGwg==
X-Google-Smtp-Source: AMsMyM7fVNhyVmRM8Eylp+Nkyta7pkixfdw2cOfncLdYG6iHIMyt8zpYrUEU6a7GJoGQWbp5v1H9PQ==
X-Received: by 2002:a05:622a:2cc:b0:398:22c2:7e81 with SMTP id a12-20020a05622a02cc00b0039822c27e81mr28617007qtx.633.1666647363353;
        Mon, 24 Oct 2022 14:36:03 -0700 (PDT)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id j6-20020a37c246000000b006eed47a1a1esm623867qkm.134.2022.10.24.14.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 14:36:02 -0700 (PDT)
Message-ID: <5bcc3207-8c3a-1759-ee65-35e5efd77702@linaro.org>
Date:   Mon, 24 Oct 2022 16:36:00 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 1/2] net: ipa: fix v3.5.1 resource limit max values
Content-Language: en-US
To:     Caleb Connolly <caleb.connolly@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jami Kettunen <jami.kettunen@somainline.org>
Cc:     Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221024210336.4014983-1-caleb.connolly@linaro.org>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20221024210336.4014983-1-caleb.connolly@linaro.org>
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

On 10/24/22 4:03 PM, Caleb Connolly wrote:
> Some resource limits on IPA v3.5.1 have their max values set to
> 255, this causes a few splats in ipa_reg_encode and prevents the
> IPA from booting properly. The limits are all 6 bits wide so
> adjust the max values to 63.
> 
> Fixes: 1c418c4a929c ("net: ipa: define resource group/type IPA register fields")
> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>

Thanks Caleb, this looks good.

David et al, in case it isn't obvious, this is for net/master,
for back-port (only to 6.0.y).

Reviewed-by: Alex Elder <elder@linaro.org>

> ---
> V1: https://lore.kernel.org/netdev/20221024165636.3979249-1-caleb.connolly@linaro.org/
> Changes since v1:
>   * Apply the correct fix for v3.1 which has the opposite issue where the masks
>     are wrong rather than the values.
>   * Split into two patches
> ---
>   drivers/net/ipa/data/ipa_data-v3.5.1.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
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

