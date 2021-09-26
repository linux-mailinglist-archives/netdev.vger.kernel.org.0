Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6E54185B0
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 04:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhIZCdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 22:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhIZCds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 22:33:48 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E75EC061570
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 19:32:13 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id j13so13409146qtq.6
        for <netdev@vger.kernel.org>; Sat, 25 Sep 2021 19:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Zd9V205mJf6Bbk5O7ewUq5k0H5GPeZ+CHiDKdBStfPo=;
        b=U3Q5gB6mTo5PjtVlKYC+4lSzgmZIHB4xodnX18mbejsfWr5DitEe+NAZjt51q+zHFe
         UKHe5sk2cIrnMEkbKqL6GvqCcZdd/B9eIlkZU6JLOepn+1pt1cseU26LHe8f/31JuUZI
         5aLvDNQgWIdef0dUSbZuAQ1f29XRKzh4+FuQKPDx0Flb1clN4Xe+GKBY74+wkrdRnKYa
         Aa0PUS2UaVlugQ9rNugLVxB2iWXo1ELc0pu7mYC15cOppaSABj9UN0lwCEfxmVanUgJb
         QUfFkfN2pJ9eNzk7ZegftvZRGE1ysHgJ6XJK5Ycj3ok4qv48jT2b+oIiM4OcB0IGPGXE
         RVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Zd9V205mJf6Bbk5O7ewUq5k0H5GPeZ+CHiDKdBStfPo=;
        b=sjeOCXng3pwhM/RwlAm+dKw5RhnWcEov2h2vUvkhLSdaJOeEH2y7cieSNX19aHzNI+
         LiaRebDleO2Nt4UnrJMNa0N5yegGnZRXcsrlcs2cSbpISFtcryxDjFlvQJA6KKyMOvYx
         WQCui645ov7nPI3ZZPZwr3SI924+67EKYl1QBLPMpkpdOM0FzKrb3IEg+AagdL7diF6E
         rfZiaIwPLqGwF0TAtsZ/VlR8Wo0sdKts+3SA4kcMCGSZmuG6Xcb5leVvTG8MN4SUH+/i
         3UAFmQNQ9jLwH3Jxq0Twbcy80QtRkJiziGMrN6bNbxIJfgFEFaSwdfJAyjMpgm+j2y2f
         DQ6A==
X-Gm-Message-State: AOAM533rWY4VfOvcjbDSjSpg22qm0ds4OC+J+Zf8Cz4sNNgMYQdY8lOu
        LfAqwYrPVf4iyOtUcwl9QVM=
X-Google-Smtp-Source: ABdhPJztxMbW8+vGSs/RqwROu/XZwkp+Y/xv2ESHlpjoJjt3ToRuObLvVtBoeEUGn8oVmaoMCpgatA==
X-Received: by 2002:ac8:5f0a:: with SMTP id x10mr5509162qta.175.1632623532228;
        Sat, 25 Sep 2021 19:32:12 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:a90f:da5:ff6e:aa3e? ([2600:1700:dfe0:49f0:a90f:da5:ff6e:aa3e])
        by smtp.gmail.com with ESMTPSA id u19sm5179328qtx.40.2021.09.25.19.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Sep 2021 19:32:11 -0700 (PDT)
Message-ID: <1d725fdb-8f80-1fb0-70da-c2ae4facb950@gmail.com>
Date:   Sat, 25 Sep 2021 19:32:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH net-next 4/6 v6] net: dsa: rtl8366rb: Fix off-by-one bug
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
 <20210925132311.2040272-5-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210925132311.2040272-5-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/2021 6:23 AM, Linus Walleij wrote:
> The max VLAN number with non-4K VLAN activated is 15, and the
> range is 0..15. Not 16.
> 
> The impact should be low since we by default have 4K VLAN and
> thus have 4095 VLANs to play with in this switch. There will
> not be a problem unless the code is rewritten to only use
> 16 VLANs.
> 
> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
