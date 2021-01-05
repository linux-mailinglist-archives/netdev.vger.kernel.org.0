Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EB62EA9DD
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 12:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbhAEL0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 06:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbhAEL0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 06:26:32 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED68C061796;
        Tue,  5 Jan 2021 03:25:51 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id x20so71720298lfe.12;
        Tue, 05 Jan 2021 03:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nREWbUi+bMkL9IZ2W3EDeCQCfPlDw/qtuVovcJ0X+z0=;
        b=BqhBclnBir0D1pSGWN/4sAR2kjYZ2C2YbuEO23FeeeD8GJegwTwG6OIV6D2D4heseo
         yk6Z1nJa2PzANspPpM8wsmo7lLUFUDb3sMounKtUxLSjeTzCmiOCuL5iaLYYWHSblaqD
         FoOGWO9498GaMLfLP+8NQko2tMkIZqcjRkCBMog+lszZhVf+izH93Xc2qVnUg+JKt/Q8
         JvovMxQDN3PNw51iCXgusdIm85Dcc5MJ3oj136dV04M5phm3DDlacOzbWmp7Ph/t0A8r
         oK71sU6tZH02C5BQYKIKAnpa4wK3OJpw3w42ZDdHf8M5LiWTZSVuaegnpupCRJbOEkEt
         MjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nREWbUi+bMkL9IZ2W3EDeCQCfPlDw/qtuVovcJ0X+z0=;
        b=QP9Z8pWGgcaU1pXWlR9zjMNCSoSE+tOCMduZXZg7js/kSIdm0yhOQriKor57MVwa4r
         LQuMtSd4YKDisRBDWYaeyn5wFMdDT9ITrTjHBEYEhg35ADI9FQbTKu0Zhvq/3KTBLqhv
         OBZj7Miavu2DilcXSPD5HyiQgdF/3GOvLvCczCYXbdbY5sh6ZTQl4QrtTX1zQfh4ofWY
         i8XJK6hkrS0RoQlL7/P89BEHdS6mAsL2f42SZEByEi0PVLFNLBu7hr/LDBsuMIRMmIoa
         RNON2e6ilIEYRtFQOzp6Bu4zsqFfjWmgrw8nV4AdLNGxdr3+1X/1kK6ii2w/9xPA9U66
         u38A==
X-Gm-Message-State: AOAM531pskCQDDLmChB8z6ZftfZm5Rj/0YnrWbTISxu6042l0qYKBT4x
        hIRR0WZ6j4qioW3JVEKaZvG+sTIzXDe8sOiBr+A=
X-Google-Smtp-Source: ABdhPJxYUrj2lpQfvkDaNBNvJq3CH36qG7xLrafEGcgCm0fm8THd6IyGlyQuzeCQ6wqhI8Xa/+cnJF31uzCJXSOQvxw=
X-Received: by 2002:a19:6547:: with SMTP id c7mr32790336lfj.14.1609845950349;
 Tue, 05 Jan 2021 03:25:50 -0800 (PST)
MIME-Version: 1.0
References: <20210105103525.28159-1-unixbhaskar@gmail.com>
In-Reply-To: <20210105103525.28159-1-unixbhaskar@gmail.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Tue, 5 Jan 2021 22:25:38 +1100
Message-ID: <CAGRGNgVVt-nPT0BtE+i2YWczDmmDVujRsbtqrDZta43QYs7o6Q@mail.gmail.com>
Subject: Re: [PATCH] drivers: rtlwifi: rtl8723ae: Fix word association in trx.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        zhengbin13@huawei.com, baijiaju1990@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bhaskar,

On Tue, Jan 5, 2021 at 9:39 PM Bhaskar Chowdhury <unixbhaskar@gmail.com> wrote:
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
> index 340b3d68a54e..59e0a04b167d 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
> @@ -673,7 +673,7 @@ bool rtl8723e_is_tx_desc_closed(struct ieee80211_hw *hw,
>
>         /**
>          *beacon packet will only use the first
> -        *descriptor defautly,and the own may not
> +        *descriptor de-faulty,and the own may not

Same comments here as the previous patches:

"de-faultly" makes less sense than "defaultly". This comment needs to
be re-written by someone who knows what's going on here.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
