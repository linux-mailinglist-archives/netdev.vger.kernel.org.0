Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033D339CE70
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 11:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhFFJkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 05:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhFFJkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 05:40:13 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3285DC061766;
        Sun,  6 Jun 2021 02:38:16 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id u24so16447186edy.11;
        Sun, 06 Jun 2021 02:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+VsLb3D4D5tJz7YivS4JKplQGmag6ktRv8w8ANpqKuI=;
        b=P67kmTb7LeFSwMncOP6SEk4nhqhkmsmhiH1l8i3ooL+lhph6J60ktESYwUVRBb56jR
         QYmkeVi/OccANnpwVR1psi3N2R97UgeBDnEvaSMbKB2sn6sbrUxohxfuKfLmgpiCzRBV
         G0W4TdvWYy4IyQBNQG7l54DtvTh4RPqJexvwZjeXe4Kkz2HhZzLNt89QTMPoBmGSirF4
         av7gqC0KX5/HDY4zGu74zYfRO9Ok2e6FM2wR5yxix5KQynCiB39wDTN6M1IYU/QkvR0f
         V7azYqMAxEUPt3hXon7JCwn+IVhHZiDZ7izIWqMOmyFr/Pgn1XwkTjSdSyvhi+OGhGsu
         HlXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+VsLb3D4D5tJz7YivS4JKplQGmag6ktRv8w8ANpqKuI=;
        b=ZyINV88UxLuIE3UrZ4nUMKpW7uRMA2WipGrrvre2sQJfPtnR9OLHDzbQ/XG/AO9u5W
         Cd4PqrBWGjLfix3vhyR9q0IQLR5Gh1NY4T96f9yYROJYlpeA7j80vDQ4vndA9ROfl2Oj
         Jn7JGOmjXAFpXiFPveAi+fRAlOzTMpSEsrUdPnRU5mVKToVAM1nHJlsoK2mIgAGOdTiz
         ddpIW8cZkz40Zt/x4I3uF3EfB8DUczeLKCgzF1QlZ0PGgSHuH5MLjkxiAH9yR7A+yAWu
         uQaLeRadP1Z/waqmHTh05oXYGB5ER7WJkv8E3AwLeLBsQQnpSv+OCQ0oj3MMA+Gtmkmr
         0TBA==
X-Gm-Message-State: AOAM532hBlWr4lkkiFjvIPvahiCbiGay5cabymBug8YySLM6HhujKtyM
        pNd6ef2GD7fdjfOVivoiQpQ=
X-Google-Smtp-Source: ABdhPJwzxJJIQZ9B4Ly3MV55RnnmjYokrxhPgRUm+8RD1KOS5W0Z+c8ePU88cQeFLyTnRpiaDF+PYQ==
X-Received: by 2002:a05:6402:b89:: with SMTP id cf9mr14834549edb.198.1622972292127;
        Sun, 06 Jun 2021 02:38:12 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id kj1sm5172626ejc.10.2021.06.06.02.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 02:38:11 -0700 (PDT)
Date:   Sun, 6 Jun 2021 12:38:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Matthew Hagan <mnhagan88@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] net: dsa: tag_qca: Check for upstream VLAN
 tag
Message-ID: <20210606093810.klwyly5qqhkmfwqx@skbuf>
References: <20210605193749.730836-1-mnhagan88@gmail.com>
 <YLvgI1e3tdb+9SQC@lunn.ch>
 <ed3940ec-5636-63db-a36b-dc6c2220b51d@gmail.com>
 <20210606005335.iuqi4yelxr5irmqg@skbuf>
 <2556ab13-ae7f-ed68-3f09-7bf5359f7801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2556ab13-ae7f-ed68-3f09-7bf5359f7801@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Sat, Jun 05, 2021 at 08:34:06PM -0700, Florian Fainelli wrote:
> On 6/5/2021 5:53 PM, Vladimir Oltean wrote:
> > Hi Matthew,
> > 
> > On Sat, Jun 05, 2021 at 11:39:24PM +0100, Matthew Hagan wrote:
> >> On 05/06/2021 21:35, Andrew Lunn wrote:
> >>
> >>>> The tested case is a Meraki MX65 which features two QCA8337 switches with
> >>>> their CPU ports attached to a BCM58625 switch ports 4 and 5 respectively.
> >>> Hi Matthew
> >>>
> >>> The BCM58625 switch is also running DSA? What does you device tree
> >>> look like? I know Florian has used two broadcom switches in cascade
> >>> and did not have problems.
> >>>
> >>>     Andrew
> >>
> >> Hi Andrew
> >>
> >> I did discuss this with Florian, who recommended I submit the changes. Can
> >> confirm the b53 DSA driver is being used. The issue here is that tagging
> >> must occur on all ports. We can't selectively disable for ports 4 and 5
> >> where the QCA switches are attached, thus this patch is required to get
> >> things working.
> >>
> >> Setup is like this:
> >>                        sw0p2     sw0p4            sw1p2     sw1p4 
> >>     wan1    wan2  sw0p1  +  sw0p3  +  sw0p5  sw1p1  +  sw1p3  +  sw1p5
> >>      +       +      +    |    +    |    +      +    |    +    |    +
> >>      |       |      |    |    |    |    |      |    |    |    |    |
> >>      |       |    +--+----+----+----+----+-+ +--+----+----+----+----+-+
> >>      |       |    |         QCA8337        | |        QCA8337         |
> >>      |       |    +------------+-----------+ +-----------+------------+
> >>      |       |             sw0 |                     sw1 |
> >> +----+-------+-----------------+-------------------------+------------+
> >> |    0       1    BCM58625     4                         5            |
> >> +----+-------+-----------------+-------------------------+------------+
> > 
> > It is a bit unconventional for the upstream Broadcom switch, which is a
> > DSA master of its own, to insert a VLAN ID of zero out of the blue,
> > especially if it operates in standalone mode. Supposedly sw0 and sw1 are
> > not under a bridge net device, are they?
> 
> This is because of the need (or desire) to always tag the CPU port
> regardless of the untagged VLAN that one of its downstream port is being
> added to. Despite talking with Matthew about this before, I had not
> realized that dsa_port_is_cpu() will return true for ports 4 and 5 when
> a VLAN is added to one of the two QCA8337 switches because from the
> perspective of that switch, those ports have been set as DSA_PORT_TYPE_CPU.

