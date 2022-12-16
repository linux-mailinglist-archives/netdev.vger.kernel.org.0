Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8184B64F0F4
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 19:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbiLPS3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 13:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiLPS3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 13:29:15 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94F010B5D;
        Fri, 16 Dec 2022 10:29:13 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id g10so3102843plo.11;
        Fri, 16 Dec 2022 10:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NPqYI1ST8fV6Zyc8gkR0LNMJ6yqnV18F+EFyxcm3Q1c=;
        b=cpW1RWj2+uzTxI/F2Icl57mG+mp7llzdEgeQ5xSniGiuEssr9YtYiJ85WQmLHZu+R6
         EfQ5kXufKjrjOqWd4bcM9yru+dDyWt4TkMRxhLDOx86cnMedXV/s+H0+KK+oh6NYDYZl
         ZVUZbitACZB0e4Ok3hx5iV5Kq1pJ4yMGNbmK+/iXWHFnumHazCqziAjKEcig0rriElAi
         yWpYDnIaAAx0mad68zF41l6iB99miC8FQV+5bWzu339gCFlYSTLUcdPF5ErtHultdUWZ
         ddHRwUylDrGuXEJvwrBmzfiQhFlkaXPmABiHEb0RlgzQgzqY3SHbF7dYozQBhB1MVn+e
         ZjfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NPqYI1ST8fV6Zyc8gkR0LNMJ6yqnV18F+EFyxcm3Q1c=;
        b=7Pu2BuXiIRhZu8NOffO9+WRa4cVd2+5cJWyXYaPHy5Ex6eBqKz1jCZgdJKOr1NRNdx
         zhJJ4iY9ecwvNal6z0l7sy4BhwdxEBKdo+8oKIDyl3pmMHAGp6FK7xl0EnpsIUKKBPeh
         IaqeuoOWi7I5IN9jyBaSfxZCsNkgOq1LLr0uLOmkW+7wiW6EqXj4dG0uwR9uP77m76Xn
         LqLr5Vqu3bdqSMbJ/pxi0gJTG0nM05rg1+lUJQi3sBSTKh1r8HpN2yF3cf/oMojAOuoh
         1NZC7VZIt1DMCqKt2HK8t54aeE9QGLV8Q1HM42YJBroZjPPksg3rTSTUGsvjNuzRBRqU
         xL+g==
X-Gm-Message-State: AFqh2kqXX/duxccytoxtSzzVAdV7b+g5GjV68VgmrZBIA1tnvJ7fxSho
        CV2zbWaMr+liaGJTVyjfiPiAmjbzr1pEWO9o7ezI/OaYdcw=
X-Google-Smtp-Source: AMrXdXvaLnn0h6GwZkkJ09vxzXcvJQyXnLGsuE4mMmiJ7kphOFjpwgL0vZEysqcHkRpGxRoq9XwOzPet3UpTiMXk1eI=
X-Received: by 2002:a17:902:9a8c:b0:190:fc28:8cb6 with SMTP id
 w12-20020a1709029a8c00b00190fc288cb6mr295776plp.144.1671215353099; Fri, 16
 Dec 2022 10:29:13 -0800 (PST)
MIME-Version: 1.0
References: <20221213004754.2633429-1-peter@pjd.dev> <ac48b381b11c875cf36a471002658edafe04d9b9.camel@gmail.com>
 <7A3DBE8E-C13D-430D-B851-207779148A77@pjd.dev>
