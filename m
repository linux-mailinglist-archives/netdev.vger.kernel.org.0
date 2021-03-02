Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C90432A2D2
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837639AbhCBIdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238330AbhCBBmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 20:42:14 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A45AC061756
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 17:41:26 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id e9so826392pjs.2
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 17:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EMVJOGw37P6uBbfQhycEQW9HtQ+5CFMEjv0/Fq3rSW8=;
        b=LSYthEICEoXvQe3hGJ6VekVodlRwA8WgPOf8CcuU/jNnatb87bfEQA+JyrbNjJDP/s
         AtlCV4L8R4k4j9t4rUGlE6EvgFUNjicrFqDF9al2lEc5fZOb/awv8SToZFjC4PDr4xO+
         7E4M9ZGqVse7RiR0cIYlfcppmb5Usyix/7UyA3JyAzrXEvrsJXfogkrcp1w8SPCpqePk
         WKmRTcL8YRv6aAFwLURujMBm67eJmeVYGrLnyMAvTeS0BLv4IWxDSc14OKFdEoUBNDfX
         V063t1Y4Vv4WQ2NcMGHTYY27/eRW6RCvr24aWTm40+1EGU15qlW/dt2BUbnwYJ5Wr6mR
         Yexg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EMVJOGw37P6uBbfQhycEQW9HtQ+5CFMEjv0/Fq3rSW8=;
        b=iSCMbGdQ2hdGCgsfX1O7DbW23Kfs1DsGjX+fm29nhJ/c0OU4n/2+qERtcAFtu5neip
         TNFLNJ9ZSeDeM4LKhBjydutvWR30UAA5QR68FXQimcD4uDMJM90P7BHn+ExNecwQBZy5
         SF5ZFN1kZQMGcb50LLCB1HbObjmrCZmyB0RBJQ1G3lQAELQWgl7nP8ag4iJB+mlN6uf+
         VmR60KbhbkHqaLzqk8Ve+AisQMz3wiF8cXbht9OB+q/zSVZlIx1SSiIvu3wVA4VH5aQ5
         odX/9TU0XC47itdjtG+a6bNk7GjG+vnESCLcKCoRieGOC27kqL+oioQgpJ65pS9dyxAJ
         tmmA==
X-Gm-Message-State: AOAM530SvoU0pr5bhKSzpg31Xp8N8gkgB5llu03MBcyu1e7zCjbYPnJn
        a2sLoLdEp07sC7eTIXknm6NFj2ZswUY=
X-Google-Smtp-Source: ABdhPJy4xAYSx/xSWxw31RUsX/Jb0V0Vs5b7BDu82lqCzLPzVsLZD44pxNPxOM4od3SFBvHncTjZHw==
X-Received: by 2002:a17:90a:1b4e:: with SMTP id q72mr1745588pjq.113.1614649285781;
        Mon, 01 Mar 2021 17:41:25 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n4sm18116809pgg.68.2021.03.01.17.41.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 17:41:25 -0800 (PST)
Subject: Re: [PATCH net 1/3] net: dsa: rtl4_a: Pad using __skb_put_padto()
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
References: <20210301133241.1277164-1-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9f47fe5d-9d9f-71ad-6a38-124b2c31b596@gmail.com>
Date:   Mon, 1 Mar 2021 17:41:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210301133241.1277164-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/2021 5:32 AM, Linus Walleij wrote:
> The eth_skb_pad() function will cause a double free
> on failure since dsa_slave_xmit() will try to free
> the frame if we return NULL. Fix this by using
> __skb_put_padto() instead.
> 
> Fixes: 86dd9868b878 ("net: dsa: tag_rtl4_a: Support also egress tags")
> Reported-by: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
