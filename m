Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086282252BB
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 18:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgGSQII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 12:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgGSQIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 12:08:07 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576EEC0619D2;
        Sun, 19 Jul 2020 09:08:07 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id q17so7838809pfu.8;
        Sun, 19 Jul 2020 09:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6e6x8F+nvFKYkpVM/PBmF306fEprwt2iW+/MkbLnTGs=;
        b=aDnO2D45JbleuQy+nqiM6Oh/adaAOBrOcXuuemjX72m35hlYQEzLP0ET6aKyZW/0De
         +Q7mdBtnW2C5kBm4r3RDNQG9lKtExMhAXvsrgNfkYbSwZSl9NbshjnImw901pffKZvZh
         0puhJSax5UZ4+ZuYvL4ifvRgjpmtIa0FeQ5nocgg6PrAAaWjFvLoWoY9a0O7epbvF2u1
         ecHEB3pESaEcR+8F4j+4aLHn1uYeBBlW0myRFkry4GDjXOxjFoN9Ic13sAoer3RbGZgy
         2uaff1ZjSdf1FIwBdJKbutM0wwJO1JwLT+EP7bVl2Rz8/ZZufcHe7CR86iVjRGK+1mUy
         /g6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6e6x8F+nvFKYkpVM/PBmF306fEprwt2iW+/MkbLnTGs=;
        b=l88wOgUForAhxUCzkMbBDmln/A3CTiXqti5HbIdmrBvg22pEX4AKLopFyDak5WalU9
         X4ZnG+CbpIiguSFXV//t/9MRvLS4NEZnWaTADPWAIO9kK5QQZ8ikz37PA2NB/C2Oe4Tk
         9CUxdXdroCRp5QKb6a3TKCIr9nbWZjzotxsNQDr88DU968wDi4vFZ+nVS4DMVMyJcRae
         UL8nO1hLLH/I/cguCNXjJeSF1fU9k54StoY8MEBTBI1L6TjFf4WURyB3taoDpTAJPbrJ
         lSEWwOaBH1eqghv+944nRpTL1YBU500u460mg4MBTQD0HngW6DBEk3kjR6AshanjmN96
         5wxw==
X-Gm-Message-State: AOAM532hOcQ22x4Ek8HPk0KA+YKt2VnRGz6XMj5T6Ep9NTAkBAxNeoSm
        H1E9I94enI7Dtz6NG2Q5JeqUhStm
X-Google-Smtp-Source: ABdhPJzvwR12vzZqXmb2+F8OxWENfXaTcZP46py/Q46CQ4GDJcZAqjKtqTP9Vtj5zgxnq7Da6YtIKw==
X-Received: by 2002:a63:9212:: with SMTP id o18mr15864925pgd.347.1595174886437;
        Sun, 19 Jul 2020 09:08:06 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 190sm13800325pfz.41.2020.07.19.09.08.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2020 09:08:05 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] net: Call into DSA netdevice_ops wrappers
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        open list <linux-kernel@vger.kernel.org>
References: <20200718030533.171556-1-f.fainelli@gmail.com>
 <20200718030533.171556-4-f.fainelli@gmail.com>
 <20200718211805.3yyckq23udacz4sa@skbuf>
 <d3a11ef5-3e4e-0c4a-790b-63da94a1545c@gmail.com>
 <20200719160441.GK1383417@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <898882da-780e-babb-15d0-01d3bba07f67@gmail.com>
Date:   Sun, 19 Jul 2020 09:08:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200719160441.GK1383417@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/19/2020 9:04 AM, Andrew Lunn wrote:
>> If we have the core network stack reference DSA as a module then we
>> force DSA to be either built-in or not, which is not very practical,
>> people would still want a modular choice to be possible. The static
>> inline only wraps indirect function pointer calls using definitions
>> available at build time and actual function pointer substitution at run
>> time, so we avoid that problem entirely that way.
> 
> Hi Florian
> 
> The jumping through the pointer avoids the inbuilt vs module problems.
> 
> The helpers themselves could be in a net/core/*.c file, rather than
> static inline in a header. Is it worth adding a net/core/dsa.c for
> code which must always be built in? At the moment, probably not.  But
> if we have more such redirect, maybe it would be?
I would continue to put what is DSA specific in net/dsa.h an not
introduce new files within net/core/ that we could easily miss while
updating DSA or we would need to update the MAINTAINERS file for etc.
-- 
Florian
