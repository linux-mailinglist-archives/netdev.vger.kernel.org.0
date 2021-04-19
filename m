Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66280364DE2
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhDSWza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhDSWz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 18:55:28 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E785C06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 15:54:58 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id r128so31534511lff.4
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 15:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Szi10f1gjvkxJCO6gaa+zlyiqVqLdtTWxp2/9wQh+OE=;
        b=IGo0P01QsH2xvHDHtqG+RFeEQM3Lfnl78FhXukWQp7Qnqy0E3aBcmGBu72cQQnpxD5
         ikzwCEAMcaV6/2Qs8HtMP3qNnHAqOj+WstJvpxeERiLvgYpYjA9jRpp2k+zWpOP8u00Q
         alXdgq6gJtnIDpmYZ+2LghAGpJbfS/YUobvp8O+EmmKxBod3DV8c4t70IYZo/yM/5UmO
         jmxPzpl7YKoVok2okWG6wBZ+KjUNyOSpmshPjjkDOC2WqZDSJb1Z5AlnSBSyENfVhrmh
         biK6hat0p+py39syT8pRdRdPTs+3bHnZqF8K+43ihudwFxd5olpx1QbP0gNrjrwE0rLU
         FI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Szi10f1gjvkxJCO6gaa+zlyiqVqLdtTWxp2/9wQh+OE=;
        b=nExfjfLsum96ewA4mLKQIfl1BAvamJkto4VUSDmvuhNsNX1QRdJU1P6YmZOdyGqkr7
         9ApbrlejdBfwxto4MsiYv4mGp1p2brD4er+m7CMn+G8h7wUZQ6kvydUULu6N9ZT7T53j
         d3FC9hqNAGLHfeeWd2Q2LSVaCAvXDWyoKwGQ92rFONHinG2NeHBGE0LpxdaikCDlyy15
         hxPhymrAPJ8ln2XrP9YpvEosSNdaq19iBgsWlInHhuQOHEfT0Yf7Vdj7flvFriQtDlBh
         kSYC/ezQthr47+POuzihc92O6Q/9EJlHgn7z15VVgmppX4WkyLSZxzWJvMy3H/SH6OF7
         4LJw==
X-Gm-Message-State: AOAM533wwxS36+tl93euJu55hUYTc5Uq07Xz3nCIYoTaPTnI6BDuCxwE
        vXgRMRWzFIYFCCD1lnXItFzKIeSKl5v4z9sl3JPwZOgQgW4=
X-Google-Smtp-Source: ABdhPJyXTOBbGGVMP9MS3w4VY3AS4Y2rcR53y0L9L3l5Onv7WEw6dJVecCC8j0K4wegnxucvrK3WEC2P+WmHh6LvuBQ=
X-Received: by 2002:a19:c38c:: with SMTP id t134mr14161114lff.29.1618872896802;
 Mon, 19 Apr 2021 15:54:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210419225133.2005360-1-linus.walleij@linaro.org> <20210419225133.2005360-3-linus.walleij@linaro.org>
In-Reply-To: <20210419225133.2005360-3-linus.walleij@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 20 Apr 2021 00:54:45 +0200
Message-ID: <CACRpkdaJtmaxK6nHwBw=TX-8_JgBX5V6JCCh4tyq44LcC=JH2Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: ethernet: ixp4xx: Use OF MDIO bus registration
To:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zoltan HERPAI <wigyori@uid0.hu>, Raylynn Knight <rayknight@me.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 12:51 AM Linus Walleij <linus.walleij@linaro.org> wrote:

> This augments the IXP4xx to use the OF MDIO bus code when
> registering the MDIO bus and when looking up the PHY
> for the ethernet network device.
>
> Cc: Zoltan HERPAI <wigyori@uid0.hu>
> Cc: Raylynn Knight <rayknight@me.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - New patch making use of more OF infrastructure.

Realized after sending that the MDIO people wanna look at this
too so adding them to CC, tell me if you want me to resend the
patch.

Yours,
Linus Walleij