It will not, the ports maintain the same roles regardless of whether
there is another switch attached to them or not. For the BCM58625
switch, ports 4 and 5 are user ports with net devices that each happen
to be DSA masters for 2 QCA8337 switches, and port 8 is the CPU port.

When a DSA user port is a DSA master for another switch, tag stacking
takes place - first the rcv() from tag_brcm.c runs, then the rcv() from
tag_qca.c runs - you taught me this, in fact.

My point is that the Broadcom switch should leave the packet in a state
where tag_qca.c can work with it without being aware that it has been
first processed by another switch. This is why I asked Matthew whether
he configured any bridging between BCM58625 ports 4 and 5, and any
bridge VLANs. I am not completely sure we should start modifying our DSA
taggers under the assumption that VLANs might just pop up everywhere -
I simply don't see a compelling use case to let that happen and justify
the complexity.

In this case, my suspicion is that the root of the issue is the
resolution from commit d965a5432d4c ("net: dsa: b53: Ensure the default
VID is untagged"). It seems like it wanted to treat VID 0 as untagged if
it's the pvid, but it only treats it as untagged in one direction.

For the network stack, I think there are checks scattered in
__netif_receive_skb_core that make it treat a skb with VID == 0 as if it
was untagged, so the fact that untagged packets are sent as egress-tagged
with VID=0 by the Broadcom CPU port (8) towards the system, and received
as VLAN-tagged by tag_brcm.c, is not that big of a problem. The problem
only appears when there is another DSA switch downstream of it, because
it shifts the expected position of the DSA tag in tag_qca.c.

DSA switch drivers don't normally send all packets as egress-tagged
towards the CPU. If they do, they ought to be more careful and not let
VLAN tags escape their tagging driver, if there was no VLAN tag to begin
with in the packet as seen on the wire.

We might make a justifiable exception in the case where DSA_TAG_PROTO_NONE
is used, but in this case, my understanding is that BCM58625 uses
DSA_TAG_PROTO_BRCM_PREPEND, so I'm not sure why sending packets towards
the CPU with VID=0 instead of untagged makes that big of a difference.

> 
> This may also mean that b53_setup() needs fixing as well while it
> iterates over the ports of the switch though I am not sure how we could
> fix that yet.
> 
> > 
> > If I'm not mistaken, this patch should solve your problem?
> 
> How about this:
> 
> diff --git a/drivers/net/dsa/b53/b53_common.c
> b/drivers/net/dsa/b53/b53_common.c
> index 3ca6b394dd5f..6dfcff9018fd 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1455,6 +1455,22 @@ static int b53_vlan_prepare(struct dsa_switch
> *ds, int port,
>         return 0;
>  }
> 
> +static inline bool b53_vlan_can_untag(struct dsa_switch *ds, int port)
> +{
> +       /* If this switch port is a CPU port */
> +       if (dsa_is_cpu_port(ds, port)) {
              this matches only for port == 8

> +               /* We permit untagging to be configured if it is the DSA
> +                * master of another switch (cascading).
> +                */
> +               if (dsa_slave_dev_check(dsa_to_port(ds, port)->master))
                                          and the master of port 8 is the "brcm,nsp-amac" controller
                      which is not a DSA slave port
> +                       return true;
> +
> +               return false;
                  so this will still return false
> +       }
> +
> +       return true;
> +}
> +
>  int b53_vlan_add(struct dsa_switch *ds, int port,
>                  const struct switchdev_obj_port_vlan *vlan,
>                  struct netlink_ext_ack *extack)
> @@ -1477,7 +1493,7 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
>                 untagged = true;
> 
>         vl->members |= BIT(port);
> -       if (untagged && !dsa_is_cpu_port(ds, port))
> +       if (untagged && b53_vlan_can_untag(ds, port))
>                 vl->untag |= BIT(port);
>         else
>                 vl->untag &= ~BIT(port);
> @@ -1514,7 +1530,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
>         if (pvid == vlan->vid)
>                 pvid = b53_default_pvid(dev);
> 
> -       if (untagged && !dsa_is_cpu_port(ds, port))
> +       if (untagged && b53_vlan_can_untag(ds, port))
          and VID 0 will still be sent as egress-tagged by the BCM58625 on port 8.
>                 vl->untag &= ~(BIT(port));
> 
>         b53_set_vlan_entry(dev, vlan->vid, vl);
> -- 
> Florian
