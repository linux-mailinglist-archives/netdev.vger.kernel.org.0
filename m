Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C6827074F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgIRUrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIRUrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:47:08 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7AEC0613CE;
        Fri, 18 Sep 2020 13:47:08 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id g26so1759640ooa.9;
        Fri, 18 Sep 2020 13:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zqU4dHq3cnc2cyAhM+VlOdSlfj3aXvC5EFVqPqbMfWE=;
        b=Cv80qOtppzDi4hEsUIIA9NynPwWDXrUWBE7Utl+nRL151JiZFmkaV9mGVuzIivtIYq
         rSM5wR2W/PVEOn9iPIwGmVKpdq3cbGnXs+a2SEncTq5FSbQiNMOqX96xxENlmRXvjLkS
         GdqSXCcd7Ls7t06HZYp+m9PnASZ/WUL4M5t6AUW06XuBvTgS/rabJCgs7fJj8kljdVK6
         NJqlvKMfkIyAidR9rgmcGmGa8o9+MelDUwM67RJnRORKYEqJoOmfH1YHiN6HnDxhbm3h
         cDCJZW+rUIYtey/+Rg+G+H+wDJYhkurnATe8vuq3enVvfPngePkkzSJCgBoBTxM8Q+fx
         0Yeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zqU4dHq3cnc2cyAhM+VlOdSlfj3aXvC5EFVqPqbMfWE=;
        b=C1cc8D1RiBElgGF28xw6CScV2PViG5wTT1FCx29KJMYZXd/2rFeW7jZQ+fyYI0uz+O
         Aen6IzZDHTFguACnEl73PtnCxjyjp5lQtGellsnRmuJjYMxUevmRKiqY7ZB+/LBPNF+8
         aMygpRIv/TRfu/7emLDfdrMNcdMXWl0Q4vDljy9ZaEjbC8+jFQzdKcMLYuph42PQSFWU
         eODh37DQ0tngsQLTmzPFMJiGMK4IVDvvhOckPkszB584hm2HeT/E6Yx/Uxa29RkXnug+
         6ZO08JNmfv5pDqA0Htc9c7jGEVm41DYSHSbPMzwN3KUehENPZgZBljPP7KnvNe8bI1p4
         v2RA==
X-Gm-Message-State: AOAM530usWvnI6u5bpbVw+voRX6nteyz+VnmcyBATNUJM8/Elk0BKCVJ
        lw0HC9P7Fx45jzeVGAi0UGjF7EefsSo=
X-Google-Smtp-Source: ABdhPJx9MpGLvkaa+tUmwmS/7S0wT0cgHv7CtmeI6rL0ncQopy3U+FcBqkfgQ2Lwbzgs8IPlKywD1A==
X-Received: by 2002:a4a:c909:: with SMTP id v9mr25290671ooq.43.1600462027463;
        Fri, 18 Sep 2020 13:47:07 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id l136sm3872514oig.7.2020.09.18.13.47.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 13:47:06 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH -next 2/9] rtlwifi: rtl8192c: fix comparison to bool
 warning in phy_common.c
To:     Zheng Bin <zhengbin13@huawei.com>, pkshih@realtek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yi.zhang@huawei.com
References: <20200918102505.16036-1-zhengbin13@huawei.com>
 <20200918102505.16036-3-zhengbin13@huawei.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <34dceb4c-8a5d-a0f1-f572-d05a9b8b9b76@lwfinger.net>
Date:   Fri, 18 Sep 2020 15:47:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918102505.16036-3-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/20 5:24 AM, Zheng Bin wrote:
> Fixes coccicheck warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c:1106:14-18: WARNING: Comparison to bool
> 
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
> index fc6c81291cf5..6a3deca404b9 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
> @@ -1103,7 +1103,7 @@ static void _rtl92c_phy_path_adda_on(struct ieee80211_hw *hw,
>   	u32 i;
> 
>   	pathon = is_patha_on ? 0x04db25a4 : 0x0b1b25a4;
> -	if (false == is2t) {
> +	if (!is2t) {
>   		pathon = 0x0bdb25a0;
>   		rtl_set_bbreg(hw, addareg[0], MASKDWORD, 0x0b1b25a0);
>   	} else {
> --
> 2.26.0.106.g9fadedd
> 

