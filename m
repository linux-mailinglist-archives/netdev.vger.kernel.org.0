Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1513F3068BA
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhA1Ai6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbhA1Aij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 19:38:39 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48902C061573;
        Wed, 27 Jan 2021 16:37:58 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id n6so4632522edt.10;
        Wed, 27 Jan 2021 16:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cFO42pMT8bS+tWPa+1Bbyz+n0QbbGo13GEuABZgxgpw=;
        b=ovEdX4fRoNvli/YPLFDvv/ku4NzfehiqFiLpDVWI2NGPeSZrP9i/Og5qCaGWt79khr
         3UXlpcAu+jJOmPDZrGzK/84EHXyPK8xyk1o+FQbYks+xgqLe+2ql0d8CDiEDe48NicJ3
         1e+1vloRlEkK2LCnexC/PJeNLZemIqU9w8HsoYM7vK1acNkFmywE+OCFPtw+mxdLwf9K
         OeU4tLVyAGRkRWlKlJ7qqYPvLvF7ijjQb3+ocFwlgq/beDHqbVbeKlDspey7UKMY64e+
         ZU0tSi1hAp9J82eRr4xvBdo9OtU3CrNpg3j66LkK//5Lw+gmLtz+NqxpY43lLklX4Ffl
         vbMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cFO42pMT8bS+tWPa+1Bbyz+n0QbbGo13GEuABZgxgpw=;
        b=NYdO0U3EY50dtHGCUqwj4a2OycAa3mUqQRfKmyhc/TpXn3gJ5cmNCcbdo6Ycmm6VSa
         lSW32AOBjaXW15Zx8kp7Bz4Pqua+p+Rn/eMkx3wlJ6TFtI6rpUl1CKbGey8zaRliNNdA
         Q76iGaYfB1ihVzLc+tr699RHpz5ODOSLRV5osSUn3aHU9yibrthY2RjEpdhwH5D33anj
         tXAb3Lfw4zUsHRAD42x7/A+iShphKdbbraR8TU2YosNRsNq/JpN7L7VJRabnVgt03LvD
         v5yWkzkY4DNEa16XsAx/SI2Df9oaSVGZpLypoCNWfCiREYgTf7ul9957ucr7yrsLeWfA
         3uWg==
X-Gm-Message-State: AOAM531wc/OGx3HYMwRDFeyNP/P5qjULUvDXSXzOoCemQS1TIG+PBpk8
        djbaXfJ+dfZlbmam0FKSKa0=
X-Google-Smtp-Source: ABdhPJwP1+WwA/nz4lEKzof0UtNtQvawnvoA05iBFwTzpJnp/wpBrp31jmH7fx/nfRYfHPocXswNCA==
X-Received: by 2002:a05:6402:4252:: with SMTP id g18mr11796672edb.231.1611794276797;
        Wed, 27 Jan 2021 16:37:56 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id e11sm1534515ejz.94.2021.01.27.16.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 16:37:56 -0800 (PST)
Date:   Thu, 28 Jan 2021 02:37:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?UGF3ZcWC?= Dembicki <paweldembicki@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Linus Wallej <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dsa: vsc73xx: add support for vlan filtering
Message-ID: <20210128003755.am4onc5d2xtmu2la@skbuf>
References: <20210120063019.1989081-1-paweldembicki@gmail.com>
 <20210121224505.nwfipzncw2h5d3rw@skbuf>
 <CAJN1KkyCopZLzHc76GC9fi4nPf_y52syKZHQ1J4zbx7Z9sauyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJN1KkyCopZLzHc76GC9fi4nPf_y52syKZHQ1J4zbx7Z9sauyQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pawel,

On Mon, Jan 25, 2021 at 08:17:04AM +0100, Paweł Dembicki wrote:
> > What are the issues that are preventing you from getting rid of
> > DSA_TAG_PROTO_NONE? Not saying that making the driver VLAN aware is a
> > bad idea, but maybe also adding a tagging driver should really be the
> > path going forward. If there are hardware issues surrounding the native
> > tagging support, then DSA can make use of your VLAN features by
> > transforming them into a software-defined tagger, see
> > net/dsa/tag_8021q.c. But using a trunk CPU port with 8021q uppers on top
> > of the DSA master is a poor job of achieving that.
> 
> I was planning to prepare tagging for the next step. Without VLAN
> filtering and/or tagging it is usable only as a full bridge.
> Vsc73xx devices support QinQ. I can use double tagging for port
> separation, but then it's impossible to filter vlans.
> So, I'm planning to start working with tagging based on
> net/dsa/tag_8021q.c. Should I wait with this patch and send the
> corrected version with tagging support?

