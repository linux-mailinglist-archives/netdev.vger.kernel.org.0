Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB08769BFE1
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 10:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjBSJuZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 19 Feb 2023 04:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjBSJuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 04:50:24 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717A326B2;
        Sun, 19 Feb 2023 01:49:44 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id bg25-20020a05600c3c9900b003e21af96703so1258012wmb.2;
        Sun, 19 Feb 2023 01:49:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/rPhwQ3nrkS0jghgazOf4raJ/t34wjX5r29z/0Bns5o=;
        b=AhU/kF4OFQgF5JIQ+g76Le9tXV8Zq8FvFg6XlZfaTNg1WXBtYtZ1ptLuhbHy3Hcus7
         QX/YsYQTuRAoD7iIySpHGQ1I0qsGCU3/VNNaigciO6s3UiDLSe6CHqk9bNhZ7IiyPDb9
         /px1kU08XKYkQGD6792P9DBS1ZSbksi5WlvXKF6Jhw8cpocPQt8MnoSyd2QgCWCIxXP5
         98MmJJuKNiEbyJfr5BLwqzZrhyVfDAc8kfbirQZEFHc2gyN/m2azxjrPQLYTEJO1un6N
         qkzGBJK9pjM+ojY3S+TSPDYpNuxmDzxO+qq9yxoOKhhlLEgdEO2381aZPoAzlMzhBXVH
         tvaw==
X-Gm-Message-State: AO0yUKU01Zc9lYfrNF5gTWVatBhWMQf1EMOHfx5J3e+69csJ1SmiRjVQ
        x6HqTkQ+iZsuGiWP10roFvg=
X-Google-Smtp-Source: AK7set+AESYU6fpRh40OZrZiAA9gfqeBNNbge1x7fNWb06r3zU88uU9evL6tZuP/nX7l1jAeqnGOKQ==
X-Received: by 2002:a05:600c:43c9:b0:3e2:1d1e:78d6 with SMTP id f9-20020a05600c43c900b003e21d1e78d6mr6702834wmn.7.1676800053518;
        Sun, 19 Feb 2023 01:47:33 -0800 (PST)
Received: from [10.148.80.132] ([195.228.69.10])
        by smtp.gmail.com with ESMTPSA id k2-20020adfe8c2000000b002c53cc7504csm9174351wrn.78.2023.02.19.01.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 01:47:32 -0800 (PST)
Message-ID: <dd782435586a73ada32c099150c274c79e1c3003.camel@inf.elte.hu>
Subject: Re: [PATCH net-next 00/12] Add tc-mqprio and tc-taprio support for
 preemptible traffic classes
From:   Ferenc Fejes <fejes@inf.elte.hu>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>
Date:   Sun, 19 Feb 2023 10:47:31 +0100
In-Reply-To: <20230218152021.puhz7m26uu2lzved@skbuf>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
         <20230218152021.puhz7m26uu2lzved@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir!

On Sat, 2023-02-18 at 17:20 +0200, Vladimir Oltean wrote:
> On Fri, Feb 17, 2023 at 01:21:14AM +0200, Vladimir Oltean wrote:
> > The last RFC in August 2022 contained a proposal for the UAPI of
> > both
> > TSN standards which together form Frame Preemption (802.1Q and
> > 802.3):
> > https://patchwork.kernel.org/project/netdevbpf/cover/20220816222920.1952936-1-vladimir.oltean@nxp.com/
> > 
> > It wasn't clear at the time whether the 802.1Q portion of Frame
> > Preemption
> > should be exposed via the tc qdisc (mqprio, taprio) or via some
> > other
> > layer (perhaps also ethtool like the 802.3 portion).
> > 
> > So the 802.3 portion got submitted separately and finally was
> > accepted:
> > https://patchwork.kernel.org/project/netdevbpf/cover/20230119122705.73054-1-vladimir.oltean@nxp.com/
> > 
> > leaving the only remaining question: how do we expose the 802.1Q
> > bits?
> > 
> > This series proposes that we use the Qdisc layer, through separate
> > (albeit very similar) UAPI in mqprio and taprio, and that both
> > these
> > Qdiscs pass the information down to the offloading device driver
> > through
> > the common mqprio offload structure (which taprio also passes).
> > 
> > Implementations are provided for the NXP LS1028A on-board Ethernet
> > (enetc, felix).
> > 
> > Some patches should have maybe belonged to separate series, leaving
> > here
> > only patches 09/12 - 12/12, for ease of review. That may be true,
> > however due to a perceived lack of time to wait for the
> > prerequisite
> > cleanup to be merged, here they are all together.
> > 
> > Vladimir Oltean (12):
> >   net: enetc: rename "mqprio" to "qopt"
> >   net: mscc: ocelot: add support for mqprio offload
> >   net: dsa: felix: act upon the mqprio qopt in taprio offload
> >   net: ethtool: fix __ethtool_dev_mm_supported() implementation
> >   net: ethtool: create and export ethtool_dev_mm_supported()
> >   net/sched: mqprio: simplify handling of nlattr portion of
> > TCA_OPTIONS
> >   net/sched: mqprio: add extack to mqprio_parse_nlattr()
> >   net/sched: mqprio: add an extack message to mqprio_parse_opt()
> >   net/sched: mqprio: allow per-TC user input of FP adminStatus
> >   net/sched: taprio: allow per-TC user input of FP adminStatus
> >   net: mscc: ocelot: add support for preemptible traffic classes
> >   net: enetc: add support for preemptible traffic classes
> > 
> >  drivers/net/dsa/ocelot/felix_vsc9959.c        |  44 ++++-
> >  drivers/net/ethernet/freescale/enetc/enetc.c  |  31 ++-
> >  drivers/net/ethernet/freescale/enetc/enetc.h  |   1 +
> >  .../net/ethernet/freescale/enetc/enetc_hw.h   |   4 +
> >  drivers/net/ethernet/mscc/ocelot.c            |  51 +++++
> >  drivers/net/ethernet/mscc/ocelot.h            |   2 +
> >  drivers/net/ethernet/mscc/ocelot_mm.c         |  56 ++++++
> >  include/linux/ethtool_netlink.h               |   6 +
> >  include/net/pkt_sched.h                       |   1 +
> >  include/soc/mscc/ocelot.h                     |   6 +
> >  include/uapi/linux/pkt_sched.h                |  17 ++
> >  net/ethtool/mm.c                              |  24 ++-
> >  net/sched/sch_mqprio.c                        | 182
> > +++++++++++++++---
> >  net/sched/sch_mqprio_lib.c                    |  14 ++
> >  net/sched/sch_mqprio_lib.h                    |   2 +
> >  net/sched/sch_taprio.c                        |  65 +++++--
> >  16 files changed, 459 insertions(+), 47 deletions(-)
> > 
> > -- 
> > 2.34.1
> > 
> 
> Seeing that there is no feedback on the proposed UAPI, I'd be tempted
> to resend this, with just the modular build fixed (export the
> ethtool_dev_mm_supported() symbol).
> 
> Would anyone hate me for doing this, considering that the merge
> window
> is close? Does anyone need some time to take a closer look at this,
> or
> think about a better alternative?

Do you have the iproute2 part? Sorry if I missed it, but it would be
nice to see how is that UAPI exposed for the config tools. Is there any
new parameter for mqprio/taprio?

Best,
Ferenc
