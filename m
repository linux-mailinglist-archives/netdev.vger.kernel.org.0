Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D654FBCDB
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346383AbiDKNQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346386AbiDKNQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:16:46 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC7D1CFD3
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:14:30 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id bu29so26665630lfb.0
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Jo9a4n+iJ7nLvMkOjKaRmzikmnBL4MvRcpX3MBR75Kw=;
        b=nA4gABxxnyKeFCVS52ZFhwnjLbcyf8Qqwd7oWr3IyIC926SNIutHKlB4CpnyhyxPHT
         Th9PT8Cdiysi4Cr68j5uGbdjwQiaIDqK15DGelZSN2GQBQRMdrg6WJcWOXMt+MITUqrU
         cChtVkcgHUH8MIBzK8tWtVYbFwMlYK0bDD2M7rIKOGXIync0nfiG7FyiAIWeBSlH4Rge
         LJlhDiiMhzh6o8dwl4zD57T610UhTBYBvQjKkNj8l/DtVHYOarz96CQknb8KzkIhDvOb
         kUNKlSAHaMgbLjAyiI/p2Zk4YviNNHrJtcwfCvplxlGYWPuHW6ILk/yxdeaAx5S1rJv8
         A2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Jo9a4n+iJ7nLvMkOjKaRmzikmnBL4MvRcpX3MBR75Kw=;
        b=N6PmQaN+jb9WKIBRbB5DFbTsf7KcJrWd9WZmJI5UZgdK5PhoLpmp9hY1Tpyd1KMdJE
         ojeUKZrP/Vdvt0fV7ivAV5hfAyOWoUeZsa88X3Sl5XgdbUuMRzqc/61Qz1nv/WkYLzDn
         iBYP3TsTP5KAqRlEsrKH8o0hnKpZAHwmJbOeozvfbD2ZV/rBxaa6x5bwf2O5nTARRZbt
         nMAIR84hGOkgC5j5bqZRHZ/Vlau7CzgZokkrkmgoec3eFd1Ub4gXyKhOjuM2iVIpg8lT
         SGnEsEl6US3LpSHwGz7pq8Y0w/+kU2cSMjCnVl8y0jg5GkWDcOWlWNa+za1Yrcgp2dxt
         EYUw==
X-Gm-Message-State: AOAM530s5/+n2y/yUswPsiy3ST7Rj9GKapU19Vy/CGhqL16vK1zADCV4
        OBcq5KbEZSU5eIWAjuvMb5mVMA==
X-Google-Smtp-Source: ABdhPJyVogYE2+lEeMpGSmbUnl2gFaoHtEFKtzPHtlCrFbIxz2+j1ZgdRBkpFMV88qQOWu9MxO0cMA==
X-Received: by 2002:a05:6512:10c9:b0:44a:fea7:50ac with SMTP id k9-20020a05651210c900b0044afea750acmr21324190lfg.680.1649682867904;
        Mon, 11 Apr 2022 06:14:27 -0700 (PDT)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id bq8-20020a056512150800b00448ab58bd53sm3330193lfb.40.2022.04.11.06.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:14:26 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: Re: [PATCH net-next 0/6] Disable host flooding for DSA ports under
 a bridge
In-Reply-To: <20220411105534.rkwicu6skd3v37qu@skbuf>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
 <877d7yhwep.fsf@waldekranz.com> <20220409204557.4ul4ohf3tjtb37dx@skbuf>
 <8735ikizq2.fsf@waldekranz.com> <20220410220324.4c3l3idubwi3w6if@skbuf>
 <87zgksge17.fsf@waldekranz.com> <20220411105534.rkwicu6skd3v37qu@skbuf>
Date:   Mon, 11 Apr 2022 15:14:25 +0200
Message-ID: <87wnfvhidq.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 10:55, Vladimir Oltean <vladimir.oltean@nxp.com> wr=
ote:
> On Mon, Apr 11, 2022 at 11:33:40AM +0200, Tobias Waldekranz wrote:
>> On Sun, Apr 10, 2022 at 22:03, Vladimir Oltean <vladimir.oltean@nxp.com>=
 wrote:
