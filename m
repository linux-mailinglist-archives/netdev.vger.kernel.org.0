Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0584120AE8E
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 10:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgFZIxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 04:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgFZIxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 04:53:38 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF9CC08C5C1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 01:53:37 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id i14so8591310ejr.9
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 01:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tCY8VdjaiYoUEdK/F26XF3lWxLThuVeIapW7FoQdSlw=;
        b=QXEiVkQcd+vFIkBh5OBSuZ4BCT44T1FoUilPcod6SUXvUPsDo09gO43w73zYTiWK3o
         QEGUS09WDSmGD3kCU4fnpVrCbHECvnhlHiFI93zO1M5RbGf9mQQbxyebO/A0FXLUpSbX
         VYjGBXmrGz/gQ5v8krNbovezN4fE33W8UZ30ngLbY5CTaPf+hAHqy524SjMtYmI7pQSa
         Nh3XDzJc5uBS4IfBcnEhag0Hy4vkfd6n8LYdLvXBssuRyoa1S0P4S/JlQrwBA/GvT5Er
         CXPCsbOQZgCZ/+MSvlFNs4DFbeQroYbH6v7lrl+EkokBevnSruHfqn108zKu+7bc15x0
         y+eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tCY8VdjaiYoUEdK/F26XF3lWxLThuVeIapW7FoQdSlw=;
        b=S+3sZcHTlNTrBDG40FRBre1NsHtLFvlvBz9dgB5CfltOMxmdeRVqIltyALfc3XJzVv
         REuQtIM5OOu3xRWp5aiN4MMYn2LyP0oKfLTwlA0EhJdoXXhm6jc33ltjtYN284BQQ9n7
         nbx0VutNXe72QEv0+6CD2iGRRSIKILFKmWAejLUY2gSfC7uYaCWRcpgVeury+ML8wY05
         Auv9B7H+222EF0cSygJHO3iH1vmFnMgfloT+bTJC0ncWVqiOADlXT4erunN9/hWqWmwK
         Cs+Z4V3JvqcHLf3scoy0DZHuwMtN3vx1hSHDPxKKpC2Nolgx7zb1B0gTtqMf1sFQHQ+L
         pfeQ==
X-Gm-Message-State: AOAM5307mzAhr6BWDSUDjYIEIqAL/3WZGhDE47iQeZ1lBLvZMgOj/SS5
        srm1FwfQfL7+RSTihi6P1kCGGE01uHUbJmYbpMU=
X-Google-Smtp-Source: ABdhPJzu2OWIB36m7AhtzjCPI8h3OgPXh/aLvItfcn8kITENaDj1zlnx60FV/yHvnrwzMvh5xMywN/Dnp70856kpWL8=
X-Received: by 2002:a17:906:6897:: with SMTP id n23mr1541560ejr.473.1593161615398;
 Fri, 26 Jun 2020 01:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200625152331.3784018-1-olteanv@gmail.com> <20200625152331.3784018-6-olteanv@gmail.com>
 <20200625165349.GI1551@shell.armlinux.org.uk>
In-Reply-To: <20200625165349.GI1551@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 26 Jun 2020 11:53:24 +0300
Message-ID: <CA+h21hqn0P6mVJd1o=P1qwmVw-E56-FbY0gkfq9KurkRuJ5_hQ@mail.gmail.com>
Subject: Re: [PATCH net-next 5/7] net: dsa: felix: delete .phylink_mac_an_restart
 code
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Thu, 25 Jun 2020 at 19:53, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Thu, Jun 25, 2020 at 06:23:29PM +0300, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > In hardware, the AN_RESTART field for these SerDes protocols (SGMII,
> > USXGMII) clears the resolved configuration from the PCS's
> > auto-negotiation state machine.
> >
> > But PHYLINK has a different interpretation of "AN restart". It assumes
> > that this Linux system is capable of re-triggering an auto-negotiation
> > sequence, something which is only possible with 1000Base-X and
> > 2500Base-X, where the auto-negotiation is symmetrical. In SGMII and
> > USXGMII, there's an AN master and an AN slave, and it isn't so much of
> > "auto-negotiation" as it is "PHY passing the resolved link state on to
> > the MAC".
>
> This is not "a different interpretation".
>
> The LX2160A documentation for this PHY says:
>
>   9             Restart Auto Negotiation
>  Restart_Auto_N Self-clearing Read / Write command bit, set to '1' to
>                 restart an auto negotiation sequence. Set to '0'
>                 (Reset value) in normal operation mode. Note: Controls
>                 the Clause 37 1000Base-X Auto-negotiation.
>
> It doesn't say anything about clearing anything for SGMII.
>
> Also, the Cisco SGMII specification does not indicate that it is
> possible to restart the "autonegotiation" - the PHY is the controlling
> end of the SGMII link.  There is no clause in the SGMII specification
> that indicates that changing the MAC's tx_config word to the PHY will
> have any effect on the PHY once the data path has been established.
>
> Finally, when a restart of negotiation is requested, and we have a PHY
> attached in SGMII mode, we will talk to that PHY to cause a restart of
> negotiation on the media side, which will implicitly cause the link
> to drop and re-establish, causing the SGMII side to indicate link down
> and subsequently re-establish according to the media side results.
>
> So, please, lay off your phylink bashing in your commit messages.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Sorry, I was in a bit of a hurry when writing this commit message, so it is a
bit imprecise as you point out. How about:

