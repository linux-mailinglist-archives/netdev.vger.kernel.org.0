Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D87406FCA
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhIJQjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhIJQjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 12:39:31 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B456C061574;
        Fri, 10 Sep 2021 09:38:20 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id t19so5178017lfe.13;
        Fri, 10 Sep 2021 09:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5QwWlin4ZDvaZz8INndl7HFIc0CWI9paTvPrHzicgUs=;
        b=DUyvAmNot4XZwCNeqeKSLbIWXwtKyNpK9CSu8KQWthes7Z5JLPWMKwLOVx/BHZczvQ
         I/n8sRYB6s4vEk1ADPAj5goJ4z80hq3K6CX5/k2uaSkbcHBuzSTFLUNN3oI3+0qK9CxD
         c2PDrR2MGkAso0PWf+M3yaSqqXKGYMjD8GFvRGh7uxrvGGbDbdhhBtqmHdzsWRn8hfTp
         rZ6aG4IPiH0u7FNxzfp36biOhtWvnGRWrlFgp0ooVeGjP/uJY3r87EhxXoSJc4u/lM2r
         5kq8NHFPQN4fe8ay62pP74YwkZqr5mdz+y2K+roRYXMWS55DOKnI6fHbwfEvWqRyndI+
         3FGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5QwWlin4ZDvaZz8INndl7HFIc0CWI9paTvPrHzicgUs=;
        b=2VX0fdr59j1QZ2qHPdBw8oFrvWY8l8OvlpL3SPA8QsRLIRy+Z+bMATKI2e3ujh382i
         4BOIiWm+AGsFjccgodaT4yvpTT/aMn7oF4UsmU4GkGbvasHsF85a37TbpbNaV3UzplKC
         bc4sfkORWINNAG7NnM2iq+cXBrEw3Pshnoi5lZJPdEqeqXBDcwC+pRhCQFi3FPh2aVI+
         6mh18vQrYxsW5QnZs9BuVuE/MADK5+VWL9OV2grNPfIY3Bpj/u7Ds1nOVEqnNAMoNhdD
         Zp3JJrErx4x1whcJYEE5/w2yqDZ/MH/Fzc7+hadxWmh75ilQSX5xLCdoLy5YKTGAr7y1
         cOpg==
X-Gm-Message-State: AOAM530E6x/tu8joTOxoeOYMn9IHH8nSg6cHU3GqU3St6vFVxoF4B3Ok
        3ShQMzP4vnvHAv2mndoKvh657olP/bvG9Q==
X-Google-Smtp-Source: ABdhPJyBMNpyr6O/YeNDwI+y61ms2IlKVu+yvNY5ICj6QQaRGZ22URyufC1dKc7Zr1+Qr8oBeU+AUw==
X-Received: by 2002:ac2:4db9:: with SMTP id h25mr4667412lfe.298.1631291898449;
        Fri, 10 Sep 2021 09:38:18 -0700 (PDT)
Received: from kari-VirtualBox ([31.132.12.44])
        by smtp.gmail.com with ESMTPSA id u17sm675056lja.45.2021.09.10.09.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:38:17 -0700 (PDT)
Date:   Fri, 10 Sep 2021 19:38:16 +0300
From:   Kari Argillander <kari.argillander@gmail.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 17/31] staging: wfx: simplify hif_join()
Message-ID: <20210910163816.jsujo3hsw7roerd5@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
 <20210910160504.1794332-18-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210910160504.1794332-18-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 06:04:50PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> The new code is smaller.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/hif_tx.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/wfx/hif_tx.c b/drivers/staging/wfx/hif_tx.c
> index 6ffbae32028b..aea0ed55edc6 100644
> --- a/drivers/staging/wfx/hif_tx.c
> +++ b/drivers/staging/wfx/hif_tx.c
> @@ -306,10 +306,7 @@ int hif_join(struct wfx_vif *wvif, const struct ieee80211_bss_conf *conf,
>  		return -ENOMEM;
>  	body->infrastructure_bss_mode = !conf->ibss_joined;
>  	body->short_preamble = conf->use_short_preamble;
> -	if (channel->flags & IEEE80211_CHAN_NO_IR)
> -		body->probe_for_join = 0;
> -	else
> -		body->probe_for_join = 1;
> +	body->probe_for_join = !(channel->flags & IEEE80211_CHAN_NO_IR);

Also harder to read imo because this is negative. But I see that whole
code is made for really really really compact so maybe it's same style
as you have done in past.

>  	body->channel_number = channel->hw_value;
>  	body->beacon_interval = cpu_to_le32(conf->beacon_int);
>  	body->basic_rate_set =
> -- 
> 2.33.0
> 
