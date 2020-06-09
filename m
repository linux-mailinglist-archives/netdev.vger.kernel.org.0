Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612FC1F3B37
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 14:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgFIMzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 08:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728423AbgFIMzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 08:55:44 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F8CC05BD1E;
        Tue,  9 Jun 2020 05:55:43 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id f7so22249309ejq.6;
        Tue, 09 Jun 2020 05:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=twBkIA7u9f+VPT3r9Zqy3gbMTVsfa7xMmgIFIMbUFIY=;
        b=r1yPZfHsgTCQrGyaek8FOM89tZsVVEsuSo+jsZxtihm7ZRfqLxQKdprmg1jpcg2kLT
         yXVHH4NzBPjbOtAbP82IyPCIR9xkGbrn2WeRWbPuC9lZRR8IEJYfqtzYH5kHPvkP9RY8
         +EG1AiNkWUaPNeItCqdQVuUS+A2Z2zla69NNtmqzyDCOIpVNldApCf9B8gJ0pYM7PTWE
         UQjsyg+gilEOSKrrZwZGTLR2rW9QpT74+aTmxv2LhnW5ptX7PspBsGxt0Vn8B4IYa57c
         Flz7CU39PWMlE54CUZ17EOVQxzC+VbqkzHArfyGEjptRwr6tLtOZzLiimlxSQ1dMWILM
         l6Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=twBkIA7u9f+VPT3r9Zqy3gbMTVsfa7xMmgIFIMbUFIY=;
        b=PSa8qDkNa4ab8QorO4K3bTF6ySREBHzvbF2A4HKoFxb6lGPxNYIkdZJ6+cZYMZVC4S
         qtRgcN8wwr0QkG3FhtUMYXTQRP/66fZ9uzYpvrb1nemWBpw0tZ0wOSHyWyFuQBbtAmpR
         DEK9CyUhAq8UCF+gTpnrHd83pNzfaZ8SGaqnwrjVxEG2jz10JH3PJR/FAZ0QGt85nmxf
         VR9Rm0wQKwDAUq2//aYS9Rol5x+8lVSBVpUIA9DqcoiM7LPJIkdiw8Bvk8h71voqnvWg
         shH68TeQ63df1QBNgP98Ncb0ZjRwbSBj6RkWwGaUg3E71AJkq5ugMEXkUsq8cb8lhwU/
         EebA==
X-Gm-Message-State: AOAM531STq26lqQOmtujFZwQKBfc189oOG7svQUfklglORNfT7lCzYkN
        OZLaKzhIXqcJ8gc6TND8T3raiDPxjzJWfBDyRDE=
X-Google-Smtp-Source: ABdhPJyE7gsr/LHXA73J15XoZfrEbg35C0UBvyeY5/1a4KsnRGBl70NnTA91GhGaPV7Jn2ubmT5NsQ3DJiBm7pgtbNU=
X-Received: by 2002:a17:906:1d56:: with SMTP id o22mr24907753ejh.406.1591707342353;
 Tue, 09 Jun 2020 05:55:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
 <20200602051828.5734-4-xiaoliang.yang_1@nxp.com> <20200602083613.ddzjh54zxtbklytw@ws.localdomain>
 <CA+h21hocBOyuDFvnLq-sBEG5phaJPxbhvZ_P5H8HnTkBDv1x+w@mail.gmail.com> <20200608135633.jznoxwny6qtzxjng@ws.localdomain>
In-Reply-To: <20200608135633.jznoxwny6qtzxjng@ws.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 9 Jun 2020 15:55:31 +0300
Message-ID: <CA+h21hqoZdQeSxTtrEsVEHi6ZP1LrWKQGwZ9zPvjyWZ62TNfbg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 03/10] net: mscc: ocelot: allocated rules to
 different hardware VCAP TCAMs by chain index
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        linux-devel@linux.nxdi.nxp.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Allan,

