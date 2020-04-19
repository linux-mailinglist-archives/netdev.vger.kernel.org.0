Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976FD1AFD21
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 20:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgDSSQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 14:16:10 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:8835 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDSSQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 14:16:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587320169; x=1618856169;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K3CK3ryNmsftM06N9mZxzR1LzWEp4k+m0jGRb2gZSIE=;
  b=atk0IlgImOor0ORNUz02DOgj+JVzPNrjGf1Y5DCKXR8k0bxYYmpluhFb
   drb8i5oWQIisyNV+0LR7ZAYxZgn5hfSXI7zfXEF9ND1RJfbmSvN5dphrc
   xE10987Z2zYWTtcPyebYdssRXqoPCGvyjFLePFZ5SK/PlVlaoGWHWW3E6
   5WwH8f1+qbLSFYVR372CQf7BOdMR3UIwHDmXbRPE4J4ZGqk6K6zhtYkEF
   zNYlK6BH+p098pLr8TS362E3eO3qHKdrHXBL8Oy9U94B5djTR9Oonggwl
   ND5M0Z6w5Oco2dLcsrOmEGjksVMDXTHTpb8brGq06MPpnTOpQhsK+cJab
   Q==;
IronPort-SDR: KgevY6AAmhPG9Du1TAISB/XTxMqixndgFfTPIJC4yuDxFTo/BYU6USSDEa0RkcuWi7FXxZM0ov
 AnF7PKQJ8MaOfhMAkX8OAq9z0kK+zofLPMFTpbL7vGX96oqwMHjjHB3MTrfsAfKGKELdetQB4c
 EBsra+cu2cmHoWXsqfmjD36tXOH9JCmyykRkx2OHCSoGrcwPiV6A/JsDh9Gp/98sHQVNwKjgxx
 7e3NSpE4U0nGOBk8ZmgW2J1cD6qFUo1MvvRCOaDYnaGPu0GdwhlWIhcdHM6CakApOqTitxVk9h
 msg=
X-IronPort-AV: E=Sophos;i="5.72,404,1580799600"; 
   d="scan'208";a="70827528"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Apr 2020 11:16:08 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 19 Apr 2020 11:15:42 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sun, 19 Apr 2020 11:16:07 -0700
Date:   Sun, 19 Apr 2020 20:16:06 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, Po Liu <po.liu@nxp.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: mscc: ocelot: deal with problematic
 MAC_ETYPE VCAP IS2 rules
Message-ID: <20200419181606.sei3q74s72cbigom@ws.localdomain>
References: <20200417190308.32598-1-olteanv@gmail.com>
 <20200419073307.uhm3w2jhsczpchvi@ws.localdomain>
 <20200419083032.GA3479405@splinter>
 <CA+h21hrqjXGUERKUXCWiciP7ZGnjhTeq=+ocMyP5msrKZ3pGSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+h21hrqjXGUERKUXCWiciP7ZGnjhTeq=+ocMyP5msrKZ3pGSw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.04.2020 15:47, Vladimir Oltean wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>Hi Ido, Allan,
