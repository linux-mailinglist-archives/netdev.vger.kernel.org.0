Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5404515B220
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 21:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgBLUr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 15:47:56 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38578 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbgBLUrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 15:47:55 -0500
Received: by mail-ed1-f65.google.com with SMTP id p23so4022142edr.5;
        Wed, 12 Feb 2020 12:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ocVi9UeaQe1UnqqnrvLRMbaF86CAckEwz1wjknCQnjg=;
        b=ievYme6tNhf7wTnSDN1+8dI+y71+GcsRdTmWT5zD0zXgldCLscjL8DmdMrYvoNjapw
         85Zb5pOcZ0aXklXnT99JoGssExC96kdlzwFffVY+8CEeYWzGHuNbyRCU2339GrdAt2CJ
         AS3KZEeuArEPSPGIJbH9h5smuPwXNzJgal4nDtzXQ2MgvTLR24NXsua69EQDKEWRTppB
         hSpfPCAPYSrJ7yUAxoQvRFcaIePuPWDeuppJc4TTUM7PEXyK6pteDYOM0pUNOQOZTEYr
         zQGWb18rfDzHrGtuP8JY4G6xi9iugXJtcAM5fxyKcdR/gfFZdGUJ1pET7oLRhgv3Pxgp
         ibmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ocVi9UeaQe1UnqqnrvLRMbaF86CAckEwz1wjknCQnjg=;
        b=J/bmwOVTFuppIVhNgrnhmo/ZQ3SFAVSY9jLck+8PvL3QnWXN8S79r1BLfTUVtWeACv
         Ytz7EYumDEeNdGE81TTu/1YFkWU+2Rl2uV8Duq37Ck9d2Q5X6aSErvR02/rI3/Rb+W5O
         UszJQ8scHE5CRjYVpxoRi48Msq5W35RWxzSdF/hLoR2KyNDAG+LdSs2yaCfgNklOTq82
         IefL+4eFA44dLR9kda2dv7x25IrNOUWpyf6J4KOnRsAU1HaJMBFDaK1yNfIUKM+oL63L
         sQjyIYeM4bQicwWjpxTrro7stWswsEH3mK/ysXIH1Jk5LLP1QXHPaNtvA4v0LA7vqyLB
         Z/KA==
X-Gm-Message-State: APjAAAWVCy9+BwVzOo/E2X/JD3Ju96MYBQU0rCHk+5yZ/IIosQ6TnEGp
        qvZZu10INwoz1grRgRCoGjEYrZxZ+Bo20Dp9Z9w=
X-Google-Smtp-Source: APXvYqySCIIJhmq37z2RmNr9z8yiBAXyw7CW1K6vEWy4ZznnC+5H7VxR1Ka5yEdaSUvZOZLzggXFQJjBnmoRjX7gQ38=
X-Received: by 2002:a17:906:9501:: with SMTP id u1mr12014650ejx.113.1581540473965;
 Wed, 12 Feb 2020 12:47:53 -0800 (PST)
MIME-Version: 1.0
References: <20200212200555.2393-1-f.fainelli@gmail.com>
In-Reply-To: <20200212200555.2393-1-f.fainelli@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 12 Feb 2020 22:47:43 +0200
Message-ID: <CA+h21hpG5y1D2d53P7KK6X5uBFxoSQ_iCs3rRAJe61yxfWWAPA@mail.gmail.com>
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

Hi Florian,

On Wed, 12 Feb 2020 at 22:06, Florian Fainelli <f.fainelli@gmail.com> wrote=
:
>
> VLAN ID 0 is special by all kinds and is really meant to be the default
> ingress and egress untagged VLAN. We were not configuring it that way
> and so we would be ingress untagged but egress tagged.
>
> When our devices are interfaced with other link partners such as switch
> devices, the results would be entirely equipment dependent. Some
> switches are completely fine with accepting an egress tagged frame with
> VLAN ID 0 and would send their responses untagged, so everything works,
> but other devices are not so tolerant and would typically reject a VLAN
> ID 0 tagged frame.

Are you sure that it's not in fact those devices that are not doing
what they're supposed to? VID 0 should be sent as tagged and no port
membership checks should be enforced on it.

>
> Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implement=
ation")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Hi all,
>
> After looking at all DSA drivers and how they implement port_vlan_add()
> I think this is the right change to do, but would appreciate if you
> could test this on your respective platforms to ensure this is not
> problematic.

I'm pretty sure this is problematic, for the simple reason that with
this change, DSA is insisting that the default PVID is 0, contrary to
the bridge core which insists it is 1. And some switches, like the
Microchip Ocelot/Felix, don't support more than 1 egress-untagged
VLAN, so adding one of the VIDs 0 or 1 will fail (I don't know the
exact order off-hand). See 1c44ce560b4d ("net: mscc: ocelot: fix
vlan_filtering when enslaving to bridge before link is up") for more
details of how that is going to work.

>
> Thank you
>
>
>  net/dsa/slave.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 088c886e609e..d3a2782eb94d 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1100,6 +1100,7 @@ static int dsa_slave_vlan_rx_add_vid(struct net_dev=
ice *dev, __be16 proto,
>  {
>         struct dsa_port *dp =3D dsa_slave_to_port(dev);
>         struct bridge_vlan_info info;
> +       u16 flags =3D 0;
>         int ret;
>
>         /* Check for a possible bridge VLAN entry now since there is no
> @@ -1118,7 +1119,13 @@ static int dsa_slave_vlan_rx_add_vid(struct net_de=
vice *dev, __be16 proto,
>                         return -EBUSY;
>         }
>
> -       ret =3D dsa_port_vid_add(dp, vid, 0);
> +       /* VLAN ID 0 is special and should be the default egress and ingr=
ess
> +        * untagged VLAN, make sure it gets programmed as such.
> +        */
> +       if (vid =3D=3D 0)
> +               flags =3D BRIDGE_VLAN_INFO_PVID | BRIDGE_VLAN_INFO_UNTAGG=
ED;

IEEE 802.1Q-2018, page 247, Table 9-2=E2=80=94Reserved VID values:

The null VID. Indicates that the tag header contains only priority
information; no VID is
present in the frame. This VID value shall not be configured as a PVID
or a member of a VID
Set, or configured in any FDB entry, or used in any Management operation.

> +
> +       ret =3D dsa_port_vid_add(dp, vid, flags);
>         if (ret)
>                 return ret;
>
> --
> 2.17.1
>

Is this a test?

Regards,
-Vladimir
