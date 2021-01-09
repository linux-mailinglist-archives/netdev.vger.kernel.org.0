Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1C72EFDA9
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 05:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbhAIELh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 23:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbhAIELh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 23:11:37 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309BCC061573
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 20:10:57 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id v19so8901198pgj.12
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 20:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K4ITaKikt6NJoisRj5YoDgeOg2Jm8GNp7c5ShxWYwp4=;
        b=KhiQG6BitjTSlczAU3bkSWiR8gPo78koicyBcn3ntDGWOWxNDbzCqRGrJrVrUjkHij
         jbZMjN1rNbRMFLerYB1DdtvVD+Nc/Rd8nVqcaCMGvvA/bp4rfZaDnkFxbKz8ADClPzMV
         R6AAqadhPIx4KhMQvNNnnWM66nBApMZQJEGboiDJlkJoxNm7Xoy6tfQn4nOH7Ldood0q
         1rvyGU+rusHkGiMkYYdKA1pbZoY6cJbyELXcBo5SvLqswaeOd6xfvdZCwZF82CxtXv+2
         F4tuHdFs9GJbFJAq8TWJBWySarbNvTZ5HlUC0YYen8M2Lln5uxqwl9BCEbA83TcH4+Qa
         mYqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K4ITaKikt6NJoisRj5YoDgeOg2Jm8GNp7c5ShxWYwp4=;
        b=bsAqQT8NP3K9+259wP0+y0nlViminLSP+QL3z+PDcgvYT95YVF3HAi9imJUKZMyQ3W
         RiWjPb5YFF9j7rg3BSO95kyESLRVXBkAb3RGHsD40ksryUDW9H4nQq2yXgevCSC8k/8k
         G/3XDBs/ZOG/g3pBIQiHN3+yU16/hUph94g/7Sh9nVi3y2ZdR/AMmJ6rC33UhobR5CbQ
         AVaWcAqQNRfgu8kyaqpp6gs8GhBMjKsgYi0BmRfun0+xJkh4QliJ6iVWGiBlzuOmSYfC
         hSMtwZsZUfnilzNi8OXzmSC49uUXK7fqZNYRSI/FlRgAPC7LrCXT6+jC5Re2yxjA1Ne+
         U70Q==
X-Gm-Message-State: AOAM531fLZJaDaZLC8C/QFmwGwRXf+UF2w1wDe5R75ReW5DsnUTdo1x8
        mqXkxHLVSncjU8RHr3pUCpc=
X-Google-Smtp-Source: ABdhPJz+fs0wEsU8zoB+twJws1OPL1vVJvIYqp+H1Eo/F0fzxHW6kwCpYXknTMNzY1prDJM1nZMpZw==
X-Received: by 2002:a63:e049:: with SMTP id n9mr10058557pgj.339.1610165456613;
        Fri, 08 Jan 2021 20:10:56 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z2sm10846061pgl.49.2021.01.08.20.10.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 20:10:55 -0800 (PST)
Subject: Re: [PATCH v4 net-next 01/11] net: switchdev: remove vid_begin ->
 vid_end range from VLAN objects
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Petr Machata <petrm@nvidia.com>
References: <20210109000156.1246735-1-olteanv@gmail.com>
 <20210109000156.1246735-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4a31ec53-bced-35e8-e6bf-4a47f83a456f@gmail.com>
