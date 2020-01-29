Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939D214C9F8
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 12:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgA2L5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 06:57:43 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36702 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgA2L5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 06:57:43 -0500
Received: by mail-ed1-f65.google.com with SMTP id j17so18353683edp.3
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 03:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YButG86THPml9p7mxfeYqxqh3TsBrQZ3DQlZnnfX388=;
        b=eykYTk1CK9VMeNWRiJE+K5ItY9XnrjCk1r+HmiLyU0f+GsH4g42WYr+iZzwoRIMZ+0
         x1HW1XEBIKZgL6yCqIm2WyxH9uCdG6JSoeJ/mkCQ3xL7f+3CIVKe6os/d++A4QT1JzLJ
         jl/q1Q4PHW+s27kNsSzKr03aDq9x8WRlsH0651iC+otr+Q/2RVuUZO/eslyjH1BAW5ON
         vy+X5+GfrMxBNKTAZrJ6dVcWVeK8o52uBlAN6YC6ZdbVS4s5UVowqUCi/zCcP4tYzlzN
         9hVMvltcWRfltnYyFtQajwkPU0WSFD7lMVPWo5+yuRmsrw/DveTlD6LmsICPB4MT/2mc
         jssA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YButG86THPml9p7mxfeYqxqh3TsBrQZ3DQlZnnfX388=;
        b=lipy5GXUBmls1gmMTFPPRSm+Uwp0Ko3ZiiOncm9MaKlLN2VsRv8di9g0an00sT7F5q
         ZAz4t/m0offWNv39QciOhx9mD+oibKelX+x+MF9L2cx6MEknBMBFlAEPyZuc56p/Wvjk
         gbYt3kGR4E8CU0Xw0GAqReeG8JjWgybcjIASU5iJKXzEOJAB7uiF6H27jKoCDPQWZIB/
         bITBnWEgvy4hMer3u5OnmnqbJMVBsIuSaLtCUU3FhFRpMdQ/U0/cz6LZMZQNNpOxklk5
         C+BMhPLD9KT9YzxE+TV3uwigyBx49Bzk7pAx/XcgPMDMZVfnCVNuPr01F4dUPdvkbYbN
         egmw==
X-Gm-Message-State: APjAAAVTu7i++kjNFF/IGYSFuiidpyMxnbeUiX8MQ3cy+1wQt31geGTr
        Ilm46nRI+HMMSVc4l6SLJ1H3CTqsSeeJLWTwT4U=
X-Google-Smtp-Source: APXvYqxHGaCBsnbw9lWyM5+LFI+uuuDmmve2W2v2DXFHiJFAAY33PearjtbtxTSfVnODTFPrtJfo6M7AElNmmNDpM7A=
X-Received: by 2002:aa7:d3cb:: with SMTP id o11mr7531296edr.145.1580299061461;
 Wed, 29 Jan 2020 03:57:41 -0800 (PST)
MIME-Version: 1.0
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
 <68921c8a-06b6-d5c0-e857-14e7bc2c0a94@gmail.com> <DB8PR04MB6985606F38572D8512E8D27EEC0F0@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <77e3ddcb-bddb-32d8-9c87-48ba9a7f2773@gmail.com> <CA+h21hq7U_EtetuLZN5rjXcq+cRUoD0y_76LxuHpoC53J70CEQ@mail.gmail.com>
 <DB8PR04MB6985139D4ABED85B701445A9EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <CA+h21hpSpgQsQ0kRmSaC2qfmFj=0KadDjwEK2Bvkz72g+iGxBQ@mail.gmail.com> <DB8PR04MB6985B0A712634DCFCD5390A4EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB6985B0A712634DCFCD5390A4EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 29 Jan 2020 13:57:30 +0200
Message-ID: <CA+h21hqz0VwPyhuKaSuS8So56KSsp260UFrigQ4=_7-VZKKtvw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation indication
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Madalin,

On Wed, 29 Jan 2020 at 12:53, Madalin Bucur (OSS)
<madalin.bucur@oss.nxp.com> wrote:
>
> > As far as I understand, for Aquantia devices this is a 3-way switch for:
> > - No rate adaptation
> > - USX rate adaptation
> > - Pause rate adaptation.
> > So what does your "phydev->rate_adaptation = 1" assignment mean?
>
> phydev->rate_adaptation = 1 means the PHY is able to perform rate adaptation
>
> There is not such thing as USX, if you refer to USXGMII, that's something you
> can check for in the interface mode.
>

