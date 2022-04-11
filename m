Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8754FBC41
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240295AbiDKMld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237693AbiDKMl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:41:26 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2F725C5
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:39:12 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id p15so30558069ejc.7
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pf9+7977DlMQgarUzcHK7YzPePjuVjehyrQzt/uukXg=;
        b=hK+7guP66rt7+Ey6dKRm1Msnv1wCzZVe/e4p2k5uAKbI5+Dp7vpUNnmIAd1jYvhIzE
         tKgNG+HMcsKggnHon5keQH9bSNvs5rvscK3mU40oQ4f7B9V9BB2ohp5b6kHZ6MQiOWFh
         gU4xi8//kI7emxf6Z3B7El0rj96QfrjCbm9DMpAcbwrFrzGWn/qd0ohb1Bst68t6zTFS
         4jHseTfWOoGkDscUeRFLHNw3aUg3xQWfYpZc0VUA6vkBmwdxdNIpHYwB8cxW2MY8+ejq
         PKQIzJCsgNJm3eyEZoZqRXvGik7bpR6pPt7rnbEj3PMSgwG2aRMl+6F+4AwzKMnAuoJB
         yJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pf9+7977DlMQgarUzcHK7YzPePjuVjehyrQzt/uukXg=;
        b=oaNfJGddJCnTUxoajjzUTVl0iIg+gZ7QIpl7SdsWXTIiP9oczk79CngNUnG0sXV8p8
         UuoT8xA+rxIldr2rL9A5kZdj+VKRm6mY0U65w9czWRpOWgmZnxwV4MH76STopyZpnXpO
         rCiycU9z79d9mUULNrM7Z8F8hZfru8fLaTBrE05MYUKwWSyC0bnkSRQPDQz82OEJcvyT
         XhFrK1JedlSET7eImZKFLnLf36umDT4gx6+ZMeexmV+4Qorq7MuCyyDxa4LjE/+9XXUg
         YV3kYpGAOX4du3QWRmWpte10ptbZZn4vDr3XJbY+jK7lQBRA7Fri3rxJEKnuXgz9D7ZU
         vKyw==
X-Gm-Message-State: AOAM533sRGrgHkPjw2MIVVOyTcVfHHiFxVJaf5QmUhvyBpRh31zHEym+
        xzTr5qMVYTHKpHmHZ5+u1RttEsFQnXY=
X-Google-Smtp-Source: ABdhPJyx+JM5UtqD9KfiOlCYjcdIgseTSPBqskPPYG7ASYq2j1yb5O6zSJAcZ0tAt6rgqvV7ltcfYg==
X-Received: by 2002:a17:907:7ea3:b0:6e8:92eb:3dcc with SMTP id qb35-20020a1709077ea300b006e892eb3dccmr4213500ejc.75.1649680750655;
        Mon, 11 Apr 2022 05:39:10 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id hy24-20020a1709068a7800b006e888dbf1d6sm1775459ejc.91.2022.04.11.05.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 05:39:10 -0700 (PDT)
Date:   Mon, 11 Apr 2022 15:39:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH v4 net-next 0/3] net: dsa: mv88e6xxx: Implement offload
 of matchall for bridged DSA ports
Message-ID: <20220411123908.i73i7uonbs2qyvjt@skbuf>
References: <20220411120633.40054-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411120633.40054-1-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 02:06:30PM +0200, Mattias Forsblad wrote:
> RFC -> v1: Monitor bridge join/leave and re-evaluate offloading (Vladimir Oltean)
> v2: Fix code standard compliance (Jakub Kicinski)
> v3: Fix warning from kernel test robot (<lkp@intel.com>)
> v4: Check matchall priority (Jakub)
>     Use boolean type (Vladimir)
>     Use Vladimirs code for checking foreign interfaces
>     Drop unused argument (Vladimir)
>     Add switchdev notifier (Vladimir)

By switchdev notifier you mean SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RCV?
I'm sorry, you must have misunderstood. I said, in reference to
dp->ds->ops->bridge_local_rcv():

| Not to mention this should be a cross-chip notifier, maybe a
| cross-tree notifier.

https://patchwork.kernel.org/project/netdevbpf/patch/20220404104826.1902292-2-mattias.forsblad@gmail.com/#24805497

A cross-chip notifier is an event signaled using dsa_tree_notify() and
handled in switch.c. Its purpose is to replicate an event exactly once
towards all switches in a multi-switch topology.

You could have explained that this isn't necessary, because
dsa_slave_setup_bridge_tc_indr_block(netdev=bridge_dev) indirectly binds
dsa_slave_setup_bridge_block_cb() which calls dsa_slave_setup_tc_block_cb()
for each user port under said bridge. So replicating the ds->ops->bridge_local_rcv()
towards each switch is already taken care of in another way, although
suboptimally, because if there are 4 user ports under br0 in switch A
and 4 user ports in switch B, ds->ops->bridge_local_rcv() will be called
4 times for switch A and 4 times for switch B. 6 out of those 8 calls
are for nothing.

Or you could have said that you don't understand the request and ask me
to clarify.

But I don't understand why you've added SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RCV
which has no consumer. Initially I thought you'd go back to having the
bridge monitor flow blocks binding to its ingress chain instead of this
broken indirect stuff, then emit SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RCV on
the switchdev notifier chain which DSA catches and offloads. And initial
state would be synced/unsynced via attribute replays in
dsa_port_switchdev_sync_attrs(). At least that would have worked.
But nope. It really looks like SWITCHDEV_ATTR_ID_BRIDGE_LOCAL_RCV was
added to appease an unclear comment even if it made no sense.

>     Only call ops when value have changed (Vladimir)
>     Add error check (Vladimir)
> 
> Mattias Forsblad (3):
>   net: dsa: track whetever bridges have foreign interfaces in them
>   net: dsa: Add support for offloading tc matchall with drop target
>   net: dsa: mv88e6xxx: Add HW offload support for tc matchall in Marvell
>     switches
> 
>  drivers/net/dsa/mv88e6xxx/chip.c |  17 +-
>  include/net/dsa.h                |  15 ++
>  include/net/switchdev.h          |   2 +
>  net/dsa/dsa2.c                   |   2 +
>  net/dsa/dsa_priv.h               |   3 +
>  net/dsa/port.c                   |  14 ++
>  net/dsa/slave.c                  | 321 +++++++++++++++++++++++++++++--
>  7 files changed, 361 insertions(+), 13 deletions(-)
> 
> -- 
> 2.25.1
> 
