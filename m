Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3505F5FC07
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 18:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfGDQnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 12:43:23 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41894 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfGDQnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 12:43:23 -0400
Received: by mail-qt1-f194.google.com with SMTP id d17so7154056qtj.8;
        Thu, 04 Jul 2019 09:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IS/wJFcvJJc/obs4u52ESPK6iZNHDaKuJQrwIU9Br5M=;
        b=Ex6kfypx3IqkZHIv1Ib6WARx4LDKQYudillIowR7AmhNuQNU9Aj0W8SszQ4nwNcEHC
         sDxVtU0reCVq3UOMNrS15qW1r55uYNZZ0WFpttUkG3CUQGxWOgtrMuF51KVR6JlXkbnu
         ftlBimI3h5vnm/A79jHjAWhpadB5AvxDBR/gPcnjuaEbqHnmn5nv6wuRv+Lzs6d7pcyp
         Y6vSsAyY2qYdEB/mYWESl76qxz1bLpn6rRuqLq5LrD6OVJsbNTCjxfOmczeCPEStbliW
         tZ1YDaJwAcNdDgZCayBZiM3CHFV1Tj+tBGbWoKq0HBYLWIHNyCxXcsE8yONlGOlrDKHW
         m6sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IS/wJFcvJJc/obs4u52ESPK6iZNHDaKuJQrwIU9Br5M=;
        b=C+3g45VmGh3XcBLy/FkJFqb9HgsY6p4if46z/XoDhB/HSUJj7t+ewYgthy33WhI1g0
         WGG/K5bhC33zdCnoI23UcIyFZ/hY/Ig5U16ETR65FtyrrMvRzHMo3IUYzXTMkLrDEY0+
         YMpCdtYRZdu4Kd1p0/E/snyddprDwuuZ9q0Ff0H7zMLXIrGxSGpY9WfYNgyJOVHcsLWA
         SKraYZu4KdL0JECh+UM6gMNW5C1vwHLGfar0oPOdeMJBv9dCI1gjop+w7Ky6IK3St8p0
         fYPnWuYXR0cfUMvzhxMQxDZwPmzE/uhddsP2UtSNgUQJDK13PvsmUzO+g2rNhxxc4CA8
         yNSg==
X-Gm-Message-State: APjAAAVUEceRoouX1z+3sDqVJQHWBASta8hvBrRuyoOLkU+ZYRZ1HkER
        9k7G45vvoeiSGvt+ssSw7Ps=
X-Google-Smtp-Source: APXvYqz4tSpAKSrmRROymk/C8WtPEk8CZ8fOFGr+Wac4NjN8D1fkinwqhPQJl8pmcq2aFUmDiSZi2Q==
X-Received: by 2002:ac8:689a:: with SMTP id m26mr36117104qtq.192.1562258601813;
        Thu, 04 Jul 2019 09:43:21 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11c1::109b? ([2620:10d:c091:480::f2b4])
        by smtp.gmail.com with ESMTPSA id l6sm2591529qkf.83.2019.07.04.09.43.20
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 09:43:20 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH v2] rtl8xxxu: Fix wifi low signal strength issue of
 RTL8723BU
To:     Chris Chiu <chiu@endlessm.com>, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
References: <20190704105528.74028-1-chiu@endlessm.com>
Message-ID: <8f1454ca-4610-03d0-82c4-06174083d463@gmail.com>
Date:   Thu, 4 Jul 2019 12:43:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190704105528.74028-1-chiu@endlessm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/4/19 6:55 AM, Chris Chiu wrote:
> The WiFi tx power of RTL8723BU is extremely low after booting. So
> the WiFi scan gives very limited AP list and it always fails to
> connect to the selected AP. This module only supports 1x1 antenna
> and the antenna is switched to bluetooth due to some incorrect
> register settings.
> 
> Compare with the vendor driver https://github.com/lwfinger/rtl8723bu,
> we realized that the 8723bu's enable_rf() does the same thing as
> rtw_btcoex_HAL_Initialize() in vendor driver. And it by default
> sets the antenna path to BTC_ANT_PATH_BT which we verified it's
> the cause of the wifi weak tx power. The vendor driver will set
> the antenna path to BTC_ANT_PATH_PTA in the consequent btcoexist
> mechanism, by the function halbtc8723b1ant_PsTdma.
> 
> This commit hand over the antenna control to PTA(Packet Traffic
> Arbitration), which compares the weight of bluetooth/wifi traffic
> then determine whether to continue current wifi traffic or not.
> After PTA take control, The wifi signal will be back to normal and
> the bluetooth scan can also work at the same time. However, the
> btcoexist still needs to be handled under different circumstances.
> If there's a BT connection established, the wifi still fails to
> connect until BT disconnected.
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> ---
> 
> 
> Note:
>  v2:
>   - Replace BIT(11) with the descriptive definition
>   - Meaningful comment for the REG_S0S1_PATH_SWITCH setting
> 
> 
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 11 ++++++++---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  3 ++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> index 3adb1d3d47ac..ceffe05bd65b 100644
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
> @@ -1568,9 +1568,14 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
>  	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.ant_sel_rsv));
>  
>  	/*
> -	 * 0x280, 0x00, 0x200, 0x80 - not clear
> +	 * Different settings per different antenna position.
> +	 *      Antenna Position:   | Normal   Inverse
> +	 * --------------------------------------------------
> +	 * Antenna switch to BT:    |  0x280,   0x00
> +	 * Antenna switch to WiFi:  |  0x0,     0x280
> +	 * Antenna switch to PTA:   |  0x200,   0x80
>  	 */
> -	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
> +	rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x80);

Per the documentation, shouldn't this be set to 0x200 then rather than 0x80?

We may need to put in place some code to detect whether we have normal
or inverse configuration of the dongle otherwise?

I really appreciate you're digging into this!

Cheers,
Jes
