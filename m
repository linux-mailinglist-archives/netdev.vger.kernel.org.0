Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBFA3242E9
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 18:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235801AbhBXRHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 12:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbhBXRHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 12:07:03 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE30C061574
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 09:06:22 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u11so1553799plg.13
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 09:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bYhCkeDdnE21YS/hmTYTxsittsiOnuQLhQRmEVvfQ4M=;
        b=tAaovtwwT9NVAj1FNLrJze7E+HApAo2fbwqzgCvKP8ozDCG+Ds5B5ovT50hLKGeTEf
         MX6SurdU0xB5m5kXuiLpXYg+LYQ9c8p7BWY7gTkwwbIg0HI3MwCidjwfOY1JIGigA6rl
         i3xp++1oUGsAaSxc3U2xWEqLxUPcAQ5sIWFDRvR1xxWr2C9pakeBqJFNHf5o3yKM+uDf
         20scNT/P8O9dE8EtgR4B9h3j3sfiqSApqIXDEBVvhNJyOT1r2pyvdwNTwQ9GkG5kJBOb
         FLt9T5cTPUTN63H8Eur/7HQDI17EnbRvd7RsX3SULZOIQqKXbMbqrWcf+zC9r7tQFTZJ
         z+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bYhCkeDdnE21YS/hmTYTxsittsiOnuQLhQRmEVvfQ4M=;
        b=Kbl6nqOly9N1kKN9N0a/yo4gv/X/FAulEQbksiu0ZfevdJ8BXEJH0+V63yQjLlLa1d
         Fw8fgyl8V/nzqO83Fsd3NYFVWVIhHIRTTQXHlIaQ2MesBi2PiK183++QPY70WqiJrEty
         gDoBDIVAvmcShFt7XodOhvzBVHLT7mAX4fSC5h3KuHrink1iXtcz36FoP0hgPQx53dyo
         G20DoJoCVHLMsfILRRUreJb5pOmgyWx2ZvV/4/rRNcCcMXyztinZBZCV6RWE6NMZkDDt
         aNUlRv8f/GGYf+r5vXm7Ph+jT99DmuCEr1RBgBmtIm4cUgL1OwJ39w5jEIRRLFu+Dftz
         Ssmw==
X-Gm-Message-State: AOAM533uCoM+ubYOv6qBx6k6VcUzA7W6K+PcJQuz3H0Mf4UcZUYoWK3B
        jOZcvIVVJsmogOPHgmsjhHJVLLJcLOo=
X-Google-Smtp-Source: ABdhPJzS3yJk3afjZwTtKMK0oGpkhhn1bbW6J9VM8zvtmbBzuAYysreQA9Dn2ETvHzZV4b9Hz0JJow==
X-Received: by 2002:a17:90a:e2ca:: with SMTP id fr10mr726820pjb.18.1614186381705;
        Wed, 24 Feb 2021 09:06:21 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gd18sm3457058pjb.5.2021.02.24.09.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 09:06:21 -0800 (PST)
Subject: Re: [PATCH net] net: broadcom: bcm4908_enet: fix NAPI poll returned
 value
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210224151842.2419-1-zajec5@gmail.com>
 <20210224151842.2419-2-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dac1dd32-6b92-f863-7f01-c8131ddd96d2@gmail.com>
Date:   Wed, 24 Feb 2021 09:06:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210224151842.2419-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/24/2021 7:18 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Missing increment was resulting in poll function always returning 0
> instead of amount of processed packets.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: 4feffeadbcb2 ("net: broadcom: bcm4908enet: add BCM4908 controller
driver")
-- 
Florian
