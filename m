Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6652116EAD4
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgBYQHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:07:13 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40248 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729206AbgBYQHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 11:07:13 -0500
Received: by mail-ed1-f65.google.com with SMTP id p3so16818626edx.7
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 08:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9arvUk2cDROQgu3vYCcsInrskI9x/O+LBT4kduBjlQY=;
        b=BCYxRthhM/uNEfGO2DIAjqr5SPNI8DCKY8qUSz6YDnWAgtIdjCoHnYoSOAKzujTf69
         FoLIAj9u2wGyC+fCGU4dB7bzkSolSW/BkE+X7aKxdS66lAvSLC07Iz+0LPtrl1mxdmUO
         NEyfnHkypLBUNu/WuOiSos0QFN1bVdOBruDzG4jnVvEAMCcUGgEXmhV2OAecLDtA3cmW
         Zu0s84N5Fr238I7jltzlJKDyJexbayfRHfw98uNt0PSV0K1pSdlEAzEgVCQ4o+ECKaR5
         u8RIMnwk2R+M0k90M2y4vUtO37xsneC6MMtO4WnZqvyX4LY0arPYhWjJmo+abyjY3SBp
         tnlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9arvUk2cDROQgu3vYCcsInrskI9x/O+LBT4kduBjlQY=;
        b=fgp5tsjfxR0lQEdYNpxcPww1qgdQFdbTNBvr04aFjf8i1dX7Xaa3MASrI1DFUR07sE
         fsRzDKR5Qut3Zqb4vLhSuoIJtKU64kYuDVQmbnA8Q0dABcwE1ziz8vqIbi6Q41SLygWu
         OFGwikNuIiPEqwj6rAttc02CgkCsvrH354rphSrBr/aTVxGuci3OZ3nbDTY3DT0mQRqo
         mYc7fEQhwL4e7OJtu7sqUy3c/YN+vD6QC7AyEpRhCGxUy79D9IwNsIV8XYa66XEbjQne
         5wPZcV6VzhPdmvaCp+PDt96T49qkH1hrVxGdGjEmfEBy20H/IHNncYMHF64nXn4npea4
         S4qA==
X-Gm-Message-State: APjAAAUWNDiFJDHCGqoOjDJbZ6RfpAP4mQsemsIlGVtsMTHKfaHJw62K
        L8X3rM9WgXje/dpOOVEB2LhDLZQPGd701GSR6AOpVg==
X-Google-Smtp-Source: APXvYqzHZ5M65J1wSxStiQAYTfSOvJoaKbxN980Ghw3Ls5JXVOh56kKcVx01i3UMF1+gKusAzMeQLZVuJgYlujPpvtk=
X-Received: by 2002:aa7:c44e:: with SMTP id n14mr54140896edr.179.1582646830983;
 Tue, 25 Feb 2020 08:07:10 -0800 (PST)
