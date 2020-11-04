Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65912A6FE5
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 22:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731256AbgKDVwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 16:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727098AbgKDVwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 16:52:40 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6325C0613D3;
        Wed,  4 Nov 2020 13:52:40 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id u7so12323751vsq.11;
        Wed, 04 Nov 2020 13:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Omb49H4MO6BunFJn4vIvDeBWor2sMHkkOLj5HAipglA=;
        b=HvlVLi9LGAmXZ7aiEHBTtsfEMiwgGdw8OM9xHzyZhDzZQuoohsGb5P+3qwYeQywe7z
         tx9S9Jjqd0bjA8YrwmpZnSOf/Rc+OBaV4DwFAt7SPbYlbd/yvUM3mN9PhwwWjE89VLc8
         S03yhSmAaIaFSHUg1X1IeBfrSmPO1gQIPXxSthPRAEymaHwMOohsp3TLaNo1g/NKSyMr
         U/j/blE8NNDKJo5jj7FbO8BnbD8wc7QApYk3s9QYxvXAd7/E+HSAwoNvFECzS3ne7Dej
         OtYa1aD6cSFT4L3rH1rLpzXctB7405orLx372LWvB7856Nit6P3z9s4yR5f5h2OJNoNP
         144w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Omb49H4MO6BunFJn4vIvDeBWor2sMHkkOLj5HAipglA=;
        b=dlQcVaYV8OrXlJo7NtoSPC+SnEbOyoP6Tm/p7X6UKue3+kXbWRtdC/6Hp5Y1izWk9C
         UrjeufjJGm9rqP2eTfF5tbtpsWFmMjGycP+ljKgH0oO2vKk68BaGpv5sqxDm7q0ZZGWt
         dpEdQbAVO+kKMXU9JIrKTbWtsdeZo8yQ7He29ZqM1JXwPvXfQNPfquM82wF3yyTH6ja+
         buw39thQLomO2jQOWrfgbiJkUkhNg0cwJr+t4df1KeFuK8SU61UkTz5fXAc19u5ln18w
         qBytQXZotW3Pmt56pEjRej/Y5uuHgiQy2znMRctHqFTANVbOFA1CDzpyDW59z7EjkTBH
         smIw==
X-Gm-Message-State: AOAM530zZNIT1Dtal4eOhS3kRmS/tjYN4DmH89Znj08t2ahI54iIIj85
        djVcET/Ig2oCdxSLIewSm8kYIUEZwDFu2NkAlOA=
X-Google-Smtp-Source: ABdhPJxFa2fnF3xcv0VOkdiuUCU7CGPlM4XKihMMqZN7EIH616JJUSgru7lE+yJVPHuA01g9il2TsKwjzmDwml27E90=
X-Received: by 2002:a67:2ac1:: with SMTP id q184mr127757vsq.57.1604526759766;
 Wed, 04 Nov 2020 13:52:39 -0800 (PST)
MIME-Version: 1.0
References: <20201104160847.30049-1-TheSven73@gmail.com> <20201104162734.GA1249360@lunn.ch>
 <CAGngYiUtMN0nOV+wZC-4ycwOAvU=BqhdP7Z3PUPh2GX8Fvo3jg@mail.gmail.com> <20201104165509.GB1249360@lunn.ch>
In-Reply-To: <20201104165509.GB1249360@lunn.ch>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Wed, 4 Nov 2020 16:52:28 -0500
Message-ID: <CAGngYiWfHhyPLKi9Znf_aXNvU_HEEdKBAxbc8wfCGTdrbEhvHw@mail.gmail.com>
Subject: Re: [PATCH v1] lan743x: correctly handle chips with internal PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Roelof Berg <rberg@berg-solutions.de>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew,

On Wed, Nov 4, 2020 at 11:55 AM Andrew Lunn <andrew@lunn.ch> wrote:
> If you look at that patch, you see:
>
> -       ret = phy_connect_direct(netdev, phydev,
> -                                lan743x_phy_link_status_change,
> -                                PHY_INTERFACE_MODE_GMII);
> -       if (ret)
> -               goto return_error;
>
>
> That was added as part of the first commit for the lan743x
> driver. Changing that now seems dangerous.

I think there's a misunderstanding on my part, and it flows from the
following bit of the commit message in 6f197fb63850
("lan743x: Added fixed link and RGMII support"):

>   . The device tree entry phy-connection-type is supported now with
>     the modes RGMII or (G)MII (default).

I interpreted that to mean "if phy-connection-type is omitted, it will default
to G(MII)". However I now notice that the code in that patch does no such
thing: if that prop is omitted, the mode is actually silently set to
PHY_INTERFACE_MODE_NA, which is probably not great.

In summary, 6f197fb63850 behaves as follows:
1. if a devnode is present, attempts to configure the phy from devicetree,
   but silently breaks if phy-connection-type is omitted
2. if no devicetree node present, tries to connect to an internal phy using
  (G)MII (which silently breaks if an internal phy chip has a devicenode)

This proposed patch replaces this with:
1. attempts to configure the phy from devicetree, fails if no correct devicetree
   description present (phy-connection-type is required)
2. if (1) fails, tries to connect to an internal phy using (G)MII

As far as I can see, this doesn't appear to introduce any breaking changes?
It's of course quite possible that I've overlooked something, I am definitely
not a netdev/phy expert.

Sven
