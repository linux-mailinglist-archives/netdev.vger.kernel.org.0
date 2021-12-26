Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC5747F85E
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 18:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhLZRSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 12:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbhLZRSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 12:18:50 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E64C06173E;
        Sun, 26 Dec 2021 09:18:49 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id v11so27985254wrw.10;
        Sun, 26 Dec 2021 09:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1EClICUpUVp7JRzRETO30oZAi2IbL/s2jOAI8KmoP/s=;
        b=PVvdgG7/iAkFCiGqMvdM5biN6wEGYaD26FdaaEXPh7DT3bp0McXrj6meqDSXhKZhRo
         fb23/cijTUNGNep4cS5vv69d+19mP/1AoSsItlutRXx20VKqCYSfEPXu+I+XXzBlGoxL
         G+WlYT1G5TxrJcDRQfTMZ97pIV9/yoJUhecWmD0wf8Zsdwq8idGXA0oix2CDE8Rvh3mm
         OigOSRDYMx9vGAm5sBPVr9LoXHzn/u79xA3BIzA+DmuSaU6FkHVSkYfZdGMvXyk/lWhn
         YH7Sxu5IRZiuWtbcYmmuUbWNCLjIMvr72ul6+ZBMZbscmRSDn1jg68bWFULkYqgNBvrv
         LQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1EClICUpUVp7JRzRETO30oZAi2IbL/s2jOAI8KmoP/s=;
        b=WEg4pMz1U5JUMrmLVlhjo/W45Dkmm8OfkTglHeKHrFFjQga8PhbZzfhWMf4WgnSIpF
         27XEEzgtptS4avvjGzXRo+CFkNXfE+6N4lYLY/ktHyF1+5TCDxvqZsLBDK4YRt4niOQz
         7GHbEPftpMylFzVXgEI64UBATE8EnvCeVLb2LbuKatBB/uUGJUtERfBG8OP0xl0LUAEI
         sFqL0RDavqYjqybqDS8kkgDux2aG2s/sdwC1noemxgoIJ2lNk4mRwplRXqpIlSuEBL5X
         RK1VMZrPApI/wWfQ+v15PE1pz9F7KIAsuwDzKyWihodS/d3ewuSEqudqRZmrtUspYuPV
         /F5Q==
X-Gm-Message-State: AOAM532lt7M40nbfb8548afW27p1btOl7T9vgfEwL0nCRM/YvHG5YAIw
        SI0UIsc5Z6k0a1SCIayszRc=
X-Google-Smtp-Source: ABdhPJypH3Y45uPEWflKChXzACmOud0odMSb6aX+7dJIbQbMmLuw0zZ5j/8Op+0qMr/HN5obcQzyiw==
X-Received: by 2002:adf:fe0f:: with SMTP id n15mr10152332wrr.705.1640539128035;
        Sun, 26 Dec 2021 09:18:48 -0800 (PST)
Received: from ?IPV6:2003:ea:8f24:fd00:c9a7:2d21:f9c0:60ee? (p200300ea8f24fd00c9a72d21f9c060ee.dip0.t-ipconnect.de. [2003:ea:8f24:fd00:c9a7:2d21:f9c0:60ee])
        by smtp.googlemail.com with ESMTPSA id k31sm13665265wms.21.2021.12.26.09.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Dec 2021 09:18:47 -0800 (PST)
Message-ID: <a82b56dc-8a74-cd6e-cfcb-9a16b858b21a@gmail.com>
Date:   Sun, 26 Dec 2021 18:18:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] asix: Use min() instead of doing it manually
Content-Language: en-US
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        davem@davemloft.net
Cc:     kuba@kernel.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20211225170847.115298-1-jiapeng.chong@linux.alibaba.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20211225170847.115298-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.12.2021 18:08, Jiapeng Chong wrote:
> Fix following coccicheck warning:
> 
> ./drivers/net/usb/asix_common.c:545:12-13: WARNING opportunity for
> min().
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/usb/asix_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index 71682970be58..da5a7df312d2 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -542,7 +542,7 @@ static int __asix_mdio_write(struct net_device *netdev, int phy_id, int loc,
>  out:
>  	mutex_unlock(&dev->phy_mutex);
>  
> -	return ret < 0 ? ret : 0;
> +	return min(ret, 0);

Same comment as for a previous such patch. It doesn't make sense.
Also coccicheck isn't always right, please check whether a warning
is justified before sending a "fix".


>  }
>  
>  void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)

