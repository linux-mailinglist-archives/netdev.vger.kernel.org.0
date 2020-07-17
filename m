Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BB12237D1
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 11:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgGQJIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 05:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgGQJIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 05:08:53 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE19C061755;
        Fri, 17 Jul 2020 02:08:53 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g20so7111236edm.4;
        Fri, 17 Jul 2020 02:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=L64mJp+Egw1Te+yzdOw1nlgMPdYcUDrBHl+mgtlrqpE=;
        b=OuVoW+T5PFzJyt1a1Cbu7qq6blQBpCwLBhz/kmPWKSSjjRLTr66hLNEVyq/gnDhkS1
         wq76RCO1L8hfZFl3LCWptbpViKPST+77ZMEc4QVmpG+YRkrHhD03SqmpjcNVEWDumC9h
         hnNKQFsaXl6jUkomtegIe0AM9wuTfqUnfIYh2rK/g5OXwpcd4pygMGHdKUCvI7fFMUOR
         2ZlxBaVpQMmbOs9IQ25jIpfX++XwSOYSKwJneZs0gauX19+ujjZHtzOMv3h6Xqf5PVlo
         pHLNz5M+y9gitMfM5np1+dXZiZVQCB1MYkaZq2nRXVTgCV0nFSGAqXnEDzjCc/uKupyr
         Z5pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=L64mJp+Egw1Te+yzdOw1nlgMPdYcUDrBHl+mgtlrqpE=;
        b=FgBTTvPUFKI7nW5cdYzQqLcCDalDQbK7O6VpYFi1ZYceiYdlWXeiZOdGJxLb+SapL9
         4t8UI3tQLPnJMpF2g291c/IxgyndhZL1f+1ZNV79GOUzK8b27F1pzIn0/Eqp/tZcRYPj
         G5UUp9GzbZiQmyDTX2t2OxdLDFpmPxcW+coVBMkuMNtmBRcNVET3p7J2OFnhJf/uwVTN
         p+rDCRhQsy/ISWibguPoF5IsVSkvpLqwFqOzubqhOaNNuRj+4Zc2KLlGLzqxolBFtZ+0
         NOZYojAP60cFSCCdJTW3pTUmn3yHxFnu8rZ0Jb6tzefzkcczLa5FlNplZ2UxrfsWOGR9
         6P6w==
X-Gm-Message-State: AOAM531ARS/OUHGEG8vCbheLHvDkjIIfxYj8rIgHgd9CF9NwlcyMlrId
        iQsRmwFPwAx+NZR1wWOChSk=
X-Google-Smtp-Source: ABdhPJw15PWnYDPNLg7EPMKzZaqpVWa8ICrohUmTl4FOHJ64tbZXIRaZw2O2shTb5fXhjnZuCDZhBQ==
X-Received: by 2002:a50:8d5a:: with SMTP id t26mr8671886edt.282.1594976931449;
        Fri, 17 Jul 2020 02:08:51 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id f10sm7589092edr.69.2020.07.17.02.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 02:08:50 -0700 (PDT)
Date:   Fri, 17 Jul 2020 12:08:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Joergen Andreasen <joergen.andreasen@microchip.com>
Cc:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
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
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Subject: Re: [EXT] Re: [PATCH v2 net-next 03/10] net: mscc: ocelot: allocated
 rules to different hardware VCAP TCAMs by chain index
Message-ID: <20200717090847.snxizsgaqebbwyui@skbuf>
References: <20200602083613.ddzjh54zxtbklytw@ws.localdomain>
 <CA+h21hocBOyuDFvnLq-sBEG5phaJPxbhvZ_P5H8HnTkBDv1x+w@mail.gmail.com>
 <20200608135633.jznoxwny6qtzxjng@ws.localdomain>
 <CA+h21hqoZdQeSxTtrEsVEHi6ZP1LrWKQGwZ9zPvjyWZ62TNfbg@mail.gmail.com>
 <20200610181802.2sqdhsoyrkd4awcg@ws.localdomain>
 <DB8PR04MB57851605ACFE209B4E54208EF07F0@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20200716085044.wzwdca535aa5oiv4@soft-dev16>
 <DB8PR04MB578594DD3C106D8BDE291B95F07F0@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20200716144519.4dftowe74by3syzk@skbuf>
 <20200717073411.vjjyq6ekhlqqnk2p@soft-dev16>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200717073411.vjjyq6ekhlqqnk2p@soft-dev16>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 09:34:11AM +0200, Joergen Andreasen wrote:
