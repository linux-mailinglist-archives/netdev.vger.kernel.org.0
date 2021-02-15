Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D4931C09E
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 18:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhBOR3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 12:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbhBOR2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 12:28:11 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0247DC061756
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 09:19:51 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id n13so5813771ejx.12
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 09:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y5NXrIkCwTPF25BLyiCpY7B1ZD/dsJSHCzHJOjFe1K0=;
        b=FoPZ9UhxPvP0OM+MtnISeUkwEYHzliFJQGzXHk2+uPmr0zcqI13QCe1iIkTuYZef7X
         8Jp8LKEUNX39d+7V6ib4ghew+fLQf18H5gorAXmjko31YADV5JTXT/hcFXUBQbFprIo3
         CYpyPyIs7nw19psM+uHf5JY4Rh0v7OsBnO9oVjKZxkT5s/V/3Q3axKZ0JeDZawZUyJuE
         EaeNHv5goHWMdFzGJGQcd2Di5kYJPHuX/yhQXyygMECsLzksTDlE6NaniwaKPGFZdKZO
         ufS696dRqrIHLcBi7RchhyouzAOQUQByo65wADtdq293F58y5nRD9tgC4qXi6bDShONY
         aVZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y5NXrIkCwTPF25BLyiCpY7B1ZD/dsJSHCzHJOjFe1K0=;
        b=iXXNdCtC7oK+brcFXLmJwDS3zyS/2BoL6z6g+gW16tq43cpywSbl+D9v3HnFgy3SbP
         Z/rI/sBxMcCMwocEYjj4SnF9Ykq9eWJgwQaSbsc+9E/o5eSSemvm5tZQD2ujvvfr4IyT
         wvq8Y8QZ3HJ/6uk4CxX99KuIphYYa/0/iiNL6YyNB2VKh9GORLkVW8eHwzREXYDkg9Cp
         /HronlaiqHxACOQezHW0JD3mA5mgVh00PpL9WEERCcvk3ndzi9I7UZoBxmN4crdpX/Ha
         7lkm3Zvk9Ayn+B9XpnjDSWX74k3wfoNjm0dpHMY+7Vv9x8diUQoDX+6tZR87Ll6jfCtx
         VgSg==
X-Gm-Message-State: AOAM533QS062ycrOPzooh6Rbenu44pnZ9k+F5OP/PtnJzKMAhT9syyWw
        2knqABRdjZiD2HR1mM0bSP86yaORDWg=
X-Google-Smtp-Source: ABdhPJwByVTNWRZsnWTH1JiFeiSt3W1tuVg1Ixwu3kA/Mn6S+pY8Qbfr7BVjKquEiCGqa4ShOHUvAA==
X-Received: by 2002:a17:906:c08e:: with SMTP id f14mr17352168ejz.388.1613409589507;
        Mon, 15 Feb 2021 09:19:49 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f6sm4014667edt.48.2021.02.15.09.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 09:19:49 -0800 (PST)
Date:   Mon, 15 Feb 2021 19:19:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH net-next 4/4] net: dsa: don't set skb->offload_fwd_mark
 when not offloading the bridge
Message-ID: <20210215171947.lvn44gb2rkeozlv7@skbuf>
References: <20210214155326.1783266-1-olteanv@gmail.com>
 <20210214155326.1783266-5-olteanv@gmail.com>
 <CAFSKS=OryZKixT7d-7tqdwZCpqQT1PaYCt52PuZYr71F3a1gSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=OryZKixT7d-7tqdwZCpqQT1PaYCt52PuZYr71F3a1gSg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi George,