I did nothing more than just read aloud the AQR412 description for
register 1E.31F.

> > From context and datasheet I deduced that you mean "the PHY is
> > configured to send PAUSE frames for 10GBase-R and 2500Base-X modes",
> > which are probably the modes in which you're using it.
> >
> > But how do you _know_ that the PHY has this switch set correctly? It
> > is either set by firmware or by MDIO, but I don't see any of that
> > being checked for.
>
> I know it is set because someone does put some work in designing a system,
> in provisioning a correct firmware image.
>

So you don't consider "firmware without this flag set, but software
(bootloader, kernel) enables it" to be a valid way of designing a
system? And your position is "well, I don't care if the person
integrating the system didn't take care of all the hardware/firmware
prerequisites, because software isn't going to attempt to do anything
helpful here even if it can"?

So the generic Linux kernel will just ask the person who put the work
in designing some system, right?

What is it that you are trying to prove?

If anything, this reminds me of the xkcd:
int getRandomNumber()
{
    return 4; // chosen by fair dice roll. guaranteed to be random.
}

> >
> > So you think that having a PHY firmware with rate adaptation disabled
> > is "stupid user"?
> > What if the rate adaptation feature is not enabled in firmware, but is
> > being enabled by U-Boot, but the user had the generic PHY driver
> > instead of the Aquantia one, or used a different or old bootloader?
> > "Stupid user"?
>
> Disabling rate adaptation is one of so many ways one could cripple a
> system interface, there are many that require polarity inversion, lane
> switching, etc. and still there is no support for that in the kernel.
>
> > The PHY and the Ethernet driver are strongly decoupled, so they need
> > to agree on an operating mode that will work for both of them.
> > Ideally the PHY would really know how it's configured, not just
> > hardcode "yeah, I can do rate adaptation, try me".
> > The fact that you can build sanity checks on top (like in this case
> > not allowing the user to disable pause frames in the Ethernet driver
> > on RX), that don't stand in the way, is just proof that the system is
> > well designed. If you can't build sanity checks, or if they stand in
> > the way, it isn't.
>
> If you don't need them, it's even better.
>

I am not really sure where you're heading with this one.

> > If anything, why haven't you considered the opposite logic here:
> > - Ethernet driver (dpaa_eth) supports all speeds 10G and below.
> > - PHY driver (or PHY core) removes the supported and advertised speeds
> > for anything other than 2.5G and 10G if it can't do this rate
> > adaptation thing, and its system side isn't USXGMII. It's not like
> > this is dpaa_eth specific in any way.
>
> "what about...", indeed. There are many situations one could imagine
> when things would not work, we can do some brain storming on improving
> this list. Meanwhile, a real issue is that in the current design, the
> ethernet driver needs to remove modes that are invalid from the PHY
> advertising, but needs to refrain from doing that when coupled with
> a PHY that does rate adaptation. This bit provides just an indication
> of that ability.

An incomplete one, at that.
Here's a list of things/potential design improvements that were
suggested to you but you only gave evasive answers on unrelated
topics:
- PHY says "I can do rate adaptation" [ via pause frames ]. Ethernet
driver knows it supports RX flow control. Good for them. But there's a
difference between "can" and "will", and somebody should bridge that
gap. The PHY should either (a) really check if rate adaptation is
enabled, before saying it is (b) say it is, for the interface modes
where that makes sense, but then actually enable it when necessary.
- The system that will be devised would work as an extensible way for
PHY to report capabilities depending on interface mode. Another
capability has been expressed (in-band autoneg) that is similar to
what you are trying to introduce, in that it requires PHY-MAC
coordination and that it is dependent on the system interface that is
being used.
- Why would the Ethernet driver be concerned about what media-side
link speed gets negotiated and used, as long as there's a PHY that can
deal with that. The approach you're taking doesn't really scale. It
scales better to have this sort of logic in the PHY driver only (if
possible), or in the PHY library (either one) too if necessary. _Yes_,
this is a larger problem and is present outside of dpaa_eth too, at
the moment.

> "what about...", indeed.

I didn't say anything about "anti-stupid devices", you did. I prefer
fail-fast systems because I don't enjoy debugging issues that can be
caught automatically. If you enjoy spending you and your users' time
like that, good for you.

>
> > > Madalin
> > >
> > >
> > > > > --
> > > > > Florian
> > > >
> > > > Regards,
> > > > -Vladimir
> >
> > -Vladimir

-Vladimir
