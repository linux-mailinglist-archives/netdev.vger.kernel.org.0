Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDCC69C994
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbjBTLRM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Feb 2023 06:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbjBTLRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:17:11 -0500
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F9619F0D;
        Mon, 20 Feb 2023 03:16:34 -0800 (PST)
Received: by mail-wm1-f46.google.com with SMTP id l7-20020a05600c1d0700b003dc4050c94aso666147wms.4;
        Mon, 20 Feb 2023 03:16:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kmnW6DpFTG4UPg7/RI/zIKxCvf9LrO9JDmiTL7d0yI0=;
        b=rFlRvsxqRJja00uKB/ijErrVJj8rYypYMQ3Pr2l+c8p9O6QTtn18snsi/QX7y4rSAC
         +kde+4gyJm/orFM4+D6yRBqPReqgQZt3ZlD0tX7PNboo35pTB8/A9OvHs4wdFgCJLTlv
         28DbgshRRJA2phqqVNf63qsfDkUmg5nINpW5RynwVKvy+I98W4ZOsFYZbT9OqKfFYZbm
         me7eUzyE5NXHOYTC8wiYduW3BVTCgYoo/OE8H2LPRm1XxkabUYn1oUZnYjNJuCFbEY1H
         ah1bVG5CEGZT/D3FX3koUnZ5xgC/0Wktyn9DQc4bvAELBgp5vxOzejnAPASQM0ah8ZfW
         CFDA==
X-Gm-Message-State: AO0yUKUtceYI8n3AAGICtfhNpVJRF8yFGgPjozNGi3zuwv0I4a/ZSiFQ
        DsOgu6PJ3MIy31ZjDA09MdI=
X-Google-Smtp-Source: AK7set/DbIvDhAhqEapx98JghuyDiFsmUSrysHHGZ8Afl/Gm/DpnbBYYGcePSbgSq2D2aW1tq5Bx5g==
X-Received: by 2002:a05:600c:2ed2:b0:3df:94c3:46f2 with SMTP id q18-20020a05600c2ed200b003df94c346f2mr435736wmn.23.1676891759426;
        Mon, 20 Feb 2023 03:15:59 -0800 (PST)
Received: from [10.148.80.132] (business-89-135-192-225.business.broadband.hu. [89.135.192.225])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c468800b003e2232d0960sm1355422wmo.23.2023.02.20.03.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 03:15:58 -0800 (PST)
Message-ID: <d016f61224b293a77969c35d09d65d5cfea7d137.camel@inf.elte.hu>
Subject: Re: [PATCH v2 net-next 00/12] Add tc-mqprio and tc-taprio support
 for preemptible traffic classes
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
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Date:   Mon, 20 Feb 2023 12:15:57 +0100
In-Reply-To: <20230219135309.594188-1-vladimir.oltean@nxp.com>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-02-19 at 15:52 +0200, Vladimir Oltean wrote:
> The last RFC in August 2022 contained a proposal for the UAPI of both
> TSN standards which together form Frame Preemption (802.1Q and
> 802.3):
> https://patchwork.kernel.org/project/netdevbpf/cover/20220816222920.1952936-1-vladimir.oltean@nxp.com/
> 
> It wasn't clear at the time whether the 802.1Q portion of Frame
> Preemption
> should be exposed via the tc qdisc (mqprio, taprio) or via some other
> layer (perhaps also ethtool like the 802.3 portion, or dcbnl), even
> though the options were discussed extensively, with pros and cons:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220816222920.1952936-3-vladimir.oltean@nxp.com/
> 
> So the 802.3 portion got submitted separately and finally was
> accepted:
> https://patchwork.kernel.org/project/netdevbpf/cover/20230119122705.73054-1-vladimir.oltean@nxp.com/
> 
> leaving the only remaining question: how do we expose the 802.1Q
> bits?
> 
> This series proposes that we use the Qdisc layer, through separate
> (albeit very similar) UAPI in mqprio and taprio, and that both these
> Qdiscs pass the information down to the offloading device driver
> through
> the common mqprio offload structure (which taprio also passes).
> 
> Implementations are provided for the NXP LS1028A on-board Ethernet
> (enetc, felix).
> 
> Some patches should have maybe belonged to separate series, leaving
> here
> only patches 09/12 - 12/12, for ease of review. That may be true,
> however due to a perceived lack of time to wait for the prerequisite
> cleanup to be merged, here they are all together.
> 
> Changes in v2:
> - add missing EXPORT_SYMBOL_GPL(ethtool_dev_mm_supported)
> - slightly reword some commit messages
> - move #include <linux/ethtool_netlink.h> to the respective patch in
>   mqprio
> - remove self-evident comment "only for dump and offloading" in
> mqprio
> 
> v1 at:
> https://patchwork.kernel.org/project/netdevbpf/cover/20230216232126.3402975-1-vladimir.oltean@nxp.com/
> 
> Vladimir Oltean (12):
>   net: enetc: rename "mqprio" to "qopt"
>   net: mscc: ocelot: add support for mqprio offload
>   net: dsa: felix: act upon the mqprio qopt in taprio offload
>   net: ethtool: fix __ethtool_dev_mm_supported() implementation
>   net: ethtool: create and export ethtool_dev_mm_supported()
>   net/sched: mqprio: simplify handling of nlattr portion of
> TCA_OPTIONS
>   net/sched: mqprio: add extack to mqprio_parse_nlattr()
>   net/sched: mqprio: add an extack message to mqprio_parse_opt()
>   net/sched: mqprio: allow per-TC user input of FP adminStatus
>   net/sched: taprio: allow per-TC user input of FP adminStatus
>   net: mscc: ocelot: add support for preemptible traffic classes
>   net: enetc: add support for preemptible traffic classes
> 
>  drivers/net/dsa/ocelot/felix_vsc9959.c        |  44 ++++-
>  drivers/net/ethernet/freescale/enetc/enetc.c  |  31 ++-
>  drivers/net/ethernet/freescale/enetc/enetc.h  |   1 +
>  .../net/ethernet/freescale/enetc/enetc_hw.h   |   4 +
>  drivers/net/ethernet/mscc/ocelot.c            |  51 +++++
>  drivers/net/ethernet/mscc/ocelot.h            |   2 +
>  drivers/net/ethernet/mscc/ocelot_mm.c         |  56 ++++++
>  include/linux/ethtool_netlink.h               |   6 +
>  include/net/pkt_sched.h                       |   1 +
>  include/soc/mscc/ocelot.h                     |   6 +
>  include/uapi/linux/pkt_sched.h                |  17 ++
>  net/ethtool/mm.c                              |  25 ++-
>  net/sched/sch_mqprio.c                        | 182 +++++++++++++++-
> --
>  net/sched/sch_mqprio_lib.c                    |  14 ++
>  net/sched/sch_mqprio_lib.h                    |   2 +
>  net/sched/sch_taprio.c                        |  65 +++++--
>  16 files changed, 460 insertions(+), 47 deletions(-)
> 

LGTM.

Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>

