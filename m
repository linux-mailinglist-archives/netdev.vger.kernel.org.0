Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722E44A9D5D
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376749AbiBDRGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbiBDRGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 12:06:38 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB55C061714;
        Fri,  4 Feb 2022 09:06:38 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id z14-20020a17090ab10e00b001b6175d4040so13710340pjq.0;
        Fri, 04 Feb 2022 09:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=f5ROkE2U+hyIbBAHZVrZsfusqtai3Yw4oyT6YlPiyuA=;
        b=BKQJbbScZLIs0nTh6kLb+roN3r1BXGlGKsqhzbs9GLr5lqzR8td1wDTjAbxmpckLzZ
         M/mnWXi0cqVmya334xzAZtA1oYM26mt3nYhIl9LXRc4HWYurSN+5rd5jdnaDqOtSm+rd
         1kuZWTa8/8aX7Ri/lI6t9mULqPdIxA5oXF0w0CE+Lv6WroCJM1Fxf8FLy8ZxX3rHyoR0
         kuL9UxvwamfU6nxXro1gXJE8nqBpukK04PEBJpNeQnaz9KpRmRZ/vbVfsf1IQvy+GK/5
         dItJ4NAYLYPM8PYlCdyFqGv+PgfysNM195HTu7oA57+3ddRTRP6hqZegTyG69HLCE5+O
         EbRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f5ROkE2U+hyIbBAHZVrZsfusqtai3Yw4oyT6YlPiyuA=;
        b=rdbmDBJUwLloXUO9JBEOG3UVssJlkdMo+ewJMoKoks7LeEI7s7t8hbnhI8b7GAR05e
         GN+KBCwuYlnOLj46Cx+YOOmNVUrhQ5wmnaHWHQlGd9dR7YyZqXZib1jjqHT7VXV8jl2f
         INpPlQZBIYlDcXOd0QyAKUKb3IMpvNQNlyeO5stqZ9LFdKRtPfqafw99TjoHqGUr+syS
         XsGrzmTqDsXGHwElmyjFBrJ74sGFrY/vPXnOyRMupqJvmVHPZohHNzDZWBh0YuriocBs
         Sn0RHIugvuRbHpOdUP9igHPEpTnADwDksm0Q1gkLxm8wrIRQYUvK18UvWxEPZSM6aFb9
         vzKA==
X-Gm-Message-State: AOAM530WDgz0UP/+dgxV3NqZ/dRMlUL/u0BAEREQUKtGKlUQ8t3alYuT
        TjRfdzqxOfTVH0kxOIIt1cM=
X-Google-Smtp-Source: ABdhPJwPxbzCGlxxeh/li/K5XsT7k1jPkZksDzQFHOEEThQJvVoLRM/fBB55pH/sof15wJyAY0SAEQ==
X-Received: by 2002:a17:90b:1bcf:: with SMTP id oa15mr4187426pjb.67.1643994397510;
        Fri, 04 Feb 2022 09:06:37 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g2sm3252778pfj.83.2022.02.04.09.06.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 09:06:36 -0800 (PST)
Message-ID: <23b8c673-9fd7-0ddc-3eee-935e6cbd2dc2@gmail.com>
Date:   Fri, 4 Feb 2022 09:06:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] net: dsa: qca8k: check correct variable in
 qca8k_phy_eth_command()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20220204100336.GA12539@kili>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220204100336.GA12539@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/2022 2:03 AM, Dan Carpenter wrote:
> This is a copy and paste bug.  It was supposed to check "clear_skb"
> instead of "write_skb".
> 
> Fixes: 2cd548566384 ("net: dsa: qca8k: add support for phy read/write with mgmt Ethernet")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
