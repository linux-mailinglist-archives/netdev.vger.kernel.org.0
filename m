Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9402C2B28C8
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 23:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgKMWty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 17:49:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgKMWty (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 17:49:54 -0500
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D2C82225E
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 22:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605307793;
        bh=GeQLa7d3PQ1pLzQVCA8nzjILyd20h5XWXeJqYcHyJ54=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hy8SbT4izdP2YEfY7A85DMIIdKk6cc2DgkuopAqO/3YK7zfUCbrgoGs54vM/HoCZ0
         OZIbpFrJ6yZNAih6JeW7FK3yTvzEG6ouFce4DS1VV6wxfjIRJX+uRyqEmNdFK3C4lH
         LhECCs2otPz8xo2JccyzfFzMbrSm60pRiQ5o6e6w=
Received: by mail-ot1-f53.google.com with SMTP id z16so10410565otq.6
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 14:49:53 -0800 (PST)
X-Gm-Message-State: AOAM533ihgP4b1K8myEyCNP11HZK8dr7TreBGwpIKcq38ZNxcHNdVi93
        PAvPaoG+9F2/nm4yRBi6xHW4hQYYp2tcpIaXSLo=
X-Google-Smtp-Source: ABdhPJyZeTkLlncQDMNy6uNZFxaQGSFq7xPTLz8cHfWmkoGAss6UebWS0en3k9o97/h6bY25YeztJxCFOYVTW/C7FuY=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr3113787otk.108.1605307792601;
 Fri, 13 Nov 2020 14:49:52 -0800 (PST)
MIME-Version: 1.0
References: <20201017230226.GV456889@lunn.ch> <20201029143934.GO878328@lunn.ch>
 <20201029144644.GA70799@apalos.home> <2697795.ZkNf1YqPoC@kista>
 <CAK8P3a2hBpQAsRekNyauUF1MgdO8CON=77MNSd0E-U1TWNT-gA@mail.gmail.com>
 <20201113144401.GM1456319@lunn.ch> <CAK8P3a2iwwneb+FPuUQRm1JD8Pk54HCPnux4935Ok43WDPRaYQ@mail.gmail.com>
 <20201113165625.GN1456319@lunn.ch> <CAK8P3a3ABKRYg_wyjz_zUPd+gE1=f3PsVs5Ac-y1jpa0+Kt1fA@mail.gmail.com>
 <20201113224301.GU1480543@lunn.ch>
In-Reply-To: <20201113224301.GU1480543@lunn.ch>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 13 Nov 2020 23:49:39 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGnfsX1pH8m1eO-B1nAqL=vMeuw6fpYdeA1RqMpSrg66Q@mail.gmail.com>
Message-ID: <CAMj1kXGnfsX1pH8m1eO-B1nAqL=vMeuw6fpYdeA1RqMpSrg66Q@mail.gmail.com>
Subject: Re: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        =?UTF-8?Q?Jernej_=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve McIntyre <steve@einval.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 at 23:43, Andrew Lunn <andrew@lunn.ch> wrote:
>
> Hi Arnd
>
> > Something of that sort. I also see a similar patch in KSZ9031
> > now, see 7dd8f0ba88fc ("arm: dts: imx6qdl-udoo: fix rgmii phy-mode
> > for ksz9031 phy")
> >
> > As this exact mismatch between rgmii and rgmii-id mode is apparently
> > a more widespread problem, the best workaround I can think of
> > is that we redefine the phy-mode="rgmii" property to actually mean
> > "use rgmii mode and let the phy driver decide the delay configuration",
>
> The problem is, the PHY driver has no idea what the delay
> configuration should be. That is the whole point of the DT property.
>
> The MAC and the PHY have to work together to ensure one of them
> inserts the delay. In most cases, the MAC driver reads the property
> and passes it unmodified to the PHY. The PHY then does what it is
> told. In some cases, the MAC decides to add the delay, it changes the
> rgmii-id to rgmii before passing it onto the PHY. The PHY does as it
> is told, and it works. And a very small number of boards simply have
> longer clock lines than signal lines, so the PCB adds the delay. It is
> not clearly defined how that should be described in DT, but it works
> so far because most MAC drivers don't add delays, pass the 'rgmii'
> from DT to the PHY and it does as it is told and does not add delays.
>
> There is one more case, which is not used very often. The PHY is
> passed the NA values, which means, don't touch, something else has set
> it up. So when the straps are doing the correct thing, you could pass
> NA. However, some MAC drivers look at the phy mode, see it is one of
> the 4 rgmii modes, and configure their end to rgmii, instead of gmii,
> mii, sgmii, etc. How networking does ACPI is still very undefined, but
> i think we need to push for ACPI to pass NA, and the firmware does all
> the setup. That seems to be ACPI way.
>
> > with a new string to mean specifically rgmii mode with no delay.
>
> As you said, we have phy-mode="rgmii" 235 times. How many of those are
> going to break when you change the definition of rgmii?  I have no
> idea, but my gut feeling is more than the number of boards which are
> currently broken because of the problem with this PHY.
>
> And, as i said above, some MAC drivers look for one of the 4 RGMII
> modes in order to configure their side. If you add a new string, you
> need to review all the MAC drivers and make sure they check for all 5
> strings, not 4. Some of that is easy, modify
> phy_interface_mode_is_rgmii(), but not all MAC use it, and it is no
> help in a switch statement.
>
> And we are potentially going to get into the same problem
> again. History has shown, we cannot get 4 properties right. Do you
> think we will do any better getting 5 properties right? Especially
> when phy-mode="rgmii" does not mean rgmii, but do whatever you think
> might be correct?
>
> Having suffered the pain from the Atheros PHY, this is something i
> review much more closely, so hopefully we are getting better at
> this. But PHY drivers live for a long time, ksz9031 was added 7 years
> ago, well before we started looking closely at delays. I expect more
> similar problems will keep being found over the next decade.
>
> To some extent, we actually need DT writers to properly test their
> DT. If both rgmii and rgmii-id works, there is a 50% chance whatever
> they pick is wrong. And it would be nice if they told the networking
> people so we can fix the PHY.
>

One question that still has not been answered is how many actual
platforms were fixed by backporting Realtek's follow up fix to
-stable. My suspicion is none. That by itself should be enough
justification to revert the backport of that change.

I do agree that we should fix this properly going forward, and if we
do manage to fix this in a backwards compatible way, we should
backport that fix. But letting the current situation exist because
nobody can be bothered to fix it properly is not the right solution
IMHO.
