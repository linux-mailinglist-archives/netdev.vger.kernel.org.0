Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21771523C18
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 19:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345950AbiEKR6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 13:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345952AbiEKR56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 13:57:58 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7B669B6D
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 10:57:57 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id a5so257467wrp.7
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 10:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QhMJGxt6vmpWWbnghdzZA/TMCh0IQXiQQ0rd51L5N3Q=;
        b=Xz6CVTJI4g3shgz0uSbRc5pNJ/HKTlTg04VLYHUt0WYLLzYG3de9RBxef/zQuUKSPg
         La9ykIhNZYA5C8UaYU+5JpRHe9uuPUGeIpsZ8eMAq2ehxEt/BUhz8invG5KmRmLLzdhe
         5aYzgNOhip/N0FX3ml+bq/nndEAS+QXMqG2GYsly7l/E0BrFWpldfBvGbEPxt7fM6v1n
         6R5KyH6vcMLx0314CaTGcfflmLrCSOMCjUGYBQ1WjbnyCI+PtBk1NU+VrQ0HTulez7FR
         bsl7yYTVtWeK8JSGXCTIiiM6yNlCuYbawiXsT5uPrzJ1x2PdHFckosh1leMnX/3E0d1L
         oWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QhMJGxt6vmpWWbnghdzZA/TMCh0IQXiQQ0rd51L5N3Q=;
        b=1AePsprVwaaGgxS3YeAQVYg5D+X4GHkjOKc9CKxCDyOhM2GrG221G3sD9f+1A8DNrF
         mJB1FOYwYba6iwk/zVrfGe5f+XNsxxNHzlmDAa38s9f1NKBLDirNyYqL2ZCT+LDJeBDq
         ibvdr8jE06uaP0sTCsjRegdNz2G1iJ0vPzBjliE11jUOMlSpRHEESa8PQUYSVnfXvI7h
         jwtQaqg2EDmuYXa71QCZrQUoIT/wC+YQPHEhoQu+k5QK5QGnx2xqPExRzz8B1HOQlho5
         8haTKhBODrYE5nZyPAXWCvdTKidpx9Smse3Vx61QUFM0f2ku1IZFW9o3mSoyOYbjK3s/
         SJsw==
X-Gm-Message-State: AOAM530MxWkeS4p/a48XV37DkrRjFycsV9QjVvDwdopjKpskz55g5NIU
        uMkz1xyLlXFPOenGcNN9k7w=
X-Google-Smtp-Source: ABdhPJy5iHGrjXOe2QesZYCcrgWeB+Bq9QGlXoan3ZOYXBzasSsytgZid4QJ9RZAwROdjCfxUp7t1g==
X-Received: by 2002:a05:6000:1569:b0:20c:4ed4:4ba8 with SMTP id 9-20020a056000156900b0020c4ed44ba8mr23376684wrz.270.1652291875868;
        Wed, 11 May 2022 10:57:55 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id o15-20020a5d684f000000b0020c5253d8fesm2287211wrw.74.2022.05.11.10.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 10:57:54 -0700 (PDT)
Subject: Re: [PATCH net-next 3/6] eth: switch to netif_napi_add_weight()
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Martin Habets <habetsm.xilinx@gmail.com>
References: <20220506170751.822862-1-kuba@kernel.org>
 <20220506170751.822862-4-kuba@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <d61cf1ea-94bc-6f71-77b6-939ba9e115c4@gmail.com>
Date:   Wed, 11 May 2022 18:57:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220506170751.822862-4-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/05/2022 18:07, Jakub Kicinski wrote:
> Switch all Ethernet drivers which use custom napi weights
> to the new API.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> index eec80b024195..3f28f9861dfa 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -1316,8 +1316,8 @@ void efx_init_napi_channel(struct efx_channel *channel)
>  	struct efx_nic *efx = channel->efx;
>  
>  	channel->napi_dev = efx->net_dev;
> -	netif_napi_add(channel->napi_dev, &channel->napi_str,
> -		       efx_poll, napi_weight);
> +	netif_napi_add_weight(channel->napi_dev, &channel->napi_str, efx_poll,
> +			      napi_weight);
>  }

This isn't really a custom weight; napi_weight is initialised to
 64 and never changed, so probably we ought to be just using
 NAPI_POLL_WEIGHT here and end up on the non-_weight API.
Same goes for Falcon.

-ed
