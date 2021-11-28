Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8D946083D
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 18:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359100AbhK1SAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 13:00:16 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42821 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239305AbhK1R6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 12:58:15 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5B9425802EE;
        Sun, 28 Nov 2021 12:54:58 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 28 Nov 2021 12:54:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=UUHBKcGQTfc55BryKks38P9q1VVkigTZnH+REkQ6S
        Co=; b=iYiN+YmWJhZj5r+gfNGtNnX5WxIBt9yrnzuHllXQ5/GUOrZwgE+2B6kqq
        v1LacLeZi5zTVMsNqmYhaoCVMmR7ErWb/6IMezfXpj4u51pcnQtnt5/PL1NDm5AK
        d9CZlDHePScIbPZ7dXxmGzpUDRkVmvPH5Em/yqEQ5o71cDbP6BJlajUs4CRXojAc
        LzDVEKJNK78Vz3a45eafY2sJ76R61tmWYjTYc4AtkcIHMr9qmajW5sqDYL0fpYei
        h6Pe7CTiBbD0MbI7zqJGjx+gCDQ2nW3O0Uo+4yN6QuRPMxk6JKI8Svoa6WW0kNuo
        tVzHESLM+PoWuo8LTnmU9cpdyMP3A==
X-ME-Sender: <xms:cMKjYWPd5DduNFfJjqZGpi_Wq71dAWE-J_wxpNXVNN7XTVtZ_QJQOw>
    <xme:cMKjYU9Rk6Tqx55hmFgiPLQKDLq2WNdabM2IbEvkxdvab2oCAl8BYbJpTf3_rCUOp
    53xpJsCz_pSqq8>
X-ME-Received: <xmr:cMKjYdTw-ttGcSarl-eU2ZcZwmqsKK1hsatFaqZGuF6YohTU7eyzmsq4leif>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrheeigddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekrodttddtudenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepieevhfevtdejhfethedvkefgudetudegudethfdtfeefleektdekkeefjeel
    tedtnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpghhithhhuhgsrdgtohhmnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:cMKjYWtuij49OVBZsOZ08kX7vOuYx2zKXpEQngCdpqkooYt8LbI4gQ>
    <xmx:cMKjYefpDNGR53rK7VKwO17_5hlV0ErgOrbjeks77FFLX_bPwm1JjA>
    <xmx:cMKjYa29fxDeX6UVEYihZVEcU-Ns9Ce4QLuSS0jmtGkEHd2vzlMc1w>
    <xmx:csKjYbWeDFzgpl2GEEg_ew_X8_3slLF376ZQh0yCCLJ9kVNpVD_Ylw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 28 Nov 2021 12:54:55 -0500 (EST)
Date:   Sun, 28 Nov 2021 19:54:53 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org, petrm@nvidia.com,
        nikolay@nvidia.com
Subject: Re: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic
 per-channel statistics
Message-ID: <YaPCbaMVaVlxXcHC@shredder>
References: <20211123163955.154512-22-alexandr.lobakin@intel.com>
 <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net>
 <87bl28bga6.fsf@toke.dk>
 <20211125170708.127323-1-alexandr.lobakin@intel.com>
 <20211125094440.6c402d63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211125204007.133064-1-alexandr.lobakin@intel.com>
 <87sfvj9k13.fsf@toke.dk>
 <20211126100611.514df099@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87ee72ah56.fsf@toke.dk>
 <20211126111431.4a2ed007@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211126111431.4a2ed007@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Petr, Nik

On Fri, Nov 26, 2021 at 11:14:31AM -0800, Jakub Kicinski wrote:
> On Fri, 26 Nov 2021 19:47:17 +0100 Toke Høiland-Jørgensen wrote:
> > > Fair. In all honesty I said that hoping to push for a more flexible
> > > approach hidden entirely in BPF, and not involving driver changes.
> > > Assuming the XDP program has more fine grained stats we should be able
> > > to extract those instead of double-counting. Hence my vague "let's work
> > > with apps" comment.
> > >
> > > For example to a person familiar with the workload it'd be useful to
> > > know if program returned XDP_DROP because of configured policy or
> > > failure to parse a packet. I don't think that sort distinction is
> > > achievable at the level of standard stats.
> > >
> > > The information required by the admin is higher level. As you say the
> > > primary concern there is "how many packets did XDP eat".  
> > 
> > Right, sure, I am also totally fine with having only a somewhat
> > restricted subset of stats available at the interface level and make
> > everything else be BPF-based. I'm hoping we can converge of a common
> > understanding of what this "minimal set" should be :)
> > 
> > > Speaking of which, one thing that badly needs clarification is our
> > > expectation around XDP packets getting counted towards the interface
> > > stats.  
> > 
> > Agreed. My immediate thought is that "XDP packets are interface packets"
> > but that is certainly not what we do today, so not sure if changing it
> > at this point would break things?
> 
> I'd vote for taking the risk and trying to align all the drivers.

I agree. I think IFLA_STATS64 in RTM_NEWLINK should contain statistics
of all the packets seen by the netdev. The breakdown into software /
hardware / XDP should be reported via RTM_NEWSTATS.

Currently, for soft devices such as VLANs, bridges and GRE, user space
only sees statistics of packets forwarded by software, which is quite
useless when forwarding is offloaded from the kernel to hardware.

Petr is working on exposing hardware statistics for such devices via
rtnetlink. Unlike XDP (?), we need to be able to let user space enable /
disable hardware statistics as we have a limited number of hardware
counters and they can also reduce the bandwidth when enabled. We are
thinking of adding a new RTM_SETSTATS for that:

# ip stats set dev swp1 hw_stats on

For query, something like (under discussion):

# ip stats show dev swp1 // all groups
# ip stats show dev swp1 group link
# ip stats show dev swp1 group offload // all sub-groups
# ip stats show dev swp1 group offload sub-group cpu
# ip stats show dev swp1 group offload sub-group hw

Like other iproute2 commands, these follow the nesting of the
RTM_{NEW,GET}STATS uAPI.

Looking at patch #1 [1], I think that whatever you decide to expose for
XDP can be queried via:

# ip stats show dev swp1 group xdp
# ip stats show dev swp1 group xdp sub-group regular
# ip stats show dev swp1 group xdp sub-group xsk

Regardless, the following command should show statistics of all the
packets seen by the netdev:

# ip -s link show dev swp1

There is a PR [2] for node_exporter to use rtnetlink to fetch netdev
statistics instead of the old proc interface. It should be possible to
extend it to use RTM_*STATS for more fine-grained statistics.

[1] https://lore.kernel.org/netdev/20211123163955.154512-2-alexandr.lobakin@intel.com/
[2] https://github.com/prometheus/node_exporter/pull/2074