In-Reply-To: <7A3DBE8E-C13D-430D-B851-207779148A77@pjd.dev>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 16 Dec 2022 10:29:00 -0800
Message-ID: <CAKgT0Uf-9XwvJJTZOD0EHby6Lr0R-tMYGiR_2og3k=d_eTBPAw@mail.gmail.com>
Subject: Re: [PATCH] net/ncsi: Always use unicast source MAC address
To:     Peter Delevoryas <peter@pjd.dev>
Cc:     sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 5:08 PM Peter Delevoryas <peter@pjd.dev> wrote:
>
>
>
> > On Dec 13, 2022, at 8:41 AM, Alexander H Duyck <alexander.duyck@gmail.c=
om> wrote:
> >
> > On Mon, 2022-12-12 at 16:47 -0800, Peter Delevoryas wrote:
> >> I use QEMU for development, and I noticed that NC-SI packets get dropp=
ed by
> >> the Linux software bridge[1] because we use a broadcast source MAC add=
ress
> >> for the first few NC-SI packets.
> >
> > Normally NC-SI packets should never be seen by a bridge.
>
> True, and it=E2=80=99s good to keep this in context. I=E2=80=99m trying t=
o make this change
> to support simulation environments, but any change in NC-SI could easily
> result in the out-of-band network connection to BMC=E2=80=99s in real dat=
a centers
> failing to come up, which can be really bad and usually impossible to
> recover remotely.
>
> > Isn't NC-SI
> > really supposed to just be between the BMC and the NIC firmware?
>
> Yep
>
> > Depending on your setup it might make more sense to use something like
> > macvtap or a socket connection to just bypass the need for the bridge
> > entirely.
>
> For unicast, yes, but I want to test multiple NIC=E2=80=99s sharing an RM=
II
> link and verifying the broadcast behavior, and the failover behavior
> when an RX or TX channel goes down.
>
> The multicast UDP socket backend _does_ work, but I was getting some
> recirculation problems or some kind of buffering thing. I managed
> to get tap0 + tap1 + br0 working faster.

Right, but I think part of the issue is that things are being extended
in a way that may actually hurt the maintainability of it.
Specifically it seems like the general idea is that the NCSI interface
should be using either broadcast or the assigned unicast address as
its source MAC address.

My main concern with just using the raw MAC address from the device is
that it may be something that would be more problematic than just
being broadcast. My suggestion at a minimum would be to verify it is
valid before we just use it or to do something like in the code I
referenced where if the device doesn't have a valid MAC address we
just overwrite it with broadcast.

> >
> >> The spec requires that the destination MAC address is FF:FF:FF:FF:FF:F=
F,
> >> but it doesn't require anything about the source MAC address as far as=
 I
> >> know. From testing on a few different NC-SI NIC's (Broadcom 57502, Nvi=
dia
> >> CX4, CX6) I don't think it matters to the network card. I mean, Meta h=
as
> >> been using this in mass production with millions of BMC's [2].
> >>
> >> In general, I think it's probably just a good idea to use a unicast MA=
C.
> >
> > I'm not sure I agree there. What is the initial value of the address?
>
> Ok so, to be honest, I thought that the BMC=E2=80=99s FTGMAC100 periphera=
ls
> came with addresses provisioned from the factory, and that we were just
> discarding that value and using an address provisioned through the NIC,
> because I hadn=E2=80=99t really dug into the FTGMAC100 datasheet fully. I=
 see now
> that the MAC address register I thought was a read-only manufacturing
> value is actually 8 different MAC address r/w registers for filtering.
> *facepalm*
>
> It suddenly makes a lot more sense why all these OEM Get MAC Address
> commands exist: the BMC chip doesn=E2=80=99t come with any MAC addresses =
from
> manufacturing. It=E2=80=99s a necessity, not some convenience artifact/et=
c.
>
> So, tracing some example systems to see what shows up:
>
> One example:
> INIT: Entering runlevel: 5
> Configuring network interfaces... [   25.893118] 8021q: adding VLAN 0 to =
HW filter on device eth0
> [   25.904809] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> [   25.917307] ftgmac100 1e660000.ethernet eth0: NCSI: Handler for packet=
 type 0x82 returned -19
