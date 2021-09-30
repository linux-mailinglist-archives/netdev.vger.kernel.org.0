Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00B641DB9E
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351584AbhI3N7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351513AbhI3N7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:59:44 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B18EC06176A;
        Thu, 30 Sep 2021 06:58:01 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t8so10286273wri.1;
        Thu, 30 Sep 2021 06:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=18QivVRaNgZyCxRZL4f3lI3BO5DrU07SsqJpq8mUAt8=;
        b=Px/631X1/iZuL3xLrC8H9nv1yXeXvbua7ytfVGkKwqw13CurMrMGHzMyasI+B/Qoi4
         u0hkEHrytDwgNZOUcIwhVdf78eM44TXYCs6CNyuItsE7D9urcakxYjJa8TiL8d9mWlO1
         boCP7ITbPHB+aS09zVEdPnqTO+c8xjc4xkuT/PTIlkPzz8uv9npVUXX8scnGozGfl+AP
         UPzpY3cjX68ABgHGm75mnNnR6Tpqyqybe766OFYg6wZVNd6RYIVAnttYHGoW/qzO/K5m
         YdIbT8ii4JrV5nCVqOI0lVkBmmvU9g6I4PVzrCjCz+uC0KuG/1L+es1yjq0quSarjZ0a
         7m2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=18QivVRaNgZyCxRZL4f3lI3BO5DrU07SsqJpq8mUAt8=;
        b=wXvxN4euhftBKh41rSytBWbK/30kmQgYVc4accEU8V7fYJ+97sSPFpVDgbLE9K0EQ1
         7ymfxhPsyciEuEZdqWeFlRFyIbVSXT2dF7VHkyK7Z27QUaQjzfHiF4pU23Mg+IBpTE5l
         +SUGNBkjgsWB8+ycc2B/wg5yTL6E3YAhuGVr0wejnAhlHD4ATY+NiZERQ3djMNSa9MEq
         C55S2EMcG9Mt0gmAhkRlxU6WHkiA+QP3BRpE+zPhAX8mRKmjReylOG/AZRpHod306m4S
         8xU1Wm7+qAPj8wajKDJ8Zh69LqmttPidto9tQDTo3u1yJkI7mf5ZNI6OEh3w/lKXVkp8
         By7A==
X-Gm-Message-State: AOAM532id/8Yooaqdq1Z00sbWqKWZRfchJrlBvfQGkqIftWNNxoi7YUk
        IPt0lutrCzYIexesfUSKAab2BVzpL0zY7g==
X-Google-Smtp-Source: ABdhPJxZwvJANa71PdqyRVSgpsorKHNBGSQGpDopGIsMga27ZLJ8v7cAvdbRQXtDQ6tvee0YKuTtyQ==
X-Received: by 2002:a5d:4e4e:: with SMTP id r14mr6499055wrt.147.1633010279635;
        Thu, 30 Sep 2021 06:57:59 -0700 (PDT)
Received: from [192.168.4.32] ([85.184.170.180])
        by smtp.gmail.com with ESMTPSA id f63sm4437779wma.24.2021.09.30.06.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 06:57:59 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: Use lower tx rates for the ack packet
To:     Chris Chiu <chris.chiu@canonical.com>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210930104422.968365-1-chris.chiu@canonical.com>
Message-ID: <76bcc40e-f302-196f-5d83-df2aa0d9d963@gmail.com>
Date:   Thu, 30 Sep 2021 09:57:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210930104422.968365-1-chris.chiu@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/21 6:44 AM, Chris Chiu wrote:
> According to the Realtek propritary driver and the rtw88 driver, the
> tx rates of the ack (includes block ack) are initialized with lower
> tx rates (no HT rates) which is set by the RRSR register value. In
> real cases, ack rate higher than current tx rate could lead to
> difficulty for the receiving end to receive management/control frames.
> The retransmission rate would be higher then expected when the driver
> is acting as receiver and the RSSI is not good.
> 
> Cross out higer rates for ack packet before implementing dynamic rrsr
> configuration

Theory of this looks sound to me, but there's an implementation detail,
see below.

> Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 7 ++++++-
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 2 ++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index 774341b0005a..413cccd88f5c 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -4460,13 +4460,18 @@ void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
>  
>  static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv, u32 rate_cfg)
>  {
> +	struct ieee80211_hw *hw = priv->hw;
>  	u32 val32;
>  	u8 rate_idx = 0;
>  
>  	rate_cfg &= RESPONSE_RATE_BITMAP_ALL;
>  
>  	val32 = rtl8xxxu_read32(priv, REG_RESPONSE_RATE_SET);
> -	val32 &= ~RESPONSE_RATE_BITMAP_ALL;
> +	       val32 = rtl8xxxu_read32(priv, REG_RESPONSE_RATE_SET);

You're reading REG_RESPONSE_RATE_SET twice.

Cheers,
Jes
