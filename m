Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC1B19AA0F
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 10:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388911AbfHWISS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 04:18:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33126 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388604AbfHWISS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 04:18:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id u16so7825964wrr.0
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 01:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=prXm3P3EuozGuFJkO3h5BCLJubkE/g8QKoERuCU4E8M=;
        b=fweN2nB3N+MJP0ngSWEQ7i9ICK8STO+eyQwG7DASE6jmfiR7L1GVpnqrlGWHT9dAKv
         1MUob/wt6UwJlXxof8YC5qD4F3djycZ469WUJ+0rAFtioo5yfEwJYNZXPoPIUhPV9vyI
         AFX6KhzOeBh9MDNDlCaW8z9Z9l/KwtXeiWjjw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=prXm3P3EuozGuFJkO3h5BCLJubkE/g8QKoERuCU4E8M=;
        b=VJmCQ7S0eacozWV4x5RP8Fp41F0kDaYPJs6LjuAMAdM0W4M7L0o6J4Qw+p6oInEy1P
         jf3aeRsSwHuOdvWXX7UdaUYiAdvnPOHZ4jaD+B6Hv0NFfQtJ/Jx44xNb5Ut61KPylsGu
         htVDRFGR+f/Lx/ufxt+kcVlo1Q2UBCrbXNllR3Xstjp+s0OcHSxrYFs46fyFp/JC/UgM
         iMuA3Qt8vrGSFu1vYa/b+ldLrBN4CgEXehcwn4iNdjPJiEy7gzcTJcMRogIfWWgmZaQc
         Gt89ikG8OSLonOz7tnk0H8pbmYeQgfLjYH2UmFbSlVxoTIJZ1eCFiZ7Z5F3ZEt/Rur5R
         OeYw==
X-Gm-Message-State: APjAAAWlwqH4/r88ebz15ld0HWUKVOG3aMhYamkePGFBLOZqWTXtUNqY
        aDFlMX+rM2C+Xbt7mSNyiBPKSw==
X-Google-Smtp-Source: APXvYqw+XUl+DLn+INP9GfpdrffdxYEgE59Xt8vee45Eb39L4aEq5x+cjyJsy5MtieVi+SDMo3zuBA==
X-Received: by 2002:adf:e504:: with SMTP id j4mr3465872wrm.222.1566548295940;
        Fri, 23 Aug 2019 01:18:15 -0700 (PDT)
Received: from [10.176.68.244] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id e14sm1771959wma.37.2019.08.23.01.18.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 01:18:15 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: replace strncpy() by strscpy()
To:     Xulin Sun <xulin.sun@windriver.com>, kvalo@codeaurora.org
Cc:     stefan.wahren@i2se.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, brcm80211-dev-list@cypress.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, davem@davemloft.net,
        stanley.hsu@cypress.com
References: <20190823074708.20081-1-xulin.sun@windriver.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <894851e7-f057-4789-f9af-f098a968d713@broadcom.com>
Date:   Fri, 23 Aug 2019 10:18:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190823074708.20081-1-xulin.sun@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/2019 9:47 AM, Xulin Sun wrote:
> The strncpy() may truncate the copied string,
> replace it by the safer strscpy().
> 
> To avoid below compile warning with gcc 8.2:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:In function 'brcmf_vndr_ie':
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:4227:2:
> warning: 'strncpy' output truncated before terminating nul copying 3 bytes from a string of the same length [-Wstringop-truncation]
>    strncpy(iebuf, add_del_cmd, VNDR_IE_CMD_LEN - 1);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Xulin Sun <xulin.sun@windriver.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
