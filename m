Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852081B9F6B
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 11:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgD0JKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 05:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgD0JKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 05:10:47 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CDAC0610D5;
        Mon, 27 Apr 2020 02:10:47 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 188so18667306wmc.2;
        Mon, 27 Apr 2020 02:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v8OYpZNOLgP9t4cgS+lWeCMwxdaxqT3UXnjOJoxqS0Y=;
        b=BqT2KEPEMxn8IqVj7zJKlZqtf/b0Oy7iK02eNt7GWBNT2SBqk+rdbWEaml3cfFqH6p
         QQIq5WxIzUgk9NArIgTB04RWTrmj9sRV78xC6RzCkOoc3S5HKX/jzO1L0BkBJ/Eml2I9
         RL4uP3PWANi7w+GXoj5pBrcxv31qD5mMCp5f8q10J3MB8P4zC+xvRUyx8eMQVtXcZTjl
         DE3G3WtiyMIsH5RLVfyviJFnDcXpfW5Ou/KgtNTvIvXHSzYu8+Vw1UcBUTZ+JWqW2bjQ
         mnxDkFfHxn/lTYOkxp7+5HqN/5ukSkb4vYggZ+5r6tzuQU9OHEvWPqowbkovmIawsRhG
         goQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v8OYpZNOLgP9t4cgS+lWeCMwxdaxqT3UXnjOJoxqS0Y=;
        b=RPDCNsb9FT3yunwxSiZS4cdub2unWmcitn5UHwShBF19kHGl5IgvJsfvD0+i1j9uV6
         DKpcWFJu90ik7dTZ8dA6O6knskdya+SSVAcGO2Mj+UZdr3ZZc9xWqZjvVtjFd9tle9jw
         A4DvXEkuU+aXCWXEb2wSbsmYNl/1nzwCSfJe2Fd3k/fQpsoewzkQS6M8JgXs6DUqiM3j
         Wvv5/5V5/lgKNfo8KNcm2UvWsPdEoc/v9HdrmHG/O0CseSFVU00Ecihi0n8LZcnQ6cJh
         FCtlDA2xBssaQ0dPelOX+ZG5lDXwmcvXHq+SBTzaZJfFMwQ+sY89tXzbSFkVgNmyhlK7
         z1jQ==
X-Gm-Message-State: AGi0PuZ0VLGL4eOiEW0pdYRV7Oqa0/5cq1CG9P2MDxu4nTh3HTw8aObI
        /D7kzRQLGY+CWWGlKd5emKl9+5Kk
X-Google-Smtp-Source: APiQypKSCpGVCZs4NZkWauLtvGJ3ItDQAys5hbROeKn4kv73H5Cu0bGms1Pj/LrGlYx38WFqoTJRIQ==
X-Received: by 2002:a7b:c4c9:: with SMTP id g9mr24852983wmk.171.1587978645987;
        Mon, 27 Apr 2020 02:10:45 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:1925:3f70:bb74:e0a1? (p200300EA8F29600019253F70BB74E0A1.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1925:3f70:bb74:e0a1])
        by smtp.googlemail.com with ESMTPSA id k14sm20585389wrp.53.2020.04.27.02.10.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 02:10:45 -0700 (PDT)
Subject: Re: [PATCH] net: tc35815: Fix phydev supported/advertising mask
To:     Anthony Felice <tony.felice@timesys.com>
Cc:     Akshay Bhat <akshay.bhat@timesys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200427020101.3059-1-tony.felice@timesys.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <62ec43c6-e9e4-555b-4c91-dda22b3620c7@gmail.com>
Date:   Mon, 27 Apr 2020 11:10:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427020101.3059-1-tony.felice@timesys.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.04.2020 04:00, Anthony Felice wrote:
> Commit 3c1bcc8614db ("net: ethernet: Convert phydev advertize and
> supported from u32 to link mode") updated ethernet drivers to use a
> linkmode bitmap. It mistakenly dropped a bitwise negation in the
> tc35815 ethernet driver on a bitmask to set the supported/advertising
> flags.
> 
> Found by Anthony via code inspection, not tested as I do not have the
> required hardware.
> 
> Fixes: 3c1bcc8614db ("net: ethernet: Convert phydev advertize and supported from u32 to link mode")
> Signed-off-by: Anthony Felice <tony.felice@timesys.com>
> Reviewed-by: Akshay Bhat <akshay.bhat@timesys.com>
> ---
>  drivers/net/ethernet/toshiba/tc35815.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
> index 3fd43d30b20d..a1066fbb93b5 100644
> --- a/drivers/net/ethernet/toshiba/tc35815.c
> +++ b/drivers/net/ethernet/toshiba/tc35815.c
> @@ -643,7 +643,7 @@ static int tc_mii_probe(struct net_device *dev)
>  		linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, mask);
>  		linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, mask);
>  	}
> -	linkmode_and(phydev->supported, phydev->supported, mask);
> +	linkmode_andnot(phydev->supported, phydev->supported, mask);
>  	linkmode_copy(phydev->advertising, phydev->supported);
>  
>  	lp->link = 0;
> 
> base-commit: 55b2af1c23eb12663015998079992f79fdfa56c8
> 
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>

The complete structure of this code is quite weird (e.g. using module
parameters to force a link mode), but the driver seems to be too old
that anybody would spend effort on refactoring it.
