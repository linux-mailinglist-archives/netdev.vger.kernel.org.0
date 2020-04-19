Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750CE1AFD2F
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 20:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgDSSZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 14:25:38 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:44066 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgDSSZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 14:25:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587320736; x=1618856736;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k8cdMW074ZfFRY/CGfLm31wElhdaKPjYey6SG7vCANA=;
  b=xxbg6P57tiQd91yhGfRG2AiO2T6up5A/7R1uV+A7lnRAgn3f2PIcbdbH
   UOu6SGoFqwi8ajm+vba/uH76xbBKv5g1KV2QSQWRDwaQdORTiaOLXYtaB
   PYHkPvG4WmN1Su+bob33i9zH+n8KQAi1uTQwTRZk/wEl+gEdauifwG/r0
   NLq0tGopHQ1ORVxCvtPJFxG3MCheqRpecw/gJFjPwzkl9T/DCLBxK/jMg
   3o+oQYMXqppzm4JDlwamh0L8XNnrOiwXclHPLQimr6tpJBuOi52oneq+/
   GE3uuY1yTOlm8WZNcbBl8XTFydyBVOu/3mf/YYsfQqJ/rghJjNvJc1XHQ
   A==;
IronPort-SDR: PqgPkzhyO9Eb5nSqZ/Itkasd7OqJlbxeinB9kQnrJ7mwQy4ErxsnszG4VosglM+hysY4zd1b06
 pCdTUJcuAF7x7mlNRvZIafV2nlOGaH3lGxOeFeXn8PL84tfmI79azcJ1jiRFQgOsteuC90Dy2J
 OSuSHMCwNZ6ottIujZqnp+60iRkBe8P11Q643RT1RnvnMgxFQ+YpaJ+TvlY+3KeY3BA7cbOlZ4
 LMMZaH+LyaDgwCFPA8GdJG2T++WWrbDSwNjLywANbqsccAB8D6IMP5tkFiNw8bmPje5vnJjaUo
 5mk=
X-IronPort-AV: E=Sophos;i="5.72,404,1580799600"; 
   d="scan'208";a="73841863"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Apr 2020 11:25:36 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 19 Apr 2020 11:25:42 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sun, 19 Apr 2020 11:25:09 -0700
Date:   Sun, 19 Apr 2020 20:25:34 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
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
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: mscc: ocelot: deal with problematic
 MAC_ETYPE VCAP IS2 rules
Message-ID: <20200419182534.o42v5fiw34qxhenu@ws.localdomain>
References: <20200417190308.32598-1-olteanv@gmail.com>
 <20200419073307.uhm3w2jhsczpchvi@ws.localdomain>
 <CA+h21hrvSjRwDORZosxDt5YA+uMckaypT51f-COr+wtB7EjVAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+h21hrvSjRwDORZosxDt5YA+uMckaypT51f-COr+wtB7EjVAQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.04.2020 17:20, Vladimir Oltean wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On Sun, 19 Apr 2020 at 10:33, Allan W. Nielsen
><allan.nielsen@microchip.com> wrote:
>>
>> Hi,
>>
>> Sorry I did not manage to provide feedback before it was merged (I will
>> need to consult some of my colleagues Monday before I can provide the
>> foll feedback).
>>
>> There are many good things in this patch, but it is not only good.
>>
>> The problem is that these TCAMs/VCAPs are insanely complicated and it is
>> really hard to make them fit nicely into the existing tc frame-work
>> (being hard does not mean that we should not try).
>>
>> In this patch, you try to automatic figure out who the user want the
>> TCAM to be configured. It works for 1 use-case but it breaks others.
>>
>> Before this patch you could do a:
>>      tc filter add dev swp0 ingress protocol ipv4 \
>>              flower skip_sw src_ip 10.0.0.1 action drop
>>      tc filter add dev swp0 ingress \
>>              flower skip_sw src_mac 96:18:82:00:04:01 action drop
>>
>> But the second rule would not apply to the ICMP over IPv4 over Ethernet
>> packet, it would however apply to non-IP packets.
>>
>> With this patch it not possible. Your use-case is more common, but the
>> other one is not unrealistic.
>>
>> My concern with this, is that I do not think it is possible to automatic
>> detect how these TCAMs needs to be configured by only looking at the
>> rules installed by the user. Trying to do this automatic, also makes the
>> TCAM logic even harder to understand for the user.
>>
>> I would prefer that we by default uses some conservative default
>> settings which are easy to understand, and then expose some expert
>> settings in the sysfs, which can be used to achieve different
>> behavioral.
>>
>> Maybe forcing MAC_ETYPE matches is the most conservative and easiest to
>> understand default.
>>
>> But I do seem to recall that there is a way to allow matching on both
>> SMAC and SIP (your original motivation). This may be a better default
>> (despite that it consumes more TCAM resources). I will follow up and
>> check if this is possible.
>>
>> Vladimir (and anyone else whom interested): would you be interested in
>> spending some time discussion the more high-level architectures and
>> use-cases on how to best integrate this TCAM architecture into the Linux
>> kernel. Not sure on the outlook for the various conferences, but we
>> could arrange some online session to discuss this.
>>
>> /Allan
>>
>
>And yes, we would be very interested in attending a call for syncing
>up on integrating the TCAM hardware with the flow offload
>infrastructure from Linux. Actually at the moment we are trying to add
>support for offloaded VLAN retagging with the VCAP IS1 and ES0 blocks.

Sounds good - lets spend some time to talk discuss this and see what
comes out of it.

Ido, if you want to join us, pleaes comment with your preferences. If
others want to join please let me know.

I can setup a meeting in WebEx or Teams. I'm happy to join on other
platformws if you prefer. They both works fine from Linux in Chrome and
FireFox (sometimes tricky to get the sound working in FF).

Proposed agenda:

- Cover the TCAM architecture in Ocelot/Felix (just to make sure we are
   all on the same page).
- Present some use-cases MCHP would like to address in future.
- Open discussion.

I think we will need something between 30-120 minutes depending on how
the discussion goes.

We are in CEST time - and I'm okay to attend from 7-22.

What about you.

/Allan