On Mon, Feb 15, 2021 at 09:48:38AM -0600, George McCollister wrote:
> On Sun, Feb 14, 2021 at 9:54 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> [snip]
> > diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
> > index 858cdf9d2913..215ecceea89e 100644
> > --- a/net/dsa/tag_xrs700x.c
> > +++ b/net/dsa/tag_xrs700x.c
> > @@ -45,8 +45,7 @@ static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev,
> >         if (pskb_trim_rcsum(skb, skb->len - 1))
> >                 return NULL;
> >
> > -       /* Frame is forwarded by hardware, don't forward in software. */
> > -       skb->offload_fwd_mark = 1;
> > +       dsa_default_offload_fwd_mark(skb);
>
> Does it make sense that the following would have worked prior to this
> change? Is this only an issue for bridging between DSA ports when
> offloading is supported? lan0 is a port an an xrs700x switch:
>
> ip link set eth0 up
> ip link del veth0
> ip link add veth0 type veth peer name veth1
>
> for eth in veth0 veth1 lan1; do
>     ip link set ${eth} up
> done
> ip link add br0 type bridge
> ip link set veth1 master br0
> ip link set lan1 master br0
> ip link set br0 up
>
> ip addr add 192.168.2.1/24 dev veth0
>
> # ping host connected to physical LAN that lan0 is on
> ping 192.168.2.249 (works!)
>
> I was trying to come up with a way to test this change and expected
> this would fail (and your patch) would fix it based on what you're
> described.

