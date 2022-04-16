Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A456503414
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiDPCEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 22:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiDPCEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 22:04:37 -0400
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717C31342DF;
        Fri, 15 Apr 2022 18:54:01 -0700 (PDT)
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-dacc470e03so9414001fac.5;
        Fri, 15 Apr 2022 18:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JSSksXfSHT8J5RaVPGQ9iInEYYQkEPPrA2/YVmqRfXs=;
        b=OU2Yqq+f86YpQJByLea2+P16BM8pxSSyWmk1uKVQm9hHeePVtZyDivMG10YhUTbIbw
         r+Lg4uSnR7ZRcHD0wUaQVXk7g72nWv1DcdTSBMpdx/8GtKC46hUtiKnHIYly4HbNYgG3
         3zZebYK2ItjOkSEAgK3SMa26KNQi3yvUXaNjwgxJpDW1K2lHXiNtUNmZl+bvvDvTGn99
         WxBcq29+4inQvCgIUQbE5uowI1ykjtiwxpvSaHxU9AnAB+COJy4VQKeV9xHHuRYUbNl1
         g2xuJEHq7422mYxkUjWKlBEeYl+vQp/FoxDHTTJpSzayNIsrn97+RnuOznmIx9PzbeUA
         0SAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JSSksXfSHT8J5RaVPGQ9iInEYYQkEPPrA2/YVmqRfXs=;
        b=Q0JfEQvsxc73HI8dA6GmBZpv9onAcdLcNezPV3aw7NgRqs/nTaqyV1wVqiI44b6SIB
         hquFtnIlPAyFpDYsQn/N7wjYtwhS/66BwDnJ/xlHPOkX9R/bGmcxJ6Rt+5x5X1iHhOyj
         hDizvy3qB+cJ5B6t81sdIceUOjrkIbp6NDHOFnEqAQNDeUJIk2DKkYeO60t+Oad8Np3c
         0s/QxVgmoLQfxeDtoRpGkHDxwiGmStTtxlXxcUJTcHD5RkKLX+pLVRcgbeEBkkRPE8Ow
         IvKZIlNCLWc7RcLi0Bkb1rSCKJ0bDVcAIFJcwkr2v1JnfReV7m06cQgqbsk1r2+dJZx7
         Jw8A==
X-Gm-Message-State: AOAM532Fl+tYP1oYBLsVZ5yJQKCmfScZ28rr+mEDJaDZNQDGWE8HWhOQ
        7g/UEyWgzt1Ti1a6ekIUrjAyr99i+EG6iw==
X-Google-Smtp-Source: ABdhPJw/Jj+ggFXWVzYqOMrwoGySpFgbznD2nqtFZEejK9A/D8nCrw3gYkqXuSkkRptU7a06zbilcw==
X-Received: by 2002:a17:90b:1c8f:b0:1b8:c6dc:ca61 with SMTP id oo15-20020a17090b1c8f00b001b8c6dcca61mr1702855pjb.13.1650073476694;
        Fri, 15 Apr 2022 18:44:36 -0700 (PDT)
Received: from d3 ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id q91-20020a17090a1b6400b001d0dcaf7920sm2917613pjq.6.2022.04.15.18.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 18:44:36 -0700 (PDT)
Date:   Sat, 16 Apr 2022 10:44:30 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Yihao Han <hanyihao@vivo.com>
Cc:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
Subject: Re: [PATCH v2] net: qlogic: qlcnic: simplify if-if to if-else
Message-ID: <Yloffi2Og9bS2fds@d3>
References: <20220415120949.86169-1-hanyihao@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415120949.86169-1-hanyihao@vivo.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-15 05:09 -0700, Yihao Han wrote:
> Replace `if (!pause->autoneg)` with `else` for simplification
> according to the kernel coding style:
> 
> "Do not unnecessarily use braces where a single statement will do."
> 
> ...
> 
> "This does not apply if only one branch of a conditional statement is
> a single statement; in the latter case use braces in both branches"
> 
> Please refer to:
> https://www.kernel.org/doc/html/v5.17-rc8/process/coding-style.html

This commit log is even more confusing than v1. Only the first line is
correct.

> 
> Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>

I did not suggest this change. Please remove the tag.

> Signed-off-by: Yihao Han <hanyihao@vivo.com>
> ---
> v2:edit commit message
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
> index bd0607680329..e3842eaf1532 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
> @@ -3752,7 +3752,7 @@ int qlcnic_83xx_set_pauseparam(struct qlcnic_adapter *adapter,
>  	if (ahw->port_type == QLCNIC_GBE) {
>  		if (pause->autoneg)
>  			ahw->port_config |= QLC_83XX_ENABLE_AUTONEG;
> -		if (!pause->autoneg)
> +		else
>  			ahw->port_config &= ~QLC_83XX_ENABLE_AUTONEG;
>  	} else if ((ahw->port_type == QLCNIC_XGBE) && (pause->autoneg)) {
>  		return -EOPNOTSUPP;
> -- 
> 2.17.1
> 
