Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1F127075F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgIRUsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIRUsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:48:38 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D28C0613CE;
        Fri, 18 Sep 2020 13:48:38 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id 26so227123ois.5;
        Fri, 18 Sep 2020 13:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ii/a5TVzrND5+9vtRgxUQeAL0VhKFwFUkCqijmB8xsE=;
        b=OT53HBsYDObbjQNq1TdBrbqrpo+ilPSB+FONA/PD+YTYpeNhfk0QuknAMjLm7M0W7+
         5hHj6Hp3oWu6o1hCIw+qhtXsqLjHJuCcaYMaGFh4jZaOtYm9YYY0orCCsyWEoExrydn4
         vfR5MPZIgxiw8/1BrU/1pdFi0hFN0z8S2RnrhdiGv5w+0KSvaVuvhPyMGug7fHNQ7yyo
         2hCsD0GlOaolXxy0DZ384fpBcr3X9YrAE1TzEm2HylAkHYx43voPKKGSF/9LMLUZTeod
         geVEFQVtZFqwmY7Cdz4a8QTsLWDwDApizofP1+j2Gghl+IySEK+6/y9NkQdrgEZ7yLSY
         iszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ii/a5TVzrND5+9vtRgxUQeAL0VhKFwFUkCqijmB8xsE=;
        b=YOYC16xBHXxFFE6qxOqCKDjaL7aqJxICrclQAweXJjwEef4eFcA9cELm2YdBVR9tOI
         8hiIHP4GV2pEKDMj/Z1jVibWdZdbULH8MSdmkwQRXvpX0+zqkFN0s8N492ceJBBkuNtI
         oUwpRDM/nvcDhPQ8xre9y4FNpysv497tyC4QsswU2FyfQFwutuaSqLnim+ogsv/OLH+n
         mVIlgp0GTPXC6cnL/NFrAlDGR16etfNxFf1JjuATlfP27FYpf+nqnjVC4Yqfkk3x9u1h
         Wy+IC8RQpWK1yQFIfDol8NZKP3STmMVpWnQpMRrqU3wek6ISj8beGLhxeon0Gk5jvbn6
         ZRZA==
X-Gm-Message-State: AOAM532wiAyFrq3+J2PqjttihNi31mxL8amyMBjZ5uUcoUyrg9fSaqiB
        IgP/26mr3Im3ipvrMnGefUM=
X-Google-Smtp-Source: ABdhPJxE/N19Zv1kM0gHN11VoOZIgomIwhQsn0HvI/lq6xLlxC1bRJWhRG/tERsGVpfVoEdSYkLqVg==
X-Received: by 2002:a05:6808:914:: with SMTP id w20mr11057477oih.72.1600462117671;
        Fri, 18 Sep 2020 13:48:37 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id i7sm3115488oto.62.2020.09.18.13.48.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 13:48:37 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH -next 6/9] rtlwifi: rtl8192cu: fix comparison to bool
 warning in hw.c
To:     Zheng Bin <zhengbin13@huawei.com>, pkshih@realtek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yi.zhang@huawei.com
References: <20200918102505.16036-1-zhengbin13@huawei.com>
 <20200918102505.16036-7-zhengbin13@huawei.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <3b955861-b53f-d1e0-bdb6-87c7d5abde35@lwfinger.net>
Date:   Fri, 18 Sep 2020 15:48:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918102505.16036-7-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/20 5:25 AM, Zheng Bin wrote:
> Fixes coccicheck warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c:831:14-49: WARNING: Comparison to bool
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> index 3061bd81f39e..6312fddd9c00 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> @@ -828,7 +828,7 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
>   					? WMM_CHIP_B_TX_PAGE_BOUNDARY
>   					: WMM_CHIP_A_TX_PAGE_BOUNDARY;
>   	}
> -	if (false == rtl92c_init_llt_table(hw, boundary)) {
> +	if (!rtl92c_init_llt_table(hw, boundary)) {
>   		pr_err("Failed to init LLT Table!\n");
>   		return -EINVAL;
>   	}
> --
> 2.26.0.106.g9fadedd
> 