> The 07/16/2020 17:45, Vladimir Oltean wrote:
> > Hi Vladimir,
> > 
> > On Thu, Jul 16, 2020 at 10:37:40AM +0000, Xiaoliang Yang wrote:
> > > Hi Joergen,
> > >
> > >
> > > -----Original Message-----
> > > From: Joergen Andreasen <joergen.andreasen@microchip.com>
> > > Sent: 2020年7月16日 16:51
> > >
> > > > >> >> Chain 0:           The default chain - today this is in IS2. If we proceed
> > > > >> >>                     with this as is - then this will change.
> > > > >> >> Chain 1-9999:      These are offloaded by "basic" classification.
> > > > >> >> Chain 10000-19999: These are offloaded in IS1
> > > > >> >>                     Chain 10000: Lookup-0 in IS1, and here we could limit the
> > > > >> >>                                  action to do QoS related stuff (priority
> > > > >> >>                                  update)
> > > > >> >>                     Chain 11000: Lookup-1 in IS1, here we could do VLAN
> > > > >> >>                                  stuff
> > > > >> >>                     Chain 12000: Lookup-2 in IS1, here we could apply the
> > > > >> >>                                  "PAG" which is essentially a GOTO.
> > > > >> >>
> > > > >> >> Chain 20000-29999: These are offloaded in IS2
> > > > >> >>                     Chain 20000-20255: Lookup-0 in IS2, where CHAIN-ID -
> > > > >> >>                                        20000 is the PAG value.
> > > > >> >>                     Chain 21000-21000: Lookup-1 in IS2.
> > > > >> >>
> > > > >> >> All these chains should be optional - users should only need to
> > > > >> >> configure the chains they need. To make this work, we need to
> > > > >> >> configure both the desired actions (could be priority update) and the goto action.
> > > > >> >> Remember in HW, all packets goes through this process, while in
> > > > >> >> SW they only follow the "goto" path.
> > > > >> >>
> > > >>
> > > >> I agree with this chain assignment, following is an example to set rules:
> > > >>
> > > >> 1. Set a matchall rule for each chain, the last chain do not need goto chain action.
> > > >> # tc filter add dev swp0 chain 0 flower skip_sw action goto chain 10000
> > > >> # tc filter add dev swp0 chain 10000 flower skip_sw action goto chain 21000
> > > >> In driver, use these rules to register the chain.
> > > >>
> > > >> 2. Set normal rules.
> > > >> # tc filter add dev swp0 chain 10000 protocol 802.1Q parent ffff: flower skip_sw vlan_id 1 vlan_prio 1 action skbedit priority 1 action goto chain 21000
> > > >> # tc filter add dev swp0 chain 21000 protocol 802.1Q parent ffff: flower skip_sw vlan_id 1 vlan_prio 1 action drop
> > > >>
> > > >> In driver, we check if the chain ID has been registered, and goto
> > > >> chain is the same as first matchall rule, if is not, then return
> > > >> error. Each rule need has goto action except last chain.
> > > >>
> > > >> I also have check about chain template, it can not set an action
> > > >> template for each chain, so I think it's no use for our case. If
> > > >> this way to set rules is OK, I will update the patch to do as this.
> > > >>
> > > >> Thanks,
> > > >> Xiaoliang Yang
> > > >
> > >
> > > > I agree that you cannot set an action template for each chain but
> > > > you can set a match template which for example can be used for
> > > > setting up which IS1 key to generate for the device/port.
> > > > The template ensures that you cannot add an illegal match.
> > > > I have attached a snippet from a testcase I wrote in order to test these ideas.
> > > > Note that not all actions are valid for the hardware.
> > > >
> > > > SMAC       = "00:00:00:11:11:11"
> > > > DMAC       = "00:00:00:dd:dd:dd"
> > > > VID1       = 0x10
> > > > VID2       = 0x20
> > > > PCP1       = 3
> > > > PCP2       = 5
> > > > DEI        = 1
> > > > SIP        = "10.10.0.1"
> > > > DIP        = "10.10.0.2"
> > > >
> > > > IS1_L0     = 10000 # IS1 lookup 0
> > > > IS1_L1     = 11000 # IS1 lookup 1
> > > > IS1_L2     = 12000 # IS1 lookup 2
> > > >
> > > > IS2_L0     = 20000 # IS2 lookup 0 # IS2 20000 - 20255 -> pag 0-255
> > > > IS2_L0_P1  = 20001 # IS2 lookup 0 pag 1
> > > > IS2_L0_P2  = 20002 # IS2 lookup 0 pag 2
> > > >
> > > > IS2_L1     = 21000 # IS2 lookup 1
> > > >
> > > > $skip = "skip_hw" # or "skip_sw"
> > > >
> > > > test "Chain templates and goto" do
> > > >     t_i "'prio #' sets the sequence of filters. Lowest number = highest priority = checked first. 0..0xffff"
> > > >     t_i "'handle #' is a reference to the filter. Use this is if you need to reference the filter later. 0..0xffffffff"
> > > >     t_i "'chain #' is the chain to use. Chain 0 is the default. Different chains can have different templates. 0..0xffffffff"
> > > >     $ts.dut.run "tc qdisc add dev #{$dp[0]} clsact"
> > > >
> > > >     t_i "Add templates"
> > > >     t_i "Configure the VCAP port configuration to match the shortest key that fulfill the purpose"
> > >
> > > >     t_i "Create a template that sets IS1 lookup 0 to generate S1_NORMAL with S1_DMAC_DIP_ENA"
> > > >     t_i "If you match on both src and dst you will generate S1_7TUPLE"
> > > >     $ts.dut.run "tc chain add dev #{$dp[0]} ingress protocol ip chain #{IS1_L0} flower #{$skip} "\
> > > >                 "dst_mac 00:00:00:00:00:00 "\
> > > >                 "dst_ip 0.0.0.0 "
> > > >
> > > >     t_i "Create a template that sets IS1 lookup 1 to generate S1_5TUPLE_IP4"
> > > >     $ts.dut.run "tc chain add dev #{$dp[0]} ingress protocol ip chain #{IS1_L1} flower #{$skip} "\
> > > >                 "src_ip 0.0.0.0 "\
> > > >                 "dst_ip 0.0.0.0 "
> > > >
> > > >     t_i "Create a template that sets IS1 lookup 2 to generate S1_DBL_VID"
> > > >     $ts.dut.run "tc chain add dev #{$dp[0]} ingress protocol 802.1ad chain #{IS1_L2} flower #{$skip} "\
> > > >                 "vlan_id 0 "\
> > > >                 "vlan_prio 0 "\
> > > >                 "vlan_ethtype 802.1q "\
> > > >                 "cvlan_id 0 "\
> > > >                 "cvlan_prio 0 "
> > > >
> > > >     $ts.dut.run "tc chain show dev #{$dp[0]} ingress"
> > >
> > > Why you set different filter keys on different lookup? Each lookup
> > > only filter one type of keys?
> > > If I want to filter a same key like dst_mac and do both QoS classified
> > > action and vlan modify action, how to implement this in the same chain
> > > #{IS1_L0} ?
> > >
> > > I think it's more reasonable to distinguish different lookup by different action like this:
> > > IS1_L0     = 10000 # IS1 lookup 0     # do QoS classified action
> > > IS1_L1     = 11000 # IS1 lookup 1     # do vlan modify action
> > > IS1_L2     = 12000 # IS1 lookup 2     # do goto PAG action
> > >
> > > IS2_L0     = 20000 # IS2 lookup 0 # IS2 20000 - 20255 -> pag 0-255
> > > IS2_L1          = 21000 # IS2 lookup 1
> > >
> > > So it’s no need to add templates, each lookup can support filtering
> > > mac, IP or vlan tag, but only support one action.
> > >
> > > Thanks,
> > > Xiaoliang
> > 
> > As far as I understand, he's still using the static chain numbers
> > exactly for that, even though he didn't explicitly mention the action
> > for each individual IS1 lookup.
> > 
> > The reason why he's also adding templates on each individual chain is to
> > be able to configure VCAP_S1_KEY_CFG and VCAP_S2_CFG. The configuration
> > of key type is per lookup.
> > 
> > Honestly, Joergen, I would take dynamic key configuration per lookup as
> > a separate item. Xiaoliang's patch series for IS1 support is pretty
> > large already.
> > 
> > Right now we have:
> > 
> > - In mainline:
> > 
> > S2_IP6_CFG
> > S2_IP6_CFG controls the key generation for IPv6 frames. Bits 1:0
> > control the first lookup and bits 3:2 control the second lookup.
> > 0: IPv6 frames are matched against IP6_TCP_UDP or IP6_OTHER entries
> > 1: IPv6 frames are matched against IP6_STD entries
> > 2: IPv6 frames are matched against IP4_TCP_UDP or IP4_OTHER entries
> > 3: IPv6 frames are matched against MAC_ETYPE entries
> > 
> > We set this field to 0xa (0b1010, aka 2 for both lookups: IP4_TCP_UDP).
> > Although we don't really parse IPv6 keys coming from tc.
> > 
> > Also there are these fields which we're managing dynamically through
> > ocelot_match_all_as_mac_etype, depending on whether there is any
> > MAC_ETYPE key added by the user:
> > S2_SNAP_DIS
> > S2_ARP_DIS
> > S2_IP_TCPUDP_DIS
> > S2_IP_OTHER_DIS
> > 
> > - In Xiaoliang's patchset:
> > 
> > S1_KEY_IP6_CFG
> > Selects key per lookup in S1 for IPv6 frames.
> > 0: Use key S1_NORMAL
> > 1: Use key S1_7TUPLE
> > 2: Use key S1_5TUPLE_IP4
> > 3: Use key S1_NORMAL_IP6
> > 4: Use key S1_5TUPLE_IP6
> > 5: Use key S1_DBL_VID
> > 
> > We set this to 2.
> > 
> > S1_KEY_IP4_CFG
> > Selects key per lookup in S1 for IPv4 frames.
> > 0: Use key S1_NORMAL
> > 1: Use key S1_7TUPLE
> > 2: Use key S1_5TUPLE_IP4
> > 3: Use key S1_DBL_VID
> > 
> > We set this to 2.
> > 
> > Your input on which tc chain template could be used for each key type is
> > valuable, we should create a table with all the options and associated
> > key sizes (and therefore, number of available filters) and post it
> > somewhere. I'm not completely sure that chains will be enough to
> > describe every key type, at least not intuitively, For example if I just
> > want to match on EtherType (protocol), I'll need an ETYPE (IS1) or
> > MAC_ETYPE (IS2) rule, but the template for that will need to be
> > formulated in terms of dst_mac because I don't think there's a way to
> > use only the protocol in a template.
> > 
> > But I expect we keep using some default values (perhaps even the current
> > ones, or deduce a valid key type from the first added rule, which is
> > exactly what ocelot_match_all_as_mac_etype tries to do now) and don't
> > expect the user to open the datasheet unless some advanced configuration
> > is required. Otherwise I'm not sure who is going to use this. If the
> > user sees a template shell script with the chains already set up,
> > chances are it won't be too hard to add the right actions to the right
> > chains. But if that is going to involve fiddling with templates to set
> > up the right key type, when all they want is a source IPv4 address
> > match, well, no chance.
> > 
> > If we agree that templates won't be strictly necessary for basic
> > functionality, we can resubmit what we have already and think more about
> > the best way to expose all key types. I don't honestly know about using
> > a flower filter with 'protocol all' and no other key as a matchall
> > replacement. This is going to be really, really restrictive, and this
> > particular restriction could even be perhaps lifted in the meantime (I
> > don't see a reason why 'matchall' wouldn't be allowed in a chain with a
> > template installed).
> > 
> > But Xiaoliang has a point though: there is something which can never be
> > supported: if I want to do QoS based on a list of filters, some of which
> > need a S1_7TUPLE key, and others need a S1_NORMAL_IP6 key, then I can
> > never do that, because in our model, there's only one chain/lookup
> > reserved for QoS classification (a software constraint) but we need 2
> > chains/lookups for the 2 different key types (a hardware constraint).
> > Yes, this is something hypothetical at this point, but it bothers me
> > that the model would be limiting us. The hardware should support QoS
> > classification in more than 1 IS1 lookup, no? It isn't limited to
> > IS1_L0. Maybe, after all, we should permit dynamic assignment of actions
> > to chains. This way, "the QoS on multiple key types" use case could be
> > supported. What do you think?
> > 
> > Allan also mentioned shared blocks. Do we see anything particularly
> > difficult with those, that we should address first?
> > 
> > Thanks,
> > -Vladimir
> 
> I agree that dynamic key configuration per lookup should be taken as a separate item.
> I was just mentioning it because I think it is the only way to derive per port
> key type generation with the current 'tc' command set.
> 
> The hardware supports all kind of actions in all lookups but mixing QoS and VLAN
> actions in same lookup could be hard to understand for the user.
> 
> Let us say we want to apply a QoS action to <dip,dport> and a VLAN action to <dip>.
> The most specific rule (the QoS action) must be specified first in the TCAM and

