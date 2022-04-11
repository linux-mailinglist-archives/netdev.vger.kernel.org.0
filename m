Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FAF4FB78D
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 11:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiDKJgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 05:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiDKJf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 05:35:58 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5092E3F88E
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 02:33:44 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id x33so19086324lfu.1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 02:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=KWyrDJjGkqYWz0T0aHqiqAeSk74TU4QgBpBVJrW378o=;
        b=SN3yslttZoup8QkMldz87Ldyle2fGYv77QddZiOLb3SOMT3xdYpfa7mvioRtZxsk7v
         84h5qkyqK2FVYs8yIexcWXp/drEowa/vKKlFH5JMsUO0qh2PG1FAvfo44eg0sqG9dhr/
         kLN2vgmwrmNWCiDWu1F73TiqJ+PWJuhL4nVkgL2FHOk1wuG+v+Zq/n+ejc50A9ZZabph
         CCdrXuBP9JgNHuYlm2ni3LnHaQMq9O4ueAobxMAZoj9QMJilVIsOvBJ1UYVEQ4kmmD+N
         RlW853frYrKXptuIKtajdy7aiaY4gIxejrK+Gjl09ObkEdEYbXVp2k8u+lg+cpJwoYyT
         Y1Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KWyrDJjGkqYWz0T0aHqiqAeSk74TU4QgBpBVJrW378o=;
        b=SDtw0J0qr0/G5gBAcsusLW5KHZYFxs3PR8T8W/WwymZO4DSkQRd2B4ZIcFItlajqwi
         bkdIBFDszBeNQJ7fgKySCJ651kIOiu8QmZYu629nePdXKCTOAsGI2CFr9EwcCnVN8XNC
         6PWhG3FpqDxry2UtBZdUz9UqsJEtGYafCo/fcLLJ9avC5XXC7/XZn9Ptvna6Wh704BV2
         RNwlPGPF9sXl7drdgZfwicN3Ile7dOPBMSPgMOQ3n1w2rv/PbrtkuELek7BRAv3L7W/9
         2ixtgHUCRs9qfAxKPxb6GXVAhY9U0WDEYJu2M7Tk/0sOv5UWD0LP58ISdbuYniTGf1Zo
         LaBQ==
X-Gm-Message-State: AOAM532UGDTicOkVxUMYAZVsDKzFKRoUsz1xbLB3ZEPFADa4KfJbZxJk
        Oo2EMaxMqohi/1yc1elJzakAHQ==
X-Google-Smtp-Source: ABdhPJwOXFxd2fhO+nd2eg9ni9hIzXd/VGJc0sSAhAWGKTsfC+XVxQKt2xqn6eTonzU9nZ6OZu1r5w==
X-Received: by 2002:ac2:4a7c:0:b0:464:f034:eb31 with SMTP id q28-20020ac24a7c000000b00464f034eb31mr14404756lfp.688.1649669622251;
        Mon, 11 Apr 2022 02:33:42 -0700 (PDT)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id a26-20020a19fc1a000000b0046ba3b78b86sm415588lfi.41.2022.04.11.02.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 02:33:41 -0700 (PDT)
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
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: Re: [PATCH net-next 0/6] Disable host flooding for DSA ports under
 a bridge
In-Reply-To: <20220410220324.4c3l3idubwi3w6if@skbuf>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
 <877d7yhwep.fsf@waldekranz.com> <20220409204557.4ul4ohf3tjtb37dx@skbuf>
 <8735ikizq2.fsf@waldekranz.com> <20220410220324.4c3l3idubwi3w6if@skbuf>