> [   25.958096] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> [   25.978124] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> [   25.990559] ftgmac100 1e660000.ethernet eth0: NCSI: 'bad' packet ignor=
ed for type 0xd0
> [   26.018180] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> [   26.030631] ftgmac100 1e660000.ethernet eth0: NCSI: 'bad' packet ignor=
ed for type 0xd0
> [   26.046594] ftgmac100 1e660000.ethernet eth0: NCSI: transmit cmd 0x50 =
ncsi_oem_sma_mlx success during probe
> [   26.168109] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> [   26.198101] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> [   26.238237] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> [   26.272011] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> [   26.308155] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> [   26.320504] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> done.
> [   26.408094] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> [   26.438100] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> [   26.450537] ftgmac100 1e660000.ethernet eth0: NCSI: bcm_gmac16 MAC RE:=
DA:CT:ED:HE:HE
> Starting random number generator[   26.472388] NCSI: source=3Dff:ff:ff:ff=
:ff:ff dest=3Dff:ff:ff:ff:ff:ff
>  daemon[   26.518241] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff=
:ff:ff
> [   26.559504] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> .
> [   26.608229] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> Setup dhclient for IPv6... done.
> [   26.681879] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> [   26.730523] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> [   26.808191] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
> [   26.855689] NCSI: source=3Dff:ff:ff:ff:ff:ff dest=3Dff:ff:ff:ff:ff:ff
>
> Oddly, due to that code you mentioned, all NC-SI packets are using
> a broadcast source MAC address, even after the Get MAC Address sequence
> gets the MAC provisioned for the BMC from the Broadcom NIC.
>
> root@bmc-oob:~# ifconfig
> eth0      Link encap:Ethernet  HWaddr RE:DA:CT:ED:HE:HE
>           inet addr:XXXXXXX  Bcast:XXXXXXXX  Mask:XXXXXXXX
>           inet6 addr: XXXXXXXX Scope:Global
>           inet6 addr: XXXXXXXX Scope:Link
>           inet6 addr: XXXXXXXX Scope:Global
>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>           RX packets:2965 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:637 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:872759 (852.3 KiB)  TX bytes:59936 (58.5 KiB)
>           Interrupt:19
>
> But, that=E2=80=99s a system using the 5.0 kernel with lots of old hacks
> on top. A system using a 5.15 kernel with this change included:
>
> INIT: Entering runlevel: 5
> Configuring network interfaces... [    6.596537] 8021q: adding VLAN 0 to =
HW filter on device eth0
> [    6.609264] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
> [    6.622913] ftgmac100 1e690000.ftgmac eth0: NCSI: Handler for packet t=
ype 0x82 returned -19
> [    6.641447] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
> [    6.662543] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
> [    6.680454] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
> [    6.694114] ftgmac100 1e690000.ftgmac eth0: NCSI: transmit cmd 0x50 nc=
si_oem_sma_mlx success during probe
> [    6.715722] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
> done.
> [    6.741372] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
> [    6.741451] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
> [    6.768714] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
> Starting random [    6.782599] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff=
:ff:ff:ff:ff:ff
> number generator[    6.799321] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff=
:ff:ff:ff:ff:ff
>  daemon[    6.815680] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff=
:ff:ff
> [    6.831388] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
> .
> [    6.846921] ftgmac100 1e690000.ftgmac eth0: NCSI: Network controller s=
upports NC-SI 1.1, querying MAC address through OEM(0x8119) command
> Setup dhclient for IPv6... done.
> [    6.908921] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
> reloading rsyslo[    6.933085] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff=
:ff:ff:ff:ff:ff
>
> So, this BMC already had the provisioned MAC address somehow,
> even before the Nvidia Get MAC Address command towards the bottom.

It is probably a hold over from the last boot. I suspect you would
need a clean power-cycle to reset it back to non-modified values.

