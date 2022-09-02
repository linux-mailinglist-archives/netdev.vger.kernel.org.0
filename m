Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947345AB881
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 20:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiIBSor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 14:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiIBSon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 14:44:43 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694F0255BB;
        Fri,  2 Sep 2022 11:44:42 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id y3so5637158ejc.1;
        Fri, 02 Sep 2022 11:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date;
        bh=h3ijsdqHIfK/6Huq8TNWRNXK3dL0Ua0BG94bDomWq6g=;
        b=pbq2K3NFK5MojpGSVqZKp1Uj/sKKyFcPQpdVi3W812Q4+U/P0AqRGOajGN8ZTX4x95
         vETVpjjatlBecNz+ZW3sbAXEzRpfNk29an3RGGG9MOt6BMQlsbFiWaqdP0I1rVE5Qthm
         E8mkFlCDAONqEvlQhRRXbkuNjyQZJccUSkpjMunLHBWnp0w8C8UnaQLysNaoT2gl+jqK
         RXPOTOL51Na+GFuKczl6WS8oyEf3OW7mAlUxSjnKktyqI/l1IUykcyaguFC6RZj5BY3n
         THXmCB88RHPENilr8K6vIfZ9TyU1kzplUEQS8C2cMW4eyCND3b31XPt7C4mIcTI17It3
         tWfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=h3ijsdqHIfK/6Huq8TNWRNXK3dL0Ua0BG94bDomWq6g=;
        b=tcQ0WKQt8D37K9mKNAnzMa9PWVbKeUteUNIHrEgpzj3jxbOY28tQZHo9lhy4srNfPA
         iJeFLUDA9Y9lnADfEn5TdfhLEiwmpeL5OeyBazTrz9XFocume98oJsNC0Qkj8IeP9YO6
         et0sLjpWvJ3HWgl0SnA0CJULcd3nc90BdIyy3r/rG1guhFAuuUGq9bEkzBeKNRwejTa8
         r+y4YntoN1QJ6NnC3y9dG7NdwArS0eBTEXjUsKU5MJ3pmd8ifXpbHPjEoZJyYX7dT4mI
         fnK9tfXbDhyKBS6RArflFIxh8JL3NlGn5y30XaHHmi3cA+ov3wBVSsAviFmC2J2S3SHL
         lG7g==
X-Gm-Message-State: ACgBeo32XPEPqkM1GD+y9CvzsjD1VU8xY36zCvHjhslRhPayBPDgkrKl
        GYfb1Um2YKRZqYVTEY3IYs4=
X-Google-Smtp-Source: AA6agR46Up0Bxd2Bz5mya3G5FfUAT9wARjFBEh/eSfIb/QlqOObbQJyeK6+c5fuk+7L6yuiU6hWWoA==
X-Received: by 2002:a17:907:6e9e:b0:741:56e5:67cb with SMTP id sh30-20020a1709076e9e00b0074156e567cbmr19769810ejc.256.1662144280626;
        Fri, 02 Sep 2022 11:44:40 -0700 (PDT)
Received: from Ansuel-xps. (host-82-53-189-210.retail.telecomitalia.it. [82.53.189.210])
        by smtp.gmail.com with ESMTPSA id kz19-20020a17090777d300b0073dc691063dsm1549468ejc.192.2022.09.02.11.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 11:44:39 -0700 (PDT)
