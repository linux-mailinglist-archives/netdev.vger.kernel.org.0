Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1288306A96
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhA1BnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhA1Bmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:42:36 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34885C061756
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:41:55 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cq1so2914021pjb.4
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EFMu19qyqL3SyD+3VB9YbFUH1W0+fr5OnZ2FjMJy2Og=;
        b=BE15wn3wX6ZZzlKg1tDy+bJErHg5jKyPXMGt5MbKGWTBETocCYBemOcU7kyvuuy1zw
         wl9Xg7DTGYHQ7dwByfrXTZeJDf4oBQG1yvaNQ+BW1fYiWRPPMIqIHH13r/dSN48vn8rg
         2pJEuNmvUztDZ5IUP+AcbIxLI1Ma/X0uw2+G4Q9cFdr6LlTe7ACKoBPICx2TyeumdrTP
         e6yKuWdkII41ssIq6O3hDU+wYLdKrx+9SJLOgZJ18dn0mE4yv9/zYpRHOnb3RTmP5e6J
         vp9MFm4mU2Cn4P4MxOWH62StKwR7Vyc9J+Mpg+C1VX9tyl8+SovwUmxam7MK0+8814In
         LFbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EFMu19qyqL3SyD+3VB9YbFUH1W0+fr5OnZ2FjMJy2Og=;
        b=TjKmeISb9rV1j65ygIriUI+gJpfBxSVJ3OwZH7RYe0CXFtSTK7A5r4xNparG2ik0XJ
         S8POOi7oiJgtECLHpghq2ZSlt4j6NC6SgaM35SASG0E0ZBmjQWvCyrxzYkqi8O+irw0d
         1lzoiqGRxhlsnlj43m/7m33jtH0b7cRN+c3/VU9I9viZhSP8xIGO2F6M4gvPPhlUYRoG
         nxJLF18Way+YiyyeCEOtFZaNWx9lLO2G0oLLPG/P+TV8fQHGfG1wM9vHNpY50fbqzQyu
         byxKTKJNq5IpKR3RQW5dPSGHoT1wxzUqm/Y6k9JqNzKjJhnw0B39f9390gmBrRt+PZE2
         q9oQ==
X-Gm-Message-State: AOAM532UIUm8f1hOOgIk1Mja9R8w2MCUHBj3lBnx0YWg+4SK6jM22nRY
        fu6r+HVIVUBymdK2ItJa8pG0K3mY5DY=
X-Google-Smtp-Source: ABdhPJwKr21MuejTrQqZ7RGLI28vIvNpw7MsGezRW6QCYNi9pUj1OJpMQ8kty6JTWUrDVvKHGYEhdQ==
X-Received: by 2002:a17:90a:183:: with SMTP id 3mr8565048pjc.99.1611798114680;
        Wed, 27 Jan 2021 17:41:54 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k6sm4032589pgk.36.2021.01.27.17.41.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 17:41:53 -0800 (PST)
Subject: Re: [PATCH net-next 1/4] net: dsa: automatically bring up DSA master
 when opening user port
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20210127010028.1619443-1-olteanv@gmail.com>
 <20210127010028.1619443-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <18e4ade4-65db-c318-5365-99ef27f02c06@gmail.com>
Date:   Wed, 27 Jan 2021 17:41:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210127010028.1619443-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/26/2021 5:00 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> DSA wants the master interface to be open before the user port is due to
> historical reasons. The promiscuity of interfaces that are down used to
> have issues, as referenced Lennert Buytenhek in commit df02c6ff2e39
> ("dsa: fix master interface allmulti/promisc handling").
> 
> The bugfix mentioned there, commit b6c40d68ff64 ("net: only invoke
> dev->change_rx_flags when device is UP"), was basically a "don't do
> that" approach to working around the promiscuity while down issue.
> 
> Further work done by Vlad Yasevich in commit d2615bf45069 ("net: core:
> Always propagate flag changes to interfaces") has resolved the
> underlying issue, and it is strictly up to the DSA and 8021q drivers
> now, it is no longer mandated by the networking core that the master
> interface must be up when changing its promiscuity.
> 
> From DSA's point of view, deciding to error out in dsa_slave_open
> because the master isn't up is (a) a bad user experience and (b) missing
> the forest for the trees. Even if there still was an issue with
> promiscuity while down, DSA could still do this and avoid it: open the
> DSA master manually, then do whatever. Voila, the DSA master is now up,
> no need to error out.
> 
> Doing it this way has the additional benefit that user space can now
> remove DSA-specific workarounds, like systemd-networkd with BindCarrier:
> https://github.com/systemd/systemd/issues/7478
> 
> And we can finally remove one of the 2 bullets in the "Common pitfalls
> using DSA setups" chapter.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
