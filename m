Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7564446D94B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237601AbhLHRNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:13:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36284 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbhLHRNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 12:13:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59C62B821C5
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 17:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8917C00446;
        Wed,  8 Dec 2021 17:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638983414;
        bh=hzrkKM7TcnMC1bg+1Lwu2h4HWTa8KIWrTVwm54vLl/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fglu4IIKkPZVBkB5gs0ENXLNhjqdSksOfA0q0JBAHE1pnDSGGq08DCUI38X69oBSH
         accUMHMs4Vc5IGJmGnQWUuGqOR7LzcAE98dFIyGFduRh118Qjo/YWGiGxhbvEDO3ko
         xWsRuRRZXq1WvzXjyexQnC0je347IUTQ2K9FW5jd+de6jtx6N3k146mv3Qs5WPqGPC
         b9mGSSUBj5SOKOGMF4ba5xzUfdmIFiMOTApLbMirzNhcAf6uUD4jBrcg2f6aFrAuy1
         M9KwCjiS0ko36S0vzxpdhVV8eCrHtMMTry85LJRucGTMTFIFK8gx+UrLxszaM8dXWp
         wt2yqKmRuhsfg==
Date:   Wed, 8 Dec 2021 18:10:09 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211208181009.3cc65cec@thinkpad>
In-Reply-To: <20211208165938.tbjhuyf6pvzqgn3t@skbuf>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
        <20211207190730.3076-2-holger.brunck@hitachienergy.com>
        <20211207202733.56a0cf15@thinkpad>
        <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208162852.4d7361af@thinkpad>
        <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208171720.6a297011@thinkpad>
        <20211208172104.75e32a6b@thinkpad>
        <20211208164131.fy2h652sgyvhm7jx@skbuf>
        <20211208175129.40aab780@thinkpad>
        <20211208165938.tbjhuyf6pvzqgn3t@skbuf>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 18:59:38 +0200
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Wed, Dec 08, 2021 at 05:51:29PM +0100, Marek Beh=C3=BAn wrote:
> > > > Vladimir, can you send your thoughts about this proposal? We are tr=
ying
> > > > to propose binding for defining serdes TX amplitude. =20
> > >
> > > I don't have any specific concern here. It sounds reasonable for
> > > different data rates to require different transmitter configurations.
> > > Having separate "serdes-tx-amplitude-millivolt" and "serdes-tx-amplit=
ude-modes"
> > > properties sounds okay, although I think a prefix with "-names" at the
> > > end is more canonical ("pinctrl-names", "clock-names", "reg-names" et=
c),
> > > so maybe "serdes-tx-amplitude-millivolt-names"?
> > > Maybe we could name the first element "default", and just the others
> > > would be named after a phy-mode. This way, if a specific TX amplitude=
 is
> > > found in the device tree for the currently operating PHY mode, it can=
 be
> > > used, otherwise the default (first) amplitude can be used. =20
> >
> > Yes, the pair
> >   serdes-tx-amplitude-millivolt
> >   serdes-tx-amplitude-millivolt-names
> > is the best.
> >
> > If the second is not defined, the first should contain only one value,
> > and that is used as default.
> >
> > If multiple values are defined, but "default" is not, the driver should
> > set default value as the default value of the corresponding register.
> >
> > The only remaining question is this: I need to implement this also for
> > comphy driver. In this case, the properties should be defined in the
> > comphy node, not in the MAC node. But the comphy also supports PCIe,
> > USB3 and SATA modes. We don't have strings for them. So this will need
> > to be extended in the future.
> >
> > But for now this proposal seems most legit. I think the properties
> > should be defined in common PHY bindings, and other bindings should
> > refer to them via $ref. =20
>=20
> I wouldn't $ref the tx-amplitude-millivolt-names from the phy-mode,
> because (a) not all phy-mode values are valid (think of parallel interfac=
es
> like rgmii) and (b) because sata, pcie, usb are also valid SERDES
> protocols as you point out. With the risk of a bit of duplication, I
> think I'd keep the SERDES protocol names a separate thing for the YAML
> validator.

Not what I meant. What I meant was that the tx-amplitude-millivolt*
properties should be defined in binding for common PHY (not network PHY)
  Documentation/devicetree/bindings/phy/phy-bindings.txt,
and then the mv88e6xxx binding should refer it's
tx-amplitude-millivolt* properties from there.

And the definition in common PHY binding should list all modes in an
enum, containing all network SerDes modes, plus the other modes like
PCIe, USB3, DisplayPort, LVDS, SATA, ...

Marek
