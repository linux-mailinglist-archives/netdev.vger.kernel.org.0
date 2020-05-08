Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75B41CAC9E
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 14:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbgEHMy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 08:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730267AbgEHMyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 08:54:55 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64D3C05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 05:54:54 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id pg17so1201336ejb.9
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 05:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4O2/jwjil81qZEZ040WaOv1zGupbZ5XbhqVZTMLA9tg=;
        b=cwP4yVJL7IEFWT8necj+HWEItoXzW6FvvKy9cQxVUOApIA2gvoiep8YkdTtb+nYRZP
         Lc6u35RNlX2rSRniicgcNUnCHr91L9k5YL/i3f0s+c1vQN/H7K+SunX2ZuV2e9PCWLkR
         tISot3sbJDCh9oEcgjGskqnvX72qOq7PKdc5TT5imY3ifWQ+Ob25QUtBsU8du6WPMeDK
         lhZElbGgOkueMs1N0SGy9zypDreYrmstgCZMZHNMsCdgLAzsPNu3nJnIKfFL8196lyGd
         /uidsVjgudoDUX0dnIM11qtx4S+VUt42EzzS+dNhU2AjkIIjHz3DyubWbqxgzPto4VMs
         rd9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4O2/jwjil81qZEZ040WaOv1zGupbZ5XbhqVZTMLA9tg=;
        b=G5IFEVX6772eijmz9EEz7V1EuJEXlD37eFvB2Cl6xhGEuR1KpV3H1R7g91D4WXUOpf
         2UWaTyAo5+Qw7WIa433JJh9XWXLOSYFZEkgczxfL+5m2Tgd/41LyPEhCfz4eeKMtzS8/
         cuUfW/0hc69XiQp0JS4RLEi7YT0aQ7yf3lvHOmoU/2osDAoQOQKSLIhqfwBjbv+Gs4Po
         zuxJG1gW8Vr4GwWN4nqHsyaGuyqTvYJeHlFTRMMkWcGfTIELH3gGWumEf8SB6p6iMwN1
         T5rAtDL9rrhcNHzuzXSec7xdr+f+W5A53Nyksh9aPl4Mk7WolgMLOH/tBgwE85oGw5bi
         OZ4A==
X-Gm-Message-State: AGi0PuYSSydJhQy4/7YJj+6Vqicjr6t0pgcacDGzEkPac2t8QCIItwpk
        xJxt6b1/Lq1dst1u8V6EifUZ4ew3tN5mLur4Efs=
X-Google-Smtp-Source: APiQypLCrt+RbBwhHLLT+qCuP9yT5SrdRPlQZxBzpYV4iFdf0ArWy1F49bn1d68jC4wa0+jbj4Y+5zCw6vKPG5eX4B0=
X-Received: by 2002:a17:906:a2c9:: with SMTP id by9mr1715697ejb.176.1588942493097;
 Fri, 08 May 2020 05:54:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200503221228.10928-1-olteanv@gmail.com> <20200503221228.10928-3-olteanv@gmail.com>
 <d4e0a8cf-a059-ff41-8e3e-0bd1fd7b0523@gmail.com>
In-Reply-To: <d4e0a8cf-a059-ff41-8e3e-0bd1fd7b0523@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 8 May 2020 15:54:42 +0300
Message-ID: <CA+h21hoEwN5zfmFnvfd2EpFEsmu-2BGGDie6DSeLzxfSkbX1Sw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: permit cross-chip bridging
 between all trees in the system
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Mingkai Hu <mingkai.hu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

Thank you so much for the review!