>
>On Sun, 19 Apr 2020 at 11:30, Ido Schimmel <idosch@idosch.org> wrote:
>>
>> On Sun, Apr 19, 2020 at 09:33:07AM +0200, Allan W. Nielsen wrote:
>> > Hi,
>> >
>> > Sorry I did not manage to provide feedback before it was merged (I will
>> > need to consult some of my colleagues Monday before I can provide the
>> > foll feedback).
>> >
>> > There are many good things in this patch, but it is not only good.
>> >
>> > The problem is that these TCAMs/VCAPs are insanely complicated and it is
>> > really hard to make them fit nicely into the existing tc frame-work
>> > (being hard does not mean that we should not try).
>> >
>> > In this patch, you try to automatic figure out who the user want the
>> > TCAM to be configured. It works for 1 use-case but it breaks others.
>> >
>> > Before this patch you could do a:
>> >     tc filter add dev swp0 ingress protocol ipv4 \
>> >             flower skip_sw src_ip 10.0.0.1 action drop
>> >     tc filter add dev swp0 ingress \
>> >             flower skip_sw src_mac 96:18:82:00:04:01 action drop
>> >
>> > But the second rule would not apply to the ICMP over IPv4 over Ethernet
>> > packet, it would however apply to non-IP packets.
>> >
>> > With this patch it not possible. Your use-case is more common, but the
>> > other one is not unrealistic.
>> >
>> > My concern with this, is that I do not think it is possible to automatic
>> > detect how these TCAMs needs to be configured by only looking at the
>> > rules installed by the user. Trying to do this automatic, also makes the
>> > TCAM logic even harder to understand for the user.
>> >
>> > I would prefer that we by default uses some conservative default
>> > settings which are easy to understand, and then expose some expert
>> > settings in the sysfs, which can be used to achieve different
>> > behavioral.
>> >
>> > Maybe forcing MAC_ETYPE matches is the most conservative and easiest to
>> > understand default.
>> >
>> > But I do seem to recall that there is a way to allow matching on both
>> > SMAC and SIP (your original motivation). This may be a better default
>> > (despite that it consumes more TCAM resources). I will follow up and
>> > check if this is possible.
>> >
>> > Vladimir (and anyone else whom interested): would you be interested in
>> > spending some time discussion the more high-level architectures and
>> > use-cases on how to best integrate this TCAM architecture into the Linux
>> > kernel. Not sure on the outlook for the various conferences, but we
>> > could arrange some online session to discuss this.
>>
>> Not sure I completely understand the difficulties you are facing, but it
>> sounds similar to a problem we had in mlxsw. You might want to look into
>> "chain templates" [1] in order to restrict the keys that can be used
>> simultaneously.
>>
>> I don't mind participating in an online discussion if you think it can
>> help.
>>
>> [1] https://github.com/Mellanox/mlxsw/wiki/ACLs#chain-templates
>
>I think it is worth giving a bit of context on what motivated me to
>add this patch. Luckily I believe I can summarize it in a paragraph
>below.
>
>I am trying to understand practical ways in which IEEE 802.1CB can be
>used - an active redundancy mechanism similar to HSR/PRP which relies
>on sending sequence-numbered frame duplicates and eliminating those
>duplicates at the destination (as opposed to passive redundancy
>mechanisms such as RSTP, MRP etc which rely on BLOCKING port states to
>stop L2 forwarding loops from killing the network). So since 802.1CB
>needs a network where none of the port states can be put to BLOCKING
>(as that would break the forwarding of some of the replicated
>streams), I need a way to limit the impact of L2 loops. Currently I am
>using, rather successfully, an idea borrowed from HSR called
>"self-address filtering". It says that received packets can be dropped
>if their source MAC address matches the device's MAC address. This
>feature is useful for ensuring that packets never traverse a ring
>network more than once.
>To implement this idea, I use an offloaded tc-flower rule matching on
>src_mac with an action of "drop".
>
>To my surprise, such a src_mac rule does not do what's written on the
>box with the Ocelot switch flow classification engine called VCAP IS2.
>That is, packets having that src_mac would only get dropped if their
>protocol is not ARP, SNAP, IPv4, IPv6 and maybe others. Clearly such a
>rule is less than useful for the purpose we want it to.
>I did raise this concern here, and the suggestion that I got is to
>implement something like this patch, aka enable a port setting which
>forces matches on MAC_ETYPE keys only, regardless of higher-layer
>protocol information:
>https://lkml.org/lkml/2020/2/24/489
>So the default (pre-patch) behavior is for IP (and other) matches to
>be sane, at the expense of MAC matches being insane.
>Whereas the current behavior is for MAC matches to be sane, at the
>expense of IP matches becoming impossible as long as MAC rules are
>also present.
>In this context, Allan's complaint seems to be that the MAC matches
>were "good enough" for them, even if not all MAC address matches were
>caught, at least it did not prevent them from installing IP matching
>rules on the same port.
The truth is rather that what we have of now is still not capable
enough to solve the problems we need. This is why I'm keen on
discussion/brainstorm how more complicated scenarios can be supported.

>I may not have completely understood Ido's suggestion to use
>FLOW_CLS_TMPLT_CREATE (I might lack the imagination of how it can be
>put to practical use to solve the clash here), but I do believe that
>it is only a way for the driver to eliminate the guesswork out of the
>user's intention.
>In this case, my personal opinion is that the intention is absolutely
>clear: a classifier with src_mac should match on all frames having
>that src_mac (if that is not commonly agreed here, a good rule of
>thumb is to compare with what a non-offloaded tc filter rule does).
I think this is a good default behavioral.

But there are cases where people might want something different.

Also, here we are talking about a relatively small fraction of the TCAM
facilities in Ocelot/Felix. What I would like to is to consider the
entire system. Considering Felix it would be great if all these extended
(features implemented in user-space) could be fitted into the kernel.

>Whereas the "non-problematic" MAC matches that the VCAP IS2 _is_ able
>to still perform [ without calling ocelot_match_all_as_mac_etype ]
>should be expressed in terms of a more specific classification key to
>tc, such as:
>
>tc filter add dev swp0 ingress *protocol 0x88f7* flower src_mac
>96:18:82:00:04:01 action drop
>
>In the above case, because "protocol" is not ipv4, ipv6, arp, snap,
>then these rules can happily live together without ever needing to
>call ocelot_match_all_as_mac_etype. If we agree on this solution, I
>can send a patch that refines the ocelot_ace_is_problematic_mac_etype
>function.
>
>Thanks,
>-Vladimir

/Allan
