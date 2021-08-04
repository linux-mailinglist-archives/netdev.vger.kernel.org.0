Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFE83E04FE
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbhHDPyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:54:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:1307 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239692AbhHDPx4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 11:53:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10066"; a="212087308"
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="212087308"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 08:53:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="441798957"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga007.fm.intel.com with ESMTP; 04 Aug 2021 08:53:34 -0700
Received: from alobakin-mobl.ger.corp.intel.com (kswiecic-MOBL.ger.corp.intel.com [10.213.28.10])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 174FrTiQ022328;
        Wed, 4 Aug 2021 16:53:29 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 03/21] ethtool, stats: introduce standard XDP statistics
Date:   Wed,  4 Aug 2021 17:53:27 +0200
Message-Id: <20210804155327.337-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210804053650.22aa8a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com> <20210803163641.3743-4-alexandr.lobakin@intel.com> <20210803134900.578b4c37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <ec0aefbc987575d1979f9102d331bd3e8f809824.camel@kernel.org> <20210804053650.22aa8a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 4 Aug 2021 05:36:50 -0700

> On Tue, 03 Aug 2021 16:57:22 -0700 Saeed Mahameed wrote:
> > On Tue, 2021-08-03 at 13:49 -0700, Jakub Kicinski wrote:
> > > On Tue,  3 Aug 2021 18:36:23 +0200 Alexander Lobakin wrote:  
> > > > Most of the driver-side XDP enabled drivers provide some statistics
> > > > on XDP programs runs and different actions taken (number of passes,
> > > > drops, redirects etc.).  
> > > 
> > > Could you please share the statistics to back that statement up?
> > > Having uAPI for XDP stats is pretty much making the recommendation 
> > > that drivers should implement such stats. The recommendation from
> > > Alexei and others back in the day (IIRC) was that XDP programs should
> > > implement stats, not the drivers, to avoid duplication.

Well, 20+ patches in the series with at least half of them is
drivers conversion. Plus mlx5. Plus we'll about to land XDP
statistics for all Intel drivers, just firstly need to get a
common infra for them (the purpose of this series).

Also, introducing IEEE and rmon stats didn't make a statement that
all drivers should really expose them, right?

> > There are stats "mainly errors*"  that are not even visible or reported
> > to the user prog, 

Not really. Many drivers like to count the number of redirects,
xdp_xmits and stuff (incl. mlx5). Nevertheless, these stats aren't
the same as something you can get from inside an XDP prog, right.

> Fair point, exceptions should not be performance critical.
> 
> > for that i had an idea in the past to attach an
> > exception_bpf_prog provided by the user, where driver/stack will report
> > errors to this special exception_prog.
> 
> Or maybe we should turn trace_xdp_exception() into a call which
> unconditionally collects exception stats? I think we can reasonably
> expect the exception_bpf_prog to always be attached, right?

trace_xdp_exception() is again a error path, and would restrict us
to have only "bad" statistics.

> > > > Regarding that it's almost pretty the same across all the drivers
> > > > (which is obvious), we can implement some sort of "standardized"
> > > > statistics using Ethtool standard stats infra to eliminate a lot
> > > > of code and stringsets duplication, different approaches to count
> > > > these stats and so on.  
> > > 
> > > I'm not 100% sold on the fact that these should be ethtool stats. 
> > > Why not rtnl_fill_statsinfo() stats? Current ethtool std stats are 
> > > all pretty Ethernet specific, and all HW stats. Mixing HW and SW
> > > stats
> > > is what we're trying to get away from.

I was trying to introduce as few functional changes as possible,
including that all the current drivers expose XDP stats through
Ethtool.
I don't say it's a 100% optimal way, but lots of different scripts
and monitoring tools are already based on this fact and there can
be some negative impact. There'll be for sure due to that std stats
is a bit different thing and different drivers count and name XDP
stats differently (breh).

BTW, I'm fine with rtnl xstats. A nice reminder, thanks. If there
won't be much cons like "don't touch our Ethtool stats", I would
prefer this one instead of Ethtool standard stats way.

> > XDP is going to always be eBPF based ! why not just report such stats
> > to a special BPF_MAP ? BPF stack can collect the stats from the driver
> > and report them to this special MAP upon user request.
> 
> Do you mean replacing the ethtool-netlink / rtnetlink etc. with
> a new BPF_MAP? I don't think adding another category of uAPI thru 
> which netdevice stats are exposed would do much good :( Plus it 
> doesn't address the "yet another cacheline" concern.

+ this makes obtaining/tracking the statistics much harder. For now,
all you need is `ethtool -S devname` (mainline) or
`ethtool -S devname --groups xdp` (this series), and obtaining rtnl
xstats is just a different command to invoke. BPF_MAP-based stats
are a completely different story then.

> To my understanding the need for stats recognizes the fact that (in
> large organizations) fleet monitoring is done by different teams than
> XDP development. So XDP team may have all the stats they need, but the
> team doing fleet monitoring has no idea how to get to them.
> 
> To bridge the two worlds we need a way for the infra team to ask the
> XDP for well-defined stats. Maybe we should take a page from the BPF
> iterators book and create a program type for bridging the two worlds?
> Called by networking core when duping stats to extract from the
> existing BPF maps all the relevant stats and render them into a well
> known struct? Users' XDP design can still use a single per-cpu map with
> all the stats if they so choose, but there's a way to implement more
> optimal designs and still expose well-defined stats.
> 
> Maybe that's too complex, IDK.

Thanks,
Al
