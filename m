Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155583F2900
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 11:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhHTJRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 05:17:00 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:38511 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233761AbhHTJQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 05:16:56 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id B340C580B27;
        Fri, 20 Aug 2021 05:16:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 20 Aug 2021 05:16:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=p8CFZs
        QoBWGFQjO7uqov/8dojZVhQBnWxPLdLX5Deac=; b=en5I7X27Hl0AqM/iuUIpVx
        uEhA4PbBAuPeO946qSJ3v3qoMb2x57mSm24dCiM9/G38vsAZOyFsTjPle2+SBFL8
        +eCg9xqBoHrXofl72MXleTlr3weB0i2dQa0IgsH33R5jRp7mObWDuZdv9nU+Y/j/
        uRjVu31hQwmPQbJUGzO/ZqR+nFzUKMOJiq+DumIwiqxdhxJcVWzbad70XCYWtzQY
        wGU96TSdkiZyIOiXfQrvY7nMu6QhQTGV4qiwm452A4MPbeS2OVBhwhAv5on4t8g8
        RgPOfLhiTMgRLVdGo0+GDRs2LASO+O88AgQUJ6DuYe4H6DnJxw1gKH0R4kfQN9Jg
        ==
X-ME-Sender: <xms:3nIfYWHbqtcnMxNtmigJOMoHaXfBZhVyu11dSV7cVJSY1-QnGkQMhg>
    <xme:3nIfYXWqOvjxznwnM4Nje9had7G0l6EnXA_87iYwZ2I1y3ctoSHfuBKqmlKlNEKFt
    STNFIRKdArsPZc>
X-ME-Received: <xmr:3nIfYQIKXPck_ptKtj7NjdRHQ0IzRhtf8j2kjlAgwexWFolOgmoaDMTHqf7CUnx6JiBZgr-6x_djs-K4lyvCn6TNbVWQPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleelgddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfgkeev
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:3nIfYQF76T0mazT1GLKlwnmqzAasWpsXgyuOZV8CJD2wjLbPQiK_fA>
    <xmx:3nIfYcUJHKAcyaPTHYACAHipqkETbEH-BZtZgcVNb6AmigwYWvZ-Og>
    <xmx:3nIfYTPDObXdMwce2c4o4_ElHzfPj5315bu3Dm6VlAY5p0K3EGCVWA>
    <xmx:4nIfYSEdgA9CiyjRB_lRPAuVPZuq-sEjQCkrK-DnOD1z5NNtHWtyxw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Aug 2021 05:16:13 -0400 (EDT)
Date:   Fri, 20 Aug 2021 12:16:10 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
Message-ID: <YR9y2nwQWtGTumIS@shredder>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 07:07:18PM +0300, Vladimir Oltean wrote:
> Problem statement:
> 
> Any time a driver needs to create a private association between a bridge
> upper interface and use that association within its
> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
> entries deleted by the bridge when the port leaves. The issue is that
> all switchdev drivers schedule a work item to have sleepable context,
> and that work item can be actually scheduled after the port has left the
> bridge, which means the association might have already been broken by
> the time the scheduled FDB work item attempts to use it.

This is handled in mlxsw by telling the device to flush the FDB entries
pointing to the {port, FID} when the VLAN is deleted (synchronously).

> 
> The solution is to modify switchdev to use its embedded SWITCHDEV_F_DEFER
> mechanism to make the FDB notifiers emitted from the fastpath be
> scheduled in sleepable context. All drivers are converted to handle
> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE from their blocking notifier block
> handler (or register a blocking switchdev notifier handler if they
> didn't have one). This solves the aforementioned problem because the
> bridge waits for the switchdev deferred work items to finish before a
> port leaves (del_nbp calls switchdev_deferred_process), whereas a work
> item privately scheduled by the driver will obviously not be waited upon
> by the bridge, leading to the possibility of having the race.

How the problem is solved if after this patchset drivers still queue a
work item?

DSA supports learning, but does not report the entries to the bridge.
How are these entries deleted when a port leaves the bridge?

> 
> This is a dependency for the "DSA FDB isolation" posted here. It was
> split out of that series hence the numbering starts directly at v2.
> 
> https://patchwork.kernel.org/project/netdevbpf/cover/20210818120150.892647-1-vladimir.oltean@nxp.com/

What is FDB isolation? Cover letter says: "There are use cases which
need FDB isolation between standalone ports and bridged ports, as well
as isolation between ports of different bridges".

Does it mean that DSA currently forwards packets between ports even if
they are member in different bridges or standalone?

> 
> Vladimir Oltean (5):
>   net: switchdev: move SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE to the blocking
>     notifier chain
>   net: bridge: switchdev: make br_fdb_replay offer sleepable context to
>     consumers
>   net: switchdev: drop the atomic notifier block from
>     switchdev_bridge_port_{,un}offload
>   net: switchdev: don't assume RCU context in
>     switchdev_handle_fdb_{add,del}_to_device
>   net: dsa: handle SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE synchronously
> 
>  .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  86 +++++------
>  .../marvell/prestera/prestera_switchdev.c     | 110 +++++++-------
>  .../mellanox/mlx5/core/en/rep/bridge.c        |  59 +++++++-
>  .../mellanox/mlxsw/spectrum_switchdev.c       |  61 +++++++-
>  .../microchip/sparx5/sparx5_switchdev.c       |  78 +++++-----
>  drivers/net/ethernet/mscc/ocelot_net.c        |   3 -
>  drivers/net/ethernet/rocker/rocker_main.c     |  73 ++++-----
>  drivers/net/ethernet/rocker/rocker_ofdpa.c    |   4 +-
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   4 +-
>  drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  57 ++++----
>  drivers/net/ethernet/ti/cpsw_new.c            |   4 +-
>  drivers/net/ethernet/ti/cpsw_switchdev.c      |  60 ++++----
>  drivers/s390/net/qeth_l2_main.c               |  10 +-
>  include/net/switchdev.h                       |  30 +++-
>  net/bridge/br.c                               |   5 +-
>  net/bridge/br_fdb.c                           |  40 ++++-
>  net/bridge/br_private.h                       |   4 -
>  net/bridge/br_switchdev.c                     |  18 +--
>  net/dsa/dsa.c                                 |  15 --
>  net/dsa/dsa_priv.h                            |  15 --
>  net/dsa/port.c                                |   3 -
>  net/dsa/slave.c                               | 138 ++++++------------
>  net/switchdev/switchdev.c                     |  61 +++++++-
>  23 files changed, 529 insertions(+), 409 deletions(-)
> 
> -- 
> 2.25.1
> 
