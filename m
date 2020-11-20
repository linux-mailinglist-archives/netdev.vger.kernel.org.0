Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCD12BB87A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 22:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgKTVjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 16:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbgKTVjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 16:39:45 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BA8C0613CF;
        Fri, 20 Nov 2020 13:39:45 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id g17so8259242qts.5;
        Fri, 20 Nov 2020 13:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s1WYbCf4DLtQCOZZjao8Kq3OsBZTVKuAEA5HpJECn0U=;
        b=Lo6qc0IBxen4XlAgIpJdR6sjJ1pLYCV3g7ArGA/SM2jyVR8pYG/MWvFdccJhivY0wa
         vW0MOv1VTxK/YFH/8Yf4mRzNdpA0I1G0zr2BJ7FbDoD8SFUQKU09T8ebe/DsA5nNI60I
         /pGFVG3h4sI1bpOsaCnY9+OiKvEv/rh5hcI5yuwOg/QDKontUYQa6Z8gV6sVlDRQhcrT
         5ENhtCCLnzijiNk2a5Ql62wErNiDYBtsoChGBfS6f9ABR0uBrDUGK+yEHFgD47MDAvIe
         6r3nmbz+miE4Upg2IlE9Zr21xWIitL0eHpXPNyv52fo06GFTCl4oHFk8nwu/fARsAqgh
         pP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s1WYbCf4DLtQCOZZjao8Kq3OsBZTVKuAEA5HpJECn0U=;
        b=Ourl23PM+zpVFITEndx3hWyX0M0ENQOCRYPuaIdlTw23DYhUxlDFr7oN8qVz4lWRsH
         Aw5yiUym3Mm5WYrYSmLGI7H+Job5h0oUB1IE9aC/trKorkjqK0EYo/bWqLxJenSYL1Yk
         xdm2c9ugNWiJ7YzVneIeLElApncyv3/hkw/BXWotU2e9loGrTgZaTBMvxUFcpmzBEzVX
         40gtXm7f2sE17sml9GydLsWGubh8qfAzAUwDp1KDOY/7ZIwbPb0XVX/O495mhhXgNVt+
         XqpsclpsvKLVuJS1xxatm6yGTrqTi5b3QNTudHvuwLrjMkHwvu6BbFeh3Ij84UqN1u+f
         8zDw==
X-Gm-Message-State: AOAM530zoY/JwnQGql6unyrU/IVuOvO0I+Nz/2SlG1MtbT/i+PbviNrO
        /dc4WjB7PY1Bprfb8XEyIaurMsniGks=
X-Google-Smtp-Source: ABdhPJxlEDpvnIi2bfpP/20pkYh6uSD1+pHNqKtO6zJ5NyqxFy86CZQ3Yhy6PKqsimLIwcrAqbTekQ==
X-Received: by 2002:ac8:5848:: with SMTP id h8mr13137812qth.232.1605908384275;
        Fri, 20 Nov 2020 13:39:44 -0800 (PST)
Received: from ?IPv6:2620:10d:c0a8:1102::1844? ([2620:10d:c091:480::1:6eec])
        by smtp.gmail.com with ESMTPSA id s7sm2823401qkm.124.2020.11.20.13.39.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 13:39:43 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 117/141] rtl8xxxu: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <cover.1605896059.git.gustavoars@kernel.org>
 <d522f387b2d0dde774785c7169c1f25aa529989d.1605896060.git.gustavoars@kernel.org>
Message-ID: <691515e4-4d40-56cf-5f7a-1819aad1afa9@gmail.com>
Date:   Fri, 20 Nov 2020 16:39:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <d522f387b2d0dde774785c7169c1f25aa529989d.1605896060.git.gustavoars@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/20 1:38 PM, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix
> multiple warnings by replacing /* fall through */ comments with
> the new pseudo-keyword macro fallthrough; instead of letting the
> code fall through to the next case.
> 
> Notice that Clang doesn't recognize /* fall through */ comments as
> implicit fall-through markings.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

While I wasn't CC'ed on the cover-letter I see Jakub also raised issues
about this unnecessary patch noise.

Quite frankly, this seems to be patch churn for the sake of patch churn.
If clang is broken, fix clang instead.

NACK


Jes

> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index 5cd7ef3625c5..afc97958fa4d 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -1145,7 +1145,7 @@ void rtl8xxxu_gen1_config_channel(struct ieee80211_hw *hw)
>  	switch (hw->conf.chandef.width) {
>  	case NL80211_CHAN_WIDTH_20_NOHT:
>  		ht = false;
> -		/* fall through */
> +		fallthrough;
>  	case NL80211_CHAN_WIDTH_20:
>  		opmode |= BW_OPMODE_20MHZ;
>  		rtl8xxxu_write8(priv, REG_BW_OPMODE, opmode);
> @@ -1272,7 +1272,7 @@ void rtl8xxxu_gen2_config_channel(struct ieee80211_hw *hw)
>  	switch (hw->conf.chandef.width) {
>  	case NL80211_CHAN_WIDTH_20_NOHT:
>  		ht = false;
> -		/* fall through */
> +		fallthrough;
>  	case NL80211_CHAN_WIDTH_20:
>  		rf_mode_bw |= WMAC_TRXPTCL_CTL_BW_20;
>  		subchannel = 0;
> @@ -1741,11 +1741,11 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
>  		case 3:
>  			priv->ep_tx_low_queue = 1;
>  			priv->ep_tx_count++;
> -			/* fall through */
> +			fallthrough;
>  		case 2:
>  			priv->ep_tx_normal_queue = 1;
>  			priv->ep_tx_count++;
> -			/* fall through */
> +			fallthrough;
>  		case 1:
>  			priv->ep_tx_high_queue = 1;
>  			priv->ep_tx_count++;
> 

