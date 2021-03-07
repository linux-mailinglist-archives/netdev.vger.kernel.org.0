Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD8B330285
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 16:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhCGPR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 10:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhCGPR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 10:17:28 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4012C06174A
        for <netdev@vger.kernel.org>; Sun,  7 Mar 2021 07:17:17 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id v2so2351289lft.9
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 07:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=HSBErEyrDSnb4IkBqIVsRuAuMSBH5oWCyYn2fpOctfc=;
        b=SPfGLZzU7nZBP1XAjA9G4nlW1JaZZhFZ2feTeo8suRi3hQUWFxK8/JR6hL+poCpmL8
         lj2wv4f4TACdckGE9JJChr5RKyyEEqa3bQAx/K1YhRYZbiTwvutxTVEy/+m/AgjLVP42
         BvpgUJLHAfWTqukWyr5+NhDnm935dSH8Q1jsV/v8gwJpscpYAzyEsM8g9HI1+JqTgcsO
         Q9OQvGrDBnDyxCwT1M7tvX+B72NvQx/rNxvS/zRBUHEIALEPQCzLeiHIUUDBiWzScxSy
         lBkSmldvuECd0wUyTUu2CaVzgrirsH28Id+lO0d0WwCJRQRyBhdZKBIXVw6DIdkfVHYK
         TSqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HSBErEyrDSnb4IkBqIVsRuAuMSBH5oWCyYn2fpOctfc=;
        b=Zce48mT2rSoeJi/9af4VCEhOxugA3ysYOChvdEchCYilv84fvoRm153nYVjCsGn9Ub
         BY5FF6U63YVAFdnXLL/f454pJq+YSqCLSkspR2Opq7QX06Nbi2GxWUj5QYZP9i5zU16D
         PxyrxUkbmgTtbxggsXtOAuBO1DR6ob3z2bs3GjAXFOvZKpyxT6takQVOe+IbpswoHHvs
         CN25wAVh3L0CjLIzydV1vLrhkPMrpTPobL8dnvR5Y+S+IghYsYiTIX8CmIb3AmA1NoEv
         pSsVJqD47ypIZNj+FCgkWraGODFOa5082MbONCo7cjs304cfDwzAXPVZij6+LgqvBvU1
         O9rg==
X-Gm-Message-State: AOAM531yO7aZraZd7nWSfBnlzOjNe2MoDIY4Yx8jjOu7wIxidzzpJ/pX
        pVW6DiOoDUtmtzNIfikXJL6aUw==
X-Google-Smtp-Source: ABdhPJxVEH/zLk6BxtpJGtE0hDX20Jhe91nuYQLg7DN/U+X6A3Af9rYt+KNuScNcH+R9ybmKkM1+1A==
X-Received: by 2002:ac2:57c9:: with SMTP id k9mr11854994lfo.119.1615130236242;
        Sun, 07 Mar 2021 07:17:16 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id g10sm1059239lfe.90.2021.03.07.07.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 07:17:15 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net] net: dsa: fix switchdev objects on bridge master mistakenly being applied on ports
In-Reply-To: <20210307102156.2282877-1-olteanv@gmail.com>
References: <20210307102156.2282877-1-olteanv@gmail.com>
Date:   Sun, 07 Mar 2021 16:17:14 +0100
Message-ID: <874khnq9hh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 12:21, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Tobias reports that after the blamed patch, VLAN objects being added to
> a bridge device are being added to all slave ports instead (swp2, swp3).
>
> ip link add br0 type bridge vlan_filtering 1
> ip link set swp2 master br0
> ip link set swp3 master br0
> bridge vlan add dev br0 vid 100 self
>
> This is because the fix was too broad: we made dsa_port_offloads_netdev
> say "yes, I offload the br0 bridge" for all slave ports, but we didn't
> add the checks whether the switchdev object was in fact meant for the
> physical port or for the bridge itself. So we are reacting on events in
> a way in which we shouldn't.
>
> The reason why the fix was too broad is because the question itself,
> "does this DSA port offload this netdev", was too broad in the first
> place. The solution is to disambiguate the question and separate it into
> two different functions, one to be called for each switchdev attribute /
> object that has an orig_dev == net_bridge (dsa_port_offloads_bridge),
> and the other for orig_dev == net_bridge_port (*_offloads_bridge_port).
>
> In the case of VLAN objects on the bridge interface, this solves the
> problem because we know that VLAN objects are per bridge port and not
> per bridge. And when orig_dev is equal to the net_bridge, we offload it
> as a bridge, but not as a bridge port; that's how we are able to skip
> reacting on those events. Note that this is compatible with future plans
> to have explicit offloading of VLAN objects on the bridge interface as a
> bridge port (in DSA, this signifies that we should add that VLAN towards
> the CPU port).
>
> Fixes: 99b8202b179f ("net: dsa: fix SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING getting ignored")
> Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Please wait before applying.

I need to do some more testing later (possibly tomorrow). But I am
pretty sure that this patch does not work with the (admittedly somewhat
exotic) combination of:

- Non-offloaded LAG
- Bridge with VLAN filtering enabled.

When adding the LAG to the bridge, I get an error because mv88e6xxx
tries to add VLAN 1 to the ports (which it should not do as the LAG is
not offloaded).