Why must the rule with the most specific key be added first to the TCAM?
Is this in reply to my comment about deriving an appropriate key type
from the first filter introduced in each lookup?

> if it matches, the lookup terminates and no VLAN action is applied to <dip>.
> To solve this, the user must assign both QoS and VLAN action in the <dip,dport>
> rule which is probably not very intuitive.
> 

If so, can't we simply alter the priority of the filters, such that the
order in which they match on packets is not the same order as which they
were introduced by the user?

Supporting multiple actions per rule could be interesting, in the sense
that the hardware supports this feature and it would be therefore nice
if it could be exposed.

I've been re-reading the discussion with you and Allan, and to be
honest, I don't completely internalize why we are doing the
1-action-per-chain now. Sorry. It has been said that the TCAM stops on
first match in each lookup, and I understand that. So we must have,
in each filter's list of actions, not only the action we want (vlan,
skbedit priority, trap, drop, police), but also an explicit 'goto'
action to the next lookup or TCAM. But if 'stealing' frames is the
problem, then it's not just a QoS action that can steal frames from a
VLAN action. But instead, a QoS action can steal frames even from
another QoS action. I mean, in your example above, with a more generic
<dip> key and another more specific <dip,dport> key, there's nothing
about the action itself that is causing this 'stealing' to occur. So, I
don't really see why we are forcing a unique action per chain/lookup,
and how that, in itself, helps with anything. With my (certainly not as
deep as yours) understanding, just chaining a goto after each action
should be enough to keep the software and the hardware behavior
identical. I would really appreciate if you could clarify my
misunderstanding.

