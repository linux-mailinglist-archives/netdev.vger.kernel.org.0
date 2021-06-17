Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25763AAD90
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 09:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhFQHaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 03:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhFQHai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 03:30:38 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AF6C061574;
        Thu, 17 Jun 2021 00:28:30 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id u190so410367pgd.8;
        Thu, 17 Jun 2021 00:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q4eMKd/XWHD7paoLb9rqGomW2R8tJagN5j+loNDzse4=;
        b=jJKe2wNR/ZWDKjhJAvYlE1NaharrJKID4MuOu/j7C43hKqxNR0oFDsiD2YYtrsUnQS
         PrTOP7yA8Nr3nP54eLTVZ6tuE80lugvysmx5PmaUTSzXwuGgvAt8ZWgYDUNUlF9lci2/
         KC5n1Z3XInptGk8uZij+pu+heyx2gb2jj+pJQ9aEXrAm/17kn2VWCaFFSH2l23y7bIRK
         gJBRJiO8MO8EM2kMMO90vYOtyFtlWKLmX2foluOz53n5QmVgWCQEdzTIYxL349Ux10pf
         JM11g3RPTtX91wIF51XMIKAgAteKcDcsT7E/yHR0hr/5FgB2QE5Vc2lF12W2LbPiRKJP
         SQ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q4eMKd/XWHD7paoLb9rqGomW2R8tJagN5j+loNDzse4=;
        b=gKUg862By+ee/lyMks6N0tVqobz2i3DAmjnbhUARjSVwpTkapvZOvSLbr9p6vIPP45
         DQyxus0nZn5pKnDL/Dn8l67t04PGzFeogHI2GlT08Jut8dPmtOyQ5HEp3M5Z7owsASxM
         A6YK6EJNKObyLdgoiJXmzJn7IpcH2a11sUsyPvmjyrH03YwlKDbwUgAAcnKe9c++quA5
         yUFyvKviMkuyJdBlVhWR0vPZwypS39fciKMEPB0SD4E0M+d6OnY59ziSSHC8V79zsvKl
         GQuZVtQ7K5I/kPF113yoGHrewcPTlBG7MWCvB/EBTakeS7Yeo4NAuePZguius0FVIGYQ
         GUdA==
X-Gm-Message-State: AOAM532jNSpwsi+HHi+68JtJZqqv3pkX6HXL7BE3bNEaYfvRbwMxaDgG
        EOyWFJOEWgH2i0ifGfk55TMhdSIK71+aHuyQfgY=
X-Google-Smtp-Source: ABdhPJzHrfp88VYI8UMAiktCXdAx4IALJ2MORGOLaiuA7nfv0xM7RFR+7Abm/sKvnt08BqgM5DMXEcBhwm5FeoF7qBg=
X-Received: by 2002:a63:f10b:: with SMTP id f11mr3658783pgi.203.1623914910434;
 Thu, 17 Jun 2021 00:28:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210616190759.2832033-1-mw@semihalf.com> <20210616190759.2832033-5-mw@semihalf.com>
 <YMpVhxxPxB/HKOn2@lunn.ch> <CAPv3WKdo_JeMRL-GtkYv7G3MUnXmyG_oJtA+=WY72-J_0jokRA@mail.gmail.com>
In-Reply-To: <CAPv3WKdo_JeMRL-GtkYv7G3MUnXmyG_oJtA+=WY72-J_0jokRA@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 17 Jun 2021 10:28:14 +0300
Message-ID: <CAHp75VfQkAqLWSXZYsdZKDphBwGH+phXe49MA3C9kZ=DxPM0Lg@mail.gmail.com>
Subject: Re: [net-next: PATCH v2 4/7] net: mvmdio: simplify clock handling
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>, upstream@semihalf.com,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Jon Nettleton <jon@solid-run.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 2:25 AM Marcin Wojtas <mw@semihalf.com> wrote:
>
> =C5=9Br., 16 cze 2021 o 21:48 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a=
):
> >
> > > +     dev->clks[0].id =3D "core";
> > > +     dev->clks[1].id =3D "mg";
> > > +     dev->clks[2].id =3D "mg_core";
> > > +     dev->clks[3].id =3D "axi";
> > > +     ret =3D devm_clk_bulk_get_optional(&pdev->dev, MVMDIO_CLOCK_COU=
NT,
> > > +                                      dev->clks);
> >
> > Kirkwood:
> >
> >                 mdio: mdio-bus@72004 {
> >                         compatible =3D "marvell,orion-mdio";
> >                         #address-cells =3D <1>;
> >                         #size-cells =3D <0>;
> >                         reg =3D <0x72004 0x84>;
> >                         interrupts =3D <46>;
> >                         clocks =3D <&gate_clk 0>;
> >                         status =3D "disabled";
> >
> > Does this work? There is no clock-names in DT.
> >
>
> Neither are the clocks in Armada 7k8k / CN913x:
>
>                 CP11X_LABEL(mdio): mdio@12a200 {
>                         #address-cells =3D <1>;
>                         #size-cells =3D <0>;
>                         compatible =3D "marvell,orion-mdio";
>                         reg =3D <0x12a200 0x10>;
>                         clocks =3D <&CP11X_LABEL(clk) 1 9>,
> <&CP11X_LABEL(clk) 1 5>,
>                                  <&CP11X_LABEL(clk) 1 6>,
> <&CP11X_LABEL(clk) 1 18>;
>                         status =3D "disabled";
>                 };
>
> Apparently I misread the code and got convinced that contrary to
> devm_clk_get_optional(), the devm_clk_get_bulk_optional() obtains the
> clocks directly by index, not name (on the tested boards, the same
> clocks are enabled by the other interfaces, so the problems

Me too. Sorry for the wrong suggestion. I think we need something that
actually gets clocks by indices in a bulk, but this is another story.

> I will drop this patch. Thank you for spotting the issue.

I'm fine with this.

--=20
With Best Regards,
Andy Shevchenko