Date:   Mon, 11 Apr 2022 11:33:40 +0200
Message-ID: <87zgksge17.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 22:03, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> On Sun, Apr 10, 2022 at 08:02:13PM +0200, Tobias Waldekranz wrote:
>> On Sat, Apr 09, 2022 at 20:45, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>> > Hi Tobias,
>> >
>> > On Sat, Apr 09, 2022 at 09:46:54PM +0200, Tobias Waldekranz wrote:
>> >> On Fri, Apr 08, 2022 at 23:03, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>> >> > For this patch series to make more sense, it should be reviewed from the
>> >> > last patch to the first. Changes were made in the order that they were
>> >> > just to preserve patch-with-patch functionality.
>> >> >
>> >> > A little while ago, some DSA switch drivers gained support for
>> >> > IFF_UNICAST_FLT, a mechanism through which they are notified of the
>> >> > MAC addresses required for local standalone termination.
>> >> > A bit longer ago, DSA also gained support for offloading BR_FDB_LOCAL
>> >> > bridge FDB entries, which are the MAC addresses required for local
>> >> > termination when under a bridge.
>> >> >
>> >> > So we have come one step closer to removing the CPU from the list of
>> >> > destinations for packets with unknown MAC DA.What remains is to check
>> >> > whether any software L2 forwarding is enabled, and that is accomplished
>> >> > by monitoring the neighbor bridge ports that DSA switches have.
>> >> >
>> >> > With these changes, DSA drivers that fulfill the requirements for
>> >> > dsa_switch_supports_uc_filtering() and dsa_switch_supports_mc_filtering()
>> >> > will keep flooding towards the CPU disabled for as long as no port is
>> >> > promiscuous. The bridge won't attempt to make its ports promiscuous
>> >> > anymore either if said ports are offloaded by switchdev (this series
>> >> > changes that behavior). Instead, DSA will fall back by its own will to
>> >> > promiscuous mode on bridge ports when the bridge itself becomes
>> >> > promiscuous, or a foreign interface is detected under the same bridge.
>> >> 
>> >> Hi Vladimir,
>> >> 
>> >> Great stuff! I've added Joachim to Cc. He has been working on a series
>> >> to add support for configuring the equivalent of BR_FLOOD,
>> >> BR_MCAST_FLOOD, and BR_BCAST_FLOOD on the bridge itself. I.e. allowing
>> >> the user to specify how local_rcv is managed in br_handle_frame_finish.
>> >> 
>> >> For switchdev drivers, being able to query whether a bridge will ingress
>> >> unknown unicast to the host or not seems like the missing piece that
>> >> makes this bullet proof. I.e. if you have...
>> >> 
>> >> - No foreign interfaces
>> >> - No promisc
>> >> _and_
>> >> - No BR_FLOOD on the bridge itself
>> >> 
>> >> ..._then_ you can safely disable unicast flooding towards the CPU
>> >> port. The same would hold for multicast and BR_MCAST_FLOOD of course.
>> >> 
>> >> Not sure how close Joachim is to publishing his work. But I just thought
>> >> you two should know about the other one's work :)
>> >
>> > I haven't seen Joachim's work and I sure hope he can clarify.
>> 
>> If you want to get a feel for it, it is available here (the branch name
>> is just where he started out I think :))
>> 
>> https://github.com/westermo/linux/tree/bridge-always-flood-unknown-mcast
>> 
>> > It seems
>> > like there is some overlap that I don't currently know what to make of.
>> > The way I see things, BR_FLOOD and BR_MCAST_FLOOD are egress settings,
>> > so I'm not sure how to interpret them when applied to the bridge device
>> > itself.
>> 
>> They are egress settings, yes. But from the view of the forwarding
>> mechanism in the bridge, I would argue that the host interface is (or at
>> least should be) as much an egress port as any of the lower devices.
>> 
>> - It can be the target of an FDB entry
>> - It can be a member of an MDB entry
>> 
>> I.e. it can be chosen as a _destination_ => egress. This is analogous to
>> the CPU port, which from the ASICs point of view is an egress port, but
>> from a system POV it is receiving frames.
>> 
>> > On the other hand, treating IFF_PROMISC/IFF_ALLMULTI on the
>> > bridge device as the knob that decides whether the software bridge wants
>> > to ingress unknown MAC DA packets seems the more appropriate thing to do.
>> 
>> Maybe. I think it depends on how exact we want to be in our
>> classification. Fundementally, I think the problem is that a bridge
>> deals with one thing that other netdevs do not:
>> 
>>   Whether the destination in known/registered or not.
>> 
>> A NIC's unicast/multicast filters are not quite the same thing, because
>> a they only deal with a single endpoint. I.e. if an address isn't in a
>> NIC's list of known DA's, then it is "not mine". But in a bridge
>> scenario, although it is not associated with the host (i.e. "not mine"),
>> it can still be "known" (i.e. associated with some lower port).
>> 
>> AFAIK, promisc means "receive all the things!", whereas BR_FLOOD would
>> just select the subset of frames for which the destination is unknown.
>> 
>> Likewise for multicast, IFF_ALLMULTI means "receive _all_ multicast" -
>> it does not discriminate between registered and unregistered
>> flows. BR_MCAST_FLOOD OTOH would only target unregistered flows.
>> 
>> Here is my understanding of how the two solutions would differ in the
>> types of flows that they would affect:
>> 
>>                     .--------------------.-----------------.
>>                     |       IFF_*        |    BR_*FLOOD    |
>> .-------------------|---------.----------|-----.-----.-----|
>> | Type              | Promisc | Allmulti | BC  | UC  | MC  |
>> |-------------------|---------|----------|-----|-----|-----|
>> | Broadcast         | Yes     | No       | Yes | No  | No  |
>> | Unknown unicast   | Yes     | No       | No  | Yes | No  |
>> | Unknown multicast | Yes     | Yes      | No  | No  | Yes |
>> | Known unicast     | Yes     | No       | No  | No  | No  |
>                         ~~~
>                         To what degree does IFF_PROMISC affect known
>                         unicast traffic?

