Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A3249606F
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 15:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348573AbiAUOG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 09:06:28 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:44146
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380942AbiAUOE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 09:04:27 -0500
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E80F13F1E9
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 14:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642773866;
        bh=3OQ/VaDIuTDhMC1t1W5jGAk9lH9/vCwpiE19iLKBlBc=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=WARDW7A7+HBB3vqTGPzn+yWYeMVhZdWDnuyiSO2kyYbnaNJ75sJiGPnNkNFExpxnX
         ze2wNqt54RqHZAhp3RG949WNqkLdXNaZLZoPi+i98Zc5ju6kHR1pl+R+gTEp+qBXV5
         7b3ZofncZ90h38Pjmsl+V1pKCq8/Vs0AnXMWgBOClCEj8Hva9KUpvsvTSj2gUSy1GJ
         2Dto992LV6XX5RhPVcmd4+hmtz4AIhJbzq3+Uaa0hkgEQiceYSNBVKhxjN5aNjoXj7
         Vqfw8RKIqpWPp7t90t8GL2KUw1LHofe8BJ0Qn+yUywjzkCH/7sNrldLi8BTBWUvKEe
         ezRYLRHFl18YA==
Received: by mail-ot1-f70.google.com with SMTP id a89-20020a9d2662000000b005909e4d9585so5517501otb.18
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 06:04:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3OQ/VaDIuTDhMC1t1W5jGAk9lH9/vCwpiE19iLKBlBc=;
        b=NoDaezhYa8A4yDlriPQa4pUr9NXBrsZlzOlDOyH4dfDceFaGBTcm+LYvVn/Rh2f1uF
         +/lJ39VIhiH0NNUqHEyTlB93F2nlFA4s6dT4Kmdh6+cH5EsuZhKj9eQXHLShXERIdoKt
         Y7I7KfqHhvBbgTpmHvpzAaJCKeQcuKqVkvfjg3ULWV7/vBF832M+E8WATJz9KwSgmeYe
         usIEjJgWkAwZYVQirVnA3AblwHMt548r0j6zdpquUb1JtACftrvS+qa/WowQ0FTpP+f3
         diQz1L5uKu6vxxvlDEyiNXgXFBOnfAh81hRBsp/ETtHNm75vDn6TKFnqEO0J1Nn/uI3j
         zujw==
X-Gm-Message-State: AOAM5305m+5AgTmiy1bIECtTiFd3NWtsTU/cq3L9R2L5rjO2gNsm+7Wq
        Ft8yhpqgzdCR1H1kilD23k54r33zi4gH2Pfc0stzXrNkzDqxL9/ov2bPF5DyOq46RF+cXg8Caic
        jT78pm05WZR1aYlg9u7GSTPP9GvNOHepQv5WZpd4Gus7f0MkV3g==
X-Received: by 2002:a9d:6f0e:: with SMTP id n14mr2822757otq.269.1642773861050;
        Fri, 21 Jan 2022 06:04:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVtaGcho3igX1lqUTemDHDs4BAm+GxXC1OfPO/KgxOSm0eeAE8Nd5NPl6H219ecy1ttNMMRO60EzgHiH7q1Tk=
X-Received: by 2002:a9d:6f0e:: with SMTP id n14mr2822645otq.269.1642773859362;
 Fri, 21 Jan 2022 06:04:19 -0800 (PST)
MIME-Version: 1.0
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
 <Yelnzrrd0a4Bl5AL@lunn.ch> <CAAd53p45BbLy0T8AG5QTKhP00zMBsMHfm7i-bTmZmQWM5DpLnQ@mail.gmail.com>
 <Yeqve+KhJKbZJNCL@lunn.ch>
In-Reply-To: <Yeqve+KhJKbZJNCL@lunn.ch>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 21 Jan 2022 22:04:08 +0800
Message-ID: <CAAd53p7of_W26DfZwemZjBYNrkqtoY=NwHDG=6g9vvZfDn3Wwg@mail.gmail.com>
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 9:05 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > Since you talked about suspend/resume, does this machine support WoL?
> > > Is the BIOS configuring LED2 to be used as an interrupt when WoL is
> > > enabled in the BIOS? Do you need to save/restore that configuration
> > > over suspend/review? And prevent the driver from changing the
> > > configuration?
> >
> > This NIC on the machine doesn't support WoL.
>
> I'm surprised about that. Are you really sure?

Yes I am sure.

>
> What are you doing for resume? pressing the power button?

Power button, RTC. The system has another igb NIC, which supports WoL.

>
> > > > +static const struct dmi_system_id platform_flags[] = {
> > > > +     {
> > > > +             .matches = {
> > > > +                     DMI_MATCH(DMI_SYS_VENDOR, "Dell EMC"),
> > > > +                     DMI_MATCH(DMI_PRODUCT_NAME, "Edge Gateway 3200"),
> > > > +             },
> > > > +             .driver_data = (void *)PHY_USE_FIRMWARE_LED,
> > > > +     },
> > >
> > > This needs a big fat warning, that it will affect all LEDs for PHYs
> > > which linux is driving, on that machine. So PHYs on USB dongles, PHYs
> > > in SFPs, PHYs on plugin PCIe card etc.
> > >
> > > Have you talked with Dells Product Manager and do they understand the
> > > implications of this?
> >
> > Right, that's why the original approach is passing the flag from the MAC driver.
> > That approach can be more specific and doesn't touch unrelated PHYs.
>
> More specific, but still will go wrong at some point, A PCEe card
> using that MAC etc. And this is general infrastructure you are adding
> here, it can be used by any machine, any combination of MAC and PHY
> etc. So you need to clearly document its limits so others are not
> surprised.

The dwmac-intel device is an integrated end point connects directly to
the host bridge, so it won't be in a form of PCIe addin card.

Kai-Heng

>
>         Andrew
