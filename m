Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D469461F97
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 19:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350514AbhK2Svo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 13:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379432AbhK2Stk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 13:49:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F65CC0494BE;
        Mon, 29 Nov 2021 07:03:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0673B8119F;
        Mon, 29 Nov 2021 15:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09833C004E1;
        Mon, 29 Nov 2021 15:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638198233;
        bh=4PfxGUCMuORTg1cVTMdzzVoIHFONrfZbw9PaLtMYGbM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FfZybPsz4FL49qCelBKPBatUjFar5ON8RPmGHDlXqzvV/VkC8JFqPyNkoVH2rVbil
         DxWZlKjJVM9UyqvVqOFr2GcbIovNIyASQOsXiDCe2ePQXprG2OXYc7qsD01WrpU7gb
         fzg/RhEw3CGwniIL+gMRQ6Lau/s6WR446y+vDmQJ6OYPMN4TkcF/7BHNin2z5tqWH3
         fQyeV07FRKMGBBOF5GcIWff0KU46EkSB0MAiVYF6HMbMD8muSqwSKWKmsG5JFxWSwK
         vfWV5oa0XmiI+MceioOohr14eK4SFjY2ebFaFSV5+avsq1aQg6BiGnC0avWLglu/Qr
         7bi1+dg9Os7Ug==
Date:   Mon, 29 Nov 2021 07:03:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?UTF-8?B?SMO4aWxhbmQt?= =?UTF-8?B?SsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, brouer@redhat.com,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
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
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 net-next 21/26] ice: add XDP and XSK generic
 per-channel statistics
Message-ID: <20211129070350.751e2afe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <37732c0b-a1f5-5e1d-d34e-16ef07fab597@redhat.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
        <20211123163955.154512-22-alexandr.lobakin@intel.com>
        <77407c26-4e32-232c-58e0-2d601d781f84@iogearbox.net>
        <87bl28bga6.fsf@toke.dk>
        <20211125170708.127323-1-alexandr.lobakin@intel.com>
        <20211125094440.6c402d63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211125204007.133064-1-alexandr.lobakin@intel.com>
        <87sfvj9k13.fsf@toke.dk>
        <20211126100611.514df099@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <871ae82a-3d5b-2693-2f77-7c86d725a056@iogearbox.net>
        <3c2fd51e-96c4-d500-bb4c-1972bb0fa3d6@iogearbox.net>
        <37732c0b-a1f5-5e1d-d34e-16ef07fab597@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 14:59:53 +0100 Jesper Dangaard Brouer wrote:
> Hmm... I don't agree here.  IMHO the BPF-program's *choice* to drop (via 
> XDP_DROP) should NOT share the counter with the driver-related drops.
> 
> The driver-related drops must be accounted separate.

+1 FWIW. The Tx stat is a little misleading because it differs from the
definition of our other tx stats which mean _successfully_ transmitted
(and are accounted on the completion path in many drivers).

In the past I've used act_*, e.g. act_tx, to indicate the stat counts
returned actions, not whether the packet made it.

I still wonder whether it makes sense to count the stats per-action or
just have one "XDP consumed it" stat and that's it. The semantics of the
action are not of interest to the admin. A firewall can drop or tx
depending if it wants to send an ICMP reject or TCP RST message in
response. I need to know what the application does to understand the
difference, and if I do I can as well look at app stats. But I'm aware
I'm not going to find much support for this position, so just saying...
;)
