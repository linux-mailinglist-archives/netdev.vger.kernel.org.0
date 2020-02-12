Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B4F15B3F8
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 23:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgBLWif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 17:38:35 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37993 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727947AbgBLWif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 17:38:35 -0500
Received: by mail-ed1-f67.google.com with SMTP id p23so4347267edr.5;
        Wed, 12 Feb 2020 14:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PohkhtrxCQXKc3msnzt2/qcaTLR5BZC172JvOaY5d7c=;
        b=ntsmAzQtK8HwGRSqGH/Ea9MHiLNgVPOgX3VIicUHyPAiAgnqCddnEuqgTosg/jlYOy
         Fl62kl3RfPTy25ehJv8WT8HVAg/xqI5nPv2/c9kvK1SKLCrgou7n2sJGYj0XpLOKdIjy
         N8FZEKs8Na4Sjmp2yL74Mif+HLempXLoteUXkXAp4WKEH9Bh8547xEI5G2MBcJcke2Rl
         poThtbjixHIAEP0wPJ8FRJHHnl5OvG70l45mbnJeIcmUd/k4y+pNA4OFySYTvfirte6F
         bH6K9O9OAScmBBfUbJYjiRuOqCLzEVEmG15bvQhxyeA50kZDLpQqM8wsyVGa3p/PLouF
         jVWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PohkhtrxCQXKc3msnzt2/qcaTLR5BZC172JvOaY5d7c=;
        b=b8Pyh+GtMU28rico2KURG0gYGmcNQlE3/OU0woijxZwKk9Bw8arej/qRzlXBTm9Q4u
         WpdZAx4IadAWKIDkrxBXr8GhEAqsObycVIaUXlg5jQlCH7wsf5RYBkrjJO3mLxhA+lOd
         azTwbyjEawhKG3yY8q6ozH1JE7UtJJE1rRj0VLLznGCrafXPMegwy1cYFbYMHcarAkvI
         b/I0bFjXe0cngGD0d1L540jVYDtGsbE/4J2B/3lvq7bawF0xfv1Ifo5PVAvSVp09GUnR
         HU6Da5w97ayzwCxIC2MsDkRk0pPe0ie34ILTowtwKuctV9aP+rcvRiNyGh++EnvzTMmg
         Xm7g==
X-Gm-Message-State: APjAAAX9KatJ//wWbHSIPJZcLV+LsFgaMKONQ5ewI1mkVoaSVQGqHIrJ
        JGSUJunT8WgTMGrX9413u9DAcLSfrNjSzr0tetM=
X-Google-Smtp-Source: APXvYqwMIp8nP5bimfFhJ38iHO7g/bQsTcUfjdehb4Vrx1PW01XzUpzhhME3bgB56zevCyZcio9nWjIFtjGHsvwSI7M=
X-Received: by 2002:a17:906:4089:: with SMTP id u9mr13343427ejj.184.1581547112663;
 Wed, 12 Feb 2020 14:38:32 -0800 (PST)
MIME-Version: 1.0
References: <20200212200555.2393-1-f.fainelli@gmail.com> <CA+h21hpG5y1D2d53P7KK6X5uBFxoSQ_iCs3rRAJe61yxfWWAPA@mail.gmail.com>
 <6ba11003-48fd-0b93-332d-3bc485bcb577@gmail.com>
In-Reply-To: <6ba11003-48fd-0b93-332d-3bc485bcb577@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 13 Feb 2020 00:38:21 +0200
Message-ID: <CA+h21hqMLJ0GuZnvv+aCzRBDRfApDouL-piqLVTgZqASBmQv4w@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: Treat VLAN ID 0 as PVID untagged
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, michal.vokac@ysoft.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Feb 2020 at 23:28, Florian Fainelli <f.fainelli@gmail.com> wrote=
:
>
> On 2/12/20 12:47 PM, Vladimir Oltean wrote:
> > Hi Florian,
> >
> > On Wed, 12 Feb 2020 at 22:06, Florian Fainelli <f.fainelli@gmail.com> w=
rote:
> >>
> >> VLAN ID 0 is special by all kinds and is really meant to be the defaul=
t
> >> ingress and egress untagged VLAN. We were not configuring it that way
> >> and so we would be ingress untagged but egress tagged.
> >>
> >> When our devices are interfaced with other link partners such as switc=
h
> >> devices, the results would be entirely equipment dependent. Some
> >> switches are completely fine with accepting an egress tagged frame wit=
h
> >> VLAN ID 0 and would send their responses untagged, so everything works=
,
> >> but other devices are not so tolerant and would typically reject a VLA=
N
> >> ID 0 tagged frame.
> >
> > Are you sure that it's not in fact those devices that are not doing
> > what they're supposed to? VID 0 should be sent as tagged and no port
> > membership checks should be enforced on it.
>
> Where everything works what I see is the following:
>
> - Linux on egress sends an untagged frame (as captured by tcpdump) but
> the VLAN entry for VID 0 makes it egress tagged and the machine on the
> other sees it as such as well

