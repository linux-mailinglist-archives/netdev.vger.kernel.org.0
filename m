Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFB033793D
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhCKQYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234527AbhCKQXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:23:46 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75585C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:23:46 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id f12so2603588wrx.8
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WrfFQBGgdmJE/DclFPK4tpByXnS0MnLO0deLcd6Z8Us=;
        b=kflMWmQNHv4BU7WQoLgfWjxuGhA9zsm/D3AwkNZHi/phjgBLHA586IqatqWW0Jk8n3
         J8zhTXZZr1J1O304S2i/91O6t4h2p0BujzUxI83MURrvMZJzkQLKXwmc4XDeDy5ufRR4
         FnPFdIHF8WP4DgMhbu9VIe+ciSY3QWjCqEN8bsJ3dUTdmFe1IR1XpLE5ngUoZfmhPGvL
         qBzmeP5PSjliXAea7ZMru5gk4kS/mX+KnVKuVdQ0JyyYLm9ZuXhxwNlIOv2KjFWyNjDp
         eAZ5fmapXeMwY8YEJCl9M+u8qrhoZezO0rDxcxJ1j6xykGlhvZQ3B4cb6rIfyRKDIqiV
         6StQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WrfFQBGgdmJE/DclFPK4tpByXnS0MnLO0deLcd6Z8Us=;
        b=kw2Amo+16wWUtmZ1yOW5jyRlRY4E7jUxNauc4hffDTJp3p5SMnDTpXg1jCYyilk5gm
         R2zYNg8wG+TLTDAdo5YKguL8FpCRFtmiohGm2cUp4vd6i1cLdq/hrP5g1QEkGPMl4iaa
         WKTclnaQQ6pA+aVEIeiqQwkqbZP3cZdzF3jE3xrkJh+O/jd2d8zeWjAd1d/PiDQA0eiN
         TduJuwTTC4/bFKmXYbiQlUAITWeiUXbKcz3x9gk2qeEFixD5s+vL4I1Dkw/O7u4CIfl/
         hO+iRvto3tgta6cxlpgRoeuartw890zJokBZbG22AHYgJok/CAbkfcmgFnuRTkub8LJ6
         v/Kw==
X-Gm-Message-State: AOAM532Z19PAmsaLCNjAihz1tWzEl6lanUvOI0Um2XBZxEKY9B7AYQK8
        xnNpp6XXHxdz1zjLFzO4r4g=
X-Google-Smtp-Source: ABdhPJwpOK6KMChFZ6EDdMvGwbtRegq6/74gIBz2nEDXc4kBrnHxwlOfjPQ5Ag4P7qG49/cq2vVvvg==
X-Received: by 2002:a5d:6d0c:: with SMTP id e12mr9308448wrq.136.1615479825179;
        Thu, 11 Mar 2021 08:23:45 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:bb00:ec37:81be:26e8:d422? (p200300ea8f1fbb00ec3781be26e8d422.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:ec37:81be:26e8:d422])
        by smtp.googlemail.com with ESMTPSA id q19sm4721474wrg.80.2021.03.11.08.23.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 08:23:44 -0800 (PST)
To:     ljakku77@gmail.com
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <20200413105838.GK334007@unreal>
 <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
 <20200413113430.GM334007@unreal>
 <03d9f8d9-620c-1f8b-9c58-60b824fa626c@gmail.com>
 <d3adc7f2-06bb-45bc-ab02-3d443999cefd@gmail.com>
 <f143b58d-4caa-7c9b-b98b-806ba8d2be99@gmail.com>
 <0415fc0d-1514-0d79-c1d8-52984973cca5@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: NET: r8168/r8169 identifying fix
Message-ID: <3e3b4402-3b6f-7d26-10f3-8e2b18eb65c4@gmail.com>
Date:   Thu, 11 Mar 2021 17:23:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <0415fc0d-1514-0d79-c1d8-52984973cca5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.03.2021 17:00, gmail wrote:
> 15. huhtik. 2020, 19.18, Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> kirjoitti:
> 
>    On 15.04.2020 16:39, Lauri Jakku wrote:
> 
>        Hi, There seems to he Something odd problem, maybe timing
>        related. Stripped version not workingas expected. I get back to
>        you, when  i have it working.
> 
>    There's no point in working on your patch. W/o proper justification it
>    isn't acceptable anyway. And so far we still don't know which problem
>    you actually have.
>    FIRST please provide the requested logs and explain the actual problem
>    (incl. the commit that caused the regression).
> 
> 
>     
>        13. huhtik. 2020, 14.46, Lauri Jakku <ljakku77@gmail.com
>        <mailto:ljakku77@gmail.com>> kirjoitti: Hi, Fair enough, i'll
>        strip them. -lja On 2020-04-13 14:34, Leon Romanovsky wrote: On
>        Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote: Hi,
>        Comments inline. On 2020-04-13 13:58, Leon Romanovsky wrote: On
>        Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote: From
>        2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00
>        2001 From: Lauri Jakku <lja@iki.fi> Date: Mon, 13 Apr 2020
>        13:18:35 +0300 Subject: [PATCH] NET: r8168/r8169 identifying fix
>        The driver installation determination made properly by checking
>        PHY vs DRIVER id's. ---
>        drivers/net/ethernet/realtek/r8169_main.c | 70
>        ++++++++++++++++++++--- drivers/net/phy/mdio_bus.c | 11 +++- 2
>        files changed, 72 insertions(+), 9 deletions(-) I would say that
>        most of the code is debug prints. I tought that they are helpful
>        to keep, they are using the debug calls, so they are not visible
>        if user does not like those. You are missing the point of who
>        are your users. Users want to have working device and the code.
>        They don't need or like to debug their kernel. Thanks
> 
>    Hi, now i got time to tackle with this again :) .. I know the proposed fix is quite hack, BUT it does give a clue what is wrong.
> 
>    Something in subsystem is not working at the first time, but it needs to be reloaded to work ok (second time). So what I will do
>    is that I try out re-do the module load within the module, if there is known HW id available but driver is not available, that
>    would be much nicer and user friendly way.
> 
> 
>    When the module setup it self nicely on first load, then can be the hunt for late-init of subsystem be checked out. Is the HW
>    not brought up correct way during first time, or does the HW need time to brough up, or what is the cause.
> 
>    The justification is the same as all HW driver bugs, the improvement is always better to take in. Or do this patch have some-
>    thing what other patches do not?
> 
>    Is there legit reason why NOT to improve something, that is clearly issue for others also than just me ? I will take on the
>    task to fiddle with the module to get it more-less hacky and fully working version. Without the need for user to do something
>    for the module to work.
> 
>        --Lauri J.
> 
> 

I have no clue what you're trying to say. The last patch wasn't acceptable at all.
If you want to submit a patch:

- Follow kernel code style
- Explain what the exact problem is, what the root cause is, and how your patch fixes it
- Explain why you're sure that it doesn't break processing on other chip versions
  and systems.

