Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D51293CEF
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407275AbgJTNGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 09:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406443AbgJTNGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 09:06:51 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76329C061755
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 06:06:51 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id m16so1901154ljo.6
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 06:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zy9IXRmu3b6F+JC61rfAUXl9xU6fCDPuBKv5mLvUeHY=;
        b=ap0Ca2KxVV9dnZPPwoBZQUD+qCgfAEdKC0DF0hQlb27DlufpgJq5fk1Go6dRCEzUsV
         C4OClSV2/vPNCJcULOPUnamk0TajIEEOp2wDbAMXCPX1QF+3nmbmv/bA5/hF9Lh4kJhk
         f4LPaOJV3Cdekl+mfVuNePJsZbsnoDWwke5Tkn2S2k/hE5rNea/a4yGKMTWktyXQGIde
         S6xZQ/raW8I4CTZ23+OssRG/vJ3PeCaBzDjJb7el5EK6B80DByZkXWM9FeST9cXhjdmW
         qYI5RY/WSfn/4ZuRBepBX9FFAZ7ruBSxIndhLj3DS7rZyF4IxiLjtzutsNvGbzbM+HTZ
         JVuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zy9IXRmu3b6F+JC61rfAUXl9xU6fCDPuBKv5mLvUeHY=;
        b=nKHkSL5J/fKKi4ZGePfVoXTdkr0Xf+BR2vhDFiHRbRraHhTVijIb5mEVoqGNPZxh1O
         omAbUTB33sHZ3T4dx3SaAz+6rSatQ9trD/Z0KLqax5E9LMOBJCulidL7pKYXoU0GhBlI
         tykPGRNPYIBwjZ0eVMOKl3kYkYm5BQzhVgrwUUida3PWOEx7mLtu3kSbWTfgCbthCImD
         IHeyYhR5mGFIZZB9v7jDa1ajvpR4x718EJFuZLNOi0AknTOYxUg98rr4XXC/+7KVx+U3
         hcsDNIQHTzX4t6JjPeRcRErRXVNWJguBpVnrXzN6y8/suiGyO2gyBAdudhE/q8lqgYWN
         j7IA==
X-Gm-Message-State: AOAM53314bVWNbVDmhG+eqH8SDVt2FWQexVAidKtR+mtBdtqUCRtnLC2
        TuwOySdNzrRBjYASBotR9MN10YIRcFA6rVVK2/clcYlpeT4=
X-Google-Smtp-Source: ABdhPJx8UEKBEb+DGsZ/VmVmKw0KkZd9Mhf2q1/2vg6HyATcXr3XmbcQ6/a4WUw+njPosMntlbkMEjKZDR8F+7aXGEg=
X-Received: by 2002:a2e:905:: with SMTP id 5mr985798ljj.136.1603199209782;
 Tue, 20 Oct 2020 06:06:49 -0700 (PDT)
MIME-Version: 1.0
References: <c8143134-1df9-d3bc-8ce7-79cb71148d49@linux-m68k.org>
 <20201020024000.GV456889@lunn.ch> <AM8PR04MB73150BDBA6E79ABE662B6762FF1F0@AM8PR04MB7315.eurprd04.prod.outlook.com>
In-Reply-To: <AM8PR04MB73150BDBA6E79ABE662B6762FF1F0@AM8PR04MB7315.eurprd04.prod.outlook.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Tue, 20 Oct 2020 06:06:38 -0700
Message-ID: <CAFXsbZopA5esZzdNkFAxUpfwK6zmtRKn07TUfa2ShR4Y-qXBNw@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Greg Ungerer <gerg@linux-m68k.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 8:02 PM Andy Duan <fugang.duan@nxp.com> wrote:
>
> From: Andrew Lunn <andrew@lunn.ch> Sent: Tuesday, October 20, 2020 10:40 AM
> > On Tue, Oct 20, 2020 at 12:14:04PM +1000, Greg Ungerer wrote:
> > > Hi Andrew,
> > >
> > > Commit f166f890c8f0 ("[PATCH] net: ethernet: fec: Replace interrupt
> > > driven MDIO with polled IO") breaks the FEC driver on at least one of
> > > the ColdFire platforms (the 5208). Maybe others, that is all I have
> > > tested on so far.
> > >
> > > Specifically the driver no longer finds any PHY devices when it probes
> > > the MDIO bus at kernel start time.
> > >
> > > I have pinned the problem down to this one specific change in this commit:
> > >
> > > > @@ -2143,8 +2142,21 @@ static int fec_enet_mii_init(struct
> > platform_device *pdev)
> > > >     if (suppress_preamble)
> > > >             fep->phy_speed |= BIT(7);
> > > > +   /* Clear MMFR to avoid to generate MII event by writing MSCR.
> > > > +    * MII event generation condition:
> > > > +    * - writing MSCR:
> > > > +    *      - mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
> > > > +    *        mscr_reg_data_in[7:0] != 0
> > > > +    * - writing MMFR:
> > > > +    *      - mscr[7:0]_not_zero
> > > > +    */
> > > > +   writel(0, fep->hwp + FEC_MII_DATA);
> > >
> > > At least by removing this I get the old behavior back and everything
> > > works as it did before.
> > >
> > > With that write of the FEC_MII_DATA register in place it seems that
> > > subsequent MDIO operations return immediately (that is FEC_IEVENT is
> > > set) - even though it is obvious the MDIO transaction has not completed yet.
> > >
> > > Any ideas?
> >
> > Hi Greg
> >
> > This has come up before, but the discussion fizzled out without a final patch
> > fixing the issue. NXP suggested this
> >
> > writel(0, fep->hwp + FEC_MII_DATA);
> >
> > Without it, some other FEC variants break because they do generate an
> > interrupt at the wrong time causing all following MDIO transactions to fail.
> >
> > At the moment, we don't seem to have a clear understanding of the different
> > FEC versions, and how their MDIO implementations vary.
> >
> >           Andrew
>
> Andrew, different varants has little different behavior, so the line is required for
> Imx6/7/7 platforms but should be removed in imx5 and ColdFire.

Do we know which variants of i.MX6 and i.MX7 do and don't need this?
I'm successfully running with polling mode using the i.MX6q, i.MX6qp,
i.MX7d, and Vybrid, all of which benefit from the considerably higher
throughput achieved with polling.  (In all my use cases I'm working
with an Ethernet Switch attached via MDIO.)

>
> As we discuss one solution to resolve the issue, but it bring 30ms latency for kernel boot.
>
> Now, I want to revert the polling mode to original interrupt mode, do you agree ?
>
> Andy
