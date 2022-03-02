Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F424CA2CD
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237701AbiCBLHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236360AbiCBLHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:07:22 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851236F4BF;
        Wed,  2 Mar 2022 03:06:37 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id i8so2141099wrr.8;
        Wed, 02 Mar 2022 03:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=E2P9iS3Je2xtRYNQbf594u+ZhYUMIabIgXxUGm6ODGg=;
        b=XDBi/VgM2pC+yfKexBdJowraPWQ9pDLo5J5uw0lSPu4iIxYax5L6nfzVEHQqe6yCHC
         8w1QEPPOeWHPyH/bUDuoTP1xo+3ZOfX9I+DculDZY8l4FR48Fc7pVaB6E/nHxL/TfgeN
         8ZN/Q7aJ/079M30Ap6Wk5q542ao4LOtiGfYnDn6EcrYv13BoFOFcvO7OmCpnVAD5vpXj
         Ixf8F5ZTDGVy5CznPVp6/rVB35r6GhrofIASwhSw/aL7uD1IpdlXy6RtaLRKH3Lr5dlq
         0Q95eRCjj0ET371T89RWv8K5uv1vRPyy98Zc6XE2XRilQRw/Hcio+S8P+CT/yUrTcPOR
         l46w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E2P9iS3Je2xtRYNQbf594u+ZhYUMIabIgXxUGm6ODGg=;
        b=pytTMizFrb2V78vvzTnQsknPH8iWnoRtDCcHHGXwN2XdMlb7FOFsyiikrE39aOOB2U
         h6CwtDAGqlHnAsbzYrT+5f/zbWpuyT6TCGDqQn8js9VdW1dxG8+le+yRNohr0N8hMuq8
         h7Jpjw1GmJYdsT8qT4SwEGPYajm/7gKPUKLM7UUuFGi2gExjAnhWz5rRj8l3TVHRtUm4
         UVeSjjRGQUr4UBq49NeF6hhm9K0Nw7VMuzBPTiGo2EVdQ86ItYOM//g/EsNfp0oF9xTk
         IrOYXlYk46HikA3jaOSy/VAWB1v/JAD+sFXZ7Cxt2q5i9cuhOMH7xV3n4IVK33u44AeS
         5rnQ==
X-Gm-Message-State: AOAM531ePnfdsFOANIuNeWSVqsd7gpNOfBQIk1jDsQ5vD2yu8/nysA08
        2xe0LxBjrYYb3NNYm/E/jrU=
X-Google-Smtp-Source: ABdhPJxF+X+kjDOeLlKYxPtIXbGBHiWyz+tjkvF6rLjESw5o5HWJ1vUVytl0RwHD09LW+tMhZNFd/g==
X-Received: by 2002:a5d:47ae:0:b0:1ef:d725:876e with SMTP id 14-20020a5d47ae000000b001efd725876emr9969292wrb.447.1646219196121;
        Wed, 02 Mar 2022 03:06:36 -0800 (PST)
Received: from ?IPV6:2a01:c22:7331:8a00:3d70:3e0f:83b8:3269? (dynamic-2a01-0c22-7331-8a00-3d70-3e0f-83b8-3269.c22.pool.telefonica.de. [2a01:c22:7331:8a00:3d70:3e0f:83b8:3269])
        by smtp.googlemail.com with ESMTPSA id u4-20020adfdb84000000b001e8d8ac5394sm17377635wri.110.2022.03.02.03.06.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 03:06:35 -0800 (PST)
Message-ID: <f519c59e-fdf0-14e8-8cce-c6c2d19cff8b@gmail.com>
Date:   Wed, 2 Mar 2022 12:06:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2] net: marvell: Use min() instead of doing it manually
Content-Language: en-US
To:     Haowen Bai <baihaowen88@gmail.com>,
        sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1646203686-30397-1-git-send-email-baihaowen88@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <1646203686-30397-1-git-send-email-baihaowen88@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.03.2022 07:48, Haowen Bai wrote:
> Fix following coccicheck warning:
> drivers/net/ethernet/marvell/mv643xx_eth.c:1664:35-36: WARNING opportunity for min()
> 
> Signed-off-by: Haowen Bai <baihaowen88@gmail.com>
> ---
>  drivers/net/ethernet/marvell/mv643xx_eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
> index 143ca8b..e3e79cf 100644
> --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
> +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
> @@ -1661,7 +1661,7 @@ mv643xx_eth_set_ringparam(struct net_device *dev, struct ethtool_ringparam *er,
>  	if (er->rx_mini_pending || er->rx_jumbo_pending)
>  		return -EINVAL;
>  
> -	mp->rx_ring_size = er->rx_pending < 4096 ? er->rx_pending : 4096;
> +	mp->rx_ring_size = min(er->rx_pending, (unsigned)4096);

Don't just use unsigned w/o int. Why not simply marking the constant as unsigned: 4096U ?
And again: You should at least compile-test it.

>  	mp->tx_ring_size = clamp_t(unsigned int, er->tx_pending,
>  				   MV643XX_MAX_SKB_DESCS * 2, 4096);
>  	if (mp->tx_ring_size != er->tx_pending)

