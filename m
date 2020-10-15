Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC8428F260
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 14:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgJOMi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 08:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbgJOMiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 08:38:21 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079E4C0613D2
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 05:38:20 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h20so2962019lji.9
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 05:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jh1aY+47O6ijaqC86FDIidJoI9nLsLE5P2PScZjVVYc=;
        b=AQoXVekiV2SgOwW5jhwFYEpMmlaKGCs+XQecaBElJ8effG1Nu+2U49Ccd4kdtEQy2U
         S+OOH0BxW6QdDeA0hasikyMkK6DX1iW80hExe7zPfnmQXgLXuz0Bp/f/BWcNRsyKPA4d
         XMHaMCkS/Fq25XyC6Ab+xmbBHB4ey94bFFBTGHiMaVVPCgg0OYoOZmo2h+6ndHbbfUt8
         xE49yeAHilYYHeVr0qnA+dFc4lAJ+vEyqCqajVMTrzJwNh8NA0YmSkb+4F+xyXuX0kRR
         /CUicfeusURGqlxEjfHLQunypvKflSsWeh+wqhIPD489Q8Nacr8h2UqxgsD1Tw2096iO
         cZxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jh1aY+47O6ijaqC86FDIidJoI9nLsLE5P2PScZjVVYc=;
        b=ZzrBlg4M4SPuabOW3TBVQP09ckk1P2ObCwa1nAlx+q+sAnmlVg2BbmG773sQSBuPKC
         CqiLJ4MVYRmCKjB/k4qCEnNcNNcDCGkYSKnYiMCIXNK0kDFOsuwAaPvRjPinBvCyaHJn
         x9yr8+82bNyyGSvJDBL7t95rzFcgkXsScn/wXcxeVXJhpwDis/dFu6vBD6xZMucJ/ryy
         0amVH8Xv3xNiF0B0uD83db4CUFWERsMERjSGcK1rs11Pjng+A6k/4CtMJ9j5fn2DW9iv
         LAAtrpbmMIWGz+se1OQEeTLKA9fllPQMiEw3nQkqX4/bc1Ch+JDhc5HJXaK/rFO/m0fb
         tV5A==
X-Gm-Message-State: AOAM532Sscxe/JsQ6wkbZnB91N5JmOdTig+q1a17gZ/ZULHKKaNbKkeO
        UostSlW67ZQFLYFE4wEF/5Olghy9mKRwUQPGTkPBVw==
X-Google-Smtp-Source: ABdhPJxvMITtZRdUF7vCkgov96m37F496Q+RbCqUO6UxDlRRW2t1pr04OQAupH8vwGhiQD5mxcK8M5s+Hj+cVW2k+0w=
X-Received: by 2002:a2e:9b0c:: with SMTP id u12mr1089670lji.338.1602765499407;
 Thu, 15 Oct 2020 05:38:19 -0700 (PDT)
MIME-Version: 1.0
References: <20201008154601.1901004-1-arnd@arndb.de> <20201008154601.1901004-4-arnd@arndb.de>
 <CACRpkdbc-Y6M+q8f7VEiee41ChUtP_5ygy_YN-wi873a+bN3yQ@mail.gmail.com> <20201015095307.GS1551@shell.armlinux.org.uk>
In-Reply-To: <20201015095307.GS1551@shell.armlinux.org.uk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 15 Oct 2020 14:38:07 +0200
Message-ID: <CACRpkdaOuMHfqrToVPRVW1zEYDY6H-gPm1QkR2CydtbLj-7csw@mail.gmail.com>
Subject: Re: [PATCH 3/3] timekeeping: remove arch_gettimeoffset
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 11:53 AM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:

> Don't be misled. It was not a matter of "enough gritty people", it
> was a matter that EBSA110 was blocking it.

I remember that EBSA110 was quite different in that it had this
especially limited PIT timer, true that. At one point I even read
up on the details of it and then forgot them :/

Yours,
Linus Walleij
