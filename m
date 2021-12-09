Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A66646E11B
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 04:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhLIDJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 22:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhLIDJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 22:09:36 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E08DC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 19:06:03 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x6so15043948edr.5
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 19:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=YoaTi48szbW9jc92c152vaJQXm02JI4dVA3QCqDg+n4=;
        b=TJS2zGDWYKXMQPv2D9vXpnl8qz7rVGLJ83qpIkTvUflwrInG1USPoaIvCbm4mLB7N2
         tVFsrGFE3dj1taA58+zcaVZUftahYhS5O0HFK8WoiwGHo8O4gY8aec+M9pEEhI55wFhL
         25MeZCuQu6JnTzWleIN5v0LPfFKT+Fcm41+EAfVgwYnIaNRUUQSUryDUO5BYNY6ZqimO
         OybL1Dzb157ELv6Jw4nWnE/hB0Daj3O1ABUhTUv8usRST/enqryH9vkAz2sO9f1ylmdO
         OlZR5z4NoaA26+Z32UHhEjFCIMHxX3I6HXl0JEzf4wCpRfXjZwMj4mISJHUUwyNmqsPx
         qSfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=YoaTi48szbW9jc92c152vaJQXm02JI4dVA3QCqDg+n4=;
        b=a6pimlGUZcrQQDwuuvmr+jSxPJ+swmZqjRxwywa1LyfA8tD1bRUF+zwCx4fTXdzqQM
         0xETWVwXmaxLvLbmoPjTt5o1iOMUus9KKE7siNWrIT/x0r4/cvZfvTNzyYMU9thU+UA5
         BA8fwRVhvLjA/b0pORmnAl6wjQ+UxenZYx50P517r/8OV38fyDCTkCXYXqFNW+jLf9mO
         N+oN2FJnZhOizM1UVTNRxQz1YCtHs+N96Iif0TtXL3kaFmTOYTq7dOl5E7SM10ddDA18
         OMu5+f9Gf/GwX7c6osYlflrORLpdCiksHfEcnuJEx+vixNQsy+sfFy1fWdZHxWJyRlvy
         G4Ow==
X-Gm-Message-State: AOAM531vqSePGVdZlQMNTPMYGSlZZgl0lTrmhVjsQZhAZLSB08rWwhLw
        mm+f8Jv3FZu4q+lOVV0srW4=
X-Google-Smtp-Source: ABdhPJzksj7gBiGIGbQL6EWsNLJjXPmgJaIDZ5Auf/wm84GZry/H5RSD+qV6V4oyF0etKTOU+z4H4g==
X-Received: by 2002:a50:d492:: with SMTP id s18mr24558757edi.145.1639019162045;
        Wed, 08 Dec 2021 19:06:02 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id mp9sm2188949ejc.106.2021.12.08.19.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 19:06:01 -0800 (PST)
Message-ID: <61b17299.1c69fb81.8ef9.8daa@mx.google.com>
X-Google-Original-Message-ID: <YbFylzUTgiUFT0x/@Ansuel-xps.>
Date:   Thu, 9 Dec 2021 04:05:59 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next 0/7] DSA master state tracking
References: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 12:32:23AM +0200, Vladimir Oltean wrote:
> This patch set is provided solely for review purposes (therefore not to
> be applied anywhere) and for Ansuel to test whether they resolve the
> slowdown reported here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942.7444-1-ansuelsmth@gmail.com/
> 
> It does conflict with net-next due to other patches that are in my tree,
> and which were also posted here and would need to be picked ("Rework DSA
> bridge TX forwarding offload API"):
> https://patchwork.kernel.org/project/netdevbpf/cover/20211206165758.1553882-1-vladimir.oltean@nxp.com/
> 
> Additionally, for Ansuel's work there is also a logical dependency with
> this series ("Replace DSA dp->priv with tagger-owned storage"):
> https://patchwork.kernel.org/project/netdevbpf/cover/20211208200504.3136642-1-vladimir.oltean@nxp.com/
> 
> To get both dependency series, the following commands should be sufficient:
> git b4 20211206165758.1553882-1-vladimir.oltean@nxp.com
> git b4 20211208200504.3136642-1-vladimir.oltean@nxp.com
> 
> where "git b4" is an alias in ~/.gitconfig:
> [b4]
> 	midmask = https://lore.kernel.org/r/%s
> [alias]
> 	b4 = "!f() { b4 am -t -o - $@ | git am -3; }; f"
> 
> The patches posted here are mainly to offer a consistent
> "master_up"/"master_going_down" chain of events to switches, without
> duplicates, and always starting with "master_up" and ending with
> "master_going_down". This way, drivers should know when they can perform
> Ethernet-based register access.
> 
> Vladimir Oltean (7):
>   net: dsa: only bring down user ports assigned to a given DSA master
>   net: dsa: refactor the NETDEV_GOING_DOWN master tracking into separate
>     function
>   net: dsa: use dsa_tree_for_each_user_port in
>     dsa_tree_master_going_down()
>   net: dsa: provide switch operations for tracking the master state
>   net: dsa: stop updating master MTU from master.c
>   net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
>   net: dsa: replay master state events in
>     dsa_tree_{setup,teardown}_master
> 
>  include/net/dsa.h  |  8 +++++++
>  net/dsa/dsa2.c     | 52 ++++++++++++++++++++++++++++++++++++++++++++--
>  net/dsa/dsa_priv.h | 11 ++++++++++
>  net/dsa/master.c   | 29 +++-----------------------
>  net/dsa/slave.c    | 32 +++++++++++++++-------------
>  net/dsa/switch.c   | 29 ++++++++++++++++++++++++++
>  6 files changed, 118 insertions(+), 43 deletions(-)
> 
> -- 
> 2.25.1
> 

I applied this patch and it does work correctly. Sadly the problem is
not solved and still the packet are not tracked correctly. What I notice
is that everything starts to work as soon as the master is set to
promiiscuous mode. Wonder if we should track that event instead of
simple up?

Here is a bootlog [0]. I added some log when the function timeouts and when
master up is actually called.
Current implementation for this is just a bool that is set to true on
master up and false on master going down. (final version should use
locking to check if an Ethernet transation is in progress)

[0] https://pastebin.com/7w2kgG7a

-- 
	Ansuel
