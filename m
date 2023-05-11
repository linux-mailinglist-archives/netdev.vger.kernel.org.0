Return-Path: <netdev+bounces-1660-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 180D36FEAB7
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 06:34:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22D62281672
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C6A8C00;
	Thu, 11 May 2023 04:34:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14695371
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:34:24 +0000 (UTC)
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B064C28;
	Wed, 10 May 2023 21:34:21 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-192c2569c72so3546637fac.2;
        Wed, 10 May 2023 21:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683779661; x=1686371661;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=bF0E8dYTn10kN4jTvi8jZ6DlK/Lu6WpIxNqCFWuU084=;
        b=EclxmqzpA765BbSy0RGR1ite70yLvjChBt8piQqgI4KBxHXb+aIjJRwVlUJ5VsUMPj
         X/NMkVQUp/8nVqB0hBWoluwCo+zhxQjzfgreWnCvVjd6WuaZiMoSpBDfKkYBQ7Ld06UT
         bsGJBGUw43FUtKmr/SjYXl/IsFwHaHSy6er0InaXDzfnONrcSqsVY4R56InH3IlH3yLX
         o+tV8Kcej+JaakL1M4/P1y5HEy7xMwJyRYc15z/i8q6v2sqjUcvsLYpySKaXZCUistdg
         tAKLsUu5o36GwWZ7K1Ezby1WBXG0znZ2pXGjXGYfY5dnSM5FGwwTKJt9b63xRhJbaBJe
         cIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683779661; x=1686371661;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bF0E8dYTn10kN4jTvi8jZ6DlK/Lu6WpIxNqCFWuU084=;
        b=Pb7y3DWWbpy7FaIs3TA3GkVtfCBJpBJDB5Ry8UpqMudWvdqBtRuy2Ehego0QArpO/S
         oHFImbC6SkqybipFu0Dbu6UKF554Gcz2xMvzc5JdAQ1MVQCyU6wFUp22YL8QIek5qg5d
         khaKZnbMiJBUXgDjZZrkoaILewaoy7W1mQnNnvDTlhbh4HjJEO84GiFmGI7eU6ZKSPFk
         muCQ342gxVGPiNm+LH6wODEoPfcMDXv0RhU3L9kd9HKMuyNxZLJVJM/EMrlcQTHv9O4N
         lI5kW6INn3sl70un2of/BI/OZH4NkfVZW+91XdDF8xGfPd2W/sYUHkdPT+68kvWnhNIr
         IxTQ==
X-Gm-Message-State: AC+VfDx6Myh+EjnUAC2pkc0Rzh0kH5qqKROqJBVDXRpLXRiAuwYxvyLa
	d294AWaGo3lYoB0JD1JjHQ4=
X-Google-Smtp-Source: ACHHUZ71CW/KtAYyGaxPvlf8qw7GVnWsjNclwNumXElHY+dUAs59DywzO7pGARK2mNMYVhd/ydBLlA==
X-Received: by 2002:a05:6870:e14a:b0:187:9d7a:36e3 with SMTP id z10-20020a056870e14a00b001879d7a36e3mr9572079oaa.28.1683779660874;
        Wed, 10 May 2023 21:34:20 -0700 (PDT)
Received: from [10.62.118.118] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id a6-20020a056870618600b0017197629658sm7701842oah.56.2023.05.10.21.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 21:34:20 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <d8b5f499-6778-34c0-1f12-9d0f6698abb7@lwfinger.net>
Date: Wed, 10 May 2023 23:34:19 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v2] wifi: rtl8xxxu: fix authentication timeout due to
 incorrect RCR value
Content-Language: en-US
To: Yun Lu <luyun_611@163.com>, Jes.Sorensen@gmail.com
Cc: kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org
References: <20230511031825.2125279-1-luyun_611@163.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20230511031825.2125279-1-luyun_611@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/10/23 22:18, Yun Lu wrote:
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
> Link: https://lore.kernel.org/all/20230427020512.1221062-1-luyun_611@163.com
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

Acked-by and Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry


