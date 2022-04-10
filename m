Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADF14FAF82
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 20:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbiDJSEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 14:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiDJSE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 14:04:29 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01DC60DAC
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 11:02:17 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id b21so23006819lfb.5
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 11:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=FvUQzM3GT0YLTNt980Na18miq2QIIe4lEYU6qrNdVCk=;
        b=BlXdDaAXyvyfV/PjOuSBeF1PSJegbpJN6gLCjzJ+o+wYtc3UN4/gZwATAaPffCZ7wD
         1FPTS5OMm4SdrRJnBSQNQ9BsTrDauN4DjXrHYfAhAYDWD4TlcRIkSLvMLDLFmaPHX2MK
         dwE0D7lMDMbSFADExd3Yy0ou6dITpnumsR/GgMDVfBpahsIo5csB8hmBbHHhNYbrmkZf
         aXBdAgZONZD8gWI6XAZjSnGWUPBfqHQoSUQcWN3+cXKm/FqkWyv1AhQi4QBu2G1oUejG
         2mDBB+YwCUXyNcryy9PNVKti9zZ/UTAp9Xvxqa/o/YcQmMdCok/qlsLEoqjpfucKiQSe
         Ix7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FvUQzM3GT0YLTNt980Na18miq2QIIe4lEYU6qrNdVCk=;
        b=mcIQJJZ0IYj5hK6mYp3JQePJCvaqXxoz2vKuqGp5lZwvkolfEMoq2CCjo+6Py43mnw
         UBvB5412dgxadJu4CX5YJfEerTm1wNjZqSxfQ8XkKmomTvedyvkhLuBvBipUTcEBz6y4
         4UXKnI4iYuc9WLP/gGS8YTbECiDy8NUt5DIMaECZC2dfVYACJp2+FnzdikPdsmAR3NbH
         YK/Y+Nkm69yIFPHqYVm7pU+FjorfnScSeVRaLG5EluyGJEKkUZ2KO6NE6d54SMqKmdTp
         PnBG2aI3h2LojNFnausSrq8uQJHwueHmZ4cXnLvgqbVGHMFJtykryAsK8roOqYZdBRnU
         iluw==
X-Gm-Message-State: AOAM530cZdP8/VpG9ZXvKA7km9St//p9cwINmO9VWCinAaAsolje53X/
        Qg476HVKH0ufGXOboFxv7VrbQg==
X-Google-Smtp-Source: ABdhPJx7jK1wGaKDLMluJnIuaUjwVNxCrW1QAw8wEgWq4HXJMMFr7h9G+z2HfiMvJ4Z7uMAM7fXrhQ==
X-Received: by 2002:a05:6512:3e1d:b0:44a:b550:f115 with SMTP id i29-20020a0565123e1d00b0044ab550f115mr18779810lfv.261.1649613736106;
        Sun, 10 Apr 2022 11:02:16 -0700 (PDT)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id f17-20020a2e1f11000000b00247f8eb86a7sm2794944ljf.108.2022.04.10.11.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 11:02:15 -0700 (PDT)
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
In-Reply-To: <20220409204557.4ul4ohf3tjtb37dx@skbuf>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
 <877d7yhwep.fsf@waldekranz.com> <20220409204557.4ul4ohf3tjtb37dx@skbuf>
Date:   Sun, 10 Apr 2022 20:02:13 +0200
Message-ID: <8735ikizq2.fsf@waldekranz.com>
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

On Sat, Apr 09, 2022 at 20:45, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> Hi Tobias,
>
> On Sat, Apr 09, 2022 at 09:46:54PM +0200, Tobias Waldekranz wrote:
>> On Fri, Apr 08, 2022 at 23:03, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>> > For this patch series to make more sense, it should be reviewed from the
>> > last patch to the first. Changes were made in the order that they were
>> > just to preserve patch-with-patch functionality.
>> >
>> > A little while ago, some DSA switch drivers gained support for
>> > IFF_UNICAST_FLT, a mechanism through which they are notified of the
>> > MAC addresses required for local standalone termination.
>> > A bit longer ago, DSA also gained support for offloading BR_FDB_LOCAL
>> > bridge FDB entries, which are the MAC addresses required for local
>> > termination when under a bridge.
>> >
>> > So we have come one step closer to removing the CPU from the list of
>> > destinations for packets with unknown MAC DA.What remains is to check
>> > whether any software L2 forwarding is enabled, and that is accomplished
>> > by monitoring the neighbor bridge ports that DSA switches have.
>> >
>> > With these changes, DSA drivers that fulfill the requirements for
>> > dsa_switch_supports_uc_filtering() and dsa_switch_supports_mc_filtering()
>> > will keep flooding towards the CPU disabled for as long as no port is
>> > promiscuous. The bridge won't attempt to make its ports promiscuous
>> > anymore either if said ports are offloaded by switchdev (this series
>> > changes that behavior). Instead, DSA will fall back by its own will to
>> > promiscuous mode on bridge ports when the bridge itself becomes
>> > promiscuous, or a foreign interface is detected under the same bridge.
>> 
>> Hi Vladimir,
>> 
>> Great stuff! I've added Joachim to Cc. He has been working on a series
>> to add support for configuring the equivalent of BR_FLOOD,
>> BR_MCAST_FLOOD, and BR_BCAST_FLOOD on the bridge itself. I.e. allowing
>> the user to specify how local_rcv is managed in br_handle_frame_finish.
>> 
>> For switchdev drivers, being able to query whether a bridge will ingress
>> unknown unicast to the host or not seems like the missing piece that
>> makes this bullet proof. I.e. if you have...
>> 
>> - No foreign interfaces
>> - No promisc
>> _and_
>> - No BR_FLOOD on the bridge itself
>> 
>> ..._then_ you can safely disable unicast flooding towards the CPU
>> port. The same would hold for multicast and BR_MCAST_FLOOD of course.
>> 
>> Not sure how close Joachim is to publishing his work. But I just thought
>> you two should know about the other one's work :)
>
> I haven't seen Joachim's work and I sure hope he can clarify.

If you want to get a feel for it, it is available here (the branch name
is just where he started out I think :))

https://github.com/westermo/linux/tree/bridge-always-flood-unknown-mcast

> It seems
> like there is some overlap that I don't currently know what to make of.
> The way I see things, BR_FLOOD and BR_MCAST_FLOOD are egress settings,
> so I'm not sure how to interpret them when applied to the bridge device
> itself.

They are egress settings, yes. But from the view of the forwarding
mechanism in the bridge, I would argue that the host interface is (or at
least should be) as much an egress port as any of the lower devices.

- It can be the target of an FDB entry
- It can be a member of an MDB entry

I.e. it can be chosen as a _destination_ => egress. This is analogous to
the CPU port, which from the ASICs point of view is an egress port, but
from a system POV it is receiving frames.

> On the other hand, treating IFF_PROMISC/IFF_ALLMULTI on the
> bridge device as the knob that decides whether the software bridge wants
> to ingress unknown MAC DA packets seems the more appropriate thing to do.

Maybe. I think it depends on how exact we want to be in our
classification. Fundementally, I think the problem is that a bridge
deals with one thing that other netdevs do not:

  Whether the destination in known/registered or not.

A NIC's unicast/multicast filters are not quite the same thing, because
a they only deal with a single endpoint. I.e. if an address isn't in a
NIC's list of known DA's, then it is "not mine". But in a bridge
scenario, although it is not associated with the host (i.e. "not mine"),
it can still be "known" (i.e. associated with some lower port).

AFAIK, promisc means "receive all the things!", whereas BR_FLOOD would
just select the subset of frames for which the destination is unknown.

Likewise for multicast, IFF_ALLMULTI means "receive _all_ multicast" -
it does not discriminate between registered and unregistered
flows. BR_MCAST_FLOOD OTOH would only target unregistered flows.

Here is my understanding of how the two solutions would differ in the
types of flows that they would affect:

                    .--------------------.-----------------.
                    |       IFF_*        |    BR_*FLOOD    |
.-------------------|---------.----------|-----.-----.-----|
| Type              | Promisc | Allmulti | BC  | UC  | MC  |
|-------------------|---------|----------|-----|-----|-----|
| Broadcast         | Yes     | No       | Yes | No  | No  |
| Unknown unicast   | Yes     | No       | No  | Yes | No  |
| Unknown multicast | Yes     | Yes      | No  | No  | Yes |
| Known unicast     | Yes     | No       | No  | No  | No  |
| Known multicast   | Yes     | Yes      | No  | No  | No  |
'-------------------'--------------------'-----------------'

