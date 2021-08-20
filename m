Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54653F2954
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 11:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbhHTJiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 05:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235001AbhHTJiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 05:38:06 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5018AC061575
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 02:37:28 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gr13so18960919ejb.6
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 02:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3jmipdcU2wWlFmVrXV5FBipNUDtiJIUF/hkmr9i7X6g=;
        b=Ev7B3qy/6OQNvOfBzTOpew9ITlbmptwDZO33pFWTAEKCKCGCvVb2l7DMpz/LOUms76
         ywEhwgcwC+tUAse5R7eF1e2RYZNeAddRBGHuY03B2ubPVekrYDyME8YYhbeZPhzLBqSy
         Oxa8Td8DDqpczPdBeLNgMhcVMzJ/lcBSdxG6TzgX9Xz0CbPvnCcr4BPdoPIZgl5ZDIpd
         MGiWm4LbaifageRHbxybbEw1PxAxxhRpjqkt9kjvBjXxhNEaC4+Wl9OVXI1p1V6cSpTD
         ngcSWDxYxDbcA9Nt2F5AIrHXazoVRJc5InRAzKVrvb4ir8P6ydXel5ftkjcIwHKLRz13
         QEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3jmipdcU2wWlFmVrXV5FBipNUDtiJIUF/hkmr9i7X6g=;
        b=jmOUz3Ikw2InJEvf++3xVEsmGnvSI7Hf8m630hijEnBL1J+D6a+L22GxEMgdhat25T
         l0ehqT8hk++dsfJNiyg/KC6YiyWntKS7c/azp1zwST5nOrEwC6qUMWqX2/aionC7K/8J
         pVFzY/gV+1aV+YO9DwAPy5O2tXNRmAIowNSyIR6TXI7fVUmvdWcf4UpgbTqCat1nXXhS
         fOYh7qrO34vdbRlL4UK6zY3blsns3ba529Dj3QZnLpa4tYE5riYFzyP5gv5aF/8ipVT7
         8WXpW1a/Iabuz8aGrU6HjhbwLC2pouN5kYH0Zd7qPRttbcYpD2+PgIgOO2O1E+jydcMX
         NMPg==
X-Gm-Message-State: AOAM531Lat1NDpZni/eKVqyOL6e59bbW5cGKBGhFZByFELFFGIu5d8PZ
        UHDG9dwNo9XU7WqaMrjTeKs=
X-Google-Smtp-Source: ABdhPJx1xv3Gtp9rS9Uzynp5wUaDaw6CFcLTSZrambjxQPMzZtqfBB5723c7Tvr21ddu5BasLrrkDQ==
X-Received: by 2002:a17:907:1043:: with SMTP id oy3mr1446777ejb.116.1629452246831;
        Fri, 20 Aug 2021 02:37:26 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id w5sm2634396ejz.25.2021.08.20.02.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 02:37:26 -0700 (PDT)
Date:   Fri, 20 Aug 2021 12:37:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v2 net-next 0/5] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
Message-ID: <20210820093723.qdvnvdqjda3m52v6@skbuf>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <YR9y2nwQWtGTumIS@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YR9y2nwQWtGTumIS@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 12:16:10PM +0300, Ido Schimmel wrote:
> On Thu, Aug 19, 2021 at 07:07:18PM +0300, Vladimir Oltean wrote:
> > Problem statement:
> > 
> > Any time a driver needs to create a private association between a bridge
> > upper interface and use that association within its
> > SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
> > entries deleted by the bridge when the port leaves. The issue is that
> > all switchdev drivers schedule a work item to have sleepable context,
> > and that work item can be actually scheduled after the port has left the
> > bridge, which means the association might have already been broken by
> > the time the scheduled FDB work item attempts to use it.
> 
> This is handled in mlxsw by telling the device to flush the FDB entries
> pointing to the {port, FID} when the VLAN is deleted (synchronously).

Again, central solution vs mlxsw solution.

If a port leaves a LAG that is offloaded but the LAG does not leave the
bridge, the driver still needs to initiate the VLAN deletion. I really
don't like that, it makes switchdev drivers bloated.

As long as you call switchdev_bridge_port_unoffload and you populate the
blocking notifier pointer, you will get replays of item deletion from
the bridge.

> > The solution is to modify switchdev to use its embedded SWITCHDEV_F_DEFER
> > mechanism to make the FDB notifiers emitted from the fastpath be
> > scheduled in sleepable context. All drivers are converted to handle
> > SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE from their blocking notifier block
> > handler (or register a blocking switchdev notifier handler if they
> > didn't have one). This solves the aforementioned problem because the
> > bridge waits for the switchdev deferred work items to finish before a
> > port leaves (del_nbp calls switchdev_deferred_process), whereas a work
> > item privately scheduled by the driver will obviously not be waited upon
> > by the bridge, leading to the possibility of having the race.
> 
> How the problem is solved if after this patchset drivers still queue a
> work item?

It's only a problem if you bank on any stateful association between FDB
entries and your ports (aka you expect that port->bridge_dev still holds
the same value in the atomic handler as in the deferred work item). I
think drivers don't do this at the moment, otherwise they would be
broken.

When they need that, they will convert to synchronous handling and all
will be fine.

> DSA supports learning, but does not report the entries to the bridge.

Why is this relevant exactly?

> How are these entries deleted when a port leaves the bridge?

dsa_port_fast_age does the following
(a) deletes the hardware learned entries on a port, in all VLANs
(b) notifies the bridge to also flush its software FDB on that port

It is called
(a) when the STP state changes from a learning-capable state (LEARNING,
    FORWARDING) to a non-learning capable state (BLOCKING, LISTENING)
(b) when learning is turned off by the user
(c) when learning is turned off by the port becoming standalone after
    leaving a bridge (actually same code path as b)

So the FDB of a port is also flushed when a single switch port leaves a
LAG that is the actual bridge port (maybe not ideal, but I don't know
any better).

> > This is a dependency for the "DSA FDB isolation" posted here. It was
> > split out of that series hence the numbering starts directly at v2.
> > 
> > https://patchwork.kernel.org/project/netdevbpf/cover/20210818120150.892647-1-vladimir.oltean@nxp.com/
> 
> What is FDB isolation? Cover letter says: "There are use cases which
> need FDB isolation between standalone ports and bridged ports, as well
> as isolation between ports of different bridges".

FDB isolation means exactly what it says: that the hardware FDB lookup
of ports that are standalone, or under one bridge, is unable to find FDB entries
(same MAC address, same VID) learned on another port from another bridge.

> Does it mean that DSA currently forwards packets between ports even if
> they are member in different bridges or standalone?

No, that is plain forwarding isolation in my understanding of terms, and
we have had that for many years now.