>> > On Sun, Apr 10, 2022 at 08:02:13PM +0200, Tobias Waldekranz wrote:
>> >> On Sat, Apr 09, 2022 at 20:45, Vladimir Oltean <vladimir.oltean@nxp.c=
om> wrote:
>> >> > Hi Tobias,
>> >> >
>> >> > On Sat, Apr 09, 2022 at 09:46:54PM +0200, Tobias Waldekranz wrote:
>> >> >> On Fri, Apr 08, 2022 at 23:03, Vladimir Oltean <vladimir.oltean@nx=
p.com> wrote:
>> >> >> > For this patch series to make more sense, it should be reviewed =
from the
>> >> >> > last patch to the first. Changes were made in the order that the=
y were
>> >> >> > just to preserve patch-with-patch functionality.
>> >> >> >
>> >> >> > A little while ago, some DSA switch drivers gained support for
>> >> >> > IFF_UNICAST_FLT, a mechanism through which they are notified of =
the
>> >> >> > MAC addresses required for local standalone termination.
>> >> >> > A bit longer ago, DSA also gained support for offloading BR_FDB_=
LOCAL
>> >> >> > bridge FDB entries, which are the MAC addresses required for loc=
al
>> >> >> > termination when under a bridge.
>> >> >> >
>> >> >> > So we have come one step closer to removing the CPU from the lis=
t of
>> >> >> > destinations for packets with unknown MAC DA.What remains is to =
check
>> >> >> > whether any software L2 forwarding is enabled, and that is accom=
plished
>> >> >> > by monitoring the neighbor bridge ports that DSA switches have.
>> >> >> >
>> >> >> > With these changes, DSA drivers that fulfill the requirements for
>> >> >> > dsa_switch_supports_uc_filtering() and dsa_switch_supports_mc_fi=
ltering()
>> >> >> > will keep flooding towards the CPU disabled for as long as no po=
rt is
>> >> >> > promiscuous. The bridge won't attempt to make its ports promiscu=
ous
>> >> >> > anymore either if said ports are offloaded by switchdev (this se=
ries
>> >> >> > changes that behavior). Instead, DSA will fall back by its own w=
ill to
>> >> >> > promiscuous mode on bridge ports when the bridge itself becomes
>> >> >> > promiscuous, or a foreign interface is detected under the same b=
ridge.
>> >> >>=20
>> >> >> Hi Vladimir,
>> >> >>=20
>> >> >> Great stuff! I've added Joachim to Cc. He has been working on a se=
ries
>> >> >> to add support for configuring the equivalent of BR_FLOOD,
>> >> >> BR_MCAST_FLOOD, and BR_BCAST_FLOOD on the bridge itself. I.e. allo=
wing
>> >> >> the user to specify how local_rcv is managed in br_handle_frame_fi=
nish.
>> >> >>=20
>> >> >> For switchdev drivers, being able to query whether a bridge will i=
ngress
>> >> >> unknown unicast to the host or not seems like the missing piece th=
at
>> >> >> makes this bullet proof. I.e. if you have...
>> >> >>=20
>> >> >> - No foreign interfaces
>> >> >> - No promisc
>> >> >> _and_
>> >> >> - No BR_FLOOD on the bridge itself
>> >> >>=20
>> >> >> ..._then_ you can safely disable unicast flooding towards the CPU
>> >> >> port. The same would hold for multicast and BR_MCAST_FLOOD of cour=
se.
>> >> >>=20
>> >> >> Not sure how close Joachim is to publishing his work. But I just t=
hought
>> >> >> you two should know about the other one's work :)
>> >> >
>> >> > I haven't seen Joachim's work and I sure hope he can clarify.
>> >>=20
>> >> If you want to get a feel for it, it is available here (the branch na=
me
>> >> is just where he started out I think :))
>> >>=20
>> >> https://github.com/westermo/linux/tree/bridge-always-flood-unknown-mc=
ast
>> >>=20
>> >> > It seems
>> >> > like there is some overlap that I don't currently know what to make=
 of.