Date:   Fri, 8 Jan 2021 20:10:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210109000156.1246735-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 4:01 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The call path of a switchdev VLAN addition to the bridge looks something
> like this today:
> 
>         nbp_vlan_init
>         |  __br_vlan_set_default_pvid
>         |  |                       |
>         |  |    br_afspec          |
>         |  |        |              |
>         |  |        v              |
>         |  | br_process_vlan_info  |
>         |  |        |              |
>         |  |        v              |
>         |  |   br_vlan_info        |
>         |  |       / \            /
>         |  |      /   \          /
>         |  |     /     \        /
>         |  |    /       \      /
>         v  v   v         v    v
>       nbp_vlan_add   br_vlan_add ------+
>        |              ^      ^ |       |
>        |             /       | |       |
>        |            /       /  /       |
>        \ br_vlan_get_master/  /        v
>         \        ^        /  /  br_vlan_add_existing
>          \       |       /  /          |
>           \      |      /  /          /
>            \     |     /  /          /
>             \    |    /  /          /
>              \   |   /  /          /
>               v  |   | v          /
>               __vlan_add         /
>                  / |            /
>                 /  |           /
>                v   |          /
>    __vlan_vid_add  |         /
>                \   |        /
>                 v  v        v
>       br_switchdev_port_vlan_add
> 
> The ranges UAPI was introduced to the bridge in commit bdced7ef7838
> ("bridge: support for multiple vlans and vlan ranges in setlink and
> dellink requests") (Jan 10 2015). But the VLAN ranges (parsed in br_afspec)
> have always been passed one by one, through struct bridge_vlan_info
> tmp_vinfo, to br_vlan_info. So the range never went too far in depth.
> 
> Then Scott Feldman introduced the switchdev_port_bridge_setlink function
> in commit 47f8328bb1a4 ("switchdev: add new switchdev bridge setlink").
> That marked the introduction of the SWITCHDEV_OBJ_PORT_VLAN, which made
> full use of the range. But switchdev_port_bridge_setlink was called like
> this:
> 
> br_setlink
> -> br_afspec
> -> switchdev_port_bridge_setlink
> 
> Basically, the switchdev and the bridge code were not tightly integrated.
> Then commit 41c498b9359e ("bridge: restore br_setlink back to original")
> came, and switchdev drivers were required to implement
> .ndo_bridge_setlink = switchdev_port_bridge_setlink for a while.
> 
> In the meantime, commits such as 0944d6b5a2fa ("bridge: try switchdev op
> first in __vlan_vid_add/del") finally made switchdev penetrate the
> br_vlan_info() barrier and start to develop the call path we have today.
> But remember, br_vlan_info() still receives VLANs one by one.
> 
> Then Arkadi Sharshevsky refactored the switchdev API in 2017 in commit
> 29ab586c3d83 ("net: switchdev: Remove bridge bypass support from
> switchdev") so that drivers would not implement .ndo_bridge_setlink any
> longer. The switchdev_port_bridge_setlink also got deleted.
> This refactoring removed the parallel bridge_setlink implementation from
> switchdev, and left the only switchdev VLAN objects to be the ones
> offloaded from __vlan_vid_add (basically RX filtering) and  __vlan_add
> (the latter coming from commit 9c86ce2c1ae3 ("net: bridge: Notify about
> bridge VLANs")).
> 
> That is to say, today the switchdev VLAN object ranges are not used in
> the kernel. Refactoring the above call path is a bit complicated, when
> the bridge VLAN call path is already a bit complicated.
> 
> Let's go off and finish the job of commit 29ab586c3d83 by deleting the
> bogus iteration through the VLAN ranges from the drivers. Some aspects
> of this feature never made too much sense in the first place. For
> example, what is a range of VLANs all having the BRIDGE_VLAN_INFO_PVID
> flag supposed to mean, when a port can obviously have a single pvid?
> This particular configuration _is_ denied as of commit 6623c60dc28e
> ("bridge: vlan: enforce no pvid flag in vlan ranges"), but from an API
> perspective, the driver still has to play pretend, and only offload the
> vlan->vid_end as pvid. And the addition of a switchdev VLAN object can
> modify the flags of another, completely unrelated, switchdev VLAN
> object! (a VLAN that is PVID will invalidate the PVID flag from whatever
> other VLAN had previously been offloaded with switchdev and had that
> flag. Yet switchdev never notifies about that change, drivers are
> supposed to guess).
> 
> Nonetheless, having a VLAN range in the API makes error handling look
> scarier than it really is - unwinding on errors and all of that.
> When in reality, no one really calls this API with more than one VLAN.
> It is all unnecessary complexity.
> 
> And despite appearing pretentious (two-phase transactional model and
> all), the switchdev API is really sloppy because the VLAN addition and
> removal operations are not paired with one another (you can add a VLAN
> 100 times and delete it just once). The bridge notifies through
> switchdev of a VLAN addition not only when the flags of an existing VLAN
> change, but also when nothing changes. There are switchdev drivers out
> there who don't like adding a VLAN that has already been added, and
> those checks don't really belong at driver level. But the fact that the
> API contains ranges is yet another factor that prevents this from being
> addressed in the future.
> 
> Of the existing switchdev pieces of hardware, it appears that only
> Mellanox Spectrum supports offloading more than one VLAN at a time,
> through mlxsw_sp_port_vlan_set. I have kept that code internal to the
> driver, because there is some more bookkeeping that makes use of it, but
> I deleted it from the switchdev API. But since the switchdev support for
> ranges has already been de facto deleted by a Mellanox employee and
> nobody noticed for 4 years, I'm going to assume it's not a biggie.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com> # switchdev and mlxsw

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