I was going to send a patch some time to the DSA documentation, maybe it
clarifies some of your options.

Dealing with switches without hardware support for DSA tags
===========================================================

DSA registers a network interface for each user port, and the tagging
protocol allows the network stack to redirect Ethernet frames sent and
received by the host port into Ethernet frames sent and received by each
individual switch port. In lack of a tagging protocol, DSA will register
network interfaces that are incapable of sending or receiving traffic,
and are 'dead' from the perspective of a user space process trying to
open a socket on them. This should be avoided as much as possible for
new drivers.

Individual addressing of switch ports is a necessity for:
- supporting the default configuration where ports operate as standalone
  with no bridging offload
- implementing link-layer protocols that send PDUs (STP, IEEE 1588, etc)
  when the ports offload the Linux bridge

In lack of hardware support for a tagging protocol, the switch can be
configured in other ways that uniquely mark the frames sent to the CPU
with source port information (and steer them towards the correct
destination port on transmission). There is no standardized methodology
for this approach, since it depends highly on what the hardware is able
to do.

The most basic approach is to assign each port a unique pvid (port-based
VLAN, i.e. the VLAN ID that a bridge classifies untagged traffic to) and
make the CPU port a VLAN trunk. The benefit is that each port will now
be isolated from every other port in terms of forwarding, so unique
pvids per port can also be used to implement the standalone ports mode.
This is also the drawback: when offloading the Linux bridge, forwarding
will not be allowed between ports because of the VLAN restriction
imposed by the unique pvids. A workaround to this is to add all the
other ports that are members in the same bridge into the VLAN membership
of this port's pvid, but care must be taken such that the switch is
configured to operate in shared VLAN learning mode (i.e. FDB lookup is
performed ignoring the VLAN ID, just looking at the destination MAC).

There are more drawbacks to the basic approach:
(a) it would work only for VLAN-untagged traffic. VLAN tagged traffic
    would be classified by the hardware to the VID derived from the VLAN
    header, if that is present, unless the port is configured in
    VLAN-unaware mode.
(b) if the switch port is configured in VLAN-unaware mode, it cannot
    offload a Linux bridge with vlan_filtering=1, i.e. it cannot use its
    hardware VLAN support for the bridge VLANs.

Further refinements to the basic approach are possible. VLAN retagging
rules can be used, which match on an ingress port equal to the front
panel port, an egress port equal to the CPU port, a VLAN ID equal to the
ingress VLAN ID, and which produce as a result a packet tagged with a
remapped VLAN ID that encodes not only the original VLAN, but also the
source port information. On transmission, VLAN-tagged traffic is
basically not a problem because most hardware is happy to transmit
double-tagged traffic. The drawbacks with VLAN retagging are usually
related to the limited number of retagging rules (which means that less
than the full 4096 VLAN ID range can typically be installed per port)
and, more importantly, the fact that encoding the source port
information in the 12-bit VLAN ID sent to the CPU will consume bits that
are used to encode the number of the original VLAN ID.

With enhancements to the Linux bridge code and to DSA, this limitation
can be somewhat alleviated by not adding a VLAN retagging rule for every
VLAN ID inserted into the hardware database, but just for those VLAN IDs
that are also present in the software VLAN database (installed with
"bridge vlan add dev br0 self"). The other VLANs will just allow
autonomous forwarding and no packet delivery to the CPU, which works
because a VLAN-aware bridge would drop VLAN-tagged packets if their VLAN
ID is not present in the software database anyway.

In short, the basic approach relies on port VLAN membership, and unless
VLAN retagging is used, means that a choice needs to be made regarding
whether the offload for a VLAN-aware bridge is to be supported, or DSA
tagging is to be supported.

With even more enhancements to the bridge and DSA data path, the source
port information might not even matter for the network stack when the
port is bridged, since the packet will end up in the data path of the
bridge anyway, regardless of which bridged port the packet came in
through (a notable exception to this is link-local traffic like bridge
PDUs - some switches treat link-local packets differently than normal
data ones). On transmission, the imprecise steering to the correct
egress port poses further complications, because of the flooding
implementation in the Linux bridge: a packet that is to be flooded
towards swp0, swp1 and swp2 will be cloned by the bridge once per egress
port, and each skb will be individually delivered to each net_device
driver for xmit. The bridge does not know that the packet transmission
through a DSA driver with no tagging protocol is imprecise, and instead
of delivering the packet just towards the requested egress port, that
the switch will likely flood the packet.  So each packet will end up
flooded once by the software bridge, and twice by the hardware bridge.
This can be modeled as a TX-side offload for packet flooding, and could
be used to prevent the bridge from cloning the packets in the first
place, and just deliver them once to a randomly chosen port which is
bridged.

