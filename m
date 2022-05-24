Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE62F5329E6
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbiEXMC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiEXMCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:02:25 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959FB5DBD8
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 05:02:23 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h11so21600001eda.8
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 05:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=/uRnXsIKajNQMBlJVdlFLGNMaZd6ueWszeFgqKX9Ys4=;
        b=p3X+aAYeI6dFPW30GQwg1V09fKrL5dY0U5kQc3WWp/dJPCdnUZYirJN9ta5hANoX9I
         Lv7GgccACCoRTdkSg7XJf8V2lkiwBU0HaehWizm76tVCQYOd4cUOZENLXA0u7Z065SZJ
         3RtLwtvD9Y8oW0xcKbbN876UAc38zHGPYfxjH4cwb8l6lGAP0Cndgq+vTj8GiYWZrGJD
         cjv8PQXec3DR57Y3CACok4jk1OpGzk/CI9zk/WZ2BhfEARX9yCD/UAVLNhB5+XLmjqta
         WNM8regvDHDjDZGMhOGTzK46j1X8NHqQQi8n7BWHy8AsuLVZr6UH9tPqWHeqSPduLz+S
         S/tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=/uRnXsIKajNQMBlJVdlFLGNMaZd6ueWszeFgqKX9Ys4=;
        b=mfML9MBgMl8rs7dOXk1wjUFJTUywnOfJ4OnDSpRlY9DMiVyaJGsnqLmXFCdDlvi+6c
         6pov9vwQ/+poHs5moJdfE5gbllF19I614xXfwzDKc6IHLRQUI7MjztfNteWqsF5ui+DB
         kU6lDjaBevmgjAb+cDSbeOGw4Pxf7Ow+MLckpldG4hFRlJ7MLp3blmMPR8fOurfTAYqD
         CI4nvzz3v/aadGTIEuwMmduKK9AY9cOOdz5HB0E8InRVypDPKc+FWNxysoielVf5J7aZ
         Ww/gbvj9DtdgFW4Waao8wk5PnS0uJK+fm9MwwPVia2W/kXWzXkTYIKEulKqHWcKULktm
         NERQ==
X-Gm-Message-State: AOAM531KY+Q7T/bw+Y7MrzjAIHOhJHTBVhu/7xdzJdoQWA6tgG3rWyL2
        +7wHZEdJDTvqVWr9J8PJ9f8=
X-Google-Smtp-Source: ABdhPJx1pwBojpUtANiR6UtpN+KglMG08y2omAJhNxtTyHqoEfdpMZ5goxGIYYAAf06qnlPm0NjE6Q==
X-Received: by 2002:a05:6402:6d9:b0:42a:b514:a992 with SMTP id n25-20020a05640206d900b0042ab514a992mr29123422edy.209.1653393741679;
        Tue, 24 May 2022 05:02:21 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id l3-20020a170906230300b006fec1a73e48sm3343094eja.64.2022.05.24.05.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 05:02:21 -0700 (PDT)
Message-ID: <628cc94d.1c69fb81.15b0d.422d@mx.google.com>
X-Google-Original-Message-ID: <YozJS2MbPtjAmLjg@Ansuel-xps.>
Date:   Tue, 24 May 2022 14:02:19 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH net-next 00/12] DSA changes for multiple CPU ports
 (part 3)
