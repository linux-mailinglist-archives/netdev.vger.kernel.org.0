Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6186C87EB
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbjCXWAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjCXWAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:00:51 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D631589E;
        Fri, 24 Mar 2023 15:00:47 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id t10so13091736edd.12;
        Fri, 24 Mar 2023 15:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679695246;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N6cb/WvP5UEuo60Ox9JEtmaEQ0/5hQ+szbVvH7g+pJA=;
        b=lDuptsk0iEh7/cd7vHyOp6QyZzL08EdLtK+PQcl5RmLFqxL/Qg4M5nBewA7b8ZdrO/
         TzULSP8qCYq2gPP81dfasPIPsmEu23ZfLN94qkkSdY+EoURuK4wzFNWg3x9T0IfKD/cF
         MHUqSinQJT6MWR/MI11UnA5zhfzpuhJkUV/w/y54EAqA9t0VTfmKYKYTKj82P2co/jtb
         WxOGeb+SzUvEQ2k5mVwi3UZTO1yNfkXS4CK4P0H0oma5s6PbXNl9HDDwsp5AcIHLW3bu
         ah81hZSVeTwjG7A0zQ6oZG+d7xlxlrqx1sYg/h+ZveMPSZMeIbzFN2bQmBSfnqUG4oLI
         1TpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679695246;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N6cb/WvP5UEuo60Ox9JEtmaEQ0/5hQ+szbVvH7g+pJA=;
        b=KrvE8RrxYkDvaH/Jh6qxzK09USx3uEGYq9anDbChkEAykm3wLO942RM3hXK1Mr8P1B
         3En9cvAdpYMXXhUHC/ouLlMHE0YOHPjiO8+ibBF0NeIoGPnqOAvmwvNW5MrTcfGNBXIr
         guT1wjZhHdrf26FDbDx+1XGCGi1ijk2hbp5gL/52E2tU7Hg8E+eqqaz5BkEAkDim0KdN
         t17HcRse11Ov4orzWAuI5jAnNh2+nn9qdCz5o5Lk7ssRi3sP9b3kzPQiowOVtYMWCXtq
         3ttr012YD+7OGpqR0AH6bIlQCXFPkV4CVkDRrAOBZT/VGSXNeIaeKMXzWWs30ktPSQrl
         qO4Q==
X-Gm-Message-State: AAQBX9d8LxxY39wN1M78c0TR8Cr+t0zrJOWt0jvr7BpVBDDIrqI4yDiq
        0eKaS+pg/kExqEtFxpd8C5I=
X-Google-Smtp-Source: AKy350btYgvzYGTaMevFWksrBrRS8JsPuopSppHkSiS8tHxrzJTSYF/plHqcuvCZmfnYLfqnAiJ0ag==
X-Received: by 2002:a17:906:8519:b0:923:1714:b3d0 with SMTP id i25-20020a170906851900b009231714b3d0mr4257331ejx.19.1679695245540;
        Fri, 24 Mar 2023 15:00:45 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ce20-20020a170906b25400b00929fc8d264dsm10940272ejb.17.2023.03.24.15.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 15:00:45 -0700 (PDT)
Date:   Sat, 25 Mar 2023 00:00:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND net-next v4 3/3] net: dsa: rzn1-a5psw: add vlan
 support
Message-ID: <20230324220042.rquucjt7dctn7xno@skbuf>
References: <20230314163651.242259-1-clement.leger@bootlin.com>
 <20230314163651.242259-1-clement.leger@bootlin.com>
 <20230314163651.242259-4-clement.leger@bootlin.com>
 <20230314163651.242259-4-clement.leger@bootlin.com>
 <20230314233454.3zcpzhobif475hl2@skbuf>
 <20230315155430.5873cdb6@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230315155430.5873cdb6@fixe.home>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Clément,

I'm very sorry for the delay.

On Wed, Mar 15, 2023 at 03:54:30PM +0100, Clément Léger wrote:
> The documentation is public and available at [1]. Section 4.5.3 is of
> interest for your understanding of the VLAN filtering support. Let's
> hope I answered most of your questions.
> 
> [1]
> https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1l-group-users-manual-r-engine-and-ethernet-peripherals?r=1054561

Yes, indeed, it appears that you gave me this link before and I already
had the PDF downloaded, but forgot about it... I've reorganized my
documentation PDFs since then.

> > - can it drop a VLAN which isn't present in the port membership list?
> >   I guess this is what A5PSW_VLAN_DISC_SHIFT does.
> 
> Yes, A5PSW_VLAN_DISC_SHIFT stands for "discard" which means the packet
> is discarded if the port is not a member of the VLAN.
> A5PSW_VLAN_VERI_SHIFT is meant to enable VLAN lookup for packet
> flooding (instead of the default lookup).

OK. IMO, this driver should always enable VLANDISC and VLANVERI for all
ports, no matter whether under a VLAN-aware bridge or not. But more on
that at the end.

