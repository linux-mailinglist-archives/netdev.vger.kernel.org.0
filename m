Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA2E2D8B37
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 04:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393401AbgLMDuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 22:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393241AbgLMDtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 22:49:43 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B1CC0613D3;
        Sat, 12 Dec 2020 19:49:03 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id i6so12374764otr.2;
        Sat, 12 Dec 2020 19:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CDYp5c7kUryWTtjnNNFi8EEViruTR4hOP8Evr/dP/MY=;
        b=D46Eko50CUvR9h6CxROCYUlFb9AcrqBawlXAA8hppaKj+ehO+A6DikeByUFIYbAb0b
         8j22PJLYiO3SY4I4pyDqRvetuKRlATm5m87S7gDzEGD+RUlRIFuUIFymLguUCidEwX0X
         LDng4GatOqsn/u4yknSrIbgqaxzzWodHdkMcFXtnoH0MM+Ygd9pny/fxMA5vNaDB9duQ
         0jhqjsaDDsBgxQ3J5l8w4ss4UVoPVvLVqMS4vkiTvR90xECp6CLXLI8CzyuTrATJYPCp
         W/B6C/VgkCWi3Azvbbj6C+yXuSa2FjNfCIv1CxKJus8h2RW6h7jp6zjQTpdAoFfDENYE
         AHWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CDYp5c7kUryWTtjnNNFi8EEViruTR4hOP8Evr/dP/MY=;
        b=CLoho4jSu7/8ICfXmF02ZoXcX0Vfvej3GTANN6OMqUBvvxZvoVI7aAQGjcB3L6rCnI
         Qvw2FO2CT5TQMyL6Jpj4oFdzHa86KnefHSuPtcAJojcY+hsHlxyi1V9ZX3fWFd01moIP
         nStCjKHg1GDr4FyhivJFGbwh494ajWupahTl/u1HhQpCoSgF0LD+AdJQ4pWR0kgGw72w
         k18FWUpxlRtKwCqa+QS4qRHo4+QUx8OKP7pfQ/MLtbxvYf8vCg2z/vywNrOcwLPkp58q
         l25n3fx16uqaU3qK2Y4N1G5qquuQR4HiPpqDdKMxVEvxgYr14utX7bHqj/7d6Yyf9v0A
         Ztjw==
X-Gm-Message-State: AOAM532ZsClfvtdtGpFZs3EzU2sCFvOlgk6GVjXHLrrtLjMk6jKeKixD
        5nJ+04bbB4Sm8DEtJVW2JIrJYC+Smek=
X-Google-Smtp-Source: ABdhPJzumAltjGTMMT9/URCUIgajCxmkoGtWeMB+lnZotmFN8BAYC3ZEheglVD6SVRmFjAonYK24Wg==
X-Received: by 2002:a9d:4ce:: with SMTP id 72mr15369215otm.23.1607831342882;
        Sat, 12 Dec 2020 19:49:02 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:5c21:b591:3efd:575e? ([2600:1700:dfe0:49f0:5c21:b591:3efd:575e])
        by smtp.gmail.com with ESMTPSA id v8sm3172969otp.10.2020.12.12.19.49.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 19:49:02 -0800 (PST)
Subject: Re: [PATCH v2 net-next 5/6] net: dsa: listen for
 SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
References: <20201213024018.772586-1-vladimir.oltean@nxp.com>
 <20201213024018.772586-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <641d19c9-cd2d-fb63-de86-150d01bdb17e@gmail.com>