On Mon, 8 Jun 2020 at 16:56, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> On 03.06.2020 13:04, Vladimir Oltean wrote:
> >On Tue, 2 Jun 2020 at 11:38, Allan W. Nielsen
> ><allan.nielsen@microchip.com> wrote:
> >>
> >> Hi Xiaoliang,
> >>
> >> Happy to see that you are moving in the directions of multi chain - this
> >> seems ilke a much better fit to me.
> >>
> >>
> >> On 02.06.2020 13:18, Xiaoliang Yang wrote:
> >> >There are three hardware TCAMs for ocelot chips: IS1, IS2 and ES0. Each
> >> >one supports different actions. The hardware flow order is: IS1->IS2->ES0.
> >> >
> >> >This patch add three blocks to store rules according to chain index.
> >> >chain 0 is offloaded to IS1, chain 1 is offloaded to IS2, and egress chain
> >> >0 is offloaded to ES0.
> >>
> >> Using "static" allocation to to say chain-X goes to TCAM Y, also seems
> >> like the right approach to me. Given the capabilities of the HW, this
> >> will most likely be the easiest scheme to implement and to explain to
> >> the end-user.
> >>
> >> But I think we should make some adjustments to this mapping schema.
> >>
> >> Here are some important "things" I would like to consider when defining
> >> this schema:
> >>
> >> - As you explain, we have 3 TCAMs (IS1, IS2 and ES0), but we have 3
> >>    parallel lookups in IS1 and 2 parallel lookups in IS2 - and also these
> >>    TCAMs has a wide verity of keys.
> >>
> >> - We can utilize these multiple parallel lookups such that it seems like
> >>    they are done in serial (that is if they do not touch the same
> >>    actions), but as they are done in parallel they can not influence each
> >>    other.
> >>
> >> - We can let IS1 influence the IS2 lookup (like the GOTO actions was
> >>    intended to be used).
> >>
> >> - The chip also has other QoS classification facilities which sits
> >>    before the TCAM (take a look at 3.7.3 QoS, DP, and DSCP Classification
> >>    in vsc7514 datasheet). It we at some point in time want to enable
> >>    this, then I think we need to do that in the same tc-flower framework.
> >>
> >> Here is my initial suggestion for an alternative chain-schema:
> >>
> >> Chain 0:           The default chain - today this is in IS2. If we proceed
> >>                     with this as is - then this will change.
> >> Chain 1-9999:      These are offloaded by "basic" classification.
> >> Chain 10000-19999: These are offloaded in IS1
> >>                     Chain 10000: Lookup-0 in IS1, and here we could limit the
> >>                                  action to do QoS related stuff (priority
> >>                                  update)
> >>                     Chain 11000: Lookup-1 in IS1, here we could do VLAN
> >>                                  stuff
> >>                     Chain 12000: Lookup-2 in IS1, here we could apply the
> >>                                  "PAG" which is essentially a GOTO.
> >>
> >> Chain 20000-29999: These are offloaded in IS2
> >>                     Chain 20000-20255: Lookup-0 in IS2, where CHAIN-ID -
> >>                                        20000 is the PAG value.
> >>                     Chain 21000-21000: Lookup-1 in IS2.
> >>
> >> All these chains should be optional - users should only need to
> >> configure the chains they need. To make this work, we need to configure
> >> both the desired actions (could be priority update) and the goto action.
> >> Remember in HW, all packets goes through this process, while in SW they
> >> only follow the "goto" path.
> >>
> >> An example could be (I have not tested this yet - sorry):
> >>
> >> tc qdisc add dev eth0 ingress
> >>
> >> # Activate lookup 11000. We can not do any other rules in chain 0, also
> >> # this implicitly means that we do not want any chains <11000.
> >> tc filter add dev eth0 parent ffff: chain 0
> >>     action
> >>     matchall goto 11000
> >>
> >> tc filter add dev eth0 parent ffff: chain 11000 \
> >>     flower src_mac 00:01:00:00:00:00/00:ff:00:00:00:00 \
> >>     action \
> >>     vlan modify id 1234 \
> >>     pipe \
> >>     goto 20001
> >>
> >> tc filter add dev eth0 parent ffff: chain 20001 ...
> >>
> >> Maybe it would be an idea to create some use-cases, implement them in a
> >> test which can pass with today's SW, and then once we have a common
> >> understanding of what we want, we can implement it?
> >>
> >> /Allan
> >>
> >> >Using action goto chain to express flow order as follows:
> >> >        tc filter add dev swp0 chain 0 parent ffff: flower skip_sw \
> >> >        action goto chain 1
> >> >
> >> >Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> >> >---
> >> > drivers/net/ethernet/mscc/ocelot_ace.c    | 51 +++++++++++++++--------
> >> > drivers/net/ethernet/mscc/ocelot_ace.h    |  7 ++--
> >> > drivers/net/ethernet/mscc/ocelot_flower.c | 46 +++++++++++++++++---
> >> > include/soc/mscc/ocelot.h                 |  2 +-
> >> > include/soc/mscc/ocelot_vcap.h            |  4 +-
> >> > 5 files changed, 81 insertions(+), 29 deletions(-)
> >
> >> /Allan
> >
> >What would be the advantage, from a user perspective, in exposing the
> >3 IS1 lookups as separate chains with orthogonal actions?
> >If the user wants to add an IS1 action that performs QoS
> >classification, VLAN classification and selects a custom PAG, they
> >would have to install 3 separate filters with the same key, each into
> >its own chain. Then the driver would be smart enough to figure out
> >that the 3 keys are actually the same, so it could merge them.
> >In comparison, we could just add a single filter to the IS1 chain,
> >with 3 actions (skbedit priority, vlan modify, goto is2).
>
> Hi, I realize I forgot to answer this one - sorry.
>
> The reason for this design is that we have use-cases where the rules to
> do QoS classification must not impact VLAN classification. The easiest
> way to do that, it to have it in separated lookups.
>

