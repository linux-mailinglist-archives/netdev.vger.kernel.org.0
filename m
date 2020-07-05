Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F046215045
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 01:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgGEXE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 19:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgGEXE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 19:04:26 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDFCC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 16:04:26 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z24so18332355ljn.8
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 16:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fbGN5BgcN44HfBaFnTW86elVegBiMJ39hXtUwCEMgLk=;
        b=mbicwZcCQSP+F3G8Q3PIVTukd6Z4qDzimTXCWNHvDplAzX/zV2S7Xq1HpDiqAKrhM2
         zemftdqCD0zIguxvSvr1at5wX7chJP1ZImnjvuQEKI3jM9BAmHUkqSIX+s/A4gb9kFxc
         xgdne1RCtVUy8sXf8r+GithTKZB4EkuJR5dswjU3u8gn0c5ZHGlWBgZxOOK92s7UCbEk
         GFpH0xMlHJ4tJa9/zrnRB0uNW2MzzxOCnob+y8NsGXGSHO8RogjeZv7Cq4XJNi2uLuqb
         EaHB/rLU3UdXku1sSHoqyeqfDvqTg4Ymj0m4EApDlawngalgOcjxbSFgMsW1xKRXVO7i
         86TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fbGN5BgcN44HfBaFnTW86elVegBiMJ39hXtUwCEMgLk=;
        b=szyNXJqbuVnKlojlRhWi/Y5KxBU/IA7P5JZd3RbZG+X0ub6HttTAUF8pFUPDGuHtbM
         6vbbN30g/hss7KicBMeEK1oqNshOnHPRzt9+T58R/42q5H0+WLl1Q3ML4acEOE7dsDxY
         OStjpDJrRNcep75Zjh+PBGGysu945TB1s2r1Vso8tKuvFB6rfzvbyfWoIFqg0x5QEqEv
         gW38vbfiGLxqL9CvhDOwfAQ9Bvb14JxYnBqdG00ag8A3TgAY1zqzU9rJoGT0ir7v4Zk+
         Sy8U3wSqOqUeWAaDveV7RenUBG7oETS1F0bJUX6QYdynBmzI9chzd5d0w/7yTofmiWjR
         eETA==
X-Gm-Message-State: AOAM533dE1VzC8JMfa16IOyHoM+5C7uNM4WJL+AthA4VxbEjHT4hq8iM
        qkCOYqPMBx0gERCHnRYTIeGNVA7l0620x8gIGkC2OA==
X-Google-Smtp-Source: ABdhPJzIYAwWmETeLNajWmFwflvwSfEYVmM4Nab6svsVaP60XiDQP4thV5gBEzSHU8RemVC7QqNYvJ6pNtbJ5eJw+00=
X-Received: by 2002:a2e:8597:: with SMTP id b23mr9773626lji.338.1593990263355;
 Sun, 05 Jul 2020 16:04:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200617083132.1847234-1-linus.walleij@linaro.org>
 <20200617083132.1847234-4-linus.walleij@linaro.org> <a575b511-fb9c-48c3-211b-0da5001b9e0c@gmail.com>
In-Reply-To: <a575b511-fb9c-48c3-211b-0da5001b9e0c@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 6 Jul 2020 01:04:12 +0200
Message-ID: <CACRpkdb-OLq7d5RViDTyHEA1e0+Jtx26BMnv+ZmE6TL_kBjgzg@mail.gmail.com>
Subject: Re: [net-next PATCH 4/5 v2] net: dsa: rtl8366: VLAN 0 as disable tagging
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 5:24 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 6/17/2020 1:31 AM, Linus Walleij wrote:

> > Make sure that setting VLAN 0 has the same effect
> > and does not try to actually tell the hardware to use
> > VLAN 0 on the port because that will not work.
>
> Why, you are not really describing what happens if VID = 0 is programmed?

OK I'll add some words about it to the commit message.
The packets doesn't go through the switch is the short
answer, I cannot give any better answer I think because,
well, realtek-type documentation (none).

> It also sounds like you should be setting
> configure_vlan_while_not_filtering if you need the switch to be
> configured with VLAN awareness no matter whether there is a bridge
> configured or not.

Oh another thing I didn't know existed, I'll try this,
but it needs to be a separate patch I think, possibly
removing some code for default VLANs.

Thanks!
Linus Walleij