The enhancements discussed earlier make one assumption: that link-local
traffic is to be treated separately, and that the hardware has
provisioning for decoding the source port at least for those. In fact,
link-local traffic is an issue also on transmission, since BPDUs need to
be transmitted by the network stack even towards ports that are in the
BLOCKING STP state. A tagging protocol implementation based purely on
VLAN port membership will not help with that.

A radically different implementation approach based still on VLAN IDs is
to make use of packet processing pipelines in the switch that are not
coupled with the bridging service, but work independently on a port's
ingress and egress pipeline. Typically, these are configured by the user
as an offload to tc-flower filters.

Identifying the ingress switch port can be achieved by pushing the
desired VLAN as a second, outer tag, on egress towards the CPU port.
In tc-flower pseudocode it would look like this:

$ tc qdisc add dev <cpu-port> clsact
$ for eth in swp0 swp1 swp2 swp3; do \
        tc filter add dev <cpu-port> egress flower indev ${eth} \
                action vlan push id <rxvlan> protocol 802.1ad; \
done

Other ways of pushing an outer VLAN, such as based on 802.1ad bridging,
are useless because they basically require that the port is VLAN-unaware,
which lands us in the same spot as the basic approach with port-based
VLAN membership, being unable to offload a VLAN-aware bridge.

As for steering traffic injected into the switch from the network stack,
it can be done using a combination of a redirect rule that matches on
VLAN ID, plus another VLAN pop action chained to it.

$ tc qdisc add dev <cpu-port> clsact
$ for eth in swp0 swp1 swp2 swp3; do \
        tc filter add dev <cpu-port> ingress protocol 802.1Q flower
                vlan_id <txvlan> action vlan pop \
                action mirred egress redirect dev ${eth}; \
done

But since DSA does not register network interfaces for the CPU port,
this configuration would be impossible for the user to do. So this
configuration, if supported by the hardware, should be done privately
by the driver.

The advantage is that since the packet processing pipeline is not
coupled with the bridging service, then a VLAN-aware Linux bridge can
still be offloaded. The drawback is that chances are low for a switch to
not have hardware support for a tagging protocol, but to support a
programmable packet pipeline, which may make the idea impractical.

----------------------------

So there you have it, this is my trainwreck of thoughts, you should
think about the use cases you need and choose appropriately. It is
unfortunately not easy and you will need to find compromises.

Finally, it may be that the switch is not really a DSA switch (you can
be certain that this is the case if you can't even decode link-local
traffic, or inject link-local traffic into a BLOCKING port) and you are
doing it a disservice by treating it like one.
Non-DSA switches are devices that have non-Ethernet based methods of
sending and receiving packets.

> > Can you please rebase your work on top of the net-next/master branch?
> > You will see that the API has changed.
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
> >
> > > +
> > > +static void vsc73xx_port_vlan_add(struct dsa_switch *ds, int port,
> > > +                               const struct switchdev_obj_port_vlan *vlan)
> > > +{
> > > +     bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
> > > +     bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
> > > +     struct vsc73xx *vsc = ds->priv;
> > > +     int ret;
> > > +     u32 tmp;
> > > +
> > > +     if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
> > > +             return;
> >
> > Sorry, but no. You need to support the case where the bridge (or 8021q
> > module) adds a VLAN even when the port is not enforcing VLAN filtering.
> > See commit:
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=0ee2af4ebbe3c4364429859acd571018ebfb3424
> >
> > > +
> > > +     ret = vsc73xx_port_update_vlan_table(ds, port, vlan->vid_begin,
> > > +                                          vlan->vid_end, 1);
> > > +     if (ret)
> > > +             return;
> > > +
> > > +     if (untagged && port != CPU_PORT) {
> > > +             /* VSC73xx can have only one untagged vid per port. */
> > > +             vsc73xx_read(vsc, VSC73XX_BLOCK_MAC, port,
> > > +                          VSC73XX_TXUPDCFG, &tmp);
> > > +
> > > +             if (tmp & VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA)
> > > +                     dev_warn(vsc->dev,
> > > +                              "Chip support only one untagged VID per port. Overwriting...\n");
> >
> > Just return an error, don't overwrite, this leaves the bridge VLAN
> > information out of sync with the hardware otherwise, which is not a
> > great idea.
> >
> 
> But it's a void return function. It always will be out of sync after
> the second untagged VID attemption.
> Should I give warning without changing untagged vlan?

If you had checked the updated API, you'd have noticed that the function
no longer returns void.