>> >> > The way I see things, BR_FLOOD and BR_MCAST_FLOOD are egress settin=
gs,
>> >> > so I'm not sure how to interpret them when applied to the bridge de=
vice
>> >> > itself.
>> >>=20
>> >> They are egress settings, yes. But from the view of the forwarding
>> >> mechanism in the bridge, I would argue that the host interface is (or=
 at
>> >> least should be) as much an egress port as any of the lower devices.
>> >>=20
>> >> - It can be the target of an FDB entry
>> >> - It can be a member of an MDB entry
>> >>=20
>> >> I.e. it can be chosen as a _destination_ =3D> egress. This is analogo=
us to
>> >> the CPU port, which from the ASICs point of view is an egress port, b=
ut
>> >> from a system POV it is receiving frames.
>> >>=20
>> >> > On the other hand, treating IFF_PROMISC/IFF_ALLMULTI on the
>> >> > bridge device as the knob that decides whether the software bridge =
wants
>> >> > to ingress unknown MAC DA packets seems the more appropriate thing =
to do.
>> >>=20
>> >> Maybe. I think it depends on how exact we want to be in our
>> >> classification. Fundementally, I think the problem is that a bridge
>> >> deals with one thing that other netdevs do not:
>> >>=20
>> >>   Whether the destination in known/registered or not.
>> >>=20
>> >> A NIC's unicast/multicast filters are not quite the same thing, becau=
se
>> >> a they only deal with a single endpoint. I.e. if an address isn't in a
>> >> NIC's list of known DA's, then it is "not mine". But in a bridge
>> >> scenario, although it is not associated with the host (i.e. "not mine=
"),
>> >> it can still be "known" (i.e. associated with some lower port).
>> >>=20
>> >> AFAIK, promisc means "receive all the things!", whereas BR_FLOOD would
>> >> just select the subset of frames for which the destination is unknown.
>> >>=20
>> >> Likewise for multicast, IFF_ALLMULTI means "receive _all_ multicast" -
>> >> it does not discriminate between registered and unregistered
>> >> flows. BR_MCAST_FLOOD OTOH would only target unregistered flows.
>> >>=20
>> >> Here is my understanding of how the two solutions would differ in the
>> >> types of flows that they would affect:
>> >>=20
>> >>                     .--------------------.-----------------.
>> >>                     |       IFF_*        |    BR_*FLOOD    |
>> >> .-------------------|---------.----------|-----.-----.-----|
>> >> | Type              | Promisc | Allmulti | BC  | UC  | MC  |
>> >> |-------------------|---------|----------|-----|-----|-----|
>> >> | Broadcast         | Yes     | No       | Yes | No  | No  |
>> >> | Unknown unicast   | Yes     | No       | No  | Yes | No  |
>> >> | Unknown multicast | Yes     | Yes      | No  | No  | Yes |
>> >> | Known unicast     | Yes     | No       | No  | No  | No  |
>> >                         ~~~
>> >                         To what degree does IFF_PROMISC affect known
>> >                         unicast traffic?
>>=20
>> When a bridge interface has this flag set, local_rcv is unconditionally
>> set to true in br_handle_frame_finish:
>>=20
>>     local_rcv =3D !!(br->dev->flags & IFF_PROMISC);
>>=20
>> Which means we will always end up in br_pass_frame_up.
>>=20
>> >> | Known multicast   | Yes     | Yes      | No  | No  | No  |
>> >> '-------------------'--------------------'-----------------'
>> >
>> > So to summarize what you're trying to say. You see two planes back to =
back.
>> >
>> >  +-------------------------------+
>> >  |    User space, other uppers   |
>> >  +-------------------------------+
>> >  |   Termination plane governed  |
>> >  |     by dev->uc and dev->mc    |
>> >  |            +-----+            |
>> >  |            | br0 |            |
>> >  +------------+-----+------------+
>> >  |            | br0 |            |
>> >  |            +-----+            |
>> >  |  Forwarding plane governed    |
>> >  |        by FDB and MDB         |
>> >  | +------+------+------+------+ |
>> >  | | swp0 | swp1 | swp2 | swp3 | |
>> >  +-+------+------+------+------+-+
>>=20
>> Yes, this is pretty much my mental model of it.
>>=20
>> > For a packet to be locally received on the br0 interface, it needs to
>> > pass the filters from both the forwarding plane and the termination
>> > plane.
>>=20
>> I see it more as the forwarding plane having a superset of the
>> information available to the termination plane.
>>=20
>> I.e. all of the information in dev->uc and dev->mc can easily be
>> represented in the FDB (as a "local" entry) and MDB (by setting
>> `host_joined`) respectively, but there's loads of information in the
>> {F,M}DB for which there is no representation in a netdev's address
>> lists.
>>=20
>> > Considering a unicast packet:
>> > - if a local/permanent entry exists in the FDB, it is known to the
>> >   forwarding plane, and its destination is the bridge device seen as a
>> >   bridge port
>> > - if the FDB doesn't contain this MAC DA, it is unknown to the
>> >   forwarding plane, but the bridge device is still a destination for i=
t,
>> >   since the bridge seen as a bridge port has a non-configurable BR_FLO=
OD
>> >   port flag which allows unknown unicast to exit the forwarding plane
>> >   towards the termination plane implicitly on
>> > - if the MAC DA exists in the RX filter of the bridge device
>> >   (dev->dev_addr or dev->uc), the packet is known to the termination
>> >   plane, so it is not filtered out.
>>=20
>> It's more like the aggregate of all local entries _is_ the termination
>> plane's Rx filter. I.e. in the bridge's .ndo_set_rx_mode, we should sync
>> all UC/MC addresses into the FDB/MDB.
>>=20
>> There's a lot of stuff to deal with here around VLANs, since that
>> concept is missing from the kernel's address lists.
>>=20
>> > - if the MAC DA doesn't exist in the RX filter, the packet is filtered
>> >   out, unless the RX filter is disabled via IFF_PROMISC, case in which
>> >   it is still accepted
>> >
>> > Considering a multicast packet, things are mostly the same, except for
>> > the fact that having a local/permanent MDB entry towards the bridge
>> > device does not necessarily 'steal' it from the forwarding plane as it
>> > does in case of unicast, since multicast traffic can have multiple
>> > destinations which don't exclude each other.
>>=20
>> Not _necessarily_, but you are reclassifying the group as registered,
>> which means you go from flooding to forwarding. This in turn, means only
>> other registered subscribers (and routers) will see it.
>>=20
>> > Needless to say that what we have today is a very limited piece of the
>> > bigger puzzle you've presented above, and perhaps does not even behave
>> > the same as the larger puzzle would, restricted to the same operating
>> > conditions as the current code.
>> >
>> > Here are some practical questions so I can make sure I understand the
>> > model you're proposing.
>> >
>> > 1. You or Joachim add support for BR_FLOOD on the bridge device itself.
>> >    The bridge device is promiscuous, and a packet with a MAC DA unknown
>> >    to the forwarding plane is received. Will this packet be seen in
>> >    tcpdump or not? I assume not, because it never even reached the RX
>> >    filtering lists of the bridge device, it didn't exit the forwarding
>> >    plane.
>>=20
>> We don't propose any changes to how IFF_PROMISC is interpreted at
>> all. Joachim's changes will simply allow a user more fine grained
>> control over which flows are recieved by the termination plane when
>> IFF_PROMISC is _not_ set.
>>=20
>> > 2. Somebody comes later and adds support for IFF_ALLMULTI. This means,
>> >    the RX filtering for unknown multicast can be toggled on or off.
>> >    Be there a bridge with mcast_router enabled. Should the bridge devi=
ce
>> >    receive unknown multicast traffic or not, when IFF_ALLMULTI isn't
>> >    enabled? Right now, I think IFF_ALLMULTI isn't necessary.
>>=20
>> I think that setting IFF_ALLMULTI on a bridge interface is really just
>> another way of saying that the bridge should be configured as a static
>> multicast router. I.e. ...
>>=20
>>     ip link set dev br0 allmulticast on
>>=20
>> ...should be equivalent to...
>>=20
>>     ip link set dev br0 type bridge mcast_router 2
>>=20
>> ...since that flag is an indication that _all_ multicast should be
>> received, both registered and unregistered.
>>=20
>> We propose to add support for all three classes of _unknown_ traffic
>> (BUM) from the get-go:
>>=20
>> - BR_FLOOD (Unknown unicast)
>> - BR_MCAST_FLOOD (Unregistered multicast)
>> - BR_BCAST_FLOOD (Broadcast)
>>=20
>> So if BR_MCAST_FLOOD is not set, then the termination plane will not
>> receive any unregistered multicast. If it is marked as a multicast
>> router, then it will receive all registered _and_ unregistered
>> multicast. Same as with any other bridge port.
>
> A bridge port does not *receive* said flooded traffic, but *sends* it.

Right, that's why I tried to use your "termination plane" terminology.

> The station attached to that bridge port *receives* it. You as a bridge
> cannot control whether that station will actually *receive* it.
> That is the analogy with the bridge device as a bridge port.
> BR_MCAST_FLOOD may decide whether the forwarding plane sends the flow to
> the bridge, but the bridge's RX filter still needs to decide whether it
> accepts it.

So in br_pass_frame_up we would have a separate validation of whether
the DA matches the termination plane's Rx filter or not? That makes
sense.

>> > 3. The bridge device does not implement IFF_UNICAST_FLT today, so any
>> >    addition to the bridge_dev->uc list will turn on bridge_dev->flags &
>> >    IFF_PROMISC. Do you see this as a problem on the RX filtering side =
of
>> >    things, or from a system administration PoV, would you just like to
>> >    disable BR_FLOOD on the forwarding side of the bridge device and ca=
ll
>> >    it a day, expect the applications to just continue working?
>> >
>> > 4. Let's say we implement IFF_UNICAST_FLT for the bridge device.
>> >    How do we do it? Add one more lookup in br_handle_frame_finish()
>> >    which didn't exist before, to search for this MAC DA in bridge_dev-=
>uc?
>>=20
>> I think the most natural way would be to add them to the FDB as local
>> entries. We might need an extra flag to track its origin or something,
>> but it should be doable, I think. Again I think this is analogous to how
>> host addresses are added as FDB entries pointing towards the CPU port in
>> an ASIC.
>>=20
>> > 5. Should the implementation of IFF_UNICAST_FLT influence the forwardi=
ng
>> >    plane in any way?
>>=20
>> Since I propose we keep it in the FDB, yes, it will affect forwarding.
>>=20
>> >    Think of a user space application emitting a
>> >    PACKET_MR_UNICAST request to ensure it sees the packets with the MAC
>> >    DA it needs. Should said application have awareness of the fact that
>> >    the interface it's speaking to is a bridge device? If not, three
>> >    things may happen. The admin (you) has turned off BR_FLOOD towards
>> >    the bridge device, effectively cutting it off from the (unknown to
>> >    the forwarding plane) packets it wants to see. Or the admin hasn't
>> >    turned off BR_FLOOD, but the MAC DA, while present in the RX
>> >    filtering lists, is still absent from the FDB, so while it is
>> >    received locally by the application, is also flooded to all other
>> >    bridge ports. Or the kernel may automatically add a BR_FDB_LOCAL en=
try,
>> >    considering that it knows that if there's a destination for this
>> >    MAC DA in this broadcast domain, for certain there isn't more than
>> >    one, so it could just as well guide the forwarding plane towards it.
>> >    Or you may choose completely the other side, "hey, the bridge device
>> >    really is that special, and user space should put up with it and kn=
ow
>> >    it has to configure both its forwarding and termination plane before
>> >    things work in a reasonable manner on it". But if this is the path
>> >    you choose, what about the uppers a bridge may have, like a VLAN wi=
th
>> >    a MAC address different from the bridge's? Should the 8021q driver
>> >    also be aware of the fact that dev_uc_add() may not be sufficient
>> >    when applied to the bridge as a real_dev?
>>=20
>> I might be repeating myself, but just to be clear: I think the end goal
>> should be to have a proper .ndo_set_rx_mode implementation that
>> translates the device address lists into the forwarding plane, making
>> most of this transparent to users.
>>=20
>> > 6. For a switchdev driver like DSA, what condition do you propose it
>> >    should monitor for deciding whether to enable flooding towards the
>> >    host? IFF_PROMISC, BR_FLOOD towards the bridge, or both? You may say
>> >    "hey, switchdev offloads just the forwarding plane, I don't really
>> >    care if the bridge software path is going to accept the packet or
>> >    not". Or you may say that unicast flooding is to be enabled if
>> >    IFF_PROMISC || BR_FLOOD, and multicast flooding if IFF_PROMISC ||
>> >    IFF_ALLMULTI || BR_MCAST_FLOOD, and broadcast flooding if
>> >    BR_BCAST_FLOOD. Now take into consideration the additional checks f=
or
>> >    foreign interfaces. Does this complexity scale to the number of
>> >    switchdev drivers we have? If not, can we do something about it?
>>=20
>> Rule #1 is, If IFF_PROMISC is enabled on our bridge, we must flood
>> everything.
>>=20
>> Then for each class:
>>=20
>> - Broadcast: If BR_BCAST_FLOOD is enabled on the bridge or on any
>>   foreign interface, we must flood it to the CPU.
>>=20
>> - Unicast: If BR_FLOOD is enabled on the bridge or on any foreign
>>   interface, we must flood it to the CPU.
>>=20
>> - Multicast: If BR_MCAST_FLOOD is enabled on the bridge or on any
>>   foreign interface, we must flood it to the CPU.
>>=20
>> For multicast, we also have to take the router port status of the bridge
>> for foreign interfaces into consideration, but I believe that should be
>> managed separately.
>>=20
>> Additionally, if you _truly_ want to model the bridge's behavior, then
>> IFF_PROMISC on the bridge would mean that we either disable offloading
>> completely and forward everything via the CPU or setup some kind of port
>> mirror on all ports. Although that seems kind of silly, it might
>> actually be useful for debugging on occasion. You could have an ethtool
>> flag or something that would allow the user to enable it.
>
> So to summarize your second message.
>
> You're saying "hey, I see that IFF_PROMISC and IFF_ALLMULTI on the
> bridge are these beasts that defy all conventional wisdom about what an
> RX filter even is. A unicast packet forwarded by the bridge shouldn't be
> seen in tcpdump if there is an FDB entry that points to some other port
> than the bridge device itself, according to the mental model we agreed
> on, yet that is what happens today.

I think IFF_PROMISC and IFF_ALLMULTI serve their purpose as Rx filters
for NICs. It's just that I don't think they map that well to the flood
controls normally available on a switch ASIC (due to the fact that a
switch must differentiate between known and unknown traffic).

> So transposed to an offloading plane, setting IFF_PROMISC would mean
> that all traffic should be mirrored to the CPU, which is obviously
> something that no driver does, for more than one single reason.
> Consequently, the presence of an address in dev->uc would mean to mirror
> that single address to the CPU.
>
> For practical reasons (unicast traffic has a single destination), we may
> mirror that address by installing it to the FDB as a local entry. And
> maybe we could get away with that.

More than getting away with it, I would argue that it's the Right
Thing=E2=84=A2. Station addresses on an Ethernet segment must be unique, so=
 if
we know a station's location (by any means) then by definition it can
only be in that location.

> But for multicast RX filters, when an entry would get added to dev->mc,
> but that same multicast MAC address is absent from the MDB, we can't
> really do much about adding it to the MDB either, because this would
> transform the flow from being unregistered to being registered towards
> the CPU, so stations that used to see this flow via flooding will no
> longer see it.

Yes, multicast is much more tricky. For IP multicast, I think this
already works because an IP_ADD_MEMBERSHIP will cause the kernel to
generate an IGMP/MLD report which can be snooped by the bridge and an
entry installed in the MDB.

We can do the same with L2 multicast by having a PACKET_ADD_MEMBERSHIP
trigger an MMRP message, and then implement MMRP in the bridge.

So as an administrator, for L2 and L3 multicast, you have two choices:

1. Enable the relevant control protocol (MMRP, or IGMP/MLD). In this
   case you can get better filtering because we can load the multicast
   address list into the MDB. The trade-off is that all group listeners
   must speak the control protocol.

2. Disable the control protocol. The address lists will be ignored by
   the bridge, and you rely on flooding to distribute the traffic to
   where it needs to get. This will work for stations that can't take
   part in the control protocol.

There are also variations of (1) where you can help legacy devices by
either marking the ports as permanent router ports or by adding static
entries to the MDB.

> So much for our implementation of a mirror via the FDB/MDB, we'd instead
> have to add actual mirroring logic of individual addresses, without
> touching the FDB/MDB. Then have a way to offload those mirrors. And that
> would be for the sake of correctness.
>
> In terms of usability in the context of dev_uc_add() and dev_mc_add()
> though, that isn't really sane and just caters to the naive view that
> "tcpdump should see everything after it sets IFF_PROMISC". Because when
> a macvlan becomes an upper of the bridge, dev_uc_add() is what it'll
> call, and this won't stop the bridge from flooding packets towards the
> macvlan's MAC DA towards the network. It will just ensure that the
> macvlan is copied to the traffic destined towards it, too.
>
> I maybe agree that the aggregate of all local entries is the termination
> plane's Rx filter, in other words not more than that, i.e. the termination
> plane shouldn't treat the RX filters as mirrors from the forwarding plane.
> And in that view, yes maybe I agree that IFF_PROMISC would implicitly
> correspond to BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD, and

I would phrase it as: IFF_PROMISC means that switchdevs should forward
as much crap as possible towards the CPU. But at the DSA layer, I think
calling a driver specific .bridge_set_promisc op would be better than
assuming that driver's can't do any better.

> IFF_ALLMULTI would implicitly correspond to BR_MCAST_FLOOD (ok, also
> adjust for mcast_router ports).

IFF flags shouldn't correspond to any bridge flags. They describe higher
level features. Therefore, they should be passed down to the drivers,
who in many cases may decide to use hardware resources that are shared
with bridge flags (i.e. flood controls), but in some cases may be able
to do something better.

As an example of "something better": some ASICs have separate flooding
controls for IP and non-IP multicast.

So, I think

    ip link set dev br0 allmulticast on

Should be one way for userspace to tell the bridge to mark the host port
as a permanent multicast router port. This in turn would trigger a

    switchdev_port_attr_set(dev,
    	&{ .id =3D SWITCHDEV_ATTR_ID_BRIDGE_MROUTER ... }, extack);

At the DSA layer this info would be passed to the driver, which will
decide if that means the same thing as BR_MCAST_FLOOD or something
else.

> But I'd rather turn a blind eye to that, on the practical basis that
> making any changes at all to this mess that isn't correct even now is
> going to break something. I'm going to invent some new knobs which
> broadly mean what IFF_PROMISC | IFF_ALLMULTI should have meant, and I'm
> going to insist on the selling point that these allow me more
> fine-grained control over which class of MAC DA is flooded. In any case
> I'm not making things worse, because the BR_FLOOD flags towards the
> bridge device still make some amount of sense even in the context of a
> more normal interpretation of the bridge's RX filtering flags, if
> someone from the future really gets infuriated by the bridge device's
> behavior in the presence of uppers with different MAC address and has
> the guts to change/break something. So maybe I can get away with this."
>
> Am I getting this right? Because maybe I can hop onboard :)

I think we're getting there. Would love to have you on deck! :)
