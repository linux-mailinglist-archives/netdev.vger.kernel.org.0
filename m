Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68052270752
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgIRUrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgIRUrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:47:41 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B074C0613CE;
        Fri, 18 Sep 2020 13:47:41 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id a2so6592000otr.11;
        Fri, 18 Sep 2020 13:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fjLUBBkNYRNts2lWPX+gVf9aF11G3Xxzq9mQdqSzF28=;
        b=onfwCGpYJskG/64FG+WpQXptndQupzPdHGfVajzBf2EZW/sFFdf7xmzd3IFtBebo9o
         5iImK8XnQMt4rPPweI++wIGomvbB64xJTT/Q5yS1kgLT0NumbXcAow5NIYENgbFuex0y
         8O9yjKv+Y/dFqn7jsUOhRD7DKy3ij4g5Sdxr9FdgOfEswmZzgIKhfsKgEsoZavLmV/et
         RktR5tWiwwkx3cbV9ZsUCP6FALgM3BmEeAITzDlKpv6o8AWICN6UqADhUQkGBXHGo6Fv
         ynARRXgy04xi76Wt0C0tl4zLyEp6VEBcxWM4fA7Q4aMRBXVkHpRDoe06p1VXJXu8dHVe
         gSNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fjLUBBkNYRNts2lWPX+gVf9aF11G3Xxzq9mQdqSzF28=;
        b=hdWQv4IJZctz+TxNekUlB44Et0XgiH5KH1SnVzbvOW9fK9vPgNQ7xI4aP3hD8+VYih
         6F3MaG1OmscIQuLJ7NQ1bSe36JcQrRlL2s0fp3Vxu3gMyRzG9wiDRAlo/u3a9eDi10cP
         XbPDz+qS5FMyjiW1w1MfOuADnDofMiQeZDTff+XuvIC1hrdwlOxrEPug5jbuAek7iCvG
         bkbFM8H18GELYNDnP1UazVlnaUWvZ4Uw3YsnjCqRQgK3T5uNQ5lAXh3Rh22Fbqblh3h6
         u6d4pNjtiDmLP2YXOmM1KsJzqmfA4yzwZxQX+40F3LjP0FcQVqioTlQAo3OdFta1AAnd
         hQGQ==
X-Gm-Message-State: AOAM531Qy2jfRFL1dgnXTCRZt8y6VeU/QT88MVG3mobbjdKgAuZgHd/h
        3GgDnYfsF3Qlw4wMlru4WIs=
X-Google-Smtp-Source: ABdhPJzLVFqsX8a+6Drui7SlJKLkJFmBr+lhFJGW9pjcDAUWQaCcW/rP7IEDCv8Ct1U4jQFGlMo2mQ==
X-Received: by 2002:a9d:57c3:: with SMTP id q3mr22427156oti.146.1600462060846;
        Fri, 18 Sep 2020 13:47:40 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id a13sm3535682oib.35.2020.09.18.13.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 13:47:40 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH -next 3/9] rtlwifi: rtl8192cu: fix comparison to bool
 warning in mac.c
To:     Zheng Bin <zhengbin13@huawei.com>, pkshih@realtek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yi.zhang@huawei.com
References: <20200918102505.16036-1-zhengbin13@huawei.com>
 <20200918102505.16036-4-zhengbin13@huawei.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <b6dec9a5-4778-6e57-4be7-3c998482140a@lwfinger.net>
Date:   Fri, 18 Sep 2020 15:47:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918102505.16036-4-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/20 5:24 AM, Zheng Bin wrote:
> Fixes coccicheck warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:161:14-17: WARNING: Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:168:13-16: WARNING: Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:179:14-17: WARNING: Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:186:13-16: WARNING: Comparison to bool
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
> index d7afb6a186df..2890a495a23e 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
> @@ -158,14 +158,14 @@ bool rtl92c_init_llt_table(struct ieee80211_hw *hw, u32 boundary)
> 
>   	for (i = 0; i < (boundary - 1); i++) {
>   		rst = rtl92c_llt_write(hw, i , i + 1);
> -		if (true != rst) {
> +		if (!rst) {
>   			pr_err("===> %s #1 fail\n", __func__);
>   			return rst;
>   		}
>   	}
>   	/* end of list */
>   	rst = rtl92c_llt_write(hw, (boundary - 1), 0xFF);
> -	if (true != rst) {
> +	if (!rst) {
>   		pr_err("===> %s #2 fail\n", __func__);
>   		return rst;
>   	}
> @@ -176,14 +176,14 @@ bool rtl92c_init_llt_table(struct ieee80211_hw *hw, u32 boundary)
>   	 */
>   	for (i = boundary; i < LLT_LAST_ENTRY_OF_TX_PKT_BUFFER; i++) {
>   		rst = rtl92c_llt_write(hw, i, (i + 1));
> -		if (true != rst) {
> +		if (!rst) {
>   			pr_err("===> %s #3 fail\n", __func__);
>   			return rst;
>   		}
>   	}
>   	/* Let last entry point to the start entry of ring buffer */
>   	rst = rtl92c_llt_write(hw, LLT_LAST_ENTRY_OF_TX_PKT_BUFFER, boundary);
> -	if (true != rst) {
> +	if (!rst) {
>   		pr_err("===> %s #4 fail\n", __func__);
>   		return rst;
>   	}
> --
> 2.26.0.106.g9fadedd
> 