Date:   Sat, 12 Dec 2020 19:48:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201213024018.772586-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/2020 6:40 PM, Vladimir Oltean wrote:
> Some DSA switches (and not only) cannot learn source MAC addresses from
> packets injected from the CPU. They only perform hardware address
> learning from inbound traffic.
> 
> This can be problematic when we have a bridge spanning some DSA switch
> ports and some non-DSA ports (which we'll call "foreign interfaces" from
> DSA's perspective).
> 
> There are 2 classes of problems created by the lack of learning on
> CPU-injected traffic:
> - excessive flooding, due to the fact that DSA treats those addresses as
>   unknown
> - the risk of stale routes, which can lead to temporary packet loss
> 
> To illustrate the second class, consider the following situation, which
> is common in production equipment (wireless access points, where there
> is a WLAN interface and an Ethernet switch, and these form a single
> bridging domain).
> 
>  AP 1:
>  +------------------------------------------------------------------------+
>  |                                          br0                           |
>  +------------------------------------------------------------------------+
>  +------------+ +------------+ +------------+ +------------+ +------------+
>  |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
>  +------------+ +------------+ +------------+ +------------+ +------------+
>        |                                                       ^        ^
>        |                                                       |        |
>        |                                                       |        |
>        |                                                    Client A  Client B
>        |
>        |
>        |
>  +------------+ +------------+ +------------+ +------------+ +------------+
>  |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
>  +------------+ +------------+ +------------+ +------------+ +------------+
>  +------------------------------------------------------------------------+
>  |                                          br0                           |
>  +------------------------------------------------------------------------+
>  AP 2
> 
> - br0 of AP 1 will know that Clients A and B are reachable via wlan0
> - the hardware fdb of a DSA switch driver today is not kept in sync with
>   the software entries on other bridge ports, so it will not know that
>   clients A and B are reachable via the CPU port UNLESS the hardware
>   switch itself performs SA learning from traffic injected from the CPU.
>   Nonetheless, a substantial number of switches don't.
> - the hardware fdb of the DSA switch on AP 2 may autonomously learn that
>   Client A and B are reachable through swp0. Therefore, the software br0
>   of AP 2 also may or may not learn this. In the example we're
>   illustrating, some Ethernet traffic has been going on, and br0 from AP
>   2 has indeed learnt that it can reach Client B through swp0.
> 
> One of the wireless clients, say Client B, disconnects from AP 1 and
> roams to AP 2. The topology now looks like this:
> 
>  AP 1:
>  +------------------------------------------------------------------------+
>  |                                          br0                           |
>  +------------------------------------------------------------------------+
>  +------------+ +------------+ +------------+ +------------+ +------------+
>  |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
>  +------------+ +------------+ +------------+ +------------+ +------------+
>        |                                                            ^
>        |                                                            |
>        |                                                         Client A
>        |
>        |
>        |                                                         Client B
>        |                                                            |
>        |                                                            v
>  +------------+ +------------+ +------------+ +------------+ +------------+
>  |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    wlan0   |
>  +------------+ +------------+ +------------+ +------------+ +------------+
>  +------------------------------------------------------------------------+
>  |                                          br0                           |
>  +------------------------------------------------------------------------+
>  AP 2
> 
> - br0 of AP 1 still knows that Client A is reachable via wlan0 (no change)
> - br0 of AP 1 will (possibly) know that Client B has left wlan0. There
>   are cases where it might never find out though. Either way, DSA today
>   does not process that notification in any way.
> - the hardware FDB of the DSA switch on AP 1 may learn autonomously that
>   Client B can be reached via swp0, if it receives any packet with
>   Client 1's source MAC address over Ethernet.
> - the hardware FDB of the DSA switch on AP 2 still thinks that Client B
>   can be reached via swp0. It does not know that it has roamed to wlan0,
>   because it doesn't perform SA learning from the CPU port.
> 
> Now Client A contacts Client B.
> AP 1 routes the packet fine towards swp0 and delivers it on the Ethernet
> segment.
> AP 2 sees a frame on swp0 and its fdb says that the destination is swp0.
> Hairpinning is disabled => drop.
> 
> This problem comes from the fact that these switches have a 'blind spot'
> for addresses coming from software bridging. The generic solution is not
> to assume that hardware learning can be enabled somehow, but to listen
> to more bridge learning events. It turns out that the bridge driver does
> learn in software from all inbound frames, in __br_handle_local_finish.
> A proper SWITCHDEV_FDB_ADD_TO_DEVICE notification is emitted for the
> addresses serviced by the bridge on 'foreign' interfaces. The software
> bridge also does the right thing on migration, by notifying that the old
> entry is deleted, so that does not need to be special-cased in DSA. When
> it is deleted, we just need to delete our static FDB entry towards the
> CPU too, and wait.
> 
> The problem is that DSA currently only cares about SWITCHDEV_FDB_ADD_TO_DEVICE
> events received on its own interfaces, such as static FDB entries.
> 
> Luckily we can change that, and DSA can listen to all switchdev FDB
> add/del events in the system and figure out if those events were emitted
> by a bridge that spans at least one of DSA's own ports. In case that is
> true, DSA will also offload that address towards its own CPU port, in
> the eventuality that there might be bridge clients attached to the DSA
> switch who want to talk to the station connected to the foreign
> interface.
> 
> In terms of implementation, we need to keep the fdb_info->added_by_user
> check for the case where the switchdev event was targeted directly at a
> DSA switch port. But we don't need to look at that flag for snooped
> events. So the check is currently too late, we need to move it earlier.
> This also simplifies the code a bit, since we avoid uselessly allocating
> and freeing switchdev_work.
> 
> We could probably do some improvements in the future. For example,
> multi-bridge support is rudimentary at the moment. If there are two
> bridges spanning a DSA switch's ports, and both of them need to service
> the same MAC address, then what will happen is that the migration of one
> of those stations will trigger the deletion of the FDB entry from the
> CPU port while it is still used by other bridge. That could be improved
> with reference counting but is left for another time.
> 
> This behavior needs to be enabled at driver level by setting
> ds->learning_broken_on_cpu_port = true. This is because we don't want to
> inflict a potential performance penalty (accesses through MDIO/I2C/SPI
> are expensive) to hardware that really doesn't need it because address
> learning on the CPU port works there.
> 
> Reported-by: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

The implementation is much simpler than I though it would be, nice! Just
in case you need to spin a v2, I would probably name the flag
"learning_on_cpu_port_challenged", or preferably
"no_learning_on_cpu_port", the term "broken" is a bit subjective IMHO
(although honestly, why not learn from the CPU port though...)
-- 
Florian