No, the configuration you've shown should be supported and functional
already (as you've noticed, in fact). I call it 'bridging with a
foreign interface', where a foreign interface is a bridge port that has
a different switchdev mark compared to the DSA switch. A switchdev mark
is a number assigned to every bridge port by nbp_switchdev_mark_set,
based on the "physical switch id"*.

There is a simple rule with switchdev: on reception of an skb, the bridge
checks if it was marked as 'already forwarded in hardware' (checks if
skb->offload_fwd_mark == 1), and if it is, it puts a mark of its own on
that skb, with the switchdev mark of the ingress port. Then during
forwarding, it enforces that the egress port must have a different switchdev
mark than the ingress one (this is done in nbp_switchdev_allowed_egress).

The veth driver does not implement any sort of method for retrieving a
physical switch id (neither devlink nor .ndo_get_port_parent_id),
therefore the bridge assigns it a switchdev mark of 0, and packets
coming from it will always have skb->offload_fwd_mark = 0. So there
aren't any restrictions.

Problems appear as soon as software bridging is attempted between two
interfaces that have the same switchdev mark. If skb->offload_fwd_mark=1,
the bridge will say that forwarding was already performed in hw, so it
will deny it in sw.
The issue is that a bond0 (or hsr0) upper of lan0 will be assigned the
same switchdev mark as lan0 itself, because the function that assigns
switchdev marks to bridge ports, nbp_switchdev_mark_set, recurses
through that port's lower interfaces until it finds something that
implements devlink.

What I tested is actually pretty laughable and a far cry from a
real-life scenario: I commented out the .port_bridge_join and
.port_bridge_leave methods of a driver and made sure that forwarding
between ports still works regardless of what uppers they have
(even that used not to). But this bypasses the switchdev mark checks in
nbp_switchdev_allowed_egress because the skb->offload_fwd_mark=0 now.
This is an important prerequisite for seamless operation, true, but it
isn't quite what we want. For one thing, we may have a topology like
this:

         +-- br0 -+
        /   / |    \
       /   /  |     \
      /   /   |      \
     /   /    |       \
    /   /     |        \
   /    |     |       bond0
  /     |     |      /    \
 swp0  swp1  swp2  swp3  swp4

where it is desirable that the presence of swp3 and swp4 under a
non-offloaded LAG does not preclude us from doing hardware bridging
beteen swp0, swp1 and swp2.

But this creates an impossible paradox if we continue in the way that I
started in this patch.

When the CPU receives a packet from swp0 (say, due to flooding), the
tagger must set skb->offload_fwd_mark to something.

If we set it to 0, then the bridge will forward it towards swp1, swp2
and bond0. But the switch has already forwarded it towards swp1 and
swp2 (not to bond0, remember, that isn't offloaded, so as far as the
switch is concerned, ports swp3 and swp4 are not looking up the FDB, and
the entire bond0 is a destination that is strictly behind the CPU). But
we don't want duplicated traffic towards swp1 and swp2, so it's not ok
to set skb->offload_fwd_mark = 0.

If we set it to 1, then the bridge will not forward the skb towards the
ports with the same switchdev mark, i.e. not to swp1, swp2 and bond0.
Towards swp1 and swp2 that's ok, but towards bond0? It should have
forwarded the skb there.

An actual solution to this problem, which has nothing to do with my
series, is to give the bridge more hints as to what switchdev mark it
should use for each port.

Currently, the bridging offload is very 'silent': a driver registers a
netdevice notifier, which is put on the netns's notifier chain, and
which sniffs around for NETDEV_CHANGEUPPER events where the upper is a
bridge, and the lower is an interface it knows about (one registered by
this driver, normally). Then, from within that notifier, it does a bunch
of stuff behind the bridge's back, without the bridge necessarily
knowing that there's somebody offloading that port. It looks like this:

     ip link set lan0 master br0
                  |
                  v
   bridge calls netdev_master_upper_dev_link
                  |
                  v
        call_netdevice_notifiers
                  |
                  v
       dsa_slave_netdevice_event
                  |
                  v
        oh, hey! it's for me!
                  |
                  v
           .port_bridge_join

What we should probably do to solve the conundrum is to be less silent,
and emit a notification back. Something like this:

     ip link set lan0 master br0
                  |
                  v
   bridge calls netdev_master_upper_dev_link
                  |
                  v                    bridge: Aye! I'll use this
        call_netdevice_notifiers           ^  switch_id as the
                  |                        |  switchdev mark for
                  v                        |  this port, and zero
       dsa_slave_netdevice_event           |  if I got nothing.
                  |                        |
                  v                        |
        oh, hey! it's for me!              |
                  |                        |
                  v                        |
           .port_bridge_join               |
                  |                        |
                  +------------------------+
      call_switchdev_notifiers(lan0, SWITCHDEV_BRPORT_OFFLOADED, switch_id)

Then stacked interfaces (like bond0 on top of swp3/swp4) would be
treated differently in DSA, depending on whether we can or cannot
offload them.

The offload case:

    ip link set bond0 master br0
                  |
                  v
   bridge calls netdev_master_upper_dev_link
                  |
                  v                    bridge: Aye! I'll use this
        call_netdevice_notifiers           ^  switch_id as the
                  |                        |  switchdev mark for
                  v                        |        bond0.
       dsa_slave_netdevice_event           | Coincidentally (or not),
                  |                        | bond0 and swp0, swp1, swp2
                  v                        | all have the same switchdev
        hmm, it's not quite for me,        | mark now, since the ASIC
         but my driver has already         | is able to forward towards
           called .port_lag_join           | all these ports in hw.
          for it, because I have           |
      a port with dp->lag_dev == bond0.    |
                  |                        |
                  v                        |
           .port_bridge_join               |
           for swp3 and swp4               |
                  |                        |
                  +------------------------+
      call_switchdev_notifiers(bond0, SWITCHDEV_BRPORT_OFFLOADED, switch_id)

And the non-offload case:

    ip link set bond0 master br0
                  |
                  v
   bridge calls netdev_master_upper_dev_link
                  |
                  v                    bridge waiting:
        call_netdevice_notifiers           ^  huh, no SWITCHDEV_BRPORT_OFFLOADED
                  |                        |  event, okay, I'll use a switchdev
                  v                        |  mark of zero for this one.
       dsa_slave_netdevice_event           :  Then packets received on swp0 will
                  |                        :  not be forwarded towards swp1, but
                  v                        :  they will towards bond0.
         it's not for me, but
       bond0 is an upper of swp3
      and swp4, but their dp->lag_dev
       is NULL because they couldn't
            offload it.

This is what I should have really done. For some reason though, I was so
trigger-happy that I got the data path working (without the surrounding
control logic to manage the switchdev marks automatically) that I just
got carried away and sent this small patch set.

I need some time to take my mind off of this for a while, and then I'll
come with a serious proposal eventually. Sorry again for the confusion.


*This is retrieved, in DSA's case, through the "switch_id" attribute
that we populate in dsa_port_devlink_setup. DSA says that the entire
DSA switch tree dst has the same switch_id, because it assumes that any
driver capable of cross-chip bridging (aka Marvell) is able to do
hardware forwarding towards any other switch in the same "switching
fabric". So it's not really a "switch_id", but a "port parent" somehow.