On Fri, 8 May 2020 at 06:16, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 5/3/2020 3:12 PM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > One way of utilizing DSA is by cascading switches which do not all have
> > compatible taggers. Consider the following real-life topology:
> >
> >       +---------------------------------------------------------------+
> >       | LS1028A                                                       |
> >       |               +------------------------------+                |
> >       |               |      DSA master for Felix    |                |
> >       |               |(internal ENETC port 2: eno2))|                |
> >       |  +------------+------------------------------+-------------+  |
> >       |  | Felix embedded L2 switch                                |  |
> >       |  |                                                         |  |
> >       |  | +--------------+   +--------------+   +--------------+  |  |
> >       |  | |DSA master for|   |DSA master for|   |DSA master for|  |  |
> >       |  | |  SJA1105 1   |   |  SJA1105 2   |   |  SJA1105 3   |  |  |
> >       |  | |(Felix port 1)|   |(Felix port 2)|   |(Felix port 3)|  |  |
> >       +--+-+--------------+---+--------------+---+--------------+--+--+
> >
> > +-----------------------+ +-----------------------+ +-----------------------+
> > |   SJA1105 switch 1    | |   SJA1105 switch 2    | |   SJA1105 switch 3    |
> > +-----+-----+-----+-----+ +-----+-----+-----+-----+ +-----+-----+-----+-----+
> > |sw1p0|sw1p1|sw1p2|sw1p3| |sw2p0|sw2p1|sw2p2|sw2p3| |sw3p0|sw3p1|sw3p2|sw3p3|
> > +-----+-----+-----+-----+ +-----+-----+-----+-----+ +-----+-----+-----+-----+
> >
> > The above can be described in the device tree as follows (obviously not
> > complete):
> >
> > mscc_felix {
> >       dsa,member = <0 0>;
> >       ports {
> >               port@4 {
> >                       ethernet = <&enetc_port2>;
> >               };
> >       };
> > };
> >
> > sja1105_switch1 {
> >       dsa,member = <1 1>;
> >       ports {
> >               port@4 {
> >                       ethernet = <&mscc_felix_port1>;
> >               };
> >       };
> > };
> >
> > sja1105_switch2 {
> >       dsa,member = <2 2>;
> >       ports {
> >               port@4 {
> >                       ethernet = <&mscc_felix_port2>;
> >               };
> >       };
> > };
> >
> > sja1105_switch3 {
> >       dsa,member = <3 3>;
> >       ports {
> >               port@4 {
> >                       ethernet = <&mscc_felix_port3>;
> >               };
> >       };
> > };
> >
> > Basically we instantiate one DSA switch tree for every hardware switch
> > in the system, but we still give them globally unique switch IDs (will
> > come back to that later). Having 3 disjoint switch trees makes the
> > tagger drivers "just work", because net devices are registered for the
> > 3 Felix DSA master ports, and they are also DSA slave ports to the ENETC
> > port. So packets received on the ENETC port are stripped of their
> > stacked DSA tags one by one.
> >
> > Currently, hardware bridging between ports on the same sja1105 chip is
> > possible, but switching between sja1105 ports on different chips is
> > handled by the software bridge. This is fine, but we can do better.
> >
> > In fact, the dsa_8021q tag used by sja1105 is compatible with cascading.
> > In other words, a sja1105 switch can correctly parse and route a packet
> > containing a dsa_8021q tag. So if we could enable hardware bridging on
> > the Felix DSA master ports, cross-chip bridging could be completely
> > offloaded.
> >
> > Such as system would be used as follows:
> >
> > ip link add dev br0 type bridge && ip link set dev br0 up
> > for port in sw0p0 sw0p1 sw0p2 sw0p3 \
> >           sw1p0 sw1p1 sw1p2 sw1p3 \
> >           sw2p0 sw2p1 sw2p2 sw2p3; do
> >       ip link set dev $port master br0
> > done
> >
> > The above makes switching between ports on the same row be performed in
> > hardware, and between ports on different rows in software. Now assume
> > the Felix switch ports are called swp0, swp1, swp2. By running the
> > following extra commands:
> >
> > ip link add dev br1 type bridge && ip link set dev br1 up
> > for port in swp0 swp1 swp2; do
> >       ip link set dev $port master br1
> > done
> >
> > the CPU no longer sees packets which traverse sja1105 switch boundaries
> > and can be forwarded directly by Felix. The br1 bridge would not be used
> > for any sort of traffic termination.
>
> Is there anything that prevents br1 from terminating traffic though
> (just curious)?
>

Well, one obvious limitation is the fact that to support termination
on br1, the bridge rx_handler would have to steal packets from DSA
software RX processing path. We just need the upstream switch to
forward packets in hardware between ports that are DSA masters, so the
choice was to at least permit that.
So given the fact that now we have a dummy rx_handler on br1, it _can_
not terminate any traffic.

