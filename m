Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC90B1F1A76
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 15:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729829AbgFHN4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 09:56:37 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12407 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728799AbgFHN4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 09:56:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1591624595; x=1623160595;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bVJ4KOa8pad+GQLBr/cyk0fAVQ9B94wv/q+cz6Xt+bE=;
  b=sV7kmoaNmFKjPSyZH7gRFW8deZhEfE2ShIZgGhHARKkmmn8Qzib12rrb
   tSCU59hnsvAMdQYMSEJYfooyzfsRmGFTWSaX7of4YI28AodBSC1a7Ylo1
   wsdOWUqXYAHaFt7/5TnbqANrAg+Qm0GYZSq/Z5eSkUpQNeutT6JySokW3
   6gDJsTxLMUCsOh6CV+a1IUJNdPj3THBFFj1cMY4ZTwMPbWzqAg7KoWLlC
   4ebAVkvo+hdaq0N/7Dp7gI7cdwVKWZsCulafcmyLZkA9XMvAso983fzRI
   IKWW6K3yGXlvx9JxWwfW6nbSR7pxqE5TgOs24Ll23xFjSqAB08jzIcRED
   A==;
IronPort-SDR: C8Xr94BcqocK4nupxF/eU6NtUd/Pt+swdFdKKd1as8NeZNtO+mEnOwZQ9wMZLtv41zGoD82pQO
 riVvhJyXZr6usnhzjq01Vfcm8OCNPlA5W3K50XjPC78GIxlfIEe2QjlLE0PbWBDt06xpFPOnY7
 2a3RmTZtHJLmcEC7L9V9GPhLEgo+wpHzR9rXNiObtN92tm/6swfRNpl5i3Qg+TzF9Y+kTWlZAL
 uRPIK1a9qc/JDDno7tU59OD3Araj9k0JLKJraLFJuPsN1PRBVTrSDJX17uIC5A1ihISmRJu7CA
 d3I=
X-IronPort-AV: E=Sophos;i="5.73,487,1583218800"; 
   d="scan'208";a="82649276"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jun 2020 06:56:34 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 8 Jun 2020 06:56:32 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1847.3 via Frontend
 Transport; Mon, 8 Jun 2020 06:56:34 -0700
Date:   Mon, 8 Jun 2020 15:56:33 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Li Yang" <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jiri Pirko" <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "Nikolay Aleksandrov" <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        <linux-devel@linux.nxdi.nxp.com>
Subject: Re: [PATCH v2 net-next 03/10] net: mscc: ocelot: allocated rules to
 different hardware VCAP TCAMs by chain index
Message-ID: <20200608135633.jznoxwny6qtzxjng@ws.localdomain>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
 <20200602051828.5734-4-xiaoliang.yang_1@nxp.com>
 <20200602083613.ddzjh54zxtbklytw@ws.localdomain>
 <CA+h21hocBOyuDFvnLq-sBEG5phaJPxbhvZ_P5H8HnTkBDv1x+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+h21hocBOyuDFvnLq-sBEG5phaJPxbhvZ_P5H8HnTkBDv1x+w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.06.2020 13:04, Vladimir Oltean wrote:
>On Tue, 2 Jun 2020 at 11:38, Allan W. Nielsen
><allan.nielsen@microchip.com> wrote:
>>
>> Hi Xiaoliang,
>>
>> Happy to see that you are moving in the directions of multi chain - this
>> seems ilke a much better fit to me.
>>
>>
>> On 02.06.2020 13:18, Xiaoliang Yang wrote:
>> >There are three hardware TCAMs for ocelot chips: IS1, IS2 and ES0. Each
>> >one supports different actions. The hardware flow order is: IS1->IS2->ES0.
>> >
>> >This patch add three blocks to store rules according to chain index.
>> >chain 0 is offloaded to IS1, chain 1 is offloaded to IS2, and egress chain
>> >0 is offloaded to ES0.
>>
>> Using "static" allocation to to say chain-X goes to TCAM Y, also seems
>> like the right approach to me. Given the capabilities of the HW, this
>> will most likely be the easiest scheme to implement and to explain to
>> the end-user.
>>
>> But I think we should make some adjustments to this mapping schema.
>>
>> Here are some important "things" I would like to consider when defining
>> this schema:
>>
>> - As you explain, we have 3 TCAMs (IS1, IS2 and ES0), but we have 3
>>    parallel lookups in IS1 and 2 parallel lookups in IS2 - and also these
>>    TCAMs has a wide verity of keys.
>>
>> - We can utilize these multiple parallel lookups such that it seems like
>>    they are done in serial (that is if they do not touch the same
>>    actions), but as they are done in parallel they can not influence each
>>    other.
>>
>> - We can let IS1 influence the IS2 lookup (like the GOTO actions was
>>    intended to be used).
>>
>> - The chip also has other QoS classification facilities which sits
>>    before the TCAM (take a look at 3.7.3 QoS, DP, and DSCP Classification
>>    in vsc7514 datasheet). It we at some point in time want to enable
>>    this, then I think we need to do that in the same tc-flower framework.
>>
>> Here is my initial suggestion for an alternative chain-schema:
>>
>> Chain 0:           The default chain - today this is in IS2. If we proceed
>>                     with this as is - then this will change.
>> Chain 1-9999:      These are offloaded by "basic" classification.
>> Chain 10000-19999: These are offloaded in IS1
>>                     Chain 10000: Lookup-0 in IS1, and here we could limit the
>>                                  action to do QoS related stuff (priority
>>                                  update)
>>                     Chain 11000: Lookup-1 in IS1, here we could do VLAN
>>                                  stuff
>>                     Chain 12000: Lookup-2 in IS1, here we could apply the
>>                                  "PAG" which is essentially a GOTO.
>>
>> Chain 20000-29999: These are offloaded in IS2
>>                     Chain 20000-20255: Lookup-0 in IS2, where CHAIN-ID -
>>                                        20000 is the PAG value.
>>                     Chain 21000-21000: Lookup-1 in IS2.
>>
>> All these chains should be optional - users should only need to
>> configure the chains they need. To make this work, we need to configure
>> both the desired actions (could be priority update) and the goto action.
>> Remember in HW, all packets goes through this process, while in SW they
>> only follow the "goto" path.
>>
>> An example could be (I have not tested this yet - sorry):
>>
>> tc qdisc add dev eth0 ingress
>>
>> # Activate lookup 11000. We can not do any other rules in chain 0, also
>> # this implicitly means that we do not want any chains <11000.
>> tc filter add dev eth0 parent ffff: chain 0
>>     action
>>     matchall goto 11000
>>
>> tc filter add dev eth0 parent ffff: chain 11000 \
>>     flower src_mac 00:01:00:00:00:00/00:ff:00:00:00:00 \
>>     action \
>>     vlan modify id 1234 \
>>     pipe \
>>     goto 20001
>>
>> tc filter add dev eth0 parent ffff: chain 20001 ...
>>
>> Maybe it would be an idea to create some use-cases, implement them in a
>> test which can pass with today's SW, and then once we have a common
>> understanding of what we want, we can implement it?
>>
>> /Allan
>>
>> >Using action goto chain to express flow order as follows:
>> >        tc filter add dev swp0 chain 0 parent ffff: flower skip_sw \
>> >        action goto chain 1
>> >
>> >Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
>> >---
>> > drivers/net/ethernet/mscc/ocelot_ace.c    | 51 +++++++++++++++--------
>> > drivers/net/ethernet/mscc/ocelot_ace.h    |  7 ++--
>> > drivers/net/ethernet/mscc/ocelot_flower.c | 46 +++++++++++++++++---
>> > include/soc/mscc/ocelot.h                 |  2 +-
>> > include/soc/mscc/ocelot_vcap.h            |  4 +-
>> > 5 files changed, 81 insertions(+), 29 deletions(-)
>
>> /Allan
>
>What would be the advantage, from a user perspective, in exposing the
>3 IS1 lookups as separate chains with orthogonal actions?
>If the user wants to add an IS1 action that performs QoS
>classification, VLAN classification and selects a custom PAG, they
>would have to install 3 separate filters with the same key, each into
>its own chain. Then the driver would be smart enough to figure out
>that the 3 keys are actually the same, so it could merge them.
>In comparison, we could just add a single filter to the IS1 chain,
>with 3 actions (skbedit priority, vlan modify, goto is2).

Hi, I realize I forgot to answer this one - sorry.

The reason for this design is that we have use-cases where the rules to
do QoS classification must not impact VLAN classification. The easiest
way to do that, it to have it in separated lookups.

But we could make this more flexible to support your use-case better. A
alternative approach would be to assign exclusive-right-to-action on
first use. If the user choose to use the VLAN update in a given loopup,
then it cannot be used in others.

If the user attempt to use a given action across different lookups we
need to return an error.

Would that work for you? Any downside in such approach?

/Allan

