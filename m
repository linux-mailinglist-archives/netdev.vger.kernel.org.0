Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4A8BE95A
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 02:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387679AbfIZAHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 20:07:00 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43381 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387632AbfIZAHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 20:07:00 -0400
Received: by mail-oi1-f196.google.com with SMTP id t84so506914oih.10;
        Wed, 25 Sep 2019 17:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z4X9jDl/gogPQ/X6hgep747Xt9DUFKrCuAetppUGPN4=;
        b=Sa4noR+qX70kJICtZoLObZ4fIzvQCb6HEw6UMjkZSPdTmrcTGqB9h1m97ultMmGkmO
         toqdNZTI7IEuIStvMY8e9ztuiflfhejBO8q9MYHDFbD8Aa9FV9AiNc6vs6KNqBR6CUZW
         /5N6whQdgYkAHsAJXTYly5WvnUFGKI+HgVQTi01vLhy3E6E8ekc0cRXT3+jT7dra8hsk
         o0aGHUnii605Vt8Z4zaHZs47nKMiB5RFkpw/nM6FpT42KL70EViWjZw8S1qYYi0xaxCf
         oUPwS3+Jkf/sd3zrb8yMu2N3GFjbDgVdJPlojxGEl72/aHeSi2G+fWoCoOQzeWEM9YgZ
         ezYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z4X9jDl/gogPQ/X6hgep747Xt9DUFKrCuAetppUGPN4=;
        b=dlOyjx/1ez++kIgUMArwM08iYSBz1KeN9IZvjsEHJG3jXG80sNvy3OC2EUpy/nqdmq
         hfeJS6H1yc6k044NijCqVuRdtUSYNw01hMjsqOI4kQRg6Qc6Xw5sF09LdWGzMEtduomW
         VhtA7qJYnZkAq4GjpwRPdj69QQPtRBVPN3hW8dCgmaYrS6wU9JiI8xkq5BmwYt/PmhBr
         ZTI6mkDVyI4yfijHoZmnwkzEtjhzcKWMogtm5GhKbVIEqAdLAGB1vAP+YPopfVWSIfi3
         xnEoS1jaQeCz/ab/khHgXnfR9jcl0dn8YWdGbPrRkyTZ+JiRDzY3lMvqcAiIoxy749xh
         7Rag==
X-Gm-Message-State: APjAAAUUJZIIGUk0LMaWa/tWsAsGwaIsa5aryTl2+fxWedMXVnJyc5CP
        nVSvmzAYMpnORhYypgHfMYDAu4j4
X-Google-Smtp-Source: APXvYqwGZsQ2HLY28D+3a3L5fHSQpp6Yt59KkPvnFaLe/DHbgYXzecmnpExSVTmeRIymcv1UaJwAJA==
X-Received: by 2002:aca:af11:: with SMTP id y17mr545931oie.76.1569456419205;
        Wed, 25 Sep 2019 17:06:59 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id e61sm117171ote.24.2019.09.25.17.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 17:06:58 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: Remove excessive check in _rtl_ps_inactive_ps()
To:     Denis Efremov <efremov@linux.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190925205858.30216-1-efremov@linux.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <bf0e64a5-5072-9706-98d2-cc226ad70380@lwfinger.net>
Date:   Wed, 25 Sep 2019 19:06:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190925205858.30216-1-efremov@linux.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/19 3:58 PM, Denis Efremov wrote:
> There is no need to check "rtlhal->interface == INTF_PCI" twice in
> _rtl_ps_inactive_ps(). The nested check is always true. Thus, the
> expression can be simplified.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/ps.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
> index 70f04c2f5b17..6a8127539ea7 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/ps.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
> @@ -161,8 +161,7 @@ static void _rtl_ps_inactive_ps(struct ieee80211_hw *hw)
>   	if (ppsc->inactive_pwrstate == ERFON &&
>   	    rtlhal->interface == INTF_PCI) {
>   		if ((ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) &&
> -		    RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM) &&
> -		    rtlhal->interface == INTF_PCI) {
> +		    RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
>   			rtlpriv->intf_ops->disable_aspm(hw);
>   			RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
>   		}
> 
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

