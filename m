Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B55B2A35C9
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 22:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgKBVJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 16:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbgKBVJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 16:09:18 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20100C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 13:09:18 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id j18so12264878pfa.0
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 13:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gFoyfo3XU/VbucV6oSS/6R4FFkj/4hsTcRiVC5PWCAU=;
        b=FGHaQLMjnui44plaweSQD30qL9SwL8Nn3ZaOf+A0AllrSLiXA6Mqh6INnjOK31a9vU
         NV2lQEh9ZEf7BYAvEMG4UMlIsIVmRht2bLvIca4kwjbR4YeohkCm69T1JWX5+5rG6cx0
         TD2w6mk2KqBYitg9A5i+64u/g8CC/lXWzRi7O2XPkYRDuEmi2RHka2rW4MIMqhyIDvGe
         Ztv8KnTsFaTuImIGgakLI9fFS8Vg8dsA5aNWwN0Tw5Zd8kRi8VDfZYrR9IWWXeRhK1ZR
         6ssQxYN8HNpIdUpHBiGOHQ2RcVYLdCpi9F2DoF7Glue9s8aQD1Ij1uS6mD6o65avSk9b
         rpeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gFoyfo3XU/VbucV6oSS/6R4FFkj/4hsTcRiVC5PWCAU=;
        b=KrwraAmRQAvJPkYwGWrgW02NuwfdMuXw3Bhgdh7t56O6McUgW5yR5HQrVRkok/5pYX
         c13sMXcrgjH+Rvz3L3Lx1xjCAikEgvH3r/MvW/USjKRsTh0hlF7Ni+7jpUsoBzNfs+9u
         C7VwAw3M4CdwIXCBAD54+4ObDdK3bMbjcZRP1RIYPNuO4MVzo58TsH6HKtujTccWvaWW
         ewgj6hmB+C2k/X0P4Pr+7Xbedo6x4qxJS7CD2E6i7zxnFu0q9Qz8QEL+f59/nWm6RHzs
         p3JiNDWnUneVY7EP//v/QOabQtkik9caH86yMU6L5TwjoPif+3d0H934TzjktMR9zEZl
         x6yA==
X-Gm-Message-State: AOAM531GPH3tLcoIm4tf13xOA3Eiec6KZ1l2uBLkHVrhN0mnu72ReNjs
        4/zA18JsGDAtLe8efVUyHQfM6BOdsTg=
X-Google-Smtp-Source: ABdhPJzAAOsZNY8drM69OAR0YzIxf0DxdpCLVZL1j/H2nVPe8Kihw1zIMDy8IZWlVL0bRj8nVyq7HQ==
X-Received: by 2002:a63:500c:: with SMTP id e12mr10778340pgb.346.1604351357370;
        Mon, 02 Nov 2020 13:09:17 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h14sm3537332pfr.32.2020.11.02.13.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 13:09:16 -0800 (PST)
Subject: Re: [PATCH net-next 1/5] net: core: add dev_get_tstats64 as a
 ndo_get_stats64 implementation
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
 <4580e187-9c2f-dfdf-d135-a5c420451428@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4727de94-62df-4fae-d966-8f6a28b4069f@gmail.com>
Date:   Mon, 2 Nov 2020 13:09:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <4580e187-9c2f-dfdf-d135-a5c420451428@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2020 4:34 AM, Heiner Kallweit wrote:
> It's a frequent pattern to use netdev->stats for the less frequently
> accessed counters and per-cpu counters for the frequently accessed
> counters (rx/tx bytes/packets). Add a default ndo_get_stats64()
> implementation for this use case.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
