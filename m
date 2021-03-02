Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A9C32A2D4
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837657AbhCBId0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238808AbhCBBmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 20:42:42 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F12C06178A
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 17:41:40 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id k22so11065874pll.6
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 17:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=84355NBkcU1ghBFdxGwjfVXuVitUiaN4/TccOvqZLqA=;
        b=SrFI9NeFsDFAlDw5aUogFa52cjjf9Wdj5IyG/BQHP4MM7gh17XyA1e31hM/vg6qIPk
         8w2gdY79QkUmkQFB7Mqs5l004Y2ZzeHrhgw7ok9H6B6yoEBYyEiy09NU1R3LMm9dgkQI
         5i0hlWrZBYqq6Ad2KbgPerLT6/NKrsqIv+wtQXQqppBv2WR30h9VrAu3rPJrYM1Q7hl5
         ldjn6fUCHfY6RRuJtIDBmQ2I38XllWH8Z2URyZJeF3aL1KTHy7ZlUR4RqkXxlSE7SJjD
         muvIRmMb121oNlQoK+ZOixj0YrSE8E9jTE3McTgDWUMK629Ecnb6cyIQcrDcf3rhBoES
         SbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=84355NBkcU1ghBFdxGwjfVXuVitUiaN4/TccOvqZLqA=;
        b=LBNYTjJj+TPVo1UOcI64XWSoBbP7QUTN4tWU0hdg5GxY6u4H3QsI3Cdz2F4aB4i5kL
         m+pD1pcibGgOWzEAt+/zYWRhZuPvuKsoRgORA32WsBGH0cwNjJ6BANA2hWmJJXBZd7na
         wwwLi5ZnDYLKrJTKbcLtiFVwHrocHgHNnStemgTwsDr4CdaEq1B/tXwrQYZyYbtPg03Y
         qMDATHJdpkQqFZw8VT1AAMs/ckCSMOt41XGclKdLB7HbtnMpX3w8UmfoUCt/yoi7jVIW
         JQrcppi3dN0SAL8XyrIHC+BkqMq6zvNo/pZXwfs1pkAE/chasWkWX+Ue5u86XSmripR4
         UYpA==
X-Gm-Message-State: AOAM530UTBIXh9ycwztReYAnMzwSKOYYM7veM+ZYpqAbnx5Mh/YJ3Qse
        8XwXBUdHEE9doqj3ta0xPqQ=
X-Google-Smtp-Source: ABdhPJyey9TwpXUEzBgDd0blkzCTXXxG3H2YxL9R7B0mP6FNVN1zapxtYoe6SB4g5jDCnRPumk6UNQ==
X-Received: by 2002:a17:90a:9f83:: with SMTP id o3mr1756351pjp.133.1614649299993;
        Mon, 01 Mar 2021 17:41:39 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r186sm14301124pfr.124.2021.03.01.17.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 17:41:39 -0800 (PST)
Subject: Re: [PATCH net 2/3] net: dsa: rtl4_a: Drop skb_cow_head()
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
References: <20210301133241.1277164-1-linus.walleij@linaro.org>
 <20210301133241.1277164-2-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <02017d55-e4a6-36ad-efa9-daf9c204e02b@gmail.com>
Date:   Mon, 1 Mar 2021 17:41:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210301133241.1277164-2-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/2021 5:32 AM, Linus Walleij wrote:
> The DSA core already provides the tag headroom, drop this.
> 
> Fixes: 86dd9868b878 ("net: dsa: tag_rtl4_a: Support also egress tags")
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Reported-by: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