Impact in the sense that an IS1 rule for VLAN classification might
'steal' packets from an IS1 rule for QoS classification (since the
TCAM stops after the first matching entry in each lookup)?
Such as:

tc filter add dev swp0 ingress protocol 802.1Q flower vlan_ethtype
ipv4 action skbedit priority 3
tc filter add dev swp0 ingress protocol 802.1Q flower vlan_id 0
vlan_prio 2 action vlan modify id 12 priority 1

The trouble with this TCAM seems to be that it doesn't support the
'pipe' control, so rules on overlapping keys will have unpredictable
results. So if we had these 2 rules in the same lookup in hardware,
then an IPv4 packet tagged with VID 0 and PCP 2 would get classified
to QoS class 3 but would not get retagged to VID 12 PCP 1, right?

So we should error out if the rule's control is 'pipe' (I haven't
checked if we can do that, I hope we can), and basically only 'goto'
something.
Which brings the discussion to "goto where?".
From the IS1 chain for QoS classification, you could goto the IS1
chain for VLAN classification, ok, that's your example. Is this goto
optional? (i.e. can you goto a PAG in IS2 directly, and in that case
would VLAN classification be skipped in hardware for the packets that
skip it in software?)
Your suggestion of having an entire chain for PAG selection suggests
to me that the rules in chain 10000 (IS1 for QoS classification) would
need to have a non-optional goto to chain 11000 (IS1 for VLAN
classification), which in turn would have a non-optional goto to chain
12000, where there would be a bunch of rules with just a goto action
that selects the IS2 policy. You can't have a goto from chains 10000
or 11000 directly into an IS2 chain (either the default policy of 0 or
a custom one).

> But we could make this more flexible to support your use-case better. A
> alternative approach would be to assign exclusive-right-to-action on
> first use. If the user choose to use the VLAN update in a given loopup,
> then it cannot be used in others.
>
> If the user attempt to use a given action across different lookups we
> need to return an error.
>
> Would that work for you? Any downside in such approach?
>
> /Allan
>

No, I definitely wasn't trying to suggest that.
If I understand correctly what you're proposing, then I don't
necessarily have anything against breaking compatibility with the
current single-chain layout. Our users will definitely need an extra
book for filling in TCAM filters (the other one being on how to use tc
in general), but on the other hand, at the end of the day, having
things like the actions rigidly assigned to static id's per chain is
the more sane thing to do given the TCAM design.

My only concern was literally that duplicating filter keys in a bunch
of different chains (all of which eventually land in the same TCAM,
just in different lookups) might result in waste of TCAM space. In
Felix, VCAP IS1 has space for 512 half key entries.
Consider just the trivial example when the user wants to do something like:

tc filter add dev swp0 ingress protocol 802.1Q flower \
        vlan_ethtype ipv4 src_ip 192.168.1.1 \
        action skbedit priority 1 \
        action vlan modify id 101 priority 1
tc filter add dev swp0 ingress protocol 802.1Q flower \
        vlan_ethtype ipv4 src_ip 192.168.1.2 \
        action skbedit priority 2 \
        action vlan modify id 101 priority 2

and 100 more rules like that.
With a forced "1-action-per-chain" split, the rules would have to look
like this:

Chain 10000:
tc filter add dev swp0 ingress protocol 802.1Q flower \
        vlan_ethtype ipv4 src_ip 192.168.1.1 \
        action skbedit priority 1
tc filter add dev swp0 ingress protocol 802.1Q flower \
        vlan_ethtype ipv4 src_ip 192.168.1.2 \
        action skbedit priority 2

Chain 11000:
tc filter add dev swp0 ingress protocol 802.1Q flower \
        vlan_ethtype ipv4 src_ip 192.168.1.1 \
        action vlan modify id 101 priority 1
tc filter add dev swp0 ingress protocol 802.1Q flower \
        vlan_ethtype ipv4 src_ip 192.168.1.2 \
        action vlan modify id 101 priority 2

So I would just like to avoid this latter approach consuming 200
entries. It sounds to me like it would need pretty complicated
bookkeeping in the driver.

Also, another topic: would the lookups in VCAP IS2 be ever exposed to
the user? Looking at the VSC7514 datasheet Table 60 "MASK_MODE and
PORT_MASK Combinations" (for how the action vectors resulted from
different lookups combine into a single result), I think it's
relatively difficult to make sense out of it.

And last question: why the large spacing between chain IDs in your example?

Thanks,
-Vladimir
