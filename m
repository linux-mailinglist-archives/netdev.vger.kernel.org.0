Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D24E4A883E
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242211AbiBCQDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244351AbiBCQDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:03:01 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2372C06173D
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:03:01 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id k17so2566578plk.0
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yY2bzUZwNMPnhcHR5z5MDI7i8ZyrF+lUHnqiNuxus8c=;
        b=rBrEb5yFwDlLbCMeQHwcMbA5BugUu4J0lSxvTjnezQM5GlT60pVaRMvYto2/kU6ylX
         0mfrW41j4MDoEJ3RygMmvcXlI+XXxDE7ZSHfQFBcr3V/8ld08Oetk2lHB4a+8dJzNHVb
         RD68p3HHU5qnrrgdTnP7bUwHGcYlPsp48c0Tzf9tot8yr8Bd81+7nNPRxRUeOx9TxS0l
         TGdMwOljRECCoyVe251txOzmx2z0CbRa5jrXuObXsZP9HPaqhyNLsZWtIn4TZUqjjvkd
         YCaAyAOLzGXWkkIo7kEdM+wd16a6IlvER8M9IH7KHq9xRso0n2Nxo54mdzQVMTYRhbTG
         Rcww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yY2bzUZwNMPnhcHR5z5MDI7i8ZyrF+lUHnqiNuxus8c=;
        b=e+8PZjr7c4P9iFK56SUSFowwdDg00AYNqBS3G+xOI1cyJ3J/1eV1iEsAKK0mKPYF3U
         BFZO6vI2RjQIuMXx6f1P5062yLrQHQ2ztgEcA0JtXtMG1f2vHJtlv0NqRhxaYrtqf/9t
         antcwlk/ZxD8R7Tt8Pp4x/edNPeNNVf+VXY1AT2XKtN6So56bx3fFRM1BI3yJSWoL4jX
         c3KN1R2GHeLa7EwWf5+BYQQ2L3Zl2SC6i5tkz8bpMbgABQKivyjugTSPW6Hp3c2fLla4
         CXf4J4DmF+LviMPA2B5S+h2I7eJxOru5EH+PupVIYHSHUykioy6m3FQiECrDhngHk4as
         dr0A==
X-Gm-Message-State: AOAM531oYdqxm+W2e2ZH1h3zlPoeNoWLuBnayM0p8erFb+R4+RHCGAyD
        w+n2J1uaYNhgWqxciXlrh31OkEVBnzY9tUUT9wY55w==
X-Google-Smtp-Source: ABdhPJzooFfrIJpspgvK+mD3sLc09TgikOJ/KOjspt7+1jKiKLjJ8/kyHE9SR60SqWoTD5QUDunJVoE58D/iwdpatVw=
X-Received: by 2002:a17:90b:380f:: with SMTP id mq15mr14643628pjb.66.1643904181104;
 Thu, 03 Feb 2022 08:03:01 -0800 (PST)
MIME-Version: 1.0
References: <20210421055047.22858-1-ms@dev.tdt.de> <CAJ+vNU1=4sDmGXEzPwp0SCq4_p0J-odw-GLM=Qyi7zQnVHwQRA@mail.gmail.com>
 <YfspazpWoKuHEwPU@lunn.ch> <c732e1ce-8c9c-b947-8d4b-78903920a5b2@gmail.com>
In-Reply-To: <c732e1ce-8c9c-b947-8d4b-78903920a5b2@gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Thu, 3 Feb 2022 08:02:49 -0800
Message-ID: <CAJ+vNU1Urkd4A8BdvP7H9W_H2DDOH2_khXesh49KzWoVqjk_iw@mail.gmail.com>
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led functions
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Martin Schiller <ms@dev.tdt.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 7:12 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 2/2/2022 5:01 PM, Andrew Lunn wrote:
> >> As a person responsible for boot firmware through kernel for a set of
> >> boards I continue to do the following to keep Linux from mucking with
> >> various PHY configurations:
> >> - remove PHY reset pins from Linux DT's to keep Linux from hard resetting PHY's
> >> - disabling PHY drivers
> >>
> >> What are your thoughts about this?
> >
> > Hi Tim
> >
> > I don't like the idea that the bootloader is controlling the hardware,
> > not linux.
>
> This is really trying to take advantage of the boot loader setting
> things up in a way that Linux can play dumb by using the Generic PHY
> driver and being done with it. This works... until it stops, which
> happens very very quickly in general. The perfect counter argument to
> using the Generic PHY driver is when your system implements a low power
> mode where the PHY loses its power/settings, comes up from suspend and
> the strap configuration is insufficient and the boot loader is not part
> of the resume path *prior* to Linux. In that case Linux needs to restore
> the settings, but it needs a PHY driver for that.

Florian,

That makes sense - I'm always trying to figure out what the advantage
of using some of these PHY drivers really is vs disabling them.

>
> If your concern Tim is with minimizing the amount of time the link gets
> dropped and re-established, then there is not really much that can be
> done that is compatible with Linux setting things up, short of
> minimizing the amount of register writes that do need the "commit phase"
> via BMCR.RESET.

No, my reasoning has nothing to do with link time - I have just run
into several cases where some new change in a PHY driver blatantly
either resets the PHY reverting to pin-strapping config which is wrong
(happend to me with DP83867 but replacing the 'reset' to a 'restart'
solved that) or imposes some settings without dt bindings to guide it
(this case with the LEDs) or imposes some settings based on 'new'
dt-bindings which I was simply not aware of (a lesser issue as dt
bindings can be added to resolve it).

>
> I do agree that blindly imposing LED settings that are different than
> those you want is not great, and should be remedied. Maybe you can
> comment this part out in your downstream tree for a while until the LED
> binding shows up (we have never been so close I am told).

or disable the driver in defconfig, or blacklist the module if I want
to do it via rootfs.

Can you point me to something I can look at for these new LED bindings
that are being worked on?

Best Regards,

Tim
