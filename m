Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F3D2CF23C
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbgLDQsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgLDQsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:48:39 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1383BC0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 08:47:59 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id o9so4093135pfd.10
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 08:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=sCBA1JTH89d63eQFJ09waU8HObVKCbnr1NyXd9ofD4U=;
        b=Gh2wP+ppvxPgJKLqRgV2EqiICk/14DfLHhb0gKhfGf6beqY41BDEjUUhA4gHcLJ2tc
         WYLjb2KR84H02AAflG7RU0iLpsjYjxYCB0Or4Hhfnu++z00ZiGTo3apMqM9VyMLCey/5
         o1slTetGyxnjr8abG2I6TAmetVYSDhds4DHc5PJi43QXE3D+szJB0AtCN/Df2PDAhK/0
         ca9DTdQls3X6JoyaWjQS0fZpRVDArLgvIZAerQhjhQBgBv3lRsXh8hW+yYRTx4ghjzsW
         tJtryEPt+JK+6MtIezM9QAxSR2ASpxZf7+W+Ac34e9Wg9LrlLQEN4VqKEDY2SbpaE//9
         mVHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sCBA1JTH89d63eQFJ09waU8HObVKCbnr1NyXd9ofD4U=;
        b=Qw0fJKfT3sgxB1KXvTMYP50YWlXJWjY7kSUc/QPgkrq/8M/QyfePGkctifc67GjHnG
         FuLSI3c2JQKrPOphYuNUpqG6gqf+fz4T8Jq50KCnU/lQU0icfQYG2Sqnt6MuljbdKCRr
         cBmrzfSgtaJ+5MekmdFgdxOXUCYGmPCVRfXuE/w3LGgRT5KdlIgr3ESFhtN7UCZWAkRZ
         mGU5OkTxj1wx/OpyUFTpSZ1RJvicKKqliLinRLqAU22/Ww+pAzmo/+nqom2MeQlVj0wt
         PypuhH2Q5fDN0VJMV1giBeXSjczuLI+KYpvRHDuXBla0sp7qaxl28f39auILfwWShyhS
         jNWQ==
X-Gm-Message-State: AOAM530I7SWw4AjGMq5fJfHr2pR0jpSZRSoEdB6tDIOMFIUltkrONIuF
        vYNF1uHYwdGCJciSvkO/f3S+YVgbK/U=
X-Google-Smtp-Source: ABdhPJzR7wOfdguQrW603G7Lg7IpVmTNH/uPlakjMZtdoRCJXaIIlG+vR8tBxv/I1mbhyy5dyiB32w==
X-Received: by 2002:a62:77ce:0:b029:197:6f40:a1bf with SMTP id s197-20020a6277ce0000b02901976f40a1bfmr4718585pfc.69.1607100478544;
        Fri, 04 Dec 2020 08:47:58 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x26sm5165345pfn.46.2020.12.04.08.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 08:47:57 -0800 (PST)
Subject: Re: net: macb: fail when there's no PHY
To:     Grant Edwards <grant.b.edwards@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com> <X8fb4zGoxcS6gFsc@grante>
 <20201202183531.GJ2324545@lunn.ch> <rq8p74$2l0$1@ciao.gmane.io>
 <20201202211134.GM2324545@lunn.ch> <rq9ki2$uqk$1@ciao.gmane.io>
 <57728908-1ae3-cbe9-8721-81f06ab688b8@gmail.com> <rq9nih$egv$1@ciao.gmane.io>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b842bb79-85c8-3da7-ec89-01dbbab447f5@gmail.com>
Date:   Fri, 4 Dec 2020 08:47:53 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <rq9nih$egv$1@ciao.gmane.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/2020 7:54 PM, Grant Edwards wrote:
> On 2020-12-03, Florian Fainelli <f.fainelli@gmail.com> wrote:
> 
>> You would have to have a local hack that intercepts the macb_ioctl()
>> and instead of calling phylink_mii_ioctl() it would have to
>> implement a custom ioctl() that does what
>> drivers/net/phy/phy.c::phy_mii_ioctl does except the mdiobus should
>> be pointed to the MACB MDIO bus instance and not be derived from the
>> phy_device instance (because that one points to the fixed PHY).
> 
> So I can avoid my local hack to macb_main.c by doing a doing a local
> hack to macb_main.c?

There is value in having the macb driver support the scheme that was
just described which is to support a fixed PHY as far as the MAC link
parameters go, and also support registering the MACB internal MDIO bus
to interface with other devices. People using DSA would typically fall
under that category.

The fact that you need to access the MACB internal MDIO bus to interface
with your PHYs would be a hack that is easier to carry forward, and
maybe more justifiable.

I don't have a dog in the fight, but dealing myself with cute little
hacks in our downstream Linux kernel, the better it fits with useful
functionality to other people, the better.
-- 
Florian
