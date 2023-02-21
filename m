Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3100469DE47
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 11:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbjBUK4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 05:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbjBUK4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 05:56:17 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A30724CBC
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 02:56:06 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id p8so4072278wrt.12
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 02:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CXu/zBQ2nxBv6rOmbaplWY5cFB2cZHBN8gFQBgVhOcM=;
        b=nlsE1+oEAH3lONwty4WQZ2Hd9T8OYTRBpDGK5xyaWrDJ73Oq1PPvSIMVtL9nHVuPSk
         1FmxJurU2ZuMNUyvEezPQs5Mn4oS904rOajGRyXDKsMAg+XrfPB6eiJVHUz/k/CLr3oC
         gVcsJoYV5qSav/ft69LXq5vwxjsQP1Kzdw45McP+RHuUnYz9v0cj8Du96KUs1HZngH84
         unmqIzcwbFiO06NOtPQ3aARPuLNwJd/X5iKVOZ5ZGx/lXw00p4xfE+8/+Kg+fhrcDtUM
         4iShrwmaeJL8Y68mKBEdKIOscmKiEOaHO3rq2MblxrEylpWELD3kR38xL4qwuQefQJoB
         W1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CXu/zBQ2nxBv6rOmbaplWY5cFB2cZHBN8gFQBgVhOcM=;
        b=bPfFX82t2oi2WSWOCrwwn5s959bvY4G5vy+mjVjnZP1762F1U8lCpPjDGRzZcHE9dY
         k5mn0tIDDreQFRZ8u1N/PrHvE7r4Tp1NcY/sZ/zmpqob5Rx/5bs18/gKl+7/8Xs042Uz
         Fda1wTwr+9ej81rjLkq6+KBbdMwgb11sxW4Vg2eT2uaOrgY7Y3uXMARJVsbirE9/2kEh
         kcxbwTglUWW63uE1/ssm+Vn9LOgmJjQ08CbyiOVTlKxfjC3dojA/9rGiNBTDMwFPTldO
         g6hMKrVsjOqV8xynx20q/zBMsCs9o1YpNUiTlL1cFsqPvDPlT2505xguLVMH2SJzqzYG
         ePDg==
X-Gm-Message-State: AO0yUKVMCzmX6/pfh0OozS/D+IREsImZZ4b02hCMeZzFrXwSF7PcOD71
        6dQlrgWkMd6tgkvy6GrfqStOfylMfuwj4vbX
X-Google-Smtp-Source: AK7set9SG+fwINhHBjoWr8nvdrrYTPKbPyBasgEhsH8HtYZ5xzJHZdgwRW7WmMjoStXLnS3onq+ymQ==
X-Received: by 2002:adf:fe06:0:b0:2c5:a48e:8623 with SMTP id n6-20020adffe06000000b002c5a48e8623mr3522564wrr.64.1676976964529;
        Tue, 21 Feb 2023 02:56:04 -0800 (PST)
Received: from [10.148.80.132] ([195.228.69.10])
        by smtp.gmail.com with ESMTPSA id u4-20020adfed44000000b002c706c754fesm807510wro.32.2023.02.21.02.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 02:56:03 -0800 (PST)
Message-ID: <218059630624eea06a9c8cc9120b8cf8c930cb04.camel@gmail.com>
Subject: Re: [PATCH net-next] net/hanic: Add the hanic network interface for
 high availability links
From:   Ferenc Fejes <primalgamer@gmail.com>
To:     Steve Williams <steve.williams@getcruise.com>,
        netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "<andrew@lunn.ch>" <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 21 Feb 2023 11:56:03 +0100
In-Reply-To: <20221118232639.13743-1-steve.williams@getcruise.com>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steve!

I just noticed your patch.

