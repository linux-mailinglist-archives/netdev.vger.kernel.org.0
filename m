Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413D4463970
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbhK3PMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:12:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32900 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244928AbhK3PKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:10:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 426B1B81A1D;
        Tue, 30 Nov 2021 15:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A3AC53FC7;
        Tue, 30 Nov 2021 15:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284831;
        bh=jFQ+6eYpfo8AQTphnbl6MyyOotoZuBDGCJKxTEg5dTg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=okOaZXwVQha6VENLbtkW/K3UpmSv4x49LI137OshO7/GQ3udI34yAew/t1F4aeWjp
         9RRQJdhcJifvYVBtH1uv9s90R9dXC+jkftp+VyKrmGOwTZU1drMlxR78YGJ4tUsNTb
         ZeHxC/J1Ylt1+gxhsRnzopmxV2PFCL0Mi6ejlLDDN9agiengKlehxRxCy8hak+mcD+
         XhyTEYILzqgFd9PW/SlVvRy6r+/OiSN8cbVsLxju8oy1ZuZ5WtvL/qEwyU58CrvAEg
         mq/1Ni4N4qOnq/1dV/zSGy7z/TRfGgF4iADeKw5XsZJKXHsXoz5d70RsGtE3tfVb+j
         UOXFLXcmuzxxw==
Date:   Tue, 30 Nov 2021 07:07:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <toke@redhat.com>,
        "Alexander Lobakin" <alexandr.lobakin@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Shay Agroskin" <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David Arinzon" <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        "Saeed Bishara" <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "Claudiu Manoil" <claudiu.manoil@nxp.com>,
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
        "Martin Habets" <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <bpf@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <nikolay@nvidia.com>
Subject: Re: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic
 per-channel statistics
Message-ID: <20211130070709.0ddf19f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87o861q2m4.fsf@nvidia.com>
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
        <YaPCbaMVaVlxXcHC@shredder>
        <20211129064755.539099c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <874k7vq7tl.fsf@nvidia.com>
        <20211129080502.53f7d316@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87sfveq48z.fsf@nvidia.com>
        <20211129091713.2dc8462f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87o861q2m4.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 12:55:47 +0100 Petr Machata wrote:
> I still think it would be better to report HW_STATS explicitly as well
> though. One reason is simply convenience. The other is that OK, now we
> have SW stats, and XDP stats, and total stats, and I (as a client) don't
> necessarily know how it all fits together. But the contract for HW_STATS
> is very clear.

Would be good to check with Jiri, my recollection is that this argument
was brought up when CPU_HIT stats were added. I don't recall the
reasoning.

<insert xkcd standards>
