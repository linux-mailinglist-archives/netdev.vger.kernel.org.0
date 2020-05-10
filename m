Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6791CC5B0
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 02:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgEJAJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 20:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726356AbgEJAJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 20:09:20 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD08C061A0C;
        Sat,  9 May 2020 17:09:19 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m7so2316452plt.5;
        Sat, 09 May 2020 17:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o3detd1AYttJs6OZpXIVQGzd1u5wNOYGeXzjS0zdGOI=;
        b=ITtgJmOqbz1RARnFlLwvp1UVvFPcGlbIzOxQXHCurZSKpLeTEf2yB4POAZM6itE9RG
         AiCraKFErAhxzwmJXu1RElED84RNphU5hlvJzai6KNglwWOZa8u0nucQJcJ1j19NOoln
         EHYwFRFZ3t1gOTTVK7ASQ7VfMYo0lFtkPFqqDmJV2Re+i2F0e4x4uOU++VJ2At8VKSCn
         aqY0QHiptt7kYcyFD0VOThJOtruzG1sU9pFC0d8vvDCHIiS0peZuPpsbE9gDjJFuWLzm
         ID0uINefWsu0XfGtcBgLUZos3vFq8n5HeR0IBpkh+idcU9J8yZt6xaE/2lLnF8OhegYO
         K1gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o3detd1AYttJs6OZpXIVQGzd1u5wNOYGeXzjS0zdGOI=;
        b=LV//v6SzdhRw3K9v+VQTykad8mFy6Oz5SVMUHO4m4Sf7P7Aq4BVv3tR1TrhPrDRO5A
         iYUINz4MCGul3df/vX78sNBZTyGfyDSS8fXfZT+rlORL+x33tbJZzCQd5dyDiXsGdbW4
         TE+Y4X4fz/queKqqx7CO9Jwb+Nc2u9pBhW4NZJ/UALgkoriYjOjYUvM+t1oDzT/I1Xlf
         QPCcKFqkZAU3ToiqZBbzNZiobdxC8n+jvGercidZQPRFRkLTHbgyxnSXaRtoH3Xzvsfc
         BSzAnc0JmhrVTiKx/CSGIgAKFbJJEWidoGnovN5u4sGOg/npbJjtOCVipLKF80OJN1W2
         VAwA==
X-Gm-Message-State: AGi0Puaz3aR8+lRxWarCKZ3A1qSN+OQ078oZOR3iMw/s1MgmOc6AHf3p
        Ny3vOx8jgXkrrhV9ubhK+y+UAedH
X-Google-Smtp-Source: APiQypK+cg77Bzb7ew2Ocqaezdzd2cqLJPDE/5q0GVHgBpvRbhWDNAMHP5/Xsd3Cl6OHnfftRu4s5Q==
X-Received: by 2002:a17:902:8b88:: with SMTP id ay8mr8778126plb.235.1589069358903;
        Sat, 09 May 2020 17:09:18 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m18sm5920235pjl.14.2020.05.09.17.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 17:09:18 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net: phy: bcm54140: add cable diagnostics
 support
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
References: <20200509223714.30855-1-michael@walle.cc>
 <20200509223714.30855-5-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c37337c1-f339-03d1-bcee-aedd2e68501e@gmail.com>
Date:   Sat, 9 May 2020 17:09:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200509223714.30855-5-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/2020 3:37 PM, Michael Walle wrote:
> Use the generic cable tester functions from bcm-phy-lib to add cable
> tester support.
> 
> 100m cable, A/B/C/D open:
>   Cable test started for device eth0.
>   Cable test completed for device eth0.
>   Pair: Pair A, result: Open Circuit
>   Pair: Pair B, result: Open Circuit
>   Pair: Pair C, result: Open Circuit
>   Pair: Pair D, result: Open Circuit
>   Pair: Pair A, fault length: 106.60m
>   Pair: Pair B, fault length: 103.32m
>   Pair: Pair C, fault length: 104.96m
>   Pair: Pair D, fault length: 106.60m
> 
> 1m cable, A/B connected, pair C shorted, D open:
>   Cable test started for device eth0.
>   Cable test completed for device eth0.
>   Pair: Pair A, result: OK
>   Pair: Pair B, result: OK
>   Pair: Pair C, result: Short within Pair
>   Pair: Pair D, result: Open Circuit
>   Pair: Pair C, fault length: 0.82m
>   Pair: Pair D, fault length: 1.64m
> 
> 1m cable, A/B connected, pair C shorted with D:
>   Cable test started for device eth0.
>   Cable test completed for device eth0.
>   Pair: Pair A, result: OK
>   Pair: Pair B, result: OK
>   Pair: Pair C, result: Short to another pair
>   Pair: Pair D, result: Short to another pair
>   Pair: Pair C, fault length: 1.64m
>   Pair: Pair D, fault length: 1.64m
> 
> The granularity of the length measurement seems to be 82cm.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