Message-ID: <63124f17.170a0220.80d35.2d31@mx.google.com>
X-Google-Original-Message-ID: <YxJPFTkLPFfA8Vfn@Ansuel-xps.>
Date:   Fri, 2 Sep 2022 20:44:37 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part 4)
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830195932.683432-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 10:59:23PM +0300, Vladimir Oltean wrote:
> Those who have been following part 1:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220511095020.562461-1-vladimir.oltean@nxp.com/
> part 2:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220521213743.2735445-1-vladimir.oltean@nxp.com/
> and part 3:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220819174820.3585002-1-vladimir.oltean@nxp.com/
> will know that I am trying to enable the second internal port pair from
> the NXP LS1028A Felix switch for DSA-tagged traffic via "ocelot-8021q".
> 
> This series represents the final part of that effort. We have:
> 
> - the introduction of new UAPI in the form of IFLA_DSA_MASTER
> 
> - preparation for LAG DSA masters in terms of suppressing some
>   operations for masters in the DSA core that simply don't make sense
>   when those masters are a bonding/team interface
> 
> - handling all the net device events that occur between DSA and a
>   LAG DSA master, including migration to a different DSA master when the
>   current master joins a LAG, or the LAG gets destroyed
> 
> - updating documentation
> 
> - adding an implementation for NXP LS1028A, where things are insanely
>   complicated due to hardware limitations. We have 2 tagging protocols:
> 
>   * the native "ocelot" protocol (NPI port mode). This does not support
>     CPU ports in a LAG, and supports a single DSA master. The DSA master
>     can be changed between eno2 (2.5G) and eno3 (1G), but all ports must
>     be down during the changing process, and user ports assigned to the
>     old DSA master will refuse to come up if the user requests that
>     during a "transient" state.
> 
>   * the "ocelot-8021q" software-defined protocol, where the Ethernet
>     ports connected to the CPU are not actually "god mode" ports as far
>     as the hardware is concerned. So here, static assignment between
>     user and CPU ports is possible by editing the PGID_SRC masks for
>     the port-based forwarding matrix, and "CPU ports in a LAG" simply
>     means "a LAG like any other".
> 
> The series was regression-tested on LS1028A using the local_termination.sh
> kselftest, in most of the possible operating modes and tagging protocols.
> I have not done a detailed performance evaluation yet, but using LAG, is
> possible to exceed the termination bandwidth of a single CPU port in an
> iperf3 test with multiple senders and multiple receivers.
> 
> There was a previous RFC posted, which contains most of these changes,
> however it's so old by now that it's unlikely anyone of the reviewers
> remembers it in detail. I've applied most of the feedback requested by
> Florian and Ansuel there.
> https://lore.kernel.org/netdev/20220523104256.3556016-1-olteanv@gmail.com/

Hi,
I would love to test this but for me it's a bit problematic to use a
net-next kernel. I wonder if it's possible to backport the 4 part to
older kernel or other prereq are needed. (I know backporting the 4 part
will be crazy but it's something that has to be done anyway to actually
use this on OpenWrt where we currently use 5.10 and 5.15)

Would be good to know if the 4 part require other changes to dsa core to
make a LAG implementation working. (talking for 5.15 since backporting
this to 5.10 is a nono...)

> 
> Vladimir Oltean (9):
>   net: introduce iterators over synced hw addresses
>   net: dsa: introduce dsa_port_get_master()
>   net: dsa: allow the DSA master to be seen and changed through
>     rtnetlink
>   net: dsa: don't keep track of admin/oper state on LAG DSA masters
>   net: dsa: suppress appending ethtool stats to LAG DSA masters
>   net: dsa: suppress device links to LAG DSA masters
>   net: dsa: allow masters to join a LAG
>   docs: net: dsa: update information about multiple CPU ports
>   net: dsa: felix: add support for changing DSA master
> 
>  .../networking/dsa/configuration.rst          |  84 +++++
>  Documentation/networking/dsa/dsa.rst          |  38 ++-
>  drivers/net/dsa/bcm_sf2.c                     |   4 +-
>  drivers/net/dsa/bcm_sf2_cfp.c                 |   4 +-
>  drivers/net/dsa/lan9303-core.c                |   4 +-
>  drivers/net/dsa/ocelot/felix.c                | 117 ++++++-
>  drivers/net/dsa/ocelot/felix.h                |   3 +
>  .../net/ethernet/mediatek/mtk_ppe_offload.c   |   2 +-
>  drivers/net/ethernet/mscc/ocelot.c            |   3 +-
>  include/linux/netdevice.h                     |   6 +
>  include/net/dsa.h                             |  19 ++
>  include/soc/mscc/ocelot.h                     |   1 +
>  include/uapi/linux/if_link.h                  |  10 +
>  net/dsa/Makefile                              |  10 +-
>  net/dsa/dsa.c                                 |   9 +
>  net/dsa/dsa2.c                                |  34 ++-
>  net/dsa/dsa_priv.h                            |  17 +-
>  net/dsa/master.c                              |  82 ++++-
>  net/dsa/netlink.c                             |  62 ++++
>  net/dsa/port.c                                | 159 +++++++++-
>  net/dsa/slave.c                               | 288 +++++++++++++++++-
>  net/dsa/switch.c                              |  22 +-
>  net/dsa/tag_8021q.c                           |   4 +-
>  23 files changed, 924 insertions(+), 58 deletions(-)
>  create mode 100644 net/dsa/netlink.c
> 
> -- 
> 2.34.1
> 

-- 
	Ansuel
