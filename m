Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F7160BE61
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 01:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbiJXXPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 19:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiJXXPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 19:15:25 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC67132CC60
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:36:28 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id s17so6897348qkj.12
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gk7TlUCe82Khl4QlorbqbbPFStHIH3+Iv/P2rNwZu0o=;
        b=uCMsBsZsyNSicwFLc5eBQIDw9d/ijN5Z1RGIP8Hel2XXUFnaIsSFU+Z43X/zkM+5P/
         0qJThUC3pXejzgWcgINJoBNZzyUPoZNft8DNnebXE7WGxlFNJMyY/oAetcvt/19J+JsX
         e80ham7Ou9Ldkp3IxUmVFxMymo3CY/yDlJInbbTgFDYkfT3QeZPN5QKrBh8u3dur+CLy
         n1sNufly3U3//6xQ7I6snoo0dYCblPXViF9RBM2BraKoPxi4FP5Z3psUlQ1Isc5nXeDP
         loRP1blly4913PyruuJXHmkEHR4kcQsge82dROPhH30DdgouOYYxwfYPAcF1v6brRu9p
         Mb/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gk7TlUCe82Khl4QlorbqbbPFStHIH3+Iv/P2rNwZu0o=;
        b=M4H3e4PDZ/bwBiHhuf+AC7/9zTqKlQT6mwHArDZ+CkI/72kVb3KT/wHgqtJAJ973lh
         He0Z9Q8QVA5BO79Sv7b5iHEZ0SY4HT3K+BzjwTZtB/7XD4/hJ/Rp9m6MO8okPZ8Dloj+
         Xmit/yaJ3pbplVZr0eIieyDLTRuDBJxAu+Yayj4DKAbL+XHDVfZFoivOs+SadqPYFPLo
         dN30YO2uWSEtRrgZmhvXznEUiEY6YC5nOccy1FL/aCBEG3RqGUR1ExWQOu+D5ENdOeY1
         V+CiGahnwPIHkI6ox0Ep4mq9MwwMxyhWGECbhuSHiHwEH6miElABSZbHUYkjElj0lGeg
         AblA==
X-Gm-Message-State: ACrzQf3ZCEFNTS0usv5eXoWGfN6JGhoI5jbo4mmng8Ru6ZvX3bTFsUdX
        3bhu2h3rEmZlU2I/ghjd3t0uWQ==
X-Google-Smtp-Source: AMsMyM4f9hVL4a3tNfN6IvxxUpWbGQp6ot77O39v+uSqC3ly1x4ypzOlqA7Y3l1Oq77QqnWVtHcg3Q==
X-Received: by 2002:a05:620a:40cb:b0:6ee:79ce:e985 with SMTP id g11-20020a05620a40cb00b006ee79cee985mr24019893qko.219.1666647368612;
        Mon, 24 Oct 2022 14:36:08 -0700 (PDT)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id bm33-20020a05620a19a100b006e42a8e9f9bsm650239qkb.121.2022.10.24.14.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 14:36:07 -0700 (PDT)
Message-ID: <5424b68c-1192-455e-8c0f-f47d0bf0122f@linaro.org>
Date:   Mon, 24 Oct 2022 16:36:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 2/2] net: ipa: fix v3.1 resource limit masks
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
 <20221024210336.4014983-2-caleb.connolly@linaro.org>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20221024210336.4014983-2-caleb.connolly@linaro.org>
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
> The resource group limits for IPA v3.1 mistakenly used 6 bit wide mask
> values, when the hardware actually uses 8. Out of range values were
> silently ignored before, so the IPA worked as expected. However the
> new generalised register definitions introduce stricter checking here,
> they now cause some splats and result in the value 0 being written
> instead. Fix the limit bitmask widths so that the correct values can be
> written.
> 
> Fixes: 1c418c4a929c ("net: ipa: define resource group/type IPA register fields")
> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>

Looks good to me, thanks for fixing this.

Note: this is for net/master, to be back-ported to v6.0.y.

Reviewed-by: Alex Elder <elder@linaro.org>

> ---
>   drivers/net/ipa/reg/ipa_reg-v3.1.c | 96 ++++++++++--------------------
>   1 file changed, 32 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/net/ipa/reg/ipa_reg-v3.1.c b/drivers/net/ipa/reg/ipa_reg-v3.1.c
> index 116b27717e3d..0d002c3c38a2 100644
> --- a/drivers/net/ipa/reg/ipa_reg-v3.1.c
> +++ b/drivers/net/ipa/reg/ipa_reg-v3.1.c
> @@ -127,112 +127,80 @@ static const u32 ipa_reg_counter_cfg_fmask[] = {
>   IPA_REG_FIELDS(COUNTER_CFG, counter_cfg, 0x000001f0);
>   
>   static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>   };
>   
>   IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, src_rsrc_grp_01_rsrc_type,
>   		      0x00000400, 0x0020);
>   
>   static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>   };
>   
>   IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, src_rsrc_grp_23_rsrc_type,
>   		      0x00000404, 0x0020);
>   
>   static const u32 ipa_reg_src_rsrc_grp_45_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>   };
>   
>   IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_45_RSRC_TYPE, src_rsrc_grp_45_rsrc_type,
>   		      0x00000408, 0x0020);
>   
>   static const u32 ipa_reg_src_rsrc_grp_67_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>   };
>   
>   IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_67_RSRC_TYPE, src_rsrc_grp_67_rsrc_type,
>   		      0x0000040c, 0x0020);
>   
>   static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>   };
>   
>   IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, dst_rsrc_grp_01_rsrc_type,
>   		      0x00000500, 0x0020);
>   
>   static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>   };
>   
>   IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, dst_rsrc_grp_23_rsrc_type,
>   		      0x00000504, 0x0020);
>   
>   static const u32 ipa_reg_dst_rsrc_grp_45_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>   };
>   
>   IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_45_RSRC_TYPE, dst_rsrc_grp_45_rsrc_type,
>   		      0x00000508, 0x0020);
>   
>   static const u32 ipa_reg_dst_rsrc_grp_67_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>   };
>   
>   IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_67_RSRC_TYPE, dst_rsrc_grp_67_rsrc_type,

