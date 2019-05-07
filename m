Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E799D16BE2
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 22:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfEGUJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 16:09:53 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34986 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfEGUJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 16:09:53 -0400
Received: by mail-ot1-f67.google.com with SMTP id g24so16238147otq.2;
        Tue, 07 May 2019 13:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fI1mA9ESug9bpIMcAscwwV+2PwBr17QEmrdS2H87k8E=;
        b=hnKjPBsD1YOkh1tsO1NYtTAfIb90D0OB3cIsu0dCIAuXdwfxVkUgNHUJ0CgR6F+qrm
         kml5Z/zMubgfryxeBE2+ePgYoWQt2nkTy7U/+pLnIHMUa31xhf9eKWdokpeGGiq2NTIr
         dFzd6SR+92h+U1oT5wljQ5NOmL2TKflMQj6fabRpPRWUkjs+z0gqBnDwjrZM8o9woUwt
         x4qTggkL2j7yJhZBGoGUV8jMwWy65xjkICCzfrRMLCiDk9GtFPrFvalmsGc8XzulN2t9
         21f5fwT0/2Ka42wf1eR93P4G+wlOHc6lSklt+t+DktyaKjWr2Qu10ve+JBrrdcsoXTxs
         wyXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fI1mA9ESug9bpIMcAscwwV+2PwBr17QEmrdS2H87k8E=;
        b=XUFEuA3u01n+ulH5HvunbUCgH2kZKiBEnHYJ/3avIBIeCaJ6JE/SAGWXNbZAR1kmfQ
         jDA+JiDW6HIctRLS+dQypoWWSlUClfx7wSD1Hlprx/e+OESnGZOMSBVwNKW/HQwsoA1a
         AztmxyfGpMhGxYbySVK10kdHx0R6w8eseObli07eqmWWAErc/fjUgwjMnFFxzK/mEXSv
         YMFFhavSkVBlBX8Vnm+WwnXmPTA7gRQdX58n8g8XAPjOCOuWFJEwFDoLzIPlYfVM8KEj
         ozLKqqgodkJ2dbAvagW8pJZGJ3jC8jbWP9J+f9BCbGvcD2l/xqrj/Dqbc2VXzLpoFJVP
         bUuw==
X-Gm-Message-State: APjAAAWGoclITPGTUE7KABEOZet4eOig6wCtG1E2vWoSGZamCBwHOC+Y
        SMbn+f1dSMqhyq0OrpYg3+IaoB4egoG+up1dwj+3lZHq
X-Google-Smtp-Source: APXvYqzzaywUVXxICXWkQJ+tB+2b9MVV5YFg5yZDOIUELoDaEWCO2DtvZ3TGYj0DfVvmUnkqlrBaVGDohK/YaTEoqw8=
X-Received: by 2002:a9d:6759:: with SMTP id w25mr22676241otm.348.1557259792940;
 Tue, 07 May 2019 13:09:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190426212112.5624-1-fancer.lancer@gmail.com>
 <20190426212112.5624-2-fancer.lancer@gmail.com> <20190426214631.GV4041@lunn.ch>
 <20190426233511.qnkgz75ag7axt5lp@mobilestation> <f27df721-47aa-a708-aaee-69be53def814@gmail.com>
 <CA+h21hpTRCrD=FxDr=ihDPr+Pdhu6hXT3xcKs47-NZZZ3D9zyg@mail.gmail.com>
 <20190429211225.ce7cspqwvlhwdxv6@mobilestation> <CAFBinCBxgMr6ZkOSGfXZ9VwJML=GnzrL+FSo5jMpN27L2o5+JA@mail.gmail.com>
 <20190506143906.o3tublcxr5ge46rg@mobilestation> <CAFBinCA=-oK3qhPv-sPge6qAo9jiv8me72_d8HCqKN3g0qiM-A@mail.gmail.com>
 <11d22189-79c2-1f4f-a93c-f99e8310ceb7@gmail.com>
In-Reply-To: <11d22189-79c2-1f4f-a93c-f99e8310ceb7@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 7 May 2019 22:09:41 +0200
Message-ID: <CAFBinCC3zG4aBZfob2FqYiytvEAKDUQUZn9GTJYE-3Jn_v0HRA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: phy: realtek: Change TX-delay setting for
 RGMII modes only
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

On Tue, May 7, 2019 at 7:37 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 06.05.2019 19:21, Martin Blumenstingl wrote:
> > Hi Serge,
> >
> > On Mon, May 6, 2019 at 4:39 PM Serge Semin <fancer.lancer@gmail.com> wrote:
> > [...]
> >>> the changes in patch 1 are looking good to me (except that I would use
> >>> phy_modify_paged instead of open-coding it, functionally it's
> >>> identical with what you have already)
> >>>
> >>
> >> Nah, this isn't going to work since the config register is placed on an extension
> >> page. So in order to reach the register first I needed to enable a standard page,
> >> then select an extended page, then modify the register bits.
> > I'm probably missing something here. my understanding about
> > phy_modify_paged is that it is equal to:
> > - select extension page
> > - read register
> > - calculate the new register value
> > - write register
> > - restore the original extension page
> >
> What maybe causes the confusion: Realtek has two kinds of pages.
> First there is the following, let's call it simple page:
> You select a page via register 0x1f and then access the paged register.
>
> Then there are extended pages. First you select a page via register 0x1f,
> then the extended page via register 0x1e, and then the paged register.
I totally missed that, thank you for pointing me in the right direction!
that means I don't have anything obvious to complain about in patch 1.


Regards
Martin