On Fri, 2022-11-18 at 15:26 -0800, Steve Williams wrote:
> This is a virtual device that implements support for 802.1cb R-TAGS
> and duplication and deduplication. The hanic nic itself is not a
> device,
> but enlists ethernet nics to act as parties in a high-availability
> link. Outbound packets are duplicated and tagged with R-TAGs, then
> set out the enlisted links. Inbound packets with R-TAGs have their
> R-TAGs removed, and duplicates are dropped to complete the link. The
> algorithm handles links being completely disconnected, sporadic
> packet
> loss, and out-of-order arrivals.
>=20
> To the extent possible, the link is self-configuring: It detects and
> brings up streams as R-TAG'ed packets are detected, and creates
> streams
> for outbound packets unless explicitly filtered to skip tagging.
> ---
> =C2=A0Documentation/networking/hanic.rst |=C2=A0 351 ++++++++++
> =C2=A0Documentation/networking/index.rst |=C2=A0=C2=A0=C2=A0 1 +
> =C2=A0MAINTAINERS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0=C2=A0=C2=A0 6 +
> =C2=A0drivers/net/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 17 +
> =C2=A0drivers/net/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0 1 +
> =C2=A0drivers/net/hanic/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0=C2=A0 15 +
> =C2=A0drivers/net/hanic/hanic_dev.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 1006
> ++++++++++++++++++++++++++++
> =C2=A0drivers/net/hanic/hanic_filter.c=C2=A0=C2=A0 |=C2=A0 172 +++++
> =C2=A0drivers/net/hanic/hanic_main.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 109 =
+++
> =C2=A0drivers/net/hanic/hanic_netns.c=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 58 =
++
> =C2=A0drivers/net/hanic/hanic_priv.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 408 =
+++++++++++
> =C2=A0drivers/net/hanic/hanic_protocol.c |=C2=A0 350 ++++++++++
> =C2=A0drivers/net/hanic/hanic_streams.c=C2=A0 |=C2=A0 161 +++++
> =C2=A0drivers/net/hanic/hanic_sysfs.c=C2=A0=C2=A0=C2=A0 |=C2=A0 672 +++++=
++++++++++++++
> =C2=A014 files changed, 3327 insertions(+)
> =C2=A0create mode 100644 Documentation/networking/hanic.rst
> =C2=A0create mode 100644 drivers/net/hanic/Makefile
> =C2=A0create mode 100644 drivers/net/hanic/hanic_dev.c
> =C2=A0create mode 100644 drivers/net/hanic/hanic_filter.c
> =C2=A0create mode 100644 drivers/net/hanic/hanic_main.c
> =C2=A0create mode 100644 drivers/net/hanic/hanic_netns.c
> =C2=A0create mode 100644 drivers/net/hanic/hanic_priv.h
> =C2=A0create mode 100644 drivers/net/hanic/hanic_protocol.c
> =C2=A0create mode 100644 drivers/net/hanic/hanic_streams.c
> =C2=A0create mode 100644 drivers/net/hanic/hanic_sysfs.c
>=20
> diff --git a/Documentation/networking/hanic.rst
> b/Documentation/networking/hanic.rst
> new file mode 100644
> index 000000000000..16b04247b0b0
> --- /dev/null
> +++ b/Documentation/networking/hanic.rst
> @@ -0,0 +1,351 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +HANIC DRIVER
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Copyright |copy| 2022 Cruise LLC
> +
> +OVERVIEW
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The hanic driver creates a virtual network interface that implements
> +the high availability protocol 802.1cb, with vector matching. The
> +idea is to create a hanic NIC, then enlist a pair of physical NIC
> +devices to act at the redundant ports. The hanic NIC replaces the
> +enlisted ports, and handles duplication and R-TAGS (outbound) and
> +de-duplication and removing R-TAGS (inbound).

Pair of NICs is what HSR can handle as redundant ifaces. .1CB can use
arbitrary number of NICs, but its just a nit.

> +
> +The current implementation assumes that all outbound unicast traffic
> +is to be R-TAGed and duplicated, so there is no need to define
> +outbound streams explicitly. Arriving traffic that includes R-TAGs
> +automatically call themselves out as 802.1cb traffic, so inbound
> +streams don't need to be explicitly defined either.
> +
> +Inbound traffic that does not have an R-TAG is assumed to not be
> +redundant, and is simply passed up the network stack.
> +
> +Broadcast Packets
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Outbound broadcast and multicast traffic is either sent out a single
> +(prime or second mode) or duplicated without R-TAGS and sent out all
> +the enlisted ports (flood mode). The appropriate mode depends on
> +network topology. Broadcast packets are never R-TAGed by the hanic
> +driver.
> +
> +Broadcast packets cannot be R-TAGed by the hanic driver, because
> there
> +is not enough information in the stream identification process to
> +properly identify a stream context for the R-TAG sequence
> +number.
> +
> +Consider the example of a source MAC-A and destination MAC-B. MAC-A
> +can send unicast packets to MAC-B and also broadcast packets to
> +MAC-x. MAC-A identifies the outbound stream (and thus the scope for
> +the R-TAG sequence number) by using the target address, so
> +MAC-A-to-MAC-x is one stream, and MAC-A-to-MAC-B is a different
> +stream.
> +
> +On the receiving (B) side, the hanic driver uses the source address
> to
> +identify the stream. (The destination address is the host itself.)
> +Thus, MAC-A-to-MAC-B and MAC-A-to-MAC-x map to the same
> +stream. Now the R-TAGs don't match and the link breaks.
> +
> +A work-around would be to use both the source and destination MAC
> +addresses, but that's beyond the scope of the 802.1cb standard, so
> +other devices will not be able to communicate with the hanic
> +driver. Therefore, broadcast (and multicast) packets cannot be
> +R-TAGed.

