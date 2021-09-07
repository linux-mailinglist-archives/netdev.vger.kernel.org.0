Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A20402313
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 07:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237387AbhIGFgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 01:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhIGFgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 01:36:19 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CAEC061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 22:35:13 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id j12so14589499ljg.10
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 22:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fv00XXSXV+0G1BZRvFbXikyIwPt2cAAWiqcIY/3kj2Y=;
        b=ASUOpxJ/Jo2oPytlpsKivfVD8m16CkMDihs4FFoBWkWpEjccYnn0xb7w8ryOwzXPaY
         am0f3PQTqelmdq/iyunj57+J6nJJ3g/0Wob4NmTeQf6MNr/AvsSaEyJKC9xuB8BUNs85
         Q8K8REDosJyB+tW9GccDPKx4WX4iEkxsHJimQ7wPHORYvFEYO/QU8gV6OcHDCJH7L4Z+
         rKIEpgNG5iDAH8kQy8j0nlluKwrYIQi/NDuM7fSMM1q7wOaYxbPxCP7ktFa9sxtiDTVM
         ufHO1thapMBawKVtR9Y0pZIzFjBhVNSpXl6h8bYssl3cd0bbL1/oaupMfAsVg27wRWHE
         /q9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fv00XXSXV+0G1BZRvFbXikyIwPt2cAAWiqcIY/3kj2Y=;
        b=NqPGkIKmFhiY9egn0NxtcYf2WnzhjmyfEJTtJErYeAG3qbARHEJ30x/mpsJ74LHE75
         Y4rzPzaPD1q5tIlxMD3bjgV8/3xBXFV+KjvAigC5m/rDipkvYUdS2bKSPkZZH73OwDEO
         XQ4DQ9Dl7d/JUCIE5LFNGWGyCVu9NJw2xNdht3uZrS76Eeb6kFWBE0W1b5KXGd9udONg
         8zowh4Wi6MGh+BhsQRiHMMx85zVnZEDJK0Ns2QQ8Mi/lMfqTXWcLbQnQU9OZ41YVcZfP
         Rh1ETWFUCoapgElgcLMPbVgbEsfkdglUi7/DWYEaUwfKt3x62HiB8cp7fySn6vIlW9Bp
         G/nw==
X-Gm-Message-State: AOAM531HsXufaFeGQitA8l12GH/K7xXpFqj3OWIkrenmojv5bPMNMTn6
        ox8UG/o7cIThH2gX2LTpGgo=
X-Google-Smtp-Source: ABdhPJw/1y7i264vZc7SFFFj8cao9KA2ds1Wnu9eWO9I+xpdgoipqm8ytle4MSONY+J7fXolxLXZUg==
X-Received: by 2002:a05:651c:102d:: with SMTP id w13mr13415058ljm.229.1630992911473;
        Mon, 06 Sep 2021 22:35:11 -0700 (PDT)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id z24sm909571lfr.105.2021.09.06.22.35.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 22:35:10 -0700 (PDT)
Subject: Re: [PATCH] net: dsa: b53: Fix IMP port setup on BCM5301x
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        patchwork-bot+netdevbpf@kernel.org, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        rafal@milecki.pl
References: <20210905172328.26281-1-zajec5@gmail.com>
 <163086540526.12372.2831878860317230975.git-patchwork-notify@kernel.org>
 <5de7487c-4ffe-bca4-f9a3-e437fc63926b@gmail.com> <YTVlYqzeKckGfqu0@lunn.ch>
 <20210906184838.2ebf3dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <8c81f173-88da-64e6-69e1-bf824b3a99ab@gmail.com>
Date:   Tue, 7 Sep 2021 07:35:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210906184838.2ebf3dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.09.2021 03:48, Jakub Kicinski wrote:
> On Mon, 6 Sep 2021 02:48:34 +0200 Andrew Lunn wrote:
>>> not allowing a proper review to happen. So please, I am begging you, wait at
>>> least 12h, ideally 24h before applying a patch.
> 
> The fixed wait time before applying would likely require more nuance.
> For example something like 0h for build fixed; 12h if reviewed by all
> area experts; 24h+ for the rest? Not counting weekends?

As a maintainer I'd probably prefer 48 hours with 24 h being a minimum.


>> 24 hours is too short. We all have lives outside of the kernel. I
>> found the older policy of 3 days worked well. Enough time for those
>> who had interest to do a review, but short enough to not really slow
>> down development. And 3 days is still probably faster than any other
>> subsystem.
> 
> It is deeply unsatisfying tho to be waiting for reviews 3 days, ping
> people and then have to apply the patch anyway based on one's own
> judgment. I personally dislike the uncertainty of silently waiting.
> I have floated the idea before, perhaps it's not taken seriously given
> speed of patchwork development, but would it be okay to have a strict
> time bound and then require people to mark patches in patchwork as
> "I'm planning to review this"?
> 
> Right now we make some attempts to delegate to "Needs ACK" state but
> with mixed result (see the two patches hanging in that state now).
> 
> Perhaps the "Plan to review" marking in pw is also putting the cart
> before the horse (quite likely, knowing my project management prowess.)
> Either way if we're expending brain cycles on process changes it would
> be cool to think more broadly than just "how long to set a timer for".

"Needs ACK" sounds good for a state where net maintainers need code
maintainer ack/review.

Do you already have some special meaning for the "Under Review"? That
sounds (compared to the "New") like someone actually planning to (n)ack
a patch.
