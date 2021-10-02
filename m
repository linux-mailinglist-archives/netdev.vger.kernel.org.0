Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B55341FC09
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 15:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhJBNHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 09:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbhJBNHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 09:07:38 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F37AC0613EC;
        Sat,  2 Oct 2021 06:05:52 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id y26so50242272lfa.11;
        Sat, 02 Oct 2021 06:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lXrL1qWH/r5J06H6u4KpGY5v+3ijqCmr7e740BtGrQY=;
        b=opUg8tgNV2hczq1/rKD20FWVUUy3fk5cMT+HLO356BjDEEyAjhQogdG++1/gy5NGoU
         0fRRVF/yXgcPYfbGFmo5cfSNsiUr69qB82+h7mtIza+QlXDGiDxpzNLoJtS4yKxve2yx
         Rp9h930zMboT7FtjvShcm1iLVNmblrL9tN2kdfeDVEv/1Cu5qERPdYtvjrVn7FpEJLn4
         g3C46U+OamZGZ1wG45HvXx+hLX5M6Lkb5PQim7gJmMLQTYEqi1SzAEL+icNdrt8FvbCT
         dGamGs8Kn6X130C0ZxVrEzpWlQjTDwa9fEmIpNDLr1J0vzAiMlcHNDbypt3C7nFIaDzu
         RKvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lXrL1qWH/r5J06H6u4KpGY5v+3ijqCmr7e740BtGrQY=;
        b=lOVJ+57EY7u5LzYwGsR9hyc1VHcOLofhm34DCfwce8fDxNbaf81JRYoywXIabNZYhS
         VeqHWPB3qzhHKfP7rSqFS0SnwliLnMo3PRf9JD160NB076+UB8F/frjtYtkAT+hLF/43
         UUZ4vdhF0jT98VhH2/b1ddARcPAJVciQPwzyzfCngfDrtCQBgJQIccT3qySuC2fJH361
         t0K38ugs5Jk4EzYJwpGmLAYSPcJFTYi4gcdgxfxVN7QUrZBBgLqKQEHNdB+sKW34/DzT
         FmRUPC1UKXyO+xGtMh38qh0OEXj/E/cETY59UsfVYn6nnxdAo2d+jRivyMlwNyRpPaBh
         k1AQ==
X-Gm-Message-State: AOAM530BZ+LdC3hYjO57fHiHuOYKYhq8ji17JsfS/r45pV1AVwoaYFtg
        vDIK8NetgD/fsCeWYaONdTU=
X-Google-Smtp-Source: ABdhPJxPzYPWNDq8QM7KGWmBrCRAYh1vCV0bL7t/PUADFJUa8h1yV6yRZVCL6GOfPtnuoqDuvZaE0A==
X-Received: by 2002:a19:c310:: with SMTP id t16mr3564346lff.611.1633179950350;
        Sat, 02 Oct 2021 06:05:50 -0700 (PDT)
Received: from [192.168.1.11] ([217.117.245.149])
        by smtp.gmail.com with ESMTPSA id n8sm123215lfi.209.2021.10.02.06.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Oct 2021 06:05:49 -0700 (PDT)
Message-ID: <9bbf1f36-2878-69d1-f262-614d3cb66328@gmail.com>
Date:   Sat, 2 Oct 2021 16:05:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH RESEND] net: ath9k: fix use-after-free in
 ath9k_hif_usb_rx_cb
Content-Language: en-US
To:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, Sujith.Manoharan@atheros.com,
        linville@tuxdriver.com, vasanth@atheros.com,
        senthilkumar@atheros.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
References: <4e1374b1-74e4-22ea-d5e0-7cf592a0b65b@gmail.com>
 <20210922164204.32680-1-paskripkin@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20210922164204.32680-1-paskripkin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/21 19:42, Pavel Skripkin wrote:
> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb(). The
> problem was in incorrect htc_handle->drv_priv initialization.
> 
> Probable call trace which can trigger use-after-free:
> 
> ath9k_htc_probe_device()
>    /* htc_handle->drv_priv = priv; */
>    ath9k_htc_wait_for_target()      <--- Failed
>    ieee80211_free_hw()		   <--- priv pointer is freed
> 
> <IRQ>
> ...
> ath9k_hif_usb_rx_cb()
>    ath9k_hif_usb_rx_stream()
>     RX_STAT_INC()		<--- htc_handle->drv_priv access
> 
> In order to not add fancy protection for drv_priv we can move
> htc_handle->drv_priv initialization at the end of the
> ath9k_htc_probe_device() and add helper macro to make
> all *_STAT_* macros NULL save.
> 
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> Why resend?
> 	No activity on this patch since 8/6/21, Kalle Valo has asked around,
> 	for review and no one claimed it.
> 
> Resend changes:
> 	1. Rebased on top of v5.15-rc2
> 	2. Removed clean ups for macros
> 	3. Added 1 more syzbot tag, since this patch has passed 2 syzbot
> 	tests
> 

Hi, ath9k maintainers!

Does this patch need any further work? I can't see any comments on it 
since 8/6/21 and I can't see it on wireless patchwork.

If this bug is already fixed and I've overlooked a fix commit, please, 
let me know. As I see syzbot hits this bug really often [1]

Thanks


[1] 
https://syzkaller.appspot.com/bug?id=6ead44e37afb6866ac0c7dd121b4ce07cb665f60




With regards,
Pavel Skripkin
