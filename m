Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D6630996A
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 01:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhAaAeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 19:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbhAaAeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 19:34:19 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016ACC061573;
        Sat, 30 Jan 2021 16:33:38 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id s5so1958132edw.8;
        Sat, 30 Jan 2021 16:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kzq/GQt2yVaeDoy/LnxfjPMyQ9vcFmj/uvYalC+5OKc=;
        b=h4FvtfsWh/EEv/XruLtTAN9jXoA5GMIHqUjNeSJI+MHhKtUzLB9cIR9LGMk/FuqYpe
         zG4NGW9BLc/gUIFy+7eSE9A/VQ1qdjZBd3Nl44sr4/zUQLdOgDbjQZBcJFq7stpNvdsV
         jAgrJxQecgQFfc5zzkVpDHuth0ZIfMT7Wjbhcbjgg6aNZLq4IZPYlPo9JP7ZxBgo/J1P
         8N6mD6gDqPG6GAXwNnMNrr7tRCS4u4lrgU+C3b4kN46pZIe70JyYPKEtFG7SRv1GIKD7
         SHQ1CR/NUOBlQRNkhMQuH+klICiJDofj00OvFbC3TpAl2bbiCrCVhtdRMIUErwBpiq6+
         3Pcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kzq/GQt2yVaeDoy/LnxfjPMyQ9vcFmj/uvYalC+5OKc=;
        b=ECQ69LlAuzHl1IKDLJASedf5t55WFiekNo0WJwsmKQ7G3ERhOMZnkTiHIF1Ps8XcIr
         OHpYhoiOchc6yrLXbBQ+3bqavvbsSwUN3Fsip8GVfkIbNWcAWOC9d0upJw9lWfBI2CrM
         8bxHD1JHgyrzvLAcP7BRk/1m/GHq3PtizAcpeiCP4vQ3fOd14E4MA20K2zMy0mzT9heq
         z3KCWtv0lpOzLCDiYW+3f8gMjXm8XTfgWP3jVKjwlRv8mLFK/njajUjBWUjkmncMA+N8
         zdNm0l3pqYEG5rSyVwBn9PkcGxhyMVJin0+LQ63s2EQ3PNTmoOyAspO+DIhng8hUoZyN
         LvTQ==
X-Gm-Message-State: AOAM530ESpIBBOh1RDjlLX6MP9nGr2cCeeTXEppGRaEgaE0mcRVxqTjN
        +GtOwi3mv7XAmdrahl93EJo=
X-Google-Smtp-Source: ABdhPJxq3iRs+6XXYPNADW6VDrjBBcE67G0Ti0Ux5FAzPOyc7eac6IBZohUHhBrxRS1lKm3aw+oyVA==
X-Received: by 2002:a05:6402:34c5:: with SMTP id w5mr12234645edc.65.1612053215877;
        Sat, 30 Jan 2021 16:33:35 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s15sm5907300ejy.68.2021.01.30.16.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 16:33:35 -0800 (PST)
Date:   Sun, 31 Jan 2021 02:33:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: override existent unicast
 portvec in port_fdb_add
Message-ID: <20210131003333.5lhacwr4usd3dv2l@skbuf>
References: <20210130134334.10243-1-dqfext@gmail.com>
 <87eei25f09.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eei25f09.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 09:47:02PM +0100, Tobias Waldekranz wrote:
> root@envoy:~# bridge fdb add 02:00:de:ad:00:01 dev eth1 static vlan 1
> Why does the second add operation succeed? Am I missing some magic flag?

Yes, 'master'.
We talked about this before. 'bridge fdb add' is implicitly 'self' which
bypasses the bridge code and shoots straight for the .ndo_fdb_add that
DSA implements. Maybe we should just kill that to avoid further
confusion.

$ bridge link
6: eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
7: eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
10: swp5@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
11: swp2@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
12: swp3@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
13: swp4@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 4
$ bridge fdb add 00:01:02:03:04:05 dev eth0 master static
$ bridge fdb add 00:01:02:03:04:05 dev eth1 master static
RTNETLINK answers: File exists
