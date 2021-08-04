Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A013E0144
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 14:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238157AbhHDMhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 08:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237413AbhHDMhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 08:37:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5D9B60E8D;
        Wed,  4 Aug 2021 12:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628080613;
        bh=vBpefUuV9lPRsEP836BJTZ6bfER+5hsJBPPFMvDOds8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BSpuy+9oxQBnoYzJOoSXbZG8vAm1B+S8OtdkUPiUtvHZ5j8rXSHuo1cz5S+eIpPwH
         8tY0Pz9SFrVSHvW56DyPW7UudNz6jLBUug0H1SvFHzCgQNd+xep5hYVpshE25Qcihf
         PXgJuTJ2WN11AC/sSgeqlpkg8AqpdcCoRb5TQF1SPUAplqFFGF7635d6/7f29nSMad
         Z5RQ6zAwEZ2QfnVWwMz6QYbfHeToYEfPDzXfFUVWxrZC9I7wdIAMUDFDY7ODWpunjd
         yqaSaR6eGF8oFmIAKnhRYMql4L+AG6oB2ghzShjJd1TaBkar9KNUcJ33vDRNXOOVBc
         FVa1dZ/72AXIw==
Date:   Wed, 4 Aug 2021 05:36:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
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
        Guy Tzalik <gtzalik@amazon.com>,
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
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 03/21] ethtool, stats: introduce standard XDP
 statistics
Message-ID: <20210804053650.22aa8a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ec0aefbc987575d1979f9102d331bd3e8f809824.camel@kernel.org>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
        <20210803163641.3743-4-alexandr.lobakin@intel.com>
        <20210803134900.578b4c37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ec0aefbc987575d1979f9102d331bd3e8f809824.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Aug 2021 16:57:22 -0700 Saeed Mahameed wrote:
> On Tue, 2021-08-03 at 13:49 -0700, Jakub Kicinski wrote:
> > On Tue,=C2=A0 3 Aug 2021 18:36:23 +0200 Alexander Lobakin wrote: =20
> > > Most of the driver-side XDP enabled drivers provide some statistics
> > > on XDP programs runs and different actions taken (number of passes,
> > > drops, redirects etc.). =20
> >=20
> > Could you please share the statistics to back that statement up?
> > Having uAPI for XDP stats is pretty much making the recommendation=20
> > that drivers should implement such stats. The recommendation from
> > Alexei and others back in the day (IIRC) was that XDP programs should
> > implement stats, not the drivers, to avoid duplication.
>=20
> There are stats "mainly errors*"  that are not even visible or reported
> to the user prog,=20

Fair point, exceptions should not be performance critical.

> for that i had an idea in the past to attach an
> exception_bpf_prog provided by the user, where driver/stack will report
> errors to this special exception_prog.

Or maybe we should turn trace_xdp_exception() into a call which
unconditionally collects exception stats? I think we can reasonably
expect the exception_bpf_prog to always be attached, right?

> > > Regarding that it's almost pretty the same across all the drivers
> > > (which is obvious), we can implement some sort of "standardized"
> > > statistics using Ethtool standard stats infra to eliminate a lot
> > > of code and stringsets duplication, different approaches to count
> > > these stats and so on. =20
> >=20
> > I'm not 100% sold on the fact that these should be ethtool stats.=20
> > Why not rtnl_fill_statsinfo() stats? Current ethtool std stats are=20
> > all pretty Ethernet specific, and all HW stats. Mixing HW and SW
> > stats
> > is what we're trying to get away from.
>=20
> XDP is going to always be eBPF based ! why not just report such stats
> to a special BPF_MAP ? BPF stack can collect the stats from the driver
> and report them to this special MAP upon user request.

Do you mean replacing the ethtool-netlink / rtnetlink etc. with
a new BPF_MAP? I don't think adding another category of uAPI thru=20
which netdevice stats are exposed would do much good :( Plus it=20
doesn't address the "yet another cacheline" concern.

To my understanding the need for stats recognizes the fact that (in
large organizations) fleet monitoring is done by different teams than
XDP development. So XDP team may have all the stats they need, but the
team doing fleet monitoring has no idea how to get to them.

To bridge the two worlds we need a way for the infra team to ask the
XDP for well-defined stats. Maybe we should take a page from the BPF
iterators book and create a program type for bridging the two worlds?
Called by networking core when duping stats to extract from the
existing BPF maps all the relevant stats and render them into a well
known struct? Users' XDP design can still use a single per-cpu map with
all the stats if they so choose, but there's a way to implement more
optimal designs and still expose well-defined stats.

Maybe that's too complex, IDK.
