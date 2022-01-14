Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CD848ED15
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 16:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241925AbiANPXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 10:23:08 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:40214
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233576AbiANPXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 10:23:08 -0500
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B03AA3F1DD
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642173786;
        bh=Ia9jCR2j/rA1cIOYRQT6jRXDjntVCpr3+k1Bg19zGmo=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=NGGEQPQ6DXcJv+0lF0fm9b6XPu/oIqpT5+UDOSbramjwxe3NOW7JkGSGbI//COBye
         IHCMEB43PMIS7vkxOVLiF2a1MyHzJ5qMf33VzIHsXNGLMHrXJVETj8Kp6G7AFOdCCT
         v/05dhuQgRhxAoLt+O2vb42GymvVY1+hG8cJzQ5uAucXaDWzY8ynsD7MHRQMK6Rfvc
         LaGyQDbCj64H0SW8m0fPlcpqn+Qre3xnoiVgdH85uXuREfGSgBFTFmxfavqitr1yWR
         HHt1pOATlmz7xDo6DIR91CRvczo2XLD6rRexdj4RoHGRYeSffu9JH9Sr8bz5auS9nw
         VR8zC13W8CSig==
Received: by mail-ot1-f72.google.com with SMTP id t1-20020a9d7481000000b005919e9a1347so1817403otk.2
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 07:23:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ia9jCR2j/rA1cIOYRQT6jRXDjntVCpr3+k1Bg19zGmo=;
        b=ki79kRLhuZVXEibOymzH7Qr+6RHq+ggY3VWYrvQpA3y//lC4xBwUC254svH6ksUBCS
         zuc1rR9a47cxOpMUIyvFPE4rpWZQChu9bq3E1om5wEmvYqpkL6XQBVFbKQEYYVIUXf3X
         r1gtS2jFxVZDt6eBJ9qpYx/ZZSHbleDHn7QZRCN0WnA9LODtJiopbH/xXzkU5yoGH4iE
         FJyFwgEMbK4KSWGufcnuzBthozKJJaxvhTL/mktVT5nG8AeLpwZS5nA/aKyG53UtVZbl
         uDADARUEV6QLcmLG0AqoSmsfVG7IfIAGc3SjuMh0oPXUYsh8tj3ENj6OXJzKjkTEBrZ4
         87nA==
X-Gm-Message-State: AOAM532ZIXRMWJ14J0jJQh3u7el5qNnMRG6sG86CT7OajGvs1g18wqYy
        qdxxcq9mbBIkjQPmkhbkMWAmSz9hQcL76IpsEPuXWJTmYNZTKIOVVQPYLwkP/4YVVsaOw42x6Rf
        mschcm3Y8tbWt6dh+bW2FwCsgU9gmTqXQg9JF9nhvdgoOBG6ZJQ==
X-Received: by 2002:a9d:24e4:: with SMTP id z91mr7171448ota.11.1642173785398;
        Fri, 14 Jan 2022 07:23:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy1rRcmwLgU1sdJqzQCBSfOAGlb01uPOBf0ZfAZY09v0WzUQ92iIkMR8shxtN95ewZDg/NvYsXU4kg6yfRt754=
X-Received: by 2002:a9d:24e4:: with SMTP id z91mr7171417ota.11.1642173785054;
 Fri, 14 Jan 2022 07:23:05 -0800 (PST)
MIME-Version: 1.0
References: <20220114040755.1314349-1-kai.heng.feng@canonical.com>
 <20220114040755.1314349-2-kai.heng.feng@canonical.com> <YeF18mxKuO4/4G0V@lunn.ch>
In-Reply-To: <YeF18mxKuO4/4G0V@lunn.ch>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 14 Jan 2022 23:22:53 +0800
Message-ID: <CAAd53p5R2y-2JhWx3wp2=aBypJO=iV7fFS99eAgk6q7KBZMFMA@mail.gmail.com>
Subject: Re: [PATCH 2/2] stmmac: intel: Honor phy LED set by system firmware
 on a Dell hardware
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Ivan Bornyakov <i.bornyakov@metrotek.ru>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 9:09 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Jan 14, 2022 at 12:07:54PM +0800, Kai-Heng Feng wrote:
> > BIOS on Dell Edge Gateway 3200 already makes its own phy LED setting, so
> > instead of setting another value, keep it untouched and restore the saved
> > value on system resume.
> >
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> >  .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 16 +++++
> >  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  2 +
> >  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 ++
> >  drivers/net/phy/marvell.c                     | 58 ++++++++++++-------
> >  include/linux/marvell_phy.h                   |  1 +
> >  5 files changed, 61 insertions(+), 20 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> > index 8e8778cfbbadd..f8a2879e0264a 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> > @@ -857,6 +857,16 @@ static const struct dmi_system_id quark_pci_dmi[] = {
> >       {}
> >  };
> >
> > +static const struct dmi_system_id use_preset_led[] = {
> > +     {
> > +             .matches = {
> > +                     DMI_MATCH(DMI_SYS_VENDOR, "Dell EMC"),
> > +                     DMI_MATCH(DMI_PRODUCT_NAME, "Edge Gateway 3200"),
> > +             },
> > +     },
> > +     {}
> > +};
>
> This is a PHY property. Why is the MAC involved?

This is inspired by commit a93f7fe13454 ("net: phy: marvell: add new
default led configure for m88e151x") which passes the flag from MAC to
PHY.

>
> Please also think about how to make this generic, so any ACPI based
> system can use it, with any PHY.

ACPI property won't work because it ties to ACPI platform device or
PCI device, so the property still needs to be passed from MAC to PHY.

So the only approach I can think of is to use DMI match directly in PHY driver.

Kai-Heng

>
>      Andrew