net: dsa: felix: delete .phylink_mac_an_restart code

The Cisco SGMII and USXGMII standards specify control information exchange to
be "achieved by using the Auto-Negotiation functionality defined in Clause 37
of the IEEE Specification 802.3z".

The differences to clause 37 auto-negotiation are specified by the respective
standards. In the case of SGMII, the differences are spelled out as being:

- A reduction of the link timer value, from 10 ms to 1.6 ms.
- A customization of the tx_config_reg[15:0], mostly to allow propagation of
  speed information.

A similar situation is going on for USXGMII as well: "USXGMII Auto-neg
mechanism is based on Clause 37 (Figure 37-6) plus additional management
control to select USXGMII mode".

The point is, both Cisco standards make explicit reference that they require an
auto-negotiation state machine implemented as per "Figure 37-6-Auto-Negotiation
state diagram" from IEEE 802.3. In the SGMII spec, it is very clearly pointed
out that both the MAC PCS (Figure 3 MAC Functional Block) and the PHY PCS
(Figure 2 PHY Functional Block) contain an auto-negotiation block defined by
"Auto-Negotiation Figure 37-6".

Since both ends of the SGMII/USXGMII link implement the same state machine
(just carry different tx_config_reg payloads, which they convey to their link
partner via /C/ ordered sets), naturally the ability to restart
auto-negotiation is symmetrical. The state machine in IEEE 802.3 Figure 37-6
specifies the signal that triggers an auto-negotiation restart as being
"mr_restart_an=TRUE".

Furthermore, clause "37.2.5.1.9 State diagram variable to management register
mapping", through its "Table 37-8-PCS state diagram variable to management
register mapping", requires a PCS compliant to clause 37 to expose the
mr_restart_an signal to management through MDIO register "0.9 Auto-Negotiation
restart", aka BMCR_ANRESTART in Linux terms.

The Felix PCS for SGMII and USXGMII is compliant to clause 37, so it exposes
BMCR_ANRESTART to the operating system. When this bit is asserted, the
following happens:

1. STATUS[Auto_Negotiation_Complete] goes from 1->0.
2. The PCS starts sending AN sequences instead of packets or IDLEs.
3. The PCS waits to receive AN sequences from PHY and matches them.
4. Once it has received  matching AN sequences and a PHY acknowledge,
   STATUS[Auto_Negotiation_Complete] goes from 0->1.
5. Normal packet transmission restarts.

Otherwise stated, the MAC PCS has the ability to re-trigger a switch of the
lane from data mode into configuration mode, then control information exchange
takes place, then the lane is switched back into data mode. These 5 steps are
collectively described as "restart AN state machine" by the PCS documentation.
This is all as per IEEE 802.3 Clause 37 AN state machine, which SGMII and
USXGMII do not touch at this fundamental level.

Now, it is true that the Cisco SGMII and USXGMII specs mention that the control
information exchange has a unidirectional meaning. That is, the PHY restarts
the clause 37 auto-negotiation upon any change in MDI auto-negotiation
parameters. PHYLINK takes this fact a bit further, and since the fact that the
MAC PCS conveys no new information to the PHY PCS (beyond acknowledging the
received config word), does not permit the MAC PCS to trigger a restart of the
clause 37 auto-negotiation for any other SERDES protocols than 1000Base-X and
2500Base-X. For those, the control information exchange _is_ bidirectional
(local PCS specifies its duplex and flow control abilities). For any other
SERDES protocols, the .phylink_mac_an_restart callback is dead code. This is
probably OK, I can't come up with a situation where it might be useful for the
MAC PCS to clear its cache of link state and ask for a new tx_config_reg. So
remove this code.

Thanks,
-Vladimir