When a bridge interface has this flag set, local_rcv is unconditionally
set to true in br_handle_frame_finish:

    local_rcv = !!(br->dev->flags & IFF_PROMISC);

Which means we will always end up in br_pass_frame_up.

>> | Known multicast   | Yes     | Yes      | No  | No  | No  |
>> '-------------------'--------------------'-----------------'
>
> So to summarize what you're trying to say. You see two planes back to back.
>
>  +-------------------------------+
>  |    User space, other uppers   |
>  +-------------------------------+
>  |   Termination plane governed  |
>  |     by dev->uc and dev->mc    |
>  |            +-----+            |
>  |            | br0 |            |
>  +------------+-----+------------+
>  |            | br0 |            |
>  |            +-----+            |
>  |  Forwarding plane governed    |
>  |        by FDB and MDB         |
>  | +------+------+------+------+ |
>  | | swp0 | swp1 | swp2 | swp3 | |
>  +-+------+------+------+------+-+

Yes, this is pretty much my mental model of it.

> For a packet to be locally received on the br0 interface, it needs to
> pass the filters from both the forwarding plane and the termination
> plane.

I see it more as the forwarding plane having a superset of the
information available to the termination plane.

I.e. all of the information in dev->uc and dev->mc can easily be
represented in the FDB (as a "local" entry) and MDB (by setting
`host_joined`) respectively, but there's loads of information in the
{F,M}DB for which there is no representation in a netdev's address
lists.

> Considering a unicast packet:
> - if a local/permanent entry exists in the FDB, it is known to the
>   forwarding plane, and its destination is the bridge device seen as a
>   bridge port
> - if the FDB doesn't contain this MAC DA, it is unknown to the
>   forwarding plane, but the bridge device is still a destination for it,
>   since the bridge seen as a bridge port has a non-configurable BR_FLOOD
>   port flag which allows unknown unicast to exit the forwarding plane
>   towards the termination plane implicitly on
> - if the MAC DA exists in the RX filter of the bridge device
>   (dev->dev_addr or dev->uc), the packet is known to the termination
>   plane, so it is not filtered out.

It's more like the aggregate of all local entries _is_ the termination
plane's Rx filter. I.e. in the bridge's .ndo_set_rx_mode, we should sync
all UC/MC addresses into the FDB/MDB.

There's a lot of stuff to deal with here around VLANs, since that
concept is missing from the kernel's address lists.

> - if the MAC DA doesn't exist in the RX filter, the packet is filtered
>   out, unless the RX filter is disabled via IFF_PROMISC, case in which
>   it is still accepted
>
> Considering a multicast packet, things are mostly the same, except for
> the fact that having a local/permanent MDB entry towards the bridge
> device does not necessarily 'steal' it from the forwarding plane as it
> does in case of unicast, since multicast traffic can have multiple
> destinations which don't exclude each other.

Not _necessarily_, but you are reclassifying the group as registered,
which means you go from flooding to forwarding. This in turn, means only
other registered subscribers (and routers) will see it.

> Needless to say that what we have today is a very limited piece of the
> bigger puzzle you've presented above, and perhaps does not even behave
> the same as the larger puzzle would, restricted to the same operating
> conditions as the current code.
>
> Here are some practical questions so I can make sure I understand the
> model you're proposing.
>
> 1. You or Joachim add support for BR_FLOOD on the bridge device itself.
>    The bridge device is promiscuous, and a packet with a MAC DA unknown
>    to the forwarding plane is received. Will this packet be seen in
>    tcpdump or not? I assume not, because it never even reached the RX
>    filtering lists of the bridge device, it didn't exit the forwarding
>    plane.

We don't propose any changes to how IFF_PROMISC is interpreted at
all. Joachim's changes will simply allow a user more fine grained
control over which flows are recieved by the termination plane when
IFF_PROMISC is _not_ set.

> 2. Somebody comes later and adds support for IFF_ALLMULTI. This means,
>    the RX filtering for unknown multicast can be toggled on or off.
>    Be there a bridge with mcast_router enabled. Should the bridge device
>    receive unknown multicast traffic or not, when IFF_ALLMULTI isn't
>    enabled? Right now, I think IFF_ALLMULTI isn't necessary.

I think that setting IFF_ALLMULTI on a bridge interface is really just
another way of saying that the bridge should be configured as a static
multicast router. I.e. ...

    ip link set dev br0 allmulticast on

...should be equivalent to...

    ip link set dev br0 type bridge mcast_router 2

...since that flag is an indication that _all_ multicast should be
received, both registered and unregistered.

