Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9783E061D
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 18:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239551AbhHDQos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 12:44:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhHDQor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 12:44:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB71B60EEA;
        Wed,  4 Aug 2021 16:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628095475;
        bh=//fKBBSt3n1/P1LVS4WBxVUOw0wUMDz5+Qh2Rq0PsuM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rYI/nUjXtev/74v6WfNUQwK16+1Wyls4oryefMwJV50UjiwFqbzGajz6/+6Mar/EH
         M6gd/iVbGY9GqW8vYKtWOQ8hnf4bYBdQ/MCdiCvP11FzrG+MKlVPOsxTVa0VL+O3J5
         BqlsFb4zxw8H4FqSa00FaVye9aO45qkYoAapmHrrke41GxrWCGImJUKhjv/vQol5bQ
         ELrqY+PTdk2IsIpjyNr+dwyDmiHBcWT0j3C6jGpuFIkop1RGtdZqZ/AbUwTCoOS/zS
         omoBJGD49FY3+XzT2b5Ad8qvUvvNbiJKNiig5JAY3XvYvAah6zTqpHzN9eSpytFZAd
         hjDU/ejZODebQ==
Date:   Wed, 4 Aug 2021 09:44:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
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
Message-ID: <20210804094432.08d0fa86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <43e91ce1-0f82-5820-7cac-b42461a0311a@gmail.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
        <20210803163641.3743-4-alexandr.lobakin@intel.com>
        <20210803134900.578b4c37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ec0aefbc987575d1979f9102d331bd3e8f809824.camel@kernel.org>
        <20210804053650.22aa8a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <43e91ce1-0f82-5820-7cac-b42461a0311a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Aug 2021 10:17:56 -0600 David Ahern wrote:
> On 8/4/21 6:36 AM, Jakub Kicinski wrote:
> >> XDP is going to always be eBPF based ! why not just report such stats
> >> to a special BPF_MAP ? BPF stack can collect the stats from the driver
> >> and report them to this special MAP upon user request.  
> > Do you mean replacing the ethtool-netlink / rtnetlink etc. with
> > a new BPF_MAP? I don't think adding another category of uAPI thru 
> > which netdevice stats are exposed would do much good :( Plus it 
> > doesn't address the "yet another cacheline" concern.
> > 
> > To my understanding the need for stats recognizes the fact that (in
> > large organizations) fleet monitoring is done by different teams than
> > XDP development. So XDP team may have all the stats they need, but the
> > team doing fleet monitoring has no idea how to get to them.
> > 
> > To bridge the two worlds we need a way for the infra team to ask the
> > XDP for well-defined stats. Maybe we should take a page from the BPF
> > iterators book and create a program type for bridging the two worlds?
> > Called by networking core when duping stats to extract from the
> > existing BPF maps all the relevant stats and render them into a well
> > known struct? Users' XDP design can still use a single per-cpu map with
> > all the stats if they so choose, but there's a way to implement more
> > optimal designs and still expose well-defined stats.
> > 
> > Maybe that's too complex, IDK.  
> 
> I was just explaining to someone internally how to get stats at all of
> the different points in the stack to track down reasons for dropped packets:
> 
> ethtool -S for h/w and driver
> tc -s for drops by the qdisc
> /proc/net/softnet_stat for drops at the backlog layer
> netstat -s for network and transport layer
> 
> yet another command and API just adds to the nightmare of explaining and
> understanding these stats.

Are you referring to RTM_GETSTATS when you say "yet another command"?
RTM_GETSTATS exists and is used by offloads today.

I'd expect ip -s (-s) to be extended to run GETSTATS and display the xdp
stats. (Not sure why ip -s was left out of your list :))

> There is real value in continuing to use ethtool API for XDP stats. Not
> saying this reorg of the XDP stats is the right thing to do, only that
> the existing API has real user benefits.

RTM_GETSTATS is an existing API. New ethtool stats are intended to be HW
stats. I don't want to go back to ethtool being a dumping ground for all
stats because that's what the old interface encouraged.

> Does anyone have data that shows bumping a properly implemented counter
> causes a noticeable performance degradation and if so by how much? You
> mention 'yet another cacheline' but collecting stats on stack and
> incrementing the driver structs at the end of the napi loop should not
> have a huge impact versus the value the stats provide.

Not sure, maybe Jesper has some numbers. Maybe Intel folks do?

I'm just allergic to situations when there is a decision made and 
then months later patches are posted disregarding the decision, 
without analysis on why that decision was wrong. And while the
maintainer who made the decision is on vacation.