> > - can it use VLAN information from the packet (with a fallback on the
> >   port PVID) to determine where to send, and where *not* to send the
> >   packet? How does this relate to the flooding registers? Is the flood
> >   mask restricted by the VLAN mask? Is there a default VLAN installed in
> >   the hardware tables, which is also the PVID of all ports, and all
> >   ports are members of it? Could you implement standalone/bridged port
> >   forwarding isolation based on VLANs, rather than the flimsy and most
> >   likely buggy implementation done based on flooding domains, from this
> >   patch set?
> 
> Yes, the VLAN membership is used for packet flooding. The flooding
> registers are used when the packets come has a src MAC that is not in

s/src/destination/

> the FDB. For more infiormation, see section 4.5.3.9, paragraph 3.c
> which describe the whole lookup process.

Ok, got it. So UCAST_DEFAULT_MASK/MCAST_DEFAULT_MASK/BCAST_DEFAULT_MASK
are only used for flooding, if the packet doesn't see any hit in the
VLAN resolution table.

And, I guess, if BIT(port) is unset in VLAN_IN_MODE_ENA, then untagged
packets will not see any hit in the VLAN resolution table.
But, if VLAN_IN_MODE_ENA contains BIT(port) and VLAN_IN_MODE is set to,
say, TAG_ALWAYS for BIT(port), then all frames (including untagged
frames) will get encapsulated in the VLAN from SYSTEM_TAGINFO[port].
In that case, the packets will always hit the VLAN resolution table
(assuming that the VID from $SYSTEM_TAGINFO[port] was installed there),
and the UCAST_DEFAULT_MASK/MCAST_DEFAULT_MASK/BCAST_DEFAULT_MASK
flooding masks are never used for traffic coming from this port; but
rather, only the VLAN resolution table decides the destination ports.

Did I get this right?

> Regarding your other question, by default, there is no default VLAN
> installed but indeed, I see what you mean, a default VLAN could be used
> to isolate each ports rather than setting the rule to forward only to
> root CPU port + disabling of flooding. I guess a unique VLAN ID per port
> should be used to isolate each of them and added to the root port to
> untag the input frames tagged with the PVID ?

For example, hellcreek_setup_vlan_membership() does something like this
already. But your switch only has 32 VLANs.

> > - is the FDB looked up per {MAC DA, VLAN ID} or just MAC DA? Looking at
> >   a5psw_port_fdb_add(), there's absolutely no sign of "vid" being used,
> >   so I guess it's Shared VLAN Learning. In that case, there's absolutely
> >   no hope to implement ds->fdb_isolation for this hardware. But at the
> >   *very* least, please disable address learning on standalone ports,
> >   *and* implement ds->ops->port_fast_age() so that ports quickly forget
> >   their learned MAC adddresses after leaving a bridge and become
> >   standalone again.
> 
> Indeed, the lookup table does not contain the VLAN ID and thus it is
> unused. We talked about it in a previous review and you already
> mentionned that there is no hope to implement fdb_isolation.

Yes, I vaguely remember. In any case, absolutely horrible, and let me
explain why.

AFAIU from the documentation, the (VLAN-unaware) MAC Address Lookup table
always decides where the packet should go, if there is a MAC DA hit.
Whereas the VLAN Resolution table decides if the packet can go there.

The problem is that setups like this will not work for the a5psw:

                ___ br0__
               /     |   \
              /      |    \
(software) bond0     |     \
          /    \     |      |
        swp0  swp1  swp2  swp3
         |                  |
         |                  |
         |                  |
     station A          station B

DSA has logic to support bond0 as an unoffloaded bridge port (swp0 and
swp1 are standalone and pass all traffic just to/from the CPU port), in
the same bridging domain with swp2 and swp3, which do offload the
bridging process.

Assume station B wants to ping station A.

