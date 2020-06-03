Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF581ECD20
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 12:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgFCKEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 06:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbgFCKEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 06:04:39 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCB7C05BD43;
        Wed,  3 Jun 2020 03:04:38 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id z5so1537650ejb.3;
        Wed, 03 Jun 2020 03:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=44gyNKRHt4QF/vPRIOPJyLOrQtx4dtOeripUx2Nlv8Y=;
        b=gKWnowBAFeZweThi34HP6SpyklT6dtng6gCCETFHntSCx36eVq8ODAlKulPMIGFX20
         PQCB/DBjNY/wXR2JGFdCk7g/TFOkHnZVbOs3lDeRjO53Yflx8MSDPGr/Sgkm0wEg0UX4
         ObCOoBQ0u00ZETtMQVjSYWeFz7wWUBxIR+bZmxrKTGIbAtAtMPOTy8SH1omvJx6SicVG
         UcITMxvYjbnRdgxoLA+BnmbgoBSEh6KO4M3hINgq9vu0OH+lCpch+N9bv2JBg7mXS9rD
         2EF7hCTKcpNr/g+CLQy3pkfXXlh+nQMAQ3QkW859qX0J4jkQPb63W1wOSv40KqMrNddo
         YHng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=44gyNKRHt4QF/vPRIOPJyLOrQtx4dtOeripUx2Nlv8Y=;
        b=pjyqoULJp+QPApKAmzE5hHwKrf/jAFJCSS+CKEaF+kpRMLCPDyv5z6l2TM83BI8NSK
         h9QqlTe74CXxSdtxKkLGolVazNAOwghd4sm9M8+L9E2xEd1bbdOrMORcabLHDbp7klRY
         dBtEBQA4Sw1xv3HjzyQz6lPPJpgJYuCKB/cnSqhVKM1rvmMn/NITcRxaCJIg5ahQWhrh
         wt/V0U0DlNqbh9YH5/wb3awnNXOl+ca8dVu7q7pS1+P1w+0UWkxU+8ZFNoMv9dGAC2G7
         06aBVMMk7hq6m1a8t7UH7WX0mVxUuqazcxxs6bGHpjnRPlEaxWHu0RjuEJLHa36LPDex
         U87Q==
X-Gm-Message-State: AOAM530MhZrCrb7FYpLvUj8/SFHaMUiGVisONjultE4ZU7JTp9QofFPL
        a4+YlXmH63zAQ7XQhbzKt47bGtZGl38n+4B4Olk=
X-Google-Smtp-Source: ABdhPJyGUQAE20j514YO5FGAxASURlaiYnUxtxhO7GZO6wTsnnD6NLGXkhpGlyeJaJBxXunqSECxtR3GB8+JIjPX8fc=
X-Received: by 2002:a17:906:851:: with SMTP id f17mr15708901ejd.396.1591178677114;
 Wed, 03 Jun 2020 03:04:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
 <20200602051828.5734-4-xiaoliang.yang_1@nxp.com> <20200602083613.ddzjh54zxtbklytw@ws.localdomain>
In-Reply-To: <20200602083613.ddzjh54zxtbklytw@ws.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 3 Jun 2020 13:04:26 +0300
Message-ID: <CA+h21hocBOyuDFvnLq-sBEG5phaJPxbhvZ_P5H8HnTkBDv1x+w@mail.gmail.com>
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

