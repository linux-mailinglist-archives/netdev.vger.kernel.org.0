Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787BE3FC41C
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 10:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240207AbhHaII6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 04:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240195AbhHaIIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 04:08:54 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A12C061575;
        Tue, 31 Aug 2021 01:07:58 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id d22-20020a1c1d16000000b002e7777970f0so1351951wmd.3;
        Tue, 31 Aug 2021 01:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MnhSLTH8eLra+aU3jtPLmoRBRTI1Oo6K9jHTpVGmJYg=;
        b=caogiY8rcJNBgStQAg1BdfbIHwoVbocbGp49VEZ0hBckAp8JqoBZ5C6XHmKroAyDjO
         xG+chLdbfBcmhGESMy3eoJVR0DwzUQwYiRss+PYoN/A4gUSybfRhvahXW73xAsOgBffz
         3yufojTJdktVIecXKhIiZArtxNpz6pYj72Xf1sM0zFfoPkRXdCTiyLyog0drM45qCTGE
         cnCoY3nxdNNglEa79n5ZrjJPHFVjlihmkTa8Q2+uwJWF6OxKdZDxdRZhSlcCC4XNbCNF
         m6wp9RDx1xWp12WgxJezx/wbMZcb81U3Qsx9Xl3Xh5P/S0htIfztmNB/94Z0o+fvgbfh
         aHCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MnhSLTH8eLra+aU3jtPLmoRBRTI1Oo6K9jHTpVGmJYg=;
        b=fn7heXVY3MzPJQeNOQhLdVB9YcpCLP6+F9beq7nqI3uSeZc/V3yJ5j1p1zeTUsUdbo
         L9kVFOF7CQtg5P3xs7jwemhnLm9L38JFnn2+Q1WzOemgfFVqWOQbFQzAK6ThwWHqOIKb
         cparSvV+JILpb76wdVj2F3nFB3HcI7Cd1JvJD2LeslPAjqs/jvAUFkWgrcDMVRwDHPNa
         HRTygEDrB8aLV56YXQe61lTJxHwaHs0BADPhwXeKerPuOlY8zm/c9JqjqrPatvhS6fwf
         ha4mvo7A+d5PABqHM0A1cPvvktu+H+AwmZtF7NNj4rTPFGC1A5lTtdykmRfR7uYRQWiZ
         42ag==
X-Gm-Message-State: AOAM530UogoioLT9yb0G2AuKH+89Ynd7tGoptf5CbzTxhMWoh3/tH7R9
        aHtk0AAW/OymGMqc3u7HI6OXbphV5OU=
X-Google-Smtp-Source: ABdhPJyNV/Bln0OqLvVo6nX9QT0XaKxNR879yM2JzHyRsi11M8JoBlW5x5Vr6s7/ZvdH+s/rfgJw+A==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr2915784wmk.51.1630397277492;
        Tue, 31 Aug 2021 01:07:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:7054:c5a4:5c4c:e530? (p200300ea8f0845007054c5a45c4ce530.dip0.t-ipconnect.de. [2003:ea:8f08:4500:7054:c5a4:5c4c:e530])
        by smtp.googlemail.com with ESMTPSA id k25sm18571391wrd.42.2021.08.31.01.07.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 01:07:56 -0700 (PDT)
To:     cgel.zte@gmail.com, rajur@chelsio.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chi Minghao <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20210831062255.13113-1-chi.minghao@zte.com.cn>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] cxgb4: remove unneeded variable
Message-ID: <90c48d79-29e5-ec9e-273d-5598fc4f5fab@gmail.com>
Date:   Tue, 31 Aug 2021 10:07:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210831062255.13113-1-chi.minghao@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.08.2021 08:22, cgel.zte@gmail.com wrote:
> From: Chi Minghao <chi.minghao@zte.com.cn>
> 
> Fix the following coccicheck REVIEW:
> ./drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:3266:5-8 REVIEW Unneeded
> variable
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Chi Minghao <chi.minghao@zte.com.cn>

This patch is simply wrong and obviously not even compile-tested.
You would have found out by looking 5s at the code of the function.
Look at what the FIRST_RET macro is doing.
Please don't blindly trust tools and check patches proposed by tools.

> ---
>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> index 5e8ac42ac6ab..c986a414414b 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> @@ -3263,8 +3263,6 @@ int t4_get_scfg_version(struct adapter *adapter, u32 *vers)
>   */
>  int t4_get_version_info(struct adapter *adapter)
>  {
> -	int ret = 0;
> -
>  	#define FIRST_RET(__getvinfo) \
>  	do { \
>  		int __ret = __getvinfo; \
> @@ -3280,7 +3278,7 @@ int t4_get_version_info(struct adapter *adapter)
>  	FIRST_RET(t4_get_vpd_version(adapter, &adapter->params.vpd_vers));
>  
>  	#undef FIRST_RET
> -	return ret;
> +	return 0;
>  }
>  
>  /**
> 