swp3 learns the MAC SA (station B's MAC address) from the ICMP request
as a FDB entry towards swp3. The MAC DA for the packet is unknown, so it
is flooded to swp2 and to the CPU port. From there, the software bridge
delivers the packet to bond0, which delivers it to swp0, and it reaches
station A.

Station A sends an ICMP reply to station B's MAC DA.

When swp0 receives this packet, the MAC Address Lookup table finds an
FDB entry saying that the packet should go to swp3. But the VLAN
Resolution table says that swp3 is unreachable from swp0. So, the packet
is dropped.

There is simply no way this can work if the MAC Address Lookup table is
VLAN-unaware. What should have happened is that swp0 should have not
been able to find the FDB entry towards swp3, because swp0 is standalone,
and swp3 is under a bridge.

Hmm, this makes me want to go to dsa_slave_changeupper() and to disable
all the "Offloading not supported" fallback code paths, unless
ds->fdb_isolation is set to true, so that people don't run into this
pitfall. However, only the drivers that I maintain have FDB isolation,
so that would disable the fallback for a lot of people :(

> Ok for disabling learning on standalone ports, and indeed, by default,
> it's enabled.

Okay. Disabling address learning on standalone ports should help with
some use cases, like when all ports are standalone and there is no
bridging offload.

> Regarding ds->ops->port_fast_age(), it is already implemented.

Sorry, I didn't notice that.

> The port PVID itself is not used to filter the flooding mask. But each
> time a PVID is set, the port must also be programmed as a membership of
> the PVID VLAN ID in the VLAN resolution table. So actually, the PVID is
> just here to tag (or not) the input packet, it does not take a role in
> packet forwading. This is entirely done by the VLAN resolution table
> content (VLAN_RES_TABLE register).

I think I've understood that now, finally.

> Does this means I don't have to be extra careful when programming it ?

Actually, no :) you still do.

What I don't think will work in your current setup of the hardware is this:

 br0  (standalone)
  |      |
 swp0   swp1

ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
ip link set swp0 master br0 && ip link set swp0 up
bridge vlan add dev swp0 vid 100
bridge fdb add 00:01:02:03:04:05 dev swp0 master static

and then connect a station to swp1 and send a packet with
{ MAC DA 00:01:02:03:04:05, VID 100 }. It should only reach the CPU port
of the switch, but it also leaks to swp0, am I right?

I'm saying this because the standalone swp1 has vlan_filtering 0, so in
the VLAN_VERIFY register, VLANVERI is 0 for swp1 (packets with VID 100 are
accepted even if in the VLAN table, swp1 isn't a member of VID 100).

[ hmm, if I'm correct about this, then I see that this situation isn't
  covered in tools/testing/selftests/drivers/net/dsa/no_forwarding.sh.
  Maybe we should add another entry to the selftest, for the "leak via
  FDB entry" case ]


This creates the very awkward situation where you have do the hard work
and do everything exactly right (to avoid forwarding domain leaks), as
if you were shooting for ds->fdb_isolation = true, but still do not get
ds->fdb_isolation = true in the end (because the MAC table is VLAN
unaware and there's nothing you can do about that). So, the software
bonding scenario won't work, but at least it will result in packet drops
(or, ideally, would be denied), and not in packet leaks. That's about
the best scenario we're aiming for. So frustrating.

I think the UCAST_DEFAULT_MASK/MCAST_DEFAULT_MASK/BCAST_DEFAULT_MASK
flooding destination masks are useless, because they are not keyed per
source port, but global. This means that you need to be extraordinarily
careful when you enable any port in these masks, because packets from
literally any other port, which were untagged and didn't hit an entry in
the MAC table, can reach there.

To avoid forwarding leaks, I guess that:

- each standalone port should be in a single VLAN with just the CPU
  port. This would be achieved by setting A5PSW_VLAN_IN_MODE_ENA=true to
  enable VLAN input manipulation, and to set SYSTEM_TAGINFO[port] to
  unique values per standalone port, together with VLAN_IN_MODE =
  "always" and VLAN_OUT_MODE = "tag through" (to encapsulate all traffic
  in the private port PVID, SYSTEM_TAGINFO, on ingress, and to
  decapsulate it on egress). Then, care must be taken that the values
  chosen for SYSTEM_TAGINFO[port] are reserved, and packets coming from
  other ports are never able to be classified to the same VLANs.

- each port under a bridge which is currently VLAN-unaware should use
  the same technique as for standalone ports, which is to set
  SYSTEM_TAGINFO[port] to a reserved value, common for all ports under
  the same bridge. That value can even be the standalone PVID of the
  first port that joined the VLAN-unaware bridge. This way, you would
  need to reserve no more than 4 VLANs, and you would keep reusing them
  also for VLAN-unaware bridging.

- each port under a VLAN-aware bridge should set its SYSTEM_TAGINFO[port]
  to the switchdev VLAN which has the BRIDGE_VLAN_INFO_PVID flag.

If you reserve VLAN IDs of 4095, 4094, 4093, 4092 as special values to
configure to SYSTEM_TAGINFO[port] when VLAN-unaware, then you must also
reject port_vlan_add() of these VLANs, and you must ensure, using the
VLAN Domain Verification function, that an "attacker" cannot sneak
crafted packets through VLAN-aware bridge ports so that they are
processed by the switch as if they were received on another ports.

However, I do appreciate that 32 VLANs is not a lot, and that cropping 4
of them is already 12.5%. The hardware designers probably didn't intend
the switch to be used like that.

Would it be possible to hack the 802.1X functionality of this switch
such as to configure all standalone ports to "require authentication"?
IIUC, that would mean that all traffic received on these ports is
delivered by the switch straight to the management port, and it would
bypass even the MAC table lookup, which would be good considering the
software bonding use case, for example. It would also mean that you
don't need to allocate one private SYSTEM_TAGINFO value per port.
