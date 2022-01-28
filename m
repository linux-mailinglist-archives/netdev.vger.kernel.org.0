Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D6F4A0251
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 21:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbiA1Uws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 15:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236318AbiA1Uwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 15:52:47 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8E4C061714;
        Fri, 28 Jan 2022 12:52:46 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id bu18so14176090lfb.5;
        Fri, 28 Jan 2022 12:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FxgoJ87HkOo4Sya7mWsI9Jkjvlhv0yv3YR69qNwYcgY=;
        b=FASeYDqXNB7SNFPPSMjeNYgeeX65/uG3+UKBDXjBMIjiwA71UcIShrtJzoOijUNBxW
         fd62G9kbA7ttoa4DPaUbg9B3M0xvk3MkVH8AiT6DgmjNm1Y4iBai0RrA9FhIhmqG7M24
         5TO0XK0nW31E5zHyvFpgUbLsc/5VYC2Mq+0L8lj0YOEaiHdKUv8JN4O4ZSjmn5KCPF0b
         OVobR2UcqH6/tjRleXAThquVCIrGv5qOLlGDjkSqBDzfICN6P4cbwWCYLo+sFFieDNXC
         uaSGYsnWKU1WcHpHRI16xwMD03y1GYYOk9VHsP41ov5dN3AKBXv4ttrysDMlPsDuIa8C
         u0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FxgoJ87HkOo4Sya7mWsI9Jkjvlhv0yv3YR69qNwYcgY=;
        b=c68TFuTzXGkuGQ4gLN26F3doZp69OuF6ODH7jmz+qH2/U6MyY0v1T2ZnI6cqQuTjCN
         /Colzg2rABaNpVkD4GG94Ru0ToR0huM/Bw4qf/sOvXEqSlXK10uT6YpQq0TFBgMsec2c
         o1GQmwBelhHl1I7NkohN8EWGJxGLUK++7L6KF7sVZEbfLWp5AyeH2HJuuJ8OScF0yDfW
         XDveDO8MOQyQnnkbsLcRqfe9YplhQNWhayMgo9Sqv8nR457kB0rBV+BeMMOxmnd2BvrV
         2daJsXyA/yy3q9WLDtyLC7x9mH6bm+CRee5oqVTz+a1Wu2aLHeLg7i9lU7cUT26y1i6p
         ScdA==
X-Gm-Message-State: AOAM533uQl2yT4IieP5mUU4o/DAm2GraBfUjTI7jnNLWNR7srt+l7saQ
        lJyongi+fd9WsBSFz2FNwsY=
X-Google-Smtp-Source: ABdhPJyljK+IMPeEvoQrkr8pES9R2ymfkjp48tGYsn/vuifjCmeWhNCPgqE8CaO/iUAYRBR04YeWWA==
X-Received: by 2002:ac2:5604:: with SMTP id v4mr7184599lfd.284.1643403164687;
        Fri, 28 Jan 2022 12:52:44 -0800 (PST)
Received: from [192.168.1.11] ([94.103.225.90])
        by smtp.gmail.com with ESMTPSA id z13sm2651546lft.92.2022.01.28.12.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 12:52:44 -0800 (PST)
Message-ID: <0647fd91-f0a7-4cf7-4f80-cd5dc3f2f6a2@gmail.com>
Date:   Fri, 28 Jan 2022 23:52:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] ath9k_htc: fix uninit value bugs
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com,
        vasanth@atheros.com, Sujith.Manoharan@atheros.com,
        senthilkumar@atheros.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+f83a1df1ed4f67e8d8ad@syzkaller.appspotmail.com
References: <20220115122733.11160-1-paskripkin@gmail.com>
 <164337315159.4876.15861801637015517784.kvalo@kernel.org>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <164337315159.4876.15861801637015517784.kvalo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

On 1/28/22 15:32, Kalle Valo wrote:
>> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
>> Reported-by: syzbot+f83a1df1ed4f67e8d8ad@syzkaller.appspotmail.com
>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
> 
> Patch applied to ath-next branch of ath.git, thanks.
> 
> d1e0df1c57bd ath9k_htc: fix uninit value bugs
> 

Thanks, Kalle! Can you also, please, check out this one too :)
Quite old, but syzbot is getting mad with this bug (like 20k hits). Thanks!


https://lore.kernel.org/all/20210922164204.32680-1-paskripkin@gmail.com/




With regards,
Pavel Skripkin