We propose to add support for all three classes of _unknown_ traffic
(BUM) from the get-go:

- BR_FLOOD (Unknown unicast)
- BR_MCAST_FLOOD (Unregistered multicast)
- BR_BCAST_FLOOD (Broadcast)

So if BR_MCAST_FLOOD is not set, then the termination plane will not
receive any unregistered multicast. If it is marked as a multicast
router, then it will receive all registered _and_ unregistered
multicast. Same as with any other bridge port.

> 3. The bridge device does not implement IFF_UNICAST_FLT today, so any
>    addition to the bridge_dev->uc list will turn on bridge_dev->flags &
>    IFF_PROMISC. Do you see this as a problem on the RX filtering side of
>    things, or from a system administration PoV, would you just like to
>    disable BR_FLOOD on the forwarding side of the bridge device and call
>    it a day, expect the applications to just continue working?
>
> 4. Let's say we implement IFF_UNICAST_FLT for the bridge device.
>    How do we do it? Add one more lookup in br_handle_frame_finish()
>    which didn't exist before, to search for this MAC DA in bridge_dev->uc?

I think the most natural way would be to add them to the FDB as local
entries. We might need an extra flag to track its origin or something,
but it should be doable, I think. Again I think this is analogous to how
host addresses are added as FDB entries pointing towards the CPU port in
an ASIC.

> 5. Should the implementation of IFF_UNICAST_FLT influence the forwarding
>    plane in any way?

Since I propose we keep it in the FDB, yes, it will affect forwarding.

>    Think of a user space application emitting a
>    PACKET_MR_UNICAST request to ensure it sees the packets with the MAC
>    DA it needs. Should said application have awareness of the fact that
>    the interface it's speaking to is a bridge device? If not, three
>    things may happen. The admin (you) has turned off BR_FLOOD towards
>    the bridge device, effectively cutting it off from the (unknown to
>    the forwarding plane) packets it wants to see. Or the admin hasn't
>    turned off BR_FLOOD, but the MAC DA, while present in the RX
>    filtering lists, is still absent from the FDB, so while it is
>    received locally by the application, is also flooded to all other
>    bridge ports. Or the kernel may automatically add a BR_FDB_LOCAL entry,
>    considering that it knows that if there's a destination for this
>    MAC DA in this broadcast domain, for certain there isn't more than
>    one, so it could just as well guide the forwarding plane towards it.
>    Or you may choose completely the other side, "hey, the bridge device
>    really is that special, and user space should put up with it and know
>    it has to configure both its forwarding and termination plane before
>    things work in a reasonable manner on it". But if this is the path
>    you choose, what about the uppers a bridge may have, like a VLAN with
>    a MAC address different from the bridge's? Should the 8021q driver
>    also be aware of the fact that dev_uc_add() may not be sufficient
>    when applied to the bridge as a real_dev?

I might be repeating myself, but just to be clear: I think the end goal
should be to have a proper .ndo_set_rx_mode implementation that
translates the device address lists into the forwarding plane, making
most of this transparent to users.

> 6. For a switchdev driver like DSA, what condition do you propose it
>    should monitor for deciding whether to enable flooding towards the
>    host? IFF_PROMISC, BR_FLOOD towards the bridge, or both? You may say
>    "hey, switchdev offloads just the forwarding plane, I don't really
>    care if the bridge software path is going to accept the packet or
>    not". Or you may say that unicast flooding is to be enabled if
>    IFF_PROMISC || BR_FLOOD, and multicast flooding if IFF_PROMISC ||
>    IFF_ALLMULTI || BR_MCAST_FLOOD, and broadcast flooding if
>    BR_BCAST_FLOOD. Now take into consideration the additional checks for
>    foreign interfaces. Does this complexity scale to the number of
>    switchdev drivers we have? If not, can we do something about it?

Rule #1 is, If IFF_PROMISC is enabled on our bridge, we must flood
everything.

Then for each class:

- Broadcast: If BR_BCAST_FLOOD is enabled on the bridge or on any
  foreign interface, we must flood it to the CPU.

- Unicast: If BR_FLOOD is enabled on the bridge or on any foreign
  interface, we must flood it to the CPU.

- Multicast: If BR_MCAST_FLOOD is enabled on the bridge or on any
  foreign interface, we must flood it to the CPU.

For multicast, we also have to take the router port status of the bridge
for foreign interfaces into consideration, but I believe that should be
managed separately.

Additionally, if you _truly_ want to model the bridge's behavior, then
IFF_PROMISC on the bridge would mean that we either disable offloading
completely and forward everything via the CPU or setup some kind of port
mirror on all ports. Although that seems kind of silly, it might
actually be useful for debugging on occasion. You could have an ethtool
flag or something that would allow the user to enable it.
