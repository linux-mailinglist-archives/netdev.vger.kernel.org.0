Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6049F454434
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 10:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbhKQJyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 04:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbhKQJyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 04:54:06 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10A6C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 01:51:07 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id i6so4554292uae.6
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 01:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6oHxCHdQqk1gh3FI9+RJPzkWEREzp+khMC/c8pj77v0=;
        b=YcoRJxjwrtTyqW2qbj7FcIlHAZHzUpSqJD3/jwPU17gBIgwXX8bClDU4AGEa6CsGcW
         SQPY9DvEJiMxr34YDITdg7chA6y4IfS+AOYqb5HtS1uOYLY+YlJKF15ocuXn1w6hwBdP
         ZubXsmXuLlLks+zSTc8HlZycwcUQQsDPqCt20e+vf/2uxEKVZu/CFMw8UuyiVyH6ZGuE
         0ouB7pwpJezqDbAR9M9NO8rm2C8R0AmOmRWNArG2q0Nk9ePetXThkZcDAdHCtycJ7v0C
         ggR242uBjrTkh9wKQPObQ37WFcMYKxYxXmf5N3rdrthB/ZwGA2gk0gqIVPgQsynKWtWo
         PUMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6oHxCHdQqk1gh3FI9+RJPzkWEREzp+khMC/c8pj77v0=;
        b=woXKlBhETokYna9Zy/i+Gi1jRf6Rr+pqKpW9xl4AdiPpIr+4FotikmzEOXzR/R2fMh
         0Li8wcUBJ0eYQXujwNtUgR6GgsEHs00ipmLGw459QnpI2FLGfJqOkCJTyLTuT4yJnMfD
         PMwncCjfC1d3wCZaEX3jTo/xHWm5g9+m51Qg0mOiUG4JHnj7n4grw+WtJSA9XZrCYvyf
         hVdX3uuiH3KKakEjDLtnTfe7kXBlXWRGjVpYpZGoUUDSwXFYykwpg5a22wW4F6PzsSr5
         GnsbBaPJ68Qf7/XFjdcNRJirHxbtOgJg8l+g8c+0a+wchjcMxJ9XfEOrV7Tc0mT1JQQm
         /BZg==
X-Gm-Message-State: AOAM530LbydsepwwxVr4FnLpZ8LtyocpFp7a0ucAqmwMDaJP2lBVfqP0
        GDrjjHd6BTRW6Z6MwW2QdCau8fhSQIeaIWd6/r8r3g==
X-Google-Smtp-Source: ABdhPJxSidgB1PW9yP9u9BdHEQuv2rP1drUYCBdYh8is5tDtH4wIN5ovaQZc3DJK07EXhI6g5X/uImaIFGytGxx1GLM=
X-Received: by 2002:ab0:6998:: with SMTP id t24mr21846787uaq.60.1637142666659;
 Wed, 17 Nov 2021 01:51:06 -0800 (PST)
MIME-Version: 1.0
References: <CAKD1Yr02W-WuLx8ouvP+wTtkxeyTBW_dp1deo9sim7wfLA2LXQ@mail.gmail.com>
 <20211117071732.7455-1-rocco.yue@mediatek.com> <CAKD1Yr3CMPWMmNNU6YvpBiaXVttS9T8qGVgmddijYfLSfK-Rog@mail.gmail.com>
In-Reply-To: <CAKD1Yr3CMPWMmNNU6YvpBiaXVttS9T8qGVgmddijYfLSfK-Rog@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 17 Nov 2021 01:50:54 -0800
Message-ID: <CANP3RGdrhrSYOnRRq1r6Uq6a4hK90f_KsUW2VOYQGW0GHMv-oQ@mail.gmail.com>
Subject: Re: [PATCH net-next] ipv6: don't generate link-local addr in random
 or privacy mode
To:     Lorenzo Colitti <lorenzo@google.com>
Cc:     Rocco Yue <rocco.yue@mediatek.com>, dsahern@gmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, yanjie.jiang@mediatek.com,
        kuohong.wang@mediatek.com, Zhuoliang.Zhang@mediatek.com,
        markzzzsmith@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Can't 4 be the same as 3? The same netlink message can configure both
> the addr_gen_mode and the token, no?
>
> It seems to me that the following should work, and would be much simpler.
>
> 1. Bring the interface down. All addresses are deleted.
> 2. Send a netlink request to set addr_gen_mode RANDOM_LL_TOKEN or
> PRIVACY_LL_TOKEN and set the token.
> 3. Bring the interface up. Autoconf runs. The link-local address is
> generated from the token. An RS is sent. When the RA is received, the
> global address is generated using RFC 7217 or randomly.

Could you simply manually add an ipv6 link local address to the
interface while it is down (ip -6 addr add fe80::..../64 dev X), then
bring the interface up (ip link set dev X up)...
All that would need to happen is the automatic link local generation
would need to be suppressed if there's already a link local ip
configured - which sounds like a good idea anyway, since why have two?
(btw. even a manually added link local ip will get deleted when the
interface gets brought back down)
