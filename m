Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DAC448031
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 14:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239899AbhKHNYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 08:24:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:65453 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239890AbhKHNYg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 08:24:36 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10161"; a="219420950"
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="219420950"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 05:21:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="491211437"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 08 Nov 2021 05:21:37 -0800
Received: from baltimore.igk.intel.com (baltimore.igk.intel.com [10.102.21.1])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1A8DLXuM005812;
        Mon, 8 Nov 2021 13:21:33 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
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
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 03/21] ethtool, stats: introduce standard XDP statistics
Date:   Mon,  8 Nov 2021 14:21:13 +0100
Message-Id: <20211108132113.5152-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <87v912ri7h.fsf@toke.dk>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com> <20210803163641.3743-4-alexandr.lobakin@intel.com> <20210803134900.578b4c37@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <ec0aefbc987575d1979f9102d331bd3e8f809824.camel@kernel.org> <20211026092323.165-1-alexandr.lobakin@intel.com> <20211105164453.29102-1-alexandr.lobakin@intel.com> <87v912ri7h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Mon, 08 Nov 2021 12:37:54 +0100

> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> 
> > From: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Date: Tue, 26 Oct 2021 11:23:23 +0200
> >
> >> From: Saeed Mahameed <saeed@kernel.org>
> >> Date: Tue, 03 Aug 2021 16:57:22 -0700
> >> 
> >> [ snip ]
> >> 
> >> > XDP is going to always be eBPF based ! why not just report such stats
> >> > to a special BPF_MAP ? BPF stack can collect the stats from the driver
> >> > and report them to this special MAP upon user request.
> >> 
> >> I really dig this idea now. How do you see it?
> >> <ifindex:channel:stat_id> as a key and its value as a value or ...?
> >
> > Ideas, suggestions, anyone?
> 
> I don't like the idea of putting statistics in a map instead of the
> regular statistics counters. Sure, for bespoke things people want to put
> into their XDP programs, use a map, but for regular packet/byte
> counters, update the regular counters so XDP isn't "invisible".

I wanted to provide an `ip link` command for getting these stats
from maps and printing them in a usual format as well, but seems
like that's an unneeded overcomplication of things since using
maps for "regular"/"generic" XDP stats really has no reason except
for "XDP means eBPF means maps".

> As Jesper pointed out, batching the updates so the global counters are
> only updated once per NAPI cycle is the way to avoid a huge performance
> overhead of this...

That's how I do things currently, seems to work just fine.

> -Toke

Thanks,
Al
