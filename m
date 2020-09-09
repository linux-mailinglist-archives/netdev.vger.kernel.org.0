Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8D1263186
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730999AbgIIQQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730995AbgIIQMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:12:49 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B111DC061795
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 04:53:19 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id u20so2006647ilk.6
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 04:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h/sZ1uzeumtgrunqJv1IilUpq0Y//RwPDbB/FiznfE0=;
        b=Iye7sLmYs1YKbtPfsmtNSE1fjp6xINJmasUJH2zx9suBZsXlfOBHf/Bau1OaTqNi43
         T0F/0rP1ja69j0HYugXe3pWU9+nyezMEvekO66eKg6thZprVfYUx9XAkv2K+eBfu9hsb
         r0hVctbXYRYcM93Nto+GmCMd7KB2rH2c3dZmeg4fMrPhHMcp6NQ8i7h3JxtNg823rTOJ
         1lpsG2xxXMu/0/m5tDd5K8LLJDqzbSEENdj57dOvtGmNQ+Gifx7/OqXFoprCUR5jW6+p
         W3ZM/ytJZw3Il+2RjwOgrzEevA12vyHEtZMVxBq6q5RSsngnUtk1YJKPIgRaxHHGKpVX
         dXSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h/sZ1uzeumtgrunqJv1IilUpq0Y//RwPDbB/FiznfE0=;
        b=VYOG1IgrrPjbmgyxTiHOGZGnVfBba6R2pDi2BxgU1hjzMxAX307azNgra1P2nQBF/B
         N9vUHkpZslWLJll/2L5e3X2/NUDhn2dZ1s0zTZqOo23AP4jzOKtBtjwPF4rL21kOF75u
         TpK1b7pt3+hHleFOog6ikC+Gr5GZja7dNYCjyuiUni8kkdIckINfVcFWKkJJ32eck3ZQ
         vnZdbuoCCgvjCRV9YCFhRrDWgiuSDg6DlVXQtrQ6J54QaPUDhfFg1mrUlOhVxJLUl6vC
         6xKF1qiDMqB1oaLVV6q/qpV9jnpoiLo0kYOYqaEwwBiUwdgzyGPQ7kRqoawPQzZIyhmO
         ZcNg==
X-Gm-Message-State: AOAM533o5U9+4CZR+JhKjmca50nZeDGwafoGGmAB+c2i/ma2bb3jd/bu
        YzPhRplBCJ825vYrrJS2DrNw5w==
X-Google-Smtp-Source: ABdhPJxVUSxkjm3sEQPqlYfwGwgS6iRmfqRvKD4Ebfn2d4E9I8C2b/F+2ldjVsBk6//GAq6f57E1sg==
X-Received: by 2002:a92:bf0a:: with SMTP id z10mr3517882ilh.39.1599652399048;
        Wed, 09 Sep 2020 04:53:19 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id b8sm1095647ioa.33.2020.09.09.04.53.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 04:53:18 -0700 (PDT)
Subject: Re: [RFT net] net: ipa: fix u32_replace_bits by u32p_xxx version
To:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20200908143237.8816-1-vadym.kochan@plvision.eu>
From:   Alex Elder <elder@linaro.org>
Message-ID: <030185d3-8401-dd2f-8981-9dfe2239866a@linaro.org>
Date:   Wed, 9 Sep 2020 06:53:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200908143237.8816-1-vadym.kochan@plvision.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 9:32 AM, Vadym Kochan wrote:
> Looks like u32p_replace_bits() should be used instead of
> u32_replace_bits() which does not modifies the value but returns the
> modified version.
> 
> Fixes: 2b9feef2b6c2 ("soc: qcom: ipa: filter and routing tables")
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>

You are correct!  Thank you for finding this.

Your fix is good, and I have now tested it and verified it
works as desired.

FYI, this is currently used only for the SDM845 platform.  It turns
out the register values (route and filter hash config) that are read
and intended to be updated always have value 0, so (fortunately) your
change has no effect there.

Nevertheless, you have fixed this bug and I appreciate it.

Reviewed-by: Alex Elder <elder@linaro.org>

> ---
> Found it while grepping of u32_replace_bits() usage and
> replaced it w/o testing.
> 
>  drivers/net/ipa/ipa_table.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
> index 2098ca2f2c90..b3790aa952a1 100644
> --- a/drivers/net/ipa/ipa_table.c
> +++ b/drivers/net/ipa/ipa_table.c
> @@ -521,7 +521,7 @@ static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
>  	val = ioread32(endpoint->ipa->reg_virt + offset);
>  
>  	/* Zero all filter-related fields, preserving the rest */
> -	u32_replace_bits(val, 0, IPA_REG_ENDP_FILTER_HASH_MSK_ALL);
> +	u32p_replace_bits(&val, 0, IPA_REG_ENDP_FILTER_HASH_MSK_ALL);
>  
>  	iowrite32(val, endpoint->ipa->reg_virt + offset);
>  }
> @@ -573,7 +573,7 @@ static void ipa_route_tuple_zero(struct ipa *ipa, u32 route_id)
>  	val = ioread32(ipa->reg_virt + offset);
>  
>  	/* Zero all route-related fields, preserving the rest */
> -	u32_replace_bits(val, 0, IPA_REG_ENDP_ROUTER_HASH_MSK_ALL);
> +	u32p_replace_bits(&val, 0, IPA_REG_ENDP_ROUTER_HASH_MSK_ALL);
>  
>  	iowrite32(val, ipa->reg_virt + offset);
>  }
> 

