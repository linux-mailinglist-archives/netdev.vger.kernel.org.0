Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BD32235F3
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 09:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgGQHeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 03:34:17 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:5605 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgGQHeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 03:34:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594971258; x=1626507258;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=NwqMTa/LFxX2c399Xlq0zpZADfcUw1NykBsehlS+uug=;
  b=mkxVvu9Sn0bWRZBnqkWOIViwxwkNIl9WOj1QTH27HW32lUp0YwVdMTLF
   G0gd2PJtbR5TdjHvXyRx792pMcm+KSkJlrBoulEo9d5kaZyvWFVawDK4M
   CCdKU9gSiR+0w41fz5E+cp7qEzl/SwM3EZu8h6Sav+0jpvGmptyca5Cus
   cmyDmiLqFOk7zUEYlT6f2gcGZ7ZebbBv0ZtPqhmK4LaFh5hHfz2A1dDZw
   ypn9S32OJTqH+Xi+lzhPs2TOtBAO3puCTlyYAGsacsUcM0+zt0RGIavnV
   QfTs/gWvO/7Kgcbgq9OQivDt63bG1jsWDXcTkpkxCi6IsJf8uVC70C5Jn
   g==;
IronPort-SDR: vryBvgf2l9sYiZZD4VwXOj4s+vyh1f7vg/TBFTHfKfD843dGxTsB3kLxw79wQCzmanSbZeXPHT
 kio9b42oP4XxtIDv1EfpnpqeGuGoFTbLEERQphQ/VKS4mkW1Js2KQkKN1xl4SWdfkmjFtKQXo2
 SDbydm1HVuICiPkAiXrazWpNz3iaDjQXmM3Jza3XtrxuKnLM179RpOHxNW23mxazOS3NUMhf2/
 5219Ex1GS4jpNg/AzdxvF4n4fmBCNIoyEnBlmiB1m05R9ZVXOzD/7wUWGnJBSWFroBS6xAc61X
 tPU=
X-IronPort-AV: E=Sophos;i="5.75,362,1589266800"; 
   d="scan'208";a="83549071"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jul 2020 00:34:14 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 17 Jul 2020 00:34:13 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 17 Jul 2020 00:34:12 -0700
Date:   Fri, 17 Jul 2020 09:34:11 +0200
From:   Joergen Andreasen <joergen.andreasen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        "Ido Schimmel" <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Vinicius Costa Gomes" <vinicius.gomes@intel.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Horatiu Vultur" <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Subject: Re: [EXT] Re: [PATCH v2 net-next 03/10] net: mscc: ocelot: allocated
 rules to different hardware VCAP TCAMs by chain index
