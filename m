Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E95D15CFB6
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 14:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfGBMok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 08:44:40 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39620 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfGBMok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 08:44:40 -0400
Received: by mail-qk1-f196.google.com with SMTP id i125so13779128qkd.6;
        Tue, 02 Jul 2019 05:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=12DvkmsIeJchtWeIYbkkPm0CS9UwzM+pY9NcdRKJXAs=;
        b=lsJx5lBpRBZjNj+5nK4dJ+DtsTXH08kT7T/VPeQKT9M/7F8t14tEA1L6HB7mqquGz5
         QUs9FAa4cCqDpE8UR885Mj5VOhX8Ws8B5tiOm7WdYsv8Zvo4eOqsCeFQ48+twRIRixic
         DA+RmflG5Jew7L7Ekh8Pky2lnbDl2QcJ7PfMGy6EjNCQt31vRouRsVDSS+wU0eOl7Nvk
         gQ1D4pgMhjiH1oIfwB+A9lsBueHqNQZZfb9uloz0AgW4cp0Y1tKCiRxdt0RcAs7VoJgf
         cigPc85MExR2+ibp1QK1WVStKAnuGyMHL8BecDVG6hxHHQpkgsQmzKy5lcnWBi1cAmyU
         MwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=12DvkmsIeJchtWeIYbkkPm0CS9UwzM+pY9NcdRKJXAs=;
        b=uTLiStz2u9wuxjdZfcHloyYQibEhJiukh0sHAh3ZP0JkVuacd9Iq3F90WpGLlUeEDg
         bD/DfKe2hk7YlNT7pcWC1pSTKbyT8/Tr0nXS5NZK8Wmvi/2TLSZx3dc4yleICu5Giyoj
         RhA01vjJmOZ8cuF7oj5oh4WbGWErQ2BlTfuRKExcA5gWNgncQm1qaamFsd2C1iZxmXV2
         au7BhPWtngJGdcVCO/MX2XtlL+9b1FqWyvtT30KxQu6T+YPAZTL0CFzGcq1g8eMnapLs
         8FUC1hL+CPUaOoQfJH6t9ClOcRtGO/lf5Ii/xmL7gBluAlD34IywSuF+u5H/FHr2l6+a
         6buQ==
X-Gm-Message-State: APjAAAXV/T9/wg9tSh3i7WcED/x1AzLk9jv6n708vrzYZlSZce8rTWMJ
        7+bA84JPr3LYO8e0kt5Y4qY=
X-Google-Smtp-Source: APXvYqxVzJZDPRBzxtZBOov+pn/D6Gdft1M0srMH15n4l+GpGb00FLuFSt6r+WXgCdR6Be8w6RbBqw==
X-Received: by 2002:a37:6587:: with SMTP id z129mr24845496qkb.295.1562071478848;
        Tue, 02 Jul 2019 05:44:38 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11c1::1019? ([2620:10d:c091:480::c41e])
        by smtp.gmail.com with ESMTPSA id o71sm6087975qke.18.2019.07.02.05.44.37
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 05:44:38 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
To:     Chris Chiu <chiu@endlessm.com>, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
References: <20190627095247.8792-1-chiu@endlessm.com>
Message-ID: <31f59db2-0e04-447b-48f8-66ea53ebfa7d@gmail.com>
Date:   Tue, 2 Jul 2019 08:44:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190627095247.8792-1-chiu@endlessm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/27/19 5:52 AM, Chris Chiu wrote:
> The WiFi tx power of RTL8723BU is extremely low after booting. So
> the WiFi scan gives very limited AP list and it always fails to
> connect to the selected AP. This module only supports 1x1 antenna
> and the antenna is switched to bluetooth due to some incorrect
> register settings.
> 
> This commit hand over the antenna control to PTA, the wifi signal
> will be back to normal and the bluetooth scan can also work at the
> same time. However, the btcoexist still needs to be handled under
> different circumstances. If there's a BT connection established,
> the wifi still fails to connect until disconneting the BT.
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 9 ++++++---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 3 ++-
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> index 3adb1d3d47ac..6c3c70d93ac1 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> @@ -1525,7 +1525,7 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
>  	/*
>  	 * WLAN action by PTA
>  	 */
> -	rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x04);
> +	rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x0c);
>  
>  	/*
>  	 * BT select S0/S1 controlled by WiFi
> @@ -1568,9 +1568,12 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
>  	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.ant_sel_rsv));
>  
>  	/*
> -	 * 0x280, 0x00, 0x200, 0x80 - not clear
> +	 * Different settings per different antenna position.
> +	 * Antenna switch to BT: 0x280, 0x00 (inverse)
> +	 * Antenna switch to WiFi: 0x0, 0x280 (inverse)
> +	 * Antenna controlled by PTA: 0x200, 0x80 (inverse)
>  	 */
> -	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
> +	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x80);
>  
>  	/*
>  	 * Software control, antenna at WiFi side
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index 8136e268b4e6..87b2179a769e 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -3891,12 +3891,13 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
>  
>  	/* Check if MAC is already powered on */
>  	val8 = rtl8xxxu_read8(priv, REG_CR);
> +	val16 = rtl8xxxu_read16(priv, REG_SYS_CLKR);
>  
>  	/*
>  	 * Fix 92DU-VC S3 hang with the reason is that secondary mac is not
>  	 * initialized. First MAC returns 0xea, second MAC returns 0x00
>  	 */
> -	if (val8 == 0xea)
> +	if (val8 == 0xea || !(val16 & BIT(11)))
>  		macpower = false;
>  	else
>  		macpower = true;

This part I would like to ask you take a good look at the other chips to
make sure you don't break support for 8192cu, 8723au, 8188eu with this.

Cheers,
Jes