MIME-Version: 1.0
References: <20200224130831.25347-1-olteanv@gmail.com> <20200225144545.3lriucp2igwd3kpb@soft-dev3.microsemi.net>
In-Reply-To: <20200225144545.3lriucp2igwd3kpb@soft-dev3.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 25 Feb 2020 18:06:59 +0200
Message-ID: <CA+h21hrFLBF9+_v+Pk8nC6Vv0dGjP1P2fkA+ECtms-GL201OYg@mail.gmail.com>
Subject: Re: [PATCH net-next 00/10] Wire up Ocelot tc-flower to Felix DSA
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, Po Liu <po.liu@nxp.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Tue, 25 Feb 2020 at 16:45, Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> The 02/24/2020 15:08, Vladimir Oltean wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> >
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > This series is a proposal on how to wire up the tc-flower callbacks into
> > DSA. The example taken is the Microchip Felix switch, whose core
> > implementation is actually located in drivers/net/ethernet/mscc/.
> >
> > The proposal is largely a compromise solution. The DSA middle layer
> > handles just enough to get to the interesting stuff (FLOW_CLS_REPLACE,
> > FLOW_CLS_DESTROY, FLOW_CLS_STATS), but also thin enough to let drivers
> > decide what filter keys and actions they support without worrying that
> > the DSA middle layer will grow exponentially. I am far from being an
> > expert, so I am asking reviewers to please voice your opinion if you
> > think it can be done differently, with better results.
> >
> > The bulk of the work was actually refactoring the ocelot driver enough
> > to allow the VCAP (Versatile Content-Aware Processor) code for vsc7514
> > and the vsc9959 switch cores to live together.
> >
> > Flow block offloads have not been tested yet, only filters attached to a
> > single port. It might be as simple as replacing ocelot_ace_rule_create
> > with something smarter, it might be more complicated, I haven't tried
> > yet.
> >
> > I should point out that the tc-matchall filter offload is not
> > implemented in the same manner in current mainline. Florian has already
> > went all the way down into exposing actual per-action callbacks,
> > starting with port mirroring. Because currently only mirred is supported
> > by this DSA mid layer, everything else will return -EOPNOTSUPP. So even
> > though ocelot supports matchall (aka port-based) policers, we don't have
> > a call path to call into them.  Personally I think that this is not
> > going to scale for tc-matchall (there may be policers, traps, drops,
> > VLAN retagging, etc etc), and that we should consider replacing the port
> > mirroring callbacks in DSA with simple accessors to
> > TC_CLSMATCHALL_REPLACE and TC_CLSMATCHALL_DESTROY, just like for flower.
> > That means that drivers which currently implement the port mirroring
> > callbacks will need to have some extra "if" conditions now, in order for
> > them to call their port mirroring implementations.
> >
> > Vladimir Oltean (9):
> >   net: mscc: ocelot: simplify tc-flower offload structures
> >   net: mscc: ocelot: replace "rule" and "ocelot_rule" variable names
> >     with "ace"
> >   net: mscc: ocelot: return directly in
> >     ocelot_cls_flower_{replace,destroy}
> >   net: mscc: ocelot: don't rely on preprocessor for vcap key/action
> >     packing
> >   net: mscc: ocelot: remove port_pcs_init indirection for VSC7514
> >   net: mscc: ocelot: parameterize the vcap_is2 properties
> >   net: dsa: Refactor matchall mirred action to separate function
> >   net: dsa: Add bypass operations for the flower classifier-action
> >     filter
> >   net: dsa: felix: Wire up the ocelot cls_flower methods
> >
> > Yangbo Lu (1):
> >   net: mscc: ocelot: make ocelot_ace_rule support multiple ports
> >
> >  drivers/net/dsa/ocelot/felix.c            |  31 ++
> >  drivers/net/dsa/ocelot/felix.h            |   3 +
> >  drivers/net/dsa/ocelot/felix_vsc9959.c    | 126 ++++++
> >  drivers/net/ethernet/mscc/ocelot.c        |  20 +-
> >  drivers/net/ethernet/mscc/ocelot_ace.c    | 472 +++++++++++-----------
> >  drivers/net/ethernet/mscc/ocelot_ace.h    |  26 +-
> >  drivers/net/ethernet/mscc/ocelot_board.c  | 151 +++++--
> >  drivers/net/ethernet/mscc/ocelot_flower.c | 256 ++++--------
> >  drivers/net/ethernet/mscc/ocelot_tc.c     |  22 +-
> >  drivers/net/ethernet/mscc/ocelot_vcap.h   | 403 ------------------
> >  include/net/dsa.h                         |   6 +
> >  include/soc/mscc/ocelot.h                 |  20 +-
> >  include/soc/mscc/ocelot_vcap.h            | 205 ++++++++++
> >  net/dsa/slave.c                           | 128 ++++--
> >  14 files changed, 954 insertions(+), 915 deletions(-)
> >  delete mode 100644 drivers/net/ethernet/mscc/ocelot_vcap.h
> >  create mode 100644 include/soc/mscc/ocelot_vcap.h
> >
> > --
> > 2.17.1
> >
>
> Hi Vladimir,
>
> From my point, it looks OK the changes to Ocelot.
> Also I managed to run some tests and they are passing.
>

Thanks, I really appreciate you trying out the patches. Having the
VCAP IS2 already implemented and working for Felix with minimal
changes is also huge.
I'll wait for further comments from the flow offload people, DSA
people or anybody else, and if the timeout expires I'll send a v2
addressing the Kbuild and David's reverse Christmas tree complaints.

> --
> /Horatiu

Regards,
-Vladimir