> The raseon for using a flower filter with an empty key as the final 'catch all'
> is that you cannot add a matchall filter in a chain configured with flower.
> I haven't checked how ineffective this is in the sw path but it works as expected.
> 

I realize now I didn't explicitly mention why the 'flower' instead of
'matchall' concerns me if we use templates, and that is because one of
the use cases we are interested in (which we are not covering in this
patch series) is masked matching on the raw first 4 bytes after
EtherType. This could be done with an u32 filter, and in hardware it
would use the L3_IP4_SIP field of an S1_NORMAL half key:

L3_IP4_SIP
Overloaded fields for different frame types:
LLC frame: L3_IP4_SIP = [CTRL, PAYLOAD[0:2]]
SNAP frame: L3_IP4_SIP = [PID[2:0], PAYLOAD[0]]
IPv4 or IPv6 frame: L3_IP4_SIP = source IP address, bits [31:0]
OAM, ARP or ETYPE frame: L3_IP4_SIP = PAYLOAD[0:3]  <- we have ETYPE frame
For IPv4 or IPv6 frames, use destination IP address if
VCAP_CFG.S1_DMAC_DIP_ENA is set for ingress port.

But if tc chain templates require us to not mix different types of
filters (such as matchall and flower, u32 and flower), I think it could
become very challenging.

> I don't see any problems with shared blocks. They could be used for setting
> IGR_PORT_MASK if you want to apply a filter to more than one interface.
> 

Ok, that's what I figured too.

> -- 
> Joergen Andreasen, Microchip

Thanks,
-Vladimir
