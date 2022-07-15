Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34381576788
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiGOTg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiGOTg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:36:29 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DBB599DE
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 12:36:27 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id n18so9457668lfq.1
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 12:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xZE5stm+6oM3UiW7c/LmJ+dXc0L6/Ob37lrJneCA0+c=;
        b=iRjOa8HnomKOJAMxvsLaYCFQeTf/KxmJ7saMVATHGokS3qoRb4KwZzuW+8X4zTyLxb
         s0hZoaKM5CbsOSXvih/OR82Zw2DJ3n1awx/kVcbOw+TYZ1TRE1B+Y/BGVGIzRHO8oicM
         VP+aXwgX0byEzCpM10jQ8cPbykFYre82ZtNzjyX0tBLQ2VjBVVLICEEjCCZyTJxTqHX7
         LPsP87qJxO7ATMor+KrCHZ5VuiCYAfxxGQ3B9320wd49vHfflhjP6/a5tzFS5cr5G1Cl
         s0DOpDEjOs2KZTyDmukUrIG45K1yanW2aigsJ78AzRmjf0gcrCN92laIRzsI4mrrnECJ
         NOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xZE5stm+6oM3UiW7c/LmJ+dXc0L6/Ob37lrJneCA0+c=;
        b=brXjmAPhjhblQxdrML9eyTwPeKMSVEo3AYaohP5EebbkVcYyArMCPVImYr1pQPaWvZ
         oeqnFDNxsLZzivCLX+EMyoPwqguj23ABjd3UvTIEahjJV+kTPPGR9j1baUHjHStZPNoB
         lbxhrh4Z4Ij8pY656W5YhP11qYcj16/S2tcBsw7ZQfYq8TEBpPqz3nZbHY7Bt/CBmL28
         7EfYKvjim5LvjZEuQ9raioGxQw9uSTerdhDsr3Q1bwbWLNmrWSEJq7IztjldjzFq7Eqh
         kMoctFrcFL9d12MrT+JXay2+TWL5l8HQGCZS9zKY5j7Fi9ZKmAyca4WlVEyz17wbI3nk
         ASZw==
X-Gm-Message-State: AJIora83P4Ydl27OIOsaJHtwnMIAgwxa9ohB64AQ0VPMxuAJ40RjGa5o
        ak6wqd4i2aoMm0CeTJSfCFUu6uq6SEx8XlwpPJLsTw==
X-Google-Smtp-Source: AGRyM1vGM4eC2yO8nFUQGMb9DIQnGggmbyjLOqho3fownS7BUY5zWv3lrkOkybcGhdRTa8KWdNU3TShCpRb0aTbWYy0=
X-Received: by 2002:ac2:44cf:0:b0:48a:1251:1cf5 with SMTP id
 d15-20020ac244cf000000b0048a12511cf5mr6226799lfm.680.1657913786280; Fri, 15
 Jul 2022 12:36:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220715085012.2630214-1-mw@semihalf.com> <20220715085012.2630214-4-mw@semihalf.com>
 <YtG/NFKC6a0oPTcd@smile.fi.intel.com>
In-Reply-To: <YtG/NFKC6a0oPTcd@smile.fi.intel.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Fri, 15 Jul 2022 21:36:15 +0200
Message-ID: <CAPv3WKeJL107p+B2fV2xKj2bvHCa2fx3XCDd3qMoY0uzFVkENA@mail.gmail.com>
Subject: Re: [net-next: PATCH v2 3/8] net: dsa: switch to device_/fwnode_ APIs
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pt., 15 lip 2022 o 21:25 Andy Shevchenko
<andriy.shevchenko@linux.intel.com> napisa=C5=82(a):
>
> On Fri, Jul 15, 2022 at 10:50:07AM +0200, Marcin Wojtas wrote:
> > In order to support both ACPI and DT, modify the generic
> > DSA code to use device_/fwnode_ equivalent routines.
> > Drop using port's dn field and use only fwnode - update
> > all dependent drivers.
> > Because support for more generic fwnode is added,
> > replace '_of' suffix with '_fw' in related routines.
> > No functional change is introduced by this patch.
>
> It's a bit too narrow text in the commit message, can you use more width?
>

Ok.

> ...
>
> > -             ret =3D of_get_phy_mode(dsa_to_port(ds, 5)->dn, &interfac=
e);
> > +             ret =3D of_get_phy_mode(to_of_node(dsa_to_port(ds, 5)->fw=
node), &interface);
>
> So, I believe this is expected to be a temporary change and something lik=
e
> fwnode_get_phy_mode() is on its way, correct?
>

I use fwnode_get_phy_mode even if this patch. I can do the conversion
here in v3.

> ...
>
> > -                     phy_handle =3D of_parse_phandle(dp->dn, "phy-hand=
le", 0);
> > +                     phy_handle =3D of_parse_phandle(to_of_node(dp->fw=
node), "phy-handle", 0);
>
> This can be translated to fwnode_find_reference(), but it might require m=
ore
> changes.

Yes.

>
> Actually you may start from converting drivers one-by-one to fwnode
> APIs (as much as it's possible), and then do with a library call. Up to y=
ou.
>

I'm dropping the dn and will try to keep the diff in the other drivers
minimal (however, for 2 above cases I will consider of_ -> fwnode_
replacements). Except for mv88e6xxx, I can do only compile-check.

Best regards,
Marcin
