Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62853463C88
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 18:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244648AbhK3RKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244619AbhK3RKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:10:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CF6C061574;
        Tue, 30 Nov 2021 09:07:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A51CECE1A95;
        Tue, 30 Nov 2021 17:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD39C53FC1;
        Tue, 30 Nov 2021 17:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638292038;
        bh=gXB8rDIFW0PtguRogFlBo25h9dW+PPZpU4PIMjQ3mh4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xzn4oBr1FcLMAR7S/89+TY/MtXp2SkTV/0yRAhajm8HHztZHFY5XQzAbdnGqFUAJy
         nrQrHRTvsgGaHTXg7TP/VFDSdu/xfHbT9dUJs7P7JfXlv9ls5uw2lD/HGI5LN0L+W4
         OOirquVHI7R6IU5DjG6l+1bJDX2a+Gh5aSX+htcGtvVAiPw5M2AnH+f+2lLMPY4W8F
         bZ7S9/eoWwi/ibNsbeuSk3BqSiRs4fV0gmipNT5yO40vnX+sIOtkRLZCotF+YnCQvC
         o79bum8ajEd8K1Ke5XYs5Uy6Ish6yIdq+Yti+UiVHWdflbNpQtJcEU75xkXLxonflB
         +pK1tQrFJJUiA==
Date:   Tue, 30 Nov 2021 09:07:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
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
        Daniel Borkmann <daniel@iogearbox.net>,
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
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 00/26] net: introduce and use generic XDP
 stats
Message-ID: <20211130090716.4a557036@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <871r2x8vor.fsf@toke.dk>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
        <20211130155612.594688-1-alexandr.lobakin@intel.com>
        <871r2x8vor.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 17:17:24 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > 1. Channels vs queues vs global.
> >
> > Jakub: no per-channel.
> > David (Ahern): it's worth it to separate as Rx/Tx.
> > Toke is fine with globals at the end I think? =20
>=20
> Well, I don't like throwing data away, so in that sense I do like
> per-queue stats, but it's not a very strong preference (i.e., I can live
> with either)...

We don't even have a clear definition of a queue in Linux.

As I said, adding this API today without a strong user and letting
drivers diverge in behavior would be a mistake.