On Tue, 2 Jun 2020 at 11:38, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> Hi Xiaoliang,
>
> Happy to see that you are moving in the directions of multi chain - this
> seems ilke a much better fit to me.
>
>
> On 02.06.2020 13:18, Xiaoliang Yang wrote:
> >There are three hardware TCAMs for ocelot chips: IS1, IS2 and ES0. Each
> >one supports different actions. The hardware flow order is: IS1->IS2->ES0.
> >
> >This patch add three blocks to store rules according to chain index.
> >chain 0 is offloaded to IS1, chain 1 is offloaded to IS2, and egress chain
> >0 is offloaded to ES0.
>
> Using "static" allocation to to say chain-X goes to TCAM Y, also seems
> like the right approach to me. Given the capabilities of the HW, this
> will most likely be the easiest scheme to implement and to explain to
> the end-user.
>
> But I think we should make some adjustments to this mapping schema.
>
> Here are some important "things" I would like to consider when defining
> this schema:
>
> - As you explain, we have 3 TCAMs (IS1, IS2 and ES0), but we have 3
>    parallel lookups in IS1 and 2 parallel lookups in IS2 - and also these
>    TCAMs has a wide verity of keys.
>
> - We can utilize these multiple parallel lookups such that it seems like
>    they are done in serial (that is if they do not touch the same
>    actions), but as they are done in parallel they can not influence each
>    other.
>
> - We can let IS1 influence the IS2 lookup (like the GOTO actions was
>    intended to be used).
>
> - The chip also has other QoS classification facilities which sits
>    before the TCAM (take a look at 3.7.3 QoS, DP, and DSCP Classification
>    in vsc7514 datasheet). It we at some point in time want to enable
>    this, then I think we need to do that in the same tc-flower framework.
>
> Here is my initial suggestion for an alternative chain-schema:
>
> Chain 0:           The default chain - today this is in IS2. If we proceed
>                     with this as is - then this will change.
> Chain 1-9999:      These are offloaded by "basic" classification.
> Chain 10000-19999: These are offloaded in IS1
>                     Chain 10000: Lookup-0 in IS1, and here we could limit the
>                                  action to do QoS related stuff (priority
>                                  update)
>                     Chain 11000: Lookup-1 in IS1, here we could do VLAN
>                                  stuff
>                     Chain 12000: Lookup-2 in IS1, here we could apply the
>                                  "PAG" which is essentially a GOTO.
>
> Chain 20000-29999: These are offloaded in IS2
>                     Chain 20000-20255: Lookup-0 in IS2, where CHAIN-ID -
>                                        20000 is the PAG value.
>                     Chain 21000-21000: Lookup-1 in IS2.
>
> All these chains should be optional - users should only need to
> configure the chains they need. To make this work, we need to configure
> both the desired actions (could be priority update) and the goto action.
> Remember in HW, all packets goes through this process, while in SW they
> only follow the "goto" path.
>
> An example could be (I have not tested this yet - sorry):
>
> tc qdisc add dev eth0 ingress
>
> # Activate lookup 11000. We can not do any other rules in chain 0, also
> # this implicitly means that we do not want any chains <11000.
> tc filter add dev eth0 parent ffff: chain 0
>     action
>     matchall goto 11000
>
> tc filter add dev eth0 parent ffff: chain 11000 \
>     flower src_mac 00:01:00:00:00:00/00:ff:00:00:00:00 \
>     action \
>     vlan modify id 1234 \
>     pipe \
>     goto 20001
>
> tc filter add dev eth0 parent ffff: chain 20001 ...
>
> Maybe it would be an idea to create some use-cases, implement them in a
> test which can pass with today's SW, and then once we have a common
> understanding of what we want, we can implement it?
>
> /Allan
>
> >Using action goto chain to express flow order as follows:
> >        tc filter add dev swp0 chain 0 parent ffff: flower skip_sw \
> >        action goto chain 1
> >
> >Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> >---
> > drivers/net/ethernet/mscc/ocelot_ace.c    | 51 +++++++++++++++--------
> > drivers/net/ethernet/mscc/ocelot_ace.h    |  7 ++--
> > drivers/net/ethernet/mscc/ocelot_flower.c | 46 +++++++++++++++++---
> > include/soc/mscc/ocelot.h                 |  2 +-
> > include/soc/mscc/ocelot_vcap.h            |  4 +-
> > 5 files changed, 81 insertions(+), 29 deletions(-)

> /Allan

What would be the advantage, from a user perspective, in exposing the
3 IS1 lookups as separate chains with orthogonal actions?
If the user wants to add an IS1 action that performs QoS
classification, VLAN classification and selects a custom PAG, they
would have to install 3 separate filters with the same key, each into
its own chain. Then the driver would be smart enough to figure out
that the 3 keys are actually the same, so it could merge them.
In comparison, we could just add a single filter to the IS1 chain,
with 3 actions (skbedit priority, vlan modify, goto is2).

Thanks,
-Vladimir