I'm confused. The 802.1CB have two parts: the FRER definition and
stream identification definitions. Take a look into the 6. chapter,
especially the Table 6-1. Not only some identifications using DMAC too
but it defines 6 tuple (IP Stream identification) based identification.
So my main problem here, the stream identification somehow must be
separated from the FRER (chapter 7 of the standard).

I would recommend to use the approach of using tc filters like u32,
flower, etc. for stream identification.

> +
> +Special multicast handling
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +
> +By default, multicast packets (outbound) are treated as broadcast
> +packets, and are not R-TAGed. Their disposition follows the
> broadcast
> +packet disposition setting.
> +
> +However, one can request that multicast packets be R-TAGed and
> +replicated. Set the multicast_rtag setting, and multicast packets
> +will be handled the same as unicast packets. This should only work
> +if by design the network knows that will only be one source nic
> +for any packets with a given multicast group. (There may obviously
> +still be multiple receivers). If this constraint is true, then the
> +objection in the broadcast case that the stream cannot be uniquely
> +identified no longer applies, and R-TAGed multicast packets will
> +work fine.
> +
> +If the multicast_rtag flag is set, it is still possible to set some
> +multicast groups to avoid tagging by using the vlan and vmac filters
> +to set the disposition.
> +
> +Special ARP handling
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +ARP requests are broadcast, so are not R-TAGed. ARP replies, on the
> +other hand, are unicast and can theoretically be R-TAGed. However,
> +hanic detects outbound ARP replies and handles them based on the
> +arp_rtag configuration flag. If this flag is set to 1, then ARP
> +response packets are R-TAGed; if this flag is set to 0 (the default)
> +they are sent out the primary port (prime mode), secondary port
> +(second mode) or all the enlisted ports (flood mode), without R-
> TAGs.
> +
> +It is unlikely that the ARP requestor matching an ARP reply is an
> +802.1CB protected stream, and even if it is, it should still be able
> +to receive an untagged ARP reply packet. That's certainly the case
> +with hanic. Thus, the default for arp_rtag is 0, and this is
> probably
> +the best choice if the remotes are all hanic implementations. If the
> +network requires all packets to be R-TAGed, set arp_rtag to 1 to
> force
> +arp resposes to be R-TAGed. A hanic implementation will be able to
> +understand and work with R-TAGed and not R-TAGed ARP responses, no
> +matter how it is configured to handle outbound ARP replies.

The standard does not mention ARP anywhere, so we have great level of
freedom here in regard of the implementation. I cant really see how
generic is this, or it might brings limitations in the future. But one
way or other, have the option to R-tag ARP packets or not is good, but
IPv6 ND should be addressed as well IMO. Including these logics in
hanic might be necessary but I would be happy to have an option where
the ARP/ND handling is hanic agnostic. I dont know if thats possible or
not.

> +
> +Output R-TAG filter
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +In a realistic system, some destinations do not support 802.1cb,
> +or don't need it. The hanic driver has a means to call out these
> +destinations by vlan or by mac and vlan together. For example, if
> +all the destinations on vlan=3D11 (0x000b) should not receive r-TAG'ed
> +packets, then that can be arranged like so::
> +
> +=C2=A0 $ echo 000b: prime > /sys/class/net/\<nic\>/hanic/filters_vlan
> +
> +If you need to be more selective, then you can use the vmac filter
> +to suppress tags::
> +
> +=C2=A0 $ echo 01:23:45:56:89:ab-000b: prime >
> /sys/class/net/<nic>/hanic/filter_vmac
> +
> +This filter does not affect inbound traffic, since the driver can
> +already tell if a packet is R-TAG'ed and handle it appropriately.

Well thats definitely not generic enough. If someone has to do
something like this, tc filters and actions should be utilized.

