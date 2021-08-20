Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F7F3F31FB
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 19:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhHTRHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 13:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbhHTRHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 13:07:22 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D2DC061575
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 10:06:43 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gr13so21567711ejb.6
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 10:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ecPgqBqmFzsFcTtJQuMB2hArnZJEHFMJRz4EsQsOPCY=;
        b=sGwIAoebtQoXqpzxjQlu4FVyl9dJwU6ShbwX70egGb7S5a6unNp9DBkb8/SJRsQ1Aq
         l7a9zMwo8HUZ5hnSDru4M9pCunEfKOGzVndjV0Rwj5ioddzqYOablxS01J1f9ACkO589
         q70wLRFhJnl0vf5caJiqAHn5/tK2xf/EBWY8qgFqLH5oSLqZ+agvnAvCkJ3GVh2NJaXw
         skff0ISvxBfAb/LMfK1G9K+YOqVJjrIr3NFdb/NCQrzOWbHSjSpt8hoaxFBqK7WqgfYF
         78x+vXhFz2djsaKoACI7gFBddkbNd0uN0WrqhDJ0t/x+kutEaaCt9O1PyvlOxFG8Od9c
         lavQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ecPgqBqmFzsFcTtJQuMB2hArnZJEHFMJRz4EsQsOPCY=;
        b=Ptvd4OHX1A4a1G+B1Vvkfsu7MSAcH2n7FUljczWY9a5nnyL3xmtCpzv5bq6p4+YHo7
         WDC6Pdh8PY7M7c9uuHl3oa5bsHoZCs4haETFAhsTscbHLg4r6WJLI76j5B/NoyT4lsLn
         zWkssr7D47U4gRrFtylSflZ4p10ZB2pyaR4GSyTEpb4o3/zGi489xDscM6L1gv/13H6P
         QlQzrC5nBD641FQwYJFVX9+R3ZKcTuu1B20CJdjgCi9mCfNmEBKchXASY2h45pMytKin
         /lAix4ZMXeOjrmlhU24vC6IT2MElHpdAM1qzX7iH8lGkgPpHMbTcBjuFsT1CUiJx6spr
         ukRw==
X-Gm-Message-State: AOAM531gWeK48paO7bOaWzTl5r+Nb/AL4JOOirISCdCh6hV/poOgy4of
        8Ul0OTjFiOlMKp1BTYj0GE8=
X-Google-Smtp-Source: ABdhPJzR2cQ0y6fdb1JnEvBYXWJEOjCh0hkKtankK7y92Fp7I6+Cn9wtHyfZlwkEQYvV5HbaIVAg6g==
X-Received: by 2002:a17:906:6a8d:: with SMTP id p13mr22420449ejr.327.1629479202356;
        Fri, 20 Aug 2021 10:06:42 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id o3sm3093155eju.123.2021.08.20.10.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 10:06:41 -0700 (PDT)
Date:   Fri, 20 Aug 2021 20:06:39 +0300
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
Message-ID: <20210820170639.rvzlh4b6agvrkv2w@skbuf>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <YR9y2nwQWtGTumIS@shredder>
 <20210820093723.qdvnvdqjda3m52v6@skbuf>
 <YR/TrkbhhN7QpRcQ@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YR/TrkbhhN7QpRcQ@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 07:09:18PM +0300, Ido Schimmel wrote:
> On Fri, Aug 20, 2021 at 12:37:23PM +0300, Vladimir Oltean wrote:
> > On Fri, Aug 20, 2021 at 12:16:10PM +0300, Ido Schimmel wrote:
> > > On Thu, Aug 19, 2021 at 07:07:18PM +0300, Vladimir Oltean wrote:
> > > > Problem statement:
> > > >
> > > > Any time a driver needs to create a private association between a bridge
> > > > upper interface and use that association within its
> > > > SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
> > > > entries deleted by the bridge when the port leaves. The issue is that
> > > > all switchdev drivers schedule a work item to have sleepable context,
> > > > and that work item can be actually scheduled after the port has left the
> > > > bridge, which means the association might have already been broken by
> > > > the time the scheduled FDB work item attempts to use it.
> > >
> > > This is handled in mlxsw by telling the device to flush the FDB entries
> > > pointing to the {port, FID} when the VLAN is deleted (synchronously).
> >
> > Again, central solution vs mlxsw solution.
>
> Again, a solution is forced on everyone regardless if it benefits them
> or not. List is bombarded with version after version until patches are
> applied. *EXHAUSTING*.

So if I replace "bombarded" with a more neutral word, isn't that how
it's done though? What would you do if you wanted to achieve something
but the framework stood in your way? Would you work around it to avoid
bombarding the list?

> With these patches, except DSA, everyone gets another queue_work() for
> each FDB entry. In some cases, it completely misses the purpose of the
> patchset.

I also fail to see the point. Patch 3 will have to make things worse
before they get better. It is like that in DSA too, and made more
reasonable only in the last patch from the series.

If I saw any middle-ground way, like keeping the notifiers on the atomic
chain for unconverted drivers, I would have done it. But what do you do
if more than one driver listens for one event, one driver wants it
blocking, the other wants it atomic. Do you make the bridge emit it
twice? That's even worse than having one useless queue_work() in some
drivers.

So if you think I can avoid that please tell me how.

> Want a central solution? Make sure it is properly integrated. "Don't
> have the energy"? Ask for help. Do not try to force a solution on
> everyone and motivate them to change the code by doing a poor conversion
> yourself.
>
> I don't accept "this will have to do".

So I can make many suppositions about what I did wrong, but I would
prefer that you tell me.

Is it the timing, as we're late in the development cycle? Maybe, and
that would make a lot of sense, but I don't want to assume anything that
has not been said.

Is it that I converted too few drivers? You said I'm bombarding the
list. Can I convert more drivers with less code? I would be absolutely
glad to. I have more driver conversions unsubmitted, some tested on
hardware.

Is it that I didn't ask for help? I still believe that it is best I
leave the driver maintainers to do the rest of the conversion, at their
own pace and with hardware to test and find issues I can not using just
code analysis and non-expert knowledge. After all, with all due respect
to the net-next tree, I sent these patches to a development git tree,
not to a production facility.

> > > What is FDB isolation? Cover letter says: "There are use cases which
> > > need FDB isolation between standalone ports and bridged ports, as well
> > > as isolation between ports of different bridges".
> >
> > FDB isolation means exactly what it says: that the hardware FDB lookup
> > of ports that are standalone, or under one bridge, is unable to find FDB entries
> > (same MAC address, same VID) learned on another port from another bridge.
> >
> > > Does it mean that DSA currently forwards packets between ports even if
> > > they are member in different bridges or standalone?
> >
> > No, that is plain forwarding isolation in my understanding of terms, and
> > we have had that for many years now.
>
> So if I have {00:01:02:03:04:05, 5} in br0, but not in br1 and now a
> packet with this DMAC/VID needs to be forwarded in br1 it will be
> dropped instead of being flooded?

Yes.