References: <20220523104256.3556016-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523104256.3556016-1-olteanv@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 01:42:44PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Note: this patch set isn't probably tested nearly well enough, and
> contains (at least minor) bugs. Don't do crazy things with it. I'm
> posting it to get feedback on the proposed UAPI.
> 
> Those who have been following part 1:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220511095020.562461-1-vladimir.oltean@nxp.com/
> and part 2:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220521213743.2735445-1-vladimir.oltean@nxp.com/
> will know that I am trying to enable the second internal port pair from
> the NXP LS1028A Felix switch for DSA-tagged traffic via "ocelot-8021q".
> This series represents part 3 of that effort.
> 
> Covered here are some code structure changes so that DSA monitors
> changeupper events of its masters, as well as new UAPI introduction via
> rtnetlink for changing the current master. Note, in the case of a LAG
> DSA master, DSA user ports can be assigned to the LAG in 2 ways, either
> through this new IFLA_DSA_MASTER, or simply when their existing DSA
> master joins a LAG.
> 
> Compared to previous attempts to introduce support for multiple CPU ports:
> https://lore.kernel.org/netdev/20210410133454.4768-1-ansuelsmth@gmail.com/
> 
> my proposal is to not change anything in the default behavior (i.e.
> still start off with the first CPU port from the device tree as the only
> active CPU port). But focus is instead put on being able to live-change
> what the user-to-CPU-port affinity is. Marek Behun has expressed a
> potential use case as being to dynamically load balance the termination
> of ports between CPU ports, and that should be best handled by a user
> space daemon if it only had the means - this creates the means.
> 
> Host address filtering is interesting with multiple CPU ports.
> There are 2 types of host filtered addresses to consider:
> - standalone MAC addresses of ports. These are either inherited from the
>   respective DSA masters of the ports, or from the device tree blob.
> - local bridge FDB entries.
> 
> Traditionally, DSA manages host-filtered addresses by calling
> port_fdb_add(dp->cpu_dp->index) in the appropriate database.
> But for example, when we have 2 bridged DSA user ports, one with CPU
> port A and the other with CPU port B, and the bridge offloads a local
> FDB entry for 00:01:02:03:04:05, DSA would attempt to first call
> port_fdb_add(A, 00:01:02:03:04:05, DSA_DB_BRIDGE), then
> port_fdb_add(B, 00:01:02:03:04:05, DSA_DB_BRIDGE). And since an FDB
> entry can have a single destination, the second port_fdb_add()
> overwrites the first one, and locally terminated traffic for the ports
> assigned to CPU port A is broken.
> 
> What should be done in that situation, at least with the HW I'm working
> with, is that the host filtered addresses should be delivered towards a
> "multicast" destination that covers both CPU ports, and let the
> forwarding matrix eliminate the CPU port that the current user port
> isn't affine to.
> 
> In my proposed patch set, the Felix driver does exactly that: host
> filtered addresses are learned towards a special PGID_CPU that has both
> tag_8021q CPU ports as destinations.
> 
> I have considered introducing new dsa_switch_ops API in the form of
> host_fdb_add(user port) and host_fdb_del(user port) rather than calling
> port_fdb_add(cpu port). After all, this would be similar to the newly
> introduced port_set_host_flood(user port). But I need to think a bit
> more whether it's needed right away.
> 
> Finally, there's LAG. Proposals have been made before to describe in DT
> that CPU ports are under a LAG, the idea being that we could then do the
> same for DSA (cascade) ports. The common problem is that shared (CPU and
> DSA) ports have no netdev exposed.
> 
> I didn't do that, instead I went for the more natural approach of saying
> that if the CPU ports are in a LAG, then the DSA masters are in a
> symmetric LAG as well. So why not just monitor when the DSA masters join
> a LAG, and piggyback on that configuration and make DSA reconfigure
> itself accordingly.
> 
> So LAG devices can now be DSA masters, and this is accomplished by
> populating their dev->dsa_ptr. Note that we do not create a specific
> struct dsa_port to populate their dsa_ptr, instead we reuse the dsa_ptr
> of one of the physical DSA masters (the first one, in fact).
> 
> Vladimir Oltean (12):
>   net: introduce iterators over synced hw addresses
>   net: dsa: walk through all changeupper notifier functions
>   net: dsa: don't stop at NOTIFY_OK when calling
>     ds->ops->port_prechangeupper
>   net: bridge: move DSA master bridging restriction to DSA
>   net: dsa: existing DSA masters cannot join upper interfaces
>   net: dsa: only bring down user ports assigned to a given DSA master
>   net: dsa: all DSA masters must be down when changing the tagging
>     protocol
>   net: dsa: use dsa_tree_for_each_cpu_port in
>     dsa_tree_{setup,teardown}_master
>   net: dsa: introduce dsa_port_get_master()
>   net: dsa: allow the DSA master to be seen and changed through
>     rtnetlink
>   net: dsa: allow masters to join a LAG
>   net: dsa: felix: add support for changing DSA master
> 
>  drivers/net/dsa/bcm_sf2.c                     |   4 +-
>  drivers/net/dsa/bcm_sf2_cfp.c                 |   4 +-
>  drivers/net/dsa/lan9303-core.c                |   4 +-
>  drivers/net/dsa/ocelot/felix.c                | 117 ++++-
>  drivers/net/dsa/ocelot/felix.h                |   3 +
>  .../net/ethernet/mediatek/mtk_ppe_offload.c   |   2 +-
>  drivers/net/ethernet/mscc/ocelot.c            |   3 +-
>  include/linux/netdevice.h                     |   6 +
>  include/net/dsa.h                             |  23 +
>  include/soc/mscc/ocelot.h                     |   1 +
>  include/uapi/linux/if_link.h                  |  10 +
>  net/bridge/br_if.c                            |  20 -
>  net/dsa/Makefile                              |  10 +-
>  net/dsa/dsa.c                                 |   9 +
>  net/dsa/dsa2.c                                |  72 ++--
>  net/dsa/dsa_priv.h                            |  18 +-
>  net/dsa/master.c                              |  62 ++-
>  net/dsa/netlink.c                             |  62 +++
>  net/dsa/port.c                                | 162 ++++++-
>  net/dsa/slave.c                               | 404 +++++++++++++++++-
>  net/dsa/switch.c                              |  22 +-
>  net/dsa/tag_8021q.c                           |   4 +-
>  22 files changed, 915 insertions(+), 107 deletions(-)
>  create mode 100644 net/dsa/netlink.c
> 
> -- 
> 2.25.1
> 

Probably offtopic but I wonder if the use of a LAG as master can
cause some problem with configuration where the switch use a mgmt port
to send settings. Wonder if with this change we will have to introduce
an additional value to declare a management port that will be used since
master can now be set to various values. Or just the driver will have to
handle this with its priv struct (think this is the correct solution)

I still have to find time to test this with qca8k.

-- 
	Ansuel
