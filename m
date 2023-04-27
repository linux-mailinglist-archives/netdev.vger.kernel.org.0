Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21506F0BB1
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 20:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244437AbjD0SBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 14:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjD0SBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 14:01:45 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624353A91;
        Thu, 27 Apr 2023 11:01:44 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1879e28ab04so7081489fac.2;
        Thu, 27 Apr 2023 11:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682618503; x=1685210503;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=+ydjrGkt4gIeKcYgkoU5EuhO/kYH9fZY+GJ0KKFuhI8=;
        b=fW96y9kcUIa7cVIbKqiJ9fOEPwa0rS7hHU9EjWxjjN9zbZkDBw2oCf1OX3d3lbATBh
         OtPKAEt+DMrju/qFRt535JaNZ54ddi0uGftEXAXKoGIzDlmBBqCPZXbuq2UU4F2b7M8z
         YTFzzEHiRxNNUrZfvLFU5tChQsJgDzLFZxwd5ft/dFCqixh0Cnaass0D0O0hRpcCpOwb
         seDSa5msDJqy6ZG2qyq09r083x3rYNDkKqpI3hPxV9P4fqwovv6LhT9+8yE+SCp891p7
         5Ol+tCpwbxAlP+kBebjo8AyleswF3/tu1nZWCo5+BXvVn7vT9PNBzobMihZdef4zKQMn
         GY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682618503; x=1685210503;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ydjrGkt4gIeKcYgkoU5EuhO/kYH9fZY+GJ0KKFuhI8=;
        b=Z8Ne37ggXXCMb0UHVLjudEue6oPjN13mmJdGpi+n9/ZFEeXEOwRCGg4QIya8r47o9S
         Qs4k+7GC5R+8OiscVVwqLr13HMpPUnDGnZqKOCEHI9tB7Qh9TlE9nGBCwvkUvU0WK1cg
         cEd3TeVeQ8xcGmYWF2JV1aTytFSTRLx1rF4/staac9/tN5uV9l9TECrmNDw0aJGpBOrY
         U3D8GJSFWZrQuLsjzy3dCCBM5va1/dm1uZWPhqZUT+TcpFDhICgShbp/WX87XK9w0B1p
         CEC8HbrywlfoUmaO2t8iY/hVAim1xLfSe3ko3uDmpgq8WsJ3i0RUKWcFlVjrpBMPCw2H
         DtKA==
X-Gm-Message-State: AC+VfDz3bKBDpXlYY7gpiYtFZG9KB9RF8uhxBUy0yeWnKR7Biz0sdKXd
        b0/kJ0+L7avu+RdKAczEadw=
X-Google-Smtp-Source: ACHHUZ7HvL3iOBHvVYhcy2bXFQNS8zJtEnt4OKQ9GSTiL1U6GYFGr+E1wJl3/HcZGtsAl3kkscC+iA==
X-Received: by 2002:a05:6870:3505:b0:177:809e:ead3 with SMTP id k5-20020a056870350500b00177809eead3mr1099769oah.41.1682618503341;
        Thu, 27 Apr 2023 11:01:43 -0700 (PDT)
Received: from [192.168.0.162] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id e2-20020a056870c34200b0017299192eb1sm7953605oak.25.2023.04.27.11.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 11:01:42 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <b2ea271c-2139-7579-e4a8-6eae009f6021@lwfinger.net>
Date:   Thu, 27 Apr 2023 13:01:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] wifi: rtl8xxxu: fix authentication timeout due to
 incorrect RCR value
Content-Language: en-US
To:     Yun Lu <luyun_611@163.com>, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230427020512.1221062-1-luyun_611@163.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20230427020512.1221062-1-luyun_611@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/23 21:05, Yun Lu wrote:
> From: Yun Lu <luyun@kylinos.cn>
> 
> When using rtl8192cu with rtl8xxxu driver to connect wifi, there is a
> probability of failure, which shows "authentication with ... timed out".
> Through debugging, it was found that the RCR register has been inexplicably
> modified to an incorrect value, resulting in the nic not being able to
> receive authenticated frames.
> 
> To fix this problem, add regrcr in rtl8xxxu_priv struct, and store
> the RCR value every time the register is writen, and use it the next
> time the register need to be modified.
> 
> Signed-off-by: Yun Lu <luyun@kylinos.cn>
> ---
>   drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h      | 1 +
>   drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 4 +++-
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> index c8cee4a24755..4088aaa1c618 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> @@ -1518,6 +1518,7 @@ struct rtl8xxxu_priv {
>   	u32 rege9c;
>   	u32 regeb4;
>   	u32 regebc;
> +	u32 regrcr;
>   	int next_mbox;
>   	int nr_out_eps;
>   
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index 620a5cc2bfdd..2fe71933ba08 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -4053,6 +4053,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
>   		RCR_ACCEPT_MGMT_FRAME | RCR_HTC_LOC_CTRL |
>   		RCR_APPEND_PHYSTAT | RCR_APPEND_ICV | RCR_APPEND_MIC;
>   	rtl8xxxu_write32(priv, REG_RCR, val32);
> +	priv->regrcr = val32;
>   
>   	if (priv->rtl_chip == RTL8188F) {
>   		/* Accept all data frames */
> @@ -6273,7 +6274,7 @@ static void rtl8xxxu_configure_filter(struct ieee80211_hw *hw,
>   				      unsigned int *total_flags, u64 multicast)
>   {
>   	struct rtl8xxxu_priv *priv = hw->priv;
> -	u32 rcr = rtl8xxxu_read32(priv, REG_RCR);
> +	u32 rcr = priv->regrcr;
>   
>   	dev_dbg(&priv->udev->dev, "%s: changed_flags %08x, total_flags %08x\n",
>   		__func__, changed_flags, *total_flags);
> @@ -6319,6 +6320,7 @@ static void rtl8xxxu_configure_filter(struct ieee80211_hw *hw,
>   	 */
>   
>   	rtl8xxxu_write32(priv, REG_RCR, rcr);
> +	priv->regrcr = rcr;
>   
>   	*total_flags &= (FIF_ALLMULTI | FIF_FCSFAIL | FIF_BCN_PRBRESP_PROMISC |
>   			 FIF_CONTROL | FIF_OTHER_BSS | FIF_PSPOLL |

Wouldn't it be better to find the location that is writing the incorrect value 
to RCR and fix that? It seems to me that you are applying a band-aid rather than 
fixing the problem.

Larry

