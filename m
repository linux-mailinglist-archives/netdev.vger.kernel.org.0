Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4356E270762
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgIRUtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgIRUtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:49:02 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1635C0613CE;
        Fri, 18 Sep 2020 13:49:02 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id s17so1763814ooe.6;
        Fri, 18 Sep 2020 13:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TE4Y3ovgHTOwBCsrzFjt22p6tBgCRmLn4d8DQXc5xm0=;
        b=LR22OpT9nGJvEM9zyNxa6HzZkm8DEyBK+I4Q6bK1Zij+UyfAOGhPodBWxWwefQjy2M
         m1dYjTUs256Y3qY+BFXWL/AZPykHJ7PvraHjPwypPo4IXfxxK8NpR7f+GwtAmUhDKBGy
         47TRmzeAvqcru2wvCPX3w9mPjKm6jgaSNJIcRU0FeRP2rEnnUprN6G1BZlKTe8gdCtg1
         A2gNjv68UokI71/tUoC/6VNiIp+F2EAfO6qb+EhIpwLAwfX697D/9bgNict6G46mufsa
         ea4AfRVufgao5jvJZdj/9u1ixO8k0imodqjqZVaWZL6ONGEz6VXd7siFfLxqrOtT/6lT
         gVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TE4Y3ovgHTOwBCsrzFjt22p6tBgCRmLn4d8DQXc5xm0=;
        b=TL1VLejdCHnAfxOmhSc/pmuadp/E4N1HKGWbgcgBQrO+zO9YB4HYxBCCHn1HFEX9+W
         llqN7orI5bxvLwWfTl43WxbqPa638CpsU8u70xHtj25pqpsZAIfNkueW3Ze2uY8eS2jz
         7Ug1Ltps/DEZDrb50RVDiobUI4wxRr/qx8+72HskmMt3264TYHmK2nkWSJwLRJHdioUs
         P0wLRVcySZT56S7B8r37iP3Qw+4jPKpkf9N1iPBocbJ44lz4aKyJzJWtcEP36/WW1g79
         HCjCsQu1MHQBptActW0Nr5CRXW7UaDx86T0CLk3tsqJw0anSlZEfiEbxy0dvMa6OGs9P
         Au/g==
X-Gm-Message-State: AOAM533QSEkRBEpjUPZn0giQec1GhvXyDTA6lQuy0GTCp0jDX7oJlr5F
        ZcC0O/DtP4NTLEsnFv+lrxg=
X-Google-Smtp-Source: ABdhPJxWl3ZmB40TrYgfmeo7JHWnMkhk6fqZMWaqRKPUb9Oc6y6SLi57y9O4ujxEITP0D5k1QDPEwQ==
X-Received: by 2002:a4a:3308:: with SMTP id q8mr25440133ooq.48.1600462142223;
        Fri, 18 Sep 2020 13:49:02 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id j1sm3620830oig.45.2020.09.18.13.49.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 13:49:01 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH -next 7/9] rtlwifi: rtl8192ce: fix comparison to bool
 warning in hw.c
To:     Zheng Bin <zhengbin13@huawei.com>, pkshih@realtek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yi.zhang@huawei.com
References: <20200918102505.16036-1-zhengbin13@huawei.com>
 <20200918102505.16036-8-zhengbin13@huawei.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <b23f4341-4b85-28be-49c7-8d1efdad20d3@lwfinger.net>
Date:   Fri, 18 Sep 2020 15:49:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918102505.16036-8-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/20 5:25 AM, Zheng Bin wrote:
> Fixes coccicheck warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c:616:14-20: WARNING: Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c:621:13-19: WARNING: Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c:626:14-20: WARNING: Comparison to bool
> drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c:631:13-19: WARNING: Comparison to bool
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
> index d4cd186036fd..bb5a0c4aec93 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
> @@ -613,22 +613,22 @@ static bool _rtl92ce_llt_table_init(struct ieee80211_hw *hw)
> 
>   	for (i = 0; i < (txpktbuf_bndy - 1); i++) {
>   		status = _rtl92ce_llt_write(hw, i, i + 1);
> -		if (true != status)
> +		if (!status)
>   			return status;
>   	}
> 
>   	status = _rtl92ce_llt_write(hw, (txpktbuf_bndy - 1), 0xFF);
> -	if (true != status)
> +	if (!status)
>   		return status;
> 
>   	for (i = txpktbuf_bndy; i < maxpage; i++) {
>   		status = _rtl92ce_llt_write(hw, i, (i + 1));
> -		if (true != status)
> +		if (!status)
>   			return status;
>   	}
> 
>   	status = _rtl92ce_llt_write(hw, maxpage, txpktbuf_bndy);
> -	if (true != status)
> +	if (!status)
>   		return status;
> 
>   	return true;
> --
> 2.26.0.106.g9fadedd
> 