So the operating system is sending untagged traffic, it gets
pvid-tagged by the hardware on the CPU port and is sent as
egress-tagged on the front panel.
Odd, but ok, not illegal, I suppose. The odd part is caused by having
the vid 0 as pvid. Otherwise, having vid 0 as egress-tagged is not in
itself a problem, since the assumption is that the only way a frame
would get to the switch with VID 0 was if that VID was already in the
tag.
If anything, changing the pvid to something that is egress-untagged
will give you some nice throughput boost, save you 4 bytes on the wire
per frame.

> - the response from that machine is also ingress tagged as captured from
> the DSA master network device
>
> what I do not have visibility into are systems where this does not work
> but will try to request that.

Well, we can talk until the cows come home, but until the drop reason
on those devices is clear, I would refrain from drawing any
conclusion.

> Breaking users is obviously bad which
> prompted me for doing this specification violating frame. I am not sure
> whether DSA standalone ports qualify as managed ports or not, sounds
> like no given we have not added support for doing much UC/MC filtering
> unlike what NICs do.
>
> >
> >>
> >> Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implem=
entation")
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >> ---
> >> Hi all,
> >>
> >> After looking at all DSA drivers and how they implement port_vlan_add(=
)
> >> I think this is the right change to do, but would appreciate if you
> >> could test this on your respective platforms to ensure this is not
> >> problematic.
> >
> > I'm pretty sure this is problematic, for the simple reason that with
> > this change, DSA is insisting that the default PVID is 0, contrary to
> > the bridge core which insists it is 1. And some switches, like the
> > Microchip Ocelot/Felix, don't support more than 1 egress-untagged
> > VLAN, so adding one of the VIDs 0 or 1 will fail (I don't know the
> > exact order off-hand). See 1c44ce560b4d ("net: mscc: ocelot: fix
> > vlan_filtering when enslaving to bridge before link is up") for more
> > details of how that is going to work.
>
> OK, I do wonder if we would be better off just skipping the VLAN
> programming for VID =3D 0 and/or just defining a different
> reserved/default VLAN ID for switches that have global VLAN filtering.
>

Oh, right, I remember. This is one of the switches with b53_default_pvid=3D=
0?
So what were you saying... [0]

> > > > Why should we bend the framework because sja1105 and dsa_8021q are
> > > > special?

[0]: https://lore.kernel.org/netdev/670c1d7f-4d2c-e9b4-3057-e87a66ad0d33@gm=
ail.com/

So having 0 as pvid will inevitably cause problems trying to do
something meaningful with it on egress. Send it tagged, it'll mess
with your untagged traffic, send it untagged, it'll mess with your
stack-originated 802.1p-tagged traffic, as well as 802.1p-tagged
traffic forwarded from other endpoints. Hence the reason why IEEE said
"don't do that".

Can't you do whatever workarounds with vid 0 and/or
NETIF_F_HW_VLAN_CTAG_FILTER that are restricted to b53? The "flags"
value of 0 for 802.1p tagged frames is fine under the assumption that
vid 0 is never going to be a pvid, which it'd better not be. The
bridge doesn't even let you run "bridge vlan add dev swp0 vid 0 pvid
untagged", that should say something.

> >
> >>
> >> Thank you
> >>
> >>
> >>  net/dsa/slave.c | 9 ++++++++-
> >>  1 file changed, 8 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> >> index 088c886e609e..d3a2782eb94d 100644
> >> --- a/net/dsa/slave.c
> >> +++ b/net/dsa/slave.c
> >> @@ -1100,6 +1100,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_=
device *dev, __be16 proto,
> >>  {
> >>         struct dsa_port *dp =3D dsa_slave_to_port(dev);
> >>         struct bridge_vlan_info info;
> >> +       u16 flags =3D 0;
> >>         int ret;
> >>
> >>         /* Check for a possible bridge VLAN entry now since there is n=
o
> >> @@ -1118,7 +1119,13 @@ static int dsa_slave_vlan_rx_add_vid(struct net=
_device *dev, __be16 proto,
> >>                         return -EBUSY;
> >>         }
> >>
> >> -       ret =3D dsa_port_vid_add(dp, vid, 0);
> >> +       /* VLAN ID 0 is special and should be the default egress and i=
ngress
> >> +        * untagged VLAN, make sure it gets programmed as such.
> >> +        */
> >> +       if (vid =3D=3D 0)
> >> +               flags =3D BRIDGE_VLAN_INFO_PVID | BRIDGE_VLAN_INFO_UNT=
AGGED;
> >
> > IEEE 802.1Q-2018, page 247, Table 9-2=E2=80=94Reserved VID values:
> >
> > The null VID. Indicates that the tag header contains only priority
> > information; no VID is
> > present in the frame. This VID value shall not be configured as a PVID
> > or a member of a VID
> > Set, or configured in any FDB entry, or used in any Management operatio=
n.
> >
> >> +
> >> +       ret =3D dsa_port_vid_add(dp, vid, flags);
> >>         if (ret)
> >>                 return ret;
> >>
> >> --
> >> 2.17.1
> >>
> >
> > Is this a test?
>
> Of course, I am always testing you, that way you do not know if I am
> incredibly smart or stupid.

Actually I was more like happy about not being a complete beginner
anymore. Looking through the sja1105 git history you'll see that I've
oscillated a few times myself between vid 0 and 1 as pvid. Perhaps
overly excited that I could point to the right page in the right book,
for once.

> --
> Florian

Regards,
-Vladimir
