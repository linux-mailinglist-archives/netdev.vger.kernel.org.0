Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03413333231
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhCJANj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 19:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbhCJANS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 19:13:18 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70504C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 16:13:18 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id i8so15983809iog.7
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 16:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oJsimWQGv+nfxwJDcSHm6XWSpSKmLLqWw1knhzFY0+I=;
        b=hpDGePcJHeIO2+zoYEJui6H5jSM+l6RyrqjBSr9A7PrVNLB7AySkl0dhjyxxmbiCzI
         qMhkNBpFAAUEPNRUhZEs7q9iIh2yx6tSHKaVpeSwCDcPt2DwYrUFO4k+XoTOIELhOCw6
         pKxLewzr93w2+DTmxcCjQ97s07devVrRi2PxVuXYrmUL+uZea8rfkV3ZvmOLPpERxvOT
         tQaBjDU8eLoa8K0iaTeEYqJ223kwR3LCjJF9trTh83Rl8a77u8rgK6MgqICNMrv8Hsc9
         S1SoWaOCtqH7qSy8C2qhQJGiRfMGpVsn1xl+L2GzMkgXKwCGQ+2e04W3ZhnYzmli3wSh
         nadw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oJsimWQGv+nfxwJDcSHm6XWSpSKmLLqWw1knhzFY0+I=;
        b=WCk8FQ5xbDo4rECGL9Btb4G9AZu3Ia/GOWX2T2DW/V70uHMycNEyz6Yg+YUJaaVTcv
         hGXUWWNXlCaJGc4rMpIy3m6ciCfdzlxnO/CRLYubKXfjhXDPTnheNrbHyCqqqdsHtbDg
         hYfwOkUk13EFXOnMauq+viq8BRhXDsm0WCyGvyFYsuR638RR40mbJJvO8iX9HYNm1P1K
         84sU5j4V7Ua+FS1Au8QmQ6O3RL2DklQNefsWTglHTbewxdxbOXRIswjumys6EG0FXmaf
         wtOfCYqghSsVSaITbvBi9+jT/kmPLmQcV8EvMAMPmWsRBhjCum64jHHXcsUcwnRLEEpo
         3TpA==
X-Gm-Message-State: AOAM530AEhuVzNUraS/3e5igjrsS84DbITdon76SdSxr0FrqkJkx9EB3
        HW6mu9Zpq64/fuCTcRJtDwpTHtrkTnEq4A==
X-Google-Smtp-Source: ABdhPJxPhLWA9b0o8Cp2L2/0E0XyrzO2t12cXRkOhnBLB0EFYKshKgK03H+2x5YneNbJnx1ZC/E3Sg==
X-Received: by 2002:a6b:6618:: with SMTP id a24mr580607ioc.100.1615335197895;
        Tue, 09 Mar 2021 16:13:17 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id e195sm8269790iof.51.2021.03.09.16.13.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 16:13:17 -0800 (PST)
Subject: Re: [PATCH net-next v3 5/6] net: qualcomm: rmnet: don't use C
 bit-fields in rmnet checksum trailer
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210309124848.238327-1-elder@linaro.org>
 <20210309124848.238327-6-elder@linaro.org>
Message-ID: <ad9a6bf4-a850-69d2-ec20-cbafcfa5b22b@linaro.org>
Date:   Tue, 9 Mar 2021 18:13:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210309124848.238327-6-elder@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/21 6:48 AM, Alex Elder wrote:
> Replace the use of C bit-fields in the rmnet_map_dl_csum_trailer
> structure with a single one-byte field, using constant field masks
> to encode or get at embedded values.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
> v3: Use BIT(x) and don't use u8_get_bits() for the checksum valid flag
> 
>   .../ethernet/qualcomm/rmnet/rmnet_map_data.c    |  2 +-
>   include/linux/if_rmnet.h                        | 17 +++++++----------
>   2 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> index 3291f252d81b0..72dbbe2c27bd7 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> @@ -365,7 +365,7 @@ int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len)
>   
>   	csum_trailer = (struct rmnet_map_dl_csum_trailer *)(skb->data + len);
>   
> -	if (!csum_trailer->valid) {
> +	if (csum_trailer->flags & MAP_CSUM_DL_VALID_FLAG) {

This was the actual problem.  The result of the new
test is the reverse of what it should be.

In any case, I'm taking a break from this for a while.

					-Alex

>   		priv->stats.csum_valid_unset++;
>   		return -EINVAL;
>   	}
> diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
> index 22ccc89bb5d8e..a848bb2e0dad0 100644
> --- a/include/linux/if_rmnet.h
> +++ b/include/linux/if_rmnet.h
> @@ -19,21 +19,18 @@ struct rmnet_map_header {
>   #define MAP_PAD_LEN_FMASK		GENMASK(5, 0)
>   
>   struct rmnet_map_dl_csum_trailer {
> -	u8  reserved1;
> -#if defined(__LITTLE_ENDIAN_BITFIELD)
> -	u8  valid:1;
> -	u8  reserved2:7;
> -#elif defined (__BIG_ENDIAN_BITFIELD)
> -	u8  reserved2:7;
> -	u8  valid:1;
> -#else
> -#error	"Please fix <asm/byteorder.h>"
> -#endif
> +	u8 reserved1;
> +	u8 flags;			/* MAP_CSUM_DL_*_FMASK */
>   	__be16 csum_start_offset;
>   	__be16 csum_length;
>   	__be16 csum_value;
>   } __aligned(1);
>   
> +/* rmnet_map_dl_csum_trailer flags field:
> + *  VALID:	1 = checksum and length valid; 0 = ignore them
> + */
> +#define MAP_CSUM_DL_VALID_FLAG		BIT(0)
> +
>   struct rmnet_map_ul_csum_header {
>   	__be16 csum_start_offset;
>   #if defined(__LITTLE_ENDIAN_BITFIELD)
> 