For the particular hardware layout presented above, the choice was to
let the user bridge the Felix ports. Functionally it is optional
(sja1105 ports are still bridged both ways), but the data paths are
different:
- if br1 doesn't exist, then a packet that needs to go from sw1p0 to
sw2p0 is bridged in software by br0 (because Felix is not bridged, all
of its traffic goes to the CPU, then the rules on br0 kick in, and
this reinjects the packet to sw2p0, which calls dev_queue_xmit to
Felix port 2, which calls dev_queue_xmit to the one and only ENETC
master).
- If br1 exists and we want to forward packets along the same route
(sw1p0 -> sw2p0), then br0 only defines the forwarding domain to which
packets are allowed to go to. There would initially be one duplicate,
when Felix floods the first packet to the CPU _and_ to its other port
(the DSA master of sw2p0), because the packet sent to the stack will
still get software-bridged and re-enqueued just as in the case above.
But for further packets, Felix will no longer flood packets to the
CPU, but just to the other switch. On that end, the other switch will
look at the dsa_8021q tag and decide which ports are allowed to see
the packet and which aren't (these are the "crosschip links" that
depend on which ports are part of br0).

So to answer your question, we never need to terminate traffic on br1
because it only serves as double duty for br0 (accelerating its
forwarding path).
The alternative would have been to build some sja1105 awareness in
Felix of some sorts. The question, of course, is when can the Felix
driver automatically decide that its DSA masters can be bridged
together? And if we take an "automatic decision" route, is it sane
that Felix ports 1 and 2 are forwarding packets autonomously between
them, even though there is no Linux bridge that asked for that?

On the other hand, we may imagine a few situations where things might
look differently.
Let's say Felix had 4 ports, but sja1105 switches were hanging off of
only 3 of its ports. The 4th interface goes straight to a copper port.
If sw1p0 wants to talk to the copper port of Felix, how can we model
that, and what are the chances of it working in hardware?
Spoiler alert, it won't work purely in hardware, because the copper
port would see the unpopped dsa_8021q headers coming from sw1p0.
But we can still put sw1p0 and Felix port 4 in the same br0 interface,
and packets from sw1p0 would go to the CPU, where a new packet would
be forwarded to Felix port 4 without the dsa_8021q tag of sw1p0.
So bridging a Felix standalone (not DSA master) interface with a
sja1105 interface could work under some circumstances (through
software bridging), but that is non-ideal, so as long as the DSA
master switch doesn't have any understanding of the DSA headers it's
transporting, it's simply easier to not do that :) and design boards
where there's a sja1105 switch hanging off of every used Felix port.

But what if we build a super-Felix switch in the future, that
understands the DSA tags of the switches cascaded beneath it? Let's
treat this "super-Felix" in the generic case where it's not a DSA
device. Currently DSA only means that it has an Ethernet connection
towards the system, so its I/O is performed indirectly. But
"super-Felix" can be a pure switchdev device just as well, we need to
think about this situation in a generic way.
The point is just that "super-Felix" has awareness of the DSA tags of
switches beneath it. It can listen for "change upper" events for
bridging, and it can detect when its standalone copper port 4 gets
added to the same bridge as one such downstream switch that it can
understand.
So in that case, the "super-Felix" switch can do some magic in the
background: it can permit hardware bridging of its copper port 4 with
a downstream sja1105 hanging off of its port 0. Based on the topology
described in the device tree, packets sent to the sja1105 would
contain a DSA tag, and packets sent to the copper port wouldn't. From
a user perspective, things would "just work".

I know the data flow sja1105 <-> super-Felix copper port 4 that I just
described is different than what this patch set is providing. With
current Felix, this data flow is not even possible in hardware. But I
would like to look forward and imagine, with that super-Felix, if br1
would still be necessary for the simple case where we're bridging
sw1p0 with sw2p0. I think it would still be necessary, because there's
still no "natural" place for super-Felix to listen on "change upper"
events of the DSA net devices below it. That's the dilemma I'm having,
but it looks like br1 between masters is still the way to go, and that
model won't change regardless of whether the parent switchdev driver
is DSA-aware or not.

I would like to get some more feedback on this.

> >
> > For this to work, we need to give drivers an opportunity to listen for
> > bridging events on DSA trees other than their own, and pass that other
> > tree index as argument. I have made the assumption, for the moment, that
> > the other existing DSA notifiers don't need to be broadcast to other
> > trees. That assumption might turn out to be incorrect. But in the
> > meantime, introduce a dsa_broadcast function, similar in purpose to
> > dsa_port_notify, which is used only by the bridging notifiers.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> --
> Florian

Thanks,
-Vladimir