Hanic send out the frame with R-tag to everywhere regardless if the
destionation support it or not.
To R-tag unaware destionations we should pop the R-tag with a TC action
(like we do this at VLAN) either at egress (after the hanic passed the
frame or at the ingress of the destiontion device.

> +
> +Creating interfaces
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The way to create interfaces is with a command like this::
> +
> +=C2=A0 $ echo +hanic0 > /sys/class/net/hanic_interfaces
> +
> +It is also possible to destroy interfaces thusly::
> +
> +=C2=A0 $ echo -hanic0 > /sys/class/net/hanic_interfaces
> +
> +
> +Enlisting other ethernet ports to an interface
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The standard IP commands can be used to do the enlistment, like so::
> +
> +=C2=A0 $ ip link set sandlan0a master hanic0
> +=C2=A0 $ ip link set sandlan0b master hanic0
> +
> +These commands enlist the sandlan0a and sandlan0b interfaces to the
> +hanic0 interface. Interfaces remain enlisted until they are
> +unregistered, or until the hanic interface is destroyed.
> +
> +The first NIC added to the hanic device is the prime NIC. This is
> +the NIC that is used for broadcast and multicast traffic, unless the
> +broadcast_port mode is changed to "flood".
> +
> +The default MAC address for the hanic NIC is that of the prime NIC,
> +but the user mode may explicitly set the MAC address. Wherever the
> MAC
> +address comes from, all the NICs are compelled to take on the MAC
> +address of the master, so that they receive packets destined for the
> +master.
> +
> +When a NIC is released, it is given the MAC address that it had when
> it
> +was first enlisted, but NICs are not typically released.
> +
> +
> +VLANS
> +=3D=3D=3D=3D=3D
> +
> +Hanic understands 802.1Q VLANs. Create hanic protected VLANs by
> +starting with a regular hanic NIC (e.g. hanic0) and linking a VLAN
> +like so::
> +
> +=C2=A0 $ ip link add link hanic0 name hanic0.11 type vlan id 11
> +
> +The hanic0.11 appears to the user like any other NIC, but it is
> linked
> +to the hanic protocol; the hanic module will recognize packets going
> +through this VLAN and handle the parts of the protocol that need
> VLAN
> +awareness.
> +
> +It appears to the user that the VLAN is on top of the hanic driver,
> +but the packets out and in will have the 802.1Q tags before the
> +802.1cb R-TAGs, as expected. This works out because the Linux vlan
> +module reaches around into the header to mark the tags. More
> +correctly, one says that hanic0.11 is "linked" to hanic0, and not
> +stacked.

Again, for .1CB conformance we should think about IP matching as well
:-( Packets can received with the same VLAN ID but with different
MAC/IP addresses therefore they belongs to different streams.

I cant see how the decouple of the identification and the FRER
functionality can be avoided.

> +
> +The statistics for vlan NICs (e.g. hanic0.11 above) are kept by the
> +hanic driver and made available via the underlying interface
> (hanic0).
> +So the hanic interface streams and statistics for the hanic lan and
> +all bound vlans are found in the /sys/class/net/hanic0/hanic/
> directory.
> +
> +SYSFS interface
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +* /sys/class/net/hanic_interfaces [rw]
> +
> +Read this file to get the hanic interfaces that exist. Write this
> file
> +to create or destroy hanic interfaces.
> +
> +* /sys/class/net/<nic>/hanic/broadcast_port [rw]
> +
> +Read this file to find out how outbound broadcast (and multicast)
> +packets are handled. If the value is "flood", then the packets are
> +sent out all the NICs. Otherwise, the value is the number for the
> port
> +that is used for broadcast.
> +
> +* /sys/class/net/<nic>/hanic/arp_rtag [rw] (bool)
> +
> +Normally, ARP response packets are not R-TAG'ed an are instead
> +disposed out the broadcast port. If this flag is set to 1, the ARP
> +packet is instead R-TAG'ed. This will create a destination stream if
> +needed, R-TAGs will be inserted to the outbound ARP response, and
> the
> +packet will be sent redundantly.
> +
> +* /sys/class/net/<nic>/hanic/multicast_rtag [rw] (bool)
> +
> +Normally, multicast packets are not R-TAG'ed and are instead
> +disposed out the broadcast port. If this flag is set to 1, multicast
> +packets are instead R-TAG'ed. This will create a destination stream
> if
> +needed, R-TAGs will be inserted to the outbound packet, and the
> +packet will be sent redundantly.
> +
> +* /sys/class/net/<nic>/hanic/ports [r]
> +
> +Read this file to see the NICs bound to the hanic device, one port
> +per line.
> +
> +* /sys/class/net/<nic>/hanic/stream-xx:xx:xx:xx:xx:xx-vvvv [r]
> +
> +There is a file like this for every active stream, which contains
> +802.1cb stream specific statistics. The file name is made up from
> +the mac address (6 bytes) and a vlan id (2 bytes). A vlan of 0 means
> +no vlan at all.
> +
> +* /sys/class/net/<nic>/hanic/filter_vlan [rw]
> +
> +This contains vlan filters. Each line is the format::
> +
> +=C2=A0 vvvv: mode
> +
> +where vvvv is the vlan in hex, and mode is the port to use. Outbound
> +packets that match this vlan are sent out this port without
> replication
> +and 802.1cb outbound processing is skipped. (This does not affect
> inbound
> +traffic.) The valid modes are:
> +
> +| Mode=C2=A0=C2=A0 | Meaning=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
> +| +---=C2=A0=C2=A0 | +------=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
> +| none=C2=A0=C2=A0 | Remove from the filter=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
> +| <N>=C2=A0=C2=A0=C2=A0 | Send untagged out port <N>=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |
> +| flood=C2=A0 | Send untagged out all the ports=C2=A0=C2=A0 |
> +
> +* /sys/class/net/\<nic\>/hanic/filter_vmac [rw]
> +
> +This contains vlan filters. Each line is the format:
> +
> +=C2=A0 xx:xx:xx:xx:xx:xx-vvvv: mode
> +
> +where xx..xx is the target mac address and vvvv is the vlan in
> +hex; and mode is the port to use. Outbound packets that match
> +this vlan are sent out this port without replication and 802.1cb
> +outbound processing is skipped. (This does not affect inbound
> +traffic.) The valid modes are:
> +
> +| Mode=C2=A0=C2=A0 | Meaning=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
> +| +---=C2=A0=C2=A0 | +------=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
> +| none=C2=A0=C2=A0 | Remove from the filter=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
> +| <N>=C2=A0=C2=A0=C2=A0 | Send untagged out port <N>=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 |
> +| flood=C2=A0 | Send untagged out all the ports=C2=A0=C2=A0 |
> +
> +* /sys/class/net/\<nic\>/hanic/jiffies_per_hanic_tick [r]
> +
> +This is the period, measured in Linux Jiffies, of the 802.1cb timer.
> +The TicksPerSecond described in IEEE Std 802.1CB-2017 section
> 7.4.3.2.5
> +is a frequency, and is (HZ / jiffies_per_hanic_tick).
> +
> +* /sys/class/net/\<nic\>/hanic/ticks_per_reset [rw]
> +
> +This is the hanic equivalent of frerSeqRcvyResetMSec. It is the
> number
> +of hanic ticks of inactivity before deciding to reset the vector
> recovery
> +algorithm. The frerSeqRcvyResetMSec value can be calculated as::
> +
> +=C2=A0 frerSeqRcvyResetMSec =3D
> (1000.0*jiffies_per_hanic_tick*ticks_per_reset)/HZ
> +
> +This value can be written to set the set the ticks_per_reset (and
> thus
> +change the frerSeqRcvyResetMSec value) so long as this value is 2 or
> +more. This implies that there is a minimum value defined by the HZ
> of
> +the Linux/CPU combination and other compile time constants. For ARM,
> +with HZ=3D250, jiffies_per_hanic_tick=3D=3D2, so frerSeqRcvyResetMSec>=
=3D16.
> +(The default is much larger.)
> +
> +* /sys/class/net/\<nic\>/hanic/test_drop_packet_in
> +
> +Inject faults by dropping input packets from some port. Write to
> this
> +file the port number and the number of packets to drop. For example,
> +to tell port 1 to drop the next 5 input packets::
> +
> +=C2=A0 % echo 1 5 > test_drop_packet_in
> +
> +To cancel any further packet drops, replace the number with 0::
> +
> +=C2=A0 % echo 1 0 > test_drop_packet_in
> +
> +Read the file to see how many drops remain for all the ports::
> +
> +=C2=A0 % cat test_prop_packet_in
> +=C2=A0 0 0
> +=C2=A0 1 5
> +=C2=A0 2 0
> +=C2=A0 3 0
> +
> +* /sys/class/net/\<nic\>/hanic/test_drop_packet_out
> +
> +Inject faults by dropping output packets to some port. Write to this
> +file the port number and the number of packets to drop. For example,
> +to tell port 1 to drop the next 5 output packets::
> +
> +=C2=A0 % echo 1 5 > test_drop_packet_out
> +
> +This fault injection only affects packets that are replicated. So
> for
> +example packets that are routed through one port or the other via
> +filters are immune to this fault injection.
> +
> +To cancel any further packet drops, replace the number with 0::
> +
> +=C2=A0 % echo 1 0 > test_drop_packet_out
> +
> +Read the file to see how many drops remain for all the ports::
> +
> +=C2=A0 % cat test_prop_packet_out
> +=C2=A0 * 0
> +=C2=A0 0 0
> +=C2=A0 1 5
> +=C2=A0 2 0
> +=C2=A0 3 0
> +
> +As a special case, one can also request that _all_ replicated
> packets
> +are dropped. This would test the remote's ability to detect or at
> least
> +cope with lost packets. Invoke this feature by setting the ' * '
> port to
> +drop packets::
> +
> +=C2=A0 % echo '* 1' > test_drop_packet_out
> +=C2=A0 % cat test_prop_packet_out
> +=C2=A0 * 1
> +=C2=A0 0 0
> +=C2=A0 1 0
> +=C2=A0 2 0
> +=C2=A0 3 0
> +
> +The R-TAG sequence number for the fully dropped packet will be
> counted
> +as if it was transmitted, so the loss of packets will be reflected
> in the
> +R-TAG value of the packet that does get transmitted.
> +
> +Notes
> +=3D=3D=3D=3D=3D
> +
> +The IPv6 protocol engine has some implicit multicast packets that
> +are generated, in the range 33:33:xx:xx:xx:xx. These are not R-TAGed
> +outbound, even when multicast_rtag is enabled.
> diff --git a/Documentation/networking/index.rst
> b/Documentation/networking/index.rst
> index 4f2d1f682a18..4c5df4e7da1e 100644
> --- a/Documentation/networking/index.rst
> +++ b/Documentation/networking/index.rst
> @@ -56,6 +56,7 @@ Contents:
> =C2=A0=C2=A0=C2=A0 generic_netlink
> =C2=A0=C2=A0=C2=A0 gen_stats
> =C2=A0=C2=A0=C2=A0 gtp
> +=C2=A0=C2=A0 hanic
> =C2=A0=C2=A0=C2=A0 ila
> =C2=A0=C2=A0=C2=A0 ioam6-sysctl
> =C2=A0=C2=A0=C2=A0 ipddp
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 14ee1c72d01a..b59f8c11cee4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8960,6 +8960,12 @@
> Q:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0http://patchwork.linuxtv.org/=
project/linux-media/list/
> =C2=A0T:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0git git://linuxtv.org/anttip/media_=
tree.git
> =C2=A0F:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0drivers/media/usb/hackrf/
> =C2=A0
> +HANIC NET DEVICE
> +M:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Steve Williams <steve.williams@getcruise=
.com>
> +S:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Maintained
> +F:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Documentation/networking/hanic.rst
> +F:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0drivers/net/hanic/
> +
> =C2=A0HANTRO VPU CODEC DRIVER
> =C2=A0M:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Ezequiel Garcia <ezequiel@vanguardi=
asur.com.ar>
> =C2=A0M:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Philipp Zabel <p.zabel@pengutronix.=
de>
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 9e63b8c43f3e..8cc990921032 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -631,4 +631,21 @@ config NETDEV_LEGACY_INIT
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Drivers that call =
netdev_boot_setup_check() should select
> this
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 symbol, everything=
 else no longer needs it.
> =C2=A0
> +config HANIC
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 tristate "Cruise High Availability =
NIC driver"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 depends on INET
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 help
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Support for the HANIC m=
odule. This driver creates virtual
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 devices that enlist physical =
NIC interfaces and combines
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 them to implement the IEEE 80=
2.1cb frame replication and
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 elimination protocol, without=
 any special hardware support.
> +
> +config HANIC_FAULT_INJECTION
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool "Enable fault injection interf=
aces for the hanic driver"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 depends on HANIC
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 help
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Include with the HANIC module suppo=
rt for fault injection.
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 This is a debug aid that allows tes=
ters to introduce faults
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 in the form of dropped packets.
> +
>=20

[just cut the rest of the code, also so far I have not looked into it]

I try my best to sneak into this discussion since we also designed a
.1CB + DetNet software bridge + router recently. But thats userspace so
utilizing veth heavily to pass packets into userspace. But since
switches like NXP, Espressobin and Microchip 9668 supporting hardware
FRER (and might be more to come) the need for good UAPI and offloading
model is necessary.=20


Best,
Ferenc