Message-ID: <20200717073411.vjjyq6ekhlqqnk2p@soft-dev16>
References: <20200602051828.5734-4-xiaoliang.yang_1@nxp.com>
 <20200602083613.ddzjh54zxtbklytw@ws.localdomain>
 <CA+h21hocBOyuDFvnLq-sBEG5phaJPxbhvZ_P5H8HnTkBDv1x+w@mail.gmail.com>
 <20200608135633.jznoxwny6qtzxjng@ws.localdomain>
 <CA+h21hqoZdQeSxTtrEsVEHi6ZP1LrWKQGwZ9zPvjyWZ62TNfbg@mail.gmail.com>
 <20200610181802.2sqdhsoyrkd4awcg@ws.localdomain>
 <DB8PR04MB57851605ACFE209B4E54208EF07F0@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20200716085044.wzwdca535aa5oiv4@soft-dev16>
 <DB8PR04MB578594DD3C106D8BDE291B95F07F0@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20200716144519.4dftowe74by3syzk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200716144519.4dftowe74by3syzk@skbuf>
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 07/16/2020 17:45, Vladimir Oltean wrote:
> Hi Vladimir,
> 
> On Thu, Jul 16, 2020 at 10:37:40AM +0000, Xiaoliang Yang wrote:
> > Hi Joergen,
> >
> >
> > -----Original Message-----
> > From: Joergen Andreasen <joergen.andreasen@microchip.com>
> > Sent: 2020年7月16日 16:51
> >
> > > >> >> Chain 0:           The default chain - today this is in IS2. If we proceed
> > > >> >>                     with this as is - then this will change.
> > > >> >> Chain 1-9999:      These are offloaded by "basic" classification.
> > > >> >> Chain 10000-19999: These are offloaded in IS1
> > > >> >>                     Chain 10000: Lookup-0 in IS1, and here we could limit the
> > > >> >>                                  action to do QoS related stuff (priority
> > > >> >>                                  update)
> > > >> >>                     Chain 11000: Lookup-1 in IS1, here we could do VLAN
> > > >> >>                                  stuff
> > > >> >>                     Chain 12000: Lookup-2 in IS1, here we could apply the
> > > >> >>                                  "PAG" which is essentially a GOTO.
> > > >> >>
> > > >> >> Chain 20000-29999: These are offloaded in IS2
> > > >> >>                     Chain 20000-20255: Lookup-0 in IS2, where CHAIN-ID -
> > > >> >>                                        20000 is the PAG value.
> > > >> >>                     Chain 21000-21000: Lookup-1 in IS2.
> > > >> >>
> > > >> >> All these chains should be optional - users should only need to
> > > >> >> configure the chains they need. To make this work, we need to
> > > >> >> configure both the desired actions (could be priority update) and the goto action.
> > > >> >> Remember in HW, all packets goes through this process, while in
> > > >> >> SW they only follow the "goto" path.
> > > >> >>
> > >>
> > >> I agree with this chain assignment, following is an example to set rules:
> > >>
> > >> 1. Set a matchall rule for each chain, the last chain do not need goto chain action.
> > >> # tc filter add dev swp0 chain 0 flower skip_sw action goto chain 10000
> > >> # tc filter add dev swp0 chain 10000 flower skip_sw action goto chain 21000
> > >> In driver, use these rules to register the chain.
> > >>
> > >> 2. Set normal rules.
> > >> # tc filter add dev swp0 chain 10000 protocol 802.1Q parent ffff: flower skip_sw vlan_id 1 vlan_prio 1 action skbedit priority 1 action goto chain 21000
> > >> # tc filter add dev swp0 chain 21000 protocol 802.1Q parent ffff: flower skip_sw vlan_id 1 vlan_prio 1 action drop
> > >>
> > >> In driver, we check if the chain ID has been registered, and goto
> > >> chain is the same as first matchall rule, if is not, then return
> > >> error. Each rule need has goto action except last chain.
> > >>
> > >> I also have check about chain template, it can not set an action
> > >> template for each chain, so I think it's no use for our case. If
> > >> this way to set rules is OK, I will update the patch to do as this.
> > >>
> > >> Thanks,
> > >> Xiaoliang Yang
> > >
> >
> > > I agree that you cannot set an action template for each chain but
> > > you can set a match template which for example can be used for
> > > setting up which IS1 key to generate for the device/port.
> > > The template ensures that you cannot add an illegal match.
> > > I have attached a snippet from a testcase I wrote in order to test these ideas.
> > > Note that not all actions are valid for the hardware.
> > >
> > > SMAC       = "00:00:00:11:11:11"
> > > DMAC       = "00:00:00:dd:dd:dd"
> > > VID1       = 0x10
> > > VID2       = 0x20
> > > PCP1       = 3
> > > PCP2       = 5
> > > DEI        = 1
> > > SIP        = "10.10.0.1"
> > > DIP        = "10.10.0.2"
> > >
> > > IS1_L0     = 10000 # IS1 lookup 0
> > > IS1_L1     = 11000 # IS1 lookup 1
> > > IS1_L2     = 12000 # IS1 lookup 2
> > >
> > > IS2_L0     = 20000 # IS2 lookup 0 # IS2 20000 - 20255 -> pag 0-255
> > > IS2_L0_P1  = 20001 # IS2 lookup 0 pag 1
> > > IS2_L0_P2  = 20002 # IS2 lookup 0 pag 2
> > >
> > > IS2_L1     = 21000 # IS2 lookup 1
> > >
> > > $skip = "skip_hw" # or "skip_sw"
> > >
> > > test "Chain templates and goto" do
> > >     t_i "'prio #' sets the sequence of filters. Lowest number = highest priority = checked first. 0..0xffff"
> > >     t_i "'handle #' is a reference to the filter. Use this is if you need to reference the filter later. 0..0xffffffff"
> > >     t_i "'chain #' is the chain to use. Chain 0 is the default. Different chains can have different templates. 0..0xffffffff"
> > >     $ts.dut.run "tc qdisc add dev #{$dp[0]} clsact"
> > >
> > >     t_i "Add templates"
> > >     t_i "Configure the VCAP port configuration to match the shortest key that fulfill the purpose"
> >
> > >     t_i "Create a template that sets IS1 lookup 0 to generate S1_NORMAL with S1_DMAC_DIP_ENA"
> > >     t_i "If you match on both src and dst you will generate S1_7TUPLE"
> > >     $ts.dut.run "tc chain add dev #{$dp[0]} ingress protocol ip chain #{IS1_L0} flower #{$skip} "\
> > >                 "dst_mac 00:00:00:00:00:00 "\
> > >                 "dst_ip 0.0.0.0 "
> > >
> > >     t_i "Create a template that sets IS1 lookup 1 to generate S1_5TUPLE_IP4"
> > >     $ts.dut.run "tc chain add dev #{$dp[0]} ingress protocol ip chain #{IS1_L1} flower #{$skip} "\
> > >                 "src_ip 0.0.0.0 "\
> > >                 "dst_ip 0.0.0.0 "
> > >
> > >     t_i "Create a template that sets IS1 lookup 2 to generate S1_DBL_VID"
> > >     $ts.dut.run "tc chain add dev #{$dp[0]} ingress protocol 802.1ad chain #{IS1_L2} flower #{$skip} "\
> > >                 "vlan_id 0 "\
> > >                 "vlan_prio 0 "\
> > >                 "vlan_ethtype 802.1q "\
> > >                 "cvlan_id 0 "\
> > >                 "cvlan_prio 0 "
> > >
> > >     $ts.dut.run "tc chain show dev #{$dp[0]} ingress"
> >
> > Why you set different filter keys on different lookup? Each lookup
> > only filter one type of keys?
> > If I want to filter a same key like dst_mac and do both QoS classified
> > action and vlan modify action, how to implement this in the same chain
> > #{IS1_L0} ?
> >
> > I think it's more reasonable to distinguish different lookup by different action like this:
> > IS1_L0     = 10000 # IS1 lookup 0     # do QoS classified action
> > IS1_L1     = 11000 # IS1 lookup 1     # do vlan modify action
> > IS1_L2     = 12000 # IS1 lookup 2     # do goto PAG action
> >
> > IS2_L0     = 20000 # IS2 lookup 0 # IS2 20000 - 20255 -> pag 0-255
> > IS2_L1          = 21000 # IS2 lookup 1
> >
> > So it’s no need to add templates, each lookup can support filtering
> > mac, IP or vlan tag, but only support one action.
> >
> > Thanks,
> > Xiaoliang
> 
> As far as I understand, he's still using the static chain numbers
> exactly for that, even though he didn't explicitly mention the action
> for each individual IS1 lookup.
> 
> The reason why he's also adding templates on each individual chain is to
> be able to configure VCAP_S1_KEY_CFG and VCAP_S2_CFG. The configuration
> of key type is per lookup.
> 
> Honestly, Joergen, I would take dynamic key configuration per lookup as
> a separate item. Xiaoliang's patch series for IS1 support is pretty
> large already.
> 
> Right now we have:
> 
> - In mainline:
> 
> S2_IP6_CFG
> S2_IP6_CFG controls the key generation for IPv6 frames. Bits 1:0
> control the first lookup and bits 3:2 control the second lookup.
> 0: IPv6 frames are matched against IP6_TCP_UDP or IP6_OTHER entries
> 1: IPv6 frames are matched against IP6_STD entries
> 2: IPv6 frames are matched against IP4_TCP_UDP or IP4_OTHER entries
> 3: IPv6 frames are matched against MAC_ETYPE entries
> 
> We set this field to 0xa (0b1010, aka 2 for both lookups: IP4_TCP_UDP).
> Although we don't really parse IPv6 keys coming from tc.
> 
> Also there are these fields which we're managing dynamically through
> ocelot_match_all_as_mac_etype, depending on whether there is any
> MAC_ETYPE key added by the user:
> S2_SNAP_DIS
> S2_ARP_DIS
> S2_IP_TCPUDP_DIS
> S2_IP_OTHER_DIS
> 
> - In Xiaoliang's patchset:
> 
> S1_KEY_IP6_CFG
> Selects key per lookup in S1 for IPv6 frames.
> 0: Use key S1_NORMAL
> 1: Use key S1_7TUPLE
> 2: Use key S1_5TUPLE_IP4
> 3: Use key S1_NORMAL_IP6
> 4: Use key S1_5TUPLE_IP6
> 5: Use key S1_DBL_VID
> 
> We set this to 2.
> 
> S1_KEY_IP4_CFG
> Selects key per lookup in S1 for IPv4 frames.
> 0: Use key S1_NORMAL
> 1: Use key S1_7TUPLE
> 2: Use key S1_5TUPLE_IP4
> 3: Use key S1_DBL_VID
> 
> We set this to 2.
> 
> Your input on which tc chain template could be used for each key type is
> valuable, we should create a table with all the options and associated
> key sizes (and therefore, number of available filters) and post it
> somewhere. I'm not completely sure that chains will be enough to
> describe every key type, at least not intuitively, For example if I just
> want to match on EtherType (protocol), I'll need an ETYPE (IS1) or
> MAC_ETYPE (IS2) rule, but the template for that will need to be
> formulated in terms of dst_mac because I don't think there's a way to
> use only the protocol in a template.
> 
> But I expect we keep using some default values (perhaps even the current
> ones, or deduce a valid key type from the first added rule, which is
> exactly what ocelot_match_all_as_mac_etype tries to do now) and don't
> expect the user to open the datasheet unless some advanced configuration
> is required. Otherwise I'm not sure who is going to use this. If the
> user sees a template shell script with the chains already set up,
> chances are it won't be too hard to add the right actions to the right
> chains. But if that is going to involve fiddling with templates to set
> up the right key type, when all they want is a source IPv4 address
> match, well, no chance.
> 
> If we agree that templates won't be strictly necessary for basic
> functionality, we can resubmit what we have already and think more about
> the best way to expose all key types. I don't honestly know about using
> a flower filter with 'protocol all' and no other key as a matchall
> replacement. This is going to be really, really restrictive, and this
> particular restriction could even be perhaps lifted in the meantime (I
> don't see a reason why 'matchall' wouldn't be allowed in a chain with a
> template installed).
> 
> But Xiaoliang has a point though: there is something which can never be
> supported: if I want to do QoS based on a list of filters, some of which
> need a S1_7TUPLE key, and others need a S1_NORMAL_IP6 key, then I can
> never do that, because in our model, there's only one chain/lookup
> reserved for QoS classification (a software constraint) but we need 2
> chains/lookups for the 2 different key types (a hardware constraint).
> Yes, this is something hypothetical at this point, but it bothers me
> that the model would be limiting us. The hardware should support QoS
> classification in more than 1 IS1 lookup, no? It isn't limited to
> IS1_L0. Maybe, after all, we should permit dynamic assignment of actions
> to chains. This way, "the QoS on multiple key types" use case could be
> supported. What do you think?
> 
> Allan also mentioned shared blocks. Do we see anything particularly
> difficult with those, that we should address first?
> 
> Thanks,
> -Vladimir

I agree that dynamic key configuration per lookup should be taken as a separate item.
I was just mentioning it because I think it is the only way to derive per port
key type generation with the current 'tc' command set.

The hardware supports all kind of actions in all lookups but mixing QoS and VLAN
actions in same lookup could be hard to understand for the user.

Let us say we want to apply a QoS action to <dip,dport> and a VLAN action to <dip>.
The most specific rule (the QoS action) must be specified first in the TCAM and
if it matches, the lookup terminates and no VLAN action is applied to <dip>.
To solve this, the user must assign both QoS and VLAN action in the <dip,dport>
rule which is probably not very intuitive.

The raseon for using a flower filter with an empty key as the final 'catch all'
is that you cannot add a matchall filter in a chain configured with flower.
I haven't checked how ineffective this is in the sw path but it works as expected.

I don't see any problems with shared blocks. They could be used for setting
IGR_PORT_MASK if you want to apply a filter to more than one interface.

-- 
Joergen Andreasen, Microchip