> Adding tracing to ftgmac100:
>
> [    2.018672] ftgmac100_initial_mac
> [    2.026090] Read MAC address from FTGMAC100 register: RE:DA:CT:ED:AD:D=
R
> [    2.040771] ftgmac100 1e690000.ftgmac: Read MAC address RE:DA:CT:ED:AD=
:DR from chip
> [    2.057774] ftgmac100 1e690000.ftgmac: Using NCSI interface
> [    2.070957] ftgmac100 1e690000.ftgmac eth0: irq 33, mapped at (ptrval)
>
> Now, after rewriting the FTGMAC100 register to fa:ce:b0:0c:20:22 and rebo=
oting:
>
> root@dhcp6-2620-10d-c0b9-4b08-0-0-0-e4e:~# devmem 0x1e690008 32 0x0000fac=
e
> root@dhcp6-2620-10d-c0b9-4b08-0-0-0-e4e:~# devmem 0x1e690008
> 0x0000FACE
> root@dhcp6-2620-10d-c0b9-4b08-0-0-0-e4e:~# devmem 0x1e69000c 32 0xb00c202=
2
> root@dhcp6-2620-10d-c0b9-4b08-0-0-0-e4e:~# devmem 0x1e69000c
> 0xB00C2022
>
> [    2.001304] ftgmac100_initial_mac
> [    2.008727] Read MAC address from FTGMAC100 register: fa:ce:b0:0c:20:2=
2
> [    2.023373] ftgmac100 1e690000.ftgmac: Read MAC address fa:ce:b0:0c:20=
:22 from chip
> [    2.040367] ftgmac100 1e690000.ftgmac: Using NCSI interface
>
> [    6.581239] ftgmac100_reset_mac
> [    6.589193] ftgmac100_reset_mac
> [    6.596727] 8021q: adding VLAN 0 to HW filter on device eth0
> [    6.609462] NCSI: source=3Dfa:ce:b0:0c:20:22 dest=3Dff:ff:ff:ff:ff:ff
> [    6.623117] ftgmac100 1e690000.ftgmac eth0: NCSI: Handler for packet t=
ype 0x82 returned -19
> [    6.641647] NCSI: source=3Dfa:ce:b0:0c:20:22 dest=3Dff:ff:ff:ff:ff:ff
> [    6.662398] NCSI: source=3Dfa:ce:b0:0c:20:22 dest=3Dff:ff:ff:ff:ff:ff
> [    6.680380] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
> [    6.694000] ftgmac100 1e690000.ftgmac eth0: NCSI: transmit cmd 0x50 nc=
si_oem_sma_mlx success during probe
> [    6.715700] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
> [    6.729528] NCSI: source=3DRE:DA:CT:ED:AD:DR dest=3Dff:ff:ff:ff:ff:ff
>
> So, it looks like whatever is initialized in ftgmac100_initial_mac become=
s
> the address we use for the NCSI queries initially.
>
> The Aspeed datasheet says the FTGMAC100 MAC address registers are initial=
ized to zero,
> and in that case the ftgmac100 driver initializes it to something random
> with eth_hw_addr_random().
>
> So, I mean correct me if I=E2=80=99m wrong, but I think it all seems fine=
?
>
> On a hard power cycle (instead of just resetting the ARM cores, which doe=
sn=E2=80=99t seem to
> have reset the peripherals), maybe it would actually be zero, and get ini=
tialized
> to the random value. I=E2=80=99ll test that, need to do some more debug i=
mage building to do it
> remotely.

So we know now that it is using a random MAC address on reboot.

> > My main
> > concern would be that the dev_addr is not initialized for those first
> > few messages so you may be leaking information.
> >
> >> This might have the effect of causing the NIC to learn 2 MAC addresses=
 from
> >> an NC-SI link if the BMC uses OEM Get MAC Address commands to change i=
ts
> >> initial MAC address, but it shouldn't really matter. Who knows if NIC'=
s
> >> even have MAC learning enabled from the out-of-band BMC link, lol.
> >>
> >> [1]: https://tinyurl.com/4933mhaj
> >> [2]: https://tinyurl.com/mr3tyadb
> >
> > The thing is the OpenBMC approach initializes the value themselves to
> > broadcast[3]. As a result the two code bases are essentially doing the
> > same thing since mac_addr is defaulted to the broadcast address when
> > the ncsi interface is registered.
>
> That=E2=80=99s a very good point, thanks for pointing that out, I hadn=E2=
=80=99t
> even noticed that!
>
> Anyways, let me know what you think of the traces I added above.
> Sorry for the delay, I=E2=80=99ve just been busy with some other stuff,
> but I do really actually care about upstreaming this (and several
> other NC-SI changes I=E2=80=99ll submit after this one, which are unrelat=
ed
> but more useful).
>
> Thanks,
> Peter

So the NC-SI spec says any value can be used for the source MAC and
that broadcast "may" be used. I would say there are some debugging
advantages to using broadcast that will be obvious in a packet trace.
I wonder if we couldn't look at doing something like requiring
broadcast or LAA if the gma_flag isn't set. With that we could at
least advertise that we don't expect this packet to be going out in a
real network as we cannot guarantee the MAC is unique.
