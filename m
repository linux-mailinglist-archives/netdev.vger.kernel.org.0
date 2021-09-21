Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2614B413A8C
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 21:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbhIUTNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 15:13:16 -0400
Received: from gateway30.websitewelcome.com ([192.185.160.12]:21257 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234240AbhIUTNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 15:13:15 -0400
X-Greylist: delayed 1414 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2021 15:13:15 EDT
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 12EF5302C2
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 13:48:10 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id SkoLmYgoRBvjySkoMmFpwH; Tue, 21 Sep 2021 13:48:10 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DE7tJmoJY542ECw3zNe99FgfYCCZRmZ+e7TMY8BcwkI=; b=ydXAntc8wo6PEex7KQ+biJ4Ok4
        kqiDaypCXy7PA53MZiT+wphL75V5V2rxZUxbVQgoM6i9XWx6YHoanCNTlPnV/ghZRgAl4st5d2GTC
        YNj5IXr0Eo2QmSeJtWn9EvgpsR3X5Fxu6EPd8caMyS87EaJ76Dr3Xd/wxm1h9WQW8GSCyaPJ4UGmd
        6B9wASWWXjU1ntxRGEOSF+W9MoisLFNceKTYv2u9DLSM8EmmqHtW5vnGO1HatUxZdF3PXXIoOYeVx
        3a0+t6BATb/sMe3rsoAEBtL8SOL/VUjecYux4JxBNpyqIn3Su9bHGghNb+X4QcRKy9Bjh/tEge5P/
        582q5ptA==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:36692 helo=[192.168.15.9])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1mSkoL-0010W9-Ey; Tue, 21 Sep 2021 13:48:09 -0500
Subject: Re: [PATCH] nl80211: prefer struct_size over open coded arithmetic
To:     Len Baker <len.baker@gmx.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210919114040.41522-1-len.baker@gmx.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <47961463-5b2c-dd6f-0e98-ea95c13409fb@embeddedor.com>
Date:   Tue, 21 Sep 2021 13:51:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210919114040.41522-1-len.baker@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1mSkoL-0010W9-Ey
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.9]) [187.162.31.110]:36692
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 17
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/19/21 06:40, Len Baker wrote:
> As noted in the "Deprecated Interfaces, Language Features, Attributes,
> and Conventions" documentation [1], size calculations (especially
> multiplication) should not be performed in memory allocator (or similar)
> function arguments due to the risk of them overflowing. This could lead
> to values wrapping around and a smaller allocation being made than the
> caller was expecting. Using those allocations could lead to linear
> overflows of heap memory and other misbehaviors.
> 
> So, use the struct_size() helper to do the arithmetic instead of the
> argument "size + count * size" in the kzalloc() functions.
> 
> Also, take the opportunity to refactor the memcpy() call to use the
> flex_array_size() helper.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> 
> Signed-off-by: Len Baker <len.baker@gmx.com>
> ---
>  net/wireless/nl80211.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index bf7cd4752547..b56856349ced 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -11766,9 +11766,10 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
>  	wdev_lock(wdev);
>  	if (n_thresholds) {
>  		struct cfg80211_cqm_config *cqm_config;
> +		size_t size = struct_size(cqm_config, rssi_thresholds,
> +					  n_thresholds);
> 
> -		cqm_config = kzalloc(sizeof(struct cfg80211_cqm_config) +
> -				     n_thresholds * sizeof(s32), GFP_KERNEL);
> +		cqm_config = kzalloc(size, GFP_KERNEL);

I don't think variable _size_ is needed here; this is just fine:

-               cqm_config = kzalloc(sizeof(struct cfg80211_cqm_config) +
-                                    n_thresholds * sizeof(s32), GFP_KERNEL);
+               cqm_config = kzalloc(struct_size(cqm_config, rssi_thresholds,
+                                                n_thresholds), GFP_KERNEL);

Thanks
--
Gustavo

>  		if (!cqm_config) {
>  			err = -ENOMEM;
>  			goto unlock;
> @@ -11777,7 +11778,8 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
>  		cqm_config->rssi_hyst = hysteresis;
>  		cqm_config->n_rssi_thresholds = n_thresholds;
>  		memcpy(cqm_config->rssi_thresholds, thresholds,
> -		       n_thresholds * sizeof(s32));
> +		       flex_array_size(cqm_config, rssi_thresholds,
> +				       n_thresholds));
> 
>  		wdev->cqm_config = cqm_config;
>  	}
> @@ -15081,9 +15083,7 @@ static int nl80211_set_sar_specs(struct sk_buff *skb, struct genl_info *info)
>  	if (specs > rdev->wiphy.sar_capa->num_freq_ranges)
>  		return -EINVAL;
> 
> -	sar_spec = kzalloc(sizeof(*sar_spec) +
> -			   specs * sizeof(struct cfg80211_sar_sub_specs),
> -			   GFP_KERNEL);
> +	sar_spec = kzalloc(struct_size(sar_spec, sub_specs, specs), GFP_KERNEL);
>  	if (!sar_spec)
>  		return -ENOMEM;
> 
> --
> 2.25.1
> 
