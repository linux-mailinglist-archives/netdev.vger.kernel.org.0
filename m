Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64EEF6CD3
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 03:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfKKCgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 21:36:51 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33018 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfKKCgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 21:36:50 -0500
Received: by mail-ed1-f66.google.com with SMTP id a24so7048260edt.0
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 18:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EUrEftNBotZRmamMjZf+7wcByK3TrrvQAevsRHHxM3I=;
        b=SULQ0aULd3u/aCVWCLj80EWv6uLHoH1+hM5ggFrAQWk1GFNACw4lmf3XOfCENV0g/1
         yeCgNQWqxExHQG3gDHEFYxDjh+mlmv4Outtmhz+0iyXk/V9Rg7S+CBJhiMrCyJckRKZf
         ijwIKkmyYlab5CXkTSELrhYTEx75v9cFBQ0xZNZH29czgav++1w9gENnJx+VpizgmLVL
         r8GP+WDcSVDQH04gvFIVz1Jkv0vQXf5SZgDs98ex7srehIB50gJQn81XCNEGSy/Ndoi9
         FyfKZ+ifsvpWmZRiQY8Zi+QAmP/KRKQVaWj9wLT0ui6DTzcTxs0R3DLgtEDkZuP9kEMV
         CaGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EUrEftNBotZRmamMjZf+7wcByK3TrrvQAevsRHHxM3I=;
        b=UNF6oSSme5bdXCZnBOLDC3uovuuLUeZLgZQR+oRiI3NTGYgksDVroAGM6Nzrp40+KL
         wUI2OHPo1RY7mzKe+QuUzg6IunzdYUGZMrHVgJ7JLFj5Z1W3C3Ilh7o8MuC6gvawk7I0
         T8HE64yZtZImZLigDIhTyDcbMsampPQwCxq4b5K06Rc9A43boTt4Ku8MKKUlPMn/Ak3M
         ZqzM1lVtaICVEC68ZIYMvOu83v27Fbny3gshTPTuwEOTZc7Cy9nLBs2rh7ulcknDFsIJ
         oDVTvqIGnTxX7qSt8nuZisfA5JBJXe2xQEDtE2MVLP4DHe3o9eN04RMeXkuEp/JW3WOs
         30KA==
X-Gm-Message-State: APjAAAUgA2wFuTVqc+jKyxJ3Qy5LxNFJKVAQjNgjOZQQzyM2WYTfaRd+
        DGJ4MvDOsh/qwbhDOEIaXgxVBQCSrNO5+Tbt/2p4S+kRqeizPg==
X-Google-Smtp-Source: APXvYqw01OaHjEqaML0Q/wUNAOq5QSeReweaP1MtIZ0zQhqqMHFhtOuJhxTLbtcM/0e284Nxk12KxX+fZnfjA8uUHOU=
X-Received: by 2002:a17:906:4dd5:: with SMTP id f21mr20454702ejw.203.1573439808834;
 Sun, 10 Nov 2019 18:36:48 -0800 (PST)
MIME-Version: 1.0
References: <20191111004211.96425-1-olof@lixom.net> <20191111023255.GY25889@lunn.ch>
In-Reply-To: <20191111023255.GY25889@lunn.ch>
From:   Olof Johansson <olof@lixom.net>
Date:   Sun, 10 Nov 2019 18:36:35 -0800
Message-ID: <CAOesGMgokhLiTnAc7b04FPYY=i7ehCE5a3jJaj4j_UDuqR_DHA@mail.gmail.com>
Subject: Re: [PATCH] net: mdio-octeon: Fix pointer/integer casts
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 6:32 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Nov 10, 2019 at 04:42:11PM -0800, Olof Johansson wrote:
> > Fixes a bunch of these warnings on arm allmodconfig:
> >
> > In file included from /build/drivers/net/phy/mdio-cavium.c:11:
> > /build/drivers/net/phy/mdio-cavium.c: In function 'cavium_mdiobus_set_mode':
> > /build/drivers/net/phy/mdio-cavium.h:114:37: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> >   114 | #define oct_mdio_readq(addr)  readq((void *)addr)
> >       |                                     ^
> > /build/drivers/net/phy/mdio-cavium.c:21:16: note: in expansion of macro 'oct_mdio_readq'
> >    21 |  smi_clk.u64 = oct_mdio_readq(p->register_base + SMI_CLK);
> >       |                ^~~~~~~~~~~~~~
> >
> > Fixes: 171a9bae68c7 ("staging/octeon: Allow test build on !MIPS")
> > Signed-off-by: Olof Johansson <olof@lixom.net>
> > ---
> >  drivers/net/phy/mdio-cavium.h  | 14 +++++++-------
> >  drivers/net/phy/mdio-octeon.c  |  5 ++---
> >  drivers/net/phy/mdio-thunder.c |  2 +-
> >  3 files changed, 10 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/net/phy/mdio-cavium.h b/drivers/net/phy/mdio-cavium.h
> > index b7f89ad27465f..1cf81f0bc585f 100644
> > --- a/drivers/net/phy/mdio-cavium.h
> > +++ b/drivers/net/phy/mdio-cavium.h
> > @@ -90,7 +90,7 @@ union cvmx_smix_wr_dat {
> >
> >  struct cavium_mdiobus {
> >       struct mii_bus *mii_bus;
> > -     u64 register_base;
> > +     void __iomem *register_base;
> >       enum cavium_mdiobus_mode mode;
> >  };
> >
> > @@ -98,20 +98,20 @@ struct cavium_mdiobus {
> >
> >  #include <asm/octeon/octeon.h>
> >
> > -static inline void oct_mdio_writeq(u64 val, u64 addr)
> > +static inline void oct_mdio_writeq(u64 val, void __iomem *addr)
> >  {
> > -     cvmx_write_csr(addr, val);
> > +     cvmx_write_csr((u64)addr, val);
> >  }
>
> Hi Olof
>
> Humm. The warning goes away, but is it really any better?
>
> Did you try also changing the stub function in
> drivers/staging/octeon/octeon-stubs.h so it takes void __iomem?  Or
> did that cause a lot more warnings from other places?

That percolates through a bunch of MIPS code that I didn't feel like
getting into. So indeed, I stopped at that point.


-Olof
