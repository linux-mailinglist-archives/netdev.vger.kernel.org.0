Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF5D4081B9
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 22:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbhILVAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 17:00:20 -0400
Received: from gateway20.websitewelcome.com ([192.185.46.107]:37668 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231560AbhILVAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 17:00:19 -0400
X-Greylist: delayed 1257 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Sep 2021 17:00:19 EDT
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 0380B400D376E
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 15:19:41 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id PWEomy2efK61iPWEom5bkz; Sun, 12 Sep 2021 15:38:06 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bTvHNmRto0c3Q12aHNZXcfzC8RmgCTvLXG0gbaQDzZs=; b=fAFqb0RbOxCoSFvl4espjd21av
        6BKxxHMhumwxxYvF9U5YBgP72ZOBqSQ/OTdemj8UD1PxU2WU1+6K7LSMDZ9SmSUGwZ2MikTf6wBgu
        e6/yNw+EuSlEPl8YCr9RdLOg0pr39n1V55xqvIpvQKp75J9VghU4Q3xGfxXVzk0BhHvcoDcH+usbJ
        qtGFv0dDw8I+aylk5RKvmHON6lX5EJY8ZVdGk7ZxshOyR3y7pS74+YAtiBEf7jEUYieGrtilq7qSl
        LFfCoT1il5VxYWOQAdxkTSlrSkiGOSKoco4vv9hj3WQynZKVA0uKbHv3mZgJIAcZzq1PVwJQs4GRW
        OLDyRstA==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:57174 helo=[192.168.15.9])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1mPWEo-000Mwx-5W; Sun, 12 Sep 2021 15:38:06 -0500
Subject: Re: [Intel-wired-lan] [PATCH] ice: Prefer kcalloc over open coded
 arithmetic
To:     Len Baker <len.baker@gmx.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-hardening@vger.kernel.org
References: <20210905065020.8402-1-len.baker@gmx.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <8cd5adaf-6f83-d3df-abd2-b668d29b50a1@embeddedor.com>
Date:   Sun, 12 Sep 2021 15:41:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210905065020.8402-1-len.baker@gmx.com>
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
X-Exim-ID: 1mPWEo-000Mwx-5W
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.9]) [187.162.31.110]:57174
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/5/21 01:50, Len Baker wrote:
> As noted in the "Deprecated Interfaces, Language Features, Attributes,
> and Conventions" documentation [1], size calculations (especially
> multiplication) should not be performed in memory allocator (or similar)
> function arguments due to the risk of them overflowing. This could lead
> to values wrapping around and a smaller allocation being made than the
> caller was expecting. Using those allocations could lead to linear
> overflows of heap memory and other misbehaviors.
> 
> In this case this is not actually dynamic sizes: both sides of the
> multiplication are constant values. However it is best to refactor this
> anyway, just to keep the open-coded math idiom out of code.
> 
> So, use the purpose specific kcalloc() function instead of the argument
> size * count in the kzalloc() function.
> 
> [1] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> 
> Signed-off-by: Len Baker <len.baker@gmx.com>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

BTW... Len, feel free to CC me on all your patches related to KSPP work. :)

Thanks
--
Gustavo

> ---
>  drivers/net/ethernet/intel/ice/ice_arfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
> index 88d98c9e5f91..3071b8e79499 100644
> --- a/drivers/net/ethernet/intel/ice/ice_arfs.c
> +++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
> @@ -513,7 +513,7 @@ void ice_init_arfs(struct ice_vsi *vsi)
>  	if (!vsi || vsi->type != ICE_VSI_PF)
>  		return;
> 
> -	arfs_fltr_list = kzalloc(sizeof(*arfs_fltr_list) * ICE_MAX_ARFS_LIST,
> +	arfs_fltr_list = kcalloc(ICE_MAX_ARFS_LIST, sizeof(*arfs_fltr_list),
>  				 GFP_KERNEL);
>  	if (!arfs_fltr_list)
>  		return;
> --
> 2.25.1
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
> 
